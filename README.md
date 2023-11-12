# Word Definition App

Search for a word using the search bar and receive definitions for that word.

# Considerations

lorem ipsum

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
