module Sessions
  class Create
    attr_reader :email, :password

    def initialize(email:, password:)
      @email, @password = email, password
    end

    def process
      user = User.find_by_email(email)

      if user && user.authenticate(password)
        new_token = Sessions::GenerateToken.new(user.id, Time.now).process
        Session.create! token: new_token, user: user
      end
    end
  end
end
