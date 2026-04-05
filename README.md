# S&P 500 Analysis

A personal project to relearn SQL and learn Tableau from scratch — building a full data pipeline from raw dataset to published interactive dashboards, with a focus on understanding every step along the way.

## Dashboards

Live on Tableau Public:

| # | Dashboard | Description |
|---|-----------|-------------|
| 1 | [Market Cap by Sector](https://public.tableau.com/app/profile/saar.yanin/viz/tableau_dashboards/MarketCapbySector?publish=yes) | Total market cap breakdown across S&P 500 sectors |
| 2 | [Market Cap by Company](https://public.tableau.com/app/profile/saar.yanin/viz/tableau_dashboards/MarketCapbyCompany?publish=yes) | Treemap of top companies by market cap |
| 3 | [Historical Performance](https://public.tableau.com/app/profile/saar.yanin/viz/tableau_dashboards/SP500HistoricalPerformance?publish=yes) | S&P 500 index time series with COVID crash annotation |
| 4 | [Sector Returns Heatmap](https://public.tableau.com/app/profile/saar.yanin/viz/tableau_dashboards/SectorReturnsHeatmap?publish=yes) | Yearly return % per sector from 2010–2024 |
| 5 | [52-Week Price Range](https://public.tableau.com/app/profile/saar.yanin/viz/tableau_dashboards/52-WeekPriceRange?publish=yes) | Dot plot showing each stock's position within its 52-week high/low range |

## Stack

- **PostgreSQL** — data storage and analytical views
- **Python** — data loading and CSV exports (pandas, SQLAlchemy)
- **Tableau Desktop / Tableau Public** — dashboards

## Dataset

[S&P 500 Stocks — Kaggle](https://www.kaggle.com/datasets/andrewmvd/sp-500-stocks) by andrewmvd.

Three files:
- `sp500_companies.csv` — company info: sector, industry, market cap, revenue growth, EBITDA, employees
- `sp500_stocks.csv` — daily OHLCV price data per stock (2010–2024, ~1.9M rows)
- `sp500_index.csv` — daily S&P 500 index level

## Project Structure

```
sp500-analysis/
├── dataset/          # Raw CSV files (from Kaggle)
├── sql/
│   ├── schema.sql    # Table definitions
│   └── views.sql     # Analytical views used by Tableau
├── src/
│   ├── load_data.py  # Loads CSVs into PostgreSQL
│   └── export_views.py # Exports views to CSV for Tableau
├── exports/          # Generated CSVs connected to Tableau
└── tableau/
    └── tableau_dashboards.twbx
```

## Setup

1. Create a PostgreSQL database and set the connection string in a `.env` file:
   ```
   DB_URL=postgresql://user:password@localhost:5432/sp500
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Load the data:
   ```bash
   python src/load_data.py
   ```

4. Apply the schema and views from `sql/schema.sql` and `sql/views.sql` in your SQL client.

5. Export views to CSV for Tableau:
   ```bash
   python src/export_views.py
   ```
