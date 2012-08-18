Macchina
========

This is my experimentation about reverse engineering the Native Instruments Maschine.

The Maschine is a combination of a rhythm oriented software sampler, and a custom USB
hardware controller that exposes most of the software features.

State of the project
--------------------

Everything you see here is "proof of concept"-stage. Everything in this repository is
meant for my entertainment purposes only, and it is **NOT** stable software.

If you want, however, you can have the same fun I am having in working with this fun piece
of hardware, even when you're not in a music-making mood.

Currently with code contained in this repository you can connect to the Maschine USB
controller, get the raw input of pads, knobs and switches, and set the state of the leds
and, _yes_, upload images to the device's displays.

One part that I've completely neglected in order to work on the fun part first is error
handling and graceful termination. That means that frequent reboots of the various
services are required, to get your system in a stable and predictable state.

Patches and pull-requests are always welcome, of course =).

Other hardware controllers
--------------------------

It just happened that I had a Maschine laying around, but from my experimentation it seems
that a lot of this work can be used to support any other Native Instruments hardware, with
the required modifications.

If you want, you can send me your favorite controller and I'll try to make it work ;).

Organization of the project
---------------------------

The project is intended to run in Mac OS X only.

In the Xcode project you can find two targets:

- MacchinaClient, and
- MacchinaServer.

This reflects the organization of the Native Instrument's original software.

MacchinaClient is a Mac commandline application that connects to the NIHardwareAgent
daemon, waits for a Maschine controller to focus on it's instance, and then light up some
leds and log the incoming messages.

MacchinaServer, on the other end, is its dual. This application will expose to clients the
same interface of NIHardwareAgent, and it will do the minimum in order to let clients such
as the Maschine standalone or Maschine plugins, or even the Controller Editor to connect
and log their requests.

Running the project
-------------------

As I said, currently this is a proof of concept. If you don't understand this paragraph
(and you can exclude it is not because of my english) I advise you to stop. My Maschine
didn't fry up, but I have just some knowledge of what I am doing.

### To run MacchinaClient (and enjoy a bit of light show)

1. Open the project in Xcode
2. Select the client from the Scheme menu
3. Make sure NIHardwareAgent is running

    Selena:~ willy$ ps ax | grep NIHardwareAgent
    13487 s001  U      0:01.24 /Library/Application Support/Native Instruments/Hardware/NIHardwareAgent.app/Contents/MacOS/NIHardwareAgent
    13491 s001  R+     0:00.00 grep NIHardwareAgent
    Selena:~ willy$ 

4. Run the target
5. Close anything that might use your Maschine
6. If it was not connected, connect the Maschine hardware controller
7. In the Maschine controller, open the Instance menu and load it

### To run MacchinaServer (and take a look under the hood)

1. Close anything that might use your Maschine, or any other Native Instrument controller
2. Make sure NIHardwareAgent is **NOT** running
3. In Xcode, select the server from the scheme menu
4. Run the target
5. Open some application that uses the Native Instrument controller
6. Check the MacchinaServer logs for the detailed information on the underlying
   communication

Legal
-----

Basically, you can do whatever you like with my works. Just do not expect they're perfect
(they're far from it), so I can't give you any warranty of anything. Also, if you want to
use my works in *your* work, I'd love to see it, but of course I can't force people to
have my same choices, so I won't.

So, the software in this repository is released under the MIT license, of which you can
find a copy at the end of this document.

License
-------

Copyright (c) 2012 Antonio Malara

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

Cease and desist
----------------

If you, however, are a representative of Native Instruments particularly offended and
bothered with my tinkering with my stuff developed by you, just send me a friendly note.

Life is short to deal with litigations.
