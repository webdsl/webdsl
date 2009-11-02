application registerexample

  entity User {
    password :: Secret
  }

  define main(){
    elements
  }

  define page root() {
    main {
   
      var u : User := User{};
      var p : Secret;

      header { "Register" }
      form {
        label("Password:") { input(u.password) }
        label("Verify password:") { input(p){validate(p==u.password,"passwords don't match input")} }
        validate(p==u.password,"passwords don't match form")
        action("Register", register())

        action register() {
          validate(p==u.password,"passwords don't match action");
          u.password := u.password.digest();
          u.save();
          message("You have successfully registered. Sign in now.");
        }
      }
    }
  }

