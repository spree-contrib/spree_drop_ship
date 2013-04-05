FactoryGirl.define do

  factory :drop_ship_order, :class => Spree::DropShipOrder do
    supplier
    order { create(:completed_order_with_totals) }
    commission 0
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
