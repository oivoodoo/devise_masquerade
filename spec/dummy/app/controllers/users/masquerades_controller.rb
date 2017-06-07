class Users::MasqueradesController < Devise::MasqueradesController
  # Just an example showing how you would add authorization to devise_masquerade
  def show
    super
  end

  protected

  # Custom url redirect after masquerade
  def after_masquerade_path_for(resource)
    "/"
  end
end
