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
              # Select supplier providing at the lowest cost.
              supplier = content.variant.supplier_variants.order('spree_supplier_variants.cost ASC').first.supplier
              # Select first available stock location.
              stock_location = supplier.stock_locations.detect { |sl| sl.stock_items.find_by_variant_id(content.variant.id) }
              # Add to any existing packages or create a new one.
              if existing_package = split_packages.detect { |p| p.stock_location == stock_location }
                existing_package.contents << content
              else
                split_packages << Spree::Stock::Package.new(stock_location, [content])
              end
            end
          end
          return_next split_packages
        end

      end
    end
  end
end
