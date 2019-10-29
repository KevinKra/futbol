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
    assert_equal "16", Game.opponent_goals_average
  end

  def test_it_determines_highest_average_opponent_goals
    assert_equal "20", Game.opponent_goals_average(false)
  end

  def test_it_determines_biggest_loss_for_the_team
    assert_equal 3, Game.worst_loss("3")
  end
end
