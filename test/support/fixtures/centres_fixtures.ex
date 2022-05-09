defmodule LetorEcom.CentresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.Centres` context.
  """

  @doc """
  Generate a pick_up.
  """
  def pick_up_fixture(attrs \\ %{}) do
    {:ok, pick_up} =
      attrs
      |> Enum.into(%{
        pick_up_code: "some pick_up_code",
        pick_up_time: ~U[2022-05-07 23:03:00Z],
        picked: true
      })
      |> LetorEcom.Centres.create_pick_up()

    pick_up
  end
end
