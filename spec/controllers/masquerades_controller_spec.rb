require 'spec_helper'

describe MasqueradesController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  context 'no access for masquerade' do
    before do
      session.clear
      allow_any_instance_of(MasqueradesController).to receive(:masquerade_authorized?) { false }
    end

    before { logged_in }

    let(:mask) { create(:user) }

    before { get :show, params: { :id => mask.to_param } }

    it { expect(response.status).to eq(403) }
    it { expect(session.keys).not_to include('devise_masquerade_user') }
    it { expect(session["warden.user.user.key"].first.first).not_to eq(mask.id) }
  end

  context 'access for masquerade' do
    before do
      session.clear
      allow_any_instance_of(MasqueradesController).to receive(:masquerade_authorized?) { true }
    end

    before { logged_in }

    let(:mask) { create(:user) }

    before do
      expect(SecureRandom).to receive(:urlsafe_base64) { "secure_key" }
      get :show, params: { id: mask.to_param }
    end

    it { expect(response.status).to eq(302) }
    it { expect(session.keys).to include('devise_masquerade_user') }
    it { expect(session["warden.user.user.key"].first.first).to eq(mask.id) }
  end
end
