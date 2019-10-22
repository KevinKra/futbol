require './lib/stat_tracker'

game_path = './data/games.csv'
team_path = './data/teams.csv'
game_teams_path = './data/game_results.csv'

locations = {
  games: game_path,
  teams: team_path,
  results: results_path
}

stat_tracker = StatTracker.from_csv(locations)

require 'pry'; binding.pry
