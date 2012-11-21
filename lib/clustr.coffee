Cluster = require("adcloud-cluster")

cluster = Cluster.create
  webWorker:
    count: 4
    cpuBinding: true
  cacheWorker:
    count: 4
    cpuBinding: true



cluster.master.do () =>
  webWorker.send.toWebWorker
    message:
      to: "webWorker"

  webWorker.send.toCacheWorker
    message:
      to: "cacheWorker"

cluster.webWorker.do (webWorker) =>
  webWorker.send.toMaster
    message:
      to: "master"

  webWorker.send.toCacheWorker
    message:
      to: "cacheWorker"

cluster.cacheWorker.do () =>
  webWorker.send.toMaster
    message:
      to: "master"

  webWorker.send.toWebWorker
    message:
      to: "webWorker"
