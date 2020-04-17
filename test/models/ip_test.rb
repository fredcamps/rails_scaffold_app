# frozen_string_literal: true

require 'test_helper'

class IpTest < ActiveSupport::TestCase
  test 'should_not_save_data_on_record_when_omit_address_presence' do
  end

  test 'should_not_save_data_on_record_when_pass_invalid_address_format' do
    ip = Ip.create
    ip.address = 'not-a-valid-ip'
    assert_not ip.valid?,
               'Failed validate when try to save a invalid IP address'
    assert_not ip.save
  end
  test 'should_save_data_on_record' do
    ip = Ip.create
    ip.address = '0.0.0.0'
    assert ip.valid?, 'Failed validate when try to save a valid IP address'
    assert ip.save
  end
  test 'should_not_save_data_on_record_when_violate_uniqueness' do
    ip1 = Ip.create
    ip1.address = '127.0.0.1'
    assert ip1.save, 'Failed to save a valid address'
    ip2 = Ip.create
    ip2.address = '127.0.0.1'
    assert_not ip2.valid?,
           'Failed validate when try to save repeated Ip address'
    assert_not ip2.save
  end
end
