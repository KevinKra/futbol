class Result
  @@result_data = []

  attr_reader :team_id, :hoa, :result, :goals, :game_id
  
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

  # def self.find_team_name(id)
  #   @@game
  # end

  def self.find_best_offense(average = true)
    teams = Hash[@@result_data.map { |result| [result.team_id, []]}]
    @@result_data.each { |result| teams[result.team_id] << result.goals}
    teams.each { |key, value| teams[key] = (value.sum.to_f / value.length).round(2) }
    average ? teams.max_by {|team, goals_average| goals_average}[0] : teams.min_by {|team, goals_average| goals_average}[0]
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

 def self.winningest_team  # iteration-3-darren
  winningest = Hash.new { |hash, key| hash[key] = Hash.new(0) }
  @@result_data.each do |result|
    winningest[result.team_id][:nr_games_played] += 1
    winningest[result.team_id][:nr_games_won] += 1 if result.result == 'WIN'
    winningest[result.team_id][:win_percentage] = (winningest[result.team_id][:nr_games_won] / winningest[result.team_id][:nr_games_played].to_f*100).round(2) if winningest[result.team_id][:nr_games_won] > 0
  end
  winningest.max_by { |key, value| value[:win_percentage] }[0]
 end

 def self.best_worst_fans # iteration-3-darren helper method for best_fans and worst_fans
  best_worst = Hash.new { |hash, key| hash[key] = Hash.new(0) }
  @@result_data.each do |result|
    if result.hoa == 'home'
      best_worst[result.team_id][:games_played_home] += 1
      best_worst[result.team_id][:games_won_home] += 1 if result.result == 'WIN'
      best_worst[result.team_id][:win_pct_home] = (best_worst[result.team_id][:games_won_home] / best_worst[result.team_id][:games_played_home].to_f * 100).round(2)
    else # ie if hoa == 'away'
      best_worst[result.team_id][:games_played_away] += 1
      best_worst[result.team_id][:games_won_away] += 1 if result.result == 'WIN'
      best_worst[result.team_id][:win_pct_away] = (best_worst[result.team_id][:games_won_away] / best_worst[result.team_id][:games_played_away].to_f * 100).round(2)
    end
    best_worst[result.team_id][:diff_home_away_win_pct] = (best_worst[result.team_id][:win_pct_home] - best_worst[result.team_id][:win_pct_away]).round(2)
   end
  best_worst
 end

  # Helper method to retrieve all_goals_scored by a particular team by game
  # -> Returns Hash
  def self.all_goals_scored(team_id)
      @@result_data.reduce({}) do |all_goals, result|
        all_goals[result.game_id] = result.goals if result.team_id == team_id
        all_goals
      end
    end

   # Highest number of goals a particular team has scored in a single game.
   # -> Returns Integer
   def self.most_goals_scored(team_id)
    self.all_goals_scored(team_id).max_by { |key, value| value }[1]
   end


  # Lowest numer of goals a particular team has scored in a single game.
  # -> Returns Integer
   def self.fewest_goals_scored(team_id)
    self.all_goals_scored(team_id).min_by { |key, value| value }[1]
   end

 # Name of the opponent that has the lowest win percentage against
 # the given team. -> Returns String
 def self.favorite_opponent(team_id)
 end



end
