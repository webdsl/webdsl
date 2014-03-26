package org.webdsl.lang;

/**
 *  'with/requires' calls map

      define page root(){
        var i := 7
        test() with {
          ---> content(s:String){ "123" output(s) output(i) } <---
        }
      }
      define test() requires content(String){
        "content: " content("456")
      }

      content(s:String) is lifted, i becomes an argument, 
      a partial templatecall is stored in the environment
      which contains the name of the lifted template and the value of i 

      returns null if templatecall is not found, used when 'elements' are empty
 */

public class EnvironmentWithCallLookup {

	protected EnvironmentWithCallLookup up = null;
	protected String name = null;
	protected utils.TemplateCall templatecall = null;

	public EnvironmentWithCallLookup(EnvironmentWithCallLookup up)
	{
		this.up = up;
	}

	public utils.TemplateCall getWithcall(String key) {
		if (key.equals(name)){
			return templatecall;
		}
		else{
			if(up!=null){
				return up.getWithcall(key);
			}
			else{
				return null;
			}
		}
	}

	public EnvironmentWithCallLookup putWithcall(String key, utils.TemplateCall value) {
		name = key;
		templatecall = value;
		return new EnvironmentWithCallLookup(this);
	}

}
