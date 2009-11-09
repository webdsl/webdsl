application com.example.derive

description {
  This is an automatically generated description
}

section templates

  define main() {
    block("top") {
      top() }
    block("body") {
      block("left_innerbody") {
        sidebar() }
      block("main_innerbody") {
        body() } }
  }
  
  define top() {
    block("header") { }
  }
  
  define sidebar() { }

  define body() { }

section data model

  entity NewsItem {
    name :: String
    text :: Text
    comment :: Text
    dinges :: String := "Dinges" 
  }

section pages

  define page root() {
     var item : NewsItem;
    
    init {
      item := NewsItem{};
      item.save();
    }
    table {
      row { navigate(editNewsItem(item)){"Edit news item"} }
    }
  }

section test pages

  define page editNewsItem(item: NewsItem) {
    derive editPage from item for (name, text)
  }