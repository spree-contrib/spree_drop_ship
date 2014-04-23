Spree::Order.class_eval do

  has_many :stock_locations, through: :shipments
  has_many :suppliers, through: :stock_locations

  # Once order is finalized we want to notify the suppliers of their drop ship orders.
  # Here we are handling notification by emailing the suppliers.
  # If you want to customize this you could override it as a hook for notifying a supplier with a API request instead.
  def finalize_with_drop_ship!
    finalize_without_drop_ship!
    shipments.each do |shipment|
      if SpreeDropShip::Config[:send_supplier_email] && shipment.supplier.present?
        begin
          Spree::DropShipOrderMailer.supplier_order(shipment.id).deliver!
        rescue => ex #Errno::ECONNREFUSED => ex
          puts ex.message
          puts ex.backtrace.join("\n")
          Rails.logger.error ex.message
          Rails.logger.error ex.backtrace.join("\n")
          return true # always return true so that failed email doesn't crash app.
        end
      end
    end
  end
  alias_method_chain :finalize!, :drop_ship

end
