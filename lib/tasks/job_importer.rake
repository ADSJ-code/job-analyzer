namespace :job_importer do
  desc "Busca por vagas de emprego e enriquece os dados das empresas"
  task find_and_enrich: :environment do
    puts "🤖 Iniciando o robô de vagas..."

    query = ENV.fetch('JOB_QUERY', 'Ruby on Rails developer')
    gl_location = ENV.fetch('JOB_LOCATION_GL', 'br')
    hl_language = ENV.fetch('JOB_LOCATION_HL', 'pt')

    puts "--- Fase 1: Procurando por vagas de '#{query}' (Local: #{gl_location}, Idioma: #{hl_language})..."
    
    jobs_search_params = {
      q: query,
      engine: "google_jobs",
      gl: gl_location,
      hl: hl_language,
      api_key: ENV['SERPAPI_KEY']
    }
    jobs_search = SerpApiSearch.new(jobs_search_params)
    jobs_results = jobs_search.get_hash

    unless jobs_results[:jobs_results]
      puts "❌ Nenhuma vaga encontrada."
      next
    end

    puts "✅ Encontradas #{jobs_results[:jobs_results].count} vagas. Iniciando enriquecimento..."

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

      company_search_params = {
        q: "#{job.company_name} official website logo",
        engine: 'google',
        gl: gl_location,
        hl: hl_language,
        api_key: ENV['SERPAPI_KEY']
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