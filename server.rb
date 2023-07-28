require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'

get '/index' do
  File.open('index.html')
end

get '/pacientes' do
  File.open('list.html')
end

get '/resultados' do
  File.open('resultados.html')
end
# Endpoints
get '/data' do
  conn = PG.connect(dbname: 'teste', user: 'postgres', password: 'secret', host: 'rebase-data', port: '5432')
  sql_query = 'SELECT * FROM pacientes'

  begin
    result = conn.exec(sql_query)
    result.map(&:to_h).to_json
  rescue PG::Error => e
    puts "Não foi possível executar a query #{e.message}"
  end
end

get '/data/:token' do
  conn = PG.connect(dbname: 'teste', user: 'postgres', password: 'secret', host: 'rebase-data', port: '5432')
  sql_query = "SELECT * FROM pacientes WHERE token = '#{params[:token]}'"

  begin
    result = conn.exec(sql_query)
    result.map(&:to_h).to_a.each_with_object({}) do |data,hash|
      token = data['token']
        if hash.has_key?(token)
          hash[token]['testes'] << {
            'tipo_de_exame' => data['tipo_exame'],
            'limites' => data['limites_tipo_exame'],
            'resultado' => data['resultado']
          }
        else
          hash[token] = {
            'cpf' => data['cpf'],
            'paciente' => data['nome_paciente'],
            'email' => data['email_paciente'],
            'data_nascimento' => data['data_nascimento'],
            'endereco' => data['endereco'],
            'cidade' => data['cidade_paciente'],
            'estado' => data['estado'],
            'medico' => {
              'crm_medico' => data['crm_medico'],
              'crm_medico_estado' => data['crm_medico_estado'],
              'nome' => data['nome_medico'],
              'email' => data['email_medico']
            },
            'token' => data['token'],
            'data_exame' => data['data_exame'],
            'testes' => [{
              'tipo_de_exame' => data['tipo_exame'],
              'limites' => data['limites_tipo_exame'],
              'resultado' => data['resultado']
            }]
          }
        end
    end.to_json
  rescue PG::Error => e
    puts "Não foi possível executar a query #{e.message}"
  end
end

get '/tests' do
  rows = CSV.read('./data.csv', col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end.to_json
end

get '/hello' do
  'Hello world!'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
