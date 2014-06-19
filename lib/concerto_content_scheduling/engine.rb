require 'recurring_select'
module ConcertoContentScheduling
  class Engine < ::Rails::Engine
    isolate_namespace ConcertoContentScheduling

    engine_name 'concerto_content_scheduling'

    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do
        
        add_view_hook "ContentsController", 
                      :content_form, 
                      :partial => "concerto_content_scheduling/content/schedule"

        # filter the contents according to the schedule
        # the manykinds plugin if concurrently enabled will cause this to be skipped
        add_controller_hook "Subscription", :filter_contents, :after do
          @contents.reject!{|c| !ConcertoContentScheduling::Engine.is_effective?(c.start_time, c.schedule)}
        end

      end
    end
    
    # this needs to find a different place to reside, but it needs to be available to the 
    # Subscription:filter_contents hook and to the views in this engine
    def is_effective?(start_time, schedule)
      effective = false

      # if no schedule set assume always available
      if schedule.blank? or start_time.blank? or schedule['from_time'].blank? or schedule['to_time'].blank?
        effective = true
      else
        # check the schedule... and see if it is within the viewing window for the day
        if Clock.time >= Time.parse(schedule['from_time']) && Clock.time <= Time.parse(schedule['to_time'])
          # and it matches the criteria
          if !schedule['criteria'].blank?
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
