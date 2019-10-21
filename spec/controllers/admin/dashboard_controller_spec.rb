require 'spec_helper'

describe Admin::DashboardController, type: :controller do
  context 'when logged in' do
    before { admin_logged_in }

    context 'and admin masquerade by user' do
      let!(:user) { create(:admin_user) }

      before do
        user.masquerade!
        get :index, params: { masquerade: user.masquerade_key }
      end

      it { expect(current_admin_user.reload).to eq(user) }
    end
  end
end
