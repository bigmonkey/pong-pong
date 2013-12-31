Payday Loan Review Site

The main site is designed to run on one domain with sub-directorys but actually runs on Wordpress and Rails.

Main websever is nginx which reverse proxys to Wordpress for articles and to Heroku for rankings and tools. The rankings are done using Rails.

This is the Rails code.

Structure
blogbars_controller		called by WP for sidebar sliders
lenders_controller		called by WP for individual lender reviews
homes_controller			has methods called by WP for styles, js, footer
 
Updates
12/31/2013	pages and sources tables no longer in use. URI now used
