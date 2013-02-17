namespace :db do
  namespace :sample do
    desc "Create sample suppliers and randomly link to products"
    task :suppliers => :environment do

      @usa = Spree::Country.find_by_iso("US")
      @ca  = @usa.states.find_by_abbr("CA") 

      count = Spree::Supplier.count
      puts "Creating Suppliers..."
      5.times{|i|
        name = "Supplier #{count + i + 1}"
        supplier = Spree::Supplier.new(:name => name, :email => "#{name.parameterize}@example.com", :phone => "800-555-5555", :url => "http://example.com")
        supplier.build_address(:firstname => name, :lastname => name, :address1 => "100 State St", :city => "Santa Barbara", :phone => "555-555-5555", :zipcode => "93101", :state_id => @ca.id, :country_id => @usa.id)
        print "*" if supplier.save
      }
      puts
      puts "#{Spree::Supplier.count - count} suppliers created"

      puts "Randomly linking Products & Suppliers..."

      @supplier_ids = Spree::Supplier.select('id').all.map(&:id).shuffle
      @products     = Spree::Product.all
      count         = 0

      @products.each do |product|
        product.supplier_id = @supplier_ids[rand(@supplier_ids.length)]
        product.save
        count += 1 
        print "*"
      end

      puts
      puts "#{count} products linked."

    end
  end
end
