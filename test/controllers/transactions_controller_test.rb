require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    password = '123123123'
    @user = User.new(email: 'example@mail.com', password: password, password_confirmation: password)
    @user.save
    @user2 = User.new(email: 'example2@mail.com', password: password, password_confirmation: password)
    @user2.save
    @token = AuthenticateUser.call(@user.email, password).result

    @user_account = CheckingAccount.new(user: @user, name: 'Test Account')
    @user_account.save!
    @user_account_initial_balance = 200.15
    Transaction.create!(destination_account: @user_account, amount: @user_account_initial_balance, message: 'Deposit')

    @users_friend_account = CheckingAccount.new(user: @user2, name: 'Test Destination Account')
    @users_friend_account_initial_balance = 200.15
    @users_friend_account.save!
    Transaction.create!(destination_account: @users_friend_account, amount: @user_account_initial_balance, message: 'Deposit')
  end

  test "create transaction updates account balance" do
    transfer_amount = 50
    assert_difference('Transaction.count') do
      post(
        transactions_url,
        params: {
          transaction: {
            amount: transfer_amount,
            destination_account_id: @users_friend_account.id,
            source_account_id: @user_account.id
          }
        },
        as: :json,
        headers: { Authorization: @token }
      )
    end

    assert_equal @user_account.current_balance.to_f,
      @user_account_initial_balance - transfer_amount
    assert_equal @users_friend_account.current_balance.to_f,
      @users_friend_account_initial_balance + transfer_amount
    assert_response 201
  end


  test "create transaction with account that does not exist" do
    transfer_amount = 50
    assert_no_difference('Transaction.count') do
      post(
        transactions_url,
        params: {
          transaction: {
            amount: transfer_amount,
            destination_account_id: 42,
            source_account_id: @user_account.id
          }
        },
        as: :json,
        headers: { Authorization: @token }
      )
    end

    assert_equal JSON.parse(response.body)['error_message'], 'Account 42 does not exist'
    assert_response 422
  end

  test "create transaction with account without enough balance" do
    transfer_amount = 50
    assert_no_difference('Transaction.count') do
      post(
        transactions_url,
        params: {
          transaction: {
            amount: @user_account_initial_balance + 30,
            destination_account_id: @users_friend_account.id,
            source_account_id: @user_account.id
          }
        },
        as: :json,
        headers: { Authorization: @token }
      )
    end

    assert_response 422
  end

end
