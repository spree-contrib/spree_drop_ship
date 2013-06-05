module Spree
  class SupplierBankAccount < ActiveRecord::Base

    attr_accessor :account_number, :amount_1, :amount_2, :name, :routing_number, :type
    attr_accessible :account_number, :amount_1, :amount_2, :name, :routing_number, :type

    belongs_to :supplier

    validates :account_number, presence: { on: :create }
    validates :masked_number,  presence: true
    validates :name,           presence: { on: :create }
    validates :routing_number, presence: { on: :create }
    validates :supplier,       presence: true
    validates :token,          presence: true, uniqueness: true
    validates :type,           presence: { on: :create }

    before_save :attempt_verification, on: :update
    before_validation :balanced_api_call, on: :create

    def verification_status
      verified ? I18n.t(:verified) : I18n.t(:unverified)
    end

    private

    def attempt_verification
      return if self.amount_1.blank? or self.amount_2.blank?
      Balanced.configure(SpreeDropShip::Config[:balanced_api_key])
      bank_account = Balanced::BankAccount.find(self.token)
      verification = Balanced::Verification.find(self.verification_token)
      verification.amount_1 = self.amount_1
      verification.amount_2 = self.amount_2
      verification.save
      self.verified = true if verification.state == 'verified'
    end

    def balanced_api_call
      return if self.account_number.blank? or self.name.blank? or self.routing_number.blank? or self.type.blank?
      Balanced.configure(SpreeDropShip::Config[:balanced_api_key])
      merchant_account = Balanced::Account.find(self.supplier.token)
      bank_account = Balanced::BankAccount.new(
        :routing_number => self.routing_number,
        :type           => self.type,
        :name           => self.name,
        :account_number => self.account_number
      ).save
      merchant_account.add_bank_account(bank_account.uri)
      self.masked_number      = bank_account.account_number
      self.token              = bank_account.uri
      verification            = bank_account.verify
      self.verification_token = verification.uri
    end

  end
end
