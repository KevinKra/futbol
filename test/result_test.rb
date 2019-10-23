require_relative './test_helper'
require './lib/game'
require_relative "../lib/result.rb"

class ResultTest < Minitest::Test
  def setup
    mock_result_data = {
      game_id: 2012030221,
      team_id: 3,
      HoA: "home",
      result: "LOSS",
      settled_in: "OT",
      head_coach: "John Tortorella",
      goals: 2,
      shots: 3,
      tackles: 44,
      pim: 8,
      powerPlayOpportunities: 12,
      powerPlayGoals: 31,
      faceOffWinPercentage: 4.2,
      giveaways: 9,
      takeaways: 2
    }
    @result = Result.new(mock_result_data)
  end

  def test_it_exists
    assert_instance_of Result, @result
  end
end
