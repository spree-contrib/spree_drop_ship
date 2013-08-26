module Spree
  class SupplierMailer < Spree::BaseMailer

    default from: Spree::Config[:mails_from]

    def welcome(supplier_id)
      @supplier = Supplier.find supplier_id
      mail to: @supplier.email_with_name, subject: Spree.t('supplier_mailer.welcome.subject')
    end

  end
end
