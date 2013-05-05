module Spree
  class SupplierMailer < Spree::BaseMailer

    default from: Spree::Config[:mails_from]

    def welcome(supplier)
      @supplier = supplier
      mail to: @supplier.email_with_name, subject: I18n.t('spree.supplier_mailer.welcome.subject')
    end

  end
end
