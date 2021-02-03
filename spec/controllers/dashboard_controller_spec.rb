require 'spec_helper'

describe DashboardController, type: :controller do
  context 'when logged in' do
    before { logged_in }

    context 'and admin masquerade by user' do
      let!(:mask) { create(:user) }

      before do
        get :index, params: { masquerade: mask.masquerade_key }
      end

      it { expect(current_user.reload).to eq(mask) }
    end
  end
end
