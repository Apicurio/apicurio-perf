var stats = {
    type: "GROUP",
name: "Global Information",
path: "",
pathFormatted: "group_missing-name-b06d1",
stats: {
    "name": "Global Information",
    "numberOfRequests": {
        "total": "900900",
        "ok": "900900",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "5",
        "ok": "5",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "2197",
        "ok": "2197",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "226",
        "ok": "226",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "308",
        "ok": "308",
        "ko": "-"
    },
    "percentiles1": {
        "total": "94",
        "ok": "94",
        "ko": "-"
    },
    "percentiles2": {
        "total": "302",
        "ok": "302",
        "ko": "-"
    },
    "percentiles3": {
        "total": "971",
        "ok": "971",
        "ko": "-"
    },
    "percentiles4": {
        "total": "1214",
        "ok": "1214",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 828773,
    "percentage": 92
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 60672,
    "percentage": 7
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 11455,
    "percentage": 1
},
    "group4": {
    "name": "failed",
    "count": 0,
    "percentage": 0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "498.01",
        "ok": "498.01",
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
        "total": "900",
        "ok": "900",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "16",
        "ok": "16",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "1520",
        "ok": "1520",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "87",
        "ok": "87",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "200",
        "ok": "200",
        "ko": "-"
    },
    "percentiles1": {
        "total": "21",
        "ok": "21",
        "ko": "-"
    },
    "percentiles2": {
        "total": "30",
        "ok": "30",
        "ko": "-"
    },
    "percentiles3": {
        "total": "525",
        "ok": "525",
        "ko": "-"
    },
    "percentiles4": {
        "total": "1057",
        "ok": "1057",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 876,
    "percentage": 97
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 19,
    "percentage": 2
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 5,
    "percentage": 1
},
    "group4": {
    "name": "failed",
    "count": 0,
    "percentage": 0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "0.498",
        "ok": "0.498",
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
        "total": "900000",
        "ok": "900000",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "5",
        "ok": "5",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "2197",
        "ok": "2197",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "226",
        "ok": "226",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "308",
        "ok": "308",
        "ko": "-"
    },
    "percentiles1": {
        "total": "94",
        "ok": "94",
        "ko": "-"
    },
    "percentiles2": {
        "total": "302",
        "ok": "302",
        "ko": "-"
    },
    "percentiles3": {
        "total": "972",
        "ok": "972",
        "ko": "-"
    },
    "percentiles4": {
        "total": "1214",
        "ok": "1214",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 827897,
    "percentage": 92
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 60653,
    "percentage": 7
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 11450,
    "percentage": 1
},
    "group4": {
    "name": "failed",
    "count": 0,
    "percentage": 0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "497.512",
        "ok": "497.512",
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
