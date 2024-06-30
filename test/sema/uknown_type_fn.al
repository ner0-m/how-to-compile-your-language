// RUN: compiler %s -res-dump 2>&1 | filecheck %s

// CHECK: [[# @LINE + 1 ]]:1: error: function 'foo' has invalid 'userDefinedType' type
fn foo(): userDefinedType {}

fn main(): void {}
