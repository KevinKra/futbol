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

  def self.opponent_goals_average(lowest = true)
    team_average =  Hash[@@game_data.map { |game| [game.home_team_id, []]}]
    @@game_data.each { |game| team_average[game.home_team_id] << game.away_goals}
    team_average.each { |key, value| team_average[key] = (value.sum.to_f / value.length).round(2) }
    lowest ? team_average.min_by { |team, avg_opponent_goals| avg_opponent_goals}[0] : team_average.max_by { |team, avg_opponent_goals| avg_opponent_goals}[0]
  end

  def self.biggest_team_blowout(team_id) # iteration-4-darren
    select_games = @@game_data.find_all { |game| game.home_team_id == team_id && game.home_goals > game.away_goals }
    select_games.map { |game| game.home_goals - game.away_goals }.max
  end

  def self.worst_loss(team_id) # iteration-4-darren
    select_games = @@game_data.find_all { |game| game.home_team_id == team_id && game.home_goals < game.away_goals }
    select_games.map { |game| game.away_goals - game.home_goals }.max
  end

  def self.head_to_head(team_id) # iteration-4-darren
    select_games = @@game_data.find_all { |game| game.home_team_id == team_id }
    head_to_head = Hash.new{ |hash, key| hash[key] = Hash.new(0) }
    select_games.each do |game|
      head_to_head[game.away_team_id][:nr_games_played] += 1
      head_to_head[game.away_team_id][:nr_games_won] += 1 if game.home_goals > game.away_goals
      head_to_head[game.away_team_id][:win_pct] = (head_to_head[game.away_team_id][:nr_games_won] / head_to_head[game.away_team_id][:nr_games_played].to_f).round(2)
    end
    head_to_head_final = Hash.new(0)
    head_to_head.each { |key, value| head_to_head_final[key] = value[:win_pct] }
    head_to_head_final
  end

  def self.seasonal_summary(team_id) # iteration-4-darren
    seasonal = Hash.new{ |hash, key| hash[key] = Hash.new{ |nest_hash, nest_key| nest_hash[nest_key] = Hash.new(0) } }
    select_games = @@game_data.find_all { |game| game.home_team_id == team_id }
    select_games.each do |game|
      if game.type == 'Regular Season'
        game_type = :regular_season
      elsif game.type == 'Postseason'
        game_type = :postseason
      end
      seasonal[game.season][game_type][:nr_games_played] += 1
      seasonal[game.season][game_type][:nr_games_won] += 1 if game.home_goals > game.away_goals
      seasonal[game.season][game_type][:total_goals_scored] += game.home_goals
      seasonal[game.season][game_type][:total_goals_against] += game.away_goals
      seasonal[game.season][game_type][:average_goals_scored] = (seasonal[game.season][game_type][:total_goals_scored] / seasonal[game.season][game_type][:nr_games_played].to_f).round(2)
      seasonal[game.season][game_type][:average_goals_against] = (seasonal[game.season][game_type][:total_goals_against] / seasonal[game.season][game_type][:nr_games_played].to_f).round(2)
      seasonal[game.season][game_type][:win_percentage] = (seasonal[game.season][game_type][:nr_games_won] / seasonal[game.season][game_type][:nr_games_played].to_f).round(2)
    end
    seasonal
  end

end
