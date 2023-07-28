const url = "http://localhost:3000/data"

const fragment = new DocumentFragment()

fetch(url)
  .then(response => response.json())
  .then(data => {
    data.forEach(person =>{
      const tr = document.createElement('tr')
      tr.innerHTML = `
        <td>${person.id}</td>
        <td>${person.cpf}</td>
        <td>${person.cidade_paciente}</td>
        <td>${person.data_exame}</td>
        <td>${person.data_nascimento}</td>
        <td>${person.email_paciente}</td>
        <td>${person.endereco}</td>
        <td>${person.estado}</td>
        <td>${person.limites_tipo_exame}</td>
        <td>${person.nome_paciente}</td>
        <td>${person.resultado}</td>
        <td>${person.tipo_exame}</td>
        <td>${person.token}</td>
      `
      fragment.appendChild(tr)
    })
  }).then(()=>{
    document.getElementById('table').getElementsByTagName('tbody')[0].appendChild(fragment)
  })
  .catch(function(error) {
    console.log(error);
  });

getResults = () => {
  search = document.getElementById('search');
  const token = search.value
  fetch(`${url}/${search.value}`)
  .then(response => response.json())
  .then(data => {
    
    obj = data[token]
    obj != undefined ? alert('resultados encontrados') : alert('não foi possível encontrar dados pelo token fornecido'); 

    document.getElementById('results').innerHTML =`
    <h2>Paciente: ${obj.paciente}</h2>
    <p>CPF: ${obj.cpf}</p>
    <p>Data do exame: ${obj.data_exame}</p>
    <p>Email: ${obj.email}</p>
    <address>
      <p>Endereço: ${obj.endereco}</p>
      <p>Cidade: ${obj.cidade}</p>
      <p>Estado: ${obj.estado}</p>
    </adress>

    <h3>Médico responsável: ${obj.medico.nome}</h3>
    <p>Email: ${obj.medico.email}</p>
    <p>CRM: ${obj.medico.crm_medico}</p>
    <p>CRM Estado: ${obj.medico.crm_medico_estado}</p>
    `
    frag = new DocumentFragment()
    obj.testes.forEach(teste =>{
      const tr = document.createElement('tr')
      tr.innerHTML = `
        <td>${teste.tipo_de_exame}</td>
        <td>${teste.limites}</td>
        <td>${teste.resultado}</td>
      `
      frag.appendChild(tr)
    })
    document.getElementById('table-results').getElementsByTagName('tbody')[0].appendChild(frag)
  })
  .catch(function(error){
    console.log(error);
  })
}