load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library")
load("@io_bazel_rules_docker//go:image.bzl", "go_image")
load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_push")

go_library(
    name = "server_lib",
    srcs = ["main.go"],
    importpath = "github.com/mindonglab/yngdieng/server/gateway",
    visibility = ["//visibility:private"],
    deps = [
        "//server/gateway/internal:go_default_library",
        "@com_github_golang_glog//:go_default_library",
    ],
)

go_binary(
    name = "gateway",
    embed = [":server_lib"],
    visibility = ["//visibility:public"],
)

go_image(
    name = "gateway_image",
    embed = [":server_lib"],
    visibility = ["//visibility:public"],
)

container_image(
    name = "image",
    base = ":gateway_image",
)
