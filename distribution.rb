require 'pry'
require 'date'
require 'ostruct'
require_relative 'devices_work_distributor'

ARGV[1].to_i.times do |i|
  start_time = Time.now
  devices_work_distributor = DevicesWorkDistributor.new(ARGV[0], i)
  devices_work_distributor.calculate_work_distribution!
  devices_work_distributor.export
  devices_work_distributor.inspect
  end_time = (Time.now - start_time).to_i
  end_time_str = "#{end_time / 3600}:#{(end_time % 3600) / 60}:#{end_time % 60}"
  p "Elapsed time - #{end_time_str}"
end
