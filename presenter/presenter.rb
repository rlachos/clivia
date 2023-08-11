module Presenter
  def print_welcome
    # print the welcome message
    puts ["###################################",
          "#   Welcome to Clivia Generator   #",
        "###################################"].join("\n")
  end

  def menu
    options = ["random","scores","exit"]
    get_with_options(options)
  end

  def get_with_options(options, required: true)
    input = ""
    loop do
      puts options.join(" | ")
      print "> "
      input = gets.chomp # ["update", "48"]
      break if options.include?(input) || (input.empty? && !required)
      puts "Invalid option"
    end
  input
  end

  def print_score(score)
    # print the score message
 
  end
end
