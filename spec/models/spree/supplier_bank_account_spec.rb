require 'spec_helper'

describe Spree::SupplierBankAccount do

  it { should belong_to(:supplier) }

  it { should validate_presence_of(:masked_number) }
  it { should validate_presence_of(:supplier) }
  it { should validate_presence_of(:token) }
  it { should validate_uniqueness_of(:token) }

  it 'should set masked number & tokens before create' do
    supplier = create(:supplier)
    account = supplier.bank_accounts.build(name: 'John Doe', account_number: '9900000001', routing_number: '121000358', type: 'Checking')
    account.masked_number.should be_nil
    account.token.should be_nil
    account.verification_token.should be_nil
    account.save
    account.token.should be_present
    account.masked_number.should eql('xxxxxx0001')
    account.verification_token.should be_present
  end

  it 'should send verification when amounts are set' do
    supplier = create(:supplier)
    account = supplier.bank_accounts.build(name: 'John Doe', account_number: '9900000001', routing_number: '121000358', type: 'Checking')
    account.save
    account.verified.should be_false
    account.amount_1 = 1
    account.amount_2 = 1
    account.save
    account.verified.should be_true
  end

  it '#verification_status' do
    subject.verification_status.should eql('Unverified')
    subject.verified = true
    subject.verification_status.should eql('Verified')
  end

end
