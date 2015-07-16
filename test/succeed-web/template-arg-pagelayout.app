application completelayouttemplate

entity Tmp{
  i : Int
}

var globali := Tmp{ i := 1111 }

page root(){
  parallaxpage(
    {
      "test1" ""
    },
    "test2",
    "test3",
    "http://materializecss.com/templates/parallax-template/background1.jpg",
    "test4test5",
    "test6",
    "test7",
    { <a href="#" id="download-button" class="btn-large waves-effect waves-light teal lighten-1">"test8"</a> },
    "test9",
    { form{ input(globali.i) submit action{} {"test10"} } },
    "test11",
    {  <p class="light">"test12"</p>},
    "test13",
    {  <p class="light">"test14"</p> },
    "http://materializecss.com/templates/parallax-template/background2.jpg",
    "test15test16",
    "test17",
    "test18",
    { <p class="left-align light">"test19"</p> },
    "http://materializecss.com/templates/parallax-template/background3.jpg",
    "test20test21",
    "test22",
    "test23",
    { <p class="grey-text text-lighten-4">"test24"</p> },
    "test25",
    {
      li{ a[class="white-text", href="#!"]{ "test26" } }
    },
    "test27",
    {
      li{ a[class="white-text", href="#!"]{ "test28" } }
    },
    {
      <a class="brown-text text-lighten-3" href="#">"test29"</a>
    }
  )
}

template parallaxpage(
  logo: TemplateElements,
  navbarlink1: String,
  navbarlink2: String,
  image1: String,
  image1alt: String,
  headertitle: String,
  headertext: String,
  headerelements: TemplateElements,
  leftbartitle: String,
  leftbarcontent: TemplateElements,
  middlebartitle: String,
  middlebarcontent: TemplateElements,
  rightbartitle: String,
  rightbarcontent: TemplateElements,
  image2: String,
  image2alt: String,
  middleimagetext: String,
  bigbartitle: String,
  bigbarcontent: TemplateElements,
  image3: String,
  image3alt: String,
  bottomimagetext: String,
  companytitle: String,
  companycontent: TemplateElements,
  link1title: String,
  link1 : TemplateElements,
  link2title: String,
  link2: TemplateElements,
  footercontent: TemplateElements
){
  main{
    <nav class="white" role="navigation">
      <div class="nav-wrapper container">
        <a id="logo-container" href="#" class="brand-logo">logo</a>
        <ul class="right hide-on-med-and-down">
          li{ a[href="#"]{ output(navbarlink1) } }
        </ul>
        <ul id="nav-mobile" class="side-nav">
          li{ a[href="#"]{ output(navbarlink2) } }
        </ul>
        <a href="#" data-activates="nav-mobile" class="button-collapse"><i class="mdi-navigation-menu"></i></a>
      </div>
    </nav>

    parallaxContainer(image1, image1alt)[id="index-banner"]{
      <br><br>
      <h1 class="header center teal-text text-lighten-2">output(headertitle)</h1>
      parallaxRowCenter{ output(headertext) }
      <div class="row center">
        headerelements
      </div>
      <br><br>
    }

    <div class="container">
      <div class="section">

        <!--   Icon Section   -->
        <div class="row">
          <div class="col s12 m4">
            <div class="icon-block">
              <h2 class="center brown-text"><i class="mdi-image-flash-on"></i></h2>
              <h5 class="center">output(leftbartitle)</h5>
              leftbarcontent
            </div>
          </div>

          <div class="col s12 m4">
            <div class="icon-block">
              <h2 class="center brown-text"><i class="mdi-social-group"></i></h2>
              <h5 class="center">output(middlebartitle)</h5>
              middlebarcontent
            </div>
          </div>

          <div class="col s12 m4">
            <div class="icon-block">
              <h2 class="center brown-text"><i class="mdi-action-settings"></i></h2>
              <h5 class="center">output(rightbartitle)</h5>
              rightbarcontent
            </div>
          </div>
        </div>

      </div>
    </div>

    parallaxContainer(image2, image2alt)[class="valign-wrapper"]{
      parallaxRowCenter{
        output(middleimagetext)
      }
    }

    <div class="container">
      <div class="section">

        <div class="row">
          <div class="col s12 center">
            <h3><i class="mdi-content-send brown-text"></i></h3>
            <h4>output(bigbartitle)</h4>
            bigbarcontent
          </div>
        </div>

      </div>
    </div>

    parallaxContainer(image3, image3alt)[class="valign-wrapper"]{
      parallaxRowCenter{
        output(bottomimagetext)
      }
    }

    footercomponents(
      companytitle,
      { "" companycontent },
      link1title,
      { "" link1},
      link2title,
      { "" link2},
      { "" footercontent})
  }
}

template parallaxContainer(image: String, alt: String){
  <div class="parallax-container" all attributes>
    <div class="section no-pad-bot">
      <div class="container">
        elements
      </div>
    </div>
    <div class="parallax"><img src=image alt=alt></div>
  </div>
}

template parallaxRowCenter(){
  <div class="row center">
    <h5 class="header col s12 light">elements</h5>
  </div>
}

template footercomponents(
  companytitle: String,
  companycontent: TemplateElements,
  link1title: String,
  link1: TemplateElements,
  link2title: String,
  link2: TemplateElements,
  footercontent: TemplateElements
){
  footer{
    container{
      row{
        colls(6,12){
          h5white{ output(companytitle) }
          companycontent
        }
        colls(3,12){
          h5white{ output(link1title) }
          ul{
            link1
          }
        }
        colls(3,12){
          h5white{ output(link2title) }
          ul{
            link2
          }
        }
      }
    }
    footerCopyright{
      footercontent
    }
  }
}

template footerCopyright(){
  <div class="footer-copyright">
    container{
      elements
    }
  </div>
}

override template container(){
  <div class="container" all attributes>
    elements
  </div>
}

override template row(){
  <div class="row" all attributes>
    elements
  </div>
}

template colls(l:Int, s:Int){
  <div class="col l"+l+" s"+s all attributes>
    elements
  </div>
}

htmlwrapper{
  a a
  li li
  ul ul
  h5white h5[class="white-text"]
  footer footer[class="page-footer teal"]
}

template main(){
  head{
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no"/>
    <title>"Parallax Template - Materialize"</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.0/css/materialize.min.css">
<style>
nav ul a,
nav .brand-logo {
  color: #444;
}

p {
  line-height: 2rem;
}

.button-collapse {
  color: #26a69a;
}

.parallax-container {
  min-height: 380px;
  line-height: 0;
  height: auto;
  color: rgba(255,255,255,.9);
}
  .parallax-container .section {
    width: 100%;
  }

@media only screen and (max-width : 992px) {
  .parallax-container .section {
    position: absolute;
    top: 40%;
  }
  #index-banner .section {
    top: 10%;
  }
}

@media only screen and (max-width : 600px) {
  #index-banner .section {
    top: 0;
  }
}

.icon-block {
  padding: 0 15px;
}

footer.page-footer {
  margin: 0;
}
</style>

  }

  elements

  <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.0/js/materialize.min.js"></script>
<script>
(function($){
  $(function(){
    $('.button-collapse').sideNav();
    $('.parallax').parallax();
  });
})(jQuery);
</script>

}

test{
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  
  for(i:Int from 1 to 30){
    assert(d.getPageSource().contains("test"+i));
  }
}
