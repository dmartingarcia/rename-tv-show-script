#!/bin/ruby

def pick_data(filepath)
  file_name = File.basename(filepath)
  /^(?<title>[a-zA-Z ]+) - Temporada (?<season>\d) \[(?<video_profile>[0-9a-zA-Z ]+)\]\[Cap.\d{1}(?<episode>\d{2})\]\[(?<audio>[0-9a-zA-Z .]+)\]\[(?<release_group>[a-zA-Z0-9.]+)\](?<ext>.+)/.match(file_name)&.named_captures
  # TVSHOWNAME - Temporada 1 [HDTV 720p][Cap.101][AC3 5.1 Castellano][www.*****.COM].mkv
end

def rename(file_path, new_file_name, dry: true)
  file_dir, file_name = File.split(file_path)
  puts "#{file_name} -> #{new_file_name}"

  return if dry || File.exist?("#{file_dir}/#{new_file_name}")

  File.link("#{file_dir}/#{file_name}", "#{file_dir}/#{new_file_name}")
end

def list_files(path)
  Dir["#{path}/**/*.{mkv,avi,mpeg}"]
end

def generate_file_name(data)
  "#{data["title"]} S#{data["season"]}E#{data["episode"]} [#{data["video_profile"].gsub(" ", "-")}][#{data["audio"]}][x264]-RlsGrp#{data["ext"]}"
end

path = ARGV[0]
dry = false

files = list_files(path)

files.each do |file|
  data = pick_data(file)
  next if data.nil?

  new_file_name = generate_file_name(data)
  rename(file, new_file_name, dry: dry)
end
