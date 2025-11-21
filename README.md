# Job Analyzer

![Ruby](https://img.shields.io/badge/Ruby-3.3.3-CC342D.svg?style=for-the-badge&logo=ruby)
![Rails](https://img.shields.io/badge/Rails-8.0.2-D30001.svg?style=for-the-badge&logo=rubyonrails)
![MongoDB](https://img.shields.io/badge/MongoDB-4.7.1-47A248.svg?style=for-the-badge&logo=mongodb)
![Docker](https://img.shields.io/badge/Docker-20.10.21-2496ED.svg?style=for-the-badge&logo=docker)

## 1. Executive Summary

Job Analyzer is a full-stack Ruby on Rails application designed to demonstrate **API Orchestration** and **Data Enrichment**.

Instead of simply displaying raw data, the system consumes the Google Jobs API (via SerpApi) to find job listings and then automatically triggers secondary API calls to fetch enrichment data—such as official company websites and high-resolution logos—persisting the enhanced results in a NoSQL database (MongoDB).

The project has been fully refactored for production-grade portability using **Docker Multi-Stage builds**.

---

## 2. Tech Stack

* **Core:** Ruby 3.3.3 / Rails 8.0.2 (API Mode Logic)

* **Database:** MongoDB (via Mongoid ODM) - Chosen for flexible schema handling of external API JSON data.

* **Integration:** [SerpApi](https://serpapi.com/) (Google Jobs & Google Search APIs).

* **Infrastructure:** Docker & Docker Compose (Nginx + Puma).

* **Styling:** Pico.css (Semantic & Minimalist).

---

## 3. Key Features

* **API Orchestration:** Handles dependent API requests where the output of one service (Jobs) drives the input of another (Search for Logos/Links).

* **NoSQL Persistence:** Utilizes MongoDB to store unstructured job metadata efficiently.

* **Containerized Environment:** Runs completely isolated via Docker, requiring no local Ruby or Mongo installation.

* **Clean Architecture:** Service objects handle external API communication, keeping controllers thin.

---

## 4. How to Run

Prerequisites: **Docker Desktop** installed and running.

**1. Clone the Repository and navigate**
```bash
git clone https://github.com/ADSJ-code/job-analyzer.git
```

and 

```bash
cd job-analyzer
```
2. Configure Environment Variables Create the .env file from the template:

```bash
cp .env.example .env
```
**Critical Step**: Open the .env file and paste your SerpApi Key (free tier is sufficient): SERPAPI_KEY=your_api_key_here

3. Build and Run Execute the complete environment with a single command:

```bash
docker-compose up --build
```

4. Access the Application Once the terminal shows "Listening on...", open your browser:

URL: http://localhost:3000

### 5. Project Structure
app/services/: Contains the core logic for API communication (SerpApiService).

app/models/: Mongoid documents (Job, Company).

docker-compose.yml: Orchestrates the Web and Database services.

Dockerfile: Multi-stage build configuration for optimized image size.