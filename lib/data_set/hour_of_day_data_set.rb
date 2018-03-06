class DataSet::HourOfDayDataSet < DataSet

  def initialize(point_array)
    @datapoints = {}
    hours.each do |hour|
      @datapoints[hour] = 0
    end

    point_array.each do |hour_of_day, value|
      value = value.to_f
      @datapoints[hour_of_day.to_i] = value
    end

    @datapoints = @datapoints.sort
  end

  def hours
    (0..23)
  end

  def values
    hours.collect { |hour| @datapoints[hour][1] }
  end

end
