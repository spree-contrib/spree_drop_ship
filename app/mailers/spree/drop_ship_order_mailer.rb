class Spree::DropShipOrderMailer < ActionMailer::Base

  default :from => 'no-reply@example.com'

  def supplier_order(dso)
    get_defaults(dso)
    send_mail "#{Spree::Config[:site_name]} - Order ##{dso.id}"
  end

  def confirmation(dso)
    get_defaults(dso)
    send_mail "Confirmation - #{Spree::Config[:site_name]} - Order ##{dso.id}"
  end

  def shipment(dso)
    get_defaults(dso)
    send_mail "Shipped - #{Spree::Config[:site_name]} - Order ##{dso.id}"
  end

  def shipment_notification(dso)
    get_defaults(dso)
    mail :to => @order.email, :subject => "Shipped - #{Spree::Config[:site_name]} - Order ##{dso.id}"
  end

  private

    def get_defaults(dso)
      @dso = dso
      @order = dso.order
      @supplier = dso.supplier
      @address = @order.ship_address
    end

    def send_mail(subject)
      mail :to => @supplier.email_with_name, :subject => subject
    end

end
