require 'recurring_select'

module ConcertoContentScheduling
  class Engine < ::Rails::Engine
    isolate_namespace ConcertoContentScheduling
    engine_name 'concerto_content_scheduling'

    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do

        extend_model Content, ConcertoContentScheduling::Concerns::Scheduling
        
        add_view_hook "ContentsController", 
                      :content_form, 
                      :partial => "concerto_content_scheduling/content/schedule"

        add_view_hook "ContentsController", 
                      :content_details, 
                      :partial => "concerto_content_scheduling/content/details"

        add_view_hook "ContentsController", 
                      :tile_labels, 
                      :partial => "concerto_content_scheduling/content/tile_labels"

        # filter the contents according to the schedule
        # the manykinds plugin if concurrently enabled will cause this to be skipped
        add_controller_hook "Subscription", :filter_contents, :after do
          @contents.reject!{|c| !c.is_active_per_schedule?}
        end

        add_controller_hook "ContentsController", :update_params, :after do
          @attributes.concat([:schedule_info => [:criteria, :start_time, :end_time]])
        end

      end
    end
  end
end
