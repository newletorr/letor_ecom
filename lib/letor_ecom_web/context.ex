defmodule LetorEcomWeb.Context do
  @moduledoc """
  Copyright © Letor Limited.
  All rights reserved.
  """

  alias LetorEcom.Guardian

  import Plug.Conn
  alias Absinthe.Plug

  @spec init(any()) :: any()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _) do
    context = build_context(conn)
    Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    %{}
    |> add_remote_ip_to_context(conn)
    |> add_users_to_context(conn)
  end

  defp add_remote_ip_to_context(%{} = context, conn) do
    case conn.remote_ip do
      remote_ip when is_tuple(remote_ip) -> Map.put(context, :remote_ip, get_string_ip(remote_ip))
      _ -> context
    end
  end

  defp add_users_to_context(%{} = context, conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Guardian.decode_and_verify(token),
         {:ok, user} <- Guardian.resource_from_claims(claims) do
      Map.put(context, :current_user, user)
    else
      nil ->
        {:error, "unauthorized"}

      _ ->
        %{}
    end
  end

  defp get_string_ip(address) when is_tuple(address) do
    address
    |> :inet_parse.ntoa()
    |> IO.iodata_to_binary()
  end
end
