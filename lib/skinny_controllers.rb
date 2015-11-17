# required gems
require 'active_support'
require 'active_support/core_ext/class'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/string/inflections'

# files for this gem
require 'skinny_controllers/default_verbs'
require 'skinny_controllers/policy/base'
require 'skinny_controllers/operation/policy_helpers'
require 'skinny_controllers/operation/model_helpers'
require 'skinny_controllers/operation/base'
require 'skinny_controllers/operation/default'
require 'skinny_controllers/diet'
require 'skinny_controllers/version'

# load the policy and operation to the top level name space.
# TODO: this might be horrible
#   the problem here is that specify numerous namespaces to
#   define policies and namespaces gets cumbersome.
#   Maybe there is a way to wrap a namespace...
#   Or maybe that's why Rails perfers suffixes on its objects
#   e.g.: XController, XSerializer, XHelper, etc
$LOAD_PATH.unshift Dir[File.dirname(__FILE__) + '/skinny_controllers/'].first

# Object.const_set("Policy", SkinnyControllers::Policy)
# Object.const_set("Operation", SkinnyControllers::Operation)

module SkinnyControllers
  # Tells the Diet what namespace of the controller
  # isn't going to be part of the model name
  #
  # @example
  #  # config/initializers/skinny_controllers.rb
  #  SkinnyControllers.controller_namespace = 'API'
  #  # 'API::' would be removed from 'API::Namespace::ObjectNamesController'
  cattr_accessor :controller_namespace

  #
  cattr_accessor :operation_namespace do
    'Operation'.freeze
  end

  cattr_accessor :allow_by_default do
    true
  end

  cattr_accessor :accessible_to_method do
    :is_accessible_to?
  end

  # the diet uses ActionController::Base's
  # `action_name` method to get the current action.
  # From that action, we map what verb we want to use for our operation
  #
  # If an action is not be listed, the action name will be
  # manipulated to fit the verb naming convention.
  #
  # @example POST controller#send_receipt will use 'SendReceipt' for the verb
  cattr_accessor :action_map do
    {
      'default'.freeze => DefaultVerbs::Read,
      'index'.freeze => DefaultVerbs::ReadAll,
      'destroy'.freeze => DefaultVerbs::Delete,
      # these two are redundant, as the action will be
      # converted to a verb via inflection
      'create'.freeze => DefaultVerbs::Create,
      'update'.freeze => DefaultVerbs::Update
    }
  end
end
