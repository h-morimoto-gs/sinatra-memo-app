# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'securerandom'

MEMOS_FILE = 'data/memos.json'

helpers do
  def load_memos
    JSON.parse(File.read(MEMOS_FILE))
  end

  def save_memos(memos)
    File.write(MEMOS_FILE, JSON.pretty_generate(memos))
  end

  def find_memo(id)
    load_memos.find { |memo| memo['id'] == id }
  end

  def display_title(title)
    title.to_s.empty? ? '(無題)' : title
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end
end

not_found do
  erb :not_found
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = load_memos
  memos << {
    'id' => SecureRandom.uuid,
    'title' => params[:title],
    'content' => params[:content]
  }
  save_memos(memos)
  redirect '/memos'
end

get '/memos/:id' do
  @memo = find_memo(params[:id])
  halt 404 unless @memo
  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo(params[:id])
  halt 404 unless @memo
  erb :edit
end

patch '/memos/:id' do
  memos = load_memos
  memo = memos.find { |m| m['id'] == params[:id] }
  halt 404 unless memo
  memo['title'] = params[:title]
  memo['content'] = params[:content]
  save_memos(memos)
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = load_memos.reject { |memo| memo['id'] == params[:id] }
  save_memos(memos)
  redirect '/memos'
end
