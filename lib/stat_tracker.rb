require 'csv'
require_relative './game'
require_relative './team'
require_relative './result'

class StatTracker
  def self.from_csv(location_paths)
    result_data = Result.parse_csv_data(location_paths[:results])
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

  def percentage_home_wins(team_id)
    Result.games_by_team_id(team_id, "home", "WIN")
  end

  def percentage_visitor_wins(team_id)
    Result.games_by_team_id(team_id, "away", "WIN")
  end

  def percentage_ties(team_id)
    Result.games_by_team_id(team_id, "away", "TIE")
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
    Result.find_best_offense
  end

  def worst_offense
    Result.find_best_offense(false)
  end
end
