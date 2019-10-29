require 'csv'
require_relative './test_helper'
require_relative "../lib/team.rb"

class TeamTest < Minitest::Test
  def setup
    mock_teams = "./data/mock_data/mock_teams.csv"
    @teams = Team.parse_csv_data(mock_teams)
    @team = Team.team_data[0]
  end

  def test_it_exists
    assert_instance_of Team, @teams[0]
  end

  def test_lookup_team_name
    assert_equal "Houston Dynamo", Team.lookup_team_name("3")
  end

  def test_it_can_count_the_amount_of_teams
    assert_equal 29, Team.count_of_teams
  end

  def test_it_can_return_a_hash_of_team_info
    expected = {"team_id"=>"1", 
      "franchise_id"=>"23", 
      "team_name"=>"Atlanta United", 
      "abbreviation"=>"ATL",
      "link"=>"/api/v1/teams/1"}

    assert_equal expected, Team.team_info("1")
  end
end
