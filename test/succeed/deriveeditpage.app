application com.example.derive

section templates

  define override main() {
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

  define override body() { }

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
    derive editPage from item
  }