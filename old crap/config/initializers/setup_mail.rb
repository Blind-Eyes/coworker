ActionMailer::Base.smtp_settings = {  
      :address              => "smtp.gmail.com",  
      :port                 => 587,  
      :domain               => "gmail.com",  
     :user_name            => "seclabati@gmail.com", #Your user name
      :password             => "labati07", # Your password
      :authentication       => "plain",  
      :enable_starttls_auto => true  
}