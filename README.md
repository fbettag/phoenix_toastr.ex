# Toastr Notifications for Phoenix Applications

This package implements helpers and macros for generating easy Notifications in LiveViews.

## Installation

This package can be installed by adding `phoenix_toastr` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_toastr, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
defmodule MyWeb.Notifier do
  use Toastr.Notifier, MyWeb.Gettext

  defp model_name(%My.Accounts.User{name: name}), do: {gettext("User"), name}
  defp model_name(%My.Customers.Customer{name: name}), do: {gettext("Customer"), name}

  defp model_name(_), do: :bad_model
end

defmodule MyWeb.MyDataLive.Show do
  use MyWeb, :live_view

  use Toastr.Phoenix.Show,
    notifier: MyWeb.Notifier,
    key: :data,
    pattern: %My.MyData{},
    to: &Routes.my_data_path(&1, :index)

  ...
end

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

Now you can replace your existing flash-helper functions with these two:

<%= Toastr.Notifier.flash_errors(@conn) %>
<%= Toastr.Notifier.flash_live_errors(@flash) %>


## Documentation

Documentation can be found at [https://hexdocs.pm/phoenix_toastr](https://hexdocs.pm/phoenix_toastr).
