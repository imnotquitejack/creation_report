require 'rails'
require 'support/active_record'

def monthly_datapoints( options={} )
  {
    "#{1.month.ago.year}-#{1.month.ago.strftime("%m")}" => '200.58', 
    "#{Time.now.year}-#{Time.now.strftime("%m")}" => '205.39'
  }
end

def daily_datapoints( options={} )
  {
    1.month.ago.strftime("%Y-%m-%d") => '200.58', 
    Time.now.strftime("%Y-%m-%d") => '205.39'
  }
end

def hourly_datapoints( options={} )
  {
    1.hour.ago.strftime("%Y-%m-%d %H") => '200.58', 
    Time.now.strftime("%Y-%m-%d %H") => '205.39'
  }
end


def specific_daily_datapoints
  [
    ['2007-12-03', 62.1],
    ['2007-12-28', 32.65],
    ['2008-02-12', 2],
  ]
end

def lots_of_monthly_datapoints( month_count = 30 )
  datapoints = {}
  (0..month_count).to_a.collect do |i| 
    datapoints["#{i.months.ago.year}-#{i.months.ago.strftime("%m")}"] = random_dollar_amount
  end
  return datapoints
end

def random_dollar_amount
  "#{rand(400)}.#{rand(99)}"
end