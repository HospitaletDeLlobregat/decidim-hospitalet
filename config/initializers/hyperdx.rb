# frozen_string_literal: true

if ENV["OTEL_EXPORTER_OTLP_HEADERS"].present?
  require "opentelemetry-exporter-otlp"
  require "opentelemetry/instrumentation/all"
  require "opentelemetry/sdk"

  OpenTelemetry::SDK.configure(&:use_all)

  Rails.application.configure do
    Rails.logger = Logger.new($stdout)
    # Rails.logger.log_level = Logger::INFO # default is DEBUG, but you might want INFO or above in production
    # rubocop:disable Style/StringConcatenation
    Rails.logger.formatter = proc do |severity, time, _progname, msg|
      span_id = OpenTelemetry::Trace.current_span.context.hex_span_id
      trace_id = OpenTelemetry::Trace.current_span.context.hex_trace_id
      operation = if defined? OpenTelemetry::Trace.current_span.name
                    OpenTelemetry::Trace.current_span.name
                  else
                    "undefined"
                  end

      { "time" => time, "level" => severity, "message" => msg, "trace_id" => trace_id, "span_id" => span_id,
        "operation" => operation }.to_json + "\n"
    end
    # rubocop:enable Style/StringConcatenation

    Rails.logger.info "Logger initialized !! 🐱"
  end
end
