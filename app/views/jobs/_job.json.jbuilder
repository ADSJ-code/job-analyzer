json.extract! job, :id, :title, :company_name, :location, :description, :job_url, :company_logo_url, :company_website, :created_at, :updated_at
json.url job_url(job, format: :json)
