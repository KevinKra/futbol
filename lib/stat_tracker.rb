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

  def team_games_percentages(team_id, format = "home", seek_result = "WIN")
    # defaults to home games won and returns ex: 33.37
    all_matching_games = @result_data.result_data.select do |game| 
      game.team_id == team_id.to_s && game.hoa == format
    end
    matching_results = all_matching_games.select do |game| 
      game.result == seek_result
    end.length
    outcome_percentage = (matching_results.to_f / all_matching_games.length) * 100
    outcome_percentage.round(2)
  end

  def games_by_team_id(team_id, format, seek_result)
    # team_id, format ("home", "away"), seek_result ("WIN", "LOSE", "TIE") 
    all_matching_games = @result_data.result_data.select do |game| 
      game.team_id == team_id.to_s && game.hoa == format
    end
    matching_results = all_matching_games.select do |game| 
      game.result == seek_result
    end.length
    outcome_percentage = (matching_results.to_f / all_matching_games.length) * 100
    outcome_percentage.round(2)
  end

  def percentage_home_wins(team_id)
    games_by_team_id(team_id, "home", "WIN")
  end

  def percentage_visitor_wins(team_id)
    games_by_team_id(team_id, "away", "WIN")
  end

  def percentage_ties(team_id)
    games_by_team_id(team_id, "away", "TIE")
  end
end
