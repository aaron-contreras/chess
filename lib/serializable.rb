# frozen_string_literal: true

# Require the serializer currently set
require 'oj'

# Module for serializing and deserializing a game
module Serializable
  EXTENSION = 'json'
  SERIALIZER = Oj
  SAVED_GAMES_DIRECTORY = './saved_games'

  def deserialize(string)
    recovered_client = Oj.load(string)
    recovered_client.instance_variables.each do |var|
      instance_variable_set(var, recovered_client.instance_variable_get(var))
    end
  end

  def check_for_saved_games_directory
    Dir.mkdir(SAVED_GAMES_DIRECTORY) unless Dir.exist?(SAVED_GAMES_DIRECTORY)
  end

  def save_to_file(game_name)
    check_for_saved_games_directory
    path = "#{SAVED_GAMES_DIRECTORY}/#{game_name}.#{EXTENSION}"
    File.open(path, 'w') { |file| file.puts Oj.dump(self) }
  end

  def game_list
    check_for_saved_games_directory
    list = Dir.glob("#{SAVED_GAMES_DIRECTORY}/*.json").to_h { |filename| [filename, filename] }
  end
end
