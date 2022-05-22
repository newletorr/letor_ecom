defmodule LetorEcomWeb.UserSocket do
  use Phoenix.Socket

  use Absinthe.Phoenix.Socket,
    schema: LetorEcomWeb.Schema

  alias LetorEcom.Accounts.User
  alias LetorEcom.Repo

  @spec connect(any, any) :: :error | {:ok, Phoenix.Socket.t()}
  def connect(params, socket) do
    token =
      try do
        params["Authorization"] |> String.split() |> List.last()
      rescue
        ArgumentError -> nil
      end

    if is_nil(token) == false do
      {:ok, claims} = LetorEcom.Guardian.decode_and_verify(token)
      {:ok, user} = LetorEcom.Guardian.resource_from_claims(claims)

      current_user = current_user(user)

      socket =
        Absinthe.Phoenix.Socket.put_options(socket,
          context: %{
            current_user: current_user
          }
        )

      {:ok, socket}
    else
      :error
    end
  end

  defp current_user(user) do
    Repo.get(User, user.id)
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  # def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     LetorEcomWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil

  defdelegate put_options(socket, opts), to: Absinthe.Phoenix.Socket

  defdelegate put_schema(socket, schema), to: Absinthe.Phoenix.Socket
end
