// RUN: compiler %s -res-dump 2>&1 | filecheck %s
fn main(): void {
    // CHECK: [[# @LINE + 1 ]]:9: error: variable 'x' has invalid 'userDefinedType' type
    let x: userDefinedType = 1.0;
}
