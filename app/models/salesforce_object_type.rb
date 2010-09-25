class SalesforceObjectType < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    object_type     :string
    timestamps
  end

  has_many :salesforce_objects

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
