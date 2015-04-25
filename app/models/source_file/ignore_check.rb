class SourceFile::IgnoreCheck
  PATTERN = /(spec\/|test\/|_spec\.rb$|_test\.rb$|rails\/generators\/|db\/migrate\/|db\/schema\.rb$|^Library\/Formula\/|lib\/generators\/|benchmark\/|db\/seeds\.rb)/
  include Procto.call

  attr_reader :filename

  def initialize(filename)
    @filename = (filename || '').freeze
  end

  # @return [Boolean] should be ignored if true
  def call
    !filename.match(PATTERN).nil?
  end
end
