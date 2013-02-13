Spree.user_class.class_eval do

  has_one :supplier, :foreign_key => :user_id

  # TODO: add to spree_auth_devise
  def admin?
    self.spree_roles.pluck(:name).include?('admin')
  end

  def has_supplier?
    self.supplier.present?
  end

end
