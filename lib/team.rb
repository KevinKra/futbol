class Team

  def initialize(team_data)
    @team_id = team_data[:team_id]
    @franchise_id = team_data[:franchise_id]
    @team_name = team_data[:team_name]
    @abbreviation = team_data[:abbreviation]
    @stadium = team_data[:stadium]
    @link = team_data[:link]
  end
end
