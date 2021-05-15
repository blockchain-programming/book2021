class CreateExchanges < ActiveRecord::Migration[5.2]
  def change
    create_table :exchanges do |t|
      t.integer :blocktime, null: false
      t.string :tx_id, null: false
      t.integer :bitcoin_trading_volume, null: false
      t.integer :fiat_trading_volume, null: false
      t.integer :fiat_balance, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :exchanges, [:user_id, :created_at]
  end
end
