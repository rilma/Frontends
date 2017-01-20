from compute import compute
from model import InputForm
from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/mvc05', methods=['GET', 'POST'])
def index():
    form = InputForm(request.form)
    if request.method == 'POST' and form.validate():
        result = compute(form.f.data, [form.x0.data, form.xf.data])
    else:
        result = None
    return render_template('view.html', form=form, result=result)

if __name__ == '__main__':
    app.run(debug=True)