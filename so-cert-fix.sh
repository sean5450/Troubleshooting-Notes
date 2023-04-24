#!/usr/bin/env python3import os
import subprocess
import datetimevalidity_days = 365for root, dirs, files in os.walk('/etc/pki'):
    for file in files:
        if file.endswith('.crt'):
            cert_file = os.path.join(root, file)
            key_file = os.path.join(root, file.replace('.crt', '.key'))
            if os.path.isfile(key_file):
                cert_date = subprocess.check_output(['openssl', 'x509', '-in', cert_file, '-noout', '-enddate']).decode('utf-8').strip().split('=')[1]
                cert_date_obj = datetime.datetime.strptime(cert_date, '%b %d %H:%M:%S %Y %Z')
                now = datetime.datetime.now()
                days_left = (cert_date_obj - now).days
                if days_left <= 0:
                    print("Certificate is expired, updating: {}".format(cert_file))
                    subject = subprocess.check_output(['openssl', 'x509', '-in', cert_file, '-noout', '-subject']).decode('utf-8').strip().split('=')[1]
                    subj_str = '/CN={}'.format(subject)
                    if ',' in subject:
                        for elem in subject.split(','):
                            if '=' in elem:
                                key, value = elem.split('=')
                                if key and value:
                                    subj_str += '/{},{}'.format(key, value)
                    subprocess.run(['openssl', 'req', '-x509', '-nodes', '-newkey', 'rsa:2048', '-keyout', key_file, '-out', cert_file, '-days', str(validity_days), '-subj', subj_str])
                    print("Updated certificate: {}".format(cert_file))
                else:
                    print("Certificate is valid for {} more days, skipping: {}".format(days_left, cert_file)) 
