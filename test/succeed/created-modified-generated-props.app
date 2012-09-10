application createdmodified

  entity Something {
  
  }

  page root(){
    output(Something{}.created)
    output(Something{}.modified)
  }