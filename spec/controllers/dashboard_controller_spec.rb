require 'spec_helper'

describe DashboardController do
  context 'when logged in' do
    before { logged_in }

    context 'and admin masquerade by user' do
      let!(:user) { create(:user) }

      before do
        user.masquerade!

        get :index, :masquerade => user.masquerade_key
      end

      it { current_user.reload.should == user }
    end
  end
end

