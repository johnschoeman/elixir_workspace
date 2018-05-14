defmodule MyTest do
  use TestCase

  test "arithmentic operations" do
    4 = 2 + 2
  end

  test "list operations" do
    [1,2,3] = [1,2] ++ [3]
  end
end

MyTest.run
