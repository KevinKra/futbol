require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/result.rb"
require_relative "../lib/stat_tracker.rb"

class ResultTest < Minitest::Test
  def setup
    mock_results = "./data/mock_data/mock_results.csv"
    @results = Result.parse_csv_data(mock_results)
  end

  def test_it_exists
    assert_instance_of Result, Result.result_data[0]
  end

  def test_it_has_the_correct_data_amount
    total_data = Result.result_data
    assert_equal 7, total_data.length
  end

  def test_that_games_by_team_id_works_correctly
    assert_equal 66.67, Result.games_by_team_id(6, "home", "WIN")
    assert_equal 100, Result.games_by_team_id(6, "away", "WIN")
    assert_equal 33.33, Result.games_by_team_id(3, "away", "TIE")
  end

  def test_average_scores_by_type
    assert_equal 2.0, Result.average_scores("away").values[0][:average_goals]
  end

  def test_highest_scoring_visitor
    assert_equal "3", Result.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "6", Result.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    assert_equal "6", Result.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    assert_equal "6", Result.lowest_scoring_home_team
  end
  
  def test_it_can_determine_the_team_with_most_goals_across_all_seasons
    assert_equal "3", Result.find_best_offense
  end

  def test_it_can_determine_the_team_with_least_goals_across_all_seasons
    assert_equal "6", Result.find_best_offense(false)
  end

end
