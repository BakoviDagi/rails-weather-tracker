class AddUserToLocation < ActiveRecord::Migration[7.0]
  def change
    add_reference :locations, :user, null: true, foreign_key: true, index: true


    reversible do |change|
      change.up do
          first_user = User.first
          Location.find_each do |item|
              item.user_id = first_user.id
              item.save
            end
        end
    end
    
    change_column_null :locations, :user_id, false
  end
end
