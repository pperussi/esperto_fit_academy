class CustomFormatter < Logger::Formatter                  
    def call(severity, time, progname, msg)                                     
      "[Level] #{severity} \n" +                                                  
      "[Time] #{time} \n" +                                                       
      "[Message] #{msg} \n" +
      "=(^___^)= nyaaaa~\n\n\n"                                                
    end                                                                           
  end