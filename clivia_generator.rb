# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
require_relative "presenter/Presenter"
require "json"
require 'htmlentities'
require "httparty"
require_relative "requester"
require "terminal-table"

class CliviaGenerator
  # maybe we need to include a couple of modules?
  include Presenter
  include HTTParty
  include Requester
  def initialize(filename)
    # we need to initialize a couple of properties here
    @random = []
    @score = 0
    @filename = filename
    
   # @argv = argv
  end

  def start
    # welcome message
    print_welcome
    action = ""
    until action == "exit"
     # begin
        action = menu
        case action
        when "random" then 
          random_trivia
          ask_questions
        when "scores" then parse_scores
        when "exit" then puts "Thanks for using Clivia Generator"
        end
      # rescue HTTParty::ResponseError => e
      #   parsed_error = JSON.parse(e.message, symbolize_names: true)
      #   puts parsed_error
      # end
    end
    # prompt the user for an action
    # keep going until the user types exit
  end

  def random_trivia
    response = self.class.get("https://opentdb.com/api.php?amount=2")
    @random = JSON.parse(response.body, symbolize_names: true)
    # load the questions from the api
    # questions are loaded, then let's ask them
  end

  def ask_questions
    #  Category: Entertainment: Video Games | Difficulty: medium
    # Question: In the Resident Evil series, Leon S. Kennedy is a member of STARS.
    # 1. True
    # 2. False
    # > 1
    # True... Incorrect!
    # The correct answer was: False
    html_entities = HTMLEntities.new
    @random[:results].each_with_index do |result, index|
      array_answer, option = ask_question(result, index)

      if array_answer[option.to_i-1] == result[:correct_answer]
        puts html_entities.decode(result[:correct_answer]) + "... " + "Correct!"
        @score += 10
      else
        puts array_answer[option.to_i-1] +"... "+ "Incorrect!"
        puts "The correct answer was: " + html_entities.decode(result[:correct_answer])
      end
    end

    will_save?(@score,@filename)
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
  end

  def save(data)
    # write to file the scores data
  end

  def parse_scores

    table = Terminal::Table.new
    table.title = "Top score"
    table.headings = ["name", "score"]

    if File.exist?(@filename)
      # El archivo existe
      # Aquí puedes realizar las operaciones que necesites con el archivo JSON
      array_score = JSON.load(File.read(@filename))
    else
      # El archivo no existe
      cadena_json = JSON.pretty_generate(Array.new)
      array_score = []
    # Escribir la cadena JSON en un archivo
      File.open(@filename, 'w') do |archivo|
      archivo.write(cadena_json)
      end

    end
    array_score = array_score.sort_by { |item| item["score"] }.reverse
    array_score_top = array_score .first(3)
    array_new = []
    array_score_top.each do |score|
    array_new << [score["name"],score["score"].to_s]
    end
    table.rows = array_new
    puts table
    # get the scores data from file
  end

  def load_questions
    # ask the api for a random set of questions
    # then parse the questions
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
  end

  def print_scores
    # print the scores sorted from top to bottom
  end
end
