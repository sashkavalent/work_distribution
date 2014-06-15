require 'rubyXL'

class WorkShedule

  def initialize(months_count: months_count, work_for_months: work_for_months)
    @work_for_months = work_for_months || Array.new(months_count) { 0 }
  end

  def inspect
    months_in_year = Date::MONTHNAMES.count - 1
    @work_for_months.map.with_index do |el, i|
      month_number = i % months_in_year + 1
      print "__________________\n" if month_number == 1
      print [Date::MONTHNAMES[month_number], el].to_s + "\n"
    end
  end

  def sum
    @work_for_months.reduce(:+)
  end

  def add_work!(start_month, period, work_amount)
    month_number = start_month
    while month_number < @work_for_months.count
      @work_for_months[month_number] += work_amount
      month_number += period
    end
  end

  def sum_delta
    average_month_work = self.average
    @work_for_months.inject { |sum_delta, month_work| sum_delta + (average_month_work - month_work).abs }
  end

  def average
    sum / @work_for_months.count
  end

  def clone
    WorkShedule.new(work_for_months: @work_for_months.clone)
  end

  def export
    @work_for_months
  end

end
