from compute import compute
from flask import Flask, render_template, request
from model import InputForm

app = Flask(__name__)

# view
@app.route('/mvc03', methods=['GET', 'POST'])
def index():
    form = InputForm(request.form)
    if request.method == 'POST' and form.validate():
        a = form.a.data
        b = form.a.data
        s = compute(a, b)
    else:
        s = None
    return render_template('view.html', form=form, s=s)

if __name__ == '__main__':
    app.run(debug=True)