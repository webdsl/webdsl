package org.webdsl.search;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.lucene.analysis.WhitespaceAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.NumericField;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.index.IndexWriterConfig.OpenMode;
import org.apache.lucene.index.LogMergePolicy;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.BooleanClause;
import org.apache.lucene.search.BooleanQuery;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.spell.Dictionary;
import org.apache.lucene.search.spell.LevensteinDistance;
import org.apache.lucene.search.spell.LuceneDictionary;
import org.apache.lucene.search.spell.StringDistance;
import org.apache.lucene.store.AlreadyClosedException;
import org.apache.lucene.store.Directory;
import org.apache.lucene.util.ReaderUtil;
import org.apache.lucene.util.Version;

/**
 * <p>
 *   Auto completer class  (Main class) <br/>
 *  (Based on Lucene SpellChecker class).
 * </p>
 *
 * <p>Example Usage:
 * 
 * <pre>
 *  AutoCompleter autocompleter = new AutoCompleter(autocompleteIndexDirectory);
 *  // To index a field of a user index:
 *  autocompleter.indexDictionary(new LuceneDictionary(my_lucene_reader, a_field));
 *  // To index a file containing words:
 *  autocompleter.indexDictionary(new PlainTextDictionary(new File("myfile.txt")));
 *  String[] suggestions = autocompleter.suggestSimilar("toComplete", 5);
 * </pre>
 * 
 *
 * @version 1.0
 */
public class AutoCompleter implements java.io.Closeable {


  /**
   * Field name for each word in the ngram index.
   */
  public static final String F_WORD = "word";
  
  private static final int MAX_PREFIX_LENGTH = 10;
  
  private static final String F_FREQ = "frequency";

  private static final Term F_WORD_TERM = new Term(F_WORD);

  /**
   * the autocomplete index
   */
  // don't modify the directory directly - see #swapSearcher()
  // TODO: why is this package private?
  Directory autoCompleteIndex;

  // don't use this searcher directly - see #swapSearcher()

  private IndexSearcher searcher;
  /*
   * this locks all modifications to the current searcher.
   */

  private final Object searcherLock = new Object();
  /*
   * this lock synchronizes all possible modifications to the
   * current index directory. It should not be possible to try modifying
   * the same index concurrently. Note: Do not acquire the searcher lock
   * before acquiring this lock!
   */
  private final Object modifyCurrentIndexLock = new Object();

  private volatile boolean closed = false;

  /**
   * Use the given directory as an auto completer index with a
   * {@link LevensteinDistance} as the default {@link StringDistance}. The
   * directory is created if it doesn't exist yet.
   * 
   * @param autoCompleteIndex
   *          the autocomplete index directory
   * @throws IOException
   *           if autocompleter can not open the directory
   */
  public AutoCompleter(Directory autocompleteIndex) throws IOException {
	  setAutoCompleteIndex(autocompleteIndex);
  }

  
  /**
   * Use a different index as the auto completer index or re-open
   * the existing index if <code>autocompleteIndex</code> is the same value
   * as given in the constructor.
   * @param autocompleteIndexDir the autocomplete directory to use
   * @throws AlreadyClosedException if the Autocompleter is already closed
   * @throws  IOException if autocompleter can not open the directory
   */
  // TODO: we should make this final as it is called in the constructor
  public void setAutoCompleteIndex(Directory autocompleteIndexDir) throws IOException {
    // this could be the same directory as the current autocompleteIndex
    // modifications to the directory should be synchronized 
    synchronized (modifyCurrentIndexLock) {
      ensureOpen();
      if (!IndexReader.indexExists(autocompleteIndexDir)) {
          IndexWriter writer = new IndexWriter(autocompleteIndexDir,
            new IndexWriterConfig(Version.LUCENE_CURRENT,
                new WhitespaceAnalyzer(Version.LUCENE_CURRENT)));
          writer.close();
      }
      swapSearcher(autocompleteIndexDir);
    }
  }
  
  /**
   * Suggest similar words (optionally restricted to a field of an index).
   *
   * <p>As the Lucene similarity that is used to fetch the most relevant n-grammed terms
   * is not the same as the edit distance strategy used to calculate the best
   * matching autocomplete word from the hits that Lucene found, one usually has
   * to retrieve a couple of numSug's in order to get the true best match.
   *
   * <p>I.e. if numSug == 1, don't count on that suggestion being the best one.
   * Thus, you should set this value to <b>at least</b> 5 for a good suggestion.
   *
   * @param word the word you want a auto complete done on
   * @param numSug the number of suggested words
   * @param ir the indexReader of the user index (can be null see field param)
   * @param field the field of the user index: if field is not null, the suggested
   * words are restricted to the words present in this field.
   * @throws IOException if the underlying index throws an {@link IOException}
   * @throws AlreadyClosedException if the Autocompleter is already closed
   * @return List<String> the sorted list of the suggest words with these 2 criteria:
   * first criteria: the edit distance, second criteria (only if restricted mode): the popularity
   * of the suggest words in the field of the user index
   */
  public String[] suggestSimilar(String word, int numSug) throws IOException {
    // obtainSearcher calls ensureOpen
    final IndexSearcher indexSearcher = obtainSearcher();
    try{
      BooleanQuery query = new BooleanQuery();
      List<String[]> grams = formGrams(word);
      String key;
      for (String[] gramArray : grams) {
    	  for (int i = 0; i < gramArray.length; i++) {
    	        key = "start" + gramArray[i].length(); // form key        
    	        add(query, key, gramArray[i]);
    	      }
	  }
      

      int maxHits = 2 * numSug;
      
      //First sort on similarity, then on popularity (based on frequency in the source index)
      SortField[] sortFields = {SortField.FIELD_SCORE, new SortField(F_FREQ, SortField.INT, true)};
      
      ScoreDoc[] hits = indexSearcher.search(query, maxHits, new Sort(sortFields)).scoreDocs;
      //indexSearcher.search(query, null, maxHits).scoreDocs;
      int stop = Math.min(hits.length, maxHits);
      String[] toReturn = new String[stop];      
      
      for (int i = 0; i < stop; i++) {
    	toReturn[i] =  indexSearcher.doc(hits[i].doc).get(F_WORD); // get orig word
      }
      return toReturn;
    } finally {
      releaseSearcher(indexSearcher);
    }
  }

  /**
   * Add a clause to a boolean query.
   */
  private static void add(BooleanQuery q, String name, String value) {
    q.add(new BooleanClause(new TermQuery(new Term(name, value)), BooleanClause.Occur.SHOULD));
  }

  /**
   * Returns at most 3 ngrams for each token (whitespace separated), so 2 typos can be made at the end of 
   * each token from the currently typed string.
   * @param text the word to parse
   * @return an list of arrays of all ngrams in the word and note that duplicates are not removed
   */
  private static List<String[]> formGrams(String text) {
	//first split into tokens to match words in phrases
	text = text.toLowerCase(); //search prefixes in lower case!
	String[] tokens = text.split("\\s");
	int len, tokenlen;
	ArrayList<String[]> grams = new ArrayList<String[]>();
	
	for (String token : tokens) {
		len = 3;
		tokenlen = Math.min(token.length(), MAX_PREFIX_LENGTH);		  
		if (tokenlen < 3) {
		  len = tokenlen;
		}
		  
		String[] res = new String[len];
		for (int i = 0; i < len; i++) {
		  res[i] = token.substring(0, tokenlen-i);
		}
		grams.add(res);
	}
	
	
	return grams;
  }

  /**
   * Removes all terms from the auto complete index.
   * @throws IOException
   * @throws AlreadyClosedException if the Autocompleter is already closed
   */
  public void clearIndex() throws IOException {
    synchronized (modifyCurrentIndexLock) {
      ensureOpen();
      final Directory dir = this.autoCompleteIndex;
      final IndexWriter writer = new IndexWriter(dir, new IndexWriterConfig(
          Version.LUCENE_CURRENT,
          new WhitespaceAnalyzer(Version.LUCENE_CURRENT))
          .setOpenMode(OpenMode.CREATE));
      writer.close();
      swapSearcher(dir);
    }
  }

  /**
   * Check whether the word exists in the index.
   * @param word
   * @throws IOException
   * @throws AlreadyClosedException if the Autocompleter is already closed
   * @return true if the word exists in the index
   */
  public boolean exist(String word) throws IOException {
    // obtainSearcher calls ensureOpen
    final IndexSearcher indexSearcher = obtainSearcher();
    try{
      return indexSearcher.docFreq(F_WORD_TERM.createTerm(word)) > 0;
    } finally {
      releaseSearcher(indexSearcher);
    }
  }

  /**
   * Indexes the data from the given {@link Dictionary}.
 * @param reader Source index reader, from which autocomplete words are obtained for the defined field
 * @param field the field of the source index reader to index for autocompletion
 * @param mergeFactor mergeFactor to use when indexing
 * @param ramMB the max amount or memory in MB to use
 * @param optimize whether or not the autocomplete index should be optimized
   * @throws AlreadyClosedException if the Autocompleter is already closed
   * @throws IOException
   */
  public final void indexDictionary(IndexReader reader, String field, int mergeFactor, int ramMB, boolean optimize) throws IOException {
    synchronized (modifyCurrentIndexLock) {
      ensureOpen();
      final Directory dir = this.autoCompleteIndex;
      final Dictionary dict = new LuceneDictionary(reader, field);
      final IndexWriter writer = new IndexWriter(dir, new IndexWriterConfig(Version.LUCENE_CURRENT, new WhitespaceAnalyzer(Version.LUCENE_CURRENT)).setRAMBufferSizeMB(ramMB));
      ((LogMergePolicy) writer.getConfig().getMergePolicy()).setMergeFactor(mergeFactor);
      IndexSearcher indexSearcher = obtainSearcher();
      final List<IndexReader> readers = new ArrayList<IndexReader>();

      if (searcher.maxDoc() > 0) {
        ReaderUtil.gatherSubReaders(readers, searcher.getIndexReader());
      }
      
      //clear the index
      writer.deleteAll();
      
      try { 
        Iterator<String> iter = dict.getWordsIterator();
        
      while (iter.hasNext()) {
          String word = iter.next();
          
          // ok index the word
          Document doc = createDocument(word, reader.docFreq(new Term(field, word)));
          writer.addDocument(doc);
        }
      } finally {
        releaseSearcher(indexSearcher);
      }
      // close writer
      if (optimize)
        writer.optimize();
      writer.close();
      // also re-open the autocomplete index to see our own changes when the next suggestion
      // is fetched:
      swapSearcher(dir);
    }
  }

  /**
   * Indexes the data from the given {@link Dictionary}.
 * @param reader Source index reader, from which autocomplete words are obtained for the defined field
 * @param field the field of the source index reader to index for autocompletion
 * @param mergeFactor mergeFactor to use when indexing
 * @param ramMB the max amount or memory in MB to use
   * @throws IOException
   */
  public final void indexDictionary(IndexReader reader, String field, int mergeFactor, int ramMB) throws IOException {
    indexDictionary(reader, field, mergeFactor, ramMB, true);
  }
  
  /**
   * Indexes the data from the given {@link Dictionary}.
 * @param reader Source index reader, from which autocomplete words are obtained for the defined field
 * @param field the field of the source index reader to index for autocompletion
   * @throws IOException
   */
  public final void indexDictionary(IndexReader reader, String field) throws IOException {
    indexDictionary(reader, field, 300, (int)IndexWriterConfig.DEFAULT_RAM_BUFFER_SIZE_MB);
  }

  private static int getMax(int l) {
    if (l > MAX_PREFIX_LENGTH) {
      return MAX_PREFIX_LENGTH;
    }
    return l;
  }

  private static Document createDocument(String text, int freq) {
    Document doc = new Document();
    // the word field is never queried on... its indexed so it can be quickly
    // checked for rebuild (and stored for retrieval). Doesn't need norms or TF/pos
    Field f = new Field(F_WORD, text, Field.Store.YES, Field.Index.NOT_ANALYZED);
    f.setOmitTermFreqAndPositions(true);
    f.setOmitNorms(true);
    doc.add(f); // orig term
    NumericField nf = new NumericField(F_FREQ).setIntValue(freq);
    doc.add(nf);
    addGram(text, doc);
    return doc;
  }

  private static void addGram(String text, Document doc) {
	//If phrases are indexed as completions, it is nice to suggest these phrase if a token is matched
	//i.e. the phrase "Best practices in software architecture" is suggested on input "softw..."
	text = text.toLowerCase(); //index prefixes as lower case!
	String[] tokens = text.split("\\s");
	String token, key, gram;
	for (int t = 0; t < tokens.length; t++) {
		token = tokens[t];
		int len = getMax(token.length());
	    for (int i = 1; i <= len; i++) {
	      key = "start" + i;
	      gram = token.substring(0, i);
	      doc.add(new Field(key, gram, Field.Store.NO, Field.Index.NOT_ANALYZED));
	    }
	}
  }
  
  private IndexSearcher obtainSearcher() {
    synchronized (searcherLock) {
      ensureOpen();
      searcher.getIndexReader().incRef();
      return searcher;
    }
  }
  
  private void releaseSearcher(final IndexSearcher aSearcher) throws IOException{
      // don't check if open - always decRef 
      // don't decrement the private searcher - could have been swapped
      aSearcher.getIndexReader().decRef();      
  }
  
  private void ensureOpen() {
    if (closed) {
      throw new AlreadyClosedException("Autocompleter has been closed");
    }
  }
  
  /**
   * Close the IndexSearcher used by this AutoCompleter
   * @throws IOException if the close operation causes an {@link IOException}
   * @throws AlreadyClosedException if the {@link AutoCompleter} is already closed
   */
  public void close() throws IOException {
    synchronized (searcherLock) {
      ensureOpen();
      closed = true;
      if (searcher != null) {
        searcher.close();
      }
      searcher = null;
    }
  }
  
  private void swapSearcher(final Directory dir) throws IOException {
    /*
     * opening a searcher is possibly very expensive.
     * We rather close it again if the Autocompleter was closed during
     * this operation than block access to the current searcher while opening.
     */
    final IndexSearcher indexSearcher = createSearcher(dir);
    synchronized (searcherLock) {
      if(closed){
        indexSearcher.close();
        throw new AlreadyClosedException("Autocompleter has been closed");
      }
      if (searcher != null) {
        searcher.close();
      }
      // set the autocomplete index in the sync block - ensure consistency.
      searcher = indexSearcher;
      this.autoCompleteIndex = dir;
    }
  }
  
  /**
   * Creates a new read-only IndexSearcher 
   * @param dir the directory used to open the searcher
   * @return a new read-only IndexSearcher
   * @throws IOException f there is a low-level IO error
   */
  // for testing purposes
  IndexSearcher createSearcher(final Directory dir) throws IOException{
    return new IndexSearcher(dir, true);
  }
  
  /**
   * Returns <code>true</code> if and only if the {@link AutoCompleter} is
   * closed, otherwise <code>false</code>.
   * 
   * @return <code>true</code> if and only if the {@link AutoCompleter} is
   *         closed, otherwise <code>false</code>.
   */
  boolean isClosed(){
    return closed;
  }
  
}