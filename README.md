# Loan Review site

This site the reviews [payday loans](http://www.thepaydayhound.com/payday-loans/) and [installment loans](http://www.thepaydayhound.com/installment-loans/). It's aims to bring transparency to this market. Transparency will help borrows protect themselves through education and get better pricing through efficient markets. The site provided detailed reviews on short-term lenders. It provided direct links to direct lenders and an application to a matching service.

This site is my project to learn how to code.

The site is designed to run on one domain with a blog in a sub-directory. It is used Rails and Wordpress. The main websever is nginx which reverse proxys to Wordpress for the blog and to Rails for rankings and tools. nginx and Wordpress are hosted on EC2. Rails is hosted on Heroku. Wordpress uses a LAMP stack on EC2. Rails uses unicorn and postgresql.

Github stores the Rails code.

## General Structure

All styles, javascript, google tag manager, internal tracking are managed and coded once in Rails. Headers, navigation, and footer are also managed in Rails. All these components are called in from WordPress.

* __blogbars\_controller__ called by WP for sidebar sliders  
* __lenders\_controller__ called by WP for individual lender reviews  
* __homes\_controller__	has methods called by WP for styles, js, footer. It also has pixel tracking method that WP calls for internal tracking.

Visitors are tracked based on sessions and are saved once they click to a lender or enter the application. 


 
## Notable Updates

* 1/11/2014 DB clean up deleted pages, sources, lenders (and associated joins) tables; deleted unused fields
* 12/31/2013 pages and sources tables no longer in use. URI now used

## Database
Applicants tracking table gets downloaded when I need to upload new database. Haven't figured out how to append information into one table and or setup for production versus analysis DB.
*1/11/2014 downloaded applicants table. Heroku has clean start.
