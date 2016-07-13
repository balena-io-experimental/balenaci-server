module Resinci
  class Server < Sinatra::Base
    get "/" do
      content_type "text/plain"

      <<HEREDOC
Usage:

  GET     /
    Display this help output

  GET     /containers
    List running docker-in-docker containers

  POST    /containers
    Create a new docker-in-docker container

  GET     /dockers/:id
    Get information about a running container

  GET     /dockers/:id/port
    Get the port for a particular containerized Docker daemon

  PUT     /dockers/:id/stop
    Stop a containerized Docker daemon
HEREDOC
    end

    get "/containers" do
      content_type "text/plain"

      Docker.ps
    end

    # TODO: remove this route
    get "/dockers/create" do
      content_type "text/plain"

      unless params[:context]
        return 400, { error: "context is required" }.to_json
      end

      version = params[:version] || DEFAULT_DOCKER_VERSION
      context = "%s-%s" % [ params[:context], version]

      if context && context != ""
        container = Docker.inspect(context)
        if container
          unless container.running?
            container.start
          end

          return container.connection_string
        end
      end

      name = (context && context != "") ? "--name=#{context}" : ""
      container = Docker.run(name: name, version: version)

      container.connection_string
    end

    post "/containers" do
      content_type "text/plain"

      unless params[:context]
        return 400, { error: "context is required" }.to_json
      end

      version = params[:version] || DEFAULT_DOCKER_VERSION
      context = "%s-%s" % [ params[:context], version]

      if context && context != ""
        container = Docker.inspect(context)
        if container
          unless container.running?
            container.start
          end

          return container.connection_string
        end
      end

      name = (context && context != "") ? "--name=#{context}" : ""
      container = Docker.run(name: name, version: version)

      container.connection_string
    end

    get "/dockers/:id" do
      content_type :json

      Docker.inspect(params[:id]).to_json
    end

    get "/dockers/:id/port" do
      content_type "text/plain"

      Docker.inspect(params[:id]).port
    end

    # TODO: remove this route
    get "/dockers/:id/stop" do
      content_type "text/plain"

      Docker.stop(params[:id])
    end

    put "/dockers/:id/stop" do
      content_type "text/plain"

      Docker.stop(params[:id])
    end
  end
end

