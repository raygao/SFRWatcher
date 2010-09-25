################################################################################
# Project SFRWatcher: A Salesforce Chatter Externalization Tool                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
# Demo app running on http://parl8-vo.us:3000/                                 #
################################################################################

class SalesforceObjectsController < ApplicationController

  #hobo_controller

  hobo_model_controller

  auto_actions :all, [:do_advanced_search, :advanced_search_form, :new_ajax_sf_form, :observe_object, :ignore_object]

  def index; end

  before_filter :sf_login

  # Load the appropriate Object creation form for each type of SF object
  def new_ajax_sf_form
    @object_type = params[:salesforce_object][:object_type]

    @sf_object = salesforce_object_create(@object_type)
    @editable = true
    object_description = @binding.describeSObject(:sObjectType => @object_type)
    @meta_attributes = object_description.describeSObjectResponse.result
    
    render :file => "salesforce_objects/new_ajax_sf_form.dryml"
  end

  # Create a new Salesforce Object
  def create
    @object_type = params[:otype]
    new_attributes = params[@object_type]
    
    if params.include?('Save')
      begin
        @sf_object = salesforce_object_create(@object_type)
        if @sf_object.update_attributes(new_attributes)
          flash[:notice] = "New record #{@object_type} created. It has Object ID: #{@sf_object.id}."
        else
          flash[:notice] = "Record cannot be created."
        end
        #redirect_to request.env['HTTP_REFERER']
        redirect_to :controller => "Salesforce_Objects", :action => 'show', :id => @sf_object.id
      rescue ActiveSalesforce::ASFError => exception
        logger.info(exception.fault)
        flash[:notice] = exception.fault
        redirect_to request.env['HTTP_REFERER']
      end

      #render :text => 'Save button clicked.'#@user_group = UserGroup.create( params[:user_group] )
    elsif params.include?('Cancel')
      flash[:notice] = "Update Cancelled."
      redirect_to request.env['HTTP_REFERER']
      # render :text=> 'Cancel button clicked.'
    end
    #redirect_to :action => 'list' and return
  end


  def delete
    @oid = params[:oid]
    @sf_object = salesforce_object_find_by_id(@oid)
    @otype = @sf_object.type

    result = Salesforce::SfBase.delete(@oid)
    if (result.first.success == 'true') || (result.first.success == true)
      flash[:notice] = "Object #{@oid} has been deleted."
      redirect_to :controller => "Salesforce_Objects", :action => 'index'
    else
      flash[:notice] = "Object cannot be deleted."
      redirect_to :controller => "Salesforce_Objects", :action => 'index'
    end


  end

  # Display a Salesforce Object record
  def show
    # pp user.connection.binding.describeSObject(:sObjectType => "Contact")
    @oid = params[:id]
    @otype = determine_sf_object_type(@oid)

    @sf_object = salesforce_object_find_by_id(@oid)

    object_description = @binding.describeSObject(:sObjectType => @otype)
    @meta_attributes = object_description.describeSObjectResponse.result
    @this = @sf_object

    if @meta_attributes[:updateable].to_s.upcase == "TRUE"
      @editable = true
    else
      @editable = false
    end

  end

  # Updates a SalesObject Record
  # either work or show error.
  def update
    @oid = params[:oid]
    new_attributes = params[params[:otype]]
    if params.include?('Save')
      begin
        @sf_object = salesforce_object_find_by_id(@oid)
        unless @sf_object.nil?
          if @sf_object.update_attributes(new_attributes)
            flash[:notice] = "Record updated."
            redirect_to request.env['HTTP_REFERER']
          else
            flash[:notice] = "Record cannot be updated"
            redirect_to request.env['HTTP_REFERER']
          end
        else
          flash[:notice] = "Updating a Nil object is not supported."
          redirect_to request.env['HTTP_REFERER']
        end              
      rescue ActiveSalesforce::ASFError => exception
        logger.info(exception.fault)
        flash[:notice] = exception.fault
        redirect_to request.env['HTTP_REFERER']
      end

      #render :text => 'Save button clicked.'#@user_group = UserGroup.create( params[:user_group] )
    elsif params.include?('Cancel')
      flash[:notice] = "Update Cancelled."
      redirect_to request.env['HTTP_REFERER']
      # render :text=> 'Cancel button clicked.'
    elsif params.include?('Delete')
      delete
    end
    #redirect_to :action => 'list' and return
  end

  #Summarizes the application and analyzes Salesforce Objects
  def summary
    if !current_user.administrator?
      redirect_to user_login_path
    end
  end

  def search
    unless params[:salesforce_object][:name].nil?

      query_conditions = ["name like :name", {:name => "%" +  params[:salesforce_object][:name] + "%"}]
      @results = salesforce_object_find_by_type_and_conditions(params[:salesforce_object][:object_type], query_conditions)

      #or use Salesforce Object Search Language (SOSL)
      #description = params[:salesforce_object][:description]
      #object_type = params[:salesforce_object][:object_type]
      #searchstring = "find {#{description}} in all fields returning #{object_type}(id, name, description, phone)"
      #@results = @binding.search :searchString =>  searchstring
      #logger.info @results
    else
      @results = salesforce_object_find_all(params[:salesforce_object][:object_type], nil)
    end
  end
  
  def observe_object
    begin
      nes = Salesforce::EntitySubscription.new
      nes.parent_id = params[:id]
      nes.subscriber_id = @current_sf_user.id

      if request.xhr?
        #AJAX Request
        if nes.save
          #AJAX request.
          render :text => 'Ignore'
        else
          render :text => 'Error'
        end
      else
        if nes.save
          # not AJAX, regular submit
          flash[:notice] = "You are now tracking #{nes.parent_id}."
          redirect_to request.env['HTTP_REFERER']
        else
          flash[:notice] = "You cannot track #{nes.parent_id}"
          redirect_to request.env['HTTP_REFERER']
        end
      end
    rescue Exception => exception
      if request.xhr?
        render :text => "Error: #{exception.fault}"
      else
        flash[:notice] = "Error: #{exception.fault}."
        redirect_to request.env['HTTP_REFERER']
      end
    end

  end

  def ignore_object
    begin
      nes = Salesforce::EntitySubscription.find_by_parent_id(params[:id])
      if request.xhr?
        #AJAX request
        if nes.delete
          render :text => 'Observe'
        else
          render :text => 'Error'
        end
      else
        #not AJAX, regular submit
        if nes.delete
          flash[:notice] = "You are no longer subscribed to entity -> #{params[:id]}"
          redirect_to request.env['HTTP_REFERER']
        else
          flash[:notice] = "You cannot unsubscribe from entity -> #{params[:id]}"
          redirect_to request.env['HTTP_REFERER']
        end
      end
    rescue Exception => exception
      if request.xhr?
        render :text => "Error: #{exception.message}"
      else
        flash[:notice] = "Error: #{exception.message}."
        redirect_to request.env['HTTP_REFERER']
      end
    end
  end


  def do_advanced_search

  end

  def advanced_search_form
    render :text => 'advanced search form'
  end
end

