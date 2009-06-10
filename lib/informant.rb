module Informant

  class Standard < ActionView::Helpers::FormBuilder
  
    # Declare some options hash keys as custom (not to be passed to built-in
    # form helpers).
    @@custom_field_options = [:label, :required, :description, :decoration]
    @@custom_label_options = [:colon, :label_for]
    
    @@custom_options = @@custom_field_options + @@custom_label_options

    ##
    # Run already-defined helpers through our "shell".
    #
    helpers = field_helpers + %w(select time_zone_select date_select) -
      %w(hidden_field fields_for label)
    helpers.each do |h|
      define_method h do |field, *args|
        options = args.detect { |a| a.is_a?(Hash) } || {}
        prefix = 'standard'
        case h 
        when 'check_box':
          template = "#{prefix}_check_box_field"
          options[:colon] = false
        #when 'radio_button':
        #  template = "#{prefix}_radio_button_field"
        #  options[:colon] = false
        else
          template = "#{prefix}_field"
        end
        all_options = options.clone
        options.reject!{ |i,j| @@custom_options.include? i }
        build_shell(field, all_options, template) { super }
      end
    end
    
    ##
    # Standard Rails date_select.
    #
    def date_select(method, options = {}, html_options = {})
      options[:include_blank] ||= false
      options[:start_year]    ||= 1801
      options[:end_year]      ||= Time.now.year
      options[:label_for]       = "#{object_name}_#{method}_1i"
		  build_shell(method, options) do
        super
		  end
    end
    
    ##
    # This differs from the Rails-default date_select in that it
    # submits three distinct fields for storage in three separate DB columns.
    # This allows partial dates (e.g., year only). See FlexDate plugin for
    # handling partial dates.
    #
    def multipart_date_select(method, options = {}, html_options = {})
      options[:include_blank] ||= false
      options[:start_year]    ||= 1801
      options[:end_year]      ||= Time.now.year
      options[:prefix]          = object_name # for date helpers
      options[:label_for]       = "#{object_name}_#{method}_y"
		  build_shell(method, options) do
        [['y', 'year'], ['m', 'month'], ['d', 'day']].map{ |p|
          i,j = p
          value = @object.send(method.to_s + '_' + i)
          options[:field_name] = method.to_s + '_' + i
          eval("@template.select_#{j}(#{value.inspect}, options, html_options)")
        }.join(' ')
		  end
    end
    
    ##
    # Takes options <tt>:start_year</tt> and <tt>:end_year</tt>.
    #
    def year_select(method, options = {})
      options[:first] = (options[:start_year] or 1801)
      options[:last]  = (options[:end_year] or Time.now.year)
      integer_select(method, options)
    end
    
    ##
    # Integer select menu.
    #
    def integer_select(method, options = {})
      choices = options[:first]..options[:last]
		  build_shell(method, options){ select method, choices, options }
    end
    
    ##
    # Submit button with smart text and +submit+ class.
    #
    def submit(value = nil, options = {})
      options = {:class => "submit"}.merge(options)
      value = (@object.new_record? ? "Create" : "Update") if value.nil?
      super
    end
    
    
    protected # -----------------------------------------------------------------

    ##
    # Insert a field into its HTML "shell".
    #
    def build_shell(method, options, template = 'standard_field')

      # Build new options hash for custom label options.
      label_options = options.reject{ |i,j| !@@custom_label_options.include? i }
      
      # Build new options hash for custom field options.
      field_options = options.reject{ |i,j| !@@custom_field_options.include? i }

      # Remove custom options from options hash so things like
      # <tt>include_blank</tt> aren't added as HTML attributes.
      options.reject!{ |i,j| @@custom_options.include? i }
      
      locals = {
        :element     => yield,
        :label       => label(method, field_options[:label], label_options),
        :description => field_options[:description],
        :error       => error_message_on(method, options),
        :div_id      => "#{@object.class.to_s.underscore}_#{method}_field",
        :required    => field_options[:required],
        :decoration  => field_options[:decoration] || false
      }
      send "#{template}_template", locals
    end

    ##
    # Render standard field template.
    # Store in method rather than external file for speed.
    #
    def standard_field_template(l = {})
      <<-END
      <div id="#{l[:div_id]}" class="field">
	      #{l[:label]}
        #{' <span class="required">*</span>' if l[:required]}<br />
        #{l[:element]}#{l[:decoration] if l[:decoration]}
        #{"<p class=\"field_description\">#{l[:description]}</p>" unless l[:description].blank?}
	    </div>
	    END
    end
    
    ##
    # Render standard check box field template.
    #
    def standard_check_box_field_template(l = {})
      <<-END
      <div id="#{l[:div_id]}" class="field"> 
	      #{l[:element]} #{l[:label]}#{' <span class="required">*</span>' if l[:required]}<br />
	      #{"<p class=\"field_description\">#{l[:description]}</p>" unless l[:description].blank?}
	    </div>
	    END
    end

    ##
    # Render a field label.
    #
    def label(method, text = nil, options = {})
      colon = options[:colon].nil? ? false : options[:colon]
      options.delete :colon
      options[:for] = options[:label_for]
      options.delete :label_for
      if text.blank?
        text = method.to_s.humanize 
      else
        text = text.to_s
      end
      text += ':' if colon
      super
    end
  end
end
