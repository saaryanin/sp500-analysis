import os
import pandas as pd
from sqlalchemy import create_engine, text
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()
DB_URL = os.getenv("DB_URL")
DATASET_DIR = Path(__file__).parent.parent / "dataset"
CHUNK_SIZE = 50_000


def get_engine():
    return create_engine(DB_URL)


def load_companies(engine):
    df = pd.read_csv(DATASET_DIR / "sp500_companies.csv")
    df.columns = df.columns.str.lower().str.replace(" ", "_")
    df.to_sql("companies", engine, if_exists="replace", index=False)
    print(f"Loaded {len(df)} companies")


def load_index(engine):
    df = pd.read_csv(DATASET_DIR / "sp500_index.csv", parse_dates=["Date"])
    df.columns = ["date", "sp500"]
    df.to_sql("sp500_index", engine, if_exists="replace", index=False)
    print(f"Loaded {len(df)} index rows")


def load_stocks(engine):
    total = 0
    for i, chunk in enumerate(pd.read_csv(
        DATASET_DIR / "sp500_stocks.csv",
        parse_dates=["Date"],
        chunksize=CHUNK_SIZE
    )):
        chunk.columns = ["date", "symbol", "adj_close", "close", "high", "low", "open", "volume"]
        chunk.dropna(subset=["close"], inplace=True)
        chunk.to_sql("stocks", engine, if_exists="append" if i > 0 else "replace", index=False)
        total += len(chunk)
        print(f"  Loaded {total:,} stock rows...", end="\r")
    print(f"\nDone — {total:,} stock rows total")


if __name__ == "__main__":
    engine = get_engine()
    print("Loading companies...")
    load_companies(engine)
    print("Loading S&P 500 index...")
    load_index(engine)
    print("Loading stocks (this may take a minute)...")
    load_stocks(engine)
    print("\nAll data loaded successfully.")
