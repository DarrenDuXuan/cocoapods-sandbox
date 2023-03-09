module Pod
    class Command
        class Sandbox < Command
            class Clean < Sandbox
                self.summary = '清理缓存'
                self.description = <<-DESC
                    清理缓存
                DESC

                def self.options
                    [
                        ["--all", "clean all"],
                        ["--name=NAME ", "clean by name"],
                        ["--repo=REPO", "clean by repo"]
                    ]
                end

                def initialize (argv)
                    @all = argv.flag?("all")
                    @name = argv.option("name")
                    @repo = argv.option("repo")
                end
                
                def validate!
                    # super
                    if !@all && !@name && !@repo
                        help! "参数为空，尝试添加 --all, --name, --repo"
                    end
                end

                def run
                    Cleaner.new(@name, @repo, @all).clean()
                end
            end
        end
    end
end