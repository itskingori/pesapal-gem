Changelog
=========

v0.2.2
------

* Automate release date to reduce chances of forgetting to update it

v0.2.1
------

* Fix screwed up rubygem date

v0.2.0
------

* Fix syntax error, and incorrect config hash name
* Add pesapal config file generator
* Move loading YAML config to initializer instead of each time the object is initialized

v0.1.0
------

* Add configuration with YAML file functionality, fall back to default, previous method still applies
* Move callback details to config hash (breaking change)

v0.0.3
------

* Fix screwed up the specifying of dependencies

v0.0.2
------

* Add dependencies htmlentities
* Update homepage url in rubygem
* Update to README

v0.0.1
------

Initial release, kind of a proof of concept ... by v1.0.0 we should have a
version ready for deployment in production environment and having all those
other features that should be there at bare minimum such IPN stuff and all. Also
by then, the demo (in rails) should have been complete.

* Transparently handles authentication on API calls
* Has method to generate post-order-url with ease i.e. that url that has the various payment options and whatnot
