require 'spec_helper'

describe Devise::MasqueradesController do
  context 'with configured devise app' do
    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'when logged in' do
      before { logged_in }

      describe '#masquerade user' do
        let(:mask) { create(:user) }

        before do
          SecureRandom.should_receive(:base64).and_return("secure_key")

          get :show, :id => mask.to_param
        end

        it { should redirect_to("/?masquerade=secure_key") }
      end
    end

    context 'when not logged in' do
      before { get :show, :id => 'any_id' }

      it { should redirect_to(new_user_session_path) }
    end

    describe 'back to the owner of the request' do
      before { logged_in }

      context 'and masquerade user' do
        let(:mask) { create(:user) }

        before { get :show, :id => mask.to_param }

        context 'and back' do
          before { get :back }

          it { should redirect_to(masquerade_page) }
          it { current_user.reload.should == @user }
        end
      end
    end
  end

  # it's a page with masquerade button ("Login As")
  def masquerade_page
    "/"
  end
end

