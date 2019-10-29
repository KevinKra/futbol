require_relative './stat_tracker'

game_path = './data/games.csv'
team_path = './data/teams.csv'
result_path = './data/game_teams.csv'

locations = {
  games: game_path,
  teams: team_path,
  game_teams: result_path
}

stat_tracker = StatTracker.from_csv(locations)

require 'pry'; binding.pry
