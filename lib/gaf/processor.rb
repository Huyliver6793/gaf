require "pry"
require_relative "worksheet/update_worksheet"

module Gaf
  module Processor
    def hook_event_github
      return if request.headers["X-GitHub-Event"] != "pull_request"
      init_or_create_user
      Gaf::Worksheet::UpdateWorksheet.new(params).update_ws
    end

    private

    def init_or_create_user
      user_params = params["pull_request"]["user"]
      @user = User.find_or_create_by(name: user_params["login"], github_id: user_params["id"])
    end
  end
end
