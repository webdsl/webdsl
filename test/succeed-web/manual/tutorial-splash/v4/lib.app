module lib

  define ignore-access-control radiobutton(ent1:Ref<Entity>,ent2:List<Entity>){
    var rname := getUniqueTemplateId()
    var tmp : String:= getRequestParameter(rname);
    var subme : Entity := null;
    init{
      if(tmp != null){
        subme := loadEntity(ent1.getTypeString(),UUIDFromString(tmp));
      }
    }
    for(e:Entity in ent2){
      <input type="radio"
        //either it was submitted or it was not submitted but the value was already p
        if(tmp != null && subme == e || tmp == null && ent1 == e){
           checked="checked"
        }
        name=rname
        value=e.id
        all attributes
      />
      output(e.name)
    }
    databind{
      if(tmp != null && subme in ent2){
        ent1 := subme;
      }
    }
  }

  define ignore-access-control errorTemplateInput(messages : List<String>){
    validatedInput
    for(ve: String in messages){
      block()[style := "width:100%; clear:left; float:left; color: #FF0000;"]{
        output(ve)
      }
    }
  }