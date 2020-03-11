desc 'test all'
task :test do
  ENV['TEST'] = Greenkin::Package.name
  require 'test/unit'
  Dir.glob(File.join(Greenkin::Environment.dir, 'test/*.rb')).sort.each do |t|
    require t
  end
end
