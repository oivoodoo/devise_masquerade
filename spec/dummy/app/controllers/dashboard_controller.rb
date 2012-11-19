class DashboardController < ApplicationController
  before_filter :masquerade_user!

  def index
    render :text => "text to render"
  end
end

