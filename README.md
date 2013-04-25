SpreeDropShip [![Build Status](https://secure.travis-ci.org/jdutil/spree_drop_ship.png)](http://travis-ci.org/jdutil/spree_drop_ship) [![Dependency Status](https://gemnasium.com/jdutil/spree_drop_ship.png?travis)](https://gemnasium.com/jdutil/spree_drop_ship)
=============

[travis]: http://travis-ci.org/jdutil/spree_drop_ship
[gemnasium]: https://gemnasium.com/jdutil/spree_drop_ship

What is drop shipping?

"Drop shipping is a supply chain management technique in which the retailer does not keep goods in stock, but instead transfers customer orders and shipment details to either the manufacturer or a wholesaler, who then ships the goods directly to the customer." [[wikipedia](http://en.wikipedia.org/wiki/Drop_shipping)]

So the main goal with spree_drop_ship is to link products to suppliers and forward orders to the appropriate suppliers.

Once an order is placed for a product that belongs to a supplier a drop ship order is created for the product's supplier. This drop ship order is then sent to the supplier (via Email by default). The supplier then follows a link to the order within the email where they are prompted to confirm the order.

After the supplier has confirmed an order and is ready to ship, they can log into the site and update the drop ship order shipping method, and tracking number. Once they 'ship' the order the customer will receive their shipment notification, and the drop ship order will transition to a completed state.

Drop Ship Order's make use of the State Machine similarly to the usual Order, Payment, and Shipment models within Spree.
The following are the drop ship order states and what they represent:

*Active:* Is the initial drop ship order state indicating that it has been created.
*Delivered:* Represents that the drop ship order's supplier has been notified of the order i.e. supplier's notification has been delivered.  By default email notifications will be sent automatically, but you may want to customize things to use an API instead.
*Confirmed:* Represents that the supplier has confirmed receiving the drop ship order notification & information.
*Complete:* Represents that the drop ship order has been shipped, and the supplier's work is complete.

Spree Drop Ship will also integrate with [Balanced Payments](https://www.balancedpayments.com/) in order to handle charging commission
w/Escrow accounts for sales, as well as, handling payments to your suppliers via ACH direct deposits.  This is still currently a work in progress, and any input is welcome.  This may likely be refactored into it's own extension if other viable alternatives to Balanced Payments are desired.

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

If you'd like to generate sample data, use the included rake tasks:

```shell
rake spree_sample:load            # Loads sample data into the store
rake db:sample:suppliers          # Create sample suppliers and randomly link to products
rake db:sample:drop_ship_orders   # Create sample drop ship orders
```

Demo
----

You can easily use the spec/dummy app as a demo of spree_drop_ship. Just `cd` to where you develop and run:

```shell
git clone git://github.com/jdutil/spree_drop_ship.git
cd spree_drop_ship
bundle install
bundle exec rake test_app
cd spec/dummy
rake db:migrate db:seed spree_sample:load db:sample:suppliers db:sample:drop_ship_orders
rails s
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

Todo
----

- Return authorization ui
- Finish I18n implementation (mailer views, and anywhere else plain text is found)
- Integrate SupplierAbility w/Spree::API (actually making spree api respect cancan in missing places particular read actions)
- Better documentation
- Add new languages

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
* by writing code (*no patch is too small*: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues](https://github.com/jdutil/spree_drop_ship/issues)
* by reviewing patches

Donating
--------

Bitcoin donations may be sent to: 1L6akT6Aus9r6Ashw1wDtLg7D8zJCVVZac

Copyright (c) 2012-2013 Jeff Dutil, released under the [New BSD License](https://github.com/jdutil/spree_drop_ship/tree/master/LICENSE).
