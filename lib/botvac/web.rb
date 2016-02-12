require 'botvac'

module Botvac
  class Web
    def call(env)
      if supported_actions.include?(env["REQUEST_PATH"][1..-1])
        [200, {'Content-Type' => 'application/json'}, [robot.send(env["REQUEST_PATH"][1..-1])]]
      else
        [404, {'Content-Type' => 'application/json'}, ['{}']]
      end
    end

    def supported_actions
      %w(start_cleaning pause_cleaning stop_cleaning send_to_base get_robot_state disable_schedule enable_schedule get_schedule)
    end

    def robot
      @robot ||= Botvac::Robot.new(ENV['SERIAL'], ENV['SECRET'])
    end
  end
end
