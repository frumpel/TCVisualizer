from flask import render_template
from models.task import Task
import db
import json

def render(project_names):
    projects = []
    for project_name in project_names:
        project_tasks = _get_tasks(project_name)
        
        # Create list of applicable project task types
        project_task_types = []
        for project_task in project_tasks:
            if project_task['taskName'] not in project_task_types:
                project_task_types.append(project_task['taskName'])

        project_task_types.sort(key=str.lower)
        projects.append({
            'name': project_name,
            'tasks': project_tasks,
            'types': project_task_types[::-1]
        })
    return render_template('index.htm', projects=projects, jsondumps=json.dumps)

def _get_tasks(project_name):
    session = db.Session()
    tasks = [task.to_dict() for task in session.query(Task).filter(Task.projectName == project_name)]
    session.close()
    return tasks

def get_projects():
    session = db.Session()
    projects = [project[0] for project in session.query(Task.projectName).distinct()]
    session.close()
    return projects
