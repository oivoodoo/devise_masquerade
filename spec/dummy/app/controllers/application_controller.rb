class ApplicationController < ActionController::Base
  before_action :masquerade!

  protect_from_forgery
end

