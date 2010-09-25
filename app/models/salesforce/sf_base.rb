################################################################################
# Project SFRWatcher: A Salesforce Chatter Externalization Tool                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
# Demo app running on http://parl8-vo.us:3000/                                 #
################################################################################
class Salesforce::SfBase < ActiveRecord::Base
  self.abstract_class = true

  # if not using <connection> from database.yml
  def self.login(user, pass, token)
    params = {:adapter => "activesalesforce",
              :url => "https://login.salesforce.com/services/Soap/u/19.0",
              :username => user,
              :password => pass + token
    }
    self.establish_connection(params)
  end

  def logout(session_ids=Hash.new)
    result = Salesforce::SfBase.connection.binding.invalidateSessions(session_ids)
    if"invalidateSessionsResponse" == result.to_s
      return true
    else
      return false
    end
    #result this.connection.binding.logout(Hash.new)
  end

  # Once using establish_connection '<connection>' from database.yml
  # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN) is no longer needed.
  # The connection is shared across all child objects.
  # TODO, this needs to be modified. Right now, everyone is sharing the default
  # connection. This needs to be changed to use individual connection.
  establish_connection "salesforce-default-realm"
  set_table_name 'salesforce_sf_bases'

  def self.swap_connection (connection)
    @@connection = connection
  end
  
end