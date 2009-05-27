#!/usr/bin/env ruby -wKU

require "ftools"
require "asset"

LAYOUTS = ["public/index.html"]

asset_filenames = %w( stylesheets/rvdh_styles.css
                      stylesheets/blueprint/ie.css
                      stylesheets/blueprint/print.css)

asset_filenames.each do |asset_filename|
  asset = Asset.new(asset_filename)
  asset.version_control!
end
