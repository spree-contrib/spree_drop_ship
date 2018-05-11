require 'spec_helper'

describe Spree::Shipment do

  describe 'Scopes' do

    it '#by_supplier' do
      supplier = create(:supplier)
      stock_location_1 = supplier.stock_locations.first
      stock_location_2 = create(:stock_location, supplier: supplier)
      shipment_1 = create(:shipment)
      shipment_2 = create(:shipment, stock_location: stock_location_1)
      shipment_3 = create(:shipment)
      shipment_4 = create(:shipment, stock_location: stock_location_2)
      shipment_5 = create(:shipment)
      shipment_6 = create(:shipment, stock_location: stock_location_1)

      expect(subject.class.by_supplier(supplier.id)).to match_array([shipment_2, shipment_4, shipment_6])
    end

  end

  describe '#after_ship' do
    before do
      allow_any_instance_of(Spree::ShipmentHandler).to receive(:send_shipped_email)
    end

    it 'should capture payment if balance due' do
      skip 'TODO make it so!'
    end

    it 'should track commission for shipment' do
      supplier = create(:supplier_with_commission)
      shipment = create(:shipment, stock_location: supplier.stock_locations.first)

      expect(shipment.supplier_commission.to_f).to eql(0.0)
      shipment.stub final_price_with_items: 10.0
      shipment.send(:after_ship)
      expect(shipment.reload.supplier_commission.to_f).to eql(1.5)
    end

  end

  it '#final_price_with_items' do
    shipment = build :shipment
    shipment.stub item_cost: 50.0, final_price: 5.5
    expect(shipment.final_price_with_items.to_f).to eql(55.5)
  end

end
