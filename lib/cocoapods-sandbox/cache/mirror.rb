module Pod
    module Add
        class Mirror

            attr_reader :name, :repo, :use_count, :path, :lock
            @name = nil
            @repo = nil
            @use_count = 0
            @path = nil
            @lock = false

            def decode(hash)
                @name = hash[self.class.name]
                @repo = hash[self.class.repo]
                @use_count = hash[self.class.use_count]
                @path = hash[self.class.path]
                @lock = hash[self.class.lock]
            end


            class << self
                def name
                    "name"
                end

                def repo
                    "repo"
                end

                def use_count
                    "use_count"
                end

                def path
                    "path"
                end

                def lock
                    "lock"
                end
            end
        end
    end
end