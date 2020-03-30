class CheckingAccountsController < ApplicationController
  before_action :set_checking_account, only: %i[show]

  # GET /checking_accounts
  # def index
  #   @checking_accounts = CheckingAccount.all
  #
  #   render json: @checking_accounts
  # end

  # GET /checking_accounts/1
  def show
    render json: @checking_account
  end

  # POST /checking_accounts
  def create
    if CheckingAccount.get(checking_account_params[:id])
      render json: @checking_account, status: 200, location: @checking_account
      return
    end
    @checking_account = CheckingAccount.new(user: current_user, name: checking_account_params[:name])
    if @checking_account.save
      transaction = Transaction.new(destination_account: @checking_account, amount: checking_account_params[:amount], message: 'Initial transfer')
      if transaction.save
        render json: @checking_account, status: :created, location: @checking_account
      else
        render json: transaction.errors, status: :unprocessable_entity
      end
    else
      render json: @checking_account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /checking_accounts/1
  # def update
  #   if @checking_account.update(checking_account_params)
  #     render json: @checking_account
  #   else
  #     render json: @checking_account.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /checking_accounts/1
  # def destroy
  #   @checking_account.destroy
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_checking_account
    @checking_account = CheckingAccount.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def checking_account_params
    params.require(:checking_account).permit(:id, :name, :amount)
  end
end
