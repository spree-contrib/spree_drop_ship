class Spree::DropShipOrderMailer < ActionMailer::Base

  default :from => Spree::MailMethod.current.try(:preferred_mails_from) || 'replace@test.com'

  def supplier_order(drop_ship_order)
    get_defaults(drop_ship_order)
    send_mail "#{Spree::Config[:site_name]} - Order ##{drop_ship_order.id}"
  end

  def confirmation(drop_ship_order)
    get_defaults(drop_ship_order)
    send_mail "Confirmation - #{Spree::Config[:site_name]} - Order ##{drop_ship_order.id}"
  end

  def shipment(drop_ship_order)
    get_defaults(drop_ship_order)
    send_mail "Shipped - #{Spree::Config[:site_name]} - Order ##{drop_ship_order.id}"
  end

  def shipment_notification(drop_ship_order)
    get_defaults(drop_ship_order)
    mail :to => @order.email, :subject => "Shipped - #{Spree::Config[:site_name]} - Order ##{drop_ship_order.id}"
  end

  private

    def get_defaults(drop_ship_order)
      @drop_ship_order = drop_ship_order
      @order = drop_ship_order.order
      @supplier = drop_ship_order.supplier
      @address = @order.ship_address
    end

    def send_mail(subject)
      mail :to => @supplier.email_with_name, :subject => subject
    end

end
