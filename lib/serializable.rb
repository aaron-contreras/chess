# frozen_string_literal: true

# Require the serializer currently set
require 'json'

module Serializable
  EXTENSION = 'json'
  SERIALIZER = JSON
  SAVED_GAMES_DIRECTORY = './saved_games'

  def serialize
    game_data = instance_variables.reduce({}) do |hash, variable|
      hash[variable] = instance_variable_get(variable)
      hash
    end 

    SERIALIZER.dump(game_data)
  end

  def deserialize(string)
    object = SERIALIZER.parse(string)
    object.each do |key, value|
      instance_variable_set(key, value)
    end
  end

  def check_for_saved_games_directory
    Dir.mkdir(SAVED_GAMES_DIRECTORY) unless Dir.exist?(SAVED_GAMES_DIRECTORY)
  end

  def save_to_file(game_name)
    check_for_saved_games_directory
    path = "#{SAVED_GAMES_DIRECTORY}/#{game_name}.#{EXTENSION}"
    File.open(path, 'w') { |file| file.puts serialize}
  end

  def game_list
    check_for_saved_games_directory
    list = Dir.glob("#{SAVED_GAMES_DIRECTORY}/*.json").to_h { |filename| [filename, filename] }
  end
end