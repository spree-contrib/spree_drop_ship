require 'spec_helper'

describe Spree::StockLocation do

  it { should belong_to(:supplier) }

  subject { create(:stock_location_with_items, backorderable_default: true) }
  let(:stock_item) { subject.stock_items.order(:id).first }
  let(:variant) { stock_item.variant }

  # TODO fix stack level too deep error
  # context "propagate variants" do
  #   let(:stock_item) { subject.propagate_variant(variant) }
  # 
  #   it "creates a new stock item" do
  #     expect {
  #       subject.propagate_variant(variant)
  #     }.to change{ Spree::StockItem.count }.by(1)
  #   end
  # 
  #   context "passes backorderable default config" do
  #     context "true" do
  #       before { subject.backorderable_default = true }
  #       it { stock_item.backorderable.should be_true }
  #     end
  #   
  #     context "false" do
  #       before { subject.backorderable_default = false }
  #       it { stock_item.backorderable.should be_false }
  #     end
  #   end
  # 
  #   context 'sets to false for non supplier variants' do
  #     before { subject.supplier_id = create(:supplier).id }
  #     it { stock_item.backorderable.should be_false }
  #   end
  # 
  # end

end
