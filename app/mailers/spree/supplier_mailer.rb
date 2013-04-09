class Spree::SupplierMailer < ActionMailer::Base

  default :from => Spree::MailMethod.current.try(:preferred_mails_from) || 'replace@example.com'

  def welcome(supplier)
  	if Spree::DropShipConfig[:send_supplier_email]
	    @supplier = supplier
	    mail :to => @supplier.email_with_name, :subject => I18n.t('spree.supplier_mailer.welcome.subject')
	end
  end

end
