class MasqueradesController < Devise::MasqueradesController
  before_filter :save_masquerade_owner_session, :only => :show, if: -> { authorized? }
  after_filter :cleanup_masquerade_owner_session, :only => :back, if: -> { authorized? }

  def show
    !authorized? && head(403) && return

    super
  end

  private

  def authorized?
    authorize!(:masquerade, User)
  end
end
