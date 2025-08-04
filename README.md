# Job Analyzer

![Ruby](https://img.shields.io/badge/Ruby-3.3.3-CC342D.svg?style=for-the-badge&logo=ruby)
![Rails](https://img.shields.io/badge/Rails-8.0.2-D30001.svg?style=for-the-badge&logo=rubyonrails)
![MongoDB](https://img.shields.io/badge/MongoDB-4.7.1-47A248.svg?style=for-the-badge&logo=mongodb)
![Docker](https://img.shields.io/badge/Docker-20.10.21-2496ED.svg?style=for-the-badge&logo=docker)

## Sumário

O Job Analyzer é uma aplicação web full-stack desenvolvida em Ruby on Rails. A sua função principal é consumir a API do Google Jobs (através da SerpApi) para buscar vagas de emprego e, em seguida, orquestrar chamadas de API adicionais para enriquecer os dados das empresas contratantes, buscando informações como o website oficial e o logo.

Este projeto foi construído para demonstrar a capacidade de orquestração de múltiplas APIs e o enriquecimento de dados, uma competência chave no desenvolvimento de aplicações orientadas a dados.

---

## Stack de Tecnologias

* **Framework:** Ruby on Rails 8.0.2
* **Linguagem:** Ruby 3.3.3
* **Banco de Dados:** MongoDB, com Mongoid ODM
* **Fonte de Dados Externos:** [SerpApi Google Jobs API](https://serpapi.com/) & [Google Search API](https://serpapi.com/)
* **Estilo Visual:** Pico.css
* **Ambiente de Desenvolvimento:** Docker

---

## Utilização

### 1. Importação e Enriquecimento de Dados
Para popular o banco de dados com as vagas de emprego, execute a Rake task:
```bash
bin/rails job_importer:find_and_enrich
```

### 2. Iniciar a Aplicação
Com os dados no banco, inicie o servidor Rails:
```bash
bin/rails server
```
Acesse a aplicação no seu navegador em `http://localhost:3000/jobs`.