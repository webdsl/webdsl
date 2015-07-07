//No property length defined for TemplateElements

// old error:
// Type cannot be determined for empty untyped set creation
application test
 
  define page root(){
    output({}.length)
  }