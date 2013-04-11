Spree.user_class.class_eval do

  belongs_to :supplier

  has_many :products, through: :supplier
  has_many :variants, through: :products

  def supplier?
    supplier.present?
  end

end
