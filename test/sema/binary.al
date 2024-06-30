// RUN: compiler %s -res-dump 2>&1 | filecheck %s
fn foo(): void {}

fn main(): void {
    // CHECK: [[# @LINE + 1 ]]:8: error: void expression cannot be used as LHS operand to binary operator
    foo() + 1.0;
    
    // CHECK: [[# @LINE + 1 ]]:14: error: void expression cannot be used as RHS operand to binary operator
    1.0 + foo();
    
    // CHECK: [[# @LINE + 1 ]]:8: error: void expression cannot be used as LHS operand to binary operator
    foo() + foo();

    1.0 + 3.0;
    2.0 + (10.0 * (3.0 > 2.0));

}
