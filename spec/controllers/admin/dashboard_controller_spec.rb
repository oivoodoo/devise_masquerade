require 'spec_helper'

describe Admin::DashboardController do
  context 'when logged in' do
    before { admin_logged_in }

    context 'and admin masquerade by user' do
      let!(:user) { create(:admin_user) }

      before do
        user.masquerade!
        get :index, :masquerade => user.masquerade_key
      end

      it { current_admin_user.reload.should == user }
    end
  end
end

