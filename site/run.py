from flask import Flask
from tcvisualizer import charts

app = Flask(
    import_name=__name__,
    template_folder='tcvisualizer/templates',
    static_folder='tcvisualizer/static'
)

@app.route('/')
def home():
    return charts.render(['SMART Learn WBP'])

@app.route('/visualize/')
def visualize():
    return charts.render(['Whiteboard'])


if __name__ == '__main__':
    app.run(debug=True)
