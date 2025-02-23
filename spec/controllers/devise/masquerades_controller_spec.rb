require 'spec_helper'

describe Devise::MasqueradesController, type: :controller do
  before { Devise.masquerade_storage_method = :cache }
  after { Devise.masquerade_storage_method = :session }

  context 'with configured devise app' do
    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'when logged in' do
      before { logged_in }

      context 'with masqueradable_class param' do
        let(:mask) { create(:student) }

        before do
          get :show, params: { id: mask.id, masqueraded_resource_class: mask.class.name, masquerade: mask.masquerade_key }
        end

        it { expect(cache_read(mask)).to be }

        it 'should have warden keys defined' do
          expect(session["warden.user.student.key"].first.first).to eq(mask.id)
        end

        it { should redirect_to('/') }
      end
    end
    context 'when logged in' do
      before { logged_in }

      describe '#masquerade user' do
        let(:mask) { create(:user) }

        before do
          allow_any_instance_of(described_class).to(
            receive(:after_masquerade_flash_message).with(mask).and_return("You are logged as an user"))

          get :show, params: { id: mask.id, masquerade: mask.masquerade_key }
        end

        it { expect(cache_read(mask)).to be }
        it { expect(session["warden.user.user.key"].first.first).to eq(mask.id) }
        it { should redirect_to('/') }
        it { expect(flash[:notice]).to match("You are logged as an user") }

        context 'and back' do
          before { get :back }

          it { should redirect_to(masquerade_page) }
          it { expect(current_user.reload).to eq(@user) }
          it { expect(cache_read(mask)).not_to be }
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
              get :show, params: { id: mask.id, masquerade: mask.masquerade_key }
            end # before

            it { should redirect_to('previous_location') }
          end # context

          context 'no http referrer' do
            before do
              allow_any_instance_of(described_class).to(
                receive(:after_masquerade_path_for).and_return("/dashboard?color=red"))
            end

            before { get :show, params: { id: mask.id, masquerade: mask.masquerade_key } }

            it { should redirect_to("/dashboard?color=red") }
          end # context
        end # context

        context 'and back' do
          before do
            allow_any_instance_of(described_class).to(
              receive(:after_back_masquerade_flash_message).with(mask).and_return("You logged out from user's session")
            )

            get :show, params: { id: mask.id, masquerade: mask.masquerade_key }

            get :back
          end

          it { should redirect_to(masquerade_page) }
          it { expect(flash[:notice]).to match("You logged out from user's session") }
        end # context

        context 'and back fallback if http_referer not present' do
          before do
            get :show, params: { id: mask.id, masquerade: mask.masquerade_key }

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

  def guid
    session[:devise_masquerade_masquerading_resource_guid]
  end

  def cache_read(user)
    Rails.cache.read(cache_key(user))
  end

  def cache_key(user)
    "devise_masquerade_#{mask.class.name.downcase}_#{mask.id}_#{guid}"
  end
end
