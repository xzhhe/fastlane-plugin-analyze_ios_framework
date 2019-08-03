describe Fastlane::Actions::AnalyzeIosFrameworkAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The analyze_ios_framework plugin is working!")

      Fastlane::Actions::AnalyzeIosFrameworkAction.run(nil)
    end
  end
end
