import sys, getopt
import subprocess
import json

def main(argv):
    emailBucket = str(sys.argv[1])
    dataBucket = str(sys.argv[2])

    print 'Email is ', emailBucket
    print 'Data is ',dataBucket

    URL = 'http://qa-takehome-dac9a438.dev.aetion.com:4440'
    LOGIN_COMMAND = 'steps/login.sh'

    # DEBUG Commenting out during development
    #token = subprocess.check_output([ LOGIN_COMMAND ])
    token = '69d5f061-9646-4886-9b4a-5579652bd69d'
    print 'Token is ', token

    # First get all record - getting all records using a wide search is inefficient and there should be a more explicit way such as by email
    START_AGE= 'start_age=1'
    END_AGE= 'end_age=100'
    all_records = subprocess.check_output(['http','-f','POST',URL + '/user/search','X-Auth-Token:' + token,START_AGE,END_AGE,'--json' ])

    records_json = json.loads(all_records)

    found = False
    for record in records_json:
        if record['email'] == emailBucket:
            found = True
            id = record['id']
            try:
                all_records = subprocess.check_output(['http','PUT',URL + '/user/' + str(id),'X-Auth-Token:' + token,dataBucket,'--json' ])
                print 'Updating id ' + str(id)
            except subprocess.CalledProcessError as grepexc:                                                                                                   
                sys.exit(1)
 
if __name__ == "__main__":
    main(sys.argv[1:])

