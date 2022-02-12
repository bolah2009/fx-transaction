class TransactionsController < ApplicationController
  before_action :transaction_params, only: :create

  # GET /transactions
  def index
    @transactions = Transaction.all

    render json: @transactions, status: :ok
  end

  # GET /transactions/1
  def show
    @transaction = Transaction.find(params[:id])
    render json: @transaction, status: :ok
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      render json: @transaction, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:customer, :input_amount, :input_currency, :output_amount,
                                        :output_currency)
  end
end
