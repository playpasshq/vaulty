module Vaulty
  module Output
    class Banner
      attr_reader :msg, :prompt, :color

      def initialize(msg, color: :blue, prompt:)
        @msg = msg
        @color = "on_#{color}".to_sym
        @prompt = prompt
      end

      def render
        now = Time.new.strftime('%H:%M:%S')
        formatted = msg.ljust(72, ' ')
        prompt.say("[#{now}] #{formatted}", color: %I(bold white #{color}))
        puts
      end

      def self.render(*args)
        new(*args).render
      end
    end
  end
end
