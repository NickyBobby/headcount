require "test_helper"
require "parser"

class ParserTest < Minitest::Test
  def test_can_parse_multiple_csv_files
    parser = Parser.new
    hash_of_csvs = parser.parse_files(economic_profile_files)
    assert_instance_of CSV, hash_of_csvs[:title_i]
  end
end
