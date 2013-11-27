require 'durable_decorator'
require 'spree_api'
require 'spree_backend'
require 'spree_core'
require 'spree_drop_ship/engine'
# Must go after Spree so ActiveRecord is already initialized.
require 'friendly_id'
