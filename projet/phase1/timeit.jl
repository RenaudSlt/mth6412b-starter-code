""" Donne le temps moyen d'exécution de l'instruction fn(args) sur nruns essais """
function timeit(fn, args...; nruns=1)
  fn(args...)

  times = zeros(nruns)
  for run = 1 : nruns
    val, t, bytes, gctime, memallocs = @timed fn(args...)
    times[run] = t
  end
  return sum(times) / nruns
end