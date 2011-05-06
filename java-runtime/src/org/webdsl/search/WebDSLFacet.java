package org.webdsl.search;

import org.hibernate.search.query.facet.Facet;

public class WebDSLFacet {
	
	private int count;
	private String fieldName;
	private String value;
	
	public WebDSLFacet(){};
	
	public WebDSLFacet(String fieldAndValue){
		String[] ar = fieldAndValue.split(":", 2);
		this.fieldName = ar[0];
		this.value = ar[1];
	}
	
	public WebDSLFacet(Facet f){
		this.fieldName = f.getFieldName();
		this.value = f.getValue();
		this.count = f.getCount();
	}
	
	public int getCount() {
		return this.count;
	}

	public String getFieldName() {
		return this.fieldName;
	}

	public String getValue() {
		return this.value;
	}
	
	public String createBuildString(){
		return fieldName + "|" + encode(value) + "|" + count;
	}
	
	public WebDSLFacet buildFromString(String searchQueryAsString){
		String[] props = searchQueryAsString.split("\\|");
		this.fieldName = props[0];
		this.value = decode(props[1]);
		this.count = Integer.parseInt(props[2]);
		
		return this;
	}	
	
	private String encode(String str){
		return str.replaceAll("\\\\", "\\\\\\\\ ").replaceAll("\\|", "\\\\p");
	}
	
	private String decode(String str){
		return str.replaceAll("\\\\p", "|").replaceAll("\\\\\\\\ ", "\\\\");
	}
}
