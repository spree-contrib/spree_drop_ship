require 'spec_helper'

module Spree
  module Stock
    describe Packer do
      let!(:order) { create(:order_with_line_items, line_items_count: 5) }
      let(:stock_location) { create(:stock_location) }

      subject { Packer.new(stock_location, order) }

      context '#default_package' do

        context 'original behavior specs' do
          it 'contains all the items' do
            package = subject.default_package
            package.contents.size.should eq 5
          end

          it 'variants are added as backordered without enough on_hand' do
            stock_location.should_receive(:fill_status).exactly(5).times.and_return([2,3])

            package = subject.default_package
            package.on_hand.size.should eq 5
            package.backordered.size.should eq 5
          end

          context "location doesn't have order items in stock" do
            let(:stock_location) { create(:stock_location, propagate_all_variants: false) }
            let(:packer) { Packer.new(stock_location, order) }

            it "builds an empty package" do
              packer.default_package.contents.should be_empty
            end
          end

          context "doesn't track inventory levels" do
            let(:order) { Order.create }
            let!(:line_item) { order.contents.add(create(:variant), 30) }

            before { Config.track_inventory_levels = false }

            it "doesn't bother stock items status in stock location" do
              expect(subject.stock_location).not_to receive(:fill_status)
              subject.default_package
            end

            it "still creates package with proper quantity" do
              expect(subject.default_package.quantity).to eql 30
            end
          end
        end

        context 'custom behavior spec' do
          let(:order) { create(:order_for_drop_ship) }
          let(:stock_location) { create(:stock_location) }

          context "location doesn't belong to product supplier" do
            let(:packer) { Packer.new(stock_location, order) }

            it "builds an empty package" do
              packer.default_package.contents.should be_empty
            end
          end
        end
      end
    end
  end
end
