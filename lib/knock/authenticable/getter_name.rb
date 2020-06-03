module Knock
  module Authenticable
    class GetterName
      attr_reader :entity_class

      def initialize(entity_class)
        @entity_class = entity_class
      end

      def cleared
        "current_#{entity_class.to_s.gsub('::', '').underscore}"
      end
    end
  end
end
