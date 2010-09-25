class SalesforceObject < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    object_id             :string
    name                  :string
    timestamps
  end

  belongs_to :salesforce_object_type

  # --- Permissions --- #

  def create_permitted?
    true
    #acting_user.administrator?
  end

  def update_permitted?
    true
    #acting_user.administrator?
  end

  def destroy_permitted?
    true
    #acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end