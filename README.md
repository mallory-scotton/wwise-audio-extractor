# 🎵 Wwise Audio Extractor

"Wwise Audio Extractor" is a small script which automatically **extracts** and **renames**
[WwiseAudio](https://www.audiokinetic.com/en/wwise/overview/) soundbanks.

> [!WARNING]
> The script has been developped in 2021 and has not been updated since.

## Dependencies

- [ww2ogg](https://github.com/hcs64/ww2ogg)
  - Convert Wem to Ogg.
- [revorb](https://github.com/ItsBranK/ReVorb)
  - Recomputes page granule positions in Ogg Vorbis files.
- [bnkextr](https://github.com/eXpl0it3r/bnkextr)
  - *.BNK File Extractor
- batool

## Usage

__*Only for Unreal Engine__

First you must have extracted `.bnk`, `.xml`, `.json` and `.txt` files from the UE game you want.
Using `UnrealPak.exe`:

```batch
"%UE_PATH%\Engine\Binaries\Win64\UnrealPak.exe" "%GAME_PATH%\Content\Paks\***.pak" -Extract "%UNPACK_PATH%"
```
- `%UE_PATH%`: The Unreal Engine location
- `%GAME_PATH%`: The game path you want to extract
- `%UNPACK_PATH`: Where you want it to be extracted

__*For everyone__

Place all the `.bnk`, `.txt`, `.xml` and `.json` files in the `/banks` folder.

Run the script: `process.bat`

Type the bank name without the extension. (e.g. To extract `Weapon_MP5.bnk`, I will write `Weapon_MP5`)

Now wait until the process is completed.

You can find the final assets in `/progress/ended/%BANK_NAME%`.

## Thanks You
