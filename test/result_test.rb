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
    assert_equal 33, total_data.length
  end

  def test_global_result_percentages
    assert_equal 0.5, Result.global_result_percentages("home", "WIN")
    assert_equal 0.47, Result.global_result_percentages("away", "WIN")
    assert_equal 0.06, Result.global_result_percentages("away", "TIE")
  end

  def test_average_scores_by_type
    assert_equal 1.67, Result.average_scores("away").values[0][:average_goals]
  end

  def test_highest_scoring_visitor
    assert_equal "6", Result.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "26", Result.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    assert_equal "5", Result.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    assert_equal "15", Result.lowest_scoring_home_team
  end

  def test_it_can_determine_the_team_with_most_goals_across_all_seasons
    assert_equal "6", Result.find_best_offense
  end

  def test_it_can_determine_the_team_with_least_goals_across_all_seasons
    assert_equal "5", Result.find_best_offense(false)
  end

  def test_it_can_get_all_goals_scored_by_team
    assert_equal 9, Result.all_goals_scored("6").length
    assert_equal ["2012030221", 3], Result.all_goals_scored("6").first
  end

  def test_most_goals_scored_for_particular_team
    assert_equal 4, Result.most_goals_scored("6")
  end

  def test_least_goals_scored_for_particular_team
    assert_equal 1, Result.fewest_goals_scored("6")
  end

  def test_most_accurate_team
    season_games = ["2012030221",
                    "2012030222",
                    "2012030223",
                    "2012030224",
                    "2012030225",
                    "2012030311",
                    "2012030312"]

    assert_equal "6", Result.most_accurate_team(season_games)
  end

  def test_least_accurate_team
    season_games = ["2012030221",
                    "2012030222",
                    "2012030223",
                    "2012030224",
                    "2012030225",
                    "2012030311",
                    "2012030312"]

    assert_equal "5", Result.least_accurate_team(season_games)
  end

  def test_most_tackles
    season_games = ["2012030221",
                    "2012030222",
                    "2012030223",
                    "2012030224",
                    "2012030225",
                    "2012030311",
                    "2012030312"]

    assert_equal "6", Result.most_tackles(season_games)
  end

  def test_fewest_tackles
    season_games = ["2012030221",
                    "2012030222",
                    "2012030223",
                    "2012030224",
                    "2012030225",
                    "2012030311",
                    "2012030312"]

    assert_equal "5", Result.fewest_tackles(season_games)
  end

end
