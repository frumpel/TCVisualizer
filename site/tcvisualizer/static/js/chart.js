var taskStatus = {
    "SUCCESS" : "bar-success",
    "FAILURE" : "bar-failure",
    "ERROR" : "bar-error"
};

var listOfCharts = [];

function changeTimeDomain(startDate, endDate) {
    console.debug("changeTimeDomain:" + startDate + "(" + typeof(startDate) + ")")
    for (var i = 0; i < listOfCharts.length; i++) {
        listOfCharts[i].gantt.timeDomain([startDate, endDate]);
        listOfCharts[i].gantt.redraw(listOfCharts[i].tasks);
    }
}

var addGanttChart = function (project, useElement) {
    for (i = 0; i < project.tasks.length; i++) {
        project.tasks[i].startDate = new Date(project.tasks[i].startDate);
        project.tasks[i].endDate = new Date(project.tasks[i].endDate);
    }

    var gantt = d3.gantt().taskTypes(project.types).taskStatus(taskStatus).tickFormat("%d/%m").height(200).width(800);
    gantt.timeDomainMode("fixed");
    gantt(project.tasks,useElement);
    listOfCharts.push({'gantt': gantt, 'tasks': project.tasks});
};

$(function() {
    $( "#from" ).datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        onClose: function( selectedDate ) {
            $( "#to" ).datepicker( "option", "minDate", selectedDate );
        }
    });

    $( "#to" ).datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        onClose: function( selectedDate ) {
            $( "#from" ).datepicker( "option", "maxDate", selectedDate );
        }
    });

    var datePickerValueChange = function () {
        var fromDate = $("#from").datepicker("getDate");
        if (fromDate != null) {
            fromDate.setHours(-6, 0, 0, 0);
        }

        var toDate = $("#to").datepicker("getDate");
        if (toDate != null) {
            toDate.setHours(-6, 0, 0, 0);
        }

        if (toDate < fromDate) {
            toDate = fromDate;
            toDate.setHours(+6,0,0,0)
        }

        // Update time domain for all Gantt charts
        changeTimeDomain(d3.time.day.offset(fromDate,0), d3.time.day.offset(toDate,0));
    }

    $("#from").on("change", datePickerValueChange);
    $("#to").on("change", datePickerValueChange);
});