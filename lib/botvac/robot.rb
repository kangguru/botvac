require "openssl"
require "json"
require "faraday"
require 'faraday_middleware'

module Botvac
  class Robot
    attr_accessor :serial, :secret

    def initialize(serial, secret)
      self.serial  = serial
      self.secret  = secret
    end

    def start_cleaning
      connection.post("messages", JSON.dump(
        {
          reqId: "1",
          cmd: "startCleaning",
          params: {
            category: 2,
            mode: 2,
            modifier: 2
          }
        }
      )).body
    end

    def pause_cleaning
      connection.post("messages", JSON.dump({ reqId: "1",cmd: "pauseCleaning" })).body
    end

    def stop_cleaning
      connection.post("messages", JSON.dump({ reqId: "1",cmd: "stopCleaning" })).body
    end

    def send_to_base
      connection.post("messages", JSON.dump({ reqId: "1",cmd: "sendToBase" })).body
    end

    def get_robot_state
      connection.post("messages", JSON.dump({ reqId: "1", cmd: "getRobotState" })).body
    end

    def enable_schedule
      connection.post("messages", JSON.dump({ reqId: "1", cmd: "enableSchedule" })).body
    end

    def disable_schedule
      connection.post("messages", JSON.dump({ reqId: "1", cmd: "disableSchedule"})).body
    end

    def get_schedule
      connection.post("messages", JSON.dump({ reqId: "1", cmd: "getSchedule" })).body
    end

    protected

    class Hmac < Faraday::Middleware
      def initialize(app, options = {})
        super(app)
        @digest = OpenSSL::Digest.new('sha256')
        @serial = options[:serial].downcase
        @secret = options[:secret]
      end

      def call(env)
        "#{Time.now.gmtime.strftime("%a, %d %h %Y %H:%M:%S")} GMT".tap do |date|
          hmac   = OpenSSL::HMAC.hexdigest(@digest, @secret, [@serial, date, env['body']].join("\n"))
          env[:request_headers]['Date']= date
          env[:request_headers]['Authorization']= "NEATOAPP #{hmac}"
        end

        @app.call(env)
      end
    end

    def connection
      @connection ||= Faraday.new(ssl: { ca_file: File.join(File.dirname(__FILE__), '..', '..', 'cert', 'neatocloud.com.crt') }) do |faraday|
        faraday.url_prefix= "#{Botvac::ENDPOINT}/vendors/neato/robots/#{self.serial}/"
        faraday.use Hmac, { serial: self.serial, secret: self.secret }
        faraday.headers["Accept"]= 'application/vnd.neato.nucleo.v1'
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
