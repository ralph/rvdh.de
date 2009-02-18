class Asset
  @@public_dir = "public/"
  
  def initialize(filename)
    @filename = filename
  end
  
  def filename(option = "")
    :versioned == option ? @filename.split(".").insert(-2, sha).join(".") : @filename
  end
  
  def filepath(option = "")
    @@public_dir + filename(option)
  end
  
  def version_control!
    File.copy(filepath, filepath(:versioned))
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
    `git log -n 1 #{filepath}`[7,40]
  end
end