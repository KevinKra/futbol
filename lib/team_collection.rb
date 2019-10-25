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
    csv = CSV.foreach(team_data, headers:true, header_converters: :symbol)
    csv.map { |row| Team.new(row) }
  end
end
