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

  def test_it_determine_lowest_average_opponent_goals
    assert_equal "16", Game.opponent_goals_average
  end

  def test_it_determine_highest_average_opponent_goals
    assert_equal "16", Game.opponent_goals_average(false)
  end
end
