require 'spec_helper'
require 'data_set/monthly_data_set'

describe 'MonthlyDataSet' do

  it "can be initialized correctly" do
    monthly_set = DataSet::MonthlyDataSet.new( monthly_datapoints )
    monthly_set.should be_a DataSet::MonthlyDataSet
    monthly_set.datapoints.length.should == 24
    monthly_set.dates.should include "#{Time.now.year}-#{Time.now.strftime("%m")}"
    monthly_set.value_for_date("#{Time.now.year}-#{Time.now.strftime("%m")}").should == 205.39
  end

  it "should be populated with zeroes for dates not initialized" do
    monthly_set = DataSet::MonthlyDataSet.new( monthly_datapoints, 3 )
    monthly_set.datapoints.length.should == 3
    monthly_set.value_for_date("#{2.months.ago.year}-#{2.months.ago.strftime("%m")}").should == 0
  end

  it "should truncate dates correctly" do
    monthly_set = DataSet::MonthlyDataSet.new( lots_of_monthly_datapoints, 12 )
    monthly_set.datapoints.length.should == 12
    
    the_month = 11.months.ago
    monthly_set.value_for_date("#{the_month.year}-#{the_month.strftime('%m')}").should be_a Float
    
    the_month = Time.now
    monthly_set.value_for_date("#{the_month.year}-#{the_month.strftime('%m')}").should be_a Float
  end

end