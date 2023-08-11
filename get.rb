require "httparty"
require "json"
require 'htmlentities'
require "terminal-table"


class Rossio
include HTTParty

table = Terminal::Table.new
table.title = "Top score"
table.headings = ["name", "score"]
array_score = JSON.load(File.read("arreglo.json"))
array_score = array_score.sort_by { |item| item["score"] }.reverse
array_new = []
array_score.each do |score|
 array_new << [score["name"],score["score"].to_s]
end

table.rows = array_new

puts table

response = get("https://opentdb.com/api.php?amount=2")
random = JSON.parse(response.body, symbolize_names: true)

html_entities = HTMLEntities.new
score = 0
  random[:results].each_with_index do |result, index|
    array_answer = result[:incorrect_answers] << result[:correct_answer]
    decoded_string = html_entities.decode(result[:question])
    puts "#{index+1}. " + decoded_string
    array_answer.shuffle!.each_with_index do |answer, index|
      puts "   #{index+1}. " + html_entities.decode(answer)
    end
    print ">"
    option = gets.chomp #controlar el error si lo deja en blanco o coloca un número que no esta en la lista de respuesta
  
    if array_answer[option.to_i-1] == result[:correct_answer]
      puts "correct answer"
      score += 10
    else
      puts "incorrect answer"
    end
  end
  puts "Tu score total es #{score}"
  array_score = JSON.load(File.read("arreglo.json"))
  puts "deseas guardar tu score"
  respond = gets.chomp
  if respond == "y"
    print "Ingresa tu nombre"
    name = gets.chomp
    x = {name: name, score: score}
    array_score << x
    cadena_json = JSON.pretty_generate(array_score)
    # Escribir la cadena JSON en un archivo
    File.open('arreglo.json', 'w') do |archivo|
      archivo.write(cadena_json)
    end
  else
    puts "return to menu"
  end
  
end 

