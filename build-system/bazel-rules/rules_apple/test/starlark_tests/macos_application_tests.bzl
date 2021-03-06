# Copyright 2019 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""macos_application Starlark tests."""

load(
    ":rules/apple_verification_test.bzl",
    "apple_verification_test",
)
load(
    ":rules/common_verification_tests.bzl",
    "archive_contents_test",
)
load(
    ":rules/dsyms_test.bzl",
    "dsyms_test",
)
load(
    ":rules/infoplist_contents_test.bzl",
    "infoplist_contents_test",
)
load(
    ":rules/analysis_xcasset_argv_test.bzl",
    "analysis_xcasset_argv_test",
)

def macos_application_test_suite():
    """Test suite for macos_application."""
    name = "macos_application"

    apple_verification_test(
        name = "{}_codesign_test".format(name),
        build_type = "device",
        target_under_test = "//test/starlark_tests/targets_under_test/macos:app",
        verifier_script = "verifier_scripts/codesign_verifier.sh",
        tags = [name],
    )

    apple_verification_test(
        name = "{}_entitlements_test".format(name),
        build_type = "device",
        target_under_test = "//test/starlark_tests/targets_under_test/macos:app",
        verifier_script = "verifier_scripts/entitlements_verifier.sh",
        tags = [name],
    )

    archive_contents_test(
        name = "{}_additional_contents_test".format(name),
        build_type = "device",
        contains = [
            "$CONTENT_ROOT/Additional/additional.txt",
            "$CONTENT_ROOT/Nested/non_nested.txt",
            "$CONTENT_ROOT/Nested/nested/nested.txt",
        ],
        target_under_test = "//test/starlark_tests/targets_under_test/macos:app",
        tags = [name],
    )

    archive_contents_test(
        name = "{}_resources_test".format(name),
        build_type = "device",
        contains = [
            "$CONTENT_ROOT/Resources/resource_bundle.bundle/Info.plist",
            "$CONTENT_ROOT/Resources/Another.plist",
        ],
        target_under_test = "//test/starlark_tests/targets_under_test/macos:app",
        tags = [name],
    )

    archive_contents_test(
        name = "{}_strings_device_test".format(name),
        build_type = "device",
        target_under_test = "//test/starlark_tests/targets_under_test/macos:app",
        contains = [
            "$RESOURCE_ROOT/localization.bundle/en.lproj/files.stringsdict",
            "$RESOURCE_ROOT/localization.bundle/en.lproj/greetings.strings",
        ],
        tags = [name],
    )

    dsyms_test(
        name = "{}_dsyms_test".format(name),
        target_under_test = "//test/starlark_tests/targets_under_test/macos:app",
        expected_dsyms = ["app.app"],
        tags = [name],
    )

    infoplist_contents_test(
        name = "{}_plist_test".format(name),
        target_under_test = "//test/starlark_tests/targets_under_test/macos:app",
        expected_values = {
            "BuildMachineOSBuild": "*",
            "CFBundleExecutable": "app",
            "CFBundleIdentifier": "com.google.example",
            "CFBundleName": "app",
            "CFBundleSupportedPlatforms:0": "MacOSX",
            "DTCompiler": "com.apple.compilers.llvm.clang.1_0",
            "DTPlatformBuild": "*",
            "DTPlatformName": "macosx",
            "DTPlatformVersion": "*",
            "DTSDKBuild": "*",
            "DTSDKName": "macosx*",
            "DTXcode": "*",
            "DTXcodeBuild": "*",
            "LSMinimumSystemVersion": "10.10",
        },
        tags = [name],
    )

    # Tests xcasset tool is passed the correct arguments.
    analysis_xcasset_argv_test(
        name = "{}_xcasset_actool_argv".format(name),
        target_under_test = "//test/starlark_tests/targets_under_test/macos:app",
        tags = [name],
    )

    infoplist_contents_test(
        name = "{}_multiple_plist_test".format(name),
        target_under_test = "//test/starlark_tests/targets_under_test/macos:app_multiple_infoplists",
        expected_values = {
            "AnotherKey": "AnotherValue",
            "CFBundleExecutable": "app_multiple_infoplists",
        },
        tags = [name],
    )

    native.test_suite(
        name = name,
        tags = [name],
    )
