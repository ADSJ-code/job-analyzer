# Job Analyzer

![Ruby](https://img.shields.io/badge/Ruby-3.3.3-CC342D.svg?style=for-the-badge&logo=ruby)
![Rails](https://img.shields.io/badge/Rails-8.0.2-D30001.svg?style=for-the-badge&logo=rubyonrails)
![MongoDB](https://img.shields.io/badge/MongoDB-4.7.1-47A248.svg?style=for-the-badge&logo=mongodb)
![Docker](https://img.shields.io/badge/Docker-20.10.21-2496ED.svg?style=for-the-badge&logo=docker)

## 1. Executive Summary

Job Analyzer is a full-stack Ruby on Rails application designed to demonstrate **API Orchestration** and **Data Enrichment**.

Instead of simply displaying raw data, the system consumes the **Google Jobs API** (via SerpApi) to find job listings and automatically triggers secondary API calls to fetch enrichment data—such as official company websites and high-resolution logos—persisting the results in a NoSQL database (**MongoDB**).

The project is fully containerized and includes an automated "Job Bot" that fetches data upon startup.

---

## 2. Tech Stack

* **Core:** Ruby 3.3.3 / Rails 8.0.2

* **Database:** MongoDB (via Mongoid ODM) - Chosen for flexible schema handling of external API JSON data.

* **Integration:** [SerpApi](https://serpapi.com/) (Google Jobs & Google Search APIs).

* **Infrastructure:** Docker & Docker Compose (Puma).

* **Styling:** Pico.css (Semantic & Minimalist).

---

## 3. Key Features

* **API Orchestration:** Handles dependent API requests where the output of one service (Jobs) drives the input of another (Search for Logos/Links).

* **Automated Data Fetching:** A background bot fetches and updates job listings automatically.

* **NoSQL Persistence:** Utilizes MongoDB to store unstructured job metadata efficiently.

* **Dockerized:** Runs completely isolated via Docker Multi-Stage builds.

---

## 4. How to Run (Quick Setup)

Prerequisites: **Docker Desktop** installed.

**1. Clone the Repository**

```bash
git clone https://github.com/ADSJ-code/job-analyzer.git
```

**2. Configure Environment Variables Create the .env file from the template:**

```Bash
cd job-analyzer
```

and

```Bash
cp .env.example .env
```
**⚠️ CRITICAL STEP**: Open the .env file and paste your SerpApi Key. You can get a free key at SerpApi.com.

SERPAPI_KEY=your_api_key_here

**3. Build and Run Execute the environment. The "Job Bot" will run automatically on the first boot to populate the database.**

```bash
docker-compose up --build
```

**4. Access the Application Once the terminal shows "Listening on...", open your browser:**

URL: http://localhost:3000

## 5. Controlling the Job Bot (Manual Trigger)

The system is designed to auto-import jobs when the container starts. However, if you wish to force a new search or fetch fresh data without restarting the server, you can trigger the bot manually via the terminal.

**Run the Importer Command**: (Run this in a new terminal window inside the project folder)

```bash
docker-compose exec web bin/rails job_importer:find_and_enrich
```

**Customizing the Search**: You can also override the default search parameters (Location/Query) on the fly:

```bash
docker-compose exec -e JOB_QUERY="Python Developer" -e JOB_LOCATION_GL="us" web bin/rails job_importer:find_and_enrich
```

## 6. Project Structure

lib/tasks/job_importer.rake: The "Robot" logic. It orchestrates the API calls to SerpApi and saves data to MongoDB.

app/models/: Mongoid documents (Job).

docker-compose.yml: Orchestrates the Web and Database services.

Dockerfile: Multi-stage build configuration for optimized image size.