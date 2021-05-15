class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_index :wallets, [:user_id, :created_at]
  end
end
