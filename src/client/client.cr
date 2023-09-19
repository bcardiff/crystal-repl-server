require "http/client"
require "../common/api"

class Crystal::Repl::Server::Client
  @socket_path : String
  @input : IO::Memory
  @output : IO::Memory
  @error : IO::Memory
  @server : Process
  @client : HTTP::Client

  def self.start_server_and_connect(*, server : String, socket : String? = nil) : self
    new(server: server, socket: socket || File.tempname("crystal", ".sock"))
  end

  def initialize(*, server : String, socket : String)
    @socket_path = socket

    @input = IO::Memory.new
    @output = IO::Memory.new
    @error = IO::Memory.new

    @server = Process.new(server, {@socket_path}, input: @input, output: @output, error: @error)

    @client = retry do
      HTTP::Client.new(UNIXSocket.new(@socket_path))
    end
  end

  def close
    @server.close
    @client.close
    # TODO delete socket
    # @socket.delete
  end

  def raw_post(path, body)
    @client.post(path, body: body).body
  end

  def post(path, *, body = nil, as result_type : T.class) : T forall T
    result_type.from_json(raw_post(path, body: body))
  end

  private def retry
    last_ex = nil
    5.times do
      return yield
    rescue ex
      sleep 0.1
      last_ex = ex
    end
    raise last_ex.not_nil!
  end
end
