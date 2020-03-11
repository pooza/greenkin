module Greenkin
  class Mastodon < Ginseng::Mastodon
    include Package

    def initialize(uri = nil, token = nil)
      @config = Config.instance
      uri ||= @config['/mastodon/url']
      token ||= @config['/mastodon/token']
      super(uri, token)
    end
  end
end
