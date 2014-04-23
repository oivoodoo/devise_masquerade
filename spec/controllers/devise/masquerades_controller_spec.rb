require 'spec_helper'

describe Devise::MasqueradesController do
  context 'with configured devise app' do
    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'when logged in' do
      before { logged_in }

      describe '#masquerade user' do
        let(:mask) { create(:user) }

        before do
          SecureRandom.should_receive(:urlsafe_base64).and_return("secure_key")
          get :show, :id => mask.to_param
        end

        it { session.keys.should include('devise_masquerade_user') }
        it { session["warden.user.user.key"].first.first.should == mask.id }
        it { should redirect_to("/?masquerade=secure_key") }

        context 'and back' do
          before { get :back }

          it { should redirect_to(masquerade_page) }
          it { current_user.reload.should == @user }
          it { session.keys.should_not include('devise_masquerade_user') }
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

