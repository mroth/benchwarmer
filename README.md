Benchwarmer (Work in Progress)
===========

Benchwarmer is an Elixir micro-benchmarking utility that runs a function (or
list of functions) repeatedly against a dataset for a period of time, and then
reports on the average time each operation took to complete, allowing for easy
comparison.

Benchwarmer was inspired by the built-in benchmark operations in the Go
test library.


## Examples

    iex> Benchwarmer.benchmark fn -> 123456*654321 end
    #Function<20.90072148/0 in :erl_eval.expr/5>
    1.2 sec   2M iterations   0.61 μs/op

    iex> Benchwarmer.benchmark [&String.first/1, &String.last/1], ["abcdefghijklmnop"]
    &String.first/1
    1.0 sec   4M iterations   0.24 μs/op
    &String.last/1
    1.2 sec   524K iterations   2.33 μs/op
