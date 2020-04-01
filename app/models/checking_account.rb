class CheckingAccount < ApplicationRecord
  belongs_to :user

  has_many :transactions_as_source, class_name: 'Transaction',
                                    foreign_key: :source_account_id,
                                    inverse_of: :source_account
  has_many :transactions_as_destination, class_name: 'Transaction',
                                         foreign_key: :destination_account_id,
                                         inverse_of: :destination_account

  validates :name, presence: true

  def current_balance
    inbound_money - outbound_money
  end

  def self.find_by_id(id)
    CheckingAccount.find id
  rescue ActiveRecord::RecordNotFound
    nil
  end

  private

  def inbound_money
    transactions_as_destination.sum(:amount)
  end

  def outbound_money
    transactions_as_source.sum(:amount)
  end
end
