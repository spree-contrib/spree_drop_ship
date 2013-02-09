Spree.user_class.class_eval do

  has_one :supplier, :foreign_key => :user_id

  def has_supplier?
    supplier.present?
  end

end
