from flask import render_template
from models.task import Task
import db
import json

def render(project_names):
    projects = []
    for project_name in project_names:
        _get_tasks2(project_name)
        project_tasks = _get_tasks(project_name)
        
        # Create list of applicable project task types
        project_task_types = []
        for project_task in project_tasks:
            if project_task['taskName'] not in project_task_types:
                project_task_types.append(project_task['taskName'])
        
        projects.append({
            'name': project_name,
            'tasks': project_tasks,
            'types': project_task_types
        })
    return render_template('index.htm', projects=projects, jsondumps=json.dumps)

def _get_tasks(project_name):
    tasks = [
        {"buildNumber" : "3.0.24.0","projectName" : "SMART Learn Identity (AppEngine)","taskName" : "3.0 UAT Deploy","startDate" : 1399637955000,"endDate" : 1399637957000,"taskStatus" : "FAILURE"},
        {"buildNumber" : "2.50.1498.0","projectName" : "SMART Learn WBP","taskName" : "2.0 Dev Deploy","startDate" : 1399637929000,"endDate" : 1399638108000,"taskStatus" : "SUCCESS"},
        {"buildNumber" : "2.50.1498.0","projectName" : "SMART Learn WBP","taskName" : "1.1 Deploy Docs","startDate" : 1399637927000,"endDate" : 1399638335000,"taskStatus" : "SUCCESS"},
        {"buildNumber" : "1.0.1002.0","projectName" : "DCB server","taskName" : "3.0 Uat Deploy","startDate" : 1399637581000,"endDate" : 1399637585000,"taskStatus" : "FAILURE"}
    ]
    result = []
    for item in tasks:
        if (item['projectName'] == project_name):
            result.append(item)
    return result

def _get_tasks2(project_name):
    session = db.Session()
    for task in session.query(Task).all():
        print task.projectName