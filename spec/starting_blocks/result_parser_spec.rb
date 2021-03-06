require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks::ResultParser do

  let(:parsed_output) { {} }

  let(:output) do
    text        = Object.new
    text_parser = Object.new

    StartingBlocks::ResultTextParser.stubs(:new).returns text_parser
    text_parser.stubs(:parse).with(text).returns parsed_output

    StartingBlocks::ResultParser.new.parse text
  end

  it "should return the result from the text parser" do
    output.must_be_same_as parsed_output
  end

  describe "different output scenarios" do

    [:tests, :skips].to_objects {[
      [9, 1], [10, 2], [10, 3]
    ]}.each do |test|
      describe "yellow" do
        it "should have tests and skips" do
          parsed_output[:tests] = test.tests
          parsed_output[:skips] = test.skips
          output[:color].must_equal :yellow
        end
      end
    end

    [:tests, :failures, :errors, :skips].to_objects {[
      [1, 1,   nil, nil],
      [2, nil, 1,   nil],
      [3, nil, 2,   0],
      [4, 3,   nil, 0],
    ]}.each do |test|
      describe "red" do
        it "should return red" do
          parsed_output[:tests]    = test.tests
          parsed_output[:failures] = test.failures
          parsed_output[:errors]   = test.errors
          parsed_output[:skips]    = test.skips
          output[:color].must_equal :red
        end
      end
    end

    [:tests, :failures, :errors, :skips].to_objects {[
      [1, nil, nil, nil],
      [2, 0,   nil, nil],
      [3, nil, 0,   nil],
      [4, nil, nil, 0],
    ]}.each do |test|

      describe "green" do
        it "should set the color to red if there are tests and failures" do
          parsed_output[:tests]    = test.tests
          parsed_output[:failures] = test.failures
          parsed_output[:errors]   = test.errors
          parsed_output[:skips]    = test.skips
          output[:color].must_equal :green
        end
      end

    end

  end

end
