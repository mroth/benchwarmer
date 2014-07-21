defmodule Benchwarmer.Results do
  defstruct(
    n: 0,          # completed iterations
    prev_n: 0,     # iterations run in previous cycle
    duration: 0    # time elapsed in μs
    #bytes: 0,     # TODO: optional bytes for MB/s calcs (see golang version)
  )
end

defimpl String.Chars, for: Benchwarmer.Results do
  def to_string(r) do
    "#{pretty_time(r.duration)} sec   #{pretty_num(r.n)} iterations   #{opsec(r)} μs/op"
  end

  defp opsec(%Benchwarmer.Results{n: 0}), do: 0
  defp opsec(r) do
    Float.ceil(r.duration / r.n, 2)
  end

  defp pretty_time(ms) do
    Float.floor(ms/1_000_000, 1) |> Kernel.to_string
  end

  defp pretty_num(n) do
    cond do
      n >= 1_000_000_000_000 ->
        Kernel.to_string(trunc(Float.floor(n/1_000_000_000_000))) <> "T"
      n >= 1_000_000_000 ->
        Kernel.to_string(trunc(Float.floor(n/1_000_000_000))) <> "B"
      n >= 1_000_000 ->
        Kernel.to_string(trunc(Float.floor(n/1_000_000))) <> "M"
      n >= 1000 ->
        Kernel.to_string(trunc(Float.floor(n/1000))) <> "K"
      true -> Kernel.to_string(n)
    end
  end
end

defmodule Benchwarmer do
  @moduledoc """
  Benchwarmer is a microbenchmarking utility that runs a function (or list of
  functions) repeatedly against a dataset for a period of time (default: 1
  second), and then reports on the average time each operation took to complete.

  Highly inspired by the built-in benchmark operations in Go.
  """

  # minimum duration for a benchmark is 1 second (1Mμs)
  @min_duration 1_000_000

  alias Benchwarmer.Results

  @doc """
  Benchmarks a function or list of functions with optional args.

  ## Examples
    iex> Benchwarmer.benchmark &String.last/1, ["abcdefghijklmnop"]

    iex> Benchwarmer.benchmark [&String.first/1, &String.last/1], ["abcdefghijklmnop"]
    &String.first/1
    1.0 sec   4M iterations   0.24 μs/op
    &String.last/1
    1.2 sec   524K iterations   2.33 μs/op
  """
  # args is a list of arguments, as a list
  def benchmark(f, args \\ [])
  def benchmark(f, args) when is_function(f), do: benchmark([f], args)
  def benchmark(functions, args) when is_list(functions) do
    Enum.each(functions, fn(f) ->
      IO.inspect f

      results = do_benchmark(f, args)
      IO.puts results
    end)
  end

  defp do_benchmark(f, args, r \\ %Results{}) do
    # TODO: does this help with the load timer issues?
    :timer.start()

    cond do
      # if elapsed test time is greater than minimum, return no matter what
      r.duration >= @min_duration -> r

      # first time run for a single iteration
      r.n == 0 ->
        {:ok, _, optime} = run_n_times(f, args, 1)
        do_benchmark( f, args, %{r | n: 1, prev_n: 1, duration: optime} )

      # default case, run with double iterations of previous instance
      true ->
        {:ok, iters, optime} = run_n_times(f, args, r.prev_n * 2)
        do_benchmark( f, args, %{r | n: r.n + iters, prev_n: iters, duration: r.duration + optime} )
    end
  end

  defp run_n_times(f, args, 1) do
    {optime, _results} = :timer.tc(f, args)
    {:ok, 1, optime}
  end
  defp run_n_times(f, args, n) do
    start = :erlang.now
    for _n <- 1..n, do: apply(f, args)
    stop = :erlang.now
    optime = :timer.now_diff(stop, start)
    {:ok, n, optime}
  end

end
