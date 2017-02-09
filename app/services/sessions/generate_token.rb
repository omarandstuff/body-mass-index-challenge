module Sessions
  class GenerateToken
    extend ProcessWraper

    attr_reader :id, :created_at

    def initialize(id:, created_at:)
      @id, @created_at = id, created_at
    end

    def process
       JWT.encode(payload, secret, 'HS256')
    end

    private

    def payload
      { user_id: id, created_at: created_at.to_i }
    end

    def secret
      Rails.application.secrets.secret_key_base
    end
  end
end
