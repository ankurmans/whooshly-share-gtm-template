___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Whooshly Share Buttons",
  "categories": ["SOCIAL"],
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Share buttons that turn every share into a short link with UTM tags, so you see which pages get shared. No cookies. Add them from Tag Manager without touching your site's code.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "placement",
    "displayName": "Where to show the buttons",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "floating",
        "displayValue": "A floating rail (left edge on desktop, bottom bar on phones)"
      },
      {
        "value": "after",
        "displayValue": "After an element on the page (CSS selector)"
      },
      {
        "value": "manual",
        "displayValue": "I place <whooshly-share> elements myself"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "floating",
    "help": "The floating rail can be dismissed by the visitor. \"After an element\" adds one row after the first match, for example after the article."
  },
  {
    "type": "TEXT",
    "name": "selector",
    "displayName": "CSS selector",
    "simpleValueType": true,
    "defaultValue": "article",
    "help": "The row is added after the first element that matches, for example article or .post-content.",
    "enablingConditions": [
      {
        "paramName": "placement",
        "paramValue": "after",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "networks",
    "displayName": "Networks",
    "simpleValueType": true,
    "defaultValue": "linkedin,x,facebook,email,copy",
    "help": "Comma-separated, in display order. Available: linkedin, x, facebook, whatsapp, reddit, threads, bluesky, email, copy, native.",
    "enablingConditions": [
      {
        "paramName": "placement",
        "paramValue": "manual",
        "type": "NOT_EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "REGEX",
        "args": [
          "^[a-z]+(,[a-z]+)*$"
        ],
        "errorMessage": "Use lowercase network names separated by commas, for example linkedin,x,copy."
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "showIcon",
    "checkboxText": "Show a small Whooshly icon after the buttons",
    "simpleValueType": true,
    "defaultValue": false,
    "help": "The icon links to whooshly.co and helps other site owners find the share kit. It is off unless you turn it on."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const queryPermission = require('queryPermission');
const encodeUriComponent = require('encodeUriComponent');

// Which tool installed the buttons (counted per channel by Whooshly), then the options.
const params = ['via=gtm'];
if (!data.showIcon) {
  params.push('badge=off');
}
if (data.placement === 'floating') {
  params.push('auto=floating');
} else if (data.placement === 'after' && data.selector) {
  params.push('auto=after:' + encodeUriComponent(data.selector));
}
if (data.placement !== 'manual' && data.networks) {
  params.push('networks=' + encodeUriComponent(data.networks));
}

const url = 'https://whooshly.co/share.js?' + params.join('&');

if (queryPermission('inject_script', url)) {
  // The script is cached by its address, so it loads once per page however often the tag fires.
  injectScript(url, data.gtmOnSuccess, data.gtmOnFailure, url);
} else {
  data.gtmOnFailure();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://whooshly.co/share.js*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Floating rail with the default networks
  code: |-
    const mockData = { placement: 'floating', networks: 'linkedin,x,facebook,email,copy', showIcon: false };
    let injected;
    mock('queryPermission', () => true);
    mock('injectScript', (url, onSuccess, onFailure, cacheToken) => {
      injected = url;
      onSuccess();
    });
    runCode(mockData);
    assertThat(injected).isEqualTo('https://whooshly.co/share.js?via=gtm&badge=off&auto=floating&networks=linkedin%2Cx%2Cfacebook%2Cemail%2Ccopy');
    assertApi('gtmOnSuccess').wasCalled();
- name: After an element, with the Whooshly icon turned on
  code: |-
    const mockData = { placement: 'after', selector: '.post-content', networks: 'linkedin,x', showIcon: true };
    let injected;
    mock('queryPermission', () => true);
    mock('injectScript', (url, onSuccess, onFailure, cacheToken) => {
      injected = url;
      onSuccess();
    });
    runCode(mockData);
    assertThat(injected).isEqualTo('https://whooshly.co/share.js?via=gtm&auto=after:.post-content&networks=linkedin%2Cx');
    assertApi('gtmOnSuccess').wasCalled();
- name: Manual placement sends no placement or networks
  code: |-
    const mockData = { placement: 'manual', networks: 'x', showIcon: false };
    let injected;
    mock('queryPermission', () => true);
    mock('injectScript', (url, onSuccess, onFailure, cacheToken) => {
      injected = url;
      onSuccess();
    });
    runCode(mockData);
    assertThat(injected).isEqualTo('https://whooshly.co/share.js?via=gtm&badge=off');
- name: Fails closed when the script is not permitted
  code: |-
    const mockData = { placement: 'floating', networks: 'x', showIcon: false };
    mock('queryPermission', () => false);
    mock('injectScript', () => { fail('injectScript must not run without permission'); });
    runCode(mockData);
    assertApi('gtmOnFailure').wasCalled();


___NOTES___

Whooshly Share Buttons – https://whooshly.co/share-kit
Source and tests: https://github.com/ankurmans/whooshly (integrations/gtm).
Privacy: the buttons do not set cookies. When a visitor presses or hovers over a share button, the page address and
network are sent to whooshly.co to prepare a short link. Whooshly sees the request IP address for abuse controls
(https://whooshly.co/privacy). Support: contact@whooshly.co.
