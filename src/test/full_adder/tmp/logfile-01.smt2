(get-info :version)
; (:version "4.8.6")
; Started: 2024-07-17 23:27:22
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
(declare-const class_Full_adder<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Object<TYPE> TYPE)
(declare-const class_Prc_half_adder_1<TYPE> TYPE)
(declare-const class_Prc_half_adder_2<TYPE> TYPE)
(declare-const class_Prc_or<TYPE> TYPE)
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
; /field_value_functions_declarations.smt2 [Full_adder_m: Ref]
(declare-fun $FVF.domain_Full_adder_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Full_adder_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Full_adder_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Full_adder_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Full_adder_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Full_adder_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [Prc_half_adder_1_m: Ref]
(declare-fun $FVF.domain_Prc_half_adder_1_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Prc_half_adder_1_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Prc_half_adder_1_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Prc_half_adder_1_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Prc_half_adder_1_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Prc_half_adder_1_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [Prc_half_adder_2_m: Ref]
(declare-fun $FVF.domain_Prc_half_adder_2_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Prc_half_adder_2_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Prc_half_adder_2_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Prc_half_adder_2_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Prc_half_adder_2_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Prc_half_adder_2_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [Prc_or_m: Ref]
(declare-fun $FVF.domain_Prc_or_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Prc_or_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Prc_or_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Prc_or_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Prc_or_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Prc_or_m $FVF<$Ref>)
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
(declare-fun Prc_half_adder_1_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Prc_half_adder_1_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Prc_half_adder_2_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Prc_half_adder_2_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Prc_or_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Prc_or_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_held_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
; ////////// Uniqueness assumptions from domains
(assert (distinct class_Full_adder<TYPE> class_java_DOT_lang_DOT_Object<TYPE> class_Prc_half_adder_1<TYPE> class_Prc_half_adder_2<TYPE> class_Prc_or<TYPE> class_Main<TYPE> class_EncodedGlobalVariables<TYPE>))
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
  (directSuperclass<TYPE> (as class_Full_adder<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Prc_half_adder_1<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Prc_half_adder_2<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Prc_or<TYPE>  TYPE))
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
; /field_value_functions_axioms.smt2 [Full_adder_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Full_adder_m vs) ($FVF.domain_Full_adder_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Full_adder_m vs))
            (= ($FVF.lookup_Full_adder_m vs x) ($FVF.lookup_Full_adder_m ws x)))
          :pattern (($FVF.lookup_Full_adder_m vs x) ($FVF.lookup_Full_adder_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Full_adder_m pm r))
    :pattern ($FVF.perm_Full_adder_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Full_adder_m f r) true)
    :pattern ($FVF.loc_Full_adder_m f r))))
; /field_value_functions_axioms.smt2 [Prc_half_adder_1_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Prc_half_adder_1_m vs) ($FVF.domain_Prc_half_adder_1_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Prc_half_adder_1_m vs))
            (= ($FVF.lookup_Prc_half_adder_1_m vs x) ($FVF.lookup_Prc_half_adder_1_m ws x)))
          :pattern (($FVF.lookup_Prc_half_adder_1_m vs x) ($FVF.lookup_Prc_half_adder_1_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Prc_half_adder_1_m pm r))
    :pattern ($FVF.perm_Prc_half_adder_1_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Prc_half_adder_1_m f r) true)
    :pattern ($FVF.loc_Prc_half_adder_1_m f r))))
; /field_value_functions_axioms.smt2 [Prc_half_adder_2_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Prc_half_adder_2_m vs) ($FVF.domain_Prc_half_adder_2_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Prc_half_adder_2_m vs))
            (= ($FVF.lookup_Prc_half_adder_2_m vs x) ($FVF.lookup_Prc_half_adder_2_m ws x)))
          :pattern (($FVF.lookup_Prc_half_adder_2_m vs x) ($FVF.lookup_Prc_half_adder_2_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Prc_half_adder_2_m pm r))
    :pattern ($FVF.perm_Prc_half_adder_2_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Prc_half_adder_2_m f r) true)
    :pattern ($FVF.loc_Prc_half_adder_2_m f r))))
; /field_value_functions_axioms.smt2 [Prc_or_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Prc_or_m vs) ($FVF.domain_Prc_or_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Prc_or_m vs))
            (= ($FVF.lookup_Prc_or_m vs x) ($FVF.lookup_Prc_or_m ws x)))
          :pattern (($FVF.lookup_Prc_or_m vs x) ($FVF.lookup_Prc_or_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Prc_or_m pm r))
    :pattern ($FVF.perm_Prc_or_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Prc_or_m f r) true)
    :pattern ($FVF.loc_Prc_or_m f r))))
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
    (and (not (= diz@7@00 $Ref.null)) (= (Seq_length vals@8@00) 6))
    (and
      (and
        (and
          (and
            (and
              (and
                (or
                  (< (Seq_index vals@8@00 0) (- 0 1))
                  (<= result@9@00 (Seq_index vals@8@00 0)))
                (or
                  (< (Seq_index vals@8@00 1) (- 0 1))
                  (<= result@9@00 (Seq_index vals@8@00 1))))
              (or
                (< (Seq_index vals@8@00 2) (- 0 1))
                (<= result@9@00 (Seq_index vals@8@00 2))))
            (or
              (< (Seq_index vals@8@00 3) (- 0 1))
              (<= result@9@00 (Seq_index vals@8@00 3))))
          (or
            (< (Seq_index vals@8@00 4) (- 0 1))
            (<= result@9@00 (Seq_index vals@8@00 4))))
        (or
          (< (Seq_index vals@8@00 5) (- 0 1))
          (<= result@9@00 (Seq_index vals@8@00 5))))
      (and
        (implies
          (and
            (and
              (and
                (and
                  (and
                    (< (Seq_index vals@8@00 0) (- 0 1))
                    (< (Seq_index vals@8@00 1) (- 0 1)))
                  (< (Seq_index vals@8@00 2) (- 0 1)))
                (< (Seq_index vals@8@00 3) (- 0 1)))
              (< (Seq_index vals@8@00 4) (- 0 1)))
            (< (Seq_index vals@8@00 5) (- 0 1)))
          (= result@9@00 0))
        (implies
          (or
            (or
              (or
                (or
                  (or
                    (<= (- 0 1) (Seq_index vals@8@00 0))
                    (<= (- 0 1) (Seq_index vals@8@00 1)))
                  (<= (- 0 1) (Seq_index vals@8@00 2)))
                (<= (- 0 1) (Seq_index vals@8@00 3)))
              (<= (- 0 1) (Seq_index vals@8@00 4)))
            (<= (- 0 1) (Seq_index vals@8@00 5)))
          (or
            (or
              (or
                (or
                  (or
                    (and
                      (<= (- 0 1) (Seq_index vals@8@00 0))
                      (= result@9@00 (Seq_index vals@8@00 0)))
                    (and
                      (<= (- 0 1) (Seq_index vals@8@00 1))
                      (= result@9@00 (Seq_index vals@8@00 1))))
                  (and
                    (<= (- 0 1) (Seq_index vals@8@00 2))
                    (= result@9@00 (Seq_index vals@8@00 2))))
                (and
                  (<= (- 0 1) (Seq_index vals@8@00 3))
                  (= result@9@00 (Seq_index vals@8@00 3))))
              (and
                (<= (- 0 1) (Seq_index vals@8@00 4))
                (= result@9@00 (Seq_index vals@8@00 4))))
            (and
              (<= (- 0 1) (Seq_index vals@8@00 5))
              (= result@9@00 (Seq_index vals@8@00 5)))))))))
  :pattern ((Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@7@00 vals@8@00))
  )))
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- Prc_half_adder_1_joinOperator_EncodedGlobalVariables ----------
(declare-const diz@0@01 $Ref)
(declare-const globals@1@01 $Ref)
(declare-const diz@2@01 $Ref)
(declare-const globals@3@01 $Ref)
(push) ; 1
(declare-const $t@4@01 $Snap)
(assert (= $t@4@01 ($Snap.combine ($Snap.first $t@4@01) ($Snap.second $t@4@01))))
(assert (= ($Snap.first $t@4@01) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@2@01 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@5@01 $Snap)
(assert (= $t@5@01 ($Snap.combine ($Snap.first $t@5@01) ($Snap.second $t@5@01))))
(assert (=
  ($Snap.second $t@5@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@5@01))
    ($Snap.second ($Snap.second $t@5@01)))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25
;  :arith-assert-lower      1
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     22
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   2
;  :datatype-splits         1
;  :decisions               1
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             243
;  :mk-clause               1
;  :num-allocs              3250513
;  :num-checks              2
;  :propagations            22
;  :quant-instantiations    1
;  :rlimit-count            100934)
(assert (=
  ($Snap.second ($Snap.second $t@5@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@5@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@5@01))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@5@01))) $Snap.unit))
; [eval] diz.Prc_half_adder_1_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@01))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@5@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@5@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@01)))))))
(declare-const $k@6@01 $Perm)
(assert ($Perm.isReadVar $k@6@01 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@6@01 $Perm.No) (< $Perm.No $k@6@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               37
;  :arith-assert-diseq      1
;  :arith-assert-lower      3
;  :arith-assert-upper      2
;  :arith-eq-adapter        2
;  :binary-propagations     22
;  :conflicts               1
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   2
;  :datatype-splits         1
;  :decisions               1
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             252
;  :mk-clause               3
;  :num-allocs              3250513
;  :num-checks              3
;  :propagations            23
;  :quant-instantiations    2
;  :rlimit-count            101506)
(assert (<= $Perm.No $k@6@01))
(assert (<= $k@6@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@6@01)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@01)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@01)))))
  $Snap.unit))
; [eval] diz.Prc_half_adder_1_m.Main_adder_half_adder1 == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43
;  :arith-assert-diseq      1
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-eq-adapter        2
;  :binary-propagations     22
;  :conflicts               2
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   2
;  :datatype-splits         1
;  :decisions               1
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             255
;  :mk-clause               3
;  :num-allocs              3250513
;  :num-checks              4
;  :propagations            23
;  :quant-instantiations    2
;  :rlimit-count            101779
;  :time                    0.01)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@5@01)))))
  diz@2@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@01)))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               50
;  :arith-assert-diseq      1
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-eq-adapter        2
;  :binary-propagations     22
;  :conflicts               2
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   2
;  :datatype-splits         1
;  :decisions               1
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             258
;  :mk-clause               3
;  :num-allocs              3250513
;  :num-checks              5
;  :propagations            23
;  :quant-instantiations    3
;  :rlimit-count            102030)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@01))))))
  $Snap.unit))
; [eval] !diz.Prc_half_adder_1_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@01)))))))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Prc_half_adder_2_joinOperator_EncodedGlobalVariables ----------
(declare-const diz@7@01 $Ref)
(declare-const globals@8@01 $Ref)
(declare-const diz@9@01 $Ref)
(declare-const globals@10@01 $Ref)
(push) ; 1
(declare-const $t@11@01 $Snap)
(assert (= $t@11@01 ($Snap.combine ($Snap.first $t@11@01) ($Snap.second $t@11@01))))
(assert (= ($Snap.first $t@11@01) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@9@01 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@12@01 $Snap)
(assert (= $t@12@01 ($Snap.combine ($Snap.first $t@12@01) ($Snap.second $t@12@01))))
(assert (=
  ($Snap.second $t@12@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@12@01))
    ($Snap.second ($Snap.second $t@12@01)))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               68
;  :arith-assert-diseq      1
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-eq-adapter        2
;  :binary-propagations     22
;  :conflicts               2
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   4
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             264
;  :mk-clause               3
;  :num-allocs              3250513
;  :num-checks              7
;  :propagations            23
;  :quant-instantiations    3
;  :rlimit-count            102697)
(assert (=
  ($Snap.second ($Snap.second $t@12@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@12@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@12@01))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@12@01))) $Snap.unit))
; [eval] diz.Prc_half_adder_2_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@12@01))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@12@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@01)))))))
(declare-const $k@13@01 $Perm)
(assert ($Perm.isReadVar $k@13@01 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@13@01 $Perm.No) (< $Perm.No $k@13@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               80
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :binary-propagations     22
;  :conflicts               3
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   4
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             273
;  :mk-clause               5
;  :num-allocs              3250513
;  :num-checks              8
;  :propagations            24
;  :quant-instantiations    4
;  :rlimit-count            103270)
(assert (<= $Perm.No $k@13@01))
(assert (<= $k@13@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@13@01)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@12@01)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@01)))))
  $Snap.unit))
; [eval] diz.Prc_half_adder_2_m.Main_adder_half_adder2 == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@13@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               86
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     22
;  :conflicts               4
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   4
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             276
;  :mk-clause               5
;  :num-allocs              3250513
;  :num-checks              9
;  :propagations            24
;  :quant-instantiations    4
;  :rlimit-count            103543
;  :time                    0.00)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@01)))))
  diz@9@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@01)))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               93
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     22
;  :conflicts               4
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   4
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             279
;  :mk-clause               5
;  :num-allocs              3250513
;  :num-checks              10
;  :propagations            24
;  :quant-instantiations    5
;  :rlimit-count            103794)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@01))))))
  $Snap.unit))
; [eval] !diz.Prc_half_adder_2_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@01)))))))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Prc_or_joinOperator_EncodedGlobalVariables ----------
(declare-const diz@14@01 $Ref)
(declare-const globals@15@01 $Ref)
(declare-const diz@16@01 $Ref)
(declare-const globals@17@01 $Ref)
(push) ; 1
(declare-const $t@18@01 $Snap)
(assert (= $t@18@01 ($Snap.combine ($Snap.first $t@18@01) ($Snap.second $t@18@01))))
(assert (= ($Snap.first $t@18@01) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@16@01 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@19@01 $Snap)
(assert (= $t@19@01 ($Snap.combine ($Snap.first $t@19@01) ($Snap.second $t@19@01))))
(assert (=
  ($Snap.second $t@19@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@19@01))
    ($Snap.second ($Snap.second $t@19@01)))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               111
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     22
;  :conflicts               4
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              4
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             285
;  :mk-clause               5
;  :num-allocs              3250513
;  :num-checks              12
;  :propagations            24
;  :quant-instantiations    5
;  :rlimit-count            104461)
(assert (=
  ($Snap.second ($Snap.second $t@19@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@19@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@19@01))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@19@01))) $Snap.unit))
; [eval] diz.Prc_or_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@01))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@19@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@01)))))))
(declare-const $k@20@01 $Perm)
(assert ($Perm.isReadVar $k@20@01 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@20@01 $Perm.No) (< $Perm.No $k@20@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               123
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      6
;  :arith-eq-adapter        4
;  :binary-propagations     22
;  :conflicts               5
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              4
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             294
;  :mk-clause               7
;  :num-allocs              3250513
;  :num-checks              13
;  :propagations            25
;  :quant-instantiations    6
;  :rlimit-count            105034)
(assert (<= $Perm.No $k@20@01))
(assert (<= $k@20@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@20@01)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@01)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@01)))))
  $Snap.unit))
; [eval] diz.Prc_or_m.Main_adder_prc == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@20@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               129
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     22
;  :conflicts               6
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              4
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             297
;  :mk-clause               7
;  :num-allocs              3250513
;  :num-checks              14
;  :propagations            25
;  :quant-instantiations    6
;  :rlimit-count            105307)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@01)))))
  diz@16@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@01)))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               136
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     22
;  :conflicts               6
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              4
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             300
;  :mk-clause               7
;  :num-allocs              3250513
;  :num-checks              15
;  :propagations            25
;  :quant-instantiations    7
;  :rlimit-count            105558)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@01))))))
  $Snap.unit))
; [eval] !diz.Prc_or_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@01)))))))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main_Main_EncodedGlobalVariables ----------
(declare-const globals@21@01 $Ref)
(declare-const sys__result@22@01 $Ref)
(declare-const globals@23@01 $Ref)
(declare-const sys__result@24@01 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@25@01 $Snap)
(assert (= $t@25@01 ($Snap.combine ($Snap.first $t@25@01) ($Snap.second $t@25@01))))
(assert (= ($Snap.first $t@25@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@24@01 $Ref.null)))
(assert (=
  ($Snap.second $t@25@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@25@01))
    ($Snap.second ($Snap.second $t@25@01)))))
(assert (= ($Snap.first ($Snap.second $t@25@01)) $Snap.unit))
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
(assert (= (type_of<TYPE> sys__result@24@01) (as class_Main<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@25@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@25@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))
(declare-const $k@26@01 $Perm)
(assert ($Perm.isReadVar $k@26@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@26@01 $Perm.No) (< $Perm.No $k@26@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               154
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      8
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               7
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             311
;  :mk-clause               9
;  :num-allocs              3250513
;  :num-checks              17
;  :propagations            26
;  :quant-instantiations    7
;  :rlimit-count            106482)
(assert (<= $Perm.No $k@26@01))
(assert (<= $k@26@01 $Perm.Write))
(assert (implies (< $Perm.No $k@26@01) (not (= sys__result@24@01 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@25@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@25@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@25@01))))
  $Snap.unit))
; [eval] sys__result.Main_adder_prc != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@26@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               160
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               8
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             314
;  :mk-clause               9
;  :num-allocs              3250513
;  :num-checks              18
;  :propagations            26
;  :quant-instantiations    7
;  :rlimit-count            106745)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@25@01))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))
(push) ; 3
(assert (not (< $Perm.No $k@26@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               166
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               9
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             317
;  :mk-clause               9
;  :num-allocs              3250513
;  :num-checks              19
;  :propagations            26
;  :quant-instantiations    8
;  :rlimit-count            107041)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               166
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               9
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             317
;  :mk-clause               9
;  :num-allocs              3250513
;  :num-checks              20
;  :propagations            26
;  :quant-instantiations    8
;  :rlimit-count            107054)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))
  $Snap.unit))
; [eval] sys__result.Main_adder_prc.Prc_or_m == sys__result
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@26@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               172
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               10
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.67
;  :mk-bool-var             319
;  :mk-clause               9
;  :num-allocs              3250513
;  :num-checks              21
;  :propagations            26
;  :quant-instantiations    8
;  :rlimit-count            107283)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))
  sys__result@24@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@26@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               179
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               11
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             322
;  :mk-clause               9
;  :num-allocs              3364145
;  :num-checks              22
;  :propagations            26
;  :quant-instantiations    9
;  :rlimit-count            107579)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               179
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               11
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             322
;  :mk-clause               9
;  :num-allocs              3364145
;  :num-checks              23
;  :propagations            26
;  :quant-instantiations    9
;  :rlimit-count            107592)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))
  $Snap.unit))
; [eval] !sys__result.Main_adder_prc.Prc_or_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@26@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               185
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               12
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             324
;  :mk-clause               9
;  :num-allocs              3364145
;  :num-checks              24
;  :propagations            26
;  :quant-instantiations    9
;  :rlimit-count            107841)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))
(declare-const $k@27@01 $Perm)
(assert ($Perm.isReadVar $k@27@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@27@01 $Perm.No) (< $Perm.No $k@27@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      10
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               13
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             332
;  :mk-clause               11
;  :num-allocs              3478247
;  :num-checks              25
;  :propagations            27
;  :quant-instantiations    11
;  :rlimit-count            108320)
(assert (<= $Perm.No $k@27@01))
(assert (<= $k@27@01 $Perm.Write))
(assert (implies (< $Perm.No $k@27@01) (not (= sys__result@24@01 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))
  $Snap.unit))
; [eval] sys__result.Main_adder_half_adder1 != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@27@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               200
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               14
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             335
;  :mk-clause               11
;  :num-allocs              3478247
;  :num-checks              26
;  :propagations            27
;  :quant-instantiations    11
;  :rlimit-count            108643)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@27@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               206
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               15
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             338
;  :mk-clause               11
;  :num-allocs              3478247
;  :num-checks              27
;  :propagations            27
;  :quant-instantiations    12
;  :rlimit-count            108997)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               206
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               15
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             338
;  :mk-clause               11
;  :num-allocs              3478247
;  :num-checks              28
;  :propagations            27
;  :quant-instantiations    12
;  :rlimit-count            109010)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))
  $Snap.unit))
; [eval] sys__result.Main_adder_half_adder1.Prc_half_adder_1_m == sys__result
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@27@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               212
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               16
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             340
;  :mk-clause               11
;  :num-allocs              3478247
;  :num-checks              29
;  :propagations            27
;  :quant-instantiations    12
;  :rlimit-count            109299)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))
  sys__result@24@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@27@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               220
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               17
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             343
;  :mk-clause               11
;  :num-allocs              3478247
;  :num-checks              30
;  :propagations            27
;  :quant-instantiations    13
;  :rlimit-count            109654)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               220
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               17
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             343
;  :mk-clause               11
;  :num-allocs              3478247
;  :num-checks              31
;  :propagations            27
;  :quant-instantiations    13
;  :rlimit-count            109667)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))
  $Snap.unit))
; [eval] !sys__result.Main_adder_half_adder1.Prc_half_adder_1_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@27@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               226
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               18
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             345
;  :mk-clause               11
;  :num-allocs              3478247
;  :num-checks              32
;  :propagations            27
;  :quant-instantiations    13
;  :rlimit-count            109976)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))
(declare-const $k@28@01 $Perm)
(assert ($Perm.isReadVar $k@28@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@28@01 $Perm.No) (< $Perm.No $k@28@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               234
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      12
;  :arith-eq-adapter        7
;  :binary-propagations     22
;  :conflicts               19
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             352
;  :mk-clause               13
;  :num-allocs              3478247
;  :num-checks              33
;  :propagations            28
;  :quant-instantiations    14
;  :rlimit-count            110496)
(assert (<= $Perm.No $k@28@01))
(assert (<= $k@28@01 $Perm.Write))
(assert (implies (< $Perm.No $k@28@01) (not (= sys__result@24@01 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))
  $Snap.unit))
; [eval] sys__result.Main_adder_half_adder2 != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@28@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               240
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     22
;  :conflicts               20
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             355
;  :mk-clause               13
;  :num-allocs              3478247
;  :num-checks              34
;  :propagations            28
;  :quant-instantiations    14
;  :rlimit-count            110879)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@28@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               246
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     22
;  :conflicts               21
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             358
;  :mk-clause               13
;  :num-allocs              3478247
;  :num-checks              35
;  :propagations            28
;  :quant-instantiations    15
;  :rlimit-count            111293)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               246
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     22
;  :conflicts               21
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             358
;  :mk-clause               13
;  :num-allocs              3478247
;  :num-checks              36
;  :propagations            28
;  :quant-instantiations    15
;  :rlimit-count            111306)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))
  $Snap.unit))
; [eval] sys__result.Main_adder_half_adder2.Prc_half_adder_2_m == sys__result
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@28@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               252
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     22
;  :conflicts               22
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             360
;  :mk-clause               13
;  :num-allocs              3478247
;  :num-checks              37
;  :propagations            28
;  :quant-instantiations    15
;  :rlimit-count            111655)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))
  sys__result@24@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@28@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               260
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     22
;  :conflicts               23
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             363
;  :mk-clause               13
;  :num-allocs              3478247
;  :num-checks              38
;  :propagations            28
;  :quant-instantiations    16
;  :rlimit-count            112070)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               260
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     22
;  :conflicts               23
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             363
;  :mk-clause               13
;  :num-allocs              3478247
;  :num-checks              39
;  :propagations            28
;  :quant-instantiations    16
;  :rlimit-count            112083)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))))
  $Snap.unit))
; [eval] !sys__result.Main_adder_half_adder2.Prc_half_adder_2_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@28@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               266
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     22
;  :conflicts               24
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             365
;  :mk-clause               13
;  :num-allocs              3478247
;  :num-checks              40
;  :propagations            28
;  :quant-instantiations    16
;  :rlimit-count            112452)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@26@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               274
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     22
;  :conflicts               25
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             368
;  :mk-clause               13
;  :num-allocs              3478247
;  :num-checks              41
;  :propagations            28
;  :quant-instantiations    17
;  :rlimit-count            112888)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@27@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               279
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     22
;  :conflicts               26
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             369
;  :mk-clause               13
;  :num-allocs              3478247
;  :num-checks              42
;  :propagations            28
;  :quant-instantiations    17
;  :rlimit-count            113245)
(push) ; 3
(assert (not (< $Perm.No $k@28@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               279
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     22
;  :conflicts               27
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              6
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             369
;  :mk-clause               13
;  :num-allocs              3478247
;  :num-checks              43
;  :propagations            28
;  :quant-instantiations    17
;  :rlimit-count            113293)
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_91__104: Ref
(declare-const __flatten_91__104@29@01 $Ref)
; [exec]
; var __flatten_89__103: Ref
(declare-const __flatten_89__103@30@01 $Ref)
; [exec]
; var __flatten_87__102: Ref
(declare-const __flatten_87__102@31@01 $Ref)
; [exec]
; var __flatten_85__101: Ref
(declare-const __flatten_85__101@32@01 $Ref)
; [exec]
; var __flatten_84__100: Seq[Int]
(declare-const __flatten_84__100@33@01 Seq<Int>)
; [exec]
; var __flatten_83__99: Seq[Int]
(declare-const __flatten_83__99@34@01 Seq<Int>)
; [exec]
; var __flatten_82__98: Seq[Int]
(declare-const __flatten_82__98@35@01 Seq<Int>)
; [exec]
; var __flatten_81__97: Seq[Int]
(declare-const __flatten_81__97@36@01 Seq<Int>)
; [exec]
; var diz__96: Ref
(declare-const diz__96@37@01 $Ref)
; [exec]
; diz__96 := new(Main_process_state, Main_event_state, Main_adder, Main_adder_prc, Main_adder_half_adder1, Main_adder_half_adder2)
(declare-const diz__96@38@01 $Ref)
(assert (not (= diz__96@38@01 $Ref.null)))
(declare-const Main_process_state@39@01 Seq<Int>)
(declare-const Main_event_state@40@01 Seq<Int>)
(declare-const Main_adder@41@01 $Ref)
(declare-const Main_adder_prc@42@01 $Ref)
(declare-const Main_adder_half_adder1@43@01 $Ref)
(declare-const Main_adder_half_adder2@44@01 $Ref)
(assert (not (= diz__96@38@01 sys__result@24@01)))
(assert (not (= diz__96@38@01 __flatten_85__101@32@01)))
(assert (not (= diz__96@38@01 __flatten_91__104@29@01)))
(assert (not (= diz__96@38@01 diz__96@37@01)))
(assert (not (= diz__96@38@01 __flatten_87__102@31@01)))
(assert (not (= diz__96@38@01 globals@23@01)))
(assert (not (= diz__96@38@01 __flatten_89__103@30@01)))
; [exec]
; inhale type_of(diz__96) == class_Main()
(declare-const $t@45@01 $Snap)
(assert (= $t@45@01 $Snap.unit))
; [eval] type_of(diz__96) == class_Main()
; [eval] type_of(diz__96)
; [eval] class_Main()
(assert (= (type_of<TYPE> diz__96@38@01) (as class_Main<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; __flatten_82__98 := Seq(-1, -1, -1)
; [eval] Seq(-1, -1, -1)
; [eval] -1
; [eval] -1
; [eval] -1
(assert (=
  (Seq_length
    (Seq_append
      (Seq_append (Seq_singleton (- 0 1)) (Seq_singleton (- 0 1)))
      (Seq_singleton (- 0 1))))
  3))
(declare-const __flatten_82__98@46@01 Seq<Int>)
(assert (Seq_equal
  __flatten_82__98@46@01
  (Seq_append
    (Seq_append (Seq_singleton (- 0 1)) (Seq_singleton (- 0 1)))
    (Seq_singleton (- 0 1)))))
; [exec]
; __flatten_81__97 := __flatten_82__98
; [exec]
; diz__96.Main_process_state := __flatten_81__97
; [exec]
; __flatten_84__100 := Seq(-3, -3, -3, -3, -3, -3)
; [eval] Seq(-3, -3, -3, -3, -3, -3)
; [eval] -3
; [eval] -3
; [eval] -3
; [eval] -3
; [eval] -3
; [eval] -3
(assert (=
  (Seq_length
    (Seq_append
      (Seq_append
        (Seq_append
          (Seq_append
            (Seq_append (Seq_singleton (- 0 3)) (Seq_singleton (- 0 3)))
            (Seq_singleton (- 0 3)))
          (Seq_singleton (- 0 3)))
        (Seq_singleton (- 0 3)))
      (Seq_singleton (- 0 3))))
  6))
(declare-const __flatten_84__100@47@01 Seq<Int>)
(assert (Seq_equal
  __flatten_84__100@47@01
  (Seq_append
    (Seq_append
      (Seq_append
        (Seq_append
          (Seq_append (Seq_singleton (- 0 3)) (Seq_singleton (- 0 3)))
          (Seq_singleton (- 0 3)))
        (Seq_singleton (- 0 3)))
      (Seq_singleton (- 0 3)))
    (Seq_singleton (- 0 3)))))
; [exec]
; __flatten_83__99 := __flatten_84__100
; [exec]
; diz__96.Main_event_state := __flatten_83__99
; [exec]
; __flatten_85__101 := Full_adder_Full_adder_EncodedGlobalVariables_Main(globals, diz__96)
(declare-const sys__result@48@01 $Ref)
(declare-const $t@49@01 $Snap)
(assert (= $t@49@01 ($Snap.combine ($Snap.first $t@49@01) ($Snap.second $t@49@01))))
(assert (= ($Snap.first $t@49@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@48@01 $Ref.null)))
(assert (=
  ($Snap.second $t@49@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@49@01))
    ($Snap.second ($Snap.second $t@49@01)))))
(assert (= ($Snap.first ($Snap.second $t@49@01)) $Snap.unit))
; [eval] type_of(sys__result) == class_Full_adder()
; [eval] type_of(sys__result)
; [eval] class_Full_adder()
(assert (= (type_of<TYPE> sys__result@48@01) (as class_Full_adder<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@49@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@49@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@49@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))))))
  $Snap.unit))
; [eval] sys__result.Full_adder_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@49@01))))
  diz__96@38@01))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; diz__96.Main_adder := __flatten_85__101
; [exec]
; __flatten_87__102 := Prc_or_Prc_or_EncodedGlobalVariables_Main(globals, diz__96)
(declare-const sys__result@50@01 $Ref)
(declare-const $t@51@01 $Snap)
(assert (= $t@51@01 ($Snap.combine ($Snap.first $t@51@01) ($Snap.second $t@51@01))))
(assert (= ($Snap.first $t@51@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@50@01 $Ref.null)))
(assert (=
  ($Snap.second $t@51@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@51@01))
    ($Snap.second ($Snap.second $t@51@01)))))
(assert (= ($Snap.first ($Snap.second $t@51@01)) $Snap.unit))
; [eval] type_of(sys__result) == class_Prc_or()
; [eval] type_of(sys__result)
; [eval] class_Prc_or()
(assert (= (type_of<TYPE> sys__result@50@01) (as class_Prc_or<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@51@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@51@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@51@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@51@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@01))))))
  $Snap.unit))
; [eval] !sys__result.Prc_or_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@01))))))
  $Snap.unit))
; [eval] sys__result.Prc_or_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@01)))))
  diz__96@38@01))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__96.Main_adder_prc := __flatten_87__102
; [exec]
; __flatten_89__103 := Prc_half_adder_1_Prc_half_adder_1_EncodedGlobalVariables_Main(globals, diz__96)
(declare-const sys__result@52@01 $Ref)
(declare-const $t@53@01 $Snap)
(assert (= $t@53@01 ($Snap.combine ($Snap.first $t@53@01) ($Snap.second $t@53@01))))
(assert (= ($Snap.first $t@53@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@52@01 $Ref.null)))
(assert (=
  ($Snap.second $t@53@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@53@01))
    ($Snap.second ($Snap.second $t@53@01)))))
(assert (= ($Snap.first ($Snap.second $t@53@01)) $Snap.unit))
; [eval] type_of(sys__result) == class_Prc_half_adder_1()
; [eval] type_of(sys__result)
; [eval] class_Prc_half_adder_1()
(assert (= (type_of<TYPE> sys__result@52@01) (as class_Prc_half_adder_1<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@53@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@53@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@53@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@53@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@01))))))
  $Snap.unit))
; [eval] !sys__result.Prc_half_adder_1_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@01))))))
  $Snap.unit))
; [eval] sys__result.Prc_half_adder_1_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@01)))))
  diz__96@38@01))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__96.Main_adder_half_adder1 := __flatten_89__103
; [exec]
; __flatten_91__104 := Prc_half_adder_2_Prc_half_adder_2_EncodedGlobalVariables_Main(globals, diz__96)
(declare-const sys__result@54@01 $Ref)
(declare-const $t@55@01 $Snap)
(assert (= $t@55@01 ($Snap.combine ($Snap.first $t@55@01) ($Snap.second $t@55@01))))
(assert (= ($Snap.first $t@55@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@54@01 $Ref.null)))
(assert (=
  ($Snap.second $t@55@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@55@01))
    ($Snap.second ($Snap.second $t@55@01)))))
(assert (= ($Snap.first ($Snap.second $t@55@01)) $Snap.unit))
; [eval] type_of(sys__result) == class_Prc_half_adder_2()
; [eval] type_of(sys__result)
; [eval] class_Prc_half_adder_2()
(assert (= (type_of<TYPE> sys__result@54@01) (as class_Prc_half_adder_2<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@55@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@55@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@55@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@55@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@01))))))
  $Snap.unit))
; [eval] !sys__result.Prc_half_adder_2_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@01))))))
  $Snap.unit))
; [eval] sys__result.Prc_half_adder_2_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@01)))))
  diz__96@38@01))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__96.Main_adder_half_adder2 := __flatten_91__104
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz__96, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(set-option :timeout 0)
(push) ; 3
(assert (not (= (Seq_length __flatten_82__98@46@01) 3)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               713
;  :arith-add-rows          24
;  :arith-assert-diseq      16
;  :arith-assert-lower      50
;  :arith-assert-upper      34
;  :arith-bound-prop        4
;  :arith-conflicts         1
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               37
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   29
;  :datatype-splits         22
;  :decisions               61
;  :del-clause              180
;  :final-checks            16
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             667
;  :mk-clause               181
;  :num-allocs              3721932
;  :num-checks              49
;  :propagations            96
;  :quant-instantiations    84
;  :rlimit-count            122695)
(assert (= (Seq_length __flatten_82__98@46@01) 3))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(push) ; 3
(assert (not (= (Seq_length __flatten_84__100@47@01) 6)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               714
;  :arith-add-rows          24
;  :arith-assert-diseq      16
;  :arith-assert-lower      51
;  :arith-assert-upper      35
;  :arith-bound-prop        4
;  :arith-conflicts         1
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               38
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   29
;  :datatype-splits         22
;  :decisions               61
;  :del-clause              180
;  :final-checks            16
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             673
;  :mk-clause               181
;  :num-allocs              3721932
;  :num-checks              50
;  :propagations            96
;  :quant-instantiations    84
;  :rlimit-count            122820)
(assert (= (Seq_length __flatten_84__100@47@01) 6))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@56@01 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@56@01 | live]
; [else-branch: 0 | !(0 <= i@56@01) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@56@01]
(assert (<= 0 i@56@01))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@56@01)]
(assert (not (<= 0 i@56@01)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@56@01 < |__flatten_82__98@46@01| && 0 <= i@56@01 | live]
; [else-branch: 1 | !(i@56@01 < |__flatten_82__98@46@01| && 0 <= i@56@01) | live]
(push) ; 5
; [then-branch: 1 | i@56@01 < |__flatten_82__98@46@01| && 0 <= i@56@01]
(assert (and (< i@56@01 (Seq_length __flatten_82__98@46@01)) (<= 0 i@56@01)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 6
(assert (not (>= i@56@01 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               715
;  :arith-add-rows          24
;  :arith-assert-diseq      16
;  :arith-assert-lower      53
;  :arith-assert-upper      37
;  :arith-bound-prop        4
;  :arith-conflicts         1
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               38
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   29
;  :datatype-splits         22
;  :decisions               61
;  :del-clause              180
;  :final-checks            16
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             678
;  :mk-clause               181
;  :num-allocs              3721932
;  :num-checks              51
;  :propagations            96
;  :quant-instantiations    84
;  :rlimit-count            123007)
; [eval] -1
(push) ; 6
; [then-branch: 2 | __flatten_82__98@46@01[i@56@01] == -1 | live]
; [else-branch: 2 | __flatten_82__98@46@01[i@56@01] != -1 | live]
(push) ; 7
; [then-branch: 2 | __flatten_82__98@46@01[i@56@01] == -1]
(assert (= (Seq_index __flatten_82__98@46@01 i@56@01) (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | __flatten_82__98@46@01[i@56@01] != -1]
(assert (not (= (Seq_index __flatten_82__98@46@01 i@56@01) (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@56@01 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               716
;  :arith-add-rows          26
;  :arith-assert-diseq      16
;  :arith-assert-lower      53
;  :arith-assert-upper      37
;  :arith-bound-prop        4
;  :arith-conflicts         1
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               38
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   29
;  :datatype-splits         22
;  :decisions               61
;  :del-clause              180
;  :final-checks            16
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             683
;  :mk-clause               185
;  :num-allocs              3721932
;  :num-checks              52
;  :propagations            96
;  :quant-instantiations    85
;  :rlimit-count            123174)
(push) ; 8
; [then-branch: 3 | 0 <= __flatten_82__98@46@01[i@56@01] | live]
; [else-branch: 3 | !(0 <= __flatten_82__98@46@01[i@56@01]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= __flatten_82__98@46@01[i@56@01]]
(assert (<= 0 (Seq_index __flatten_82__98@46@01 i@56@01)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@56@01 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               716
;  :arith-add-rows          26
;  :arith-assert-diseq      17
;  :arith-assert-lower      56
;  :arith-assert-upper      37
;  :arith-bound-prop        4
;  :arith-conflicts         1
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               38
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   29
;  :datatype-splits         22
;  :decisions               61
;  :del-clause              180
;  :final-checks            16
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             686
;  :mk-clause               186
;  :num-allocs              3721932
;  :num-checks              53
;  :propagations            96
;  :quant-instantiations    85
;  :rlimit-count            123247)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= __flatten_82__98@46@01[i@56@01])]
(assert (not (<= 0 (Seq_index __flatten_82__98@46@01 i@56@01))))
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
; [else-branch: 1 | !(i@56@01 < |__flatten_82__98@46@01| && 0 <= i@56@01)]
(assert (not (and (< i@56@01 (Seq_length __flatten_82__98@46@01)) (<= 0 i@56@01))))
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
(assert (not (forall ((i@56@01 Int)) (!
  (implies
    (and (< i@56@01 (Seq_length __flatten_82__98@46@01)) (<= 0 i@56@01))
    (or
      (= (Seq_index __flatten_82__98@46@01 i@56@01) (- 0 1))
      (and
        (<
          (Seq_index __flatten_82__98@46@01 i@56@01)
          (Seq_length __flatten_84__100@47@01))
        (<= 0 (Seq_index __flatten_82__98@46@01 i@56@01)))))
  :pattern ((Seq_index __flatten_82__98@46@01 i@56@01))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               803
;  :arith-add-rows          98
;  :arith-assert-diseq      24
;  :arith-assert-lower      77
;  :arith-assert-upper      47
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        103
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               58
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 70
;  :datatype-occurs-check   39
;  :datatype-splits         30
;  :decisions               93
;  :del-clause              375
;  :final-checks            21
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             869
;  :mk-clause               376
;  :num-allocs              3721932
;  :num-checks              54
;  :propagations            122
;  :quant-instantiations    96
;  :rlimit-count            125051
;  :time                    0.00)
(assert (forall ((i@56@01 Int)) (!
  (implies
    (and (< i@56@01 (Seq_length __flatten_82__98@46@01)) (<= 0 i@56@01))
    (or
      (= (Seq_index __flatten_82__98@46@01 i@56@01) (- 0 1))
      (and
        (<
          (Seq_index __flatten_82__98@46@01 i@56@01)
          (Seq_length __flatten_84__100@47@01))
        (<= 0 (Seq_index __flatten_82__98@46@01 i@56@01)))))
  :pattern ((Seq_index __flatten_82__98@46@01 i@56@01))
  :qid |prog.l<no position>|)))
(declare-const $k@57@01 $Perm)
(assert ($Perm.isReadVar $k@57@01 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@57@01 $Perm.No) (< $Perm.No $k@57@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               803
;  :arith-add-rows          98
;  :arith-assert-diseq      25
;  :arith-assert-lower      79
;  :arith-assert-upper      48
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               59
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 70
;  :datatype-occurs-check   39
;  :datatype-splits         30
;  :decisions               93
;  :del-clause              375
;  :final-checks            21
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             874
;  :mk-clause               378
;  :num-allocs              3721932
;  :num-checks              55
;  :propagations            123
;  :quant-instantiations    96
;  :rlimit-count            125521)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               803
;  :arith-add-rows          98
;  :arith-assert-diseq      25
;  :arith-assert-lower      79
;  :arith-assert-upper      48
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               59
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 70
;  :datatype-occurs-check   39
;  :datatype-splits         30
;  :decisions               93
;  :del-clause              375
;  :final-checks            21
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             874
;  :mk-clause               378
;  :num-allocs              3721932
;  :num-checks              56
;  :propagations            123
;  :quant-instantiations    96
;  :rlimit-count            125534)
(assert (< $k@57@01 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@57@01)))
(assert (<= (- $Perm.Write $k@57@01) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@57@01)) (not (= diz__96@38@01 $Ref.null))))
; [eval] diz.Main_adder != null
(declare-const $k@58@01 $Perm)
(assert ($Perm.isReadVar $k@58@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@58@01 $Perm.No) (< $Perm.No $k@58@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               803
;  :arith-add-rows          98
;  :arith-assert-diseq      26
;  :arith-assert-lower      81
;  :arith-assert-upper      50
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               60
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 70
;  :datatype-occurs-check   39
;  :datatype-splits         30
;  :decisions               93
;  :del-clause              375
;  :final-checks            21
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             879
;  :mk-clause               380
;  :num-allocs              3721932
;  :num-checks              57
;  :propagations            124
;  :quant-instantiations    96
;  :rlimit-count            125822)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               803
;  :arith-add-rows          98
;  :arith-assert-diseq      26
;  :arith-assert-lower      81
;  :arith-assert-upper      50
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               60
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 70
;  :datatype-occurs-check   39
;  :datatype-splits         30
;  :decisions               93
;  :del-clause              375
;  :final-checks            21
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             879
;  :mk-clause               380
;  :num-allocs              3721932
;  :num-checks              58
;  :propagations            124
;  :quant-instantiations    96
;  :rlimit-count            125835)
(assert (< $k@58@01 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@58@01)))
(assert (<= (- $Perm.Write $k@58@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $Perm.Write $k@58@01))
  (not (= sys__result@48@01 $Ref.null))))
; [eval] diz.Main_adder.Full_adder_m == diz
(declare-const $k@59@01 $Perm)
(assert ($Perm.isReadVar $k@59@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@59@01 $Perm.No) (< $Perm.No $k@59@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               803
;  :arith-add-rows          98
;  :arith-assert-diseq      27
;  :arith-assert-lower      83
;  :arith-assert-upper      52
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 70
;  :datatype-occurs-check   39
;  :datatype-splits         30
;  :decisions               93
;  :del-clause              375
;  :final-checks            21
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             884
;  :mk-clause               382
;  :num-allocs              3721932
;  :num-checks              59
;  :propagations            125
;  :quant-instantiations    96
;  :rlimit-count            126124)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               803
;  :arith-add-rows          98
;  :arith-assert-diseq      27
;  :arith-assert-lower      83
;  :arith-assert-upper      52
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 70
;  :datatype-occurs-check   39
;  :datatype-splits         30
;  :decisions               93
;  :del-clause              375
;  :final-checks            21
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             884
;  :mk-clause               382
;  :num-allocs              3721932
;  :num-checks              60
;  :propagations            125
;  :quant-instantiations    96
;  :rlimit-count            126137)
(assert (< $k@59@01 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@59@01)))
(assert (<= (- $Perm.Write $k@59@01) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@59@01)) (not (= diz__96@38@01 $Ref.null))))
; [eval] diz.Main_adder_prc != null
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               803
;  :arith-add-rows          98
;  :arith-assert-diseq      27
;  :arith-assert-lower      83
;  :arith-assert-upper      53
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 70
;  :datatype-occurs-check   39
;  :datatype-splits         30
;  :decisions               93
;  :del-clause              375
;  :final-checks            21
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             885
;  :mk-clause               382
;  :num-allocs              3721932
;  :num-checks              61
;  :propagations            125
;  :quant-instantiations    96
;  :rlimit-count            126234)
(set-option :timeout 10)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               843
;  :arith-add-rows          98
;  :arith-assert-diseq      27
;  :arith-assert-lower      83
;  :arith-assert-upper      53
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 84
;  :datatype-occurs-check   46
;  :datatype-splits         34
;  :decisions               107
;  :del-clause              375
;  :final-checks            23
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             889
;  :mk-clause               382
;  :num-allocs              3721932
;  :num-checks              62
;  :propagations            125
;  :quant-instantiations    96
;  :rlimit-count            126760
;  :time                    0.00)
(declare-const $k@60@01 $Perm)
(assert ($Perm.isReadVar $k@60@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@60@01 $Perm.No) (< $Perm.No $k@60@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               843
;  :arith-add-rows          98
;  :arith-assert-diseq      28
;  :arith-assert-lower      85
;  :arith-assert-upper      54
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               62
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 84
;  :datatype-occurs-check   46
;  :datatype-splits         34
;  :decisions               107
;  :del-clause              375
;  :final-checks            23
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             893
;  :mk-clause               384
;  :num-allocs              3721932
;  :num-checks              63
;  :propagations            126
;  :quant-instantiations    96
;  :rlimit-count            126959)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               843
;  :arith-add-rows          98
;  :arith-assert-diseq      28
;  :arith-assert-lower      85
;  :arith-assert-upper      54
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               62
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 84
;  :datatype-occurs-check   46
;  :datatype-splits         34
;  :decisions               107
;  :del-clause              375
;  :final-checks            23
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             893
;  :mk-clause               384
;  :num-allocs              3721932
;  :num-checks              64
;  :propagations            126
;  :quant-instantiations    96
;  :rlimit-count            126972)
(assert (< $k@60@01 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@60@01)))
(assert (<= (- $Perm.Write $k@60@01) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@60@01)) (not (= diz__96@38@01 $Ref.null))))
; [eval] diz.Main_adder_half_adder1 != null
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               843
;  :arith-add-rows          98
;  :arith-assert-diseq      28
;  :arith-assert-lower      85
;  :arith-assert-upper      55
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               62
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 84
;  :datatype-occurs-check   46
;  :datatype-splits         34
;  :decisions               107
;  :del-clause              375
;  :final-checks            23
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             894
;  :mk-clause               384
;  :num-allocs              3721932
;  :num-checks              65
;  :propagations            126
;  :quant-instantiations    96
;  :rlimit-count            127069)
(set-option :timeout 10)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               883
;  :arith-add-rows          98
;  :arith-assert-diseq      28
;  :arith-assert-lower      85
;  :arith-assert-upper      55
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               62
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 98
;  :datatype-occurs-check   53
;  :datatype-splits         38
;  :decisions               121
;  :del-clause              375
;  :final-checks            25
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             898
;  :mk-clause               384
;  :num-allocs              3721932
;  :num-checks              66
;  :propagations            126
;  :quant-instantiations    96
;  :rlimit-count            127599
;  :time                    0.00)
(declare-const $k@61@01 $Perm)
(assert ($Perm.isReadVar $k@61@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@61@01 $Perm.No) (< $Perm.No $k@61@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               883
;  :arith-add-rows          98
;  :arith-assert-diseq      29
;  :arith-assert-lower      87
;  :arith-assert-upper      56
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               63
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 98
;  :datatype-occurs-check   53
;  :datatype-splits         38
;  :decisions               121
;  :del-clause              375
;  :final-checks            25
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             902
;  :mk-clause               386
;  :num-allocs              3721932
;  :num-checks              67
;  :propagations            127
;  :quant-instantiations    96
;  :rlimit-count            127798)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               883
;  :arith-add-rows          98
;  :arith-assert-diseq      29
;  :arith-assert-lower      87
;  :arith-assert-upper      56
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               63
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 98
;  :datatype-occurs-check   53
;  :datatype-splits         38
;  :decisions               121
;  :del-clause              375
;  :final-checks            25
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             902
;  :mk-clause               386
;  :num-allocs              3721932
;  :num-checks              68
;  :propagations            127
;  :quant-instantiations    96
;  :rlimit-count            127811)
(assert (< $k@61@01 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@61@01)))
(assert (<= (- $Perm.Write $k@61@01) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@61@01)) (not (= diz__96@38@01 $Ref.null))))
; [eval] diz.Main_adder_half_adder2 != null
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               883
;  :arith-add-rows          98
;  :arith-assert-diseq      29
;  :arith-assert-lower      87
;  :arith-assert-upper      57
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               63
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 98
;  :datatype-occurs-check   53
;  :datatype-splits         38
;  :decisions               121
;  :del-clause              375
;  :final-checks            25
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             903
;  :mk-clause               386
;  :num-allocs              3721932
;  :num-checks              69
;  :propagations            127
;  :quant-instantiations    96
;  :rlimit-count            127908)
(set-option :timeout 10)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               923
;  :arith-add-rows          98
;  :arith-assert-diseq      29
;  :arith-assert-lower      87
;  :arith-assert-upper      57
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               63
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 112
;  :datatype-occurs-check   60
;  :datatype-splits         42
;  :decisions               135
;  :del-clause              375
;  :final-checks            27
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.14
;  :memory                  4.14
;  :minimized-lits          2
;  :mk-bool-var             907
;  :mk-clause               386
;  :num-allocs              3721932
;  :num-checks              70
;  :propagations            127
;  :quant-instantiations    96
;  :rlimit-count            128442
;  :time                    0.00)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($SortWrappers.Seq<Int>To$Snap __flatten_82__98@46@01)
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($SortWrappers.Seq<Int>To$Snap __flatten_84__100@47@01)
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($SortWrappers.$RefTo$Snap sys__result@48@01)
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@01))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))))
                                ($Snap.combine
                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))))
                                  ($Snap.combine
                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01)))))))))))
                                    ($Snap.combine
                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@01))))))))))))
                                      ($Snap.combine
                                        ($Snap.first ($Snap.second ($Snap.second $t@49@01)))
                                        ($Snap.combine
                                          $Snap.unit
                                          ($Snap.combine
                                            ($SortWrappers.$RefTo$Snap sys__result@50@01)
                                            ($Snap.combine
                                              $Snap.unit
                                              ($Snap.combine
                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@01)))))
                                                ($Snap.combine
                                                  ($SortWrappers.$RefTo$Snap sys__result@52@01)
                                                  ($Snap.combine
                                                    $Snap.unit
                                                    ($Snap.combine
                                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@01)))))
                                                      ($Snap.combine
                                                        ($SortWrappers.$RefTo$Snap sys__result@54@01)
                                                        ($Snap.combine
                                                          $Snap.unit
                                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@01)))))))))))))))))))))))))))))))))) diz__96@38@01 globals@23@01))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz__96, globals), write)
; [exec]
; sys__result := diz__96
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Main() && acc(sys__result.Main_adder_prc, wildcard) && sys__result.Main_adder_prc != null && acc(sys__result.Main_adder_prc.Prc_or_m, 1 / 2) && sys__result.Main_adder_prc.Prc_or_m == sys__result && acc(sys__result.Main_adder_prc.Prc_or_init, 1 / 2) && !sys__result.Main_adder_prc.Prc_or_init && acc(sys__result.Main_adder_half_adder1, wildcard) && sys__result.Main_adder_half_adder1 != null && acc(sys__result.Main_adder_half_adder1.Prc_half_adder_1_m, 1 / 2) && sys__result.Main_adder_half_adder1.Prc_half_adder_1_m == sys__result && acc(sys__result.Main_adder_half_adder1.Prc_half_adder_1_init, 1 / 2) && !sys__result.Main_adder_half_adder1.Prc_half_adder_1_init && acc(sys__result.Main_adder_half_adder2, wildcard) && sys__result.Main_adder_half_adder2 != null && acc(sys__result.Main_adder_half_adder2.Prc_half_adder_2_m, 1 / 2) && sys__result.Main_adder_half_adder2.Prc_half_adder_2_m == sys__result && acc(sys__result.Main_adder_half_adder2.Prc_half_adder_2_init, 1 / 2) && !sys__result.Main_adder_half_adder2.Prc_half_adder_2_init && acc(Prc_or_idleToken_EncodedGlobalVariables(sys__result.Main_adder_prc, globals), write) && acc(Prc_half_adder_1_idleToken_EncodedGlobalVariables(sys__result.Main_adder_half_adder1, globals), write) && acc(Prc_half_adder_2_idleToken_EncodedGlobalVariables(sys__result.Main_adder_half_adder2, globals), write)
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
(declare-const $k@62@01 $Perm)
(assert ($Perm.isReadVar $k@62@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@62@01 $Perm.No) (< $Perm.No $k@62@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               989
;  :arith-add-rows          98
;  :arith-assert-diseq      30
;  :arith-assert-lower      89
;  :arith-assert-upper      58
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               64
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 112
;  :datatype-occurs-check   60
;  :datatype-splits         42
;  :decisions               135
;  :del-clause              375
;  :final-checks            27
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.24
;  :memory                  4.24
;  :minimized-lits          2
;  :mk-bool-var             918
;  :mk-clause               388
;  :num-allocs              3852477
;  :num-checks              71
;  :propagations            128
;  :quant-instantiations    102
;  :rlimit-count            129864)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- $Perm.Write $k@59@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               989
;  :arith-add-rows          98
;  :arith-assert-diseq      30
;  :arith-assert-lower      89
;  :arith-assert-upper      58
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               65
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 112
;  :datatype-occurs-check   60
;  :datatype-splits         42
;  :decisions               135
;  :del-clause              375
;  :final-checks            27
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.24
;  :memory                  4.24
;  :minimized-lits          2
;  :mk-bool-var             919
;  :mk-clause               388
;  :num-allocs              3852477
;  :num-checks              72
;  :propagations            128
;  :quant-instantiations    102
;  :rlimit-count            129916)
(assert (< $k@62@01 (- $Perm.Write $k@59@01)))
(assert (<= $Perm.No (- (- $Perm.Write $k@59@01) $k@62@01)))
(assert (<= (- (- $Perm.Write $k@59@01) $k@62@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- $Perm.Write $k@59@01) $k@62@01))
  (not (= diz__96@38@01 $Ref.null))))
; [eval] sys__result.Main_adder_prc != null
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@59@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               989
;  :arith-add-rows          98
;  :arith-assert-diseq      30
;  :arith-assert-lower      90
;  :arith-assert-upper      60
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               65
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 112
;  :datatype-occurs-check   60
;  :datatype-splits         42
;  :decisions               135
;  :del-clause              375
;  :final-checks            27
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.24
;  :memory                  4.24
;  :minimized-lits          2
;  :mk-bool-var             922
;  :mk-clause               388
;  :num-allocs              3852477
;  :num-checks              73
;  :propagations            128
;  :quant-instantiations    102
;  :rlimit-count            130096)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               989
;  :arith-add-rows          98
;  :arith-assert-diseq      30
;  :arith-assert-lower      90
;  :arith-assert-upper      60
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               65
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 112
;  :datatype-occurs-check   60
;  :datatype-splits         42
;  :decisions               135
;  :del-clause              375
;  :final-checks            27
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.24
;  :memory                  4.24
;  :minimized-lits          2
;  :mk-bool-var             922
;  :mk-clause               388
;  :num-allocs              3852477
;  :num-checks              74
;  :propagations            128
;  :quant-instantiations    102
;  :rlimit-count            130109)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@59@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               989
;  :arith-add-rows          98
;  :arith-assert-diseq      30
;  :arith-assert-lower      90
;  :arith-assert-upper      60
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               65
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 112
;  :datatype-occurs-check   60
;  :datatype-splits         42
;  :decisions               135
;  :del-clause              375
;  :final-checks            27
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.24
;  :memory                  4.24
;  :minimized-lits          2
;  :mk-bool-var             922
;  :mk-clause               388
;  :num-allocs              3852477
;  :num-checks              75
;  :propagations            128
;  :quant-instantiations    102
;  :rlimit-count            130135)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1380
;  :arith-add-rows          98
;  :arith-assert-diseq      30
;  :arith-assert-lower      90
;  :arith-assert-upper      60
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               76
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 225
;  :datatype-occurs-check   387
;  :datatype-splits         116
;  :decisions               233
;  :del-clause              386
;  :final-checks            36
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          4
;  :mk-bool-var             1043
;  :mk-clause               399
;  :num-allocs              3984565
;  :num-checks              76
;  :propagations            132
;  :quant-instantiations    102
;  :rlimit-count            132084
;  :time                    0.00)
; [eval] sys__result.Main_adder_prc.Prc_or_m == sys__result
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@59@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1380
;  :arith-add-rows          98
;  :arith-assert-diseq      30
;  :arith-assert-lower      90
;  :arith-assert-upper      60
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               76
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 225
;  :datatype-occurs-check   387
;  :datatype-splits         116
;  :decisions               233
;  :del-clause              386
;  :final-checks            36
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          4
;  :mk-bool-var             1043
;  :mk-clause               399
;  :num-allocs              3984565
;  :num-checks              77
;  :propagations            132
;  :quant-instantiations    102
;  :rlimit-count            132110)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1380
;  :arith-add-rows          98
;  :arith-assert-diseq      30
;  :arith-assert-lower      90
;  :arith-assert-upper      60
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               76
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 225
;  :datatype-occurs-check   387
;  :datatype-splits         116
;  :decisions               233
;  :del-clause              386
;  :final-checks            36
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          4
;  :mk-bool-var             1043
;  :mk-clause               399
;  :num-allocs              3984565
;  :num-checks              78
;  :propagations            132
;  :quant-instantiations    102
;  :rlimit-count            132123)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@59@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1380
;  :arith-add-rows          98
;  :arith-assert-diseq      30
;  :arith-assert-lower      90
;  :arith-assert-upper      60
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               76
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 225
;  :datatype-occurs-check   387
;  :datatype-splits         116
;  :decisions               233
;  :del-clause              386
;  :final-checks            36
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          4
;  :mk-bool-var             1043
;  :mk-clause               399
;  :num-allocs              3984565
;  :num-checks              79
;  :propagations            132
;  :quant-instantiations    102
;  :rlimit-count            132149)
; [eval] !sys__result.Main_adder_prc.Prc_or_init
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@59@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1380
;  :arith-add-rows          98
;  :arith-assert-diseq      30
;  :arith-assert-lower      90
;  :arith-assert-upper      60
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               76
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 225
;  :datatype-occurs-check   387
;  :datatype-splits         116
;  :decisions               233
;  :del-clause              386
;  :final-checks            36
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          4
;  :mk-bool-var             1043
;  :mk-clause               399
;  :num-allocs              3984565
;  :num-checks              80
;  :propagations            132
;  :quant-instantiations    102
;  :rlimit-count            132175)
(declare-const $k@63@01 $Perm)
(assert ($Perm.isReadVar $k@63@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@63@01 $Perm.No) (< $Perm.No $k@63@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1380
;  :arith-add-rows          98
;  :arith-assert-diseq      31
;  :arith-assert-lower      92
;  :arith-assert-upper      61
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               77
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 225
;  :datatype-occurs-check   387
;  :datatype-splits         116
;  :decisions               233
;  :del-clause              386
;  :final-checks            36
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          4
;  :mk-bool-var             1047
;  :mk-clause               401
;  :num-allocs              3984565
;  :num-checks              81
;  :propagations            133
;  :quant-instantiations    102
;  :rlimit-count            132374)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- $Perm.Write $k@60@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1380
;  :arith-add-rows          98
;  :arith-assert-diseq      31
;  :arith-assert-lower      92
;  :arith-assert-upper      61
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               78
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 225
;  :datatype-occurs-check   387
;  :datatype-splits         116
;  :decisions               233
;  :del-clause              386
;  :final-checks            36
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          4
;  :mk-bool-var             1048
;  :mk-clause               401
;  :num-allocs              3984565
;  :num-checks              82
;  :propagations            133
;  :quant-instantiations    102
;  :rlimit-count            132426)
(assert (< $k@63@01 (- $Perm.Write $k@60@01)))
(assert (<= $Perm.No (- (- $Perm.Write $k@60@01) $k@63@01)))
(assert (<= (- (- $Perm.Write $k@60@01) $k@63@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- $Perm.Write $k@60@01) $k@63@01))
  (not (= diz__96@38@01 $Ref.null))))
; [eval] sys__result.Main_adder_half_adder1 != null
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@60@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1380
;  :arith-add-rows          98
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      63
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               78
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 225
;  :datatype-occurs-check   387
;  :datatype-splits         116
;  :decisions               233
;  :del-clause              386
;  :final-checks            36
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          4
;  :mk-bool-var             1051
;  :mk-clause               401
;  :num-allocs              3984565
;  :num-checks              83
;  :propagations            133
;  :quant-instantiations    102
;  :rlimit-count            132606)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1380
;  :arith-add-rows          98
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      63
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               78
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 225
;  :datatype-occurs-check   387
;  :datatype-splits         116
;  :decisions               233
;  :del-clause              386
;  :final-checks            36
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          4
;  :mk-bool-var             1051
;  :mk-clause               401
;  :num-allocs              3984565
;  :num-checks              84
;  :propagations            133
;  :quant-instantiations    102
;  :rlimit-count            132619)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@60@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1380
;  :arith-add-rows          98
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      63
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               78
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 225
;  :datatype-occurs-check   387
;  :datatype-splits         116
;  :decisions               233
;  :del-clause              386
;  :final-checks            36
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          4
;  :mk-bool-var             1051
;  :mk-clause               401
;  :num-allocs              3984565
;  :num-checks              85
;  :propagations            133
;  :quant-instantiations    102
;  :rlimit-count            132645)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1771
;  :arith-add-rows          98
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      63
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               89
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   714
;  :datatype-splits         190
;  :decisions               331
;  :del-clause              397
;  :final-checks            45
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          6
;  :mk-bool-var             1172
;  :mk-clause               412
;  :num-allocs              3984565
;  :num-checks              86
;  :propagations            137
;  :quant-instantiations    102
;  :rlimit-count            134600
;  :time                    0.00)
; [eval] sys__result.Main_adder_half_adder1.Prc_half_adder_1_m == sys__result
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@60@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1771
;  :arith-add-rows          98
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      63
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               89
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   714
;  :datatype-splits         190
;  :decisions               331
;  :del-clause              397
;  :final-checks            45
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          6
;  :mk-bool-var             1172
;  :mk-clause               412
;  :num-allocs              3984565
;  :num-checks              87
;  :propagations            137
;  :quant-instantiations    102
;  :rlimit-count            134626)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1771
;  :arith-add-rows          98
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      63
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               89
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   714
;  :datatype-splits         190
;  :decisions               331
;  :del-clause              397
;  :final-checks            45
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          6
;  :mk-bool-var             1172
;  :mk-clause               412
;  :num-allocs              3984565
;  :num-checks              88
;  :propagations            137
;  :quant-instantiations    102
;  :rlimit-count            134639)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@60@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1771
;  :arith-add-rows          98
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      63
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               89
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   714
;  :datatype-splits         190
;  :decisions               331
;  :del-clause              397
;  :final-checks            45
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          6
;  :mk-bool-var             1172
;  :mk-clause               412
;  :num-allocs              3984565
;  :num-checks              89
;  :propagations            137
;  :quant-instantiations    102
;  :rlimit-count            134665)
; [eval] !sys__result.Main_adder_half_adder1.Prc_half_adder_1_init
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@60@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1771
;  :arith-add-rows          98
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      63
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               89
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   714
;  :datatype-splits         190
;  :decisions               331
;  :del-clause              397
;  :final-checks            45
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          6
;  :mk-bool-var             1172
;  :mk-clause               412
;  :num-allocs              3984565
;  :num-checks              90
;  :propagations            137
;  :quant-instantiations    102
;  :rlimit-count            134691)
(declare-const $k@64@01 $Perm)
(assert ($Perm.isReadVar $k@64@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@64@01 $Perm.No) (< $Perm.No $k@64@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1771
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      95
;  :arith-assert-upper      64
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               90
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   714
;  :datatype-splits         190
;  :decisions               331
;  :del-clause              397
;  :final-checks            45
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          6
;  :mk-bool-var             1176
;  :mk-clause               414
;  :num-allocs              3984565
;  :num-checks              91
;  :propagations            138
;  :quant-instantiations    102
;  :rlimit-count            134890)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- $Perm.Write $k@61@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1771
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      95
;  :arith-assert-upper      64
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               91
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   714
;  :datatype-splits         190
;  :decisions               331
;  :del-clause              397
;  :final-checks            45
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          6
;  :mk-bool-var             1177
;  :mk-clause               414
;  :num-allocs              3984565
;  :num-checks              92
;  :propagations            138
;  :quant-instantiations    102
;  :rlimit-count            134942)
(assert (< $k@64@01 (- $Perm.Write $k@61@01)))
(assert (<= $Perm.No (- (- $Perm.Write $k@61@01) $k@64@01)))
(assert (<= (- (- $Perm.Write $k@61@01) $k@64@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- $Perm.Write $k@61@01) $k@64@01))
  (not (= diz__96@38@01 $Ref.null))))
; [eval] sys__result.Main_adder_half_adder2 != null
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@61@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1771
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               91
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   714
;  :datatype-splits         190
;  :decisions               331
;  :del-clause              397
;  :final-checks            45
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          6
;  :mk-bool-var             1180
;  :mk-clause               414
;  :num-allocs              3984565
;  :num-checks              93
;  :propagations            138
;  :quant-instantiations    102
;  :rlimit-count            135122)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1771
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               91
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   714
;  :datatype-splits         190
;  :decisions               331
;  :del-clause              397
;  :final-checks            45
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          6
;  :mk-bool-var             1180
;  :mk-clause               414
;  :num-allocs              3984565
;  :num-checks              94
;  :propagations            138
;  :quant-instantiations    102
;  :rlimit-count            135135)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@61@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1771
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               91
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   714
;  :datatype-splits         190
;  :decisions               331
;  :del-clause              397
;  :final-checks            45
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          6
;  :mk-bool-var             1180
;  :mk-clause               414
;  :num-allocs              3984565
;  :num-checks              95
;  :propagations            138
;  :quant-instantiations    102
;  :rlimit-count            135161)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2162
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 451
;  :datatype-occurs-check   1041
;  :datatype-splits         264
;  :decisions               429
;  :del-clause              408
;  :final-checks            54
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1301
;  :mk-clause               425
;  :num-allocs              3984565
;  :num-checks              96
;  :propagations            142
;  :quant-instantiations    102
;  :rlimit-count            137122
;  :time                    0.00)
; [eval] sys__result.Main_adder_half_adder2.Prc_half_adder_2_m == sys__result
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@61@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2162
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 451
;  :datatype-occurs-check   1041
;  :datatype-splits         264
;  :decisions               429
;  :del-clause              408
;  :final-checks            54
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1301
;  :mk-clause               425
;  :num-allocs              3984565
;  :num-checks              97
;  :propagations            142
;  :quant-instantiations    102
;  :rlimit-count            137148)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2162
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 451
;  :datatype-occurs-check   1041
;  :datatype-splits         264
;  :decisions               429
;  :del-clause              408
;  :final-checks            54
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1301
;  :mk-clause               425
;  :num-allocs              3984565
;  :num-checks              98
;  :propagations            142
;  :quant-instantiations    102
;  :rlimit-count            137161)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@61@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2162
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 451
;  :datatype-occurs-check   1041
;  :datatype-splits         264
;  :decisions               429
;  :del-clause              408
;  :final-checks            54
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1301
;  :mk-clause               425
;  :num-allocs              3984565
;  :num-checks              99
;  :propagations            142
;  :quant-instantiations    102
;  :rlimit-count            137187)
; [eval] !sys__result.Main_adder_half_adder2.Prc_half_adder_2_init
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@61@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2162
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 451
;  :datatype-occurs-check   1041
;  :datatype-splits         264
;  :decisions               429
;  :del-clause              408
;  :final-checks            54
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1301
;  :mk-clause               425
;  :num-allocs              3984565
;  :num-checks              100
;  :propagations            142
;  :quant-instantiations    102
;  :rlimit-count            137213)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@59@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2162
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 451
;  :datatype-occurs-check   1041
;  :datatype-splits         264
;  :decisions               429
;  :del-clause              408
;  :final-checks            54
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1301
;  :mk-clause               425
;  :num-allocs              3984565
;  :num-checks              101
;  :propagations            142
;  :quant-instantiations    102
;  :rlimit-count            137239)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@60@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2162
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 451
;  :datatype-occurs-check   1041
;  :datatype-splits         264
;  :decisions               429
;  :del-clause              408
;  :final-checks            54
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1301
;  :mk-clause               425
;  :num-allocs              3984565
;  :num-checks              102
;  :propagations            142
;  :quant-instantiations    102
;  :rlimit-count            137265)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@61@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2162
;  :arith-add-rows          98
;  :arith-assert-diseq      32
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 451
;  :datatype-occurs-check   1041
;  :datatype-splits         264
;  :decisions               429
;  :del-clause              408
;  :final-checks            54
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1301
;  :mk-clause               425
;  :num-allocs              3984565
;  :num-checks              103
;  :propagations            142
;  :quant-instantiations    102
;  :rlimit-count            137291)
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main_reset_all_events_EncodedGlobalVariables ----------
(declare-const diz@65@01 $Ref)
(declare-const globals@66@01 $Ref)
(declare-const diz@67@01 $Ref)
(declare-const globals@68@01 $Ref)
(push) ; 1
(declare-const $t@69@01 $Snap)
(assert (= $t@69@01 ($Snap.combine ($Snap.first $t@69@01) ($Snap.second $t@69@01))))
(assert (= ($Snap.first $t@69@01) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@67@01 $Ref.null)))
(assert (=
  ($Snap.second $t@69@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@69@01))
    ($Snap.second ($Snap.second $t@69@01)))))
(assert (=
  ($Snap.second ($Snap.second $t@69@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@69@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@69@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@69@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@69@01))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01)))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01)))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@70@01 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 4 | 0 <= i@70@01 | live]
; [else-branch: 4 | !(0 <= i@70@01) | live]
(push) ; 4
; [then-branch: 4 | 0 <= i@70@01]
(assert (<= 0 i@70@01))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 4 | !(0 <= i@70@01)]
(assert (not (<= 0 i@70@01)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 5 | i@70@01 < |First:(Second:(Second:($t@69@01)))| && 0 <= i@70@01 | live]
; [else-branch: 5 | !(i@70@01 < |First:(Second:(Second:($t@69@01)))| && 0 <= i@70@01) | live]
(push) ; 4
; [then-branch: 5 | i@70@01 < |First:(Second:(Second:($t@69@01)))| && 0 <= i@70@01]
(assert (and
  (<
    i@70@01
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))))
  (<= 0 i@70@01)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@70@01 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2200
;  :arith-add-rows          100
;  :arith-assert-diseq      34
;  :arith-assert-lower      103
;  :arith-assert-upper      69
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    157
;  :datatype-constructor-ax 451
;  :datatype-occurs-check   1041
;  :datatype-splits         264
;  :decisions               429
;  :del-clause              424
;  :final-checks            54
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1330
;  :mk-clause               431
;  :num-allocs              3984565
;  :num-checks              104
;  :propagations            144
;  :quant-instantiations    108
;  :rlimit-count            138501)
; [eval] -1
(push) ; 5
; [then-branch: 6 | First:(Second:(Second:($t@69@01)))[i@70@01] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:($t@69@01)))[i@70@01] != -1 | live]
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:($t@69@01)))[i@70@01] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))
    i@70@01)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 6 | First:(Second:(Second:($t@69@01)))[i@70@01] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))
      i@70@01)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@70@01 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2200
;  :arith-add-rows          100
;  :arith-assert-diseq      34
;  :arith-assert-lower      103
;  :arith-assert-upper      69
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    157
;  :datatype-constructor-ax 451
;  :datatype-occurs-check   1041
;  :datatype-splits         264
;  :decisions               429
;  :del-clause              424
;  :final-checks            54
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1331
;  :mk-clause               431
;  :num-allocs              3984565
;  :num-checks              105
;  :propagations            144
;  :quant-instantiations    108
;  :rlimit-count            138664)
(push) ; 7
; [then-branch: 7 | 0 <= First:(Second:(Second:($t@69@01)))[i@70@01] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:($t@69@01)))[i@70@01]) | live]
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:($t@69@01)))[i@70@01]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))
    i@70@01)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@70@01 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2200
;  :arith-add-rows          100
;  :arith-assert-diseq      35
;  :arith-assert-lower      106
;  :arith-assert-upper      69
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    157
;  :datatype-constructor-ax 451
;  :datatype-occurs-check   1041
;  :datatype-splits         264
;  :decisions               429
;  :del-clause              424
;  :final-checks            54
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1334
;  :mk-clause               432
;  :num-allocs              3984565
;  :num-checks              106
;  :propagations            144
;  :quant-instantiations    108
;  :rlimit-count            138778)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 7 | !(0 <= First:(Second:(Second:($t@69@01)))[i@70@01])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))
      i@70@01))))
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
; [else-branch: 5 | !(i@70@01 < |First:(Second:(Second:($t@69@01)))| && 0 <= i@70@01)]
(assert (not
  (and
    (<
      i@70@01
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))))
    (<= 0 i@70@01))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@70@01 Int)) (!
  (implies
    (and
      (<
        i@70@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))))
      (<= 0 i@70@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))
          i@70@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))
            i@70@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))
            i@70@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))
    i@70@01))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@71@01 $Snap)
(assert (= $t@71@01 ($Snap.combine ($Snap.first $t@71@01) ($Snap.second $t@71@01))))
(assert (=
  ($Snap.second $t@71@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@71@01))
    ($Snap.second ($Snap.second $t@71@01)))))
(assert (=
  ($Snap.second ($Snap.second $t@71@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@71@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@71@01))) $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@71@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@72@01 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 8 | 0 <= i@72@01 | live]
; [else-branch: 8 | !(0 <= i@72@01) | live]
(push) ; 5
; [then-branch: 8 | 0 <= i@72@01]
(assert (<= 0 i@72@01))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 8 | !(0 <= i@72@01)]
(assert (not (<= 0 i@72@01)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 9 | i@72@01 < |First:(Second:($t@71@01))| && 0 <= i@72@01 | live]
; [else-branch: 9 | !(i@72@01 < |First:(Second:($t@71@01))| && 0 <= i@72@01) | live]
(push) ; 5
; [then-branch: 9 | i@72@01 < |First:(Second:($t@71@01))| && 0 <= i@72@01]
(assert (and
  (<
    i@72@01
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))))
  (<= 0 i@72@01)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@72@01 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2255
;  :arith-add-rows          100
;  :arith-assert-diseq      35
;  :arith-assert-lower      111
;  :arith-assert-upper      72
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               103
;  :datatype-accessor-ax    164
;  :datatype-constructor-ax 457
;  :datatype-occurs-check   1044
;  :datatype-splits         269
;  :decisions               434
;  :del-clause              431
;  :final-checks            57
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1362
;  :mk-clause               433
;  :num-allocs              3984565
;  :num-checks              108
;  :propagations            144
;  :quant-instantiations    112
;  :rlimit-count            140546)
; [eval] -1
(push) ; 6
; [then-branch: 10 | First:(Second:($t@71@01))[i@72@01] == -1 | live]
; [else-branch: 10 | First:(Second:($t@71@01))[i@72@01] != -1 | live]
(push) ; 7
; [then-branch: 10 | First:(Second:($t@71@01))[i@72@01] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))
    i@72@01)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 10 | First:(Second:($t@71@01))[i@72@01] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))
      i@72@01)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@72@01 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2255
;  :arith-add-rows          100
;  :arith-assert-diseq      35
;  :arith-assert-lower      111
;  :arith-assert-upper      72
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               103
;  :datatype-accessor-ax    164
;  :datatype-constructor-ax 457
;  :datatype-occurs-check   1044
;  :datatype-splits         269
;  :decisions               434
;  :del-clause              431
;  :final-checks            57
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1363
;  :mk-clause               433
;  :num-allocs              3984565
;  :num-checks              109
;  :propagations            144
;  :quant-instantiations    112
;  :rlimit-count            140697)
(push) ; 8
; [then-branch: 11 | 0 <= First:(Second:($t@71@01))[i@72@01] | live]
; [else-branch: 11 | !(0 <= First:(Second:($t@71@01))[i@72@01]) | live]
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:($t@71@01))[i@72@01]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))
    i@72@01)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@72@01 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2255
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      114
;  :arith-assert-upper      72
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               103
;  :datatype-accessor-ax    164
;  :datatype-constructor-ax 457
;  :datatype-occurs-check   1044
;  :datatype-splits         269
;  :decisions               434
;  :del-clause              431
;  :final-checks            57
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1366
;  :mk-clause               434
;  :num-allocs              3984565
;  :num-checks              110
;  :propagations            144
;  :quant-instantiations    112
;  :rlimit-count            140800)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 11 | !(0 <= First:(Second:($t@71@01))[i@72@01])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))
      i@72@01))))
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
; [else-branch: 9 | !(i@72@01 < |First:(Second:($t@71@01))| && 0 <= i@72@01)]
(assert (not
  (and
    (<
      i@72@01
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))))
    (<= 0 i@72@01))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@72@01 Int)) (!
  (implies
    (and
      (<
        i@72@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))))
      (<= 0 i@72@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))
          i@72@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))
            i@72@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))
            i@72@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))
    i@72@01))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@71@01)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@69@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2272
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               103
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 457
;  :datatype-occurs-check   1044
;  :datatype-splits         269
;  :decisions               434
;  :del-clause              432
;  :final-checks            57
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1385
;  :mk-clause               445
;  :num-allocs              3984565
;  :num-checks              111
;  :propagations            148
;  :quant-instantiations    114
;  :rlimit-count            141825)
(push) ; 3
; [then-branch: 12 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0 | live]
; [else-branch: 12 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] != 0 | live]
(push) ; 4
; [then-branch: 12 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    0)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 12 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2272
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               103
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 457
;  :datatype-occurs-check   1044
;  :datatype-splits         269
;  :decisions               434
;  :del-clause              432
;  :final-checks            57
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1386
;  :mk-clause               445
;  :num-allocs              3984565
;  :num-checks              112
;  :propagations            148
;  :quant-instantiations    114
;  :rlimit-count            142010)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2310
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               104
;  :datatype-accessor-ax    168
;  :datatype-constructor-ax 469
;  :datatype-occurs-check   1050
;  :datatype-splits         280
;  :decisions               446
;  :del-clause              434
;  :final-checks            60
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1403
;  :mk-clause               447
;  :num-allocs              3984565
;  :num-checks              113
;  :propagations            149
;  :quant-instantiations    114
;  :rlimit-count            142637)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2346
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               105
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 481
;  :datatype-occurs-check   1056
;  :datatype-splits         287
;  :decisions               456
;  :del-clause              435
;  :final-checks            63
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1415
;  :mk-clause               448
;  :num-allocs              3984565
;  :num-checks              114
;  :propagations            150
;  :quant-instantiations    114
;  :rlimit-count            143255
;  :time                    0.00)
; [then-branch: 13 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == -1 | live]
; [else-branch: 13 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == -1) | live]
(push) ; 4
; [then-branch: 13 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2346
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               105
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 481
;  :datatype-occurs-check   1056
;  :datatype-splits         287
;  :decisions               456
;  :del-clause              435
;  :final-checks            63
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1417
;  :mk-clause               449
;  :num-allocs              3984565
;  :num-checks              115
;  :propagations            150
;  :quant-instantiations    114
;  :rlimit-count            143414)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 13 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        0)
      (- 0 1)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2352
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               105
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 481
;  :datatype-occurs-check   1056
;  :datatype-splits         287
;  :decisions               456
;  :del-clause              436
;  :final-checks            63
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1423
;  :mk-clause               453
;  :num-allocs              3984565
;  :num-checks              116
;  :propagations            150
;  :quant-instantiations    114
;  :rlimit-count            143909)
(push) ; 3
; [then-branch: 14 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0 | live]
; [else-branch: 14 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] != 0 | live]
(push) ; 4
; [then-branch: 14 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    1)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 14 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2352
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               105
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 481
;  :datatype-occurs-check   1056
;  :datatype-splits         287
;  :decisions               456
;  :del-clause              436
;  :final-checks            63
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1424
;  :mk-clause               453
;  :num-allocs              3984565
;  :num-checks              117
;  :propagations            150
;  :quant-instantiations    114
;  :rlimit-count            144090)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2391
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               106
;  :datatype-accessor-ax    173
;  :datatype-constructor-ax 493
;  :datatype-occurs-check   1062
;  :datatype-splits         298
;  :decisions               470
;  :del-clause              438
;  :final-checks            66
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1441
;  :mk-clause               455
;  :num-allocs              3984565
;  :num-checks              118
;  :propagations            155
;  :quant-instantiations    114
;  :rlimit-count            144753)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2428
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               107
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 505
;  :datatype-occurs-check   1068
;  :datatype-splits         309
;  :decisions               482
;  :del-clause              439
;  :final-checks            69
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1458
;  :mk-clause               456
;  :num-allocs              3984565
;  :num-checks              119
;  :propagations            160
;  :quant-instantiations    114
;  :rlimit-count            145407
;  :time                    0.00)
; [then-branch: 15 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == -1 | live]
; [else-branch: 15 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == -1) | live]
(push) ; 4
; [then-branch: 15 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2428
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               107
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 505
;  :datatype-occurs-check   1068
;  :datatype-splits         309
;  :decisions               482
;  :del-clause              439
;  :final-checks            69
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1460
;  :mk-clause               457
;  :num-allocs              3984565
;  :num-checks              120
;  :propagations            160
;  :quant-instantiations    114
;  :rlimit-count            145566)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 15 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        1)
      (- 0 1)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1 ==> diz.Main_event_state[2] == -2
; [eval] old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 3
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2434
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               107
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 505
;  :datatype-occurs-check   1068
;  :datatype-splits         309
;  :decisions               482
;  :del-clause              440
;  :final-checks            69
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1466
;  :mk-clause               461
;  :num-allocs              3984565
;  :num-checks              121
;  :propagations            160
;  :quant-instantiations    114
;  :rlimit-count            146067)
(push) ; 3
; [then-branch: 16 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0 | live]
; [else-branch: 16 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] != 0 | live]
(push) ; 4
; [then-branch: 16 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    2)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 16 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2434
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               107
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 505
;  :datatype-occurs-check   1068
;  :datatype-splits         309
;  :decisions               482
;  :del-clause              440
;  :final-checks            69
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1467
;  :mk-clause               461
;  :num-allocs              3984565
;  :num-checks              122
;  :propagations            160
;  :quant-instantiations    114
;  :rlimit-count            146248)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2474
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               108
;  :datatype-accessor-ax    178
;  :datatype-constructor-ax 517
;  :datatype-occurs-check   1074
;  :datatype-splits         320
;  :decisions               498
;  :del-clause              442
;  :final-checks            72
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1484
;  :mk-clause               463
;  :num-allocs              3984565
;  :num-checks              123
;  :propagations            169
;  :quant-instantiations    114
;  :rlimit-count            146947
;  :time                    0.00)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2512
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               109
;  :datatype-accessor-ax    180
;  :datatype-constructor-ax 529
;  :datatype-occurs-check   1080
;  :datatype-splits         331
;  :decisions               512
;  :del-clause              443
;  :final-checks            75
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1501
;  :mk-clause               464
;  :num-allocs              3984565
;  :num-checks              124
;  :propagations            178
;  :quant-instantiations    114
;  :rlimit-count            147637
;  :time                    0.00)
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == -1 | live]
; [else-branch: 17 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == -1) | live]
(push) ; 4
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      2)
    (- 0 1))))
; [eval] diz.Main_event_state[2] == -2
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2512
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               109
;  :datatype-accessor-ax    180
;  :datatype-constructor-ax 529
;  :datatype-occurs-check   1080
;  :datatype-splits         331
;  :decisions               512
;  :del-clause              443
;  :final-checks            75
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1503
;  :mk-clause               465
;  :num-allocs              3984565
;  :num-checks              125
;  :propagations            178
;  :quant-instantiations    114
;  :rlimit-count            147796)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 17 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        2)
      (- 0 1)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        2)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      2)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[3]) == 0 || old(diz.Main_event_state[3]) == -1 ==> diz.Main_event_state[3] == -2
; [eval] old(diz.Main_event_state[3]) == 0 || old(diz.Main_event_state[3]) == -1
; [eval] old(diz.Main_event_state[3]) == 0
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 3
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2518
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               109
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 529
;  :datatype-occurs-check   1080
;  :datatype-splits         331
;  :decisions               512
;  :del-clause              444
;  :final-checks            75
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1509
;  :mk-clause               469
;  :num-allocs              3984565
;  :num-checks              126
;  :propagations            178
;  :quant-instantiations    114
;  :rlimit-count            148307)
(push) ; 3
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] != 0 | live]
(push) ; 4
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    3)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 18 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      3)
    0)))
; [eval] old(diz.Main_event_state[3]) == -1
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2518
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               109
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 529
;  :datatype-occurs-check   1080
;  :datatype-splits         331
;  :decisions               512
;  :del-clause              444
;  :final-checks            75
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1510
;  :mk-clause               469
;  :num-allocs              3984565
;  :num-checks              127
;  :propagations            178
;  :quant-instantiations    114
;  :rlimit-count            148488)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        3)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        3)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2559
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               110
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 541
;  :datatype-occurs-check   1086
;  :datatype-splits         342
;  :decisions               530
;  :del-clause              446
;  :final-checks            78
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1527
;  :mk-clause               471
;  :num-allocs              3984565
;  :num-checks              128
;  :propagations            191
;  :quant-instantiations    114
;  :rlimit-count            149223)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      3)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      3)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2598
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               111
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 553
;  :datatype-occurs-check   1092
;  :datatype-splits         353
;  :decisions               546
;  :del-clause              447
;  :final-checks            81
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1544
;  :mk-clause               472
;  :num-allocs              3984565
;  :num-checks              129
;  :propagations            204
;  :quant-instantiations    114
;  :rlimit-count            149949)
; [then-branch: 19 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == -1 | live]
; [else-branch: 19 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == -1) | live]
(push) ; 4
; [then-branch: 19 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      3)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      3)
    (- 0 1))))
; [eval] diz.Main_event_state[3] == -2
; [eval] diz.Main_event_state[3]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2598
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               111
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 553
;  :datatype-occurs-check   1092
;  :datatype-splits         353
;  :decisions               546
;  :del-clause              447
;  :final-checks            81
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1546
;  :mk-clause               473
;  :num-allocs              3984565
;  :num-checks              130
;  :propagations            204
;  :quant-instantiations    114
;  :rlimit-count            150108)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 19 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        3)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        3)
      (- 0 1)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        3)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        3)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      3)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[4]) == 0 || old(diz.Main_event_state[4]) == -1 ==> diz.Main_event_state[4] == -2
; [eval] old(diz.Main_event_state[4]) == 0 || old(diz.Main_event_state[4]) == -1
; [eval] old(diz.Main_event_state[4]) == 0
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 3
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2604
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               111
;  :datatype-accessor-ax    186
;  :datatype-constructor-ax 553
;  :datatype-occurs-check   1092
;  :datatype-splits         353
;  :decisions               546
;  :del-clause              448
;  :final-checks            81
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1552
;  :mk-clause               477
;  :num-allocs              3984565
;  :num-checks              131
;  :propagations            204
;  :quant-instantiations    114
;  :rlimit-count            150629)
(push) ; 3
; [then-branch: 20 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0 | live]
; [else-branch: 20 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] != 0 | live]
(push) ; 4
; [then-branch: 20 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    4)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 20 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      4)
    0)))
; [eval] old(diz.Main_event_state[4]) == -1
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2604
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               111
;  :datatype-accessor-ax    186
;  :datatype-constructor-ax 553
;  :datatype-occurs-check   1092
;  :datatype-splits         353
;  :decisions               546
;  :del-clause              448
;  :final-checks            81
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1553
;  :mk-clause               477
;  :num-allocs              3984565
;  :num-checks              132
;  :propagations            204
;  :quant-instantiations    114
;  :rlimit-count            150810)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        4)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        4)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2646
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               112
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 565
;  :datatype-occurs-check   1098
;  :datatype-splits         364
;  :decisions               566
;  :del-clause              450
;  :final-checks            84
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1570
;  :mk-clause               479
;  :num-allocs              3984565
;  :num-checks              133
;  :propagations            221
;  :quant-instantiations    114
;  :rlimit-count            151581)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      4)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      4)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2686
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               113
;  :datatype-accessor-ax    190
;  :datatype-constructor-ax 577
;  :datatype-occurs-check   1104
;  :datatype-splits         375
;  :decisions               584
;  :del-clause              451
;  :final-checks            87
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1587
;  :mk-clause               480
;  :num-allocs              3984565
;  :num-checks              134
;  :propagations            238
;  :quant-instantiations    114
;  :rlimit-count            152343
;  :time                    0.00)
; [then-branch: 21 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == -1 | live]
; [else-branch: 21 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == -1) | live]
(push) ; 4
; [then-branch: 21 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      4)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      4)
    (- 0 1))))
; [eval] diz.Main_event_state[4] == -2
; [eval] diz.Main_event_state[4]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2686
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               113
;  :datatype-accessor-ax    190
;  :datatype-constructor-ax 577
;  :datatype-occurs-check   1104
;  :datatype-splits         375
;  :decisions               584
;  :del-clause              451
;  :final-checks            87
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1589
;  :mk-clause               481
;  :num-allocs              3984565
;  :num-checks              135
;  :propagations            238
;  :quant-instantiations    114
;  :rlimit-count            152502)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 21 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        4)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        4)
      (- 0 1)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        4)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        4)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      4)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[5]) == 0 || old(diz.Main_event_state[5]) == -1 ==> diz.Main_event_state[5] == -2
; [eval] old(diz.Main_event_state[5]) == 0 || old(diz.Main_event_state[5]) == -1
; [eval] old(diz.Main_event_state[5]) == 0
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 3
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2692
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               113
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 577
;  :datatype-occurs-check   1104
;  :datatype-splits         375
;  :decisions               584
;  :del-clause              452
;  :final-checks            87
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1595
;  :mk-clause               485
;  :num-allocs              3984565
;  :num-checks              136
;  :propagations            238
;  :quant-instantiations    114
;  :rlimit-count            153033)
(push) ; 3
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0 | live]
; [else-branch: 22 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] != 0 | live]
(push) ; 4
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    5)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 22 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      5)
    0)))
; [eval] old(diz.Main_event_state[5]) == -1
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2692
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               113
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 577
;  :datatype-occurs-check   1104
;  :datatype-splits         375
;  :decisions               584
;  :del-clause              452
;  :final-checks            87
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1596
;  :mk-clause               485
;  :num-allocs              3984565
;  :num-checks              137
;  :propagations            238
;  :quant-instantiations    114
;  :rlimit-count            153214)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        5)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        5)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2735
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               114
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 589
;  :datatype-occurs-check   1110
;  :datatype-splits         386
;  :decisions               606
;  :del-clause              454
;  :final-checks            90
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1613
;  :mk-clause               487
;  :num-allocs              3984565
;  :num-checks              138
;  :propagations            259
;  :quant-instantiations    114
;  :rlimit-count            154021
;  :time                    0.00)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      5)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      5)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2776
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               115
;  :datatype-accessor-ax    195
;  :datatype-constructor-ax 601
;  :datatype-occurs-check   1116
;  :datatype-splits         397
;  :decisions               626
;  :del-clause              455
;  :final-checks            93
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1630
;  :mk-clause               488
;  :num-allocs              3984565
;  :num-checks              139
;  :propagations            280
;  :quant-instantiations    114
;  :rlimit-count            154819)
; [then-branch: 23 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == -1 | live]
; [else-branch: 23 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == -1) | live]
(push) ; 4
; [then-branch: 23 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      5)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      5)
    (- 0 1))))
; [eval] diz.Main_event_state[5] == -2
; [eval] diz.Main_event_state[5]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2776
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               115
;  :datatype-accessor-ax    195
;  :datatype-constructor-ax 601
;  :datatype-occurs-check   1116
;  :datatype-splits         397
;  :decisions               626
;  :del-clause              455
;  :final-checks            93
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1632
;  :mk-clause               489
;  :num-allocs              3984565
;  :num-checks              140
;  :propagations            280
;  :quant-instantiations    114
;  :rlimit-count            154978)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 23 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        5)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        5)
      (- 0 1)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        5)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        5)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      5)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1) ==> diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1)
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2782
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               115
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 601
;  :datatype-occurs-check   1116
;  :datatype-splits         397
;  :decisions               626
;  :del-clause              456
;  :final-checks            93
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1638
;  :mk-clause               493
;  :num-allocs              3984565
;  :num-checks              141
;  :propagations            280
;  :quant-instantiations    114
;  :rlimit-count            155519)
(push) ; 3
; [then-branch: 24 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0 | live]
; [else-branch: 24 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] != 0 | live]
(push) ; 4
; [then-branch: 24 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    0)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 24 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2782
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               115
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 601
;  :datatype-occurs-check   1116
;  :datatype-splits         397
;  :decisions               626
;  :del-clause              456
;  :final-checks            93
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1638
;  :mk-clause               493
;  :num-allocs              3984565
;  :num-checks              142
;  :propagations            280
;  :quant-instantiations    114
;  :rlimit-count            155684)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2824
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               116
;  :datatype-accessor-ax    198
;  :datatype-constructor-ax 613
;  :datatype-occurs-check   1122
;  :datatype-splits         408
;  :decisions               646
;  :del-clause              457
;  :final-checks            96
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1653
;  :mk-clause               494
;  :num-allocs              3984565
;  :num-checks              143
;  :propagations            302
;  :quant-instantiations    114
;  :rlimit-count            156488
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2875
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               119
;  :datatype-accessor-ax    201
;  :datatype-constructor-ax 628
;  :datatype-occurs-check   1130
;  :datatype-splits         421
;  :decisions               671
;  :del-clause              460
;  :final-checks            100
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1677
;  :mk-clause               497
;  :num-allocs              3984565
;  :num-checks              144
;  :propagations            326
;  :quant-instantiations    114
;  :rlimit-count            157348
;  :time                    0.00)
; [then-branch: 25 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == -1) | live]
; [else-branch: 25 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == -1 | live]
(push) ; 4
; [then-branch: 25 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2875
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               119
;  :datatype-accessor-ax    201
;  :datatype-constructor-ax 628
;  :datatype-occurs-check   1130
;  :datatype-splits         421
;  :decisions               671
;  :del-clause              460
;  :final-checks            100
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1677
;  :mk-clause               497
;  :num-allocs              3984565
;  :num-checks              145
;  :propagations            327
;  :quant-instantiations    114
;  :rlimit-count            157532)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2875
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               119
;  :datatype-accessor-ax    201
;  :datatype-constructor-ax 628
;  :datatype-occurs-check   1130
;  :datatype-splits         421
;  :decisions               671
;  :del-clause              460
;  :final-checks            100
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1677
;  :mk-clause               497
;  :num-allocs              3984565
;  :num-checks              146
;  :propagations            327
;  :quant-instantiations    114
;  :rlimit-count            157547)
(pop) ; 4
(push) ; 4
; [else-branch: 25 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      0)
    (- 0 1))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1) ==> diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1)
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2881
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               119
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 628
;  :datatype-occurs-check   1130
;  :datatype-splits         421
;  :decisions               671
;  :del-clause              460
;  :final-checks            100
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1680
;  :mk-clause               498
;  :num-allocs              3984565
;  :num-checks              147
;  :propagations            327
;  :quant-instantiations    114
;  :rlimit-count            158038)
(push) ; 3
; [then-branch: 26 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0 | live]
; [else-branch: 26 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] != 0 | live]
(push) ; 4
; [then-branch: 26 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    1)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 26 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2881
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               119
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 628
;  :datatype-occurs-check   1130
;  :datatype-splits         421
;  :decisions               671
;  :del-clause              460
;  :final-checks            100
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1680
;  :mk-clause               498
;  :num-allocs              3984565
;  :num-checks              148
;  :propagations            327
;  :quant-instantiations    114
;  :rlimit-count            158203)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2924
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               120
;  :datatype-accessor-ax    204
;  :datatype-constructor-ax 640
;  :datatype-occurs-check   1136
;  :datatype-splits         432
;  :decisions               691
;  :del-clause              461
;  :final-checks            103
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1695
;  :mk-clause               499
;  :num-allocs              3984565
;  :num-checks              149
;  :propagations            351
;  :quant-instantiations    114
;  :rlimit-count            159020)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2978
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    207
;  :datatype-constructor-ax 655
;  :datatype-occurs-check   1144
;  :datatype-splits         445
;  :decisions               716
;  :del-clause              464
;  :final-checks            107
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1719
;  :mk-clause               502
;  :num-allocs              3984565
;  :num-checks              150
;  :propagations            378
;  :quant-instantiations    114
;  :rlimit-count            159896
;  :time                    0.00)
; [then-branch: 27 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == -1) | live]
; [else-branch: 27 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == -1 | live]
(push) ; 4
; [then-branch: 27 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2978
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    207
;  :datatype-constructor-ax 655
;  :datatype-occurs-check   1144
;  :datatype-splits         445
;  :decisions               716
;  :del-clause              464
;  :final-checks            107
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1719
;  :mk-clause               502
;  :num-allocs              3984565
;  :num-checks              151
;  :propagations            379
;  :quant-instantiations    114
;  :rlimit-count            160080)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2978
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    207
;  :datatype-constructor-ax 655
;  :datatype-occurs-check   1144
;  :datatype-splits         445
;  :decisions               716
;  :del-clause              464
;  :final-checks            107
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1719
;  :mk-clause               502
;  :num-allocs              3984565
;  :num-checks              152
;  :propagations            379
;  :quant-instantiations    114
;  :rlimit-count            160095)
(pop) ; 4
(push) ; 4
; [else-branch: 27 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      1)
    (- 0 1))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1) ==> diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] !(old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1)
; [eval] old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 3
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2984
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 655
;  :datatype-occurs-check   1144
;  :datatype-splits         445
;  :decisions               716
;  :del-clause              464
;  :final-checks            107
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1722
;  :mk-clause               503
;  :num-allocs              3984565
;  :num-checks              153
;  :propagations            379
;  :quant-instantiations    114
;  :rlimit-count            160596)
(push) ; 3
; [then-branch: 28 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0 | live]
; [else-branch: 28 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] != 0 | live]
(push) ; 4
; [then-branch: 28 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    2)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 28 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2984
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 655
;  :datatype-occurs-check   1144
;  :datatype-splits         445
;  :decisions               716
;  :del-clause              464
;  :final-checks            107
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1722
;  :mk-clause               503
;  :num-allocs              3984565
;  :num-checks              154
;  :propagations            379
;  :quant-instantiations    114
;  :rlimit-count            160761)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3028
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    210
;  :datatype-constructor-ax 667
;  :datatype-occurs-check   1150
;  :datatype-splits         456
;  :decisions               736
;  :del-clause              465
;  :final-checks            110
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1737
;  :mk-clause               504
;  :num-allocs              3984565
;  :num-checks              155
;  :propagations            405
;  :quant-instantiations    114
;  :rlimit-count            161588)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3084
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               127
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 682
;  :datatype-occurs-check   1158
;  :datatype-splits         469
;  :decisions               761
;  :del-clause              468
;  :final-checks            114
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1761
;  :mk-clause               507
;  :num-allocs              3984565
;  :num-checks              156
;  :propagations            434
;  :quant-instantiations    114
;  :rlimit-count            162475)
; [then-branch: 29 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == -1) | live]
; [else-branch: 29 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == -1 | live]
(push) ; 4
; [then-branch: 29 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        2)
      (- 0 1)))))
; [eval] diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3084
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               127
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 682
;  :datatype-occurs-check   1158
;  :datatype-splits         469
;  :decisions               761
;  :del-clause              468
;  :final-checks            114
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1761
;  :mk-clause               507
;  :num-allocs              3984565
;  :num-checks              157
;  :propagations            435
;  :quant-instantiations    114
;  :rlimit-count            162659)
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3084
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               127
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 682
;  :datatype-occurs-check   1158
;  :datatype-splits         469
;  :decisions               761
;  :del-clause              468
;  :final-checks            114
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1761
;  :mk-clause               507
;  :num-allocs              3984565
;  :num-checks              158
;  :propagations            435
;  :quant-instantiations    114
;  :rlimit-count            162674)
(pop) ; 4
(push) ; 4
; [else-branch: 29 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      2)
    (- 0 1))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          2)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          2)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[3]) == 0 || old(diz.Main_event_state[3]) == -1) ==> diz.Main_event_state[3] == old(diz.Main_event_state[3])
; [eval] !(old(diz.Main_event_state[3]) == 0 || old(diz.Main_event_state[3]) == -1)
; [eval] old(diz.Main_event_state[3]) == 0 || old(diz.Main_event_state[3]) == -1
; [eval] old(diz.Main_event_state[3]) == 0
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 3
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3090
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               127
;  :datatype-accessor-ax    214
;  :datatype-constructor-ax 682
;  :datatype-occurs-check   1158
;  :datatype-splits         469
;  :decisions               761
;  :del-clause              468
;  :final-checks            114
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1764
;  :mk-clause               508
;  :num-allocs              3984565
;  :num-checks              159
;  :propagations            435
;  :quant-instantiations    114
;  :rlimit-count            163185)
(push) ; 3
; [then-branch: 30 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0 | live]
; [else-branch: 30 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] != 0 | live]
(push) ; 4
; [then-branch: 30 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    3)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 30 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      3)
    0)))
; [eval] old(diz.Main_event_state[3]) == -1
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3090
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               127
;  :datatype-accessor-ax    214
;  :datatype-constructor-ax 682
;  :datatype-occurs-check   1158
;  :datatype-splits         469
;  :decisions               761
;  :del-clause              468
;  :final-checks            114
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1764
;  :mk-clause               508
;  :num-allocs              3984565
;  :num-checks              160
;  :propagations            435
;  :quant-instantiations    114
;  :rlimit-count            163350)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      3)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      3)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3135
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               128
;  :datatype-accessor-ax    216
;  :datatype-constructor-ax 694
;  :datatype-occurs-check   1164
;  :datatype-splits         480
;  :decisions               781
;  :del-clause              469
;  :final-checks            117
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1779
;  :mk-clause               509
;  :num-allocs              3984565
;  :num-checks              161
;  :propagations            463
;  :quant-instantiations    114
;  :rlimit-count            164187
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        3)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        3)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3193
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               131
;  :datatype-accessor-ax    219
;  :datatype-constructor-ax 709
;  :datatype-occurs-check   1172
;  :datatype-splits         493
;  :decisions               806
;  :del-clause              472
;  :final-checks            121
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1803
;  :mk-clause               512
;  :num-allocs              3984565
;  :num-checks              162
;  :propagations            494
;  :quant-instantiations    114
;  :rlimit-count            165085
;  :time                    0.00)
; [then-branch: 31 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == -1) | live]
; [else-branch: 31 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == -1 | live]
(push) ; 4
; [then-branch: 31 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        3)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        3)
      (- 0 1)))))
; [eval] diz.Main_event_state[3] == old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3193
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               131
;  :datatype-accessor-ax    219
;  :datatype-constructor-ax 709
;  :datatype-occurs-check   1172
;  :datatype-splits         493
;  :decisions               806
;  :del-clause              472
;  :final-checks            121
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1803
;  :mk-clause               512
;  :num-allocs              3984565
;  :num-checks              163
;  :propagations            495
;  :quant-instantiations    114
;  :rlimit-count            165269)
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3193
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               131
;  :datatype-accessor-ax    219
;  :datatype-constructor-ax 709
;  :datatype-occurs-check   1172
;  :datatype-splits         493
;  :decisions               806
;  :del-clause              472
;  :final-checks            121
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1803
;  :mk-clause               512
;  :num-allocs              3984565
;  :num-checks              164
;  :propagations            495
;  :quant-instantiations    114
;  :rlimit-count            165284)
(pop) ; 4
(push) ; 4
; [else-branch: 31 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[3] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      3)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      3)
    (- 0 1))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          3)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          3)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      3)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      3))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[4]) == 0 || old(diz.Main_event_state[4]) == -1) ==> diz.Main_event_state[4] == old(diz.Main_event_state[4])
; [eval] !(old(diz.Main_event_state[4]) == 0 || old(diz.Main_event_state[4]) == -1)
; [eval] old(diz.Main_event_state[4]) == 0 || old(diz.Main_event_state[4]) == -1
; [eval] old(diz.Main_event_state[4]) == 0
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 3
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3199
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               131
;  :datatype-accessor-ax    220
;  :datatype-constructor-ax 709
;  :datatype-occurs-check   1172
;  :datatype-splits         493
;  :decisions               806
;  :del-clause              472
;  :final-checks            121
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1806
;  :mk-clause               513
;  :num-allocs              3984565
;  :num-checks              165
;  :propagations            495
;  :quant-instantiations    114
;  :rlimit-count            165805)
(push) ; 3
; [then-branch: 32 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0 | live]
; [else-branch: 32 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] != 0 | live]
(push) ; 4
; [then-branch: 32 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    4)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 32 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      4)
    0)))
; [eval] old(diz.Main_event_state[4]) == -1
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3199
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               131
;  :datatype-accessor-ax    220
;  :datatype-constructor-ax 709
;  :datatype-occurs-check   1172
;  :datatype-splits         493
;  :decisions               806
;  :del-clause              472
;  :final-checks            121
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1806
;  :mk-clause               513
;  :num-allocs              3984565
;  :num-checks              166
;  :propagations            495
;  :quant-instantiations    114
;  :rlimit-count            165970)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      4)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      4)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3245
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    222
;  :datatype-constructor-ax 721
;  :datatype-occurs-check   1178
;  :datatype-splits         504
;  :decisions               826
;  :del-clause              473
;  :final-checks            124
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1821
;  :mk-clause               514
;  :num-allocs              3984565
;  :num-checks              167
;  :propagations            525
;  :quant-instantiations    114
;  :rlimit-count            166817)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        4)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        4)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3305
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               135
;  :datatype-accessor-ax    225
;  :datatype-constructor-ax 736
;  :datatype-occurs-check   1186
;  :datatype-splits         517
;  :decisions               851
;  :del-clause              476
;  :final-checks            128
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1845
;  :mk-clause               517
;  :num-allocs              3984565
;  :num-checks              168
;  :propagations            558
;  :quant-instantiations    114
;  :rlimit-count            167726
;  :time                    0.00)
; [then-branch: 33 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == -1) | live]
; [else-branch: 33 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == -1 | live]
(push) ; 4
; [then-branch: 33 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        4)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        4)
      (- 0 1)))))
; [eval] diz.Main_event_state[4] == old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3305
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               135
;  :datatype-accessor-ax    225
;  :datatype-constructor-ax 736
;  :datatype-occurs-check   1186
;  :datatype-splits         517
;  :decisions               851
;  :del-clause              476
;  :final-checks            128
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1845
;  :mk-clause               517
;  :num-allocs              3984565
;  :num-checks              169
;  :propagations            559
;  :quant-instantiations    114
;  :rlimit-count            167910)
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3305
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               135
;  :datatype-accessor-ax    225
;  :datatype-constructor-ax 736
;  :datatype-occurs-check   1186
;  :datatype-splits         517
;  :decisions               851
;  :del-clause              476
;  :final-checks            128
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1845
;  :mk-clause               517
;  :num-allocs              3984565
;  :num-checks              170
;  :propagations            559
;  :quant-instantiations    114
;  :rlimit-count            167925)
(pop) ; 4
(push) ; 4
; [else-branch: 33 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[4] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      4)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      4)
    (- 0 1))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          4)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          4)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      4)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      4))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@71@01))))))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[5]) == 0 || old(diz.Main_event_state[5]) == -1) ==> diz.Main_event_state[5] == old(diz.Main_event_state[5])
; [eval] !(old(diz.Main_event_state[5]) == 0 || old(diz.Main_event_state[5]) == -1)
; [eval] old(diz.Main_event_state[5]) == 0 || old(diz.Main_event_state[5]) == -1
; [eval] old(diz.Main_event_state[5]) == 0
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 3
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3307
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               135
;  :datatype-accessor-ax    225
;  :datatype-constructor-ax 736
;  :datatype-occurs-check   1186
;  :datatype-splits         517
;  :decisions               851
;  :del-clause              476
;  :final-checks            128
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1847
;  :mk-clause               518
;  :num-allocs              3984565
;  :num-checks              171
;  :propagations            559
;  :quant-instantiations    114
;  :rlimit-count            168364)
(push) ; 3
; [then-branch: 34 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0 | live]
; [else-branch: 34 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] != 0 | live]
(push) ; 4
; [then-branch: 34 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
    5)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 34 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      5)
    0)))
; [eval] old(diz.Main_event_state[5]) == -1
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3307
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               135
;  :datatype-accessor-ax    225
;  :datatype-constructor-ax 736
;  :datatype-occurs-check   1186
;  :datatype-splits         517
;  :decisions               851
;  :del-clause              476
;  :final-checks            128
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1847
;  :mk-clause               518
;  :num-allocs              3984565
;  :num-checks              172
;  :propagations            559
;  :quant-instantiations    114
;  :rlimit-count            168529)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      5)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      5)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3351
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               136
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 747
;  :datatype-occurs-check   1192
;  :datatype-splits         526
;  :decisions               870
;  :del-clause              477
;  :final-checks            131
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1860
;  :mk-clause               519
;  :num-allocs              3984565
;  :num-checks              173
;  :propagations            591
;  :quant-instantiations    114
;  :rlimit-count            169372
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        5)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        5)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3410
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               139
;  :datatype-accessor-ax    230
;  :datatype-constructor-ax 761
;  :datatype-occurs-check   1200
;  :datatype-splits         537
;  :decisions               894
;  :del-clause              480
;  :final-checks            135
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1882
;  :mk-clause               522
;  :num-allocs              3984565
;  :num-checks              174
;  :propagations            626
;  :quant-instantiations    114
;  :rlimit-count            170278
;  :time                    0.00)
; [then-branch: 35 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == -1) | live]
; [else-branch: 35 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == -1 | live]
(push) ; 4
; [then-branch: 35 | !(First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        5)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
        5)
      (- 0 1)))))
; [eval] diz.Main_event_state[5] == old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3410
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               139
;  :datatype-accessor-ax    230
;  :datatype-constructor-ax 761
;  :datatype-occurs-check   1200
;  :datatype-splits         537
;  :decisions               894
;  :del-clause              480
;  :final-checks            135
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1882
;  :mk-clause               522
;  :num-allocs              3984565
;  :num-checks              175
;  :propagations            627
;  :quant-instantiations    114
;  :rlimit-count            170462)
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3410
;  :arith-add-rows          100
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      73
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               139
;  :datatype-accessor-ax    230
;  :datatype-constructor-ax 761
;  :datatype-occurs-check   1200
;  :datatype-splits         537
;  :decisions               894
;  :del-clause              480
;  :final-checks            135
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.34
;  :memory                  4.34
;  :minimized-lits          8
;  :mk-bool-var             1882
;  :mk-clause               522
;  :num-allocs              3984565
;  :num-checks              176
;  :propagations            627
;  :quant-instantiations    114
;  :rlimit-count            170477)
(pop) ; 4
(push) ; 4
; [else-branch: 35 | First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@69@01)))))[5] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      5)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      5)
    (- 0 1))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          5)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
          5)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@71@01)))))
      5)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@69@01))))))
      5))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
