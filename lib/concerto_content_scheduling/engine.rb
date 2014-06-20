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
          @contents.reject!{|c| !ConcertoContentScheduling::Engine.is_active?(c)}
        end

        # allow the schedule field via strong params
        add_controller_hook "ContentsController", :content_params, :after do
          @attributes.concat([:schedule_info => [:criteria, :start_time, :end_time]])
        end

        add_controller_hook "Content", :initialize, :after do
          self.schedule_info = { 
            "start_time" => ConcertoConfig[:content_default_start_time], 
            "end_time" => ConcertoConfig[:content_default_end_time], 
            "criteria" => nil 
          } if self.schedule_info.nil?
        end

        add_controller_hook "Content", :find, :after do
          self.schedule_info = JSON.load(self.schedule) rescue {}
        end

        add_controller_hook "Content", :validation, :before do
          self.schedule = JSON.dump(self.schedule_info)
        end
      end
    end
    
    # this needs to find a different place to reside, but it needs to be available to the 
    # Subscription:filter_contents hook and to the views in this engine
    def is_active?(content)
      active = true

      if content.blank? or content.schedule_info.blank? or !content.schedule_info.is_a?(Hash) or
        !content.schedule_info.include?("start_time") or !content.schedule_info.include?("end_time") or
        !content.schedule_info.include?("criteria") or content.schedule_info["start_time"].blank? or
        content.schedule_info["end_time"].blank? or content.schedule_info["criteria"].blank?
        # missing or incomplete schedule information so assume active
      else
        # see if it is within the viewing window for the day
        begin
          if Clock.time >= Time.parse(content.schedule_info['start_time']) && Clock.time <= Time.parse(content.schedule_info['end_time'])
            # and it matches the criteria
            s = IceCube::Schedule.new(content.start_time)
            s.add_recurrence_rule(RecurringSelect.dirty_hash_to_rule(content.schedule_info['criteria']))
            active = s.occurs_on? Clock.time
          else
            active = false
          end
        rescue => e
          active = false
          Rails.logger.error("Unable to determine if schedule is active - #{e.message} for content #{content.id}")
        end
      end

      active
    end
    
  end
end
