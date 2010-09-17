package main;

 ExtendEntity("Entry", "
 private Int accesses;
 
   public Int get_accesses {
     return accesses;  
   }
 
   public void set_accesses (Int accesses) {
     this.accesses = accesses;    
   }
 
 private String lastAccess;
 
   public String get_lastAccess {
     return lastAccess;  
   }
 
   public void set_lastAccess (String lastAccess) {
     this.lastAccess = lastAccess;    
   }
 ExtendFunction("write", "", "Block("Assign("Var("accesses")", "Plus("Var("accesses")", "IntLit("1")")")Assign("Var("lastAccess")", "StringLit(""now"")")Assign("Var("title")", "StringLit(""zyx"")")")")")
