// RUN: compiler %s -res-dump 2>&1 | filecheck %s
fn foo(): void {}

fn main(): void {
    var x: number = 1.0;

    // CHECK: [[# @LINE + 1 ]]:5: error: expected to call function 'foo'
    foo;
    
    x;
    
    // CHECK: [[# @LINE + 1 ]]:5: error: symbol 'y' not found
    y;

    let foo: number = 2.0;

    // CHECK: [[# @LINE + 1 ]]:8: error: calling non-function symbol
    foo();
}

fn bar(x: number): void {
    x;

    // CHECK: [[# @LINE + 1 ]]:6: error: calling non-function symbol
    x();
}
