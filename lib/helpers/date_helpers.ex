defmodule LetorEcom.Helpers.DateHelpers do
  @moduledoc """
  Copyright © 2021 Letorr Nigeria Limited.
  All rights reserved.

  """
  @spec expired?(nil | %{calendar: any, microsecond: any}, any) :: boolean
  def expired?(nil, _), do: true

  def expired?(datetime, opts) do
    not Timex.before?(Timex.now(), shift(datetime, opts))
  end

  def shift(datetime, opts) do
    datetime
    |> NaiveDateTime.to_erl()
    |> Timex.to_datetime()
    |> Timex.shift(opts)
  end
end
