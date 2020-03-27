class Transaction < ApplicationRecord
  belongs_to :source_account, class_name: 'CheckingAccount',
                              inverse_of: :transactions_as_source

  belongs_to :destination_account, class_name: 'CheckingAccount',
                                   inverse_of: :transactions_as_destination
end
