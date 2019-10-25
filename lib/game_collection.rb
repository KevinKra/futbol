class GameCollection

  attr_reader :game_data

  def initialize(game_data)
    @game_data = create_games(game_data)
  end

  def length
    @game_data.length
  end

  def create_games(game_data)
    csv = CSV.foreach(game_data, headers:true, header_converters: :symbol)
    csv.map { |row| Game.new(row) }
  end

  def highest_total_score
    max_sum = 0
    @game_data.each do |game|
      sum = game.away_goals + game.home_goals
      if sum > max_sum
        max_sum = sum
      end
    end
    max_sum
  end

  def lowest_total_score
    min_sum = 0
    @game_data.each do |game|
      sum = game.away_goals.to_i + game.home_goals.to_i
      if sum < min_sum
        min_sum = sum
      end
    end
    min_sum
  end

  def biggest_blowout
    highest_difference = 0
    @game_data.each do |game|
      difference = (game.away_goals.to_i - game.home_goals.to_i).abs
      if difference > highest_difference
        highest_difference = difference
      end
    end
    highest_difference
  end
end
