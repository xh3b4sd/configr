_        = require "underscore"
Path     = require "path"
Optimist = require "optimist"

###
Create configuration in order of:
  default options
  env options
  custom options
###
exports.create = (env, customOptions = {}) ->
  env = env || Optimist.argv.env || "dev"

  defaultConfigPath = Path.join(__dirname, "../config", "default.coffee")
  envConfigPath     = Path.join(__dirname, "../config", "#{env}.coffee")

  defaultOptions = require defaultConfigPath
  envOptions     = require envConfigPath
  options        = merge {}, defaultOptions, envOptions, customOptions, Optimist.argv

  require.cache[defaultConfigPath] = undefined
  require.cache[envConfigPath] = undefined

  options


merge = (objects...) ->
  dest = {}

  for obj in objects
    dest = mergeRecursive dest, obj

  return dest


mergeRecursive = (dest, obj) ->
  for p of obj
    if _.isObject obj[p]
      if _.isUndefined dest[p]
        dest[p] = obj[p]
      else
        dest[p] = mergeRecursive dest[p], obj[p]
    else
      dest[p] = obj[p]

  return dest
