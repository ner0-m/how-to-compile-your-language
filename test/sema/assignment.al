// RUN: compiler %s -res-dump 2>&1 | filecheck %s
fn foo(): void {}

fn bar(): number { return 1.0; }

fn main(): void {
    var x: number = 1.0;

    // CHECK: [[# @LINE + 1 ]]:12: error: assigned value type doesn't match variable type
    x = foo();

    let y: number = 3.0;
    
    // CHECK: [[# @LINE + 1 ]]:5: error: immutable variables cannot be assigned
    y = 3.0;

    // CHECK: [[# @LINE + 1 ]]:5: error: expected to call function 'bar'
    bar = 3.0;

    // CHECK: [[# @LINE + 1 ]]:5: error: expected to call function 'foo'
    foo = 3.0;

    let z: number;
    z = 3.0;
}

fn assignParam(x: number): void {
    // CHECK: [[# @LINE + 1 ]]:5: error: parameters are immutable and cannot be assigned
    x = 1.0;
}
