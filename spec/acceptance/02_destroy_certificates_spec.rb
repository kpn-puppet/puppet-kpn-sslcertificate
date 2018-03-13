require 'spec_helper_acceptance'

describe 'sslcertificate', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  context 'remove 2 certificates' do

    it 'should work idempotently with no errors' do
      pp = <<-EOS
      # Destroy certificates

      sslcertificate { 'certificaat_crt':
        path            => 'LocalMachine\\Root\\59AF82799186C7B47507CBCF035746EB04DDB716',
        ensure          => 'absent',
      }
      sslcertificate { 'certificaat_cer':
        path            => 'LocalMachine\\CA\\4EB251A8CA19975AE959E26D41F12A82B9DE761B',
        ensure          => 'absent',
      }
      EOS
      # Run it twice and test for idempotency
      if fact('operatingsystemmajrelease') =~ /2008/
        apply_manifest(pp, :catch_failures => true)
      end
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe command('powershell.exe "(Get-ChildItem Cert:\LocalMachine\Root\59AF82799186C7B47507CBCF035746EB04DDB716).thumbprint"') do
      its(:stdout) { is_expected.to match // }
    end

    describe command('powershell.exe "(Get-ChildItem Cert:\LocalMachine\CA\4EB251A8CA19975AE959E26D41F12A82B9DE761B).thumbprint"') do
      its(:stdout) { is_expected.to match // }
    end

  end # with default parameters

end # security_policy_class
