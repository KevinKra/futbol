class Result

  attr_reader :result,
              :team_id,
              :hoa,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles,
              :pim,
              :ppo,
              :ppg,
              :fowp,
              :giveaways,
              :takeaways

  def initialize(result_data)
    @game_id = result_data[:game_id]
    @team_id = result_data[:team_id]
    @hoa = result_data[:hoa]
    @result = result_data[:result]
    @settled_in = result_data[:settled_in]
    @head_coach = result_data[:head_coach]
    @goals = result_data[:goals].to_i
    @shots = result_data[:shots].to_i
    @tackles = result_data[:tackles].to_i
    @pim = result_data[:pim].to_i
    @ppo = result_data[:powerplayopportunities].to_i
    @ppg = result_data[:powerplaygoals].to_i
    @fowp = result_data[:faceoffwinpercentage].to_f
    @giveaways = result_data[:giveaways].to_i
    @takeaways = result_data[:takeaways].to_i
  end
end
