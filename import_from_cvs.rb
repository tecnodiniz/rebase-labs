require 'csv'
require 'pg'

rows = CSV.read('./data.csv', col_sep: ';')

columns = rows.shift

datas = rows.map do |row|
  row.each_with_object({}).with_index do |(cell, acc), idx|
    column = columns[idx]
    acc[column] = cell
  end
end

conn = PG.connect(dbname: 'teste', user: 'postgres', password: 'secret', host: 'rebase-data', port: '5432')

begin
  conn.exec(<<~SQL)
    DROP TABLE IF EXISTS pacientes
  SQL
rescue PG::Error => e
  put "Não foi possível dropar tabela #{e.message}"
end

begin
  conn.exec(<<~SQL)
    CREATE TABLE pacientes (
      id SERIAL PRIMARY KEY,
      cpf VARCHAR NOT NULL,
      cidade_paciente VARCHAR NOT NULL,
      crm_medico VARCHAR NOT NULL,
      crm_medico_estado VARCHAR NOT NULL,
      data_exame DATE NOT NULL,
      data_nascimento DATE NOT NULL,
      email_medico VARCHAR NOT NULL,
      email_paciente VARCHAR NOT NULL,
      endereco VARCHAR NOT NULL,
      estado VARCHAR NOT NULL,
      limites_tipo_exame VARCHAR NOT NULL,
      nome_medico VARCHAR NOT NULL,
      nome_paciente VARCHAR NOT NULL,
      resultado VARCHAR NOT NULL,
      tipo_exame VARCHAR NOT NULL,
      token VARCHAR NOT NULL
    );
  SQL
rescue PG::Error => e
  puts "Erro ao criar tabela #{e.message}"
end

datas.each do |row|
  conn.exec_params('INSERT INTO pacientes (cpf, cidade_paciente, crm_medico,
                                            crm_medico_estado, data_exame, data_nascimento, email_medico, email_paciente,
                                            endereco, estado, limites_tipo_exame, nome_medico, nome_paciente, resultado,
                                            tipo_exame, token) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16)',
                   [row['cpf'], row['cidade paciente'], row['crm médico'], row['crm médico estado'], row['data exame'],
                    row['data nascimento paciente'], row['email médico'], row['email paciente'], row['endereço/rua paciente'],
                    row['estado patiente'], row['limites tipo exame'], row['nome médico'], row['nome paciente'],
                    row['resultado tipo exame'], row['tipo exame'], row['token resultado exame']])
end

puts 'dados importados para o banco de dados'
conn.close
