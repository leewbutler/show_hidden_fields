# ShowHiddenFields

module LeeWB #:nodoc:
  module Helpers #:nodoc:
    module ShowHiddenFields #ShowHiddenFields 
      
      # Overrides calls to hidden_field, instead calls text_field.
      def hidden_field(object_name, method, options = {}) 
        text_field(object_name, method, add_shown_hidden_features(options)) 
      end 
      
      # Overrides calls to hidden_field_tag, instead calls text_field_tag .
      def hidden_field_tag(name, value = nil, options = {}) 
        text_field_tag(name, value, add_shown_hidden_features(options))  
      end
      
      def tag(name, options = nil, open = false, escape = true)
        if options[:type] == 'hidden'
          options[:type] = 'text'
          options = add_shown_hidden_features(options)
        elsif options['type'] == 'hidden'
          options['type'] = 'text'
          options = add_shown_hidden_features(options)
        end
        super
      end 
      
      private
      
      # Adds css styles to indicate it's a shown hidden field. 
      # Also adds JS that reveals the field name & id onmouseover,
      # then resets the field to it's origional value onmouseout.
      def add_shown_hidden_features(options)
        options['style']        = 'color: #777; border: 1px solid #ccc; background-color: #eee; font-size: 10px;'
        options['onmouseover']  = "this.origval = this.value; this.style.color = '#0000CD'; this.value = 'id=\\'' + this.id + '\\', name=\\'' + this.name + '\\'' ;" 
        options['onmouseout']   = "this.value = this.origval; this.style.color = '#777'"
        options
      end
      
    end
  end
end

ActionController::Base.class_eval do 
  SHOW_HIDDEN_FIELDS = false unless defined?(SHOW_HIDDEN_FIELDS)
  
  # Loads the plugin code only if the SHOW_HIDDEN_FIELDS flag
  # is set to true (most likely set in the apps config/environmnet.rb init block).
  if SHOW_HIDDEN_FIELDS 
    helper LeeWB::Helpers::ShowHiddenFields
  end
  
end


