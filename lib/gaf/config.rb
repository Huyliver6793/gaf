module Gaf
  class Config
    attr_reader :google_application_credential
    attr_reader :title_worksheet
    attr_reader :array_main_branchs

    def google_application_credential=(credential)
      @google_application_credential = credential
    end

    def title_worksheet=(title)
      @title_worksheet = title
    end

    def array_main_branchs=(arr_branchs)
      @array_main_branchs = arr_branchs
    end
  end
end
