module ConcertoContentScheduling
  module ApplicationHelper

    def is_effective?(start_time, schedule)
      effective = false

      # if no schedule set assume always available
      if schedule.empty? or start_time.empty? or schedule['from_time'].empty? or schedule['to_time'].empty?
        effective = true
      else
        # check the schedule... and see if it is within the viewing window for the day
        if Clock.time >= Time.parse(schedule['from_time']) && Clock.time <= Time.parse(schedule['to_time'])
          # and it matches the criteria
          if !schedule['criteria'].empty?
            s = IceCube::Schedule.new(start_time)
            s.add_recurrence_rule(RecurringSelect.dirty_hash_to_rule(schedule['criteria']))
            effective = s.occurs_on? Clock.time
          else
            # or no criteria was set
            effective = true
          end
        end
      end

      effective
    end

  end
end
