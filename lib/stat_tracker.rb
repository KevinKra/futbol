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

  def percentage_home_wins #iteration-2-kevin
    Result.global_result_percentages("home", "WIN")
  end

  def percentage_visitor_wins #iteration-2-kevin
    Result.global_result_percentages("away", "WIN")
  end

  def percentage_ties #iteration-2-kevin
    Result.global_result_percentages("away", "TIE")
  end
  
  def count_of_teams #iteration-2-kevin
    Team.count_of_teams
  end

  def count_of_games_by_season #iteration-2-darren
    Game.count_of_games_by_season
  end

  def average_goals_per_game #iteration-2-darren
    Game.average_goals_per_game
  end

  def average_goals_by_season #iteration-2-darren
    Game.average_goals_by_season
  end

  def best_offense #iteration-3-kevin
    find_team_name(Result.find_best_offense, Team.team_data)
  end

  def worst_offense #iteration-3-kevin
    find_team_name(Result.find_best_offense(false), Team.team_data)
  end

  def best_defense #iteration-3-kevin
    find_team_name(Game.opponent_goals_average, Team.team_data)
  end

  def worst_defense #iteration-3-kevin
    find_team_name(Game.opponent_goals_average(false), Team.team_data)
  end

  def lowest_scoring_visitor #iteration-3-melissa
    find_team_name(Result.lowest_scoring_visitor, Team.team_data)
  end

  def highest_scoring_visitor #iteration-3-melissa
    find_team_name(Result.highest_scoring_visitor, Team.team_data)
  end

  def highest_scoring_home_team #iteration-3-melissa
    find_team_name(Result.highest_scoring_home_team, Team.team_data)
  end

  def winningest_team #iteration-3-darren
    find_team_name(Result.winningest_team, Team.team_data)
  end

  def lowest_scoring_home_team #iteration-3-melissa
    find_team_name(Result.lowest_scoring_home_team, Team.team_data)
  end
    
  def best_season(team_id) #iteration-4-kevin
    Game.season_outcome(team_id)
  end

  def worst_season(team_id) #iteration-4-kevin
    Game.season_outcome(team_id, true)
  end

  def team_info(team_id) #iteration-4-kevin
    Team.team_info(team_id)
  end

  def average_win_percentage(team_id) #iteration-4-kevin
    Game.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id) #iteration-4-melissa
     Result.all_goals_scored(team_id).max_by { |key, value| value }[1]
    end

  def fewest_goals_scored(team_id) #iteration-4-melissa
    Result.all_goals_scored(team_id).min_by { |key, value| value }[1]
  end
  
  def favorite_opponent(team_id) #iteration-4-melissa
    find_team_name(Game.favorite_opponent(team_id), Team.team_data)
  end

  def rival(team_id) #iteration-4-melissa
    find_team_name(Game.rival(team_id), Team.team_data)
  end
 

end
