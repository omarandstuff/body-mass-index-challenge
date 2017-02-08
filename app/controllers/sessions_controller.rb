class SessionsController < ApplicationController

  def login
    session = Sessions::Retrieve.new(email: params[:email], password: params[:password], token: request.headers[:HTTP_CSRF_TOKEN]).process

    if session && session.errors.empty?
      render json: { user: session.user, token: session.token }
    else
      render json: { error: "Can't login"}, status: :bad_request
    end
  end

  def register
    user = User.new user_params

    if user.save
      session = Sessions::Retrieve.new(email: user.email, password: user.password, token: nil).process

      if session && session.errors.empty?
        render json: { user: user, token: user.sessions.first.token }
      else
        render json: '', status: :internal_server_error
      end
    else
      render json: { error: user.errors }, status: :bad_request
    end
  end

  def logout
    session = Session.where(token: request.headers[:HTTP_CSRF_TOKEN]).first

    if session
      session.active = false

      if session.save
        render json: ''
      else
        render json: '', status: :internal_server_error
      end
    else
      render json: '', status: :bad_request
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :firstname, :lastname, :password)
    end
end
