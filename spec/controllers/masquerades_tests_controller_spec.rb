require 'spec_helper'

describe MasqueradesTestsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  context 'no access for masquerade' do
    before do
      session.clear
      allow_any_instance_of(MasqueradesTestsController).to receive(:masquerade_authorized?) { false }
    end

    before { logged_in }

    let(:mask) { create(:user) }

    before { get :show, params: { id: mask.to_param, masquerade: mask.masquerade_key } }

    it { expect(response.status).to eq(403) }
    it { expect(Rails.cache.read("devise_masquerade_user_#{mask.to_param}")).not_to be }
    it { expect(session['warden.user.user.key'].first.first).not_to eq(mask.id) }
  end

  context 'access for masquerade' do
    before do
      session.clear
      allow_any_instance_of(MasqueradesTestsController).to receive(:masquerade_authorized?) { true }
    end

    before { logged_in }

    let(:mask) { create(:user) }

    before do
      get :show, params: { id: mask.to_param, masquerade: mask.masquerade_key }
    end

    it { expect(response.status).to eq(302) }
    it { expect(Rails.cache.read("devise_masquerade_user_#{mask.to_param}")).to be }
    it { expect(session['warden.user.user.key'].first.first).to eq(mask.id) }
  end
end
