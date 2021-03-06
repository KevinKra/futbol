require 'csv'

class Team
  @@team_data = []

  attr_reader :team_id,
              :franchise_id,
              :team_name,
              :abbreviation,
              :stadium,
              :link

  def initialize(team_data)
    @team_id = team_data[:team_id]
    @franchise_id = team_data[:franchiseid]
    @team_name = team_data[:teamname]
    @abbreviation = team_data[:abbreviation]
    @stadium = team_data[:stadium]
    @link = team_data[:link]
  end

  def self.assign_team_data(data)
    @@team_data = data
  end

  def self.team_data
    @@team_data
  end

  def self.parse_csv_data(file_path)
    output = []
    CSV.foreach(file_path, headers: :true, header_converters: :symbol) do |csv_row|
      output << Team.new(csv_row)
    end
    self.assign_team_data(output)
  end

  def self.count_of_teams
    @@team_data.length
  end

  def self.lookup_team_name(team_id)
    @@team_data.find { |team| team.team_id == team_id }.team_name
  end

  def self.team_info(team_id)
    team = @@team_data.find {|team| team.team_id == team_id}
    {
      "team_id" => team.team_id, 
      "franchise_id" => team.franchise_id, 
      "team_name" => team.team_name, 
      "abbreviation" => team.abbreviation, 
      "link" => team.link
    }
  end
end
