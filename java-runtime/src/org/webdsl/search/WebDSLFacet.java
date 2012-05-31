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

    public WebDSLFacet(String field, String value, Occur oc, int cnt){
        this.fieldName = field;
        this.value = value;
        this.occur = oc;
        this.count = cnt;
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

    public WebDSLFacet mustNot(){
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
        paramMap.put("cnt", Integer.toString(count));
        paramMap.put("occ", occur.name());
        paramMap.put("sel", String.valueOf(isSelected));

        return paramMap;
    }

    public static WebDSLFacet fromParamMap(Map<String,String> paramMap){
        WebDSLFacet f = new WebDSLFacet();
        try{
            String key, value;
            for (Map.Entry<String, String> e : paramMap.entrySet()) {
                key = e.getKey();
                value = e.getValue();
                if ("fn".equals(key)) {
                    f.fieldName = value;
                } else if ("v".equals(key)) {
                    f.value = value;
                } else if ("cnt".equals(key)) {
                    f.count = Integer.parseInt(value);
                } else if ("occ".equals(key)){
                    f.occur = Occur.valueOf(value);
                } else if ("sel".equals(key)){
                    f.isSelected = Boolean.parseBoolean(value);
                }
            }
        } catch (Exception ex){
            return new WebDSLFacet("Illegal facet", "Illegal facet", Occur.SHOULD, 0);
        }
        return f;
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
    public boolean isMust(){
        return occur.equals(Occur.MUST);
    }
    public boolean isShould(){
        return occur.equals(Occur.SHOULD);
    }
    public boolean isMustNot(){
        return occur.equals(Occur.MUST_NOT);
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
