module ConcertoContentScheduling
  class Schedule < ActiveRecord::Base

    SCHEDULE_RULES = ["Daily", "Weekly", "Monthly (by day of month)",
                      "Yearly (by day of year)", "Yearly (by month of year)" ]

  end
end