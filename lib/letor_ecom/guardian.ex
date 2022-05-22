defmodule LetorEcom.Guardian do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.

  """
  use Guardian, otp_app: :letor_ecom
  alias LetorEcom.Account.User
  alias LetorEcom.Repo

  @spec subject_for_token(any, any) :: {:error, :reason_for_error} | {:ok, binary}
  def subject_for_token(%User{} = user, _claims) do
    {:ok, to_string(user.id)}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  @spec resource_from_claims(any()) ::
          {:error, :reason_for_error | :resources_not_found} | {:ok, any()}
  def resource_from_claims(%{"sub" => id}) do
    {:ok, user} = Repo.get(User, id)

    case user do
      nil -> {:error, :resources_not_found}
      users -> {:ok, users}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end

  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
      {:ok, {old_token, old_claims}, {new_token, new_claims}}
    end
  end

  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end
end
