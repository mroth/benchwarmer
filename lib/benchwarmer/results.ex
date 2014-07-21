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
