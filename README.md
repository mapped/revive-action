# Revive Action

👉Same as [morphy2k/revive-action](https://github.com/marketplace/actions/revive-action) but not using Docker.

Problems when using Docker:
1. Takes time pull the image.
1. Cannot upgrade Go quickly.

This Action runs [Revive](https://github.com/mgechev/revive) on your [Go](https://golang.org/) code and adds annotations to the check.

## Usage

Prepare your workflow by adding the following steps:

```YAML
- name: Check out code into the Go module directory
  uses: actions/checkout@v4

- name: Set up Go
  uses: actions/setup-go@v5
  with:
    go-version: '1.22'
```

Run

```YAML
- name: Run Revive Action by building from repository
  uses: mapped/revive-action@master
```

Configuration

```YAML
  with:
    # Path to your Revive config within the repo (optional)
    config: revive/config.toml
    # Exclude patterns, separated by semicolons (optional)
    exclude: "file.go;foo/bar.go;./foo/bar/..."
    # Path pattern (default: ./...)
    path: "./foo/..."
```

## Screenshots

![Screenshot of annotations](screenshot.png)

_GitHub Annotations_
