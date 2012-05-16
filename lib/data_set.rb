class DataSet
  
  attr_accessor :datapoints
  attr_reader :max_value, :min_value, :max_date, :min_date, :count
  
  # The standard initialize function creates a hash out of an array of points.
  def initialize( point_array )
    @datapoints ||= {}
    @count = count || 30
    
    point_array.each do |x_value, y_value|
      y_value = y_value.to_f
      @datapoints[x_value] = y_value
    end
  end
  
  def values_for_google_chart
    values.join(',')
  end
  
  def min_value
    values.min
  end
  
  def max_value
    values.max
  end
  
  def min_date
    dates.min
  end
  
  def max_date
    dates.max
  end
  
  def dates
    @datapoints.collect{|point| point[0]}
  end

  def values
    @datapoints.collect{|point| point[1]}
  end
  
  def value_for_date(date)
    begin
      return @datapoints.detect{|point| point[0]==date}[1]
    rescue
      raise "That date is not in the dataset."
    end
  end
  
end
