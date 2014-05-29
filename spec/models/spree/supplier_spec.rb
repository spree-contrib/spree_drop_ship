require 'spec_helper'

describe Spree::Supplier do

  it { should belong_to(:address) }

  it { should have_many(:products).through(:variants) }
  it { should have_many(:stock_locations) }
  it { should have_many(:users) }
  it { should have_many(:variants).through(:supplier_variants) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }

  it '#deleted?' do
    subject.deleted_at = nil
    subject.deleted_at?.should eql(false)
    subject.deleted_at = Time.now
    subject.deleted_at?.should eql(true)
  end

  context '#assign_user' do

    before do
      @instance = build(:supplier)
    end

    it 'with user' do
      Spree.user_class.should_not_receive :find_by_email
      @instance.email = 'test@test.com'
      @instance.users << create(:user)
      @instance.save
    end

    it 'with existing user email' do
      user = create(:user, email: 'test@test.com')
      Spree.user_class.should_receive(:find_by_email).with(user.email).and_return(user)
      @instance.email = user.email
      @instance.save
      @instance.reload.users.first.should eql(user)
    end

  end

  it '#create_stock_location' do
    Spree::StockLocation.count.should eql(0)
    supplier = create :supplier
    Spree::StockLocation.first.active.should be true
    Spree::StockLocation.first.country.should eql(supplier.address.country)
    Spree::StockLocation.first.supplier.should eql(supplier)
  end

  context '#send_welcome' do

    after do
      SpreeDropShip::Config[:send_supplier_email] = true
    end

    before do
      @instance = build(:supplier)
      @mail_message = double('Mail::Message')
    end

    context 'with Spree::DropShipConfig[:send_supplier_email] == false' do

      it 'should not send' do
        SpreeDropShip::Config[:send_supplier_email] = false
        expect {
          Spree::SupplierMailer.should_not_receive(:welcome).with(an_instance_of(Integer))
        }
        @instance.save
      end

    end

    context 'with Spree::DropShipConfig[:send_supplier_email] == true' do

      it 'should send welcome email' do
        expect {
          Spree::SupplierMailer.should_receive(:welcome).with(an_instance_of(Integer))
        }
        @instance.save
      end

    end

  end

  it '#set_commission' do
    SpreeDropShip::Config.set default_commission_flat_rate: 1
    SpreeDropShip::Config.set default_commission_percentage: 1
    supplier = create :supplier
    SpreeDropShip::Config.set default_commission_flat_rate: 0
    SpreeDropShip::Config.set default_commission_percentage: 0
    # Default configuration is 0.0 for each.
    supplier.commission_flat_rate.to_f.should eql(1.0)
    supplier.commission_percentage.to_f.should eql(1.0)
    # With custom commission applied.
    supplier = create :supplier, commission_flat_rate: 123, commission_percentage: 25
    supplier.commission_flat_rate.should eql(123.0)
    supplier.commission_percentage.should eql(25.0)
  end

  describe '#shipments' do

    let!(:supplier) { create(:supplier) }

    it 'should return shipments for suppliers stock locations' do
      stock_location_1 = supplier.stock_locations.first
      stock_location_2 = create(:stock_location, supplier: supplier)
      shipment_1 = create(:shipment)
      shipment_2 = create(:shipment, stock_location: stock_location_1)
      shipment_3 = create(:shipment)
      shipment_4 = create(:shipment, stock_location: stock_location_2)
      shipment_5 = create(:shipment)
      shipment_6 = create(:shipment, stock_location: stock_location_1)

      expect(supplier.shipments).to match_array([shipment_2, shipment_4, shipment_6])
    end

  end

end
