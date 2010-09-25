class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this
  
  set_table_name 'hobo_users'

  fields do
    name          :string, :required, :unique
    #role          enum_string(:Coordinator, :Analyst, :Developer, :Tester)

    #Salesforce login information
    salesforce_username         :email_address #check for email address
    salesforce_password         :password
    salesforce_secret_token     :string
    chatter_load_attachment     :boolean, :default => true

    email_address :email_address, :login => true
    administrator :boolean, :default => false
    timestamps
  end

  has_many :rules, :class_name => "Rule", :foreign_key => "owner_id", :dependent => :destroy
  has_many :tasks, :class_name => "Task", :foreign_key => "owner_id", :dependent => :destroy
  has_many :filters, :class_name => "Filter", :foreign_key => "owner_id", :dependent => :destroy
  has_many :words, :class_name => "Word", :foreign_key => "owner_id", :dependent => :destroy
  has_many :chatter_sessions, :class_name => "ChatterSession", :foreign_key => "owner_id", :dependent => :destroy
  
  # This gives admin rights to the first sign-up.
  # Just remove it if you don't want that
  before_create { |user| user.administrator = true if !Rails.env.test? && count == 0 }

  # --- Signup lifecycle --- #

  lifecycle do

    state :active, :default => true
    state :inactive
    # for e-mail activation
    # state :inactive, :default => true
    # state :active

    create :signup, :available_to => "Guest",
      :params => [:name, :email_address, :password, :password_confirmation, :salesforce_username,
                  :salesforce_password, :salesforce_secret_token, :chatter_load_attachment],
      :become => :active do
        UserMailer.deliver_account_created(self) unless email_address.blank?
      end

    # create :signup, :available_to => "Guest",
    #  :params => [:name, :email_address, :password, :password_confirmation, :salesforce_username,
    #              :salesforce_password, :salesforce_secret_token],
    #  :become => :inactive, :new_key => true do
    #      UserMailer.deliver_activation(self, lifecycle.key) unless email_address.blank?
    # end


    # transition :activate, { :inactive => :active }, :available_to => :key_holder
             
    transition :request_password_reset, { :active => :active }, :new_key => true do
      UserMailer.deliver_forgot_password(self, lifecycle.key)
    end

    # transition :request_password_reset, { :inactive => :inactive }, :new_key => true do
    #   UserMailer.deliver_activation(self, lifecycle.key)
    # end

    transition :reset_password, { :active => :active }, :available_to => :key_holder,
      :params => [ :password, :password_confirmation ]

  end
  

  # --- Permissions --- #

  def create_permitted?
    #false
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator? || 
      (acting_user == self && only_changed?(:email_address, :crypted_password,
        :current_password, :password, :password_confirmation,
        :salesforce_username, :salesforce_password, :salesforce_secret_token, :chatter_load_attachment ))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
