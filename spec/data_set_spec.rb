require 'spec_helper'
require 'data_set'

describe 'DataSet' do
  it "can be initialized" do
    DataSet.new(daily_datapoints).should be_a DataSet
  end

  it "can get values" do
    DataSet.new(daily_datapoints).respond_to?(:values).should == true
    DataSet.new(daily_datapoints).values.should be_a Array
  end

  it "can get the minimum value" do
    DataSet.new(daily_datapoints).min_value.should == 200.58
  end

  it "can get the maximum value" do
    DataSet.new(daily_datapoints).max_value.should == 205.39
  end

  it "can get dates" do
    DataSet.new(daily_datapoints).respond_to?(:dates).should == true
    DataSet.new(daily_datapoints).dates.should be_a Array
  end

  it "can get the minimum date" do
    DataSet.new(daily_datapoints).min_date.should == 1.month.ago.strftime("%Y-%m-%d")
  end

  it "can get the maximum date" do
    DataSet.new(daily_datapoints).max_date.should == Time.now.strftime("%Y-%m-%d")
  end

  it "can retrieve the value for a date" do
    DataSet.new(specific_daily_datapoints).value_for_date('2007-12-03').should == 62.1
    DataSet.new(specific_daily_datapoints).value_for_date('2007-12-28').should == 32.65
    DataSet.new(specific_daily_datapoints).value_for_date('2008-02-12').should == 2
  end

  it "raises exception if requesting value for date that doesn't exist" do
    lambda do
      DataSet.new(specific_daily_datapoints).value_for_date('1786-02-12')
    end.should raise_error "That date is not in the dataset."
  end
end