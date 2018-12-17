class TournamentsController < ActionController::Base
  def games
    new_tournament = Tournament.new(params_games[:pools].to_i,
                                    params_games[:teams].to_i,
                                    params_games[:rounds].to_i)
    render json: new_tournament.pool_games_list
  end

  def params_games
    params.permit(:pools, :teams, :rounds)
  end
  private :params_games

end
