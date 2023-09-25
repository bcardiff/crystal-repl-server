# This is a shorter version of commands to include only the env command

require "json"
require "compiler/crystal/command/env"

class Crystal::Command
  def self.run(options = ARGV)
    new(options).run
  end

  private getter options

  def initialize(@options : Array(String))
  end

  def run
    command = options.first?
    case
    when command == "env"
      options.shift
      env
    end
  end
end
