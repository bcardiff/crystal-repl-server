require "../spec_helper"

# these specs run agains the ./bin/crystal-repl-server executable
require "http/client"
require "../../src/client"

CRYSTAL_REPL_SERVER_BIN = Path[__DIR__].parent.parent.join("bin", "crystal-repl-server").to_s

include Crystal::Repl::Server::API

def it_(description, file = __FILE__, line = __LINE__, end_line = __END_LINE__, &block : Crystal::Repl::Server::Client ->)
  it(description, file, line, end_line) do
    client = Crystal::Repl::Server::Client.start_server_and_connect(server: CRYSTAL_REPL_SERVER_BIN)
    begin
      block.call(client)
    ensure
      client.close
    end
  end
end

describe "http interpreter" do
  it_ "can start an interpreter" do |c|
    c.start.should eq(StartResult.new("ok"))
  end

  it_ "can evaluate with prelude" do |c|
    c.start
    c.eval("1 + 2")
      .should eq(EvalSuccess.new("3", "Int32", "Int32"))
  end

  describe "can return static and runtime type information for" do
    it_ "MixedUnionType" do |c|
      c.start
      c.eval("1 || \"a\"")
        .should eq(EvalSuccess.new("1", "Int32", "(Int32 | String)"))
    end

    it_ "UnionType" do |c|
      c.start
      c.eval("true || 1")
        .should eq(EvalSuccess.new("true", "Bool", "(Bool | Int32)"))
    end
  end

  it_ "can check syntax errors" do |c|
    c.start
    c.check_syntax("a = [1")
      .should eq(CheckSyntaxError.new(
        "expecting token ']', not 'EOF'",
        ["syntax error in :1",
         "Error: expecting token ']', not 'EOF'",
        ])
      )
    c.check_syntax("a = 1\nb = foo(1]")
      .should eq(CheckSyntaxError.new(
        "expecting token ')', not ']'",
        ["syntax error in :2",
         "Error: expecting token ')', not ']'",
        ])
      )
  end

  it_ "evaluate has backtrace of compile errors" do |c|
    c.start
    # TODO: it seems the interpreter is unable to generate:
    #
    #  5 | 1.invalid_method
    #      ^-------------
    # Error: undefined method 'invalid_method' for Int32
    #
    # Which would be nicer output for the backtrace.
    c.eval("1.invalid_method")
      .should eq(EvalError.new(
        "undefined method 'invalid_method' for Int32",
        ["error in line 1",
         "Error: undefined method 'invalid_method' for Int32",
        ])
      )
  end
end
