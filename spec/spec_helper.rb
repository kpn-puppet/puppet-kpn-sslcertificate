require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.fail_fast = true
end

at_exit {
  print "Resource coverage report is N/A for custom provider type\n\n"
}
