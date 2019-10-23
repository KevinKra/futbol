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
    self.new(game_data, team_data, result_data)
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

end
