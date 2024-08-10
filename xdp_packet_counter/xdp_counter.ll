; ModuleID = 'xdp_counter.c'
source_filename = "xdp_counter.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon.1 = type { ptr, ptr, ptr, ptr }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@packet_count = dso_local global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !78
@llvm.compiler.used = appending global [3 x ptr] [ptr @_license, ptr @packet_count, ptr @xdp_packet_counter], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local noundef i32 @xdp_packet_counter(ptr nocapture noundef readonly %0) #0 section "xdp" !dbg !108 {
  %2 = alloca i32, align 4, !DIAssignID !173
  call void @llvm.dbg.assign(metadata i1 undef, metadata !166, metadata !DIExpression(), metadata !173, metadata ptr %2, metadata !DIExpression()), !dbg !174
  %3 = alloca i64, align 8, !DIAssignID !175
  call void @llvm.dbg.assign(metadata i1 undef, metadata !170, metadata !DIExpression(), metadata !175, metadata ptr %3, metadata !DIExpression()), !dbg !176
  tail call void @llvm.dbg.value(metadata ptr %0, metadata !121, metadata !DIExpression()), !dbg !177
  %4 = getelementptr inbounds %struct.xdp_md, ptr %0, i64 0, i32 1, !dbg !178
  %5 = load i32, ptr %4, align 4, !dbg !178, !tbaa !179
  %6 = zext i32 %5 to i64, !dbg !184
  %7 = inttoptr i64 %6 to ptr, !dbg !185
  tail call void @llvm.dbg.value(metadata ptr %7, metadata !122, metadata !DIExpression()), !dbg !177
  %8 = load i32, ptr %0, align 4, !dbg !186, !tbaa !187
  %9 = zext i32 %8 to i64, !dbg !188
  %10 = inttoptr i64 %9 to ptr, !dbg !189
  tail call void @llvm.dbg.value(metadata ptr %10, metadata !123, metadata !DIExpression()), !dbg !177
  tail call void @llvm.dbg.value(metadata ptr %10, metadata !124, metadata !DIExpression()), !dbg !177
  %11 = getelementptr inbounds i8, ptr %10, i64 14, !dbg !190
  %12 = icmp ugt ptr %11, %7, !dbg !192
  br i1 %12, label %39, label %13, !dbg !193

13:                                               ; preds = %1
  %14 = getelementptr inbounds %struct.ethhdr, ptr %10, i64 0, i32 2, !dbg !194
  %15 = load i16, ptr %14, align 1, !dbg !194, !tbaa !196
  %16 = icmp ne i16 %15, 8, !dbg !199
  tail call void @llvm.dbg.value(metadata ptr %11, metadata !136, metadata !DIExpression()), !dbg !177
  %17 = getelementptr inbounds i8, ptr %10, i64 34
  %18 = icmp ugt ptr %17, %7
  %19 = select i1 %16, i1 true, i1 %18, !dbg !200
  br i1 %19, label %39, label %20, !dbg !200

20:                                               ; preds = %13
  %21 = getelementptr inbounds i8, ptr %10, i64 23, !dbg !201
  %22 = load i8, ptr %21, align 1, !dbg !201, !tbaa !202
  switch i8 %22, label %39 [
    i8 6, label %23
    i8 17, label %23
    i8 1, label %23
  ], !dbg !204

23:                                               ; preds = %20, %20, %20
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #4, !dbg !205
  %24 = zext nneg i8 %22 to i32, !dbg !206
  store i32 %24, ptr %2, align 4, !dbg !207, !tbaa !208, !DIAssignID !209
  call void @llvm.dbg.assign(metadata i32 %24, metadata !166, metadata !DIExpression(), metadata !209, metadata ptr %2, metadata !DIExpression()), !dbg !174
  %25 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @packet_count, ptr noundef nonnull %2) #4, !dbg !210
  tail call void @llvm.dbg.value(metadata ptr %25, metadata !169, metadata !DIExpression()), !dbg !174
  %26 = icmp eq ptr %25, null, !dbg !211
  br i1 %26, label %35, label %27, !dbg !212

27:                                               ; preds = %23
  %28 = load i32, ptr %2, align 4, !dbg !213, !tbaa !208
  %29 = icmp eq i32 %28, 1, !dbg !216
  br i1 %29, label %30, label %33, !dbg !217

30:                                               ; preds = %27
  %31 = load i64, ptr %25, align 8, !dbg !218, !tbaa !219
  %32 = icmp ugt i64 %31, 10, !dbg !221
  br i1 %32, label %38, label %33, !dbg !222

33:                                               ; preds = %30, %27
  %34 = atomicrmw add ptr %25, i64 1 seq_cst, align 8, !dbg !223
  br label %37, !dbg !224

35:                                               ; preds = %23
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #4, !dbg !225
  store i64 1, ptr %3, align 8, !dbg !226, !tbaa !219, !DIAssignID !227
  call void @llvm.dbg.assign(metadata i64 1, metadata !170, metadata !DIExpression(), metadata !227, metadata ptr %3, metadata !DIExpression()), !dbg !176
  %36 = call i64 inttoptr (i64 2 to ptr)(ptr noundef nonnull @packet_count, ptr noundef nonnull %2, ptr noundef nonnull %3, i64 noundef 0) #4, !dbg !228
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #4, !dbg !229
  br label %37

37:                                               ; preds = %33, %35
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #4, !dbg !230
  br label %39

38:                                               ; preds = %30
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #4, !dbg !230
  br label %39

39:                                               ; preds = %38, %37, %20, %13, %1
  %40 = phi i32 [ 2, %1 ], [ 2, %13 ], [ 1, %38 ], [ 2, %37 ], [ 2, %20 ], !dbg !177
  ret i32 %40, !dbg !231
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
!llvm.module.flags = !{!102, !103, !104, !105, !106}
!llvm.ident = !{!107}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "packet_count", scope: !2, file: !3, line: 12, type: !84, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !52, globals: !60, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_counter.c", directory: "/home/pedro/xdp_packet_counter", checksumkind: CSK_MD5, checksum: "5cab69a8e8850f4ac88b1e5e28061825")
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
!60 = !{!61, !70, !78, !0}
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !63, line: 56, type: !64, isLocal: true, isDefinition: true)
!63 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "c4541ac9eb5775ba778051c940b03a18")
!64 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !65)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DISubroutineType(types: !67)
!67 = !{!53, !53, !68}
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !63, line: 78, type: !72, isLocal: true, isDefinition: true)
!72 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !73)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = !DISubroutineType(types: !75)
!75 = !{!54, !53, !68, !68, !76}
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !58, line: 31, baseType: !77)
!77 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 48, type: !80, isLocal: false, isDefinition: true)
!80 = !DICompositeType(tag: DW_TAG_array_type, baseType: !81, size: 32, elements: !82)
!81 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!82 = !{!83}
!83 = !DISubrange(count: 4)
!84 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 7, size: 256, elements: !85)
!85 = !{!86, !92, !97, !100}
!86 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !84, file: !3, line: 8, baseType: !87, size: 64)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DICompositeType(tag: DW_TAG_array_type, baseType: !89, size: 32, elements: !90)
!89 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!90 = !{!91}
!91 = !DISubrange(count: 1)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !84, file: !3, line: 9, baseType: !93, size: 64, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = !DICompositeType(tag: DW_TAG_array_type, baseType: !89, size: 8192, elements: !95)
!95 = !{!96}
!96 = !DISubrange(count: 256)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !84, file: !3, line: 10, baseType: !98, size: 64, offset: 128)
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !58, line: 27, baseType: !7)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !84, file: !3, line: 11, baseType: !101, size: 64, offset: 192)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!102 = !{i32 7, !"Dwarf Version", i32 5}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !{i32 1, !"wchar_size", i32 4}
!105 = !{i32 7, !"frame-pointer", i32 2}
!106 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!107 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!108 = distinct !DISubprogram(name: "xdp_packet_counter", scope: !3, file: !3, line: 15, type: !109, scopeLine: 15, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !120)
!109 = !DISubroutineType(types: !110)
!110 = !{!89, !111}
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!112 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 6331, size: 192, elements: !113)
!113 = !{!114, !115, !116, !117, !118, !119}
!114 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !112, file: !6, line: 6332, baseType: !99, size: 32)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !112, file: !6, line: 6333, baseType: !99, size: 32, offset: 32)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !112, file: !6, line: 6334, baseType: !99, size: 32, offset: 64)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !112, file: !6, line: 6336, baseType: !99, size: 32, offset: 96)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !112, file: !6, line: 6337, baseType: !99, size: 32, offset: 128)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !112, file: !6, line: 6339, baseType: !99, size: 32, offset: 160)
!120 = !{!121, !122, !123, !124, !136, !166, !169, !170}
!121 = !DILocalVariable(name: "ctx", arg: 1, scope: !108, file: !3, line: 15, type: !111)
!122 = !DILocalVariable(name: "data_end", scope: !108, file: !3, line: 16, type: !53)
!123 = !DILocalVariable(name: "data", scope: !108, file: !3, line: 17, type: !53)
!124 = !DILocalVariable(name: "eth", scope: !108, file: !3, line: 18, type: !125)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !126, size: 64)
!126 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !127, line: 173, size: 112, elements: !128)
!127 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!128 = !{!129, !134, !135}
!129 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !126, file: !127, line: 174, baseType: !130, size: 48)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !131, size: 48, elements: !132)
!131 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!132 = !{!133}
!133 = !DISubrange(count: 6)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !126, file: !127, line: 175, baseType: !130, size: 48, offset: 48)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !126, file: !127, line: 176, baseType: !55, size: 16, offset: 96)
!136 = !DILocalVariable(name: "ip", scope: !108, file: !3, line: 26, type: !137)
!137 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !138, size: 64)
!138 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !139, line: 87, size: 160, elements: !140)
!139 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "149778ace30a1ff208adc8783fd04b29")
!140 = !{!141, !143, !144, !145, !146, !147, !148, !149, !150, !152}
!141 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !138, file: !139, line: 89, baseType: !142, size: 4, flags: DIFlagBitField, extraData: i64 0)
!142 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !58, line: 21, baseType: !131)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !138, file: !139, line: 90, baseType: !142, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !138, file: !139, line: 97, baseType: !142, size: 8, offset: 8)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !138, file: !139, line: 98, baseType: !55, size: 16, offset: 16)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !138, file: !139, line: 99, baseType: !55, size: 16, offset: 32)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !138, file: !139, line: 100, baseType: !55, size: 16, offset: 48)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !138, file: !139, line: 101, baseType: !142, size: 8, offset: 64)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !138, file: !139, line: 102, baseType: !142, size: 8, offset: 72)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !138, file: !139, line: 103, baseType: !151, size: 16, offset: 80)
!151 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !56, line: 38, baseType: !57)
!152 = !DIDerivedType(tag: DW_TAG_member, scope: !138, file: !139, line: 104, baseType: !153, size: 64, offset: 96)
!153 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !138, file: !139, line: 104, size: 64, elements: !154)
!154 = !{!155, !161}
!155 = !DIDerivedType(tag: DW_TAG_member, scope: !153, file: !139, line: 104, baseType: !156, size: 64)
!156 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !153, file: !139, line: 104, size: 64, elements: !157)
!157 = !{!158, !160}
!158 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !156, file: !139, line: 104, baseType: !159, size: 32)
!159 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !56, line: 34, baseType: !99)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !156, file: !139, line: 104, baseType: !159, size: 32, offset: 32)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !153, file: !139, line: 104, baseType: !162, size: 64)
!162 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !153, file: !139, line: 104, size: 64, elements: !163)
!163 = !{!164, !165}
!164 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !162, file: !139, line: 104, baseType: !159, size: 32)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !162, file: !139, line: 104, baseType: !159, size: 32, offset: 32)
!166 = !DILocalVariable(name: "protocol", scope: !167, file: !3, line: 32, type: !99)
!167 = distinct !DILexicalBlock(scope: !168, file: !3, line: 31, column: 99)
!168 = distinct !DILexicalBlock(scope: !108, file: !3, line: 31, column: 8)
!169 = !DILocalVariable(name: "count", scope: !167, file: !3, line: 33, type: !101)
!170 = !DILocalVariable(name: "initial_count", scope: !171, file: !3, line: 40, type: !76)
!171 = distinct !DILexicalBlock(scope: !172, file: !3, line: 39, column: 12)
!172 = distinct !DILexicalBlock(scope: !167, file: !3, line: 34, column: 9)
!173 = distinct !DIAssignID()
!174 = !DILocation(line: 0, scope: !167)
!175 = distinct !DIAssignID()
!176 = !DILocation(line: 0, scope: !171)
!177 = !DILocation(line: 0, scope: !108)
!178 = !DILocation(line: 16, column: 41, scope: !108)
!179 = !{!180, !181, i64 4}
!180 = !{!"xdp_md", !181, i64 0, !181, i64 4, !181, i64 8, !181, i64 12, !181, i64 16, !181, i64 20}
!181 = !{!"int", !182, i64 0}
!182 = !{!"omnipotent char", !183, i64 0}
!183 = !{!"Simple C/C++ TBAA"}
!184 = !DILocation(line: 16, column: 30, scope: !108)
!185 = !DILocation(line: 16, column: 22, scope: !108)
!186 = !DILocation(line: 17, column: 37, scope: !108)
!187 = !{!180, !181, i64 0}
!188 = !DILocation(line: 17, column: 26, scope: !108)
!189 = !DILocation(line: 17, column: 18, scope: !108)
!190 = !DILocation(line: 20, column: 14, scope: !191)
!191 = distinct !DILexicalBlock(scope: !108, file: !3, line: 20, column: 9)
!192 = !DILocation(line: 20, column: 38, scope: !191)
!193 = !DILocation(line: 20, column: 9, scope: !108)
!194 = !DILocation(line: 23, column: 14, scope: !195)
!195 = distinct !DILexicalBlock(scope: !108, file: !3, line: 23, column: 9)
!196 = !{!197, !198, i64 12}
!197 = !{!"ethhdr", !182, i64 0, !182, i64 6, !198, i64 12}
!198 = !{!"short", !182, i64 0}
!199 = !DILocation(line: 23, column: 22, scope: !195)
!200 = !DILocation(line: 23, column: 9, scope: !108)
!201 = !DILocation(line: 31, column: 12, scope: !168)
!202 = !{!203, !182, i64 9}
!203 = !{!"iphdr", !182, i64 0, !182, i64 0, !182, i64 1, !198, i64 2, !198, i64 4, !198, i64 6, !182, i64 8, !182, i64 9, !198, i64 10, !182, i64 12}
!204 = !DILocation(line: 31, column: 36, scope: !168)
!205 = !DILocation(line: 32, column: 5, scope: !167)
!206 = !DILocation(line: 32, column: 22, scope: !167)
!207 = !DILocation(line: 32, column: 11, scope: !167)
!208 = !{!181, !181, i64 0}
!209 = distinct !DIAssignID()
!210 = !DILocation(line: 33, column: 20, scope: !167)
!211 = !DILocation(line: 34, column: 9, scope: !172)
!212 = !DILocation(line: 34, column: 9, scope: !167)
!213 = !DILocation(line: 35, column: 6, scope: !214)
!214 = distinct !DILexicalBlock(scope: !215, file: !3, line: 35, column: 6)
!215 = distinct !DILexicalBlock(scope: !172, file: !3, line: 34, column: 16)
!216 = !DILocation(line: 35, column: 15, scope: !214)
!217 = !DILocation(line: 35, column: 31, scope: !214)
!218 = !DILocation(line: 35, column: 34, scope: !214)
!219 = !{!220, !220, i64 0}
!220 = !{!"long long", !182, i64 0}
!221 = !DILocation(line: 35, column: 41, scope: !214)
!222 = !DILocation(line: 35, column: 6, scope: !215)
!223 = !DILocation(line: 38, column: 9, scope: !215)
!224 = !DILocation(line: 39, column: 5, scope: !215)
!225 = !DILocation(line: 40, column: 9, scope: !171)
!226 = !DILocation(line: 40, column: 15, scope: !171)
!227 = distinct !DIAssignID()
!228 = !DILocation(line: 41, column: 9, scope: !171)
!229 = !DILocation(line: 42, column: 5, scope: !172)
!230 = !DILocation(line: 43, column: 1, scope: !168)
!231 = !DILocation(line: 46, column: 1, scope: !108)
