require 'pry'
require 'date'
require_relative 'devices_work_distributor'

class Float
  def to_s
    self.round(2).inspect
  end
end

ARGV[1].to_i.times do |i|
  devices_work_distributor = DevicesWorkDistributor.new(ARGV[0], i)
  devices_work_distributor.calculate_work_distribution!
  devices_work_distributor.export
  puts '________________________'
  p i
  devices_work_distributor.inspect
end
