# frozen_string_literal: true
module SkinnyControllers
  module Lookup
    module Model
      module_function

      # @example 'ObjectOperations::Verb' => Object
      #
      # @return [Class] class based on the operation
      def class_from_operation(operation_name)
        # "Namespace::Model" => "Model"
        model_name = Model.name_from_operation(operation_name)
        # model_name.demodulize

        # "Model" => Model
        model_name.constantize
      end

      # @example 'Namespace::ModelOperation::Verb' => 'Model'
      # @return [String] the model name corresponding to the operation
      def name_from_operation(operation_name)
        # operation_name is something of the form:
        # Namespace::ModelOperations::Verb

        # Namespace::ModelOperations::Verb => Namespace::ModelOperations
        namespace = operation_name.deconstantize
        # Namespace::ModelOperations => ModelOperations
        # nested_namespace = namespace.demodulize
        nested_namespace = namespace.gsub(SkinnyControllers.operations_namespace, '')
        # ModelOperations => Model
        nested_namespace.gsub(SkinnyControllers.operations_suffix, '')
      end
    end
  end
end
