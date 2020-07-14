# frozen_string_literal: true

require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require_relative 'spec_helper_acceptance_methods'

UNSUPPORTED_PLATFORMS = ['RedHat'].freeze

unless ENV['RS_PROVISION'] == 'no' || ENV['BEAKER_provision'] == 'no'
  # Install Puppet Enterprise Agent
  run_puppet_install_helper

  # Clone module dependencies
  clone_dependent_modules

  # Install dependent modules
  install_dependent_modules

end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # configure root certificates
    puppet_module_install(source: proj_root, module_name: 'sslcertificate')

    profile_sslcertificate = <<-SSL
    include ::profile_sslcertificate
    SSL

    # Configure Chocolatey
    profile_chocolatey = <<-CHOCO
    include ::profile_chocolatey_client
    CHOCO

    apply_manifest(profile_sslcertificate, catch_failures: true)
    apply_manifest(profile_chocolatey, catch_failures: true)
    apply_manifest(profile_chocolatey, catch_failures: true)
  end
end
