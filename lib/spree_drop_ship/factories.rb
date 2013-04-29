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

  factory :order_ready_for_drop_ship, parent: :order_ready_to_ship do
    after :create do |order|
      supplier = create(:supplier)
      order.shipments.update_all(stock_location_id: supplier.stock_locations.first.id)
      create(:drop_ship_order, line_items: order.line_items, order: order, supplier: supplier)
    end
  end

  factory :supplier, :class => Spree::Supplier do
    sequence(:name) { |i| "Big Store #{i}" }
    email { Faker::Internet.email }
    merchant_type 'individual'
    contacts_date_of_birth '1970-4-20'
    url "http://example.com"
    address
  end

  factory :supplier_bank_account, class: Spree::SupplierBankAccount do
    supplier
    # Details sent to Balanced.
    name 'John Doe'
    account_number '9900000001'
    routing_number '121000358'
    type 'checking'
  end

  factory :supplier_user, parent: :user do
    supplier
  end

  factory :variant_with_supplier, parent: :variant do
    product { create(:product, supplier: create(:supplier)) }
  end

end
