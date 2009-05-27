class Asset
  @@public_dir = "public/"
  
  def initialize(filename)
    @filename = filename
  end
  
  def filename(option = "")
    :versioned == option ? @filename.split(".").insert(-2, sha[1..8]).join(".") : @filename
  end
  
  def filepath(option = "")
    @@public_dir + filename(option)
  end
  
  def version_control!
    File.copy(filepath, filepath(:versioned))
    lines = []
    LAYOUTS.each do |layout|
      File.open(layout, "r") do |file|
        lines = file.readlines
      end
    end
    lines.each_with_index do |line, i|
      if line.include?(filename)
        lines[i] = line.sub(filename, filename(:versioned))
      end
    end
    LAYOUTS.each do |layout|
      File.open(layout, "r+") do |file|
        file << lines
      end
    end
  end

  private
  def sha
    `git log -n 1 #{filepath}`[7,40]
  end
end