module Resinci
  class Util
    class << self
      def shell(cmd)
        STDERR.puts cmd

        `#{cmd}`.strip
      end
    end
  end
end

