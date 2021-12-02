[![Build Status](https://github.com/mna/luaprecomp/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/mna/luaprecomp/actions)

# luaprecomp

A small Lua library that adds support via a search to insert in `package.searchers` to `require`
pre-compiled Lua modules (pre-compiled with `luac` to bytecode). The searcher function can
be inserted before or after the searcher for source-code Lua modules, depending on the intended
effect (note that inserting it *before* the source code searcher means that changes to the source
code of `require`d modules will not be seen until it is re-compiled to bytecode, while inserting
it *after* means that the pre-compiled version will never be used if the source code is available).

This works "recursively", so to speak, in that if a pre-compiled module requires another module,
it too will support loading from a pre-compiled file if available, and so on.

## Install

Via LuaRocks:

```
$ luarocks install luaprecomp
```

Or simply copy the single precomp.lua file in your project or your `LUA_PATH`.

## API

Assuming `local precomp = require 'precomp'`. You can check out `test/main.lua`
for examples of using the API.

### `precomp.searcher`

The searcher function that returns a loader for pre-compiled modules. It is not
meant to be called directly, typically it will be inserted in the `package.searchers`
table so that it is used by the `require` built-in mechanism.

See https://www.lua.org/manual/5.4/manual.html#6.3 for more details.

If `precomp.path` is not set, the search path used is `package.path` with the
`.lua` extension replaced with `.luac`. The `precomp.ext` field can be set to
specify a different extension to replace `.lua` with. If `precomp.path` is set,
it is used as search path as-is.

Typical use is to insert it like this before requiring the modules:

```
-- use index 2 to insert before source code, index 3 for after.
table.insert(package.searchers, 2, precomp.searcher)
```

### `precomp.path`

The search path for pre-compiled modules. If not set, `package.path` is used
with the `.lua` extension replaced with `.luac` or `precomp.ext` if set.

See https://www.lua.org/manual/5.4/manual.html#pdf-package.searchpath for
details on the format and behaviour of the path.

### `precomp.ext`

If set, indicates the extension to use to replace `.lua` in the `package.path`
string. Ignored if `precomp.path` is set. Note that it must include the leading
dot.

## Development

Clone the project and install the required development dependencies:

* luaunit (the unit test runner)
* luacov (recommended, test coverage)

To run tests and coverage:

```
# unit tests
$ lua test/main.lua

# test coverage
$ lua -lluacov test/main.lua
# generates a luacov.stats.out file
$ luacov
# generates a luacov.report.out file
$ cat luacov.report.out
```

## License

The [BSD 3-clause](http://opensource.org/licenses/BSD-3-Clause) license.

