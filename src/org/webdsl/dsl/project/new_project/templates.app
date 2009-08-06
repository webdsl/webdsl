module templates

section main template.

  define main() {
    div("outersidebar") {
      sidebar()
    }
    div("outerbody") {
      div("menubar") {
        menu()
      }
      body()
      footer()
    }
  }

section basic page elements.

  define body(){
  
  }

  define sidebar() {

  }
  
  define footer() {
    "generated with "
    navigate(url("http://www.webdsl.org")){ "WebDSL" } " and "
    navigate(url("http://www.strategoxt.org")){ "Stratego/XT" }
  }
  
section menus.
  
  define menu() {

    
  }
  
section entity management.

  define manageMenu() {}
  
  define page manage() {
    main()
    define sidebar() {}
    define body() {

    }
  }

