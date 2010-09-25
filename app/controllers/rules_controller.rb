################################################################################
# Project SFRWatcher: A Salesforce Chatter Externalization Tool                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
# Demo app running on http://parl8-vo.us:3000/                                 #
################################################################################
class RulesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  autocomplete

  def show
    @rule = find_instance
    @filters = @rule.filters.apply_scopes(:search => [params[:search], :name],
      :order_by  => parse_sort_param(:name, :description))
  end

end
