require 'securerandom'

class Devise::MasqueradesController < DeviseController
  Devise.mappings.each do |name, _|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      skip_before_action :masquerade_#{name}!, raise: false
    METHODS
  end
  skip_before_action :masquerade!, raise: false

  prepend_before_action :authenticate_scope!, only: :show
  prepend_before_action :masquerade_authorize!

  def show
    if send("#{masqueraded_resource_name}_masquerade?")
      resource = masquerading_current_user

      go_back(resource, path: after_masquerade_full_path_for(resource))
    else
      masqueradable_resource = find_masqueradable_resource

      save_masquerade_owner_session(masqueradable_resource)

      resource = masqueradable_resource
      sign_out(masquerading_current_user)

      unless resource
        flash[:error] = "#{masqueraded_resource_class} not found."
        redirect_to(send("new_#{masqueraded_resource_name}_session_path")) and return
      end

      request.env['devise.skip_trackable'] = '1'

      masquerade_sign_in(resource)

      go_back(resource, path: after_masquerade_full_path_for(resource))
    end
  end

  def back
    unless send("#{masqueraded_resource_name}_masquerade?")
      resource = send("current_#{masqueraded_resource_name}")
      go_back(resource, path: after_back_masquerade_path_for(resource))
    else
      masqueradable_resource = send("current_#{masqueraded_resource_name}")

      unless send("#{masqueraded_resource_name}_signed_in?")
        head(401) and return
      end

      resource = find_owner_resource(masqueradable_resource)
      sign_out(send("current_#{masqueraded_resource_name}"))

      sign_in(resource)
      request.env['devise.skip_trackable'] = nil

      go_back(resource, path: after_back_masquerade_path_for(resource))

      cleanup_masquerade_owner_session(masqueradable_resource)
    end
  end

  protected

  def masquerade_authorize!
    head(403) unless masquerade_authorized?
  end

  def masquerade_authorized?
    true
  end

  def find_masqueradable_resource
    GlobalID::Locator.locate_signed(params[Devise.masquerade_param], for: 'masquerade')
  end

  def find_owner_resource(masqueradable_resource)
    skey = session_key(masqueradable_resource, masquerading_guid)

    if Devise.masquerade_storage_method_session?
      resource_id = session[skey]

      masquerading_resource_class.find(resource_id)
    else
      data = Rails.cache.read(skey)

      GlobalID::Locator.locate_signed(data, for: 'masquerade')
    end
  end

  def go_back(user, path:)
    if Devise.masquerade_routes_back
      redirect_back(fallback_location: path)
    else
      redirect_to path
    end
  end

  private

  def masqueraded_resource_name
    Devise.masqueraded_resource_name || masqueraded_resource_class.model_name.param_key
  end

  def masquerading_resource_class
    @masquerading_resource_class ||= begin
      unless params[:masquerading_resource_class].blank?
        params[:masquerading_resource_class].constantize
      else
        unless session[session_key_masquerading_resource_class].blank?
          session[session_key_masquerading_resource_class].constantize
        else
          if Devise.masquerading_resource_class_name.present?
            Devise.masquerading_resource_class_name.constantize
          else
            Devise.masquerading_resource_class || resource_class
          end
        end
      end
    end
  end

  def masquerading_resource_name
    Devise.masquerading_resource_name || masquerading_resource_class.model_name.param_key
  end

  def authenticate_scope!
    send(:"authenticate_#{masquerading_resource_name}!", force: true)
  end

  def after_masquerade_path_for(resource)
    '/'
  end

  def after_masquerade_full_path_for(resource)
    after_masquerade_path_for(resource)
  end

  def after_back_masquerade_path_for(resource)
    '/'
  end

  def save_masquerade_owner_session(masqueradable_resource)
    guid = SecureRandom.uuid

    skey = session_key(masqueradable_resource, guid)

    resource_obj = send("current_#{masquerading_resource_name}")

    if Devise.masquerade_storage_method_session?
      session[skey] = resource_obj.id
    else
      # skip sharing owner id via session
      Rails.cache.write(skey, resource_obj.to_sgid(for: 'masquerade'))

      session[skey] = true
    end

    session[session_key_masquerading_resource_class] = masquerading_resource_class.name
    session[session_key_masqueraded_resource_class] = masqueraded_resource_class.name
    session[session_key_masquerading_resource_guid] = guid
  end

  def cleanup_masquerade_owner_session(masqueradable_resource)
    skey = session_key(masqueradable_resource, masquerading_guid)

    Rails.cache.delete(skey) if Devise.masquerade_storage_method_cache?

    session.delete(session_key_masqueraded_resource_class)
    session.delete(session_key_masquerading_resource_class)
    session.delete(session_key_masquerading_resource_guid)
  end

  def session_key(masqueradable_resource, guid)
    "devise_masquerade_#{masqueraded_resource_name}_#{masqueradable_resource.id}_#{guid}".to_sym
  end

  def masquerading_current_user
    send("current_#{masquerading_resource_name}")
  end

  def masquerading_guid
    session[session_key_masquerading_resource_guid]
  end
end

