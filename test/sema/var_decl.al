// RUN: compiler %s -res-dump 2>&1 | filecheck %s
fn foo(): void {}
fn bar(): number { return 1.0; }

fn main(): void {
    // CHECK: [[# @LINE + 1 ]]:9: error: variable 'x' has invalid 'void' type
    var x: void;

    // CHECK: [[# @LINE + 1 ]]:9: error: variable 'x2' has invalid 'customType' type
    var x2: customType;
    
    // CHECK: [[# @LINE + 1 ]]:25: error: initializer type mismatch
    let x3: number = foo();

    let x4: number;
    
    let x5: number = bar();
}
