defmodule Benchwarmer.Results do
  defstruct(
    n: 0,          # completed iterations
    prev_n: 0,     # iterations run in previous cycle
    duration: 0    # time elapsed in μs
    #bytes: 0,     # TODO: optional bytes for MB/s calcs (see golang version)
  )

  alias Benchwarmer.Results
  def optime(%Results{n: 0}), do: 0.0
  def optime(%Results{duration: duration, n: n}), do: duration / n

end


defimpl String.Chars, for: Benchwarmer.Results do
  alias Benchwarmer.Results.Helpers

  def to_string(r) do
    Enum.join [ "#{Helpers.pretty_time(r.duration)} sec",
                "#{Helpers.pretty_num(r.n)} iterations",
                "#{Helpers.pretty_optime(r)} μs/op" ], "   "
  end
end

defmodule Benchwarmer.Results.Helpers do
  @moduledoc """
  Helper methods used to format Benchwarmer.Results when rendered to string or
  inspected in iex.

  Mostly one-off string formatters. You can safely ignore these. :-)
  """

  def pretty_optime(r) do
    Float.ceil(Benchwarmer.Results.optime(r), 2)
  end

  def pretty_time(ms) do
    Float.floor(ms/1_000_000, 1) |> Kernel.to_string
  end

  def pretty_num(n) do
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
