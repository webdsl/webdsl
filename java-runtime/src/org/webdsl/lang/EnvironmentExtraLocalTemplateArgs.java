package org.webdsl.lang;

import org.apache.commons.lang3.ArrayUtils;

import utils.LocalTemplateArguments;

/**
 * Used for storing implicit arguments to local template redefinitions

      define page root() {
        var st := "1"
        form{
          b(12345)  	
          submit action{ } {"save"}
        } 
        define b(i:Int) = a(*,--->st<---)
      }
      define a(i:Int, s:Ref<String>){}
      define b(i:Int){}
 */

public class EnvironmentExtraLocalTemplateArgs {

	protected EnvironmentExtraLocalTemplateArgs up = null;
	protected String name = null;
	protected LocalTemplateArguments extraLocalTemplateArguments = null;

	public EnvironmentExtraLocalTemplateArgs(EnvironmentExtraLocalTemplateArgs up)
	{
		this.up = up;
	}

	public LocalTemplateArguments getExtraLocalTemplateArguments(String key) {
		if (key.equals(name)){
			return extraLocalTemplateArguments;
		}
		else{
			if(up!=null){
				return up.getExtraLocalTemplateArguments(key);
			}
			else{
				return null;
			}
		}
	}

	public Object[] addExtraLocalTemplateArgumentsToArguments(Object[] args, String key) {
		LocalTemplateArguments tmp = getExtraLocalTemplateArguments(key);
		if(tmp == null){
			return args;
		}
		else{
			return ArrayUtils.addAll(args,tmp.extraArgs);
		}
	}

	public EnvironmentExtraLocalTemplateArgs putExtraLocalTemplateArguments(String key, LocalTemplateArguments value) {
		name = key;
		extraLocalTemplateArguments = value;
		return new EnvironmentExtraLocalTemplateArgs(this);
	} 

}
