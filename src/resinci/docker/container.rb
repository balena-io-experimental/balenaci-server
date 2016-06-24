module Resinci
  module Docker
    class Container
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def port
        data = @data["HostConfig"]["PortBindings"]

        data.values.flatten.map { |n| n["HostPort"] }.first
      end

      def start
        Docker.start(id)
      end

      def stop
        Docker.stop(id)
      end

      def running?
        return false unless @data

        @data["State"]["Running"]
      end

      def id
        @id ||= @data["Id"]
      end

      def to_json
        @data.to_json
      end

      def connection_string
        output = <<-HEREDOC
          DOCKER_HOST=%s:%s; export DOCKER_HOST\n
          DOCKER_INSTANCE_ID=%s; export DOCKER_INSTANCE_ID\n
          DOCKER_TLS_VERIFY=1; export DOCKER_TLS_VERIFY\n
        HEREDOC

        output.gsub(/^\s*/, "") % [
          HOSTNAME,
          port,
          id,
        ]
      end
    end
  end
end

