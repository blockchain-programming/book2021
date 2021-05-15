class CreateFinances < ActiveRecord::Migration[5.2]
  def change
    create_table :finances do |t|
      t.integer :branch_number, null: false, default: 123
      t.integer :account_number, null: false, default: 1234567
      t.string :name, null: false, default: ''
      t.integer :fiat_jpy, null: false, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :finances, [:user_id, :created_at]
  end
end
