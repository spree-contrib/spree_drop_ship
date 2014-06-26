require 'spec_helper'

describe Spree::StockLocation do

  it { should belong_to(:supplier) }

  subject { create(:stock_location, backorderable_default: true) }

  context "propagate variants" do

    let(:variant) { build(:variant) }
    let(:stock_item) { subject.propagate_variant(variant) }

    context "passes backorderable default config" do
      context "true" do
        before { subject.backorderable_default = true }
        it { stock_item.backorderable.should be true }
      end

      context "false" do
        before { subject.backorderable_default = false }
        it { stock_item.backorderable.should be false }
      end
    end

    context 'does not propagate for non supplier variants' do
      before { subject.supplier_id = create(:supplier).id }
      it { stock_item.should be_nil }
    end

  end

end
