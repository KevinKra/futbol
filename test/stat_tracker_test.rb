require_relative './test_helper'
require_relative '../lib/stat_tracker.rb'
require_relative "../lib/game.rb"
require_relative "../lib/result.rb"

class StatTrackerTest < Minitest::Test
  def setup
    result_path = './data/mock_data/mock_results.csv'
    game_path = './data/mock_data/mock_games.csv'
    team_path = './data/mock_data/mock_teams.csv'
    @stat_tracker = StatTracker.new
    @games = Game.parse_csv_data(game_path)
    @results = Result.parse_csv_data(result_path)
    @teams = Team.parse_csv_data(team_path)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  # def test_initialized
  #   assert_equal 32, @stat_tracker.team_data.length
  #   assert_equal 7, @stat_tracker.result_data.length
  #   assert_equal 7441, @stat_tracker.game_data.length
  # end

  def test_highest_total_score
    assert_equal 7, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 2, @stat_tracker.lowest_total_score
  end

  def test_biggest_blowout
    assert_equal 3, @stat_tracker.biggest_blowout
  end

  def test_it_can_return_a_percentage_of_home_games_won
    assert_equal 100.0, @stat_tracker.percentage_home_wins(6)
  end

  def test_it_can_return_a_percentage_of_away_games_won
    assert_equal 100, @stat_tracker.percentage_visitor_wins(6)
  end

  def test_it_can_return_a_percentage_of_games_tied
    assert_equal 0.0, @stat_tracker.percentage_ties(3)
  end

  def test_count_of_games_by_season  # iteration-2-darren
    games_by_season = {
      '20122013' =>	5,
      '20142015' =>	6,
      '20152016' =>	6,
      '20162017' =>	4,
    }
    assert_equal games_by_season, @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game  # iteration-2-darren
    assert_equal 4.24, @stat_tracker.average_goals_per_game
  end

  def test_average_goals_by_season  # iteration-2-darren
    average_goals_by_season = {
      '20122013' =>	4.2,
      '20142015' =>	3.5,
      '20152016' =>	4.67,
      '20162017' =>	4.75,
    }
    assert_equal average_goals_by_season, @stat_tracker.average_goals_by_season
  end

  def test_it_can_count_the_number_of_teams
    assert_equal 29, @stat_tracker.count_of_teams
  end

  def test_it_can_determine_the_team_with_most_goals_across_all_seasons
    assert_equal "FC Dallas", @stat_tracker.best_offense
  end

  def test_it_can_determine_the_team_with_least_goals_across_all_seasons
    assert_equal "Sporting Kansas City", @stat_tracker.worst_offense
  end

  def test_it_can_find_the_best_defense
    assert_equal "New England Revolution", @stat_tracker.best_defense
  end

  def test_it_can_find_the_best_defense
    assert_equal "Toronto FC", @stat_tracker.worst_defense
  end

  def test_highest_scoring_visitor
    assert_equal "FC Dallas", @stat_tracker.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "FC Dallas", @stat_tracker.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    assert_equal "Sporting Kansas City", @stat_tracker.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    assert_equal "Portland Timbers", @stat_tracker.lowest_scoring_home_team
  end

  def test_winningest_team # iteration-3-darren
    assert_equal 'FC Dallas', @stat_tracker.winningest_team
  end

  def test_best_fans # iteration-3-darren
    assert_equal "New England Revolution", @stat_tracker.best_fans
  end

  def test_worst_fans # iteration-3-darren
    assert_equal ['Portland Timbers'], @stat_tracker.worst_fans
  end

  def test_biggest_team_blowout # iteration-4-darren
    assert_equal 1, @stat_tracker.biggest_team_blowout('5')
  end

  def test_worst_loss # iteration-4-darren
    assert_equal 1, @stat_tracker.worst_loss('14')
  end

  def test_head_to_head # iteration-4-darren
    assert_equal ({"New England Revolution"=>0.0}), @stat_tracker.head_to_head('14')
  end

  def test_seasonal_summary # iteration-4-darren
    seasonal = {"20142015"=>{:postseason=>{:nr_games_played=>3, :total_goals_scored=>4, :total_goals_against=>7, :average_goals_scored=>1.33, :average_goals_against=>2.33, :win_percentage=>0.0}}}
    assert_equal seasonal, @stat_tracker.seasonal_summary('14')
  end

end
