# ============================================================================ #
#                                                                              #
#                        Algorithms for the Benchmark                          #
#                                                                              #
# ============================================================================ #

# compboost:
# -------------------------

benchmarkCompboost = function (job, data, instance, iters, learner) {

  gc()

  if (! learner %in% c("spline", "linear")) {
    stop("No valid learner!")
  }

  y.idx = which(names(instance$data) == "y")
  data.names = names(instance$data[, -y.idx])

  time = proc.time()

  mem.change = pryr::mem_change(code = {
    cboost.objects = list(source = list(), target = list(), factory = list())
    factory.list   = BlearnerFactoryList$new()
    for (i in data.names) {
      cboost.objects[["source"]][[i]] = list()
      if (learner == "spline") {
        cboost.objects[["source"]][[i]] = InMemoryData$new(as.matrix(instance$data[, i]), i)
      }
      if (learner == "linear") {
        cboost.objects[["source"]][[i]] = InMemoryData$new(cbind(1, instance$data[, i]), i)
      }

      cboost.objects[["target"]][[i]] = list()
      cboost.objects[["target"]][[i]] = InMemoryData$new()

      cboost.objects[["factory"]][[i]] = list()
      if (learner == "spline") {
        cboost.objects[["factory"]][[i]] = PSplineBlearnerFactory$new(
          cboost.objects[["source"]][[i]], cboost.objects[["target"]][[i]], 3, 20, 2, 2
        )
      }
      if (learner == "linear") {
        cboost.objects[["factory"]][[i]] = PolynomialBlearnerFactory$new(
          cboost.objects[["source"]][[i]], cboost.objects[["target"]][[i]], 1
        )
      }

      factory.list$registerFactory(cboost.objects[["factory"]][[i]])
    }

    iteration.logger = IterationLogger$new(TRUE, iters)
    logger.list = LoggerList$new()
    logger.list$registerLogger("iteration", iteration.logger)

    myloss      = QuadraticLoss$new()
    myoptimizer = GreedyOptimizer$new()

    target = instance$data[, y.idx]

    # Initialize object:
    cboost = Compboost$new(
      response      = target,
      learning_rate = 0.05,
      stop_if_all_stopper_fulfilled = FALSE,
      factory_list = factory.list,
      loss         = myloss,
      logger_list  = logger.list,
      optimizer    = myoptimizer
    )
    cboost$train(trace = FALSE)
  })

  time = proc.time() - time

  return (list(time = time, data.dim = dim(instance$data), learner = learner,
    iters = iters, algo = "compboost", mem.change = mem.change))
}

# mboost:
# -------------------------

benchmarkMboost = function (job, data, instance, iters, learner) {

  gc()

  y.idx = which(names(instance$data) == "y")
  data.names = names(instance$data[, -y.idx])
  if (learner == "spline") {
    myformula = paste0(
      "y ~ ",
      paste(
        paste0("bbs(", data.names, ", knots = 20, degree = 3, differences = 2, lambda = 2)"),
        collapse = " + "
      )
    )
  }
  if (learner == "linear") {
    myformula = paste0(
      "y ~ ",
      paste(
        paste0("bols(", data.names, ")"),
        collapse = " + "
      )
    )
  }
  if (! learner %in% c("spline", "linear")) {
    stop("No valid learner!")
  }

  time = proc.time()
  mem.change = pryr::mem_change(code = {
    mod = mboost(formula = as.formula(myformula), data = instance$data,
      control = boost_control(mstop = iters, nu = 0.05, trace = FALSE))
  })
  time = proc.time() - time

  return (list(time = time, data.dim = dim(instance$data), learner = learner,
    iters = iters, algo = "mboost", mem.change = mem.change))

}
