################################################################################
# Project SFRWatcher: A Salesforce Chatter Externalization Tool                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
# Demo app running on http://parl8-vo.us:3000/                                 #
################################################################################

class TasksController < ApplicationController

  hobo_model_controller

  auto_actions :all
  ## With explicit (:destroy or :write_only), it generates the delete box on the 'rule' page.

  autocomplete

end
