# frozen_string_literal: true
require 'spec_helper'

describe SkinnyControllers::Lookup::Operation do
  let(:klass) { SkinnyControllers::Lookup::Operation }
  context :model_name_to_operation_namespace do
  end

  context :operation_of do
  end

  context :from_controller do
  end

  context :default_operation_class_for do
    it 'creates a namespace' do
      expect(defined? SomeObjectOperations::Default).to be_falsey
      klass.default_operation_class_for('SomeObject', 'Default')
      expect(defined? SomeObjectOperations::Default).to be_truthy
    end

    it 'creates a namespace for reading all' do
      expect(defined? SomeObjectOperations::ReadAll).to be_falsey
      klass.default_operation_class_for('SomeObject', 'ReadAll')
      expect(defined? SomeObjectOperations::ReadAll).to be_truthy
    end

    it 'creates a namespace for reading' do
      expect(defined? SomeObjectOperations::Read).to be_falsey
      klass.default_operation_class_for('SomeObject', 'Read')
      expect(defined? SomeObjectOperations::Read).to be_truthy
    end

    it 'creates a namespace for non-REST' do
      expect(defined? SomeObjectOperations::RefundPayment).to be_falsey
      klass.default_operation_class_for('SomeObject', 'RefundPayment')
      expect(defined? SomeObjectOperations::RefundPayment).to be_truthy
    end
  end

  context :default_operation_namespace_for do
    before(:each) do
      # just in case of race conditions
      if defined? SomeObjectOperations
        # this is a scary command o.o
        Object.send(:remove_const, :SomeObjectOperations)
      end
    end

    it 'creates a namespace' do
      expect(defined? SomeObjectOperations).to be_falsey
      klass.default_operation_namespace_for('SomeObject')
      expect(defined? SomeObjectOperations).to be_truthy
    end
  end

  context :name_from_model do
    it 'prepends the operation prefix' do
      verb = SkinnyControllers::DefaultVerbs::ReadAll
      name = 'SomeObject'
      suffix = SkinnyControllers.operations_suffix
      expected = SkinnyControllers.operations_namespace + '::' + name + suffix + '::' + verb

      result = klass.name_from_model(name, verb)

      expect(result).to eq expected
    end
  end
end
