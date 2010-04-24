//Entity function with name 'save' collides with a built-in function that you are not allowed to overwrite.
//Entity function with name 'delete' collides with a built-in function that you are not allowed to overwrite.

application test

  entity User{
    test :: Int
    
    function save(){
    
    }
    function delete(){
    
    }
  }
  
  define page root(){}
