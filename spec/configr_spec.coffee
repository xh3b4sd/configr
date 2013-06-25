_          = require "underscore"
Path       = require "path"
Optimist   = require "optimist"
SpecHelper = require "../spec_helper"
Configr    = require "../../lib/configr"

describe "Configr", ->
  describe "environments", ->
    afterEach ->
      delete Optimist.argv.env

    it "should default to dev environment", ->
      config = Configr.create()
      expect(config.env).toEqual("dev")

    it "should use command line environment", ->
      Optimist.argv.env = "stage"
      config = Configr.create()
      expect(config.env).toEqual("stage")

    it "should use dev environment", ->
      config = Configr.create("dev")
      expect(config.env).toEqual("dev")

    it "should use stage environment", ->
      config = Configr.create("stage")
      expect(config.env).toEqual("stage")

    it "should use live environment", ->
      config = Configr.create("live")
      expect(config.env).toEqual("live")


  describe "require.cache", ->
    it "should not cache default configurations to prevent side effects", ->
      defaultConfigPath = Path.join(__dirname, "../config", "default.coffee")

      config = Configr.create()

      expect(require.cache[defaultConfigPath]).toBeUndefined()

    it "should not cache dev configurations to prevent side effects", ->
      devConfigPath = Path.join(__dirname, "../config", "dev.coffee")

      config = Configr.create()

      expect(require.cache[devConfigPath]).toBeUndefined()

    it "should not cache stage configurations to prevent side effects", ->
      stageConfigPath = Path.join(__dirname, "../config", "stage.coffee")

      config = Configr.create()

      expect(require.cache[stageConfigPath]).toBeUndefined()

    it "should not cache live configurations to prevent side effects", ->
      liveConfigPath = Path.join(__dirname, "../config", "live.coffee")

      config = Configr.create()

      expect(require.cache[liveConfigPath]).toBeUndefined()


  describe "error handling", ->
    it "should throw errors if something went wrong", ->
      expect( ->
        config = Configr.create("wrongEnvironment")
      ).toThrow()


  describe "merging", ->
    [ customOptions ] = []

    beforeEach ->
      customOptions =
        retargeting:
          redisClient: {}

    it "should merge correctly", ->
      config = Configr.create("dev", customOptions)
      expect(config.retargeting).toEqual
        redis_db: 1
        redis_retry_delay: 300000
        threshholds:
          abort_after: 100
          reenable_time: 30000
          failure_threshold: 100
        redisClient: {}
