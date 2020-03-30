class AddMessageToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :message, :string
  end
end
