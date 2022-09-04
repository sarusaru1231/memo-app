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
    file_content = load_json_file(filename)
    file_content.map { |params| Memo.new(params['id'], params['title'], params['content']) }
  end

  def self.calculate_id(filename)
    file_content = load_json_file(filename)
    file_content.empty? ? '1' : (file_content.map { |params| params['id'].to_i }.max + 1).to_s
  end

  def self.load_content(filename, id)
    file_content = load_json_file(filename)
    result = file_content.find { |params| params['id'].eql?(id.to_s) }
    Memo.new(result['id'], result['title'], result['content']) unless result.nil?
  end

  def self.save_content(filename, memo)
    file_content = load_json_file(filename)
    result = file_content.find_index { |params| params['id'].eql?(memo.id.to_s) }
    if result.nil?
      new_memo = { 'id' => memo.id, 'title' => memo.title, 'content' => memo.content }
      file_content.push(new_memo)
    else
      file_content[result]['title'] = memo.title
      file_content[result]['content'] = memo.content
    end
    save_json_file(file_content, filename)
  end

  def self.destroy_content(filename, memo)
    file_content = load_json_file(filename)
    result = file_content.find_index { |params| params['id'].eql?(memo.id.to_s) }
    file_content.delete_at(result)
    save_json_file(file_content, filename)
  end

  def self.load_json_file(filename)
    File.open(filename, 'r') do |f|
      f.flock(File::LOCK_SH)
      JSON.parse(f.read)
    end
  end

  def self.save_json_file(file_content, filename)
    File.open(filename, 'w') do |f|
      f.flock(File::LOCK_EX)
      JSON.dump(file_content, f)
    end
  end
  private_class_method :load_json_file, :save_json_file
end
