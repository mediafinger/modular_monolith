class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_enum :admin_engine_admin_status_enum, AdminEngine::Admin::STATUS

    create_table :admin_engine_admins, id: :uuid do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.text :roles, array: true, default: []
      t.enum :status, enum_type: :admin_engine_admin_status_enum, null: false, default: :pending, index: true
      t.uuid :creator_id
      t.timestamps
    end
  end
end
