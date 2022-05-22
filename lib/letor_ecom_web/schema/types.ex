defmodule LetorEcomWeb.Schema.Types do
  @moduledoc """
  Copyright © 2021 Letor Limited.
  All rights reserved.

  """
  use Absinthe.Schema.Notation
  alias LetorEcomWeb.Schema.Types

  import_types(Types.UserType)
end
