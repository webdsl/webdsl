application nativeclass

  native class utils.TableContext as TableThingy {
    inRowContext : Int
              
    constructor()
    
    enterRowContext() 
    isInRowContext() : Bool
  }

  define page root() {
  
    var p : TableThingy := TableThingy()

    init{
      p.enterRowContext();
      p.enterRowContext();
    }
    
    output(p.isInRowContext())
    output(p.inRowContext)
    
  }
