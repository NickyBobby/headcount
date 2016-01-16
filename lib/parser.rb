

class Parser
  
  def parse_file(data)
    CSV.open data[:enrollment][:kindergarten],
                      headers: true,
                      header_converters: :symbol
  end

  def convert_csv_to_hashes(contents)
    contents.map do |row|
      {
        district:    row[:location],
        time_frame:  row[:timeframe],
        data_format: row[:dataformat],
        data:        row[:data]
      }
    end
  end

end
