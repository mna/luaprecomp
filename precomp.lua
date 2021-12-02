local m = {}

local DEFAULT_EXT = '.luac'

function m.searcher(name)
  local path = m.path
  if not path then
    local ext = m.ext or DEFAULT_EXT
    path = string.gsub(package.path, '(%.lua)%f[%W]', ext)
  end

  local file, err = package.searchpath(name, path)
  if not file then
    return err
  end

  return function(_, filepath)
    local fn = loadfile(filepath, 'b')
    return fn()
  end, file
end

return m
