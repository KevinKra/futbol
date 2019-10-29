require 'csv'

class Game
  @@game_data = []

  attr_reader :game_id, :season, :type, :date_time, :away_team_id, :home_team_id, :away_goals, :home_goals, :venue, :venue_link
  def initialize(game_data)
    @game_id = game_data[:game_id]
    @season = game_data[:season]
    @type = game_data[:type]
    @date_time = game_data[:date_time]
    @away_team_id = game_data[:away_team_id]
    @home_team_id = game_data[:home_team_id]
    @away_goals = game_data[:away_goals].to_i
    @home_goals = game_data[:home_goals].to_i
    @venue = game_data[:venue]
    @venue_link = game_data[:venue_link]
  end

  def self.assign_game_data(data)
    @@game_data = data
  end

  def self.game_data
    @@game_data
  end

  def self.parse_csv_data(file_path)
    output = []
    CSV.foreach(file_path, headers: :true, header_converters: :symbol) do |csv_row|
      output << Game.new(csv_row)
    end
    self.assign_game_data(output)
  end

  # Helper method to sum total score by game -> Returns array of Integers
  def self.total_scores
    @@game_data.map { |game| game.away_goals + game.home_goals }
  end

  # Highest sum of the winning and losing teams’ scores	-> returns Integer
  def self.highest_total_score
    self.total_scores.max_by { |score| score }
  end

# Lowest sum of the winning and losing teams’ scores -> returns Integer
  def self.lowest_total_score
    self.total_scores.min_by { |score| score }
  end

  # Helper method to get score differences of all games -> Returns array of Integers
  def self.score_difference
    @@game_data.map { |game| (game.away_goals - game.home_goals).abs}
  end

  # Highest difference between winner and loser	-> returns Integer
  def self.biggest_blowout
    self.score_difference.max_by { |difference| difference }
  end

  def self.count_of_games_by_season # iteration-2-darren
    season_count = Hash.new(0)
    @@game_data.each { |game| season_count[game.season] += 1 }
    season_count
  end

  def self.average_goals_per_game # iteration-2-darren
    (@@game_data.reduce(0) { |acc, game| acc + game.away_goals + game.home_goals } / @@game_data.count.to_f).round(2)
  end

  def self.average_goals_by_season # iteration-2-darren
    season_average = Hash.new{|h,k| h[k] = []}
    @@game_data.each { |game| season_average[game.season] << (game.away_goals + game.home_goals) }
    season_average.each { |key, value| season_average[key] = (value.sum.to_f / value.length).round(2) }
  end

  def self.opponent_goals_average(lowest = true)
    team_average =  Hash[@@game_data.map { |game| [game.home_team_id, []]}]
    @@game_data.each { |game| team_average[game.home_team_id] << game.away_goals}
    team_average.each { |key, value| team_average[key] = (value.sum.to_f / value.length).round(2) }
    lowest ? team_average.min_by { |team, avg_opponent_goals| avg_opponent_goals}[0] : team_average.max_by { |team, avg_opponent_goals| avg_opponent_goals}[0]
  end

  # Helper method to get all opponents by team with win percentages
  # -> Returns nested Hash
  def self.opponents_by_team(team_id)
    fav_opponent = Hash.new{ |hash,k| hash[k] = Hash.new(0) }
    all_games = @@game_data.find_all { |game| game.home_team_id == team_id || game.away_team_id == team_id }
    all_games.each do |game|
      opponent_id = get_opponent(team_id, game.home_team_id, game.away_team_id)
      hoa = home_or_away(team_id, game.home_team_id, game.away_team_id)
      home_away_goals = home_goals_away_goals(hoa, game.home_goals, game.away_goals)
      home_goals = home_away_goals[0]
      away_goals = home_away_goals[1]
      fav_opponent[opponent_id][:num_games] += 1
      fav_opponent[opponent_id][:num_wins] += 1 if home_goals > away_goals
      fav_opponent[opponent_id][:win_pct] = (fav_opponent[opponent_id][:num_wins] / fav_opponent[opponent_id][:num_games].to_f).round(2)
    end
    fav_opponent
  end

  # Name of the opponent that has the lowest win percentage against
  # the given team. -> Returns String
  def self.favorite_opponent(team_id)
    all_opponents = self.opponents_by_team(team_id)
    all_opponents.max_by { |key, value| value[:win_pct] }[0]
  end
  # Name of the opponent that has the highest win percentage against
  # the given team. -> Returns String
  def self.rival(team_id)
    all_opponents = self.opponents_by_team(team_id)
    all_opponents.min_by { |key, value| value[:win_pct] }[0]
  end

  # Helper method to get correct opponent ids from game_data
  def self.get_opponent(team_id, home_team_id, away_team_id)
    if home_team_id == team_id
      opponent_id = away_team_id
    elsif away_team_id == team_id
      opponent_id = home_team_id
    end
  end

  def self.home_or_away(team_id, home_team_id, away_team_id) # iteration-4-darren seasonal_summary helper
    return 'home' if team_id == home_team_id
    return 'away' if team_id == away_team_id
  end

  def self.home_goals_away_goals(hoa, home_goals, away_goals) # iteration-4-darren seasonal_summary helper
    return [home_goals, away_goals] if hoa == 'home'
    return [away_goals, home_goals] if hoa == 'away'
  end

end
