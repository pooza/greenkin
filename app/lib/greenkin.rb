require 'ginseng'

module Greenkin
  def self.dir
    return File.expand_path('../..', __dir__)
  end

  def self.loader
    config = YAML.load_file(File.join(dir, 'config/autoload.yaml'))
    loader = Zeitwerk::Loader.new
    loader.inflector.inflect(config['inflections'])
    loader.push_dir(File.join(dir, 'app/lib'))
    loader.collapse('app/lib/greenkin/*')
    return loader
  end

  def self.load_tasks
    Dir.glob(File.join(dir, 'app/task/*.rb')).sort.each do |f|
      require f
    end
  end
end

Greenkin.loader.setup
