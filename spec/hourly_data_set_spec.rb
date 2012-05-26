require 'spec_helper'
require 'data_set/hourly_data_set'

describe 'HourlyDataSet' do

  it "can be initialized correctly" do
    hourly_set = DataSet::HourlyDataSet.new( hourly_datapoints )
    hourly_set.should be_a DataSet::HourlyDataSet
    hourly_set.datapoints.length.should == 24
    hourly_set.dates.should include( Time.now.strftime("%Y-%m-%d %H") )
    hourly_set.value_for_date( Time.now.strftime("%Y-%m-%d %H") ).should == 205.39 
  end

  it "reduces dataset to 24 entries when given 30" do
    entries = []
    30.times do |i|
      entries.push( [i.hours.ago.strftime("%Y-%m-%d %H"), rand(100)] )
    end
    entries.length.should == 30
    hourly_set = DataSet::HourlyDataSet.new( entries, 24 )
    hourly_set.datapoints.length.should == 24
  end

  it "should be populated with zeroes for dates not initialized" do
    hourly_set = DataSet::HourlyDataSet.new( hourly_datapoints, 3 )
    hourly_set.datapoints.length.should == 3
    hourly_set.value_for_date( 2.hours.ago.strftime("%Y-%m-%d %H")).should == 0
  end

end