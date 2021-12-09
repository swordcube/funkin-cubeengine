<div align="center"> <img src="https://github.com/swordcube/funkin-cubeengine/blob/main/art/stupid%20shit/cube%20engine%20logo.png" height=350 width=500 align="center"></div>
<div align="center">An experimental engine by swordcube</div>

# About the engine

Cube Engine is an engine for Friday Night Funkin' designed to make neat little improvements to the game. Here's our to-do list and what we've done so far:

## Fully finished:
- Toggleable Outdated Warning / Yes, you can disable that stupid fucking outdated warning at the beginning of the game now.
- Downscroll & Middlescroll / Self explanatory.
- Ghost Tapping / If you have this disabled when you press a note that doesn't exist you'll get a miss.
- Flashing Lights / Disables all flashing lights in the game, Includes menus n shit.
- Anti-Aliasing / Makes performance go a bit faster on decent/shit computers
- Framerate / Change how much s p e e d your game has, somehow helps rhythm game players idfk i'm not a fucking osu!mania player
- Hit Sounds / If this is enabled, A hit sound will play when you hit a note, That hitsound being from osu!.
- Scroll Speed / Change how much s p e e d your notes have lol
- Song Time Bar / If this is enabled, The song name & difficulty along with the time remaining will show at the top or bottom of the screen during gameplay.
- Toggle FPS Counter / Do you want the funny FPS thingy at the top left to fucking Die? Turn this shit off and your wish is grant!!
- Optimization / Removes all characters and background shits, good for horrible dog shit poo poo fard shit ass computers!!1
- Note Splashes / If you have this enabled, A cool firework-like effect will appear if you hit a note and get a "Sick!!" rating.
- Opponent Arrow Opacity / Changes the opacity of the opponent/enemy's arrows, idfk why you'd want to have this changed, let alone why it was added, because Raf added it not me

i have just now realized how much shit is done what the fuck

btw swordcube's writing the readme unless specified otherwise

## To-Do List:
- Low Quality / Removes only SOME background shit, good for computers that are.. decent
- Custom Note Skin / Allows you to change the look of your notes in the Note Skin menu.
- Camera Zooms / If you have this disabled the camera won't zoom every few beats or every 8276347329128748329 nanoseconds in M.I.L.F on that one part.
- Arrow Underlay / Puts a funny black background behind your arrows so you can SEE them. On certain backgrounds the arrows can blend in, so this may help.
- Underlay Opacity / Change the opacity/transparency of the Funny arrow underlay

## Cube Engine Credits / Shoutouts
- [swordcube (Me Lol)](https://twitter.com/swordcube) - Dumbass Programmer
- [Raf](https://github.com/RafaelGiacom) - 999x Smarter Programmer
- [Vienna](https://twitter.com/MarcyRoseX) - Idea suggester or smth idfk, suggested health percentage text

## Funkin' Credits / Shoutouts

- [ninjamuffin99](https://twitter.com/ninja_muffin99) - Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art
- [Kawaisprite](https://twitter.com/kawaisprite) - Musician

This game was made with love to Newgrounds and its community. Extra love to Tom Fulp.

## Build instructions

THESE INSTRUCTIONS ARE FOR COMPILING THE GAME'S SOURCE CODE!!!

IF YOU WANT TO JUST DOWNLOAD AND INSTALL AND PLAY THE GAME NORMALLY, GO TO ITCH.IO TO DOWNLOAD THE GAME FOR PC, MAC, AND LINUX!!

https://ninja-muffin24.itch.io/funkin

IF YOU WANT TO COMPILE THE GAME YOURSELF, CONTINUE READING!!!

### Installing the Required Programs

First, you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple). 
1. [Install Haxe 4.1.5](https://haxe.org/download/version/4.1.5/) (Download 4.1.5 instead of 4.2.0 because 4.2.0 is broken and is not working with gits properly...)
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe

Other installations you'd need are the additional libraries, a fully updated list will be in `Project.xml` in the project root. Currently, these are all of the things you need to install:
```
flixel
flixel-addons
flixel-ui
linc-luajit
hscript
newgrounds
```
So for each of those type `haxelib install [library]` so shit like `haxelib install newgrounds`

You'll also need to install a couple things that involve Gits. To do this, you need to do a few things first.
1. Download [git-scm](https://git-scm.com/downloads). Works for Windows, Mac, and Linux, just select your build.
2. Follow instructions to install the application properly.
3. Run `haxelib git polymod https://github.com/larsiusprime/polymod.git` to install Polymod.
4. Run `haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc` to install Discord RPC.

You should have everything ready for compiling the game! Follow the guide below to continue!

At the moment, you can optionally fix the transition bug in songs with zoomed-out cameras.
- Run `haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons` in the terminal/command-prompt.

### Ignored files

I gitignore the API keys for the game so that no one can nab them and post fake high scores on the leaderboards. But because of that the game
doesn't compile without it.

Just make a file in `/source` and call it `APIStuff.hx`, and copy & paste this into it

```haxe
package;

class APIStuff
{
	public static var API:String = "";
	public static var EncKey:String = "";
}

```

and you should be good to go there.

### Compiling game
NOTE: If you see any messages relating to deprecated packages, ignore them. They're just warnings that don't affect compiling

Once you have all those installed, it's pretty easy to compile the game. You just need to run `lime test html5 -debug` in the root of the project to build and run the HTML5 version. (command prompt navigation guide can be found here: [https://ninjamuffin99.newgrounds.com/news/post/1090480](https://ninjamuffin99.newgrounds.com/news/post/1090480))
To run it from your desktop (Windows, Mac, Linux) it can be a bit more involved. For Linux, you only need to open a terminal in the project directory and run `lime test linux -debug` and then run the executable file in export/release/linux/bin. For Windows, you need to install Visual Studio Community 2019. While installing VSC, don't click on any of the options to install workloads. Instead, go to the individual components tab and choose the following:
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)

Once that is done you can open up a command line in the project's directory and run `lime test windows -debug`. Once that command finishes (it takes forever even on a higher end PC), you can run FNF from the .exe file under export\release\windows\bin
As for Mac, 'lime test mac -debug' should work, if not the internet surely has a guide on how to compile Haxe stuff for Mac.

### Additional guides

- [Command line basics](https://ninjamuffin99.newgrounds.com/news/post/1090480)

