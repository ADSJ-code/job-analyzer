namespace :job_importer do
  desc "Search for jobs via API and enrich company data"
  task find_and_enrich: :environment do
    puts "🤖 Starting Job Bot..."

    query = ENV.fetch('JOB_QUERY', 'Ruby on Rails developer')
    gl_location = ENV.fetch('JOB_LOCATION_GL', 'br')
    hl_language = ENV.fetch('JOB_LOCATION_HL', 'pt') # Language of the results, not the logs

    puts "--- Phase 1: Searching for '#{query}' jobs (Location: #{gl_location}, Language: #{hl_language})..."
    
    jobs_search_params = {
      q: query,
      engine: "google_jobs",
      gl: gl_location,
      hl: hl_language,
      api_key: ENV['SERPAPI_KEY']
    }
    
    # Assuming SerpApiSearch is a wrapper or the gem class available in your env
    jobs_search = SerpApiSearch.new(jobs_search_params)
    jobs_results = jobs_search.get_hash

    unless jobs_results[:jobs_results]
      puts "❌ No jobs found."
      next
    end

    puts "✅ Found #{jobs_results[:jobs_results].count} jobs. Starting enrichment..."

    jobs_results[:jobs_results].each do |job_data|
      apply_options = job_data[:apply_options]
      
      unless apply_options && !apply_options.empty?
        puts "⚠️ Job for '#{job_data[:company_name]}' has no application link. Skipping."
        next
      end
      
      job_url = apply_options.first[:link]

      job = Job.find_or_create_by(job_url: job_url) do |j|
        j.title = job_data[:title]
        j.company_name = job_data[:company_name]
        j.location = job_data[:location]
        j.description = job_data[:description]
      end

      puts "--- Enriching data for: #{job.company_name}"

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
        company_website: company_website || "Not found",
        company_logo_url: company_logo || "Not found"
      )

      puts "✅ Data for '#{job.company_name}' enriched."
    end

    puts "🏆 Process finished! Total of #{Job.count} jobs in the database."
  end
end