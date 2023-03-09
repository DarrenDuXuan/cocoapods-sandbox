module Pod
    class Adder
        require 'cocoapods-sandbox/cache/params' 
        require 'cocoapods-sandbox/cache/cache'
        require 'cocoapods-sandbox/cache/fetch'
        require 'cocoapods-sandbox/cache/mirror'
        def initialize(name = nil, repo)
            @name = name
            @repo = repo

            raise "repo 不能为空，并且必须使用ssh" unless @repo && @repo.start_with?('ssh://')
        end

        # add repo to cache
        # 
        # @return bool
        def add
            name = @name ? @name : File.basename(@repo, ".git")
            params = Add::Params.new(name, @repo)
            if Add::Cache.new(params).find_repo_cache()
                fetch_res = Add::Fetch.fetch(params)
                UI.puts("#{@name} fetch success") if fetch_res
                fetch_res
            else    
                clone_res = Add::Fetch.clone_mirror(params)
                UI.puts("#{@name} add success") if clone_res
                clone_res
            end
        end
    end
end   