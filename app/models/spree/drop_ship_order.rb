class Spree::DropShipOrder < ActiveRecord::Base

  attr_accessible :notes

  #==========================================
  # Associations

  belongs_to :order
  belongs_to :supplier

  has_many :drop_ship_line_items, dependent: :destroy
  has_many :line_items, through: :drop_ship_line_items
  has_many :return_authorizations, through: :order
  has_many :stock_locations, through: :supplier
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
    after_transition :on => :complete, :do => :perform_complete

    event :deliver do
      transition [ :active, :delivered ] => :delivered
    end

    event :confirm do
      transition [ :active, :delivered ] => :confirmed
    end

    event :complete do
      transition [ :active, :delivered, :confirmed ] => :completed
    end

  end

  #==========================================
  # Instance Methods

  delegate :adjustments, to: :order
  delegate :checkout_steps, to: :order
  delegate :currency, to: :order

  # Don't allow drop ship orders to be destroyed
  def destroy
    false
  end

  def display_item_total
    Spree::Money.new(self.item_total, { currency: currency })
  end

  def display_ship_total
    Spree::Money.new self.ship_total, currency: currency
  end

  def display_total
    Spree::Money.new(self.total, { currency: currency })
  end

  delegate :find_line_item_by_variant, to: :order

  def item_total
    line_items.map(&:amount).sum
  end

  alias_method :number, :id

  delegate :payment_state, to: :order

  delegate :payments, to: :order

  def promo_total
    adjustments.eligible.promotion.sum(:amount)
  end

  delegate :ship_address, to: :order

  def ship_total
    adjustments.shipping.where('source_id in (?)', shipments.map(&:id)).sum(:amount)
  end

  def shipment_state
    shipment_count = shipments.size
    return 'pending' if shipment_count == 0 or shipment_count == shipments.pending.size
    return 'ready'   if shipment_count == shipments.ready.size
    return 'shipped' if shipment_count == shipments.shipped.size
    return 'partial'
  end

  def shipments
    order.shipments.includes(:stock_location).where('spree_stock_locations.supplier_id = ?', self.supplier_id)
  end

  def tax_total
    adjustments.tax.sum(:amount)
  end

  #==========================================
  # Private Methods

  private

    def perform_complete # :nodoc:
      self.update_attribute(:completed_at, Time.now)
    end

    def perform_confirmation # :nodoc:
      self.update_attribute(:confirmed_at, Time.now)
    end

    def perform_delivery # :nodoc:
      self.update_attribute(:sent_at, Time.now)
      Spree::DropShipOrderMailer.supplier_order(self.id).deliver! if SpreeDropShip::Config[:send_supplier_email]
    end

    def update_commission
      self.commission = (self.total * self.supplier.commission_percentage / 100) + self.supplier.commission_flat_rate
    end

    # Updates the drop ship order's total by getting the shipment totals.
    def update_total
      self.total = self.shipments.map(&:total_cost).sum
    end

end
