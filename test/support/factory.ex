defmodule LetorEcom.Factory do
  alias LetorEcom.Repo
  alias LetorEcom.Account.{Address, User, ReferedList}
  alias LetorEcom.AgentsAndSuppliers.CampusAgent

  alias LetorEcom.Catalogue.{
    Item,
    ItemCategory,
    ItemSubcategory,
    ItemImage,
    ItemTag,
    ItemTagging,
    Sku
  }

  alias LetorEcom.Centres.{
    DailyDeal,
    FeaturedItem,
    PickupCentre,
    PopularItem,
    Inventory,
    InventoryChangeHistory,
    InventoryLocation
  }

  alias LetorEcom.Control.{CoveredInstitution, EcommerceControl, Location}

  alias LetorEcom.CustomerPurchases.{
    CartItem,
    DeliveryCharge,
    Order,
    OrderDispatch,
    PickUp,
    ReferalDiscount
  }

  alias LetorEcom.Delicacies.{ItemRecipe, Recipe, RecipeClass}
  alias LetorEcom.HumanResource.{Driver, Staff, StaffPosting}

  alias LetorEcom.Transactions.UserWallet

  def build(:user) do
    %User{
      address: "No 12 Agip Road Rumueme PHC",
      date_of_birth: ~D[2022-03-23],
      email: "#{System.unique_integer()}some@email.com",
      first_name: "first_name",
      last_name: "last_name",
      phone: "081688918#{Enum.random(10..99)}"
      # password: "Password1@",
      # password_confirmation: "Password1@"
    }
  end

  def build(:address) do
    %Address{
      address1: "some address1",
      address2: "some address2",
      business_name: "some business_name",
      order_instruction: "some order_instruction",
      zip_code: "some zip_code"
    }
  end

  def build(:refered_list) do
    %ReferedList{
      date_activated: ~U[2022-04-15 12:58:00Z],
      refered_person_id: "some refered_person_id"
    }
  end

  def build(:campus_agent) do
    %CampusAgent{
      business_address: "some business_address",
      email: "#{System.unique_integer()}first_name@gmail.com",
      first_name: "some first_name",
      guarantor_first_name: "some guarantor_first_name",
      guarantor_phone: "some guarantor_phone",
      guarantor_residential_address: "some guarantor_residential_address",
      guarantor_last_name: "some guarantor_second_name",
      home_town: "some home_town",
      last_name: "some last_name",
      means_of_id: "some means_of_id",
      nationality: "some nationality",
      phone: "some phone",
      residential_address: "some residential_address",
      secret_code: "some secret_code",
      state_of_origin: "some state_of_origin",
      status: "some status",
      verified: true
    }
  end

  def build(:item_category) do
    %ItemCategory{
      description: "some description",
      name: "some name#{Enum.random(1..100)}"
    }
  end

  def build(:item_subcategory) do
    %ItemSubcategory{
      description: "some description",
      name: "some name#{Enum.random(1..100)}"
    }
  end

  def build(:sku) do
    %Sku{
      code: "some code",
      item_name: "some item_name"
    }
  end

  def build(:item_image) do
    %ItemImage{
      item_image1: "some item_image1",
      item_image2: "some item_image2",
      item_image3: "some item_image3",
      item_image4: "some item_image4",
      item_name: "some item_name",
      video_url: "some video_url"
    }
  end

  def build(:item_tag) do
    %ItemTag{
      class: "some class",
      description: "some description",
      name: "some name"
    }
  end

  def build(:item_tagging) do
    %ItemTagging{}
  end

  def build(:item) do
    %Item{
      actual_price: "120.5",
      availability_time: "some availability_time",
      available_quantity: 42,
      barcode: "some barcode",
      brand_name: "some brand_name",
      bulk: true,
      customization_allowed: true,
      description: "some description",
      details: "some details",
      expired: true,
      group_buying_price: "120.5",
      item_code: "some item_code",
      main_price: "120.5",
      name: "some name",
      out_of_stock: true,
      package_size: "some package_size",
      preparation_time: "some preparation_time",
      promo_price: "120.5",
      qa_cleared: true,
      qr_code: "some qr_code",
      regional_name: "some regional_name",
      size: 42,
      third_party_item: "some third_party_item",
      type: "some type"
    }
  end

  def build(:pickup_centre) do
    %PickupCentre{
      address: "#{Enum.random(1..1000)}some address",
      area: "#{Enum.random(1..1000)}some area",
      city: "some city",
      country: "some country",
      longitude_and_latitude_point: %Geo.Point{coordinates: {3.90010, 0.90000}, srid: 4326},
      name: "#{Enum.random(1..1000)}some name",
      state: "some state"
    }
  end

  def build(:inventory_location) do
    %InventoryLocation{
      name: "some name",
      type: "some type"
    }
  end

  def build(:daily_deal) do
    %DailyDeal{}
  end

  def build(:popular_item) do
    %PopularItem{}
  end

  def build(:featured_item) do
    %FeaturedItem{}
  end

  def build(:inventory) do
    %Inventory{
      brand_name: "some brand_name",
      buy_price: "120.5",
      description: "some description",
      expired: true,
      expiry_date: ~D[2022-04-06],
      external_quantity: 42,
      external_quantity_uom: "some external_quantity_uom",
      internal_quantity_uom: "some intenal_quantity_uom",
      internal_quantity: 42,
      max_external_quantity: 42,
      max_internal_quantity: 42,
      name: "some name",
      qr_code: "some qr_code",
      quality_assurance_status: "some quality_assurance_status",
      sales_price: "120.5",
      size: 42,
      status: "some status"
    }
  end

  def build(:inventory_change_history) do
    %InventoryChangeHistory{
      buy_price: "120.5",
      external_quantity: 42,
      internal_quantity: 42,
      sales_price: "120.5",
      change_type: "created"
    }
  end

  def build(:ecommerce_control) do
    %EcommerceControl{
      country: "some country",
      name: "#{System.unique_integer()}some name",
      region: "#{System.unique_integer()}some region"
    }
  end

  def build(:location) do
    %Location{
      city: "some city",
      country: "some country",
      location_area: "#{Enum.random(10..1000)}some location_area",
      longitude_and_latitude_point: %Geo.Point{coordinates: {3.90010, 0.90000}, srid: 4326},
      postal_code: "some postal_code",
      state: "some state"
    }
  end

  def build(:covered_institution) do
    %CoveredInstitution{
      campus_name: "some campus_name#{Enum.random(10..100)}",
      name: "some name"
    }
  end

  def build(:cart_item) do
    %CartItem{
      additional_info: "some additional_info",
      decline_item: true,
      quantity: 42,
      sold: true,
      sub_total: "some sub_total"
    }
  end

  def build(:order) do
    %Order{
      address: "some address",
      agent_delivery_confirmation_code: "some agent_delivery_confirmation_code",
      centre_pickup: "some centre_pickup",
      contact_person: "some contact_person",
      customer_delivery_confirmation_code: "some customer_delivery_confirmation_code",
      delivery_charge: "120.5",
      delivery_date: ~D[2022-03-30],
      delivery_period: "some delivery_period",
      delivery_option: "some deliviery_option",
      door_step_delivery: true,
      eight_am_twelve_pm: true,
      fifteen_to_thirty_minutes: true,
      four_pm_ten_pm: true,
      grand_total: "120.5",
      latest_time: ~T[14:00:00],
      one_to_two_hours: true,
      order_confirmed: true,
      order_instructions: "some order_instructions",
      order_number: "some order_number",
      order_placed_at: ~U[2022-03-30 12:32:00Z],
      order_status: "some order_status",
      pay_at_pickup: true,
      pay_on_delivery: true,
      pay_with_card: true,
      payment_option: "some payment_option",
      payment_status: "some payment_status",
      phone: "some phone",
      referal_discount: "120.5",
      time_delivered: ~U[2022-03-30 12:32:00Z],
      twelve_pm_four_pm: true,
      urgency_status: "some urgency_status"
    }
  end

  def build(:order_dispatch) do
    %OrderDispatch{
      all_delivered: true,
      delayed: true,
      dispatch_id: "some dispatch_id",
      dispatched: true,
      order_count: 42,
      order_delivered: 42
    }
  end

  def build(:delivery_charge) do
    %DeliveryCharge{
      eight_to_twelve: "120.5",
      fifteen_to_thirty_minutes: "120.5",
      four_to_ten: "120.5",
      twelve_to_four: "120.5"
    }
  end

  def build(:referal_discount) do
    %ReferalDiscount{
      first_discount: "120.5",
      fourth_discount: "120.5",
      second_discount: "120.5",
      third_discount: "120.5"
    }
  end

  def build(:pick_up) do
    %PickUp{
      pick_up_time: ~U[2022-04-15 19:53:00Z],
      picked: true,
      pickup_code: "some pickup_code"
    }
  end

  def build(:recipe_class) do
    %RecipeClass{
      description: "some description",
      name: "some name"
    }
  end

  def build(:recipe) do
    %Recipe{
      description: "some description",
      directions: "some directions",
      image1_url: "some image1_url",
      image2_url: "some image2_url",
      image3_url: "some image3_url",
      meal_type: "some meal_type",
      name: "some name",
      special: "some special",
      video: "some video"
    }
  end

  def build(:item_recipe) do
    %ItemRecipe{}
  end

  def build(:staff) do
    %Staff{
      country: "some country",
      date_employed: "some date_employed",
      designation: "some designation",
      email: "some email",
      employment_status: "some employment_status",
      first_name: "some first_name",
      full_name: "some full_name",
      guarantor_address: "some guarantor_address",
      guarantor_name: "some guarantor_name",
      guarantor_phone: "some guarantor_phone",
      home_town: "some home_town",
      id_code: "some id_code",
      last_name: "some last_name",
      lga: "some lga",
      means_of_id: "some means_of_id",
      phone: "some phone",
      residential_address: "some residential_address",
      state_of_origin: "some state_of_origin"
    }
  end

  def build(:driver) do
    %Driver{
      email: "some email",
      name: "some name",
      phone: "some phone",
      status: "some status"
    }
  end

  def build(:staff_posting) do
    %StaffPosting{
      date_posted: ~D[2022-04-03],
      previous_posting: "some previous_posting"
    }
  end

  def build(:user_wallet) do
    %UserWallet{
      amount: "120.5",
      wallet_id: "some wallet_id"
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
