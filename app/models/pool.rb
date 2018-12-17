class Pool
  def initialize(name)
    @name = name
    @teams_list = Array.new
    @games_list = Array.new
  end

  attr_accessor :name
  attr_accessor :teams_list
  attr_accessor :games_list

  def add_team(team)
    @teams_list << team
  end

  def add_game(game)
    @games_list << game
  end

  def games_list_array
    Array.new(@games_list.length) do |i|
      [@games_list[i].id, [@games_list[i].team_pair[0].name,
                           @games_list[i].team_pair[1].name]]
    end
  end
end