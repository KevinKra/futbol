class Result
  @@result_data = []

  attr_reader :team_id, :hoa, :result, :goals, :game_id, :shots, :head_coach, :tackles

  def initialize(result_data)
    @game_id = result_data[:game_id]
    @team_id = result_data[:team_id]
    @hoa = result_data[:hoa]
    @result = result_data[:result]
    @settled_in = result_data[:settled_in]
    @head_coach = result_data[:head_coach]
    @goals = result_data[:goals].to_i
    @shots = result_data[:shots].to_i
    @tackles = result_data[:tackles].to_i
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

  def self.global_result_percentages(format, seek_result)
    # format ("home", "away"), seek_result ("WIN", "LOSE", "TIE")
    games = @@result_data.select { |game| game.hoa == format }
    results = games.select { |game| game.result == seek_result }.length
    outcome_percentage = (results.to_f / games.length)
    outcome_percentage.round(2)
  end

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

   def self.best_worst_coach(games_by_season) # iteration-5-darren
     coach_results = Hash.new { |hash, key| hash[key] = Hash.new(0) }
     games_by_season.each do |game|
       home_coach = @@result_data.find { |result| result.game_id == game.game_id && result.team_id == game.home_team_id }.head_coach
       home_team_id = game.home_team_id
       coach_results[home_coach][:nr_games_coached] += 1
       coach_results[home_coach][:coached_games_won] += 1 if game.home_goals > game.away_goals
       coach_results[home_coach][:win_percentage] = (coach_results[home_coach][:coached_games_won] / coach_results[home_coach][:nr_games_coached].to_f).round(2)
       away_coach = @@result_data.find { |result| result.game_id == game.game_id && result.team_id == game.away_team_id }.head_coach
       away_team_id = game.away_team_id
       coach_results[away_coach][:nr_games_coached] += 1
       coach_results[away_coach][:coached_games_won] += 1 if game.away_goals > game.home_goals
       coach_results[away_coach][:win_percentage] = (coach_results[away_coach][:coached_games_won] / coach_results[away_coach][:nr_games_coached].to_f).round(2)
     end
     coach_results
   end

  # Helper method to generate hash of shot ratios by team by season
  # Returns -> nested Hash
  def self.shot_ratios_by_season(season_games)
    team_ratios = Hash.new{ |hash,k| hash[k] = Hash.new(0) }
    @@result_data.each do |result|
      if season_games.include?(result.game_id)
        team_ratios[result.team_id][:num_goals] += result.goals
        team_ratios[result.team_id][:num_shots] += result.shots
        team_ratios[result.team_id][:shot_ratio] = (team_ratios[result.team_id][:num_goals] / team_ratios[result.team_id][:num_shots].to_f).round(4)
      end
    end
    team_ratios
  end

  # Name of the Team with the best ratio of shots to goals for the season
  # Returns -> String
  def self.most_accurate_team(game_ids)
    team_ratios = shot_ratios_by_season(game_ids)
    team_ratios.max_by {|key, value| value[:shot_ratio] }[0]
  end

  # Name of the Team with the worst ratio of shots to goals for the season
  # Returns -> String
  def self.least_accurate_team(game_ids)
    team_ratios = shot_ratios_by_season(game_ids)
    team_ratios.min_by {|key, value| value[:shot_ratio] }[0]
  end

  # Helper method that generates hash of tackles by season by team
  def self.tackles_by_season(season_games)
  tackles = Hash.new{ |hash,k| hash[k] = Hash.new(0) }
    @@result_data.each do |result|
      if season_games.include?(result.game_id)
        tackles[result.team_id][:num_tackles] += result.tackles
      end
    end
    tackles
  end

  def self.most_tackles(season_games)
    tackles = tackles_by_season(season_games)
    tackles.max_by {|key, value| value[:num_tackles] }[0]
  end

  def self.fewest_tackles(season_games)
    tackles = tackles_by_season(season_games)
    tackles.min_by {|key, value| value[:num_tackles] }[0]
  end
end
