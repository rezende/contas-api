require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  test 'create with no account throws error' do
    t = Transaction.new(amount: 900)
    t.save
    assert t.errors.present?
    assert_equal t.errors.messages[:base][0], 'Source and destination can\'t be the same account'
  end

  test 'create with only source account is ok' do
    t = Transaction.new(amount: 900.11, source_account_id: 98_989)
    t.save
    assert t.errors.blank?
  end

  test 'create with only destination account is ok' do
    t = Transaction.new(amount: 900.15, destination_account_id: 98_989)
    t.save
    assert t.errors.blank?
  end

  test 'create with negative amount throws error' do
    t = Transaction.new(amount: -900, destination_account_id: 98_989)
    t.save
    assert_equal t.errors.messages[:amount][0], 'must be greater than or equal to 0'
  end

  test 'create with 0 amount is ok' do
    t = Transaction.new(amount: 0, destination_account_id: 98_989)
    t.save
    assert t.errors.blank?
  end
end
