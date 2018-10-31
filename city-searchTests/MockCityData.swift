//
//  MockCityData.swift
//  city-searchTests
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import Foundation

let mockCityJsonString = """
    [
        {\"country\":\"DE\",\"name\":\"Bogenhausen\",\"_id\":2947022,\"coord\":{\"lon\":11.61667,\"lat\":48.150002}},
        {\"country\":\"DE\",\"name\":\"Mahlsdorf\",\"_id\":2874455,\"coord\":{\"lon\":13.61373,\"lat\":52.50935}},
        {\"country\":\"DE\",\"name\":\"Koeln-Ehrenfeld\",\"_id\":6947479,\"coord\":{\"lon\":6.92059,\"lat\":50.945599}},
        {\"country\":\"DE\",\"name\":\"Bohnsdorf\",\"_id\":2946887,\"coord\":{\"lon\":13.57339,\"lat\":52.394341}},
        {\"country\":\"DE\",\"name\":\"Wannsee\",\"_id\":2814196,\"coord\":{\"lon\":13.15531,\"lat\":52.419151}},
        {\"country\":\"DE\",\"name\":\"Markt Nordheim\",\"_id\":2873292,\"coord\":{\"lon\":10.35,\"lat\":49.583328}},
        {\"country\":\"DE\",\"name\":\"Staaken\",\"_id\":2829962,\"coord\":{\"lon\":13.13333,\"lat\":52.533329}},
        {\"country\":\"DE\",\"name\":\"Oberschoneweide\",\"_id\":2859103,\"coord\":{\"lon\":13.52108,\"lat\":52.46106}},
        {\"country\":\"DE\",\"name\":\"Niederschoneweide\",\"_id\":2862890,\"coord\":{\"lon\":13.5,\"lat\":52.450001}},
        {\"country\":\"DE\",\"name\":\"Mariendorf\",\"_id\":2873606,\"coord\":{\"lon\":13.38109,\"lat\":52.437801}},
        {\"country\":\"DE\",\"name\":\"Muggelheim\",\"_id\":2868837,\"coord\":{\"lon\":13.66403,\"lat\":52.411369}},
        {\"country\":\"DE\",\"name\":\"Schmockwitz\",\"_id\":2837672,\"coord\":{\"lon\":13.64948,\"lat\":52.37513}},
        {\"country\":\"ES\",\"name\":\"Playa Blanca\",\"_id\":2512465,\"coord\":{\"lon\":-13.82814,\"lat\":28.86426}},
        {\"country\":\"ES\",\"name\":\"Vicalvaro\",\"_id\":3106054,\"coord\":{\"lon\":-3.6,\"lat\":40.400002}},
        {\"country\":\"CL\",\"name\":\"El Tabo\",\"_id\":3890338,\"coord\":{\"lon\":-71.666672,\"lat\":-33.450001}},
        {\"country\":\"AR\",\"name\":\"Ituzaingo\",\"_id\":3433359,\"coord\":{\"lon\":-58.65836,\"lat\":-34.655819}},
        {\"country\":\"NZ\",\"name\":\"Tinwald\",\"_id\":2181108,\"coord\":{\"lon\":171.716675,\"lat\":-43.916672}},
        {\"country\":\"CH\",\"name\":\"Pailly\",\"_id\":2659262,\"coord\":{\"lon\":6.6754,\"lat\":46.701229}},
        {\"country\":\"CH\",\"name\":\"Bavois\",\"_id\":2661591,\"coord\":{\"lon\":6.5671,\"lat\":46.684029}},
        {\"country\":\"CH\",\"name\":\"Grancy\",\"_id\":2660540,\"coord\":{\"lon\":6.46391,\"lat\":46.59214}}
    ]
"""

let mockCityJsonMalformed = """
[
{\"country\":\"DE\",\"name\":\"Bogenhausen\",\"_id\":2947022,\"coord\":{\"lon\":11.61667,\"lat\":48.150002}},
{\"country\":\"DE\",\"name\":\"Mahlsdorf\",\"_id\":2874455,\"c
]
"""

let mockCityData: Data = mockCityJsonString.data(using: .utf8)!
let mockCityDataMalformed = mockCityJsonMalformed.data(using: .utf8)!
