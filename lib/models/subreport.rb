class Subreport
  class UnknownType < StandardError; end
  class InvalidType < StandardError; end
  class InvalidReport < StandardError; end
  class InvalidContentFormat < StandardError; end

  attr_accessor :report, :type, :content, :title, :path

  def initialize(report:, type:, content:)
    raise InvalidReport unless report.is_a? Report
    @report = report

    raise InvalidType unless type.is_a? Symbol
    raise UnknownType unless type_valid?(type)
    @type = type

    raise InvalidContentFormat unless content_valid?(content)
    @content = content

    @title = @type.to_s.tr('_', ' ').capitalize
    @path = "#{report_subdirectory}/#{@type}.txt"
  end

  private

  def report_subdirectory
    @report.report_subdirectory
  end

  def type_valid?(type)
    @report.class.subreport_types.include?(type)
  end

  def content_valid?(content)
    [Array, Hash, String].include? content.class
  end
end