require_relative 'work_shedule'
require_relative 'device'
require_relative 'devices_xlsx_driver'
require 'yaml'

class DevicesWorkDistributor

  def initialize(xlsx_path, deep_level)
    @deep_level = deep_level
    @devices_xlsx_driver = YAML.load(File.read('devices_xlsx_driver.yml'))
    # @devices_xlsx_driver = DevicesXLSXDriver.new(xlsx_path)
    devices = @devices_xlsx_driver.import
    # File.write('devices.yml', devices.to_yaml)
    # File.write('devices_xlsx_driver.yml', @devices_xlsx_driver.to_yaml)
    @devices = devices.sort_by!(&:work_amount).reverse!

    @work_shedule = WorkShedule.new(@devices_xlsx_driver.months_count, nil)
  end

  def inspect
    puts 'average = ' + @work_shedule.average.to_s
    puts 'total_amount_of_work = ' + @work_shedule.sum.to_s
    puts 'sum_delta = ' + @work_shedule.sum_delta.to_s
    # puts 'sum_delta / total_amount_of_work = ' + (@work_shedule.sum_delta / @work_shedule.sum.to_f * 100).to_s + '%'
    @work_shedule.inspect
  end

  def calculate_work_distribution!
    @devices.each.with_index do |device, index|
      @copy_work_shedule = @work_shedule.clone
      @work_shedule.add_work!(smart_best_start_month(index, @deep_level).month_number, device)
    end
  end

  def export
    # @devices_xlsx_driver.export_to_file(@work_shedule.serialize, 'export.xlsx')
  end

  private

  def smart_best_start_month(device_index, deep_level)
    month_number_with_smallest_delta = 0
    best_delta = Float::INFINITY

    device = @devices[device_index]
    device.service_period.times do |month_number|

      current_delta = 0
      if (deep_level == 0) || (device_index == @devices.length - 1)
        temp_work_shedule = @copy_work_shedule.clone
        temp_work_shedule.add_work!(month_number, device)
        current_delta = temp_work_shedule.sum_delta
      else
        stack_work_shedule = @copy_work_shedule.clone
        @copy_work_shedule.add_work!(month_number, device)

        current_delta = smart_best_start_month(device_index + 1, deep_level - 1).best_delta
        @copy_work_shedule = stack_work_shedule.clone
      end

      if current_delta < best_delta
        best_delta = current_delta
        month_number_with_smallest_delta = month_number
      end
    end

    OpenStruct.new(month_number: month_number_with_smallest_delta, best_delta: best_delta)
  end

  def best_start_month(device)
    month_number_with_smallest_delta = 0
    delta = Float::INFINITY

    device.service_period.times do |month_number|
      temp_work_shedule = @work_shedule.clone
      temp_work_shedule.add_work!(month_number, device)
      current_delta = temp_work_shedule.sum_delta
      if current_delta < delta
        delta = current_delta
        month_number_with_smallest_delta = month_number
      end
    end

    month_number_with_smallest_delta
  end
end
