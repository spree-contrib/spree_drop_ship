class Spree::DropShipOrderMailer < ActionMailer::Base

  default :from => Spree::MailMethod.current.try(:preferred_mails_from) || 'replace@example.com'

  def supplier_order(drop_ship_order)
    @drop_ship_order = drop_ship_order
    @order = drop_ship_order.order
    @supplier = drop_ship_order.supplier
    mail :to => @supplier.email_with_name, :subject => I18n.t('spree.drop_ship_order_mailer.supplier_order.subject', name: Spree::Config[:site_name], number: drop_ship_order.id)
  end

end
