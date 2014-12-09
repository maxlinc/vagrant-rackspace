@announce
@rackspace
@windows
Feature: vagrant-rackspace fog tests

  Background:
    Given I have Rackspace credentials available
    # And I have cleaned up servers
    And I have successfully run `bundle exec destroy --force`

  Scenario: Create a single server (with provisioning)
    Given a file named "Vagrantfile" with:
    """
    # -*- mode: ruby -*-
    # vi: set ft=ruby :

    # Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
    VAGRANTFILE_API_VERSION = "2"

    %w{RAX_USERNAME RAX_API_KEY VAGRANT_ADMIN_PASSWORD}.each do |var|
      abort "Please set the environment variable #{var} in order to run the test" unless ENV.key? var
    end

    Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
      Vagrant.require_plugin "vagrant-rackspace"
      # All Vagrant configuration is done here. The most common configuration
      # options are documented and commented below. For a complete reference,
      # please see the online documentation at vagrantup.com.

      # Every Vagrant virtual environment requires a box to build off of.
      config.vm.box = "dummy"
      config.vm.define :ubuntu do |ubuntu|
        ubuntu.ssh.private_key_path = '~/.ssh/id_rsa'
        ubuntu.vm.provider :rackspace do |rs|
          rs.username = ENV['RAX_USERNAME']
          rs.admin_password = ENV['VAGRANT_ADMIN_PASSWORD']
          rs.api_key  = ENV['RAX_API_KEY']
          rs.flavor   = /1 GB Performance/
          rs.image    = /Ubuntu/
          rs.rackspace_region = :iad
          rs.public_key_path = '~/.ssh/id_rsa.pub'
        end
      end

      config.vm.define :windows do |windows|
        windows.vm.provision :shell, :inline => 'Write-Output "WinRM is working!"'
        windows.vm.communicator = :winrm
        windows.winrm.username = 'Administrator'
        windows.winrm.password = ENV['VAGRANT_ADMIN_PASSWORD']
        begin
          config.winrm.ssl      = true
        rescue
          puts "Warning: Vagrant #{Vagrant::VERSION} does not support WinRM over SSL."
        end
        windows.vm.synced_folder ".", "/vagrant", disabled: true
        windows.vm.provider :rackspace do |rs|
          rs.username = ENV['RAX_USERNAME']
          rs.api_key  = ENV['RAX_API_KEY']
          rs.admin_password = ENV['VAGRANT_ADMIN_PASSWORD']
          rs.flavor   = /2 GB Performance/
          rs.image    = 'Windows Server 2012'
          rs.rackspace_region = ENV['RAX_REGION'] ||= 'dfw'
          # You'll need to manually enabled WinRM while the server is coming up, until personality file support is available
        end
      end
    end
    """
    When I successfully run `bundle exec vagrant up --provider rackspace`
    # I want to capture the ID like I do in tests for other tools, but Vagrant doesn't print it!
    # And I get the server from "Instance ID:"
    Then the server "vagrant-windows-server" should be active