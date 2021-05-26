var stats = {
    type: "GROUP",
name: "Global Information",
path: "",
pathFormatted: "group_missing-name-b06d1",
stats: {
    "name": "Global Information",
    "numberOfRequests": {
        "total": "180600",
        "ok": "180600",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "5",
        "ok": "5",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "6236",
        "ok": "6236",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "18",
        "ok": "18",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "101",
        "ok": "101",
        "ko": "-"
    },
    "percentiles1": {
        "total": "9",
        "ok": "9",
        "ko": "-"
    },
    "percentiles2": {
        "total": "13",
        "ok": "13",
        "ko": "-"
    },
    "percentiles3": {
        "total": "40",
        "ok": "40",
        "ko": "-"
    },
    "percentiles4": {
        "total": "137",
        "ok": "137",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 180467,
    "percentage": 100
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 15,
    "percentage": 0
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 118,
    "percentage": 0
},
    "group4": {
    "name": "failed",
    "count": 0,
    "percentage": 0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "299.502",
        "ok": "299.502",
        "ko": "-"
    }
},
contents: {
"req_create-artifact-45651": {
        type: "REQUEST",
        name: "create_artifact",
path: "create_artifact",
pathFormatted: "req_create-artifact-45651",
stats: {
    "name": "create_artifact",
    "numberOfRequests": {
        "total": "600",
        "ok": "600",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "19",
        "ok": "19",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "637",
        "ok": "637",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "33",
        "ok": "33",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "44",
        "ok": "44",
        "ko": "-"
    },
    "percentiles1": {
        "total": "25",
        "ok": "25",
        "ko": "-"
    },
    "percentiles2": {
        "total": "29",
        "ok": "29",
        "ko": "-"
    },
    "percentiles3": {
        "total": "60",
        "ok": "60",
        "ko": "-"
    },
    "percentiles4": {
        "total": "193",
        "ok": "193",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 600,
    "percentage": 100
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 0,
    "percentage": 0
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 0,
    "percentage": 0
},
    "group4": {
    "name": "failed",
    "count": 0,
    "percentage": 0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "0.995",
        "ok": "0.995",
        "ko": "-"
    }
}
    },"req_get-by-globalid-c88fc": {
        type: "REQUEST",
        name: "get_by_globalId",
path: "get_by_globalId",
pathFormatted: "req_get-by-globalid-c88fc",
stats: {
    "name": "get_by_globalId",
    "numberOfRequests": {
        "total": "180000",
        "ok": "180000",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "5",
        "ok": "5",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "6236",
        "ok": "6236",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "18",
        "ok": "18",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "101",
        "ok": "101",
        "ko": "-"
    },
    "percentiles1": {
        "total": "9",
        "ok": "9",
        "ko": "-"
    },
    "percentiles2": {
        "total": "12",
        "ok": "12",
        "ko": "-"
    },
    "percentiles3": {
        "total": "40",
        "ok": "40",
        "ko": "-"
    },
    "percentiles4": {
        "total": "134",
        "ok": "134",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 179867,
    "percentage": 100
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 15,
    "percentage": 0
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 118,
    "percentage": 0
},
    "group4": {
    "name": "failed",
    "count": 0,
    "percentage": 0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "298.507",
        "ok": "298.507",
        "ko": "-"
    }
}
    }
}

}

function fillStats(stat){
    $("#numberOfRequests").append(stat.numberOfRequests.total);
    $("#numberOfRequestsOK").append(stat.numberOfRequests.ok);
    $("#numberOfRequestsKO").append(stat.numberOfRequests.ko);

    $("#minResponseTime").append(stat.minResponseTime.total);
    $("#minResponseTimeOK").append(stat.minResponseTime.ok);
    $("#minResponseTimeKO").append(stat.minResponseTime.ko);

    $("#maxResponseTime").append(stat.maxResponseTime.total);
    $("#maxResponseTimeOK").append(stat.maxResponseTime.ok);
    $("#maxResponseTimeKO").append(stat.maxResponseTime.ko);

    $("#meanResponseTime").append(stat.meanResponseTime.total);
    $("#meanResponseTimeOK").append(stat.meanResponseTime.ok);
    $("#meanResponseTimeKO").append(stat.meanResponseTime.ko);

    $("#standardDeviation").append(stat.standardDeviation.total);
    $("#standardDeviationOK").append(stat.standardDeviation.ok);
    $("#standardDeviationKO").append(stat.standardDeviation.ko);

    $("#percentiles1").append(stat.percentiles1.total);
    $("#percentiles1OK").append(stat.percentiles1.ok);
    $("#percentiles1KO").append(stat.percentiles1.ko);

    $("#percentiles2").append(stat.percentiles2.total);
    $("#percentiles2OK").append(stat.percentiles2.ok);
    $("#percentiles2KO").append(stat.percentiles2.ko);

    $("#percentiles3").append(stat.percentiles3.total);
    $("#percentiles3OK").append(stat.percentiles3.ok);
    $("#percentiles3KO").append(stat.percentiles3.ko);

    $("#percentiles4").append(stat.percentiles4.total);
    $("#percentiles4OK").append(stat.percentiles4.ok);
    $("#percentiles4KO").append(stat.percentiles4.ko);

    $("#meanNumberOfRequestsPerSecond").append(stat.meanNumberOfRequestsPerSecond.total);
    $("#meanNumberOfRequestsPerSecondOK").append(stat.meanNumberOfRequestsPerSecond.ok);
    $("#meanNumberOfRequestsPerSecondKO").append(stat.meanNumberOfRequestsPerSecond.ko);
}
