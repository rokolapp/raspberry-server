class CreateSuperusers < ActiveRecord::Migration
  def change
    create_table :superusers do |t|
    	t.string :name
    	t.string :email
    	t.string :password

      t.timestamps null: false
    end
    add_index :superusers, :email, unique: true
  end
end
