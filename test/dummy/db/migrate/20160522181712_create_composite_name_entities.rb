class CreateCompositeNameEntities < ActiveRecord::Migration[4.2]
  def change
    create_table :composite_name_entities do |t|
      t.string :email
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
