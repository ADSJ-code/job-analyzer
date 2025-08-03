class Job
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :company_name, type: String
  field :location, type: String
  field :description, type: String
  field :job_url, type: String
  field :company_logo_url, type: String
  field :company_website, type: String
end
