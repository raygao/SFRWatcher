################################################################################
# Project SFRWatcher: A Salesforce Chatter Externalization Tool                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
# Demo app running on http://parl8-vo.us:3000/                                 #
################################################################################
class WordsController < ApplicationController

  hobo_model_controller

  auto_actions :write_only, :edit

  auto_actions_for :filter, :create

end
