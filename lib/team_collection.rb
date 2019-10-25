require 'CSV'

class TeamCollection

  attr_reader :team_data

  def initialize(team_data)
    @team_data = create_teams(team_data)
  end

  def length
    @team_data.length
  end

  def create_teams(team_data)
    teams = []
    CSV.foreach(team_data, headers:true, header_converters: :symbol) do |row|
      teams << Team.new(row)
    end
    teams
  end
end
