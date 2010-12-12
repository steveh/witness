module Witness
  class Base
    VALID_TYPES = [:string, :integer, :symbol]

    class_inheritable_accessor :actions, :columns, :validates_presence, :validates_signature

    self.actions             ||= []
    self.columns             ||= {}
    self.validates_presence  ||= {}
    self.validates_signature ||= {}

    def self.action(*action_names)
      [*action_names].each do |action_name|
        self.actions << action_name.to_sym

        class_eval <<-end_eval
          def self.#{action_name.to_sym}(provided_params, key = nil)
            command = "#{action_name}".to_sym
            provided_params.merge!(:key => key) if key.present?
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
        self.validates_presence[on] ||= []

        [*attr_names].each do |attr_name|
          self.validates_presence[on] << attr_name
        end
      end
    end

    def self.validates_signature_of(*attr_names)
      configuration = { :on => self.actions }
      configuration.update(attr_names.extract_options!)

      [*configuration[:on]].each do |on|
        self.validates_signature[on] ||= []

        [*attr_names].each do |attr_name|
          self.validates_signature[on] << attr_name
        end
      end

      column :signature
      column :key
    end

    protected :initialize

    private

      def self.construct(provided_params)
        command = provided_params[:command]

        result = new

        self.columns.each do |column, configuration|
          if provided_params[column] == nil || provided_params[column] == ""
            if self.validates_presence[command] && self.validates_presence[command].include?(column)
              raise Witness::Error, "#{configuration[:name]} not set"
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
                    raise Witness::Error, "#{configuration[:name]} not valid: #{provided_params[column].inspect}"
                end
              else
                provided_params[column]
            end

            result.send("#{column.to_s}=", value)
          end
        end

        if self.validates_signature[command]

          if provided_params[:key].blank?
            raise Witness::Error, "Key not set"
          end

          if provided_params[:signature].blank?
            raise Witness::Error, "Signature not set"
          end

          secure_params = {}

          self.validates_signature[command].each do |key|
            secure_params[key] = provided_params[key]
          end

          sigil = Sigil::Base.new(secure_params, provided_params[:key])

          verified = sigil.verify(provided_params[:signature])

          if !verified
            raise Witness::Error, "Signature does not match"
          end

        end

        result
      end

  end
end