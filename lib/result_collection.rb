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
    csv = CSV.foreach(result_data, headers:true, header_converters: :symbol)
    csv.map { |row| Result.new(row) }
  end
end
