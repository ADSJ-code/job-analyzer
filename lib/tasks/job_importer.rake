# lib/tasks/job_importer.rake

namespace :job_importer do
  desc "Busca por vagas de emprego e enriquece os dados das empresas"
  task find_and_enrich: :environment do
    puts "🤖 Iniciando o robô de vagas..."

    # Fase 1: Buscar Vagas
    puts "--- Fase 1: Procurando por vagas de 'Ruby on Rails developer'..."
    jobs_search_params = {
      q: "Ruby on Rails developer",
      engine: "google_jobs",
      api_key: Rails.application.credentials.serpapi[:api_key]
    }
    jobs_search = SerpApiSearch.new(jobs_search_params)
    jobs_results = jobs_search.get_hash

    unless jobs_results[:jobs_results]
      puts "❌ Nenhuma vaga encontrada."
      next
    end

    puts "✅ Encontradas #{jobs_results[:jobs_results].count} vagas. Iniciando enriquecimento..."

    # Fase 2: Enriqueçer Cada Vaga
    jobs_results[:jobs_results].each do |job_data|
      apply_options = job_data[:apply_options]
      unless apply_options && !apply_options.empty?
        puts "⚠️ Vaga para '#{job_data[:company_name]}' sem link de candidatura. A pular."
        next
      end
      job_url = apply_options.first[:link]

      job = Job.find_or_create_by(job_url: job_url) do |j|
        j.title = job_data[:title]
        j.company_name = job_data[:company_name]
        j.location = job_data[:location]
        j.description = job_data[:description]
      end

      puts "--- enriquecendo dados para: #{job.company_name}"

      # ## CORREÇÃO FINALÍSSIMA AQUI ##
      company_search_params = {
        q: "#{job.company_name} official website logo",
        engine: 'google', # Adicionamos o engine para a busca da empresa
        api_key: Rails.application.credentials.serpapi[:api_key]
      }
      company_search = SerpApiSearch.new(company_search_params)
      company_results = company_search.get_hash

      company_website = company_results.dig(:knowledge_graph, :website)
      company_logo = company_results.dig(:knowledge_graph, :header_images, 0, :image)

      job.update(
        company_website: company_website || "Não encontrado",
        company_logo_url: company_logo || "Não encontrado"
      )

      puts "✅ Dados de '#{job.company_name}' enriquecidos."
    end

    puts "🏆 Processo concluído! Total de #{Job.count} vagas na base de dados."
  end
end