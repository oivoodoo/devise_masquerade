require 'spec_helper'

describe Admin::DashboardController, type: :controller do
  context 'when logged in' do
    before { admin_logged_in }

    context 'and admin masquerade by user' do
      let!(:mask) { create(:admin_user) }

      before do
        get :index, params: { masquerade: mask.masquerade_key, masqueraded_resource_class: 'Admin::User' }
      end

      it { expect(current_admin_user.reload).to eq(mask) }
    end
  end
end
