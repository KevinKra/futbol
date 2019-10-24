require 'csv'
require_relative './game_collection'
require_relative './game'
require_relative './team_collection'
require_relative './team'
require_relative './result_collection'
require_relative './result'

class StatTracker
  attr_reader :game_data, :team_data, :result_data
  def initialize(game_data, team_data, result_data)
    @game_data = game_data
    @team_data = team_data
    @result_data = result_data
  end

  def self.from_csv(location_paths)
    game_path = location_paths[:games]
    team_path = location_paths[:teams]
    result_path = location_paths[:result]
    game_data = GameCollection.new(parse_csv_data(game_path, "game"))
    team_data = TeamCollection.new(parse_csv_data(team_path, "team"))
    result_data = ResultCollection.new(parse_csv_data(result_path, "result"))
    self.new(game_data.game_data, team_data.team_data, result_data.result_data)
  end

  def self.parse_csv_data(file_path, format)
    output = []
    if format == "game"
      CSV.foreach(file_path, headers: :true, header_converters: :symbol) do |csv_row|
        output << Game.new(csv_row)
      end
    elsif format == "team"
      CSV.foreach(file_path, headers: :true, header_converters: :symbol) do |csv_row|
        output << Team.new(csv_row)
      end
    elsif format == "result"
      CSV.foreach(file_path, headers: :true, header_converters: :symbol) do |csv_row|
        output << Result.new(csv_row)
      end
    end
    output
  end

  def highest_total_score
    max_sum = 0
    @game_data.each do |game|
      sum = game.away_goals.to_i + game.home_goals.to_i
      if sum > max_sum
        max_sum = sum
      end
    end
    max_sum
  end

  def lowest_total_score
    min_sum = 0
    @game_data.each do |game|
      sum = game.away_goals.to_i + game.home_goals.to_i
      if sum < min_sum
        min_sum = sum
      end
    end
    min_sum
  end

  def biggest_blowout
    highest_difference = 0
    @game_data.each do |game|
      difference = (game.away_goals.to_i - game.home_goals.to_i).abs
      if difference > highest_difference
        highest_difference = difference
      end
    end
    highest_difference
  end
end
