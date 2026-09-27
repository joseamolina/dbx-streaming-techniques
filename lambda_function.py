import boto3
import json
import time
import random
import uuid
from datetime import datetime, timezone

BUCKET_NAME = "amz-prueba-s3-354452812509-us-east-1-an"
REGION      = "us-east-1"
SENSOR_ID   = "sensor-001"
INTERVAL    = 3
DURATION    = 57  # run for 57s, leaving 3s buffer before Lambda timeout

s3 = boto3.client("s3", region_name=REGION)

def generate():
    return {
        "sensor_id": SENSOR_ID,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "readings": {
            "temperature_celsius": round(random.uniform(18.0, 35.0), 2),
            "humidity_percent":    round(random.uniform(30.0, 90.0), 2),
            "pressure_hpa":        round(random.uniform(980.0, 1050.0), 2),
            "co2_ppm":             round(random.uniform(400.0, 1200.0), 1),
        },
        "status": "ok",
        "reading_id": str(uuid.uuid4()),
    }

def write(data):
    ts  = datetime.now(timezone.utc)
    key = (
        f"sensors/{SENSOR_ID}/"
        f"{ts.strftime('%Y/%m/%d')}/"
        f"{ts.strftime('%H%M%S')}-{data['reading_id'][:8]}.json"
    )
    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=key,
        Body=json.dumps(data, indent=2),
        ContentType="application/json",
    )
    print(f"Written → s3://{BUCKET_NAME}/{key}")

def lambda_handler(event, context):
    start = time.time()
    count = 0
    while (time.time() - start) < DURATION:
        write(generate())
        count += 1
        time.sleep(INTERVAL)
    print(f"Done. Wrote {count} records in {DURATION}s.")
    return {"statusCode": 200, "body": f"Wrote {count} records"}
