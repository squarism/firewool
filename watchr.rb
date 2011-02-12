ENV["WATCHR"] = "1"
system 'clear'

def growl(message)
  growlnotify = `which growlnotify`.chomp
  title = "Watchr Test Results"
  passed = message.include?('0 failures, 0 errors')
  image = passed ? "~/.watchr_images/passed.png" : "~/.watchr_images/failed.png"
  severity = passed ? "-1" : "1"
  options = "-w -n Watchr --image '#{File.expand_path(image)}'"
  options << " -m '#{message}' '#{title}' -p #{severity}"
  system %(#{growlnotify} #{options} &)
end

def run(cmd)
  puts(cmd)
  `#{cmd}`
end

def run_test_file(file)
  system('clear')
  result = run(%Q(ruby -I"lib:test" -rubygems #{file}))
  result_lines = result.split("\n")
  msg = result_lines[result_lines.size - 3]
  growl msg rescue nil
  puts result
end

def run_all_tests
  system('clear')
  result = run "rake test"
  result_lines = result.split("\n")
  # new rake has Test run options as last line, result is 2 lines up
  msg = result_lines[result_lines.size - 3]
  growl msg rescue nil
  puts result
end

def related_test_files(path)
  Dir['test/**/*.rb'].select { |file| file =~ /#{File.basename(path).split(".").first}_test.rb/ }
end

def run_suite
  run_all_tests
end

watch('test/test_helper\.rb') { run_all_tests }
watch('test/.*_test\.rb') { |m| run_test_file(m[0]) }
watch('lib/.*\.rb') { run_all_tests }
watch('lib/firewool/.*\.rb') { run_all_tests }


# Ctrl-\
Signal.trap 'QUIT' do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

@interrupted = false

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    # raise Interrupt, nil # let the run loop catch it
    run_suite
  end
end
