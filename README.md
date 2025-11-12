# Job Analyzer

![Ruby](https://img.shields.io/badge/Ruby-3.3.3-CC342D.svg?style=for-the-badge&logo=ruby)
![Rails](https://img.shields.io/badge/Rails-8.0.2-D30001.svg?style=for-the-badge&logo=rubyonrails)
![MongoDB](https://img.shields.io/badge/MongoDB-4.7.1-47A248.svg?style=for-the-badge&logo=mongodb)
![Docker](https://img.shields.io/badge/Docker-20.10.21-2496ED.svg?style=for-the-badge&logo=docker)

## Summary

Job Analyzer is a full-stack Ruby on Rails application. Its core function is to consume the Google Jobs API (via SerpApi) to find job listings and then orchestrate additional API calls to enrich the hiring company's data, fetching information like official websites and logos.

This project demonstrates the ability to orchestrate multiple APIs and perform data enrichment, a key skill in data-driven application development.

---

## Tech Stack

* **Framework:** Ruby on Rails 8.0.2
* **Language:** Ruby 3.3.3
* **Database:** MongoDB (with Mongoid ODM)
* **External Data Source:** [SerpApi Google Jobs API](https://serpapi.com/) & [Google Search API](https://serpapi.com/)
* **Styling:** Pico.css
* **Environment:** Docker & Docker Compose

---

## How to Run

This project is fully containerized.

**1. Clone the Repository**
`git clone https://github.com/ADSJ-code/job-analyzer.git`

**2. Set Up Environment**
Navigate into the directory and create your `.env` file:
```bash
cd job-analyzer
cp .env.example .env