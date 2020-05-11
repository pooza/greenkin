namespace :greenkin do
  [:listener].each do |daemon|
    namespace daemon do
      [:start, :stop].each do |action|
        desc "#{action} #{daemon}"
        task action do
          sh "#{File.join(Greenkin::Environment.dir, 'bin', "#{daemon}_daemon.rb")} #{action}"
        rescue => e
          warn "#{e.class} #{daemon}:#{action} #{e.message}"
        end
      end

      desc "restart #{daemon}"
      task restart: [:stop, :start]
    end
  end
end

[:start, :stop, :restart].each do |action|
  desc "#{action} all"
  task action => [
    "greenkin:listener:#{action}",
  ]
end
