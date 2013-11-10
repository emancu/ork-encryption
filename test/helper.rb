$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))

require 'coveralls'
Coveralls.wear!

SimpleCov.start do
  project_name "Ork-Encryptor"
  command_name "Protest"

  add_filter "/test/"
end

require "rubygems"
require "protest"
require "ork"
require 'ork/encryption'

Riak.disable_list_keys_warnings = true
Protest.report_with(:progress)

def deny(condition, message="Expected condition to be unsatisfied")
  assert !condition, message
end
