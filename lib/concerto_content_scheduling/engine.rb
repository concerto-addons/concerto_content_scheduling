module ConcertoContentScheduling
  class Engine < ::Rails::Engine
    isolate_namespace ConcertoContentScheduling

    engine_name 'concerto_content_scheduling'

    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do
        
        add_view_hook "ContentsController", 
                      :content_form, 
                      :partial => "concerto_content_scheduling/content/schedule"
        
      end
    end
    
  end
end
