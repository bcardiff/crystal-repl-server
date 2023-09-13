# crystal-repl-server

Experimental tool to run a Crystal REPL as an HTTP Server.

## Installation

Prerequisites

- The latest version of [crystal](https://crystal-lang.org/).
- Be able to [compile crystal from sources](https://crystal-lang.org/install/from_sources/).

## Usage

After building the `bin/crystal-repl-server` binary, run it with:

```
./bin/crystal-repl-server /tmp/crystal-repl-0001.sock
```

Then, in another terminal, run:

```
% curl -X POST --unix-socket /tmp/crystal-repl-0001.sock http://server/v1/start
{"status":"ok"}

% curl -X POST --unix-socket /tmp/crystal-repl-0001.sock http://server/v1/eval -d '1 + 2'
{"value":"3","runtime_type":"Int32","static_type":"Int32","type":"success"}
```

## Development

To build crystal-repl-server using the install crystal compiler run:

```
make bin/crystal-repl-server
# or
make all
```

You will need to have the same llvm version installed as the one informed in `crystal --version`.

To build crystal-repl-server using crystal sources run:

```
make all CRYSTAL=~/path/to/crystal-clone/bin/crystal
```

You will need to run `make clean deps` in your crystal-clone first.

In either case, the crystal-repl-server binary will be left in the `./bin/crystal-repl-server`.

To specify a specific llvm-config, use the `LLVM_CONFIG` environment variable.

### Specs

To run the specs do

```
make system_spec
# or
make all
```

## Contributing

1. Fork it (<https://github.com/bcardiff/crystal-repl-server/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Brian J. Cardiff](https://github.com/bcardiff) - creator and maintainer
