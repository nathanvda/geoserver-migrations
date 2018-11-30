
RSpec::Matchers.define :match_fuzzy do |expected|
  expected = expected.to_s

  match do |actual|
    actual = actual.to_s
    actual.strip.gsub(/[[:blank:]]+/, '').gsub(/\n+/, "\n") == expected.strip.gsub(/[[:blank:]]+/, '').gsub(/\n+/, "\n")
  end

  failure_message do |actual|
    actual = actual.to_s
    actual_normalized = actual.strip.gsub(/^\s+/, '').gsub(/[[:blank:]]+/, "\s").gsub(/\n+/, "\n").gsub(/\s+$/, '')
    expected_normalized = expected.strip.gsub(/^\s+/, '').gsub(/[[:blank:]]+/, "\s").gsub(/\n+/, "\n").gsub(/\s+$/, '')

    message = <<-EOS.strip_heredoc
      expected: #{expected_normalized.inspect}
           got: #{actual_normalized.inspect}
    EOS

    diff = RSpec::Expectations.differ.diff(actual_normalized, expected_normalized)

    unless diff.strip.empty?
      diff_label = RSpec::Matchers::ExpectedsForMultipleDiffs::DEFAULT_DIFF_LABEL
      message << "\n\n" << diff_label << diff
    end

    message
  end
end