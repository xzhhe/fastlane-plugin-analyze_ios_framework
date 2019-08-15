require 'pp'

describe Fastlane::Actions::AnalyzeIosFrameworkAction do
  describe '#run' do
    it 'action' do
      pods = '/Users/xiongzenghui/collect_zhihu/osee2unified/osee2unified/Pods'
      build = '/Users/xiongzenghui/Library/Developer/Xcode/DerivedData/osee2unified-ddwxlveleudpnlgcnxforrauuxfw/Build/Products/Debug-iphonesimulator'
      app = '/Users/xiongzenghui/Desktop/osee2unifiedRelease.app'
      Fastlane::Actions::AnalyzeIosFrameworkAction.run(
        pod: pods,
        build: build,
        app: app
      )
    end

    it 'heler - frameworks' do
      pods = '/Users/xiongzenghui/collect_zhihu/osee2unified/osee2unified/Pods'
      build = '/Users/xiongzenghui/Library/Developer/Xcode/DerivedData/osee2unified-ddwxlveleudpnlgcnxforrauuxfw/Build/Products/Debug-iphonesimulator'
      app = '/Users/xiongzenghui/Desktop/osee2unifiedRelease.app'
      pp Fastlane::Helper::AnalyzeIosFrameworkHelper.frameworks(pods, build, app)
    end

    it 'heler - file_size' do
      # path = '/Users/xiongzenghui/Desktop/GemfileLockDemo'
      path = '/Users/xiongzenghui/Desktop/osee2unifiedRelease.app'
      pp Fastlane::Helper::AnalyzeIosFrameworkHelper.file_size(path)
    end

    it 'heler - format_size' do
      path = '/Users/xiongzenghui/Desktop/osee2unifiedRelease.app'
      pp Fastlane::Helper::AnalyzeIosFrameworkHelper.format_size(Fastlane::Helper::AnalyzeIosFrameworkHelper.file_size(path))
    end

    it 'heler - binary_parse' do
      path = '/Users/xiongzenghui/Library/Developer/Xcode/DerivedData/osee2unified-ddwxlveleudpnlgcnxforrauuxfw/Build/Products/Debug-iphonesimulator/ZHUDID/ZHUDID.framework'
      pp Fastlane::Helper::AnalyzeIosFrameworkHelper.binary_parse(path)

      path = '/Users/xiongzenghui/Desktop/osee2unifiedRelease.app/Frameworks/du.framework'
      pp Fastlane::Helper::AnalyzeIosFrameworkHelper.binary_parse(path)
    end
    
  end
end
