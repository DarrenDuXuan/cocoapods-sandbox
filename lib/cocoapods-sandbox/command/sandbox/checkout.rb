module Pod
    class Command
        class Sandbox < Command
            class CheckOut < Sandbox
                self.summary = '从缓存中checkout'
                self.description = <<-DESC
                    从缓存中checkout
                DESC

                self.arguments = [
                    CLAide::Argument.new('REPO', true),                    
                ]
                
                def self.options
                    [
                        ['--branch=BRANCH', 'branch/tag default is default branch'],
                        ['--path=PATH', 'path, default is currentPath']
                    ]
                end

                def initialize argv
                    @repo = argv.shift_argument
                    @branch = argv.option("branch", nil)
                    @path = argv.option("path", nil)
                end
                
                def validate!
                    require_repo unless @repo
                    require_path unless @path
                end
                
                def require_repo
                    UI.puts "请输入仓库地址？请使用ssh"
                    @repo = $stdin.gets.chomp.strip;
                end

                def require_path
                    @path = Dir.pwd
                end

                def run
                    Checkouter.new(@repo, @branch, @path).checkout()
                end
            end
        end
    end
end