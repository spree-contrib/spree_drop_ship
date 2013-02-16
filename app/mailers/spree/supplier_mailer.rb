class Spree::SupplierMailer < ActionMailer::Base

  default :from => Spree::MailMethod.current.try(:preferred_mails_from)

  def welcome(supplier)
    @supplier = supplier
    @user     = supplier.user
    mail :to => @supplier.email_with_name, :subject => "#{Spree::Config[:site_name]} - Welcome!"
  end

end
