require 'csv'
require_relative './game_collection'
require_relative './game'

class StatTracker

  def initialize(game_path, team_path, result_path)

  end

  def self.from_csv(location_paths)
    game_path = location_paths[:games]
    team_path = location_paths[:teams]
    result_path = location_paths[:result]
    game_data = GameCollection.new(parse_csv_data(game_path))
    team_data = TeamCollection.new(parse_csv_data(team_path))
    result_data = ResultCollection.new(parse_csv_data(result_path))
    self.new(game_data, team_data, result_data)
  end

  def self.parse_csv_data(file_path)
    output = []
    CSV.foreach(file_path, headers: :true, header_converters: :symbol) do |csv_row|
      output << Game.new(csv_row)
    end
    output
  end

end
