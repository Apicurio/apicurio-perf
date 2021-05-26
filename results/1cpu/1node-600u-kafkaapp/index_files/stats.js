var stats = {
    type: "GROUP",
name: "Global Information",
path: "",
pathFormatted: "group_missing-name-b06d1",
stats: {
    "name": "Global Information",
    "numberOfRequests": {
        "total": "180600",
        "ok": "52452",
        "ko": "128148"
    },
    "minResponseTime": {
        "total": "1",
        "ok": "3",
        "ko": "1"
    },
    "maxResponseTime": {
        "total": "40008",
        "ok": "39511",
        "ko": "40008"
    },
    "meanResponseTime": {
        "total": "764",
        "ok": "1816",
        "ko": "334"
    },
    "standardDeviation": {
        "total": "2425",
        "ok": "2263",
        "ko": "2357"
    },
    "percentiles1": {
        "total": "3",
        "ok": "1551",
        "ko": "2"
    },
    "percentiles2": {
        "total": "914",
        "ok": "2193",
        "ko": "3"
    },
    "percentiles3": {
        "total": "3006",
        "ok": "4793",
        "ko": "1835"
    },
    "percentiles4": {
        "total": "7143",
        "ok": "8301",
        "ko": "4315"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 13623,
    "percentage": 8
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 5443,
    "percentage": 3
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 33386,
    "percentage": 18
},
    "group4": {
    "name": "failed",
    "count": 128148,
    "percentage": 71
},
    "meanNumberOfRequestsPerSecond": {
        "total": "285.759",
        "ok": "82.994",
        "ko": "202.766"
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
        "total": "13",
        "ok": "13",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "29327",
        "ok": "29327",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "885",
        "ok": "885",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "3503",
        "ok": "3503",
        "ko": "-"
    },
    "percentiles1": {
        "total": "25",
        "ok": "25",
        "ko": "-"
    },
    "percentiles2": {
        "total": "786",
        "ok": "786",
        "ko": "-"
    },
    "percentiles3": {
        "total": "1877",
        "ok": "1877",
        "ko": "-"
    },
    "percentiles4": {
        "total": "28042",
        "ok": "28042",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 452,
    "percentage": 75
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 58,
    "percentage": 10
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 90,
    "percentage": 15
},
    "group4": {
    "name": "failed",
    "count": 0,
    "percentage": 0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "0.949",
        "ok": "0.949",
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
        "ok": "51852",
        "ko": "128148"
    },
    "minResponseTime": {
        "total": "1",
        "ok": "3",
        "ko": "1"
    },
    "maxResponseTime": {
        "total": "40008",
        "ok": "39511",
        "ko": "40008"
    },
    "meanResponseTime": {
        "total": "764",
        "ok": "1827",
        "ko": "334"
    },
    "standardDeviation": {
        "total": "2421",
        "ok": "2242",
        "ko": "2357"
    },
    "percentiles1": {
        "total": "3",
        "ok": "1577",
        "ko": "2"
    },
    "percentiles2": {
        "total": "915",
        "ok": "2196",
        "ko": "3"
    },
    "percentiles3": {
        "total": "3007",
        "ok": "4811",
        "ko": "1835"
    },
    "percentiles4": {
        "total": "7137",
        "ok": "8277",
        "ko": "4315"
    },
    "group1": {
    "name": "t < 800 ms",
    "count": 13171,
    "percentage": 7
},
    "group2": {
    "name": "800 ms < t < 1200 ms",
    "count": 5385,
    "percentage": 3
},
    "group3": {
    "name": "t > 1200 ms",
    "count": 33296,
    "percentage": 18
},
    "group4": {
    "name": "failed",
    "count": 128148,
    "percentage": 71
},
    "meanNumberOfRequestsPerSecond": {
        "total": "284.81",
        "ok": "82.044",
        "ko": "202.766"
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
