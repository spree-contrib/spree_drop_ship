Spree.user_class.class_eval do

  belongs_to :supplier

  has_many :variants, through: :supplier

  def supplier?
    supplier.present?
  end

end
