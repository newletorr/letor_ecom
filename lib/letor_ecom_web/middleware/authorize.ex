defmodule LetorEcomWeb.Schema.Middleware.Authorize do
  @moduledoc """
  EcomHealthService application Authorization middleware
  """

  @behaviour Absinthe.Middleware

  def call(resolution, role) do
    with %{current_user: current_user} <- resolution.context,
         true <- correct_role?(current_user, role) do
      resolution
    else
      _ ->
        resolution
        |> Absinthe.Resolution.put_result(
          {:error, "You are not authorized to perform this action!"}
        )
    end
  end

  defp correct_role?(%{}, :any), do: true

  defp correct_role?(%{role: role}, role), do: true

  defp correct_role?(%{role: role}, roles) do
    if Enum.member?(roles, role) == true do
      true
    else
      false
    end
  end

  defp correct_role?(_, _), do: false
end
