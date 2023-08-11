require_relative "clivia_generator"
#ruby main.rb  fiore.json
# capture command line arguments (ARGV)
filename = ARGV[0]

filename = "arreglo.json" if filename == nil
ARGV.clear
trivia = CliviaGenerator.new(filename)
trivia.start
