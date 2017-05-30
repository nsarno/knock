class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :email, unique: true, null: false
      t.string :password_digest, null: false

      t.timestamps null: false
    end
  end
end
