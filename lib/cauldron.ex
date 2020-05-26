defmodule Cauldron do
  use GenServer
  @short 200
  @long 400
  
  def toil_and_trouble(server) do
    short_wait()
    toil(server)
    IO.puts "MQ Length: #{message_queue_length(server)}"
    toil_and_trouble(server)
  end
  
  defp toil(server) do
    :ok = GenServer.call(server, :toil)
  end
  
  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end
  
  def init(initial_value) do
    {:ok, initial_value}
  end
  
  def handle_cast(:toil, state) do
    long_job()
    {:noreply, state + 1}
  end

  def handle_call(:toil, _from, state) do
    long_job()
    {:reply, :ok, state + 1}
  end
  
  defp message_queue_length(pid) do
    pid
    |> Process.info(:message_queue_len) 
    |> elem(1)
  end
    
  defp short_wait, do: wait(@short)
  
  defp long_job, do: wait(@long)
  
  defp wait(time) do
    time
    |> :random.uniform
    |> Process.sleep
  end
end
