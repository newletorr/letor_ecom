defmodule LetorEcom.ScheduledTasks do
  import Ecto.Query, warn: false
  alias LetorEcom.{Centres, Repo}
  alias LetorEcom.Centres.Inventory

  def create_purchase_on_reorder_level_reached() do
    inventory_items =
      Repo.all(from(inventory in Inventory, where: inventory.re_ordering_required == true))

    Enum.each(inventory_items, fn item ->
      Centres.add_purchase_items_to_purchase(%{
        inventory_id: item.id,
        pickup_centre_id: item.pickup_centre_id,
        quantity: item.max_bulk_quantity - item.re_order_level
      })
    end)
  end
end
