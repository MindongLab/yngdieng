load("//web/tools:ng_ts_library.bzl", ng_module = "ng_ts_library")

package(default_visibility = ["//web:__subpackages__"])

ng_module(
    name = "material",
    srcs = ["material.module.ts"],
    module_name = "@yngdieng-web/shared/material",
    tsconfig = "//:tsconfig.json",
    deps = [
        "@npm//@angular/cdk",
        "@npm//@angular/core",
        "@npm//@angular/material",
    ],
)
