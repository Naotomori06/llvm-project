// Test FIR to LLVM IR conversion invalid cases and diagnostics.

// RUN: fir-opt --split-input-file --fir-to-llvm-ir="target=x86_64-unknown-linux-gnu" --verify-diagnostics %s


// Test `fir.shape` conversion failure because the op has uses.

func.func @shape_not_dead(%arg0: !fir.ref<!fir.array<?x?xf32>>, %i: index, %j: index) {
  %c0 = arith.constant 1 : index
  // expected-error@+1{{failed to legalize operation 'fir.shape'}}
  %0 = fir.shape %c0, %c0 : (index, index) -> !fir.shape<2>
  %1 = fir.array_coor %arg0(%0) %i, %j : (!fir.ref<!fir.array<?x?xf32>>, !fir.shape<2>, index, index) -> !fir.ref<f32>
  return
}

// -----

// Test `fir.slice` conversion failure because the op has uses.

func.func @slice_not_dead(%arg0: !fir.ref<!fir.array<?x?xf32>>, %i: index, %j: index) {
  %c0 = arith.constant 1 : index
  // expected-error@+1{{failed to legalize operation 'fir.slice'}}
  %0 = fir.slice %c0, %c0, %c0, %c0, %c0, %c0 : (index, index, index, index, index, index) -> !fir.slice<2>
  %1 = fir.array_coor %arg0[%0] %i, %j : (!fir.ref<!fir.array<?x?xf32>>, !fir.slice<2>, index, index) -> !fir.ref<f32>
  return
}

// -----

// Test `fir.shift` conversion failure because the op has uses.

func.func @shift_not_dead(%arg0: !fir.box<!fir.array<?xf32>>, %i: index) {
  %c0 = arith.constant 1 : index
  // expected-error@+1{{failed to legalize operation 'fir.shift'}}
  %0 = fir.shift %c0 : (index) -> !fir.shift<1>
  %1 = fir.array_coor %arg0(%0) %i : (!fir.box<!fir.array<?xf32>>, !fir.shift<1>, index) -> !fir.ref<f32>
  return
}

// -----

// Test `fir.shape_shift` conversion failure because the op has uses.

func.func @shape_shift_not_dead(%arg0: !fir.ref<!fir.array<?x?xf32>>, %i: index, %j: index) {
  %c0 = arith.constant 1 : index
  // expected-error@+1{{failed to legalize operation 'fir.shape_shift'}}
  %0 = fir.shape_shift %c0, %c0, %c0, %c0 : (index, index, index, index) -> !fir.shapeshift<2>
  %1 = fir.array_coor %arg0(%0) %i, %j : (!fir.ref<!fir.array<?x?xf32>>, !fir.shapeshift<2>, index, index) -> !fir.ref<f32>
  return
}

// -----

// Test `fir.select_type` conversion to llvm.
// Should have been converted.

func.func @bar_select_type(%arg : !fir.class<!fir.type<derivedst{a:f32}>>) -> i32 {
  %0 = arith.constant 1 : i32
  %2 = arith.constant 3 : i32
  // expected-error@+2{{fir.select_type should have already been converted}}
  // expected-error@+1{{failed to legalize operation 'fir.select_type'}}
  fir.select_type %arg : !fir.class<!fir.type<derivedst{a:f32}>> [
    #fir.type_is<!fir.int<4>>,^bb1(%0:i32),
    #fir.type_is<!fir.int<8>>,^bb2(%2:i32),
    unit,^bb5 ]
^bb1(%a : i32) :
  return %a : i32
^bb2(%b : i32) :
  return %b : i32
^bb5 :
  %zero = arith.constant 0 : i32
  return %zero : i32
}

// -----

// Verify that `fir.dt_entry` requires a parent op

// expected-error@+1{{'fir.dt_entry' op expects parent op 'fir.type_info'}}
fir.dt_entry "method", @method_impl

// -----

// expected-error@+1{{'fir.type_info' op type must be a fir.type}}
fir.type_info @bad : i32

// -----

// expected-error@+1{{'fir.type_info' op parent_type must be a fir.type}}
fir.type_info @bad extends f32 : !fir.type<t1{i:i32}>

// -----

fir.type_info @bad : !fir.type<bad{i:i32}> dispatch_table {
  // expected-error@+1{{dispatch table must contain dt_entry}}
  %zero = arith.constant 0 : i32
}

// -----

// `fir.coordinate_of` - dynamically sized arrays are not supported
func.func @coordinate_of_dynamic_array(%arg0: !fir.ref<!fir.array<1x!fir.char<4,?>>>, %arg1: index) {
  // expected-error@+2{{fir.coordinate_of with a dynamic element size is unsupported}}
  // expected-error@+1{{failed to legalize operation 'fir.coordinate_of'}}
  %p = fir.coordinate_of %arg0, %arg1 : (!fir.ref<!fir.array<1x!fir.char<4,?>>>, index) -> !fir.ref<f32>
  return
}
