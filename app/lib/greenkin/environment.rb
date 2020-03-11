module Greenkin
  class Environment < Ginseng::Environment
    def self.name
      return File.basename(dir)
    end

    def self.dir
      return Greenkin.dir
    end
  end
end
