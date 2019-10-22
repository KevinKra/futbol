class Result

  def initialize(result_data)
    @game_id = result_data[:game_id]
    @team_id = result_data[:team_id]
    @hoa = result_data[:hoa]
    @result = result_data[:result]
    @settled_in = result_data[:settled_in]
    @head_coach = result_data[:head_coach]
    @goals = result_data[:goals]
    @shots = result_data[:shots]
    @tackles = result_data[:tackles]
    @pim = result_data[:pim]
    @ppo = result_data[:ppo]
    @ppg = result_data[:ppg]
    @fowp = result_data[:fowp]
    @giveaways = result_data[:giveaways]
    @takeaways = result_data[:takeaways]
  end
end
