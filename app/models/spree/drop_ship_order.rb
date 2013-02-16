class Spree::DropShipOrder < ActiveRecord::Base

  attr_accessible :confirmation_number, :notes, :shipping_method, :tracking_number

  #==========================================
  # Associations

  belongs_to :order
  belongs_to :supplier

  has_many   :line_items, :class_name => "Spree::DropShipLineItem"

  has_one    :user, :through => :supplier

  #==========================================
  # Validations

  validates :commission_fee, presence: true
  validates :supplier_id, :order_id, :presence => true

  #==========================================
  # Callbacks
  
  before_save :update_total

  #==========================================
  # State Machine

  state_machine :initial => :active do

    after_transition :on => :deliver, :do => :perform_delivery
    after_transition :on => :confirm, :do => :perform_confirmation
    after_transition :on => :ship,    :do => :perform_shipment

    event :deliver do
      transition [ :active, :sent ] => :sent
    end

    event :confirm do
      transition :sent => :confirmed
    end

    event :ship do
      transition :confirmed => :complete
    end 

    state :complete do
      validates :shipping_method, :tracking_number, :presence => true 
    end

  end

  #==========================================
  # Instance Methods

  # Adds line items to the drop ship order. This method will group similar line items
  # and update quantities as necessary. You can add a single line item or an array of
  # line items.
  # TODO: This is overly complex and need to refactor
  #       start of refactoring makes me think this should be update_line_items rather than add for clarity
  def add(new_line_items)
    new_line_items = Array.wrap(new_line_items).reject{ |li| li.supplier_id.nil? || li.supplier_id != self.supplier_id }
    new_line_items.each do |new_line_item|
      if line_item = self.line_items.find_by_line_item_id(new_line_item.id)
        line_item.update_attributes(:quantity => new_line_item.quantity)
      else
        self.line_items.create(new_line_item.drop_ship_attributes, without_protection: true)
      end
    end
    # TODO: remove any old line items?
    self.save ? self : nil
  end

  # Don't allow drop ship orders to be destroyed
  def destroy
    false
  end

  # Updates the drop ship order's total by getting the sum of its line items' subtotals
  def update_total
    self.total = self.line_items.reload.map(&:subtotal).inject(:+).to_f
  end

  #==========================================
  # Private Methods

  private

    def perform_confirmation # :nodoc:
      self.update_attribute(:confirmed_at, Time.now)
      Spree::DropShipOrderMailer.confirmation(self).deliver!
    end

    def perform_delivery # :nodoc:
      self.update_attribute(:sent_at, Time.now)
      Spree::DropShipOrderMailer.supplier_order(self).deliver!
    end

    def perform_shipment # :nodoc:
      self.update_attribute(:shipped_at, Time.now)
      Spree::DropShipOrderMailer.shipment(self).deliver!
      Spree::DropShipOrderMailer.shipment_notification(self).deliver!
    end

end
