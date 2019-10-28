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

  def count_of_games_by_season # iteration-2-darren
    Game.count_of_games_by_season
  end

  def average_goals_per_game # iteration-2-darren
    Game.average_goals_per_game
  end

  def average_goals_by_season # iteration-2-darren
    Game.average_goals_by_season
  end

  def winningest_team # iteration-3-darren
    id_best_team = Result.winningest_team
    Team.lookup_team_name(id_best_team)
  end

  def best_fans # iteration-3-darren
    best_fan_team_id = Result.best_worst_fans.max_by { |key, value| value[:diff_home_away_win_pct] }[0]
    team_name = Team.lookup_team_name(best_fan_team_id)
  end

  def worst_fans # iteration-3-darren
    team_ids = Result.best_worst_fans.keep_if { |key, value| value[:diff_home_away_win_pct] < 0 }.keys
    team_names = team_ids.map { |team_id| Team.lookup_team_name(team_id) }
  end

end
