//THIS TEST IS EXCLUDED FROM WEB-TEST HYDRA JOB, BECAUSE IT CONTAINS NO TEST
//SEE generatenix.sh.in

application versionfour

  imports data
  imports lib
  imports ac
  imports ui
  imports invite
  imports rootpage
  
  
  //task 1
  
  access control rules 
  
    rule template showEvent(e:Event){
      e.organizer == null || e.organizer == principal
    }