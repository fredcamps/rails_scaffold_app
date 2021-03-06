# frozen_string_literal: true
require 'json'
require 'test_helper'

class Api::V1::DnsRecordsControllerTest < ActionDispatch::IntegrationTest
  fixtures :hostnames, :ips, :hostnames_ips
  test 'should_retrieve_http_200_status_code' do
    get '/api/v1/dns_records/1?include=dolor.com,ipsum.com&exclude=sit.com'
    expected_result = {
      'total_records' => 2,
      'records' => [{ 'id' => 1,
                      'ip_address' => '1.1.1.1' },
                    { 'id' => 3, 'ip_address' => '3.3.3.3' }],
      'related_hostnames' => [{ 'count' => 1, 'hostname' => 'lorem.com' },
                              { 'count' => 2, 'hostname' => 'ipsum.com' },
                              { 'count' => 2, 'hostname' => 'dolor.com' },
                              { 'count' => 2, 'hostname' => 'amet.com' }]
    }
    assert_equal 200, status
    assert_equal expected_result, JSON.parse(body)
  end

  test 'should_retrieve_http_200_code_withou_query_string_params' do
    get '/api/v1/dns_records/1'
    assert_equal 200, status
  end

  test 'should_retrieve_http_200_code_when_get_an_empty_result' do
    get '/api/v1/dns_records/1?include=sharklasers.com&exclude=sit.com'
    expected_result = {
      'total_records' => 0,
      'records' => [],
      'related_hostnames' => []
    }
    assert_equal 200, status
    assert_equal expected_result, JSON.parse(body)
  end

  test 'should_retrieve_http_201_status_code' do
    post '/api/v1/dns_records/',
         params: {
           'dns_records': {'ip' => '5.5.5.5',
                           'hostnames_attributes' => [{ 'hostname' => 'lerolero.com' },
                                                      { 'hostname' => 'power2damasses.com'}] }
         }
    expected_result = { 'id' => 5 }
    assert_equal 201, status
    assert_equal expected_result, JSON.parse(body)
  end

  test 'should_retrieve_http_409_status_code' do
    post '/api/v1/dns_records',
         params: {
           'dns_records': {'ip' => '5.5.5.5',
                           'hostnames_attributes' => [{ 'hostname' => 'dolor.com' },
                                                      { 'hostname' => 'sit.com' }] }
         }
    assert_equal 409, status
  end

  test 'should_retrieve_bad_request_status' do
    post '/api/v1/dns_records',
         params: { 'dns_records': { 'ip' => '7.7.7.7',
                                    'hostnames_attributes' => [{'hostname' => nil}]}}
    assert_equal 400, status
    post '/api/v1/dns_records',
         params: { 'dns_records': nil}
    assert_equal 400, status
  end
end
