class DataSet::DayOfWeekDataSet < DataSet

  def initialize(point_array)
    @datapoints ||= { 'Mon' => 0, 'Tue' => 0, 'Wed' => 0, 'Thu' => 0, 'Fri' => 0, 'Sat' => 0, 'Sun' => 0 }

    point_array.each do |day_of_week, value|
      value = value.to_f
      @datapoints[day_of_week] = value
    end
  end

  def days
    %w[Mon Tue Wed Thu Fri Sat Sun]
  end

  def values
    [@datapoints['Mon'],
     @datapoints['Tue'],
     @datapoints['Wed'],
     @datapoints['Thu'],
     @datapoints['Fri'],
     @datapoints['Sat'],
     @datapoints['Sun']]
  end

end
