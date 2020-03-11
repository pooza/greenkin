dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'app/lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'greenkin'

Dir.glob(File.join(Greenkin::Environment.dir, 'app/task/*.rb')).sort.each do |f|
  require f
end
