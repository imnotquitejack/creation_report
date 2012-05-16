class DataSet::MonthlyDataSet < DataSet

  def initialize( point_array, count = 24 )

    @datapoints ||= {} #[["2008-06", 200.58], ["2008-07", 205.39]]
    @count = count
    
    point_array.each do |date, value|
      value = value.to_f
      @datapoints[date] = value
    end
    fill_with_zeroes(@count)
    truncate_datapoints
  end
  
  # Return array of months in '2009-11' format corresponding to datapoints
  def months
    @datapoints.collect{ |point| point[0] }
  end
  
  # Array of abbreviated months ('Jan', 'Feb') corresponding to datapoints
  def month_labels
    months.collect{ |month| 
      "#{month}-01".to_date.strftime("%b")
    }
  end
  
  # Array containing full year (2009) x-axis labels stacked beneath month labels that are "Jan"
  def year_labels
    months.collect{|month| "#{month}-01".to_date.month==1 ? "#{month}-01".to_date.year : '' }
  end
  
  
  protected
    # Set dates that don't have values to 0.
    # This method turns the @datapoints hash into an array.
    def fill_with_zeroes(month_count)
      (0..month_count-1).each do |i|
        @datapoints[i.months.ago.to_date.strftime("%Y-%m")] ||= 0
      end
      @datapoints = @datapoints.sort
    end
  
  # Ditch the datapoints that we aren't interested in
  def truncate_datapoints
    return unless @datapoints.length > @count
    @datapoints = @datapoints.slice( @datapoints.length - @count, @count)
  end
end