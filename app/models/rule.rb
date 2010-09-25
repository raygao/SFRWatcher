class Rule < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name        :string
    description :html
    timestamps
  end


  has_many :tasks, :accessible => true, :dependent => :destroy
  has_many :filters, :accessible => true, :dependent => :destroy
  belongs_to :owner, :class_name => "User", :creator => true

  never_show :owner

  # --- Permissions --- #

  def create_permitted?
    #acting_user.administrator?
    acting_user.signed_up?
  end

  def update_permitted?
    #acting_user.administrator?
    acting_user.administrator? || (owner_is?(acting_user) && !owner_changed?)
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
