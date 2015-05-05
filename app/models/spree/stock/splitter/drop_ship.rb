module Spree
  module Stock
    module Splitter
      class DropShip < Spree::Stock::Splitter::Base

        def split(packages)
          split_packages = []
          packages.each do |package|
            # Package fulfilled items together.
            fulfilled = package.contents.select { |content| content.variant.suppliers.count == 0 }
            split_packages << build_package(fulfilled)
            # Determine which supplier to package drop shipped items.
            drop_ship = package.contents.select { |content| content.variant.suppliers.count > 0 }
            drop_ship.each do |content|
              # Select the related variant
              variant = content.variant
              # Select suppliers ordering ascending according to cost.
              suppliers = variant.supplier_variants.order('spree_supplier_variants.cost ASC').map(&:supplier)
              # Select first supplier that has stock location with avialable stock item.
              available_supplier = suppliers.detect { |supplier| supplier.stock_locations_with_available_stock_items(variant).any? }
              # Select the first available stock location with in the available_supplier stock locations.
              stock_location = available_supplier.stock_locations_with_available_stock_items(variant).first
              # Add to any existing packages or create a new one.
              if existing_package = split_packages.detect { |p| p.stock_location == stock_location }
                existing_package.contents << content
              else
                split_packages << Spree::Stock::Package.new(stock_location, order, [content])
              end
            end
          end
          return_next split_packages
        end

      end
    end
  end
end
