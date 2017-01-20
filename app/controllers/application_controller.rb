class ApplicationController < ActionController::API
  attr_reader :current_user

  def authenticate_request
    token = request.headers[:HTTP_CSRF_TOKEN]

    if token
      session = Session.where(token: token, active: true).first
      @current_user = session.user if session
    end

    render json: { error: 'Not authorized' }, status: :bad_request unless @current_user
  end
end
