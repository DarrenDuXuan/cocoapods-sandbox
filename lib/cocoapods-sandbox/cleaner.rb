module Pod
    class Cleaner
        require 'cocoapods-sandbox/cache/params' 
        require 'cocoapods-sandbox/cache/cache'

        def initialize(name = nil, repo = nil , all = false)
            @name = name
            @repo = repo
            @all = all

        end

        # clean repo
        # 
        # @return bool
        def clean
            Add::Cache.new
            if @all
                Add::Cache.cleanAll
                return true
            end
            
            if @repo
                raise "repo 不能为空，并且必须使用ssh" unless @repo && @repo.start_with?('ssh://')
                Add::Cache.clean_by_repo(@repo)
                return true
            end

            if @name
                Add::Cache.clean_by_name(@name)
                return true
            end
            help! "参数为空，尝试添加 --all, --name, --repo" 
            false
        end

        

    end
end