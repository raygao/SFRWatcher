################################################################################
# Project SFRWatcher: A Salesforce Chatter Externalization Tool                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
# Demo app running on http://parl8-vo.us:3000/                                 #
################################################################################

class UserMailer < ActionMailer::Base
  
  def forgot_password(user, key)
    host = Hobo::Controller.request_host
    app_name = Hobo::Controller.app_name || host
    @subject    = "#{app_name} -- forgotten password"
    @body       = { :user => user, :key => key, :host => host, :app_name => app_name }
    @recipients = user.email_address
    @from       = "no-reply@#{host}"
    @sent_on    = Time.now
    @headers    = {}
  end

  # for e-mail activation
  def activation(user, key)
    host = Hobo::Controller.request_host
    app_name = Hobo::Controller.app_name || host
    @subject    = "#{app_name} -- activate"
    @body       = { :user => user, :key => key, :host => host, :app_name => app_name }
    @recipients = user.email_address
    @from       = "no-reply@#{host}"
    @sent_on    = Time.now
    @headers    = {}
  end

  def account_created(user)
    host = Hobo::Controller.request_host
    app_name = Hobo::Controller.app_name || host
    @subject    = "Account on #{app_name} has been created."
    @body       = { :user => user, :host => host, :app_name => app_name, :password => user.password, :email => user.email_address }
    @recipients = user.email_address
    @from       = "no-reply@#{host}"
    @sent_on    = Time.now
    @headers    = {}
  end
end
