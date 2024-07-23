(get-info :version)
; (:version "4.8.6")
; Started: 2024-07-15 15:44:38
; Silicon.version: 1.1-SNAPSHOT (4dbb81fc@(detached))
; Input file: -
; Verifier id: 00
; ------------------------------------------------------------
; Begin preamble
; ////////// Static preamble
; 
; ; /z3config.smt2
(set-option :print-success true) ; Boogie: false
(set-option :global-decls true) ; Boogie: default
(set-option :auto_config false) ; Usually a good idea
(set-option :smt.restart_strategy 0)
(set-option :smt.restart_factor |1.5|)
(set-option :smt.case_split 3)
(set-option :smt.delay_units true)
(set-option :smt.delay_units_threshold 16)
(set-option :nnf.sk_hack true)
(set-option :type_check true)
(set-option :smt.bv.reflect true)
(set-option :smt.mbqi false)
(set-option :smt.qi.eager_threshold 100)
(set-option :smt.qi.cost "(+ weight generation)")
(set-option :smt.qi.max_multi_patterns 1000)
(set-option :smt.phase_selection 0) ; default: 3, Boogie: 0
(set-option :sat.phase caching)
(set-option :sat.random_seed 0)
(set-option :nlsat.randomize true)
(set-option :nlsat.seed 0)
(set-option :nlsat.shuffle_vars false)
(set-option :fp.spacer.order_children 0) ; Not available with Z3 4.5
(set-option :fp.spacer.random_seed 0) ; Not available with Z3 4.5
(set-option :smt.arith.random_initial_value true) ; Boogie: true
(set-option :smt.random_seed 0)
(set-option :sls.random_offset true)
(set-option :sls.random_seed 0)
(set-option :sls.restart_init false)
(set-option :sls.walksat_ucb true)
(set-option :model.v2 true)
; 
; ; /preamble.smt2
(declare-datatypes () ((
    $Snap ($Snap.unit)
    ($Snap.combine ($Snap.first $Snap) ($Snap.second $Snap)))))
(declare-sort $Ref 0)
(declare-const $Ref.null $Ref)
(declare-sort $FPM)
(declare-sort $PPM)
(define-sort $Perm () Real)
(define-const $Perm.Write $Perm 1.0)
(define-const $Perm.No $Perm 0.0)
(define-fun $Perm.isValidVar ((p $Perm)) Bool
	(<= $Perm.No p))
(define-fun $Perm.isReadVar ((p $Perm) (ub $Perm)) Bool
    (and ($Perm.isValidVar p)
         (not (= p $Perm.No))
         (< p $Perm.Write)))
(define-fun $Perm.min ((p1 $Perm) (p2 $Perm)) Real
    (ite (<= p1 p2) p1 p2))
(define-fun $Math.min ((a Int) (b Int)) Int
    (ite (<= a b) a b))
(define-fun $Math.clip ((a Int)) Int
    (ite (< a 0) 0 a))
; ////////// Sorts
(declare-sort Seq<Int>)
(declare-sort Set<$Ref>)
(declare-sort Set<Bool>)
(declare-sort Set<Int>)
(declare-sort Set<Seq<Int>>)
(declare-sort Set<$Snap>)
(declare-sort frac)
(declare-sort TYPE)
(declare-sort zfrac)
(declare-sort $FVF<Seq<Int>>)
(declare-sort $FVF<$Ref>)
; ////////// Sort wrappers
; Declaring additional sort wrappers
(declare-fun $SortWrappers.IntTo$Snap (Int) $Snap)
(declare-fun $SortWrappers.$SnapToInt ($Snap) Int)
(assert (forall ((x Int)) (!
    (= x ($SortWrappers.$SnapToInt($SortWrappers.IntTo$Snap x)))
    :pattern (($SortWrappers.IntTo$Snap x))
    :qid |$Snap.$SnapToIntTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.IntTo$Snap($SortWrappers.$SnapToInt x)))
    :pattern (($SortWrappers.$SnapToInt x))
    :qid |$Snap.IntTo$SnapToInt|
    )))
(declare-fun $SortWrappers.BoolTo$Snap (Bool) $Snap)
(declare-fun $SortWrappers.$SnapToBool ($Snap) Bool)
(assert (forall ((x Bool)) (!
    (= x ($SortWrappers.$SnapToBool($SortWrappers.BoolTo$Snap x)))
    :pattern (($SortWrappers.BoolTo$Snap x))
    :qid |$Snap.$SnapToBoolTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.BoolTo$Snap($SortWrappers.$SnapToBool x)))
    :pattern (($SortWrappers.$SnapToBool x))
    :qid |$Snap.BoolTo$SnapToBool|
    )))
(declare-fun $SortWrappers.$RefTo$Snap ($Ref) $Snap)
(declare-fun $SortWrappers.$SnapTo$Ref ($Snap) $Ref)
(assert (forall ((x $Ref)) (!
    (= x ($SortWrappers.$SnapTo$Ref($SortWrappers.$RefTo$Snap x)))
    :pattern (($SortWrappers.$RefTo$Snap x))
    :qid |$Snap.$SnapTo$RefTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$RefTo$Snap($SortWrappers.$SnapTo$Ref x)))
    :pattern (($SortWrappers.$SnapTo$Ref x))
    :qid |$Snap.$RefTo$SnapTo$Ref|
    )))
(declare-fun $SortWrappers.$PermTo$Snap ($Perm) $Snap)
(declare-fun $SortWrappers.$SnapTo$Perm ($Snap) $Perm)
(assert (forall ((x $Perm)) (!
    (= x ($SortWrappers.$SnapTo$Perm($SortWrappers.$PermTo$Snap x)))
    :pattern (($SortWrappers.$PermTo$Snap x))
    :qid |$Snap.$SnapTo$PermTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$PermTo$Snap($SortWrappers.$SnapTo$Perm x)))
    :pattern (($SortWrappers.$SnapTo$Perm x))
    :qid |$Snap.$PermTo$SnapTo$Perm|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.Seq<Int>To$Snap (Seq<Int>) $Snap)
(declare-fun $SortWrappers.$SnapToSeq<Int> ($Snap) Seq<Int>)
(assert (forall ((x Seq<Int>)) (!
    (= x ($SortWrappers.$SnapToSeq<Int>($SortWrappers.Seq<Int>To$Snap x)))
    :pattern (($SortWrappers.Seq<Int>To$Snap x))
    :qid |$Snap.$SnapToSeq<Int>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Seq<Int>To$Snap($SortWrappers.$SnapToSeq<Int> x)))
    :pattern (($SortWrappers.$SnapToSeq<Int> x))
    :qid |$Snap.Seq<Int>To$SnapToSeq<Int>|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.Set<$Ref>To$Snap (Set<$Ref>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<$Ref> ($Snap) Set<$Ref>)
(assert (forall ((x Set<$Ref>)) (!
    (= x ($SortWrappers.$SnapToSet<$Ref>($SortWrappers.Set<$Ref>To$Snap x)))
    :pattern (($SortWrappers.Set<$Ref>To$Snap x))
    :qid |$Snap.$SnapToSet<$Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<$Ref>To$Snap($SortWrappers.$SnapToSet<$Ref> x)))
    :pattern (($SortWrappers.$SnapToSet<$Ref> x))
    :qid |$Snap.Set<$Ref>To$SnapToSet<$Ref>|
    )))
(declare-fun $SortWrappers.Set<Bool>To$Snap (Set<Bool>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Bool> ($Snap) Set<Bool>)
(assert (forall ((x Set<Bool>)) (!
    (= x ($SortWrappers.$SnapToSet<Bool>($SortWrappers.Set<Bool>To$Snap x)))
    :pattern (($SortWrappers.Set<Bool>To$Snap x))
    :qid |$Snap.$SnapToSet<Bool>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Bool>To$Snap($SortWrappers.$SnapToSet<Bool> x)))
    :pattern (($SortWrappers.$SnapToSet<Bool> x))
    :qid |$Snap.Set<Bool>To$SnapToSet<Bool>|
    )))
(declare-fun $SortWrappers.Set<Int>To$Snap (Set<Int>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Int> ($Snap) Set<Int>)
(assert (forall ((x Set<Int>)) (!
    (= x ($SortWrappers.$SnapToSet<Int>($SortWrappers.Set<Int>To$Snap x)))
    :pattern (($SortWrappers.Set<Int>To$Snap x))
    :qid |$Snap.$SnapToSet<Int>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Int>To$Snap($SortWrappers.$SnapToSet<Int> x)))
    :pattern (($SortWrappers.$SnapToSet<Int> x))
    :qid |$Snap.Set<Int>To$SnapToSet<Int>|
    )))
(declare-fun $SortWrappers.Set<Seq<Int>>To$Snap (Set<Seq<Int>>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Seq<Int>> ($Snap) Set<Seq<Int>>)
(assert (forall ((x Set<Seq<Int>>)) (!
    (= x ($SortWrappers.$SnapToSet<Seq<Int>>($SortWrappers.Set<Seq<Int>>To$Snap x)))
    :pattern (($SortWrappers.Set<Seq<Int>>To$Snap x))
    :qid |$Snap.$SnapToSet<Seq<Int>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Seq<Int>>To$Snap($SortWrappers.$SnapToSet<Seq<Int>> x)))
    :pattern (($SortWrappers.$SnapToSet<Seq<Int>> x))
    :qid |$Snap.Set<Seq<Int>>To$SnapToSet<Seq<Int>>|
    )))
(declare-fun $SortWrappers.Set<$Snap>To$Snap (Set<$Snap>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<$Snap> ($Snap) Set<$Snap>)
(assert (forall ((x Set<$Snap>)) (!
    (= x ($SortWrappers.$SnapToSet<$Snap>($SortWrappers.Set<$Snap>To$Snap x)))
    :pattern (($SortWrappers.Set<$Snap>To$Snap x))
    :qid |$Snap.$SnapToSet<$Snap>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<$Snap>To$Snap($SortWrappers.$SnapToSet<$Snap> x)))
    :pattern (($SortWrappers.$SnapToSet<$Snap> x))
    :qid |$Snap.Set<$Snap>To$SnapToSet<$Snap>|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.fracTo$Snap (frac) $Snap)
(declare-fun $SortWrappers.$SnapTofrac ($Snap) frac)
(assert (forall ((x frac)) (!
    (= x ($SortWrappers.$SnapTofrac($SortWrappers.fracTo$Snap x)))
    :pattern (($SortWrappers.fracTo$Snap x))
    :qid |$Snap.$SnapTofracTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.fracTo$Snap($SortWrappers.$SnapTofrac x)))
    :pattern (($SortWrappers.$SnapTofrac x))
    :qid |$Snap.fracTo$SnapTofrac|
    )))
(declare-fun $SortWrappers.TYPETo$Snap (TYPE) $Snap)
(declare-fun $SortWrappers.$SnapToTYPE ($Snap) TYPE)
(assert (forall ((x TYPE)) (!
    (= x ($SortWrappers.$SnapToTYPE($SortWrappers.TYPETo$Snap x)))
    :pattern (($SortWrappers.TYPETo$Snap x))
    :qid |$Snap.$SnapToTYPETo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.TYPETo$Snap($SortWrappers.$SnapToTYPE x)))
    :pattern (($SortWrappers.$SnapToTYPE x))
    :qid |$Snap.TYPETo$SnapToTYPE|
    )))
(declare-fun $SortWrappers.zfracTo$Snap (zfrac) $Snap)
(declare-fun $SortWrappers.$SnapTozfrac ($Snap) zfrac)
(assert (forall ((x zfrac)) (!
    (= x ($SortWrappers.$SnapTozfrac($SortWrappers.zfracTo$Snap x)))
    :pattern (($SortWrappers.zfracTo$Snap x))
    :qid |$Snap.$SnapTozfracTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.zfracTo$Snap($SortWrappers.$SnapTozfrac x)))
    :pattern (($SortWrappers.$SnapTozfrac x))
    :qid |$Snap.zfracTo$SnapTozfrac|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.$FVF<Seq<Int>>To$Snap ($FVF<Seq<Int>>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<Seq<Int>> ($Snap) $FVF<Seq<Int>>)
(assert (forall ((x $FVF<Seq<Int>>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<Seq<Int>>($SortWrappers.$FVF<Seq<Int>>To$Snap x)))
    :pattern (($SortWrappers.$FVF<Seq<Int>>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<Seq<Int>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<Seq<Int>>To$Snap($SortWrappers.$SnapTo$FVF<Seq<Int>> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<Seq<Int>> x))
    :qid |$Snap.$FVF<Seq<Int>>To$SnapTo$FVF<Seq<Int>>|
    )))
(declare-fun $SortWrappers.$FVF<$Ref>To$Snap ($FVF<$Ref>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<$Ref> ($Snap) $FVF<$Ref>)
(assert (forall ((x $FVF<$Ref>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<$Ref>($SortWrappers.$FVF<$Ref>To$Snap x)))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<$Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<$Ref>To$Snap($SortWrappers.$SnapTo$FVF<$Ref> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<$Ref> x))
    :qid |$Snap.$FVF<$Ref>To$SnapTo$FVF<$Ref>|
    )))
; ////////// Symbols
(declare-fun Set_in ($Ref Set<$Ref>) Bool)
(declare-fun Set_card (Set<$Ref>) Int)
(declare-const Set_empty Set<$Ref>)
(declare-fun Set_singleton ($Ref) Set<$Ref>)
(declare-fun Set_unionone (Set<$Ref> $Ref) Set<$Ref>)
(declare-fun Set_union (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_disjoint (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_difference (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_intersection (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_subset (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_equal (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_in (Bool Set<Bool>) Bool)
(declare-fun Set_card (Set<Bool>) Int)
(declare-const Set_empty Set<Bool>)
(declare-fun Set_singleton (Bool) Set<Bool>)
(declare-fun Set_unionone (Set<Bool> Bool) Set<Bool>)
(declare-fun Set_union (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_disjoint (Set<Bool> Set<Bool>) Bool)
(declare-fun Set_difference (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_intersection (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_subset (Set<Bool> Set<Bool>) Bool)
(declare-fun Set_equal (Set<Bool> Set<Bool>) Bool)
(declare-fun Set_in (Int Set<Int>) Bool)
(declare-fun Set_card (Set<Int>) Int)
(declare-const Set_empty Set<Int>)
(declare-fun Set_singleton (Int) Set<Int>)
(declare-fun Set_unionone (Set<Int> Int) Set<Int>)
(declare-fun Set_union (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_disjoint (Set<Int> Set<Int>) Bool)
(declare-fun Set_difference (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_intersection (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_subset (Set<Int> Set<Int>) Bool)
(declare-fun Set_equal (Set<Int> Set<Int>) Bool)
(declare-fun Set_in (Seq<Int> Set<Seq<Int>>) Bool)
(declare-fun Set_card (Set<Seq<Int>>) Int)
(declare-const Set_empty Set<Seq<Int>>)
(declare-fun Set_singleton (Seq<Int>) Set<Seq<Int>>)
(declare-fun Set_unionone (Set<Seq<Int>> Seq<Int>) Set<Seq<Int>>)
(declare-fun Set_union (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_disjoint (Set<Seq<Int>> Set<Seq<Int>>) Bool)
(declare-fun Set_difference (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_intersection (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_subset (Set<Seq<Int>> Set<Seq<Int>>) Bool)
(declare-fun Set_equal (Set<Seq<Int>> Set<Seq<Int>>) Bool)
(declare-fun Set_in ($Snap Set<$Snap>) Bool)
(declare-fun Set_card (Set<$Snap>) Int)
(declare-const Set_empty Set<$Snap>)
(declare-fun Set_singleton ($Snap) Set<$Snap>)
(declare-fun Set_unionone (Set<$Snap> $Snap) Set<$Snap>)
(declare-fun Set_union (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_disjoint (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Set_difference (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_intersection (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_subset (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Set_equal (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Seq_length (Seq<Int>) Int)
(declare-const Seq_empty Seq<Int>)
(declare-fun Seq_singleton (Int) Seq<Int>)
(declare-fun Seq_build (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_index (Seq<Int> Int) Int)
(declare-fun Seq_append (Seq<Int> Seq<Int>) Seq<Int>)
(declare-fun Seq_update (Seq<Int> Int Int) Seq<Int>)
(declare-fun Seq_contains (Seq<Int> Int) Bool)
(declare-fun Seq_take (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_drop (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_equal (Seq<Int> Seq<Int>) Bool)
(declare-fun Seq_sameuntil (Seq<Int> Seq<Int> Int) Bool)
(declare-fun Seq_range (Int Int) Seq<Int>)
(declare-fun frac_val<Perm> (frac) $Perm)
(declare-const class_ALU<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Object<TYPE> TYPE)
(declare-const class_Driver<TYPE> TYPE)
(declare-const class_Monitor<TYPE> TYPE)
(declare-const class_Main<TYPE> TYPE)
(declare-const class_EncodedGlobalVariables<TYPE> TYPE)
(declare-fun directSuperclass<TYPE> (TYPE) TYPE)
(declare-fun type_of<TYPE> ($Ref) TYPE)
(declare-fun zfrac_val<Perm> (zfrac) $Perm)
; /field_value_functions_declarations.smt2 [Main_process_state: Seq[Int]]
(declare-fun $FVF.domain_Main_process_state ($FVF<Seq<Int>>) Set<$Ref>)
(declare-fun $FVF.lookup_Main_process_state ($FVF<Seq<Int>> $Ref) Seq<Int>)
(declare-fun $FVF.after_Main_process_state ($FVF<Seq<Int>> $FVF<Seq<Int>>) Bool)
(declare-fun $FVF.loc_Main_process_state (Seq<Int> $Ref) Bool)
(declare-fun $FVF.perm_Main_process_state ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Main_process_state $FVF<Seq<Int>>)
; /field_value_functions_declarations.smt2 [ALU_m: Ref]
(declare-fun $FVF.domain_ALU_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_ALU_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_ALU_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_ALU_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_ALU_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_ALU_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [Driver_m: Ref]
(declare-fun $FVF.domain_Driver_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Driver_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Driver_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Driver_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Driver_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Driver_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [Monitor_m: Ref]
(declare-fun $FVF.domain_Monitor_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Monitor_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Monitor_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Monitor_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Monitor_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Monitor_m $FVF<$Ref>)
; Declaring symbols related to program functions (from program analysis)
(declare-fun instanceof_TYPE_TYPE ($Snap TYPE TYPE) Bool)
(declare-fun instanceof_TYPE_TYPE%limited ($Snap TYPE TYPE) Bool)
(declare-fun instanceof_TYPE_TYPE%stateless (TYPE TYPE) Bool)
(declare-fun new_frac ($Snap $Perm) frac)
(declare-fun new_frac%limited ($Snap $Perm) frac)
(declare-fun new_frac%stateless ($Perm) Bool)
(declare-fun new_zfrac ($Snap $Perm) zfrac)
(declare-fun new_zfrac%limited ($Snap $Perm) zfrac)
(declare-fun new_zfrac%stateless ($Perm) Bool)
(declare-fun Main_find_minimum_advance_Sequence$Integer$ ($Snap $Ref Seq<Int>) Int)
(declare-fun Main_find_minimum_advance_Sequence$Integer$%limited ($Snap $Ref Seq<Int>) Int)
(declare-fun Main_find_minimum_advance_Sequence$Integer$%stateless ($Ref Seq<Int>) Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
(declare-fun Driver_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Driver_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Monitor_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Monitor_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_held_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
; ////////// Uniqueness assumptions from domains
(assert (distinct class_ALU<TYPE> class_java_DOT_lang_DOT_Object<TYPE> class_Driver<TYPE> class_Monitor<TYPE> class_Main<TYPE> class_EncodedGlobalVariables<TYPE>))
; ////////// Axioms
(assert (forall ((s Seq<Int>)) (!
  (<= 0 (Seq_length s))
  :pattern ((Seq_length s))
  :qid |$Seq[Int]_prog.seq_length_non_negative|)))
(assert (= (Seq_length (as Seq_empty  Seq<Int>)) 0))
(assert (forall ((s Seq<Int>)) (!
  (implies (= (Seq_length s) 0) (= s (as Seq_empty  Seq<Int>)))
  :pattern ((Seq_length s))
  :qid |$Seq[Int]_prog.only_empty_seq_length_zero|)))
(assert (forall ((e Int)) (!
  (= (Seq_length (Seq_singleton e)) 1)
  :pattern ((Seq_length (Seq_singleton e)))
  :qid |$Seq[Int]_prog.length_singleton_seq|)))
(assert (forall ((s Seq<Int>) (e Int)) (!
  (= (Seq_length (Seq_build s e)) (+ 1 (Seq_length s)))
  :pattern ((Seq_length (Seq_build s e)))
  :qid |$Seq[Int]_prog.length_seq_build_inc_by_one|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int)) (!
  (ite
    (= i (Seq_length s))
    (= (Seq_index (Seq_build s e) i) e)
    (= (Seq_index (Seq_build s e) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_build s e) i))
  :qid |$Seq[Int]_prog.seq_index_over_build|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Int>)))
      (not (= s2 (as Seq_empty  Seq<Int>))))
    (= (Seq_length (Seq_append s1 s2)) (+ (Seq_length s1) (Seq_length s2))))
  :pattern ((Seq_length (Seq_append s1 s2)))
  :qid |$Seq[Int]_prog.seq_length_over_append|)))
(assert (forall ((e Int)) (!
  (= (Seq_index (Seq_singleton e) 0) e)
  :pattern ((Seq_index (Seq_singleton e) 0))
  :qid |$Seq[Int]_prog.seq_index_over_singleton|)))
(assert (forall ((e1 Int) (e2 Int)) (!
  (= (Seq_contains (Seq_singleton e1) e2) (= e1 e2))
  :pattern ((Seq_contains (Seq_singleton e1) e2))
  :qid |$Seq[Int]_prog.seq_contains_over_singleton|)))
(assert (forall ((s Seq<Int>)) (!
  (= (Seq_append (as Seq_empty  Seq<Int>) s) s)
  :pattern ((Seq_append (as Seq_empty  Seq<Int>) s))
  :qid |$Seq[Int]_prog.seq_append_empty_left|)))
(assert (forall ((s Seq<Int>)) (!
  (= (Seq_append s (as Seq_empty  Seq<Int>)) s)
  :pattern ((Seq_append s (as Seq_empty  Seq<Int>)))
  :qid |$Seq[Int]_prog.seq_append_empty_right|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (i Int)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Int>)))
      (not (= s2 (as Seq_empty  Seq<Int>))))
    (ite
      (< i (Seq_length s1))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s1 i))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s2 (- i (Seq_length s1))))))
  :pattern ((Seq_index (Seq_append s1 s2) i))
  :pattern ((Seq_index s1 i) (Seq_append s1 s2))
  :qid |$Seq[Int]_prog.seq_index_over_append|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int)) (!
  (implies
    (and (<= 0 i) (< i (Seq_length s)))
    (= (Seq_length (Seq_update s i e)) (Seq_length s)))
  :pattern ((Seq_length (Seq_update s i e)))
  :qid |$Seq[Int]_prog.seq_length_invariant_over_update|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (j Int)) (!
  (ite
    (implies (and (<= 0 i) (< i (Seq_length s))) (= i j))
    (= (Seq_index (Seq_update s i e) j) e)
    (= (Seq_index (Seq_update s i e) j) (Seq_index s j)))
  :pattern ((Seq_index (Seq_update s i e) j))
  :qid |$Seq[Int]_prog.seq_index_over_update|)))
(assert (forall ((s Seq<Int>) (e Int)) (!
  (=
    (Seq_contains s e)
    (exists ((i Int)) (!
      (and (<= 0 i) (and (< i (Seq_length s)) (= (Seq_index s i) e)))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains s e))
  :qid |$Seq[Int]_prog.seq_element_contains_index_exists|)))
(assert (forall ((e Int)) (!
  (not (Seq_contains (as Seq_empty  Seq<Int>) e))
  :pattern ((Seq_contains (as Seq_empty  Seq<Int>) e))
  :qid |$Seq[Int]_prog.empty_seq_contains_nothing|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (e Int)) (!
  (=
    (Seq_contains (Seq_append s1 s2) e)
    (or (Seq_contains s1 e) (Seq_contains s2 e)))
  :pattern ((Seq_contains (Seq_append s1 s2) e))
  :qid |$Seq[Int]_prog.seq_contains_over_append|)))
(assert (forall ((s Seq<Int>) (e1 Int) (e2 Int)) (!
  (= (Seq_contains (Seq_build s e1) e2) (or (= e1 e2) (Seq_contains s e2)))
  :pattern ((Seq_contains (Seq_build s e1) e2))
  :qid |$Seq[Int]_prog.seq_contains_over_build|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies (<= n 0) (= (Seq_take s n) (as Seq_empty  Seq<Int>)))
  :pattern ((Seq_take s n))
  :qid |$Seq[Int]_prog.seq_take_negative_length|)))
(assert (forall ((s Seq<Int>) (n Int) (e Int)) (!
  (=
    (Seq_contains (Seq_take s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (< i n) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_take s n) e))
  :qid |$Seq[Int]_prog.seq_contains_over_take_index_exists|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies (<= n 0) (= (Seq_drop s n) s))
  :pattern ((Seq_drop s n))
  :qid |$Seq[Int]_prog.seq_drop_negative_length|)))
(assert (forall ((s Seq<Int>) (n Int) (e Int)) (!
  (=
    (Seq_contains (Seq_drop s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (<= n i) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_drop s n) e))
  :qid |$Seq[Int]_prog.seq_contains_over_drop_index_exists|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (=
    (Seq_equal s1 s2)
    (and
      (= (Seq_length s1) (Seq_length s2))
      (forall ((i Int)) (!
        (implies
          (and (<= 0 i) (< i (Seq_length s1)))
          (= (Seq_index s1 i) (Seq_index s2 i)))
        :pattern ((Seq_index s1 i))
        :pattern ((Seq_index s2 i))
        ))))
  :pattern ((Seq_equal s1 s2))
  :qid |$Seq[Int]_prog.extensional_seq_equality|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (implies (Seq_equal s1 s2) (= s1 s2))
  :pattern ((Seq_equal s1 s2))
  :qid |$Seq[Int]_prog.seq_equality_identity|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (n Int)) (!
  (=
    (Seq_sameuntil s1 s2 n)
    (forall ((i Int)) (!
      (implies (and (<= 0 i) (< i n)) (= (Seq_index s1 i) (Seq_index s2 i)))
      :pattern ((Seq_index s1 i))
      :pattern ((Seq_index s2 i))
      )))
  :pattern ((Seq_sameuntil s1 s2 n))
  :qid |$Seq[Int]_prog.extensional_seq_equality_prefix|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_take s n)) n)
      (= (Seq_length (Seq_take s n)) (Seq_length s))))
  :pattern ((Seq_length (Seq_take s n)))
  :qid |$Seq[Int]_prog.seq_length_over_take|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< i (Seq_length s))))
    (= (Seq_index (Seq_take s n) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_take s n) i))
  :pattern ((Seq_index s i) (Seq_take s n))
  :qid |$Seq[Int]_prog.seq_index_over_take|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_drop s n)) (- (Seq_length s) n))
      (= (Seq_length (Seq_drop s n)) 0)))
  :pattern ((Seq_length (Seq_drop s n)))
  :qid |$Seq[Int]_prog.seq_length_over_drop|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= 0 i) (< i (- (Seq_length s) n))))
    (= (Seq_index (Seq_drop s n) i) (Seq_index s (+ i n))))
  :pattern ((Seq_index (Seq_drop s n) i))
  :qid |$Seq[Int]_prog.seq_index_over_drop_1|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_index (Seq_drop s n) (- i n)) (Seq_index s i)))
  :pattern ((Seq_index s i) (Seq_drop s n))
  :qid |$Seq[Int]_prog.seq_index_over_drop_2|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_take (Seq_update s i e) n) (Seq_update (Seq_take s n) i e)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_take_over_update_1|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= n i) (< i (Seq_length s)))
    (= (Seq_take (Seq_update s i e) n) (Seq_take s n)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_take_over_update_2|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_update (Seq_drop s n) (- i n) e)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_update_1|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_drop s n)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_update_2|)))
(assert (forall ((s Seq<Int>) (e Int) (n Int)) (!
  (implies
    (and (<= 0 n) (<= n (Seq_length s)))
    (= (Seq_drop (Seq_build s e) n) (Seq_build (Seq_drop s n) e)))
  :pattern ((Seq_drop (Seq_build s e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_build|)))
(assert (forall ((min_ Int) (max Int)) (!
  (ite
    (< min_ max)
    (= (Seq_length (Seq_range min_ max)) (- max min_))
    (= (Seq_length (Seq_range min_ max)) 0))
  :pattern ((Seq_length (Seq_range min_ max)))
  :qid |$Seq[Int]_prog.ranged_seq_length|)))
(assert (forall ((min_ Int) (max Int) (i Int)) (!
  (implies
    (and (<= 0 i) (< i (- max min_)))
    (= (Seq_index (Seq_range min_ max) i) (+ min_ i)))
  :pattern ((Seq_index (Seq_range min_ max) i))
  :qid |$Seq[Int]_prog.ranged_seq_index|)))
(assert (forall ((min_ Int) (max Int) (e Int)) (!
  (= (Seq_contains (Seq_range min_ max) e) (and (<= min_ e) (< e max)))
  :pattern ((Seq_contains (Seq_range min_ max) e))
  :qid |$Seq[Int]_prog.ranged_seq_contains|)))
(assert (forall ((s Set<$Ref>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Ref]_prog.card_non_negative|)))
(assert (forall ((e $Ref)) (!
  (not (Set_in e (as Set_empty  Set<$Ref>)))
  :pattern ((Set_in e (as Set_empty  Set<$Ref>)))
  :qid |$Set[Ref]_prog.in_empty_set|)))
(assert (forall ((s Set<$Ref>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<$Ref>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e $Ref)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Ref]_prog.empty_set_cardinality|)))
(assert (forall ((e $Ref)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Ref]_prog.in_singleton_set|)))
(assert (forall ((e1 $Ref) (e2 $Ref)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Ref]_prog.in_singleton_set_equality|)))
(assert (forall ((e $Ref)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Ref]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Ref]_prog.in_unionone_same|)))
(assert (forall ((s Set<$Ref>) (e1 $Ref) (e2 $Ref)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Ref]_prog.in_unionone_other|)))
(assert (forall ((s Set<$Ref>) (e1 $Ref) (e2 $Ref)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Ref]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Ref]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Ref]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Ref]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Ref]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Ref]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Ref]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Ref]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Ref]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Ref]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Ref]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Ref]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Ref]_prog.in_difference|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Ref]_prog.not_in_difference|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e $Ref)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Ref]_prog.subset_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e $Ref)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Ref]_prog.equality_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Ref]_prog.native_equality|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e $Ref)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Ref]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Ref]_prog.cardinality_difference|)))
(assert (forall ((s Set<Bool>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Bool]_prog.card_non_negative|)))
(assert (forall ((e Bool)) (!
  (not (Set_in e (as Set_empty  Set<Bool>)))
  :pattern ((Set_in e (as Set_empty  Set<Bool>)))
  :qid |$Set[Bool]_prog.in_empty_set|)))
(assert (forall ((s Set<Bool>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Bool>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Bool)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Bool]_prog.empty_set_cardinality|)))
(assert (forall ((e Bool)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Bool]_prog.in_singleton_set|)))
(assert (forall ((e1 Bool) (e2 Bool)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Bool]_prog.in_singleton_set_equality|)))
(assert (forall ((e Bool)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Bool]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Bool]_prog.in_unionone_same|)))
(assert (forall ((s Set<Bool>) (e1 Bool) (e2 Bool)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Bool]_prog.in_unionone_other|)))
(assert (forall ((s Set<Bool>) (e1 Bool) (e2 Bool)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Bool]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Bool]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Bool]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Bool]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Bool]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Bool]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Bool]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Bool]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Bool]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Bool]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Bool]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Bool]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Bool]_prog.in_difference|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Bool]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Bool)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Bool]_prog.subset_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Bool)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Bool]_prog.equality_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Bool]_prog.native_equality|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Bool)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Bool]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Bool]_prog.cardinality_difference|)))
(assert (forall ((s Set<Int>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Int]_prog.card_non_negative|)))
(assert (forall ((e Int)) (!
  (not (Set_in e (as Set_empty  Set<Int>)))
  :pattern ((Set_in e (as Set_empty  Set<Int>)))
  :qid |$Set[Int]_prog.in_empty_set|)))
(assert (forall ((s Set<Int>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Int>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Int)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Int]_prog.empty_set_cardinality|)))
(assert (forall ((e Int)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Int]_prog.in_singleton_set|)))
(assert (forall ((e1 Int) (e2 Int)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Int]_prog.in_singleton_set_equality|)))
(assert (forall ((e Int)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Int]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Int]_prog.in_unionone_same|)))
(assert (forall ((s Set<Int>) (e1 Int) (e2 Int)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Int]_prog.in_unionone_other|)))
(assert (forall ((s Set<Int>) (e1 Int) (e2 Int)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Int]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Int]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Int]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Int]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Int]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Int]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Int]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Int]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Int]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Int]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Int]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Int]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Int]_prog.in_difference|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Int]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Int)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Int]_prog.subset_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Int)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Int]_prog.equality_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Int]_prog.native_equality|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Int)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Int]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Int]_prog.cardinality_difference|)))
(assert (forall ((s Set<Seq<Int>>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Int]]_prog.card_non_negative|)))
(assert (forall ((e Seq<Int>)) (!
  (not (Set_in e (as Set_empty  Set<Seq<Int>>)))
  :pattern ((Set_in e (as Set_empty  Set<Seq<Int>>)))
  :qid |$Set[Seq[Int]]_prog.in_empty_set|)))
(assert (forall ((s Set<Seq<Int>>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Seq<Int>>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Seq<Int>)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Int]]_prog.empty_set_cardinality|)))
(assert (forall ((e Seq<Int>)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Seq[Int]]_prog.in_singleton_set|)))
(assert (forall ((e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Seq[Int]]_prog.in_singleton_set_equality|)))
(assert (forall ((e Seq<Int>)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Seq[Int]]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Seq[Int]]_prog.in_unionone_same|)))
(assert (forall ((s Set<Seq<Int>>) (e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Seq[Int]]_prog.in_unionone_other|)))
(assert (forall ((s Set<Seq<Int>>) (e1 Seq<Int>) (e2 Seq<Int>)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Seq[Int]]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Int]]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Int]]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Seq[Int]]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Seq[Int]]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Seq[Int]]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Int]]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Seq[Int]]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Seq[Int]]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Seq[Int]]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Seq[Int]]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Seq[Int]]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Seq[Int]]_prog.in_difference|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Int]]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Seq<Int>)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Seq[Int]]_prog.subset_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Seq<Int>)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Int]]_prog.equality_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Int]]_prog.native_equality|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Seq<Int>)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Seq[Int]]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Seq[Int]]_prog.cardinality_difference|)))
(assert (forall ((s Set<$Snap>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Snap]_prog.card_non_negative|)))
(assert (forall ((e $Snap)) (!
  (not (Set_in e (as Set_empty  Set<$Snap>)))
  :pattern ((Set_in e (as Set_empty  Set<$Snap>)))
  :qid |$Set[Snap]_prog.in_empty_set|)))
(assert (forall ((s Set<$Snap>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<$Snap>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e $Snap)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Snap]_prog.empty_set_cardinality|)))
(assert (forall ((e $Snap)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Snap]_prog.in_singleton_set|)))
(assert (forall ((e1 $Snap) (e2 $Snap)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Snap]_prog.in_singleton_set_equality|)))
(assert (forall ((e $Snap)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Snap]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Snap]_prog.in_unionone_same|)))
(assert (forall ((s Set<$Snap>) (e1 $Snap) (e2 $Snap)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Snap]_prog.in_unionone_other|)))
(assert (forall ((s Set<$Snap>) (e1 $Snap) (e2 $Snap)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Snap]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Snap]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Snap]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Snap]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Snap]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Snap]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Snap]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Snap]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Snap]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Snap]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Snap]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Snap]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Snap]_prog.in_difference|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Snap]_prog.not_in_difference|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e $Snap)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Snap]_prog.subset_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e $Snap)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Snap]_prog.equality_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Snap]_prog.native_equality|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e $Snap)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Snap]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Snap]_prog.cardinality_difference|)))
(assert (forall ((a frac) (b frac)) (!
  (= (= (frac_val<Perm> a) (frac_val<Perm> b)) (= a b))
  :pattern ((frac_val<Perm> a) (frac_val<Perm> b))
  :qid |prog.frac_eq|)))
(assert (forall ((a frac)) (!
  (and (< $Perm.No (frac_val<Perm> a)) (<= (frac_val<Perm> a) $Perm.Write))
  :pattern ((frac_val<Perm> a))
  :qid |prog.frac_bound|)))
(assert (=
  (directSuperclass<TYPE> (as class_ALU<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Driver<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Monitor<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Main<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_EncodedGlobalVariables<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (forall ((a zfrac) (b zfrac)) (!
  (= (= (zfrac_val<Perm> a) (zfrac_val<Perm> b)) (= a b))
  :pattern ((zfrac_val<Perm> a) (zfrac_val<Perm> b))
  :qid |prog.zfrac_eq|)))
(assert (forall ((a zfrac)) (!
  (and (<= $Perm.No (zfrac_val<Perm> a)) (<= (zfrac_val<Perm> a) $Perm.Write))
  :pattern ((zfrac_val<Perm> a))
  :qid |prog.zfrac_bound|)))
; /field_value_functions_axioms.smt2 [Main_process_state: Seq[Int]]
(assert (forall ((vs $FVF<Seq<Int>>) (ws $FVF<Seq<Int>>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Main_process_state vs) ($FVF.domain_Main_process_state ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Main_process_state vs))
            (= ($FVF.lookup_Main_process_state vs x) ($FVF.lookup_Main_process_state ws x)))
          :pattern (($FVF.lookup_Main_process_state vs x) ($FVF.lookup_Main_process_state ws x))
          :qid |qp.$FVF<Seq<Int>>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<Seq<Int>>To$Snap vs)
              ($SortWrappers.$FVF<Seq<Int>>To$Snap ws)
              )
    :qid |qp.$FVF<Seq<Int>>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Main_process_state pm r))
    :pattern ($FVF.perm_Main_process_state pm r))))
(assert (forall ((r $Ref) (f Seq<Int>)) (!
    (= ($FVF.loc_Main_process_state f r) true)
    :pattern ($FVF.loc_Main_process_state f r))))
; /field_value_functions_axioms.smt2 [ALU_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_ALU_m vs) ($FVF.domain_ALU_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_ALU_m vs))
            (= ($FVF.lookup_ALU_m vs x) ($FVF.lookup_ALU_m ws x)))
          :pattern (($FVF.lookup_ALU_m vs x) ($FVF.lookup_ALU_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_ALU_m pm r))
    :pattern ($FVF.perm_ALU_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_ALU_m f r) true)
    :pattern ($FVF.loc_ALU_m f r))))
; /field_value_functions_axioms.smt2 [Driver_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Driver_m vs) ($FVF.domain_Driver_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Driver_m vs))
            (= ($FVF.lookup_Driver_m vs x) ($FVF.lookup_Driver_m ws x)))
          :pattern (($FVF.lookup_Driver_m vs x) ($FVF.lookup_Driver_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Driver_m pm r))
    :pattern ($FVF.perm_Driver_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Driver_m f r) true)
    :pattern ($FVF.loc_Driver_m f r))))
; /field_value_functions_axioms.smt2 [Monitor_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Monitor_m vs) ($FVF.domain_Monitor_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Monitor_m vs))
            (= ($FVF.lookup_Monitor_m vs x) ($FVF.lookup_Monitor_m ws x)))
          :pattern (($FVF.lookup_Monitor_m vs x) ($FVF.lookup_Monitor_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Monitor_m pm r))
    :pattern ($FVF.perm_Monitor_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Monitor_m f r) true)
    :pattern ($FVF.loc_Monitor_m f r))))
; End preamble
; ------------------------------------------------------------
; State saturation: after preamble
(set-option :timeout 100)
(check-sat)
; unknown
; ------------------------------------------------------------
; Begin function- and predicate-related preamble
; Declaring symbols related to program functions (from verification)
(assert (forall ((s@$ $Snap) (t@0@00 TYPE) (u@1@00 TYPE)) (!
  (=
    (instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00)
    (instanceof_TYPE_TYPE s@$ t@0@00 u@1@00))
  :pattern ((instanceof_TYPE_TYPE s@$ t@0@00 u@1@00))
  )))
(assert (forall ((s@$ $Snap) (t@0@00 TYPE) (u@1@00 TYPE)) (!
  (instanceof_TYPE_TYPE%stateless t@0@00 u@1@00)
  :pattern ((instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00))
  )))
(assert (forall ((s@$ $Snap) (t@0@00 TYPE) (u@1@00 TYPE)) (!
  (let ((result@2@00 (instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00))) (=
    result@2@00
    (or (= t@0@00 u@1@00) (= (directSuperclass<TYPE> t@0@00) u@1@00))))
  :pattern ((instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00))
  )))
(assert (forall ((s@$ $Snap) (x@3@00 $Perm)) (!
  (= (new_frac%limited s@$ x@3@00) (new_frac s@$ x@3@00))
  :pattern ((new_frac s@$ x@3@00))
  )))
(assert (forall ((s@$ $Snap) (x@3@00 $Perm)) (!
  (new_frac%stateless x@3@00)
  :pattern ((new_frac%limited s@$ x@3@00))
  )))
(assert (forall ((s@$ $Snap) (x@3@00 $Perm)) (!
  (let ((result@4@00 (new_frac%limited s@$ x@3@00))) (implies
    (and (< $Perm.No x@3@00) (<= x@3@00 $Perm.Write))
    (= (frac_val<Perm> result@4@00) x@3@00)))
  :pattern ((new_frac%limited s@$ x@3@00))
  )))
(assert (forall ((s@$ $Snap) (x@5@00 $Perm)) (!
  (= (new_zfrac%limited s@$ x@5@00) (new_zfrac s@$ x@5@00))
  :pattern ((new_zfrac s@$ x@5@00))
  )))
(assert (forall ((s@$ $Snap) (x@5@00 $Perm)) (!
  (new_zfrac%stateless x@5@00)
  :pattern ((new_zfrac%limited s@$ x@5@00))
  )))
(assert (forall ((s@$ $Snap) (x@5@00 $Perm)) (!
  (let ((result@6@00 (new_zfrac%limited s@$ x@5@00))) (implies
    (and (<= $Perm.No x@5@00) (<= x@5@00 $Perm.Write))
    (= (zfrac_val<Perm> result@6@00) x@5@00)))
  :pattern ((new_zfrac%limited s@$ x@5@00))
  )))
(assert (forall ((s@$ $Snap) (diz@7@00 $Ref) (vals@8@00 Seq<Int>)) (!
  (=
    (Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@7@00 vals@8@00)
    (Main_find_minimum_advance_Sequence$Integer$ s@$ diz@7@00 vals@8@00))
  :pattern ((Main_find_minimum_advance_Sequence$Integer$ s@$ diz@7@00 vals@8@00))
  )))
(assert (forall ((s@$ $Snap) (diz@7@00 $Ref) (vals@8@00 Seq<Int>)) (!
  (Main_find_minimum_advance_Sequence$Integer$%stateless diz@7@00 vals@8@00)
  :pattern ((Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@7@00 vals@8@00))
  )))
(assert (forall ((s@$ $Snap) (diz@7@00 $Ref) (vals@8@00 Seq<Int>)) (!
  (let ((result@9@00 (Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@7@00 vals@8@00))) (implies
    (and (not (= diz@7@00 $Ref.null)) (= (Seq_length vals@8@00) 2))
    (and
      (and
        (or
          (< (Seq_index vals@8@00 0) (- 0 1))
          (<= result@9@00 (Seq_index vals@8@00 0)))
        (or
          (< (Seq_index vals@8@00 1) (- 0 1))
          (<= result@9@00 (Seq_index vals@8@00 1))))
      (and
        (implies
          (and
            (< (Seq_index vals@8@00 0) (- 0 1))
            (< (Seq_index vals@8@00 1) (- 0 1)))
          (= result@9@00 0))
        (implies
          (or
            (<= (- 0 1) (Seq_index vals@8@00 0))
            (<= (- 0 1) (Seq_index vals@8@00 1)))
          (or
            (and
              (<= (- 0 1) (Seq_index vals@8@00 0))
              (= result@9@00 (Seq_index vals@8@00 0)))
            (and
              (<= (- 0 1) (Seq_index vals@8@00 1))
              (= result@9@00 (Seq_index vals@8@00 1)))))))))
  :pattern ((Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@7@00 vals@8@00))
  )))
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- ALU___contract_unsatisfiable__operate_EncodedGlobalVariables ----------
(declare-const diz@0@02 $Ref)
(declare-const globals@1@02 $Ref)
(declare-const diz@2@02 $Ref)
(declare-const globals@3@02 $Ref)
(push) ; 1
(declare-const $t@4@02 $Snap)
(assert (= $t@4@02 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@2@02 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.ALU_m, wildcard) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && (true && (true && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__23: Int :: { diz.ALU_m.Main_process_state[i__23] } 0 <= i__23 && i__23 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__23] == -1 || 0 <= diz.ALU_m.Main_process_state[i__23] && diz.ALU_m.Main_process_state[i__23] < |diz.ALU_m.Main_event_state|)) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && 0 <= diz.ALU_m.Main_alu.ALU_RESULT && diz.ALU_m.Main_alu.ALU_RESULT <= 16 && acc(diz.ALU_m.Main_dr, wildcard) && diz.ALU_m.Main_dr != null && acc(diz.ALU_m.Main_dr.Driver_init, 1 / 2) && acc(diz.ALU_m.Main_dr.Driver_z, write) && acc(diz.ALU_m.Main_dr.Driver_x, write) && acc(diz.ALU_m.Main_dr.Driver_y, write) && acc(diz.ALU_m.Main_dr.Driver_a, write) && acc(diz.ALU_m.Main_mon, wildcard) && diz.ALU_m.Main_mon != null && acc(diz.ALU_m.Main_mon.Monitor_init, 1 / 2) && acc(diz.ALU_m.Main_alu.ALU_m, wildcard) && diz.ALU_m.Main_alu.ALU_m == diz.ALU_m) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu == diz)
(declare-const $t@5@02 $Snap)
(assert (= $t@5@02 ($Snap.combine ($Snap.first $t@5@02) ($Snap.second $t@5@02))))
(assert (= ($Snap.first $t@5@02) $Snap.unit))
(assert (=
  ($Snap.second $t@5@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@5@02))
    ($Snap.second ($Snap.second $t@5@02)))))
(declare-const $k@6@02 $Perm)
(assert ($Perm.isReadVar $k@6@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@6@02 $Perm.No) (< $Perm.No $k@6@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             18
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             1
;  :datatype-accessor-ax  3
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           265
;  :mk-clause             3
;  :num-allocs            3508183
;  :num-checks            2
;  :propagations          17
;  :quant-instantiations  1
;  :rlimit-count          112053)
(assert (<= $Perm.No $k@6@02))
(assert (<= $k@6@02 $Perm.Write))
(assert (implies (< $Perm.No $k@6@02) (not (= diz@2@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@5@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@5@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@5@02))) $Snap.unit))
; [eval] diz.ALU_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             24
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             2
;  :datatype-accessor-ax  4
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           268
;  :mk-clause             3
;  :num-allocs            3508183
;  :num-checks            3
;  :propagations          17
;  :quant-instantiations  1
;  :rlimit-count          112306)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@5@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@5@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             30
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             3
;  :datatype-accessor-ax  5
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           271
;  :mk-clause             3
;  :num-allocs            3508183
;  :num-checks            4
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          112590
;  :time                  0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             47
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             4
;  :datatype-accessor-ax  8
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           276
;  :mk-clause             3
;  :num-allocs            3508183
;  :num-checks            5
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          113030
;  :time                  0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             53
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             5
;  :datatype-accessor-ax  9
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           278
;  :mk-clause             3
;  :num-allocs            3626231
;  :num-checks            6
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          113279)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             60
;  :arith-assert-diseq    2
;  :arith-assert-lower    6
;  :arith-assert-upper    4
;  :arith-eq-adapter      4
;  :binary-propagations   16
;  :conflicts             6
;  :datatype-accessor-ax  10
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           287
;  :mk-clause             6
;  :num-allocs            3626231
;  :num-checks            7
;  :propagations          18
;  :quant-instantiations  5
;  :rlimit-count          113664)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             66
;  :arith-assert-diseq    2
;  :arith-assert-lower    6
;  :arith-assert-upper    4
;  :arith-eq-adapter      4
;  :binary-propagations   16
;  :conflicts             7
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           289
;  :mk-clause             6
;  :num-allocs            3626231
;  :num-checks            8
;  :propagations          18
;  :quant-instantiations  5
;  :rlimit-count          113933)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))
  $Snap.unit))
; [eval] (forall i__23: Int :: { diz.ALU_m.Main_process_state[i__23] } 0 <= i__23 && i__23 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__23] == -1 || 0 <= diz.ALU_m.Main_process_state[i__23] && diz.ALU_m.Main_process_state[i__23] < |diz.ALU_m.Main_event_state|)
(declare-const i__23@7@02 Int)
(push) ; 3
; [eval] 0 <= i__23 && i__23 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__23] == -1 || 0 <= diz.ALU_m.Main_process_state[i__23] && diz.ALU_m.Main_process_state[i__23] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__23 && i__23 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__23
(push) ; 4
; [then-branch: 0 | 0 <= i__23@7@02 | live]
; [else-branch: 0 | !(0 <= i__23@7@02) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i__23@7@02]
(assert (<= 0 i__23@7@02))
; [eval] i__23 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             74
;  :arith-assert-diseq    3
;  :arith-assert-lower    10
;  :arith-assert-upper    5
;  :arith-eq-adapter      6
;  :binary-propagations   16
;  :conflicts             8
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           300
;  :mk-clause             9
;  :num-allocs            3626231
;  :num-checks            9
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114425)
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i__23@7@02)]
(assert (not (<= 0 i__23@7@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i__23@7@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))| && 0 <= i__23@7@02 | live]
; [else-branch: 1 | !(i__23@7@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))| && 0 <= i__23@7@02) | live]
(push) ; 5
; [then-branch: 1 | i__23@7@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))| && 0 <= i__23@7@02]
(assert (and
  (<
    i__23@7@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
  (<= 0 i__23@7@02)))
; [eval] diz.ALU_m.Main_process_state[i__23] == -1 || 0 <= diz.ALU_m.Main_process_state[i__23] && diz.ALU_m.Main_process_state[i__23] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__23] == -1
; [eval] diz.ALU_m.Main_process_state[i__23]
(push) ; 6
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             9
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           302
;  :mk-clause             9
;  :num-allocs            3626231
;  :num-checks            10
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114586)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i__23@7@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             9
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           302
;  :mk-clause             9
;  :num-allocs            3626231
;  :num-checks            11
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114595)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__23@7@02] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__23@7@02] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__23@7@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
    i__23@7@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__23@7@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
      i__23@7@02)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__23] && diz.ALU_m.Main_process_state[i__23] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__23]
; [eval] diz.ALU_m.Main_process_state[i__23]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             10
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           303
;  :mk-clause             9
;  :num-allocs            3626231
;  :num-checks            12
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114845)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i__23@7@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             10
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           303
;  :mk-clause             9
;  :num-allocs            3626231
;  :num-checks            13
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114854)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__23@7@02] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__23@7@02]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__23@7@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
    i__23@7@02)))
; [eval] diz.ALU_m.Main_process_state[i__23] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__23]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             11
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           306
;  :mk-clause             10
;  :num-allocs            3626231
;  :num-checks            14
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115047)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__23@7@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             11
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           306
;  :mk-clause             10
;  :num-allocs            3626231
;  :num-checks            15
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115056)
; [eval] |diz.ALU_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             12
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           306
;  :mk-clause             10
;  :num-allocs            3626231
;  :num-checks            16
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115104)
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__23@7@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
      i__23@7@02))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 1 | !(i__23@7@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))| && 0 <= i__23@7@02)]
(assert (not
  (and
    (<
      i__23@7@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
    (<= 0 i__23@7@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__23@7@02 Int)) (!
  (implies
    (and
      (<
        i__23@7@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
      (<= 0 i__23@7@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
          i__23@7@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
            i__23@7@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
            i__23@7@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
    i__23@7@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             80
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             13
;  :datatype-accessor-ax  13
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           308
;  :mk-clause             10
;  :num-allocs            3626231
;  :num-checks            17
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115819)
(declare-const $k@8@02 $Perm)
(assert ($Perm.isReadVar $k@8@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@8@02 $Perm.No) (< $Perm.No $k@8@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             80
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    7
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             14
;  :datatype-accessor-ax  13
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           312
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            18
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116017)
(assert (<= $Perm.No $k@8@02))
(assert (<= $k@8@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@8@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             86
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             15
;  :datatype-accessor-ax  14
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           315
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            19
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116370)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             86
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             16
;  :datatype-accessor-ax  14
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           315
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            20
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116418)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             92
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             17
;  :datatype-accessor-ax  15
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           318
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            21
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          116804)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             92
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             18
;  :datatype-accessor-ax  15
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           318
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            22
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          116852)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             97
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             19
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           319
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            23
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117139)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             97
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             20
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           319
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            24
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117187)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             102
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             21
;  :datatype-accessor-ax  17
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           320
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            25
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117484)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             102
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             22
;  :datatype-accessor-ax  17
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           320
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            26
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117532)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             107
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             23
;  :datatype-accessor-ax  18
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           321
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            27
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117839)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             107
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             24
;  :datatype-accessor-ax  18
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           321
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            28
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117887)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             112
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             25
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           322
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            29
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118204)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             112
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             26
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           322
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            30
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118252)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             117
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             27
;  :datatype-accessor-ax  20
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           323
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            31
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118579)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             117
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             28
;  :datatype-accessor-ax  20
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           323
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            32
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118627)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             123
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             29
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           325
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            33
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118996)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             123
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             30
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           325
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            34
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119044)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             130
;  :arith-assert-diseq    5
;  :arith-assert-lower    17
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             31
;  :datatype-accessor-ax  22
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           329
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            35
;  :propagations          20
;  :quant-instantiations  10
;  :rlimit-count          119522)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             130
;  :arith-assert-diseq    5
;  :arith-assert-lower    17
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             32
;  :datatype-accessor-ax  22
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           329
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            36
;  :propagations          20
;  :quant-instantiations  10
;  :rlimit-count          119570)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             135
;  :arith-assert-diseq    5
;  :arith-assert-lower    17
;  :arith-assert-upper    9
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             33
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           331
;  :mk-clause             12
;  :num-allocs            3626231
;  :num-checks            37
;  :propagations          20
;  :quant-instantiations  10
;  :rlimit-count          119973)
(declare-const $k@9@02 $Perm)
(assert ($Perm.isReadVar $k@9@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@9@02 $Perm.No) (< $Perm.No $k@9@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             135
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             34
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           335
;  :mk-clause             14
;  :num-allocs            3626231
;  :num-checks            38
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          120172)
(assert (<= $Perm.No $k@9@02))
(assert (<= $k@9@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@9@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_dr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             141
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             35
;  :datatype-accessor-ax  24
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           338
;  :mk-clause             14
;  :num-allocs            3626231
;  :num-checks            39
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          120625)
(push) ; 3
(assert (not (< $Perm.No $k@9@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             141
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             36
;  :datatype-accessor-ax  24
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           338
;  :mk-clause             14
;  :num-allocs            3626231
;  :num-checks            40
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          120673)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             147
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             37
;  :datatype-accessor-ax  25
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           341
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            41
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          121159)
(push) ; 3
(assert (not (< $Perm.No $k@9@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             147
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             38
;  :datatype-accessor-ax  25
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           341
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            42
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          121207)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             147
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             38
;  :datatype-accessor-ax  25
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           341
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            43
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          121220)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             152
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             39
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           342
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            44
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          121607)
(push) ; 3
(assert (not (< $Perm.No $k@9@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             152
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             40
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           342
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            45
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          121655)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             157
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             41
;  :datatype-accessor-ax  27
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           343
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            46
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          122052)
(push) ; 3
(assert (not (< $Perm.No $k@9@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             157
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             42
;  :datatype-accessor-ax  27
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           343
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            47
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          122100)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             162
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             43
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           344
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            48
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          122507)
(push) ; 3
(assert (not (< $Perm.No $k@9@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             162
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             44
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           344
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            49
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          122555)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             167
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             45
;  :datatype-accessor-ax  29
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           345
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            50
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          122972)
(push) ; 3
(assert (not (< $Perm.No $k@9@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             167
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             46
;  :datatype-accessor-ax  29
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           345
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            51
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          123020)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             172
;  :arith-assert-diseq    6
;  :arith-assert-lower    19
;  :arith-assert-upper    11
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             47
;  :datatype-accessor-ax  30
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           346
;  :mk-clause             14
;  :num-allocs            3750018
;  :num-checks            52
;  :propagations          21
;  :quant-instantiations  11
;  :rlimit-count          123447)
(declare-const $k@10@02 $Perm)
(assert ($Perm.isReadVar $k@10@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@10@02 $Perm.No) (< $Perm.No $k@10@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             172
;  :arith-assert-diseq    7
;  :arith-assert-lower    21
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             48
;  :datatype-accessor-ax  30
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           350
;  :mk-clause             16
;  :num-allocs            3750018
;  :num-checks            53
;  :propagations          22
;  :quant-instantiations  11
;  :rlimit-count          123645)
(assert (<= $Perm.No $k@10@02))
(assert (<= $k@10@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@10@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_mon != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             178
;  :arith-assert-diseq    7
;  :arith-assert-lower    21
;  :arith-assert-upper    13
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             49
;  :datatype-accessor-ax  31
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           353
;  :mk-clause             16
;  :num-allocs            3750018
;  :num-checks            54
;  :propagations          22
;  :quant-instantiations  11
;  :rlimit-count          124168)
(push) ; 3
(assert (not (< $Perm.No $k@10@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             178
;  :arith-assert-diseq    7
;  :arith-assert-lower    21
;  :arith-assert-upper    13
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             50
;  :datatype-accessor-ax  31
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           353
;  :mk-clause             16
;  :num-allocs            3750018
;  :num-checks            55
;  :propagations          22
;  :quant-instantiations  11
;  :rlimit-count          124216)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             184
;  :arith-assert-diseq    7
;  :arith-assert-lower    21
;  :arith-assert-upper    13
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             51
;  :datatype-accessor-ax  32
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           356
;  :mk-clause             16
;  :num-allocs            3750018
;  :num-checks            56
;  :propagations          22
;  :quant-instantiations  12
;  :rlimit-count          124780)
(push) ; 3
(assert (not (< $Perm.No $k@10@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             184
;  :arith-assert-diseq    7
;  :arith-assert-lower    21
;  :arith-assert-upper    13
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             52
;  :datatype-accessor-ax  32
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           356
;  :mk-clause             16
;  :num-allocs            3750018
;  :num-checks            57
;  :propagations          22
;  :quant-instantiations  12
;  :rlimit-count          124828)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             184
;  :arith-assert-diseq    7
;  :arith-assert-lower    21
;  :arith-assert-upper    13
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             52
;  :datatype-accessor-ax  32
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           356
;  :mk-clause             16
;  :num-allocs            3750018
;  :num-checks            58
;  :propagations          22
;  :quant-instantiations  12
;  :rlimit-count          124841)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             189
;  :arith-assert-diseq    7
;  :arith-assert-lower    21
;  :arith-assert-upper    13
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             53
;  :datatype-accessor-ax  33
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           357
;  :mk-clause             16
;  :num-allocs            3750018
;  :num-checks            59
;  :propagations          22
;  :quant-instantiations  12
;  :rlimit-count          125298)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             189
;  :arith-assert-diseq    7
;  :arith-assert-lower    21
;  :arith-assert-upper    13
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             54
;  :datatype-accessor-ax  33
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           357
;  :mk-clause             16
;  :num-allocs            3750018
;  :num-checks            60
;  :propagations          22
;  :quant-instantiations  12
;  :rlimit-count          125346)
(declare-const $k@11@02 $Perm)
(assert ($Perm.isReadVar $k@11@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@11@02 $Perm.No) (< $Perm.No $k@11@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             189
;  :arith-assert-diseq    8
;  :arith-assert-lower    23
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             55
;  :datatype-accessor-ax  33
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           361
;  :mk-clause             18
;  :num-allocs            3750018
;  :num-checks            61
;  :propagations          23
;  :quant-instantiations  12
;  :rlimit-count          125545)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@2@02
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               249
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               56
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   7
;  :datatype-splits         23
;  :decisions               23
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             386
;  :mk-clause               19
;  :num-allocs              3750018
;  :num-checks              62
;  :propagations            23
;  :quant-instantiations    12
;  :rlimit-count            126398
;  :time                    0.00)
(assert (<= $Perm.No $k@11@02))
(assert (<= $k@11@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@11@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_m == diz.ALU_m
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               255
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      15
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               57
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   7
;  :datatype-splits         23
;  :decisions               23
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             389
;  :mk-clause               19
;  :num-allocs              3750018
;  :num-checks              63
;  :propagations            23
;  :quant-instantiations    12
;  :rlimit-count            126951)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               255
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      15
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               58
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   7
;  :datatype-splits         23
;  :decisions               23
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             389
;  :mk-clause               19
;  :num-allocs              3750018
;  :num-checks              64
;  :propagations            23
;  :quant-instantiations    12
;  :rlimit-count            126999)
(push) ; 3
(assert (not (< $Perm.No $k@11@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               255
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      15
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               59
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   7
;  :datatype-splits         23
;  :decisions               23
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             389
;  :mk-clause               19
;  :num-allocs              3750018
;  :num-checks              65
;  :propagations            23
;  :quant-instantiations    12
;  :rlimit-count            127047)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               255
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      15
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               60
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   7
;  :datatype-splits         23
;  :decisions               23
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             389
;  :mk-clause               19
;  :num-allocs              3750018
;  :num-checks              66
;  :propagations            23
;  :quant-instantiations    12
;  :rlimit-count            127095)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               263
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      15
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               61
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   7
;  :datatype-splits         23
;  :decisions               23
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             392
;  :mk-clause               19
;  :num-allocs              3878341
;  :num-checks              67
;  :propagations            23
;  :quant-instantiations    13
;  :rlimit-count            127686)
(declare-const $k@12@02 $Perm)
(assert ($Perm.isReadVar $k@12@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@12@02 $Perm.No) (< $Perm.No $k@12@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               263
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               62
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   7
;  :datatype-splits         23
;  :decisions               23
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             396
;  :mk-clause               21
;  :num-allocs              3878341
;  :num-checks              68
;  :propagations            24
;  :quant-instantiations    13
;  :rlimit-count            127885)
(declare-const $t@13@02 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@8@02)
    (=
      $t@13@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))
  (implies
    (< $Perm.No $k@12@02)
    (=
      $t@13@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@8@02 $k@12@02)))
(assert (<= (+ $k@8@02 $k@12@02) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@8@02 $k@12@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               268
;  :arith-assert-diseq      9
;  :arith-assert-lower      26
;  :arith-assert-upper      17
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               63
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   7
;  :datatype-splits         23
;  :decisions               23
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             402
;  :mk-clause               21
;  :num-allocs              3878341
;  :num-checks              69
;  :propagations            24
;  :quant-instantiations    14
;  :rlimit-count            128604)
(push) ; 3
(assert (not (< $Perm.No (+ $k@8@02 $k@12@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               268
;  :arith-assert-diseq      9
;  :arith-assert-lower      26
;  :arith-assert-upper      18
;  :arith-conflicts         1
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     16
;  :conflicts               64
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   7
;  :datatype-splits         23
;  :decisions               23
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             403
;  :mk-clause               21
;  :num-allocs              3878341
;  :num-checks              70
;  :propagations            24
;  :quant-instantiations    14
;  :rlimit-count            128670)
(assert (= $t@13@02 diz@2@02))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; // assert
; assert false
(set-option :timeout 10)
(check-sat)
; unknown
; [state consolidation]
; State saturation: before repetition
(check-sat)
; unknown
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
  diz@2@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               430
;  :arith-assert-diseq      9
;  :arith-assert-lower      26
;  :arith-assert-upper      18
;  :arith-conflicts         1
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     16
;  :conflicts               66
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 88
;  :datatype-occurs-check   21
;  :datatype-splits         48
;  :decisions               84
;  :del-clause              20
;  :final-checks            11
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             433
;  :mk-clause               22
;  :num-allocs              3878341
;  :num-checks              74
;  :propagations            26
;  :quant-instantiations    14
;  :rlimit-count            130766)
(declare-const $t@14@02 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@11@02)
    (=
      $t@14@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))))
  (implies
    (< $Perm.No $k@6@02)
    (= $t@14@02 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02)))))))
(assert (<= $Perm.No (+ $k@11@02 $k@6@02)))
(assert (<= (+ $k@11@02 $k@6@02) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@11@02 $k@6@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
      $Ref.null))))
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Main_Main_EncodedGlobalVariables ----------
(declare-const globals@15@02 $Ref)
(declare-const sys__result@16@02 $Ref)
(declare-const globals@17@02 $Ref)
(declare-const sys__result@18@02 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@19@02 $Snap)
(assert (= $t@19@02 ($Snap.combine ($Snap.first $t@19@02) ($Snap.second $t@19@02))))
(assert (= ($Snap.first $t@19@02) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@18@02 $Ref.null)))
(assert (=
  ($Snap.second $t@19@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@19@02))
    ($Snap.second ($Snap.second $t@19@02)))))
(assert (= ($Snap.first ($Snap.second $t@19@02)) $Snap.unit))
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
(assert (= (type_of<TYPE> sys__result@18@02) (as class_Main<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@19@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@19@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))
(declare-const $k@20@02 $Perm)
(assert ($Perm.isReadVar $k@20@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@20@02 $Perm.No) (< $Perm.No $k@20@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               501
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      20
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               67
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             450
;  :mk-clause               24
;  :num-allocs              3878341
;  :num-checks              77
;  :propagations            28
;  :quant-instantiations    14
;  :rlimit-count            132541)
(assert (<= $Perm.No $k@20@02))
(assert (<= $k@20@02 $Perm.Write))
(assert (implies (< $Perm.No $k@20@02) (not (= sys__result@18@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@19@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@02))))
  $Snap.unit))
; [eval] sys__result.Main_dr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               507
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               68
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             453
;  :mk-clause               24
;  :num-allocs              3878341
;  :num-checks              78
;  :propagations            28
;  :quant-instantiations    14
;  :rlimit-count            132804)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@19@02))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))
(push) ; 3
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               513
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               69
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             456
;  :mk-clause               24
;  :num-allocs              3878341
;  :num-checks              79
;  :propagations            28
;  :quant-instantiations    15
;  :rlimit-count            133100)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               513
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               69
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             456
;  :mk-clause               24
;  :num-allocs              3878341
;  :num-checks              80
;  :propagations            28
;  :quant-instantiations    15
;  :rlimit-count            133113)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))
  $Snap.unit))
; [eval] sys__result.Main_dr.Driver_m == sys__result
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               519
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               70
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             458
;  :mk-clause               24
;  :num-allocs              3878341
;  :num-checks              81
;  :propagations            28
;  :quant-instantiations    15
;  :rlimit-count            133342)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))
  sys__result@18@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               526
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               71
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             461
;  :mk-clause               24
;  :num-allocs              3878341
;  :num-checks              82
;  :propagations            28
;  :quant-instantiations    16
;  :rlimit-count            133638)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               526
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               71
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             461
;  :mk-clause               24
;  :num-allocs              3878341
;  :num-checks              83
;  :propagations            28
;  :quant-instantiations    16
;  :rlimit-count            133651)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))
  $Snap.unit))
; [eval] !sys__result.Main_dr.Driver_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               532
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               72
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             463
;  :mk-clause               24
;  :num-allocs              3878341
;  :num-checks              84
;  :propagations            28
;  :quant-instantiations    16
;  :rlimit-count            133900)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))
(declare-const $k@21@02 $Perm)
(assert ($Perm.isReadVar $k@21@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@21@02 $Perm.No) (< $Perm.No $k@21@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               541
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      22
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               73
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             471
;  :mk-clause               26
;  :num-allocs              3878341
;  :num-checks              85
;  :propagations            29
;  :quant-instantiations    18
;  :rlimit-count            134379)
(assert (<= $Perm.No $k@21@02))
(assert (<= $k@21@02 $Perm.Write))
(assert (implies (< $Perm.No $k@21@02) (not (= sys__result@18@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))
  $Snap.unit))
; [eval] sys__result.Main_mon != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               547
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               74
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             474
;  :mk-clause               26
;  :num-allocs              3878341
;  :num-checks              86
;  :propagations            29
;  :quant-instantiations    18
;  :rlimit-count            134702)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               553
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               75
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             477
;  :mk-clause               26
;  :num-allocs              3878341
;  :num-checks              87
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135056)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               553
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               75
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             477
;  :mk-clause               26
;  :num-allocs              3878341
;  :num-checks              88
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135069)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))
  $Snap.unit))
; [eval] sys__result.Main_mon.Monitor_m == sys__result
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               559
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             479
;  :mk-clause               26
;  :num-allocs              3878341
;  :num-checks              89
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135358)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))
  sys__result@18@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               567
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             482
;  :mk-clause               26
;  :num-allocs              3878341
;  :num-checks              90
;  :propagations            29
;  :quant-instantiations    20
;  :rlimit-count            135713)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               567
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             482
;  :mk-clause               26
;  :num-allocs              3878341
;  :num-checks              91
;  :propagations            29
;  :quant-instantiations    20
;  :rlimit-count            135726)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))))
  $Snap.unit))
; [eval] !sys__result.Main_mon.Monitor_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               78
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             484
;  :mk-clause               26
;  :num-allocs              3878341
;  :num-checks              92
;  :propagations            29
;  :quant-instantiations    20
;  :rlimit-count            136035)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@02))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               581
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             487
;  :mk-clause               26
;  :num-allocs              3878341
;  :num-checks              93
;  :propagations            29
;  :quant-instantiations    21
;  :rlimit-count            136411)
(push) ; 3
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               581
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               80
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   25
;  :datatype-splits         50
;  :decisions               104
;  :del-clause              21
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             487
;  :mk-clause               26
;  :num-allocs              3878341
;  :num-checks              94
;  :propagations            29
;  :quant-instantiations    21
;  :rlimit-count            136459)
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_56__87: Ref
(declare-const __flatten_56__87@22@02 $Ref)
; [exec]
; var __flatten_54__86: Ref
(declare-const __flatten_54__86@23@02 $Ref)
; [exec]
; var __flatten_52__85: Ref
(declare-const __flatten_52__85@24@02 $Ref)
; [exec]
; var __flatten_51__84: Seq[Int]
(declare-const __flatten_51__84@25@02 Seq<Int>)
; [exec]
; var __flatten_50__83: Seq[Int]
(declare-const __flatten_50__83@26@02 Seq<Int>)
; [exec]
; var __flatten_49__82: Seq[Int]
(declare-const __flatten_49__82@27@02 Seq<Int>)
; [exec]
; var __flatten_48__81: Seq[Int]
(declare-const __flatten_48__81@28@02 Seq<Int>)
; [exec]
; var diz__80: Ref
(declare-const diz__80@29@02 $Ref)
; [exec]
; diz__80 := new(Main_process_state, Main_event_state, Main_alu, Main_dr, Main_mon)
(declare-const diz__80@30@02 $Ref)
(assert (not (= diz__80@30@02 $Ref.null)))
(declare-const Main_process_state@31@02 Seq<Int>)
(declare-const Main_event_state@32@02 Seq<Int>)
(declare-const Main_alu@33@02 $Ref)
(declare-const Main_dr@34@02 $Ref)
(declare-const Main_mon@35@02 $Ref)
(assert (not (= diz__80@30@02 __flatten_56__87@22@02)))
(assert (not (= diz__80@30@02 __flatten_54__86@23@02)))
(assert (not (= diz__80@30@02 diz__80@29@02)))
(assert (not (= diz__80@30@02 sys__result@18@02)))
(assert (not (= diz__80@30@02 __flatten_52__85@24@02)))
(assert (not (= diz__80@30@02 globals@17@02)))
; [exec]
; inhale type_of(diz__80) == class_Main()
(declare-const $t@36@02 $Snap)
(assert (= $t@36@02 $Snap.unit))
; [eval] type_of(diz__80) == class_Main()
; [eval] type_of(diz__80)
; [eval] class_Main()
(assert (= (type_of<TYPE> diz__80@30@02) (as class_Main<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; __flatten_49__82 := Seq(-1)
; [eval] Seq(-1)
; [eval] -1
(assert (= (Seq_length (Seq_singleton (- 0 1))) 1))
(declare-const __flatten_49__82@37@02 Seq<Int>)
(assert (Seq_equal __flatten_49__82@37@02 (Seq_singleton (- 0 1))))
; [exec]
; __flatten_48__81 := __flatten_49__82
; [exec]
; diz__80.Main_process_state := __flatten_48__81
; [exec]
; __flatten_51__84 := Seq(-3, -3)
; [eval] Seq(-3, -3)
; [eval] -3
; [eval] -3
(assert (= (Seq_length (Seq_append (Seq_singleton (- 0 3)) (Seq_singleton (- 0 3)))) 2))
(declare-const __flatten_51__84@38@02 Seq<Int>)
(assert (Seq_equal
  __flatten_51__84@38@02
  (Seq_append (Seq_singleton (- 0 3)) (Seq_singleton (- 0 3)))))
; [exec]
; __flatten_50__83 := __flatten_51__84
; [exec]
; diz__80.Main_event_state := __flatten_50__83
; [exec]
; __flatten_52__85 := ALU_ALU_EncodedGlobalVariables_Main(globals, diz__80)
(declare-const sys__result@39@02 $Ref)
(declare-const $t@40@02 $Snap)
(assert (= $t@40@02 ($Snap.combine ($Snap.first $t@40@02) ($Snap.second $t@40@02))))
(assert (= ($Snap.first $t@40@02) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@39@02 $Ref.null)))
(assert (=
  ($Snap.second $t@40@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@40@02))
    ($Snap.second ($Snap.second $t@40@02)))))
(assert (= ($Snap.first ($Snap.second $t@40@02)) $Snap.unit))
; [eval] type_of(sys__result) == class_ALU()
; [eval] type_of(sys__result)
; [eval] class_ALU()
(assert (= (type_of<TYPE> sys__result@39@02) (as class_ALU<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@40@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@40@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@40@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))
  $Snap.unit))
; [eval] sys__result.ALU_OP1 == 0
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))
  0))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))
  $Snap.unit))
; [eval] sys__result.ALU_OP2 == 0
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))
  0))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))
  $Snap.unit))
; [eval] !sys__result.ALU_CARRY
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))
  $Snap.unit))
; [eval] !sys__result.ALU_ZERO
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))))
  $Snap.unit))
; [eval] sys__result.ALU_RESULT == 0
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))))
  0))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))))
  $Snap.unit))
; [eval] sys__result.ALU_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@40@02))))
  diz__80@30@02))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; diz__80.Main_alu := __flatten_52__85
; [exec]
; __flatten_54__86 := Driver_Driver_EncodedGlobalVariables_Main(globals, diz__80)
(declare-const sys__result@41@02 $Ref)
(declare-const $t@42@02 $Snap)
(assert (= $t@42@02 ($Snap.combine ($Snap.first $t@42@02) ($Snap.second $t@42@02))))
(assert (= ($Snap.first $t@42@02) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@41@02 $Ref.null)))
(assert (=
  ($Snap.second $t@42@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@42@02))
    ($Snap.second ($Snap.second $t@42@02)))))
(assert (= ($Snap.first ($Snap.second $t@42@02)) $Snap.unit))
; [eval] type_of(sys__result) == class_Driver()
; [eval] type_of(sys__result)
; [eval] class_Driver()
(assert (= (type_of<TYPE> sys__result@41@02) (as class_Driver<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@42@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@42@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@42@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))
  $Snap.unit))
; [eval] !sys__result.Driver_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))))
  $Snap.unit))
; [eval] sys__result.Driver_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
  diz__80@30@02))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__80.Main_dr := __flatten_54__86
; [exec]
; __flatten_56__87 := Monitor_Monitor_EncodedGlobalVariables_Main(globals, diz__80)
(declare-const sys__result@43@02 $Ref)
(declare-const $t@44@02 $Snap)
(assert (= $t@44@02 ($Snap.combine ($Snap.first $t@44@02) ($Snap.second $t@44@02))))
(assert (= ($Snap.first $t@44@02) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@43@02 $Ref.null)))
(assert (=
  ($Snap.second $t@44@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@44@02))
    ($Snap.second ($Snap.second $t@44@02)))))
(assert (= ($Snap.first ($Snap.second $t@44@02)) $Snap.unit))
; [eval] type_of(sys__result) == class_Monitor()
; [eval] type_of(sys__result)
; [eval] class_Monitor()
(assert (= (type_of<TYPE> sys__result@43@02) (as class_Monitor<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@44@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@44@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@44@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@44@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@44@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02))))))
  $Snap.unit))
; [eval] !sys__result.Monitor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02))))))
  $Snap.unit))
; [eval] sys__result.Monitor_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@44@02)))))
  diz__80@30@02))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__80.Main_mon := __flatten_56__87
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz__80, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(set-option :timeout 0)
(push) ; 3
(assert (not (= (Seq_length __flatten_49__82@37@02) 1)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               877
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      51
;  :arith-assert-upper      33
;  :arith-conflicts         1
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               81
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              96
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             659
;  :mk-clause               102
;  :num-allocs              4017825
;  :num-checks              99
;  :propagations            58
;  :quant-instantiations    50
;  :rlimit-count            143913)
(assert (= (Seq_length __flatten_49__82@37@02) 1))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(push) ; 3
(assert (not (= (Seq_length __flatten_51__84@38@02) 2)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               878
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      52
;  :arith-assert-upper      34
;  :arith-conflicts         1
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               82
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              96
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             665
;  :mk-clause               102
;  :num-allocs              4017825
;  :num-checks              100
;  :propagations            58
;  :quant-instantiations    50
;  :rlimit-count            144038)
(assert (= (Seq_length __flatten_51__84@38@02) 2))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@45@02 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@45@02 | live]
; [else-branch: 4 | !(0 <= i@45@02) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@45@02]
(assert (<= 0 i@45@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@45@02)]
(assert (not (<= 0 i@45@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@45@02 < |__flatten_49__82@37@02| && 0 <= i@45@02 | live]
; [else-branch: 5 | !(i@45@02 < |__flatten_49__82@37@02| && 0 <= i@45@02) | live]
(push) ; 5
; [then-branch: 5 | i@45@02 < |__flatten_49__82@37@02| && 0 <= i@45@02]
(assert (and (< i@45@02 (Seq_length __flatten_49__82@37@02)) (<= 0 i@45@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 6
(assert (not (>= i@45@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               880
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      54
;  :arith-assert-upper      36
;  :arith-conflicts         1
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               82
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              96
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             670
;  :mk-clause               102
;  :num-allocs              4017825
;  :num-checks              101
;  :propagations            58
;  :quant-instantiations    50
;  :rlimit-count            144229)
; [eval] -1
(push) ; 6
; [then-branch: 6 | __flatten_49__82@37@02[i@45@02] == -1 | live]
; [else-branch: 6 | __flatten_49__82@37@02[i@45@02] != -1 | live]
(push) ; 7
; [then-branch: 6 | __flatten_49__82@37@02[i@45@02] == -1]
(assert (= (Seq_index __flatten_49__82@37@02 i@45@02) (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | __flatten_49__82@37@02[i@45@02] != -1]
(assert (not (= (Seq_index __flatten_49__82@37@02 i@45@02) (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@45@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               882
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      54
;  :arith-assert-upper      36
;  :arith-conflicts         1
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               83
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              96
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             672
;  :mk-clause               102
;  :num-allocs              4017825
;  :num-checks              102
;  :propagations            58
;  :quant-instantiations    51
;  :rlimit-count            144356)
(push) ; 8
; [then-branch: 7 | 0 <= __flatten_49__82@37@02[i@45@02] | live]
; [else-branch: 7 | !(0 <= __flatten_49__82@37@02[i@45@02]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= __flatten_49__82@37@02[i@45@02]]
(assert (<= 0 (Seq_index __flatten_49__82@37@02 i@45@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@45@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               882
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      54
;  :arith-assert-upper      36
;  :arith-conflicts         1
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               83
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              96
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             673
;  :mk-clause               102
;  :num-allocs              4017825
;  :num-checks              103
;  :propagations            58
;  :quant-instantiations    51
;  :rlimit-count            144411)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= __flatten_49__82@37@02[i@45@02])]
(assert (not (<= 0 (Seq_index __flatten_49__82@37@02 i@45@02))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 5 | !(i@45@02 < |__flatten_49__82@37@02| && 0 <= i@45@02)]
(assert (not (and (< i@45@02 (Seq_length __flatten_49__82@37@02)) (<= 0 i@45@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 3
(assert (not (forall ((i@45@02 Int)) (!
  (implies
    (and (< i@45@02 (Seq_length __flatten_49__82@37@02)) (<= 0 i@45@02))
    (or
      (= (Seq_index __flatten_49__82@37@02 i@45@02) (- 0 1))
      (and
        (<
          (Seq_index __flatten_49__82@37@02 i@45@02)
          (Seq_length __flatten_51__84@38@02))
        (<= 0 (Seq_index __flatten_49__82@37@02 i@45@02)))))
  :pattern ((Seq_index __flatten_49__82@37@02 i@45@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               885
;  :arith-add-rows          2
;  :arith-assert-diseq      18
;  :arith-assert-lower      55
;  :arith-assert-upper      37
;  :arith-conflicts         1
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               84
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              107
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             681
;  :mk-clause               113
;  :num-allocs              4017825
;  :num-checks              104
;  :propagations            58
;  :quant-instantiations    52
;  :rlimit-count            144769)
(assert (forall ((i@45@02 Int)) (!
  (implies
    (and (< i@45@02 (Seq_length __flatten_49__82@37@02)) (<= 0 i@45@02))
    (or
      (= (Seq_index __flatten_49__82@37@02 i@45@02) (- 0 1))
      (and
        (<
          (Seq_index __flatten_49__82@37@02 i@45@02)
          (Seq_length __flatten_51__84@38@02))
        (<= 0 (Seq_index __flatten_49__82@37@02 i@45@02)))))
  :pattern ((Seq_index __flatten_49__82@37@02 i@45@02))
  :qid |prog.l<no position>|)))
(declare-const $k@46@02 $Perm)
(assert ($Perm.isReadVar $k@46@02 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@46@02 $Perm.No) (< $Perm.No $k@46@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               885
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      38
;  :arith-conflicts         1
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              107
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             686
;  :mk-clause               115
;  :num-allocs              4017825
;  :num-checks              105
;  :propagations            59
;  :quant-instantiations    52
;  :rlimit-count            145239)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               885
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      38
;  :arith-conflicts         1
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              107
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             686
;  :mk-clause               115
;  :num-allocs              4017825
;  :num-checks              106
;  :propagations            59
;  :quant-instantiations    52
;  :rlimit-count            145252)
(assert (< $k@46@02 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@46@02)))
(assert (<= (- $Perm.Write $k@46@02) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@46@02)) (not (= diz__80@30@02 $Ref.null))))
; [eval] diz.Main_alu != null
; [eval] 0 <= diz.Main_alu.ALU_RESULT
(set-option :timeout 0)
(push) ; 3
(assert (not (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               885
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      39
;  :arith-conflicts         1
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              107
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             687
;  :mk-clause               115
;  :num-allocs              4017825
;  :num-checks              107
;  :propagations            59
;  :quant-instantiations    52
;  :rlimit-count            145347)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))))))
; [eval] diz.Main_alu.ALU_RESULT <= 16
(push) ; 3
(assert (not (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))))
  16)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               885
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      39
;  :arith-conflicts         1
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              107
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             687
;  :mk-clause               115
;  :num-allocs              4017825
;  :num-checks              108
;  :propagations            59
;  :quant-instantiations    52
;  :rlimit-count            145361)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02))))))))))))))
  16))
(declare-const $k@47@02 $Perm)
(assert ($Perm.isReadVar $k@47@02 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@47@02 $Perm.No) (< $Perm.No $k@47@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               885
;  :arith-add-rows          2
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      40
;  :arith-conflicts         1
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               86
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              107
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             691
;  :mk-clause               117
;  :num-allocs              4017825
;  :num-checks              109
;  :propagations            60
;  :quant-instantiations    52
;  :rlimit-count            145563)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               885
;  :arith-add-rows          2
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      40
;  :arith-conflicts         1
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               86
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              107
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             691
;  :mk-clause               117
;  :num-allocs              4017825
;  :num-checks              110
;  :propagations            60
;  :quant-instantiations    52
;  :rlimit-count            145576)
(assert (< $k@47@02 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@47@02)))
(assert (<= (- $Perm.Write $k@47@02) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@47@02)) (not (= diz__80@30@02 $Ref.null))))
; [eval] diz.Main_dr != null
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               885
;  :arith-add-rows          2
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      41
;  :arith-conflicts         1
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               86
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   41
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              107
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             692
;  :mk-clause               117
;  :num-allocs              4017825
;  :num-checks              111
;  :propagations            60
;  :quant-instantiations    52
;  :rlimit-count            145673)
(set-option :timeout 10)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               924
;  :arith-add-rows          2
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      43
;  :arith-conflicts         1
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               86
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 142
;  :datatype-occurs-check   47
;  :datatype-splits         83
;  :decisions               141
;  :del-clause              117
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             708
;  :mk-clause               127
;  :num-allocs              4017825
;  :num-checks              112
;  :propagations            65
;  :quant-instantiations    55
;  :rlimit-count            146246
;  :time                    0.00)
(declare-const $k@48@02 $Perm)
(assert ($Perm.isReadVar $k@48@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@48@02 $Perm.No) (< $Perm.No $k@48@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               924
;  :arith-add-rows          2
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      44
;  :arith-conflicts         1
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 142
;  :datatype-occurs-check   47
;  :datatype-splits         83
;  :decisions               141
;  :del-clause              117
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             712
;  :mk-clause               129
;  :num-allocs              4017825
;  :num-checks              113
;  :propagations            66
;  :quant-instantiations    55
;  :rlimit-count            146444)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               924
;  :arith-add-rows          2
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      44
;  :arith-conflicts         1
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 142
;  :datatype-occurs-check   47
;  :datatype-splits         83
;  :decisions               141
;  :del-clause              117
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             712
;  :mk-clause               129
;  :num-allocs              4017825
;  :num-checks              114
;  :propagations            66
;  :quant-instantiations    55
;  :rlimit-count            146457)
(assert (< $k@48@02 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@48@02)))
(assert (<= (- $Perm.Write $k@48@02) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@48@02)) (not (= diz__80@30@02 $Ref.null))))
; [eval] diz.Main_mon != null
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               924
;  :arith-add-rows          2
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      45
;  :arith-conflicts         1
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 142
;  :datatype-occurs-check   47
;  :datatype-splits         83
;  :decisions               141
;  :del-clause              117
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             713
;  :mk-clause               129
;  :num-allocs              4017825
;  :num-checks              115
;  :propagations            66
;  :quant-instantiations    55
;  :rlimit-count            146554)
(set-option :timeout 10)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               963
;  :arith-add-rows          2
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      47
;  :arith-conflicts         1
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 152
;  :datatype-occurs-check   53
;  :datatype-splits         93
;  :decisions               152
;  :del-clause              127
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             729
;  :mk-clause               139
;  :num-allocs              4017825
;  :num-checks              116
;  :propagations            71
;  :quant-instantiations    58
;  :rlimit-count            147131)
(declare-const $k@49@02 $Perm)
(assert ($Perm.isReadVar $k@49@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@49@02 $Perm.No) (< $Perm.No $k@49@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               963
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      71
;  :arith-assert-upper      48
;  :arith-conflicts         1
;  :arith-eq-adapter        40
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 152
;  :datatype-occurs-check   53
;  :datatype-splits         93
;  :decisions               152
;  :del-clause              127
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             733
;  :mk-clause               141
;  :num-allocs              4017825
;  :num-checks              117
;  :propagations            72
;  :quant-instantiations    58
;  :rlimit-count            147329)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               963
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      71
;  :arith-assert-upper      48
;  :arith-conflicts         1
;  :arith-eq-adapter        40
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 152
;  :datatype-occurs-check   53
;  :datatype-splits         93
;  :decisions               152
;  :del-clause              127
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             733
;  :mk-clause               141
;  :num-allocs              4017825
;  :num-checks              118
;  :propagations            72
;  :quant-instantiations    58
;  :rlimit-count            147342)
(assert (< $k@49@02 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@49@02)))
(assert (<= (- $Perm.Write $k@49@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- $Perm.Write $k@49@02))
  (not (= sys__result@39@02 $Ref.null))))
; [eval] diz.Main_alu.ALU_m == diz
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($SortWrappers.Seq<Int>To$Snap __flatten_49__82@37@02)
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($SortWrappers.Seq<Int>To$Snap __flatten_51__84@38@02)
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($SortWrappers.$RefTo$Snap sys__result@39@02)
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@02))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@02)))))))))))))
                                ($Snap.combine
                                  $Snap.unit
                                  ($Snap.combine
                                    $Snap.unit
                                    ($Snap.combine
                                      ($SortWrappers.$RefTo$Snap sys__result@41@02)
                                      ($Snap.combine
                                        $Snap.unit
                                        ($Snap.combine
                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
                                          ($Snap.combine
                                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))
                                            ($Snap.combine
                                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))
                                              ($Snap.combine
                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
                                                ($Snap.combine
                                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))))
                                                  ($Snap.combine
                                                    ($SortWrappers.$RefTo$Snap sys__result@43@02)
                                                    ($Snap.combine
                                                      $Snap.unit
                                                      ($Snap.combine
                                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02)))))
                                                        ($Snap.combine
                                                          ($Snap.first ($Snap.second ($Snap.second $t@40@02)))
                                                          $Snap.unit))))))))))))))))))))))))))))) diz__80@30@02 globals@17@02))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz__80, globals), write)
; [exec]
; sys__result := diz__80
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Main() && acc(sys__result.Main_dr, wildcard) && sys__result.Main_dr != null && acc(sys__result.Main_dr.Driver_m, 1 / 2) && sys__result.Main_dr.Driver_m == sys__result && acc(sys__result.Main_dr.Driver_init, 1 / 2) && !sys__result.Main_dr.Driver_init && acc(sys__result.Main_mon, wildcard) && sys__result.Main_mon != null && acc(sys__result.Main_mon.Monitor_m, 1 / 2) && sys__result.Main_mon.Monitor_m == sys__result && acc(sys__result.Main_mon.Monitor_init, 1 / 2) && !sys__result.Main_mon.Monitor_init && acc(Driver_idleToken_EncodedGlobalVariables(sys__result.Main_dr, globals), write) && acc(Monitor_idleToken_EncodedGlobalVariables(sys__result.Main_mon, globals), write)
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
(declare-const $k@50@02 $Perm)
(assert ($Perm.isReadVar $k@50@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@50@02 $Perm.No) (< $Perm.No $k@50@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1028
;  :arith-add-rows          2
;  :arith-assert-diseq      25
;  :arith-assert-lower      73
;  :arith-assert-upper      50
;  :arith-conflicts         1
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               89
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 152
;  :datatype-occurs-check   53
;  :datatype-splits         93
;  :decisions               152
;  :del-clause              127
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             744
;  :mk-clause               143
;  :num-allocs              4017825
;  :num-checks              119
;  :propagations            73
;  :quant-instantiations    63
;  :rlimit-count            148892)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- $Perm.Write $k@47@02) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1028
;  :arith-add-rows          2
;  :arith-assert-diseq      25
;  :arith-assert-lower      73
;  :arith-assert-upper      50
;  :arith-conflicts         1
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 152
;  :datatype-occurs-check   53
;  :datatype-splits         93
;  :decisions               152
;  :del-clause              127
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             745
;  :mk-clause               143
;  :num-allocs              4017825
;  :num-checks              120
;  :propagations            73
;  :quant-instantiations    63
;  :rlimit-count            148944)
(assert (< $k@50@02 (- $Perm.Write $k@47@02)))
(assert (<= $Perm.No (- (- $Perm.Write $k@47@02) $k@50@02)))
(assert (<= (- (- $Perm.Write $k@47@02) $k@50@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- $Perm.Write $k@47@02) $k@50@02))
  (not (= diz__80@30@02 $Ref.null))))
; [eval] sys__result.Main_dr != null
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@47@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1028
;  :arith-add-rows          2
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      52
;  :arith-conflicts         1
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 152
;  :datatype-occurs-check   53
;  :datatype-splits         93
;  :decisions               152
;  :del-clause              127
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             748
;  :mk-clause               143
;  :num-allocs              4017825
;  :num-checks              121
;  :propagations            73
;  :quant-instantiations    63
;  :rlimit-count            149130)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1028
;  :arith-add-rows          2
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      52
;  :arith-conflicts         1
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 152
;  :datatype-occurs-check   53
;  :datatype-splits         93
;  :decisions               152
;  :del-clause              127
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             748
;  :mk-clause               143
;  :num-allocs              4017825
;  :num-checks              122
;  :propagations            73
;  :quant-instantiations    63
;  :rlimit-count            149143)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@47@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1028
;  :arith-add-rows          2
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      52
;  :arith-conflicts         1
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 152
;  :datatype-occurs-check   53
;  :datatype-splits         93
;  :decisions               152
;  :del-clause              127
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             748
;  :mk-clause               143
;  :num-allocs              4017825
;  :num-checks              123
;  :propagations            73
;  :quant-instantiations    63
;  :rlimit-count            149169)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1266
;  :arith-add-rows          2
;  :arith-assert-diseq      26
;  :arith-assert-lower      78
;  :arith-assert-upper      54
;  :arith-conflicts         1
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 209
;  :datatype-occurs-check   210
;  :datatype-splits         122
;  :decisions               200
;  :del-clause              144
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             815
;  :mk-clause               160
;  :num-allocs              4163055
;  :num-checks              124
;  :propagations            81
;  :quant-instantiations    66
;  :rlimit-count            150449
;  :time                    0.00)
; [eval] sys__result.Main_dr.Driver_m == sys__result
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@47@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1266
;  :arith-add-rows          2
;  :arith-assert-diseq      26
;  :arith-assert-lower      78
;  :arith-assert-upper      54
;  :arith-conflicts         1
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 209
;  :datatype-occurs-check   210
;  :datatype-splits         122
;  :decisions               200
;  :del-clause              144
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             815
;  :mk-clause               160
;  :num-allocs              4163055
;  :num-checks              125
;  :propagations            81
;  :quant-instantiations    66
;  :rlimit-count            150475)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1266
;  :arith-add-rows          2
;  :arith-assert-diseq      26
;  :arith-assert-lower      78
;  :arith-assert-upper      54
;  :arith-conflicts         1
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 209
;  :datatype-occurs-check   210
;  :datatype-splits         122
;  :decisions               200
;  :del-clause              144
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             815
;  :mk-clause               160
;  :num-allocs              4163055
;  :num-checks              126
;  :propagations            81
;  :quant-instantiations    66
;  :rlimit-count            150488)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@47@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1266
;  :arith-add-rows          2
;  :arith-assert-diseq      26
;  :arith-assert-lower      78
;  :arith-assert-upper      54
;  :arith-conflicts         1
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 209
;  :datatype-occurs-check   210
;  :datatype-splits         122
;  :decisions               200
;  :del-clause              144
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             815
;  :mk-clause               160
;  :num-allocs              4163055
;  :num-checks              127
;  :propagations            81
;  :quant-instantiations    66
;  :rlimit-count            150514)
; [eval] !sys__result.Main_dr.Driver_init
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@47@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1266
;  :arith-add-rows          2
;  :arith-assert-diseq      26
;  :arith-assert-lower      78
;  :arith-assert-upper      54
;  :arith-conflicts         1
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 209
;  :datatype-occurs-check   210
;  :datatype-splits         122
;  :decisions               200
;  :del-clause              144
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             815
;  :mk-clause               160
;  :num-allocs              4163055
;  :num-checks              128
;  :propagations            81
;  :quant-instantiations    66
;  :rlimit-count            150540)
(declare-const $k@51@02 $Perm)
(assert ($Perm.isReadVar $k@51@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@51@02 $Perm.No) (< $Perm.No $k@51@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1266
;  :arith-add-rows          2
;  :arith-assert-diseq      27
;  :arith-assert-lower      80
;  :arith-assert-upper      55
;  :arith-conflicts         1
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               98
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 209
;  :datatype-occurs-check   210
;  :datatype-splits         122
;  :decisions               200
;  :del-clause              144
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             819
;  :mk-clause               162
;  :num-allocs              4163055
;  :num-checks              129
;  :propagations            82
;  :quant-instantiations    66
;  :rlimit-count            150739)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- $Perm.Write $k@48@02) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1266
;  :arith-add-rows          2
;  :arith-assert-diseq      27
;  :arith-assert-lower      80
;  :arith-assert-upper      55
;  :arith-conflicts         1
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               99
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 209
;  :datatype-occurs-check   210
;  :datatype-splits         122
;  :decisions               200
;  :del-clause              144
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             820
;  :mk-clause               162
;  :num-allocs              4163055
;  :num-checks              130
;  :propagations            82
;  :quant-instantiations    66
;  :rlimit-count            150791)
(assert (< $k@51@02 (- $Perm.Write $k@48@02)))
(assert (<= $Perm.No (- (- $Perm.Write $k@48@02) $k@51@02)))
(assert (<= (- (- $Perm.Write $k@48@02) $k@51@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- $Perm.Write $k@48@02) $k@51@02))
  (not (= diz__80@30@02 $Ref.null))))
; [eval] sys__result.Main_mon != null
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@48@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1266
;  :arith-add-rows          2
;  :arith-assert-diseq      27
;  :arith-assert-lower      81
;  :arith-assert-upper      57
;  :arith-conflicts         1
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               99
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 209
;  :datatype-occurs-check   210
;  :datatype-splits         122
;  :decisions               200
;  :del-clause              144
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             823
;  :mk-clause               162
;  :num-allocs              4163055
;  :num-checks              131
;  :propagations            82
;  :quant-instantiations    66
;  :rlimit-count            150977)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1266
;  :arith-add-rows          2
;  :arith-assert-diseq      27
;  :arith-assert-lower      81
;  :arith-assert-upper      57
;  :arith-conflicts         1
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               99
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 209
;  :datatype-occurs-check   210
;  :datatype-splits         122
;  :decisions               200
;  :del-clause              144
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             823
;  :mk-clause               162
;  :num-allocs              4163055
;  :num-checks              132
;  :propagations            82
;  :quant-instantiations    66
;  :rlimit-count            150990)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@48@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1266
;  :arith-add-rows          2
;  :arith-assert-diseq      27
;  :arith-assert-lower      81
;  :arith-assert-upper      57
;  :arith-conflicts         1
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               99
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 209
;  :datatype-occurs-check   210
;  :datatype-splits         122
;  :decisions               200
;  :del-clause              144
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             823
;  :mk-clause               162
;  :num-allocs              4163055
;  :num-checks              133
;  :propagations            82
;  :quant-instantiations    66
;  :rlimit-count            151016)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1504
;  :arith-add-rows          2
;  :arith-assert-diseq      28
;  :arith-assert-lower      85
;  :arith-assert-upper      59
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        3
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   367
;  :datatype-splits         151
;  :decisions               248
;  :del-clause              161
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             890
;  :mk-clause               179
;  :num-allocs              4163055
;  :num-checks              134
;  :propagations            90
;  :quant-instantiations    69
;  :rlimit-count            152302
;  :time                    0.00)
; [eval] sys__result.Main_mon.Monitor_m == sys__result
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@48@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1504
;  :arith-add-rows          2
;  :arith-assert-diseq      28
;  :arith-assert-lower      85
;  :arith-assert-upper      59
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        3
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   367
;  :datatype-splits         151
;  :decisions               248
;  :del-clause              161
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             890
;  :mk-clause               179
;  :num-allocs              4163055
;  :num-checks              135
;  :propagations            90
;  :quant-instantiations    69
;  :rlimit-count            152328)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1504
;  :arith-add-rows          2
;  :arith-assert-diseq      28
;  :arith-assert-lower      85
;  :arith-assert-upper      59
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        3
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   367
;  :datatype-splits         151
;  :decisions               248
;  :del-clause              161
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             890
;  :mk-clause               179
;  :num-allocs              4163055
;  :num-checks              136
;  :propagations            90
;  :quant-instantiations    69
;  :rlimit-count            152341)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@48@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1504
;  :arith-add-rows          2
;  :arith-assert-diseq      28
;  :arith-assert-lower      85
;  :arith-assert-upper      59
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        3
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   367
;  :datatype-splits         151
;  :decisions               248
;  :del-clause              161
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             890
;  :mk-clause               179
;  :num-allocs              4163055
;  :num-checks              137
;  :propagations            90
;  :quant-instantiations    69
;  :rlimit-count            152367)
; [eval] !sys__result.Main_mon.Monitor_init
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@48@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1504
;  :arith-add-rows          2
;  :arith-assert-diseq      28
;  :arith-assert-lower      85
;  :arith-assert-upper      59
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        3
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   367
;  :datatype-splits         151
;  :decisions               248
;  :del-clause              161
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             890
;  :mk-clause               179
;  :num-allocs              4163055
;  :num-checks              138
;  :propagations            90
;  :quant-instantiations    69
;  :rlimit-count            152393)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@47@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1504
;  :arith-add-rows          2
;  :arith-assert-diseq      28
;  :arith-assert-lower      85
;  :arith-assert-upper      59
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        3
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   367
;  :datatype-splits         151
;  :decisions               248
;  :del-clause              161
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             890
;  :mk-clause               179
;  :num-allocs              4163055
;  :num-checks              139
;  :propagations            90
;  :quant-instantiations    69
;  :rlimit-count            152419)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@48@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1504
;  :arith-add-rows          2
;  :arith-assert-diseq      28
;  :arith-assert-lower      85
;  :arith-assert-upper      59
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        3
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   367
;  :datatype-splits         151
;  :decisions               248
;  :del-clause              161
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             890
;  :mk-clause               179
;  :num-allocs              4163055
;  :num-checks              140
;  :propagations            90
;  :quant-instantiations    69
;  :rlimit-count            152445)
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main_wakeup_after_wait_EncodedGlobalVariables ----------
(declare-const diz@52@02 $Ref)
(declare-const globals@53@02 $Ref)
(declare-const diz@54@02 $Ref)
(declare-const globals@55@02 $Ref)
(push) ; 1
(declare-const $t@56@02 $Snap)
(assert (= $t@56@02 ($Snap.combine ($Snap.first $t@56@02) ($Snap.second $t@56@02))))
(assert (= ($Snap.first $t@56@02) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@54@02 $Ref.null)))
(assert (=
  ($Snap.second $t@56@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@56@02))
    ($Snap.second ($Snap.second $t@56@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@56@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@56@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@56@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@02))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02)))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02)))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@57@02 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 8 | 0 <= i@57@02 | live]
; [else-branch: 8 | !(0 <= i@57@02) | live]
(push) ; 4
; [then-branch: 8 | 0 <= i@57@02]
(assert (<= 0 i@57@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 8 | !(0 <= i@57@02)]
(assert (not (<= 0 i@57@02)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 9 | i@57@02 < |First:(Second:(Second:($t@56@02)))| && 0 <= i@57@02 | live]
; [else-branch: 9 | !(i@57@02 < |First:(Second:(Second:($t@56@02)))| && 0 <= i@57@02) | live]
(push) ; 4
; [then-branch: 9 | i@57@02 < |First:(Second:(Second:($t@56@02)))| && 0 <= i@57@02]
(assert (and
  (<
    i@57@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))))
  (<= 0 i@57@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@57@02 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1543
;  :arith-add-rows          4
;  :arith-assert-diseq      30
;  :arith-assert-lower      92
;  :arith-assert-upper      62
;  :arith-conflicts         1
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    142
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   367
;  :datatype-splits         151
;  :decisions               248
;  :del-clause              178
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             919
;  :mk-clause               185
;  :num-allocs              4163055
;  :num-checks              141
;  :propagations            92
;  :quant-instantiations    75
;  :rlimit-count            153642)
; [eval] -1
(push) ; 5
; [then-branch: 10 | First:(Second:(Second:($t@56@02)))[i@57@02] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:($t@56@02)))[i@57@02] != -1 | live]
(push) ; 6
; [then-branch: 10 | First:(Second:(Second:($t@56@02)))[i@57@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    i@57@02)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 10 | First:(Second:(Second:($t@56@02)))[i@57@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
      i@57@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@57@02 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1543
;  :arith-add-rows          4
;  :arith-assert-diseq      30
;  :arith-assert-lower      92
;  :arith-assert-upper      62
;  :arith-conflicts         1
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    142
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   367
;  :datatype-splits         151
;  :decisions               248
;  :del-clause              178
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             920
;  :mk-clause               185
;  :num-allocs              4163055
;  :num-checks              142
;  :propagations            92
;  :quant-instantiations    75
;  :rlimit-count            153805)
(push) ; 7
; [then-branch: 11 | 0 <= First:(Second:(Second:($t@56@02)))[i@57@02] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:($t@56@02)))[i@57@02]) | live]
(push) ; 8
; [then-branch: 11 | 0 <= First:(Second:(Second:($t@56@02)))[i@57@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    i@57@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@57@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1543
;  :arith-add-rows          4
;  :arith-assert-diseq      31
;  :arith-assert-lower      95
;  :arith-assert-upper      62
;  :arith-conflicts         1
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    142
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   367
;  :datatype-splits         151
;  :decisions               248
;  :del-clause              178
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             923
;  :mk-clause               186
;  :num-allocs              4163055
;  :num-checks              143
;  :propagations            92
;  :quant-instantiations    75
;  :rlimit-count            153919)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 11 | !(0 <= First:(Second:(Second:($t@56@02)))[i@57@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
      i@57@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 9 | !(i@57@02 < |First:(Second:(Second:($t@56@02)))| && 0 <= i@57@02)]
(assert (not
  (and
    (<
      i@57@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))))
    (<= 0 i@57@02))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@57@02 Int)) (!
  (implies
    (and
      (<
        i@57@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))))
      (<= 0 i@57@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
          i@57@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            i@57@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            i@57@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    i@57@02))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@58@02 $Snap)
(assert (= $t@58@02 ($Snap.combine ($Snap.first $t@58@02) ($Snap.second $t@58@02))))
(assert (=
  ($Snap.second $t@58@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@58@02))
    ($Snap.second ($Snap.second $t@58@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@58@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@58@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@58@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@58@02))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@58@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@59@02 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 12 | 0 <= i@59@02 | live]
; [else-branch: 12 | !(0 <= i@59@02) | live]
(push) ; 5
; [then-branch: 12 | 0 <= i@59@02]
(assert (<= 0 i@59@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 12 | !(0 <= i@59@02)]
(assert (not (<= 0 i@59@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 13 | i@59@02 < |First:(Second:($t@58@02))| && 0 <= i@59@02 | live]
; [else-branch: 13 | !(i@59@02 < |First:(Second:($t@58@02))| && 0 <= i@59@02) | live]
(push) ; 5
; [then-branch: 13 | i@59@02 < |First:(Second:($t@58@02))| && 0 <= i@59@02]
(assert (and
  (<
    i@59@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))))
  (<= 0 i@59@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@59@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1599
;  :arith-add-rows          4
;  :arith-assert-diseq      31
;  :arith-assert-lower      100
;  :arith-assert-upper      65
;  :arith-conflicts         1
;  :arith-eq-adapter        55
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   370
;  :datatype-splits         156
;  :decisions               253
;  :del-clause              185
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             951
;  :mk-clause               187
;  :num-allocs              4163055
;  :num-checks              145
;  :propagations            92
;  :quant-instantiations    79
;  :rlimit-count            155716)
; [eval] -1
(push) ; 6
; [then-branch: 14 | First:(Second:($t@58@02))[i@59@02] == -1 | live]
; [else-branch: 14 | First:(Second:($t@58@02))[i@59@02] != -1 | live]
(push) ; 7
; [then-branch: 14 | First:(Second:($t@58@02))[i@59@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))
    i@59@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 14 | First:(Second:($t@58@02))[i@59@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))
      i@59@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@59@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1599
;  :arith-add-rows          4
;  :arith-assert-diseq      31
;  :arith-assert-lower      100
;  :arith-assert-upper      65
;  :arith-conflicts         1
;  :arith-eq-adapter        55
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   370
;  :datatype-splits         156
;  :decisions               253
;  :del-clause              185
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             952
;  :mk-clause               187
;  :num-allocs              4163055
;  :num-checks              146
;  :propagations            92
;  :quant-instantiations    79
;  :rlimit-count            155867)
(push) ; 8
; [then-branch: 15 | 0 <= First:(Second:($t@58@02))[i@59@02] | live]
; [else-branch: 15 | !(0 <= First:(Second:($t@58@02))[i@59@02]) | live]
(push) ; 9
; [then-branch: 15 | 0 <= First:(Second:($t@58@02))[i@59@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))
    i@59@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@59@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1599
;  :arith-add-rows          4
;  :arith-assert-diseq      32
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-conflicts         1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   370
;  :datatype-splits         156
;  :decisions               253
;  :del-clause              185
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             955
;  :mk-clause               188
;  :num-allocs              4163055
;  :num-checks              147
;  :propagations            92
;  :quant-instantiations    79
;  :rlimit-count            155971)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 15 | !(0 <= First:(Second:($t@58@02))[i@59@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))
      i@59@02))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 13 | !(i@59@02 < |First:(Second:($t@58@02))| && 0 <= i@59@02)]
(assert (not
  (and
    (<
      i@59@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))))
    (<= 0 i@59@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@59@02 Int)) (!
  (implies
    (and
      (<
        i@59@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))))
      (<= 0 i@59@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))
          i@59@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))
            i@59@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))
            i@59@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))
    i@59@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@02)))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1) ==> diz.Main_process_state[0] == -1
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1617
;  :arith-add-rows          4
;  :arith-assert-diseq      32
;  :arith-assert-lower      104
;  :arith-assert-upper      66
;  :arith-conflicts         1
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   370
;  :datatype-splits         156
;  :decisions               253
;  :del-clause              186
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             975
;  :mk-clause               199
;  :num-allocs              4163055
;  :num-checks              148
;  :propagations            96
;  :quant-instantiations    81
;  :rlimit-count            157032)
(push) ; 3
; [then-branch: 16 | 0 <= First:(Second:(Second:($t@56@02)))[0] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:($t@56@02)))[0]) | live]
(push) ; 4
; [then-branch: 16 | 0 <= First:(Second:(Second:($t@56@02)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1617
;  :arith-add-rows          4
;  :arith-assert-diseq      32
;  :arith-assert-lower      105
;  :arith-assert-upper      66
;  :arith-conflicts         1
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   370
;  :datatype-splits         156
;  :decisions               253
;  :del-clause              186
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             981
;  :mk-clause               205
;  :num-allocs              4163055
;  :num-checks              149
;  :propagations            96
;  :quant-instantiations    82
;  :rlimit-count            157194)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1617
;  :arith-add-rows          4
;  :arith-assert-diseq      32
;  :arith-assert-lower      105
;  :arith-assert-upper      66
;  :arith-conflicts         1
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   370
;  :datatype-splits         156
;  :decisions               253
;  :del-clause              186
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             981
;  :mk-clause               205
;  :num-allocs              4163055
;  :num-checks              150
;  :propagations            96
;  :quant-instantiations    82
;  :rlimit-count            157203)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1618
;  :arith-add-rows          4
;  :arith-assert-diseq      32
;  :arith-assert-lower      106
;  :arith-assert-upper      67
;  :arith-conflicts         2
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               108
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   370
;  :datatype-splits         156
;  :decisions               253
;  :del-clause              186
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             981
;  :mk-clause               205
;  :num-allocs              4163055
;  :num-checks              151
;  :propagations            100
;  :quant-instantiations    82
;  :rlimit-count            157310)
(push) ; 5
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0 | live]
; [else-branch: 17 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] != 0 | live]
(push) ; 6
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
      0))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 17 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
        0))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 7
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1618
;  :arith-add-rows          4
;  :arith-assert-diseq      32
;  :arith-assert-lower      106
;  :arith-assert-upper      67
;  :arith-conflicts         2
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               108
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   370
;  :datatype-splits         156
;  :decisions               253
;  :del-clause              186
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             982
;  :mk-clause               205
;  :num-allocs              4163055
;  :num-checks              152
;  :propagations            100
;  :quant-instantiations    82
;  :rlimit-count            157529)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1618
;  :arith-add-rows          4
;  :arith-assert-diseq      32
;  :arith-assert-lower      106
;  :arith-assert-upper      67
;  :arith-conflicts         2
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               108
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   370
;  :datatype-splits         156
;  :decisions               253
;  :del-clause              186
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             982
;  :mk-clause               205
;  :num-allocs              4163055
;  :num-checks              153
;  :propagations            100
;  :quant-instantiations    82
;  :rlimit-count            157538)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1619
;  :arith-add-rows          4
;  :arith-assert-diseq      32
;  :arith-assert-lower      107
;  :arith-assert-upper      68
;  :arith-conflicts         3
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        3
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   370
;  :datatype-splits         156
;  :decisions               253
;  :del-clause              186
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             982
;  :mk-clause               205
;  :num-allocs              4163055
;  :num-checks              154
;  :propagations            104
;  :quant-instantiations    82
;  :rlimit-count            157645)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 16 | !(0 <= First:(Second:(Second:($t@56@02)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
      0))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1646
;  :arith-add-rows          4
;  :arith-assert-diseq      34
;  :arith-assert-lower      114
;  :arith-assert-upper      71
;  :arith-conflicts         3
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        3
;  :arith-pivots            14
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 280
;  :datatype-occurs-check   374
;  :datatype-splits         161
;  :decisions               261
;  :del-clause              201
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1005
;  :mk-clause               214
;  :num-allocs              4163055
;  :num-checks              155
;  :propagations            109
;  :quant-instantiations    84
;  :rlimit-count            158430)
(push) ; 4
(assert (not (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1672
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      121
;  :arith-assert-upper      74
;  :arith-conflicts         3
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   378
;  :datatype-splits         166
;  :decisions               270
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1029
;  :mk-clause               236
;  :num-allocs              4163055
;  :num-checks              156
;  :propagations            120
;  :quant-instantiations    86
;  :rlimit-count            159207
;  :time                    0.00)
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == -1 && 0 <= First:(Second:(Second:($t@56@02)))[0] | live]
; [else-branch: 18 | !(First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == -1 && 0 <= First:(Second:(Second:($t@56@02)))[0]) | live]
(push) ; 4
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == -1 && 0 <= First:(Second:(Second:($t@56@02)))[0]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1672
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      122
;  :arith-assert-upper      74
;  :arith-conflicts         3
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   378
;  :datatype-splits         166
;  :decisions               270
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1037
;  :mk-clause               243
;  :num-allocs              4163055
;  :num-checks              157
;  :propagations            120
;  :quant-instantiations    87
;  :rlimit-count            159431)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 18 | !(First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == -1 && 0 <= First:(Second:(Second:($t@56@02)))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
        0)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@02))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)) ==> diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] !(0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1))
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1674
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      122
;  :arith-assert-upper      74
;  :arith-conflicts         3
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   378
;  :datatype-splits         166
;  :decisions               270
;  :del-clause              230
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1043
;  :mk-clause               247
;  :num-allocs              4163055
;  :num-checks              158
;  :propagations            120
;  :quant-instantiations    87
;  :rlimit-count            159870)
(push) ; 3
; [then-branch: 19 | 0 <= First:(Second:(Second:($t@56@02)))[0] | live]
; [else-branch: 19 | !(0 <= First:(Second:(Second:($t@56@02)))[0]) | live]
(push) ; 4
; [then-branch: 19 | 0 <= First:(Second:(Second:($t@56@02)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1674
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      123
;  :arith-assert-upper      74
;  :arith-conflicts         3
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   378
;  :datatype-splits         166
;  :decisions               270
;  :del-clause              230
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1048
;  :mk-clause               253
;  :num-allocs              4163055
;  :num-checks              159
;  :propagations            120
;  :quant-instantiations    88
;  :rlimit-count            159987)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1674
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      123
;  :arith-assert-upper      74
;  :arith-conflicts         3
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   378
;  :datatype-splits         166
;  :decisions               270
;  :del-clause              230
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1048
;  :mk-clause               253
;  :num-allocs              4163055
;  :num-checks              160
;  :propagations            120
;  :quant-instantiations    88
;  :rlimit-count            159996)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1675
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      124
;  :arith-assert-upper      75
;  :arith-conflicts         4
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   378
;  :datatype-splits         166
;  :decisions               270
;  :del-clause              230
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1048
;  :mk-clause               253
;  :num-allocs              4163055
;  :num-checks              161
;  :propagations            124
;  :quant-instantiations    88
;  :rlimit-count            160104)
(push) ; 5
; [then-branch: 20 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0 | live]
; [else-branch: 20 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] != 0 | live]
(push) ; 6
; [then-branch: 20 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
      0))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 20 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
        0))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 7
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1675
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      124
;  :arith-assert-upper      75
;  :arith-conflicts         4
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   378
;  :datatype-splits         166
;  :decisions               270
;  :del-clause              230
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1048
;  :mk-clause               253
;  :num-allocs              4163055
;  :num-checks              162
;  :propagations            124
;  :quant-instantiations    88
;  :rlimit-count            160307)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1675
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      124
;  :arith-assert-upper      75
;  :arith-conflicts         4
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   378
;  :datatype-splits         166
;  :decisions               270
;  :del-clause              230
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1048
;  :mk-clause               253
;  :num-allocs              4163055
;  :num-checks              163
;  :propagations            124
;  :quant-instantiations    88
;  :rlimit-count            160316)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1676
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      125
;  :arith-assert-upper      76
;  :arith-conflicts         5
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               111
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   378
;  :datatype-splits         166
;  :decisions               270
;  :del-clause              230
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1048
;  :mk-clause               253
;  :num-allocs              4163055
;  :num-checks              164
;  :propagations            128
;  :quant-instantiations    88
;  :rlimit-count            160424)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 19 | !(0 <= First:(Second:(Second:($t@56@02)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
      0))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1699
;  :arith-add-rows          4
;  :arith-assert-diseq      38
;  :arith-assert-lower      131
;  :arith-assert-upper      80
;  :arith-conflicts         5
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               111
;  :datatype-accessor-ax    154
;  :datatype-constructor-ax 295
;  :datatype-occurs-check   382
;  :datatype-splits         170
;  :decisions               279
;  :del-clause              255
;  :final-checks            45
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1067
;  :mk-clause               272
;  :num-allocs              4163055
;  :num-checks              165
;  :propagations            139
;  :quant-instantiations    90
;  :rlimit-count            161194
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1747
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      134
;  :arith-assert-upper      81
;  :arith-conflicts         5
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               114
;  :datatype-accessor-ax    157
;  :datatype-constructor-ax 309
;  :datatype-occurs-check   390
;  :datatype-splits         181
;  :decisions               293
;  :del-clause              260
;  :final-checks            49
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1094
;  :mk-clause               277
;  :num-allocs              4163055
;  :num-checks              166
;  :propagations            144
;  :quant-instantiations    91
;  :rlimit-count            162007
;  :time                    0.00)
; [then-branch: 21 | !(First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == -1 && 0 <= First:(Second:(Second:($t@56@02)))[0]) | live]
; [else-branch: 21 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == -1 && 0 <= First:(Second:(Second:($t@56@02)))[0] | live]
(push) ; 4
; [then-branch: 21 | !(First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == -1 && 0 <= First:(Second:(Second:($t@56@02)))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1747
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      134
;  :arith-assert-upper      81
;  :arith-conflicts         5
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               114
;  :datatype-accessor-ax    157
;  :datatype-constructor-ax 309
;  :datatype-occurs-check   390
;  :datatype-splits         181
;  :decisions               293
;  :del-clause              260
;  :final-checks            49
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1094
;  :mk-clause               278
;  :num-allocs              4163055
;  :num-checks              167
;  :propagations            144
;  :quant-instantiations    91
;  :rlimit-count            162222)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1747
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      134
;  :arith-assert-upper      81
;  :arith-conflicts         5
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        3
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               114
;  :datatype-accessor-ax    157
;  :datatype-constructor-ax 309
;  :datatype-occurs-check   390
;  :datatype-splits         181
;  :decisions               293
;  :del-clause              260
;  :final-checks            49
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             1094
;  :mk-clause               278
;  :num-allocs              4163055
;  :num-checks              168
;  :propagations            144
;  :quant-instantiations    91
;  :rlimit-count            162237)
(pop) ; 4
(push) ; 4
; [else-branch: 21 | First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@56@02)))))[First:(Second:(Second:($t@56@02)))[0]] == -1 && 0 <= First:(Second:(Second:($t@56@02)))[0]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
      0))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (or
        (=
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
              0))
          0)
        (=
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@02))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@58@02)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@56@02))))
      0))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
