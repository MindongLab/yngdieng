load("//web/tools:ng_ts_library.bzl", ng_module = "ng_ts_library")
load("@io_bazel_rules_sass//:defs.bzl", "multi_sass_binary")

ng_module(
    name = "app",
    srcs = glob(
        ["**/*.ts"],
        exclude = [
            "**/*.spec.ts",
        ],
    ),
    angular_assets = glob([
        "**/*.css",
        "**/*.html",
    ]) + [":styles"],
    tsconfig = "//:tsconfig.json",
    visibility = ["//web:__subpackages__"],
    deps = [
        "//web/shared/material",
        "//yngdieng/admin/v1:resources_ts_proto",
        "//yngdieng/admin/v1:service_ts_proto",
        "@npm//@angular/cdk",
        "@npm//@angular/common",
        "@npm//@angular/core",
        "@npm//@angular/forms",
        "@npm//@angular/material",
        "@npm//@angular/platform-browser",
        "@npm//@angular/router",
        "@npm//@auth0/auth0-angular",
        "@npm//@types",
        "@npm//howler",
        "@npm//rxjs",
    ],
)

multi_sass_binary(
    name = "styles",
    srcs = glob(
        ["**/*.scss"],
        exclude = [
            "styles.scss",
            "custom-theme.scss",
        ],
    ),
)
