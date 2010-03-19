require "digest/sha1"

module Bundler
  class Definition
    attr_reader :dependencies, :sources, :hash

    def initialize(dependencies, sources, hash=nil)
      @dependencies = dependencies
      @sources = sources
      @hash = hash
    end

    def self.from_lock(details)
      hash = details["hash"]

      sources = details["sources"].map do |args|
        name, options = args.to_a.flatten
        Bundler::Source.const_get(name).new(options)
      end

      dependencies = details["dependencies"].map do |opts|
        Bundler::Dependency.new(opts.delete("name"), opts.delete("version"), opts)
      end

      new(dependencies, sources, hash)
    end

    def groups
      dependencies.map { |d| d.groups }.flatten.uniq
    end
  end
end
