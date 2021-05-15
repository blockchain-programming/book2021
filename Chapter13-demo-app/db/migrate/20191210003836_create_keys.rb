class CreateKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :keys do |t|
      t.references :wallet, foreign_key: true
      t.string :public_key, null: false
      t.string :private_key, null: false
      t.boolean :is_hot, null: false, default: true

      t.timestamps
    end
    add_index :keys, [:wallet_id, :created_at]
  end
end
