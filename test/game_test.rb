require_relative './test_helper'
require './lib/game'

class GameTest < Minitest::Test

  def setup
    mock_games = "./data/mock_data/mock_games.csv"
    @games = Game.parse_csv_data(mock_games)
    @game = Game.game_data[0]
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_initializes
    assert_equal "2012030321", @game.game_id
    assert_equal "Postseason", @game.type
  end

  def test_total_scores
    assert_equal 3, Game.total_scores[0]
  end

  def test_highest_total_score
    assert_equal 7, Game.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 2, Game.lowest_total_score
  end

  def test_score_difference
    assert_equal 1, Game.score_difference[0]
  end

  def test_biggest_blowout
    assert_equal 3, Game.biggest_blowout
  end

  def test_it_determines_lowest_average_opponent_goals
    assert_equal "5", Game.opponent_goals_average
  end

  def test_it_determines_highest_average_opponent_goals
    assert_equal "20", Game.opponent_goals_average(false)
  end

  def test_it_can_find_a_teams_best_and_worst_season
    assert_equal "20142015", Game.season_outcome("16")
    assert_equal "20122013", Game.season_outcome("16", true)
  end

  def test_it_can_find_the_average_win_percentage_per_team
    assert_equal 0.62, Game.average_win_percentage("16")
    assert_equal 0, Game.average_win_percentage("3")
  end

  def test_it_can_get_all_opponents_of_given_team
    assert_equal 2, Game.opponents_by_team("16").count
  end

  def test_favorite_opponent_for_particular_team
    assert_equal "14", Game.favorite_opponent("16")
  end

  def test_rival_for_particular_team
    assert_equal "26", Game.rival("16")
  end

  def test_get_opponent_for_particular_team
    assert_equal "26", Game.get_opponent("16", "26", "16")
  end

  def test_games_by_season #iteration-5-melissa
    assert_equal 7, Game.games_by_season("20122013").count
  end

end
