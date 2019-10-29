require 'csv'
require_relative './game'
require_relative './team'
require_relative './result'
require_relative '../helpers/helpers.rb'

class StatTracker
  include Helpers
  def self.from_csv(location_paths)
    result_data = Result.parse_csv_data(location_paths[:game_teams])
    game_data = Game.parse_csv_data(location_paths[:games])
    team_data = Team.parse_csv_data(location_paths[:teams])
    StatTracker.new
  end

  def highest_total_score
    Game.highest_total_score
  end

  def lowest_total_score
    Game.lowest_total_score
  end

  def biggest_blowout
    Game.biggest_blowout
  end

  def percentage_home_wins
    Result.global_result_percentages("home", "WIN")
  end

  def percentage_visitor_wins
    Result.global_result_percentages("away", "WIN")
  end

  def percentage_ties
    Result.global_result_percentages("away", "TIE")
  end

  def count_of_games_by_season
    Game.count_of_games_by_season
  end

  def average_goals_per_game
    Game.average_goals_per_game
  end

  def average_goals_by_season
    Game.average_goals_by_season
  end

  def count_of_teams
    Team.count_of_teams
  end

  def best_offense
    find_team_name(Result.find_best_offense, Team.team_data)
  end

  def worst_offense
    find_team_name(Result.find_best_offense(false), Team.team_data)
  end

  def best_defense
    find_team_name(Game.opponent_goals_average, Team.team_data)
  end

  def worst_defense
    find_team_name(Game.opponent_goals_average(false), Team.team_data)
    # Game.opponent_goals_average(false)
  end

  def best_season(team_id)
    Game.season_outcome(team_id)
  end

  def worst_season(team_id)
    Game.season_outcome(team_id, true)
  end

  def lowest_scoring_visitor
    find_team_name(Result.lowest_scoring_visitor, Team.team_data)
  end

  def highest_scoring_visitor
    find_team_name(Result.highest_scoring_visitor, Team.team_data)
  end

  def highest_scoring_home_team
    find_team_name(Result.highest_scoring_home_team, Team.team_data)
  end

  def winningest_team
    find_team_name(Result.winningest_team, Team.team_data)
  end

  def lowest_scoring_home_team
    find_team_name(Result.lowest_scoring_home_team, Team.team_data)
  end

  def team_info(team_id)
    Team.team_info(team_id)
  end

  def average_win_percentage(team_id)
    Game.average_win_percentage(team_id)
  end
end
