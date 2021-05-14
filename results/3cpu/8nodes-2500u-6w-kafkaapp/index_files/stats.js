var stats = {
    type: "GROUP",
name: "Global Information",
path: "",
pathFormatted: "group_missing-name-b06d1",
stats: {
    "name": "Global Information",
    "numberOfRequests": {
        "total": "27015000",
        "ok": "27015000",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "4",
        "ok": "4",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "1433",
        "ok": "1433",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "491",
        "ok": "491",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "312",
        "ok": "312",
        "ko": "-"
    },
    "percentiles1": {
        "total": "614",
        "ok": "614",
        "ko": "-"
    },
    "percentiles2": {
        "total": "772",
        "ok": "772",
        "ko": "-"
    },
    "percentiles3": {
        "total": "851",
        "ok": "851",
        "ko": "-"
    },
    "percentiles4": {
        "total": "902",
        "ok": "902",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 22513308,
    "percentage": 83
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 4501671,
    "percentage": 17
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 21,
    "percentage": 0
},
    "group4": {
    "name": "failed",
    "count": 0,
    "percentage": 0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "6991.46",
        "ok": "6991.46",
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
        "total": "15000",
        "ok": "15000",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "14",
        "ok": "14",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "1028",
        "ok": "1028",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "184",
        "ok": "184",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "243",
        "ok": "243",
        "ko": "-"
    },
    "percentiles1": {
        "total": "28",
        "ok": "28",
        "ko": "-"
    },
    "percentiles2": {
        "total": "311",
        "ok": "311",
        "ko": "-"
    },
    "percentiles3": {
        "total": "716",
        "ok": "716",
        "ko": "-"
    },
    "percentiles4": {
        "total": "835",
        "ok": "835",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 14740,
    "percentage": 98
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 260,
    "percentage": 2
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
        "total": "3.882",
        "ok": "3.882",
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
        "total": "27000000",
        "ok": "27000000",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "4",
        "ok": "4",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "1433",
        "ok": "1433",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "491",
        "ok": "491",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "312",
        "ok": "312",
        "ko": "-"
    },
    "percentiles1": {
        "total": "614",
        "ok": "614",
        "ko": "-"
    },
    "percentiles2": {
        "total": "772",
        "ok": "772",
        "ko": "-"
    },
    "percentiles3": {
        "total": "851",
        "ok": "851",
        "ko": "-"
    },
    "percentiles4": {
        "total": "902",
        "ok": "902",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 22498568,
    "percentage": 83
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 4501411,
    "percentage": 17
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 21,
    "percentage": 0
},
    "group4": {
    "name": "failed",
    "count": 0,
    "percentage": 0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "6987.578",
        "ok": "6987.578",
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
