require_relative './test_helper'
require_relative "../lib/team.rb"

class TeamTest < Minitest::Test
  def setup
    mock_team_data = {
      team_id: 3,
      franchiseId: 23,
      teamName: "ATL United",
      abbreviation: "ATL",
      Stadium: "Mercedes-Benz Stadium",
      link: "/api/v1/teams/1"
    }
    @team = Team.new(mock_team_data)
  end

  def test_it_exists
    assert_instance_of Team, @team
  end
end
