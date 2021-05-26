var stats = {
    type: "GROUP",
name: "Global Information",
path: "",
pathFormatted: "group_missing-name-b06d1",
stats: {
    "name": "Global Information",
    "numberOfRequests": {
        "total": "4322400",
        "ok": "4322400",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "4",
        "ok": "4",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "6951",
        "ok": "6951",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "14",
        "ok": "14",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "66",
        "ok": "66",
        "ko": "-"
    },
    "percentiles1": {
        "total": "6",
        "ok": "6",
        "ko": "-"
    },
    "percentiles2": {
        "total": "6",
        "ok": "6",
        "ko": "-"
    },
    "percentiles3": {
        "total": "92",
        "ok": "92",
        "ko": "-"
    },
    "percentiles4": {
        "total": "178",
        "ok": "178",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 4321610,
    "percentage": 100
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 225,
    "percentage": 0
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 565,
    "percentage": 0
},
    "group4": {
    "name": "failed",
    "count": 0,
    "percentage": 0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "1424.654",
        "ok": "1424.654",
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
        "total": "2400",
        "ok": "2400",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "15",
        "ok": "15",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "285",
        "ok": "285",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "20",
        "ok": "20",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "14",
        "ok": "14",
        "ko": "-"
    },
    "percentiles1": {
        "total": "18",
        "ok": "18",
        "ko": "-"
    },
    "percentiles2": {
        "total": "20",
        "ok": "20",
        "ko": "-"
    },
    "percentiles3": {
        "total": "26",
        "ok": "26",
        "ko": "-"
    },
    "percentiles4": {
        "total": "59",
        "ok": "59",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 2400,
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
        "total": "0.791",
        "ok": "0.791",
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
        "total": "4320000",
        "ok": "4320000",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "4",
        "ok": "4",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "6951",
        "ok": "6951",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "14",
        "ok": "14",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "66",
        "ok": "66",
        "ko": "-"
    },
    "percentiles1": {
        "total": "6",
        "ok": "6",
        "ko": "-"
    },
    "percentiles2": {
        "total": "6",
        "ok": "6",
        "ko": "-"
    },
    "percentiles3": {
        "total": "92",
        "ok": "92",
        "ko": "-"
    },
    "percentiles4": {
        "total": "178",
        "ok": "178",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 4319210,
    "percentage": 100
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 225,
    "percentage": 0
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 565,
    "percentage": 0
},
    "group4": {
    "name": "failed",
    "count": 0,
    "percentage": 0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "1423.863",
        "ok": "1423.863",
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
