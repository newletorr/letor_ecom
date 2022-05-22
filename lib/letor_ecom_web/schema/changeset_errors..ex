defmodule LetorEcomWeb.Schema.ChangesetErrors do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  alias Ecto.Changeset

  @spec transform_errors(Ecto.Changeset.t()) :: [any]
  def transform_errors(changeset) do
    changeset
    |> Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn
      {key, value} ->
        %{key: key, message: value}
    end)
  end

  @spec format_error(Ecto.Changeset.error()) :: String.t()
  def format_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
