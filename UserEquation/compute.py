from io import BytesIO
from matplotlib.pyplot import figure, savefig
from scipy import linspace, pi
import base64, glob, os, scipy, seaborn, time

FILE_TYPE = 'png'

def compute(f, xlim):
    
    fig = figure(figsize=(8,6))
    pn = fig.add_subplot(111)    
    namespace = scipy.__dict__.copy()
    x = linspace(eval(xlim[0]), eval(xlim[1]), 100)
    namespace.update({'x': x})
    y = eval(f, namespace)
    pn.plot(x, y)
    
    # Creating the object to be embedded into the HTML template
    #
    pfile = BytesIO()
    savefig(pfile, format=FILE_TYPE)
    pfile.seek(0)
    pfilePNG = base64.b64encode(pfile.getvalue())

    # Turning to Python string and return
    #
    return pfilePNG.decode('utf-8').rstrip('\n')
