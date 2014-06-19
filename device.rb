class Device < Struct.new(:id, :name, :service_count, :work_amount)

  def service_period
    ((Date::MONTHNAMES.count - 1) / service_count).to_i
  end

  def self.sort_devices(devices)
    devices.sort do |a, b|
      case a.work_amount <=> b.work_amount
      when -1 then -1
      when 0 then a.service_count <=> b.service_count
      when 1 then 1
      end
    end
  end

end
