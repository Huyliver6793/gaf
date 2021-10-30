module Gaf
  module Worksheet
    module LoadWorksheet
      def load_worksheet
        session = GoogleDrive::Session.from_config(Gaf.config.google_application_credential)
        spreadsheet = session.spreadsheet_by_title(Gaf.config.title_worksheet)
        @worksheet ||= spreadsheet.worksheets.last
        @sprint ||= Sprint.find_or_create_by name: worksheet.title
      end

      def get_first_row
        @hash_row_title = {}
        @worksheet.rows.first.each_with_index do |value, index|
          @hash_row_title.store(value, index + 1)
        end
      end
    end
  end
end

