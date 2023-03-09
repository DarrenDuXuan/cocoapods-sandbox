require 'digest' 

module Pod
    module Add
        class Cache
            def initialize(params = nil) 
                @params = params

                create_cacheJSon
            end

            # 是否能找到cache
            #
            # @return bool
            #         yes | no
            def find_repo_cache()
                repo = @params.repo  

                repoPathname = Pathname.new(self.class.cache_repo_path(repo))
                exist = repoPathname.exist?
                if !exist
                    self.class.clean_by_repo(repo, false)
                end
                exist
            end

            # add或fetch一次repo，需要调用此方法，对计数加一
            def used_repo()
                repo = @params.repo

                hash = self.class.find_json_hash
                
                # 当前repo存入json
                repoMD5 = self.class.repo_to_md5(repo)
                if !hash[repoMD5]
                    name = @params.name
                    mirror_hash = Hash.new
                    mirror_hash[Mirror.repo] = repo
                    mirror_hash[Mirror.name] = name
                    mirror_hash[Mirror.use_count] = 1
                    mirror_hash[Mirror.path] = self.class.cache_repo_path(repo)
                    mirror_hash[Mirror.lock] = false
                    hash[repoMD5] = mirror_hash
                    self.class.writeDataToCacheJson(hash)
                else
                # 更新count
                    use_count = hash[repoMD5][Mirror.use_count]
                    hash[repoMD5][Mirror.use_count] = use_count + 1
                    self.class.writeDataToCacheJson(hash)
                end
                hash[repoMD5] 
            end

            # 读取json文件数据
            # @return [Hash]
            def self.find_json_hash
                file = File.read(cacheJsonFilePath)
                json = JSON.parse(file)
                json
            end

            # 清理所有的缓存
            def self.cleanAll
                names = Dir.entries(cache_root_path)
                names.each do |name|
                    path = cache_root_path + name
                    pathname = Pathname.new(path)
                    pathname.rmtree if !name.include?(".") && pathname.exist?
                end
                hash = Hash.new
                writeDataToCacheJson(hash)
                UI.puts("clean all success")
                true
            end

            # 根据repo清理缓存
            def self.clean_by_repo(repo, showWarnings = true)
                hash = find_json_hash
                repoMD5 = repo_to_md5(repo)
                findedHash = hash[repoMD5]
                if !findedHash
                    if showWarnings 
                        UI.warn ("没找到此repo #{repo} 缓存")
                    end
                    return
                end
                UI.puts("#{repo} 清理中")
                path = findedHash[Mirror.path]
                pathname = Pathname.new(path)
                pathname.rmtree if pathname.exist?
                hash.delete(repoMD5)
                writeDataToCacheJson(hash)
                UI.puts("#{repo} 清理完成")
            end

            # 根据name清理缓存
            # 可能会有多个，用户需手动选择
            # 
            # @param name String
            def self.clean_by_name(name)
                findedArray = fetchRepoHashArray(name)
                if findedArray.empty?
                    UI.warn("没有找到 #{name}")
                    return
                end
                if findedArray.length == 1  
                    firstRepoHash = findedArray[0]
                    repo = firstRepoHash[Mirror.repo]
                    clean_by_repo(repo)
                else
                    choices = findedArray.map {|h| "name:#{name} repo:#{h[Mirror.repo]}"}
                    index = UI.choose_from_array(choices, 'Which pod cache do you want to remove?')
                    hash = findedArray[index]
                    repo = hash[Mirror.repo]
                    clean_by_repo(repo) 
                end
            end

            # 根据名称获取repo hash list
            #
            # @return [Hash]
            #
            # @param name = nil String
            #        库名
            def self.fetchRepoHashArray(name = nil) 
                hash = find_json_hash
                findedArray = Array.new
                hash.each do |key, value|
                    if !name
                        findedArray << value
                    else
                        findedArray << value if value[Mirror.name] == name
                    end
                end
                findedArray
            end

            # 缓存json文件名
            @@martinXCacheJsonFlileName = ".cache.json"
            class << self
                # 缓存根目录路径
                def cache_root_path
                    "#{Config.instance.sandbox_cache_dir}" + "/"
                end
                
                # 缓存管理Json文件路径
                def cacheJsonFilePath
                    cache_root_path + @@martinXCacheJsonFlileName
                end

                def cache_repo_path(repo)
                    cache_root_path + repo_to_md5(repo)
                end

                # repo -> MD5
                # @return String
                #         md5
                def repo_to_md5(repo)
                    Digest::MD5.hexdigest(repo)
                end
            end

            private
            # 创建本地CacheJson对应文件
            def create_cacheJSon
                fileExists = File.exists?(self.class.cacheJsonFilePath)
                if !fileExists
                    FileUtils.touch(self.class.cacheJsonFilePath)
                    scanCaheFiles()          
                    hash = Hash.new
                    self.class.writeDataToCacheJson(hash)
                    raise "Cache File Touch Failed" unless File.exist?(self.class.cacheJsonFilePath)
                end

                file = File.join(self.class.cacheJsonFilePath)
                # TODO: 本地文件夹与json文件校验同步
                # puts file
            end

            # 如果Json文件非法，或者被删除需要重新扫描已有文件到Json中
            def scanCaheFiles()
                root = self.class.cache_root_path
                names = Dir.entries(root)
                size = names.size
                dirs = Array.new(size)
                names.each do |name|
                    # dirs<<name unless name.start_with?(".")
                    dirs<<name unless name.include?(".")
                end
                dirs
            end

            # 写入数据到json中
            def self.writeDataToCacheJson(hash)
                File.write(cacheJsonFilePath, JSON.dump(hash))
            end
        end
    end
end