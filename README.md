Benchwarmer
===========

Benchwarmer is an Elixir micro-benchmarking utility that runs a function (or list of functions) repeatedly against a dataset for a period of time, and then reports on the average time each operation took to complete, allowing for easy comparison.

Benchwarmer was inspired by the built-in benchmark operations in the Go test library.


## Examples
You can simply pass an inline function, results will be pretty printed to screen
as well as returned in a struct:

    iex> Benchwarmer.benchmark fn -> 123456*654321 end
    *** #Function<20.90072148/0 in :erl_eval.expr/5> ***
    1.2 sec     2M iterations   0.61 μs/op

    [%Benchwarmer.Results{...}]

Comparing two different functions with the same data as an argument:

    iex> alphabet = "abcdefghijklmnopqrstuvwxyz"
    iex> Benchwarmer.benchmark [&String.first/1, &String.last/1], alphabet
    *** &String.first/1 ***
    1.9 sec     8M iterations   0.24 μs/op

    *** &String.last/1 ***
    1.9 sec   524K iterations   3.75 μs/op

    [%Benchwarmer.Results{...}, %Benchwarmer.Results{...}]

## Work in Progress
Please note this library is a work in progress, and the API will likely change.  In particular, I'm looking for feedback from the Elixir community as to what would be useful before declaring a version `0.0.1` and uploading on Hex.

Therefore, please give it a try and send me your feedback (or pull requests!)
