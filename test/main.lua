local lu = require 'luaunit'
local precomp = require 'precomp'

TestRequire = {}

function TestRequire:testRequireCompiledFirst()
  -- load compiled before source
  self.searcher_index = 2
  table.insert(package.searchers, self.searcher_index, precomp.searcher)
  local main = require 'test.testdata.main'
  lu.assertEquals(main, 'compiledsourcemodulesubmodule')
end

function TestRequire:testRequireSourceFirst()
  -- load source before compiled
  self.searcher_index = 3
  table.insert(package.searchers, self.searcher_index, precomp.searcher)
  local main = require 'test.testdata.main'
  lu.assertEquals(main, 'compiledsourcemodulesrcsubmodulesrc')
end

function TestRequire.testRequireSourceOnly()
  lu.assertErrorMsgContains("module 'test.testdata.compiled' not found:", function()
    require 'test.testdata.main'
  end)
end

function TestRequire:testRequireCustomPath()
  -- load compiled before source
  self.searcher_index = 2
  precomp.path = './test/testdata/alttree/?.luad'
  table.insert(package.searchers, self.searcher_index, precomp.searcher)
  local main = require 'test.testdata.main'
  lu.assertEquals(main, 'alt')
end

function TestRequire:testRequireCustomExt()
  -- load compiled before source
  self.searcher_index = 2
  precomp.ext = '.luad' -- will not find compiled
  table.insert(package.searchers, self.searcher_index, precomp.searcher)
  local module = require 'test.testdata.module'
  lu.assertEquals(module.msg, 'modulesrc')
end

function TestRequire:tearDown()
  precomp.path, precomp.ext = nil, nil

  -- remove searcher function for precompiled modules
  if (self.searcher_index or 0) > 0 then
    table.remove(package.searchers, self.searcher_index)
    self.searcher_index = 0
  end

  -- remove already required modules
  for mod in pairs(package.loaded) do
    if string.find(mod, 'test%.testdata%.') then
      package.loaded[mod] = nil
    end
  end
end

os.exit(lu.LuaUnit.run())
