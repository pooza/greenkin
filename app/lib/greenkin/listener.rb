require 'eventmachine'
require 'faye/websocket'

module Greenkin
  class Listener
    attr_reader :client
    attr_reader :uri

    def open
      @logger.info(class: self.class.to_s, message: 'open', uri: @uri.to_s)
    end

    def close(event)
      @client = nil
      @logger.info(class: self.class.to_s, message: 'close', reason: event.reason)
    end

    def error(event)
      @client = nil
      @logger.error(class: self.class.to_s, message: 'error', reason: event.reason)
    end

    def receive(message)
      data = JSON.parse(message.data)
      payload = JSON.parse(data['payload'])
      return unless data['event'] == 'notification'
      send("handle_#{payload['type']}_notification".to_sym, payload)
    rescue NoMethodError => e
      @logger.error(e)
    rescue => e
      message = Ginseng::Error.create(e).to_h
      message[:payload] = payload if payload
      Slack.broadcast(message)
      @logger.error(message)
    end

    def handle_mention_notification(payload)
      @logger.info(payload)
      Mastodon.new.toot("@#{payload['account']['acct']} #{message}")
    end

    def message
      return 'パプパプ' * rand(1..2) + 'うるさいぞ' + ['。', '！'].sample
    end

    def self.start
      EM.run do
        listener = Listener.new

        listener.client.on :open do |e|
          listener.open
        end

        listener.client.on :close do |e|
          listener.close(e)
          raise 'closed'
        end

        listener.client.on :error do |e|
          listener.error(e)
          raise 'error'
        end

        listener.client.on :message do |message|
          listener.receive(message)
        end
      end
    rescue
      sleep(5)
      retry
    end

    private

    def initialize
      @config = Config.instance
      @logger = Logger.new
      @mastodon = Mastodon.new(@config['/mastodon/url'], @config['/mastodon/token'])
      @uri = @mastodon.create_streaming_uri
      @client = Faye::WebSocket::Client.new(@uri.to_s, nil, {
        ping: @config['/websocket/keepalive'],
      })
    end
  end
end
