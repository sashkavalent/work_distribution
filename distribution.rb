require 'pry'
require 'date'
require 'ostruct'
require_relative 'devices_work_distributor'

ARGV[1].to_i.times do |i|
  devices_work_distributor = DevicesWorkDistributor.new(ARGV[0], i)
  devices_work_distributor.calculate_work_distribution!
  devices_work_distributor.export
  devices_work_distributor.inspect
end
