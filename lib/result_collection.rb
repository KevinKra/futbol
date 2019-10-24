class ResultCollection
  attr_reader :result_data
  def initialize(result_data)
    @result_data = result_data
  end

  def length
    @result_data.length
  end

end
