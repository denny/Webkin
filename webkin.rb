require 'yaml'
require 'pry'

# Find out where we're at
my_dir = File.expand_path( File.dirname(__FILE__) )

# Pull in the core Story lib
require "#{my_dir}/lib/story"

# Load the config file
config = YAML.load_file "#{my_dir}/config.yaml"

# Create and configure the Story object
story = Story.new
story.url = ARGV[0].dup
story.output_dir = config['output_dir']

# Fetch, convert, and write out the story
story.fetch
story.to_txt
story.write_file
