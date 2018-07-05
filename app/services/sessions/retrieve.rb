module Sessions
  class Retrieve
    extend ProcessWraper

    attr_reader :token, :email, :password

    def initialize(token: nil, email: nil, password: nil)
      @token, @email, @password = token, email, password
    end

    def process
      return session if session and session.active?

      if user and session and session.user == user and user.authenticate(password)
        session.activate!
        session
      end
    end

    private

    def user
      @user ||= User.find_by(email: email)
    end

    def session
      @session ||= Session.find_by_token(token)
    end

  end
end
