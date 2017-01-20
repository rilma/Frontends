from matplotlib.pyplot import figure, savefig
from scipy import linspace, pi
import glob, os, scipy, seaborn, time

FILE_TYPE = 'png'

def compute(f, xlim):
    fig = figure(figsize=(8,6))
    pn = fig.add_subplot(111)    
    namespace = scipy.__dict__.copy()
    x = linspace(eval(xlim[0]), eval(xlim[1]), 100)
    namespace.update({'x': x})
    y = eval(f, namespace)
    pn.plot(x, y)
    from io import BytesIO
    pfile = BytesIO()
    savefig(pfile, format=FILE_TYPE)
    pfile.seek(0)
    import base64
    pfilePNG = base64.b64encode(pfile.getvalue())
    return pfilePNG