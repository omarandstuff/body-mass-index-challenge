require 'rails_helper'

describe Sessions::Create do
  it 'respond to ProcessWraper' do
    user = FactoryGirl.create(:david)
    token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process

    generated_session = Sessions::Create.for(email: user.email, password: user.password)

    expect(generated_session).to_not eq nil
    expect(Session.last).to be_active
  end

  describe '#process' do

    context 'When the right credentials are given' do
      it 'returns a new active session object' do
        user = FactoryGirl.create(:david)
        token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process

        service = Sessions::Create.new(email: user.email, password: user.password)

        expect{ service.process }.to change(Session, :count).by(1)
        expect(Session.last).to be_active
      end
    end

    context 'when the wrong credentials are given' do
      it 'returns nil' do
        service = Sessions::Retrieve.new(email: 'wron_gemail', password: 'wrong_password')

        expect(service.process).to eq nil
      end
    end
  end
end
