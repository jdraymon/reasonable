require "fileutils"
require "haml"
require "RedCloth"
require "sass"

EXTENSION_DIR = File.join(File.dirname(__FILE__), "ext")
SOURCE_DIR    = File.join(File.dirname(__FILE__), "src")

def verify_directory(path)
  FileUtils.mkdir_p(path) unless File.directory?(path)
end

def verify_extension_structure
  verify_directory EXTENSION_DIR
  %w(css img js).each do |subdirectory|
    verify_directory File.join(EXTENSION_DIR, subdirectory)
  end
end

def collect_sources(input_type, output_type, output_dir = nil)
  output_dir ||= output_type
  Dir[File.join(SOURCE_DIR, input_type, "*.#{input_type}")].each do |path|
    output_name = "#{File.basename(path, ".*")}.#{output_type}"
    yield({
      :full_path   => path,
      :file_name   => File.basename(path),
      :output_path => File.join(EXTENSION_DIR, output_dir, output_name),
      :content     => File.read(path)
    })
  end
end

namespace :build do
  desc "Say hi"
  task :haml do |t|
    verify_extension_structure
    collect_sources("haml", "html", "") do |file|
      File.open(file[:output_path], "w") do |handle|
        handle.puts Haml::Engine.new(file[:content]).render
      end
    end
  end

  desc "Say hi"
  task :sass do |t|
    verify_extension_structure

  end
end

__END__
PADDING = 24

fs = require 'fs'
exec = require('child_process').exec
path = require 'path'

contentScripts = [
  "vars"
  "trolls"
  "thread"
  "article"
  "commenting"
  "history"
  "realtime"
  "init"
]

# String repetition function
repeat = (pattern, count) ->
  return '' if count < 1
  result = ''
  while count > 0
    result += pattern if count & 1
    count >>= 1
    pattern += pattern
  result

highlight = (text, formats...) -> "\033[#{formats.join ";"}m#{text}\033[0m"

pad = (text) -> text + repeat ' ', PADDING - text.length

errorLog = (err, stdout, stderr) -> throw err if err
verifyTarget = (target) -> fs.mkdir target, 0777 unless path.existsSync target

build = (target, environment) ->
  console.log "\n\033[32mCompiling #{environment} build...\033[0m"
  buildSCSS   target
  buildCoffee target
  buildHAML   target
  buildOther  target

concatenate = (directory, files, extension = "") ->
  result = []
  result.push "#{directory}/#{file}#{if extension is "" then "" else ".#{extension}"}" for file in files
  result.join " "

task 'build', 'Build project from source to dev', (options) ->
  target ?= "ext"
  invoke "coffee"
  invoke "sass"
  invoke "haml"
  invoke "other"

task 'clear', 'Clear ext directory', (options) ->
  exec "rm -rf ext/*"

# Individual filetypes
task 'coffee', 'Compile CoffeeScript to development', (options) ->
  target ?= "ext"
  verifyTarget target

  fs.readdir "src/coffee", (err, scripts) ->
    console.log highlight 'Coffee -> JS (source)', 1, 32
    for script in scripts
      if path.extname(script) is ""
        console.log pad("  #{script}/") + highlight(script + ".js", 1)
        console.log "    #{subscript}.coffee" for subscript in contentScripts
        exec "coffee --bare --compile --join #{script}.js --output #{target}/js/
              #{concatenate "src/coffee/content", contentScripts, "coffee"}", errorLog
      else
        console.log pad("  #{script}") + highlight(script.replace(".coffee", ".js"), 1)
        exec "coffee --bare --compile --output #{target}/js/ src/coffee/#{script}", errorLog

  fs.readdir "lib/coffee", (err, scripts) ->
    console.log highlight 'Coffee -> JS (library)', 1, 32
    for script in scripts
      console.log pad("  #{script}") + highlight(script.replace(".coffee", ".js"), 1)
      exec "coffee --compile --output #{target}/js/ lib/coffee/#{script}", errorLog

task 'haml', 'Compile HAML to development', (options) ->
  target ?= "ext"
  verifyTarget target

  fs.readdir "src/haml", (err, pages) ->
    console.log highlight 'HAML -> HTML', 1, 32
    for page in pages
      htmlPage = page.replace ".haml", ".html"
      console.log pad("  #{page}") + highlight(htmlPage, 1)
      exec "haml src/haml/#{page} #{target}/#{htmlPage}", errorLog

task 'sass', 'Compile SASS files to development', (options) ->
  target ?= "ext"
  verifyTarget target

  fs.readdir "src/sass", (err, sheets) ->
    console.log highlight 'SASS -> CSS', 1, 32
    for sheet in sheets
      cssSheet = sheet.replace ".sass", ".css"
      console.log pad("  #{sheet}") + highlight(cssSheet, 1)
      exec "sass --no-cache src/sass/#{sheet}:#{target}/css/#{cssSheet}", errorLog

task 'other', 'Copy other files to development', (options) ->
  target ?= "ext"
  verifyTarget target
  console.log 'Other: static CSS, images, HTML, vendor JavaScript and manifest'
  exec "cp -r src/css #{target}", errorLog
  exec "cp -r src/img #{target}", errorLog
  exec "cp -r vendor/js #{target}", errorLog
  exec "cp -r src/manifest.json #{target}/manifest.json", errorLog

# Zipping
task 'zip', 'Create a zip of the compiled extrary', (options) ->
  console.log highlight "Zipping extension...", 1, 32
  exec "cd ./ext"
  exec "zip -r ../extension.zip *"
  exec "cd .."
  console.log "Zipped ext directory to extension.zip"
