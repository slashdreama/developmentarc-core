# Introduction #

The Utility class provides a series of static properties that retrieve information from the current URL. When a property is accessed, the url is retrieved from the browser via ExternalInterface so the url is always the most current.  No custom JavaScript is necessary for the class to work.  The class simply leverages the browser's window.location.href object.


# Details #

## URL Properties ##


```
https://www.developmentarc.com:8080/path/is/here/?param1=value1#page2
\___/   \____________________/ \__/\____________/ \___________/ \___/
  |                |             |       |               |        |
  |                |             |       |               |    fragment:String
  |                |             |       |           query:String
  |                |             |       |               |    
  |                |             |       |         parameters:Object
  |                |             |   path:String      
  |                |         port:uint
  |           serverName:String                       
protocal:String
```

## Code Example ##

```
    public function getURLProperties():void {
      // current url - https://developmentarc.com:8080/path/is/here/?param1=value1#page2
      
      var protocal:String  = BrowserLocationUtil.protocal // 'https'
      var serverName:String = BrowserLocationUtil.serverName // 'www.developmentarc.com'
      var port:String = BrowserLocationUtil.port // '8080'
      var path:String = BrowserLocationUtil.path // '/path/is/here/'
      var query:String = BrowserLocationUtil.query // 'param1=value1'
      var parameters:Object = BrowserLocationUtil.parameters // {param1:'value1'}
      var fragment:String = BrowserLocationUtil.fragment // 'page2'
    }

```