class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :masquerade_user!
end

