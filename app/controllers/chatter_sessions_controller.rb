################################################################################
# Project SFRWatcher: A Salesforce Chatter Externalization Tool                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
# Demo app running on http://parl8-vo.us:3000/                                 #
################################################################################

require 'yaml'
require 'base64'

class ChatterSessionsController < ApplicationController

  hobo_model_controller

  auto_actions :all, [:entities, :show_object, :add_post, :delete_item, :add_comment, :chatter_sessions]

  autocomplete

  before_filter :sf_login


  #######################################
  # Show a particular object
  #######################################
  def show_object
    @oid = params[:id]
    @otype = determine_sf_object_type(params[:id])

    @sf_object = salesforce_object_find_by_id(@oid)
    unless @sf_object.nil?
      @feeds = Array.new

      chatter_feed_finder = Salesforce::ChatterFeed.new
      limit = QUERY_RESULT_LIMIT || 100
      #@feeds = chatter_feed_finder.get_all_chatter_feeds_with_attachments(@oid, @otype, @binding, session.session_id, limit, true)

      if current_user[:chatter_load_attachment] == true
        @feeds = chatter_feed_finder.get_all_chatter_feeds_with_attachments(@oid, @otype, @binding, session.session_id, limit, true)
      else
        @feeds = chatter_feed_finder.get_all_chatter_feeds_without_attachments(@oid, @otype, @binding, session.session_id, limit)
      end

      @this = @feeds
    else
      flash[:notice] = "Such object does not exist."
    end
    return
  end

  #######################################
  # Adds a new feedpost/staus-update to SF objects
  #######################################

  def create #add_post
    otype = determine_sf_object_type(params[:oid])
    @oid = params[:oid]
    message = params[:message]

    if otype == "User" && params[:chatter_session].nil?
      # Default to be FeedPost to be UserStatus type
      target_user = Salesforce::User.find(params[:oid])

      target_user.current_status = message
      if target_user.save
        flash[:notice] = "Your message '#{message}' has been successfully posted on: '#{target_user.name.to_s}'"
      else
        flash[:notice] = "Unable to update the status of: '#{target_user.name.to_s}'"
      end
    else
      feedpost = Salesforce::FeedPost.new

      @sf_object = salesforce_object_find_by_id(@oid)

      feedpost.parent_id = @sf_object.id
      feedpost.body =  message

      unless params[:chatter_session].nil?
        # 1st, if it has attachment, it is a ContentPost
        if !params[:chatter_session][:photo].nil?
          # The post contains file attachment
          tmp_file = params[:chatter_session][:photo]
          # Rewind the file to beginning
          tmp_file.rewind
          content_data = tmp_file.read

          feedpost.content_data = Base64.b64encode(content_data)
          feedpost.content_file_name = tmp_file.original_filename
          feedpost.content_size = tmp_file.size
          feedpost.type = 'ContentPost'

          # 2nd, it is a LinkPost
        elsif !params[:chatter_session][:link_url].nil?
          feedpost.link_url = params[:chatter_session][:link_url]
          feedpost.title = params[:chatter_session][:link_title]
          feedpost.type = 'LinkPost'
        end
      end

      if feedpost.save
        flash[:notice] = "Your message '#{message}' has been successfully posted."
      else
        flash[:notice] = "Unable to post to #{param[:otype]}"
      end

    end

    #redirect_to :controller => "Chatter_Sessions", :action => "index"
    # see http://stackoverflow.com/questions/771656/correctly-doing-redirect-to-back-in-ruby-on-rails-when-referrer-is-not-available
    # regarding redirect_to :back
    redirect_to request.env['HTTP_REFERER']
  end

  #######################################
  # Add Comment
  #######################################
  def add_comment
    begin
      comment = Salesforce::FeedComment.new
      comment.comment_body = params[:comment_body]
      comment.feed_item_id= params[:targetid]
      result = comment.save

      if request.xhr?
        @feed_comment =RForce::MethodHash.new
        @feed_comment[:CreatedBy] = RForce::MethodHash.new
        @feed_comment[:CreatedBy][:LastName] = @current_sf_user.last_name
        @feed_comment[:CreatedBy][:FirstName] = @current_sf_user.first_name
        @feed_comment[:CreatedBy][:Id] = RForce::MethodHash.new
        @feed_comment[:CreatedBy][:Id][0] = @current_sf_user.id
        @feed_comment[:CommentBody] = comment.comment_body
        @feed_comment[:CreatedDate] = Time.now.getutc.to_s
        @feed_comment[:Id] = RForce::MethodHash.new
        @feed_comment[:Id][0] = comment.id
        @feed_comment[:type]='FeedComment'

        @this = @feed_comment

        render :file => "chatter_sessions/add_comment_ajax_response.dryml"
        #render :json => comment
      else
        if result == true
          flash[:notice] = "Comment has been added."
        else
          flash[:notice] = "Cannot add comment."
        end
        redirect_to request.env['HTTP_REFERER']
      end
    rescue Exception => exception
      flash[:notice] = "#{params[:targetid]} cannot be commented on due to unknown reason: #{exception.message}."
      logger.info("An Exception occurred: " + exception.message + " " + exception.backtrace.to_s)
    end

  end

  #######################################
  # Delete Item
  #######################################
  def delete_item
    begin
      result = Salesforce::SfBase.delete(params[:id])
      if (result.first.success == 'true') || (result.first.success == true)
        flash[:notice] = "#{params[:object_type]} has been deleted."
      else
        flash[:notice] = "#{params[:object_type]} (#{params[:id]}) cannot be deleted."
      end
    rescue ActiveRecord::StatementInvalid => exception
      # ActiveSalesforce::ASFError: statusCodeINVALID_ID_FIELDmessageinvalid record id: DELETE FROM feedposts WHERE (id IN ('ID'))
      match = exception.message.match(/ActiveSalesforce::ASFError/mi)
      if match
        flash[:notice] = "#{params[:object_type]} (#{params[:id]}) has already been deleted."
      else
        flash[:notice] = "#{params[:object_type]} (#{params[:id]}) cannot be deleted due to unknown reason: #{exception.message}."
        logger.info("An Exception occurred: " + exception.message + " " + exception.backtrace.to_s)
      end

    ensure
      unless request.env['HTTP_REFERER'].nil?
        redirect_to request.env['HTTP_REFERER']
      else
        redirect_to :controller => "Chatter_Sessions", :action => "index"
      end
    end

  end

  #######################################
  # Index page
  #######################################
  def index
    @first_name = @current_sf_user.first_name
    @last_name = @current_sf_user.last_name

    do_get_entities_followed

    do_get_entities_following_me

    @feeds = Array.new

    chatter_feed_finder = Salesforce::ChatterFeed.new

    limit = QUERY_RESULT_LIMIT || 100
    #@feeds = chatter_feed_finder.get_all_chatter_feeds_with_attachments(@current_sf_user.id, "News", @binding, session.session_id, limit, true)

    if current_user[:chatter_load_attachment] == true
      @feeds = chatter_feed_finder.get_all_chatter_feeds_with_attachments(@current_sf_user.id, "News", @binding, session.session_id, limit, true)
    else
      @feeds = chatter_feed_finder.get_all_chatter_feeds_without_attachments(@current_sf_user.id, "News", @binding, session.session_id, limit)
    end
    @this = @feeds
    
  end

  def do_get_entities_following_me
    begin
      limit = QUERY_RESULT_LIMIT || 100
      query_conditions = "parent_id='#{@current_sf_user.id}'"
      results = Salesforce::EntitySubscription.find(:all, :conditions => [query_conditions], :limit => limit.to_s)
      if results.size > 0
        logger.info "Number of entities following me is: " + results.size.to_s
        @entities_following_me = Hash.new
        results.each do |entity|
          row = Hash.new
          if determine_sf_object_type(entity.subscriber_id) != "Unknown"
            row['id'] = entity.subscriber_id
            row['name'] = salesforce_object_find_by_id(entity.subscriber_id).name
            row['type'] = determine_sf_object_type(entity.subscriber_id)
          else
            row['id'] = entity.subscriber_id
            row['name'] = 'Unknown'
            row['type'] = determine_sf_object_type(entity.subscriber_id)
          end

          if @entities_following_me[row['type']].nil?
            @entities_following_me[row['type']] = Array.new
          end
          @entities_following_me[row['type']] << row
        end
        return @entities_following_me
        
      end
    rescue ActiveRecord::RecordNotFound => exception
      logger.info("***Record not found: " + exception.class.name + exception.message + "<hr/>" + exception.backtrace.to_s)
      flash[:notice] = "#{otype} with ID: #{oid} cannot be found. <br/>"
      return
    rescue NoMethodError => nme
      #matching for -> undefined method `entity_subscriptions' for
      #User does not have chatter installed.
      if nme.message.match(/undefined\s+method\s+\Sentity_subscriptions\S/mi)
        flash[:notice] = "You do not have Salesforce Chatter application installed."
        redirect_to base_url
      else
        return nme
      end
    end
  end

  
  def do_get_entities_followed
    begin
      limit = QUERY_RESULT_LIMIT || 100

      result = @current_sf_user.entity_subscriptions.find(:all, :limit => limit.to_s)
      @entities_following = Hash.new

      result_sorted = result.sort_by { |item| determine_sf_object_type(item[:subscriber_id]) }

      result_sorted.each do |an_entity|
        oid = an_entity.parent_id.to_s
        otype = determine_sf_object_type(oid)

        if @entities_following[otype].nil?
          @entities_following[otype] = Array.new
        end

        sf_object = salesforce_object_find_by_id(oid)
        unless sf_object.nil?
          entity_row = RForce::MethodHash.new
          entity_row['name'] = sf_object.name
          entity_row['id'] = sf_object.id #should be the same as <an_entity.parent_id.to_s>
          entity_row['type'] = otype

          @entities_following[otype] << entity_row
        else
          logger.info '---> #{oid} cannot be read by current user. <---'
        end
      end
      return @entities_following

    rescue ActiveRecord::RecordNotFound => exception
      logger.info("***Record not found: " + exception.class.name + exception.message + "<hr/>" + exception.backtrace.to_s)
      flash[:notice] = "#{otype} with ID: #{oid} cannot be found. <br/>"
      return
    rescue NoMethodError => nme
      #matching for -> undefined method `entity_subscriptions' for
      #User does not have chatter installed.
      if nme.message.match(/undefined\s+method\s+\Sentity_subscriptions\S/mi)
        flash[:notice] = "You do not have Salesforce Chatter application installed."
        redirect_to base_url
      else
        return nme
      end
    rescue Exception => exception
      logger.info exception.message
    end
  end
  
  #######################################
  # Getting feeds based on EntitySubscription
  #######################################
  def entities
    begin
      @first_name = @current_sf_user.first_name
      @last_name = @current_sf_user.last_name

      @entity_results = Array.new

      limit = QUERY_RESULT_LIMIT || 100

      @safe_user_entity_subscriptions = @current_sf_user.entity_subscriptions.find(:all, :limit => limit.to_s)
      chatter_feed_finder = Salesforce::ChatterFeed.new

      # This will be an array of entities (Users, Accounts, Asssets, etc) that this user has subscribed.
      @safe_user_entity_subscriptions.each do |an_entity|
        oid = an_entity.parent_id.to_s
        otype = determine_sf_object_type(oid)

        begin
          sf_object = salesforce_object_find_by_id(oid)
          entity_row =RForce::MethodHash.new
          entity_row['name'] = sf_object.name
          entity_row['id'] = sf_object.id #should be the same as <an_entity.parent_id.to_s>
          entity_row['type'] = otype
          #entity_row['feeds'] = chatter_feed_finder.get_all_chatter_feeds_with_attachments(entity_row['id'], entity_row['type'], @binding, session.session_id, limit, true)

          if current_user[:chatter_load_attachment] == true
            entity_row['feeds'] = chatter_feed_finder.get_all_chatter_feeds_with_attachments(entity_row['id'], entity_row['type'], @binding, session.session_id, limit, true)
          else
            entity_row['feeds'] = chatter_feed_finder.get_all_chatter_feeds_without_attachments(entity_row['id'], entity_row['type'], @binding, session.session_id, limit)
          end

          @entity_results << entity_row
        rescue ActiveRecord::RecordNotFound => exception
          logger.info("***Record not found: " + exception.class.name + exception.message + "<hr/>" + exception.backtrace.to_s)
          flash[:notice] = "#{otype} with ID: #{oid} cannot be found. <br/>"
          return
        end
      end

    rescue NoMethodError => nme
      #matching for -> undefined method `entity_subscriptions' for
      #User does not have chatter installed.
      if nme.message.match(/undefined\s+method\s+\Sentity_subscriptions\S/mi)
        flash[:notice] = "You do not have Salesforce Chatter application installed."
        redirect_to base_url
      else
        return nme
      end      
    rescue Exception => exception
      logger.info("***Other Exception: " + exception.class.name + exception.message.to_s + "<hr/>" + exception.backtrace.to_s)
      flash[:notice] = exception.class.name + exception.message.to_s + "<hr/>" + exception.backtrace
      return
    end
  end

end