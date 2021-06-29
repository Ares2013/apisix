#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
use t::APISIX 'no_plan';

repeat_each(2);
no_root_location();

run_tests;

__DATA__

=== TEST 1: sanity
--- config
    location /t {
        content_by_lua_block {
            local encode_json = require("toolkit.json").encode
            local config = require("apisix.core").config.local_conf()

            ngx.say("etcd host: ", config.etcd.host)
            ngx.say("first plugin: ", encode_json(config.plugins[1]))
        }
    }
--- request
GET /t
--- response_body
etcd host: http://127.0.0.1:2379
first plugin: "client-control"



=== TEST 2: different elements in yaml
--- config
    location /t {
        content_by_lua_block {
            local encode_json = require("toolkit.json").encode
            local config = require("apisix.core").config.local_conf()

            ngx.say("etcd host: ", config.etcd.host)
            ngx.say("first plugin: ", encode_json(config.plugins[1]))
            ngx.say("seq: ", encode_json(config.seq))
        }
    }
--- yaml_config
etcd:
  host:
    - "http://127.0.0.1:2379" # etcd address
  prefix: "/apisix"             # apisix configurations prefix
  timeout: 1

plugins:
  - example-plugin

# Collection Types #############################################################
################################################################################

# http://yaml.org/type/map.html -----------------------------------------------#

map:
  # Unordered set of key: value pairs.
  Block style: !!map
    Clark : Evans
    Ingy  : döt Net
    Oren  : Ben-Kiki
  Flow style: !!map { Clark: Evans, Ingy: döt Net, Oren: Ben-Kiki }

# http://yaml.org/type/omap.html ----------------------------------------------#

omap:
  # Explicitly typed ordered map (dictionary).
  Bestiary: !!omap
    - aardvark: African pig-like ant eater. Ugly.
    - anteater: South-American ant eater. Two species.
    - anaconda: South-American constrictor snake. Scaly.
    # Etc.
  # Flow style
  Numbers: !!omap [ one: 1, two: 2, three : 3 ]

# http://yaml.org/type/pairs.html ---------------------------------------------#

pairs:
  # Explicitly typed pairs.
  Block tasks: !!pairs
    - meeting: with team.
    - meeting: with boss.
    - break: lunch.
    - meeting: with client.
  Flow tasks: !!pairs [ meeting: with team, meeting: with boss ]

# http://yaml.org/type/set.html -----------------------------------------------#

set:
  # Explicitly typed set.
  baseball players: !!set
    ? Mark McGwire
    ? Sammy Sosa
    ? Ken Griffey
  # Flow style
  baseball teams: !!set { Boston Red Sox, Detroit Tigers, New York Yankees }

# http://yaml.org/type/seq.html -----------------------------------------------#

seq:
  # Ordered sequence of nodes
  Block style: !!seq
  - Mercury   # Rotates - no light/dark sides.
  - Venus     # Deadliest. Aptly named.
  - Earth     # Mostly dirt.
  - Mars      # Seems empty.
  - Jupiter   # The king.
  - Saturn    # Pretty.
  - Uranus    # Where the sun hardly shines.
  - Neptune   # Boring. No rings.
  - Pluto     # You call this a planet?
  Flow style: !!seq [ Mercury, Venus, Earth, Mars,      # Rocks
                      Jupiter, Saturn, Uranus, Neptune, # Gas
                      Pluto ]                           # Overrated


# Scalar Types #################################################################
################################################################################

# http://yaml.org/type/bool.html ----------------------------------------------#

bool:
  - true
  - True
  - TRUE
  - false
  - False
  - FALSE

# http://yaml.org/type/float.html ---------------------------------------------#

float:
  canonical: 6.8523015e+5
  exponential: 685.230_15e+03
  fixed: 685_230.15
  sexagesimal: 190:20:30.15
  negative infinity: -.inf
  not a number: .NaN

# http://yaml.org/type/int.html -----------------------------------------------#

int:
  canonical: 685230
  decimal: +685_230
  octal: 02472256
  hexadecimal: 0x_0A_74_AE
  binary: 0b1010_0111_0100_1010_1110
  sexagesimal: 190:20:30

# http://yaml.org/type/merge.html ---------------------------------------------#

merge:
  - &CENTER { x: 1, y: 2 }
  - &LEFT { x: 0, y: 2 }
  - &BIG { r: 10 }
  - &SMALL { r: 1 }

  # All the following maps are equal:

  - # Explicit keys
    x: 1
    y: 2
    r: 10
    label: nothing

  - # Merge one map
    << : *CENTER
    r: 10
    label: center

  - # Merge multiple maps
    << : [ *CENTER, *BIG ]
    label: center/big

  - # Override
    << : [ *BIG, *LEFT, *SMALL ]
    x: 1
    label: big/left/small

# http://yaml.org/type/null.html ----------------------------------------------#

null:
  # This mapping has four keys,
  # one has a value.
  empty:
  canonical: ~
  english: null
  ~: null key
  # This sequence has five
  # entries, two have values.
  sparse:
    - ~
    - 2nd entry
    -
    - 4th entry
    - Null

# http://yaml.org/type/str.html -----------------------------------------------#

string:
  inline1: abcd
  inline2: "abcd"
  inline3: 'abcd'
  block1: |
    aaa
    bbb
    ccc
  block2: |+
    aaa
    bbb
    ccc
  block3: |-
    aaa
    bbb
    ccc
  block4: >
    aaa
    bbb
    ccc
  text5: >+
    aaa
    bbb
    ccc
  text6: >-
    aaa
    bbb
    ccc
# http://yaml.org/type/timestamp.html -----------------------------------------#

timestamp:
  canonical:        2001-12-15T02:59:43.1Z
  valid iso8601:    2001-12-14t21:59:43.10-05:00
  space separated:  2001-12-14 21:59:43.10 -5
  no time zone (Z): 2001-12-15 2:59:43.10
  date (00:00:00Z): 2002-12-14


# JavaScript Specific Types ####################################################
################################################################################

# https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/RegExp

regexp:
  simple: !!js/regexp      foobar
  modifiers: !!js/regexp   /foobar/mi

# https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/undefined

undefined: !!js/undefined ~

# https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function

function: !!js/function >
  function foobar() {
    return 'Wow! JS-YAML Rocks!';
  }


# Custom types #################################################################
################################################################################


# JS-YAML allows you to specify a custom YAML types for your structures.
# This is a simple example of custom constructor defined in `js/demo.js` for
# custom `!sexy` type:
#
# var SexyYamlType = new jsyaml.Type('!sexy', {
#   kind: 'sequence',
#   construct: function (data) {
#     return data.map(function (string) { return 'sexy ' + string; });
#   }
# });
#
# var SEXY_SCHEMA = jsyaml.Schema.create([ SexyYamlType ]);
#
# result = jsyaml.load(yourData, { schema: SEXY_SCHEMA });

foobar: !sexy
  - bunny
  - chocolate
--- request
GET /t
--- response_body
etcd host: http://127.0.0.1:2379
first plugin: "example-plugin"
seq: {"Block style":["Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto"],"Flow style":["Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto"]}



=== TEST 3: allow environment variable
--- config
    location /t {
        content_by_lua_block {
            local config = require("apisix.core").config.local_conf()

            ngx.say(config.apisix.id)
        }
    }
--- main_config
env AID=3;
--- yaml_config
#nginx_config:
    #env: AID=3
apisix:
    id: ${{ AID }}
--- request
GET /t
--- response_body
3



=== TEST 4: allow integer worker processes
--- config
    location /t {
        content_by_lua_block {
            local config = require("apisix.core").config.local_conf()

            ngx.say(config.nginx_config.worker_processes)
        }
    }
--- extra_yaml_config
nginx_config:
    worker_processes: 1
--- request
GET /t
--- response_body
1
