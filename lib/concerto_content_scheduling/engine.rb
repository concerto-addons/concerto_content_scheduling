require 'recurring_select'
module ConcertoContentScheduling
  class Engine < ::Rails::Engine
    isolate_namespace ConcertoContentScheduling
    engine_name 'concerto_content_scheduling'

    config.to_prepare do
      Concerto::Content.class_eval { include ConcertoContentScheduling::Concerns::Scheduling }
    end

    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do
        
        add_view_hook "ContentsController", 
                      :content_form, 
                      :partial => "concerto_content_scheduling/content/schedule"

        # filter the contents according to the schedule
        # the manykinds plugin if concurrently enabled will cause this to be skipped
        add_controller_hook "Subscription", :filter_contents, :after do
          @contents.reject!{|c| !c.is_active_per_schedule?}
        end

      end
    end
  end
end
