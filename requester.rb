require 'htmlentities'
module Requester
  def select_main_menu_action
    # prompt the user for the "random | scores | exit" actions
  end

  def ask_question(result, index)
      html_entities = HTMLEntities.new
      array_answer = result[:incorrect_answers] << result[:correct_answer]
      decoded_string = html_entities.decode(result[:question])

      puts "Category: " + result[:category] + " | " + "Difficulty: " + result[:difficulty]
      puts "Question:" + decoded_string
      array_answer.shuffle!.each_with_index do |answer, index|
      puts "   #{index+1}. " + html_entities.decode(answer)
      end
      print "> "
      option = gets.chomp #controlar el error si lo deja en blanco o coloca un número que no esta en la lista de respuesta
      [array_answer,option]
    # show category and difficulty from question
    # show the question
    # show each one of the options
    # grab user input
  end

  def will_save?(score, filename)
    puts "Well done! Your score is: #{score}"
    # show user's score
    puts "--------------------------------------------------"
    puts "Do you want to save your score? (y/n)"
    respond = gets.chomp

    if File.exist?(filename)
      # El archivo existe
      # Aquí puedes realizar las operaciones que necesites con el archivo JSON
      array_score = JSON.load(File.read(filename))
    else
      # El archivo no existe
      cadena_json = JSON.pretty_generate(Array.new)
      array_score = []
    # Escribir la cadena JSON en un archivo
      File.open(filename, 'w') do |archivo|
      archivo.write(cadena_json)
      end

    end
    

    if respond == "y" || respond == "Y"
      puts  "Ingresa tu nombre: "
      print "> "
      name = gets.chomp

      name = "Anonymous" if name == ""
      x = {name: name, score: score}
     
      array_score << x #[nombre},{apellido},{nick}{j}]
      cadena_json = JSON.pretty_generate(array_score)
      
      # Escribir la cadena JSON en un archivo
      File.open(filename, 'w') do |archivo|
        archivo.write(cadena_json)
      end
    else
      puts "return to menu"
    end
    # ask the user to save the score
    # grab user input
    # prompt the user to give the score a name if there is no name given, set it as Anonymous
  end

  def gets_option(prompt, options)
    # prompt for an input
    # keep going until the user gives a valid option
  end
end
