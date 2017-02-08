module Sessions
  class Retrieve
    attr_reader :token, :email, :password

    def initialize(token: nil, email: nil, password: nil)
      @token, @email, @password = token, email, password
    end

    def process
      if session.present?
        get_session
      else
        create_session
      end
    end

    private

    def user
      @user ||= User.find_by(email: email)
    end

    def session
      @session ||= Session.find_by_token(token)
    end

    def get_session
      return session if session.active?
      
      if user and session.user == user and user.authenticate(password)
        session.activate!
        session
      end
    end

    def create_session
      user = User.find_by_email(email)

      if user && user.authenticate(password)
        new_token = Sessions::GenerateToken.new(user.id, Time.now).process
        Session.create! token: new_token, user: user
      end
    end
  end
end
