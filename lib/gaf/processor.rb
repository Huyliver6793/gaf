module Gaf
  module Processor
    extend ActiveSupport::Concern
    include Worksheet::LoadWorksheet

    included do
      attr_reader :branch, :pull_request_link, :sprint, :user
      before_action :load_branch, :load_pull_request_link, only: :hook_event_github
    end

    def hook_event_github
      return if request.headers["X-GitHub-Event"] != "pull_request"
      init_or_create_user
      update_ws
    end

    private

    def init_or_create_user
      user_params = params["pull_request"]["user"]
      @user = User.find_or_create_by(name: user_params["login"], github_id: user_params["id"])
    end

    def pull_request?
      request.headers["X-GitHub-Event"] == "pull_request" && params["hook_github"]["action"] == "opened"
    end

    def merged?
      request.headers["X-GitHub-Event"] == "pull_request" && params["hook_github"]["action"] == "closed" &&
        params["pull_request"]["merged_at"].present?
    end


    array_main_branchs.each do |branch|
      define_method("pr_merge_to_#{branch}?") do
        pull_request? && params_branch == branch
      end

      define_method("merged_pull_#{branch}?") do
        merged? && params_branch == branch
      end

      define_method("pull_merge_to_#{branch}") do |row, ws|
        col_pr_merged = hash_row_title["pr_merge_#{branch}"]
        pr_present = ws[row, col_pr_merged].present?
        ws[row, col_pr_merged]  = format_pull_request_link pr_present, ws[row, col_pr_merged]
        ws.save
      end

      define_method("update_status_merged_to_#{branch}") do |row, ws|
        col_merged = hash_row_title["merged_#{branch}"]
        ws[row, col_merged]  = "Done"
        ws.save
      end
    end

    def update_ws
      ref_branch_merge = params["pull_request"]["title"][/\[(.*?)\]/, 1]
      (1..worksheet.num_rows).each do |row|
        if [branch, ref_branch_merge].include? worksheet[row, 2].delete("\n")
          array_main_branchs.each do |branch|
            send("update_status_merged_to_#{branch}", row, worksheet) if send("merged_pull_#{branch}?")
            send("pull_merge_to_#{branch}", row, worksheet) if send("pr_merge_to_#{branch}?")
          end
          update_pull_request_for_branch(row, worksheet) if pr_merge_to_branch?
          update_status_merged_to_ticket(row, worksheet) if merged_pr?
          break
        end
      end
    end

    def update_pull_request_for_branch row, ws
      col_pr = hash_row_title["PR"]
      ticket = params["pull_request"]["head"]["ref"][/([0-9]+)(?=[^\/]*$)/,1]
      array_main_branchs.each do |branch|
        col_merged = hash_row_title["merged_#{branch}"]
        col_deployed = hash_row_title["deployed_#{branch}"]
        ws[row, col_merged]  = "N/A"
        ws[row, col_deployed]  = "N/A"
      end
      col_ticket = hash_row_title["Ticket"]
      pr_present = ws[row, col_pr].present?
      ws[row, col_pr] = format_pull_request_link pr_present, ws[row, col_pr]
      ws[row, col_ticket]  = col_ticket.present? ? ws[row, col_ticket] + "\n#{ticket}" : ticket
      ticket_by_user ticket
      ws.save
    end

    def ticket_by_user ticket
      Ticket.create user_id: user.id, sprint_id: sprint.id, ticket_id: ticket
    end

    def format_pull_request_link pr_present, previous_prs_link
      return previous_prs_link + "\n\n#{pull_request_link}" if pr_present

      pull_request_link
    end

    def update_status_merged_to_ticket row, ws
      col_ticket = hash_row_title["Ticket"]
      ticket = params["pull_request"]["head"]["ref"][/([0-9]+)(?=[^\/]*$)/,1]
      arr_ticket = ws[row, col_ticket].split("\n").map{|tick| tick == ticket ? tick + "(merged)" : tick}
      ws[row, col_ticket] = arr_ticket.join("\n")
      ws.save
    end

    def pr_merge_to_branch?
      pull_request? && array_main_branchs.exclude?(params_branch)
    end

    def merged_pr?
      merged? && array_main_branchs.exclude?(params_branch)
    end

    def params_branch
      params["pull_request"]["base"]["ref"]
    end

    def load_pull_request_link
      @pull_request_link = params["pull_request"]["html_url"]
    end

    def load_branch
      @branch = params["pull_request"]["base"]["ref"]
    end
  end
end
