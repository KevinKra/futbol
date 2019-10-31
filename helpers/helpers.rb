module Helpers

  def find_team_name(id, teams)
    matching_team = teams.find { |team| team.team_id == id}
    matching_team.team_name
  end

end
