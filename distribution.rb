require 'pry'
require 'date'
require_relative 'devices_work_distributor'

class Float
  def to_s
    self.round(2).inspect
  end
end

devices_work_distributor = DevicesWorkDistributor.new('list.xlsx')
devices_work_distributor.calculate_work_distribution!
devices_work_distributor.export
devices_work_distributor.inspect
