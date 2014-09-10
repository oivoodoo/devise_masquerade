class Devise::MasqueradesController < DeviseController
  prepend_before_filter :authenticate_scope!

  before_filter :save_masquerade_owner_session, :only => :show
  after_filter :cleanup_masquerade_owner_session, :only => :back

  def show
    self.resource = resource_class.to_adapter.find_first(:id => params[:id])

    redirect_to(new_user_session_path) and return unless self.resource

    self.resource.masquerade!

    sign_in(self.resource, :bypass => Devise.masquerade_bypass_warden_callback)

    redirect_to("#{after_masquerade_path_for(self.resource)}?#{after_masquerade_param_for(resource)}")
  end

  def back
    user_id = session[session_key]

    owner_user = if user_id.present?
                   resource_class.to_adapter.find_first(:id => user_id)
                 else
                   send(:"current_#{resouce_name}")
                 end

    sign_in(owner_user, :bypass => Devise.masquerade_bypass_warden_callback)

    redirect_to after_back_masquerade_path_for(owner_user)
  end

  private

  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
  end

  def after_masquerade_path_for(resource)
    "/"
  end

  def after_masquerade_param_for(resource)
    "#{Devise.masquerade_param}=#{resource.masquerade_key}"
  end

  def after_back_masquerade_path_for(resource)
    "/"
  end

  def save_masquerade_owner_session
    session[session_key] = send("current_#{resource_name}").id
  end

  def cleanup_masquerade_owner_session
    session.delete(session_key)
  end

  def session_key
    "devise_masquerade_#{resource_name}".to_sym
  end
end

