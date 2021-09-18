# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi'
require_relative './models/memo'

JSON_FILENAME = 'db/memos.json'

helpers do
  def submit(str)
    "<button type=\"submit\" class=\"btn btn-primary\">#{str}</button>"
  end

  def h(text)
    escape_html(text)
  end
end

not_found do
  erb :page404
end

get '/' do
  @title = 'Memo 一覧'
  @memos = Memo.order(JSON_FILENAME)
  erb :index
end

get '/memos/new' do
  @title = 'Memo 新規作成'
  @submit = submit('作成する')
  erb :create
end

post '/memos/new' do
  id = Memo.calculate_id(JSON_FILENAME)
  Memo.save_content(JSON_FILENAME, Memo.new(id, params[:title], params[:content]))
  redirect to "/memos/#{id}"
end

get '/memos/:id' do
  @memo = Memo.load_content(JSON_FILENAME, params[:id])
  if @memo.nil?
    redirect to not_found
  else
    @title = 'Memo 詳細'
    @edit_link = "/memos/#{params[:id]}/edit"
    erb :detail
  end
end

patch '/memos/:id/edit' do
  Memo.save_content(JSON_FILENAME, Memo.new(params[:id], params[:title], params[:content]))
  redirect to "/memos/#{params[:id]}"
end

get '/memos/:id/edit' do
  @memo = Memo.load_content(JSON_FILENAME, params[:id])
  if @memo.nil?
    redirect to not_found
  else
    @title = 'Memo 編集'
    @submit = submit('保存する')
    erb :edit
  end
end
