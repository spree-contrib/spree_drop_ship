module Spree
  class DropShipOrderMailer < Spree::BaseMailer

    default from: Spree::Store.current.mail_from_address

    def supplier_order(shipment_id)
      @shipment = Shipment.find shipment_id
      @supplier = @shipment.supplier
      puts Spree::Store.current.inspect
      puts Spree::Store.current.mail_from_address
      m = mail to: @supplier.email, subject: Spree.t('drop_ship_order_mailer.supplier_order.subject', name: Spree::Store.current.site_name, number: @shipment.number)
      puts m.inspect
      m
    end

  end
end
