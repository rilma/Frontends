from wtforms import FloatField, Form, validators

class InputForm(Form):
    a = FloatField(validators=[validators.InputRequired()])
    b = FloatField(validators=[validators.InputRequired()])