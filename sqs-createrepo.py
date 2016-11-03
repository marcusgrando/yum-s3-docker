#!/usr/bin/env python

import os
import time
import json
import boto.sqs

while True:
    try:
	conn = boto.sqs.connect_to_region(os.getenv('REGION'))
        q = conn.get_queue(os.getenv('REPO'))
        if q:
            m = q.get_messages()
            if m and len(m) == 1:
                try:
                    body = json.loads(m[0].get_body())
                    f = body['Records'][0]['s3']['object']['key']
                    if '.rpm' in f:
                        p = os.path.join('/mnt', os.getenv('REPO'), os.path.dirname(f))
                        print 'INFO[processing]:', p
                        if os.path.isdir(p+'/.rpm'):
                            os.system('createrepo --update --no-database '+p)
                    q.delete_message(m[0])
                except Exception, e:
                    print 'ERR[json]:', e
                    q.delete_message(m[0])
            else:
                print 'INFO: Queue is empty'
                time.sleep(1)
        else:
            print 'WARN: Queue %r not found' % os.getenv('REPO')
    except Exception, e:
        print 'ERR:', e
        time.sleep(5)
