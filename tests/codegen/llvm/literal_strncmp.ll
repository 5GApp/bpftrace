; ModuleID = 'bpftrace'
source_filename = "bpftrace"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf-pc-linux"

; Function Attrs: nounwind
declare i64 @llvm.bpf.pseudo(i64, i64) #0

define i64 @"kretprobe:vfs_read"(i8*) section "s_kretprobe:vfs_read_1" {
entry:
  %"@_val" = alloca i64
  %lookup_elem_val = alloca i64
  %comm3 = alloca [16 x i8]
  %strcmp.result = alloca i8
  %comm = alloca [16 x i8]
  %1 = bitcast [16 x i8]* %comm to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %1)
  %2 = bitcast [16 x i8]* %comm to i8*
  call void @llvm.memset.p0i8.i64(i8* align 1 %2, i8 0, i64 16, i1 false)
  %get_comm = call i64 inttoptr (i64 16 to i64 ([16 x i8]*, i64)*)([16 x i8]* %comm, i64 16)
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %strcmp.result)
  store i1 true, i8* %strcmp.result
  %3 = getelementptr [16 x i8], [16 x i8]* %comm, i32 0, i32 0
  %4 = load i8, i8* %3
  %strcmp.cmp = icmp ne i8 %4, 115
  br i1 %strcmp.cmp, label %strcmp.false, label %strcmp.loop

pred_false:                                       ; preds = %strcmp.false
  ret i64 0

pred_true:                                        ; preds = %strcmp.false
  %5 = bitcast [16 x i8]* %comm3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %5)
  %6 = bitcast [16 x i8]* %comm3 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 1 %6, i8 0, i64 16, i1 false)
  %get_comm4 = call i64 inttoptr (i64 16 to i64 ([16 x i8]*, i64)*)([16 x i8]* %comm3, i64 16)
  %pseudo = call i64 @llvm.bpf.pseudo(i64 1, i64 1)
  %lookup_elem = call i8* inttoptr (i64 1 to i8* (i64, [16 x i8]*)*)(i64 %pseudo, [16 x i8]* %comm3)
  %7 = bitcast i64* %lookup_elem_val to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %7)
  %map_lookup_cond = icmp ne i8* %lookup_elem, null
  br i1 %map_lookup_cond, label %lookup_success, label %lookup_failure

strcmp.false:                                     ; preds = %strcmp.loop1, %strcmp.loop, %entry
  %8 = load i8, i8* %strcmp.result
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %strcmp.result)
  %9 = zext i8 %8 to i64
  %10 = bitcast [16 x i8]* %comm to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %10)
  %predcond = icmp eq i64 %9, 0
  br i1 %predcond, label %pred_false, label %pred_true

strcmp.loop:                                      ; preds = %entry
  %11 = getelementptr [16 x i8], [16 x i8]* %comm, i32 0, i32 1
  %12 = load i8, i8* %11
  %strcmp.cmp2 = icmp ne i8 %12, 115
  br i1 %strcmp.cmp2, label %strcmp.false, label %strcmp.loop1

strcmp.loop1:                                     ; preds = %strcmp.loop
  store i1 false, i8* %strcmp.result
  br label %strcmp.false

lookup_success:                                   ; preds = %pred_true
  %cast = bitcast i8* %lookup_elem to i64*
  %13 = load i64, i64* %cast
  store i64 %13, i64* %lookup_elem_val
  br label %lookup_merge

lookup_failure:                                   ; preds = %pred_true
  store i64 0, i64* %lookup_elem_val
  br label %lookup_merge

lookup_merge:                                     ; preds = %lookup_failure, %lookup_success
  %14 = load i64, i64* %lookup_elem_val
  %15 = bitcast i64* %lookup_elem_val to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %15)
  %16 = bitcast i64* %"@_val" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %16)
  %17 = add i64 %14, 1
  store i64 %17, i64* %"@_val"
  %pseudo5 = call i64 @llvm.bpf.pseudo(i64 1, i64 1)
  %update_elem = call i64 inttoptr (i64 2 to i64 (i64, [16 x i8]*, i64*, i64)*)(i64 %pseudo5, [16 x i8]* %comm3, i64* %"@_val", i64 0)
  %18 = bitcast [16 x i8]* %comm3 to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %18)
  %19 = bitcast i64* %"@_val" to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %19)
  ret i64 0
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

attributes #0 = { nounwind }
attributes #1 = { argmemonly nounwind }
