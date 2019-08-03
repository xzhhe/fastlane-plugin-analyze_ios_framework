require 'fastlane/plugin/analyze_ios_framework/version'

module Fastlane
  module AnalyzeIosFramework
    # Return all .rb files inside the "actions" and "helper" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions,helper}/*.rb', File.dirname(__FILE__))]
    end
  end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::AnalyzeIosFramework.all_classes.each do |current|
  require current
end
