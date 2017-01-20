class SessionsController < ApplicationController

  def login
    session = retrieve_session email: params[:email], password: params[:password], token: request.headers[:HTTP_CSRF_TOKEN]

    if session && session.errors.empty?
      render json: { user: session.user, token: session.token }
    else
      render json: { error: "Can't login"}, status: :bad_request
    end
  end

  def register
    user = User.new user_params

    if user.save
      session = retrieve_session email: user.email, password: user.password, token: nil

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
      params.require(:user).permit(:email, :password)
    end

    def retrieve_session(token:, email:, password:)
      # Maybe the session already exists
      if token
        session = Session.find_by_token(token)

        # The session exists, if it isn't active, it has to be owned by the user with the same email
        # as the suplied to be reactivated
        if session && (session.active || session.user.email == email)
          authorized = session.active || session.user.authenticate(password)

          if authorized && !session.active
            session.active = true
            session.save
            return session
          end

          return authorized ? session : nil
        end
      end

      # No valid token was suplied, lets try to authentificate a new session
      user = User.find_by_email(email)

      # The credentials are not valid
      if !(user && user.authenticate(password))
        return nil
      end

      new_token = generate_token user

      session = Session.new token: new_token, user: user
      session.save
      return session
    end

    def generate_token(user)
      payload = { user_id: user.id, created_at: Time.now.to_i }

      return JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
    end
end
