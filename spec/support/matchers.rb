module Humanizer
  module Spec
    module Matchers
      def be_awesome
        Rspec::Matchers::Matcher.new :be_awesome do
          match do |actual|
            actual.should == "awesome"
          end
        end
      end
    end
  end
end
