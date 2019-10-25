require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/result.rb"
require_relative "../lib/stat_tracker.rb"
# require_relative "../data/mock_data/mock_results.csv"

class ResultTest < Minitest::Test
  def setup
    mock_results = "./data/mock_data/mock_results.csv"
    @results = Result.parse_csv_data(mock_results)
  end

  def test_it_exists
    assert_instance_of Result, Result.class_result_data[0]
  end

  def test_that_games_by_team_id_works_correctly
    assert_equal 66.67, Result.games_by_team_id(6, "home", "WIN")
    assert_equal 100, Result.games_by_team_id(6, "away", "WIN")
    assert_equal 33.33, Result.games_by_team_id(3, "away", "TIE")
  end

end
