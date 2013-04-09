class Spree::DropShipOrder < ActiveRecord::Base

  attr_accessible :notes

  #==========================================
  # Associations

  belongs_to :order
  belongs_to :supplier

  has_many :drop_ship_line_items, dependent: :destroy
  has_many :line_items, through: :drop_ship_line_items
  has_many :users, class_name: Spree.user_class.to_s, through: :supplier

  has_one :user, through: :order

  #==========================================
  # Validations

  validates :commission, presence: true
  validates :order_id, presence: true
  validates :supplier_id, presence: true

  #==========================================
  # Callbacks

  before_save :update_total
  before_save :update_commission # Must go after update_total so that proper total amount is available to calculate commission.

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
    new_line_items = Array.wrap(new_line_items).reject{ |li| li.product.supplier_id.nil? || li.product.supplier_id != self.supplier_id }
    new_line_items.each do |new_line_item|
      if line_item = self.drop_ship_line_items.find_by_line_item_id(new_line_item.id)
      else
        self.drop_ship_line_items.create({line_item_id: new_line_item.id}, without_protection: true)
      end
    end
    # TODO: remove any old line items?
    self.save ? self : nil
  end

  # Don't allow drop ship orders to be destroyed
  def destroy
    false
  end

  alias_method :number, :id

  def shipments
    order.shipments.joins(:stock_location).where('spree_stock_locations.supplier_id = ?', self.supplier_id)
  end

  #==========================================
  # Private Methods

  private

    def perform_confirmation # :nodoc:
      self.update_attribute(:confirmed_at, Time.now)
    end

    def perform_delivery # :nodoc:
      self.update_attribute(:sent_at, Time.now)
      Spree::DropShipOrderMailer.supplier_order(self).deliver!
    end

    def perform_shipment # :nodoc:
      self.update_attribute(:shipped_at, Time.now)
    end

    def update_commission
      self.commission = (self.total * self.supplier.commission_percentage / 100) + self.supplier.commission_flat_rate
    end

    # Updates the drop ship order's total by getting the sum of its line items' subtotals
    def update_total
      self.total = self.line_items.reload.map(&:total).inject(:+).to_f
    end

end
