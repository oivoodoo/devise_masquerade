class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :masquerade_user!
end

