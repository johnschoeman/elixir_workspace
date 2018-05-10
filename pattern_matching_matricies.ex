defmodule UseRecursion do
  def get_diagonals([[]]), do: [[]]
  def get_diagonals([[a]]), do: [[a]]
  def get_diagonals(matrix) do
    prev_diagonals = get_diagonals(sub_matrix(matrix))
    first_row = hd(matrix)
    first_col = hd(transpose(matrix))

    IO.puts "--------"
    IO.inspect matrix
    IO.inspect first_row
    IO.inspect first_col

  end

  def sub_matrix(matrix) do
    matrix
     |> remove_first_row
     |> transpose
     |> remove_first_row
  end

  def transpose([]), do: []
  def transpose([[]|_]), do: []
  def transpose(matrix) do
    [Enum.map(matrix, &hd/1) | transpose(Enum.map(matrix, &tl/1))]
  end

  def remove_first_row(matrix) do
    [_ | rest] = matrix
    rest
  end
end

defmodule BuildItUp do
  def get_diagonals(matrix) do
    matrix
      |> length
      |> diagonal_indicies
      |> Enum.map(fn list -> get_matrix_elements(list, matrix) end)
  end

  def get_matrix_elements(list, matrix) do
    list |> Enum.map(fn index -> get_element(index, matrix) end)
  end

  def get_element({row, col}, matrix) do
    matrix |> Enum.at(row) |> Enum.at(col)
  end

  def diagonal_indicies(n) do
    main_diagonal = build_main_diagonal(n)
    upper_diagonals = build_upper_diagonals(main_diagonal)
    lower_diagonals = build_lower_diagonals(upper_diagonals)
    upper_diagonals ++ [main_diagonal] ++ lower_diagonals
  end

  def build_main_diagonal(n) do
    (0..(n-1)) |> Enum.to_list |> Enum.map(fn x -> {x, x} end)
  end

  def build_upper_diagonals([{a, b}, _]) do
    [[{a, b + 1}]]
  end
  def build_upper_diagonals(diagonal) do
    next_diagonal = diagonal
      |> Enum.drop(-1)
      |> Enum.map(fn {a, b} -> {a, b + 1} end)

    prev_diagonals = build_upper_diagonals(next_diagonal)

    prev_diagonals ++ [next_diagonal]
  end

  def build_lower_diagonals(upper_diagonals) do
    upper_diagonals
      |> Enum.map(&reverse_tuples/1)
      |> Enum.reverse
  end

  def reverse_tuples(list) do
    list |> Enum.map(&reverse_tuple/1)
  end

  def reverse_tuple({a, b}), do: {b, a}
end

m1 = [[0]]
m2 = [[0,1],[2,3]]
m3 = [['0','1','2',],['3','4','5'],['6','7','8']]
m4 = [['0','1','2','3'],['4','5','6','7'],['8','9','10','11'],['12','13','14','15']]

IO.inspect UseRecursion.get_diagonals(m1)
IO.inspect UseRecursion.get_diagonals(m2)
IO.inspect UseRecursion.get_diagonals(m3)
IO.inspect UseRecursion.get_diagonals(m4)

IO.inspect BuildItUp.get_diagonals(m4)
