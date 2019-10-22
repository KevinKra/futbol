class StatTracker

  def initialize(game_path, team_path, results_path)

  end

  def self.from_csv(input_hash)
    game_path = input_hash[:games]
    team_path = input_hash[:teams]
    results_path = input_hash[:results]
    self.new(game_path, team_path, results_path)
  end
end
