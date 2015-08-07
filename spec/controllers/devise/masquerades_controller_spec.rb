require 'spec_helper'

describe Devise::MasqueradesController, type: :controller do
  context 'with configured devise app' do
    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'when logged in' do
      before { logged_in }

      describe '#masquerade user' do
        let(:mask) { create(:user) }

        before do
          expect(SecureRandom).to receive(:urlsafe_base64) { "secure_key" }
          get :show, :id => mask.to_param
        end

        it { expect(session.keys).to include('devise_masquerade_user') }
        it { expect(session["warden.user.user.key"].first.first).to eq(mask.id) }
        it { should redirect_to("/?masquerade=secure_key") }

        context 'and back' do
          before { get :back }

          it { should redirect_to(masquerade_page) }
          it { expect(current_user.reload).to eq(@user) }
          it { expect(session.keys).not_to include('devise_masquerade_user') }
        end
      end
    end

    context 'when not logged in' do
      before { get :show, :id => 'any_id' }

      it { should redirect_to(new_user_session_path) }
    end
  end

  # it's a page with masquerade button ("Login As")
  def masquerade_page
    "/"
  end
end
