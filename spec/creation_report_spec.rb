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

end