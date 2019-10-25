require_relative './test_helper'
require_relative '../lib/stat_tracker.rb'

class StatTrackerTest < Minitest::Test
  def setup
    result_path = './data/mock_data/mock_results.csv'
    locations = {
      result: result_path
    }
    @stat_tracker = StatTracker.new
    @results = Result.parse_csv_data(result_path)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  # def test_it_exists
  #   assert_instance_of StatTracker, @stat_tracker
  # end

  # def test_initialized
  #   assert_equal 32, @stat_tracker.team_data.length
  #   assert_equal 7, @stat_tracker.result_data.length
  #   assert_equal 7441, @stat_tracker.game_data.length
  # end

  # def test_highest_total_score
  #   assert_equal 11, @stat_tracker.highest_total_score
  # end

  # def test_lowest_total_score
  #   assert_equal 0, @stat_tracker.lowest_total_score
  # end

  # def test_biggest_blowout
  #   assert_equal 8, @stat_tracker.biggest_blowout
  # end
  
  def test_it_can_return_a_percentage_of_home_games_won
    assert_equal 66.67, @stat_tracker.percentage_home_wins(6)
  end 

  def test_it_can_return_a_percentage_of_away_games_won
    assert_equal 100, @stat_tracker.percentage_visitor_wins(6)
  end

  # def test_it_can_return_a_percentage_of_games_tied
  #   assert_equal 33.33, @stat_tracker.percentage_ties(3)
  # end

  # def test_count_of_games_by_season
  #   games_by_season = {
  #     '20122013' =>	806,
  #     '20132014' =>	1323,
  #     '20142015' =>	1319,
  #     '20152016' =>	1321,
  #     '20162017' =>	1317,
  #     '20172018' =>	1355
  #   }
  #   assert_equal games_by_season, @stat_tracker.count_of_games_by_season
  # end

  # def test_average_goals_per_game
  #   assert_equal 4.22, @stat_tracker.average_goals_per_game
  # end

  # def test_average_goals_by_season    
  #   average_goals_by_season = {
  #     '20122013' =>	4.12,
  #     '20132014' =>	4.19,
  #     '20142015' =>	4.14,
  #     '20152016' =>	4.16,
  #     '20162017' =>	4.23,
  #     '20172018' =>	4.44
  #   }
  #   assert_equal average_goals_by_season, @stat_tracker.average_goals_by_season
  # end

end
