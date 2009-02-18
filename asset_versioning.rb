#!/usr/bin/env ruby -wKU

require 'rubygems'
# Ruby git gives me lots of strange errors
# require 'git'
require "ftools"

class Asset
  def initialize(filename)
    @filename = filename
  end
  
  def versioned_filename
    @filename.split(".").insert(-2, sha).join(".")
  end
  
  def version_control!
    File.copy(@filename, versioned_filename)
    lines = []
    File.open("index.html", "r") do |file|
      lines = file.readlines
    end
    lines.each_with_index do |line, i|
      if line.include?(@filename)
        lines[i] = line.sub(@filename, versioned_filename)
      end
    end
    File.open("index.html", "r+") do |file|
      file << lines
    end
  end

  private
  def sha
    # Git.open(".").gblob(@filename).log.first.sha
    `git log -n 1 #{@filename}`[7,40]
  end
end

asset_filenames = %w(stylesheets/rvdh_styles.css stylesheets/blueprint/ie.css stylesheets/blueprint/print.css)
asset_filenames.each do |asset_filename|
  asset = Asset.new(asset_filename)
  asset.version_control!
end
