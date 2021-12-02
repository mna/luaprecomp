local compiled = require 'test.testdata.compiled'    -- compiled only
local subsource = require 'test.testdata.sub.source' -- source only
local module = require 'test.testdata.module'        -- both available
local submodule = require 'test.testdata.sub.module' -- both available

return compiled.msg .. subsource.msg .. module.msg .. submodule.msg
