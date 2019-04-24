#!/usr/bin/env bash
set -ex

DISABLE_AUTH=true dotnet test ./test/PalTrackerTests
artifacts_path=/tmp/artifacts

build_output="/tmp/build-output"
artifacts_path="./artifacts"
version=$1

mkdir -p $build_output
mkdir -p $artifacts_path

cp manifest-*.yml $build_output
echo "--------$build_output--------------" 
echo $build_output
echo "----------------------------------"
cp scripts/migrate-databases.sh $build_output
cp -r databases $build_output
<<<<<<< HEAD
=======

>>>>>>> b6c6ce592dba3d38f12c0a5926eeee44dfbc6cce
dotnet publish src/PalTracker --configuration Release \
    --output $build_output/src/PalTracker/bin/Release/netcoreapp2.2/publish

tar -C $build_output/ -cvzf $artifacts_path/pal-tracker-$version.tgz .
