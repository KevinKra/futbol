class Result
  @@result_data = []

  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles,
              :pim,
              :ppo,
              :ppg,
              :fowp,
              :giveaways,
              :takeaways

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

  def self.find_team_name(id)
    @@game
  end

  # Helper method to generate average scores by team by type -> Returns nested Hash
  def self.average_scores(type)
    team_average = Hash.new{ |hash,k| hash[k] = Hash.new(0) }
    @@result_data.each do |game|
      if game.hoa == type
        team_average[game.team_id][:number_of_games] += 1
        team_average[game.team_id][:number_of_goals] += game.goals
        team_average[game.team_id][:average_goals] = (team_average[game.team_id][:number_of_goals] / team_average[game.team_id][:number_of_games].to_f).round(2)
      end
    end
    team_average
  end

  # Name of the team with the highest average score
  # per game across all seasons when they are away.	-> Returns String
  def self.highest_scoring_visitor
    team_average = self.average_scores("away")
    team_average.max_by {|key, value| value[:average_goals] }[0]
  end

# Name of the team with the highest average score
# per game across all seasons when they are home. -> Returns String
  def self.highest_scoring_home_team
    team_average = self.average_scores("home")
    team_average.max_by {|key, value| value[:average_goals] }[0]
  end

# Name of the team with the lowest average score
# per game across all seasons when they are a visitor. -> Returns String
  def self.lowest_scoring_visitor
    team_average = self.average_scores("away")
    team_average.min_by {|key, value| value[:average_goals] }[0]
  end

# Name of the team with the lowest average score
# per game across all seasons when they are at home.
  def self.lowest_scoring_home_team
    team_average = self.average_scores("home")
    team_average.min_by {|key, value| value[:average_goals] }[0]
  end

  # Highest number of goals a particular team has scored in a single game.
  # -> Returns Integer
  # def self.most_goals_scored
  def self.most_goals_scored
    @@result_data.max_by { |result| result.goals }.goals
  end

# Lowest numer of goals a particular team has scored in a single game.
# -> Returns Integer
  def self.fewest_goals_scored
    @@result_data.min_by { |result| result.goals }.goals
  end

  # Name of the opponent that has the lowest win percentage against
  # the given team. -> Returns String

  def self.all_opponent_win_percentages(id)
    win_percentages = Hash.new
    @@result_data.each do |result|
      team_id == id
    win_percentages[team_id] = result.fowp

  end


  # def self.favorite_opponent
  #   win_percentages = []
  #   @@result_data.each do |game|
  #     game.team
  #   end


end
