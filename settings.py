#settings.py
import os
# __file__ refers to the file settings.py 
APP_ROOT = os.path.dirname(os.path.abspath(__file__))   # refers to application_top
AMPL_ENGINE_PATH = os.path.join(APP_ROOT, 'ampl engine')