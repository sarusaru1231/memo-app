# frozen_string_literal: true

class Memo
  attr_accessor :title, :content
  attr_reader :id

  def initialize(id, title, content)
    @id = id
    @title = title
    @content = content
  end

  def self.order(filename)
    file_content = File.open(filename, 'r') { |f| JSON.parse(f.read) }
    file_content.map { |params| Memo.new(params['id'], params['title'], params['content']) }
  end

  def self.calculate_id(filename)
    file_content = File.open(filename, 'r') { |f| JSON.parse(f.read) }
    (file_content.map { |params| params['id'].to_i }.max + 1).to_s
  end

  def self.load_content(filename, id)
    file_content = File.open(filename, 'r') { |f| JSON.parse(f.read) }
    result = file_content.find { |params| params['id'].eql?(id.to_s) }
    Memo.new(result['id'], result['title'], result['content']) unless result.nil?
  end

  def self.save_content(filename, memo)
    file_content = File.open(filename, 'r') { |f| JSON.parse(f.read) }
    result = file_content.find_index { |params| params['id'].eql?(memo.id.to_s) }
    if result.nil?
      new_memo = { 'id' => memo.id, 'title' => memo.title, 'content' => memo.content }
      file_content.push(new_memo)
    else
      file_content[result]['title'] = memo.title
      file_content[result]['content'] = memo.content
    end
    File.open(filename, 'w') { |f| JSON.dump(file_content, f) }
  end
end
