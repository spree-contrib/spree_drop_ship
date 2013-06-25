module Spree
  class SupplierMailer < Spree::BaseMailer

    default from: Spree::Config[:mails_from]

    def welcome(supplier)
      @supplier = supplier
      mail to: @supplier.email_with_name, subject: Spree.t('spree.supplier_mailer.welcome.subject')
    end

  end
end
