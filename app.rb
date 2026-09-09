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

  def h(text)
    Rack::Utils.escape_html(text)
  end
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
  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo(params[:id])
  erb :edit
end

patch '/memos/:id' do
  memos = load_memos
  memo = memos.find { |m| m['id'] == params[:id] }
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