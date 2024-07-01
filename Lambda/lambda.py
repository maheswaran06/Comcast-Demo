import boto3
import os
import logging
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client('s3')
sns = boto3.client('sns')

# Environment variables
SOURCE_BUCKET = os.environ['SOURCE_BUCKET']
DESTINATION_BUCKET = os.environ['DESTINATION_BUCKET']
SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    try:
        for record in event['Records']:
            # Get the object key from the event
            source_key = record['s3']['object']['key']
            logger.info(f"Processing file: {source_key}")

            # Determine file type based on extension
            file_type = source_key.split('.')[-1].lower()

            # Set the destination key based on file type
            if file_type == 'txt':
                destination_key = f"text-files/{source_key}"
            elif file_type == 'csv':
                destination_key = f"csv-files/{source_key}"
            else:
                destination_key = f"other-files/{source_key}"

            # Copy the object to the destination bucket
            copy_source = {'Bucket': SOURCE_BUCKET, 'Key': source_key}
            s3.copy_object(CopySource=copy_source, Bucket=DESTINATION_BUCKET, Key=destination_key)

            # Log the success and send a notification
            success_message = f"Successfully copied {source_key} to {DESTINATION_BUCKET}/{destination_key}"
            logger.info(success_message)
            sns.publish(
                TopicArn=SNS_TOPIC_ARN,
                Subject='Comcast Demo S3 File Transfer Success',
                Message=success_message
            )

        return {
            'statusCode': 200,
            'body': success_message
        }

    except ClientError as e:
        error_message = f"Error processing object {source_key} from bucket {SOURCE_BUCKET}. Error: {e}"
        logger.error(error_message)
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject='Comcast Demo S3 File Transfer Error',
            Message=error_message
        )
        return {
            'statusCode': 500,
            'body': error_message
        }
