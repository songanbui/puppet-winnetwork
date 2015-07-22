# winnetwork

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with winnetwork](#setup)
    * [What winnetwork affects](#what-winnetwork-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with winnetwork](#beginning-with-winnetwork)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The winnetwork modules manages proxy and DNS settings for Windows machines.

Unlike UNIX systems, Windows does not have a concept of System Proxy but instead applications use either WinINET or WinHTTP library proxy. 

WinINET is an API enabling applications to interact with FTP and HTTP protocols to access Internet resources. It is basically the core of Internet Explorer. It is, with a few exceptions, a superset of WinHTTP. Most applications use the WinINET proxy while services or service-like processes that require impersonation and session isolation use WinHTTP.

Find more information proxy configuration at the following MSDN link: [Understanding Web Proxy Configuration](http://blogs.msdn.com/b/ieinternals/archive/2013/10/11/web-proxy-configuration-and-ie11-changes.aspx)

## Module Description

The winnetwork module manages:

* proxy settings for Windows WinINET and WinHTTP libraries system-wide
* primary and secondary DNS

## Setup

### What winnetwork affects

* WinINET proxy configuration from registry keys and values
* WinHTTP proxy configuration from netsh application
* DNS configuration from netsh application

### Setup Requirements **OPTIONAL**

##### On the PuppetMaster
* [puppetlabs/powershell](https://forge.puppetlabs.com/puppetlabs/powershell)
* [puppetlabs/registry](https://forge.puppetlabs.com/puppetlabs/registry)
* [songanbui/devxexec](https://github.com/songanbui/puppet-devxexec)

### Beginning with winnetwork

To configure a proxy by host, port and bypass list for both WinINET and WinHTTP libraries:
```puppet
class { 'winnetwork::proxy':
  $proxy_host   => '0.0.0.1',
  $proxy_port   => '80',
  $proxy_bypass => 'localhost;127.0.0.1;',
}
```

To configure proxy for only WinINET library:
```puppet
class { 'winnetwork::proxy::wininet':
  $proxy_host   => '0.0.0.1',
  $proxy_port   => '80',
  $proxy_bypass => 'localhost;127.0.0.1;',
}
```

To configure proxy for only WinHTTP library:
```puppet
class { 'winnetwork::proxy::winhttp':
  $proxy_host   => '0.0.0.1',
  $proxy_port   => '80',
  $proxy_bypass => 'localhost;127.0.0.1;',
}
```

To configure a proxy by an automatic configuration script (PAC file) for WinINET library:
```puppet
class { 'winnetwork::proxy::wininetpac':
  $proxy_pac    = 'http://localhost/proxy.pac',
}
```
*Automatic scripts are not supported by WinHTTP library.*

To configure DNS: 
```puppet
class { 'winnetwork::dns':
  $dns_primary   = '0.0.0.1',
  $dns_secondary = '0.0.0.2',
}
```

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
