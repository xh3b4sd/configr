module.exports =
  defaults:
    slaves: (options) ->
      {webWorker, cacheWorker, mode} = options.defaults
      webWorker + cacheWorker if mode is "master"
