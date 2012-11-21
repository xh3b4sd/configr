_            = require("underscore")
optimist     = require("optimist")

###
# Order of parsed options:
#   process
#   default
#   environment
#   dynamic
###
class exports.Configr
  @create: (env) ->
    env = env or optimist.argv.env or "development"
    options = require("../../config/#{env}.coffee")
    options.defaults.env = env

    require.cache["#{__dirname}/#{env}.coffee"] = undefined

    _.each optimist.argv, (argument, name) =>
      options.defaults[name] = argument

    @dynamic(options)

  @dynamic: (options) ->
    _.each require("./dynamic"), (option, name) =>
      _.each option, (dynMethod, dynName) =>
        options[name][dynName] = dynMethod(options) or options[name][dynName]

    options
