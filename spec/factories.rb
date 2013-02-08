FactoryGirl.define do

  factory :drop_ship_order, :class => Spree::DropShipOrder do
    supplier { create(:supplier) }
    order { Spree::Order.complete.last }
    total 0
  end

  factory :supplier, :class => Spree::Supplier do
    name "Big Store"
    email { Faker::Internet.email }
    phone "800-555-5555"
    url "http://example.com"
    address { create(:address) }
  end

end
