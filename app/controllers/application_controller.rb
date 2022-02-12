class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found(err)
    render json: { error: { message: err.message } }, status: :not_found
  end
end
