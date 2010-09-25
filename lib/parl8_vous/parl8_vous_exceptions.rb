=begin
parl8_vous
Copyright 2010 Raymond Gao

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end

module Parl8_vous

# ==This is the base Error for Parl8_Vous package.
  class Parl8_vous_Base_Error < RuntimeError
    attr :fault

    def initialize(logger, message, fault = nil)
      super message

      @fault = fault

      logger.debug("\nParl8_Vous Exception:\n   message='#{message}'\n   fault='#{fault}'\n\n")
    end
  end

# ==This is raised, when the user fails to log into Salesforce
  class Login_Failed_Error < Parl8_vous_Base_Error
    def initialize(logger, message)
      super(logger, message)
    end
  end


# ==This is raised, when the user has not entered:
#    salesforce_username          :string
#    salesforce_password          :password
#    salesforce_secret_token      :string
  class Missing_Credential_Error < Parl8_vous_Base_Error
    def initialize(logger, message)
      super(logger, message)
    end

  end


end