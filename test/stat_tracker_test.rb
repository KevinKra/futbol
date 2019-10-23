# require_relative './test_helper'
# require 'csv'
# require_relative '../lib/stat_tracker.rb'
# require_relative '../lib/game_collection'
# require_relative '../lib/game'
# require_relative '../lib/team_collection'
# require_relative '../lib/team'
# require_relative '../lib/result_collection'
# require_relative '../lib/result'



# class StatTrackerTest < Minitest::Test
#   def setup
#     game_path = "./mock_data/mock_games.csv"
#     team_path = "./mock_data/mock_teams.csv"
#     result_path = "./mock_data/mock_results.csv"
#     locations = {
#       games: game_path,
#       teams: team_path,
#       result: result_path
#     }
#     @stat_tracker = StatTracker.from_csv(locations)
#   end

#   def test_it_exists
#     assert_equal [], @stat_tracker
#   end

#   # def test_it_parses_csv_data_from_given_paths

#   # end

#   # def test_it_parses_csv_data_correctly
#   #   # mock_results = [{}]
#   #   assert_equal [], @stat_tracker.parse_csv_data()
#   # end
# end
