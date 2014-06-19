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
        # TODO test with the manykinds plugin concurrently enabled to see how it works
        add_controller_hook "Subscription", :filter_contents, :after do
          @contents.reject!{|c| !is_effective(c.start_time, c.schedule)}
        end

      end
    end
    
  end
end
