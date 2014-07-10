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
* the track order (last played track is on top or bottom of the HTTP response)

In mostly all radio stations website, you can find a module telling you which track is currently playing.
By analyzing HTTP request (with `Firebug` for example), you could easily retrieve the HTTP request URL for this module.

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
With that, you should be able to deduce the artist key-path which is `info.artiste` and the title key-path which is `info.chanson` in this case (`xml` root element is ignored by `RadioKit`).
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
Then, simply use the following method to fetch last played tracks :
```ios
- (void)lastTracks:(ROKRadioLastTracksBlock)completion;
```
Results will be send as a block parameter and will be an array of `ROKTrack` objects.
Example :
```ios
ROKRadio *voltage = [ROKRadio radioWithRequestURL:@"http://www.voltage.fr/rcs/playing.xml"
                                   responseFormat:ROKRequestResponseFormatXML
                                       trackOrder:ROKRadioTrackOrderAsc
                                     titleKeyPath:@"info.chanson"
                                    artistKeyPath:@"info.artiste"];
[voltage lastTracks:^(ROKRequest *request, NSArray *tracks, NSError *error) {
    NSLog(@"%@", request);
    NSLog(@"%@", tracks);
    NSLog(@"%@", error);
}];
```

NB : Behind the scene, `ROKRadio` works with a `ROKRequest` object which is the real one performing requests.

## Object mapping
`RadioKit` provides you the capability to specify custom objects type as your query results. You only have to set the `trackMappingClass` property of a `ROKRadio` object.
The only condition is that your custom class conforms to the `ROKTrack` protocol.

## Track comparison
`ROKTrack` class provides methods to compare track using the `Levenshtein` algorithm (http://en.wikipedia.org/wiki/Levenshtein_distance). `ROKTrack` comparison methods need a 85% of matching in order to consider two tracks as the same.
```ios
- (BOOL)compareTrackWithTitle:(NSString *)title artist:(NSString *)artist;
- (BOOL)compareTrack:(ROKTrack *)track;
```

## Release notes
Version 1.0
* Initial release
