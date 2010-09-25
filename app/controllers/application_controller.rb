################################################################################
# Project SFRWatcher: A Salesforce Chatter Externalization Tool                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
# Demo app running on http://parl8-vo.us:3000/                                 #
################################################################################

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ApplicationHelper

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # before_filter ActiveSalesforce::SessionIDAuthenticationFilter

  #######################################
  # time to expire the session          #
  #######################################
  def session_expiry
    reset_session if session[:expiry_time] and session[:expiry_time] < Time.now

    session[:expiry_time] = MAX_SESSION_PERIOD.seconds.from_now
    return true
  end

  before_filter :show_cookie
  before_filter :session_expiry #sets up session expirtion policy

  def show_cookie
    puts '--------------------------------------'
    if !request.remote_ip.nil?
      puts "Client's IP is " + request.remote_ip
    elsif !request.env["HTTP_X_FORWARDED_FOR"].nil?
      puts "Client's IP is " + request.env["HTTP_X_FORWARDED_FOR"]
    end
    puts 'You have following cookies'
    request.cookies.keys.each do |key|
      logger.info 'cookie name -> '  + key + ', value -> ' + request.cookies[key]
      puts 'cookie name -> '  + key + ', value -> ' + request.cookies[key]
    end
    puts '--------------------------------------'
  end

  #######################################
  # Validates and log into Salesforce   #
  # sets:
  #  1. @current_user_sf_login_session
  #  2. @binding
  #  3. @current_sf_user
  #
  # returns:
  #  1. @current_user_sf_login_session
  #  2. false
  #######################################
  def sf_login
    # Check that user has already entered the SF credentials
    # otherwise, raise exception
    if current_user.guest?
      #raise Parl8_vous::Missing_Credential_Error.new(logger, "Current User cannot be 'GUEST', login first.")
      flash[:notice] = "Current User cannot be 'GUEST', login first."
      redirect_to base_url
      return
    end

    if current_user[:salesforce_username].nil? || current_user[:salesforce_password].nil? || current_user[:salesforce_secret_token].nil?
      #raise Parl8_vous::Missing_Credential_Error.new(logger, "Missing Safesforce login credentials.")
      flash[:notice] = "Missing Safesforce login credentials."
      redirect_to base_url
      return
    end

    sfUserID = current_user.salesforce_username
    sfPassword = current_user.salesforce_password
    sfToken = current_user.salesforce_secret_token

    begin

      puts "******Previous SF connections****"
      puts "Previous user is: " + Salesforce::User.connection.binding.instance_variable_get(:@user)
      puts "Previous password is: " + Salesforce::User.connection.binding.instance_variable_get(:@password)
      puts "Previous session id is " + Salesforce::User.connection.binding.instance_variable_get(:@session_id)
      puts "*****************************"

      #TODO need to revalidate the connection, if the user changes username, password, or security token

      @current_user_sf_login_session = nil

      if !session["user_session:" + current_user.id.to_s].nil?
        # get the existing connection
        @current_user_sf_login_session = Salesforce::SfBase.retrieve_connection()
        # test to see
        # 1. If the connection is active or
        # 2. If it is another user's stale session
        # In either case, relogin with current user's credential
        cid = @current_user_sf_login_session.instance_variable_get(:@connection).instance_variable_get(:@session_id)
        if !@current_user_sf_login_session.active? ||
            (cid != session["user_session:" + current_user.id.to_s])
          # not active -> connect fresh. #TODO to make connection session id stick
          Salesforce::SfBase.remove_connection(Salesforce::SfBase)
          # if username/password/connection token is not valid, raise exception RuntimeError
          @current_user_sf_login_session = Salesforce::SfBase.login(sfUserID, sfPassword, sfToken).connection
          session["user_session:" + current_user.id.to_s] = @current_user_sf_login_session.instance_variable_get(:@connection).instance_variable_get(:@session_id)
        end
      else
        # login with current user's SF credentials and set cookie
        # if username/password/connection token is not valid, raise exception RuntimeError
        @current_user_sf_login_session = Salesforce::SfBase.login(sfUserID, sfPassword, sfToken).connection
        session["user_session:" + current_user.id.to_s] = @current_user_sf_login_session.instance_variable_get(:@connection).instance_variable_get(:@session_id)
      end

      # TODO Use RForce Binding for now, until a better solution is found.
      @binding = nil
      if @current_user_sf_login_session.active?
        @binding = @current_user_sf_login_session.binding
      else
        @binding = RForce::Binding.new 'https://login.salesforce.com/services/Soap/u/19.0'
        @binding.login sfUserID, (sfPassword + sfToken )
      end

      @current_sf_user = Salesforce::User.find_by_username(sfUserID)

      puts "****** Current SF connections****"
      puts "Updated user is: " + Salesforce::User.connection.binding.instance_variable_get(:@user)
      puts "Updated password is: " + Salesforce::User.connection.binding.instance_variable_get(:@password)
      puts "Updated session id is " + Salesforce::User.connection.binding.instance_variable_get(:@session_id)
      puts "*****************************"

      return @current_user_sf_login_session
    rescue RuntimeError => re
      #looking for "Incorrect user name / password"
      if re.message.match(/Incorrect\s+user\s+name\s+\/\s+password/mi)
        flash[:notice] = "Your Salesforce User/Password is invalid." #re.message
        redirect_to base_url
        #raise Parl8_vous::Login_Failed_Error.new(logger, re.message)
      elsif re.message.match(/INVALID_OPERATION_WITH_EXPIRED_PASSWORD/mi)
        flash[:notice] = "Your Salesforce User/Password has expired. Go back to Salesforce and update it." #re.message
        redirect_to base_url
      else
        raise re
        return false
      end
    rescue Exception => exception
      logger.info "Exception in loggin: #{exception.message}"
      return false
    end

  end
  
end
