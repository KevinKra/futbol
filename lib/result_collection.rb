require 'CSV'

class ResultCollection

  attr_reader :result_data

  def initialize(result_data)
    @result_data = create_results(result_data)
  end

  def length
    @result_data.length
  end

  def create_results(result_data)
  results = []
    CSV.foreach(result_data, headers:true, header_converters: :symbol) do |row|
      results << Result.new(row)
    end
    results
  end
end
