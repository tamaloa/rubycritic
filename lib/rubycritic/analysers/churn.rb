module Rubycritic
  module Analyser

    class Churn
      def initialize(analysed_modules, source_control_system)
        @analysed_modules = analysed_modules
        @source_control_system = source_control_system
      end

      def run
        @analysed_modules.each do |analysed_module|
          analysed_module.churn = @source_control_system.revisions_count(analysed_module.path)
          analysed_module.committed_at = @source_control_system.date_of_last_commit(analysed_module.path)
        end
      end
    end

  end
end
