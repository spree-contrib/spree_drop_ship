SpreeDropShip [![Build Status](https://secure.travis-ci.org/jdutil/spree_drop_ship.png)](http://travis-ci.org/jdutil/spree_drop_ship) [![Dependency Status](https://gemnasium.com/jdutil/spree_drop_ship.png?travis)](https://gemnasium.com/jdutil/spree_drop_ship)
=============

[travis]: http://travis-ci.org/jdutil/spree_contact_us
[gemnasium]: https://gemnasium.com/jdutil/spree_contact_us

What is drop shipping?

"Drop shipping is a supply chain management technique in which the retailer does not keep goods in stock, but instead transfers customer orders and shipment details to either the manufacturer or a wholesaler, who then ships the goods directly to the customer." [[wikipedia](http://en.wikipedia.org/wiki/Drop_shipping)]

So the main goal with spree_drop_ship is to link products to suppliers and forward orders to appropriate suppliers.

In more detail, once an order is placed for a product that drop ships a drop ship order is created for the product's supplier. This drop ship order is sent to the supplier via Email. The supplier then follows a link to the order within the email where they are prompted to confirm the order.

After the supplier has confirmed an order and is ready to ship, they can log into the site and update the drop ship order with a shipping method, confirmation number and tracking number. Once they 'process & finalize' the order, the customer is notified with the shipment details.

Installation
------------

Here's how to install spree_drop_ship into your existing spree site:

Add the following to your Gemfile:

    gem 'spree_drop_ship', github: 'jdutil/spree_drop_ship'

Make your bundle happy:

    bundle install

Now run the generator:

    rails g spree_drop_ship:install

Then migrate your database if you did not run during installation generator:

    bundle exec rake db:migrate

And reboot your server:

    rails s

You should be up and running now!

Sample Data
-----------

If you'd like to generate sample data, use the included rake tasks

    rake db:sample                    # Loads sample data into the store
    rake db:sample:suppliers          # Create sample suppliers and randomly link to products
    rake db:sample:drop_ship_orders   # Create sample drop ship orders

Demo
----

You can easily use the spec/dummy app as a demo of spree_drop_ship. Just `cd` to where you develop and run:

    git clone git://github.com/jdutil/spree_drop_ship.git
    cd spree_drop_ship
    bundle install
    bundle exec rake test_app
    cd spec/dummy
    rake db:migrate db:seed db:sample
    rails s

Contributing
------------

In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using prerelease versions
* by reporting [bugs](https://github.com/jdutil/spree_drop_ship/issues)
* by suggesting new features
* by [translating to a new language](https://github.com/jdutil/spree_drop_ship/tree/master/config/locales)
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues](https://github.com/jdutil/spree_drop_ship/issues)
* by reviewing patches

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Todo
----

- Finish I18n implementation (mailer views, and anywhere else plain text is found)
- Admin state/country selects should use Spree code (double check they may be now)
- Mailers default from should use spree apps settings
- Finish/Style Email templates
- Finish styling views for admin redesign
- Drop ship order styles
- Make supplier address form DRY with spree core (requires patching spree_core)
- Better documentation
- Add new languages
- Support Spree 2.x frontend and SpreeFancy themes.

Thanks
------

This extension is based on past work by [Spencer Steffen](http://github.com/citrus/spree_drop_shipping).

Copyright (c) 2012 Jeff Dutil, released under the [New BSD License](https://github.com/jdutil/spree_drop_ship/tree/master/LICENSE).
