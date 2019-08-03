require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class AnalyzeIosFrameworkHelper
      # class methods that you define here become available in your action
      # as `Helper::AnalyzeIosFrameworkHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the analyze_ios_framework plugin helper!")
      end
    end
  end
end
