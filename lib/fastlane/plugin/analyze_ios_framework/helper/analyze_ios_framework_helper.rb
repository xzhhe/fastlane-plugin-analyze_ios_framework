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
          binary_map = binary(path)
          next unless binary_map

          sub_map = {}
          basename = File.basename(path)
          sub_map[:path] = path
          sub_map[:size] = file_size(path)
          sub_map[:format_size] = format_size(sub_map[:size])
          sub_map[:binary_name] = binary_map[:binary_name]
          sub_map[:binary_path] = binary_map[:binary_path]
          sub_map[:binary_size] = binary_map[:binary_size]
          sub_map[:format_binary_size] = binary_map[:format_binary_size]
          sub_map[:exclude_binary_size] = sub_map[:size] - sub_map[:binary_size]
          sub_map[:format_exclude_binary_size] = format_size(sub_map[:exclude_binary_size])
          sub_map[:static] = binary_map[:static]
          map[basename.to_sym] = sub_map
          total += sub_map[:size]
        end

        map[:real_total] = total
        map[:format_total] = format_size(total)
        map
      end

      def self.binary(framework)
        static = true
        binary_file = 'unknown'
        binary_size = 0
        files = Dir.glob(File.expand_path('*', framework))

        files.each do |file|
          # pp file
          str = `file #{file}`
          # puts "[type] #{str}"

          # static lib ==> /ar archive/
          # ~/Downloads/ZHUDID.framework  file ZHUDID
          # ZHUDID: Mach-O universal binary with 3 architectures: [arm_v7:current ar archive random library] [arm64:current ar archive random library]
          # ZHUDID (for architecture armv7):	current ar archive random library
          # ZHUDID (for architecture x86_64):	current ar archive random library
          # ZHUDID (for architecture arm64):	current ar archive random library

          # dynamic lib ==> /linked shared library/
          # ~/Downloads/du/SDK/du.framework  file du
          # du: Mach-O universal binary with 2 architectures: [arm_v7:Mach-O dynamically linked shared library arm_v7] [arm64]
          # du (for architecture armv7):	Mach-O dynamically linked shared library arm_v7
          # du (for architecture arm64):	Mach-O 64-bit dynamically linked shared library arm64

          #
          # - 1) ar archive
          # - 2) Mach-O universal binary
          #   - 1) dynamically linked shared
          #

          if str.match(/ar archive/)
            static = true
            binary_file = file
            binary_size = file_size(file)
            break
          end

          next unless str.match(/Mach-O universal binary/)
          static = if str.match(/dynamically linked shared/)
                      false
                    else
                      true
                    end
          binary_file = file
          binary_size = file_size(file)
          break
        end

        {
          static: static,
          binary_path: binary_file,
          binary_name: File.basename(binary_file),
          binary_size: binary_size,
          format_binary_size: format_size(binary_size),
        }
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
