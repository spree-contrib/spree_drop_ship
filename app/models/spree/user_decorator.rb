Spree.user_class.class_eval do

  belongs_to :supplier

  # TODO Add to SpreeAuthDevise or SpreeCore?
  def admin?
    has_spree_role?('admin')
  end

  def supplier?
    supplier.present?
  end

end
