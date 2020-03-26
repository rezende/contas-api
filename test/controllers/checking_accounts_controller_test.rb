require 'test_helper'

class CheckingAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @checking_account = checking_accounts(:one)
  end

  test "should get index" do
    get checking_accounts_url, as: :json
    assert_response :success
  end

  test "should create checking_account" do
    assert_difference('CheckingAccount.count') do
      post checking_accounts_url, params: { checking_account: { user_id: @checking_account.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show checking_account" do
    get checking_account_url(@checking_account), as: :json
    assert_response :success
  end

  test "should update checking_account" do
    patch checking_account_url(@checking_account), params: { checking_account: { user_id: @checking_account.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy checking_account" do
    assert_difference('CheckingAccount.count', -1) do
      delete checking_account_url(@checking_account), as: :json
    end

    assert_response 204
  end
end
