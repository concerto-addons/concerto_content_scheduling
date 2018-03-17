Concerto Content Scheduling
===========================
Concerto allows you to schedule content to appear from a start date through an end date.  We will call this the _active period_.  It's up to the shuffler as to when the content appears during that time frame.

This plugin allows you to specify _when_, during the active period, the content should be allowed to appear.  You can specify specific hours of the day, days of the week, month, year, alternating days or weeks, etc.  Lots of recurring/scheduling options.

![image](https://cloud.githubusercontent.com/assets/473165/23325570/d843e302-faa2-11e6-9fd4-911d12d7b405.png)

## Installation

If you click on the "Frequency" dropdown list and select "Set Schedule" and a "Repeat" pop up window does not appear, then you probably need to recompile your assets so the plugin's javascript gets included.

In /usr/share/concerto, as the concerto user or as root, run
```
RAILS_ENV=production bundle exec rake assets:precompile
chown -R www-data:www-data public/assets
service apache2 restart
```

Then reload your webpage and the pop up to set the schedule should come up.
