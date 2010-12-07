module Verify
  class Base
    VALID_TYPES = [:string, :integer, :symbol]

    class_inheritable_accessor :actions, :presence, :columns

    self.actions  ||= []
    self.columns  ||= {}
    self.presence ||= {}

    def self.action(*action_names)
      [*action_names].each do |action_name|
        self.actions << action_name.to_sym

        class_eval <<-end_eval
          def self.#{action_name.to_sym}(provided_params)
            command = "#{action_name}".to_sym
            construct(provided_params.update(:command => command))
          end
        end_eval
      end
    end

    def self.column(column, *attr_names)
      configuration = { :type => :string, :name => column.to_s.humanize }
      configuration.update(attr_names.extract_options!)

      self.columns[column] = configuration

      attr_accessor column
    end

    def self.validates_presence_of(*attr_names)
      configuration = { :on => self.actions }
      configuration.update(attr_names.extract_options!)

      [*configuration[:on]].each do |on|
        self.presence[on] ||= []

        [*attr_names].each do |attr_name|
          self.presence[on] << attr_name
        end
      end
    end

    protected :initialize

    private

      def self.construct(provided_params)
        command = provided_params[:command]

        result = new

        self.columns.each do |column, configuration|
          if provided_params[column] == nil || provided_params[column] == ""
            if self.presence[command] && self.presence[command].include?(column)
              raise Verify::Error, "#{configuration[:name]} not set"
            end
          else
            value = case configuration[:type]
              when :string
                provided_params[column].to_s
              when :integer
                provided_params[column].to_i
              when :symbol
                provided_params[column].to_sym
              when :boolean
                case provided_params[column]
                  when true, "true", 1, "1"
                    true
                  when false, "false", 0, "0"
                    false
                  else
                    raise Verify::Error, "#{configuration[:name]} not valid: #{provided_params[column].inspect}"
                end
              else
                provided_params[column]
            end

            result.send("#{column.to_s}=", value)
          end
        end

        result
      end

  end
end