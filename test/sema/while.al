// RUN: compiler %s -res-dump 2>&1 | filecheck %s
fn foo(): void {}

fn bar(): number { return 1.0; }

fn main(): void {
    while bar() {}

    // CHECK: [[# @LINE + 1 ]]:14: error: expected number in condition
    while foo() {}
}
