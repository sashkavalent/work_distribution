class Device < Struct.new(:id, :name, :service_count, :work_amount)

  def service_period
    ((Date::MONTHNAMES.count - 1) / service_count).to_i
  end

  def <=> device
    case self.work_amount <=> device.work_amount
    when -1 then -1
    when 0 then self.service_count <=> device.service_count
    when 1 then 1
    end
  end

end
