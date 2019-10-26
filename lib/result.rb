class Result
  @@result_data = []

  attr_reader :team_id, :hoa, :result, :goals
  def initialize(result_data)
    @game_id = result_data[:game_id] 
    @team_id = result_data[:team_id]
    @hoa = result_data[:hoa]
    @result = result_data[:result]
    @settled_in = result_data[:settled_in]
    @head_coach = result_data[:head_coach]
    @goals = result_data[:goals].to_i
    @shots = result_data[:shots]
    @tackles = result_data[:tackles]
    @pim = result_data[:pim]
    @ppo = result_data[:powerplayopportunities]
    @ppg = result_data[:powerplaygoals]
    @fowp = result_data[:faceoffwinpercentage]
    @giveaways = result_data[:giveaways]
    @takeaways = result_data[:takeaways]
  end

  def self.assign_result_data(data)
    @@result_data = data
  end

  def self.result_data
    @@result_data
  end

  def self.parse_csv_data(file_path)
    output = []
    CSV.foreach(file_path, headers: :true, header_converters: :symbol) do |csv_row|
      output << Result.new(csv_row)
    end
    self.assign_result_data(output)
  end

  def self.games_by_team_id(team_id, format, seek_result)
    # team_id, format ("home", "away"), seek_result ("WIN", "LOSE", "TIE") 
    all_matching_games = @@result_data.select do |game| 
      game.team_id == team_id.to_s && game.hoa == format
    end
    matching_results = all_matching_games.select do |game| 
      game.result == seek_result
    end.length
    outcome_percentage = (matching_results.to_f / all_matching_games.length) * 100
    outcome_percentage.round(2)
  end

  def self.find_best_offense(average = true)
    teams = Hash[@@result_data.map { |result| [result.team_id, []]}]
    @@result_data.each { |result| teams[result.team_id] << result.goals}
    teams.each { |key, value| teams[key] = (value.sum.to_f / value.length).round(2) }
    average ? teams.max_by {|team, goals_average| goals_average}[0] : teams.min_by {|team, goals_average| goals_average}[0]
  end
end