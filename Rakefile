require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the poker_history plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the poker_history plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'PokerHistory'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "poker_history"
    s.version = '0.0.1'
    s.summary = "Poker hands history parser"
    s.description = "Poker hands history parser. Supported rooms: PokerStars, PartyPoker, FullTilt"
    s.email = "galeta.igor@gmail.com"
    s.homepage = "https://github.com/galetahub/poker_history"
    s.authors = ["Igor Galeta"]
    s.files =  FileList["[A-Z]*", "{spec,lib}/**/*"]
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
