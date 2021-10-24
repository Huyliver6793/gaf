module Gaf
  module Worksheet
    class CreateWorksheet
      ROWS = ["STT", "Feature Branch", "Note", "Note Release", "PR feature branch", "Ticket"].freeze
      def initialize
        @array_main_branchs = Gaf.config.array_main_branchs
        arr_rows
      end

      def self.create
        session = GoogleDrive::Session.from_config(Gaf.config.google_application_credential)
        spreadsheet = session.spreadsheet_by_title(Gaf.config.title_worksheet)
        @worksheet = spreadsheet.worksheets.first
        rows.each_with_index do |row, index |
          @worksheet[1, index] = row
        end
        @worksheet.save
      end

      private
      attr_accessor :rows, :array_main_branchs

      def arr_rows
        @rows = ROWS
        array_main_branchs.each do |main_branch|
          need_rows = ["pr_merge_#{main_branch}", "merged_#{main_branch}", "deployed_#{main_branch}"]
          rows << need_rows
        end
        rows.flatten!
      end
    end
  end
end
