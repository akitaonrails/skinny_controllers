# frozen_string_literal: true
# required gems
require 'active_support'
require 'active_support/core_ext/class'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/string/inflections'

# files for this gem
require 'skinny_controllers/default_verbs'
require 'skinny_controllers/exceptions'
require 'skinny_controllers/logging'
require 'skinny_controllers/lookup/namespace'
require 'skinny_controllers/lookup/controller'
require 'skinny_controllers/lookup/model'
require 'skinny_controllers/lookup/operation'
require 'skinny_controllers/lookup/policy'
require 'skinny_controllers/policy/base'
require 'skinny_controllers/policy/default'
require 'skinny_controllers/policy/deny_all'
require 'skinny_controllers/policy/allow_all'
require 'skinny_controllers/operation/model_helpers'
require 'skinny_controllers/operation/base'
require 'skinny_controllers/operation/default'
require 'skinny_controllers/diet'
require 'skinny_controllers/version'

module SkinnyControllers
  include Logging

  POLICY_METHOD_SUFFIX = '?'.freeze

  # Tells the Diet what namespace of the controller
  # isn't going to be part of the model name
  #
  # @example
  #  # config/initializers/skinny_controllers.rb
  #  SkinnyControllers.controller_namespace = 'API'
  #  # 'API::' would be removed from 'API::Namespace::ObjectNamesController'
  cattr_accessor :controller_namespace

  # Allows integration of a search gem, like ransack.
  # The scope of this proc is within an operation, so all operation
  # instance variables will be available.
  #
  # - params
  # - params_for_action
  # - current_user
  # - action
  # - model_key
  # - model_params
  #
  # @example
  #   # config/initializers/skinny_controllers.rb
  #   SkinnyControllers.search_proc = ->(association) {
  #     association.ransack(params[:q]).result
  #   }
  cattr_accessor :search_proc do
    lambda do |association|
      association
    end
  end

  cattr_accessor :operations_suffix do
    'Operations'.freeze
  end

  cattr_accessor :policy_suffix do
    'Policy'.freeze
  end

  cattr_accessor :operations_namespace do
    ''.freeze
  end

  cattr_accessor :policies_namespace do
    ''.freeze
  end

  cattr_accessor :allow_by_default do
    true
  end

  cattr_accessor :accessible_to_method do
    :is_accessible_to?
  end

  cattr_accessor :accessible_to_scope do
    :accessible_to
  end

  # the diet uses ActionController::Base's
  # `action_name` method to get the current action.
  # From that action, we map what verb we want to use for our operation
  #
  # If an action is not be listed, the action name will be
  # manipulated to fit the verb naming convention.
  #
  # @example POST controller#send_receipt will use 'SendReceipt' for the verb
  #
  # @note Deleting the action map will make the default CRUD operation classes be
  #  - Index
  #  - Show
  #  - Destroy
  #  - Create
  #  - Update
  cattr_accessor :action_map do
    {
      # @note the only way default will get called, is if action_name is nil
      'default'.freeze => DefaultVerbs::Read,
      'show'.freeze    => DefaultVerbs::Read,
      'index'.freeze   => DefaultVerbs::ReadAll,
      'destroy'.freeze => DefaultVerbs::Delete,
      # these two are redundant, as the action will be
      # converted to a verb via inflection
      'create'.freeze  => DefaultVerbs::Create,
      'update'.freeze  => DefaultVerbs::Update
    }
  end
end
