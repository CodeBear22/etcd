#!/usr/bin/env bash

cd etcd

go clean
go clean -cache
go clean -testcache
go clean -modcache

echo "##### Build #####"

GO_BUILD_FLAGS='-v -mod=readonly' GOARCH=arm64  ./build.sh

echo "##### fmt bom dep #####"
GOARCH=amd64 PASSES='fmt dep' ./test.sh

# echo "##### unit #####"
# GOARCH=arm64 PASSES='unit' RACE='true' CPU='4' ./test.sh -p=2

echo "##### integration #####"
GOARCH=arm64 CPU=1 PASSES='integration' RACE='false' ./test.sh
GOARCH=arm64 CPU=2 PASSES='integration' RACE='false' ./test.sh
GOARCH=arm64 CPU=4 PASSES='integration' RACE='false' ./test.sh

echo "##### functional #####"
GOARCH=arm64 PASSES='functional' ./test.sh

echo "##### ete #####"
PASSES='e2e' CPU='4' EXPECT_DEBUG='true' COVER='false' RACE='true' ./test.sh

echo "##### grpcproxy #####"
PASSES='grpcproxy' GOARCH=arm64  CPU='4' COVER='false' RACE='true' ./test.sh


# revive func unit 