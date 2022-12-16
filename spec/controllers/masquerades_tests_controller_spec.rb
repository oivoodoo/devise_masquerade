require 'spec_helper'

describe MasqueradesTestsController, type: :controller do
  before { Devise.masquerade_storage_method = :cache }
  after { Devise.masquerade_storage_method = :session }

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  context 'no access for masquerade' do
    before do
      session.clear
      allow_any_instance_of(MasqueradesTestsController).to receive(:masquerade_authorized?) { false }
    end

    before { logged_in }

    let(:mask) { create(:user) }

    before { get :show, params: { id: mask.id, masquerade: mask.masquerade_key } }

    it { expect(response.status).to eq(403) }
    it { expect(cache_read(mask)).not_to be }
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
      get :show, params: { id: mask.id, masquerade: mask.masquerade_key }
    end

    it { expect(response.status).to eq(302) }
    it { expect(cache_read(mask)).to be }
    it { expect(session['warden.user.user.key'].first.first).to eq(mask.id) }
  end


  def guid
    session[:devise_masquerade_masquerading_resource_guid]
  end

  def cache_read(user)
    Rails.cache.read(cache_key(user))
  end

  def cache_key(user)
    "devise_masquerade_#{mask.class.name.downcase}_#{mask.id}_#{guid}"
  end
end
