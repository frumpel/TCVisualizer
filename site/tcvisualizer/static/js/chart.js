var taskStatus = {
    "SUCCESS" : "bar-success",
    "FAILURE" : "bar-failure",
    "ERROR" : "bar-error"
};

function changeTimeDomain(chart, tasks, startDate, endDate) {
    chart.timeDomain([startDate, endDate]);
    chart.redraw(tasks);
}

var listOfCharts = [];
var addGanttChart = function (project) {
    var minDate = d3.time.day.offset(new Date(), -1);
    var maxDate = d3.time.hour.offset(new Date(), +1);
    for (i = 0; i < project.tasks.length; i++) {
        project.tasks[i].startDate = new Date(project.tasks[i].startDate);
        project.tasks[i].endDate = new Date(project.tasks[i].endDate);
        if (project.tasks[i].startDate < minDate) {
            minDate = project.tasks[i].startDate;
        }
        if (project.tasks[i].endDate > maxDate) {
            maxDate = project.tasks[i].endDate;
        }
    }

    var gantt = d3.gantt().taskTypes(project.types).taskStatus(taskStatus).tickFormat("%H:%M").height(200).width(800);
    //gantt.timeDomainMode("fixed");
    //changeTimeDomain(gantt, project.tasks, minDate, maxDate);
    gantt(project.tasks);    
};

$(function() {
    $( "#from" ).datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 2,
        onClose: function( selectedDate ) {
            $( "#to" ).datepicker( "option", "minDate", selectedDate );
        }
    });

    $( "#to" ).datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 2,
        onClose: function( selectedDate ) {
            $( "#from" ).datepicker( "option", "maxDate", selectedDate );
        }
    });
});