module Spree
  class DropShipOrderMailer < Spree::BaseMailer

    default from: Spree::Config[:mails_from]

    def supplier_order(drop_ship_order_id)
      @drop_ship_order = DropShipOrder.find drop_ship_order_id
      @order = @drop_ship_order.order
      @supplier = @drop_ship_order.supplier
      mail to: @supplier.email_with_name, subject: Spree.t('spree.drop_ship_order_mailer.supplier_order.subject', name: Spree::Config[:site_name], number: @drop_ship_order.id)
    end

  end
end
