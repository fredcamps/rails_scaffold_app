# frozen_string_literal: true

require 'test_helper'

class HostnameTest < ActiveSupport::TestCase
  test 'should_not_save_data_on_record_when_omit_address_presence' do
    hostname = Hostname.create
    assert_not hostname.valid?,
               'Bypassing validation of hostname record without address'
    assert_not hostname.save
  end

  test 'should_save_data_on_record' do
    hostname = Hostname.create
    hostname.address = 'steam.com'
    assert hostname.valid?,
           'Failed validate, when try to save with valid hostname'
    assert hostname.save
  end

  test 'should_not_save_data_on_record_when_violate_uniqueness' do
    hostname1 = Hostname.create
    hostname1.address = 'steam.com'
    hostname1.save
    hostname1.valid?
    assert hostname1.save, 'Failed to save a valid address'
    hostname2 = Hostname.create
    hostname2.address = 'steam.com'
    hostname2.save
    assert_not hostname2.valid?,
               'Failed validate that checks address uniquess rule violation'
    assert_not hostname2.save
  end
end
