# checking_accounts
class CheckingAccountsController < ApplicationController
  before_action :set_checking_account, only: %i[show]

  # GET /checking_accounts/1
  def show
    render json: @checking_account
  end

  # POST /checking_accounts
  def create
    id = checking_account_params[:id]
    @checking_account = CheckingAccount.find_by_id id
    if @checking_account
      error_message = 'Checking Account already exists'
      render json: { id: id, error_message: error_message }, status: 400
      return
    end
    ActiveRecord::Base.transaction do
      @checking_account = CheckingAccount.new(
        user: current_user, name: checking_account_params[:name]
      )
      @checking_account.id = id if id
      @checking_account.save
      Transaction.create!(
        destination_account: @checking_account,
        amount: checking_account_params[:amount],
        message: 'Open Account'
      )
    end
    render json: @checking_account,
           status: :created,
           location: @checking_account
  rescue StandardError
    render json: { message: 'There was an error processing your request' },
           status: :unprocessable_entity
  end

  private

  def set_checking_account
    @checking_account = CheckingAccount.find(params[:id])
  end

  def checking_account_params
    params.require(:checking_account).permit(:id, :name, :amount)
  end
end
