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

  def self.highest_total_score
    max_sum = 0
    @@game_data.each do |game|
      sum = game.away_goals.to_i + game.home_goals.to_i
      if sum > max_sum
        max_sum = sum
      end
    end
    max_sum
  end

  def self.lowest_total_score
    min_sum = 0
    @@game_data.each do |game|
      sum = game.away_goals.to_i + game.home_goals.to_i
      if sum < min_sum
        min_sum = sum
      end
    end
    min_sum
  end

  def self.biggest_blowout
    highest_difference = 0
    @@game_data.each do |game|
      difference = (game.away_goals.to_i - game.home_goals.to_i).abs
      if difference > highest_difference
        highest_difference = difference
      end
    end
    highest_difference
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

end
