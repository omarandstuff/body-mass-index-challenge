class SessionsController < ApplicationController

  def login
    session = retrieve_session || create_session

    if session && session.errors.empty?
      render json: { user: session.user, token: session.token }
    else
      head :bad_request
    end
  end

  def register
    user = User.new user_params

    if user.save
      session = Sessions::Create.for(email: user.email, password: user.password)

      if session && session.errors.empty?
        render json: { user: user, token: user.sessions.first.token }
      else
        head :internal_server_error
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
        head :ok
      else
        head :internal_server_error
      end
    else
      head :bad_request
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :firstname, :lastname, :password)
    end

    def retrieve_session
      Sessions::Retrieve.for(
        email: params[:email], 
        password: params[:password], 
        token: request.headers[:HTTP_CSRF_TOKEN]
      )
    end

    def create_session
      Sessions::Create.for(
        email: params[:email],
        password: params[:password]
      )
    end
end
