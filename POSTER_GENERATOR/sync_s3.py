import os
import time

while True:
    os.system('aws s3 sync ./export/ s3://republish --acl public-read')
    print('sleep 5s')
    time.sleep(5)
