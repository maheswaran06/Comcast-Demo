import boto3
import os

def lambda_handler(event, context):
    # Initialize the S3 client
    s3 = boto3.client('s3')
    
    # Source and destination bucket names from environment variables
    source_bucket = os.environ['SOURCE_BUCKET']
    destination_bucket = os.environ['DESTINATION_BUCKET']

    try:
        for record in event['Records']:
            # Get the object key from the event
            source_key = record['s3']['object']['key']

            # Copy the object to the destination bucket
            copy_source = {'Bucket': source_bucket, 'Key': source_key}
            s3.copy_object(CopySource=copy_source, Bucket=destination_bucket, Key=source_key)

        return {
            'statusCode': 200,
            'body': f"Successfully copied {source_key} from {source_bucket} to {destination_bucket}"
        }

    except Exception as e:
        print(f"Error copying objects: {e}")
        return {
            'statusCode': 500,
            'body': f"Error copying objects: {e}"
        }
