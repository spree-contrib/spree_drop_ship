namespace :db do
  namespace :sample do
    desc "Create sample drop ship orders"
    task :drop_ship_orders => :environment do

      if Spree::Order.count == 0
        puts "Please run `rake spree_sample:load` first to create products and orders" 
        exit
      end

      if Spree::Supplier.count == 0
        puts "Please run `rake db:sample:suppliers` first to create suppliers" 
        exit
      end

      count      = 0
      @orders    = Spree::Order.complete.includes(:line_items).all
      @suppliers = Spree::Supplier.all

      puts "Linking existing line items to suppliers"
      Spree::LineItem.where("supplier_id IS NULL").all.each do |li|
        print "*" if li.supplier_id = @suppliers.shuffle.first.id and li.save
      end
      puts

      puts "Creating drop ship orders for existing orders"
      Spree::Order.all.each do |order|
        print "*" if order.finalize!
      end
      puts

    end
  end
end
