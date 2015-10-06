class LeadersController < ActionController::Base


  def create
    leader = Leader.new(leader_params)

    if leader.save
      @leaders = Leader.all.order(score: :desc)
      render json: @leaders
    else
      render json: {}
    end
  end

  def index
    @leaders = Leader.all.order(score: :desc)

    render json: @leaders
  end

  private

  def leader_params
    params.require(:leader).permit(:name, :score)
  end
end
