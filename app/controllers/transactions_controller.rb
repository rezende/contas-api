# /transactions
class TransactionsController < ApplicationController
  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)
    account_validation = validate_account_ids
    unless account_validation[:result]
      render_error_message "Account #{account_validation[:invalid_id]} does not exist"
      return
    end

    unless check_user_ownership_and_set_message
      render_error_message 'You can only transfer money from your account or make deposits to your account'
      return
    end

    unless source_account_has_enough_balance?
      render_error_message 'The account does not have enough balance'
      return
    end

    if @transaction.save
      render json: @transaction, status: :created
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def transaction_params
    params.require(:transaction).permit(:source_account_id, :destination_account_id, :amount)
  end

  # Return false if an account id is not valid
  # At least one of the accounts must exist
  def validate_account_ids
    source_account_id = transaction_params[:source_account_id]
    @source_account = CheckingAccount.find_by_id(source_account_id)
    if source_account_id.present? && !@source_account
      byebug
      return { result: false, invalid_id: source_account_id }
    end

    destination_account_id = transaction_params[:destination_account_id]
    @destination_account = CheckingAccount.find_by_id(destination_account_id)
    if destination_account_id.present? && !@destination_account
      return { result: false, invalid_id: destination_account_id }
    end

    { result: true }
  end

  # Acceptable cases for a transfer
  # FROM user account to nil account: WITHDRAWAL
  # FROM user account to other account: TRANSFER
  # FROM nil account to user account: DEPOSIT
  def check_user_ownership_and_set_message
    if @source_account && @source_account.user == current_user
      if @destination_account.present?
        @transaction.message = 'Transfer'
        return true
      end
      @transaction.message = 'Withdrawal'
      return true
    end

    if @destination_account.user == current_user
      @transaction.message = 'Deposit'
      return true
    end

    false
  rescue StandardError
    false
  end

  # If TRANSFER or WITHDRAWAL, source account must
  # have enough balance
  def source_account_has_enough_balance?
    return true if @source_account.blank?

    transfer_amount = transaction_params[:amount]
    final_balance = @source_account.current_balance - transfer_amount
    final_balance >= 0
  end

  # Helper method to render error messages
  def render_error_message(error_message)
    error_response = { error_message: error_message }
    render json: error_response, status: :unprocessable_entity
  end
end
