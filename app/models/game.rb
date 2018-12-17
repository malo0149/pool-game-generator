class Game
  def initialize(id, team_pair)
    @id = id
    @team_pair = team_pair
  end

  attr_accessor :id
  attr_accessor :team_pair
end