module SkinnyControllers
  module Operation
    module PolicyHelpers
      POLICY_CLASS_PREFIX = 'Policy::'.freeze
      POLICY_CLASS_SUFFIX = 'Policy'.freeze
      POLICY_SUFFIX = '?'.freeze

      # Takes the class name of self and converts it to a Policy class name
      #
      # @example In Operation::Event::Read, Policy::EventPolicy is returned
      def policy_class
        @policy_class ||= (
          POLICY_CLASS_PREFIX +
          object_type_of_interest +
          POLICY_CLASS_SUFFIX
        ).constantize
      end

      # Converts the class name to the method name to call on the policy
      #
      # @example Operation::Event::Read would become read?
      def policy_name
        @policy_name ||= self.class.name.demodulize.downcase + POLICY_SUFFIX
      end

      # @return a new policy object and caches it
      def policy_for(object)
        @policy ||= policy_class.new(
          current_user,
          object,
          authorized_via_parent: authorized_via_parent)
      end

      def allowed?
        allowed_for?(model)
      end

      # checks the policy
      def allowed_for?(object)
        policy_for(object).send(policy_name)
      end
    end
  end
end
