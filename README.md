RadioKit
========

Retrieve radio stations last played tracks with `RadioKit`.

## Installation
Simply drag `RadioKit` folder into your project source folder.

## Dependencies
* `XMLDictionary` (https://github.com/nicklockwood/XMLDictionary)
* `AFNetworking` (https://github.com/AFNetworking/AFNetworking)

## Initial step - determine all necessary informations
In order to query last played tracks for a given radio station, you will have to identify mandatory informations such as :
* the request URL
* the HTTP response format (usually `JSON` or `XML`)
* the response artist and title key-path (this part will be explain below)
* the track order in the response (last played track is on top or bottom on the response)

In mostly all radio stations website, you can find a module telling you which track is currently playing.
By analyzing HTTP request (with `Firebug` for example), you would easily able to retrieve the request URL for this module.

Once you have found it, you will have to analyze the HTTP response.
Example :
```
curl http://www.voltage.fr/rcs/playing.xml
<xml>
	<info>
		<artiste>EMINEM</artiste>
		<chanson>Rap God</chanson>
	</info>
</xml>

```
With this, you would be able to deduce the artist key-path which is `info.artiste` and the title key-path which is `info.chanson`.
NB : `xml` root element is ignored by `RadioKit`
You should also easily deduce the track order by comparing the response with the web module output.

## Requesting last played tracks with `RadioKit`
Now you have gathered all you need, you can start using `RadioKit` by creating a `ROKRadio` object using the following method :
```ios
+ (instancetype)radioWithRequestURL:(NSString *)requestURL
                     responseFormat:(ROKRequestResponseFormat)responseFormat
                         trackOrder:(ROKRadioTrackOrder)trackOrder
                       titleKeyPath:(NSString *)titleKeyPath
                      artistKeyPath:(NSString *)artistKeyPath;
```

