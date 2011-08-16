package org.webdsl.search;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class SearchNamespace {
	
	public SearchNamespace() {}
	public SearchNamespace(String indexName, String namespaceAsString, Integer index) {
		setEntityName(indexName);
		setNamespaceAsString(namespaceAsString);
		setIndexNr(index);
	}
	
	@Id @GeneratedValue private Long id;	
	public Long getId() {
	  return id;
	}
	
	private void setId(Long id) {
	  this.id = id;
	}

	@javax.persistence.Column(name = "indexName", length = 255) @org.hibernate.annotations.AccessType(value = "field")
	private String indexName = "";	
	public void setEntityName(String indexName) {
		this.indexName = indexName;
	}
	public String getIndexName() {
		return indexName;
	}
	@javax.persistence.Column(name = "namespaceAsString", length = 255) @org.hibernate.annotations.AccessType(value = "field")
	private String namespaceAsString = "";	
	public void setNamespaceAsString(String namespaceAsString) {
		this.namespaceAsString = namespaceAsString;
	}
	public String getNamespaceAsString() {
		return namespaceAsString;
	}
	
	@javax.persistence.Column(name = "indexNr") @org.hibernate.annotations.AccessType(value = "field")
	private Integer indexNr = -1;
	public void setIndexNr(Integer indexNr) {
		this.indexNr = indexNr;
	}

	public Integer getIndexNr() {
		return indexNr;
	}
}
