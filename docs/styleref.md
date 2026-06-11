# Homepage

For full documentation visit [mkdocs.org](https://www.mkdocs.org).

## Code Annotation Examples

### Codeblockss

Some `code` goes here.

### Plain codeblock

A plain codeblock:

```
Some code here
def myfunction()
// some comment
```

#### Code for a specific language

Some more code with the `py` at the start:

``` py
import tensorflow as tf
def whatever()
```

#### With a title

``` py title="bubble_sort.py"
def bubble_sort(items):
    for i in range(len(items)):
        for j in range(len(items) - 1 - i):
            if items[j] > items[j + 1]:
                items[j], items[j + 1] = items[j + 1], items[j]
```

#### With line numbers

``` py linenums="1"
def bubble_sort(items):
    for i in range(len(items)):
        for j in range(len(items) - 1 - i):
            if items[j] > items[j + 1]:
                items[j], items[j + 1] = items[j + 1], items[j]
```

#### Highlighting lines

``` py hl_lines="2 3"
def bubble_sort(items):
    for i in range(len(items)):
        for j in range(len(items) - 1 - i):
            if items[j] > items[j + 1]:
                items[j], items[j + 1] = items[j + 1], items[j]
```

## Icons and Emojs

:smile: 

:fontawesome-regular-face-laugh-wink:

:fontawesome-brands-twitter:{ .twitter }

:octicons-heart-fill-24:{ .heart }

## References

# References

* [Service mesh patterns repository](https://github.com/trevorbox/service-mesh-patterns/tree/master/ossm-2.0/auth)
* https://github.com/cloudfirst-dev/istio-egress-traffic-control
* [Hints about how to debug istio](https://labs.consol.de/development/2020/05/07/debugging-istio.html)
* [oauth2-proxy repository](https://github.com/oauth2-proxy/oauth2-proxy)
* [oauth2-proxy integration with RHSSO](https://oauth2-proxy.github.io/oauth2-proxy/docs/configuration/oauth_provider/#keycloak-auth-provider)
* [Istio RequestAuthentication](https://istio.io/latest/docs/reference/config/security/request_authentication/)
* [Istio AuthorizationPolicy](https://istio.io/latest/docs/reference/config/security/authorization-policy/) and [conditions](https://istio.io/latest/docs/reference/config/security/conditions/)