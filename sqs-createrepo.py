#!/usr/bin/env python

import os
import time
import json
import tempfile
import shutil
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
                    if f.endswith('.rpm') or f.endswith('.createrepo'):
                        p = os.path.join('/mnt', os.getenv('REPO'), os.path.dirname(f))
                        print('INFO: Processing', p)
                        if os.path.isfile(p+'/.createrepo'):
                            tmpdir = tempfile.mkdtemp()
                            os.system('rsync -rv %s/repodata %s/' % (p, tmpdir))
                            os.system('createrepo -v --update -o %s %s > %s/repodata/log 2>&1' % (tmpdir, p, tmpdir))
                            os.system('rsync -rv --delete %s/repodata/ %s/repodata/' % (tmpdir, p))
                            shutil.rmtree(tmpdir)
                    q.delete_message(m[0])
                except Exception as e:
                    print('ERR:', e)
                    q.delete_message(m[0])
            else:
                print('INFO: Queue is empty')
                time.sleep(3)
        else:
            print('WARN: Queue %r not found' % os.getenv('REPO'))
    except Exception as e:
        print('ERR:', e)
        time.sleep(5)