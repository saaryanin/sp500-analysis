-- Analytical views for Tableau dashboards

-- 1. Sector summary: market cap, avg revenue growth, avg EBITDA per sector
CREATE OR REPLACE VIEW vw_sector_summary AS
SELECT
    sector,
    COUNT(*)                            AS company_count,
    SUM(marketcap)                      AS total_marketcap,
    AVG(revenuegrowth)                  AS avg_revenuegrowth,
    AVG(ebitda)                         AS avg_ebitda,
    SUM(fulltimeemployees)              AS total_employees
FROM companies
WHERE sector IS NOT NULL
GROUP BY sector
ORDER BY total_marketcap DESC;


-- 2. Top companies by market cap with sector info (for treemap / ranked list)
CREATE OR REPLACE VIEW vw_companies_enriched AS
SELECT
    symbol,
    shortname,
    sector,
    industry,
    currentprice,
    marketcap,
    ebitda,
    revenuegrowth,
    fulltimeemployees,
    weight,
    city,
    state,
    country
FROM companies
WHERE sector IS NOT NULL;


-- 3. S&P 500 index with year and month columns (for time series in Tableau)
CREATE OR REPLACE VIEW vw_index_timeseries AS
SELECT
    date,
    sp500,
    EXTRACT(YEAR FROM date)             AS year,
    EXTRACT(MONTH FROM date)            AS month,
    AVG(sp500) OVER (
        ORDER BY date
        ROWS BETWEEN 49 PRECEDING AND CURRENT ROW
    )                                   AS ma_50,
    AVG(sp500) OVER (
        ORDER BY date
        ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
    )                                   AS ma_200
FROM sp500_index;


-- 4. Stock performance: yearly return per stock with sector info
CREATE OR REPLACE VIEW vw_stock_yearly_performance AS
SELECT
    s.symbol,
    c.shortname,
    c.sector,
    c.industry,
    EXTRACT(YEAR FROM s.date)           AS year,
    FIRST_VALUE(s.close) OVER w         AS open_price,
    LAST_VALUE(s.close) OVER w          AS close_price,
    ROUND(
        ((LAST_VALUE(s.close) OVER w - FIRST_VALUE(s.close) OVER w)
        / NULLIF(FIRST_VALUE(s.close) OVER w, 0) * 100)::NUMERIC
    , 2)                                AS yearly_return_pct
FROM stocks s
JOIN companies c ON s.symbol = c.symbol
WHERE s.close IS NOT NULL
WINDOW w AS (
    PARTITION BY s.symbol, EXTRACT(YEAR FROM s.date)
    ORDER BY s.date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
);


-- 5. Latest price + 52-week high/low per stock
CREATE OR REPLACE VIEW vw_stock_snapshot AS
SELECT
    s.symbol,
    c.shortname,
    c.sector,
    c.currentprice,
    c.marketcap,
    c.weight,
    MAX(s.high)  AS week52_high,
    MIN(s.low)   AS week52_low
FROM stocks s
JOIN companies c ON s.symbol = c.symbol
WHERE s.date >= (SELECT MAX(date) - INTERVAL '52 weeks' FROM stocks)
GROUP BY s.symbol, c.shortname, c.sector, c.currentprice, c.marketcap, c.weight;
