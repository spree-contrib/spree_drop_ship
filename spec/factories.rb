FactoryGirl.define do

  factory :line_item_to_drop_ship, parent: :line_item do
    supplier
  end

  factory :drop_ship_order, :class => Spree::DropShipOrder do
    supplier
    order { create(:completed_order_with_totals) }
    total 0
    commission_fee 0
  end

  factory :supplier, :class => Spree::Supplier do
    name "Big Store"
    email { Faker::Internet.email }
    phone "800-555-5555"
    url "http://example.com"
    address
    commission_fee_percentage 0
  end

end
