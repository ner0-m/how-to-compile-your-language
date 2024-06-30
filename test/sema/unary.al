// RUN: compiler %s -res-dump 2>&1 | filecheck %s
fn foo(): void {}

fn main(): void {
    // CHECK: [[# @LINE + 1 ]]:9: error: void expression cannot be used as operand to unary operator
    !foo();
}
