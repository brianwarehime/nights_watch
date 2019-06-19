from botocore.vendored import requests
import logging
import json
import time
import datetime
import os

def lambda_handler(event, context):
    # Extracting relevant fields for alerts
    event_description = (event['detail']['description'])
    event_account = (event['account'])
    event_region = (event['region'])
    event_severity = (event['detail']['severity'])
    event_count = (event['detail']['service']['count'])
    event_first_seen = (event['detail']['service']['eventFirstSeen'])
    event_last_seen = (event['detail']['service']['eventLastSeen'])
    event_type = (event['detail']['type'])
    event_id = (event['id'])

    slack_webhook = os.environ["slack_webhook"]
    event_threshold = os.environ["event_threshold"]

    # Grabbing the current timestamp for the footer
    ts = time.time()
    st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')

    # Adding link to finding in the description
    event_description += " For more information about this finding, please click <https://%s.console.aws.amazon.com/guardduty/home?region=%s#/findings?macros=current&fId=%s|here.>" % (event_region, event_region, event_id)

    guardduty_finding = {
        "attachments": [
            {
                "fallback": "GuardDuty Finding",
                "color": "#7e57c2",
                "title": "New GuardDuty Finding",
                "footer": "Alert generated at " + str(st),
                "fields": [
                    {
                        "title": "Region",
                        "value": event_region,
                        "short": "true"
                    },
                    {
                        "title": "Finding Type",
                        "value": event_type,
                        "short": "true"
                    },
                    {
                        "title": "Event First Seen",
                        "value": event_first_seen,
                        "short": "true"
                    },
                    {
                        "title": "Event Last Seen",
                        "value": event_last_seen,
                        "short": "true"
                    },
                    {
                        "title": "Severity",
                        "value": event_severity,
                        "short": "true"
                    },
                    {
                        "title": "Count",
                        "value": event_count,
                        "short": "true"
                    },
                    {
                        "title": "Description",
                        "value": event_description
                    }
                ]
            }
        ]
    }

    # Filtering out events by severity or noisy alerts
    if event_severity <= int(event_threshold):   
        pass
    else:
        response = requests.post(slack_webhook, data=json.dumps(guardduty_finding), headers={'Content-Type': 'application/json'})