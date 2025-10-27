# the following code was used to load a sample of data into a postgreSQL database using python

import pandas as pd
from sqlalchemy import create_engine
import os
import psycopg2

DB_NAME = 'flightdata'
DB_USER = 'postgres'
DB_PASSWORD = xxxxxxxxx
DB_HOST = 'localhost'
DB_PORT = '5432'

engine = create_engine(f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)

new_cols_dict = {'Year':'year',
              'Month': 'month',
              'DayofMonth': 'dayofmonth',
              'DayOfWeek': 'dayofweek',
              'DepTime': 'deptime',
              'CRSDepTime': 'crsdeptime',
              'ArrTime': 'arrtime',
              'CRSArrTime': 'crsarrtime',
              'UniqueCarrier': 'uniquecarrier',
              'FlightNum': 'flightnum',
              'TailNum': 'tailnum',
              'ActualElapsedTime': 'actualelapsedtime',
              'CRSElapsedTime': 'crselapsedtime',
              'AirTime': 'airtime',
              'ArrDelay': 'arrdelay',
              'DepDelay': 'depdelay',
              'Origin': 'origin',
              'Dest': 'dest',
              'Distance': 'distance',
              'TaxiIn': 'taxiin',
              'TaxiOut': 'taxiout',
              'Cancelled': 'cancelled',
              'CancellationCode': 'cancellationcode',
              'Diverted': 'diverted',
              'CarrierDelay': 'carrierdelay',
              'WeatherDelay': 'weatherdelay',
              'NASDelay': 'nasdelay',
              'SecurityDelay': 'securitydelay',
              'LateAircraftDelay': 'lateaircraftdelay'}

def load_csvs_to_postgres(folder_path, table_name):
    csv_files = [file for file in os.listdir(folder_path) if file.endswith('.csv')]
    for file in csv_files:
        csv_path = os.path.join(folder_path, file)
        df = pd.read_csv(csv_path)
        df.rename(new_cols_dict,axis=1,inplace=True)
        df.to_sql(name=table_name, con=engine, if_exists='append', index=False, schema='public')
        print(f"Data from {file} loaded into {table_name} table.")

folder_path = r'C:\Users\pmead\OneDrive\Documents\Flight Data\FlightDataUncompressed'
table_name = 'flightdata'

load_csvs_to_postgres(folder_path,table_name)

conn.close()
