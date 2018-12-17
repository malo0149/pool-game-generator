require 'numbered_alphabet'
require 'pool'
require 'team'
require 'game'

class Tournament
  
  def initialize(pool_count,team_count,round_count)
    @game_id = 1
    generate_teams(team_count.to_i)
    generate_pools(pool_count.to_i)
    generate_games(round_count.to_i)
  end

  attr_accessor :teams
  attr_accessor :pools

  # Returns an array of pool names, each with an array of generated games
  def pool_games_list
    Array.new(@pools.length) do |i|
      [@pools[i].name, @pools[i].games_list_array]
    end
  end

  private
 
  # Create team_count teams
  def generate_teams(team_count)
    @teams = Array.new(team_count.to_i) do |i|
      Team.new("Team #{i+1}")
    end
  end

  # Create pool_count pools and assign teams using snake seeding
  def generate_pools(pool_count)
    @pools = Array.new(pool_count.to_i) do |i|
      Pool.new(pool_name(i+1))
    end

    # Assign teams to pools
    snake_seed
  end

  # Generate a pool name like "Pool ?" where '?' is the
  # alphabet letter corresponding to the pool_number
  def pool_name(pool_number)
    if pool_number.between?(1,26)
      "Pool " + NumberedAlphabet.get_alpha(pool_number)
    end
  end

  # Assign teams to pools using snake seeding
  def snake_seed
    if @teams.length == 0 || @pools.length == 0
      return
    end
    seeding_forward = true
    current_pool = 0
    @teams.each_index do |i|
      # Add the current team to the current pool's roster
      @pools[current_pool].add_team(@teams[i])

      # Determine which pool to add the next team to
      if current_pool == 0 && !seeding_forward
        # Reached first pool, switch pool seeding direction
        seeding_forward = true
      elsif current_pool == @pools.length-1 && seeding_forward
        # Reached last pool, switch pool seeding direction
        seeding_forward = false
      elsif !seeding_forward
        # Next pool to seed is the one before the current pool
        current_pool = current_pool - 1
      else
        # Next pool to seed is the one after the current pool
        current_pool = current_pool + 1
      end
    end
  end

  # Create a list of games within each pool for the
  # specified number of rounds
  def generate_games(round_count)
    @pools.each_index do |i|
      # Generate all possible unordered pairs of teams within the current pool
      team_pairs = @pools[i].teams_list.combination(2).to_a

      # Add these team pairings to the pool with the specified number of rounds
      (1..round_count).each do |j|
        team_pairs.each_index do |k|
          new_game = Game.new(@game_id, team_pairs[k])
          @pools[i].add_game(new_game)
          @game_id += 1
        end
      end
    end
  end
end