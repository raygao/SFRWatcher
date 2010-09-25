class Filter < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name        :string
    description :text
    timestamps
  end

  never_show :owner

  has_many :words, :dependent => :destroy

  belongs_to :rule
  belongs_to :owner, :class_name => "User", :creator => true

  # --- Permissions --- #

  def create_permitted?
    #acting_user.administrator?
    owner_is?(acting_user) && acting_user.signed_up?
    #acting_user.signed_up?
  end

  def update_permitted?
    #acting_user.administrator?
    acting_user.administrator? || (owner_is?(acting_user) && !rule_changed?)
  end

  def destroy_permitted?
    #acting_user.administrator?
    acting_user.administrator? || owner_is?(acting_user)
  end

  def view_permitted?(field)
   #true
   acting_user.administrator? || acting_user == owner
  end

end
