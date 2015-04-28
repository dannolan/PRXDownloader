# PRXDownloader

[![CI Status](http://img.shields.io/travis/dannolan/PRXDownloader.svg?style=flat)](https://travis-ci.org/dannolan/PRXDownloader)
[![Coverage Status](https://coveralls.io/repos/dannolan/PRXDownloader/badge.svg)](https://coveralls.io/r/dannolan/PRXDownloader)
[![Version](https://img.shields.io/cocoapods/v/PRXDownloader.svg?style=flat)](http://cocoapods.org/pods/PRXDownloader)
[![License](https://img.shields.io/cocoapods/l/PRXDownloader.svg?style=flat)](http://cocoapods.org/pods/PRXDownloader)
[![Platform](https://img.shields.io/cocoapods/p/PRXDownloader.svg?style=flat)](http://cocoapods.org/pods/PRXDownloader)

## Usage

There is no example project, basically just include the project, instantiate a PRXDownloader and then add URLs to your heart's content. There are notifications which are fired by the system when downloads occur

## Requirements

- An iOS Application that wants to download things and whatnot
- Patience and time as this is not particularly well documented.
- An ability to hit me up and call me a gronk if something is busted

## Installation

PRXDownloader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PRXDownloader"
```

## Purpose

This is an Objective-C version of our internal NSURLDownloadTask manager we use at [Proxima](http://proxima.io). It's pretty thin on the ground in terms of features but more stuff will come depending on how the project goes. It is really not for anyone who needs anything other than a system to download a *tonne* of files that also has database representations of these so you can show individual file download progress... or whatever

## What is the go hey

If you want to contribute, ping me on [twitter](http://twitter.com/dannolan), or just to say hey. Also lodge a PR if you want to make any additions. Stuff is thin on the ground but I wanted a proper thread-safe-ish download system with a queue and fast caching of downloads with the ability to return representations.


## Author

Dan Nolan, dan@proxima.io

## License

PRXDownloader is available under the MIT license. See the LICENSE file for more info.
