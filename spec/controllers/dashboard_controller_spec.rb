require 'spec_helper'

describe DashboardController, type: :controller do
  context 'when logged in' do
    before { logged_in }

    context 'and admin masquerade by user' do
      let!(:user) { create(:user) }

      before do
        user.masquerade!

        get :index, :masquerade => user.masquerade_key
      end

      it { expect(current_user.reload).to eq(user) }
    end
  end
end
