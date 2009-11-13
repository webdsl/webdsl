package nwl;

import org.strategoxt.imp.runtime.dynamicloading.Descriptor;
import org.strategoxt.imp.runtime.services.MetaFileLanguageValidator;

public class NwlValidator extends MetaFileLanguageValidator 
{ 
  public Descriptor getDescriptor()
  { 
    return NwlParseController.getDescriptor();
  }
}