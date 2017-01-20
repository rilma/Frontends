from wtforms import FloatField, Form, TextField, validators

class InputForm(Form):
    f = TextField( \
        default='sin(x)', label='Input Function in x', \
        validators=[validators.InputRequired()])
    x0 = TextField( \
        default='0', label='Lower limit of x', \
        validators=[validators.InputRequired()])
    xf = TextField( \
        default='2*pi', label='Upper limit of x', 
        validators=[validators.InputRequired()])