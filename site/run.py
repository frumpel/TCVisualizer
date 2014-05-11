from flask import Flask
from tcvisualizer import charts

app = Flask(
    import_name=__name__,
    template_folder='tcvisualizer/templates',
    static_folder='tcvisualizer/static'
)

@app.route('/')
def home():
    projects = charts.get_projects()
    return charts.render(projects)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80);
