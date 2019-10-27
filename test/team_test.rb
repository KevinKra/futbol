require 'CSV'
require_relative './test_helper'
require_relative "../lib/team.rb"

class TeamTest < Minitest::Test
  def setup
    mock_teams = "./data/mock_data/mock_teams.csv"
    @teams = Team.parse_csv_data(mock_teams)
  end

  def test_it_exists
    assert_instance_of Team, @teams[0]
  end

  def test_lookup_team_name
    assert_equal "Houston Dynamo", Team.lookup_team_name("3")
  end
end
