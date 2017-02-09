require 'rails_helper'

describe Sessions::GenerateToken do

  it 'respond to ProcessWraper' do
    id = 1
    created_at = Time.now
    generated_token = Sessions::GenerateToken.for(id: id, created_at: created_at)
    
    token = JWT.encode(
      { user_id: id, created_at: created_at.to_i }, 
      Rails.application.secrets.secret_key_base, 
      'HS256'
    )

    expect(generated_token).to eq token
  end

  describe '#process' do
    it 'returns a token' do
      id = 1
      created_at = Time.now
      service = Sessions::GenerateToken.new(id: id, created_at: created_at)
      
      token = JWT.encode(
        { user_id: id, created_at: created_at.to_i }, 
        Rails.application.secrets.secret_key_base, 
        'HS256'
      )

      expect(service.process).to eq token
    end
  end
end
