application derive

  entity CostSheet { 
    function initialize() { init(); }
    function init() { }
  }

  var cost := CostSheet{ };
    
  define page root() {
    derive initFunction from cost
  }