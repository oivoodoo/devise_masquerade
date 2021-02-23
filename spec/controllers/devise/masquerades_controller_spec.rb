require 'spec_helper'

describe Devise::MasqueradesController, type: :controller do
  context 'with configured devise app' do
    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'when logged in' do
      before { logged_in }

      context 'with masqueradable_class param' do
        let(:mask) { create(:student) }

        before do
          get :show, params: { id: mask.to_param, masqueraded_resource_class: mask.class.name, masquerade: mask.masquerade_key }
        end

        it { expect(Rails.cache.read("devise_masquerade_student_#{mask.to_param}")).to be }

        it 'should have warden keys defined' do
          expect(session["warden.user.student.key"].first.first).to eq(mask.id)
        end

        it { should redirect_to('/') }
      end

      describe '#masquerade user' do
        let(:mask) { create(:user) }

        before do
          get :show, params: { id: mask.to_param, masquerade: mask.masquerade_key }
        end

        it { expect(Rails.cache.read("devise_masquerade_user_#{mask.to_param}")).to be }
        it { expect(session["warden.user.user.key"].first.first).to eq(mask.id) }
        it { should redirect_to('/') }

        context 'and back' do
          before { get :back }

          it { should redirect_to(masquerade_page) }
          it { expect(current_user.reload).to eq(@user) }
          it { expect(Rails.cache.read("devise_masquerade_user_#{mask.to_param}")).not_to be }
        end
      end

      # Configure masquerade_routes_back setting
      describe 'config#masquerade_routes_back' do
        let(:mask) { create(:user) }

        before { Devise.setup { |c| c.masquerade_routes_back = true } }

        after { Devise.masquerade_routes_back = false }

        context 'show' do
          context 'with http referrer' do
            before do
              @request.env['HTTP_REFERER'] = 'previous_location'
              get :show, params: { id: mask.to_param, masquerade: mask.masquerade_key }
            end # before

            it { should redirect_to('previous_location') }
          end # context

          context 'no http referrer' do
            before do
              allow_any_instance_of(described_class).to(
                receive(:after_masquerade_path_for).and_return("/dashboard?color=red"))
            end

            before { get :show, params: { id: mask.to_param, masquerade: mask.masquerade_key } }

            it { should redirect_to("/dashboard?color=red") }
          end # context
        end # context

        context 'and back' do
          before do
            get :show, params: { id: mask.to_param, masquerade: mask.masquerade_key }

            get :back
          end

          it { should redirect_to(masquerade_page) }
        end # context

        context 'and back fallback if http_referer not present' do
          before do
            get :show, params: { id: mask.to_param, masquerade: mask.masquerade_key }

            @request.env['HTTP_REFERER'] = 'previous_location'
            get :back
          end

          it { should redirect_to('previous_location') }
        end # context
      end # describe
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
