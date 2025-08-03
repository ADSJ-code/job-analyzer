# Job Analyzer

![Ruby](https://img.shields.io/badge/Ruby-3.3.3-CC342D.svg?style=for-the-badge&logo=ruby)
![Rails](https://img.shields.io/badge/Rails-8.0.2-D30001.svg?style=for-the-badge&logo=rubyonrails)
![MongoDB](https://img.shields.io/badge/MongoDB-4.7.1-47A248.svg?style=for-the-badge&logo=mongodb)
![Docker](https://img.shields.io/badge/Docker-20.10.21-2496ED.svg?style=for-the-badge&logo=docker)

## Sumário

O Job Analyzer é uma aplicação web full-stack desenvolvida em Ruby on Rails. A sua função principal é consumir a API do Google Jobs (através da SerpApi) para buscar vagas de emprego e, em seguida, orquestrar chamadas de API adicionais para enriquecer os dados das empresas contratantes, buscando informações como o website oficial e o logo.

Este projeto foi construído para demonstrar a capacidade de orquestração de múltiplas APIs e o enriquecimento de dados, uma competência chave no desenvolvimento de aplicações orientadas a dados.

---

## Arquitetura do Sistema

A aplicação utiliza uma Rake task para o processo de ingestão e enriquecimento de dados. A tarefa opera em duas fases:
1.  **Busca:** Uma chamada inicial à API do Google Jobs da SerpApi para obter uma lista de vagas.
2.  **Enriquecimento:** Para cada vaga retornada, uma segunda chamada à API de Busca Google da SerpApi é realizada para obter dados do Knowledge Graph da empresa, como website e imagens.

Os dados consolidados são persistidos numa base de dados MongoDB, e a interface web, construída com o padrão MVC do Rails, serve para exibir os resultados finais ao utilizador.

---

## Stack de Tecnologias

* **Framework:** Ruby on Rails 8.0.2
* **Linguagem:** Ruby 3.3.3
* **Banco de Dados:** MongoDB, com Mongoid ODM
* **Fonte de Dados Externos:** [SerpApi Google Jobs API](https://serpapi.com/) & [Google Search API](https://serpapi.com/)
* **Estilo Visual:** Pico.css
* **Ambiente de Desenvolvimento:** Docker (para o serviço MongoDB)

---

## Pré-requisitos

Para executar este projeto localmente, certifique-se de que possui:
* Ruby (gerenciado via `rbenv` ou similar)
* Bundler
* Docker Desktop
* Uma chave de API da [SerpApi](https://serpapi.com/)

---

## Configuração e Instalação

Siga os passos abaixo para configurar o ambiente de desenvolvimento.

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/ADSJ-code/job-analyzer.git](https://github.com/ADSJ-code/job-analyzer.git)
    ```

2.  **Navegue para o diretório do projeto:**
    ```bash
    cd job-analyzer
    ```

3.  **Instale as dependências do Ruby:**
    ```bash
    bundle install
    ```

4.  **Configure as credenciais:**
    Execute o comando abaixo para abrir o editor de credenciais do Rails:
    ```bash
    bin/rails credentials:edit
    ```
    Insira sua chave da SerpApi no seguinte formato e salve o arquivo:
    ```yaml
    serpapi:
      api_key: "SUA_CHAVE_DA_SERPAPI_AQUI"
    ```

5.  **Inicie o serviço do MongoDB via Docker:**
    ```bash
    docker run --name mongodb -d -p 27017:27017 mongo
    ```

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