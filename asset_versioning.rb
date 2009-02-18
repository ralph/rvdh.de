#!/usr/bin/env ruby -wKU

require 'rubygems'
# Ruby git gives me lots of strange errors
# require 'git'
require "ftools"

INDEX_FILE = "public/index.html"

class Asset
  def initialize(filename)
    @filename = filename
  end
  
  def filename(option = :regular)
    public_dir = "public/"
    case
    when option == :regular
      @filename
    when option == :versioned
      @filename.split(".").insert(-2, sha).join(".")
    when option == :full
      public_dir + @filename
    when option == :versioned_full
      public_dir + @filename.split(".").insert(-2, sha).join(".")
    end
  end
  
  def version_control!
    File.copy(filename(:full), filename(:versioned_full))
    lines = []
    File.open(INDEX_FILE, "r") do |file|
      lines = file.readlines
    end
    lines.each_with_index do |line, i|
      if line.include?(filename)
        lines[i] = line.sub(filename, filename(:versioned))
      end
    end
    File.open(INDEX_FILE, "r+") do |file|
      file << lines
    end
  end

  private
  def sha
    # Git.open(".").gblob(@filename).log.first.sha
    `git log -n 1 #{filename(:full)}`[7,40]
  end
end

asset_filenames = %w(stylesheets/rvdh_styles.css stylesheets/blueprint/ie.css stylesheets/blueprint/print.css)
asset_filenames.each do |asset_filename|
  asset = Asset.new(asset_filename)
  asset.version_control!
end
