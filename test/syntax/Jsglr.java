import org.spoofax.interpreter.terms.IStrategoTerm;
import org.spoofax.sunshine.model.messages.IMessage;
import org.spoofax.sunshine.parser.model.IParseTableProvider;
import org.spoofax.sunshine.parser.model.ParserConfig;
import org.spoofax.sunshine.services.analyzer.AnalysisResult;
import org.spoofax.sunshine.services.parser.FileBasedParseTableProvider;
import org.spoofax.sunshine.services.parser.JSGLRI;
import java.io.File;

public class Jsglr {
    public static void main(String[] args) {
        int parserTimeoutMillis = 3000;

        File parseTableFile = new File(args[0]);
        String startSymbol = args[1];
        File fileToParse = new File(args[2]);

        IParseTableProvider tableProvier = new FileBasedParseTableProvider(parseTableFile);
        ParserConfig config = new ParserConfig(startSymbol, tableProvier, parserTimeoutMillis);

        JSGLRI parser = new JSGLRI(config, fileToParse);

        AnalysisResult result = parser.parse();

        for (IMessage message : result.messages()) {
            System.err.println(message);
        }

        System.out.println(result.ast());
    }
}