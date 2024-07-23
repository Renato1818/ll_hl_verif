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
; ---------- Full_adder_sum__EncodedGlobalVariables_Boolean_Boolean ----------
(declare-const diz@0@05 $Ref)
(declare-const globals@1@05 $Ref)
(declare-const a@2@05 Bool)
(declare-const b@3@05 Bool)
(declare-const sys__result@4@05 Bool)
(declare-const diz@5@05 $Ref)
(declare-const globals@6@05 $Ref)
(declare-const a@7@05 Bool)
(declare-const b@8@05 Bool)
(declare-const sys__result@9@05 Bool)
(push) ; 1
(declare-const $t@10@05 $Snap)
(assert (= $t@10@05 ($Snap.combine ($Snap.first $t@10@05) ($Snap.second $t@10@05))))
(assert (= ($Snap.first $t@10@05) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@5@05 $Ref.null)))
(assert (=
  ($Snap.second $t@10@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@10@05))
    ($Snap.second ($Snap.second $t@10@05)))))
(declare-const $k@11@05 $Perm)
(assert ($Perm.isReadVar $k@11@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@11@05 $Perm.No) (< $Perm.No $k@11@05))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            18
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   2
;  :arith-eq-adapter     2
;  :binary-propagations  22
;  :conflicts            1
;  :datatype-accessor-ax 3
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.67
;  :mk-bool-var          245
;  :mk-clause            3
;  :num-allocs           3250513
;  :num-checks           1
;  :propagations         23
;  :quant-instantiations 1
;  :rlimit-count         100782)
(assert (<= $Perm.No $k@11@05))
(assert (<= $k@11@05 $Perm.Write))
(assert (implies (< $Perm.No $k@11@05) (not (= diz@5@05 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@10@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@10@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@10@05))) $Snap.unit))
; [eval] diz.Full_adder_m != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            24
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  22
;  :conflicts            2
;  :datatype-accessor-ax 4
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.67
;  :mk-bool-var          248
;  :mk-clause            3
;  :num-allocs           3250513
;  :num-checks           2
;  :propagations         23
;  :quant-instantiations 1
;  :rlimit-count         101035
;  :time                 0.01)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@10@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            30
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  22
;  :conflicts            3
;  :datatype-accessor-ax 5
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.67
;  :mk-bool-var          251
;  :mk-clause            3
;  :num-allocs           3250513
;  :num-checks           3
;  :propagations         23
;  :quant-instantiations 2
;  :rlimit-count         101319
;  :time                 0.01)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            35
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  22
;  :conflicts            4
;  :datatype-accessor-ax 6
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.67
;  :mk-bool-var          252
;  :mk-clause            3
;  :num-allocs           3250513
;  :num-checks           4
;  :propagations         23
;  :quant-instantiations 2
;  :rlimit-count         101506)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
  $Snap.unit))
; [eval] |diz.Full_adder_m.Main_process_state| == 3
; [eval] |diz.Full_adder_m.Main_process_state|
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            41
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  22
;  :conflicts            5
;  :datatype-accessor-ax 7
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.67
;  :mk-bool-var          254
;  :mk-clause            3
;  :num-allocs           3250513
;  :num-checks           5
;  :propagations         23
;  :quant-instantiations 2
;  :rlimit-count         101735)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            48
;  :arith-assert-diseq   2
;  :arith-assert-lower   6
;  :arith-assert-upper   4
;  :arith-eq-adapter     4
;  :binary-propagations  22
;  :conflicts            6
;  :datatype-accessor-ax 8
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.67
;  :mk-bool-var          263
;  :mk-clause            6
;  :num-allocs           3250513
;  :num-checks           6
;  :propagations         24
;  :quant-instantiations 5
;  :rlimit-count         102096
;  :time                 0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
  $Snap.unit))
; [eval] |diz.Full_adder_m.Main_event_state| == 6
; [eval] |diz.Full_adder_m.Main_event_state|
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            54
;  :arith-assert-diseq   2
;  :arith-assert-lower   6
;  :arith-assert-upper   4
;  :arith-eq-adapter     4
;  :binary-propagations  22
;  :conflicts            7
;  :datatype-accessor-ax 9
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.67
;  :mk-bool-var          265
;  :mk-clause            6
;  :num-allocs           3250513
;  :num-checks           7
;  :propagations         24
;  :quant-instantiations 5
;  :rlimit-count         102345)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Full_adder_m.Main_process_state[i] } 0 <= i && i < |diz.Full_adder_m.Main_process_state| ==> diz.Full_adder_m.Main_process_state[i] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i] && diz.Full_adder_m.Main_process_state[i] < |diz.Full_adder_m.Main_event_state|)
(declare-const i@12@05 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Full_adder_m.Main_process_state| ==> diz.Full_adder_m.Main_process_state[i] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i] && diz.Full_adder_m.Main_process_state[i] < |diz.Full_adder_m.Main_event_state|
; [eval] 0 <= i && i < |diz.Full_adder_m.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 0 | 0 <= i@12@05 | live]
; [else-branch: 0 | !(0 <= i@12@05) | live]
(push) ; 4
; [then-branch: 0 | 0 <= i@12@05]
(assert (<= 0 i@12@05))
; [eval] i < |diz.Full_adder_m.Main_process_state|
; [eval] |diz.Full_adder_m.Main_process_state|
(push) ; 5
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            62
;  :arith-assert-diseq   3
;  :arith-assert-lower   10
;  :arith-assert-upper   5
;  :arith-eq-adapter     6
;  :binary-propagations  22
;  :conflicts            8
;  :datatype-accessor-ax 10
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.67
;  :mk-bool-var          276
;  :mk-clause            9
;  :num-allocs           3250513
;  :num-checks           8
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         102817)
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(0 <= i@12@05)]
(assert (not (<= 0 i@12@05)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 1 | i@12@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i@12@05 | live]
; [else-branch: 1 | !(i@12@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i@12@05) | live]
(push) ; 4
; [then-branch: 1 | i@12@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i@12@05]
(assert (and
  (<
    i@12@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
  (<= 0 i@12@05)))
; [eval] diz.Full_adder_m.Main_process_state[i] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i] && diz.Full_adder_m.Main_process_state[i] < |diz.Full_adder_m.Main_event_state|
; [eval] diz.Full_adder_m.Main_process_state[i] == -1
; [eval] diz.Full_adder_m.Main_process_state[i]
(push) ; 5
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            62
;  :arith-assert-diseq   3
;  :arith-assert-lower   11
;  :arith-assert-upper   6
;  :arith-eq-adapter     6
;  :binary-propagations  22
;  :conflicts            9
;  :datatype-accessor-ax 10
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.67
;  :mk-bool-var          278
;  :mk-clause            9
;  :num-allocs           3250513
;  :num-checks           9
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         102974)
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@12@05 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            62
;  :arith-assert-diseq   3
;  :arith-assert-lower   11
;  :arith-assert-upper   6
;  :arith-eq-adapter     6
;  :binary-propagations  22
;  :conflicts            9
;  :datatype-accessor-ax 10
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.67
;  :mk-bool-var          278
;  :mk-clause            9
;  :num-allocs           3250513
;  :num-checks           10
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         102983)
; [eval] -1
(push) ; 5
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@12@05] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@12@05] != -1 | live]
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@12@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i@12@05)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@12@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
      i@12@05)
    (- 0 1))))
; [eval] 0 <= diz.Full_adder_m.Main_process_state[i] && diz.Full_adder_m.Main_process_state[i] < |diz.Full_adder_m.Main_event_state|
; [eval] 0 <= diz.Full_adder_m.Main_process_state[i]
; [eval] diz.Full_adder_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            62
;  :arith-assert-diseq   3
;  :arith-assert-lower   11
;  :arith-assert-upper   6
;  :arith-eq-adapter     6
;  :binary-propagations  22
;  :conflicts            10
;  :datatype-accessor-ax 10
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          279
;  :mk-clause            9
;  :num-allocs           3360977
;  :num-checks           11
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         103209)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i@12@05 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            62
;  :arith-assert-diseq   3
;  :arith-assert-lower   11
;  :arith-assert-upper   6
;  :arith-eq-adapter     6
;  :binary-propagations  22
;  :conflicts            10
;  :datatype-accessor-ax 10
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          279
;  :mk-clause            9
;  :num-allocs           3360977
;  :num-checks           12
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         103218)
(push) ; 7
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@12@05] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@12@05]) | live]
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@12@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i@12@05)))
; [eval] diz.Full_adder_m.Main_process_state[i] < |diz.Full_adder_m.Main_event_state|
; [eval] diz.Full_adder_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            62
;  :arith-assert-diseq   4
;  :arith-assert-lower   14
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :binary-propagations  22
;  :conflicts            11
;  :datatype-accessor-ax 10
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          282
;  :mk-clause            10
;  :num-allocs           3360977
;  :num-checks           13
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         103391)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@12@05 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            62
;  :arith-assert-diseq   4
;  :arith-assert-lower   14
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :binary-propagations  22
;  :conflicts            11
;  :datatype-accessor-ax 10
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          282
;  :mk-clause            10
;  :num-allocs           3360977
;  :num-checks           14
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         103400)
; [eval] |diz.Full_adder_m.Main_event_state|
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            62
;  :arith-assert-diseq   4
;  :arith-assert-lower   14
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :binary-propagations  22
;  :conflicts            12
;  :datatype-accessor-ax 10
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          282
;  :mk-clause            10
;  :num-allocs           3360977
;  :num-checks           15
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         103448)
(pop) ; 8
(push) ; 8
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@12@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
      i@12@05))))
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
; [else-branch: 1 | !(i@12@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i@12@05)]
(assert (not
  (and
    (<
      i@12@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
    (<= 0 i@12@05))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@12@05 Int)) (!
  (implies
    (and
      (<
        i@12@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
      (<= 0 i@12@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
          i@12@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i@12@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i@12@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i@12@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            67
;  :arith-assert-diseq   4
;  :arith-assert-lower   14
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :binary-propagations  22
;  :conflicts            13
;  :datatype-accessor-ax 11
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          284
;  :mk-clause            10
;  :num-allocs           3360977
;  :num-checks           16
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         104103)
(declare-const $k@13@05 $Perm)
(assert ($Perm.isReadVar $k@13@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@13@05 $Perm.No) (< $Perm.No $k@13@05))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            67
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   7
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            14
;  :datatype-accessor-ax 11
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          288
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           17
;  :propagations         26
;  :quant-instantiations 8
;  :rlimit-count         104301)
(assert (<= $Perm.No $k@13@05))
(assert (<= $k@13@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@13@05)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            73
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            15
;  :datatype-accessor-ax 12
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          291
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           18
;  :propagations         26
;  :quant-instantiations 8
;  :rlimit-count         104634)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            73
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            16
;  :datatype-accessor-ax 12
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          291
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           19
;  :propagations         26
;  :quant-instantiations 8
;  :rlimit-count         104682)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            79
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            17
;  :datatype-accessor-ax 13
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          294
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           20
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         105048)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            79
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            18
;  :datatype-accessor-ax 13
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          294
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           21
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         105096)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            84
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            19
;  :datatype-accessor-ax 14
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          295
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           22
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         105363)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            84
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            20
;  :datatype-accessor-ax 14
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          295
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           23
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         105411)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            89
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            21
;  :datatype-accessor-ax 15
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          296
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           24
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         105688)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            89
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            22
;  :datatype-accessor-ax 15
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          296
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           25
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         105736)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            94
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            23
;  :datatype-accessor-ax 16
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          297
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           26
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         106023)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            94
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            24
;  :datatype-accessor-ax 16
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          297
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           27
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         106071)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            99
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            25
;  :datatype-accessor-ax 17
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          298
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           28
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         106368)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            99
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            26
;  :datatype-accessor-ax 17
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          298
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           29
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         106416)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            104
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            27
;  :datatype-accessor-ax 18
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          299
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           30
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         106723)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            104
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            28
;  :datatype-accessor-ax 18
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          299
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           31
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         106771)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            109
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            29
;  :datatype-accessor-ax 19
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          300
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           32
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         107088
;  :time                 0.00)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            109
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            30
;  :datatype-accessor-ax 19
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          300
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           33
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         107136)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            114
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            31
;  :datatype-accessor-ax 20
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          301
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           34
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         107463)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            114
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            32
;  :datatype-accessor-ax 20
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.77
;  :mk-bool-var          301
;  :mk-clause            12
;  :num-allocs           3360977
;  :num-checks           35
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         107511)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            119
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            33
;  :datatype-accessor-ax 21
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.95
;  :mk-bool-var          302
;  :mk-clause            12
;  :num-allocs           3474861
;  :num-checks           36
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         107848)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            119
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            34
;  :datatype-accessor-ax 21
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.95
;  :mk-bool-var          302
;  :mk-clause            12
;  :num-allocs           3474861
;  :num-checks           37
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         107896)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            124
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            35
;  :datatype-accessor-ax 22
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.95
;  :mk-bool-var          303
;  :mk-clause            12
;  :num-allocs           3474861
;  :num-checks           38
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         108243)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            124
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            36
;  :datatype-accessor-ax 22
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.95
;  :mk-bool-var          303
;  :mk-clause            12
;  :num-allocs           3474861
;  :num-checks           39
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         108291)
(declare-const $k@14@05 $Perm)
(assert ($Perm.isReadVar $k@14@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@14@05 $Perm.No) (< $Perm.No $k@14@05))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            124
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   9
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            37
;  :datatype-accessor-ax 22
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.95
;  :mk-bool-var          307
;  :mk-clause            14
;  :num-allocs           3474861
;  :num-checks           40
;  :propagations         27
;  :quant-instantiations 9
;  :rlimit-count         108490)
(set-option :timeout 10)
(push) ; 2
(assert (not (=
  diz@5@05
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))
(check-sat)
; unknown
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               170
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      9
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               38
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             327
;  :mk-clause               15
;  :num-allocs              3474861
;  :num-checks              41
;  :propagations            27
;  :quant-instantiations    9
;  :rlimit-count            109200
;  :time                    0.00)
(assert (<= $Perm.No $k@14@05))
(assert (<= $k@14@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@14@05)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder.Full_adder_m == diz.Full_adder_m
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               176
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               39
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             330
;  :mk-clause               15
;  :num-allocs              3474861
;  :num-checks              42
;  :propagations            27
;  :quant-instantiations    9
;  :rlimit-count            109643)
(push) ; 2
(assert (not (< $Perm.No $k@13@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               176
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               40
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             330
;  :mk-clause               15
;  :num-allocs              3474861
;  :num-checks              43
;  :propagations            27
;  :quant-instantiations    9
;  :rlimit-count            109691)
(push) ; 2
(assert (not (< $Perm.No $k@14@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               176
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               41
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             330
;  :mk-clause               15
;  :num-allocs              3474861
;  :num-checks              44
;  :propagations            27
;  :quant-instantiations    9
;  :rlimit-count            109739)
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               176
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               42
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             330
;  :mk-clause               15
;  :num-allocs              3474861
;  :num-checks              45
;  :propagations            27
;  :quant-instantiations    9
;  :rlimit-count            109787)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               184
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               43
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             333
;  :mk-clause               15
;  :num-allocs              3474861
;  :num-checks              46
;  :propagations            27
;  :quant-instantiations    10
;  :rlimit-count            110284)
(declare-const $k@15@05 $Perm)
(assert ($Perm.isReadVar $k@15@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@15@05 $Perm.No) (< $Perm.No $k@15@05))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               184
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      11
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               44
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             337
;  :mk-clause               17
;  :num-allocs              3474861
;  :num-checks              47
;  :propagations            28
;  :quant-instantiations    10
;  :rlimit-count            110483)
(assert (<= $Perm.No $k@15@05))
(assert (<= $k@15@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@15@05)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder_prc != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               190
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               45
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             340
;  :mk-clause               17
;  :num-allocs              3474861
;  :num-checks              48
;  :propagations            28
;  :quant-instantiations    10
;  :rlimit-count            110946)
(push) ; 2
(assert (not (< $Perm.No $k@15@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               190
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               46
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             340
;  :mk-clause               17
;  :num-allocs              3474861
;  :num-checks              49
;  :propagations            28
;  :quant-instantiations    10
;  :rlimit-count            110994)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               196
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               47
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             343
;  :mk-clause               17
;  :num-allocs              3474861
;  :num-checks              50
;  :propagations            28
;  :quant-instantiations    11
;  :rlimit-count            111488)
(push) ; 2
(assert (not (< $Perm.No $k@15@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               196
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               48
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             343
;  :mk-clause               17
;  :num-allocs              3474861
;  :num-checks              51
;  :propagations            28
;  :quant-instantiations    11
;  :rlimit-count            111536)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               196
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               48
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             343
;  :mk-clause               17
;  :num-allocs              3474861
;  :num-checks              52
;  :propagations            28
;  :quant-instantiations    11
;  :rlimit-count            111549)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               201
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               49
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             344
;  :mk-clause               17
;  :num-allocs              3474861
;  :num-checks              53
;  :propagations            28
;  :quant-instantiations    11
;  :rlimit-count            111946)
(declare-const $k@16@05 $Perm)
(assert ($Perm.isReadVar $k@16@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@16@05 $Perm.No) (< $Perm.No $k@16@05))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               201
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               50
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             348
;  :mk-clause               19
;  :num-allocs              3474861
;  :num-checks              54
;  :propagations            29
;  :quant-instantiations    11
;  :rlimit-count            112144)
(assert (<= $Perm.No $k@16@05))
(assert (<= $k@16@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@16@05)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder_half_adder1 != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               207
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               51
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             351
;  :mk-clause               19
;  :num-allocs              3474861
;  :num-checks              55
;  :propagations            29
;  :quant-instantiations    11
;  :rlimit-count            112637)
(push) ; 2
(assert (not (< $Perm.No $k@16@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               207
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               52
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             351
;  :mk-clause               19
;  :num-allocs              3474861
;  :num-checks              56
;  :propagations            29
;  :quant-instantiations    11
;  :rlimit-count            112685)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               213
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               53
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             354
;  :mk-clause               19
;  :num-allocs              3474861
;  :num-checks              57
;  :propagations            29
;  :quant-instantiations    12
;  :rlimit-count            113211)
(push) ; 2
(assert (not (< $Perm.No $k@16@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               213
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               54
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             354
;  :mk-clause               19
;  :num-allocs              3474861
;  :num-checks              58
;  :propagations            29
;  :quant-instantiations    12
;  :rlimit-count            113259)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               213
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               54
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             354
;  :mk-clause               19
;  :num-allocs              3474861
;  :num-checks              59
;  :propagations            29
;  :quant-instantiations    12
;  :rlimit-count            113272)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               218
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               55
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             355
;  :mk-clause               19
;  :num-allocs              3474861
;  :num-checks              60
;  :propagations            29
;  :quant-instantiations    12
;  :rlimit-count            113699)
(declare-const $k@17@05 $Perm)
(assert ($Perm.isReadVar $k@17@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@17@05 $Perm.No) (< $Perm.No $k@17@05))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               218
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      15
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               56
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             359
;  :mk-clause               21
;  :num-allocs              3474861
;  :num-checks              61
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            113898)
(assert (<= $Perm.No $k@17@05))
(assert (<= $k@17@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@17@05)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder_half_adder2 != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               224
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               57
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             362
;  :mk-clause               21
;  :num-allocs              3474861
;  :num-checks              62
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            114421)
(push) ; 2
(assert (not (< $Perm.No $k@17@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               224
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               58
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             362
;  :mk-clause               21
;  :num-allocs              3474861
;  :num-checks              63
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            114469)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               230
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               59
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             365
;  :mk-clause               21
;  :num-allocs              3474861
;  :num-checks              64
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            115025)
(push) ; 2
(assert (not (< $Perm.No $k@17@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               230
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               60
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             365
;  :mk-clause               21
;  :num-allocs              3474861
;  :num-checks              65
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            115073)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               230
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               60
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             365
;  :mk-clause               21
;  :num-allocs              3474861
;  :num-checks              66
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            115086)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               235
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             366
;  :mk-clause               21
;  :num-allocs              3474861
;  :num-checks              67
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            115543)
(declare-const $k@18@05 $Perm)
(assert ($Perm.isReadVar $k@18@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@18@05 $Perm.No) (< $Perm.No $k@18@05))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               235
;  :arith-assert-diseq      10
;  :arith-assert-lower      26
;  :arith-assert-upper      17
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               62
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             370
;  :mk-clause               23
;  :num-allocs              3474861
;  :num-checks              68
;  :propagations            31
;  :quant-instantiations    13
;  :rlimit-count            115742)
(declare-const $t@19@05 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@13@05)
    (=
      $t@19@05
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))
  (implies
    (< $Perm.No $k@18@05)
    (=
      $t@19@05
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@13@05 $k@18@05)))
(assert (<= (+ $k@13@05 $k@18@05) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@13@05 $k@18@05))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               240
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      18
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               63
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             376
;  :mk-clause               23
;  :num-allocs              3474861
;  :num-checks              69
;  :propagations            31
;  :quant-instantiations    14
;  :rlimit-count            116443)
(push) ; 2
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               240
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      19
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               64
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   3
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             377
;  :mk-clause               23
;  :num-allocs              3474861
;  :num-checks              70
;  :propagations            31
;  :quant-instantiations    14
;  :rlimit-count            116509)
(assert (= $t@19@05 diz@5@05))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@20@05 $Snap)
(assert (= $t@20@05 ($Snap.combine ($Snap.first $t@20@05) ($Snap.second $t@20@05))))
(declare-const $k@21@05 $Perm)
(assert ($Perm.isReadVar $k@21@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@21@05 $Perm.No) (< $Perm.No $k@21@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               307
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      20
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               66
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             406
;  :mk-clause               26
;  :num-allocs              3474861
;  :num-checks              72
;  :propagations            32
;  :quant-instantiations    14
;  :rlimit-count            117469)
(assert (<= $Perm.No $k@21@05))
(assert (<= $k@21@05 $Perm.Write))
(assert (implies (< $Perm.No $k@21@05) (not (= diz@5@05 $Ref.null))))
(assert (=
  ($Snap.second $t@20@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@20@05))
    ($Snap.second ($Snap.second $t@20@05)))))
(assert (= ($Snap.first ($Snap.second $t@20@05)) $Snap.unit))
; [eval] diz.Full_adder_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               313
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               67
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             409
;  :mk-clause               26
;  :num-allocs              3474861
;  :num-checks              73
;  :propagations            32
;  :quant-instantiations    14
;  :rlimit-count            117712)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@20@05)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@20@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@20@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               319
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               68
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             412
;  :mk-clause               26
;  :num-allocs              3474861
;  :num-checks              74
;  :propagations            32
;  :quant-instantiations    15
;  :rlimit-count            117984)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@20@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               324
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               69
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             413
;  :mk-clause               26
;  :num-allocs              3474861
;  :num-checks              75
;  :propagations            32
;  :quant-instantiations    15
;  :rlimit-count            118161)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
  $Snap.unit))
; [eval] |diz.Full_adder_m.Main_process_state| == 3
; [eval] |diz.Full_adder_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               330
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-conflicts         1
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               70
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             415
;  :mk-clause               26
;  :num-allocs              3474861
;  :num-checks              76
;  :propagations            32
;  :quant-instantiations    15
;  :rlimit-count            118380)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               337
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      22
;  :arith-conflicts         1
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               71
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             421
;  :mk-clause               26
;  :num-allocs              3474861
;  :num-checks              77
;  :propagations            32
;  :quant-instantiations    17
;  :rlimit-count            118710)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))
  $Snap.unit))
; [eval] |diz.Full_adder_m.Main_event_state| == 6
; [eval] |diz.Full_adder_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               343
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      22
;  :arith-conflicts         1
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               72
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             423
;  :mk-clause               26
;  :num-allocs              3596951
;  :num-checks              78
;  :propagations            32
;  :quant-instantiations    17
;  :rlimit-count            118949)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Full_adder_m.Main_process_state[i] } 0 <= i && i < |diz.Full_adder_m.Main_process_state| ==> diz.Full_adder_m.Main_process_state[i] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i] && diz.Full_adder_m.Main_process_state[i] < |diz.Full_adder_m.Main_event_state|)
(declare-const i@22@05 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Full_adder_m.Main_process_state| ==> diz.Full_adder_m.Main_process_state[i] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i] && diz.Full_adder_m.Main_process_state[i] < |diz.Full_adder_m.Main_event_state|
; [eval] 0 <= i && i < |diz.Full_adder_m.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@22@05 | live]
; [else-branch: 4 | !(0 <= i@22@05) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@22@05]
(assert (<= 0 i@22@05))
; [eval] i < |diz.Full_adder_m.Main_process_state|
; [eval] |diz.Full_adder_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               351
;  :arith-assert-diseq      11
;  :arith-assert-lower      34
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               73
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             431
;  :mk-clause               26
;  :num-allocs              3596951
;  :num-checks              79
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            119387)
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@22@05)]
(assert (not (<= 0 i@22@05)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@22@05 < |First:(Second:(Second:(Second:($t@20@05))))| && 0 <= i@22@05 | live]
; [else-branch: 5 | !(i@22@05 < |First:(Second:(Second:(Second:($t@20@05))))| && 0 <= i@22@05) | live]
(push) ; 5
; [then-branch: 5 | i@22@05 < |First:(Second:(Second:(Second:($t@20@05))))| && 0 <= i@22@05]
(assert (and
  (<
    i@22@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))
  (<= 0 i@22@05)))
; [eval] diz.Full_adder_m.Main_process_state[i] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i] && diz.Full_adder_m.Main_process_state[i] < |diz.Full_adder_m.Main_event_state|
; [eval] diz.Full_adder_m.Main_process_state[i] == -1
; [eval] diz.Full_adder_m.Main_process_state[i]
(push) ; 6
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               351
;  :arith-assert-diseq      11
;  :arith-assert-lower      35
;  :arith-assert-upper      24
;  :arith-conflicts         1
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               74
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             433
;  :mk-clause               26
;  :num-allocs              3596951
;  :num-checks              80
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            119544)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@22@05 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               351
;  :arith-assert-diseq      11
;  :arith-assert-lower      35
;  :arith-assert-upper      24
;  :arith-conflicts         1
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               74
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             433
;  :mk-clause               26
;  :num-allocs              3596951
;  :num-checks              81
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            119553)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:($t@20@05))))[i@22@05] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@20@05))))[i@22@05] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@20@05))))[i@22@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
    i@22@05)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:($t@20@05))))[i@22@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
      i@22@05)
    (- 0 1))))
; [eval] 0 <= diz.Full_adder_m.Main_process_state[i] && diz.Full_adder_m.Main_process_state[i] < |diz.Full_adder_m.Main_event_state|
; [eval] 0 <= diz.Full_adder_m.Main_process_state[i]
; [eval] diz.Full_adder_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               351
;  :arith-assert-diseq      11
;  :arith-assert-lower      35
;  :arith-assert-upper      24
;  :arith-conflicts         1
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               75
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             434
;  :mk-clause               26
;  :num-allocs              3596951
;  :num-checks              82
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            119767)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i@22@05 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               351
;  :arith-assert-diseq      11
;  :arith-assert-lower      35
;  :arith-assert-upper      24
;  :arith-conflicts         1
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               75
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             434
;  :mk-clause               26
;  :num-allocs              3596951
;  :num-checks              83
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            119776)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@20@05))))[i@22@05] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@20@05))))[i@22@05]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@20@05))))[i@22@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
    i@22@05)))
; [eval] diz.Full_adder_m.Main_process_state[i] < |diz.Full_adder_m.Main_event_state|
; [eval] diz.Full_adder_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               351
;  :arith-assert-diseq      12
;  :arith-assert-lower      38
;  :arith-assert-upper      24
;  :arith-conflicts         1
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               76
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             437
;  :mk-clause               27
;  :num-allocs              3596951
;  :num-checks              84
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            119938)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i@22@05 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               351
;  :arith-assert-diseq      12
;  :arith-assert-lower      38
;  :arith-assert-upper      24
;  :arith-conflicts         1
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               76
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             437
;  :mk-clause               27
;  :num-allocs              3596951
;  :num-checks              85
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            119947)
; [eval] |diz.Full_adder_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               351
;  :arith-assert-diseq      12
;  :arith-assert-lower      38
;  :arith-assert-upper      24
;  :arith-conflicts         1
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               77
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              22
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             437
;  :mk-clause               27
;  :num-allocs              3596951
;  :num-checks              86
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            119995)
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@20@05))))[i@22@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
      i@22@05))))
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
; [else-branch: 5 | !(i@22@05 < |First:(Second:(Second:(Second:($t@20@05))))| && 0 <= i@22@05)]
(assert (not
  (and
    (<
      i@22@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))
    (<= 0 i@22@05))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@22@05 Int)) (!
  (implies
    (and
      (<
        i@22@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))
      (<= 0 i@22@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
          i@22@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
            i@22@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
            i@22@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
    i@22@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      12
;  :arith-assert-lower      38
;  :arith-assert-upper      24
;  :arith-conflicts         1
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               78
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             439
;  :mk-clause               27
;  :num-allocs              3596951
;  :num-checks              87
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            120620)
(declare-const $k@23@05 $Perm)
(assert ($Perm.isReadVar $k@23@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@23@05 $Perm.No) (< $Perm.No $k@23@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      25
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               79
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             443
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              88
;  :propagations            33
;  :quant-instantiations    19
;  :rlimit-count            120819)
(assert (<= $Perm.No $k@23@05))
(assert (<= $k@23@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@23@05)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@20@05)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               362
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               80
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             446
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              89
;  :propagations            33
;  :quant-instantiations    19
;  :rlimit-count            121142)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               362
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               81
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             446
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              90
;  :propagations            33
;  :quant-instantiations    19
;  :rlimit-count            121190)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               368
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               82
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             449
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              91
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            121546)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               368
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               83
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             449
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              92
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            121594)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               373
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               84
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             450
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              93
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            121851)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               373
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               85
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             450
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              94
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            121899)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               378
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               86
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             451
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              95
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            122166)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               378
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               87
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             451
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              96
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            122214)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               383
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               88
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             452
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              97
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            122491)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               383
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               89
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             452
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              98
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            122539)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               388
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               90
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             453
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              99
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            122826)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               388
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               91
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             453
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              100
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            122874)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               393
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               92
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             454
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              101
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            123171)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               393
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               93
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             454
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              102
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            123219)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               398
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               94
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             455
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              103
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            123526)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               398
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               95
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             455
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              104
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            123574)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               403
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               96
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             456
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              105
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            123891)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               403
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               97
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             456
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              106
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            123939)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               408
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               98
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             457
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              107
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            124266)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               408
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               99
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             457
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              108
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            124314)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               413
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               100
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             458
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              109
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            124651)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               413
;  :arith-assert-diseq      13
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               101
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             458
;  :mk-clause               29
;  :num-allocs              3596951
;  :num-checks              110
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            124699)
(declare-const $k@24@05 $Perm)
(assert ($Perm.isReadVar $k@24@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@24@05 $Perm.No) (< $Perm.No $k@24@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               413
;  :arith-assert-diseq      14
;  :arith-assert-lower      42
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   6
;  :datatype-splits         40
;  :decisions               40
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             462
;  :mk-clause               31
;  :num-allocs              3596951
;  :num-checks              111
;  :propagations            34
;  :quant-instantiations    20
;  :rlimit-count            124898)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@5@05
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               599
;  :arith-assert-diseq      14
;  :arith-assert-lower      42
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               104
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             508
;  :mk-clause               33
;  :num-allocs              3724165
;  :num-checks              112
;  :propagations            35
;  :quant-instantiations    20
;  :rlimit-count            126318
;  :time                    0.00)
(assert (<= $Perm.No $k@24@05))
(assert (<= $k@24@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@24@05)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder.Full_adder_m == diz.Full_adder_m
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               605
;  :arith-assert-diseq      14
;  :arith-assert-lower      42
;  :arith-assert-upper      28
;  :arith-conflicts         1
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               105
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             511
;  :mk-clause               33
;  :num-allocs              3724165
;  :num-checks              113
;  :propagations            35
;  :quant-instantiations    20
;  :rlimit-count            126751)
(push) ; 3
(assert (not (< $Perm.No $k@23@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               605
;  :arith-assert-diseq      14
;  :arith-assert-lower      42
;  :arith-assert-upper      28
;  :arith-conflicts         1
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               106
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             511
;  :mk-clause               33
;  :num-allocs              3724165
;  :num-checks              114
;  :propagations            35
;  :quant-instantiations    20
;  :rlimit-count            126799)
(push) ; 3
(assert (not (< $Perm.No $k@24@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               605
;  :arith-assert-diseq      14
;  :arith-assert-lower      42
;  :arith-assert-upper      28
;  :arith-conflicts         1
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               107
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             511
;  :mk-clause               33
;  :num-allocs              3724165
;  :num-checks              115
;  :propagations            35
;  :quant-instantiations    20
;  :rlimit-count            126847)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               605
;  :arith-assert-diseq      14
;  :arith-assert-lower      42
;  :arith-assert-upper      28
;  :arith-conflicts         1
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               108
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             511
;  :mk-clause               33
;  :num-allocs              3724165
;  :num-checks              116
;  :propagations            35
;  :quant-instantiations    20
;  :rlimit-count            126895)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@20@05))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               613
;  :arith-assert-diseq      14
;  :arith-assert-lower      42
;  :arith-assert-upper      28
;  :arith-conflicts         1
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               109
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             514
;  :mk-clause               33
;  :num-allocs              3724165
;  :num-checks              117
;  :propagations            35
;  :quant-instantiations    21
;  :rlimit-count            127382)
(declare-const $k@25@05 $Perm)
(assert ($Perm.isReadVar $k@25@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@25@05 $Perm.No) (< $Perm.No $k@25@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               613
;  :arith-assert-diseq      15
;  :arith-assert-lower      44
;  :arith-assert-upper      29
;  :arith-conflicts         1
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               110
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             518
;  :mk-clause               35
;  :num-allocs              3724165
;  :num-checks              118
;  :propagations            36
;  :quant-instantiations    21
;  :rlimit-count            127580)
(assert (<= $Perm.No $k@25@05))
(assert (<= $k@25@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@25@05)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@20@05)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder_prc != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               619
;  :arith-assert-diseq      15
;  :arith-assert-lower      44
;  :arith-assert-upper      30
;  :arith-conflicts         1
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               111
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             521
;  :mk-clause               35
;  :num-allocs              3724165
;  :num-checks              119
;  :propagations            36
;  :quant-instantiations    21
;  :rlimit-count            128033)
(push) ; 3
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               619
;  :arith-assert-diseq      15
;  :arith-assert-lower      44
;  :arith-assert-upper      30
;  :arith-conflicts         1
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               112
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             521
;  :mk-clause               35
;  :num-allocs              3724165
;  :num-checks              120
;  :propagations            36
;  :quant-instantiations    21
;  :rlimit-count            128081)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               625
;  :arith-assert-diseq      15
;  :arith-assert-lower      44
;  :arith-assert-upper      30
;  :arith-conflicts         1
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               113
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             524
;  :mk-clause               35
;  :num-allocs              3724165
;  :num-checks              121
;  :propagations            36
;  :quant-instantiations    22
;  :rlimit-count            128565)
(push) ; 3
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               625
;  :arith-assert-diseq      15
;  :arith-assert-lower      44
;  :arith-assert-upper      30
;  :arith-conflicts         1
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               114
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             524
;  :mk-clause               35
;  :num-allocs              3724165
;  :num-checks              122
;  :propagations            36
;  :quant-instantiations    22
;  :rlimit-count            128613)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               625
;  :arith-assert-diseq      15
;  :arith-assert-lower      44
;  :arith-assert-upper      30
;  :arith-conflicts         1
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               114
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             524
;  :mk-clause               35
;  :num-allocs              3724165
;  :num-checks              123
;  :propagations            36
;  :quant-instantiations    22
;  :rlimit-count            128626)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               630
;  :arith-assert-diseq      15
;  :arith-assert-lower      44
;  :arith-assert-upper      30
;  :arith-conflicts         1
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               115
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             525
;  :mk-clause               35
;  :num-allocs              3724165
;  :num-checks              124
;  :propagations            36
;  :quant-instantiations    22
;  :rlimit-count            129013)
(declare-const $k@26@05 $Perm)
(assert ($Perm.isReadVar $k@26@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@26@05 $Perm.No) (< $Perm.No $k@26@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               630
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      31
;  :arith-conflicts         1
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               116
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             529
;  :mk-clause               37
;  :num-allocs              3724165
;  :num-checks              125
;  :propagations            37
;  :quant-instantiations    22
;  :rlimit-count            129212)
(assert (<= $Perm.No $k@26@05))
(assert (<= $k@26@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@26@05)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@20@05)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder_half_adder1 != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               636
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      32
;  :arith-conflicts         1
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               117
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             532
;  :mk-clause               37
;  :num-allocs              3724165
;  :num-checks              126
;  :propagations            37
;  :quant-instantiations    22
;  :rlimit-count            129695)
(push) ; 3
(assert (not (< $Perm.No $k@26@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               636
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      32
;  :arith-conflicts         1
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               118
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             532
;  :mk-clause               37
;  :num-allocs              3724165
;  :num-checks              127
;  :propagations            37
;  :quant-instantiations    22
;  :rlimit-count            129743)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               642
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      32
;  :arith-conflicts         1
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               119
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             535
;  :mk-clause               37
;  :num-allocs              3724165
;  :num-checks              128
;  :propagations            37
;  :quant-instantiations    23
;  :rlimit-count            130259)
(push) ; 3
(assert (not (< $Perm.No $k@26@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               642
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      32
;  :arith-conflicts         1
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               120
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             535
;  :mk-clause               37
;  :num-allocs              3724165
;  :num-checks              129
;  :propagations            37
;  :quant-instantiations    23
;  :rlimit-count            130307)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               642
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      32
;  :arith-conflicts         1
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               120
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             535
;  :mk-clause               37
;  :num-allocs              3724165
;  :num-checks              130
;  :propagations            37
;  :quant-instantiations    23
;  :rlimit-count            130320)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               647
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      32
;  :arith-conflicts         1
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               121
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             536
;  :mk-clause               37
;  :num-allocs              3724165
;  :num-checks              131
;  :propagations            37
;  :quant-instantiations    23
;  :rlimit-count            130737)
(declare-const $k@27@05 $Perm)
(assert ($Perm.isReadVar $k@27@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@27@05 $Perm.No) (< $Perm.No $k@27@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               647
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      33
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               122
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             540
;  :mk-clause               39
;  :num-allocs              3724165
;  :num-checks              132
;  :propagations            38
;  :quant-instantiations    23
;  :rlimit-count            130936)
(assert (<= $Perm.No $k@27@05))
(assert (<= $k@27@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@27@05)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@20@05)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder_half_adder2 != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               653
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      34
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             543
;  :mk-clause               39
;  :num-allocs              3724165
;  :num-checks              133
;  :propagations            38
;  :quant-instantiations    23
;  :rlimit-count            131449)
(push) ; 3
(assert (not (< $Perm.No $k@27@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               653
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      34
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             543
;  :mk-clause               39
;  :num-allocs              3724165
;  :num-checks              134
;  :propagations            38
;  :quant-instantiations    23
;  :rlimit-count            131497)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               659
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      34
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               125
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             546
;  :mk-clause               39
;  :num-allocs              3724165
;  :num-checks              135
;  :propagations            38
;  :quant-instantiations    24
;  :rlimit-count            132043)
(push) ; 3
(assert (not (< $Perm.No $k@27@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               659
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      34
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             546
;  :mk-clause               39
;  :num-allocs              3724165
;  :num-checks              136
;  :propagations            38
;  :quant-instantiations    24
;  :rlimit-count            132091)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               659
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      34
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             546
;  :mk-clause               39
;  :num-allocs              3724165
;  :num-checks              137
;  :propagations            38
;  :quant-instantiations    24
;  :rlimit-count            132104)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               664
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      34
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               127
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             547
;  :mk-clause               39
;  :num-allocs              3724165
;  :num-checks              138
;  :propagations            38
;  :quant-instantiations    24
;  :rlimit-count            132551)
(declare-const $k@28@05 $Perm)
(assert ($Perm.isReadVar $k@28@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@28@05 $Perm.No) (< $Perm.No $k@28@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               664
;  :arith-assert-diseq      18
;  :arith-assert-lower      50
;  :arith-assert-upper      35
;  :arith-conflicts         1
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               128
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             551
;  :mk-clause               41
;  :num-allocs              3724165
;  :num-checks              139
;  :propagations            39
;  :quant-instantiations    24
;  :rlimit-count            132750)
(declare-const $t@29@05 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@23@05)
    (=
      $t@29@05
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))
  (implies
    (< $Perm.No $k@28@05)
    (=
      $t@29@05
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@23@05 $k@28@05)))
(assert (<= (+ $k@23@05 $k@28@05) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@23@05 $k@28@05))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@20@05)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      18
;  :arith-assert-lower      51
;  :arith-assert-upper      36
;  :arith-conflicts         1
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               129
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             557
;  :mk-clause               41
;  :num-allocs              3724165
;  :num-checks              140
;  :propagations            39
;  :quant-instantiations    25
;  :rlimit-count            133441)
(push) ; 3
(assert (not (< $Perm.No (+ $k@23@05 $k@28@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      18
;  :arith-assert-lower      51
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               130
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              25
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             558
;  :mk-clause               41
;  :num-allocs              3724165
;  :num-checks              141
;  :propagations            39
;  :quant-instantiations    25
;  :rlimit-count            133501)
(assert (= $t@29@05 diz@5@05))
(pop) ; 2
(push) ; 2
; [exec]
; var s_nand__3: Bool
(declare-const s_nand__3@30@05 Bool)
; [exec]
; var s_or__4: Bool
(declare-const s_or__4@31@05 Bool)
; [exec]
; s_nand__3 := !(a && b)
; [eval] !(a && b)
; [eval] a && b
(push) ; 3
; [then-branch: 8 | a@7@05 | live]
; [else-branch: 8 | !(a@7@05) | live]
(push) ; 4
; [then-branch: 8 | a@7@05]
(assert a@7@05)
(pop) ; 4
(push) ; 4
; [else-branch: 8 | !(a@7@05)]
(assert (not a@7@05))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(declare-const s_nand__3@32@05 Bool)
(assert (= s_nand__3@32@05 (not (and b@8@05 a@7@05))))
; [exec]
; s_or__4 := a || b
; [eval] a || b
(push) ; 3
; [then-branch: 9 | a@7@05 | live]
; [else-branch: 9 | !(a@7@05) | live]
(push) ; 4
; [then-branch: 9 | a@7@05]
(assert a@7@05)
(pop) ; 4
(push) ; 4
; [else-branch: 9 | !(a@7@05)]
(assert (not a@7@05))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(declare-const s_or__4@33@05 Bool)
(assert (= s_or__4@33@05 (or a@7@05 b@8@05)))
; [exec]
; sys__result := s_nand__3 && s_or__4
; [eval] s_nand__3 && s_or__4
(push) ; 3
; [then-branch: 10 | s_nand__3@32@05 | live]
; [else-branch: 10 | !(s_nand__3@32@05) | live]
(push) ; 4
; [then-branch: 10 | s_nand__3@32@05]
(assert s_nand__3@32@05)
(pop) ; 4
(push) ; 4
; [else-branch: 10 | !(s_nand__3@32@05)]
(assert (not s_nand__3@32@05))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(declare-const sys__result@34@05 Bool)
(assert (= sys__result@34@05 (and s_or__4@33@05 s_nand__3@32@05)))
; [exec]
; // assert
; assert acc(diz.Full_adder_m, wildcard) && diz.Full_adder_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.Full_adder_m, globals), write) && acc(diz.Full_adder_m.Main_process_state, write) && |diz.Full_adder_m.Main_process_state| == 3 && acc(diz.Full_adder_m.Main_event_state, write) && |diz.Full_adder_m.Main_event_state| == 6 && (forall i__5: Int :: { diz.Full_adder_m.Main_process_state[i__5] } 0 <= i__5 && i__5 < |diz.Full_adder_m.Main_process_state| ==> diz.Full_adder_m.Main_process_state[i__5] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i__5] && diz.Full_adder_m.Main_process_state[i__5] < |diz.Full_adder_m.Main_event_state|) && acc(diz.Full_adder_m.Main_adder, wildcard) && diz.Full_adder_m.Main_adder != null && acc(diz.Full_adder_m.Main_adder.Full_adder_a, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_b, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_carry_in, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_sum, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_sum_next, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_carry_out, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_c1, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_s1, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_c2, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_m, wildcard) && diz.Full_adder_m.Main_adder.Full_adder_m == diz.Full_adder_m && acc(diz.Full_adder_m.Main_adder_prc, wildcard) && diz.Full_adder_m.Main_adder_prc != null && acc(diz.Full_adder_m.Main_adder_prc.Prc_or_init, 1 / 2) && acc(diz.Full_adder_m.Main_adder_half_adder1, wildcard) && diz.Full_adder_m.Main_adder_half_adder1 != null && acc(diz.Full_adder_m.Main_adder_half_adder1.Prc_half_adder_1_init, 1 / 2) && acc(diz.Full_adder_m.Main_adder_half_adder2, wildcard) && diz.Full_adder_m.Main_adder_half_adder2 != null && acc(diz.Full_adder_m.Main_adder_half_adder2.Prc_half_adder_2_init, 1 / 2) && acc(diz.Full_adder_m.Main_adder, wildcard) && diz.Full_adder_m.Main_adder == diz
(declare-const $k@35@05 $Perm)
(assert ($Perm.isReadVar $k@35@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@35@05 $Perm.No) (< $Perm.No $k@35@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      19
;  :arith-assert-lower      53
;  :arith-assert-upper      38
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               131
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             570
;  :mk-clause               58
;  :num-allocs              3724165
;  :num-checks              142
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            133970)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $k@11@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      19
;  :arith-assert-lower      53
;  :arith-assert-upper      38
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               131
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             570
;  :mk-clause               58
;  :num-allocs              3724165
;  :num-checks              143
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            133981)
(assert (< $k@35@05 $k@11@05))
(assert (<= $Perm.No (- $k@11@05 $k@35@05)))
(assert (<= (- $k@11@05 $k@35@05) $Perm.Write))
(assert (implies (< $Perm.No (- $k@11@05 $k@35@05)) (not (= diz@5@05 $Ref.null))))
; [eval] diz.Full_adder_m != null
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      19
;  :arith-assert-lower      55
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             573
;  :mk-clause               58
;  :num-allocs              3724165
;  :num-checks              144
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            134189)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      19
;  :arith-assert-lower      55
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               133
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             573
;  :mk-clause               58
;  :num-allocs              3724165
;  :num-checks              145
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            134237)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      19
;  :arith-assert-lower      55
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               134
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             573
;  :mk-clause               58
;  :num-allocs              3724165
;  :num-checks              146
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            134285)
; [eval] |diz.Full_adder_m.Main_process_state| == 3
; [eval] |diz.Full_adder_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      19
;  :arith-assert-lower      55
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               135
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             573
;  :mk-clause               58
;  :num-allocs              3724165
;  :num-checks              147
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            134333)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      19
;  :arith-assert-lower      55
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               136
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             573
;  :mk-clause               58
;  :num-allocs              3724165
;  :num-checks              148
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            134381)
; [eval] |diz.Full_adder_m.Main_event_state| == 6
; [eval] |diz.Full_adder_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      19
;  :arith-assert-lower      55
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             573
;  :mk-clause               58
;  :num-allocs              3724165
;  :num-checks              149
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            134429)
; [eval] (forall i__5: Int :: { diz.Full_adder_m.Main_process_state[i__5] } 0 <= i__5 && i__5 < |diz.Full_adder_m.Main_process_state| ==> diz.Full_adder_m.Main_process_state[i__5] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i__5] && diz.Full_adder_m.Main_process_state[i__5] < |diz.Full_adder_m.Main_event_state|)
(declare-const i__5@36@05 Int)
(push) ; 3
; [eval] 0 <= i__5 && i__5 < |diz.Full_adder_m.Main_process_state| ==> diz.Full_adder_m.Main_process_state[i__5] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i__5] && diz.Full_adder_m.Main_process_state[i__5] < |diz.Full_adder_m.Main_event_state|
; [eval] 0 <= i__5 && i__5 < |diz.Full_adder_m.Main_process_state|
; [eval] 0 <= i__5
(push) ; 4
; [then-branch: 11 | 0 <= i__5@36@05 | live]
; [else-branch: 11 | !(0 <= i__5@36@05) | live]
(push) ; 5
; [then-branch: 11 | 0 <= i__5@36@05]
(assert (<= 0 i__5@36@05))
; [eval] i__5 < |diz.Full_adder_m.Main_process_state|
; [eval] |diz.Full_adder_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      19
;  :arith-assert-lower      56
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               138
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             574
;  :mk-clause               58
;  :num-allocs              3724165
;  :num-checks              150
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            134529)
(pop) ; 5
(push) ; 5
; [else-branch: 11 | !(0 <= i__5@36@05)]
(assert (not (<= 0 i__5@36@05)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 12 | i__5@36@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i__5@36@05 | live]
; [else-branch: 12 | !(i__5@36@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i__5@36@05) | live]
(push) ; 5
; [then-branch: 12 | i__5@36@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i__5@36@05]
(assert (and
  (<
    i__5@36@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
  (<= 0 i__5@36@05)))
; [eval] diz.Full_adder_m.Main_process_state[i__5] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i__5] && diz.Full_adder_m.Main_process_state[i__5] < |diz.Full_adder_m.Main_event_state|
; [eval] diz.Full_adder_m.Main_process_state[i__5] == -1
; [eval] diz.Full_adder_m.Main_process_state[i__5]
(push) ; 6
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      40
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               139
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             576
;  :mk-clause               58
;  :num-allocs              3724165
;  :num-checks              151
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            134686)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i__5@36@05 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      40
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               139
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             576
;  :mk-clause               58
;  :num-allocs              3724165
;  :num-checks              152
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            134695)
; [eval] -1
(push) ; 6
; [then-branch: 13 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__5@36@05] == -1 | live]
; [else-branch: 13 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__5@36@05] != -1 | live]
(push) ; 7
; [then-branch: 13 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__5@36@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i__5@36@05)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 13 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__5@36@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
      i__5@36@05)
    (- 0 1))))
; [eval] 0 <= diz.Full_adder_m.Main_process_state[i__5] && diz.Full_adder_m.Main_process_state[i__5] < |diz.Full_adder_m.Main_event_state|
; [eval] 0 <= diz.Full_adder_m.Main_process_state[i__5]
; [eval] diz.Full_adder_m.Main_process_state[i__5]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      20
;  :arith-assert-lower      60
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             582
;  :mk-clause               62
;  :num-allocs              3724165
;  :num-checks              153
;  :propagations            42
;  :quant-instantiations    26
;  :rlimit-count            134978)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i__5@36@05 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      20
;  :arith-assert-lower      60
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             582
;  :mk-clause               62
;  :num-allocs              3724165
;  :num-checks              154
;  :propagations            42
;  :quant-instantiations    26
;  :rlimit-count            134987)
(push) ; 8
; [then-branch: 14 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__5@36@05] | live]
; [else-branch: 14 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__5@36@05]) | live]
(push) ; 9
; [then-branch: 14 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__5@36@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i__5@36@05)))
; [eval] diz.Full_adder_m.Main_process_state[i__5] < |diz.Full_adder_m.Main_event_state|
; [eval] diz.Full_adder_m.Main_process_state[i__5]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      20
;  :arith-assert-lower      60
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               141
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             582
;  :mk-clause               62
;  :num-allocs              3724165
;  :num-checks              155
;  :propagations            42
;  :quant-instantiations    26
;  :rlimit-count            135150)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__5@36@05 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      20
;  :arith-assert-lower      60
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               141
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             582
;  :mk-clause               62
;  :num-allocs              3724165
;  :num-checks              156
;  :propagations            42
;  :quant-instantiations    26
;  :rlimit-count            135159)
; [eval] |diz.Full_adder_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      20
;  :arith-assert-lower      60
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               142
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              39
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             582
;  :mk-clause               62
;  :num-allocs              3724165
;  :num-checks              157
;  :propagations            42
;  :quant-instantiations    26
;  :rlimit-count            135207)
(pop) ; 9
(push) ; 9
; [else-branch: 14 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__5@36@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
      i__5@36@05))))
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
; [else-branch: 12 | !(i__5@36@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i__5@36@05)]
(assert (not
  (and
    (<
      i__5@36@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
    (<= 0 i__5@36@05))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(set-option :timeout 0)
(push) ; 3
(assert (not (forall ((i__5@36@05 Int)) (!
  (implies
    (and
      (<
        i__5@36@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
      (<= 0 i__5@36@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
          i__5@36@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i__5@36@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i__5@36@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i__5@36@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      42
;  :arith-conflicts         2
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               143
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              55
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             590
;  :mk-clause               74
;  :num-allocs              3724165
;  :num-checks              158
;  :propagations            44
;  :quant-instantiations    27
;  :rlimit-count            135665)
(assert (forall ((i__5@36@05 Int)) (!
  (implies
    (and
      (<
        i__5@36@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
      (<= 0 i__5@36@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
          i__5@36@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i__5@36@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i__5@36@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i__5@36@05))
  :qid |prog.l<no position>|)))
(declare-const $k@37@05 $Perm)
(assert ($Perm.isReadVar $k@37@05 $Perm.Write))
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      43
;  :arith-conflicts         2
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               144
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              55
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             595
;  :mk-clause               76
;  :num-allocs              3724165
;  :num-checks              159
;  :propagations            45
;  :quant-instantiations    27
;  :rlimit-count            136241)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@37@05 $Perm.No) (< $Perm.No $k@37@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      43
;  :arith-conflicts         2
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               145
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              55
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             595
;  :mk-clause               76
;  :num-allocs              3724165
;  :num-checks              160
;  :propagations            45
;  :quant-instantiations    27
;  :rlimit-count            136291)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (+ $k@13@05 $k@18@05) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      44
;  :arith-conflicts         3
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               146
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             597
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              161
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            136353)
(assert (< $k@37@05 (+ $k@13@05 $k@18@05)))
(assert (<= $Perm.No (- (+ $k@13@05 $k@18@05) $k@37@05)))
(assert (<= (- (+ $k@13@05 $k@18@05) $k@37@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@13@05 $k@18@05) $k@37@05))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
; [eval] diz.Full_adder_m.Main_adder != null
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      45
;  :arith-conflicts         3
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               147
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             600
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              162
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            136570)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      46
;  :arith-conflicts         4
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               148
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             601
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              163
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            136633)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= $t@19@05 $Ref.null))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      46
;  :arith-conflicts         4
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               148
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             601
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              164
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            136651)
(assert (not (= $t@19@05 $Ref.null)))
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      46
;  :arith-conflicts         4
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               149
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             601
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              165
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            136719)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      47
;  :arith-conflicts         5
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         4
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               150
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             602
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              166
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            136782)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $t@19@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      47
;  :arith-conflicts         5
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         4
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               151
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             603
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              167
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            136952)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      47
;  :arith-conflicts         5
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         4
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               152
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             603
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              168
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            137000)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      48
;  :arith-conflicts         6
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         5
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               153
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             604
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              169
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            137063)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $t@19@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      48
;  :arith-conflicts         6
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         5
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               154
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             605
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              170
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            137233)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      48
;  :arith-conflicts         6
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         5
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             605
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              171
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            137281)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      49
;  :arith-conflicts         7
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         6
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               156
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             606
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              172
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            137344)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $t@19@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      49
;  :arith-conflicts         7
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         6
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               157
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             607
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              173
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            137514)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      49
;  :arith-conflicts         7
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         6
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               158
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             607
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              174
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            137562)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      50
;  :arith-conflicts         8
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               159
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             608
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              175
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            137625)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $t@19@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      50
;  :arith-conflicts         8
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               160
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             609
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              176
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            137795)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      50
;  :arith-conflicts         8
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               161
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             609
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              177
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            137843)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      51
;  :arith-conflicts         9
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               162
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             610
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              178
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            137906)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $t@19@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      51
;  :arith-conflicts         9
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               163
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             611
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              179
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            138076)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      51
;  :arith-conflicts         9
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               164
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             611
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              180
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            138124)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      52
;  :arith-conflicts         10
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         9
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               165
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             612
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              181
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            138187)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $t@19@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      52
;  :arith-conflicts         10
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         9
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               166
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             613
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              182
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            138357)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      52
;  :arith-conflicts         10
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         9
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               167
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             613
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              183
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            138405)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      53
;  :arith-conflicts         11
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               168
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             614
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              184
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            138468)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $t@19@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      53
;  :arith-conflicts         11
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               169
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             615
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              185
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            138638)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      53
;  :arith-conflicts         11
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               170
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             615
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              186
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            138686)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      54
;  :arith-conflicts         12
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               171
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             616
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              187
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            138749)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $t@19@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      54
;  :arith-conflicts         12
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               172
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             617
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              188
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            138919)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      54
;  :arith-conflicts         12
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               173
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             617
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              189
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            138967)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      55
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         12
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               174
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             618
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              190
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            139030)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $t@19@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      55
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         12
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               175
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             619
;  :mk-clause               78
;  :num-allocs              3724165
;  :num-checks              191
;  :propagations            46
;  :quant-instantiations    27
;  :rlimit-count            139200)
(declare-const $k@38@05 $Perm)
(assert ($Perm.isReadVar $k@38@05 $Perm.Write))
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      23
;  :arith-assert-lower      67
;  :arith-assert-upper      56
;  :arith-conflicts         13
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         12
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               176
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             623
;  :mk-clause               80
;  :num-allocs              3724165
;  :num-checks              192
;  :propagations            47
;  :quant-instantiations    27
;  :rlimit-count            139397)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      23
;  :arith-assert-lower      67
;  :arith-assert-upper      57
;  :arith-conflicts         14
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         13
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               177
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             624
;  :mk-clause               80
;  :num-allocs              3724165
;  :num-checks              193
;  :propagations            47
;  :quant-instantiations    27
;  :rlimit-count            139460)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@38@05 $Perm.No) (< $Perm.No $k@38@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      23
;  :arith-assert-lower      67
;  :arith-assert-upper      57
;  :arith-conflicts         14
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         13
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               178
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             624
;  :mk-clause               80
;  :num-allocs              3724165
;  :num-checks              194
;  :propagations            47
;  :quant-instantiations    27
;  :rlimit-count            139510)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $t@19@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      23
;  :arith-assert-lower      67
;  :arith-assert-upper      57
;  :arith-conflicts         14
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         13
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               179
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             625
;  :mk-clause               80
;  :num-allocs              3724165
;  :num-checks              195
;  :propagations            47
;  :quant-instantiations    27
;  :rlimit-count            139680)
(push) ; 3
(assert (not (not (= $k@14@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      23
;  :arith-assert-lower      67
;  :arith-assert-upper      57
;  :arith-conflicts         14
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         13
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               179
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             625
;  :mk-clause               80
;  :num-allocs              3724165
;  :num-checks              196
;  :propagations            47
;  :quant-instantiations    27
;  :rlimit-count            139691)
(assert (< $k@38@05 $k@14@05))
(assert (<= $Perm.No (- $k@14@05 $k@38@05)))
(assert (<= (- $k@14@05 $k@38@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@14@05 $k@38@05))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
      $Ref.null))))
; [eval] diz.Full_adder_m.Main_adder.Full_adder_m == diz.Full_adder_m
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      58
;  :arith-conflicts         14
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         13
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               180
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             628
;  :mk-clause               80
;  :num-allocs              3724165
;  :num-checks              197
;  :propagations            47
;  :quant-instantiations    27
;  :rlimit-count            139905)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      59
;  :arith-conflicts         15
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         14
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               181
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             629
;  :mk-clause               80
;  :num-allocs              3724165
;  :num-checks              198
;  :propagations            47
;  :quant-instantiations    27
;  :rlimit-count            139968)
(push) ; 3
(assert (not (= diz@5@05 $t@19@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      59
;  :arith-conflicts         15
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         14
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               181
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             629
;  :mk-clause               80
;  :num-allocs              3724165
;  :num-checks              199
;  :propagations            47
;  :quant-instantiations    27
;  :rlimit-count            139979)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      59
;  :arith-conflicts         15
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         14
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               182
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             629
;  :mk-clause               80
;  :num-allocs              3724165
;  :num-checks              200
;  :propagations            47
;  :quant-instantiations    27
;  :rlimit-count            140027)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      59
;  :arith-conflicts         15
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         14
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               183
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             629
;  :mk-clause               80
;  :num-allocs              3724165
;  :num-checks              201
;  :propagations            47
;  :quant-instantiations    27
;  :rlimit-count            140075)
(declare-const $k@39@05 $Perm)
(assert ($Perm.isReadVar $k@39@05 $Perm.Write))
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      24
;  :arith-assert-lower      71
;  :arith-assert-upper      60
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         14
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               184
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             633
;  :mk-clause               82
;  :num-allocs              3724165
;  :num-checks              202
;  :propagations            48
;  :quant-instantiations    27
;  :rlimit-count            140271)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@39@05 $Perm.No) (< $Perm.No $k@39@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      24
;  :arith-assert-lower      71
;  :arith-assert-upper      60
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         14
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               185
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             633
;  :mk-clause               82
;  :num-allocs              3724165
;  :num-checks              203
;  :propagations            48
;  :quant-instantiations    27
;  :rlimit-count            140321)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $k@15@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      24
;  :arith-assert-lower      71
;  :arith-assert-upper      60
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         14
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               185
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             633
;  :mk-clause               82
;  :num-allocs              3724165
;  :num-checks              204
;  :propagations            48
;  :quant-instantiations    27
;  :rlimit-count            140332)
(assert (< $k@39@05 $k@15@05))
(assert (<= $Perm.No (- $k@15@05 $k@39@05)))
(assert (<= (- $k@15@05 $k@39@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@15@05 $k@39@05))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
; [eval] diz.Full_adder_m.Main_adder_prc != null
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      61
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         14
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               186
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             636
;  :mk-clause               82
;  :num-allocs              3724165
;  :num-checks              205
;  :propagations            48
;  :quant-instantiations    27
;  :rlimit-count            140552)
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      61
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         14
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               187
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             636
;  :mk-clause               82
;  :num-allocs              3724165
;  :num-checks              206
;  :propagations            48
;  :quant-instantiations    27
;  :rlimit-count            140600)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      61
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         14
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               187
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             636
;  :mk-clause               82
;  :num-allocs              3724165
;  :num-checks              207
;  :propagations            48
;  :quant-instantiations    27
;  :rlimit-count            140613)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      61
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         14
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               188
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             636
;  :mk-clause               82
;  :num-allocs              3724165
;  :num-checks              208
;  :propagations            48
;  :quant-instantiations    27
;  :rlimit-count            140661)
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      61
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         14
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               189
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             636
;  :mk-clause               82
;  :num-allocs              3724165
;  :num-checks              209
;  :propagations            48
;  :quant-instantiations    27
;  :rlimit-count            140709)
(declare-const $k@40@05 $Perm)
(assert ($Perm.isReadVar $k@40@05 $Perm.Write))
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      75
;  :arith-assert-upper      62
;  :arith-conflicts         15
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         14
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               190
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             640
;  :mk-clause               84
;  :num-allocs              3724165
;  :num-checks              210
;  :propagations            49
;  :quant-instantiations    27
;  :rlimit-count            140905)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@40@05 $Perm.No) (< $Perm.No $k@40@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      75
;  :arith-assert-upper      62
;  :arith-conflicts         15
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         14
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               191
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             640
;  :mk-clause               84
;  :num-allocs              3724165
;  :num-checks              211
;  :propagations            49
;  :quant-instantiations    27
;  :rlimit-count            140955)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $k@16@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      75
;  :arith-assert-upper      62
;  :arith-conflicts         15
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         14
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               191
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             640
;  :mk-clause               84
;  :num-allocs              3724165
;  :num-checks              212
;  :propagations            49
;  :quant-instantiations    27
;  :rlimit-count            140966)
(assert (< $k@40@05 $k@16@05))
(assert (<= $Perm.No (- $k@16@05 $k@40@05)))
(assert (<= (- $k@16@05 $k@40@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@16@05 $k@40@05))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
; [eval] diz.Full_adder_m.Main_adder_half_adder1 != null
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      77
;  :arith-assert-upper      63
;  :arith-conflicts         15
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         14
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               192
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             643
;  :mk-clause               84
;  :num-allocs              3724165
;  :num-checks              213
;  :propagations            49
;  :quant-instantiations    27
;  :rlimit-count            141180)
(push) ; 3
(assert (not (< $Perm.No $k@16@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      77
;  :arith-assert-upper      63
;  :arith-conflicts         15
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         14
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               193
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             643
;  :mk-clause               84
;  :num-allocs              3724165
;  :num-checks              214
;  :propagations            49
;  :quant-instantiations    27
;  :rlimit-count            141228)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      77
;  :arith-assert-upper      63
;  :arith-conflicts         15
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         14
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               193
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             643
;  :mk-clause               84
;  :num-allocs              3724165
;  :num-checks              215
;  :propagations            49
;  :quant-instantiations    27
;  :rlimit-count            141241)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      77
;  :arith-assert-upper      63
;  :arith-conflicts         15
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         14
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               194
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             643
;  :mk-clause               84
;  :num-allocs              3724165
;  :num-checks              216
;  :propagations            49
;  :quant-instantiations    27
;  :rlimit-count            141289)
(push) ; 3
(assert (not (< $Perm.No $k@16@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      77
;  :arith-assert-upper      63
;  :arith-conflicts         15
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         14
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               195
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             643
;  :mk-clause               84
;  :num-allocs              3724165
;  :num-checks              217
;  :propagations            49
;  :quant-instantiations    27
;  :rlimit-count            141337)
(declare-const $k@41@05 $Perm)
(assert ($Perm.isReadVar $k@41@05 $Perm.Write))
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      79
;  :arith-assert-upper      64
;  :arith-conflicts         15
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         14
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               196
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             647
;  :mk-clause               86
;  :num-allocs              3724165
;  :num-checks              218
;  :propagations            50
;  :quant-instantiations    27
;  :rlimit-count            141534)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@41@05 $Perm.No) (< $Perm.No $k@41@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      79
;  :arith-assert-upper      64
;  :arith-conflicts         15
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         14
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               197
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             647
;  :mk-clause               86
;  :num-allocs              3724165
;  :num-checks              219
;  :propagations            50
;  :quant-instantiations    27
;  :rlimit-count            141584)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $k@17@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      79
;  :arith-assert-upper      64
;  :arith-conflicts         15
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         14
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               197
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             647
;  :mk-clause               86
;  :num-allocs              3724165
;  :num-checks              220
;  :propagations            50
;  :quant-instantiations    27
;  :rlimit-count            141595)
(assert (< $k@41@05 $k@17@05))
(assert (<= $Perm.No (- $k@17@05 $k@41@05)))
(assert (<= (- $k@17@05 $k@41@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@17@05 $k@41@05))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
; [eval] diz.Full_adder_m.Main_adder_half_adder2 != null
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      81
;  :arith-assert-upper      65
;  :arith-conflicts         15
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         14
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               198
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             650
;  :mk-clause               86
;  :num-allocs              3724165
;  :num-checks              221
;  :propagations            50
;  :quant-instantiations    27
;  :rlimit-count            141809)
(push) ; 3
(assert (not (< $Perm.No $k@17@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      81
;  :arith-assert-upper      65
;  :arith-conflicts         15
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         14
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               199
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             650
;  :mk-clause               86
;  :num-allocs              3724165
;  :num-checks              222
;  :propagations            50
;  :quant-instantiations    27
;  :rlimit-count            141857)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      81
;  :arith-assert-upper      65
;  :arith-conflicts         15
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         14
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               199
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             650
;  :mk-clause               86
;  :num-allocs              3724165
;  :num-checks              223
;  :propagations            50
;  :quant-instantiations    27
;  :rlimit-count            141870)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      81
;  :arith-assert-upper      65
;  :arith-conflicts         15
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         14
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               200
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             650
;  :mk-clause               86
;  :num-allocs              3724165
;  :num-checks              224
;  :propagations            50
;  :quant-instantiations    27
;  :rlimit-count            141918)
(push) ; 3
(assert (not (< $Perm.No $k@17@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      81
;  :arith-assert-upper      65
;  :arith-conflicts         15
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         14
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               201
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             650
;  :mk-clause               86
;  :num-allocs              3724165
;  :num-checks              225
;  :propagations            50
;  :quant-instantiations    27
;  :rlimit-count            141966)
(declare-const $k@42@05 $Perm)
(assert ($Perm.isReadVar $k@42@05 $Perm.Write))
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      27
;  :arith-assert-lower      83
;  :arith-assert-upper      66
;  :arith-conflicts         15
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         14
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               202
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             654
;  :mk-clause               88
;  :num-allocs              3724165
;  :num-checks              226
;  :propagations            51
;  :quant-instantiations    27
;  :rlimit-count            142163)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@42@05 $Perm.No) (< $Perm.No $k@42@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      27
;  :arith-assert-lower      83
;  :arith-assert-upper      66
;  :arith-conflicts         15
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         14
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               203
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             654
;  :mk-clause               88
;  :num-allocs              3724165
;  :num-checks              227
;  :propagations            51
;  :quant-instantiations    27
;  :rlimit-count            142213)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- (+ $k@13@05 $k@18@05) $k@37@05) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          1
;  :arith-assert-diseq      27
;  :arith-assert-lower      83
;  :arith-assert-upper      66
;  :arith-conflicts         15
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         14
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               204
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             655
;  :mk-clause               88
;  :num-allocs              3724165
;  :num-checks              228
;  :propagations            51
;  :quant-instantiations    27
;  :rlimit-count            142287)
(assert (< $k@42@05 (- (+ $k@13@05 $k@18@05) $k@37@05)))
(assert (<= $Perm.No (- (- (+ $k@13@05 $k@18@05) $k@37@05) $k@42@05)))
(assert (<= (- (- (+ $k@13@05 $k@18@05) $k@37@05) $k@42@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- (+ $k@13@05 $k@18@05) $k@37@05) $k@42@05))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
; [eval] diz.Full_adder_m.Main_adder == diz
(push) ; 3
(assert (not (< $Perm.No $k@11@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          3
;  :arith-assert-diseq      27
;  :arith-assert-lower      85
;  :arith-assert-upper      67
;  :arith-conflicts         15
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         14
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               205
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             658
;  :mk-clause               88
;  :num-allocs              3724165
;  :num-checks              229
;  :propagations            51
;  :quant-instantiations    27
;  :rlimit-count            142548)
(push) ; 3
(assert (not (< $Perm.No (+ $k@13@05 $k@18@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               670
;  :arith-add-rows          3
;  :arith-assert-diseq      27
;  :arith-assert-lower      85
;  :arith-assert-upper      68
;  :arith-conflicts         16
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         15
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               206
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   14
;  :datatype-splits         79
;  :decisions               104
;  :del-clause              57
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             659
;  :mk-clause               88
;  :num-allocs              3724165
;  :num-checks              230
;  :propagations            51
;  :quant-instantiations    27
;  :rlimit-count            142611)
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
