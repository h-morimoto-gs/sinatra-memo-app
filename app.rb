# frozen_string_literal: true

require 'sinatra'
require 'pg'

configure do
  connection = PG.connect(dbname: 'memo_app')
  connection.field_name_type = :symbol
  set :db, connection
end

helpers do
  def db
    settings.db
  end

  def find_memo(id)
    db.exec_params('SELECT * FROM memos WHERE id = $1', [id]).first
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
  db.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2)', [params[:title], params[:content]])
  redirect '/memos'
end

get '/memos/:id' do
  @memo = find_memo(params[:id].to_i)
  halt 404 unless @memo
  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo(params[:id].to_i)
  halt 404 unless @memo
  erb :edit
end

patch '/memos/:id' do
  result = db.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3',
                          [params[:title], params[:content], params[:id].to_i])
  halt 404 if result.cmd_tuples.zero?
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  db.exec_params('DELETE FROM memos WHERE id = $1', [params[:id].to_i])
  redirect '/memos'
end
