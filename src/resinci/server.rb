module Resinci
  class Server < Sinatra::Base
    get "/containers" do
      content_type "text/plain"

      Docker.ps
    end

    delete "/containers" do
      content_type "text/plain"

      Docker.rm_all
    end

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

    get "/dockers/:id" do
      content_type :json

      Docker.inspect(params[:id]).to_json
    end

    get "/dockers/:id/port" do
      content_type "text/plain"

      Docker.inspect(params[:id]).port
    end

    get "/dockers/:id/stop" do
      content_type "text/plain"

      Docker.stop(params[:id])
    end
  end
end

