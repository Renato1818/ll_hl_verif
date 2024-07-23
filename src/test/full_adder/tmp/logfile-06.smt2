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
; ---------- Full_adder___contract_unsatisfiable__sum__EncodedGlobalVariables_Boolean_Boolean ----------
(declare-const diz@0@06 $Ref)
(declare-const globals@1@06 $Ref)
(declare-const a@2@06 Bool)
(declare-const b@3@06 Bool)
(declare-const sys__result@4@06 Bool)
(declare-const diz@5@06 $Ref)
(declare-const globals@6@06 $Ref)
(declare-const a@7@06 Bool)
(declare-const b@8@06 Bool)
(declare-const sys__result@9@06 Bool)
(push) ; 1
(declare-const $t@10@06 $Snap)
(assert (= $t@10@06 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@5@06 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.Full_adder_m, wildcard) && diz.Full_adder_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.Full_adder_m, globals), write) && (true && (true && acc(diz.Full_adder_m.Main_process_state, write) && |diz.Full_adder_m.Main_process_state| == 3 && acc(diz.Full_adder_m.Main_event_state, write) && |diz.Full_adder_m.Main_event_state| == 6 && (forall i__2: Int :: { diz.Full_adder_m.Main_process_state[i__2] } 0 <= i__2 && i__2 < |diz.Full_adder_m.Main_process_state| ==> diz.Full_adder_m.Main_process_state[i__2] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i__2] && diz.Full_adder_m.Main_process_state[i__2] < |diz.Full_adder_m.Main_event_state|)) && acc(diz.Full_adder_m.Main_adder, wildcard) && diz.Full_adder_m.Main_adder != null && acc(diz.Full_adder_m.Main_adder.Full_adder_a, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_b, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_carry_in, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_sum, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_sum_next, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_carry_out, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_c1, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_s1, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_c2, write) && acc(diz.Full_adder_m.Main_adder.Full_adder_m, wildcard) && diz.Full_adder_m.Main_adder.Full_adder_m == diz.Full_adder_m && acc(diz.Full_adder_m.Main_adder_prc, wildcard) && diz.Full_adder_m.Main_adder_prc != null && acc(diz.Full_adder_m.Main_adder_prc.Prc_or_init, 1 / 2) && acc(diz.Full_adder_m.Main_adder_half_adder1, wildcard) && diz.Full_adder_m.Main_adder_half_adder1 != null && acc(diz.Full_adder_m.Main_adder_half_adder1.Prc_half_adder_1_init, 1 / 2) && acc(diz.Full_adder_m.Main_adder_half_adder2, wildcard) && diz.Full_adder_m.Main_adder_half_adder2 != null && acc(diz.Full_adder_m.Main_adder_half_adder2.Prc_half_adder_2_init, 1 / 2)) && acc(diz.Full_adder_m.Main_adder, wildcard) && diz.Full_adder_m.Main_adder == diz)
(declare-const $t@11@06 $Snap)
(assert (= $t@11@06 ($Snap.combine ($Snap.first $t@11@06) ($Snap.second $t@11@06))))
(assert (= ($Snap.first $t@11@06) $Snap.unit))
(assert (=
  ($Snap.second $t@11@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@11@06))
    ($Snap.second ($Snap.second $t@11@06)))))
(declare-const $k@12@06 $Perm)
(assert ($Perm.isReadVar $k@12@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@12@06 $Perm.No) (< $Perm.No $k@12@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             19
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   22
;  :conflicts             1
;  :datatype-accessor-ax  3
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.67
;  :mk-bool-var           246
;  :mk-clause             3
;  :num-allocs            3250513
;  :num-checks            2
;  :propagations          23
;  :quant-instantiations  1
;  :rlimit-count          101054)
(assert (<= $Perm.No $k@12@06))
(assert (<= $k@12@06 $Perm.Write))
(assert (implies (< $Perm.No $k@12@06) (not (= diz@5@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@11@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@11@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@11@06))) $Snap.unit))
; [eval] diz.Full_adder_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             25
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   22
;  :conflicts             2
;  :datatype-accessor-ax  4
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.67
;  :mk-bool-var           249
;  :mk-clause             3
;  :num-allocs            3250513
;  :num-checks            3
;  :propagations          23
;  :quant-instantiations  1
;  :rlimit-count          101307)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@11@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@11@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             31
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   22
;  :conflicts             3
;  :datatype-accessor-ax  5
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.67
;  :mk-bool-var           252
;  :mk-clause             3
;  :num-allocs            3250513
;  :num-checks            4
;  :propagations          23
;  :quant-instantiations  2
;  :rlimit-count          101591)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             48
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   22
;  :conflicts             4
;  :datatype-accessor-ax  8
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.67
;  :mk-bool-var           257
;  :mk-clause             3
;  :num-allocs            3250513
;  :num-checks            5
;  :propagations          23
;  :quant-instantiations  2
;  :rlimit-count          102031)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
  $Snap.unit))
; [eval] |diz.Full_adder_m.Main_process_state| == 3
; [eval] |diz.Full_adder_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             54
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   22
;  :conflicts             5
;  :datatype-accessor-ax  9
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.77
;  :mk-bool-var           259
;  :mk-clause             3
;  :num-allocs            3360255
;  :num-checks            6
;  :propagations          23
;  :quant-instantiations  2
;  :rlimit-count          102280)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             61
;  :arith-assert-diseq    2
;  :arith-assert-lower    6
;  :arith-assert-upper    4
;  :arith-eq-adapter      4
;  :binary-propagations   22
;  :conflicts             6
;  :datatype-accessor-ax  10
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.77
;  :mk-bool-var           268
;  :mk-clause             6
;  :num-allocs            3360255
;  :num-checks            7
;  :propagations          24
;  :quant-instantiations  5
;  :rlimit-count          102665)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
  $Snap.unit))
; [eval] |diz.Full_adder_m.Main_event_state| == 6
; [eval] |diz.Full_adder_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             67
;  :arith-assert-diseq    2
;  :arith-assert-lower    6
;  :arith-assert-upper    4
;  :arith-eq-adapter      4
;  :binary-propagations   22
;  :conflicts             7
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.77
;  :mk-bool-var           270
;  :mk-clause             6
;  :num-allocs            3360255
;  :num-checks            8
;  :propagations          24
;  :quant-instantiations  5
;  :rlimit-count          102934)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))
  $Snap.unit))
; [eval] (forall i__2: Int :: { diz.Full_adder_m.Main_process_state[i__2] } 0 <= i__2 && i__2 < |diz.Full_adder_m.Main_process_state| ==> diz.Full_adder_m.Main_process_state[i__2] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i__2] && diz.Full_adder_m.Main_process_state[i__2] < |diz.Full_adder_m.Main_event_state|)
(declare-const i__2@13@06 Int)
(push) ; 3
; [eval] 0 <= i__2 && i__2 < |diz.Full_adder_m.Main_process_state| ==> diz.Full_adder_m.Main_process_state[i__2] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i__2] && diz.Full_adder_m.Main_process_state[i__2] < |diz.Full_adder_m.Main_event_state|
; [eval] 0 <= i__2 && i__2 < |diz.Full_adder_m.Main_process_state|
; [eval] 0 <= i__2
(push) ; 4
; [then-branch: 0 | 0 <= i__2@13@06 | live]
; [else-branch: 0 | !(0 <= i__2@13@06) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i__2@13@06]
(assert (<= 0 i__2@13@06))
; [eval] i__2 < |diz.Full_adder_m.Main_process_state|
; [eval] |diz.Full_adder_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    3
;  :arith-assert-lower    10
;  :arith-assert-upper    5
;  :arith-eq-adapter      6
;  :binary-propagations   22
;  :conflicts             8
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.77
;  :mk-bool-var           281
;  :mk-clause             9
;  :num-allocs            3360255
;  :num-checks            9
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          103426)
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i__2@13@06)]
(assert (not (<= 0 i__2@13@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i__2@13@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))| && 0 <= i__2@13@06 | live]
; [else-branch: 1 | !(i__2@13@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))| && 0 <= i__2@13@06) | live]
(push) ; 5
; [then-branch: 1 | i__2@13@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))| && 0 <= i__2@13@06]
(assert (and
  (<
    i__2@13@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
  (<= 0 i__2@13@06)))
; [eval] diz.Full_adder_m.Main_process_state[i__2] == -1 || 0 <= diz.Full_adder_m.Main_process_state[i__2] && diz.Full_adder_m.Main_process_state[i__2] < |diz.Full_adder_m.Main_event_state|
; [eval] diz.Full_adder_m.Main_process_state[i__2] == -1
; [eval] diz.Full_adder_m.Main_process_state[i__2]
(push) ; 6
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             9
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.77
;  :mk-bool-var           283
;  :mk-clause             9
;  :num-allocs            3360255
;  :num-checks            10
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          103583)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i__2@13@06 0)))
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
;  :binary-propagations   22
;  :conflicts             9
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.77
;  :mk-bool-var           283
;  :mk-clause             9
;  :num-allocs            3360255
;  :num-checks            11
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          103592)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
    i__2@13@06)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
      i__2@13@06)
    (- 0 1))))
; [eval] 0 <= diz.Full_adder_m.Main_process_state[i__2] && diz.Full_adder_m.Main_process_state[i__2] < |diz.Full_adder_m.Main_event_state|
; [eval] 0 <= diz.Full_adder_m.Main_process_state[i__2]
; [eval] diz.Full_adder_m.Main_process_state[i__2]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             10
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.77
;  :mk-bool-var           284
;  :mk-clause             9
;  :num-allocs            3360255
;  :num-checks            12
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          103842)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i__2@13@06 0)))
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
;  :binary-propagations   22
;  :conflicts             10
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.77
;  :mk-bool-var           284
;  :mk-clause             9
;  :num-allocs            3360255
;  :num-checks            13
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          103851)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
    i__2@13@06)))
; [eval] diz.Full_adder_m.Main_process_state[i__2] < |diz.Full_adder_m.Main_event_state|
; [eval] diz.Full_adder_m.Main_process_state[i__2]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             11
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.77
;  :mk-bool-var           287
;  :mk-clause             10
;  :num-allocs            3360255
;  :num-checks            14
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          104044)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__2@13@06 0)))
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
;  :binary-propagations   22
;  :conflicts             11
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.77
;  :mk-bool-var           287
;  :mk-clause             10
;  :num-allocs            3360255
;  :num-checks            15
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          104053)
; [eval] |diz.Full_adder_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             12
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.77
;  :mk-bool-var           287
;  :mk-clause             10
;  :num-allocs            3360255
;  :num-checks            16
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          104101)
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
      i__2@13@06))))
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
; [else-branch: 1 | !(i__2@13@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))| && 0 <= i__2@13@06)]
(assert (not
  (and
    (<
      i__2@13@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
    (<= 0 i__2@13@06))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__2@13@06 Int)) (!
  (implies
    (and
      (<
        i__2@13@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
      (<= 0 i__2@13@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
          i__2@13@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
            i__2@13@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
            i__2@13@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
    i__2@13@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             13
;  :datatype-accessor-ax  13
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           289
;  :mk-clause             10
;  :num-allocs            3471691
;  :num-checks            17
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          104816)
(declare-const $k@14@06 $Perm)
(assert ($Perm.isReadVar $k@14@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@14@06 $Perm.No) (< $Perm.No $k@14@06))))
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
;  :binary-propagations   22
;  :conflicts             14
;  :datatype-accessor-ax  13
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           293
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            18
;  :propagations          26
;  :quant-instantiations  8
;  :rlimit-count          105014)
(assert (<= $Perm.No $k@14@06))
(assert (<= $k@14@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@14@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             15
;  :datatype-accessor-ax  14
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           296
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            19
;  :propagations          26
;  :quant-instantiations  8
;  :rlimit-count          105367)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :binary-propagations   22
;  :conflicts             16
;  :datatype-accessor-ax  14
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           296
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            20
;  :propagations          26
;  :quant-instantiations  8
;  :rlimit-count          105415)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             17
;  :datatype-accessor-ax  15
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           299
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            21
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          105801)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :binary-propagations   22
;  :conflicts             18
;  :datatype-accessor-ax  15
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           299
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            22
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          105849)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             19
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           300
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            23
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          106136)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :binary-propagations   22
;  :conflicts             20
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           300
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            24
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          106184)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             21
;  :datatype-accessor-ax  17
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           301
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            25
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          106481)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :binary-propagations   22
;  :conflicts             22
;  :datatype-accessor-ax  17
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           301
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            26
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          106529)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             23
;  :datatype-accessor-ax  18
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           302
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            27
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          106836)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :binary-propagations   22
;  :conflicts             24
;  :datatype-accessor-ax  18
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           302
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            28
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          106884
;  :time                  0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             25
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           303
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            29
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          107201)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             112
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :binary-propagations   22
;  :conflicts             26
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           303
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            30
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          107249
;  :time                  0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :binary-propagations   22
;  :conflicts             27
;  :datatype-accessor-ax  20
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           304
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            31
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          107576)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :binary-propagations   22
;  :conflicts             28
;  :datatype-accessor-ax  20
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           304
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            32
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          107624)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             122
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :binary-propagations   22
;  :conflicts             29
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           305
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            33
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          107961)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             122
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :binary-propagations   22
;  :conflicts             30
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           305
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            34
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          108009)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             127
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :binary-propagations   22
;  :conflicts             31
;  :datatype-accessor-ax  22
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           306
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            35
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          108356)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             127
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :binary-propagations   22
;  :conflicts             32
;  :datatype-accessor-ax  22
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           306
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            36
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          108404)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             132
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :binary-propagations   22
;  :conflicts             33
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           307
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            37
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          108761)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             132
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :binary-propagations   22
;  :conflicts             34
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           307
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            38
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          108809)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             137
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :binary-propagations   22
;  :conflicts             35
;  :datatype-accessor-ax  24
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           308
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            39
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          109176)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             137
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :binary-propagations   22
;  :conflicts             36
;  :datatype-accessor-ax  24
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           308
;  :mk-clause             12
;  :num-allocs            3471691
;  :num-checks            40
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          109224)
(declare-const $k@15@06 $Perm)
(assert ($Perm.isReadVar $k@15@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@15@06 $Perm.No) (< $Perm.No $k@15@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             137
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    9
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             37
;  :datatype-accessor-ax  24
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.95
;  :mk-bool-var           312
;  :mk-clause             14
;  :num-allocs            3471691
;  :num-checks            41
;  :propagations          27
;  :quant-instantiations  9
;  :rlimit-count          109423)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@5@06
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               183
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      9
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               38
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             332
;  :mk-clause               15
;  :num-allocs              3471691
;  :num-checks              42
;  :propagations            27
;  :quant-instantiations    9
;  :rlimit-count            110158
;  :time                    0.00)
(assert (<= $Perm.No $k@15@06))
(assert (<= $k@15@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@15@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder.Full_adder_m == diz.Full_adder_m
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               189
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               39
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             335
;  :mk-clause               15
;  :num-allocs              3471691
;  :num-checks              43
;  :propagations            27
;  :quant-instantiations    9
;  :rlimit-count            110621)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               189
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               40
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             335
;  :mk-clause               15
;  :num-allocs              3471691
;  :num-checks              44
;  :propagations            27
;  :quant-instantiations    9
;  :rlimit-count            110669)
(push) ; 3
(assert (not (< $Perm.No $k@15@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               189
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               41
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             335
;  :mk-clause               15
;  :num-allocs              3471691
;  :num-checks              45
;  :propagations            27
;  :quant-instantiations    9
;  :rlimit-count            110717)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               189
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               42
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             335
;  :mk-clause               15
;  :num-allocs              3471691
;  :num-checks              46
;  :propagations            27
;  :quant-instantiations    9
;  :rlimit-count            110765)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               197
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     22
;  :conflicts               43
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             338
;  :mk-clause               15
;  :num-allocs              3471691
;  :num-checks              47
;  :propagations            27
;  :quant-instantiations    10
;  :rlimit-count            111282)
(declare-const $k@16@06 $Perm)
(assert ($Perm.isReadVar $k@16@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@16@06 $Perm.No) (< $Perm.No $k@16@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               197
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      11
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               44
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             342
;  :mk-clause               17
;  :num-allocs              3471691
;  :num-checks              48
;  :propagations            28
;  :quant-instantiations    10
;  :rlimit-count            111481)
(assert (<= $Perm.No $k@16@06))
(assert (<= $k@16@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@16@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder_prc != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               203
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               45
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             345
;  :mk-clause               17
;  :num-allocs              3471691
;  :num-checks              49
;  :propagations            28
;  :quant-instantiations    10
;  :rlimit-count            111964
;  :time                    0.00)
(push) ; 3
(assert (not (< $Perm.No $k@16@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               203
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               46
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             345
;  :mk-clause               17
;  :num-allocs              3471691
;  :num-checks              50
;  :propagations            28
;  :quant-instantiations    10
;  :rlimit-count            112012)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               209
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               47
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             348
;  :mk-clause               17
;  :num-allocs              3471691
;  :num-checks              51
;  :propagations            28
;  :quant-instantiations    11
;  :rlimit-count            112526)
(push) ; 3
(assert (not (< $Perm.No $k@16@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               209
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               48
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             348
;  :mk-clause               17
;  :num-allocs              3471691
;  :num-checks              52
;  :propagations            28
;  :quant-instantiations    11
;  :rlimit-count            112574)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               209
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               48
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             348
;  :mk-clause               17
;  :num-allocs              3471691
;  :num-checks              53
;  :propagations            28
;  :quant-instantiations    11
;  :rlimit-count            112587)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               214
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               49
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             349
;  :mk-clause               17
;  :num-allocs              3471691
;  :num-checks              54
;  :propagations            28
;  :quant-instantiations    11
;  :rlimit-count            113004)
(declare-const $k@17@06 $Perm)
(assert ($Perm.isReadVar $k@17@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@17@06 $Perm.No) (< $Perm.No $k@17@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               214
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               50
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             353
;  :mk-clause               19
;  :num-allocs              3471691
;  :num-checks              55
;  :propagations            29
;  :quant-instantiations    11
;  :rlimit-count            113202)
(assert (<= $Perm.No $k@17@06))
(assert (<= $k@17@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@17@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder_half_adder1 != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               220
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               51
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             356
;  :mk-clause               19
;  :num-allocs              3471691
;  :num-checks              56
;  :propagations            29
;  :quant-instantiations    11
;  :rlimit-count            113715)
(push) ; 3
(assert (not (< $Perm.No $k@17@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               220
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               52
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             356
;  :mk-clause               19
;  :num-allocs              3471691
;  :num-checks              57
;  :propagations            29
;  :quant-instantiations    11
;  :rlimit-count            113763)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               226
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               53
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             359
;  :mk-clause               19
;  :num-allocs              3471691
;  :num-checks              58
;  :propagations            29
;  :quant-instantiations    12
;  :rlimit-count            114309)
(push) ; 3
(assert (not (< $Perm.No $k@17@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               226
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               54
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             359
;  :mk-clause               19
;  :num-allocs              3471691
;  :num-checks              59
;  :propagations            29
;  :quant-instantiations    12
;  :rlimit-count            114357)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               226
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               54
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             359
;  :mk-clause               19
;  :num-allocs              3471691
;  :num-checks              60
;  :propagations            29
;  :quant-instantiations    12
;  :rlimit-count            114370)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               231
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               55
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             360
;  :mk-clause               19
;  :num-allocs              3471691
;  :num-checks              61
;  :propagations            29
;  :quant-instantiations    12
;  :rlimit-count            114817)
(declare-const $k@18@06 $Perm)
(assert ($Perm.isReadVar $k@18@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@18@06 $Perm.No) (< $Perm.No $k@18@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               231
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      15
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               56
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             364
;  :mk-clause               21
;  :num-allocs              3471691
;  :num-checks              62
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            115016)
(assert (<= $Perm.No $k@18@06))
(assert (<= $k@18@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@18@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder_half_adder2 != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               237
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               57
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             367
;  :mk-clause               21
;  :num-allocs              3471691
;  :num-checks              63
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            115559)
(push) ; 3
(assert (not (< $Perm.No $k@18@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               237
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               58
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             367
;  :mk-clause               21
;  :num-allocs              3471691
;  :num-checks              64
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            115607)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               243
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               59
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             370
;  :mk-clause               21
;  :num-allocs              3471691
;  :num-checks              65
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            116183)
(push) ; 3
(assert (not (< $Perm.No $k@18@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               243
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               60
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             370
;  :mk-clause               21
;  :num-allocs              3471691
;  :num-checks              66
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            116231)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               243
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               60
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             370
;  :mk-clause               21
;  :num-allocs              3471691
;  :num-checks              67
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            116244)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               248
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             371
;  :mk-clause               21
;  :num-allocs              3471691
;  :num-checks              68
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            116721)
(declare-const $k@19@06 $Perm)
(assert ($Perm.isReadVar $k@19@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@19@06 $Perm.No) (< $Perm.No $k@19@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               248
;  :arith-assert-diseq      10
;  :arith-assert-lower      26
;  :arith-assert-upper      17
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               62
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             375
;  :mk-clause               23
;  :num-allocs              3471691
;  :num-checks              69
;  :propagations            31
;  :quant-instantiations    13
;  :rlimit-count            116920)
(declare-const $t@20@06 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@14@06)
    (=
      $t@20@06
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))
  (implies
    (< $Perm.No $k@19@06)
    (=
      $t@20@06
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@14@06 $k@19@06)))
(assert (<= (+ $k@14@06 $k@19@06) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@14@06 $k@19@06))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Full_adder_m.Main_adder == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               253
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      18
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               63
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             381
;  :mk-clause               23
;  :num-allocs              3471691
;  :num-checks              70
;  :propagations            31
;  :quant-instantiations    14
;  :rlimit-count            117641)
(push) ; 3
(assert (not (< $Perm.No (+ $k@14@06 $k@19@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               253
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      19
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               64
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   7
;  :datatype-splits         18
;  :decisions               18
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             382
;  :mk-clause               23
;  :num-allocs              3471691
;  :num-checks              71
;  :propagations            31
;  :quant-instantiations    14
;  :rlimit-count            117707)
(assert (= $t@20@06 diz@5@06))
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
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
  diz@5@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               427
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      19
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               66
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 86
;  :datatype-occurs-check   21
;  :datatype-splits         44
;  :decisions               82
;  :del-clause              22
;  :final-checks            11
;  :max-generation          1
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             413
;  :mk-clause               24
;  :num-allocs              3471691
;  :num-checks              75
;  :propagations            33
;  :quant-instantiations    14
;  :rlimit-count            119776)
(declare-const $t@21@06 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@15@06)
    (=
      $t@21@06
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))
  (implies
    (< $Perm.No $k@12@06)
    (=
      $t@21@06
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))))))
(assert (<= $Perm.No (+ $k@15@06 $k@12@06)))
(assert (<= (+ $k@15@06 $k@12@06) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@15@06 $k@12@06))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
      $Ref.null))))
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Main_reset_events_no_delta_EncodedGlobalVariables ----------
(declare-const diz@22@06 $Ref)
(declare-const globals@23@06 $Ref)
(declare-const diz@24@06 $Ref)
(declare-const globals@25@06 $Ref)
(push) ; 1
(declare-const $t@26@06 $Snap)
(assert (= $t@26@06 ($Snap.combine ($Snap.first $t@26@06) ($Snap.second $t@26@06))))
(assert (= ($Snap.first $t@26@06) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@24@06 $Ref.null)))
(assert (=
  ($Snap.second $t@26@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@26@06))
    ($Snap.second ($Snap.second $t@26@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@26@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@26@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@26@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@06))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06)))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06)))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@27@06 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 4 | 0 <= i@27@06 | live]
; [else-branch: 4 | !(0 <= i@27@06) | live]
(push) ; 4
; [then-branch: 4 | 0 <= i@27@06]
(assert (<= 0 i@27@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 4 | !(0 <= i@27@06)]
(assert (not (<= 0 i@27@06)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 5 | i@27@06 < |First:(Second:(Second:($t@26@06)))| && 0 <= i@27@06 | live]
; [else-branch: 5 | !(i@27@06 < |First:(Second:(Second:($t@26@06)))| && 0 <= i@27@06) | live]
(push) ; 4
; [then-branch: 5 | i@27@06 < |First:(Second:(Second:($t@26@06)))| && 0 <= i@27@06]
(assert (and
  (<
    i@27@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))))
  (<= 0 i@27@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@27@06 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               522
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               66
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   25
;  :datatype-splits         46
;  :decisions               103
;  :del-clause              23
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             448
;  :mk-clause               30
;  :num-allocs              3595149
;  :num-checks              77
;  :propagations            36
;  :quant-instantiations    20
;  :rlimit-count            121780)
; [eval] -1
(push) ; 5
; [then-branch: 6 | First:(Second:(Second:($t@26@06)))[i@27@06] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:($t@26@06)))[i@27@06] != -1 | live]
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:($t@26@06)))[i@27@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))
    i@27@06)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 6 | First:(Second:(Second:($t@26@06)))[i@27@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))
      i@27@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@27@06 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               522
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               66
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   25
;  :datatype-splits         46
;  :decisions               103
;  :del-clause              23
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             449
;  :mk-clause               30
;  :num-allocs              3595149
;  :num-checks              78
;  :propagations            36
;  :quant-instantiations    20
;  :rlimit-count            121943)
(push) ; 7
; [then-branch: 7 | 0 <= First:(Second:(Second:($t@26@06)))[i@27@06] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:($t@26@06)))[i@27@06]) | live]
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:($t@26@06)))[i@27@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))
    i@27@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@27@06 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               522
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      23
;  :arith-conflicts         1
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               66
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   25
;  :datatype-splits         46
;  :decisions               103
;  :del-clause              23
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             452
;  :mk-clause               31
;  :num-allocs              3595149
;  :num-checks              79
;  :propagations            36
;  :quant-instantiations    20
;  :rlimit-count            122057)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 7 | !(0 <= First:(Second:(Second:($t@26@06)))[i@27@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))
      i@27@06))))
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
; [else-branch: 5 | !(i@27@06 < |First:(Second:(Second:($t@26@06)))| && 0 <= i@27@06)]
(assert (not
  (and
    (<
      i@27@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))))
    (<= 0 i@27@06))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@27@06 Int)) (!
  (implies
    (and
      (<
        i@27@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))))
      (<= 0 i@27@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))
          i@27@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))
            i@27@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))
            i@27@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))
    i@27@06))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@28@06 $Snap)
(assert (= $t@28@06 ($Snap.combine ($Snap.first $t@28@06) ($Snap.second $t@28@06))))
(assert (=
  ($Snap.second $t@28@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@28@06))
    ($Snap.second ($Snap.second $t@28@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@28@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@28@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@28@06))) $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@28@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@29@06 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 8 | 0 <= i@29@06 | live]
; [else-branch: 8 | !(0 <= i@29@06) | live]
(push) ; 5
; [then-branch: 8 | 0 <= i@29@06]
(assert (<= 0 i@29@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 8 | !(0 <= i@29@06)]
(assert (not (<= 0 i@29@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 9 | i@29@06 < |First:(Second:($t@28@06))| && 0 <= i@29@06 | live]
; [else-branch: 9 | !(i@29@06 < |First:(Second:($t@28@06))| && 0 <= i@29@06) | live]
(push) ; 5
; [then-branch: 9 | i@29@06 < |First:(Second:($t@28@06))| && 0 <= i@29@06]
(assert (and
  (<
    i@29@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))))
  (<= 0 i@29@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@29@06 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               577
;  :arith-assert-diseq      13
;  :arith-assert-lower      43
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               67
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   28
;  :datatype-splits         51
;  :decisions               108
;  :del-clause              30
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             480
;  :mk-clause               32
;  :num-allocs              3595149
;  :num-checks              81
;  :propagations            36
;  :quant-instantiations    24
;  :rlimit-count            123825)
; [eval] -1
(push) ; 6
; [then-branch: 10 | First:(Second:($t@28@06))[i@29@06] == -1 | live]
; [else-branch: 10 | First:(Second:($t@28@06))[i@29@06] != -1 | live]
(push) ; 7
; [then-branch: 10 | First:(Second:($t@28@06))[i@29@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))
    i@29@06)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 10 | First:(Second:($t@28@06))[i@29@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))
      i@29@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@29@06 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               577
;  :arith-assert-diseq      13
;  :arith-assert-lower      43
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               67
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   28
;  :datatype-splits         51
;  :decisions               108
;  :del-clause              30
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             481
;  :mk-clause               32
;  :num-allocs              3595149
;  :num-checks              82
;  :propagations            36
;  :quant-instantiations    24
;  :rlimit-count            123976)
(push) ; 8
; [then-branch: 11 | 0 <= First:(Second:($t@28@06))[i@29@06] | live]
; [else-branch: 11 | !(0 <= First:(Second:($t@28@06))[i@29@06]) | live]
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:($t@28@06))[i@29@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))
    i@29@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@29@06 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               577
;  :arith-assert-diseq      14
;  :arith-assert-lower      46
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               67
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   28
;  :datatype-splits         51
;  :decisions               108
;  :del-clause              30
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             484
;  :mk-clause               33
;  :num-allocs              3595149
;  :num-checks              83
;  :propagations            36
;  :quant-instantiations    24
;  :rlimit-count            124080)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 11 | !(0 <= First:(Second:($t@28@06))[i@29@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))
      i@29@06))))
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
; [else-branch: 9 | !(i@29@06 < |First:(Second:($t@28@06))| && 0 <= i@29@06)]
(assert (not
  (and
    (<
      i@29@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))))
    (<= 0 i@29@06))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@29@06 Int)) (!
  (implies
    (and
      (<
        i@29@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))))
      (<= 0 i@29@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))
          i@29@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))
            i@29@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))
            i@29@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))
    i@29@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@28@06)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@26@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               594
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               67
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   28
;  :datatype-splits         51
;  :decisions               108
;  :del-clause              31
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             503
;  :mk-clause               43
;  :num-allocs              3595149
;  :num-checks              84
;  :propagations            40
;  :quant-instantiations    26
;  :rlimit-count            125105)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               631
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               68
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 126
;  :datatype-occurs-check   34
;  :datatype-splits         58
;  :decisions               118
;  :del-clause              32
;  :final-checks            19
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             514
;  :mk-clause               44
;  :num-allocs              3595149
;  :num-checks              85
;  :propagations            41
;  :quant-instantiations    26
;  :rlimit-count            125680
;  :time                    0.00)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               667
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               69
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 138
;  :datatype-occurs-check   40
;  :datatype-splits         65
;  :decisions               128
;  :del-clause              33
;  :final-checks            22
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             525
;  :mk-clause               45
;  :num-allocs              3595149
;  :num-checks              86
;  :propagations            42
;  :quant-instantiations    26
;  :rlimit-count            126260
;  :time                    0.00)
; [then-branch: 12 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[0] == 0 | live]
; [else-branch: 12 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[0] != 0 | live]
(push) ; 4
; [then-branch: 12 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    0)
  0))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               668
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               69
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 138
;  :datatype-occurs-check   40
;  :datatype-splits         65
;  :decisions               128
;  :del-clause              33
;  :final-checks            22
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             526
;  :mk-clause               45
;  :num-allocs              3595149
;  :num-checks              87
;  :propagations            42
;  :quant-instantiations    26
;  :rlimit-count            126396)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 12 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      0)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               674
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               69
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 138
;  :datatype-occurs-check   40
;  :datatype-splits         65
;  :decisions               128
;  :del-clause              33
;  :final-checks            22
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             530
;  :mk-clause               46
;  :num-allocs              3595149
;  :num-checks              88
;  :propagations            42
;  :quant-instantiations    26
;  :rlimit-count            126843)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               712
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               70
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   46
;  :datatype-splits         76
;  :decisions               140
;  :del-clause              34
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             546
;  :mk-clause               47
;  :num-allocs              3595149
;  :num-checks              89
;  :propagations            43
;  :quant-instantiations    26
;  :rlimit-count            127444
;  :time                    0.00)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               749
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               71
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   52
;  :datatype-splits         87
;  :decisions               152
;  :del-clause              35
;  :final-checks            28
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             562
;  :mk-clause               48
;  :num-allocs              3595149
;  :num-checks              90
;  :propagations            44
;  :quant-instantiations    26
;  :rlimit-count            128054
;  :time                    0.00)
; [then-branch: 13 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[1] == 0 | live]
; [else-branch: 13 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[1] != 0 | live]
(push) ; 4
; [then-branch: 13 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    1)
  0))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               750
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               71
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   52
;  :datatype-splits         87
;  :decisions               152
;  :del-clause              35
;  :final-checks            28
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             563
;  :mk-clause               48
;  :num-allocs              3595149
;  :num-checks              91
;  :propagations            44
;  :quant-instantiations    26
;  :rlimit-count            128190)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 13 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      1)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[2]) == 0 ==> diz.Main_event_state[2] == -2
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 3
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               756
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               71
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   52
;  :datatype-splits         87
;  :decisions               152
;  :del-clause              35
;  :final-checks            28
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             567
;  :mk-clause               49
;  :num-allocs              3595149
;  :num-checks              92
;  :propagations            44
;  :quant-instantiations    26
;  :rlimit-count            128643)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      2)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               795
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               72
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 174
;  :datatype-occurs-check   58
;  :datatype-splits         98
;  :decisions               166
;  :del-clause              36
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             583
;  :mk-clause               50
;  :num-allocs              3595149
;  :num-checks              93
;  :propagations            45
;  :quant-instantiations    26
;  :rlimit-count            129274)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    2)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               833
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               73
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 186
;  :datatype-occurs-check   64
;  :datatype-splits         109
;  :decisions               180
;  :del-clause              37
;  :final-checks            34
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             599
;  :mk-clause               51
;  :num-allocs              3595149
;  :num-checks              94
;  :propagations            46
;  :quant-instantiations    26
;  :rlimit-count            129914
;  :time                    0.00)
; [then-branch: 14 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[2] == 0 | live]
; [else-branch: 14 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[2] != 0 | live]
(push) ; 4
; [then-branch: 14 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    2)
  0))
; [eval] diz.Main_event_state[2] == -2
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               834
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               73
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 186
;  :datatype-occurs-check   64
;  :datatype-splits         109
;  :decisions               180
;  :del-clause              37
;  :final-checks            34
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             600
;  :mk-clause               51
;  :num-allocs              3595149
;  :num-checks              95
;  :propagations            46
;  :quant-instantiations    26
;  :rlimit-count            130050)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 14 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      2)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      2)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[3]) == 0 ==> diz.Main_event_state[3] == -2
; [eval] old(diz.Main_event_state[3]) == 0
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 3
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               840
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               73
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 186
;  :datatype-occurs-check   64
;  :datatype-splits         109
;  :decisions               180
;  :del-clause              37
;  :final-checks            34
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             604
;  :mk-clause               52
;  :num-allocs              3595149
;  :num-checks              96
;  :propagations            46
;  :quant-instantiations    26
;  :rlimit-count            130513)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      3)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               880
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               74
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 198
;  :datatype-occurs-check   70
;  :datatype-splits         120
;  :decisions               196
;  :del-clause              38
;  :final-checks            37
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             620
;  :mk-clause               53
;  :num-allocs              3595149
;  :num-checks              97
;  :propagations            47
;  :quant-instantiations    26
;  :rlimit-count            131174
;  :time                    0.00)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    3)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               919
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               75
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 210
;  :datatype-occurs-check   76
;  :datatype-splits         131
;  :decisions               212
;  :del-clause              39
;  :final-checks            40
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             636
;  :mk-clause               54
;  :num-allocs              3595149
;  :num-checks              98
;  :propagations            48
;  :quant-instantiations    26
;  :rlimit-count            131844)
; [then-branch: 15 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[3] == 0 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[3] != 0 | live]
(push) ; 4
; [then-branch: 15 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[3] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    3)
  0))
; [eval] diz.Main_event_state[3] == -2
; [eval] diz.Main_event_state[3]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               920
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               75
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 210
;  :datatype-occurs-check   76
;  :datatype-splits         131
;  :decisions               212
;  :del-clause              39
;  :final-checks            40
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             637
;  :mk-clause               54
;  :num-allocs              3595149
;  :num-checks              99
;  :propagations            48
;  :quant-instantiations    26
;  :rlimit-count            131980)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 15 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[3] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      3)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      3)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      3)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[4]) == 0 ==> diz.Main_event_state[4] == -2
; [eval] old(diz.Main_event_state[4]) == 0
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 3
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               926
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               75
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 210
;  :datatype-occurs-check   76
;  :datatype-splits         131
;  :decisions               212
;  :del-clause              39
;  :final-checks            40
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             641
;  :mk-clause               55
;  :num-allocs              3595149
;  :num-checks              100
;  :propagations            48
;  :quant-instantiations    26
;  :rlimit-count            132453)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      4)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               967
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               76
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 222
;  :datatype-occurs-check   82
;  :datatype-splits         142
;  :decisions               230
;  :del-clause              40
;  :final-checks            43
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             657
;  :mk-clause               56
;  :num-allocs              3595149
;  :num-checks              101
;  :propagations            49
;  :quant-instantiations    26
;  :rlimit-count            133144)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    4)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1007
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               77
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 234
;  :datatype-occurs-check   88
;  :datatype-splits         153
;  :decisions               248
;  :del-clause              41
;  :final-checks            46
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             673
;  :mk-clause               57
;  :num-allocs              3595149
;  :num-checks              102
;  :propagations            50
;  :quant-instantiations    26
;  :rlimit-count            133844
;  :time                    0.00)
; [then-branch: 16 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[4] == 0 | live]
; [else-branch: 16 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[4] != 0 | live]
(push) ; 4
; [then-branch: 16 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[4] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    4)
  0))
; [eval] diz.Main_event_state[4] == -2
; [eval] diz.Main_event_state[4]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1008
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               77
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 234
;  :datatype-occurs-check   88
;  :datatype-splits         153
;  :decisions               248
;  :del-clause              41
;  :final-checks            46
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             674
;  :mk-clause               57
;  :num-allocs              3595149
;  :num-checks              103
;  :propagations            50
;  :quant-instantiations    26
;  :rlimit-count            133980)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 16 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[4] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      4)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      4)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      4)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[5]) == 0 ==> diz.Main_event_state[5] == -2
; [eval] old(diz.Main_event_state[5]) == 0
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 3
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1014
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               77
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 234
;  :datatype-occurs-check   88
;  :datatype-splits         153
;  :decisions               248
;  :del-clause              41
;  :final-checks            46
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             678
;  :mk-clause               58
;  :num-allocs              3595149
;  :num-checks              104
;  :propagations            50
;  :quant-instantiations    26
;  :rlimit-count            134463)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      5)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1056
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               78
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 246
;  :datatype-occurs-check   94
;  :datatype-splits         164
;  :decisions               268
;  :del-clause              42
;  :final-checks            49
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             694
;  :mk-clause               59
;  :num-allocs              3595149
;  :num-checks              105
;  :propagations            51
;  :quant-instantiations    26
;  :rlimit-count            135184
;  :time                    0.00)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    5)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1097
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               79
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   100
;  :datatype-splits         175
;  :decisions               288
;  :del-clause              43
;  :final-checks            52
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             710
;  :mk-clause               60
;  :num-allocs              3595149
;  :num-checks              106
;  :propagations            52
;  :quant-instantiations    26
;  :rlimit-count            135914
;  :time                    0.00)
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[5] == 0 | live]
; [else-branch: 17 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[5] != 0 | live]
(push) ; 4
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[5] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    5)
  0))
; [eval] diz.Main_event_state[5] == -2
; [eval] diz.Main_event_state[5]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1098
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               79
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   100
;  :datatype-splits         175
;  :decisions               288
;  :del-clause              43
;  :final-checks            52
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             711
;  :mk-clause               60
;  :num-allocs              3595149
;  :num-checks              107
;  :propagations            52
;  :quant-instantiations    26
;  :rlimit-count            136050)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 17 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[5] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      5)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      5)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      5)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[0]) == 0) ==> diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] !(old(diz.Main_event_state[0]) == 0)
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1104
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               79
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   100
;  :datatype-splits         175
;  :decisions               288
;  :del-clause              43
;  :final-checks            52
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             715
;  :mk-clause               61
;  :num-allocs              3595149
;  :num-checks              108
;  :propagations            52
;  :quant-instantiations    26
;  :rlimit-count            136543)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1146
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               80
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 270
;  :datatype-occurs-check   106
;  :datatype-splits         186
;  :decisions               308
;  :del-clause              44
;  :final-checks            55
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             730
;  :mk-clause               62
;  :num-allocs              3595149
;  :num-checks              109
;  :propagations            53
;  :quant-instantiations    26
;  :rlimit-count            137266
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1196
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               82
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   114
;  :datatype-splits         199
;  :decisions               330
;  :del-clause              46
;  :final-checks            59
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             754
;  :mk-clause               64
;  :num-allocs              3595149
;  :num-checks              110
;  :propagations            55
;  :quant-instantiations    26
;  :rlimit-count            138037)
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[0] != 0 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[0] == 0 | live]
(push) ; 4
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      0)
    0)))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1196
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               82
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   114
;  :datatype-splits         199
;  :decisions               330
;  :del-clause              46
;  :final-checks            59
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             754
;  :mk-clause               64
;  :num-allocs              3595149
;  :num-checks              111
;  :propagations            55
;  :quant-instantiations    26
;  :rlimit-count            138175)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1196
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               82
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   114
;  :datatype-splits         199
;  :decisions               330
;  :del-clause              46
;  :final-checks            59
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             754
;  :mk-clause               64
;  :num-allocs              3595149
;  :num-checks              112
;  :propagations            55
;  :quant-instantiations    26
;  :rlimit-count            138190)
(pop) ; 4
(push) ; 4
; [else-branch: 18 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    0)
  0))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
        0)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[1]) == 0) ==> diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] !(old(diz.Main_event_state[1]) == 0)
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1202
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               82
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   114
;  :datatype-splits         199
;  :decisions               330
;  :del-clause              46
;  :final-checks            59
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             757
;  :mk-clause               65
;  :num-allocs              3595149
;  :num-checks              113
;  :propagations            55
;  :quant-instantiations    26
;  :rlimit-count            138651)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1245
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               83
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 297
;  :datatype-occurs-check   120
;  :datatype-splits         210
;  :decisions               350
;  :del-clause              47
;  :final-checks            62
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             772
;  :mk-clause               66
;  :num-allocs              3595149
;  :num-checks              114
;  :propagations            58
;  :quant-instantiations    26
;  :rlimit-count            139387
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1297
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               85
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 312
;  :datatype-occurs-check   128
;  :datatype-splits         223
;  :decisions               372
;  :del-clause              49
;  :final-checks            66
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             796
;  :mk-clause               68
;  :num-allocs              3595149
;  :num-checks              115
;  :propagations            62
;  :quant-instantiations    26
;  :rlimit-count            140169
;  :time                    0.00)
; [then-branch: 19 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[1] != 0 | live]
; [else-branch: 19 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[1] == 0 | live]
(push) ; 4
; [then-branch: 19 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      1)
    0)))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1297
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               85
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 312
;  :datatype-occurs-check   128
;  :datatype-splits         223
;  :decisions               372
;  :del-clause              49
;  :final-checks            66
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             796
;  :mk-clause               68
;  :num-allocs              3595149
;  :num-checks              116
;  :propagations            62
;  :quant-instantiations    26
;  :rlimit-count            140307)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1297
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               85
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 312
;  :datatype-occurs-check   128
;  :datatype-splits         223
;  :decisions               372
;  :del-clause              49
;  :final-checks            66
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             796
;  :mk-clause               68
;  :num-allocs              3595149
;  :num-checks              117
;  :propagations            62
;  :quant-instantiations    26
;  :rlimit-count            140322)
(pop) ; 4
(push) ; 4
; [else-branch: 19 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    1)
  0))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
        1)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[2]) == 0) ==> diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] !(old(diz.Main_event_state[2]) == 0)
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 3
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1303
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               85
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 312
;  :datatype-occurs-check   128
;  :datatype-splits         223
;  :decisions               372
;  :del-clause              49
;  :final-checks            66
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             799
;  :mk-clause               69
;  :num-allocs              3595149
;  :num-checks              118
;  :propagations            62
;  :quant-instantiations    26
;  :rlimit-count            140793)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    2)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1347
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               86
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 324
;  :datatype-occurs-check   134
;  :datatype-splits         234
;  :decisions               392
;  :del-clause              50
;  :final-checks            69
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             814
;  :mk-clause               70
;  :num-allocs              3595149
;  :num-checks              119
;  :propagations            67
;  :quant-instantiations    26
;  :rlimit-count            141539
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      2)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1401
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               88
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 339
;  :datatype-occurs-check   142
;  :datatype-splits         247
;  :decisions               414
;  :del-clause              52
;  :final-checks            73
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             838
;  :mk-clause               72
;  :num-allocs              3595149
;  :num-checks              120
;  :propagations            73
;  :quant-instantiations    26
;  :rlimit-count            142332
;  :time                    0.00)
; [then-branch: 20 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[2] != 0 | live]
; [else-branch: 20 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[2] == 0 | live]
(push) ; 4
; [then-branch: 20 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      2)
    0)))
; [eval] diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1401
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               88
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 339
;  :datatype-occurs-check   142
;  :datatype-splits         247
;  :decisions               414
;  :del-clause              52
;  :final-checks            73
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             838
;  :mk-clause               72
;  :num-allocs              3595149
;  :num-checks              121
;  :propagations            73
;  :quant-instantiations    26
;  :rlimit-count            142470)
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1401
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               88
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 339
;  :datatype-occurs-check   142
;  :datatype-splits         247
;  :decisions               414
;  :del-clause              52
;  :final-checks            73
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             838
;  :mk-clause               72
;  :num-allocs              3595149
;  :num-checks              122
;  :propagations            73
;  :quant-instantiations    26
;  :rlimit-count            142485)
(pop) ; 4
(push) ; 4
; [else-branch: 20 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    2)
  0))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
        2)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[3]) == 0) ==> diz.Main_event_state[3] == old(diz.Main_event_state[3])
; [eval] !(old(diz.Main_event_state[3]) == 0)
; [eval] old(diz.Main_event_state[3]) == 0
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 3
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1407
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               88
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 339
;  :datatype-occurs-check   142
;  :datatype-splits         247
;  :decisions               414
;  :del-clause              52
;  :final-checks            73
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             841
;  :mk-clause               73
;  :num-allocs              3595149
;  :num-checks              123
;  :propagations            73
;  :quant-instantiations    26
;  :rlimit-count            142966)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    3)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1452
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               89
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 351
;  :datatype-occurs-check   148
;  :datatype-splits         258
;  :decisions               434
;  :del-clause              53
;  :final-checks            76
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             856
;  :mk-clause               74
;  :num-allocs              3595149
;  :num-checks              124
;  :propagations            80
;  :quant-instantiations    26
;  :rlimit-count            143722
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      3)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1508
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               91
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 366
;  :datatype-occurs-check   156
;  :datatype-splits         271
;  :decisions               456
;  :del-clause              55
;  :final-checks            80
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             880
;  :mk-clause               76
;  :num-allocs              3595149
;  :num-checks              125
;  :propagations            88
;  :quant-instantiations    26
;  :rlimit-count            144526
;  :time                    0.00)
; [then-branch: 21 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[3] != 0 | live]
; [else-branch: 21 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[3] == 0 | live]
(push) ; 4
; [then-branch: 21 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[3] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      3)
    0)))
; [eval] diz.Main_event_state[3] == old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1508
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               91
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 366
;  :datatype-occurs-check   156
;  :datatype-splits         271
;  :decisions               456
;  :del-clause              55
;  :final-checks            80
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             880
;  :mk-clause               76
;  :num-allocs              3595149
;  :num-checks              126
;  :propagations            88
;  :quant-instantiations    26
;  :rlimit-count            144664)
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1508
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               91
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 366
;  :datatype-occurs-check   156
;  :datatype-splits         271
;  :decisions               456
;  :del-clause              55
;  :final-checks            80
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             880
;  :mk-clause               76
;  :num-allocs              3595149
;  :num-checks              127
;  :propagations            88
;  :quant-instantiations    26
;  :rlimit-count            144679)
(pop) ; 4
(push) ; 4
; [else-branch: 21 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[3] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    3)
  0))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
        3)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      3)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      3))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[4]) == 0) ==> diz.Main_event_state[4] == old(diz.Main_event_state[4])
; [eval] !(old(diz.Main_event_state[4]) == 0)
; [eval] old(diz.Main_event_state[4]) == 0
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 3
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1514
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               91
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 366
;  :datatype-occurs-check   156
;  :datatype-splits         271
;  :decisions               456
;  :del-clause              55
;  :final-checks            80
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             883
;  :mk-clause               77
;  :num-allocs              3595149
;  :num-checks              128
;  :propagations            88
;  :quant-instantiations    26
;  :rlimit-count            145170)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    4)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1560
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               92
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 378
;  :datatype-occurs-check   162
;  :datatype-splits         282
;  :decisions               476
;  :del-clause              56
;  :final-checks            83
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             898
;  :mk-clause               78
;  :num-allocs              3595149
;  :num-checks              129
;  :propagations            97
;  :quant-instantiations    26
;  :rlimit-count            145936)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      4)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1618
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               94
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 393
;  :datatype-occurs-check   170
;  :datatype-splits         295
;  :decisions               498
;  :del-clause              58
;  :final-checks            87
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             922
;  :mk-clause               80
;  :num-allocs              3595149
;  :num-checks              130
;  :propagations            107
;  :quant-instantiations    26
;  :rlimit-count            146751
;  :time                    0.00)
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[4] != 0 | live]
; [else-branch: 22 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[4] == 0 | live]
(push) ; 4
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[4] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      4)
    0)))
; [eval] diz.Main_event_state[4] == old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1618
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               94
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 393
;  :datatype-occurs-check   170
;  :datatype-splits         295
;  :decisions               498
;  :del-clause              58
;  :final-checks            87
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             922
;  :mk-clause               80
;  :num-allocs              3595149
;  :num-checks              131
;  :propagations            107
;  :quant-instantiations    26
;  :rlimit-count            146889)
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1618
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               94
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 393
;  :datatype-occurs-check   170
;  :datatype-splits         295
;  :decisions               498
;  :del-clause              58
;  :final-checks            87
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             922
;  :mk-clause               80
;  :num-allocs              3595149
;  :num-checks              132
;  :propagations            107
;  :quant-instantiations    26
;  :rlimit-count            146904)
(pop) ; 4
(push) ; 4
; [else-branch: 22 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[4] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    4)
  0))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
        4)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      4)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      4))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[5]) == 0) ==> diz.Main_event_state[5] == old(diz.Main_event_state[5])
; [eval] !(old(diz.Main_event_state[5]) == 0)
; [eval] old(diz.Main_event_state[5]) == 0
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 3
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1620
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               94
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 393
;  :datatype-occurs-check   170
;  :datatype-splits         295
;  :decisions               498
;  :del-clause              58
;  :final-checks            87
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             924
;  :mk-clause               81
;  :num-allocs              3595149
;  :num-checks              133
;  :propagations            107
;  :quant-instantiations    26
;  :rlimit-count            147313)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    5)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1664
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               95
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 404
;  :datatype-occurs-check   176
;  :datatype-splits         304
;  :decisions               517
;  :del-clause              59
;  :final-checks            90
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             937
;  :mk-clause               82
;  :num-allocs              3595149
;  :num-checks              134
;  :propagations            118
;  :quant-instantiations    26
;  :rlimit-count            148075)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      5)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1721
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               97
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   184
;  :datatype-splits         315
;  :decisions               538
;  :del-clause              61
;  :final-checks            94
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             959
;  :mk-clause               84
;  :num-allocs              3595149
;  :num-checks              135
;  :propagations            130
;  :quant-instantiations    26
;  :rlimit-count            148887
;  :time                    0.00)
; [then-branch: 23 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[5] != 0 | live]
; [else-branch: 23 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[5] == 0 | live]
(push) ; 4
; [then-branch: 23 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[5] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      5)
    0)))
; [eval] diz.Main_event_state[5] == old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1721
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               97
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   184
;  :datatype-splits         315
;  :decisions               538
;  :del-clause              61
;  :final-checks            94
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             959
;  :mk-clause               84
;  :num-allocs              3595149
;  :num-checks              136
;  :propagations            130
;  :quant-instantiations    26
;  :rlimit-count            149025)
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1721
;  :arith-assert-diseq      14
;  :arith-assert-lower      47
;  :arith-assert-upper      27
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               97
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   184
;  :datatype-splits         315
;  :decisions               538
;  :del-clause              61
;  :final-checks            94
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             959
;  :mk-clause               84
;  :num-allocs              3595149
;  :num-checks              137
;  :propagations            130
;  :quant-instantiations    26
;  :rlimit-count            149040)
(pop) ; 4
(push) ; 4
; [else-branch: 23 | First:(Second:(Second:(Second:(Second:($t@26@06)))))[5] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
    5)
  0))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
        5)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
      5)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@06))))))
      5))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
