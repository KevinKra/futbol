class Result
  @@result_data = []

  attr_reader :team_id, :hoa, :result, :goals
  def initialize(result_data)
    @game_id = result_data[:game_id]
    @team_id = result_data[:team_id]
    @hoa = result_data[:hoa]
    @result = result_data[:result]
    @settled_in = result_data[:settled_in]
    @head_coach = result_data[:head_coach]
    @goals = result_data[:goals].to_i
    @shots = result_data[:shots]
    @tackles = result_data[:tackles]
    @pim = result_data[:pim]
    @ppo = result_data[:powerplayopportunities]
    @ppg = result_data[:powerplaygoals]
    @fowp = result_data[:faceoffwinpercentage]
    @giveaways = result_data[:giveaways]
    @takeaways = result_data[:takeaways]
  end

  def self.assign_result_data(data)
    @@result_data = data
  end

  def self.result_data
    @@result_data
  end

  def self.parse_csv_data(file_path)
    output = []
    CSV.foreach(file_path, headers: :true, header_converters: :symbol) do |csv_row|
      output << Result.new(csv_row)
    end
    self.assign_result_data(output)
  end

  def self.games_by_team_id(team_id, format, seek_result)
    # team_id, format ("home", "away"), seek_result ("WIN", "LOSE", "TIE")
    all_matching_games = @@result_data.select do |game|
      game.team_id == team_id.to_s && game.hoa == format
    end
    matching_results = all_matching_games.select do |game|
      game.result == seek_result
    end.length
    outcome_percentage = (matching_results.to_f / all_matching_games.length) * 100
    outcome_percentage.round(2)
  end

# Name of the team with the highest average score
# per game across all seasons when they are away.	-> Returns String
  def self.highest_scoring_visitor
    # Go through result data and find all away games by team
    away_games = @@result_data.find_all do |game|
      game.hoa == "away"
    end
    # Group away games by team
    away_games_by_team = away_games.group_by do |game|
      game.team_id
    end



    away_games_by_team = {}
    away_games.group_by do |game|
    away_games_by_team[game.team_id]
    end
    require "pry"; binding.pry

    # Average goals by game by team
    # average_goals_per_game = away_games_by_team.each do |team|
    #   team.each do |game|
    #     require "pry"; binding.pry
    #     game.goals / away_games_by_team.length
    #   end
    #   average_goals_per_game
    #   require "pry"; binding.pry
    # end



    # Average score of goals by team
    # Find highest average team id
    # match team id to team name and return string

  end

  def self.find_team_name(id)
    @@game
  end

  def self.highest_scoring_visitor
    team_average = Hash.new{ |hash,k| hash[k] = Hash.new(0) }
    @@result_data.each do |game|
      if game.hoa == "away"
        team_average[game.team_id][:number_of_games] += 1
        team_average[game.team_id][:number_of_goals] += game.goals
        team_average[game.team_id][:average_goals] = (team_average[game.team_id][:number_of_goals] / team_average[game.team_id][:number_of_games].to_f).round(2)
      end
    end
    team_average.max_by { |team| [:average_goals] }[0]
  end

# Name of the team with the highest average score
# per game across all seasons when they are home. -> Returns String
  def highest_scoring_home_team
  end

# Name of the team with the lowest average score
# per game across all seasons when they are a visitor. -> Returns String
  def lowest_scoring_visitor
  end

# Name of the team with the lowest average score
# per game across all seasons when they are at home.

  def lowest_scoring_home_team
  end


end
