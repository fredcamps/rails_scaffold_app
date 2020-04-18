# frozen_string_literal: true
require 'byebug'
module Api
  module V1
    class DnsRecordsController < ApplicationController
      def list
        limit = 10
        page = params[:page].to_i
        offset = (page - 1) * limit
        included_hostnames = params[:include] ? params[:include].split(',') : []
        excluded_hostnames = params[:exclude] ? params[:exclude].split(',') : []
        sql = <<-SQL
        SELECT ip_id, ip_address, hostnames_addresses FROM (
            SELECT i.id as ip_id, i.address as ip_address, array_agg(h.address) as hostnames_addresses FROM ips i
            INNER JOIN hostnames_ips hi ON i.id = hi.ip_id
            INNER JOIN hostnames h ON h.id = hi.hostname_id
            GROUP BY i.id LIMIT #{limit} OFFSET #{offset}
        ) as records
        SQL
        where_clause = +''
        included_hostnames.each do |included|
          if where_clause.strip.empty?
            where_clause << "'#{included}' LIKE ANY(records.hostnames_addresses)"
          else
            where_clause << " AND '#{included}' LIKE ANY(records.hostnames_addresses)"
          end
        end
        excluded_hostnames.each do |excluded|
          if where_clause.strip.empty?
            where_clause << "NOT '#{excluded}' LIKE ANY(records.hostnames_addresses)"
          else
            where_clause << " AND NOT '#{excluded}' LIKE ANY(records.hostnames_addresses)"
          end
        end
        records = []
        related_hostnames = []
        hostnames = []
        data = Ip.find_by_sql "#{sql} where #{where_clause}"
        data.each do |record|
          records << { 'id' => record.ip_id, 'ip_address' => record.ip_address }
          hostnames += record.hostnames_addresses
        end
        total_records = records.count
        hostnames.each do |hostname|
          count = hostnames.count hostname
          related_hostnames << { 'count' => count,
                                 'hostname' => hostname }
        end
        render json: { 'total_records' => total_records,
                       'records' => records,
                       'related_hostnames' => related_hostnames.uniq }
      end

      def create
        begin
          ip_address = params['dns_records']['ip']
          ip = Ip.find_by address: ip_address
          ip ||= Ip.new
          Ip.transaction do
            ip.address = ip_address
            ip.save!
            params['dns_records']['hostnames_attributes'].each do |atribute|
              hostname = Hostname.find_by address: atribute['hostname']
              hostname ||= Hostname.new
              hostname.address = atribute['hostname']
              hostname.ips << ip
              hostname.save!
            end
          end
          response_body = { 'id' => ip.id }
          status_code = 201
        rescue StandardError
          response_body = { 'error'=> 'The item(s) is already saved' }
          status_code = 409
        end
        render json: response_body, status: status_code
      end
    end
  end
end
