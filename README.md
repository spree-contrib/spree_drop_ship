# Spree Drop Ship

[![Build Status](https://travis-ci.org/JDutil/spree_drop_ship.png)](https://travis-ci.org/JDutil/spree_drop_ship)
[![Code Climate](https://codeclimate.com/github/jdutil/spree_drop_ship.png)](https://codeclimate.com/github/jdutil/spree_drop_ship)
[![Coverage Status](https://coveralls.io/repos/jdutil/spree_drop_ship/badge.png?branch=master)](https://coveralls.io/r/jdutil/spree_drop_ship)
[![Dependency Status](https://gemnasium.com/jdutil/spree_drop_ship.png?travis)](https://gemnasium.com/jdutil/spree_drop_ship)

What is drop shipping?

"Drop shipping is a supply chain management technique in which the retailer does not keep goods in stock, but instead transfers customer orders
and shipment details to either the manufacturer or a wholesaler, who then ships the goods directly to the customer." - [wikipedia](http://en.wikipedia.org/wiki/Drop_shipping)

So the main goal with spree_drop_ship is to link products to suppliers and forward orders to the appropriate suppliers.

Once an order is placed for a product that belongs to a supplier a shipment is created for the product's supplier.
This shipment is then sent to the supplier (via Email by default). The supplier then follows a link to the shipment
within the email where they are prompted to confirm the shipment.

Spree Drop Ship used with [Spree Marketplace](https://github.com/jdutil/spree_marketplace) allows handling payments to your suppliers via ACH direct deposits.  
This is still currently a work in progress, and any input is welcome.
.

Upgrading
---------

**Warning: Upgrading to Spree 2.2.x when using this extension is not backwards compatible.
            I have removed the notion of drop ship orders which payments & commission were previously tracked to.
            Now suppliers simply manage their shipments, and payments & commission are now linked to a payable object i.e. shipment in this case.
            This means the previous method of determining a suppliers commission is no longer valid, and you will need to migrate your data accordingly.**

I'm sorry for the inconvenience this may cause, but I've determined for this extension to meet it's most potential I needed to drastically alter the approach
it was taking.  I'm still undergoing several more radical changes for Spree 2.3.x that involve moving product management from this extension into the spree_marketplace
extension.  The goal from the beginning of this extension has been for it to be a very light weight and extensible drop shipping solution.  Much of this extension
has been made obsolete by split shipping, and line item adjustments within Spree Core itself.  Now I feel I can really streamline this extension to take advantage
of the recent Spree Core changes, and also move the product management into the marketplace extension as that is really more of what product management is inteded for.
The typical drop shipping scenario would simply be a supplier being able to update their shipments they need to fulfill and nothing more.

Installation
------------

Here's how to install spree_drop_ship into your existing spree site AFTER you've installed Spree:

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
rake spree_sample:load               # Loads sample data into the store
rake spree_sample:suppliers          # Create sample suppliers and randomly link to products
rake spree_sample:drop_ship_orders   # Create sample drop ship orders
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
rake db:migrate db:seed spree_sample:load spree_sample:suppliers spree_sample:drop_ship_orders
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

- suppliers should be able to manage option types and values (unsure about whether to scope to supplier or not, but thats probably best solution for everyone)
- Stock Items should automatically be set to backorderable false if the variant doesnt belong to the stock locations supplier.
- Must allow suppliers to edit their stock location addresses & require it.
- Return Authorization UI
- Better documentation
- Determine how best to handle single product having multiple suppliers.  Needs to move supplier association to variant level.
- related products should only allow suppliers own products to be related
- depending on how we handle suppliers selling the same product we should consider not creating stock items at all for variants / stock locations supplier doesnt own.  that way we would no longer need the packer_decorator.  This would require we go the route of creating a variant for each different supplier. (supplier as option type?)

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

Copyright (c) 2012-2014 Jeff Dutil, released under the [New BSD License](https://github.com/jdutil/spree_drop_ship/tree/master/LICENSE).
