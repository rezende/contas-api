class Transaction < ApplicationRecord
  class AtLeastOneAccountValidator < ActiveModel::Validator
    def validate(record)
      return if options[:fields].any? { |attr| record[attr].present? }

      record.errors.add(:base, 'Source account or destination account must be filled')
    end
  end

  belongs_to :source_account, class_name: 'CheckingAccount',
                              inverse_of: :transactions_as_source,
                              optional:true

  belongs_to :destination_account, class_name: 'CheckingAccount',
                                   inverse_of: :transactions_as_destination,
                                   optional: true

  validates_with AtLeastOneAccountValidator,
                 fields: %w[source_account_id destination_account_id]

end
