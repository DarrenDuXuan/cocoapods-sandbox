module Pod
    class Lister
        require 'cocoapods-sandbox/cache/params' 
        require 'cocoapods-sandbox/cache/cache'

        def initialize(name = nil)
            @name = name
        end

        # put repo cache list 
        # 
        # @return [Array<Mirror>]
        def list
            cacheList = Add::Cache.fetchRepoHashArray(@name)
            if cacheList.empty?
                UI.puts "no cache repo found"
                return []
            end
            
            allChoices = cacheList.map {|h| "#{h["name"]} #{h["repo"]}"} 
            UI.puts(allChoices)
            mirrirList = Array.new()
            cacheList.map { |repoMirrorHash| 
                mirror = Add::Mirror.new()
                mirror.decode(repoMirrorHash)
                mirrirList << mirror
            }
            mirrirList
        end
    end
end