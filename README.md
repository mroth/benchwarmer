Benchwarmer
===========

Benchwarmer is an Elixir micro-benchmarking utility that runs a function (or list of functions) repeatedly against a dataset for a period of time, and then reports on the average time each operation took to complete, allowing for easy comparison.

Benchwarmer was inspired by the built-in benchmark operations in the Go test library.


Installation
------------
Add Benchwarmer to your `mix.exs` dependencies with whatever published semantic version you'd like to depend on.

```elixir
def deps do
  [ { :benchwarmer, "~> x.y.z" } ]
end
```


Usage
-----
You can simply pass an inline function, results will be pretty printed to screen as well as returned in a struct:

```iex
iex> Benchwarmer.benchmark fn -> 123456*654321 end
*** #Function<20.90072148/0 in :erl_eval.expr/5> ***
1.2 sec     2M iterations   0.61 μs/op

[%Benchwarmer.Results{...}]
```

Comparing two different functions with the same data as an argument:

```iex
iex> alphabet = "abcdefghijklmnopqrstuvwxyz"
iex> Benchwarmer.benchmark [&String.first/1, &String.last/1], alphabet
*** &String.first/1 ***
1.9 sec     8M iterations   0.24 μs/op

*** &String.last/1 ***
1.9 sec   524K iterations   3.75 μs/op

[%Benchwarmer.Results{...}, %Benchwarmer.Results{...}]
```


Compared to other Elixir benchmarking tools
-------------------------------------------
For TDD-style benchmarking, you should probably check out [Benchfella][bf], which I discovered after starting this project.  It's quite good.

This library is a little more focused on quick comparative benchmarks in IEx, working without adding a single line of code to your actual project files.


Work in Progress
----------------
Please note this library is a work in progress, and the API will likely change.

Pull requests are welcome!

[bf]: https://github.com/alco/benchfella
