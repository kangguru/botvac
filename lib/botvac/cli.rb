require 'thor'
require 'botvac'
require 'securerandom'

module Botvac
  class Cli < Thor
    ENDPOINT = 'https://beehive.neatocloud.com/'

    attr_accessor :token

    desc 'login', 'login into neato cloudservices'
    def login
      email    = ask("Email:").to_s
      password = ask("Pasword:", echo: false).to_s

      self.token = connection.post('/sessions', { platform: "ios", email: email, token: SecureRandom.hex(32), password: password }).body['access_token']
    end

    desc "robots", "fetch details about you registered robots"
    def robots
      login unless token
      puts ''
      connection.get('/dashboard').body['robots'].each do |bot|
        puts "#{bot['name']} (#{bot['model']}) => Serial: #{bot['serial']} Secret: #{bot['secret_key']}"
      end
    end

    no_commands do
      def connection
        Faraday.new(ENDPOINT) do |faraday|
          faraday.response :json
          faraday.request  :json
          faraday.headers["Accept"]= 'application/vnd.neato.nucleo.v1'
          faraday.headers["Authorization"]= "Token token=#{token}" if token
          faraday.adapter Faraday.default_adapter
        end
      end
    end
  end
end
