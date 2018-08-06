if defined?(Ckeditor)
  Ckeditor::Asset.class_eval do
    belongs_to :supplier, class_name: 'Spree::Supplier', optional: true
  end
end
