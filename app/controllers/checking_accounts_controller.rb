class CheckingAccountsController < ApplicationController
  before_action :set_checking_account, only: [:show, :update, :destroy]

  # GET /checking_accounts
  def index
    @checking_accounts = CheckingAccount.all

    render json: @checking_accounts
  end

  # GET /checking_accounts/1
  def show
    render json: @checking_account
  end

  # POST /checking_accounts
  def create
    @checking_account = CheckingAccount.new(checking_account_params)

    if @checking_account.save
      render json: @checking_account, status: :created, location: @checking_account
    else
      render json: @checking_account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /checking_accounts/1
  def update
    if @checking_account.update(checking_account_params)
      render json: @checking_account
    else
      render json: @checking_account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /checking_accounts/1
  def destroy
    @checking_account.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checking_account
      @checking_account = CheckingAccount.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def checking_account_params
      params.require(:checking_account).permit(:user_id)
    end
end
