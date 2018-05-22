defmodule DatabaseServer do
  def start do
    spawn(&loop/0)
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

  defp loop do
    receive do
      {:run_query, caller, query_def} ->
        send(caller, {:query_result, run_query(query_def)})
      {:go_boom, caller} ->
        send(caller, {:go_boom, go_boom()})
    end

    loop
  end

  defp run_query(query_def) do
    :timer.sleep(2000)
    "#{query_def} result"
  end

  defp go_boom do
    IO.puts "BOOM"
  end
end
