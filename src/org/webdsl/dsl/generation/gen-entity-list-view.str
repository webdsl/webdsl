module org/webdsl/dsl/generation/gen-list-view
      

imports 
  libstrategolib 
  Java-15 
  libjava-front 
  
imports 
  org/webdsl/dsl/syntax/WebDSL
  org/webdsl/dsl/generation/utils
  org/webdsl/dsl/generation/xml-utils

rules
    
  entity-to-list-view : 
    EntityNoSuper(x_class, props) ->
    <entity-to-list-view> Entity(x_class, "Object", props)
    // @todo use some kind of forwarding mechanism for these type of definitions
  
  entity-to-list-view : 
    Entity(x_class, x_super, props) -> XmlFile("view", <concat-strings>[x_class, "List", ".xhtml"], <xml-composition-wrap>
    %><ui:define name="body">
    
        <h1>
           <h:outputText value="View <%= x_class %>" />
        </h1>
        
        <h:messages globalOnly="true" styleClass="message"/>
        
        <f:view>
          <h:outputText value="No <%= x_class %>" rendered="#{<%= x_componentList %>.rowCount==0}"/>
          <h:dataTable var="entry" value="#{<%= x_componentList %>}" rendered="#{<%= x_componentList %>.rowCount>0}">
            <h:column>
              <f:facet name="header">
                <h:outputText value="Id"/>
              </f:facet>
              <s:link view = "/view<%= x_class %>.jsp" value="#{entry.name}">
                <f:param name="<%= x_component %>Id" value="#{entry.id}" />
              </s:link>
            </h:column>
            
            // why  not delete the entity itself
            //<h:column>
            //   <s:button value="Delete" action="#{<%= x_componentListBean %>.delete}"/>
            //</h:column>
            
         </h:dataTable>
         <div class="actionButtons">
         //<s:link action="#{<%= x_componentListBean %>.refresh}" value="Refresh"/>
         <s:link view="/edit<%= x_class %>.xhtml" value="Create new <%= x_class %>"/>
         </div>
        </f:view>
        
      </ui:define><% )
    where x_component  := <decapitalize-string> x_class
        ; x_componentList := <concat-strings>[x_component, "List"]
        ; x_componentListBean := <concat-strings>[x_component, "ListBean"]
        ; x_class_home := <concat-strings>[x_component, "Home"]
        
        //; flds := <filter(property-to-edit-component(|x_component)
        //                  <+ debug(!"cannot generate xml for property: "); fail)> props
        
    // @todo add columns for (selected) properties; at least the 'name' of the entity should be included
	    
 // property-to-list-component(|x_component) :
 //   Property(x_prop, SimpleSort(y), []) -> 
 //   %><div class="prop">
 //       <tr class="prop">
 //          <td class="name"><%=Text([Literal(x_prop)])%>:</td>
 //          <td class="value">#{<%=x_component%>.<%=x_prop%>}</td>
 //       </tr>
 //     </div><%
 

   