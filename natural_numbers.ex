defmodule NaturalNums do
  def print(n) when n < 1, do: true
  def print(n) when is_float(n), do: false
  def print(1), do: IO.puts(1)
  def print(n) do
    print(n - 1)
    IO.puts(n)
  end
end

defmodule ListHelper do
  def sum([]), do: 0
  def sum([head | tail]) do
    head + sum(tail)
  end

  def psum(list) do
    do_sum(0, list)
  end

  defp do_sum(curr_sum, []) do
     curr_sum
  end

  defp do_sum(curr_sum, [head | tail]) do
    new_sum = curr_sum + head
    do_sum(new_sum, tail)
  end
end
