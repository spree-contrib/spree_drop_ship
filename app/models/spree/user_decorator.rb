Spree.user_class.class_eval do

  belongs_to :supplier

  # TODO: add to spree_auth_devise
  def admin?
    self.spree_roles.pluck(:name).include?('admin')
  end

  def supplier?
    self.supplier.present?
  end

end
