#обслуживание проводится не позднее, чем его периодичность, считая с начала года
require 'pry'
require 'date'

class Float
  def to_s
    self.round(2).inspect
  end
end

MONTH_COUNT = 25
MONTHS_IN_YEAR = 12

Device = Struct.new(:name, :service_count, :work_amount) do
  def service_period
    # @service_period = @service_period || (MONTHS_IN_YEAR / service_count.to_f)
    MONTHS_IN_YEAR / service_count.to_f
  end
end

devices = [['Car', 1.5, 8], ['Computer', 2, 5], ['Table', 1.5, 6], ['Ball', 2, 8],
  ['Car', 1.5, 8], ['Computer', 2, 5], ['Table', 1.5, 6], ['Ball', 2, 8]]
devices = devices.map { |p| Device.new(p[0], p[1], p[2]) }

work_for_months = Array.new(MONTH_COUNT) { 0 }
def work_for_months.show
  self.map.with_index do |el, i|
    month_number = i % MONTHS_IN_YEAR + 1
    print "__________________\n" if month_number == 1
    print [Date::MONTHNAMES[month_number], el].to_s + "\n"
  end
end

devices.each.with_index do |device, device_number|
  service_count = (MONTH_COUNT / MONTHS_IN_YEAR.to_f * device.service_count).ceil
  service_count.times do |i|
    month_number = i * device.service_period + device_number
    if month_number < MONTH_COUNT
      work_for_months[month_number] += device.work_amount
    end
  end
end

total_amount = work_for_months.reduce(:+)
mean = total_amount / MONTH_COUNT.to_f
delta = work_for_months.inject(0) do |result, work_for_month|
  result + (mean - work_for_month).abs
end
puts 'mean = ' + mean.to_s
puts 'delta = ' + delta.to_s
puts 'total_amount = ' + total_amount.to_s
puts 'delta / total_amount = ' + (delta / total_amount.to_f * 100).to_s + '%'

work_for_months.show
