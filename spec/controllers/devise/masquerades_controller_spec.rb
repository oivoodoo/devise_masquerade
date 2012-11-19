require 'spec_helper'

describe Devise::MasqueradesController do
  context 'with configured devise app' do
    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'when logged in' do
      before { logged_in }

      describe '#masquerade user' do
        let!(:user) { create(:user) }

        before do
          SecureRandom.should_receive(:base64).and_return("secure_key")

          get :show, :id => user.to_param
        end

        it { should redirect_to("/?masquerade=secure_key") }
      end
    end

    context 'when not logged in' do
      before { get :show, :id => 'any_id' }

      it { should redirect_to(new_user_session_path) }
    end
  end
end

