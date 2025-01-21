import csv
import json
import boto3
import time
import os


def generate(stream_name, kinesis_client):
    s3 = boto3.client('s3')
    obj = s3.get_object(Bucket='awsglueudemycourse-datasoup-etl-artifacts', Key='gluejob-artifacts/gluejob345/configuration/sample.csv')
    csvf = obj["Body"].read().decode("utf-8-sig").splitlines()
    csvReader = csv.DictReader(csvf)
    for rows in csvReader:
            #debug info in console
            print(json.dumps(rows))
            time.sleep(0.2)
            kinesis_client.put_record(StreamName=stream_name,
                                      Data=json.dumps(rows),
                                      PartitionKey="partitionkey")
if __name__ == '__main__':
    generate('gluejob345', boto3.client('kinesis'))
