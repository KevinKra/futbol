require 'csv'

class Game
  @@game_data = []

  attr_reader :game_id, :season, :type, :date_time, :away_team_id, :home_team_id, :away_goals, :home_goals, :venue, :venue_link
  def initialize(game_data)
    @game_id = game_data[:game_id]
    @season = game_data[:season]
    @type = game_data[:type]
    @date_time = game_data[:date_time]
    @away_team_id = game_data[:away_team_id]
    @home_team_id = game_data[:home_team_id]
    @away_goals = game_data[:away_goals].to_i
    @home_goals = game_data[:home_goals].to_i
    @venue = game_data[:venue]
    @venue_link = game_data[:venue_link]
  end

  def self.assign_game_data(data)
    @@game_data = data
  end

  def self.game_data
    @@game_data
  end

  def self.parse_csv_data(file_path)
    output = []
    CSV.foreach(file_path, headers: :true, header_converters: :symbol) do |csv_row|
      output << Game.new(csv_row)
    end
    self.assign_game_data(output)
  end

  def self.season_outcome(team_id, worst = false)
    team_data = @@game_data.select do |game|
      game if game.home_team_id == team_id || game.away_team_id == team_id
    end
    season_avg =  Hash[team_data.map { |game| [game.season, []]}]
    team_data.each do |game|
      if game.home_team_id == team_id
       game.home_goals > game.away_goals ? season_avg[game.season] << 1
        : season_avg[game.season] << 0
      else game.away_team_id == team_id
        game.away_goals > game.home_goals ? season_avg[game.season] << 1
        : season_avg[game.season] << 0
      end
    end
    season_avg.each { |key, value| season_avg[key] = (value.sum.to_f / value.length).round(2) }
    worst ? season_avg.min_by { |season, avg| avg}[0] : season_avg.max_by { |team, avg| avg}[0]
  end


  # Helper method to sum total score by game -> Returns array of Integers
  def self.total_scores
    @@game_data.map { |game| game.away_goals + game.home_goals }
  end

  # Highest sum of the winning and losing teams’ scores	-> returns Integer
  def self.highest_total_score
    self.total_scores.max_by { |score| score }
  end

# Lowest sum of the winning and losing teams’ scores -> returns Integer
  def self.lowest_total_score
    self.total_scores.min_by { |score| score }
  end

  # Helper method to get score differences of all games -> Returns array of Integers
  def self.score_difference
    @@game_data.map { |game| (game.away_goals - game.home_goals).abs}
  end

  # Highest difference between winner and loser	-> returns Integer
  def self.biggest_blowout
    self.score_difference.max_by { |difference| difference }
  end

  def self.count_of_games_by_season # iteration-2-darren
    season_count = Hash.new(0)
    @@game_data.each { |game| season_count[game.season] += 1 }
    season_count
  end

  def self.average_goals_per_game # iteration-2-darren
    (@@game_data.reduce(0) { |acc, game| acc + game.away_goals + game.home_goals } / @@game_data.count.to_f).round(2)
  end

  def self.average_goals_by_season # iteration-2-darren
    season_average = Hash.new{|h,k| h[k] = []}
    @@game_data.each { |game| season_average[game.season] << (game.away_goals + game.home_goals) }
    season_average.each { |key, value| season_average[key] = (value.sum.to_f / value.length).round(2) }
  end

  def self.opponent_goals_average(lowest = true) #it-4-kevin
    team_average =  Hash[@@game_data.map { |game| [game.home_team_id, []]}]
    @@game_data.each { |game| team_average[game.home_team_id] << game.away_goals}
    @@game_data.each { |game| team_average[game.away_team_id] << game.home_goals}
    team_average.each { |key, value| team_average[key] = (value.sum.to_f / value.length.to_f).round(3) }
    if lowest
      team_average.min_by { |team, avg_opponent_goals| avg_opponent_goals}[0]
    else
      team_average.max_by { |team, avg_opponent_goals| avg_opponent_goals}[0]
    end
  end

  def self.average_win_percentage(team_id)
    total = @@game_data.reduce([]) do |accum, game|
      if game.home_team_id == team_id
        game.home_goals > game.away_goals ? accum << "win" : accum << "loss"
      end
      if game.away_team_id == team_id
        game.away_goals > game.home_goals ? accum << "win" : accum << "loss"
      end
      accum
    end
    games_won = total.select {|result| result == "win" }.length.to_f
    output = (games_won / total.length.to_f).round(2)
    output.finite? == false ? 0 : output
  end

  # Helper method to get all opponents by team with win percentages
  # -> Returns nested Hash
  def self.opponents_by_team(team_id)
    fav_opponent = Hash.new{ |hash,k| hash[k] = Hash.new(0) }
    all_games = @@game_data.find_all { |game| game.home_team_id == team_id || game.away_team_id == team_id }
    all_games.each do |game|
      opponent_id = get_opponent(team_id, game.home_team_id, game.away_team_id)
      hoa = home_or_away(team_id, game.home_team_id, game.away_team_id)
      home_away_goals = home_goals_away_goals(hoa, game.home_goals, game.away_goals)
      home_goals = home_away_goals[0]
      away_goals = home_away_goals[1]
      fav_opponent[opponent_id][:num_games] += 1
      fav_opponent[opponent_id][:num_wins] += 1 if home_goals > away_goals
      fav_opponent[opponent_id][:win_pct] = (fav_opponent[opponent_id][:num_wins] / fav_opponent[opponent_id][:num_games].to_f).round(2)
    end
    fav_opponent
  end

  # Name of the opponent that has the lowest win percentage against
  # the given team. -> Returns String
  def self.favorite_opponent(team_id)
    all_opponents = self.opponents_by_team(team_id)
    all_opponents.max_by { |key, value| value[:win_pct] }[0]
  end
  # Name of the opponent that has the highest win percentage against
  # the given team. -> Returns String
  def self.rival(team_id)
    all_opponents = self.opponents_by_team(team_id)
    all_opponents.min_by { |key, value| value[:win_pct] }[0]
  end

  # Helper method to get correct opponent ids from game_data
  def self.get_opponent(team_id, home_team_id, away_team_id)
    if home_team_id == team_id
      opponent_id = away_team_id
    elsif away_team_id == team_id
      opponent_id = home_team_id
    end
  end

  def self.home_or_away(team_id, home_team_id, away_team_id) # iteration-4-darren seasonal_summary helper
    return 'home' if team_id == home_team_id
    return 'away' if team_id == away_team_id
  end

  def self.home_goals_away_goals(hoa, home_goals, away_goals) # iteration-4-darren seasonal_summary helper
    return [home_goals, away_goals] if hoa == 'home'
    return [away_goals, home_goals] if hoa == 'away'
  end

  def self.best_worst_loss(team_id) # iteration-4-darren
    select_games = select_games(team_id)
    select_games.map do |game|
      if team_id == game.home_team_id
        game.home_goals - game.away_goals
      else
        game.away_goals - game.home_goals
      end
    end
  end

  def self.head_to_head(team_id) # iteration-4-darren
    select_games = select_games(team_id)
    head_to_head = Hash.new{ |hash, key| hash[key] = Hash.new(0) }
    select_games.each do |game|
      hoa = home_or_away(team_id, game.home_team_id, game.away_team_id)
      home_away_goals = home_goals_away_goals(hoa, game.home_goals, game.away_goals)
      home_goals = home_away_goals[0]
      away_goals = home_away_goals[1]
      oppon_id = get_opponent(team_id, game.home_team_id, game.away_team_id)
      head_to_head[oppon_id][:nr_games_played] += 1
      head_to_head[oppon_id][:nr_games_won] += 1 if home_goals > away_goals
      head_to_head[oppon_id][:win_pct] = (head_to_head[oppon_id][:nr_games_won] / head_to_head[oppon_id][:nr_games_played].to_f).round(2)
    end
    head_to_head_final = Hash.new(0)
    head_to_head.each { |key, value| head_to_head_final[key] = value[:win_pct] }
    head_to_head_final
  end

  def self.get_opponent(team_id, home_team_id, away_team_id) # iteration-4-darren helper
   if home_team_id == team_id
     opponent_id = away_team_id
   elsif away_team_id == team_id
     opponent_id = home_team_id
   end
  end

  def self.seasonal_summary(team_id) # iteration-4-darren
    seasonal = nested_hash
    select_games = select_games(team_id)
    select_games.each do |game|
      gm_season = game.season
      gm_type = game_type(game.type)
      hoa = home_or_away(team_id, game.home_team_id, game.away_team_id)
      home_away_goals = home_goals_away_goals(hoa, game.home_goals, game.away_goals)
      home_goals = home_away_goals[0]
      away_goals = home_away_goals[1]
      seasonal[gm_season][gm_type][:nr_games_played] += 1
      seasonal[gm_season][gm_type][:nr_games_won] += 1 if home_goals > away_goals
      seasonal[gm_season][gm_type][:total_goals_scored] += home_goals
      seasonal[gm_season][gm_type][:total_goals_against] += away_goals
      seasonal[gm_season][gm_type][:average_goals_scored] = (seasonal[gm_season][gm_type][:total_goals_scored] / seasonal[gm_season][gm_type][:nr_games_played].to_f).round(2)
      seasonal[gm_season][gm_type][:average_goals_against] = (seasonal[gm_season][gm_type][:total_goals_against] / seasonal[gm_season][gm_type][:nr_games_played].to_f).round(2)
      seasonal[gm_season][gm_type][:win_percentage] = (seasonal[gm_season][gm_type][:nr_games_won] / seasonal[gm_season][gm_type][:nr_games_played].to_f).round(2)
    end
    tidy_and_fix_hash(seasonal)
  end

  def self.nested_hash # iteration-4-darren helper
    Hash.new{
      |hash, key| hash[key] = Hash.new{
        |nest_hash, nest_key| nest_hash[nest_key] = Hash.new(0) } }
  end

  def self.tidy_and_fix_hash(input_data) # iteration-4-darren helper
    input_data.each do |key, value|
      value.each do |nested_key, nested_value|
        input_data[key][nested_key].delete(:nr_games_played)
        input_data[key][nested_key].delete(:nr_games_won)
      end
      if value[:postseason].length == 0
        input_data[key][:postseason][:total_goals_scored] = 0
        input_data[key][:postseason][:total_goals_against] = 0
        input_data[key][:postseason][:average_goals_scored] = 0
        input_data[key][:postseason][:average_goals_against] = 0
        input_data[key][:postseason][:win_percentage] = 0
      end
    end
    input_data
  end

  def self.select_games(team_id) # iteration-4-darren helper method
    select_games = @@game_data.find_all do |game|
      team_id == game.home_team_id || team_id == game.away_team_id
    end
  end

  def self.game_type(input_type) # iteration-4-darren helper
    return :regular_season if input_type == 'Regular Season'
    return :postseason if input_type == 'Postseason'
  end

  def self.home_or_away(team_id, home_team_id, away_team_id) # iteration-4-darren helper
    return 'home' if team_id == home_team_id
    return 'away' if team_id == away_team_id
  end

  def self.home_goals_away_goals(hoa, home_goals, away_goals) # iteration-4-darren helper
    return [home_goals, away_goals] if hoa == 'home'
    return [away_goals, home_goals] if hoa == 'away'
  end

  # Helper method to return game_ids by season for iteration-5 methods
  # Returns -> array of game_id integers
  def self.games_by_season(season_id) #iteration-5-melissa
    game_ids = []
    @@game_data.each do |game|
      if game.season == season_id
        game_ids << game.game_id
      end
    end
    game_ids
  end

end
