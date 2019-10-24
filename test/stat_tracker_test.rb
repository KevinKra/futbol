require_relative './test_helper'
require_relative '../lib/stat_tracker.rb'

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    result_path = './data/mock_data/mock_results.csv'
    locations = {
      games: game_path,
      teams: team_path,
      result: result_path
    }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_initialized
    assert_equal 32, @stat_tracker.team_data.length
    assert_equal 7, @stat_tracker.result_data.length
    assert_equal 7441, @stat_tracker.game_data.length
  end

  def test_it_can_return_a_percentage_of_home_games_won
    assert_equal 66.67, @stat_tracker.team_games_percentages(6)

  end 

  def test_it_can_return_a_percentage_of_away_games_won
    assert_equal 100, @stat_tracker.team_games_percentages(6, "away")
  end

  def test_it_can_return_a_percentage_of_games_tied
    assert_equal 33.33, @stat_tracker.team_games_percentages(3, "away", "TIE")
  end

end
