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

  def self.count_of_games_by_season
    season_count = Hash.new(0)
    @@game_data.each { |game| season_count[game.season] += 1 }
    season_count
  end

  def self.average_goals_per_game
    game_number = 0
    goal_total = 0
    @@game_data.each do |game|
      game_number += 1
      goal_total += game.away_goals + game.home_goals
    end
    (goal_total / game_number.to_f).round(2)
  end

  def self.average_goals_by_season
    season_average = Hash.new{|h,k| h[k] = []}
    @@game_data.each { |game| season_average[game.season] << (game.away_goals + game.home_goals) }
    season_average.each { |key, value| season_average[key] = (value.sum.to_f / value.length).round(2) }
  end

end
