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
          get :show, params: { id: mask.to_param }
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

        # Configure masquerade_routes_back setting
        describe 'config#masquerade_routes_back' do
          before { Devise.setup { |c| c.masquerade_routes_back = true } }

          after { Devise.masquerade_routes_back = false }

          context 'show' do
            before { expect(SecureRandom).to receive(:urlsafe_base64) { "secure_key" } }

            context 'with http referrer' do
              before do
                @request.env['HTTP_REFERER'] = 'previous_location'
                get :show, params: { id: mask.to_param }
              end # before

              it { should redirect_to('previous_location') }
            end # context

            context 'no http referrer' do
              before do
                allow_any_instance_of(described_class).to(
                  receive(:after_masquerade_path_for).and_return("/dashboard?color=red"))
              end

              before { get :show, params: { id: mask.to_param } }

              it { should redirect_to("/dashboard?color=red&masquerade=secure_key") }
            end # context
          end # context

          context '< Rails 5, and back' do
            before { get :back }

            it { should redirect_to(masquerade_page) }
          end # context

          context '< Rails 5, and back fallback if http_referer not present' do
            before do
              @request.env['HTTP_REFERER'] = 'previous_location'
              get :back
            end

            it { should redirect_to('previous_location') }
          end # context
        end # describe
      end
    end

    context 'when not logged in' do
      before { get :show, params: { id: 'any_id' } }

      it { should redirect_to(new_user_session_path) }
    end
  end

  # it's a page with masquerade button ("Login As")
  def masquerade_page
    "/"
  end
end
