defmodule LetorEcom.Factory do
  alias LetorEcom.Repo
  alias LetorEcom.Account.{AddressBook, User, ReferedList, Confirmation}
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
    InventoryLocation,
    QualityAssuranceRequirement,
    Batch
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

  # ACCOUNT CONTEXT FIXTURES
  def location_fixture(attrs \\ %{}) do
    {:ok, location} =
      attrs
      |> Enum.into(%{
        city: "some city",
        country: "some country",
        location_area: "#{System.unique_integer()}some loc_area",
        location_coordinates: %Geo.Point{coordinates: {3.90010, 0.90000}, srid: 4326},
        postal_code: "some postal_code",
        state: "some state"
      })
      |> LetorEcom.Control.create_location()

    location
  end

  def user_fixture(attrs \\ %{}) do
    location = location_fixture()


    phone = "081688914#{Enum.random(10..99)}"

    {:ok, %{user: user}} =
      attrs
      |> Enum.into(%{
        address: "No 12 Agip Road Rumueme PHC",
        date_of_birth: ~D[2022-03-23],
        email: "#{Enum.random(1..1000)}siraboo@email.com",
        first_name: "first_name",
        last_name: "last_name",
        phone: phone,
        password: "Password1@",
        password_confirmation: "Password1@",
        location_id: location.id
      })
      |> LetorEcom.Account.register_customer()

    user
  end

  def address_book_fixture(attrs \\ %{}) do
    random_value = Enum.random(1..100)

    {:ok, address_book} =
      attrs
      |> Enum.into(%{
        address: "#{random_value}choba",
        city: "PH",
        area: "Tejod",
        state: "Rivers"
      })
      |> LetorEcom.Account.create_address_book()

    address_book
  end

  # def confirmation_fixture(attrs \\ %{}) do
  # {:ok, confirmation} =
  #  attrs
  # |> Enum.into(%{
  #  inputed_code: "some code",
  # })
  # |> LetorEcom.Account.create_confirmation()

  # confirmation
  # end

  def shopping_list_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, shopping_list} =
      attrs
      |> Enum.into(%{
        title: "Fruits Shopping list",
        quantity: 42,
        user_id: user.id
      })
      |> LetorEcom.Account.create_shopping_list()

    shopping_list
  end

  def refered_list_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, refered_list} =
      attrs
      |> Enum.into(%{
        date_activated: ~U[2022-04-15 12:58:00Z],
        refered_person_id: "some refered person id",
        user_id: user.id
      })
      |> LetorEcom.Account.create_refered_list()

    refered_list
  end

  def ecommerce_control_fixture(attrs \\ %{}) do
    {:ok, ecommerce_control} =
      attrs
      |> Enum.into(%{
        country: "some country",
        name: "#{System.unique_integer()}Southern Control1",
        region: "#{System.unique_integer()}South-South"
      })
      |> LetorEcom.Control.create_ecommerce_control()

    ecommerce_control
  end

  def pickup_centre_fixture(attrs \\ %{}) do
    ecommerce_control = ecommerce_control_fixture()

    # random_value = Enum.random(1..1000)

    {:ok, pickup_centre} =
      attrs
      |> Enum.into(%{
        address: "#{System.unique_integer()}Plot #800 East west Road",
        area: "#{System.unique_integer()}Oyigbo",
        city: "some city",
        country: "some country",
        location_coordinates: %Geo.Point{coordinates: {3.90010, 0.90000}, srid: 4326},
        name: "#{System.unique_integer()}Alakahia Pickup Centre",
        state: "some state",
        ecommerce_control_id: ecommerce_control.id
      })
      |> LetorEcom.Centres.create_pickup_centre()

    pickup_centre
  end

  def inventory_location_fixture(attrs \\ %{}) do
    pickup_centre = pickup_centre_fixture()

    {:ok, inventory_location} =
      attrs
      |> Enum.into(%{
        name: "#{Enum.random(1..1000)}some name",
        type: "some type",
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.Centres.create_inventory_location()

    inventory_location
  end

  def item_category_fixture(attrs \\ %{}) do
    pickup_centre = pickup_centre_fixture()

    {:ok, item_category} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "#{System.unique_integer()}Vegetables",
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.Catalogue.create_item_category()

    item_category
  end

  def item_subcategory_fixture(attrs \\ %{}) do
    item_category = item_category_fixture()

    {:ok, item_subcategory} =
      attrs
      |> Enum.into(%{
        description: "some description",
        ## {Enum.random(1..100)}",
        name: "#{System.unique_integer()}protein",
        item_category_id: item_category.id
      })
      |> LetorEcom.Catalogue.create_item_subcategory()

    item_subcategory
  end

  def item_image_fixture(attrs \\ %{}) do
    ecommerce_control = ecommerce_control_fixture()

    {:ok, item_image} =
      attrs
      |> Enum.into(%{
        item_image1: "some item_image1",
        item_image2: "some item_image2",
        item_image3: "some item_image3",
        item_image4: "some item_image4",
        item_name: "banana",
        video_url: "some video_url",
        ecommerce_control_id: ecommerce_control.id
      })
      |> LetorEcom.Catalogue.create_item_image()

    item_image
  end

  def item_tag_fixture(attrs \\ %{}) do
    {:ok, item_tag} =
      attrs
      |> Enum.into(%{
        class: "some class",
        description: "some description",
        name: "#{System.unique_integer()}Vegan"
      })
      |> LetorEcom.Catalogue.create_item_tag()

    item_tag
  end

  def item_tagging_fixture(attrs \\ %{}) do
    item = item_fixture()
    item_tag = item_tag_fixture()

    {:ok, item_tagging} =
      attrs
      |> Enum.into(%{
        item_id: item.id,
        item_tag_id: item_tag.id
      })
      |> LetorEcom.Catalogue.create_item_tagging()

    item_tagging
  end

  def sku_fixture(attrs \\ %{}) do
    pickup_centre = pickup_centre_fixture()

    {:ok, sku} =
      attrs
      |> Enum.into(%{
        code: "some code",
        name: "#{System.unique_integer()}some name",
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.Catalogue.create_sku()

    sku
  end

  # def sku_inventory_and_item_fixture(attrs \\ %{}) do
  # pickup_centre = pickup_centre_fixture()
  # item_subcategory = item_subcategory_fixture()
  # item_tag = item_tag_fixture()
  # item_image = item_image_fixture()
  # inventory_location = inventory_location_fixture()

  # random_value = Enum.random(1..1000)

  # alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
  # length = 4
  # random_value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

  # {:ok, sku_inventory_and_item} =
  # attrs
  # |> Enum.into(%{
  # code: "#{random_value}SOME CODE",
  # name: "#{System.unique_integer()}some name",
  # pickup_centre_id: pickup_centre.id,
  # item_subcategory_id: item_subcategory.id,
  # item_tag_id: item_tag.id,
  # type: "some type",
  # package_uom: "some package_uom",
  # item_image_id: item_image.id,
  # pickup_centre_id: pickup_centre.id,
  # inventory_location_id: inventory_location.id,
  # description: "some description",
  # max_bulk_quantity: 30,
  # name: "some name",
  # re_order_level: 5,
  # sales_unit_quantity: 80,
  # bulk_quantity: 5,
  # sales_unit_quantity_uom: "some sales unit qty",
  # bulk_quantity_uom: "some bulk unit qty",
  # buy_price: 150,
  # unit_sales_price: 250,
  # bulk_sales_price: 3000,
  # status: "some status",
  # expiry_date: ~D[2023-02-03]
  # })

  # LetorEcom.Catalogue.create_sku_inventory_and_item()
  # sku_inventory_and_item
  # end

  def item_fixture(attrs \\ %{}) do
    inventory_location = inventory_location_fixture()
    item_image = item_image_fixture()
    item_subcategory = item_subcategory_fixture()
    item_tag = item_tag_fixture()
    # sku_inventory_and_item = sku_inventory_and_item_fixture()

    {:ok, %{item: item}} =
      attrs
      |> Enum.into(%{
        brand_name: "some brand_name",
        buy_price: Decimal.new("120.5"),
        description: "some description",
        expired: true,
        expiry_date: ~D[2022-04-06],
        bulk_quantity: 42,
        bulk_quantity_uom: "some bulk_quantity_uom",
        sales_unit_quantity_uom: "some intenal_quantity_uom",
        sales_unit_quantity: 42,
        max_bulk_quantity: 42,
        max_sales_unit_quantity: 42,
        name: "some name",
        sales_price: Decimal.new("120.5"),
        size: 42,
        status: "some status",
        unit_sales_price: Decimal.new("120.5"),
        bulk_sales_price: Decimal.new("100.5"),
        re_order_level: 30,
        package_uom: "some package_uom",
        type: "some type",
        inventory_location_id: inventory_location.id,
        item_image_id: item_image.id,
        item_subcategory_id: item_subcategory.id,
        item_tag_id: item_tag.id
        # sku_inventory_and_item_id: sku_inventory_and_item.id
      })
      |> LetorEcom.Catalogue.create_sku_inventory_and_item()

    item
  end

  def user_fav_fixture(attrs \\ %{}) do
    item = item_fixture()
    user = user_fixture()

    {:ok, user_fav} =
      attrs
      |> Enum.into(%{
        item_id: item.id,
        user_id: user.id
      })
      |> LetorEcom.Account.create_user_fav()

    user_fav
  end

  def viewed_item_fixture(attrs \\ %{}) do
    item = item_fixture()
    user = user_fixture()

    {:ok, viewed_item} =
      attrs
      |> Enum.into(%{
        item_id: item.id,
        user_id: user.id
      })
      |> LetorEcom.Account.create_viewed_item()

    viewed_item
  end

  # AGENTS AND SUPPLIERS CONTEXT FIXTURE
  def supplier_fixture(attrs \\ %{}) do
    {:ok, supplier} =
      attrs
      |> Enum.into(%{
        address: "No 4 tejod junction",
        status: "some status",
        type: "some type",
        means_of_id: "some means of id",
        id_image: "some id image",
        first_name: "first_name",
        last_name: "last_name",
        email: "#{Enum.random(1..1000)}beauty@email.com",
        phone: "081688914#{Enum.random(10..99)}",
        city: "some city",
        state: "some state",
        country: "some country",
        business_name: "some business_name"
      })
      |> LetorEcom.AgentsAndSuppliers.create_supplier()

    supplier
  end

  # CENTRES CONTEXT FIXTURES

  def batch_fixture(attrs \\ %{}) do
    pickup_centre = pickup_centre_fixture()

    {:ok, batch} =
      attrs
      |> Enum.into(%{
        description: "some description",
        batch_type: "some batch type",
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.Centres.create_batch()

    batch
  end

  def daily_deal_fixture(attrs \\ %{}) do
    pickup_centre = pickup_centre_fixture()

    {:ok, daily_deal} =
      attrs
      |> Enum.into(%{
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.Centres.create_daily_deal()

    daily_deal
  end

  def featured_item_fixture(attrs \\ %{}) do
    pickup_centre = pickup_centre_fixture()

    {:ok, featured_item} =
      attrs
      |> Enum.into(%{
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.Centres.create_featured_item()

    featured_item
  end

  def inventory_fixture(attrs \\ %{}) do
    inventory_location = inventory_location_fixture()
    item_image = item_image_fixture()
    item_subcategory = item_subcategory_fixture()
    sku = sku_fixture()

    {:ok, inventory} =
      attrs
      |> Enum.into(%{
        buy_price: Decimal.new("120.5"),
        description: "some description",
        bulk_quantity: 42,
        bulk_quantity_uom: "some bulk_quantity_uom",
        sales_unit_quantity_uom: "some intenal_quantity_uom",
        sales_unit_quantity: 42,
        max_bulk_quantity: 42,
        bulk_quantity_uom: "some bulk qty uom",
        name: "some name",
        bulk_sales_price: Decimal.new("120.5"),
        unit_sales_price: Decimal.new("100.5"),
        re_order_level: 42,
        inventory_location_id: inventory_location.id,
        item_image_id: item_image.id,
        item_subcategory_id: item_subcategory.id,
        sku_id: sku.id
      })
      |> LetorEcom.Centres.create_inventory()

    inventory
  end

  def inventory_change_history_fixture(attrs \\ %{}) do
    inventory = inventory_fixture()

    {:ok, inventory_change_history} =
      attrs
      |> Enum.into(%{
        buy_price: Decimal.new("120.5"),
        bulk_quantity: 42,
        sales_unit_quantity: 42,
        unit_sales_price: Decimal.new("120.5"),
        bulk_sales_price: Decimal.new("100.5"),
        change_type: "created",
        inventory_id: inventory.id
      })
      |> LetorEcom.Centres.create_inventory_change_history()

    inventory_change_history
  end

  def popular_item_fixture(attrs \\ %{}) do
    pickup_centre = pickup_centre_fixture()

    {:ok, popular_item} =
      attrs
      |> Enum.into(%{
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.Centres.create_popular_item()

    popular_item
  end

  def purchase_fixture(attrs \\ %{}) do
    {:ok, purchase} =
      attrs
      |> Enum.into(%{
        code: "some code",
        status: "some status"
      })
      |> LetorEcom.Centres.create_purchase()

    purchase
  end

  def purchase_item_fixture(attrs \\ %{}) do
    {:ok, purchase_item} =
      attrs
      |> Enum.into(%{
        price_per_unit: Decimal.new("120.5"),
        item_name: "some item name",
        quantity: 20,
        unit_of_measure: "some unit of measure"
      })
      |> LetorEcom.Centres.create_purchase()

    purchase_item
  end

  def quality_assurance_requirement_fixture(attrs \\ %{}) do
    batch = batch_fixture()

    {:ok, quality_assurance_requirement} =
      attrs
      |> Enum.into(%{
        product_type: "some product type",
        batch_id: batch.id
      })
      |> LetorEcom.Centres.create_quality_assurance_requirement()

    quality_assurance_requirement
  end

  # CUSTOMER PURCHASES FIXTURES

  def delivery_charge_fixture(attrs \\ %{}) do
    ecommerce_control = ecommerce_control_fixture()

    {:ok, delivery_charge} =
      attrs
      |> Enum.into(%{
        eight_to_twelve: Decimal.new("120.5"),
        fifteen_to_thirty_minutes: Decimal.new("120.5"),
        four_to_ten: Decimal.new("120.5"),
        twelve_to_four: Decimal.new("120.5"),
        ecommerce_control_id: ecommerce_control.id
      })
      |> LetorEcom.CustomerPurchases.create_delivery_charge()

    delivery_charge
  end

  def order_fixture(attrs \\ %{}) do
    location = location_fixture()
    pickup_centre = pickup_centre_fixture()

    {:ok, order} =
      attrs
      |> Enum.into(%{
        order_status: "processing",
        order_confirmed: true,
        order_placed_at: Timex.now(),
        # payment_status: payment_verification(order),
        # address: "No 4 alakahia road",
        # phone: "081688919#{Enum.random(10..99)}",
        location_id: location.id,
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.CustomerPurchases.place_order()

    order
  end

  def order_dispatch_fixture(attrs \\ %{}) do
    pickup_centre = pickup_centre_fixture()

    {:ok, order_dispatch} =
      attrs
      |> Enum.into(%{
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.CustomerPurchases.create_order_dispatch()

    order_dispatch
  end

  def pick_up_fixture(attrs \\ %{}) do
    {:ok, pickup} =
      attrs
      |> Enum.into(%{
        pick_up_time: ~U[2022-04-15 19:53:00Z],
        picked: true,
        pickup_code: "some pickup_code"
      })
      |> LetorEcom.CustomerPurchases.create_pick_up()

    pickup
  end

  def referal_discount_fixture(attrs \\ %{}) do
    ecommerce_control = ecommerce_control_fixture()

    {:ok, referal_discount} =
      attrs
      |> Enum.into(%{
        first_discount: Decimal.new("120.5"),
        fourth_discount: Decimal.new("120.5"),
        second_discount: Decimal.new("120.5"),
        third_discount: Decimal.new("120.5"),
        ecommerce_control_id: ecommerce_control.id
      })
      |> LetorEcom.CustomerPurchases.create_referal_discount()

    referal_discount
  end

  def cart_item_fixture(attrs \\ %{}) do
    item = item_fixture()
    order = order_fixture()

    {:ok, cart_item} =
      attrs
      |> Enum.into(%{
        quantity: 42,
        item_id: item.id,
        order_id: order.id
      })
      |> LetorEcom.CustomerPurchases.create_cart_items()

    cart_item
  end

  # HUMAN RESOURCE CONTEXT FIXTURES

  def staff_fixture(attrs \\ %{}) do
    email = "#{Enum.random(1..1000)}mama@email.com"
    phone = "090545454#{Enum.random(10..99)}"
    guarantor_phone = "080372699#{Enum.random(10..99)}"

    {:ok, staff} =
      attrs
      |> Enum.into(%{
        country: "some country",
        date_employed: ~D[2022-03-07],
        designation: "some designation",
        email: email,
        employment_status: "some employment_status",
        first_name: "first_name",
        full_name: "full_name",
        guarantor_address: "No 3 alakahia junction",
        guarantor_name: "#{Enum.random(1..1000)}some guarantor_name",
        guarantor_phone: guarantor_phone,
        home_town: "some home_town",
        id_code: "some id_code",
        last_name: "last_name",
        lga: "some lga",
        means_of_id: "some means_of_id",
        phone: phone,
        residential_address: "some residential_address",
        state_of_origin: "some state_of_origin"
      })
      |> LetorEcom.HumanResource.create_staff()

    staff
  end

  def staff_posting_fixture(attrs \\ %{}) do
    ecommerce_control = ecommerce_control_fixture()
    user = user_fixture()

    {:ok, staff_posting} =
      attrs
      |> Enum.into(%{
        date_posted: ~D[2022-04-03],
        previous_posting: "some previous_posting",
        ecommerce_control_id: ecommerce_control.id,
        user_id: user.id
      })
      |> LetorEcom.HumanResource.create_staff_posting()

    staff_posting
  end

  def driver_fixture(attrs \\ %{}) do
    staff = staff_fixture()
    pickup_centre = pickup_centre_fixture()

    {:ok, driver} =
      attrs
      |> Enum.into(%{
        email: "#{Enum.random(1..1000)}mimi@email.com",
        name: "samuel",
        phone: "081688919#{Enum.random(10..99)}",
        status: "off duty",
        staff_id: staff.id,
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.HumanResource.create_driver()

    driver
  end

  # SALES CONTEXT FIXTURES

  def customer_info_fixture(attrs \\ %{}) do
    {:ok, customer_info} =
      attrs
      |> Enum.into(%{
        phone: "081688929#{Enum.random(10..99)}",
        name: "some name"
      })
      |> LetorEcom.Sales.create_customer_info()

    customer_info
  end

  def sale_fixture(attrs \\ %{}) do
    cart_item = cart_item_fixture()

    {:ok, sale} =
      attrs
      |> Enum.into(%{
        cart_item_id: cart_item.id
      })
      |> LetorEcom.Sales.create_online_sales()

    sale
  end

  def instore_sale_fixture(attrs \\ %{}) do
    sale = sale_fixture()
    item = item_fixture()

    {:ok, instore_sale} =
      attrs
      |> Enum.into(%{
        quantity: 20,
        sales_amount: Decimal.new("120.5"),
        item_price: Decimal.new("120.5"),
        sale_id: sale.id,
        item_id: item.id
      })
      |> LetorEcom.Sales.create_instore_sale()

    instore_sale
  end

  # TRANSACTION CONTEXT FIXTURE

  def user_wallet_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, user_wallet} =
      attrs
      |> Enum.into(%{
        amount: Decimal.new("150.5"),
        user_id: user.id
      })
      |> LetorEcom.Transactions.create_user_wallet()

    user_wallet
  end

  def payment_fixture(attrs \\ %{}) do
    user = user_fixture()
    order = order_fixture()

    {:ok, payment} =
      attrs
      |> Enum.into(%{
        amount: Decimal.new("120.5"),
        user_id: user.id,
        order_id: order.id
      })
      |> LetorEcom.Transactions.make_order_payment()

    payment
  end

  # DELICACIES CONTEXT FIXTURES

  def recipe_class_fixture(attrs \\ %{}) do
    {:ok, recipe_class} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> LetorEcom.Delicacies.create_recipe_class()

    recipe_class
  end

  def recipe_fixture(attrs \\ %{}) do
    recipe_class = recipe_class_fixture()

    {:ok, recipe} =
      attrs
      |> Enum.into(%{
        description: "some description",
        directions: "some directions",
        image1_url: "some image1_url",
        meal_type: "some meal_type",
        name: "some name",
        recipe_class_id: recipe_class.id
      })
      |> LetorEcom.Delicacies.create_recipe()

    recipe
  end

  def item_recipe_fixture(attrs \\ %{}) do
    item = item_fixture()
    recipe = recipe_fixture()

    {:ok, item_recipe} =
      attrs
      |> Enum.into(%{
        item_id: item.id,
        recipe_id: recipe.id
      })
      |> LetorEcom.Delicacies.create_item_recipe()

    item_recipe
  end

  # def build(factory_name, attributes) do
  # factory_name |> build() |> struct!(attributes)
  # end

  # def insert!(factory_name, attributes \\ []) do
  # factory_name |> build(attributes) |> Repo.insert!()
  # end
end
