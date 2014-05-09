TCVisualizer
============

TeamCity build pipeline visualization. The assumption is that you have a set of build chains in TeamCity and you want to have a quick visual overview where the chain breaks.

Additional assumptions are:

* you have found a way to have the same build number on each configuration in the chain
* the relevant build configurations have the words "build" or "deploy" in them

Installation
------------

You will need a unixy box with bash, mysql server, python 2.7, xmlstarlet.

Running
-------

Run a cron job like this:

```
bash collector.sh -o insert | mysql
```

to insert data into the database. 
