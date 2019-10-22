require './lib/stat_tracker'

game_path = './data/games.csv'
team_path = './data/teams.csv'
results_path = './data/results.csv'

locations = {
  games: game_path,
  teams: team_path,
  results: results_path
}

stat_tracker = StatTracker.from_csv(locations)

require 'pry'; binding.pry
