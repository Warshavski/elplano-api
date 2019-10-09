# frozen_string_literal: true

module Admin
  module Sendgrid
    # Admin::Sendgrid::Metrics
    #
    #   Used to fetch email metrics such as:
    #
    #     - clicks
    #     - delivered
    #     - opens
    #     - processed
    #     - requests
    #     - ....
    #
    # @see https://sendgrid.com/docs/api-reference/
    #
    class Metrics
      # @see #execute
      def self.call
        new.execute
      end

      attr_reader :sg

      def initialize
        @sg = SendGrid::API.new(api_key: ENV['SENDGRID_METRICS_API_KEY'])
      end

      # Perform sendgrid statistics request
      #   (email metrics for last month)
      #
      # @return [Array<Hash>]
      #
      # @example
      #   Admin::Sendgrid::Metrics.call
      #
      #   # =>
      #   [
      #     {
      #       "date" => "2019-10-01",
      #       "metrics" => {
      #         "blocks" => 0,
      #         "bounce_drops" => 0,
      #         "bounces" => 0,
      #         "clicks" => 0,
      #         "deferred" => 46,
      #         "delivered" => 0,
      #         "invalid_emails" => 0,
      #         "opens" => 0,
      #         "processed" => 1,
      #         "requests" => 1,
      #         "spam_report_drops" => 0,
      #         "spam_reports" => 0,
      #         "unique_clicks" => 0,
      #         "unique_opens" => 0,
      #         "unsubscribe_drops" => 0,
      #         "unsubscribes" => 0
      #       }
      #     }
      #   ]
      #
      def execute
        response = perform_request(compose_params)

        parse_response(response)
      end

      private

      def compose_params
        params = <<~JSON.squish
          {
            "aggregated_by": "day",
            "start_date": "#{Date.current - 1.month}",
            "end_date": "#{Date.current}"
          }
        JSON

        JSON.parse(params)
      end

      def perform_request(params)
        sg.client.stats.get(query_params: params)
      end

      def parse_response(response)
        return [] if response.status_code != '200'

        JSON.parse(response.body).map do |entity|
          date    = entity['date']
          metrics = entity['stats'].first['metrics']

          { 'date' => date, 'metrics' => metrics }
        end
      end
    end
  end
end
