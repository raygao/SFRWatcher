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

# Rforce returns hash with subnodes as methods via 'method_missing(method, *args)'
# Sometimes, such a webservices response node does not exist. This causes error.
# To avoid getting 'NoMethodError', this either returns the 'value' or 'nil'.
=begin
def hash_value_extractor (hash_with_key)
  begin
    if !hash_with_key.nil?
      return hash_with_key
    else 
      return nil
    end
  rescue NoMethodError => nme
    logger.info "No such method error: " + nme.message
    return nil
  end
end
=end