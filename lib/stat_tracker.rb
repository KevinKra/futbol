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

  def highest_total_score #iteration-2-melissa
    Game.highest_total_score
  end

  def lowest_total_score #iteration-2-melissa
    Game.lowest_total_score
  end

  def biggest_blowout #iteration-2-melissa
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
  end

  def highest_scoring_visitor #iteration-3-melissa
    highest_average = Result.highest_scoring_visitor
    Team.lookup_team_name(highest_average)
  end

  def highest_scoring_home_team #iteration-3-melissa
    highest_average = Result.highest_scoring_home_team
    Team.lookup_team_name(highest_average)
  end

  def lowest_scoring_visitor #iteration-3-melissa
    lowest_average = Result.lowest_scoring_visitor
    Team.lookup_team_name(lowest_average)
  end

  def lowest_scoring_home_team #iteration-3-melissa
    lowest_average = Result.lowest_scoring_home_team
    Team.lookup_team_name(lowest_average)
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

  def most_goals_scored(team_id) #iteration-4-melissa
     Result.all_goals_scored(team_id).max_by { |key, value| value }[1]
    end

  def fewest_goals_scored(team_id) #iteration-4-melissa
    Result.all_goals_scored(team_id).min_by { |key, value| value }[1]
  end

  def favorite_opponent(team_id) #iteration-4-melissa
    fav_opponent = Game.favorite_opponent(team_id)
    Team.lookup_team_name(fav_opponent)
  end

  def rival(team_id) #iteration-4-melissa
    rival_opponent = Game.rival(team_id)
    Team.lookup_team_name(rival_opponent)
  end

end
