require 'rails_helper'

describe Sessions::Retrieve do

  it 'respond to ProcessWraper' do
    user = FactoryGirl.create(:david)
    token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process
    session = Session.create! user: user, token: token

    generated_session = Sessions::Retrieve.for(token: token)

    expect(generated_session).to eq session
  end

  describe '#process' do

    context 'when the token is present' do
      it 'returns a session object' do
        user = FactoryGirl.create(:david)
        token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process
        session = Session.create! user: user, token: token

        service = Sessions::Retrieve.new(token: token)

        expect(service.process).to eq session
      end

      context 'and session is active' do
        it 'returns an active session object' do
          user = FactoryGirl.create(:david)
          token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process
          session = Session.create! user: user, token: token

          service = Sessions::Retrieve.new(token: token)

          expect(service.process).to eq session

          session.reload

          expect(session).to be_active
        end
      end

      context 'and session is inactive' do
        it 'returns nil' do
          user = FactoryGirl.create(:david)
          token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process
          session = Session.create! user: user, token: token, active: false

          service = Sessions::Retrieve.new(token: token)

          expect(service.process).to eq nil
        end

        it 'reactivates the session if the right credentials are given' do
          user = FactoryGirl.create(:david)
          token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process
          session = Session.create! user: user, token: token, active: false

          service = Sessions::Retrieve.new(email: user.email, password: user.password, token: token)

          expect(service.process).to eq session

          session.reload

          expect(session).to be_active
        end

        it 'does not reactivate the session if the user is not the owner' do
          user = FactoryGirl.create(:david)
          fake_user = FactoryGirl.create(:omar)
          token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process
          session = Session.create! user: user, token: token, active: false

          service = Sessions::Retrieve.new(email: fake_user.email, password: fake_user.password, token: token)

          expect(service.process).to eq nil

          session.reload

          expect(session).to_not be_active
        end
      end
    end

    context 'when the token is erratic' do
      it 'returns nil' do
        service = Sessions::Retrieve.new(token: 'erratic token')

        expect(service.process).to eq nil
      end

      context 'and the right credentials are given' do
        it 'returns nil' do
          user = FactoryGirl.create(:david)
          token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process

          service = Sessions::Retrieve.new(email: user.email, password: user.password, token: 'erratic token')

          expect(service.process).to eq nil
        end
      end

      context 'and the wrong credentials are given' do
        it 'returns nil' do
          service = Sessions::Retrieve.new(email: 'wrong_email', password: 'wrong_password', token: 'erratic token')

          expect(service.process).to eq nil
        end
      end
    end

    context 'when there is no token' do
      context 'and the right credentials are given' do
        it 'returns nil' do
          user = FactoryGirl.create(:david)
          token = Sessions::GenerateToken.new(id: user.id, created_at: Time.now).process

          service = Sessions::Retrieve.new(email: user.email, password: user.password)

          expect(service.process).to eq nil
        end
      end

      context 'and the wrong credentials are given' do
        it 'returns nil' do
          service = Sessions::Retrieve.new(email: 'wron_gemail', password: 'wrong_password')

          expect(service.process).to eq nil
        end
      end
    end
  end
end
