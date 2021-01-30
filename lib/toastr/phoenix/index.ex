defmodule Toastr.Phoenix.Index do
  @moduledoc """
  Helper to make useful notifications to be used in LiveView index.ex files.

  It implements handle_info/2 LiveView callbacks for events,
  updates the current assigns if a notification arrives.

  The value function gets passed the socket as first and only parameter.
  This way you can use any assign in the socket to use the correct query.

  ## Examples

  ```elixir
  defmodule MyWeb.MyDataLive.Index do
    use MyWeb, :live_view

    use Toastr.Phoenix.Index,
      notifier: MyWeb.Notifier,
      key: :datas,
      data: %My.MyData{},
      value: &list_datas/1

    ...
  end
  ```
  """

  @doc """
  When used, implements handle_info/2 for index.ex.
  """
  defmacro __using__(opts) do
    notifier = Keyword.get(opts, :notifier)
    assign_key = Keyword.get(opts, :key)
    data_pattern = Keyword.get(opts, :pattern)
    assign_value_fn = Keyword.get(opts, :value)

    quote do
      @impl true
      def handle_info({_, unquote(data_pattern)} = msg, socket) do
        {:noreply,
         socket
         |> unquote(notifier).to_flash(msg)
         |> update(unquote(assign_key), fn _ -> unquote(assign_value_fn).(socket) end)}
      end

      defdelegate handle_info(msg, socket), to: unquote(notifier)
    end
  end
end
