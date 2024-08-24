; ModuleID = 'xdp_counter.c'
source_filename = "xdp_counter.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon.1 = type { ptr, ptr, ptr, ptr }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@packet_count = dso_local global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !61
@llvm.compiler.used = appending global [3 x ptr] [ptr @_license, ptr @packet_count, ptr @xdp_packet_counter], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local noundef i32 @xdp_packet_counter(ptr nocapture noundef readonly %0) #0 section "xdp" !dbg !106 {
  %2 = alloca i32, align 4, !DIAssignID !171
  call void @llvm.dbg.assign(metadata i1 undef, metadata !164, metadata !DIExpression(), metadata !171, metadata ptr %2, metadata !DIExpression()), !dbg !172
  %3 = alloca i64, align 8, !DIAssignID !173
  call void @llvm.dbg.assign(metadata i1 undef, metadata !168, metadata !DIExpression(), metadata !173, metadata ptr %3, metadata !DIExpression()), !dbg !174
  tail call void @llvm.dbg.value(metadata ptr %0, metadata !119, metadata !DIExpression()), !dbg !175
  %4 = getelementptr inbounds %struct.xdp_md, ptr %0, i64 0, i32 1, !dbg !176
  %5 = load i32, ptr %4, align 4, !dbg !176, !tbaa !177
  %6 = zext i32 %5 to i64, !dbg !182
  %7 = inttoptr i64 %6 to ptr, !dbg !183
  tail call void @llvm.dbg.value(metadata ptr %7, metadata !120, metadata !DIExpression()), !dbg !175
  %8 = load i32, ptr %0, align 4, !dbg !184, !tbaa !185
  %9 = zext i32 %8 to i64, !dbg !186
  %10 = inttoptr i64 %9 to ptr, !dbg !187
  tail call void @llvm.dbg.value(metadata ptr %10, metadata !121, metadata !DIExpression()), !dbg !175
  tail call void @llvm.dbg.value(metadata ptr %10, metadata !122, metadata !DIExpression()), !dbg !175
  %11 = getelementptr inbounds i8, ptr %10, i64 14, !dbg !188
  %12 = icmp ugt ptr %11, %7, !dbg !190
  br i1 %12, label %39, label %13, !dbg !191

13:                                               ; preds = %1
  %14 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 0, i32 2, !dbg !192
  %15 = load i16, ptr %14, align 1, !dbg !192, !tbaa !194
  %16 = icmp ne i16 %15, 8, !dbg !197
  tail call void @llvm.dbg.value(metadata ptr %11, metadata !134, metadata !DIExpression()), !dbg !175
  %17 = getelementptr inbounds i8, ptr %10, i64 34
  %18 = icmp ugt ptr %17, %7
  %19 = select i1 %16, i1 true, i1 %18, !dbg !198
  br i1 %19, label %39, label %20, !dbg !198

20:                                               ; preds = %13
  %21 = getelementptr inbounds i8, ptr %10, i64 23, !dbg !199
  %22 = load i8, ptr %21, align 1, !dbg !199, !tbaa !200
  switch i8 %22, label %39 [
    i8 6, label %23
    i8 17, label %23
    i8 1, label %23
  ], !dbg !202

23:                                               ; preds = %20, %20, %20
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #4, !dbg !203
  %24 = zext nneg i8 %22 to i32, !dbg !204
  store i32 %24, ptr %2, align 4, !dbg !205, !tbaa !206, !DIAssignID !207
  call void @llvm.dbg.assign(metadata i32 %24, metadata !164, metadata !DIExpression(), metadata !207, metadata ptr %2, metadata !DIExpression()), !dbg !172
  %25 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @packet_count, ptr noundef nonnull %2) #4, !dbg !208
  tail call void @llvm.dbg.value(metadata ptr %25, metadata !167, metadata !DIExpression()), !dbg !172
  %26 = icmp eq ptr %25, null, !dbg !209
  br i1 %26, label %35, label %27, !dbg !210

27:                                               ; preds = %23
  %28 = load i32, ptr %2, align 4, !dbg !211, !tbaa !206
  %29 = icmp eq i32 %28, 17, !dbg !214
  br i1 %29, label %30, label %33, !dbg !215

30:                                               ; preds = %27
  %31 = load i64, ptr %25, align 8, !dbg !216, !tbaa !217
  %32 = icmp ugt i64 %31, 999, !dbg !219
  br i1 %32, label %38, label %33, !dbg !220

33:                                               ; preds = %30, %27
  %34 = atomicrmw add ptr %25, i64 1 seq_cst, align 8, !dbg !221
  br label %37, !dbg !222

35:                                               ; preds = %23
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #4, !dbg !223
  store i64 1, ptr %3, align 8, !dbg !224, !tbaa !217, !DIAssignID !225
  call void @llvm.dbg.assign(metadata i64 1, metadata !168, metadata !DIExpression(), metadata !225, metadata ptr %3, metadata !DIExpression()), !dbg !174
  %36 = call i64 inttoptr (i64 2 to ptr)(ptr noundef nonnull @packet_count, ptr noundef nonnull %2, ptr noundef nonnull %3, i64 noundef 0) #4, !dbg !226
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #4, !dbg !227
  br label %37

37:                                               ; preds = %33, %35
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #4, !dbg !228
  br label %39

38:                                               ; preds = %30
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #4, !dbg !228
  br label %39

39:                                               ; preds = %38, %37, %20, %13, %1
  %40 = phi i32 [ 2, %1 ], [ 2, %13 ], [ 1, %38 ], [ 2, %37 ], [ 2, %20 ], !dbg !175
  ret i32 %40, !dbg !229
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.assign(metadata, metadata, metadata, metadata, metadata, metadata) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.value(metadata, metadata, metadata) #3

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!100, !101, !102, !103, !104}
!llvm.ident = !{!105}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "packet_count", scope: !2, file: !3, line: 14, type: !82, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !52, globals: !60, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_counter.c", directory: "/home/pedro/teste_final", checksumkind: CSK_MD5, checksum: "2cf75605ca69ac4a4267fa491adc9535")
!4 = !{!5, !14, !46}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 6320, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "8106ce79fb72e4cfc709095592a01f1d")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 29, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/linux/in.h", directory: "", checksumkind: CSK_MD5, checksum: "fcee415bb19db8acb968eeda6f02fa29")
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45}
!17 = !DIEnumerator(name: "IPPROTO_IP", value: 0)
!18 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1)
!19 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2)
!20 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4)
!21 = !DIEnumerator(name: "IPPROTO_TCP", value: 6)
!22 = !DIEnumerator(name: "IPPROTO_EGP", value: 8)
!23 = !DIEnumerator(name: "IPPROTO_PUP", value: 12)
!24 = !DIEnumerator(name: "IPPROTO_UDP", value: 17)
!25 = !DIEnumerator(name: "IPPROTO_IDP", value: 22)
!26 = !DIEnumerator(name: "IPPROTO_TP", value: 29)
!27 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33)
!28 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41)
!29 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46)
!30 = !DIEnumerator(name: "IPPROTO_GRE", value: 47)
!31 = !DIEnumerator(name: "IPPROTO_ESP", value: 50)
!32 = !DIEnumerator(name: "IPPROTO_AH", value: 51)
!33 = !DIEnumerator(name: "IPPROTO_MTP", value: 92)
!34 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94)
!35 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98)
!36 = !DIEnumerator(name: "IPPROTO_PIM", value: 103)
!37 = !DIEnumerator(name: "IPPROTO_COMP", value: 108)
!38 = !DIEnumerator(name: "IPPROTO_L2TP", value: 115)
!39 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132)
!40 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136)
!41 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137)
!42 = !DIEnumerator(name: "IPPROTO_ETHERNET", value: 143)
!43 = !DIEnumerator(name: "IPPROTO_RAW", value: 255)
!44 = !DIEnumerator(name: "IPPROTO_MPTCP", value: 262)
!45 = !DIEnumerator(name: "IPPROTO_MAX", value: 263)
!46 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 1282, baseType: !7, size: 32, elements: !47)
!47 = !{!48, !49, !50, !51}
!48 = !DIEnumerator(name: "BPF_ANY", value: 0)
!49 = !DIEnumerator(name: "BPF_NOEXIST", value: 1)
!50 = !DIEnumerator(name: "BPF_EXIST", value: 2)
!51 = !DIEnumerator(name: "BPF_F_LOCK", value: 4)
!52 = !{!53, !54, !55, !57}
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!54 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !56, line: 32, baseType: !57)
!56 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "bf9fbc0e8f60927fef9d8917535375a6")
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !58, line: 24, baseType: !59)
!58 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!59 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!60 = !{!61, !0, !67, !75}
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 66, type: !63, isLocal: false, isDefinition: true)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !64, size: 32, elements: !65)
!64 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!65 = !{!66}
!66 = !DISubrange(count: 4)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression(DW_OP_constu, 1, DW_OP_stack_value))
!68 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !69, line: 56, type: !70, isLocal: true, isDefinition: true)
!69 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "09cfcd7169c24bec448f30582e8c6db9")
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = !DISubroutineType(types: !72)
!72 = !{!53, !53, !73}
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!75 = !DIGlobalVariableExpression(var: !76, expr: !DIExpression(DW_OP_constu, 2, DW_OP_stack_value))
!76 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !69, line: 78, type: !77, isLocal: true, isDefinition: true)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!78 = !DISubroutineType(types: !79)
!79 = !{!54, !53, !73, !73, !80}
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !58, line: 31, baseType: !81)
!81 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!82 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 9, size: 256, elements: !83)
!83 = !{!84, !90, !95, !98}
!84 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !82, file: !3, line: 10, baseType: !85, size: 64)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = !DICompositeType(tag: DW_TAG_array_type, baseType: !87, size: 32, elements: !88)
!87 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!88 = !{!89}
!89 = !DISubrange(count: 1)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !82, file: !3, line: 11, baseType: !91, size: 64, offset: 64)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = !DICompositeType(tag: DW_TAG_array_type, baseType: !87, size: 8192, elements: !93)
!93 = !{!94}
!94 = !DISubrange(count: 256)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !82, file: !3, line: 12, baseType: !96, size: 64, offset: 128)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !58, line: 27, baseType: !7)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !82, file: !3, line: 13, baseType: !99, size: 64, offset: 192)
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!100 = !{i32 7, !"Dwarf Version", i32 5}
!101 = !{i32 2, !"Debug Info Version", i32 3}
!102 = !{i32 1, !"wchar_size", i32 4}
!103 = !{i32 7, !"frame-pointer", i32 2}
!104 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!105 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!106 = distinct !DISubprogram(name: "xdp_packet_counter", scope: !3, file: !3, line: 19, type: !107, scopeLine: 19, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !118)
!107 = !DISubroutineType(types: !108)
!108 = !{!87, !109}
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !110, size: 64)
!110 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 6331, size: 192, elements: !111)
!111 = !{!112, !113, !114, !115, !116, !117}
!112 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !110, file: !6, line: 6332, baseType: !97, size: 32)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !110, file: !6, line: 6333, baseType: !97, size: 32, offset: 32)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !110, file: !6, line: 6334, baseType: !97, size: 32, offset: 64)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !110, file: !6, line: 6336, baseType: !97, size: 32, offset: 96)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !110, file: !6, line: 6337, baseType: !97, size: 32, offset: 128)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !110, file: !6, line: 6339, baseType: !97, size: 32, offset: 160)
!118 = !{!119, !120, !121, !122, !134, !164, !167, !168}
!119 = !DILocalVariable(name: "ctx", arg: 1, scope: !106, file: !3, line: 19, type: !109)
!120 = !DILocalVariable(name: "data_end", scope: !106, file: !3, line: 21, type: !53)
!121 = !DILocalVariable(name: "data", scope: !106, file: !3, line: 22, type: !53)
!122 = !DILocalVariable(name: "eth", scope: !106, file: !3, line: 25, type: !123)
!123 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !124, size: 64)
!124 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !125, line: 173, size: 112, elements: !126)
!125 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!126 = !{!127, !132, !133}
!127 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !124, file: !125, line: 174, baseType: !128, size: 48)
!128 = !DICompositeType(tag: DW_TAG_array_type, baseType: !129, size: 48, elements: !130)
!129 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!130 = !{!131}
!131 = !DISubrange(count: 6)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !124, file: !125, line: 175, baseType: !128, size: 48, offset: 48)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !124, file: !125, line: 176, baseType: !55, size: 16, offset: 96)
!134 = !DILocalVariable(name: "ip", scope: !106, file: !3, line: 37, type: !135)
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !136, size: 64)
!136 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !137, line: 87, size: 160, elements: !138)
!137 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "149778ace30a1ff208adc8783fd04b29")
!138 = !{!139, !141, !142, !143, !144, !145, !146, !147, !148, !150}
!139 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !136, file: !137, line: 89, baseType: !140, size: 4, flags: DIFlagBitField, extraData: i64 0)
!140 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !58, line: 21, baseType: !129)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !136, file: !137, line: 90, baseType: !140, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !136, file: !137, line: 97, baseType: !140, size: 8, offset: 8)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !136, file: !137, line: 98, baseType: !55, size: 16, offset: 16)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !136, file: !137, line: 99, baseType: !55, size: 16, offset: 32)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !136, file: !137, line: 100, baseType: !55, size: 16, offset: 48)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !136, file: !137, line: 101, baseType: !140, size: 8, offset: 64)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !136, file: !137, line: 102, baseType: !140, size: 8, offset: 72)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !136, file: !137, line: 103, baseType: !149, size: 16, offset: 80)
!149 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !56, line: 38, baseType: !57)
!150 = !DIDerivedType(tag: DW_TAG_member, scope: !136, file: !137, line: 104, baseType: !151, size: 64, offset: 96)
!151 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !136, file: !137, line: 104, size: 64, elements: !152)
!152 = !{!153, !159}
!153 = !DIDerivedType(tag: DW_TAG_member, scope: !151, file: !137, line: 104, baseType: !154, size: 64)
!154 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !151, file: !137, line: 104, size: 64, elements: !155)
!155 = !{!156, !158}
!156 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !154, file: !137, line: 104, baseType: !157, size: 32)
!157 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !56, line: 34, baseType: !97)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !154, file: !137, line: 104, baseType: !157, size: 32, offset: 32)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !151, file: !137, line: 104, baseType: !160, size: 64)
!160 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !151, file: !137, line: 104, size: 64, elements: !161)
!161 = !{!162, !163}
!162 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !160, file: !137, line: 104, baseType: !157, size: 32)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !160, file: !137, line: 104, baseType: !157, size: 32, offset: 32)
!164 = !DILocalVariable(name: "protocol", scope: !165, file: !3, line: 45, type: !97)
!165 = distinct !DILexicalBlock(scope: !166, file: !3, line: 44, column: 99)
!166 = distinct !DILexicalBlock(scope: !106, file: !3, line: 44, column: 8)
!167 = !DILocalVariable(name: "count", scope: !165, file: !3, line: 48, type: !99)
!168 = !DILocalVariable(name: "initial_count", scope: !169, file: !3, line: 58, type: !80)
!169 = distinct !DILexicalBlock(scope: !170, file: !3, line: 56, column: 12)
!170 = distinct !DILexicalBlock(scope: !165, file: !3, line: 49, column: 9)
!171 = distinct !DIAssignID()
!172 = !DILocation(line: 0, scope: !165)
!173 = distinct !DIAssignID()
!174 = !DILocation(line: 0, scope: !169)
!175 = !DILocation(line: 0, scope: !106)
!176 = !DILocation(line: 21, column: 41, scope: !106)
!177 = !{!178, !179, i64 4}
!178 = !{!"xdp_md", !179, i64 0, !179, i64 4, !179, i64 8, !179, i64 12, !179, i64 16, !179, i64 20}
!179 = !{!"int", !180, i64 0}
!180 = !{!"omnipotent char", !181, i64 0}
!181 = !{!"Simple C/C++ TBAA"}
!182 = !DILocation(line: 21, column: 30, scope: !106)
!183 = !DILocation(line: 21, column: 22, scope: !106)
!184 = !DILocation(line: 22, column: 37, scope: !106)
!185 = !{!178, !179, i64 0}
!186 = !DILocation(line: 22, column: 26, scope: !106)
!187 = !DILocation(line: 22, column: 18, scope: !106)
!188 = !DILocation(line: 29, column: 14, scope: !189)
!189 = distinct !DILexicalBlock(scope: !106, file: !3, line: 29, column: 9)
!190 = !DILocation(line: 29, column: 38, scope: !189)
!191 = !DILocation(line: 29, column: 9, scope: !106)
!192 = !DILocation(line: 33, column: 14, scope: !193)
!193 = distinct !DILexicalBlock(scope: !106, file: !3, line: 33, column: 9)
!194 = !{!195, !196, i64 12}
!195 = !{!"ethhdr", !180, i64 0, !180, i64 6, !196, i64 12}
!196 = !{!"short", !180, i64 0}
!197 = !DILocation(line: 33, column: 22, scope: !193)
!198 = !DILocation(line: 33, column: 9, scope: !106)
!199 = !DILocation(line: 44, column: 12, scope: !166)
!200 = !{!201, !180, i64 9}
!201 = !{!"iphdr", !180, i64 0, !180, i64 0, !180, i64 1, !196, i64 2, !196, i64 4, !196, i64 6, !180, i64 8, !180, i64 9, !196, i64 10, !180, i64 12}
!202 = !DILocation(line: 44, column: 36, scope: !166)
!203 = !DILocation(line: 45, column: 5, scope: !165)
!204 = !DILocation(line: 45, column: 22, scope: !165)
!205 = !DILocation(line: 45, column: 11, scope: !165)
!206 = !{!179, !179, i64 0}
!207 = distinct !DIAssignID()
!208 = !DILocation(line: 48, column: 20, scope: !165)
!209 = !DILocation(line: 49, column: 9, scope: !170)
!210 = !DILocation(line: 49, column: 9, scope: !165)
!211 = !DILocation(line: 51, column: 6, scope: !212)
!212 = distinct !DILexicalBlock(scope: !213, file: !3, line: 51, column: 6)
!213 = distinct !DILexicalBlock(scope: !170, file: !3, line: 49, column: 16)
!214 = !DILocation(line: 51, column: 15, scope: !212)
!215 = !DILocation(line: 51, column: 30, scope: !212)
!216 = !DILocation(line: 51, column: 33, scope: !212)
!217 = !{!218, !218, i64 0}
!218 = !{!"long long", !180, i64 0}
!219 = !DILocation(line: 51, column: 40, scope: !212)
!220 = !DILocation(line: 51, column: 6, scope: !213)
!221 = !DILocation(line: 55, column: 9, scope: !213)
!222 = !DILocation(line: 56, column: 5, scope: !213)
!223 = !DILocation(line: 58, column: 9, scope: !169)
!224 = !DILocation(line: 58, column: 15, scope: !169)
!225 = distinct !DIAssignID()
!226 = !DILocation(line: 59, column: 9, scope: !169)
!227 = !DILocation(line: 60, column: 5, scope: !170)
!228 = !DILocation(line: 61, column: 1, scope: !166)
!229 = !DILocation(line: 64, column: 1, scope: !106)
