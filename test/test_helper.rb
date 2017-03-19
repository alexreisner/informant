$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'informant'

require 'active_support/core_ext/string/output_safety'
require 'action_controller'
require 'action_view/test_case'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
