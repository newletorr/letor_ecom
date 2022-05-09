defmodule LetorEcom.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.Account` context.
  """

  @doc """
  Generate a viewed_item.
  """
  def viewed_item_fixture(attrs \\ %{}) do
    {:ok, viewed_item} =
      attrs
      |> Enum.into(%{

      })
      |> LetorEcom.Account.create_viewed_item()

    viewed_item
  end
end
