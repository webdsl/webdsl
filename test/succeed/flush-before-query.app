application test

define page root(){}

entity Recipe{
  
}

test saveRecipe {
       var rs: List<Recipe> := from Recipe;
       assert(rs.length == 0);
       var r:= Recipe{};
       r.save();
       rs := from Recipe;
       assert(rs.length != 0);
}