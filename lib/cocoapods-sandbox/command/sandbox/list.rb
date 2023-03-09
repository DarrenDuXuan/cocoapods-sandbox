module Pod
    class Command
        class Sandbox < Command
            class List < Sandbox
                self.summary = '缓存列表'
                self.description = <<-DESC
                    缓存列表
                DESC

                self.arguments = [
                    CLAide::Argument.new('NAME', false),                   
                ]

                def initialize argv
                    @name = argv.shift_argument
                end
                
                def validate!
                end

                def run
                    Lister.new(@name).list()  
                end
            end
        end
    end
end