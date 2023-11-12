# Word Definition App

Search for a word using the search bar and receive definitions for that word.

# Implementation Notes

Testing is not as robust as I'd like, but this could sap an entire day to get proper coverage.

I opted for a basic one page design rather than anything that used multiple pages and routing, this was because I wanted to reduce UX overhead of switching between pages for little reason.

BLoC, Hydration, providers etc. was a bit overkill for a simple app like this, but was used as a demonstration of these features more than the app requiring them for functionality.

I used https://app.quicktype.io/ for the models with some of my own getters and removal of redundant properties.

# Features

### Search

Basic `textField` with trailing `iconButton` to search, also searches on enter/done etc.  
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/image-5.png)

### Display

This is a `List` of `DictionaryEntry`'s which is basically a single word with multiple definitions.  
This list of words and associated definitions will persist through app reloads thanks to `hydrated_bloc`.

The list is set to only display a maximum of 10 items at any given time.

### Interaction
You are able to toggle displaying one or multiple definitions by opening the options (`settings` icon) and switching the toggle:  
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/image.png)

The red `iconButton` will prompt you to remove a single item from the search history:  
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/image-2.png)

Whereas the `FloatingActionButton` will prompt and remove ALL search history items:  
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/image-3.png)

The question mark `iconButton` will display a basic help dialog:  
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/image-4.png)



# Getting it Running

### Web

I have hosted a web build at: https://grantbrown-adl.github.io/

I've only tested on Chrome, ~~but didn't notice any issues with functionality.~~  
```
On mobile (Android) there is an issue with keyboard that drops focus, this won't allow you to use the app on an android (and possibly iOS) browser without a keyboard attached (making the web version somewhat useless on mobile).  
App .apk tested and working OK. Not sure if it's a `device_preview` issue, but not going to spend time troubleshooting. 
``` 
It includes the `device_preview` package, that lets you test things such as different devices and `dark mode` etc,

![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/image-1.png)


### iOS / Android

I developed this on a `Windows` machine, but have access to a `Mac` of which I will attempt to clone, run and build on an XCode simulator.  

_Note that I use this daily as a dev machine, and everything is already setup so I may miss something or it may not work exactly as described below due to a variety of reasons._

#### Pre-requisites:
* Install VSCode: https://code.visualstudio.com/docs/setup/mac
* Install Flutter: https://docs.flutter.dev/get-started/install/macos

#### Instructions:

* Clone or download the repo. I'm using `SSH` but `HTTPS` should work.  
Then open in `VS Code`:
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/PastedGraphic-2.png)
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/PastedGraphic-3.png)

* Once `VS Code` loads open the terminal with `cmd+j`:
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/PastedGraphic-4.png)

* My `flutter doctor` for reference:
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/PastedGraphic-6.png)

* Run `flutter pub get` to download all the requiered packages:
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/PastedGraphic-5.png)

* Run `flutter pub run build_runner build --delete-conflicting-outputs` to build out generated `freezed` components:
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/PastedGraphic-7.png)

* Open / select simulator  
Selecting the item at `Chrome (web-javascript)` on bottom right hand side of the screenshot should open the device selector. It may be something other than `Chrome (web-javascript)` but the location is the same:
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/PastedGraphic-8.png)

* After selecting you can see the `Chrome (web-javascript)` has changed to `iPhone 14 (ios simulator)`:
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/PastedGraphic-9.png)

* Once the simulator is open, open the `main.dart` file under `lib` and press `f5` or `Build > Run` from the toolbar menu:  
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/PastedGraphic-10.png)
![Alt text](https://github.com/grantbrown-adl/dictionary_definitions_app/blob/main/readme_images/PastedGraphic-11.png)

### Video of App Running on Simulator

https://github.com/grantbrown-adl/dictionary_definitions_app/assets/18681967/be062b53-3e84-4d00-8dae-0fa0ba6a638e



# API Details

#### API: https://dictionaryapi.dev/

#### Endpoint: https://api.dictionaryapi.dev/api/v2/entries/en/<word\>

Failure JSON:

```json
{
  "title": "No Definitions Found",
  "message": "Sorry pal, we couldn't find definitions for the word you were looking for.",
  "resolution": "You can try the search again at later time or head to the web instead."
}
```

Success JSON:

```json
[
  {
    "word": "success",
    "phonetic": "/səkˈsɛs/",
    "phonetics": [
      { "text": "/səkˈsɛs/", "audio": "" },
      {
        "text": "/səkˈsɛs/",
        "audio": "https://api.dictionaryapi.dev/media/pronunciations/en/success-us.mp3",
        "sourceUrl": "https://commons.wikimedia.org/w/index.php?curid=1239760",
        "license": {
          "name": "BY-SA 3.0",
          "url": "https://creativecommons.org/licenses/by-sa/3.0"
        }
      }
    ],
    "meanings": [
      {
        "partOfSpeech": "noun",
        "definitions": [
          {
            "definition": "The achievement of one's aim or goal.",
            "synonyms": [],
            "antonyms": ["failure"],
            "example": "His third attempt to pass the entrance exam was a success."
          },
          {
            "definition": "Financial profitability.",
            "synonyms": [],
            "antonyms": [],
            "example": "Don't let success go to your head."
          },
          {
            "definition": "One who, or that which, achieves assumed goals.",
            "synonyms": [],
            "antonyms": [],
            "example": "Scholastically, he was a success."
          },
          {
            "definition": "The fact of getting or achieving wealth, respect or fame.",
            "synonyms": [],
            "antonyms": [],
            "example": "She is country music's most recent success."
          },
          {
            "definition": "Something which happens as a consequence; the outcome or result.",
            "synonyms": [],
            "antonyms": []
          }
        ],
        "synonyms": [],
        "antonyms": ["failure"]
      }
    ],
    "license": {
      "name": "CC BY-SA 3.0",
      "url": "https://creativecommons.org/licenses/by-sa/3.0"
    },
    "sourceUrls": ["https://en.wiktionary.org/wiki/success"]
  }
]
```
