import boto3
import os
import math

CONFIG_TABLE = os.getenv("CONFIG_TABLE")

s3 = boto3.resource("s3")
dynamodb = boto3.resource("dynamodb")
output_table = dynamodb.Table(CONFIG_TABLE)


def download_source_file(src_bucket,input_path,local_path):
    print(f"Downloading s3://{src_bucket}/{input_path}")
    src_bucket = s3.Bucket(src_bucket)
    src_bucket.download_file(input_path, local_path)


def file_into_list(file_route):
    file = open(file_route, 'r')
    lines = file.readlines()
    return lines

def conjetura_de_collatz(number):
    return -1


def create_dynamodb_record(filename,result):
    response = output_table.put_item(
        Item={
            'filename': f"{filename}",
            'result': f"{result}"
        }
    )

def delete_source_object(src_bucket,input_path):
    client = boto3.client("s3")
    print(f"Deleting s3://{src_bucket}/{input_path}")
    client.delete_object(Bucket=src_bucket, Key=input_path)


def handler(event, context):
    for record in event["Records"]:
        src_bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]
        try:
            download_source_file(src_bucket,key,f"/tmp/{key}")
            lines = file_into_list(f"/tmp/{key}")
            for line in lines:
                create_dynamodb_record(line,conjetura_de_collatz(line))
                delete_source_object(src_bucket,key)
        except KeyError as e:
            print(f"Missing config key: {str(e)}")
        except Exception as e:
            print(str(e))

