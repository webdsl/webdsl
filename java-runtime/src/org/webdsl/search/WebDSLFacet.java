package org.webdsl.search;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.lucene.search.BooleanClause.Occur;
import org.hibernate.search.query.facet.Facet;

import com.browseengine.bobo.api.BrowseFacet;

public class WebDSLFacet {
	
	public int count;
	public String fieldName;
	public String value;
	protected Occur occur = Occur.MUST;
	protected boolean isSelected;
	
	
	public WebDSLFacet(){};
	
	public WebDSLFacet(String field, String value, Occur oc){
		this.fieldName = field;
		this.value = value;
		this.occur = oc;
	}
	
	public WebDSLFacet(BrowseFacet bf, String field){
		this.fieldName = field;
		this.value = bf.getValue();
		this.count = bf.getFacetValueHitCount();		
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
	
	public WebDSLFacet must(){
		occur = Occur.MUST;
		return this;
	}
	
	public WebDSLFacet mustnot(){
		occur = Occur.MUST_NOT;
		return this;
	}
	
	public WebDSLFacet should(){
		occur = Occur.SHOULD;
		return this;
	}
			
	public Map<String,String> toParamMap(){
		
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("fn", fieldName);
		paramMap.put("v", value);
		paramMap.put("cnt", String.valueOf(count));
		paramMap.put("occ", occur.name());
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
				} else if ("occ".equals(key)){
					this.occur = Occur.valueOf(value);
				}
			}
		} catch (Exception ex){
			return new WebDSLFacet("Illegal facet", "Illegal facet", Occur.SHOULD);
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
	public boolean isSelected(){
		return isSelected;
	}
	/*
	 * Compares to other WebDSLFacet object based on facet field and value  
	 *
	 */
	@Override 
	public boolean equals(Object other){
		return ( (other instanceof WebDSLFacet) 
				&& this.fieldName.equals( ( (WebDSLFacet)other ).fieldName)
				&& this.value.equals( ( (WebDSLFacet)other ).value)
			   );
		
	}
}
