class TransactionsController < ApplicationController
  prepend_before_action :ensure_json, only: :create
  before_action :transaction_params, only: :create
  before_action :find_transaction, only: %i[show update]

  # GET /transactions
  def index
    @transactions = Transaction.all

    render json: @transactions, status: :ok
  end

  # GET /transactions/1
  def show
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

  # PATCH /transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction, status: :ok
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

  def ensure_json
    return if request.content_type == 'application/json'

    render json: { error: { message: 'Request data not supported, check your header content type' } },
           status: :unsupported_media_type
  end

  def find_transaction
    @transaction = Transaction.find(params[:id])
  end
end
