# frozen_string_literal: true

require 'sinatra'
require 'fileutils'
require 'json'
require 'pg'
require 'securerandom'

MEMOS_FILE = 'data/memos.json'

configure do
  connection = PG.connect(dbname: 'memo_app')
  connection.field_name_type = :symbol
  set :db, connection
end

helpers do
  def db
    settings.db
  end

  def load_memos
    return [] unless File.exist?(MEMOS_FILE)

    JSON.parse(File.read(MEMOS_FILE), symbolize_names: true)
  end

  def save_memos(memos)
    FileUtils.mkdir_p(File.dirname(MEMOS_FILE))
    File.write(MEMOS_FILE, JSON.pretty_generate(memos))
  end

  def find_memo(id, memos = load_memos)
    memos.find { |memo| memo[:id] == id }
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
  @memos = db.exec('SELECT id, title FROM memos ORDER BY id')
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = load_memos
  memos << {
    id: SecureRandom.uuid,
    title: params[:title],
    content: params[:content]
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
  memo = find_memo(params[:id], memos)
  halt 404 unless memo
  memo[:title] = params[:title]
  memo[:content] = params[:content]
  save_memos(memos)
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = load_memos.reject { |memo| memo[:id] == params[:id] }
  save_memos(memos)
  redirect '/memos'
end
