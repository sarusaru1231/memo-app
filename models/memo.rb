# frozen_string_literal: true

require 'pg'
require 'yaml'

class Memo
  attr_accessor :title, :content
  attr_reader :id

  def initialize(id, title, content)
    @id = id
    @title = title
    @content = content
  end

  def self.order
    connection = connect_database
    results = connection.exec('SELECT id, title, content FROM memos ORDER BY id')
    connection.finish
    results.map { |params| Memo.new(params['id'], params['title'], params['content']) }
  end

  def self.load_content(id)
    connection = connect_database
    result = connection.exec_params('SELECT id, title, content FROM memos where id = $1', [id])[0]
    connection.finish
    Memo.new(result['id'], result['title'], result['content']) unless result.nil?
  end

  def self.add_content(title, content)
    connection = connect_database
    id = connection.exec('SELECT max(id) FROM memos')[0]['max'].to_i + 1
    connection.exec_params('INSERT INTO memos VALUES ($1, $2, $3)', [id, title, content])
    connection.finish
    id
  end

  def self.save_content(id, title, content)
    connection = connect_database
    connection.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3',
                           [title, content, id])
    connection.finish
  end

  def self.destroy_content(id)
    connection = connect_database
    connection.exec_params('DELETE FROM memos WHERE id = $1', [id])
    connection.finish
  end

  def self.connect_database
    db_config = YAML.load_file('./config/database.yml')['db']['development']
    PG.connect(db_config)
  end

  private_class_method :connect_database
end
