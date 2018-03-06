class DataSet::HourlyDataSet < DataSet

  def initialize(point_array, count = 24)
    @datapoints ||= {} # [["2008-06-01 12", 200.58], ["2008-06-02 13", 205.39]]
    @count = count

    point_array.each do |date, value|
      value = value.to_f
      @datapoints[date.to_s] = value
    end

    fill_with_zeroes(@count)
    trim_to_limit
  end

  # Array of dates corresponding to datapoints in "2009-11-18" format
  def dates
    @datapoints.collect { |point| point[0] }
  end

  protected

  def fill_with_zeroes(_hours)
    (0..@count - 1).each do |i|
      @datapoints[i.hours.ago.strftime('%Y-%m-%d %H')] ||= 0
    end
    @datapoints = @datapoints.sort
  end

  def trim_to_limit
    @datapoints = @datapoints.slice(0 - @count, @count)
  end
end
