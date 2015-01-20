from flask import Flask
from flask import request
from settings import AMPL_ENGINE_PATH
import json
import os
from subprocess import Popen, PIPE




app = Flask(__name__)


@app.route('/run_ampl', methods=['POST'])
def run_ampl():
    user = request.form['username']
    password = request.form['password']
    print(os.path.normpath(AMPL_ENGINE_PATH))
    p = Popen(['./ampl', 'pn.run'], cwd=AMPL_ENGINE_PATH, stdin=PIPE, stdout=PIPE, stderr=PIPE)
    output, err = p.communicate()
    rc = p.returncode

    return json.dumps({'status':output,'user':user,'pass':password})

@app.route('/')
def root():
    return app.send_static_file('index.html')

if __name__ == '__main__':
    app.run(debug=True)
