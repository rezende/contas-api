class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.bigint :source_account_id

      t.bigint :destination_account_id

      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
