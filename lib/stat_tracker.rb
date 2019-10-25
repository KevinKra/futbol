require 'csv'
require_relative './game_collection'
require_relative './game'
require_relative './team_collection'
require_relative './team'
require_relative './result_collection'
require_relative './result'

class StatTracker

  attr_reader :game_data, :team_data, :result_data

  def self.from_csv(location_paths)
    game_path = location_paths[:games]
    team_path = location_paths[:teams]
    result_path = location_paths[:result]
    StatTracker.new(game_path, team_path, result_path)
  end

  def initialize(game_data, team_data, result_data)
    @game_data = GameCollection.new(game_data)
    @team_data = TeamCollection.new(team_data)
    @result_data = ResultCollection.new(result_data)
  end


def highest_total_score
  @game_data.highest_total_score
end

def lowest_total_score
  @game_data.lowest_total_score
end

def biggest_blowout
  @game_data.biggest_blowout
end

  #
  # def games_by_team_id(team_id, format, seek_result)
  #   # team_id, format ("home", "away"), seek_result ("WIN", "LOSE", "TIE")
  #   all_matching_games = @result_data.select do |game|
  #     game.team_id == team_id.to_s && game.hoa == format
  #   end
  #   matching_results = all_matching_games.select do |game|
  #     game.result == seek_result
  #   end.length
  #   outcome_percentage = (matching_results.to_f / all_matching_games.length) * 100
  #   outcome_percentage.round(2)
  # end
  #
  # def percentage_home_wins(team_id)
  #   games_by_team_id(team_id, "home", "WIN")
  # end
  #
  # def percentage_visitor_wins(team_id)
  #   games_by_team_id(team_id, "away", "WIN")
  # end
  #
  # def percentage_ties(team_id)
  #   games_by_team_id(team_id, "away", "TIE")
  # end
  #
  # def count_of_games_by_season
  #   season_count = Hash.new(0)
  #   @game_data.each { |game| season_count[game.season] += 1 }
  #   season_count
  # end
  #
  # def average_goals_per_game
  #   game_number = 0
  #   goal_total = 0
  #   @game_data.each do |game|
  #     game_number += 1
  #     goal_total += game.away_goals + game.home_goals
  #   end
  #   (goal_total / game_number.to_f).round(2)
  # end
  #
  # def average_goals_by_season
  #   season_average = Hash.new{|h,k| h[k] = []}
  #   require "pry"; binding.pry
  #   @game_data.each { |game| season_average[game.season] << (game.away_goals + game.home_goals) }
  #   season_average.each { |key, value| season_average[key] = (value.sum.to_f / value.length).round(2) }
  # end

end
