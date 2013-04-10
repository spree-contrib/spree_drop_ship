FactoryGirl.define do

  factory :drop_ship_order, :class => Spree::DropShipOrder do
    supplier
    order { create(:completed_order_with_totals) }
    commission 0
  end

  factory :order_for_drop_ship, parent: :order_with_line_items do
    after :create do |order|
      supplier = create(:supplier)
      order.shipments.update_all(stock_location_id: supplier.stock_locations.first.id)
      create(:drop_ship_order, line_items: order.line_items, order: order, supplier: supplier)
    end
  end

  factory :supplier, :class => Spree::Supplier do
    sequence(:name) { |i| "Big Store #{i}" }
    email { Faker::Internet.email }
    url "http://example.com"
    address
  end

  factory :supplier_user, parent: :user do
    after :create do |user|
      create(:supplier, users: [user])
    end
  end

  factory :supplier_with_user, parent: :supplier do
    after :create do |supplier|
      unless supplier.users.first
        supplier.users << create(:user)
      end
    end
  end

  factory :variant_with_supplier, parent: :variant do
    product { create(:product, supplier: create(:supplier)) }
  end

end
