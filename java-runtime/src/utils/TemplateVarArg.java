package utils;

import java.util.ArrayList;
import java.util.List;

public abstract class TemplateVarArg {

	public static List<Object[]> add(List<Object[]> arg, Object[] o){
		arg.add(o);
		return arg;
	}

	public static List<Object[]> addMultiple(List<Object[]> arg, List<Object> list, TemplateVarArg addFunction){
		for(Object o : list){
			addFunction.run(arg, o);
		}
		return arg;
	}

	public abstract void run(List<Object[]> arg, Object o);

	public static List<Integer> createCountList(int i, int bound){
		List<Integer> list = new ArrayList<Integer>(); 
		int delta = (i < bound? 1 : -1);
		while(i != bound) {
			list.add(i);
			i += delta;
		}
		return list;
	}

}
