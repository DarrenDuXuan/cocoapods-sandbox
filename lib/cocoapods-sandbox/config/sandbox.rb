module Pod
    class Config
        module Sandboxx

            public

            def sandbox_cache_config_file
                @sandbox_cache_config_file ||= Pathname.new(sandbox_cache_dir).join("config.csv")

            end
            
            def sandbox_cache_dir
                @sandbox_cache_dir ||= Pathname.new(sanbox_my_home).join(".sandbox_cache")
                @sandbox_cache_dir.mkpath unless @sandbox_cache_dir.exist?
                return @sandbox_cache_dir.expand_path
            end

            def sanbox_my_home
                @sanbox_my_home ||= ENV["HOME"]
                @sanbox_my_home ||= Pathname.new("~").expand_path
                return @sanbox_my_home
            end
        end
    end
end
