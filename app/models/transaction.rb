class Transaction < ApplicationRecord
  belongs_to :source_account, class_name: 'CheckingAccount',
                              inverse_of: :transactions_as_source,
                              optional: true

  belongs_to :destination_account, class_name: 'CheckingAccount',
                                   inverse_of: :transactions_as_destination,
                                   optional: true

  class DifferentAccountsValidator < ActiveModel::Validator
    def validate(record)
      if record[:source_account_id] == record[:destination_account_id]
        record.errors.add(:base,
                          'Source and destination can\'t be the same account')
      end
    end
  end

  validates :amount, presence: true,
                     numericality: { greater_than_or_equal_to: 0 }
  validates_with DifferentAccountsValidator
end
