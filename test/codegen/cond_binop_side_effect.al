// RUN: compiler %s -llvm-dump 2>&1 | filecheck %s
// RUN: compiler %s -o cond_binop_side_effect && ./cond_binop_side_effect | grep -Plzx '1.000000\n2.000000\n3.000000\n4.000000\n5.000000\n7.000000\n10.000000\n13.000000\n14.000000\n15.000000\n16.000000\n'
fn true(x: number): number {
    print(x);
    return 1.0;
}

fn false(x: number): number {
    print(x);
    return 0.0;
}

fn test1(): void {
    false(1.0) || true(2.0) && false(3.0);
}
// CHECK: define void @test1() {
// CHECK-NEXT:   %1 = call double @false(double 1.000000e+00)
// CHECK-NEXT:   %toBool = fcmp one double %1, 0.000000e+00
// CHECK-NEXT:   br i1 %toBool, label %or.merge, label %or.rhs
// CHECK-NEXT: 
// CHECK-NEXT: or.rhs:                                           ; preds = %0
// CHECK-NEXT:   %2 = call double @true(double 2.000000e+00)
// CHECK-NEXT:   %toBool1 = fcmp one double %2, 0.000000e+00
// CHECK-NEXT:   br i1 %toBool1, label %and.rhs, label %and.merge
// CHECK-NEXT: 
// CHECK-NEXT: or.merge:                                         ; preds = %and.merge, %0
// CHECK-NEXT:   %3 = phi i1 [ %toBool3, %and.merge ], [ true, %0 ]
// CHECK-NEXT:   %toDouble4 = uitofp i1 %3 to double
// CHECK-NEXT:   ret void
// CHECK-NEXT: 
// CHECK-NEXT: and.rhs:                                          ; preds = %or.rhs
// CHECK-NEXT:   %4 = call double @false(double 3.000000e+00)
// CHECK-NEXT:   %toBool2 = fcmp one double %4, 0.000000e+00
// CHECK-NEXT:   br label %and.merge
// CHECK-NEXT: 
// CHECK-NEXT: and.merge:                                        ; preds = %and.rhs, %or.rhs
// CHECK-NEXT:   %5 = phi i1 [ %toBool2, %and.rhs ], [ false, %or.rhs ]
// CHECK-NEXT:   %toDouble = uitofp i1 %5 to double
// CHECK-NEXT:   %toBool3 = fcmp one double %toDouble, 0.000000e+00
// CHECK-NEXT:   br label %or.merge
// CHECK-NEXT: }

fn test2(): void {
    false(4.0) || true(5.0) || true(6.0);
}
// CHECK: define void @test2() {
// CHECK-NEXT:   %1 = call double @false(double 4.000000e+00)
// CHECK-NEXT:   %toBool = fcmp one double %1, 0.000000e+00
// CHECK-NEXT:   br i1 %toBool, label %or.merge, label %or.lhs.false
// CHECK-NEXT: 
// CHECK-NEXT: or.rhs:                                           ; preds = %or.lhs.false
// CHECK-NEXT:   %2 = call double @true(double 6.000000e+00)
// CHECK-NEXT:   %toBool2 = fcmp one double %2, 0.000000e+00
// CHECK-NEXT:   br label %or.merge
// CHECK-NEXT: 
// CHECK-NEXT: or.merge:                                         ; preds = %or.rhs, %or.lhs.false, %0
// CHECK-NEXT:   %3 = phi i1 [ %toBool2, %or.rhs ], [ true, %or.lhs.false ], [ true, %0 ]
// CHECK-NEXT:   %toDouble = uitofp i1 %3 to double
// CHECK-NEXT:   ret void
// CHECK-NEXT: 
// CHECK-NEXT: or.lhs.false:                                     ; preds = %0
// CHECK-NEXT:   %4 = call double @true(double 5.000000e+00)
// CHECK-NEXT:   %toBool1 = fcmp one double %4, 0.000000e+00
// CHECK-NEXT:   br i1 %toBool1, label %or.merge, label %or.rhs
// CHECK-NEXT: }

fn test3(): void {
    false(7.0) && false(8.0) && true(9.0);
}
// CHECK: define void @test3() {
// CHECK-NEXT:   %1 = call double @false(double 7.000000e+00)
// CHECK-NEXT:   %toBool = fcmp one double %1, 0.000000e+00
// CHECK-NEXT:   br i1 %toBool, label %and.lhs.true, label %and.merge
// CHECK-NEXT: 
// CHECK-NEXT: and.rhs:                                          ; preds = %and.lhs.true
// CHECK-NEXT:   %2 = call double @true(double 9.000000e+00)
// CHECK-NEXT:   %toBool2 = fcmp one double %2, 0.000000e+00
// CHECK-NEXT:   br label %and.merge
// CHECK-NEXT: 
// CHECK-NEXT: and.merge:                                        ; preds = %and.rhs, %and.lhs.true, %0
// CHECK-NEXT:   %3 = phi i1 [ %toBool2, %and.rhs ], [ false, %and.lhs.true ], [ false, %0 ]
// CHECK-NEXT:   %toDouble = uitofp i1 %3 to double
// CHECK-NEXT:   ret void
// CHECK-NEXT: 
// CHECK-NEXT: and.lhs.true:                                     ; preds = %0
// CHECK-NEXT:   %4 = call double @false(double 8.000000e+00)
// CHECK-NEXT:   %toBool1 = fcmp one double %4, 0.000000e+00
// CHECK-NEXT:   br i1 %toBool1, label %and.rhs, label %and.merge
// CHECK-NEXT: }

fn test4(): void {
    true(10.0) || true(11.0) || true(12.0);
}
// CHECK: define void @test4() {
// CHECK-NEXT:   %1 = call double @true(double 1.000000e+01)
// CHECK-NEXT:   %toBool = fcmp one double %1, 0.000000e+00
// CHECK-NEXT:   br i1 %toBool, label %or.merge, label %or.lhs.false
// CHECK-NEXT: 
// CHECK-NEXT: or.rhs:                                           ; preds = %or.lhs.false
// CHECK-NEXT:   %2 = call double @true(double 1.200000e+01)
// CHECK-NEXT:   %toBool2 = fcmp one double %2, 0.000000e+00
// CHECK-NEXT:   br label %or.merge
// CHECK-NEXT: 
// CHECK-NEXT: or.merge:                                         ; preds = %or.rhs, %or.lhs.false, %0
// CHECK-NEXT:   %3 = phi i1 [ %toBool2, %or.rhs ], [ true, %or.lhs.false ], [ true, %0 ]
// CHECK-NEXT:   %toDouble = uitofp i1 %3 to double
// CHECK-NEXT:   ret void
// CHECK-NEXT: 
// CHECK-NEXT: or.lhs.false:                                     ; preds = %0
// CHECK-NEXT:   %4 = call double @true(double 1.100000e+01)
// CHECK-NEXT:   %toBool1 = fcmp one double %4, 0.000000e+00
// CHECK-NEXT:   br i1 %toBool1, label %or.merge, label %or.rhs
// CHECK-NEXT: }

fn test5(): void {
    false(13.0) || true(14.0) && false(15.0) || true(16.0);
}
// CHECK: define void @test5() {
// CHECK-NEXT:   %1 = call double @false(double 1.300000e+01)
// CHECK-NEXT:   %toBool = fcmp one double %1, 0.000000e+00
// CHECK-NEXT:   br i1 %toBool, label %or.merge, label %or.lhs.false
// CHECK-NEXT: 
// CHECK-NEXT: or.rhs:                                           ; preds = %and.lhs.true, %or.lhs.false
// CHECK-NEXT:   %2 = call double @true(double 1.600000e+01)
// CHECK-NEXT:   %toBool3 = fcmp one double %2, 0.000000e+00
// CHECK-NEXT:   br label %or.merge
// CHECK-NEXT: 
// CHECK-NEXT: or.merge:                                         ; preds = %or.rhs, %and.lhs.true, %0
// CHECK-NEXT:   %3 = phi i1 [ %toBool3, %or.rhs ], [ true, %and.lhs.true ], [ true, %0 ]
// CHECK-NEXT:   %toDouble = uitofp i1 %3 to double
// CHECK-NEXT:   ret void
// CHECK-NEXT: 
// CHECK-NEXT: or.lhs.false:                                     ; preds = %0
// CHECK-NEXT:   %4 = call double @true(double 1.400000e+01)
// CHECK-NEXT:   %toBool1 = fcmp one double %4, 0.000000e+00
// CHECK-NEXT:   br i1 %toBool1, label %and.lhs.true, label %or.rhs
// CHECK-NEXT: 
// CHECK-NEXT: and.lhs.true:                                     ; preds = %or.lhs.false
// CHECK-NEXT:   %5 = call double @false(double 1.500000e+01)
// CHECK-NEXT:   %toBool2 = fcmp one double %5, 0.000000e+00
// CHECK-NEXT:   br i1 %toBool2, label %or.merge, label %or.rhs
// CHECK-NEXT: }

fn main(): void {
    test1();
    test2();
    test3();
    test4();
    test5();
}
