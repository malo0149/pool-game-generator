class TournamentsController < ActionController::Base

	def initialize
		@@letters = alphabet_numbers
	end
	def games
		render json: generate_games(params_games[:rounds].to_i)
	end

	def params_games
		params.permit(:pools, :teams, :rounds)
	end
	private :params_games

	def generate_teams(team_count)
		#TODO: Figure out how to use strong params for team_count as an integer
		Array.new(team_count.to_i) { |i| "Team #{i+1}" }
	end

	def generate_games(round_count)
		# Create pools and assign teams to each
		pools = generate_pools(params_games[:pools].to_i)

		# Generate games for each pool, with the given number of rounds
		pool_games = Hash.new
		game_id = 1
		(1..pools.length).each do |i|
			# Generate all combinations of teams within each pool
			team_pairs = pools[pool_name(i)].combination(2).to_a

			pool_games[pool_name(i)] = Array.new
			team_pairs.each do |j|
				# Each team pairing will play the specified number of rounds
				(1..round_count).each do |k|
					# Copy team pairings to each pool record, along with a unique game ID
				 	pool_games[pool_name(i)] << [game_id,j]
					game_id += 1
				end
			end
		end
		pool_games
	end

	def generate_pools(pool_count)
		# Create a list of all teams in the tournament
		all_teams = generate_teams(params_games[:teams])

		# Create a list of all pools, without seeding teams yet
		all_pools = ActiveSupport::OrderedHash.new
		(1..pool_count).each { |i| all_pools[pool_name(i)] = Array.new}
		
		# Assign teams to pools using snake seeding
		seeding_forward = true
		current_pool = 1
		all_teams.each_index do |i|
			# Add the current team to the current pool's roster
			all_pools[pool_name(current_pool)] << all_teams[i]

			if current_pool == 1 && !seeding_forward
				# Reached first pool, switch pool seeding direction
				seeding_forward = true
			elsif current_pool == pool_count && seeding_forward
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
		all_pools
	end

	def pool_name(pool_number)
		#TODO: Handle pool_number > 26
		"Pool " + @@letters[pool_number]
	end

	private
	def alphabet_numbers
		alphabet = ("A".."Z").to_a
		@@letters = ActiveSupport::OrderedHash.new
		(1..26).each { |i| @@letters[i] = alphabet[i-1]}
		@@letters
	end
end
