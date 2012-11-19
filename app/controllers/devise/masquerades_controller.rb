class Devise::MasqueradesController < DeviseController
  prepend_before_filter :authenticate_scope!, :only => :masquerade

  def masquerade
    self.resource = resource_class.to_adapter.find_first(:id => params[:id])
    self.resource.masquerade!

    redirect_to(after_masquerade_path_for(self.resource))
  end

  private

  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
  end

  def after_masquerade_path_for(resource)
    "/?masquerade=#{resource.masquerade_key}"
  end
end

