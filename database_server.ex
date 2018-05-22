defmodule DatabaseServer do
  def start do
    spawn(fn ->
      connection = :random.uniform(1000)
      loop(connection)
    end)
  end

  def run_async(server_pid, query_def, query \\ :run_query) do
    case query do
      :run_query ->
        send(server_pid, {:run_query, self, query_def})
      _ ->
        send(server_pid, {:go_boom, self})
    end
  end

  def get_result do
    receive do
      {:query_result, result} -> result
      {:boom_result, result} -> result
    after 5000 ->
      {:error, :timeout}
    end
  end

  defp loop(connection) do
    receive do
      {:run_query, from_pid, query_def} ->
        query_result = run_query(connection, query_def)
        send(from_pid, {:query_result, query_result})
      {:go_boom, from_pid} ->
        send(from_pid, {:go_boom, go_boom()})
    end

    loop(connection)
  end

  defp run_query(connection, query_def) do
    :timer.sleep(2000)
    "Connection #{connection} : #{query_def} result"
  end

  defp go_boom do
    IO.puts "BOOM"
  end
end
