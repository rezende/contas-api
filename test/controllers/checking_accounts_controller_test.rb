require 'test_helper'

class CheckingAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @checking_account = checking_accounts(:one)
    email =  'example@mail.com'
    password = '123123123'
    @user = User.create!(email: email, password: password, password_confirmation: password)
    @token = AuthenticateUser.call(email, password).result
  end

  test "should create checking_account with required parameters" do
    assert_difference('CheckingAccount.count') do
      assert_difference('Transaction.count') do
        post(
          checking_accounts_url,
          params: { checking_account: { name: 'Citibank', amount: 299.98 } },
          headers: { Authorization: @token },
          as: :json
        )
      end
    end

    assert_response 201
  end

  test "test create when account already exists" do
    assert_no_difference('CheckingAccount.count') do
      assert_no_difference('Transaction.count') do
        post(
          checking_accounts_url,
          params: { checking_account: { id: @checking_account.id, name: 'Citibank', amount: 299.98 } },
          headers: { Authorization: @token },
          as: :json
        )
      end
    end

    response = JSON.parse(@response.body)
    assert_equal response['id'], @checking_account.id, response
    assert_response 400
  end

  test "should show checking_account" do
    get checking_account_url(@checking_account), as: :json, headers: { Authorization: @token }
    assert_response :success
    response = JSON.parse(@response.body)
    assert response.key?('id')
    assert response.key?('name')
    assert response.key?('user_id')
    assert response.key?('current_balance')
  end

end
