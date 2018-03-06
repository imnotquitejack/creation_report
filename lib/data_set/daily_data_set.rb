class DataSet::DailyDataSet < DataSet

  def initialize(point_array, count = 30)
    @datapoints ||= {} # [["2008-06-01", 200.58], ["2008-06-02", 205.39]]
    @count = count

    point_array.each do |date, value|
      value = value.to_f
      @datapoints[date.to_s] = value
    end

    fill_with_zeroes(@count)
  end

  # Array of dates corresponding to datapoints in "2009-11-18" format
  def dates
    @datapoints.collect { |point| point[0] }
  end

  # Array of dates in "Nov 18" format corresponding to datapoints
  # at one week increments working backwords from today.
  # Compare today's DOW ("Mon") to each date in the array, and only return "Nov 18" for dates that match the DOW.
  def date_labels
    if @count < 90
      dates.collect { |date| date.to_date.strftime('%d') == Time.now.strftime('%a') ? date.to_date.strftime('%b %e') : '' }
    else
      dates.collect { |date| date.to_date.strftime('%d') == '01' ? date.to_date.strftime('%b %e') : '' }
    end
  end

  def full_weeks_in_dataset
    @count.to_i / 7
  end

  # Array containing month names corresponding to datapoint positions which represent the first day of the month.
  # ['','','December','','']
  def month_labels
    dates.collect { |date| date.to_date.day == 1 ? date.to_date.strftime('%B') : '' }
  end

  protected

  def fill_with_zeroes(_days)
    (0..@count).each do |i|
      @datapoints[i.days.ago.to_date.to_s] ||= 0
    end

    @datapoints = @datapoints.sort
  end
end
