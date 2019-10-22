class MasqueradesTestsController < Devise::MasqueradesController
  before_action :authenticate_user!

  def show
    super
  end
end
