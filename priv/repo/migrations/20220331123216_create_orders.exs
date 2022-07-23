defmodule LetorEcom.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :order_number, :string
      add :address, :string
      add :delivery_charge, :decimal
      add :delivery_date, :date
      add :within_thirty_minutes, :boolean, default: false, null: false
      add :within_one_hour, :boolean, default: false, null: false
      add :within_two_hours, :boolean, default: false, null: false
      add :within_three_hours, :boolean, default: false, null: false
      add :eight_am_twelve_pm, :boolean, default: false, null: false
      add :twelve_pm_four_pm, :boolean, default: false, null: false
      add :four_pm_ten_pm, :boolean, default: false, null: false
      add :agent_delivery_confirmation_code, :string
      add :customer_delivery_confirmation_code, :string
      add :order_instructions, :string
      add :order_status, :string
      add :pay_with_card, :boolean, default: false, null: false
      add :pay_on_delivery, :boolean, default: false, null: false
      add :pay_at_pickup, :boolean, default: false, null: false
      add :phone, :string
      add :contact_person, :string
      add :centre_pickup, :string
      add :door_step_delivery, :boolean, default: false, null: false
      add :order_confirmed, :boolean, default: false, null: false
      add :order_placed_at, :utc_datetime
      add :referal_discount, :decimal
      add :delivery_period, :string
      add :payment_status, :string
      add :payment_option, :string
      add :latest_time, :time
      add :urgency_status, :string
      add :delivery_option, :string
      add :time_delivered, :utc_datetime
      add :grand_total, :decimal

      timestamps(type: :timestamptz)
    end

    create index(:orders, [:id])
  end
end
