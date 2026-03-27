> # System Initialization via Scoop
>
> ## Overview
>
> This project provides a PowerShell script to install Windows software using Scoop based on a JSON configuration file.
>
> It is designed to:
>
> - Manage software installation declaratively
> - Automatically handle Scoop buckets (including custom repositories)
> - Support grouped installation for different environments
>
> Typical use cases include:
>
> - Initializing a new development machine
> - Reproducing a consistent environment
> - Managing toolchains across multiple setups
>
> ------
>
> ## Usage
>
> ### 1. Prerequisites
>
> Ensure Scoop is installed (need Admin):
>
> ```powershell
> iwr -useb get.scoop.sh | iex
> ```
>
> ------
>
> ### 2. Run Script
>
> Install all configured applications:
>
> ```powershell
> .\scoopInstall.ps1
> ```
>
> Specify a configuration file:
>
> ```powershell
> .\scoopInstall.ps1 -f .\apps.json
> ```
>
> Install specific groups:
>
> ```powershell
> .\scoopInstall.ps1 -f .\apps.json -Groups base,dev
> ```
>
> ------
>
> ## Configuration File
>
> The script uses a JSON file (default: `apps.json`) to define:
>
> - Buckets (optional)
> - Application groups
>
> ### Structure Overview
>
> ```json
> {
>   "buckets": {
>     "extras": {},
>     "custom-bucket": {
>       "url": "https://example.com/repo.git"
>     }
>   },
>   "groups": {
>     "base": [
>       { "name": "git" },
>       { "name": "7zip" }
>     ],
>     "dev": [
>       { "name": "vscode", "bucket": "extras" }
>     ]
>   }
> }
> ```
>
> ### Notes
>
> - `buckets`
>   Defines Scoop buckets to be added before installation.
>   - If `url` is provided, a custom repository will be used
>   - If empty, the default Scoop bucket source is used
> - `groups`
>   Organizes applications into logical sets (e.g., `base`, `dev`, `tools`)
> - `name`
>   The package name used by `scoop install`
> - `bucket` (optional)
>   Specifies which bucket the application belongs to
> - You can search for applications on [scoop website](https://scoop.sh/)
>
> ------
>
> ## Example
>
> Instead of manually running:
>
> ```powershell
> scoop bucket add scoopcn https://github.com/scoopcn/scoopcn.git
> scoop install baidudisk
> scoop install tim
> ```
>
> You can define:
>
> ```json
> {
>   "buckets": {
>     "scoopcn": {
>       "url": "https://github.com/scoopcn/scoopcn.git"
>     }
>   },
>   "groups": {
>     "tools": [
>       { "name": "baidudisk", "bucket": "scoopcn" },
>       { "name": "tim", "bucket": "scoopcn" }
>     ]
>   }
> }
> ```
>
> Then run:
>
> ```powershell
> .\scoopInstall.ps1 -Groups tools
> ```
>
> ------
>
> ## Recommendation
>
> Refer to the provided `apps.json` file in this repository for a complete example configuration.
>
> You can modify or extend it based on your own environment needs.
>
> ------
>
> ## License
>
> MIT