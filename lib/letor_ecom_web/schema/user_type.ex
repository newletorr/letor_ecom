defmodule LetorEcomWeb.Schema.Types.UserType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  # import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Account, Guardian, Repo, Sms}
  alias LetorEcom.Account.{Confirmation, User, Session}

  # alias EcomHealthServiceWeb.Email
  alias LetorEcomWeb.Schema.Middleware

  object :users_type do
    field :id, :id
    field :email, :string
    field :address, :string
    # field :business_name, :string
    field :confirmation_code, :string
    field :confirmation_sent_at, :datetime
    field :confirmed_at, :datetime
    field :current_sign_at, :datetime
    field :current_sign_in_ip, :string
    field :current_sign_in_location, :string
    field :user_image, :string
    field :date_of_birth, :date
    field :facebood_id, :string
    field :first_name, :string
    field :first_referal_earned, :boolean
    field :fourth_referal_earned, :string
    field :full_name, :string
    # field :image, LetorEcom.Uploads.Type
    field :last_name, :string
    field :last_sign_in_at, :datetime
    field :last_sign_in_ip, :string
    field :password_hash, :string
    field :phone, :string
    field :referal_code, :string
    field :referal_points_earned, :string
    field :role, :string
    field :second_referal_earned, :string
    field :sign_in_count, :integer
    field :third_referal_earned, :string

    field(:error, list_of(:mutation_error))
  end

  object :session_type do
    field(:user, non_null(:users_type))
    field(:token, non_null(:string))
    field(:error, list_of(:mutation_error))
  end

  input_object :self_checkout_registration_type do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:address, :string)
    field(:password, :string)
    field(:password_confirmation, :string)
    field(:phone, :string)
  end

  input_object :customer_input_type do
    field(:first_name, non_null(:string))
    field(:last_name, non_null(:string))
    field(:email, non_null(:string))
    field(:address, non_null(:string))
    field(:password, non_null(:string))
    field(:phone, non_null(:string))
    field(:referers_code, :string)
    field(:password_confirmation, non_null(:string))
    field(:location_id, non_null(:id))
  end

  input_object :staff_user_input_type do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:password, :string)
    field(:password_confirmation, :string)
    field(:role, :string)
    field(:staff_id, :id)
  end

  input_object :suppliers_user_input_type do
    field(:business_name, :string)
    field(:email, :string)
    field(:password, :string)
    field(:password_confirmation, :string)
    field(:supplier_id, :id)
  end

  input_object :login_input_type do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
  end

  input_object :image_upload_type do
    field :image, non_null(:upload)
  end

  enum :provider do
    value(:facebook)
  end

  object :user_mutation do
    field :register_customer_pat, :users_type,
      description: "Create Users/Patients user account information" do
      arg(:input, non_null(:customer_input_type))

      resolve(fn %{input: input}, _ ->
        with {:ok, %{user: user}} <- Account.register_customer(input),
             {:ok, _sms} <- Sms.send_code(user) do
          {:ok, user}
        else
          {:error, :user, changeset, _} ->
            {:error, transform_errors(changeset)}
        end
      end)
    end

    field :update_customer, :users_type,
      description: "Update Customers/Patients user account information" do
      arg(:input, :staff_user_input_type)
      middleware(Middleware.Authorize, :any)

      resolve(fn %{input: input}, %{context: %{current_user: current_user}} ->
        case Account.update_user(current_user, input) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, user} ->
            {:ok, user}
        end
      end)
    end

    field :register_staff_user, :users_type,
      description: "Create Users/Patients user account information" do
      arg(:input, non_null(:staff_user_input_type))

      resolve(fn %{input: input}, _ ->
        with {:ok, created_user} <- Account.create_staff_user(input),
             {:ok, _code, user_with_code} <-
               Confirmation.generate_confirmation_code(created_user),
             {:ok, _sms} <- Sms.send_code(user_with_code) do
          {:ok, user_with_code}
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          _ -> {:error, "Something went wrong, please try again!"}
        end
      end)
    end

    @desc "confirm account"
    field :confirm_account, :session_type do
      arg(:email, non_null(:string))
      arg(:code, non_null(:string))

      resolve(fn args, %{context: context} ->
        with {:ok, user} <- Account.user_by_email(args[:email]),
             {:ok, confirmed_user} <-
               Confirmation.confirm_account(user, args[:code]),
             {:ok, token, _} <- Guardian.encode_and_sign(confirmed_user) do
          confirmed_user |> Account.update_tracked_fields(context[:remote_ip])

          {:ok, %{user: user, token: token}}
        else
          {:error, %Ecto.Query{} = _query} -> {:ok, "The email: #{args[:email]} does not exist"}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          _ -> {:error, "Something went wrong,"}
        end
      end)
    end

    @desc "Resend confirmation"
    field :resend_confirmation, :boolean do
      arg(:email, non_null(:string))

      resolve(fn args, _ ->
        with {:ok, user} <- Account.user_by_email(args[:email]),
             {:ok, _code, user_with_code} <- Confirmation.generate_confirmation_code(user),
             {:ok, _sms} <- Sms.send_code(user_with_code) do
          {:ok, true}
        else
          {:error, %Ecto.Query{}} -> {:ok, "The email: #{args[:email]} does not exist! "}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          _ -> {:error, "Something went wrong, please try again"}
        end
      end)
    end

    field :update_staff_user, :users_type, description: "Update Staff User account information" do
      arg(:input, :staff_user_input_type)

      middleware(Middleware.Authorize, [
        "super admin",
        "admin",
        "dispatcher",
        "store manager",
        "purchasing",
        "content officer",
        "first level control",
        "second level control",
        "third level control"
      ])

      resolve(fn %{input: params}, %{context: %{current_user: current_user}} ->
        case Account.update_staff_user(current_user, params) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, user} ->
            {:ok, user}
        end
      end)
    end

    field :register_supplier, :users_type, description: "Create Supplier user account information" do
      arg(:input, non_null(:suppliers_user_input_type))

      middleware(Middleware.Authorize, [
        "super admin",
        "admin",
        "first level control",
        "second level control",
        "third level control"
      ])

      resolve(fn %{input: input}, %{context: context} ->
        case Account.create_supplier_user(input) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, user} ->
            {:ok, jwt_token, _} = Guardian.encode_and_sign(user)
            user |> Account.update_tracked_fields(context[:remote_ip])

            {:ok, %{user: user, token: jwt_token}}
        end
      end)
    end

    field :update_supplier_registration, :users_type,
      description: "Update Suppliers User account information" do
      arg(:input, :suppliers_user_input_type)

      middleware(Middleware.Authorize, [
        "super admin",
        "admin",
        "supplier",
        "first level control",
        "second level control",
        "third level control"
      ])

      resolve(fn %{input: params}, %{context: %{current_user: current_user}} ->
        case Account.update_supplier_user(current_user, params) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, user} ->
            {:ok, user}
        end
      end)
    end

    @desc "login users"
    field :login_staff_and_partners, :session_type do
      arg(:input, non_null(:login_input_type))

      resolve(fn %{input: input}, %{context: context} ->
        with {:ok, user} <- Session.external_authentication(input[:email], input[:password]),
             true <- Confirmation.confirmed?(user),
             {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
          user |> Account.update_tracked_fields(context[:remote_ip])

          {:ok, %{user: user, token: jwt_token}}
        else
          {:error, :no_yet_confirmed, user_with_new_code} ->
            user_with_new_code |> Email.welcome() |> Mailer.deliver_now()

            {:error,
             "Your email has not been confirmed. A confirmation code has been sent to your email"}

          {:error, message} ->
            {:error, message}
        end
      end)
    end

    field :login_customer_patient, :session_type do
      arg(:input, non_null(:login_input_type))

      resolve(fn %{input: input}, %{context: context} ->
        with {:ok, user} <- Session.external_authentication(input[:email], input[:password]),
             true <- Confirmation.confirmed?(user),
             {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
          user |> Account.update_tracked_fields(context[:remote_ip])

          {:ok, %{user: user, token: jwt_token}}
        else
          {:error, :no_yet_confirmed, user_with_new_code} ->
            user_with_new_code |> Email.welcome() |> Mailer.deliver_now()

            {:error,
             "Your email has not been confirmed. A confirmation code has been sent to your email"}

          {:error, message} ->
            {:error, message}
        end
      end)
    end

    @desc "customer's facebook login"
    field :facebook_login, :session_type do
      arg(:provider, :provider)
      arg(:token, :string)

      resolve(fn %{provider: provider, token: token}, %{context: context} ->
        with {:ok, users} <- Session.facebook_auth(provider, token),
             {:ok, jwt_token, _} <- Guardian.encode_and_sign(users) do
          users |> Account.update_tracked_fields(context[:remote_ip])
          {:ok, %{token: jwt_token, users: users}}
        else
          {:error, _message} ->
            {:error, "incorrect login credentials"}
        end
      end)
    end

    @desc "Change customer password"
    field :change_customer_password, :session_type do
      arg(:password, non_null(:string))
      arg(:current_password, non_null(:string))
      middleware(Middleware.Authorize, :any)

      resolve(fn args, %{context: context} ->
        with {:ok, user} <-
               Session.external_authentication(
                 context[:current_user].email,
                 args[:current_password]
               ),
             {:ok, jwt_token, _} <- Guardian.encode_and_sign(user),
             {:ok, loged_in_user} <- context[:current_user] |> Account.change_password(args) do
          loged_in_user |> Account.update_tracked_fields(context[:remote_ip])
          {:ok, %{token: jwt_token, user: loged_in_user}}
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          {:error, _msg} -> {:error, "current password is not valid, please try again"}
        end
      end)
    end

    @desc "Change staff and partners password"
    field :change_staff_and_partners_password, :session_type do
      arg(:password, :string)
      arg(:current_password, :string)
      middleware(Middleware.Authorize, :any)

      resolve(fn args, %{context: context} ->
        with {:ok, user} <-
               Session.internal_authentication(
                 context[:current_user].email,
                 args[:current_password]
               ),
             {:ok, jwt_token, _} <- Guardian.encode_and_sign(user),
             {:ok, loged_in_user} <- context[:current_user] |> Account.change_password(args) do
          loged_in_user |> Account.update_tracked_fields(context[:remote_ip])
          {:ok, %{token: jwt_token, user: loged_in_user}}
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          {:error, _msg} -> {:error, "current password is not valid, please try again"}
        end
      end)
    end

    @desc "Upload user image"
    field :upload_user_image, :users_type do
      arg(:input, non_null(:image_upload_type))
      # middleware(Middleware.Authorize, :any)

      resolve(fn %{input: input}, %{context: %{current_user: current_user}} ->
        case Account.upload_user_image(current_user, input) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, user} ->
            {:ok, user}
        end
      end)
    end
  end

  object :user_query do
    field :users, list_of(:users_type), description: "Get list of users" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      arg(:keywords, :string, default_value: nil)
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        users =
          User
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, users}
      end)
    end

    field :me, :users_type do
      middleware(Middleware.Authorize, :any)

      resolve(fn _, %{context: %{current_user: current_user}} ->
        {:ok, current_user}
      end)
    end
  end
end
