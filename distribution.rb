#обслуживание проводится не позднее, чем его периодичность, считая с начала года
require 'pry'
require 'date'

MONTH_COUNT = 25
MONTHS_IN_YEAR = 12

Product = Struct.new(:name, :service_count, :work_amount) do
  def service_period
    MONTHS_IN_YEAR / service_count.to_f
  end
end

products = [['Car', 1.5, 8], ['Computer', 2, 5], ['Table', 1.5, 24], ['Ball', 2, 8]]
products = products.map { |p| Product.new(p[0], p[1], p[2]) }

work_for_months = Array.new(MONTH_COUNT) { 0 }
def work_for_months.show
  self.map.with_index do |el, i|
    month_number = i % MONTHS_IN_YEAR + 1
    print "__________________\n" if month_number == 1
    print [Date::MONTHNAMES[month_number], el].to_s + "\n"
  end
end

work_for_months_list = []
products.each.with_index do |product, product_number|
  service_count = (MONTH_COUNT / MONTHS_IN_YEAR.to_f * product.service_count).ceil
  service_count.times do |i|
    month_number = i * product.service_period + product_number
    if month_number < MONTH_COUNT
      work_for_months[month_number] += product.work_amount
    end
  end
end

mean = work_for_months.take(MONTH_COUNT).reduce(:+) / MONTH_COUNT.to_f
delta = work_for_months.take(MONTH_COUNT).inject(0) do |result, work_for_month|
  result + (mean - work_for_month).abs
end
puts 'mean = ' + mean.to_s
puts 'delta = ' + delta.to_s

work_for_months.show
