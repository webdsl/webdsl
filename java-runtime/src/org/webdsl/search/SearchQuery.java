package org.webdsl.search;

import java.io.IOException;
import java.io.StringReader;

import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.similar.MoreLikeThis;
import org.hibernate.search.SearchFactory;
import org.hibernate.search.query.facet.*;
import org.hibernate.search.reader.ReaderProvider;
import org.hibernate.search.store.DirectoryProvider;
import org.webdsl.WebDSLEntity;

public abstract class SearchQuery<EntityClass extends WebDSLEntity> {

	protected final org.apache.lucene.util.Version luceneVersion = org.apache.lucene.util.Version.LUCENE_30;
	protected int limit = 100;
	protected int offset = 0;
	protected boolean luceneQueryChanged = true;
	protected org.apache.lucene.search.Query luceneQuery = null;
	protected java.util.LinkedHashMap<String, String> constraints = new java.util.LinkedHashMap<String, String>();
	protected org.hibernate.search.FullTextQuery query = null;

	protected String searchTerms = "";
	protected String[] searchFields = {};
	protected org.hibernate.search.FullTextSession fullTextSession;
	protected Class<?> entityClass;
	protected long searchTime = 0;

	public SearchQuery() {
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F addFieldConstraint(
			String fieldname, String terms) {
		if (validateQuery()) {
			enableFieldConstraintFilter(fieldname, terms);
		}
		constraints.put(fieldname, terms);
		return (F) this;
	}

	private void applyFieldConstraints() {
		for (String field : constraints.keySet())
			enableFieldConstraintFilter(field, constraints.get(field));
	}

	private void enableFieldConstraintFilter(String field, String value) {
		query.enableFullTextFilter("fieldConstraintFilter")
				.setParameter("field", field).setParameter("value", value);
	}

	private IndexReader getReader() {

		SearchFactory searchFactory = fullTextSession.getSearchFactory();
		DirectoryProvider<?> provider = searchFactory
				.getDirectoryProviders(entityClass)[0];
		ReaderProvider readerProvider = searchFactory.getReaderProvider();
		return readerProvider.openReader(provider);
	}

	@SuppressWarnings("unchecked")
	public java.util.List<EntityClass> getResultList() {
		searchTime = 0;
		if (validateQuery()) {
			searchTime = System.currentTimeMillis();
			java.util.List<EntityClass> toReturn = query.list();
			searchTime = System.currentTimeMillis() - searchTime;
			return toReturn;
		} else
			return new java.util.ArrayList<EntityClass>();
	}

	public int getResultSize() {
		if (validateQuery())
			return query.getResultSize();
		else
			return -1;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F moreLikeThis(String likeText) {
		int minWordLen = 5, maxWordLen = 30, minDocFreq = 1, minTermFreq = 2, maxQueryTerms = 3;
		return (F) moreLikeThis(likeText, minWordLen, maxWordLen, minDocFreq,
				minTermFreq, maxQueryTerms, searchFields);
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F moreLikeThis(String likeText,
			int minWordLen, int maxWordLen, int minDocFreq, int minTermFreq,
			int maxQueryTerms, String[] fieldNames) {
		MoreLikeThis mlt = new MoreLikeThis(getReader());
		mlt.setFieldNames(fieldNames);
		// mlt.setAnalyzer(new StandardAnalyzer(luceneVersion));
		mlt.setMinWordLen(minWordLen);
		mlt.setMaxWordLen(maxWordLen);
		mlt.setMinDocFreq(minDocFreq);
		mlt.setMinTermFreq(minTermFreq);
		mlt.setMaxQueryTerms(maxQueryTerms);
		try {
			org.apache.lucene.search.Query luceneQuery = mlt
					.like(new StringReader(likeText));
			query = fullTextSession.createFullTextQuery(luceneQuery,
					entityClass);
		} catch (IOException e) {
			e.printStackTrace();
		}
		luceneQueryChanged = false;

		return (F) this;
	}

	public String searchTimeAsString() {

		return searchTime + " ms.";
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F setFirstResult(int offset) {
		this.offset = offset;
		return (F) this;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F setMaxResults(int limit) {
		this.limit = limit;
		return (F) this;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F setSearchFields(
			java.util.List<String> fields) {
		searchFields = fields.toArray(new String[fields.size()]);
		luceneQueryChanged = true;
		return (F) this;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F setSearchTerms(String terms) {
		searchTerms = terms;
		luceneQueryChanged = true;
		return (F) this;
	}
	
	public java.util.List<Facet> getFacets(String field, int topN){
		
		org.hibernate.search.query.dsl.QueryBuilder builder = fullTextSession.getSearchFactory().buildQueryBuilder().forEntity( entityClass ).get();
		FacetingRequest facetReq = builder.facet()
		    .name( "facet" )
		    .onField( field )
		    .discrete()
		    .orderedBy( FacetSortOrder.COUNT_DESC )
		    .includeZeroCounts( false )
		    .maxFacetCount( topN )
		    .createFacetingRequest();
		
		validateQuery();		
		
		return query.getFacetManager().enableFaceting(facetReq).getFacets("facet");
	}

	private boolean validateQuery() {
		if (luceneQueryChanged) {
			if (!searchTerms.isEmpty()) {
				org.apache.lucene.queryParser.QueryParser parser = new org.apache.lucene.queryParser.MultiFieldQueryParser(
						luceneVersion, searchFields, fullTextSession.getSearchFactory().getAnalyzer( entityClass ));
				try {
					luceneQuery = parser.parse(searchTerms);
				} catch (org.apache.lucene.queryParser.ParseException pe) {
					return false;
				}
			}
			//Match all documents if no search terms are given
			else {
				luceneQuery = fullTextSession.getSearchFactory().buildQueryBuilder().forEntity( entityClass ).get().all().createQuery();
			}
			query = fullTextSession.createFullTextQuery(luceneQuery,
					entityClass);
			applyFieldConstraints();
			luceneQueryChanged = false;
		}
		query.setFirstResult(offset);
		query.setMaxResults(limit);

		return true;
	}

}