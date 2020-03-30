class AddNameToCheckingAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :checking_accounts, :name, :string
  end
end
