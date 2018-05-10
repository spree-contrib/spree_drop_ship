FactoryBot.define do
  factory :order_for_drop_ship, parent: :order do
    bill_address
    ship_address

    transient do
      line_items_count 5
    end

    after(:create) do |order, evaluator|
      supplier = create(:supplier)
      product = create(:product)
      product.add_supplier! supplier
      # product.stock_items.where(variant_id: product.master.id).first.adjust_count_on_hand(10)

      product_2 = create(:product)
      product_2.add_supplier! create(:supplier)

      create_list(:line_item, evaluator.line_items_count,
        order:   order,
        variant: product_2.master)
      order.line_items.reload

      create(:shipment, order: order, stock_location: supplier.stock_locations.first)
      order.shipments.reload

      order.update_with_updater!
    end

    factory :completed_order_for_drop_ship_with_totals do
      state 'complete'

      after(:create) do |order|
        order.refresh_shipment_rates
        order.update_column(:completed_at, Time.now)
      end

      factory :order_ready_for_drop_ship do
        payment_state 'paid'
        shipment_state 'ready'

        after(:create) do |order|
          create(:payment, amount: order.total, order: order, state: 'completed')
          order.shipments.each do |shipment|
            shipment.inventory_units.each { |u| u.update_column('state', 'on_hand') }
            shipment.update_column('state', 'ready')
          end
          order.reload
        end

        factory :shipped_order_for_drop_ship do
          after(:create) do |order|
            order.shipments.each do |shipment|
              shipment.inventory_units.each { |u| u.update_column('state', 'shipped') }
              shipment.update_column('state', 'shipped')
            end
            order.reload
          end
        end
      end
    end
  end

  factory :supplier, class: Spree::Supplier do
    sequence(:name) { |i| "Big Store #{i}" }
    email { FFaker::Internet.email }
    url 'http://example.com'
    address
    # Creating a stock location with a factory instead of letting the model handle it
    # so that we can run tests with backorderable defaulting to true.
    before :create do |supplier|
      supplier.stock_locations << build(:stock_location, name: supplier.name, supplier: supplier)
    end

    factory :supplier_with_commission do
      commission_flat_rate 0.5
      commission_percentage 10
    end
  end

  factory :supplier_user, parent: :user do
    supplier
  end

  factory :variant_with_supplier, parent: :variant do
    after :create do |variant|
      variant.product.add_supplier! create(:supplier)
    end
  end
end
