require 'rails_helper'

describe Sessions::Create do
  describe 'process' do

    context 'When the right credentials are given' do
      it 'returns a new active session object' do
        user = FactoryGirl.create(:david)
        token = Sessions::GenerateToken.new(user.id, Time.now).process

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
