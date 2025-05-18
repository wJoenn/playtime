class SessionsController < ApplicationController
  def index
    render json: Session.includes(:game).where(filters), include: :game, status: :ok
  end

  private

  def filters
    { active: true, played_at: params[:start_date]..params[:end_date] }
  end
end
