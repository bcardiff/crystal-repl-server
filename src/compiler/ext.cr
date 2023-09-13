# Some extensions to the Crystal REPL to use the interpreter outside the REPL loop

class Crystal::Repl
  def prepare
    load_prelude
  end

  def interpret_part(expression)
    parser = new_parser(expression)
    # TODO change warnigns output
    parser.warnings.report(STDOUT)

    node = parser.parse
    # TODO handle errors
    # next unless node

    interpret(node)
  end
end

struct Crystal::Repl::Value
  def runtime_type : Crystal::Type
    if type.is_a?(Crystal::UnionType)
      type_id = @pointer.as(Int32*).value
      context.type_from_id(type_id)
    else
      type
    end
  end
end
