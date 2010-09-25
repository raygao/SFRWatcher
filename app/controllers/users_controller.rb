################################################################################
# Project SFRWatcher: A Salesforce Chatter Externalization Tool                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
# Demo app running on http://parl8-vo.us:3000/                                 #
################################################################################

class UsersController < ApplicationController

  hobo_user_controller

  autocomplete
  
  auto_actions :all #, :except => [ :index, :new, :create ]

  def do_signup
    hobo_do_signup do
      if this.errors.blank?
        #flash[:notice] << "You must activate your account before you can log in.  Please check your email."
         flash[:notice] << " Your account has been created."

        # FIXME: remove these two lines after you get email working reliably
        # and before your application leaves its sandbox...
        #secret_path = user_activate_path :id=>this.id, :key => this.lifecycle.key
        #flash[:notice] << "The 'secret' link that was just emailed was: <a id='activation-link' href='#{secret_path}'>#{secret_path}</a>."
      else
        flash[:notice] = @this.errors.full_messages.join("<br/>")
        logger.info "error is " + flash[:notice]
      end

    end
  end  

end
