/**
 * @description       : REST API Client
 * @author            : arieend@gmail.com
 * @group             :
 * @last modified on  : 11/10/2020
 * @last modified by  : arieend@gmail.com
 * Modifications Log
 * Ver   Date         Author              Modification
 * 1.0   11/10/2020   arieend@gmail.com   Initial Version
 **/
public with sharing virtual class RestClient {
  public class RestClientException extends Exception {
  }

  private Integer timeout = 60000; // Default HTTP Timeout
  private Boolean debug = true; // should we print debug statements?

  public enum HttpVerb {
    GET,
    POST,
    PUT
  }

  private Http h;
  private Map<String, String> headers;
  private String url;
  private HttpVerb method;
  private String body;
  private HttpRequest request;
  private HttpResponse response;
  private String responseBody;
  private String lastDebugMessage;

  public void setTimeout(Integer timeout) {
    this.timeout = timeout;
  }
  public void setDebug(Boolean debug) {
    this.debug = debug;
  }

  public RestClient() {
  }
  public RestClient(
    String url,
    HttpVerb method,
    Map<String, String> headers,
    String body
  ) {
    try {
      this.h = new Http();
      this.request = this.buildRequest(url, method, headers, body);
      this.response = this.makeRequest(this.h, this.request);
      this.responseBody = this.handleResponse(this.response);
    } catch (Exception e) {
      //log the error, but set as much as we can with the input given
      log('Failed to execute callout. SFDC Reports: ', e, e.getMessage());
      if (headers != null) {
        this.headers = headers;
      }
      this.body = body;
      this.url = url;
      this.method = method;
    }
  }
  public RestClient(String url, HttpVerb method) {
    this(url, method, null, null);
  }
  public RestClient(String url, HttpVerb method, Map<String, String> headers) {
    this(url, method, headers, null);
  }
  public RestClient(String url, HttpVerb method, String body) {
    this(url, method, null, body);
  }

  private HttpRequest buildRequest(
    String url,
    HttpVerb method,
    Map<String, String> headers,
    String body
  ) {
    HttpRequest request = new HttpRequest();
    request.setTimeout(this.timeout); // timeout in milliseconds
    if (headers != null) {
      for (String hkey : headers.keySet()) {
        request.setHeader(hkey, headers.get(hkey));
      }
    }
    request.setEndpoint(url);
    request.setMethod(method.name());
    if (body != null && body.length() > 0) {
      request.setBody(body);
    }
    return request;
  }

  private HttpResponse makeRequest(Http h, HttpRequest request) {
    HttpResponse response = h.send(request);
    if (response.getStatusCode() > 299) {
      throw new RestClientException(
        'Failed to recieve a success code from remote. Code was: ' +
        response.getStatusCode() +
        ' request was ' +
        request +
        ' Response Body is: ' +
        response.getBody()
      );
    }
    return response;
  }

  private String handleResponse(HttpResponse response) {
    log('Response', response, response.getBody());
    return response.getBody();
  }

  private String request(String url, HttpVerb method) {
    RestClient x = new RestClient(url, method);
    return x.responseBody;
  }
  private String request(
    String url,
    HttpVerb method,
    Map<String, String> headers
  ) {
    RestClient x = new RestClient(url, method, headers);
    return x.responseBody;
  }

  public String get(String url) {
    return this.request(url, HttpVerb.GET);
  }
  public String get(String url, Map<String, String> headers) {
    return this.request(url, HttpVerb.GET, headers);
  }
  public HttpResponse post(
    String url,
    Map<String, String> headers,
    String body
  ) {
    RestClient x = new RestClient(url, HttpVerb.POST, headers, body);
    return x.response;
  }
  private void log(String header, Object obj, String msg) {
    if (!this.debug) {
      return;
    }
    String startStop = '\n===============================================================================';
    String logOutput = startStop;
    logOutput += (header != null)
      ? '\n== Header: ' + header
      : 'Header: No Header Set';
    logOutput += (obj != null)
      ? '\n== Obj String Rep: ' + obj
      : '\n No Obj set';
    logOutput += (msg != null) ? '\n== ' + msg : '';
    logOutput += startStop;
    lastDebugMessage = logOutput;

    System.debug(logOutput);
  }
}
