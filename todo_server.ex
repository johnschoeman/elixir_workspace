defmodule TodoServer do
  def start do
    todo_server_pid = spawn(fn -> loop(TodoList.new) end)
    Process.register(todo_server_pid, :todo_server)
  end

  def entries(date) do
    send(:todo_server, {:entries, self, date})

    receive do
      {:todo_entries, entries} -> entries
    after 5000 ->
      {:error, :timeout}
    end
  end

  def add_entry(new_entry) do
    send(:todo_server, {:add_entry, new_entry})
  end

  def update_entry(old_entry, new_entry) do
    send(:todo_server, {:update_entry, old_entry, new_entry})
  end

  def delete_entry(entry) do
    send(:todo_server, {:delete_entry, entry})
  end

  defp loop(todo_list) do
    new_todo_list = receive do
      message ->
        process_message(todo_list, message)
    end

    loop(new_todo_list)
  end

  defp process_message(todo_list, {:entries, caller, date}) do
    send(caller, {:todo_entries, TodoList.entries(todo_list, date)})
    todo_list
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:update_entry, old_entry, new_entry}) do
    TodoList.update_entry(todo_list, old_entry, new_entry)
  end

  defp process_message(todo_list, {:delete_entry, entry}) do
    TodoList.delete_entry(todo_list, entry)
  end
end

defmodule TodoList do
  def new do
    []
  end

  def add_entry(todo_list, entry) do
    [entry | todo_list]
  end

  def update_entry(todo_list, old_entry, new_entry) do
    todo_list |> Enum.map(fn(entry) ->
      case entry do
        old_entry ->
          new_entry
        _ ->
          entry
      end
    end)
  end

  def delete_entry(todo_list, entry) do
    todo_list |> Enum.filter(fn(old_entry) -> old_entry != entry end)
  end

  def entries(todo_list, date) do
    todo_list |> Enum.filter(fn(entry) ->
      %{date: entry_date} = entry
      entry_date == date
    end)
  end

end
