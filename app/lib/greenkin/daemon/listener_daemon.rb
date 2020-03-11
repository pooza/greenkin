module Greenkin
  class ListenerDaemon < Ginseng::Daemon
    include Package

    def command
      return Ginseng::CommandLine.new([File.join(Environment.dir, 'bin/listener_worker.rb')])
    end

    def motd
      return [
        Package.full_name,
        self.class.to_s,
      ].join("\n")
    end
  end
end
