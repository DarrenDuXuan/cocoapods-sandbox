module Pod
    module Add
        class Params

            attr_reader :name, :repo

            def initialize(name = "", repo)
                @name = name
                @repo = repo
                
            end
        end
    end
end