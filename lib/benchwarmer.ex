defmodule Benchwarmer do
  @moduledoc """
  Benchwarmer is an Elixir micro-benchmarking utility that runs a function (or
  list of functions) repeatedly against a dataset for a period of time, and then
  reports on the average time each operation took to complete, allowing for easy
  comparison.

  Benchwarmer was inspired by the built-in benchmark operations in the Go
  test library.
  """

  @default_duration 1_000_000 # 1 second (1Mμs)

  alias Benchwarmer.Results

  @doc """
  Benchmarks a function or list of functions with optional args.

  ## Examples

    iex> Benchwarmer.benchmark fn -> 123456*654321 end
    #Function<20.90072148/0 in :erl_eval.expr/5>
    1.2 sec   2M iterations   0.61 μs/op

    iex> Benchwarmer.benchmark [&String.first/1, &String.last/1], ["abcdefghijklmnop"]
    &String.first/1
    1.0 sec   4M iterations   0.24 μs/op
    &String.last/1
    1.2 sec   524K iterations   2.33 μs/op
  """
  def benchmark(f, args \\ [], min_duration \\ @default_duration)
  def benchmark(f, args, min_duration) when is_function(f) do
    benchmark([f], args, min_duration)
  end
  def benchmark(f, args, min_duration) when is_list(f) and is_list(args) do
    Enum.each(f, fn(fp) ->
      IO.inspect fp

      results = do_benchmark(fp, args, min_duration)
      IO.puts results
    end)
  end

  #
  # Benchmarks an individual function against args and returns results.
  #
  defp do_benchmark(f, args, min_duration, results \\ %Results{}) do
    # TODO: does this help with the load timer issues? check it out.
    :timer.start()

    cond do
      # when elapsed test time is greater than minimum, return results
      results.duration >= min_duration -> results

      # first pass, run for a single iteration only
      results.n == 0 ->
        {:ok, _, optime} = run_n_times(f, args, 1)
        do_benchmark( f, args, min_duration,
                      %{results | n: 1, prev_n: 1, duration: optime}
                    )

      # default case, run with double iterations of previous instance
      true ->
        {:ok, iters, optime} = run_n_times(f, args, results.prev_n * 2)
        do_benchmark( f, args, min_duration,
                      %{results | n: results.n + iters,
                                  prev_n: iters,
                                  duration: results.duration + optime
                      }
                    )
    end
  end

  #
  # Runs a function with args N times.
  #
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
