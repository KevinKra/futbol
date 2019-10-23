require_relative './test_helper'
require_relative '../lib/stat_tracker.rb'

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    result_path = './data/results.csv'
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
    assert_equal 14882, @stat_tracker.result_data.length
    assert_equal 7441, @stat_tracker.game_data.length
  end

end
