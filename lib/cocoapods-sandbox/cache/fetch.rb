module Pod
    module Add
        class Fetch
            def self.clone_mirror(params)
                repo = params.repo
                repo_md5 = Cache::repo_to_md5(repo)

                cacheRootPath = Cache.cache_root_path
                cacheJsonFilePath = Cache.cacheJsonFilePath

                target = "#{cacheRootPath}" + repo_md5
                git_clone = "git clone --mirror #{repo} #{target}"
                clone_res = system git_clone
                if clone_res 
                    Cache.new(params).used_repo()
                else
                    UI.warn("#{repo} clone failed #{clone_res}")
                end
                clone_res
            end

            def self.fetch(params)
                mirror_repo_hash = Cache.new(params).used_repo() 

                path = mirror_repo_hash[Mirror.path]
                raise "path is nil" unless path

                # fix 2022.06.22
                # update mirror default branch to newst
                Dir.chdir(path) do
                    f = open("|git ls-remote --symref origin HEAD")
                    foo = f.read()
                    (key, value) = foo.split("\t")
                    list = key.split(":")
                    raise "origin HEAD get error" if list.size != 2
                    head = list[1]
                    symbolic_ref = "git symbolic-ref --short HEAD #{head}"
                    system symbolic_ref
                end

                repo_fetch = "git -C '#{path}' remote update"
                repo_fetch_res = system repo_fetch
                if !repo_fetch_res
                    # fix 2022.10.28
                    # some local refs could not be updated; try running 'git remote prune origin'
                    Dir.chdir(path) do
                        prue_origin = 'git remote prune origin'
                        system prue_origin
                    end
                    repo_fetch = "git -C '#{path}' remote update"
                    repo_fetch_res = system repo_fetch
                end
                repo_fetch_res
            end

            def self.check_out(name, repo, branch, path)
                UI.puts("cloning #{name} into #{path} #{branch ? "branch: #{branch}" : "branch: Default"}")
                repo_md5 = Cache::repo_to_md5(repo)
                params = Add::Params.new(name, repo)
                cache = Cache.new(params)
                cache.used_repo()
                json_hash = Cache.find_json_hash()
                
                mirror_repo_hash = json_hash[repo_md5]
                mirror_repo_path = mirror_repo_hash[Mirror.path]

                repath = recheck_path(params.name, path)
                raise "不可以跟Cache路径一样" unless repath != mirror_repo_path

                recheck_repo_exist(name, repath)
                branch_string = branch ? "--branch=#{branch}" : ""
                git_clone = "git clone #{mirror_repo_path} '#{repath}' #{branch_string}"
                git_clone_res = system git_clone
                setRemoteUrlRes = updateCheckoutedPodRemoteUrl(repo, repath)
                return repath if git_clone_res && setRemoteUrlRes
                nil
            end

            private
            # 从mirror cache中checkout出的pod，remote url是mirror镜像的路径，所以需要修改remote url
            def self.updateCheckoutedPodRemoteUrl(repo, path) 
                Dir.chdir(path) do
                    UI.puts "git remote set-url #{repo}"
                    setRemoteUrlRes = system "git remote set-url origin #{repo}"
                    UI.puts "git remote set-url done"
                    return setRemoteUrlRes
                end
                false
            end
            
            def self.recheck_path(name, path)
                Pathname.new(Dir.pwd) + name unless path

                path_pn = Pathname.new(path) + name

                return path_pn.to_s
            end

            def self.recheck_repo_exist(name, path) 
                folder_exist = File.exist?(path)
                if folder_exist 
                    raise "不能clone #{name}, #{path}下已经存在"
                end
            end
        end
    end
end