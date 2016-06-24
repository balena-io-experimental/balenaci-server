require File.expand_path("../docker/container", __FILE__)

module Resinci
  module Docker
    class << self
      def stop(id)
        Util.shell("docker stop #{id}")
      end

      def inspect(id)
        data = ::JSON.parse(Util.shell("docker inspect #{id}"))[0]
        return nil unless data

        Container.new(data)
      end

      def ps
        Util.shell("docker ps -f label=io.resin.dev.dind")
      end

      def start(id)
        Util.shell("docker start #{id}")
      end

      def stop(id)
        Util.shell("docker stop #{id}")
      end

      def run(name:, version:)
        cmd="docker run -d --privileged -p $$:2375 %s \
          -v #{CERT_PATH}:/mnt \
          --label io.resin.dev.dind=%s \
          library/docker:%s-dind docker daemon \
          --tlsverify \
          -s overlay \
          -H 0.0.0.0:2375 \
          -H unix:///var/run/docker.sock \
          --tlscacert=/mnt/ca.cert \
          --tlscert=/mnt/server.cert \
          --tlskey=/mnt/server.key" % [name, version, version]

        id = Util.shell(cmd)
        inspect(id)
      end

      def rm_all
        Util.shell("docker rm -f $(docker ps -qf label=io.resin.dev.dind)")
      end
    end
  end
end

