-- S&P 500 Analysis Schema

CREATE TABLE IF NOT EXISTS companies (
    exchange            VARCHAR(10),
    symbol              VARCHAR(10) PRIMARY KEY,
    shortname           VARCHAR(100),
    longname            VARCHAR(200),
    sector              VARCHAR(100),
    industry            VARCHAR(150),
    currentprice        NUMERIC(12, 4),
    marketcap           BIGINT,
    ebitda              BIGINT,
    revenuegrowth       NUMERIC(8, 4),
    city                VARCHAR(100),
    state               VARCHAR(50),
    country             VARCHAR(100),
    fulltimeemployees   INTEGER,
    longbusinesssummary TEXT,
    weight              NUMERIC(12, 10)
);

CREATE TABLE IF NOT EXISTS sp500_index (
    date    DATE PRIMARY KEY,
    sp500   NUMERIC(10, 2)
);

CREATE TABLE IF NOT EXISTS stocks (
    date        DATE,
    symbol      VARCHAR(10),
    adj_close   NUMERIC(12, 4),
    close       NUMERIC(12, 4),
    high        NUMERIC(12, 4),
    low         NUMERIC(12, 4),
    open        NUMERIC(12, 4),
    volume      BIGINT,
    PRIMARY KEY (date, symbol)
);
