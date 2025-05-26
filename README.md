# Cave Survey Processing Action

This GitHub Action processes cave survey data using Survex tools and creates an artifact containing processed files.

## Features

- Processes `.svx` cave survey files using Cavern
- Generates `.3d` files from survey data
- Exports `.gpx` GPS tracks from 3D files
- Creates MD5 hashes for integrity verification
- Packages specific file types into a downloadable artifact

## Supported Repositories

- `sistem_pokljuskega_grebena`
- `kanin_rombon` 
- `planina_poljana`

## Output Artifact

The action creates `artifact.zip` containing only:
- `*.3d` files (3D cave models)
- `*.gpx` files (GPS tracks)
- `ekataster-config.json` (if present)
- `hashes.csv` (MD5 checksums)

The original folder structure is preserved in the artifact.

## Usage

```yaml
- uses: ./build
  with:
    repo: "sistem_pokljuskega_grebena"
```
