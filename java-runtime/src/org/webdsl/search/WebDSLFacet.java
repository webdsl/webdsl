package org.webdsl.search;

import java.util.Date;

import org.hibernate.search.query.facet.Facet;

public class WebDSLFacet {
	
	private int count;
	private String fieldName;
	private String value;
	
	public WebDSLFacet(){};
	
	public WebDSLFacet(String fieldAndValue){
		String[] ar = fieldAndValue.split("-", 2);
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
	
	public String encodeAsString(){
		return fieldName + "|" + encode(value) + "|" + count;
	}
	
	public WebDSLFacet decodeFromString(String webDSLFacetAsString){
		try{
			String[] props = webDSLFacetAsString.split("\\|");
			this.fieldName = props[0];
			this.value = decode(props[1]);
			this.count = Integer.parseInt(props[2]);
		} catch (Exception ex){
			return new WebDSLFacet("Illegal facet-Illegal facet");
		}
		
		return this;
	}	
	
	private String encode(String str){
		return str.replaceAll("\\\\", "\\\\\\\\ ").replaceAll("\\|", "\\\\p").replaceAll(",", "\\\\c").replaceAll(":", "\\\\a");
	}
	
	private String decode(String str){
		return str.replaceAll("\\\\a", ":").replaceAll("\\\\c",",").replaceAll("\\\\p", "|").replaceAll("\\\\\\\\ ", "\\\\");
	}
	
	// in case this is a facet on dates, get the value as date
	public Date getValueAsDate(){
		//Hibernate day resolution
		if(value.length() == 8)
			return utils.DateType.parseDate(value, "yyyyMMdd");
		//Hibernate minute resolution
		if(value.length() == 12)
			return utils.DateType.parseDate(value, "yyyyMMddHHmm");
		
		//else -> not supported
		return utils.DateType.parseDate("000000000000", "yyyyMMddHHmm");
	}
	public Float getValueAsFloat(){
		return Float.parseFloat(value);
	}
	public Integer getValueAsInt(){
		return Integer.parseInt(value);
	}
}
