class Spree::SupplierMailer < ActionMailer::Base

  default :from => Spree::MailMethod.current.try(:preferred_mails_from) || 'replace@test.com'

  def welcome(supplier)
    @supplier = supplier
    mail :to => @supplier.email_with_name, :subject => I18n.t('spree_drop_ship.supplier_mailer.welcome.subject')
  end

end
