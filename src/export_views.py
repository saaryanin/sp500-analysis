import os
import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()
DB_URL = os.getenv("DB_URL")
EXPORT_DIR = Path(__file__).parent.parent / "exports"

VIEWS = [
    "vw_sector_summary",
    "vw_companies_enriched",
    "vw_index_timeseries",
    "vw_stock_yearly_performance",
    "vw_stock_snapshot",
]


def export_views():
    EXPORT_DIR.mkdir(exist_ok=True)
    engine = create_engine(DB_URL)

    for view in VIEWS:
        print(f"Exporting {view}...", end=" ")
        df = pd.read_sql(f"SELECT * FROM {view}", engine)
        path = EXPORT_DIR / f"{view}.csv"
        df.to_csv(path, index=False)
        print(f"{len(df):,} rows → {path.name}")

    print("\nAll exports done.")


if __name__ == "__main__":
    export_views()
