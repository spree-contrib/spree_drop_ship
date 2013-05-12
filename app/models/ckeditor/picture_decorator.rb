if defined?(Ckeditor::Picture)
  Ckeditor::Picture.class_eval do
    belongs_to :supplier, class_name: 'Spree::Supplier'
  end
end
