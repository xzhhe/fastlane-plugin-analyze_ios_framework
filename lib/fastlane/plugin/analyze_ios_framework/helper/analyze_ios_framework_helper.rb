require 'fastlane_core/ui/ui'
require 'pp'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class AnalyzeIosFrameworkHelper
      def self.frameworks(pods, build, app)
        pods_frameworks = Dir.glob(File.expand_path('**/*.framework', pods))
        build_frameworks = Dir.glob(File.expand_path('**/*.framework', build))
        app_frameworks = Dir.glob(File.expand_path('**/*.framework', app))
        
        # 优先取 app/frameworks 中的 dynamic framework
        app_framework_basenames = app_frameworks.map do |f|
          File.basename(f).to_s
        end

        frameworks = pods_frameworks + build_frameworks
        frameworks = frameworks.reject do |f|
          app_framework_basenames.include?(File.basename(f).to_s)
        end

        frameworks = frameworks + app_frameworks
        frameworks
      end

      def self.generate(frameworks)
        map = {}
        return map unless frameworks

        total = 0
        frameworks.each do |path|
          sub_map = {}
          basename = File.basename(path)
          sub_map[:path] = path
          sub_map[:real_size] = file_size(path)
          sub_map[:format_size] = format_size(sub_map[:real_size])
          map[basename.to_sym] = sub_map
          total += sub_map[:real_size]
        end

        map[:real_total] = total
        map[:format_total] = format_size(total)
        map
      end

      def self.file_size(file_path)
        return 0 unless File.exist?(file_path)

        base = File.basename(file_path)
        return 0 if ['.', '..'].include?(base)

        total = 0
        if File.directory?(file_path)
          Dir.glob(File.expand_path('*', file_path)).each do |f|
            # pp f
            total += file_size(f)
          end
        else
          size = File.stat(file_path).size
          total += size
        end

        total
      end

      def self.format_size(bytes)
        return '0 B' unless bytes
        return '0 B' if bytes.zero?

        k = 1024
        suffix = %w[B KB MB GB TB PB EB ZB YB]
        i = (Math.log(bytes) / Math.log(k)).floor
        base = (k ** i).to_f
        num = (bytes / base).round(2)
        "#{num} " + suffix[i]
      end
    end
  end
end
