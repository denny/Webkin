require 'yaml'
require 'pry'

# Pull in the core Story lib
require "#{__dir__}/lib/story"

# Load the config file
config = YAML.load_file "#{__dir__}/config.yaml"

# Create and configure the Story object
story = Story.new
story.url = ARGV[0].dup
story.output_dir = config['output_dir']

# Fetch, convert, and write out the story
story.fetch
story.to_txt
story.write_file
