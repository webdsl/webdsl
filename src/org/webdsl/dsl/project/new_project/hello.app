application APPLICATION_NAME

description {
  This is an automatically generated description
}

imports templates
section pages

define page root() {
  main()
  define body() {
    "Hello world!"
  }
}

entity ExampleEntity {
  property :: String (name)
}

derive crud ExampleEntity