import subprocess
import shlex
import json

def run_command(cmd):
    cmd = shlex.split(cmd)
    return subprocess.check_output(cmd).decode('ascii')

firstName = run_command('chance name').split(" ")[0]
lastName = run_command('chance name').split(" ")[1]
email = run_command('chance email')
age = run_command('chance floating --min 1 --max 100').split(".")[0]

#python_object = {'some_text': 'my text',
#                 'some_number': 12345,
#                 'null_value': None,
#             'some_list': [1,2,3]}

python_object = {
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "age": age
}

# here we are converting python object to json string
json_string = json.dumps(python_object)

#print(json_string)

# write to file
# filename should be firstName_lastName.json
fileName = 'data/' + firstName + '_' + lastName + '.json'
with open(fileName, 'w') as f:
    f.write(json_string)

print('Created file: ' + fileName)
