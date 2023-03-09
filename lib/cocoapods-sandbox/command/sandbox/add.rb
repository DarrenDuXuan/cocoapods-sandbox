module Pod
    class Command
        class Sandbox < Command
            class Add < Sandbox
                self.summary = '添加缓存'
                self.description = <<-DESC
                    添加缓存
                DESC

                self.arguments = [
                    CLAide::Argument.new('NAME', false),
                    CLAide::Argument.new('REPO', false),                    
                ]

                def initialize argv
                    @name = argv.shift_argument
                    @repo = argv.shift_argument
                end
                
                def validate!
                    require_name unless @name
                    require_repo unless @repo && @repo.start_with?('ssh://')
                end

                def require_name
                    UI.puts "请输入仓库名称？"
                    @name = $stdin.gets.chomp.strip;
                end

                def require_repo
                    UI.puts "请输入仓库地址？请使用ssh"
                    @repo = $stdin.gets.chomp.strip;
                end

                def run
                    Adder.new(@name, @repo).add()
                end
            end
        end
    end
end