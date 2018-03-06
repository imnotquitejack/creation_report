require 'data_set'
require 'data_set/hourly_data_set'
require 'data_set/daily_data_set'
require 'data_set/day_of_week_data_set'
require 'data_set/hour_of_day_data_set'
require 'data_set/monthly_data_set'

module CreationReport

  def self.append_features(base)
    super
    unless base.superclass == ActiveRecord::Base
      raise 'CreationReport can only be included in ActiveRecord subclasses.'
    end
    base.extend(ClassMethods)
  end

  module ClassMethods
    @@number_of_days = 1000

    def created_by_hour(count = 24)
      DataSet::HourlyDataSet.new(
        where("#{table_name}.created_at > ?", count.hours.ago)
          .order("#{table_name}.id ASC")
          .group("DATE_FORMAT( CONVERT_TZ(#{table_name}.created_at, '+0:00', '#{timezone_offset_for_creation_report}'),'%Y-%m-%d %H')")
          .count,
        count,
      )
    end

    def created_by_day
      DataSet::DailyDataSet.new(
        where("#{table_name}.created_at > ?", report_start_time)
          .order("#{table_name}.id ASC")
          .group("DATE(#{table_name}.created_at)")
          .count,
        @@number_of_days,
      )
    end

    def created_by_hour_of_day
      DataSet::HourOfDayDataSet.new(
        where('created_at > ?', report_start_time)
          .group("DATE_FORMAT(created_at, '%k')")
          .order("#{table_name}.id ASC")
          .count
      )
    end

    def average_created_by_day
      created_by_day.values.sum.to_f / created_by_day.values.length.to_f
    end

    def average_created_at_this_hour
      created_by_day.values.at(Time.now.hour)
    end

    def creations_by_day_chart
      dataset = created_by_day
      GoogleChart::LineChart.new('600x150', "#{table_name.upcase} CREATED IN THE LAST #{@@number_of_days} DAYS", false) do |lc|
        lc.data_encoding = :extended
        lc.data 'Created', dataset.values, '00ff00'
        lc.show_legend = false
        lc.title_color = 'A5B1A0'
        lc.title_font_size = '10'
        lc.max_value dataset.max_value
        lc.axis :y, range: [dataset.min_value, dataset.max_value]
        lc.axis :x, labels: dataset.date_labels
        lc.grid y_step: 50, x_step: 25, length_segment: 2, length_blank: 10
      end
    end

    def creations_by_hour_of_day_chart
      dataset = created_by_hour_of_day
      GoogleChart::LineChart.new('600x150', "#{table_name.upcase} CREATED FOR EACH HOUR", false) do |lc|
        lc.data 'Created', dataset.values, '00ff00'
        lc.show_legend = false
        lc.title_color = 'A5B1A0'
        lc.title_font_size = '10'
        lc.max_value dataset.max_value
        lc.axis :y, range: [dataset.min_value, dataset.max_value]
        lc.axis :x, labels: dataset.hours.to_a
        lc.grid y_step: 50, x_step: 100 / 11.5, length_segment: 2, length_blank: 10
      end
    end

    protected

    def timezone_offset_for_creation_report
      "#{(begin
         (Time.now.utc_offset / 3600 + (Time.now.dst? ? 1 : 0))
       rescue StandardError
         '-0'
       end)}:00"
    end

    def report_start_time
      @@number_of_days.days.ago.beginning_of_day
    end

  end

end
