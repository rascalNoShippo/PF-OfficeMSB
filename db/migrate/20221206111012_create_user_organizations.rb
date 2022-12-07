class CreateUserOrganizations < ActiveRecord::Migration[6.1]
  def change
    create_table :user_organizations do |t|
      t.integer :user_id, null: false
      t.integer :organization_id, null: false
      t.integer :position_id
      t.timestamps
    end
  end
end
