module MovieOrganizer
  class Settings < MidwireCommon::YamlSetting
    def initialize
      super(MovieOrganizer.config_file)
    end
  end
end
