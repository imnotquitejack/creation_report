require 'rails'
require 'support/active_record'
require 'creation_report'

class Post < ActiveRecord::Base
  include CreationReport
  has_many :comments
end
class Comment < ActiveRecord::Base
  belongs_to :comment
end

describe CreationReport do
  before(:all) do
    @post = Post.create(:name => "Sample")
  end

  it "can be included by ActiveRecord objects" do
    lambda do
      class SomeModel < ActiveRecord::Base
        include CreationReport 
      end
    end.should_not raise_error
  end

  it "can only be included by objects inheriting ActiveRecord" do
    lambda do
      class ActiveRecord::Base
        include CreationReport 
      end
    end.should raise_error
  end

  it "responds to added methods" do
    Post.respond_to?(:created_by_hour).should == true
    Post.respond_to?(:created_by_day).should == true
    Post.respond_to?(:created_by_hour_of_day).should == true
    Post.respond_to?(:average_created_at_this_hour).should == true
    Post.respond_to?(:creations_by_day_chart).should == true
    Post.respond_to?(:creations_by_hour_of_day_chart).should == true
  end

  it "returns the correct data types" do
    Post.created_by_day.should be_a DataSet::DailyDataSet
    Post.created_by_hour_of_day.should be_a DataSet::HourOfDayDataSet
    Post.average_created_at_this_hour.should be_a Integer
  end

  context "hourly data" do
    before(:all) do
      Post.delete_all
      Post.record_timestamps = false
      20.times { Post.create(:name => "Sample", :created_at => 4.hours.ago, :updated_at => 4.hours.ago) }
      15.times { Post.create(:name => "Sample", :created_at => 3.hours.ago, :updated_at => 3.hours.ago) }
      25.times { Post.create(:name => "Sample", :created_at => 2.hours.ago, :updated_at => 2.hours.ago) }
      50.times { Post.create(:name => "Sample", :created_at => 10.minutes.ago, :updated_at => 10.minutes.ago) }
      Post.record_timestamps = true
    end

    it "should have created the posts" do
      Post.count.should be_between 100, 200
    end

    it "can aggregate data by hour" do
      Post.created_by_hour.should be_a DataSet::HourlyDataSet
    end

    it "should have the most recent hour" do
      Post.created_by_hour.max_date.should == Time.now.strftime("%Y-%m-%d %H")
    end

    it "should have the appropriate data" do
      Post.created_by_hour.values.should include(20)
      Post.created_by_hour.value_for_date(Time.now.strftime("%Y-%m-%d %H")).should == 50
      Post.created_by_hour.value_for_date(1.hours.ago.strftime("%Y-%m-%d %H")).should == 0
      Post.created_by_hour.value_for_date(2.hours.ago.strftime("%Y-%m-%d %H")).should == 25
      Post.created_by_hour.value_for_date(3.hours.ago.strftime("%Y-%m-%d %H")).should == 15
      Post.created_by_hour.value_for_date(4.hours.ago.strftime("%Y-%m-%d %H")).should == 20
      Post.created_by_hour.value_for_date(18.hours.ago.strftime("%Y-%m-%d %H")).should == 0
    end

  end


end