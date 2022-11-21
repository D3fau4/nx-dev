# NX-DEV-docker
Docker image to compile applications built with libnx

## Example Setup
```yml
name: Build Homebrew

on: [push, workflow_dispatch]
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/d3fau4/nx-dev:main
    steps:
    - name: Build app
      run: |
        make -j$(nproc)
        
    - uses: actions/upload-artifact@master
      with:
        name: Homebrew
        path: homebrew.nro
```
