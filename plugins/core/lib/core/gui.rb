
module Redcar
  class Gui
    class << self
      # All defined GUIs
      def all
        @all ||= []
      end
    end
    
    attr_reader :name
    
    # Initialize a new named gui.
    #
    # @param [String] name for the gui
    def initialize(name)
      @name = name
      @controllers = Hash.new {|h,k| h[k] = []}
      Gui.all << self
    end
    
    # Set the event loop object for this gui.
    #
    # @param [Object] the event loop, which must implement
    #        start and stop methods
    def register_event_loop(event_loop)
      @event_loop = event_loop
    end
    
    # Starts the event loop for this gui.
    def start
      @event_loop.start
    end
    
    # Stops the event loop for this gui.
    def stop
      @event_loop.stop
    end
    
    # Set the cucumber features runner for this gui.
    #
    # @param [Object] the feature runner, which must implement
    #         a run_features(args) method, where args is the cucumber
    #         arguments
    def register_features_runner(feature_runner)
      @feature_runner = feature_runner
    end
    
    # Run cucumber features
    #
    # @param [Array[String]] run cucumber features with these args
    def run_features(args)
      @feature_runner.run_features(args)
    end
    
    # Associates a model class and a controller class within this Gui.
    # Not always necessary, because controllers usually know which
    # controller to use.
    #
    # @param [Hash] model_class => controller_class
    def register_controllers(options)
      options.each do |model_class, controller_class|
        @controllers[model_class] << controller_class
      end
    end
    
    # Returns the controller class for the given model, or nil
    #
    # @param [Object] an instance of a Redcar model
    def controller_for(model)
      controller_class = @controllers[model.class].first
      raise "no controller for #{model.class}" unless controller_class
      controller_class
    end
    
    attr_reader :dialog_adapter
    
    # Set the dialog adapter for this gui. A dialog adapter must respond to the
    # standard dialog methods defined in Application::Dialog
    def register_dialog_adapter(dialog_adapter)
      @dialog_adapter = dialog_adapter
    end
  end
end