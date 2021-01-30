defmodule Toastr.Notifier do
  @moduledoc """
  Helper to make useful notifications to be used in LiveView.

  It implements the to_flash/2 function to put flashes on the socket.

  ## Examples

  ```elixir
  defmodule MyWeb.Notifier do
    use Toastr.Notifier, MyWeb.Gettext

    defp model_name(%My.Accounts.User{name: name}), do: {gettext("User"), name}
    defp model_name(%My.Customers.Customer{name: name}), do: {gettext("Customer"), name}

    defp model_name(_), do: :bad_model
  end
  ```

  You can now use this Notfier in `Toastr.Phoenix.Show` and `Toastr.Phoenix.Index`.
  """

  @doc """
  When used, implements Helpers for notifications.
  """
  defmacro __using__(gettext) do
    quote do
      require Logger
      alias Phoenix.LiveView

      defp gettext(msg, opts \\ []), do: Gettext.gettext(unquote(gettext), msg, opts)

      def to_flash(%LiveView.Socket{} = socket, {:error, data, message}) do
        {model, name} = model_name(data)
        msg = "error saving %{model} %{name}: %{message}"
        params = [model: model, name: name, message: gettext(message)]

        socket
        |> LiveView.put_flash(:error, gettext(msg, params))
      end

      def to_flash(%LiveView.Socket{} = socket, {action, data}) do
        case model_name(data) do
          {model, name} ->
            msg = "%{model} %{name} %{action} successfully"
            params = [model: model, name: name, action: gettext(Atom.to_string(action))]

            socket
            |> LiveView.put_flash(:info, gettext(msg, params))

          :bad_model ->
            Logger.error("Got unhandled Notifier data: #{inspect(data)}")
            socket
        end
      end

      def handle_info({action, _data} = msg, socket) when is_atom(action),
        do: {:noreply, to_flash(socket, msg)}
    end
  end

  use Phoenix.HTML

  @doc """
  Renders flash errors as drop in notifications.
  """
  def flash_errors(conn) do
    conn.private[:phoenix_flash]
    |> flash_live_errors()
  end

  @doc """
  Renders live flash errors as drop in notifications.
  """
  def flash_live_errors(nil), do: ~E""

  @doc """
  Renders live flash errors as drop in notifications.
  """
  def flash_live_errors(flashes) do
    ~E"""
      <%= for {category, message} <- flashes do %>
        <span class="live-flash" data-level="<%= category %>"><%= message %></span>
      <% end %>
    """
  end

  @doc """
  Helper function to redirect if its id matches the given id for the given name.
  """
  def redirect_if_id(socket, needed_id, %{"id" => object_id}, to) do
    if object_id != needed_id do
      socket
    else
      Phoenix.LiveView.redirect(socket, to)
    end
  end

  @doc """
  Helper function to update object if its id matches the given id for the given name.
  """
  def update_if_id(socket, name, needed_id, %{"id" => object_id} = object) do
    if object_id != needed_id do
      socket
    else
      Phoenix.LiveView.update(socket, name, fn _ -> object end)
    end
  end

  @doc """
  Helper function to update object if its id matches the given id for the given name, this one does nothing.
  """
  def update_if_id(socket, _, _, _), do: socket
end
