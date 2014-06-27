#!/usr/bin/env ruby

dir = ARGV[0]
scripts = Dir[File.join(dir, "*.sh")]

scripts.each do |scr|
  unless system("mnsubmit #{scr}")
    puts "Could not submit #{scr}"
  end
end
