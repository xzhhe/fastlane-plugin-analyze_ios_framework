require 'fastlane/action'
require_relative '../helper/analyze_ios_framework_helper'

module Fastlane
  module Actions
    module SharedValues
      ANALYZE_IOS_FRAMEWORK_PATHS = :ANALYZE_IOS_FRAMEWORK_PATHS
      ANALYZE_IOS_FRAMEWORK_HASH  = :ANALYZE_IOS_FRAMEWORK_HASH
    end
    class AnalyzeIosFrameworkAction < Action
      def self.run(params)
        pods = params[:pods]
        build = params[:build]
        app = params[:app]

        UI.important "⚠️ [AnalyzeIosFrameworkAction] pods=#{pods}"
        UI.important "⚠️ [AnalyzeIosFrameworkAction] build=#{build}"
        UI.important "⚠️ [AnalyzeIosFrameworkAction] app=#{app}"

        frameworks = Fastlane::Helper::AnalyzeIosFrameworkHelper.frameworks(pods, build, app)
        Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANALYZE_IOS_FRAMEWORK_PATHS] = frameworks
        pp Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANALYZE_IOS_FRAMEWORK_PATHS]

        Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANALYZE_IOS_FRAMEWORK_PATHS] = Fastlane::Helper::AnalyzeIosFrameworkHelper.generate(frameworks)
        pp Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANALYZE_IOS_FRAMEWORK_PATHS]
      end

      def self.description
        "analysis ios framework in buildout or pods dir"
      end

      def self.authors
        ["xiongzenghui"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "analysis ios framework in buildout or pods dir"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :pods,
            description: "where your pods dir",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :build,
            description: "xcode build finish product dir",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :app,
            description: "/path/to/xx.app",
            optional: false,
            type: String
          )
        ]
      end

      def self.is_supported?(platform)
        :ios == platform
      end
    end
  end
end
