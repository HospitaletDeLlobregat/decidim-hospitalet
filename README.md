# Decidim Hospitalet
## How to contribute

In order to develop on Decidim Hospitalet, you'll need:

* **PostgreSQL** 9.4+
* **Ruby** 2.4.0

The easiest way to work on decidim is to clone this repository and install its dependencies:

```bash
$ git clone git@github.com:HospitaletDeLlobregat/decidim-hospitalet.git
$ cd decidim-hospitalet
$ bundle install
$ rake db:setup
```

You should now be able to access Decidim Hospitalet at `http://localhost:3000`.
