class Word < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name        :string
    description :text
    timestamps
  end

  belongs_to :filter
  belongs_to :owner, :class_name => "User", :creator => true

  never_show :filter, :owner

  # --- Permissions --- #

  def create_permitted?
    #acting_user.administrator?
    acting_user.signed_up?
  end

  def update_permitted?
    #acting_user.administrator?
    acting_user.administrator? || (owner_is?(acting_user) && !filter_changed?)
  end

  def destroy_permitted?
    #acting_user.administrator?
    acting_user.administrator? || owner_is?(acting_user)
  end

  def view_permitted?(field)
   true
   acting_user.administrator? || acting_user == owner
  end

end
