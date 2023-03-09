module Pod
    class Checkouter
        require 'cocoapods-sandbox/cache/params' 
        require 'cocoapods-sandbox/cache/cache'
        require 'cocoapods-sandbox/cache/fetch'

        def initialize(repo, branch = nil, path = nil)
            @repo = repo
            @branch = branch
            @path = path

            raise "repo 不能为空，并且必须使用ssh" unless @repo && @repo.start_with?('ssh://')
        end

        # check out pods from ssh
        # 
        # @return bool
        #         success
        def checkout
            name = File.basename(@repo, ".git")
            params = Add::Params.new(name, @repo)
            # 找到cache，直接check out
            if Add::Cache.new(params).find_repo_cache()
                fetch_res = Add::Fetch.fetch(params)
                if !fetch_res
                    require 'cocoapods-sandbox/cleaner'
                    Pod::Cleaner.new(name, @repo, false).clean
                    return self.checkout
                end
                UI.puts ("#{name} fetch success") if fetch_res
                return self.privateCheckOut(name, @repo, @branch, @path)
            else
                # 没有找到cache，先clone mirror到本地，再check out
                clone_res = Add::Fetch.clone_mirror(params)
                if clone_res    
                    return self.privateCheckOut(name, @repo, @branch, @path)
                else
                    return clone_res
                end
            end
        end

        def privateCheckOut(name, repo, branch, path)
            path = Add::Fetch.check_out(name, @repo, @branch, @path) 
            return path
        end
    end
end