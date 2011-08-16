package org.webdsl.search;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

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
		
	public Map<String,String> toParamMap(){
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("fn", fieldName);
		paramMap.put("v", value);
		paramMap.put("cnt", String.valueOf(count));
		return paramMap;
	}
	
	public WebDSLFacet fromParamMap(Map<String,String> paramMap){
		try{
			String key, value;
			for (Map.Entry<String, String> e : paramMap.entrySet()) {
				key = e.getKey();
				value = e.getValue();
				if ("fn".equals(key)) {
					this.fieldName = value;
				} else if ("v".equals(key)) {
					this.value = value;
				} else if ("cnt".equals(key)) {
					this.count = Integer.parseInt(value);
				}
			}
		} catch (Exception ex){
			return new WebDSLFacet("Illegal facet-Illegal facet");
		}
		
		return this;
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
