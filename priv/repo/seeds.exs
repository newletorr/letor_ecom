alias LetorEcom.{
  Account,
  AgentsAndSuppliers,
  Catalogue,
  Centres,
  Control,
  CustomerPurchases,
  Delicacies,
  HumanResource,
  Transactions,
  Repo
}

alias LetorEcom.Account.{Address, Confirmation, ShoppingList, User}
alias LetorEcom.AgentsAndSuppliers.CampusAgent

alias LetorEcom.Catalogue.{
  Item,
  ItemCategory,
  ItemImage,
  ItemTag,
  ItemTagging,
  ItemSubcategory,
  Sku
}

alias LetorEcom.Centres.{
  DailyDeal,
  FeaturedItem,
  PopularItem,
  Inventory,
  InventoryChangeHistory,
  InventoryLocation,
  PickupCentre
}

alias LetorEcom.Control.{CentreCode, CoveredInstitution, EcommerceControl, Location}
alias LetorEcom.Delicacies.{ItemRecipe, Recipe, RecipeClass}
alias LetorEcom.CustomerPurchases.{DeliveryCharge, ReferalDiscount}
alias LetorEcom.HumanResource.{Driver, Staff}

EcommerceControl |> Repo.delete_all()

{:ok, ecommerce_control} =
  Control.create_ecommerce_control(%{
    name: "Southern Control1",
    region: "South South",
    country: "Nigeria"
  })

ReferalDiscount |> Repo.delete_all()

CustomerPurchases.create_referal_discount(%{
  first_discount: 1000,
  fourth_discount: 1500,
  second_discount: 2000,
  third_discount: 3000,
  ecommerce_control_id: ecommerce_control.id
})

PickupCentre |> Repo.delete_all()

{:ok, pickup_centre} =
  Centres.create_pickup_centre(%{
    name: "Choba Pickup Centre",
    address: "Plot #900 East west Road",
    area: "Choba",
    city: "Port Harcourt",
    state: "Rivers State",
    country: "Nigeria",
    location_coordinates: %Geo.Point{
      coordinates: {4.892429226369097, 6.915226982931952},
      srid: 4326
    },
    ecommerce_control_id: ecommerce_control.id
  })

DeliveryCharge |> Repo.delete_all()

CustomerPurchases.create_delivery_charge(%{
  eight_to_twelve: 300,
  four_to_ten: 500,
  one_hour: 750,
  twelve_to_four: 300,
  fifteen_to_thirty_minutes: 1000,
  ecommerce_control_id: ecommerce_control.id
})

Location |> Repo.delete_all()

{:ok, l1} =
  Control.create_location(%{
    city: "Port Harcourt",
    country: "Nigeria",
    location_area: "Rumuola",
    state: "Rivers State",
    postal_code: "5_500_019",
    pickup_centre_id: pickup_centre.id,
    location_coordinates: %Geo.Point{
      coordinates: {4.833813967530579, 7.0250130040393675},
      srid: 4326
    }
  })

{:ok, l2} =
  Control.create_location(%{
    city: "Port Harcourt",
    country: "Nigeria",
    location_area: "Ikwerre Road",
    state: "Rivers State",
    postal_code: "500_050",
    pickup_centre_id: pickup_centre.id,
    location_coordinates: %Geo.Point{
      coordinates: {4.847480291388287, 6.990528986062236},
      srid: 4326
    }
  })

{:ok, l3} =
  Control.create_location(%{
    city: "Port Harcourt",
    country: "Nigeria",
    location_area: "Trans-Amadi",
    state: "Rivers State",
    postal_code: "550_050",
    pickup_centre_id: pickup_centre.id,
    location_coordinates: %Geo.Point{
      coordinates: {4.820363267328334, 7.054064684036778},
      srid: 4326
    }
  })

{:ok, l4} =
  Control.create_location(%{
    city: "Port Harcourt",
    country: "Nigeria",
    location_area: "Elelewon",
    state: "Rivers State",
    postal_code: "550_050",
    pickup_centre_id: pickup_centre.id,
    location_coordinates: %Geo.Point{
      coordinates: {4.8399775403135346, 7.072863034551638},
      srid: 4326
    }
  })

{:ok, l5} =
  Control.create_location(%{
    city: "Port Harcourt",
    country: "Nigeria",
    location_area: "Rumukwurushi",
    state: "Rivers State",
    postal_code: "550_050",
    pickup_centre_id: pickup_centre.id,
    location_coordinates: %Geo.Point{
      coordinates: {4.855674721086868, 7.0546260493795385},
      srid: 4326
    }
  })

{:ok, l6} =
  Control.create_location(%{
    city: "Port Harcourt",
    country: "Nigeria",
    location_area: "Diobu",
    state: "Rivers State",
    postal_code: "550_050",
    pickup_centre_id: pickup_centre.id,
    location_coordinates: %Geo.Point{
      coordinates: {4.79742647706751, 6.989686287353521},
      srid: 4326
    }
  })

{:ok, l7} =
  Control.create_location(%{
    city: "Port Harcourt",
    country: "Nigeria",
    location_area: "Woji",
    state: "Rivers State",
    postal_code: "550_050",
    pickup_centre_id: pickup_centre.id,
    location_coordinates: %Geo.Point{
      coordinates: {4.830803833226627, 7.055239447143174},
      srid: 4326
    }
  })

{:ok, l7} =
  Control.create_location(%{
    city: "Port Harcourt",
    country: "Nigeria",
    location_area: "D-Line",
    state: "Rivers State",
    postal_code: "550_050",
    pickup_centre_id: pickup_centre.id,
    location_coordinates: %Geo.Point{
      coordinates: {4.803326672694468, 7.0017811414468625},
      srid: 4326
    }
  })

{:ok, l7} =
  Control.create_location(%{
    city: "Port Harcourt",
    country: "Nigeria",
    location_area: "Borokiri",
    state: "Rivers State",
    postal_code: "550_050",
    pickup_centre_id: pickup_centre.id,
    location_coordinates: %Geo.Point{
      coordinates: {4.746401785470347, 7.036592874548285},
      srid: 4326
    }
  })

CoveredInstitution |> Repo.delete_all()

{:ok, covered_institution} =
  Control.create_covered_institution(%{
    campus_name: "Port Harcourt Campus",
    name: "Rivers State University",
    location_id: l2.id,
    ecommerce_control_id: ecommerce_control.id
  })

User |> Repo.delete_all()

{:ok, %{user: user}} =
  Account.register_customer(%{
    location_id: l1.id,
    date_of_birth: ~D[1982-02-21],
    first_name: "Craige",
    last_name: "Davids",
    email: "dacraige@gmail.com",
    phone: "09068891827",
    address: "No 12 Agip Road Ph",
    password: "pass1Word*",
    password_confirmation: "pass1Word*"
  })

{:ok, code, confirmed_user} = Confirmation.generate_confirmation_code(user)

{:ok, user1} = Confirmation.confirm_account(confirmed_user, code)

{:ok, %{user: user}} =
  Account.register_customer(%{
    location_id: l2.id,
    first_name: "Promise",
    last_name: "Kpea",
    phone: "09068891800",
    email: "promisekpea@gmail.com",
    address: "No 12 Agip Road Ph",
    date_of_birth: ~D[1982-02-21],
    password: "pass1Word*",
    referers_code: user1.referal_code,
    password_confirmation: "pass1Word*"
  })

{:ok, code, confirmed_user} = Confirmation.generate_confirmation_code(user)

{:ok, user2} = Confirmation.confirm_account(confirmed_user, code)

# {:ok, unconfirmed2} =
# Account.create_staff_user(%{
#  staff_id: stf1.id,
# password: "pass1Word*",
# password_confirmation: "pass1Word*"
# })

# {:ok, code, user} = Confirmation.generate_confirmation_code(unconfirmed2)

# {:ok, user2} = Confirmation.confirm_account(user, code)

# {:ok, unconfirmed3} =
# Account.create_staff_user(%{
#  staff_id: stf4.id,
# password: "pass1Word*",
# password_confirmation: "pass1Word*"
# })

# {:ok, code, user} = Confirmation.generate_confirmation_code(unconfirmed3)

# {:ok, user3} = Confirmation.confirm_account(user, code)

{:ok, %{user: user}} =
  Account.register_customer(%{
    location_id: l1.id,
    first_name: "Ledi",
    last_name: "Prisca",
    email: "priscaledi@gmail.com",
    phone: "08102390198",
    address: "No 12 Agip Road Ph",
    date_of_birth: ~D[1982-02-21],
    referers_code: user1.referal_code,
    password: "pass1Word*",
    password_confirmation: "pass1Word*"
  })

{:ok, code, confirmed_user} = Confirmation.generate_confirmation_code(user)

{:ok, user4} = Confirmation.confirm_account(confirmed_user, code)

{:ok, %{user: user}} =
  Account.register_customer(%{
    location_id: l2.id,
    first_name: "Nathan",
    last_name: "Ipalibo",
    date_of_birth: ~D[1982-02-21],
    email: "ipalibonathan@gmail.com",
    phone: "08102390120",
    address: "No 12 Ada Road Rumueme",
    referers_code: user1.referal_code,
    password: "pass1Word*",
    password_confirmation: "pass1Word*"
  })

{:ok, code, confirmed_user} = Confirmation.generate_confirmation_code(user)

{:ok, user5} = Confirmation.confirm_account(confirmed_user, code)

{:ok, %{user: user}} =
  Account.register_customer(%{
    location_id: l1.id,
    first_name: "Jonah",
    last_name: "Paago",
    email: "paagojonah@gmail.com",
    date_of_birth: ~D[1982-02-21],
    phone: "08102390000",
    address: "No 12 Ada Road Rumueme",
    referers_code: user1.referal_code,
    password: "pass1Word*",
    password_confirmation: "pass1Word*"
  })

{:ok, code, confirmed_user} = Confirmation.generate_confirmation_code(user)

{:ok, user6} = Confirmation.confirm_account(confirmed_user, code)

{:ok, %{user: user}} =
  Account.register_customer(%{
    location_id: l1.id,
    first_name: "Mercy",
    last_name: "Jonathan",
    email: "mercyjonathan@gmail.com",
    phone: "08102390121",
    address: "No 12 Ada Road Rumueme",
    date_of_birth: ~D[1982-02-21],
    referers_code: user1.referal_code,
    password: "pass1Word*",
    password_confirmation: "pass1Word*"
  })

{:ok, code, confirmed_user} = Confirmation.generate_confirmation_code(user)

{:ok, user7} = Confirmation.confirm_account(confirmed_user, code)

{:ok, %{user: user}} =
  Account.register_supplier(%{
    address: "No 12 Agip Road",
    status: "active",
    type: "individual",
    means_of_id: "National Id",
    id_image: "/home/dumadi/Downloads/WhatsApp Image 2021-11-04 at 12.49.11 AM.jpeg",
    first_name: "Nathan",
    last_name: "John",
    email: "nathanjohn@gmail.com",
    phone: "08179901920",
    city: "Port Harcourt",
    state: "Rivers State",
    country: "Nigeria",
    password: "pass1Word*",
    password_confirmation: "pass1Word*",
    location_id: l1.id,
    ecommerce_id: ecommerce_control.id
  })

{:ok, code, confirmed_user} = Confirmation.generate_confirmation_code(user)

{:ok, user8} = Confirmation.confirm_account(confirmed_user, code)

{:ok, %{user: user}} =
  Account.register_staff_user(%{
    guarantor_address: "No 15 St George Road Port Harcourt",
    guarantor_name: "Gabriel Thompson",
    guarantor_phone: "08167781920",
    id_image: "/home/dumadi/Downloads/WhatsApp Image 2021-11-04 at 12.49.11 AM.jpeg",
    first_name: "Dumadi",
    last_name: "Bakor",
    email: "dumadivure.bakor@yahoomail.com",
    phone: "08168891829",
    address: "No. 2 Agip Road Rumuola",
    home_town: "Biara Gokana",
    designation: "ceo",
    lga: "Gokana",
    state_of_origin: "Rivers State",
    country: "Nigeria",
    date_employed: ~D[2011-05-18],
    employment_status: "active",
    means_of_id: "Drivers Licence",
    id_number: "RV990p30429845",
    password: "pass1Word*",
    password_confirmation: "pass1Word*"
  })

ItemImage |> Repo.delete_all()

{:ok, %{image_uploads: image1}} =
  Catalogue.create_item_image(%{
    item_image1: "/home/dumadi/Desktop/banana.png",
    item_image2: "/home/dumadi/Desktop/banana.png",
    item_image3: "/home/dumadi/Desktop/banana.png",
    item_image4: "/home/dumadi/Desktop/banana.png",
    item_name: "Banana",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image2}} =
  Catalogue.create_item_image(%{
    item_image1: "/home/dumadi/Desktop/cakes.png",
    item_image2: "/home/dumadi/Desktop/cakes.png",
    item_image3: "/home/dumadi/Desktop/cakes.png",
    item_image4: "/home/dumadi/Desktop/cakes.png",
    item_name: "Cakes",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image3}} =
  Catalogue.create_item_image(%{
    item_image1: "/home/dumadi/Desktop/crafish.png",
    item_image2: "/home/dumadi/Desktop/crafish.png",
    item_image3: "/home/dumadi/Desktop/crafish.png",
    item_image4: "/home/dumadi/Desktop/crafish.png",
    item_name: "Cray Fish",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image4}} =
  Catalogue.create_item_image(%{
    item_image1: "/home/dumadi/Desktop/eggs.png",
    item_image2: "/home/dumadi/Desktop/eggs.png",
    item_image3: "/home/dumadi/Desktop/eggs.png",
    item_image4: "/home/dumadi/Desktop/eggs.png",
    item_name: "Egg",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image5}} =
  Catalogue.create_item_image(%{
    item_image1: "https://res.cloudinary.com/letorrc/image/upload/v1596849287/grapes_hzmvdv.png",
    item_image2: "https://res.cloudinary.com/letorrc/image/upload/v1596849287/grapes_hzmvdv.png",
    item_image3: "https://res.cloudinary.com/letorrc/image/upload/v1596849287/grapes_hzmvdv.png",
    item_image4: "https://res.cloudinary.com/letorrc/image/upload/v1596849287/grapes_hzmvdv.png",
    item_name: "Strawberry",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image6}} =
  Catalogue.create_item_image(%{
    item_image1: "https://res.cloudinary.com/letorrc/image/upload/v1596849296/lemon_uelnua.png",
    item_image2: "https://res.cloudinary.com/letorrc/image/upload/v1596849296/lemon_uelnua.png",
    item_image3: "https://res.cloudinary.com/letorrc/image/upload/v1596849296/lemon_uelnua.png",
    item_image4: "https://res.cloudinary.com/letorrc/image/upload/v1596849296/lemon_uelnua.png",
    item_name: "Lemon",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image7}} =
  Catalogue.create_item_image(%{
    item_image1: "https://res.cloudinary.com/letorrc/image/upload/v1596849540/milk_vpoaow.png",
    item_image2: "https://res.cloudinary.com/letorrc/image/upload/v1596849540/milk_vpoaow.png",
    item_image3: "https://res.cloudinary.com/letorrc/image/upload/v1596849540/milk_vpoaow.png",
    item_image4: "https://res.cloudinary.com/letorrc/image/upload/v1596849540/milk_vpoaow.png",
    item_name: "Itambe Milk",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image8}} =
  Catalogue.create_item_image(%{
    item_image1: "https://res.cloudinary.com/letorrc/image/upload/v1596849553/onion_zkuzio.png",
    item_image2: "https://res.cloudinary.com/letorrc/image/upload/v1596849553/onion_zkuzio.png",
    item_image3: "https://res.cloudinary.com/letorrc/image/upload/v1596849553/onion_zkuzio.png",
    item_image4: "https://res.cloudinary.com/letorrc/image/upload/v1596849553/onion_zkuzio.png",
    item_name: "Spring Onions",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image9}} =
  Catalogue.create_item_image(%{
    item_image1: "https://res.cloudinary.com/letorrc/image/upload/v1596849564/pepper_vlmw62.png",
    item_image2: "https://res.cloudinary.com/letorrc/image/upload/v1596849564/pepper_vlmw62.png",
    item_image3: "https://res.cloudinary.com/letorrc/image/upload/v1596849564/pepper_vlmw62.png",
    item_image4: "https://res.cloudinary.com/letorrc/image/upload/v1596849564/pepper_vlmw62.png",
    item_name: "Fresh Pepper",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image10}} =
  Catalogue.create_item_image(%{
    item_image1:
      "https://res.cloudinary.com/letorrc/image/upload/v1596849573/pompkins_mohcpx.png",
    item_image2:
      "https://res.cloudinary.com/letorrc/image/upload/v1596849573/pompkins_mohcpx.png",
    item_image3:
      "https://res.cloudinary.com/letorrc/image/upload/v1596849573/pompkins_mohcpx.png",
    item_image4:
      "https://res.cloudinary.com/letorrc/image/upload/v1596849573/pompkins_mohcpx.png",
    item_name: "Fresh Tomatoes",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image11}} =
  Catalogue.create_item_image(%{
    item_image1: "https://res.cloudinary.com/letorrc/image/upload/v1596849595/potato_q40ppj.png",
    item_image2: "https://res.cloudinary.com/letorrc/image/upload/v1596849595/potato_q40ppj.png",
    item_image3: "https://res.cloudinary.com/letorrc/image/upload/v1596849595/potato_q40ppj.png",
    item_image4: "https://res.cloudinary.com/letorrc/image/upload/v1596849595/potato_q40ppj.png",
    item_name: "Irish Potato",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image12}} =
  Catalogue.create_item_image(%{
    item_image1: "https://res.cloudinary.com/letorrc/image/upload/v1596849603/spinash_lxtedb.png",
    item_image2: "https://res.cloudinary.com/letorrc/image/upload/v1596849603/spinash_lxtedb.png",
    item_image3: "https://res.cloudinary.com/letorrc/image/upload/v1596849603/spinash_lxtedb.png",
    item_image4: "https://res.cloudinary.com/letorrc/image/upload/v1596849603/spinash_lxtedb.png",
    item_name: "Spinach",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image13}} =
  Catalogue.create_item_image(%{
    item_image1:
      "https://res.cloudinary.com/letorrc/image/upload/v1600516853/new_images/Milo-Nestle_fnvnpg.jpg",
    item_image2:
      "https://res.cloudinary.com/letorrc/image/upload/v1600516853/new_images/Milo-Nestle_fnvnpg.jpg",
    item_image3:
      "https://res.cloudinary.com/letorrc/image/upload/v1600516853/new_images/Milo-Nestle_fnvnpg.jpg",
    item_image4:
      "https://res.cloudinary.com/letorrc/image/upload/v1600516853/new_images/Milo-Nestle_fnvnpg.jpg",
    item_name: "Medium Size Tin Milo",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image14}} =
  Catalogue.create_item_image(%{
    item_image1: "/home/dumadi/Documents/New images/bournvita.jpg",
    item_image2: "/home/dumadi/Documents/New images/bournvita.jpg",
    item_image3: "/home/dumadi/Documents/New images/bournvita.jpg",
    item_image4: "/home/dumadi/Documents/New images/bournvita.jpg",
    item_name: "Small Size Bournvita",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image15}} =
  Catalogue.create_item_image(%{
    item_image1: "/home/dumadi/Documents/New images/dangote-salt2.jpg",
    item_image2: "/home/dumadi/Documents/New images/dangote-salt2.jpg",
    item_image3: "/home/dumadi/Documents/New images/dangote-salt2.jpg",
    item_image4: "/home/dumadi/Documents/New images/dangote-salt2.jpg",
    item_name: "Sachet Dangote Salt",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image16}} =
  Catalogue.create_item_image(%{
    item_image1: "/home/dumadi/Documents/New images/PowerPasta.jpg",
    item_image2: "/home/dumadi/Documents/New images/PowerPasta.jpg",
    item_image3: "/home/dumadi/Documents/New images/PowerPasta.jpg",
    item_image4: "/home/dumadi/Documents/New images/PowerPasta.jpg",
    item_name: "Power Pasta",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image17}} =
  Catalogue.create_item_image(%{
    item_image1: "/home/dumadi/Documents/New images/supradin.jpeg",
    item_image2: "/home/dumadi/Documents/New images/supradin.jpeg",
    item_image3: "/home/dumadi/Documents/New images/supradin.jpeg",
    item_image4: "/home/dumadi/Documents/New images/supradin.jpeg",
    item_name: "Supradin",
    ecommerce_control_id: ecommerce_control.id
  })

{:ok, %{image_uploads: image18}} =
  Catalogue.create_item_image(%{
    item_image1: "/home/dumadi/Documents/New images/coffee machin.jpg",
    item_image2: "/home/dumadi/Documents/New images/coffee machin.jpg",
    item_image3: "/home/dumadi/Documents/New images/coffee machin.jpg",
    item_image4: "/home/dumadi/Documents/New images/coffee machin.jpg",
    item_name: "Coffee Machine",
    ecommerce_control_id: ecommerce_control.id
  })

ItemCategory |> Repo.delete_all()

{:ok, cat1} =
  Catalogue.create_item_category(%{
    name: "Fruits & Vegetable",
    description: "All kinds of fruits and vegetables",
    pickup_centre_id: pickup_centre.id
  })

{:ok, cat2} =
  Catalogue.create_item_category(%{
    name: "Protein",
    description: "All kinds of meat and and sea food",
    pickup_centre_id: pickup_centre.id
  })

{:ok, cat3} =
  Catalogue.create_item_category(%{
    name: "Bread & Bakery",
    description: "Baked food items",
    pickup_centre_id: pickup_centre.id
  })

{:ok, cat4} =
  Catalogue.create_item_category(%{
    name: "Food Cupboard",
    description: "Food Cupboard",
    pickup_centre_id: pickup_centre.id
  })

{:ok, cat5} =
  Catalogue.create_item_category(%{
    name: "Beverages & Alcohol",
    description: "All kinds of beverages",
    pickup_centre_id: pickup_centre.id
  })

{:ok, cat6} =
  Catalogue.create_item_category(%{
    name: "Household",
    description: "Household items",
    pickup_centre_id: pickup_centre.id
  })

{:ok, cat7} =
  Catalogue.create_item_category(%{
    name: "Pharmacy",
    description: "Pharmaceutical and medical consumable items",
    pickup_centre_id: pickup_centre.id
  })

{:ok, cat8} =
  Catalogue.create_item_category(%{
    name: "Personal Care",
    description: "Personal Care Items",
    pickup_centre_id: pickup_centre.id
  })

{:ok, cat9} =
  Catalogue.create_item_category(%{
    name: "Mother and Babies",
    description: "Items for Mothers and Babies",
    pickup_centre_id: pickup_centre.id
  })

ItemSubcategory |> Repo.delete_all()

{:ok, sub1} =
  Catalogue.create_item_subcategory(%{
    name: "Fresh Nigeria vegetables",
    description: "Fresh local vegetables",
    item_category_id: cat1.id
  })

{:ok, sub2} =
  Catalogue.create_item_subcategory(%{
    name: "Bulk",
    description: "Bulk Fruits and Vegetables",
    item_category_id: cat1.id
  })

{:ok, sub3} =
  Catalogue.create_item_subcategory(%{
    name: "Fresh Vegetables",
    description: "All kinds of fresh vegetables",
    item_category_id: cat1.id
  })

{:ok, sub4} =
  Catalogue.create_item_subcategory(%{
    name: "Fresh Fruits",
    description: "All kinds of fresh fruits",
    item_category_id: cat1.id
  })

{:ok, sub5} =
  Catalogue.create_item_subcategory(%{
    name: "Fresh Prepared Fruits",
    description: "Fresh prepared fruits",
    item_category_id: cat1.id
  })

{:ok, sub6} =
  Catalogue.create_item_subcategory(%{
    name: "Fresh Prepared Vegetables",
    description: "Fresh prepared vegetables",
    item_category_id: cat1.id
  })

{:ok, sub7} =
  Catalogue.create_item_subcategory(%{
    name: "Nuts & Dried Fruits",
    description: "Nuts and dried fruits",
    item_category_id: cat1.id
  })

{:ok, sub8} =
  Catalogue.create_item_subcategory(%{
    name: "Fresh Herbs & Flowers",
    description: "All kinds of fresh herbs and flowers",
    item_category_id: cat1.id
  })

{:ok, sub9} =
  Catalogue.create_item_subcategory(%{
    name: "Dried Herbs & Flowers",
    description: "All kinds of dried herbs and flowers",
    item_category_id: cat1.id
  })

{:ok, sub10} =
  Catalogue.create_item_subcategory(%{
    name: "Beef & Goat Meat",
    description: "All kinds of Beef",
    item_category_id: cat2.id
  })

{:ok, sub11} =
  Catalogue.create_item_subcategory(%{
    name: "Bulk Meat",
    description: "Bulk Meat, Fish and Seafood",
    item_category_id: cat2.id
  })

{:ok, sub12} =
  Catalogue.create_item_subcategory(%{
    name: "Special Meat",
    description: "All kinds of special meat like Ram, Bush meat Etc",
    item_category_id: cat2.id
  })

{:ok, sub13} =
  Catalogue.create_item_subcategory(%{
    name: "Frozen Fish",
    description: "All kinds of Frozen fish",
    item_category_id: cat2.id
  })

{:ok, sub14} =
  Catalogue.create_item_subcategory(%{
    name: "Smoked Fish",
    description: "All kinds of smoked fish",
    item_category_id: cat2.id
  })

{:ok, sub15} =
  Catalogue.create_item_subcategory(%{
    name: "Stock Fish",
    description: "All kinds of stock fish",
    item_category_id: cat2.id
  })

{:ok, sub16} =
  Catalogue.create_item_subcategory(%{
    name: "Seafood",
    description: "All kinds of sea food",
    item_category_id: cat2.id
  })

{:ok, sub17} =
  Catalogue.create_item_subcategory(%{
    name: "Fresh Fish",
    description: "All kinds of fresh fish",
    item_category_id: cat2.id
  })

{:ok, sub18} =
  Catalogue.create_item_subcategory(%{
    name: "Bacon, Hot Dogs & Sausage",
    description: "Bacon, hotdogs and sausages",
    item_category_id: cat2.id
  })

{:ok, sub19} =
  Catalogue.create_item_subcategory(%{
    name: "Chicken & Turkey",
    description: "Chicken and turkey meat",
    item_category_id: cat2.id
  })

{:ok, sub20} =
  Catalogue.create_item_subcategory(%{
    name: "Pork",
    description: "Pork Meat",
    item_category_id: cat2.id
  })

{:ok, sub21} =
  Catalogue.create_item_subcategory(%{
    name: "Milk",
    description: "All kinds of milk",
    item_category_id: cat4.id
  })

{:ok, sub22} =
  Catalogue.create_item_subcategory(%{
    name: "Bulk Grains and Swallow",
    description: "Bulk items in Food Cupboard",
    item_category_id: cat4.id
  })

{:ok, sub23} =
  Catalogue.create_item_subcategory(%{
    name: "Yogurt",
    description: "All kinds of yogurt",
    item_category_id: cat4.id
  })

{:ok, sub24} =
  Catalogue.create_item_subcategory(%{
    name: "Butter & Margarine",
    description: "All kinds butter and Margarine",
    item_category_id: cat4.id
  })

{:ok, sub25} =
  Catalogue.create_item_subcategory(%{
    name: "Biscuits & Cookies",
    description: "All kinds of Biscuits and Cookies",
    item_category_id: cat4.id
  })

{:ok, sub26} =
  Catalogue.create_item_subcategory(%{
    name: "Cake",
    description: "All kinds of Cake",
    item_category_id: cat3.id
  })

{:ok, sub27} =
  Catalogue.create_item_subcategory(%{
    name: "Eggs",
    description: "All kinds of eggs",
    item_category_id: cat4.id
  })

{:ok, sub28} =
  Catalogue.create_item_subcategory(%{
    name: "Donuts & Pastries",
    description: "Mufins, donut and pastries",
    item_category_id: cat3.id
  })

{:ok, sub29} =
  Catalogue.create_item_subcategory(%{
    name: "Sliced Bread & Loaves",
    description: "Sliced Bread and Loaves",
    item_category_id: cat3.id
  })

{:ok, sub30} =
  Catalogue.create_item_subcategory(%{
    name: "Ice creams and Desserts",
    description: "All kinds of dessert and Ice creams",
    item_category_id: cat4.id
  })

{:ok, sub31} =
  Catalogue.create_item_subcategory(%{
    name: "Cereal & Breakfast Food",
    description: "Cereals and breakfast food",
    item_category_id: cat4.id
  })

{:ok, sub33} =
  Catalogue.create_item_subcategory(%{
    name: "Baking",
    description: "Baking items",
    item_category_id: cat6.id
  })

{:ok, sub34} =
  Catalogue.create_item_subcategory(%{
    name: "Condiments",
    description: "All kinds of Condiments",
    item_category_id: cat4.id
  })

{:ok, sub35} =
  Catalogue.create_item_subcategory(%{
    name: "Cooking Oils",
    description: "All kinds of Cooking oils",
    item_category_id: cat4.id
  })

{:ok, sub36} =
  Catalogue.create_item_subcategory(%{
    name: "Spices & Seasoning",
    description: "All kinds of spices and seasoning",
    item_category_id: cat4.id
  })

{:ok, sub37} =
  Catalogue.create_item_subcategory(%{
    name: "Canned Goods",
    description: "All kinds of Canned Food",
    item_category_id: cat4.id
  })

{:ok, sub38} =
  Catalogue.create_item_subcategory(%{
    name: "Pasta and Pizza",
    description: "Pasta and Pizza items",
    item_category_id: cat4.id
  })

{:ok, sub39} =
  Catalogue.create_item_subcategory(%{
    name: "Rice, Beans & Grains",
    description: "Rice, Beans and other grains",
    item_category_id: cat4.id
  })

{:ok, sub40} =
  Catalogue.create_item_subcategory(%{
    name: "International Food",
    description: "International Food",
    item_category_id: cat4.id
  })

{:ok, sub41} =
  Catalogue.create_item_subcategory(%{
    name: "Bulk Beverages",
    description: "Bulk beverages and Alcohol",
    item_category_id: cat5.id
  })

{:ok, sub42} =
  Catalogue.create_item_subcategory(%{
    name: "Soft Drinks",
    description: "All kinds of Soft drinks",
    item_category_id: cat5.id
  })

{:ok, sub43} =
  Catalogue.create_item_subcategory(%{
    name: "Fruit Juice",
    description: "All kinds of Fruit juice",
    item_category_id: cat5.id
  })

{:ok, sub44} =
  Catalogue.create_item_subcategory(%{
    name: "Water",
    description: "All kinds of Water products",
    item_category_id: cat5.id
  })

{:ok, sub45} =
  Catalogue.create_item_subcategory(%{
    name: "Sports & Energy Drinks",
    description: "All kinds sports and energy drinks",
    item_category_id: cat5.id
  })

{:ok, sub46} =
  Catalogue.create_item_subcategory(%{
    name: "Tea & Hot Chocolate",
    description: "All kinds tea and hot chocolate products",
    item_category_id: cat5.id
  })

{:ok, sub47} =
  Catalogue.create_item_subcategory(%{
    name: "Coffee",
    description: "All kinds of Coffee products",
    item_category_id: cat5.id
  })

{:ok, sub48} =
  Catalogue.create_item_subcategory(%{
    name: "Specialty Drinks",
    description: "All kinds of specialty drinks",
    item_category_id: cat5.id
  })

{:ok, sub49} =
  Catalogue.create_item_subcategory(%{
    name: "Mixers",
    description: "All kinds of mixers",
    item_category_id: cat5.id
  })

{:ok, sub50} =
  Catalogue.create_item_subcategory(%{
    name: "Beer",
    description: "All kinds of Beer",
    item_category_id: cat5.id
  })

{:ok, sub51} =
  Catalogue.create_item_subcategory(%{
    name: "Red Wine",
    description: "All kinds of Red Wine",
    item_category_id: cat5.id
  })

{:ok, sub52} =
  Catalogue.create_item_subcategory(%{
    name: "White Wine",
    description: "All kinds of White Wine",
    item_category_id: cat5.id
  })

{:ok, sub53} =
  Catalogue.create_item_subcategory(%{
    name: "Rose & Blush Wine",
    description: "All kinds of Rose and Blush Wine",
    item_category_id: cat5.id
  })

{:ok, sub54} =
  Catalogue.create_item_subcategory(%{
    name: "Champaign & Sparkling Wine",
    description: "All kinds of Champaign and Sparkling Wine",
    item_category_id: cat5.id
  })

{:ok, sub55} =
  Catalogue.create_item_subcategory(%{
    name: "Spirits",
    description: "All kinds of Spirits",
    item_category_id: cat5.id
  })

{:ok, sub56} =
  Catalogue.create_item_subcategory(%{
    name: "Canned Cocktail",
    description: "All kinds of Canned Cocktail",
    item_category_id: cat5.id
  })

{:ok, sub57} =
  Catalogue.create_item_subcategory(%{
    name: "Kitchen Appliances",
    description: "Lite Kitchen appliances",
    item_category_id: cat6.id
  })

{:ok, sub58} =
  Catalogue.create_item_subcategory(%{
    name: "Storage & Organization",
    description: "Household storage and organization items",
    item_category_id: cat6.id
  })

{:ok, sub59} =
  Catalogue.create_item_subcategory(%{
    name: "Dinnerware & Drinkware",
    description: "Dinnerware and drinkware",
    item_category_id: cat6.id
  })

{:ok, sub60} =
  Catalogue.create_item_subcategory(%{
    name: "Kitchen",
    description: "Kitchen tools",
    item_category_id: cat6.id
  })

{:ok, sub61} =
  Catalogue.create_item_subcategory(%{
    name: "Bathroom",
    description: "Bathroom items",
    item_category_id: cat6.id
  })

{:ok, sub62} =
  Catalogue.create_item_subcategory(%{
    name: "Bedding",
    description: "Beddings",
    item_category_id: cat6.id
  })

{:ok, sub63} =
  Catalogue.create_item_subcategory(%{
    name: "Home Decor",
    description: "Home decor items",
    item_category_id: cat6.id
  })

{:ok, sub64} =
  Catalogue.create_item_subcategory(%{
    name: "Furniture",
    description: "Lite furnitures",
    item_category_id: cat6.id
  })

{:ok, sub65} =
  Catalogue.create_item_subcategory(%{
    name: "Yam, Potato, Roots & Tubers",
    description: "Yam, Potato, Roots and Tubers",
    item_category_id: cat4.id
  })

{:ok, sub66} =
  Catalogue.create_item_subcategory(%{
    name: "Swallow",
    description: "All kinds of swallow",
    item_category_id: cat4.id
  })

{:ok, sub66} =
  Catalogue.create_item_subcategory(%{
    name: "Multivitamins",
    description: "All kinds of Multivitamins",
    item_category_id: cat7.id
  })

InventoryLocation |> Repo.delete_all()

{:ok, inv_loc1} =
  Centres.create_inventory_location(%{
    name: "Rice Stack1",
    type: "Bags Stack",
    pickup_centre_id: pickup_centre.id
  })

{:ok, inv_loc2} =
  Centres.create_inventory_location(%{
    name: "Fruits Shelve 1",
    type: "Shelf",
    pickup_centre_id: pickup_centre.id
  })

{:ok, inv_loc3} =
  Centres.create_inventory_location(%{
    name: "Egg Shelve 1",
    type: "Shelf",
    pickup_centre_id: pickup_centre.id
  })

{:ok, inv_loc4} =
  Centres.create_inventory_location(%{
    name: "Cold Room",
    type: "Cold Room 1",
    pickup_centre_id: pickup_centre.id
  })

{:ok, inv_loc5} =
  Centres.create_inventory_location(%{
    name: "Potato Corner",
    type: "Floor",
    pickup_centre_id: pickup_centre.id
  })

{:ok, inv_loc6} =
  Centres.create_inventory_location(%{
    name: "Leaves Shelf",
    type: "Shelf",
    pickup_centre_id: pickup_centre.id
  })

{:ok, inv_loc7} =
  Centres.create_inventory_location(%{
    name: "Food Drinks Shelf",
    type: "Shelf",
    pickup_centre_id: pickup_centre.id
  })

{:ok, inv_loc8} =
  Centres.create_inventory_location(%{
    name: "Salt Shelf",
    type: "Shelf",
    pickup_centre_id: pickup_centre.id
  })

{:ok, inv_loc9} =
  Centres.create_inventory_location(%{
    name: "Pasta Shelf",
    type: "Shelf",
    pickup_centre_id: pickup_centre.id
  })

{:ok, inv_loc10} =
  Centres.create_inventory_location(%{
    name: "Multivitamins",
    type: "Pharmacy Shelf",
    pickup_centre_id: pickup_centre.id
  })

{:ok, inv_loc11} =
  Centres.create_inventory_location(%{
    name: "Kitchen Tools Shelf",
    type: "Kitchen Tools",
    pickup_centre_id: pickup_centre.id
  })

DailyDeal |> Repo.delete_all()

{:ok, deals} =
  Centres.create_daily_deal(%{
    pickup_centre_id: pickup_centre.id
  })

FeaturedItem |> Repo.delete_all()

{:ok, featured} =
  Centres.create_featured_item(%{
    pickup_centre_id: pickup_centre.id
  })

PopularItem |> Repo.delete_all()

{:ok, pop} =
  Centres.create_popular_item(%{
    pickup_centre_id: pickup_centre.id
  })

ItemTag |> Repo.delete_all()

{:ok, tag1} =
  Catalogue.create_item_tag(%{
    name: "Vegan",
    description: "Vegetarian foods",
    class: "Nutrition"
  })

{:ok, tag2} =
  Catalogue.create_item_tag(%{
    name: "Halal Certified",
    description: "Items that are Halal Certified",
    class: "Nutrition"
  })

{:ok, tag3} =
  Catalogue.create_item_tag(%{
    name: "Over the counter drugs",
    description: "Over the counter medicine",
    class: "Drugs and Medicals"
  })

{:ok, tag4} =
  Catalogue.create_item_tag(%{
    name: "Prescription drugs",
    description: "Over the counter medicine",
    class: "Drugs and Medicals"
  })

{:ok, tag5} =
  Catalogue.create_item_tag(%{
    name: "Sugar Free",
    description: "Sugar free items",
    class: "Nutrition"
  })

{:ok, tag6} =
  Catalogue.create_item_tag(%{
    name: "Low Cholesterol",
    description: "Low Cholesterol items",
    class: "Nutrition"
  })

{:ok, tag8} =
  Catalogue.create_item_tag(%{
    name: "Household Items",
    description: "Household items",
    class: "Household Items"
  })

Inventory |> Repo.delete_all()
Item |> Repo.delete_all()
Sku |> Repo.delete_all()
InventoryChangeHistory |> Repo.delete_all()

{:ok, %{item: item1}} =
  Catalogue.create_sku_inventory_and_item(%{
    item_subcategory_id: sub4.id,
    item_tag_id: tag5.id,
    type: "Groceries",
    details: "",
    brand_name: "",
    package_uom: "Hand",
    barcode: "",
    brand_name: "",
    details: "Fresh Banana sourced from the land of Ekpeye",
    item_image_id: image1.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc2.id,
    description: "Ripe Fresh Nigerian Bananas",
    max_bulk_quantity: 30,
    name: "Banana",
    re_order_level: 5,
    sales_unit_quantity: 20,
    bulk_quantity: 5,
    sales_unit_quantity_uom: "Hand",
    bulk_quantity_uom: "Bunch",
    buy_price: 500,
    unit_sales_price: 800,
    bulk_sales_price: 3000,
    re_order_level: 2,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item1, %{daily_deals_id: deals.id})

{:ok, %{item: item2}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_tag_id: tag5.id,
    details: "special made with adequate amount of sugar for children",
    item_subcategory_id: sub26.id,
    type: "Groceries",
    details: "",
    brand_name: "",
    package_uom: "Packet",
    item_image_id: image2.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc2.id,
    description: "Cakes",
    max_bulk_quantity: 30,
    name: "Cakes",
    re_order_level: 13,
    sales_unit_quantity: 12,
    bulk_quantity: 5,
    sales_unit_quantity_uom: "Piece",
    bulk_quantity_uom: "Piece",
    buy_price: 150,
    unit_sales_price: 250,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item2, %{daily_deals_id: deals.id, featured_item_id: featured.id})

{:ok, %{item: item3}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_tag_id: "",
    item_subcategory_id: sub16.id,
    type: "Groceries",
    details: "",
    brand_name: "",
    package_uom: "Piece",
    description: "Fresh Cray Fish",
    item_image_id: image3.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc2.id,
    max_bulk_quantity: 15,
    name: "Cray Fish",
    re_order_level: 3,
    sales_unit_quantity: 12,
    bulk_quantity: 5,
    sales_unit_quantity_uom: "bowl",
    bulk_quantity_uom: "Basket",
    buy_price: 500,
    unit_sales_price: 750,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item3, %{daily_deals_id: deals.id, featured_item_id: featured.id})

{:ok, %{item: item4}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_tag_id: "",
    item_subcategory_id: sub27.id,
    type: "Groceries",
    details: "",
    brand_name: "",
    package_uom: "Crate",
    description: "Fresh Eggs",
    item_image_id: image4.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc3.id,
    max_bulk_quantity: 120,
    name: "Egg",
    re_order_level: 10,
    sales_unit_quantity: 80,
    bulk_quantity: 10,
    sales_unit_quantity_uom: "crate",
    bulk_quantity_uom: "crate",
    buy_price: 700,
    unit_sales_price: 1000,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item4, %{daily_deals_id: deals.id, featured_item_id: featured.id})

{:ok, %{item: item5}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_tag_id: "",
    item_subcategory_id: sub4.id,
    type: "Groceries",
    details: "",
    brand_name: "",
    package_uom: "Crate",
    item_image_id: image5.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc2.id,
    description: "Strawberry",
    max_bulk_quantity: 120,
    name: "Strawberry",
    re_order_level: 13,
    sales_unit_quantity: 80,
    bulk_quantity: 10,
    sales_unit_quantity_uom: "packets",
    bulk_quantity_uom: "packets",
    buy_price: 500,
    unit_sales_price: 700,
    bulk_sales_price: 3000,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item5, %{daily_deals_id: deals.id, featured_item_id: featured.id})

{:ok, %{item: item6}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_tag_id: "",
    item_subcategory_id: sub4.id,
    type: "Groceries",
    details: "",
    brand_name: "",
    package_uom: "Piece",
    item_image_id: image6.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc2.id,
    description: "Lemon",
    max_bulk_quantity: 120,
    name: "Lemon",
    re_order_level: 5,
    sales_unit_quantity: 80,
    bulk_quantity: 10,
    sales_unit_quantity_uom: "packets",
    bulk_quantity_uom: "packets",
    buy_price: 200,
    unit_sales_price: 300,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item6, %{daily_deals_id: deals.id, featured_item_id: featured.id})

{:ok, %{item: item7}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_subcategory_id: sub21.id,
    type: "Groceries",
    item_tag_id: "",
    details: "",
    brand_name: "",
    package_uom: "Sachet",
    item_image_id: image7.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc2.id,
    description: "Itambe Sachet Liquid Milk",
    max_bulk_quantity: 30,
    name: "Itambe Milk",
    re_order_level: 5,
    sales_unit_quantity: 80,
    bulk_quantity: 5,
    sales_unit_quantity_uom: "Packet",
    bulk_quantity_uom: "Carton",
    buy_price: 150,
    unit_sales_price: 250,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item7, %{
  daily_deals_id: deals.id,
  popular_item_id: pop.id,
  featured_item_id: featured.id
})

{:ok, %{item: item8}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_subcategory_id: sub3.id,
    type: "Groceries",
    details: "",
    item_tag_id: "",
    brand_name: "",
    package_uom: "Sachet",
    item_image_id: image8.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc2.id,
    description: "Spring Onions",
    max_bulk_quantity: 30,
    name: "Spring Onions",
    re_order_level: 10,
    sales_unit_quantity: 10,
    bulk_quantity: 5,
    sales_unit_quantity_uom: "Basket",
    bulk_quantity_uom: "Set",
    buy_price: 150,
    unit_sales_price: 250,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item8, %{daily_deals_id: deals.id, popular_item_id: featured.id})

{:ok, %{item: item9}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    type: "Groceries",
    details: "",
    brand_name: "",
    package_uom: "Bowl",
    item_tag_id: "",
    item_image_id: image9.id,
    item_subcategory_id: sub1.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc2.id,
    description: "Fresh Pepper",
    max_bulk_quantity: 30,
    name: "Fresh Pepper",
    re_order_level: 10,
    sales_unit_quantity: 10,
    bulk_quantity: 5,
    sales_unit_quantity_uom: "Basket",
    bulk_quantity_uom: "Bowl",
    buy_price: 400,
    unit_sales_price: 600,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

{:ok, %{item: item10}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_subcategory_id: sub3.id,
    type: "Groceries",
    details: "",
    brand_name: "",
    package_uom: "Bowl",
    item_tag_id: tag1.id,
    item_image_id: image10.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc2.id,
    description: "Fresh Tomatoes",
    max_bulk_quantity: 30,
    name: "Fresh Tomatoes",
    re_order_level: 10,
    sales_unit_quantity: 10,
    bulk_quantity: 5,
    sales_unit_quantity_uom: "Basket",
    bulk_quantity_uom: "Bowl",
    buy_price: 150,
    unit_sales_price: 250,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item10, %{
  daily_deals_id: deals.id,
  featured_item_id: featured.id,
  popular_item_id: pop.id
})

{:ok, %{item: item11}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_subcategory_id: sub65.id,
    type: "Groceries",
    details: "",
    item_tag_id: tag1.id,
    brand_name: "",
    package_uom: "Bowl",
    item_image_id: image11.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc5.id,
    description: "Irish Potato",
    max_bulk_quantity: 30,
    name: "Irish Potato",
    re_order_level: 13,
    sales_unit_quantity: 10,
    bulk_quantity: 5,
    sales_unit_quantity_uom: "Basket",
    bulk_quantity_uom: "Bowl",
    buy_price: 500,
    unit_sales_price: 600,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item11, %{
  popular_item_id: pop.id
})

{:ok, %{item: item12}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_subcategory_id: sub3.id,
    type: "Groceries",
    details: "",
    item_tag_id: "",
    brand_name: "",
    package_uom: "Bowl",
    item_image_id: image12.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc6.id,
    description: "Spinach",
    max_bulk_quantity: 30,
    name: "Spinach",
    re_order_level: 5,
    sales_unit_quantity: 10,
    bulk_quantity: 5,
    sales_unit_quantity_uom: "Basket",
    bulk_quantity_uom: "Bowl",
    buy_price: 250,
    unit_sales_price: 400,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item12, %{
  popular_item_id: pop.id
})

{:ok, %{item: item13}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_subcategory_id: sub46.id,
    item_image_id: image13.id,
    type: "Groceries",
    details: "",
    item_tag_id: "",
    brand_name: "",
    package_uom: "tin",
    brand_name: "Nestle",
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc7.id,
    description: "Medium Size Tin Milo",
    max_bulk_quantity: 300,
    name: "Medium Size Tin Milo",
    re_order_level: 10,
    sales_unit_quantity: 100,
    bulk_quantity: 25,
    sales_unit_quantity_uom: "tin",
    bulk_quantity_uom: "Carton",
    buy_price: 1000,
    unit_sales_price: 1200,
    bulk_sales_price: 3000,
    brand_name: "Nestle",
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item13, %{
  popular_item_id: pop.id
})

inv14 =
  Catalogue.create_sku_inventory_and_item(%{
    type: "Groceries",
    details: "",
    brand_name: "",
    barcode: "",
    item_tag_id: "",
    package_uom: "Tin",
    item_subcategory_id: sub46.id,
    item_image_id: image14.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc7.id,
    description: "Small Size, tin cadbury bournvita",
    max_bulk_quantity: 300,
    name: "Small Size Bournvita",
    re_order_level: 10,
    sales_unit_quantity: 100,
    bulk_quantity: 25,
    sales_unit_quantity_uom: "tin",
    bulk_quantity_uom: "Carton",
    buy_price: 1000,
    unit_sales_price: 1200,
    bulk_sales_price: 3000,
    brand_name: "Cadbury",
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

{:ok, %{item: item15}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_subcategory_id: sub38.id,
    type: "Groceries",
    details: "",
    brand_name: "",
    item_tag_id: "",
    package_uom: "sachet",
    brand_name: "Golden Penni",
    item_image_id: image15.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc8.id,
    description: "Iodized Sachet Dangote Salt",
    max_bulk_quantity: 300,
    name: "Sachet Dangote Salt",
    re_order_level: 10,
    sales_unit_quantity: 100,
    bulk_quantity: 25,
    sales_unit_quantity_uom: "Sachet",
    bulk_quantity_uom: "Bags",
    buy_price: 1000,
    unit_sales_price: 1200,
    bulk_sales_price: 3000,
    brand_name: "Danngote",
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

Catalogue.update_for_special_cat(item15, %{
  popular_item_id: pop.id
})

{:ok, %{item: item16}} =
  Catalogue.create_sku_inventory_and_item(%{
    barcode: "",
    item_subcategory_id: sub66.id,
    type: "Health",
    name: "Supradin",
    item_tag_id: tag3.id,
    package_uom: "Packet",
    description: "Supradin Capsules",
    brand_name: "Emzor",
    item_image_id: image17.id,
    pickup_centre_id: pickup_centre.id,
    inventory_location_id: inv_loc10.id,
    max_bulk_quantity: 300,
    re_order_level: 10,
    sales_unit_quantity: 100,
    bulk_quantity: 25,
    sales_unit_quantity_uom: "packet",
    bulk_quantity_uom: "Carton",
    buy_price: 1000,
    unit_sales_price: 1200,
    bulk_sales_price: 3000,
    status: "available",
    expiry_date: ~D[2023-02-03]
  })

ShoppingList |> Repo.delete_all()

Account.create_shopping_list(%{
  title: "Fruits Shopping list",
  user_id: user.id
})

Catalogue.update_for_special_cat(item16, %{
  daily_deals_id: deals.id,
  featured_item_id: featured.id,
  popular_item_id: pop.id
})

RecipeClass |> Repo.delete_all()

{:ok, recipe_class1} =
  Delicacies.create_recipe_class(%{
    name: "Nigeria Cuisines",
    description: "All kinds of Nigeria Cuisines",
    pickup_centre_id: pickup_centre.id
  })

{:ok, recipe_class2} =
  Delicacies.create_recipe_class(%{
    name: "Ghanian Cuisines",
    description: "All kinds of Ghanian Cuisines",
    pickup_centre_id: pickup_centre.id
  })

{:ok, recipe_class3} =
  Delicacies.create_recipe_class(%{
    name: "Inter-Continental Cuisines",
    description: "All kinds of Beninese Cuisines",
    pickup_centre_id: pickup_centre.id
  })

Recipe |> Repo.delete_all()

{:ok, recipe1} =
  Delicacies.create_recipe(%{
    description:
      "Chicken Wings, Made with special spices and also deep fried to be crispy and yummy",
    name: "Chicken Wings",
    directions:
      "<p>1. Cut out twelve 4-inch rounds from tortillas, press into 12 muffin cups. Bake for 3 to 4 minutes or until lightly crisped but not browned<br>
    2. Divide pancetta, red pepper, goat cheese and green onion among tortilla cups.<br>
    3. Whisk together eggs, milk, Parmesen and pepper, divide evenly among tortilla cups. Bake for about 15 minutes or until filling is set.<br>

    4. Tip. To cook pancetta, heat large skillet set over medium heat. Saute pancetta for 5 to 8 minutes or until golden and crispy. Drain on paper towels.</p>",
    image1_url: "/home/dumadi/Documents/New images/chickenwings.jpeg",
    meal_type: "breakfast",
    recipe_class_id: recipe_class3.id
  })

{:ok, recipe2} =
  Delicacies.create_recipe(%{
    description:
      "Special Macaroni Soup, made from Macaroni and special ingredients to give it a Wow! taste",
    name: "Macaroni Soup",
    directions:
      "<p>1. Cut out twelve 4-inch rounds from tortillas, press into 12 muffin cups. Bake for 3 to 4 minutes or until lightly crisped but not browned<br>
    2. Divide pancetta, red pepper, goat cheese and green onion among tortilla cups.<br>
    3. Whisk together eggs, milk, Parmesen and pepper, divide evenly among tortilla cups. Bake for about 15 minutes or until filling is set.<br>

    4. Tip. To cook pancetta, heat large skillet set over medium heat. Saute pancetta for 5 to 8 minutes or until golden and crispy. Drain on paper towels.</p>",
    image1_url:
      "https://res.cloudinary.com/letorrc/image/upload/v1605045640/recipes/macaroni_zncf8i.jpg",
    meal_type: "breakfast",
    recipe_class_id: recipe_class3.id
  })

{:ok, recipe3} =
  Delicacies.create_recipe(%{
    description:
      "Special recipe for chicken nuggets, this is a popular recipe amongst Italian Americans",
    name: "Chicken Nuggets",
    directions:
      "<p>1. Cut out twelve 4-inch rounds from tortillas, press into 12 muffin cups. Bake for 3 to 4 minutes or until lightly crisped but not browned<br>
    2. Divide pancetta, red pepper, goat cheese and green onion among tortilla cups.<br>
    3. Whisk together eggs, milk, Parmesen and pepper, divide evenly among tortilla cups. Bake for about 15 minutes or until filling is set.<br>

    4. Tip. To cook pancetta, heat large skillet set over medium heat. Saute pancetta for 5 to 8 minutes or until golden and crispy. Drain on paper towels.</p>",
    special: true,
    image1_url:
      "https://res.cloudinary.com/letorrc/image/upload/v1605045640/recipes/chickenuggets_z8yuly.jpg",
    meal_type: "lunch",
    recipe_class_id: recipe_class3.id
  })

{:ok, recipe4} =
  Delicacies.create_recipe(%{
    description:
      "This recipe is best made with free range cow meat. The beef should never be over cooked for it to have a good look",
    name: "Slizzed Beef",
    directions:
      "<p>1. Cut out twelve 4-inch rounds from tortillas, press into 12 muffin cups. Bake for 3 to 4 minutes or until lightly crisped but not browned<br>
    2. Divide pancetta, red pepper, goat cheese and green onion among tortilla cups.<br>
    3. Whisk together eggs, milk, Parmesen and pepper, divide evenly among tortilla cups. Bake for about 15 minutes or until filling is set.<br>

    4. Tip. To cook pancetta, heat large skillet set over medium heat. Saute pancetta for 5 to 8 minutes or until golden and crispy. Drain on paper towels.</p>",
    special: true,
    image1_url:
      "https://res.cloudinary.com/letorrc/image/upload/v1605045640/recipes/slizedbeef_ltevm2.jpg",
    meal_type: "all purpose",
    recipe_class_id: recipe_class3.id
  })

{:ok, recipe5} =
  Delicacies.create_recipe(%{
    description: "A southern Nigerian Cuisine made from a special specie of mellon seeds",
    name: "Egusi Soup",
    directions:
      "<p>1. Cut out twelve 4-inch rounds from tortillas, press into 12 muffin cups. Bake for 3 to 4 minutes or until lightly crisped but not browned<br>
    2. Divide pancetta, red pepper, goat cheese and green onion among tortilla cups.<br>
    3. Whisk together eggs, milk, Parmesen and pepper, divide evenly among tortilla cups. Bake for about 15 minutes or until filling is set.<br>

    4. Tip. To cook pancetta, heat large skillet set over medium heat. Saute pancetta for 5 to 8 minutes or until golden and crispy. Drain on paper towels.</p>",
    special: true,
    image1_url:
      "https://res.cloudinary.com/letorrc/image/upload/v1612734759/recipes/Egusi_xozae6.jpg",
    meal_type: "lunch",
    recipe_class_id: recipe_class1.id
  })

{:ok, recipe6} =
  Delicacies.create_recipe(%{
    description: "A Nigerian Cuisine made from fresh Okras",
    name: "Okro Soup",
    directions:
      "<p>1. Cut out twelve 4-inch rounds from tortillas, press into 12 muffin cups. Bake for 3 to 4 minutes or until lightly crisped but not browned<br>
    2. Divide pancetta, red pepper, goat cheese and green onion among tortilla cups.<br>
    3. Whisk together eggs, milk, Parmesen and pepper, divide evenly among tortilla cups. Bake for about 15 minutes or until filling is set.<br>

    4. Tip. To cook pancetta, heat large skillet set over medium heat. Saute pancetta for 5 to 8 minutes or until golden and crispy. Drain on paper towels.</p>",
    special: true,
    image1_url:
      "https://res.cloudinary.com/letorrc/image/upload/c_scale,h_304,w_456/v1612735136/recipes/okrosoup-1_duztoi.jpg",
    meal_type: "lunch",
    recipe_class_id: recipe_class1.id
  })

{:ok, recipe7} =
  Delicacies.create_recipe(%{
    description: "A Nigerian Cuisine made from a bitter vegetable called bitter leaf",
    name: "Bitter Leaf Soup",
    directions:
      "<p>1. Cut out twelve 4-inch rounds from tortillas, press into 12 muffin cups. Bake for 3 to 4 minutes or until lightly crisped but not browned<br>
    2. Divide pancetta, red pepper, goat cheese and green onion among tortilla cups.<br>
    3. Whisk together eggs, milk, Parmesen and pepper, divide evenly among tortilla cups. Bake for about 15 minutes or until filling is set.<br>

    4. Tip. To cook pancetta, heat large skillet set over medium heat. Saute pancetta for 5 to 8 minutes or until golden and crispy. Drain on paper towels.</p>",
    special: true,
    image1_url:
      "https://res.cloudinary.com/letorrc/image/upload/c_scale,h_304,q_94,w_456/v1612735137/recipes/bitterleaf_yfjuzn.jpg",
    meal_type: "dinner",
    recipe_class_id: recipe_class1.id
  })

ItemRecipe |> Repo.delete_all()

Delicacies.create_item_recipe(%{
  item_id: item1.id,
  recipe_id: recipe1.id
})

Delicacies.create_item_recipe(%{
  item_id: item2.id,
  recipe_id: recipe1.id
})

Delicacies.create_item_recipe(%{
  item_id: item3.id,
  recipe_id: recipe1.id
})

Delicacies.create_item_recipe(%{
  item_id: item4.id,
  recipe_id: recipe1.id
})

Delicacies.create_item_recipe(%{
  item_id: item2.id,
  recipe_id: recipe2.id
})

Delicacies.create_item_recipe(%{
  item_id: item6.id,
  recipe_id: recipe2.id
})

Delicacies.create_item_recipe(%{
  item_id: item5.id,
  recipe_id: recipe2.id
})

Delicacies.create_item_recipe(%{
  item_id: item7.id,
  recipe_id: recipe2.id
})

Delicacies.create_item_recipe(%{
  item_id: item9.id,
  recipe_id: recipe5.id
})

Delicacies.create_item_recipe(%{
  item_id: item3.id,
  recipe_id: recipe5.id
})

Delicacies.create_item_recipe(%{
  item_id: item8.id,
  recipe_id: recipe5.id
})

Delicacies.create_item_recipe(%{
  item_id: item9.id,
  recipe_id: recipe6.id
})

Delicacies.create_item_recipe(%{
  item_id: item3.id,
  recipe_id: recipe6.id
})

Delicacies.create_item_recipe(%{
  item_id: item8.id,
  recipe_id: recipe6.id
})

Delicacies.create_item_recipe(%{
  item_id: item9.id,
  recipe_id: recipe7.id
})

Delicacies.create_item_recipe(%{
  item_id: item3.id,
  recipe_id: recipe7.id
})

Delicacies.create_item_recipe(%{
  item_id: item8.id,
  recipe_id: recipe7.id
})

Agent |> Repo.delete_all()

{:ok, campus_agent} =
  AgentsAndSuppliers.create_agent(%{
    business_address: "No 12 Agip Road Rumueme",
    agents_image: "/home/dumadi/Downloads/WhatsApp Image 2022-04-11 at 1.35.14 PM.jpeg",
    email: "nneka@gmail.com",
    first_name: "Nneka",
    guarantor_first_name: "Daniel",
    guarantor_phone: "09029901928",
    guarantor_residential_address: "No 12 Ada George Road PHC",
    guarantor_last_name: "Micah",
    home_town: "Alimnmini",
    id_image: "/home/dumadi/Downloads/WhatsApp Image 2022-04-11 at 1.35.14 PM.jpeg",
    last_name: "Nwachukwu",
    means_of_id: "National ID",
    nationality: "Nigeria",
    phone: "08039901928",
    residential_address: "No 1 Ada George Road PHC",
    state_of_origin: "Rivers",
    status: "active",
    verified: true,
    covered_institution_id: covered_institution.id,
    ecommerce_control_id: ecommerce_control.id,
    location_id: l1.id
  })

Supplier |> Repo.delete_all()

# Warehouse |> Repo.delete_all()

# {:ok, %{warehouse: warehouse}} =
# Centres.create_warehouse(%{
#  address: "No 12 Aba Road Port Harcourt",
# area: "Rumuomasi",
# city: "Port Harcourt",
# country: "Nigeria",
# name: "Aba Road Warehouse",
# point: %Geo.Point{coordinates: {3.90010, -0.98827}, srid: 4326},
# ecommerce_control_id: ecommerce_control.id,
# state: "Rivers State"
# })

# WarehouseInventory |> Repo.delete_all()

# Centres.create_warehouse_inventory(%{
# description: "Special China ceramic dishes",
# expiry_date: ~D[2021-06-16],
## image_url: "87y0EF23rblhfa]av",
# name: "Ceramicous Chinese",
# quantity: 21,
# unit_unit_sales_price: 1400,
# bulk_unit_sales_price: 26000,
# uom: "Carton",
# warehouse_id: warehouse.id
# seller_delivery_id
# warehouse_inventory_location
# })
