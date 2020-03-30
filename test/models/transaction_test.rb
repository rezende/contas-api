require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  test 'create with no account throws an error' do
    t = Transaction.new(amount: 900)
    t.save
    assert t.errors.present?
    assert_equal t.errors.messages[:base][0], 'Source account or destination account must be filled'
  end

  test 'create with source account is fine' do
    t = Transaction.new(amount: 900, source_account_id: 98_989)
    t.save
    assert t.errors.blank?
  end

  test 'create with destination account is fine' do
    t = Transaction.new(amount: 900, destination_account_id: 98_989)
    t.save
    assert t.errors.blank?
  end

end
