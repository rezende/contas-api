class CheckingAccount < ApplicationRecord
  belongs_to :user

  has_many :transactions_as_source, class_name: 'Transaction',
                                    foreign_key: :source_account_id,
                                    inverse_of: :source_account
  has_many :transactions_as_destination, class_name: 'Transaction',
                                         foreign_key: :destination_account_id,
                                         inverse_of: :destination_account
end
