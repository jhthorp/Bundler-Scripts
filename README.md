# Bundler Scripts

The scripts within this project are to assist in bundling various scripts for 
different systems such as Windows, MacOS, Linux, FreeBSD, TrueNAS, etc. into a 
ready-to-deploy archive.

## Table of Contents

* [Warnings](#warnings)
* [Getting Started](#getting-started)
* [Prerequisites](#prerequisites)
* [Setup](#setup)
* [Scripts](#scripts)
	* [create_bundle.sh](#create_bundlesh)
	* [create_bundle_dir.sh](#create_bundle_dirsh)
* [Deployment](#deployment)
* [Dependencies](#dependencies)
* [Notes](#notes)
* [Test Environments](#test-environments)
	* [Operating System Compatibility](#operating-system-compatibility)
	* [Hardware Compatibility](#hardware-compatibility)
* [Contributing](#contributing)
* [Support](#support)
* [Versioning](#versioning)
* [Authors](#authors)
* [Copyright](#copyright)
* [License](#license)
* [Acknowledgments](#acknowledgments)

## Warnings

This project does not contain any warnings at this time.

## Getting Started

These instructions will get you a copy of the project up and running on your 
local machine for development and testing purposes. See 
[deployment](#deployment) for notes on how to deploy the project on a live 
system.

### Prerequisites

* [Utility-Scripts](https://github.com/jhthorp/Utility-Scripts) exist at the 
same directory path

### Setup

In order to use the scripts within this package, you will need to clone, or 
download, the [Utility-Scripts](https://github.com/jhthorp/Utility-Scripts) 
repository into the same top-level directory path.

```
/path/to/Utility-Scripts
/path/to/Bundler-Scripts
```

## Scripts

### create_bundle.sh

A script to create an archived bundle from a given directory 
(E.X. Linux-Scripts) including all of the utility scripts from the 
Utility-Scripts package.

_Usage_

```
[bash] ./create_bundle.sh [auto_skip] <srcDir> <completeBundleName>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|     Source Directory      |                 Source directory                 |
|        Bundle Name        |            Name for the output bundle            |

_Examples_

* **./create_bundle.sh** "../Utility-Scripts" "Utilities"
* **./create_bundle.sh** "../TrueNAS-Scripts" "TrueNAS"
* **./create_bundle.sh** "auto_skip" "../TrueNAS-Scripts" "TrueNAS"

### create_bundle_dir.sh

A script to copy all nested files from a directory into a single flat directory 
for bundling as an archive.

_Usage_

```
[bash] ./create_bundle_dir.sh [auto_skip] <srcDir> <bundlesDir> <destDirName> 
<filenameStructure> [keepStructure]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|     Source Directory      |                 Source directory                 |
|     Bundles Directory     |                Bundles directory                 |
|   Destination Directory   |     Name of the destination bundle directory     |
|      File Name REGEX      |            REGEX for files to bundle             |
|   Maintain Directories    |      Switch to keep the directory structure      |

_Examples_

* **./create_bundle_dir.sh** "../Utility-Scripts" "../_bundles" 
"Utility-Scripts" '*.sh' false
* **./create_bundle_dir.sh** "../TrueNAS-Scripts" "../_bundles" 
"TrueNAS-Scripts" '*.sh' true
* **./create_bundle_dir.sh** "auto_skip" "../TrueNAS-Scripts" "../_bundles" 
"TrueNAS-Scripts" '*.sh' true

## Deployment

This section provides additional notes about how to deploy this on a live 
system.

## Dependencies

* [Utility-Scripts](https://github.com/jhthorp/Utility-Scripts) - A collection 
of utility scripts.

## Notes

This project does not contain any additional notes at this time.

## Test Environments

### Operating System Compatibility

|        Status        |                        System                         |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                     MacOS 11.2.x                      |
|  :white_check_mark:  |                     MacOS 11.1.x                      |
|  :white_check_mark:  |                     MacOS 11.0.x                      |

### Hardware Compatibility

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |              MacBook Pro (15-inch, 2018)              |

## Contributing

Please read [CODE_OF_CONDUCT](.github/CODE_OF_CONDUCT.md) for details on our 
Code of Conduct and [CONTRIBUTING](.github/CONTRIBUTING.md) for details on the 
process for submitting pull requests.

## Support

Please read [SUPPORT](.github/SUPPORT.md) for details on how to request 
support from the team.  For any security concerns, please read 
[SECURITY](.github/SECURITY.md) for our related process.

## Versioning

We use [Semantic Versioning](http://semver.org/) for versioning. For available 
releases, please see the 
[available tags](https://github.com/jhthorp/Bundler-Scripts/tags) or look 
through our [Release Notes](.github/RELEASE_NOTES.md). For extensive 
documentation of changes between releases, please see the 
[Changelog](.github/CHANGELOG.md).

## Authors

* **Jack Thorp** - *Initial work* - [jhthorp](https://github.com/jhthorp)

See also the list of 
[contributors](https://github.com/jhthorp/Bundler-Scripts/contributors) who 
participated in this project.

## Copyright

Copyright © 2020 - 2021, Jack Thorp and associated contributors.

## License

This project is licensed under the GNU General Public License - see the 
[LICENSE](LICENSE.md) for details.

## Acknowledgments

* N/A