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
; ---------- Full_adder_Full_adder_EncodedGlobalVariables_Main ----------
(declare-const globals@0@07 $Ref)
(declare-const m_param@1@07 $Ref)
(declare-const sys__result@2@07 $Ref)
(declare-const globals@3@07 $Ref)
(declare-const m_param@4@07 $Ref)
(declare-const sys__result@5@07 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@6@07 $Snap)
(assert (= $t@6@07 ($Snap.combine ($Snap.first $t@6@07) ($Snap.second $t@6@07))))
(assert (= ($Snap.first $t@6@07) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@5@07 $Ref.null)))
(assert (=
  ($Snap.second $t@6@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@6@07))
    ($Snap.second ($Snap.second $t@6@07)))))
(assert (= ($Snap.first ($Snap.second $t@6@07)) $Snap.unit))
; [eval] type_of(sys__result) == class_Full_adder()
; [eval] type_of(sys__result)
; [eval] class_Full_adder()
(assert (= (type_of<TYPE> sys__result@5@07) (as class_Full_adder<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@6@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@6@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@6@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@6@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))
  $Snap.unit))
; [eval] sys__result.Full_adder_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@6@07))))
  m_param@4@07))
(pop) ; 2
(push) ; 2
; [exec]
; var diz__1: Ref
(declare-const diz__1@7@07 $Ref)
; [exec]
; diz__1 := new(Full_adder_m, Full_adder_a, Full_adder_b, Full_adder_carry_in, Full_adder_sum, Full_adder_carry_out, Full_adder_c1, Full_adder_s1, Full_adder_c2, Full_adder_sum_next)
(declare-const diz__1@8@07 $Ref)
(assert (not (= diz__1@8@07 $Ref.null)))
(declare-const Full_adder_m@9@07 $Ref)
(declare-const Full_adder_a@10@07 Bool)
(declare-const Full_adder_b@11@07 Bool)
(declare-const Full_adder_carry_in@12@07 Bool)
(declare-const Full_adder_sum@13@07 Bool)
(declare-const Full_adder_carry_out@14@07 Bool)
(declare-const Full_adder_c1@15@07 Bool)
(declare-const Full_adder_s1@16@07 Bool)
(declare-const Full_adder_c2@17@07 Bool)
(declare-const Full_adder_sum_next@18@07 Bool)
(assert (not (= diz__1@8@07 m_param@4@07)))
(assert (not (= diz__1@8@07 diz__1@7@07)))
(assert (not (= diz__1@8@07 sys__result@5@07)))
(assert (not (= diz__1@8@07 globals@3@07)))
; [exec]
; inhale type_of(diz__1) == class_Full_adder()
(declare-const $t@19@07 $Snap)
(assert (= $t@19@07 $Snap.unit))
; [eval] type_of(diz__1) == class_Full_adder()
; [eval] type_of(diz__1)
; [eval] class_Full_adder()
(assert (= (type_of<TYPE> diz__1@8@07) (as class_Full_adder<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz__1.Full_adder_m := m_param
; [exec]
; diz__1.Full_adder_a := false
; [exec]
; diz__1.Full_adder_b := false
; [exec]
; diz__1.Full_adder_carry_in := false
; [exec]
; diz__1.Full_adder_sum := false
; [exec]
; diz__1.Full_adder_carry_out := false
; [exec]
; diz__1.Full_adder_c1 := false
; [exec]
; diz__1.Full_adder_s1 := false
; [exec]
; diz__1.Full_adder_c2 := false
; [exec]
; sys__result := diz__1
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Full_adder() && acc(sys__result.Full_adder_m, write) && acc(sys__result.Full_adder_a, write) && acc(sys__result.Full_adder_b, write) && acc(sys__result.Full_adder_carry_in, write) && acc(sys__result.Full_adder_sum, write) && acc(sys__result.Full_adder_sum_next, write) && acc(sys__result.Full_adder_carry_out, write) && acc(sys__result.Full_adder_c1, write) && acc(sys__result.Full_adder_s1, write) && acc(sys__result.Full_adder_c2, write) && sys__result.Full_adder_m == m_param
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Full_adder()
; [eval] type_of(sys__result)
; [eval] class_Full_adder()
; [eval] sys__result.Full_adder_m == m_param
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Prc_half_adder_2_forkOperator_EncodedGlobalVariables ----------
(declare-const diz@20@07 $Ref)
(declare-const globals@21@07 $Ref)
(declare-const diz@22@07 $Ref)
(declare-const globals@23@07 $Ref)
(push) ; 1
(declare-const $t@24@07 $Snap)
(assert (= $t@24@07 ($Snap.combine ($Snap.first $t@24@07) ($Snap.second $t@24@07))))
(assert (= ($Snap.first $t@24@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@22@07 $Ref.null)))
(assert (=
  ($Snap.second $t@24@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@24@07))
    ($Snap.second ($Snap.second $t@24@07)))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             20
;  :arith-assert-lower    1
;  :arith-assert-upper    1
;  :arith-eq-adapter      1
;  :binary-propagations   22
;  :datatype-accessor-ax  4
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.67
;  :mk-bool-var           248
;  :mk-clause             1
;  :num-allocs            3250513
;  :num-checks            3
;  :propagations          22
;  :quant-instantiations  1
;  :rlimit-count          101556)
(assert (=
  ($Snap.second ($Snap.second $t@24@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@24@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@24@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@24@07))) $Snap.unit))
; [eval] diz.Prc_half_adder_2_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@24@07))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@24@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07)))))))
(declare-const $k@25@07 $Perm)
(assert ($Perm.isReadVar $k@25@07 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@25@07 $Perm.No) (< $Perm.No $k@25@07))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             32
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   22
;  :conflicts             1
;  :datatype-accessor-ax  6
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.67
;  :mk-bool-var           257
;  :mk-clause             3
;  :num-allocs            3250513
;  :num-checks            4
;  :propagations          23
;  :quant-instantiations  2
;  :rlimit-count          102128)
(assert (<= $Perm.No $k@25@07))
(assert (<= $k@25@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@25@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@24@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07)))))
  $Snap.unit))
; [eval] diz.Prc_half_adder_2_m.Main_adder_half_adder2 == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@25@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             38
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   22
;  :conflicts             2
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.67
;  :mk-bool-var           260
;  :mk-clause             3
;  :num-allocs            3250513
;  :num-checks            5
;  :propagations          23
;  :quant-instantiations  2
;  :rlimit-count          102401
;  :time                  0.00)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@07)))))
  diz@22@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07)))))))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             45
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   22
;  :conflicts             2
;  :datatype-accessor-ax  8
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.67
;  :mk-bool-var           263
;  :mk-clause             3
;  :num-allocs            3250513
;  :num-checks            6
;  :propagations          23
;  :quant-instantiations  3
;  :rlimit-count          102652)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07)))))))
  $Snap.unit))
; [eval] !diz.Prc_half_adder_2_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@07)))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@26@07 $Snap)
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Prc_or_forkOperator_EncodedGlobalVariables ----------
(declare-const diz@27@07 $Ref)
(declare-const globals@28@07 $Ref)
(declare-const diz@29@07 $Ref)
(declare-const globals@30@07 $Ref)
(push) ; 1
(declare-const $t@31@07 $Snap)
(assert (= $t@31@07 ($Snap.combine ($Snap.first $t@31@07) ($Snap.second $t@31@07))))
(assert (= ($Snap.first $t@31@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@29@07 $Ref.null)))
(assert (=
  ($Snap.second $t@31@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@31@07))
    ($Snap.second ($Snap.second $t@31@07)))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               76
;  :arith-assert-diseq      1
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-eq-adapter        2
;  :binary-propagations     22
;  :conflicts               2
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             276
;  :mk-clause               3
;  :num-allocs              3360589
;  :num-checks              8
;  :propagations            23
;  :quant-instantiations    5
;  :rlimit-count            103582)
(assert (=
  ($Snap.second ($Snap.second $t@31@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@31@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@31@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@31@07))) $Snap.unit))
; [eval] diz.Prc_or_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@31@07))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@31@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@31@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07)))))))
(declare-const $k@32@07 $Perm)
(assert ($Perm.isReadVar $k@32@07 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@32@07 $Perm.No) (< $Perm.No $k@32@07))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               88
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :binary-propagations     22
;  :conflicts               3
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             285
;  :mk-clause               5
;  :num-allocs              3360589
;  :num-checks              9
;  :propagations            24
;  :quant-instantiations    6
;  :rlimit-count            104155)
(assert (<= $Perm.No $k@32@07))
(assert (<= $k@32@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@32@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@31@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07)))))
  $Snap.unit))
; [eval] diz.Prc_or_m.Main_adder_prc == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@32@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               94
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     22
;  :conflicts               4
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             288
;  :mk-clause               5
;  :num-allocs              3360589
;  :num-checks              10
;  :propagations            24
;  :quant-instantiations    6
;  :rlimit-count            104428)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@31@07)))))
  diz@29@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07)))))))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               101
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     22
;  :conflicts               4
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             291
;  :mk-clause               5
;  :num-allocs              3360589
;  :num-checks              11
;  :propagations            24
;  :quant-instantiations    7
;  :rlimit-count            104679)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07)))))))
  $Snap.unit))
; [eval] !diz.Prc_or_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@07)))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@33@07 $Snap)
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main___contract_unsatisfiable__Main_EncodedGlobalVariables ----------
(declare-const diz@34@07 $Ref)
(declare-const globals@35@07 $Ref)
(declare-const diz@36@07 $Ref)
(declare-const globals@37@07 $Ref)
(push) ; 1
(declare-const $t@38@07 $Snap)
(assert (= $t@38@07 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@36@07 $Ref.null)))
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@39@07 $Snap)
(assert (= $t@39@07 ($Snap.combine ($Snap.first $t@39@07) ($Snap.second $t@39@07))))
(assert (= ($Snap.first $t@39@07) $Snap.unit))
(assert (= ($Snap.second $t@39@07) $Snap.unit))
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
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Main___contract_unsatisfiable__main_EncodedGlobalVariables ----------
(declare-const diz@40@07 $Ref)
(declare-const globals@41@07 $Ref)
(declare-const diz@42@07 $Ref)
(declare-const globals@43@07 $Ref)
(push) ; 1
(declare-const $t@44@07 $Snap)
(assert (= $t@44@07 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@42@07 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.Main_adder_prc, wildcard) && diz.Main_adder_prc != null && acc(diz.Main_adder_prc.Prc_or_m, 1 / 2) && diz.Main_adder_prc.Prc_or_m == diz && acc(diz.Main_adder_prc.Prc_or_init, 1 / 2) && !diz.Main_adder_prc.Prc_or_init && acc(diz.Main_adder_half_adder1, wildcard) && diz.Main_adder_half_adder1 != null && acc(diz.Main_adder_half_adder1.Prc_half_adder_1_m, 1 / 2) && diz.Main_adder_half_adder1.Prc_half_adder_1_m == diz && acc(diz.Main_adder_half_adder1.Prc_half_adder_1_init, 1 / 2) && !diz.Main_adder_half_adder1.Prc_half_adder_1_init && acc(diz.Main_adder_half_adder2, wildcard) && diz.Main_adder_half_adder2 != null && acc(diz.Main_adder_half_adder2.Prc_half_adder_2_m, 1 / 2) && diz.Main_adder_half_adder2.Prc_half_adder_2_m == diz && acc(diz.Main_adder_half_adder2.Prc_half_adder_2_init, 1 / 2) && !diz.Main_adder_half_adder2.Prc_half_adder_2_init && acc(Prc_or_idleToken_EncodedGlobalVariables(diz.Main_adder_prc, globals), write) && acc(Prc_half_adder_1_idleToken_EncodedGlobalVariables(diz.Main_adder_half_adder1, globals), write) && acc(Prc_half_adder_2_idleToken_EncodedGlobalVariables(diz.Main_adder_half_adder2, globals), write))
(declare-const $t@45@07 $Snap)
(assert (= $t@45@07 ($Snap.combine ($Snap.first $t@45@07) ($Snap.second $t@45@07))))
(assert (= ($Snap.first $t@45@07) $Snap.unit))
(assert (=
  ($Snap.second $t@45@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@45@07))
    ($Snap.second ($Snap.second $t@45@07)))))
(declare-const $k@46@07 $Perm)
(assert ($Perm.isReadVar $k@46@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@46@07 $Perm.No) (< $Perm.No $k@46@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               141
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      6
;  :arith-eq-adapter        4
;  :binary-propagations     22
;  :conflicts               5
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             314
;  :mk-clause               7
;  :num-allocs              3360589
;  :num-checks              19
;  :propagations            25
;  :quant-instantiations    9
;  :rlimit-count            107495)
(assert (<= $Perm.No $k@46@07))
(assert (<= $k@46@07 $Perm.Write))
(assert (implies (< $Perm.No $k@46@07) (not (= diz@42@07 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@45@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@45@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@45@07))) $Snap.unit))
; [eval] diz.Main_adder_prc != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@46@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               147
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     22
;  :conflicts               6
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             317
;  :mk-clause               7
;  :num-allocs              3360589
;  :num-checks              20
;  :propagations            25
;  :quant-instantiations    9
;  :rlimit-count            107748)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@45@07))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@45@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))
(push) ; 3
(assert (not (< $Perm.No $k@46@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               153
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     22
;  :conflicts               7
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             320
;  :mk-clause               7
;  :num-allocs              3360589
;  :num-checks              21
;  :propagations            25
;  :quant-instantiations    10
;  :rlimit-count            108032)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               153
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     22
;  :conflicts               7
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             320
;  :mk-clause               7
;  :num-allocs              3360589
;  :num-checks              22
;  :propagations            25
;  :quant-instantiations    10
;  :rlimit-count            108045)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))
  $Snap.unit))
; [eval] diz.Main_adder_prc.Prc_or_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@46@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               159
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     22
;  :conflicts               8
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             322
;  :mk-clause               7
;  :num-allocs              3360589
;  :num-checks              23
;  :propagations            25
;  :quant-instantiations    10
;  :rlimit-count            108264)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))
  diz@42@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))
(push) ; 3
(assert (not (< $Perm.No $k@46@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               166
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     22
;  :conflicts               9
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             325
;  :mk-clause               7
;  :num-allocs              3360589
;  :num-checks              24
;  :propagations            25
;  :quant-instantiations    11
;  :rlimit-count            108550)
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
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     22
;  :conflicts               9
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             325
;  :mk-clause               7
;  :num-allocs              3360589
;  :num-checks              25
;  :propagations            25
;  :quant-instantiations    11
;  :rlimit-count            108563)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))
  $Snap.unit))
; [eval] !diz.Main_adder_prc.Prc_or_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@46@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               172
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     22
;  :conflicts               10
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             327
;  :mk-clause               7
;  :num-allocs              3360589
;  :num-checks              26
;  :propagations            25
;  :quant-instantiations    11
;  :rlimit-count            108802)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))
(declare-const $k@47@07 $Perm)
(assert ($Perm.isReadVar $k@47@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@47@07 $Perm.No) (< $Perm.No $k@47@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               181
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      8
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               11
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.77
;  :mk-bool-var             335
;  :mk-clause               9
;  :num-allocs              3360589
;  :num-checks              27
;  :propagations            26
;  :quant-instantiations    13
;  :rlimit-count            109270)
(assert (<= $Perm.No $k@47@07))
(assert (<= $k@47@07 $Perm.Write))
(assert (implies (< $Perm.No $k@47@07) (not (= diz@42@07 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))
  $Snap.unit))
; [eval] diz.Main_adder_half_adder1 != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@47@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               187
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               12
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             338
;  :mk-clause               9
;  :num-allocs              3476971
;  :num-checks              28
;  :propagations            26
;  :quant-instantiations    13
;  :rlimit-count            109583)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@47@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               193
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               13
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             341
;  :mk-clause               9
;  :num-allocs              3476971
;  :num-checks              29
;  :propagations            26
;  :quant-instantiations    14
;  :rlimit-count            109927)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               193
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               13
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             341
;  :mk-clause               9
;  :num-allocs              3476971
;  :num-checks              30
;  :propagations            26
;  :quant-instantiations    14
;  :rlimit-count            109940)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))
  $Snap.unit))
; [eval] diz.Main_adder_half_adder1.Prc_half_adder_1_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@47@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               199
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               14
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             343
;  :mk-clause               9
;  :num-allocs              3476971
;  :num-checks              31
;  :propagations            26
;  :quant-instantiations    14
;  :rlimit-count            110219)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))
  diz@42@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@47@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               207
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               15
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             346
;  :mk-clause               9
;  :num-allocs              3476971
;  :num-checks              32
;  :propagations            26
;  :quant-instantiations    15
;  :rlimit-count            110564)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               207
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               15
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             346
;  :mk-clause               9
;  :num-allocs              3476971
;  :num-checks              33
;  :propagations            26
;  :quant-instantiations    15
;  :rlimit-count            110577)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))
  $Snap.unit))
; [eval] !diz.Main_adder_half_adder1.Prc_half_adder_1_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@47@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               213
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     22
;  :conflicts               16
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             348
;  :mk-clause               9
;  :num-allocs              3476971
;  :num-checks              34
;  :propagations            26
;  :quant-instantiations    15
;  :rlimit-count            110876)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))
(declare-const $k@48@07 $Perm)
(assert ($Perm.isReadVar $k@48@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@48@07 $Perm.No) (< $Perm.No $k@48@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               221
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      10
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               17
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             355
;  :mk-clause               11
;  :num-allocs              3476971
;  :num-checks              35
;  :propagations            27
;  :quant-instantiations    16
;  :rlimit-count            111386)
(assert (<= $Perm.No $k@48@07))
(assert (<= $k@48@07 $Perm.Write))
(assert (implies (< $Perm.No $k@48@07) (not (= diz@42@07 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_adder_half_adder2 != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@48@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               227
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               18
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             358
;  :mk-clause               11
;  :num-allocs              3476971
;  :num-checks              36
;  :propagations            27
;  :quant-instantiations    16
;  :rlimit-count            111759)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@48@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               233
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               19
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             361
;  :mk-clause               11
;  :num-allocs              3476971
;  :num-checks              37
;  :propagations            27
;  :quant-instantiations    17
;  :rlimit-count            112163)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               233
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               19
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             361
;  :mk-clause               11
;  :num-allocs              3476971
;  :num-checks              38
;  :propagations            27
;  :quant-instantiations    17
;  :rlimit-count            112176)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_adder_half_adder2.Prc_half_adder_2_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@48@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               239
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               20
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             363
;  :mk-clause               11
;  :num-allocs              3476971
;  :num-checks              39
;  :propagations            27
;  :quant-instantiations    17
;  :rlimit-count            112515)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))
  diz@42@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@48@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               247
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               21
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             366
;  :mk-clause               11
;  :num-allocs              3476971
;  :num-checks              40
;  :propagations            27
;  :quant-instantiations    18
;  :rlimit-count            112920)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               247
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               21
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             366
;  :mk-clause               11
;  :num-allocs              3476971
;  :num-checks              41
;  :propagations            27
;  :quant-instantiations    18
;  :rlimit-count            112933)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))))
  $Snap.unit))
; [eval] !diz.Main_adder_half_adder2.Prc_half_adder_2_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@48@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               253
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               22
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             368
;  :mk-clause               11
;  :num-allocs              3476971
;  :num-checks              42
;  :propagations            27
;  :quant-instantiations    18
;  :rlimit-count            113292)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@46@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               261
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               23
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             371
;  :mk-clause               11
;  :num-allocs              3476971
;  :num-checks              43
;  :propagations            27
;  :quant-instantiations    19
;  :rlimit-count            113718)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@07))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@47@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               266
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               24
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             372
;  :mk-clause               11
;  :num-allocs              3476971
;  :num-checks              44
;  :propagations            27
;  :quant-instantiations    19
;  :rlimit-count            114065
;  :time                    0.00)
(push) ; 3
(assert (not (< $Perm.No $k@48@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               266
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     22
;  :conflicts               25
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              4
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             372
;  :mk-clause               11
;  :num-allocs              3476971
;  :num-checks              45
;  :propagations            27
;  :quant-instantiations    19
;  :rlimit-count            114113)
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
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Main_immediate_wakeup_EncodedGlobalVariables ----------
(declare-const diz@49@07 $Ref)
(declare-const globals@50@07 $Ref)
(declare-const diz@51@07 $Ref)
(declare-const globals@52@07 $Ref)
(push) ; 1
(declare-const $t@53@07 $Snap)
(assert (= $t@53@07 ($Snap.combine ($Snap.first $t@53@07) ($Snap.second $t@53@07))))
(assert (= ($Snap.first $t@53@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@51@07 $Ref.null)))
(assert (=
  ($Snap.second $t@53@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@53@07))
    ($Snap.second ($Snap.second $t@53@07)))))
(assert (=
  ($Snap.second ($Snap.second $t@53@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@53@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@53@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@07))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07)))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07)))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@54@07 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 0 | 0 <= i@54@07 | live]
; [else-branch: 0 | !(0 <= i@54@07) | live]
(push) ; 4
; [then-branch: 0 | 0 <= i@54@07]
(assert (<= 0 i@54@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(0 <= i@54@07)]
(assert (not (<= 0 i@54@07)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 1 | i@54@07 < |First:(Second:(Second:($t@53@07)))| && 0 <= i@54@07 | live]
; [else-branch: 1 | !(i@54@07 < |First:(Second:(Second:($t@53@07)))| && 0 <= i@54@07) | live]
(push) ; 4
; [then-branch: 1 | i@54@07 < |First:(Second:(Second:($t@53@07)))| && 0 <= i@54@07]
(assert (and
  (<
    i@54@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))
  (<= 0 i@54@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@54@07 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               392
;  :arith-assert-diseq      7
;  :arith-assert-lower      18
;  :arith-assert-upper      14
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               25
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   25
;  :datatype-splits         16
;  :decisions               40
;  :del-clause              10
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             409
;  :mk-clause               17
;  :num-allocs              3476971
;  :num-checks              50
;  :propagations            29
;  :quant-instantiations    25
;  :rlimit-count            116822)
; [eval] -1
(push) ; 5
; [then-branch: 2 | First:(Second:(Second:($t@53@07)))[i@54@07] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:($t@53@07)))[i@54@07] != -1 | live]
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:($t@53@07)))[i@54@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    i@54@07)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 2 | First:(Second:(Second:($t@53@07)))[i@54@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      i@54@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@54@07 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               392
;  :arith-assert-diseq      7
;  :arith-assert-lower      18
;  :arith-assert-upper      14
;  :arith-eq-adapter        10
;  :binary-propagations     22
;  :conflicts               25
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   25
;  :datatype-splits         16
;  :decisions               40
;  :del-clause              10
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             410
;  :mk-clause               17
;  :num-allocs              3476971
;  :num-checks              51
;  :propagations            29
;  :quant-instantiations    25
;  :rlimit-count            116985)
(push) ; 7
; [then-branch: 3 | 0 <= First:(Second:(Second:($t@53@07)))[i@54@07] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:($t@53@07)))[i@54@07]) | live]
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:($t@53@07)))[i@54@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    i@54@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@54@07 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               392
;  :arith-assert-diseq      8
;  :arith-assert-lower      21
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     22
;  :conflicts               25
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   25
;  :datatype-splits         16
;  :decisions               40
;  :del-clause              10
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             413
;  :mk-clause               18
;  :num-allocs              3476971
;  :num-checks              52
;  :propagations            29
;  :quant-instantiations    25
;  :rlimit-count            117099)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 3 | !(0 <= First:(Second:(Second:($t@53@07)))[i@54@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      i@54@07))))
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
; [else-branch: 1 | !(i@54@07 < |First:(Second:(Second:($t@53@07)))| && 0 <= i@54@07)]
(assert (not
  (and
    (<
      i@54@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))
    (<= 0 i@54@07))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@54@07 Int)) (!
  (implies
    (and
      (<
        i@54@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))
      (<= 0 i@54@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          i@54@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
            i@54@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
            i@54@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    i@54@07))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@55@07 $Snap)
(assert (= $t@55@07 ($Snap.combine ($Snap.first $t@55@07) ($Snap.second $t@55@07))))
(assert (=
  ($Snap.second $t@55@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@55@07))
    ($Snap.second ($Snap.second $t@55@07)))))
(assert (=
  ($Snap.second ($Snap.second $t@55@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@55@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@55@07))) $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@55@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@56@07 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@56@07 | live]
; [else-branch: 4 | !(0 <= i@56@07) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@56@07]
(assert (<= 0 i@56@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@56@07)]
(assert (not (<= 0 i@56@07)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@56@07 < |First:(Second:($t@55@07))| && 0 <= i@56@07 | live]
; [else-branch: 5 | !(i@56@07 < |First:(Second:($t@55@07))| && 0 <= i@56@07) | live]
(push) ; 5
; [then-branch: 5 | i@56@07 < |First:(Second:($t@55@07))| && 0 <= i@56@07]
(assert (and
  (<
    i@56@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))))
  (<= 0 i@56@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@56@07 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               447
;  :arith-assert-diseq      8
;  :arith-assert-lower      26
;  :arith-assert-upper      17
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               26
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 46
;  :datatype-occurs-check   28
;  :datatype-splits         21
;  :decisions               45
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             441
;  :mk-clause               19
;  :num-allocs              3476971
;  :num-checks              54
;  :propagations            29
;  :quant-instantiations    29
;  :rlimit-count            118868)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:($t@55@07))[i@56@07] == -1 | live]
; [else-branch: 6 | First:(Second:($t@55@07))[i@56@07] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:($t@55@07))[i@56@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
    i@56@07)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:($t@55@07))[i@56@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
      i@56@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@56@07 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               447
;  :arith-assert-diseq      8
;  :arith-assert-lower      26
;  :arith-assert-upper      17
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               26
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 46
;  :datatype-occurs-check   28
;  :datatype-splits         21
;  :decisions               45
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             442
;  :mk-clause               19
;  :num-allocs              3476971
;  :num-checks              55
;  :propagations            29
;  :quant-instantiations    29
;  :rlimit-count            119019)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:($t@55@07))[i@56@07] | live]
; [else-branch: 7 | !(0 <= First:(Second:($t@55@07))[i@56@07]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:($t@55@07))[i@56@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
    i@56@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@56@07 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               447
;  :arith-assert-diseq      9
;  :arith-assert-lower      29
;  :arith-assert-upper      17
;  :arith-eq-adapter        14
;  :binary-propagations     22
;  :conflicts               26
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 46
;  :datatype-occurs-check   28
;  :datatype-splits         21
;  :decisions               45
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             445
;  :mk-clause               20
;  :num-allocs              3476971
;  :num-checks              56
;  :propagations            29
;  :quant-instantiations    29
;  :rlimit-count            119122)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:($t@55@07))[i@56@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
      i@56@07))))
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
; [else-branch: 5 | !(i@56@07 < |First:(Second:($t@55@07))| && 0 <= i@56@07)]
(assert (not
  (and
    (<
      i@56@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))))
    (<= 0 i@56@07))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@56@07 Int)) (!
  (implies
    (and
      (<
        i@56@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))))
      (<= 0 i@56@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
          i@56@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
            i@56@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
            i@56@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
    i@56@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 ==> diz.Main_process_state[0] == -1
; [eval] 0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               464
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               26
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 46
;  :datatype-occurs-check   28
;  :datatype-splits         21
;  :decisions               45
;  :del-clause              18
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             464
;  :mk-clause               30
;  :num-allocs              3476971
;  :num-checks              57
;  :propagations            33
;  :quant-instantiations    31
;  :rlimit-count            120181)
(push) ; 3
; [then-branch: 8 | 0 <= First:(Second:(Second:($t@53@07)))[0] | live]
; [else-branch: 8 | !(0 <= First:(Second:(Second:($t@53@07)))[0]) | live]
(push) ; 4
; [then-branch: 8 | 0 <= First:(Second:(Second:($t@53@07)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               464
;  :arith-assert-diseq      9
;  :arith-assert-lower      31
;  :arith-assert-upper      18
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               26
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 46
;  :datatype-occurs-check   28
;  :datatype-splits         21
;  :decisions               45
;  :del-clause              18
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             470
;  :mk-clause               36
;  :num-allocs              3476971
;  :num-checks              58
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            120344)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               464
;  :arith-assert-diseq      9
;  :arith-assert-lower      31
;  :arith-assert-upper      18
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               26
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 46
;  :datatype-occurs-check   28
;  :datatype-splits         21
;  :decisions               45
;  :del-clause              18
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             470
;  :mk-clause               36
;  :num-allocs              3476971
;  :num-checks              59
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            120353)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               465
;  :arith-assert-diseq      9
;  :arith-assert-lower      32
;  :arith-assert-upper      19
;  :arith-conflicts         1
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               27
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 46
;  :datatype-occurs-check   28
;  :datatype-splits         21
;  :decisions               45
;  :del-clause              18
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             470
;  :mk-clause               36
;  :num-allocs              3476971
;  :num-checks              60
;  :propagations            37
;  :quant-instantiations    32
;  :rlimit-count            120461)
(pop) ; 4
(push) ; 4
; [else-branch: 8 | !(0 <= First:(Second:(Second:($t@53@07)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
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
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               492
;  :arith-assert-diseq      11
;  :arith-assert-lower      39
;  :arith-assert-upper      22
;  :arith-conflicts         1
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     22
;  :conflicts               27
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 54
;  :datatype-occurs-check   32
;  :datatype-splits         26
;  :decisions               52
;  :del-clause              32
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             492
;  :mk-clause               44
;  :num-allocs              3476971
;  :num-checks              61
;  :propagations            42
;  :quant-instantiations    34
;  :rlimit-count            121187
;  :time                    0.00)
(push) ; 4
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               518
;  :arith-assert-diseq      13
;  :arith-assert-lower      46
;  :arith-assert-upper      25
;  :arith-conflicts         1
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         3
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               27
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   36
;  :datatype-splits         31
;  :decisions               61
;  :del-clause              52
;  :final-checks            24
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             514
;  :mk-clause               64
;  :num-allocs              3476971
;  :num-checks              62
;  :propagations            51
;  :quant-instantiations    36
;  :rlimit-count            121895
;  :time                    0.00)
; [then-branch: 9 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[0]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[0] | live]
; [else-branch: 9 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[0]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[0]) | live]
(push) ; 4
; [then-branch: 9 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[0]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               519
;  :arith-assert-diseq      13
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-conflicts         1
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         3
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               27
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   36
;  :datatype-splits         31
;  :decisions               61
;  :del-clause              52
;  :final-checks            24
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             521
;  :mk-clause               70
;  :num-allocs              3476971
;  :num-checks              63
;  :propagations            51
;  :quant-instantiations    37
;  :rlimit-count            122099)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 9 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[0]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        0)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[1]) && old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 ==> diz.Main_process_state[1] == -1
; [eval] 0 <= old(diz.Main_process_state[1]) && old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] 0 <= old(diz.Main_process_state[1])
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               525
;  :arith-assert-diseq      13
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-conflicts         1
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         3
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               27
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   36
;  :datatype-splits         31
;  :decisions               61
;  :del-clause              58
;  :final-checks            24
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             526
;  :mk-clause               71
;  :num-allocs              3476971
;  :num-checks              64
;  :propagations            51
;  :quant-instantiations    37
;  :rlimit-count            122592)
(push) ; 3
; [then-branch: 10 | 0 <= First:(Second:(Second:($t@53@07)))[1] | live]
; [else-branch: 10 | !(0 <= First:(Second:(Second:($t@53@07)))[1]) | live]
(push) ; 4
; [then-branch: 10 | 0 <= First:(Second:(Second:($t@53@07)))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    1)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               525
;  :arith-assert-diseq      13
;  :arith-assert-lower      48
;  :arith-assert-upper      25
;  :arith-conflicts         1
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         3
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               27
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   36
;  :datatype-splits         31
;  :decisions               61
;  :del-clause              58
;  :final-checks            24
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             532
;  :mk-clause               77
;  :num-allocs              3476971
;  :num-checks              65
;  :propagations            51
;  :quant-instantiations    38
;  :rlimit-count            122755)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               525
;  :arith-assert-diseq      13
;  :arith-assert-lower      48
;  :arith-assert-upper      25
;  :arith-conflicts         1
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         3
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               27
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   36
;  :datatype-splits         31
;  :decisions               61
;  :del-clause              58
;  :final-checks            24
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             532
;  :mk-clause               77
;  :num-allocs              3476971
;  :num-checks              66
;  :propagations            51
;  :quant-instantiations    38
;  :rlimit-count            122764)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               526
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      26
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         3
;  :arith-pivots            4
;  :binary-propagations     22
;  :conflicts               28
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   36
;  :datatype-splits         31
;  :decisions               61
;  :del-clause              58
;  :final-checks            24
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             532
;  :mk-clause               77
;  :num-allocs              3476971
;  :num-checks              67
;  :propagations            55
;  :quant-instantiations    38
;  :rlimit-count            122872)
(pop) ; 4
(push) ; 4
; [else-branch: 10 | !(0 <= First:(Second:(Second:($t@53@07)))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      1))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               556
;  :arith-assert-diseq      15
;  :arith-assert-lower      57
;  :arith-assert-upper      30
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         4
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               28
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 70
;  :datatype-occurs-check   40
;  :datatype-splits         36
;  :decisions               69
;  :del-clause              76
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             557
;  :mk-clause               89
;  :num-allocs              3476971
;  :num-checks              68
;  :propagations            61
;  :quant-instantiations    40
;  :rlimit-count            123626
;  :time                    0.00)
(push) ; 4
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               584
;  :arith-assert-diseq      15
;  :arith-assert-lower      59
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               28
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   44
;  :datatype-splits         41
;  :decisions               78
;  :del-clause              83
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             573
;  :mk-clause               96
;  :num-allocs              3476971
;  :num-checks              69
;  :propagations            64
;  :quant-instantiations    41
;  :rlimit-count            124288
;  :time                    0.00)
; [then-branch: 11 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[1]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[1] | live]
; [else-branch: 11 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[1]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[1]) | live]
(push) ; 4
; [then-branch: 11 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[1]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[1]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      1))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               585
;  :arith-assert-diseq      15
;  :arith-assert-lower      60
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         4
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               28
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   44
;  :datatype-splits         41
;  :decisions               78
;  :del-clause              83
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             580
;  :mk-clause               102
;  :num-allocs              3476971
;  :num-checks              70
;  :propagations            64
;  :quant-instantiations    42
;  :rlimit-count            124491)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 11 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[1]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[1])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        1)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
      1)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[2]) && old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0 ==> diz.Main_process_state[2] == -1
; [eval] 0 <= old(diz.Main_process_state[2]) && old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0
; [eval] 0 <= old(diz.Main_process_state[2])
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 3
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               591
;  :arith-assert-diseq      15
;  :arith-assert-lower      60
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         4
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               28
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   44
;  :datatype-splits         41
;  :decisions               78
;  :del-clause              89
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             585
;  :mk-clause               103
;  :num-allocs              3476971
;  :num-checks              71
;  :propagations            64
;  :quant-instantiations    42
;  :rlimit-count            124994)
(push) ; 3
; [then-branch: 12 | 0 <= First:(Second:(Second:($t@53@07)))[2] | live]
; [else-branch: 12 | !(0 <= First:(Second:(Second:($t@53@07)))[2]) | live]
(push) ; 4
; [then-branch: 12 | 0 <= First:(Second:(Second:($t@53@07)))[2]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    2)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[2])]
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               591
;  :arith-assert-diseq      15
;  :arith-assert-lower      61
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         4
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               28
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   44
;  :datatype-splits         41
;  :decisions               78
;  :del-clause              89
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             591
;  :mk-clause               109
;  :num-allocs              3476971
;  :num-checks              72
;  :propagations            64
;  :quant-instantiations    43
;  :rlimit-count            125156)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               591
;  :arith-assert-diseq      15
;  :arith-assert-lower      61
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         4
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               28
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   44
;  :datatype-splits         41
;  :decisions               78
;  :del-clause              89
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             591
;  :mk-clause               109
;  :num-allocs              3476971
;  :num-checks              73
;  :propagations            64
;  :quant-instantiations    43
;  :rlimit-count            125165)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               592
;  :arith-assert-diseq      15
;  :arith-assert-lower      62
;  :arith-assert-upper      34
;  :arith-conflicts         3
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         4
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               29
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   44
;  :datatype-splits         41
;  :decisions               78
;  :del-clause              89
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             591
;  :mk-clause               109
;  :num-allocs              3476971
;  :num-checks              74
;  :propagations            68
;  :quant-instantiations    43
;  :rlimit-count            125272)
(pop) ; 4
(push) ; 4
; [else-branch: 12 | !(0 <= First:(Second:(Second:($t@53@07)))[2])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      2))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          2))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        2))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               626
;  :arith-assert-diseq      17
;  :arith-assert-lower      71
;  :arith-assert-upper      40
;  :arith-conflicts         3
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               29
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 86
;  :datatype-occurs-check   48
;  :datatype-splits         46
;  :decisions               87
;  :del-clause              109
;  :final-checks            30
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             621
;  :mk-clause               123
;  :num-allocs              3476971
;  :num-checks              75
;  :propagations            75
;  :quant-instantiations    46
;  :rlimit-count            126079
;  :time                    0.00)
(push) ; 4
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        2))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      2)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               658
;  :arith-assert-diseq      17
;  :arith-assert-lower      74
;  :arith-assert-upper      45
;  :arith-conflicts         3
;  :arith-eq-adapter        40
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               29
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   52
;  :datatype-splits         51
;  :decisions               97
;  :del-clause              118
;  :final-checks            32
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             642
;  :mk-clause               132
;  :num-allocs              3476971
;  :num-checks              76
;  :propagations            79
;  :quant-instantiations    48
;  :rlimit-count            126801
;  :time                    0.00)
; [then-branch: 13 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[2]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[2] | live]
; [else-branch: 13 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[2]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[2]) | live]
(push) ; 4
; [then-branch: 13 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[2]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[2]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        2))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      2))))
; [eval] diz.Main_process_state[2] == -1
; [eval] diz.Main_process_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               659
;  :arith-assert-diseq      17
;  :arith-assert-lower      75
;  :arith-assert-upper      45
;  :arith-conflicts         3
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               29
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   52
;  :datatype-splits         51
;  :decisions               97
;  :del-clause              118
;  :final-checks            32
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             649
;  :mk-clause               138
;  :num-allocs              3476971
;  :num-checks              77
;  :propagations            79
;  :quant-instantiations    49
;  :rlimit-count            127005)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 13 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[2]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[2])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          2))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        2)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          2))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        2)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
      2)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0) ==> diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] !(0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0)
; [eval] 0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               665
;  :arith-assert-diseq      17
;  :arith-assert-lower      75
;  :arith-assert-upper      45
;  :arith-conflicts         3
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               29
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   52
;  :datatype-splits         51
;  :decisions               97
;  :del-clause              124
;  :final-checks            32
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             654
;  :mk-clause               139
;  :num-allocs              3476971
;  :num-checks              78
;  :propagations            79
;  :quant-instantiations    49
;  :rlimit-count            127518)
(push) ; 3
; [then-branch: 14 | 0 <= First:(Second:(Second:($t@53@07)))[0] | live]
; [else-branch: 14 | !(0 <= First:(Second:(Second:($t@53@07)))[0]) | live]
(push) ; 4
; [then-branch: 14 | 0 <= First:(Second:(Second:($t@53@07)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               665
;  :arith-assert-diseq      17
;  :arith-assert-lower      76
;  :arith-assert-upper      45
;  :arith-conflicts         3
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               29
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   52
;  :datatype-splits         51
;  :decisions               97
;  :del-clause              124
;  :final-checks            32
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             659
;  :mk-clause               145
;  :num-allocs              3476971
;  :num-checks              79
;  :propagations            79
;  :quant-instantiations    50
;  :rlimit-count            127657)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               665
;  :arith-assert-diseq      17
;  :arith-assert-lower      76
;  :arith-assert-upper      45
;  :arith-conflicts         3
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               29
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   52
;  :datatype-splits         51
;  :decisions               97
;  :del-clause              124
;  :final-checks            32
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             659
;  :mk-clause               145
;  :num-allocs              3476971
;  :num-checks              80
;  :propagations            79
;  :quant-instantiations    50
;  :rlimit-count            127666)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               666
;  :arith-assert-diseq      17
;  :arith-assert-lower      77
;  :arith-assert-upper      46
;  :arith-conflicts         4
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               30
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   52
;  :datatype-splits         51
;  :decisions               97
;  :del-clause              124
;  :final-checks            32
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             659
;  :mk-clause               145
;  :num-allocs              3476971
;  :num-checks              81
;  :propagations            83
;  :quant-instantiations    50
;  :rlimit-count            127774)
(pop) ; 4
(push) ; 4
; [else-branch: 14 | !(0 <= First:(Second:(Second:($t@53@07)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      0))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               719
;  :arith-assert-diseq      18
;  :arith-assert-lower      82
;  :arith-assert-upper      51
;  :arith-conflicts         4
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               32
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   60
;  :datatype-splits         60
;  :decisions               114
;  :del-clause              153
;  :final-checks            36
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             696
;  :mk-clause               168
;  :num-allocs              3476971
;  :num-checks              82
;  :propagations            91
;  :quant-instantiations    53
;  :rlimit-count            128672
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               777
;  :arith-assert-diseq      19
;  :arith-assert-lower      89
;  :arith-assert-upper      60
;  :arith-conflicts         4
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               34
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 124
;  :datatype-occurs-check   68
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              165
;  :final-checks            40
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             745
;  :mk-clause               180
;  :num-allocs              3476971
;  :num-checks              83
;  :propagations            98
;  :quant-instantiations    58
;  :rlimit-count            129575
;  :time                    0.00)
; [then-branch: 15 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[0]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[0]) | live]
; [else-branch: 15 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[0]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[0] | live]
(push) ; 4
; [then-branch: 15 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[0]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               777
;  :arith-assert-diseq      19
;  :arith-assert-lower      89
;  :arith-assert-upper      60
;  :arith-conflicts         4
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               34
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 124
;  :datatype-occurs-check   68
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              165
;  :final-checks            40
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             745
;  :mk-clause               181
;  :num-allocs              3476971
;  :num-checks              84
;  :propagations            98
;  :quant-instantiations    58
;  :rlimit-count            129764)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               777
;  :arith-assert-diseq      19
;  :arith-assert-lower      89
;  :arith-assert-upper      60
;  :arith-conflicts         4
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               34
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 124
;  :datatype-occurs-check   68
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              165
;  :final-checks            40
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             745
;  :mk-clause               181
;  :num-allocs              3476971
;  :num-checks              85
;  :propagations            98
;  :quant-instantiations    58
;  :rlimit-count            129779)
(pop) ; 4
(push) ; 4
; [else-branch: 15 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[0]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      0))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
            0))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[1]) && old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0) ==> diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] !(0 <= old(diz.Main_process_state[1]) && old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0)
; [eval] 0 <= old(diz.Main_process_state[1]) && old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] 0 <= old(diz.Main_process_state[1])
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               783
;  :arith-assert-diseq      19
;  :arith-assert-lower      89
;  :arith-assert-upper      60
;  :arith-conflicts         4
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               34
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 124
;  :datatype-occurs-check   68
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              166
;  :final-checks            40
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             749
;  :mk-clause               185
;  :num-allocs              3476971
;  :num-checks              86
;  :propagations            98
;  :quant-instantiations    58
;  :rlimit-count            130292)
(push) ; 3
; [then-branch: 16 | 0 <= First:(Second:(Second:($t@53@07)))[1] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:($t@53@07)))[1]) | live]
(push) ; 4
; [then-branch: 16 | 0 <= First:(Second:(Second:($t@53@07)))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    1)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               783
;  :arith-assert-diseq      19
;  :arith-assert-lower      90
;  :arith-assert-upper      60
;  :arith-conflicts         4
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               34
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 124
;  :datatype-occurs-check   68
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              166
;  :final-checks            40
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             754
;  :mk-clause               191
;  :num-allocs              3476971
;  :num-checks              87
;  :propagations            98
;  :quant-instantiations    59
;  :rlimit-count            130409)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               783
;  :arith-assert-diseq      19
;  :arith-assert-lower      90
;  :arith-assert-upper      60
;  :arith-conflicts         4
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               34
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 124
;  :datatype-occurs-check   68
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              166
;  :final-checks            40
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             754
;  :mk-clause               191
;  :num-allocs              3476971
;  :num-checks              88
;  :propagations            98
;  :quant-instantiations    59
;  :rlimit-count            130418)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               784
;  :arith-assert-diseq      19
;  :arith-assert-lower      91
;  :arith-assert-upper      61
;  :arith-conflicts         5
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               35
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 124
;  :datatype-occurs-check   68
;  :datatype-splits         73
;  :decisions               130
;  :del-clause              166
;  :final-checks            40
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             754
;  :mk-clause               191
;  :num-allocs              3476971
;  :num-checks              89
;  :propagations            102
;  :quant-instantiations    59
;  :rlimit-count            130526)
(pop) ; 4
(push) ; 4
; [else-branch: 16 | !(0 <= First:(Second:(Second:($t@53@07)))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      1))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               839
;  :arith-assert-diseq      21
;  :arith-assert-lower      96
;  :arith-assert-upper      66
;  :arith-conflicts         5
;  :arith-eq-adapter        55
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               37
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 139
;  :datatype-occurs-check   76
;  :datatype-splits         82
;  :decisions               146
;  :del-clause              181
;  :final-checks            44
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             788
;  :mk-clause               200
;  :num-allocs              3476971
;  :num-checks              90
;  :propagations            108
;  :quant-instantiations    62
;  :rlimit-count            131426
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               893
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      70
;  :arith-conflicts         5
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               39
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   84
;  :datatype-splits         91
;  :decisions               161
;  :del-clause              189
;  :final-checks            48
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             822
;  :mk-clause               208
;  :num-allocs              3476971
;  :num-checks              91
;  :propagations            115
;  :quant-instantiations    65
;  :rlimit-count            132306
;  :time                    0.00)
; [then-branch: 17 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[1]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[1]) | live]
; [else-branch: 17 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[1]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[1] | live]
(push) ; 4
; [then-branch: 17 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[1]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[1])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        1)))))
; [eval] diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               893
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      70
;  :arith-conflicts         5
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               39
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   84
;  :datatype-splits         91
;  :decisions               161
;  :del-clause              189
;  :final-checks            48
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             822
;  :mk-clause               209
;  :num-allocs              3476971
;  :num-checks              92
;  :propagations            115
;  :quant-instantiations    65
;  :rlimit-count            132495)
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               893
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      70
;  :arith-conflicts         5
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               39
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   84
;  :datatype-splits         91
;  :decisions               161
;  :del-clause              189
;  :final-checks            48
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             822
;  :mk-clause               209
;  :num-allocs              3476971
;  :num-checks              93
;  :propagations            115
;  :quant-instantiations    65
;  :rlimit-count            132510)
(pop) ; 4
(push) ; 4
; [else-branch: 17 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[1]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[1]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      1))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
            1))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@07))))))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[2]) && old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0) ==> diz.Main_process_state[2] == old(diz.Main_process_state[2])
; [eval] !(0 <= old(diz.Main_process_state[2]) && old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0)
; [eval] 0 <= old(diz.Main_process_state[2]) && old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0
; [eval] 0 <= old(diz.Main_process_state[2])
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 3
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               895
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      70
;  :arith-conflicts         5
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               39
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   84
;  :datatype-splits         91
;  :decisions               161
;  :del-clause              190
;  :final-checks            48
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             825
;  :mk-clause               213
;  :num-allocs              3476971
;  :num-checks              94
;  :propagations            115
;  :quant-instantiations    65
;  :rlimit-count            132937)
(push) ; 3
; [then-branch: 18 | 0 <= First:(Second:(Second:($t@53@07)))[2] | live]
; [else-branch: 18 | !(0 <= First:(Second:(Second:($t@53@07)))[2]) | live]
(push) ; 4
; [then-branch: 18 | 0 <= First:(Second:(Second:($t@53@07)))[2]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    2)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[2])]
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               895
;  :arith-assert-diseq      24
;  :arith-assert-lower      104
;  :arith-assert-upper      70
;  :arith-conflicts         5
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               39
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   84
;  :datatype-splits         91
;  :decisions               161
;  :del-clause              190
;  :final-checks            48
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             830
;  :mk-clause               219
;  :num-allocs              3476971
;  :num-checks              95
;  :propagations            115
;  :quant-instantiations    66
;  :rlimit-count            133054)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               895
;  :arith-assert-diseq      24
;  :arith-assert-lower      104
;  :arith-assert-upper      70
;  :arith-conflicts         5
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               39
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   84
;  :datatype-splits         91
;  :decisions               161
;  :del-clause              190
;  :final-checks            48
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             830
;  :mk-clause               219
;  :num-allocs              3476971
;  :num-checks              96
;  :propagations            115
;  :quant-instantiations    66
;  :rlimit-count            133063)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               896
;  :arith-assert-diseq      24
;  :arith-assert-lower      105
;  :arith-assert-upper      71
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         5
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               40
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   84
;  :datatype-splits         91
;  :decisions               161
;  :del-clause              190
;  :final-checks            48
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             830
;  :mk-clause               219
;  :num-allocs              3476971
;  :num-checks              97
;  :propagations            119
;  :quant-instantiations    66
;  :rlimit-count            133171)
(pop) ; 4
(push) ; 4
; [else-branch: 18 | !(0 <= First:(Second:(Second:($t@53@07)))[2])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      2))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        2))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      2)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               953
;  :arith-assert-diseq      26
;  :arith-assert-lower      111
;  :arith-assert-upper      77
;  :arith-bound-prop        2
;  :arith-conflicts         6
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         6
;  :arith-pivots            10
;  :binary-propagations     22
;  :conflicts               42
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 168
;  :datatype-occurs-check   92
;  :datatype-splits         99
;  :decisions               176
;  :del-clause              213
;  :final-checks            52
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             873
;  :mk-clause               236
;  :num-allocs              3476971
;  :num-checks              98
;  :propagations            128
;  :quant-instantiations    70
;  :rlimit-count            134121
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          2))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        2))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1009
;  :arith-assert-diseq      29
;  :arith-assert-lower      119
;  :arith-assert-upper      82
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         7
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               44
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 182
;  :datatype-occurs-check   100
;  :datatype-splits         107
;  :decisions               190
;  :del-clause              229
;  :final-checks            56
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             916
;  :mk-clause               252
;  :num-allocs              3476971
;  :num-checks              99
;  :propagations            138
;  :quant-instantiations    74
;  :rlimit-count            135050
;  :time                    0.00)
; [then-branch: 19 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[2]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[2]) | live]
; [else-branch: 19 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[2]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[2] | live]
(push) ; 4
; [then-branch: 19 | !(First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[2]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[2])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          2))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        2)))))
; [eval] diz.Main_process_state[2] == old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1009
;  :arith-assert-diseq      29
;  :arith-assert-lower      119
;  :arith-assert-upper      82
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         7
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               44
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 182
;  :datatype-occurs-check   100
;  :datatype-splits         107
;  :decisions               190
;  :del-clause              229
;  :final-checks            56
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             916
;  :mk-clause               253
;  :num-allocs              3476971
;  :num-checks              100
;  :propagations            138
;  :quant-instantiations    74
;  :rlimit-count            135239)
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1009
;  :arith-assert-diseq      29
;  :arith-assert-lower      119
;  :arith-assert-upper      82
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         7
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               44
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 182
;  :datatype-occurs-check   100
;  :datatype-splits         107
;  :decisions               190
;  :del-clause              229
;  :final-checks            56
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             916
;  :mk-clause               253
;  :num-allocs              3476971
;  :num-checks              101
;  :propagations            138
;  :quant-instantiations    74
;  :rlimit-count            135254)
(pop) ; 4
(push) ; 4
; [else-branch: 19 | First:(Second:(Second:(Second:(Second:($t@53@07)))))[First:(Second:(Second:($t@53@07)))[2]] == 0 && 0 <= First:(Second:(Second:($t@53@07)))[2]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
        2))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      2))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
            2))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
          2))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@55@07)))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@53@07))))
      2))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main_wakeup_after_wait_EncodedGlobalVariables ----------
(declare-const diz@57@07 $Ref)
(declare-const globals@58@07 $Ref)
(declare-const diz@59@07 $Ref)
(declare-const globals@60@07 $Ref)
(push) ; 1
(declare-const $t@61@07 $Snap)
(assert (= $t@61@07 ($Snap.combine ($Snap.first $t@61@07) ($Snap.second $t@61@07))))
(assert (= ($Snap.first $t@61@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@59@07 $Ref.null)))
(assert (=
  ($Snap.second $t@61@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@61@07))
    ($Snap.second ($Snap.second $t@61@07)))))
(assert (=
  ($Snap.second ($Snap.second $t@61@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@61@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@61@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@61@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@61@07))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07)))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@62@07 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 20 | 0 <= i@62@07 | live]
; [else-branch: 20 | !(0 <= i@62@07) | live]
(push) ; 4
; [then-branch: 20 | 0 <= i@62@07]
(assert (<= 0 i@62@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 20 | !(0 <= i@62@07)]
(assert (not (<= 0 i@62@07)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 21 | i@62@07 < |First:(Second:(Second:($t@61@07)))| && 0 <= i@62@07 | live]
; [else-branch: 21 | !(i@62@07 < |First:(Second:(Second:($t@61@07)))| && 0 <= i@62@07) | live]
(push) ; 4
; [then-branch: 21 | i@62@07 < |First:(Second:(Second:($t@61@07)))| && 0 <= i@62@07]
(assert (and
  (<
    i@62@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))
  (<= 0 i@62@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 5
(assert (not (>= i@62@07 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1047
;  :arith-assert-diseq      31
;  :arith-assert-lower      126
;  :arith-assert-upper      85
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         7
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               44
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 182
;  :datatype-occurs-check   100
;  :datatype-splits         107
;  :decisions               190
;  :del-clause              252
;  :final-checks            56
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             945
;  :mk-clause               259
;  :num-allocs              3476971
;  :num-checks              102
;  :propagations            140
;  :quant-instantiations    80
;  :rlimit-count            136485)
; [eval] -1
(push) ; 5
; [then-branch: 22 | First:(Second:(Second:($t@61@07)))[i@62@07] == -1 | live]
; [else-branch: 22 | First:(Second:(Second:($t@61@07)))[i@62@07] != -1 | live]
(push) ; 6
; [then-branch: 22 | First:(Second:(Second:($t@61@07)))[i@62@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    i@62@07)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 22 | First:(Second:(Second:($t@61@07)))[i@62@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      i@62@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@62@07 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1047
;  :arith-assert-diseq      31
;  :arith-assert-lower      126
;  :arith-assert-upper      85
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         7
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               44
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 182
;  :datatype-occurs-check   100
;  :datatype-splits         107
;  :decisions               190
;  :del-clause              252
;  :final-checks            56
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             946
;  :mk-clause               259
;  :num-allocs              3476971
;  :num-checks              103
;  :propagations            140
;  :quant-instantiations    80
;  :rlimit-count            136648)
(push) ; 7
; [then-branch: 23 | 0 <= First:(Second:(Second:($t@61@07)))[i@62@07] | live]
; [else-branch: 23 | !(0 <= First:(Second:(Second:($t@61@07)))[i@62@07]) | live]
(push) ; 8
; [then-branch: 23 | 0 <= First:(Second:(Second:($t@61@07)))[i@62@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    i@62@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@62@07 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1047
;  :arith-assert-diseq      32
;  :arith-assert-lower      129
;  :arith-assert-upper      85
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         7
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               44
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 182
;  :datatype-occurs-check   100
;  :datatype-splits         107
;  :decisions               190
;  :del-clause              252
;  :final-checks            56
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             949
;  :mk-clause               260
;  :num-allocs              3476971
;  :num-checks              104
;  :propagations            140
;  :quant-instantiations    80
;  :rlimit-count            136762)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 23 | !(0 <= First:(Second:(Second:($t@61@07)))[i@62@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      i@62@07))))
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
; [else-branch: 21 | !(i@62@07 < |First:(Second:(Second:($t@61@07)))| && 0 <= i@62@07)]
(assert (not
  (and
    (<
      i@62@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))
    (<= 0 i@62@07))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@62@07 Int)) (!
  (implies
    (and
      (<
        i@62@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))
      (<= 0 i@62@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          i@62@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            i@62@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            i@62@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    i@62@07))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@63@07 $Snap)
(assert (= $t@63@07 ($Snap.combine ($Snap.first $t@63@07) ($Snap.second $t@63@07))))
(assert (=
  ($Snap.second $t@63@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@63@07))
    ($Snap.second ($Snap.second $t@63@07)))))
(assert (=
  ($Snap.second ($Snap.second $t@63@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@63@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@63@07))) $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@63@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@64@07 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 24 | 0 <= i@64@07 | live]
; [else-branch: 24 | !(0 <= i@64@07) | live]
(push) ; 5
; [then-branch: 24 | 0 <= i@64@07]
(assert (<= 0 i@64@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 24 | !(0 <= i@64@07)]
(assert (not (<= 0 i@64@07)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 25 | i@64@07 < |First:(Second:($t@63@07))| && 0 <= i@64@07 | live]
; [else-branch: 25 | !(i@64@07 < |First:(Second:($t@63@07))| && 0 <= i@64@07) | live]
(push) ; 5
; [then-branch: 25 | i@64@07 < |First:(Second:($t@63@07))| && 0 <= i@64@07]
(assert (and
  (<
    i@64@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))))
  (<= 0 i@64@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@64@07 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1102
;  :arith-assert-diseq      32
;  :arith-assert-lower      134
;  :arith-assert-upper      88
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         7
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               45
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   103
;  :datatype-splits         112
;  :decisions               195
;  :del-clause              259
;  :final-checks            59
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             977
;  :mk-clause               261
;  :num-allocs              3476971
;  :num-checks              106
;  :propagations            140
;  :quant-instantiations    84
;  :rlimit-count            138530)
; [eval] -1
(push) ; 6
; [then-branch: 26 | First:(Second:($t@63@07))[i@64@07] == -1 | live]
; [else-branch: 26 | First:(Second:($t@63@07))[i@64@07] != -1 | live]
(push) ; 7
; [then-branch: 26 | First:(Second:($t@63@07))[i@64@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
    i@64@07)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 26 | First:(Second:($t@63@07))[i@64@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
      i@64@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@64@07 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1102
;  :arith-assert-diseq      32
;  :arith-assert-lower      134
;  :arith-assert-upper      88
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         7
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               45
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   103
;  :datatype-splits         112
;  :decisions               195
;  :del-clause              259
;  :final-checks            59
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             978
;  :mk-clause               261
;  :num-allocs              3476971
;  :num-checks              107
;  :propagations            140
;  :quant-instantiations    84
;  :rlimit-count            138681)
(push) ; 8
; [then-branch: 27 | 0 <= First:(Second:($t@63@07))[i@64@07] | live]
; [else-branch: 27 | !(0 <= First:(Second:($t@63@07))[i@64@07]) | live]
(push) ; 9
; [then-branch: 27 | 0 <= First:(Second:($t@63@07))[i@64@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
    i@64@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@64@07 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1102
;  :arith-assert-diseq      33
;  :arith-assert-lower      137
;  :arith-assert-upper      88
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         7
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               45
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   103
;  :datatype-splits         112
;  :decisions               195
;  :del-clause              259
;  :final-checks            59
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             981
;  :mk-clause               262
;  :num-allocs              3476971
;  :num-checks              108
;  :propagations            140
;  :quant-instantiations    84
;  :rlimit-count            138784)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 27 | !(0 <= First:(Second:($t@63@07))[i@64@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
      i@64@07))))
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
; [else-branch: 25 | !(i@64@07 < |First:(Second:($t@63@07))| && 0 <= i@64@07)]
(assert (not
  (and
    (<
      i@64@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))))
    (<= 0 i@64@07))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@64@07 Int)) (!
  (implies
    (and
      (<
        i@64@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))))
      (<= 0 i@64@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
          i@64@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
            i@64@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
            i@64@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
    i@64@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1120
;  :arith-assert-diseq      33
;  :arith-assert-lower      138
;  :arith-assert-upper      89
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        76
;  :arith-fixed-eqs         8
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               45
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   103
;  :datatype-splits         112
;  :decisions               195
;  :del-clause              260
;  :final-checks            59
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             1001
;  :mk-clause               272
;  :num-allocs              3476971
;  :num-checks              109
;  :propagations            144
;  :quant-instantiations    86
;  :rlimit-count            139845)
(push) ; 3
; [then-branch: 28 | 0 <= First:(Second:(Second:($t@61@07)))[0] | live]
; [else-branch: 28 | !(0 <= First:(Second:(Second:($t@61@07)))[0]) | live]
(push) ; 4
; [then-branch: 28 | 0 <= First:(Second:(Second:($t@61@07)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1120
;  :arith-assert-diseq      33
;  :arith-assert-lower      139
;  :arith-assert-upper      89
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         8
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               45
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   103
;  :datatype-splits         112
;  :decisions               195
;  :del-clause              260
;  :final-checks            59
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             1007
;  :mk-clause               278
;  :num-allocs              3476971
;  :num-checks              110
;  :propagations            144
;  :quant-instantiations    87
;  :rlimit-count            140002)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1120
;  :arith-assert-diseq      33
;  :arith-assert-lower      139
;  :arith-assert-upper      89
;  :arith-bound-prop        4
;  :arith-conflicts         6
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         8
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               45
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   103
;  :datatype-splits         112
;  :decisions               195
;  :del-clause              260
;  :final-checks            59
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.95
;  :mk-bool-var             1007
;  :mk-clause               278
;  :num-allocs              3476971
;  :num-checks              111
;  :propagations            144
;  :quant-instantiations    87
;  :rlimit-count            140011)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1121
;  :arith-assert-diseq      33
;  :arith-assert-lower      140
;  :arith-assert-upper      90
;  :arith-bound-prop        4
;  :arith-conflicts         7
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         8
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               46
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   103
;  :datatype-splits         112
;  :decisions               195
;  :del-clause              260
;  :final-checks            59
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1007
;  :mk-clause               278
;  :num-allocs              3615996
;  :num-checks              112
;  :propagations            148
;  :quant-instantiations    87
;  :rlimit-count            140119)
(push) ; 5
; [then-branch: 29 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0 | live]
; [else-branch: 29 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] != 0 | live]
(push) ; 6
; [then-branch: 29 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      0))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 29 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1121
;  :arith-assert-diseq      33
;  :arith-assert-lower      140
;  :arith-assert-upper      90
;  :arith-bound-prop        4
;  :arith-conflicts         7
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         8
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               46
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   103
;  :datatype-splits         112
;  :decisions               195
;  :del-clause              260
;  :final-checks            59
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1008
;  :mk-clause               278
;  :num-allocs              3615996
;  :num-checks              113
;  :propagations            148
;  :quant-instantiations    87
;  :rlimit-count            140338)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1121
;  :arith-assert-diseq      33
;  :arith-assert-lower      140
;  :arith-assert-upper      90
;  :arith-bound-prop        4
;  :arith-conflicts         7
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         8
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               46
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   103
;  :datatype-splits         112
;  :decisions               195
;  :del-clause              260
;  :final-checks            59
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1008
;  :mk-clause               278
;  :num-allocs              3615996
;  :num-checks              114
;  :propagations            148
;  :quant-instantiations    87
;  :rlimit-count            140347)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1122
;  :arith-assert-diseq      33
;  :arith-assert-lower      141
;  :arith-assert-upper      91
;  :arith-bound-prop        4
;  :arith-conflicts         8
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         8
;  :arith-pivots            12
;  :binary-propagations     22
;  :conflicts               47
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   103
;  :datatype-splits         112
;  :decisions               195
;  :del-clause              260
;  :final-checks            59
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1008
;  :mk-clause               278
;  :num-allocs              3615996
;  :num-checks              115
;  :propagations            152
;  :quant-instantiations    87
;  :rlimit-count            140455)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 28 | !(0 <= First:(Second:(Second:($t@61@07)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1149
;  :arith-assert-diseq      35
;  :arith-assert-lower      148
;  :arith-assert-upper      94
;  :arith-bound-prop        4
;  :arith-conflicts         8
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         9
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               47
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   107
;  :datatype-splits         117
;  :decisions               203
;  :del-clause              282
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1031
;  :mk-clause               294
;  :num-allocs              3615996
;  :num-checks              116
;  :propagations            159
;  :quant-instantiations    89
;  :rlimit-count            141218)
(push) ; 4
(assert (not (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1172
;  :arith-assert-diseq      35
;  :arith-assert-lower      149
;  :arith-assert-upper      96
;  :arith-bound-prop        4
;  :arith-conflicts         8
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         9
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               47
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 204
;  :datatype-occurs-check   111
;  :datatype-splits         122
;  :decisions               211
;  :del-clause              288
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1046
;  :mk-clause               300
;  :num-allocs              3615996
;  :num-checks              117
;  :propagations            161
;  :quant-instantiations    90
;  :rlimit-count            141884
;  :time                    0.00)
; [then-branch: 30 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[0] | live]
; [else-branch: 30 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[0]) | live]
(push) ; 4
; [then-branch: 30 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[0]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1172
;  :arith-assert-diseq      35
;  :arith-assert-lower      150
;  :arith-assert-upper      96
;  :arith-bound-prop        4
;  :arith-conflicts         8
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         9
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               47
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 204
;  :datatype-occurs-check   111
;  :datatype-splits         122
;  :decisions               211
;  :del-clause              288
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1054
;  :mk-clause               307
;  :num-allocs              3615996
;  :num-checks              118
;  :propagations            161
;  :quant-instantiations    91
;  :rlimit-count            142109)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 30 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1) ==> diz.Main_process_state[1] == -1
; [eval] 0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[1])
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1178
;  :arith-assert-diseq      35
;  :arith-assert-lower      150
;  :arith-assert-upper      96
;  :arith-bound-prop        4
;  :arith-conflicts         8
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         9
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               47
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 204
;  :datatype-occurs-check   111
;  :datatype-splits         122
;  :decisions               211
;  :del-clause              295
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1061
;  :mk-clause               311
;  :num-allocs              3615996
;  :num-checks              119
;  :propagations            161
;  :quant-instantiations    91
;  :rlimit-count            142648)
(push) ; 3
; [then-branch: 31 | 0 <= First:(Second:(Second:($t@61@07)))[1] | live]
; [else-branch: 31 | !(0 <= First:(Second:(Second:($t@61@07)))[1]) | live]
(push) ; 4
; [then-branch: 31 | 0 <= First:(Second:(Second:($t@61@07)))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    1)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1178
;  :arith-assert-diseq      35
;  :arith-assert-lower      151
;  :arith-assert-upper      96
;  :arith-bound-prop        4
;  :arith-conflicts         8
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         9
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               47
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 204
;  :datatype-occurs-check   111
;  :datatype-splits         122
;  :decisions               211
;  :del-clause              295
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1067
;  :mk-clause               317
;  :num-allocs              3615996
;  :num-checks              120
;  :propagations            161
;  :quant-instantiations    92
;  :rlimit-count            142804)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1178
;  :arith-assert-diseq      35
;  :arith-assert-lower      151
;  :arith-assert-upper      96
;  :arith-bound-prop        4
;  :arith-conflicts         8
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         9
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               47
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 204
;  :datatype-occurs-check   111
;  :datatype-splits         122
;  :decisions               211
;  :del-clause              295
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1067
;  :mk-clause               317
;  :num-allocs              3615996
;  :num-checks              121
;  :propagations            161
;  :quant-instantiations    92
;  :rlimit-count            142813)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1179
;  :arith-assert-diseq      35
;  :arith-assert-lower      152
;  :arith-assert-upper      97
;  :arith-bound-prop        4
;  :arith-conflicts         9
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         9
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               48
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 204
;  :datatype-occurs-check   111
;  :datatype-splits         122
;  :decisions               211
;  :del-clause              295
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1067
;  :mk-clause               317
;  :num-allocs              3615996
;  :num-checks              122
;  :propagations            165
;  :quant-instantiations    92
;  :rlimit-count            142920)
(push) ; 5
; [then-branch: 32 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0 | live]
; [else-branch: 32 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] != 0 | live]
(push) ; 6
; [then-branch: 32 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      1))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 32 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        1))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 7
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1179
;  :arith-assert-diseq      35
;  :arith-assert-lower      152
;  :arith-assert-upper      97
;  :arith-bound-prop        4
;  :arith-conflicts         9
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         9
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               48
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 204
;  :datatype-occurs-check   111
;  :datatype-splits         122
;  :decisions               211
;  :del-clause              295
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1068
;  :mk-clause               317
;  :num-allocs              3615996
;  :num-checks              123
;  :propagations            165
;  :quant-instantiations    92
;  :rlimit-count            143139)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1179
;  :arith-assert-diseq      35
;  :arith-assert-lower      152
;  :arith-assert-upper      97
;  :arith-bound-prop        4
;  :arith-conflicts         9
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         9
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               48
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 204
;  :datatype-occurs-check   111
;  :datatype-splits         122
;  :decisions               211
;  :del-clause              295
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1068
;  :mk-clause               317
;  :num-allocs              3615996
;  :num-checks              124
;  :propagations            165
;  :quant-instantiations    92
;  :rlimit-count            143148)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1180
;  :arith-assert-diseq      35
;  :arith-assert-lower      153
;  :arith-assert-upper      98
;  :arith-bound-prop        4
;  :arith-conflicts         10
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         9
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               49
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 204
;  :datatype-occurs-check   111
;  :datatype-splits         122
;  :decisions               211
;  :del-clause              295
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1068
;  :mk-clause               317
;  :num-allocs              3615996
;  :num-checks              125
;  :propagations            169
;  :quant-instantiations    92
;  :rlimit-count            143255)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 31 | !(0 <= First:(Second:(Second:($t@61@07)))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      1))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1210
;  :arith-assert-diseq      37
;  :arith-assert-lower      162
;  :arith-assert-upper      104
;  :arith-bound-prop        4
;  :arith-conflicts         10
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         10
;  :arith-pivots            17
;  :binary-propagations     22
;  :conflicts               49
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 212
;  :datatype-occurs-check   115
;  :datatype-splits         127
;  :decisions               221
;  :del-clause              323
;  :final-checks            66
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1099
;  :mk-clause               339
;  :num-allocs              3615996
;  :num-checks              126
;  :propagations            179
;  :quant-instantiations    95
;  :rlimit-count            144123
;  :time                    0.00)
(push) ; 4
(assert (not (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1238
;  :arith-assert-diseq      37
;  :arith-assert-lower      164
;  :arith-assert-upper      108
;  :arith-bound-prop        4
;  :arith-conflicts         10
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         10
;  :arith-pivots            17
;  :binary-propagations     22
;  :conflicts               49
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 220
;  :datatype-occurs-check   119
;  :datatype-splits         132
;  :decisions               230
;  :del-clause              331
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1119
;  :mk-clause               347
;  :num-allocs              3615996
;  :num-checks              127
;  :propagations            182
;  :quant-instantiations    97
;  :rlimit-count            144859
;  :time                    0.00)
; [then-branch: 33 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[1] | live]
; [else-branch: 33 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[1]) | live]
(push) ; 4
; [then-branch: 33 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[1]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      1))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1238
;  :arith-assert-diseq      37
;  :arith-assert-lower      165
;  :arith-assert-upper      108
;  :arith-bound-prop        4
;  :arith-conflicts         10
;  :arith-eq-adapter        91
;  :arith-fixed-eqs         10
;  :arith-pivots            17
;  :binary-propagations     22
;  :conflicts               49
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 220
;  :datatype-occurs-check   119
;  :datatype-splits         132
;  :decisions               230
;  :del-clause              331
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1127
;  :mk-clause               354
;  :num-allocs              3615996
;  :num-checks              128
;  :propagations            182
;  :quant-instantiations    98
;  :rlimit-count            145084)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 33 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        1)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
      1)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[2]) && (old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[2])]) == -1) ==> diz.Main_process_state[2] == -1
; [eval] 0 <= old(diz.Main_process_state[2]) && (old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[2])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[2])
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 3
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1244
;  :arith-assert-diseq      37
;  :arith-assert-lower      165
;  :arith-assert-upper      108
;  :arith-bound-prop        4
;  :arith-conflicts         10
;  :arith-eq-adapter        91
;  :arith-fixed-eqs         10
;  :arith-pivots            17
;  :binary-propagations     22
;  :conflicts               49
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 220
;  :datatype-occurs-check   119
;  :datatype-splits         132
;  :decisions               230
;  :del-clause              338
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1134
;  :mk-clause               358
;  :num-allocs              3615996
;  :num-checks              129
;  :propagations            182
;  :quant-instantiations    98
;  :rlimit-count            145633)
(push) ; 3
; [then-branch: 34 | 0 <= First:(Second:(Second:($t@61@07)))[2] | live]
; [else-branch: 34 | !(0 <= First:(Second:(Second:($t@61@07)))[2]) | live]
(push) ; 4
; [then-branch: 34 | 0 <= First:(Second:(Second:($t@61@07)))[2]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    2)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[2])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[2])]
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1244
;  :arith-assert-diseq      37
;  :arith-assert-lower      166
;  :arith-assert-upper      108
;  :arith-bound-prop        4
;  :arith-conflicts         10
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         10
;  :arith-pivots            17
;  :binary-propagations     22
;  :conflicts               49
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 220
;  :datatype-occurs-check   119
;  :datatype-splits         132
;  :decisions               230
;  :del-clause              338
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1140
;  :mk-clause               364
;  :num-allocs              3615996
;  :num-checks              130
;  :propagations            182
;  :quant-instantiations    99
;  :rlimit-count            145789)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1244
;  :arith-assert-diseq      37
;  :arith-assert-lower      166
;  :arith-assert-upper      108
;  :arith-bound-prop        4
;  :arith-conflicts         10
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         10
;  :arith-pivots            17
;  :binary-propagations     22
;  :conflicts               49
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 220
;  :datatype-occurs-check   119
;  :datatype-splits         132
;  :decisions               230
;  :del-clause              338
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1140
;  :mk-clause               364
;  :num-allocs              3615996
;  :num-checks              131
;  :propagations            182
;  :quant-instantiations    99
;  :rlimit-count            145798)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1245
;  :arith-assert-diseq      37
;  :arith-assert-lower      167
;  :arith-assert-upper      109
;  :arith-bound-prop        4
;  :arith-conflicts         11
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         10
;  :arith-pivots            17
;  :binary-propagations     22
;  :conflicts               50
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 220
;  :datatype-occurs-check   119
;  :datatype-splits         132
;  :decisions               230
;  :del-clause              338
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1140
;  :mk-clause               364
;  :num-allocs              3615996
;  :num-checks              132
;  :propagations            186
;  :quant-instantiations    99
;  :rlimit-count            145905)
(push) ; 5
; [then-branch: 35 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0 | live]
; [else-branch: 35 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] != 0 | live]
(push) ; 6
; [then-branch: 35 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      2))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 35 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        2))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[2])]
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 7
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1245
;  :arith-assert-diseq      37
;  :arith-assert-lower      167
;  :arith-assert-upper      109
;  :arith-bound-prop        4
;  :arith-conflicts         11
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         10
;  :arith-pivots            17
;  :binary-propagations     22
;  :conflicts               50
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 220
;  :datatype-occurs-check   119
;  :datatype-splits         132
;  :decisions               230
;  :del-clause              338
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1141
;  :mk-clause               364
;  :num-allocs              3615996
;  :num-checks              133
;  :propagations            186
;  :quant-instantiations    99
;  :rlimit-count            146124)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1245
;  :arith-assert-diseq      37
;  :arith-assert-lower      167
;  :arith-assert-upper      109
;  :arith-bound-prop        4
;  :arith-conflicts         11
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         10
;  :arith-pivots            17
;  :binary-propagations     22
;  :conflicts               50
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 220
;  :datatype-occurs-check   119
;  :datatype-splits         132
;  :decisions               230
;  :del-clause              338
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1141
;  :mk-clause               364
;  :num-allocs              3615996
;  :num-checks              134
;  :propagations            186
;  :quant-instantiations    99
;  :rlimit-count            146133)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1246
;  :arith-assert-diseq      37
;  :arith-assert-lower      168
;  :arith-assert-upper      110
;  :arith-bound-prop        4
;  :arith-conflicts         12
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         10
;  :arith-pivots            17
;  :binary-propagations     22
;  :conflicts               51
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 220
;  :datatype-occurs-check   119
;  :datatype-splits         132
;  :decisions               230
;  :del-clause              338
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1141
;  :mk-clause               364
;  :num-allocs              3615996
;  :num-checks              135
;  :propagations            190
;  :quant-instantiations    99
;  :rlimit-count            146240)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 34 | !(0 <= First:(Second:(Second:($t@61@07)))[2])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      2))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            2))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            2))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        2))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1280
;  :arith-assert-diseq      39
;  :arith-assert-lower      177
;  :arith-assert-upper      117
;  :arith-bound-prop        4
;  :arith-conflicts         12
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               51
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   123
;  :datatype-splits         137
;  :decisions               240
;  :del-clause              364
;  :final-checks            70
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1174
;  :mk-clause               384
;  :num-allocs              3615996
;  :num-checks              136
;  :propagations            199
;  :quant-instantiations    103
;  :rlimit-count            147133)
(push) ; 4
(assert (not (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          2))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          2))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      2)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1313
;  :arith-assert-diseq      39
;  :arith-assert-lower      180
;  :arith-assert-upper      123
;  :arith-bound-prop        4
;  :arith-conflicts         12
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               51
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 236
;  :datatype-occurs-check   127
;  :datatype-splits         142
;  :decisions               250
;  :del-clause              374
;  :final-checks            72
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1199
;  :mk-clause               394
;  :num-allocs              3615996
;  :num-checks              137
;  :propagations            203
;  :quant-instantiations    106
;  :rlimit-count            147935
;  :time                    0.00)
; [then-branch: 36 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[2] | live]
; [else-branch: 36 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[2]) | live]
(push) ; 4
; [then-branch: 36 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[2]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          2))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          2))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      2))))
; [eval] diz.Main_process_state[2] == -1
; [eval] diz.Main_process_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1313
;  :arith-assert-diseq      39
;  :arith-assert-lower      181
;  :arith-assert-upper      123
;  :arith-bound-prop        4
;  :arith-conflicts         12
;  :arith-eq-adapter        101
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               51
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 236
;  :datatype-occurs-check   127
;  :datatype-splits         142
;  :decisions               250
;  :del-clause              374
;  :final-checks            72
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1207
;  :mk-clause               401
;  :num-allocs              3615996
;  :num-checks              138
;  :propagations            203
;  :quant-instantiations    107
;  :rlimit-count            148160)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 36 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[2])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            2))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            2))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        2)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            2))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            2))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        2)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
      2)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1319
;  :arith-assert-diseq      39
;  :arith-assert-lower      181
;  :arith-assert-upper      123
;  :arith-bound-prop        4
;  :arith-conflicts         12
;  :arith-eq-adapter        101
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               51
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 236
;  :datatype-occurs-check   127
;  :datatype-splits         142
;  :decisions               250
;  :del-clause              381
;  :final-checks            72
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1214
;  :mk-clause               405
;  :num-allocs              3615996
;  :num-checks              139
;  :propagations            203
;  :quant-instantiations    107
;  :rlimit-count            148719)
(push) ; 3
; [then-branch: 37 | 0 <= First:(Second:(Second:($t@61@07)))[0] | live]
; [else-branch: 37 | !(0 <= First:(Second:(Second:($t@61@07)))[0]) | live]
(push) ; 4
; [then-branch: 37 | 0 <= First:(Second:(Second:($t@61@07)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1319
;  :arith-assert-diseq      39
;  :arith-assert-lower      182
;  :arith-assert-upper      123
;  :arith-bound-prop        4
;  :arith-conflicts         12
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               51
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 236
;  :datatype-occurs-check   127
;  :datatype-splits         142
;  :decisions               250
;  :del-clause              381
;  :final-checks            72
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1219
;  :mk-clause               411
;  :num-allocs              3615996
;  :num-checks              140
;  :propagations            203
;  :quant-instantiations    108
;  :rlimit-count            148836)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1319
;  :arith-assert-diseq      39
;  :arith-assert-lower      182
;  :arith-assert-upper      123
;  :arith-bound-prop        4
;  :arith-conflicts         12
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               51
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 236
;  :datatype-occurs-check   127
;  :datatype-splits         142
;  :decisions               250
;  :del-clause              381
;  :final-checks            72
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1219
;  :mk-clause               411
;  :num-allocs              3615996
;  :num-checks              141
;  :propagations            203
;  :quant-instantiations    108
;  :rlimit-count            148845)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1320
;  :arith-assert-diseq      39
;  :arith-assert-lower      183
;  :arith-assert-upper      124
;  :arith-bound-prop        4
;  :arith-conflicts         13
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               52
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 236
;  :datatype-occurs-check   127
;  :datatype-splits         142
;  :decisions               250
;  :del-clause              381
;  :final-checks            72
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1219
;  :mk-clause               411
;  :num-allocs              3615996
;  :num-checks              142
;  :propagations            207
;  :quant-instantiations    108
;  :rlimit-count            148953)
(push) ; 5
; [then-branch: 38 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0 | live]
; [else-branch: 38 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] != 0 | live]
(push) ; 6
; [then-branch: 38 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      0))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 38 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1320
;  :arith-assert-diseq      39
;  :arith-assert-lower      183
;  :arith-assert-upper      124
;  :arith-bound-prop        4
;  :arith-conflicts         13
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               52
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 236
;  :datatype-occurs-check   127
;  :datatype-splits         142
;  :decisions               250
;  :del-clause              381
;  :final-checks            72
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1219
;  :mk-clause               411
;  :num-allocs              3615996
;  :num-checks              143
;  :propagations            207
;  :quant-instantiations    108
;  :rlimit-count            149156)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1320
;  :arith-assert-diseq      39
;  :arith-assert-lower      183
;  :arith-assert-upper      124
;  :arith-bound-prop        4
;  :arith-conflicts         13
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               52
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 236
;  :datatype-occurs-check   127
;  :datatype-splits         142
;  :decisions               250
;  :del-clause              381
;  :final-checks            72
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1219
;  :mk-clause               411
;  :num-allocs              3615996
;  :num-checks              144
;  :propagations            207
;  :quant-instantiations    108
;  :rlimit-count            149165)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1321
;  :arith-assert-diseq      39
;  :arith-assert-lower      184
;  :arith-assert-upper      125
;  :arith-bound-prop        4
;  :arith-conflicts         14
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               53
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 236
;  :datatype-occurs-check   127
;  :datatype-splits         142
;  :decisions               250
;  :del-clause              381
;  :final-checks            72
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1219
;  :mk-clause               411
;  :num-allocs              3615996
;  :num-checks              145
;  :propagations            211
;  :quant-instantiations    108
;  :rlimit-count            149273)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 37 | !(0 <= First:(Second:(Second:($t@61@07)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1355
;  :arith-assert-diseq      39
;  :arith-assert-lower      187
;  :arith-assert-upper      131
;  :arith-bound-prop        4
;  :arith-conflicts         14
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               53
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 244
;  :datatype-occurs-check   131
;  :datatype-splits         147
;  :decisions               260
;  :del-clause              394
;  :final-checks            74
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1240
;  :mk-clause               418
;  :num-allocs              3615996
;  :num-checks              146
;  :propagations            215
;  :quant-instantiations    111
;  :rlimit-count            150088)
(push) ; 4
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1412
;  :arith-assert-diseq      40
;  :arith-assert-lower      192
;  :arith-assert-upper      137
;  :arith-bound-prop        4
;  :arith-conflicts         14
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               56
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 259
;  :datatype-occurs-check   139
;  :datatype-splits         156
;  :decisions               277
;  :del-clause              407
;  :final-checks            79
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1278
;  :mk-clause               431
;  :num-allocs              3615996
;  :num-checks              147
;  :propagations            223
;  :quant-instantiations    114
;  :rlimit-count            151014
;  :time                    0.00)
; [then-branch: 39 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[0]) | live]
; [else-branch: 39 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[0] | live]
(push) ; 4
; [then-branch: 39 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1412
;  :arith-assert-diseq      40
;  :arith-assert-lower      192
;  :arith-assert-upper      137
;  :arith-bound-prop        4
;  :arith-conflicts         14
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               56
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 259
;  :datatype-occurs-check   139
;  :datatype-splits         156
;  :decisions               277
;  :del-clause              407
;  :final-checks            79
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1278
;  :mk-clause               432
;  :num-allocs              3615996
;  :num-checks              148
;  :propagations            223
;  :quant-instantiations    114
;  :rlimit-count            151229)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1412
;  :arith-assert-diseq      40
;  :arith-assert-lower      192
;  :arith-assert-upper      137
;  :arith-bound-prop        4
;  :arith-conflicts         14
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               56
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 259
;  :datatype-occurs-check   139
;  :datatype-splits         156
;  :decisions               277
;  :del-clause              407
;  :final-checks            79
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1278
;  :mk-clause               432
;  :num-allocs              3615996
;  :num-checks              149
;  :propagations            223
;  :quant-instantiations    114
;  :rlimit-count            151244)
(pop) ; 4
(push) ; 4
; [else-branch: 39 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[0]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[0]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
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
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
              0))
          0)
        (=
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1)) ==> diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] !(0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1))
; [eval] 0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[1])
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1418
;  :arith-assert-diseq      40
;  :arith-assert-lower      192
;  :arith-assert-upper      137
;  :arith-bound-prop        4
;  :arith-conflicts         14
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               56
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 259
;  :datatype-occurs-check   139
;  :datatype-splits         156
;  :decisions               277
;  :del-clause              408
;  :final-checks            79
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1282
;  :mk-clause               436
;  :num-allocs              3615996
;  :num-checks              150
;  :propagations            223
;  :quant-instantiations    114
;  :rlimit-count            151791)
(push) ; 3
; [then-branch: 40 | 0 <= First:(Second:(Second:($t@61@07)))[1] | live]
; [else-branch: 40 | !(0 <= First:(Second:(Second:($t@61@07)))[1]) | live]
(push) ; 4
; [then-branch: 40 | 0 <= First:(Second:(Second:($t@61@07)))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    1)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1418
;  :arith-assert-diseq      40
;  :arith-assert-lower      193
;  :arith-assert-upper      137
;  :arith-bound-prop        4
;  :arith-conflicts         14
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               56
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 259
;  :datatype-occurs-check   139
;  :datatype-splits         156
;  :decisions               277
;  :del-clause              408
;  :final-checks            79
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1287
;  :mk-clause               442
;  :num-allocs              3615996
;  :num-checks              151
;  :propagations            223
;  :quant-instantiations    115
;  :rlimit-count            151908)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1418
;  :arith-assert-diseq      40
;  :arith-assert-lower      193
;  :arith-assert-upper      137
;  :arith-bound-prop        4
;  :arith-conflicts         14
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               56
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 259
;  :datatype-occurs-check   139
;  :datatype-splits         156
;  :decisions               277
;  :del-clause              408
;  :final-checks            79
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1287
;  :mk-clause               442
;  :num-allocs              3615996
;  :num-checks              152
;  :propagations            223
;  :quant-instantiations    115
;  :rlimit-count            151917)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1419
;  :arith-assert-diseq      40
;  :arith-assert-lower      194
;  :arith-assert-upper      138
;  :arith-bound-prop        4
;  :arith-conflicts         15
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               57
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 259
;  :datatype-occurs-check   139
;  :datatype-splits         156
;  :decisions               277
;  :del-clause              408
;  :final-checks            79
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1287
;  :mk-clause               442
;  :num-allocs              3615996
;  :num-checks              153
;  :propagations            227
;  :quant-instantiations    115
;  :rlimit-count            152025)
(push) ; 5
; [then-branch: 41 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0 | live]
; [else-branch: 41 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] != 0 | live]
(push) ; 6
; [then-branch: 41 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      1))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 41 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        1))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 7
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1419
;  :arith-assert-diseq      40
;  :arith-assert-lower      194
;  :arith-assert-upper      138
;  :arith-bound-prop        4
;  :arith-conflicts         15
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               57
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 259
;  :datatype-occurs-check   139
;  :datatype-splits         156
;  :decisions               277
;  :del-clause              408
;  :final-checks            79
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1287
;  :mk-clause               442
;  :num-allocs              3615996
;  :num-checks              154
;  :propagations            227
;  :quant-instantiations    115
;  :rlimit-count            152228)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1419
;  :arith-assert-diseq      40
;  :arith-assert-lower      194
;  :arith-assert-upper      138
;  :arith-bound-prop        4
;  :arith-conflicts         15
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               57
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 259
;  :datatype-occurs-check   139
;  :datatype-splits         156
;  :decisions               277
;  :del-clause              408
;  :final-checks            79
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1287
;  :mk-clause               442
;  :num-allocs              3615996
;  :num-checks              155
;  :propagations            227
;  :quant-instantiations    115
;  :rlimit-count            152237)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1420
;  :arith-assert-diseq      40
;  :arith-assert-lower      195
;  :arith-assert-upper      139
;  :arith-bound-prop        4
;  :arith-conflicts         16
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         11
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               58
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 259
;  :datatype-occurs-check   139
;  :datatype-splits         156
;  :decisions               277
;  :del-clause              408
;  :final-checks            79
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1287
;  :mk-clause               442
;  :num-allocs              3615996
;  :num-checks              156
;  :propagations            231
;  :quant-instantiations    115
;  :rlimit-count            152345)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 40 | !(0 <= First:(Second:(Second:($t@61@07)))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      1))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1457
;  :arith-assert-diseq      40
;  :arith-assert-lower      199
;  :arith-assert-upper      146
;  :arith-bound-prop        6
;  :arith-conflicts         16
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         12
;  :arith-pivots            21
;  :binary-propagations     22
;  :conflicts               58
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 267
;  :datatype-occurs-check   143
;  :datatype-splits         161
;  :decisions               287
;  :del-clause              429
;  :final-checks            81
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1317
;  :mk-clause               457
;  :num-allocs              3615996
;  :num-checks              157
;  :propagations            238
;  :quant-instantiations    119
;  :rlimit-count            153221)
(push) ; 4
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1521
;  :arith-assert-diseq      41
;  :arith-assert-lower      206
;  :arith-assert-upper      154
;  :arith-bound-prop        8
;  :arith-conflicts         16
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         13
;  :arith-pivots            23
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 282
;  :datatype-occurs-check   151
;  :datatype-splits         174
;  :decisions               305
;  :del-clause              448
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1370
;  :mk-clause               476
;  :num-allocs              3615996
;  :num-checks              158
;  :propagations            249
;  :quant-instantiations    124
;  :rlimit-count            154225
;  :time                    0.00)
; [then-branch: 42 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[1]) | live]
; [else-branch: 42 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[1] | live]
(push) ; 4
; [then-branch: 42 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        1)))))
; [eval] diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1521
;  :arith-assert-diseq      41
;  :arith-assert-lower      206
;  :arith-assert-upper      154
;  :arith-bound-prop        8
;  :arith-conflicts         16
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         13
;  :arith-pivots            23
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 282
;  :datatype-occurs-check   151
;  :datatype-splits         174
;  :decisions               305
;  :del-clause              448
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1370
;  :mk-clause               477
;  :num-allocs              3615996
;  :num-checks              159
;  :propagations            249
;  :quant-instantiations    124
;  :rlimit-count            154440)
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1521
;  :arith-assert-diseq      41
;  :arith-assert-lower      206
;  :arith-assert-upper      154
;  :arith-bound-prop        8
;  :arith-conflicts         16
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         13
;  :arith-pivots            23
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 282
;  :datatype-occurs-check   151
;  :datatype-splits         174
;  :decisions               305
;  :del-clause              448
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1370
;  :mk-clause               477
;  :num-allocs              3615996
;  :num-checks              160
;  :propagations            249
;  :quant-instantiations    124
;  :rlimit-count            154455)
(pop) ; 4
(push) ; 4
; [else-branch: 42 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[1]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[1]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      1))))
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
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
              1))
          0)
        (=
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
              1))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[2]) && (old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[2])]) == -1)) ==> diz.Main_process_state[2] == old(diz.Main_process_state[2])
; [eval] !(0 <= old(diz.Main_process_state[2]) && (old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[2])]) == -1))
; [eval] 0 <= old(diz.Main_process_state[2]) && (old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[2])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[2])
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 3
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1523
;  :arith-assert-diseq      41
;  :arith-assert-lower      206
;  :arith-assert-upper      154
;  :arith-bound-prop        8
;  :arith-conflicts         16
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         13
;  :arith-pivots            23
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 282
;  :datatype-occurs-check   151
;  :datatype-splits         174
;  :decisions               305
;  :del-clause              449
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1373
;  :mk-clause               481
;  :num-allocs              3615996
;  :num-checks              161
;  :propagations            249
;  :quant-instantiations    124
;  :rlimit-count            154918)
(push) ; 3
; [then-branch: 43 | 0 <= First:(Second:(Second:($t@61@07)))[2] | live]
; [else-branch: 43 | !(0 <= First:(Second:(Second:($t@61@07)))[2]) | live]
(push) ; 4
; [then-branch: 43 | 0 <= First:(Second:(Second:($t@61@07)))[2]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    2)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[2])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[2])]
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1523
;  :arith-assert-diseq      41
;  :arith-assert-lower      207
;  :arith-assert-upper      154
;  :arith-bound-prop        8
;  :arith-conflicts         16
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         13
;  :arith-pivots            23
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 282
;  :datatype-occurs-check   151
;  :datatype-splits         174
;  :decisions               305
;  :del-clause              449
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1378
;  :mk-clause               487
;  :num-allocs              3615996
;  :num-checks              162
;  :propagations            249
;  :quant-instantiations    125
;  :rlimit-count            155035)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1523
;  :arith-assert-diseq      41
;  :arith-assert-lower      207
;  :arith-assert-upper      154
;  :arith-bound-prop        8
;  :arith-conflicts         16
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         13
;  :arith-pivots            23
;  :binary-propagations     22
;  :conflicts               61
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 282
;  :datatype-occurs-check   151
;  :datatype-splits         174
;  :decisions               305
;  :del-clause              449
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1378
;  :mk-clause               487
;  :num-allocs              3615996
;  :num-checks              163
;  :propagations            249
;  :quant-instantiations    125
;  :rlimit-count            155044)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1524
;  :arith-assert-diseq      41
;  :arith-assert-lower      208
;  :arith-assert-upper      155
;  :arith-bound-prop        8
;  :arith-conflicts         17
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         13
;  :arith-pivots            23
;  :binary-propagations     22
;  :conflicts               62
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 282
;  :datatype-occurs-check   151
;  :datatype-splits         174
;  :decisions               305
;  :del-clause              449
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1378
;  :mk-clause               487
;  :num-allocs              3615996
;  :num-checks              164
;  :propagations            253
;  :quant-instantiations    125
;  :rlimit-count            155152)
(push) ; 5
; [then-branch: 44 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0 | live]
; [else-branch: 44 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] != 0 | live]
(push) ; 6
; [then-branch: 44 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      2))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 44 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        2))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[2])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[2])]
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 7
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1524
;  :arith-assert-diseq      41
;  :arith-assert-lower      208
;  :arith-assert-upper      155
;  :arith-bound-prop        8
;  :arith-conflicts         17
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         13
;  :arith-pivots            23
;  :binary-propagations     22
;  :conflicts               62
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 282
;  :datatype-occurs-check   151
;  :datatype-splits         174
;  :decisions               305
;  :del-clause              449
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1378
;  :mk-clause               487
;  :num-allocs              3615996
;  :num-checks              165
;  :propagations            253
;  :quant-instantiations    125
;  :rlimit-count            155355)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1524
;  :arith-assert-diseq      41
;  :arith-assert-lower      208
;  :arith-assert-upper      155
;  :arith-bound-prop        8
;  :arith-conflicts         17
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         13
;  :arith-pivots            23
;  :binary-propagations     22
;  :conflicts               62
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 282
;  :datatype-occurs-check   151
;  :datatype-splits         174
;  :decisions               305
;  :del-clause              449
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1378
;  :mk-clause               487
;  :num-allocs              3615996
;  :num-checks              166
;  :propagations            253
;  :quant-instantiations    125
;  :rlimit-count            155364)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1525
;  :arith-assert-diseq      41
;  :arith-assert-lower      209
;  :arith-assert-upper      156
;  :arith-bound-prop        8
;  :arith-conflicts         18
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         13
;  :arith-pivots            23
;  :binary-propagations     22
;  :conflicts               63
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 282
;  :datatype-occurs-check   151
;  :datatype-splits         174
;  :decisions               305
;  :del-clause              449
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1378
;  :mk-clause               487
;  :num-allocs              3615996
;  :num-checks              167
;  :propagations            257
;  :quant-instantiations    125
;  :rlimit-count            155472)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 43 | !(0 <= First:(Second:(Second:($t@61@07)))[2])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      2))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          2))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          2))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      2)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1563
;  :arith-assert-diseq      41
;  :arith-assert-lower      214
;  :arith-assert-upper      164
;  :arith-bound-prop        12
;  :arith-conflicts         18
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         15
;  :arith-pivots            27
;  :binary-propagations     22
;  :conflicts               63
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 289
;  :datatype-occurs-check   155
;  :datatype-splits         178
;  :decisions               314
;  :del-clause              478
;  :final-checks            87
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1417
;  :mk-clause               510
;  :num-allocs              3615996
;  :num-checks              168
;  :propagations            267
;  :quant-instantiations    130
;  :rlimit-count            156395
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            2))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            2))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        2))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1625
;  :arith-assert-diseq      42
;  :arith-assert-lower      222
;  :arith-assert-upper      172
;  :arith-bound-prop        16
;  :arith-conflicts         18
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         17
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               66
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 303
;  :datatype-occurs-check   163
;  :datatype-splits         186
;  :decisions               330
;  :del-clause              510
;  :final-checks            92
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1475
;  :mk-clause               542
;  :num-allocs              3615996
;  :num-checks              169
;  :propagations            282
;  :quant-instantiations    135
;  :rlimit-count            157423
;  :time                    0.00)
; [then-branch: 45 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[2]) | live]
; [else-branch: 45 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[2] | live]
(push) ; 4
; [then-branch: 45 | !(First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[2])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            2))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
            2))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
        2)))))
; [eval] diz.Main_process_state[2] == old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1625
;  :arith-assert-diseq      42
;  :arith-assert-lower      222
;  :arith-assert-upper      172
;  :arith-bound-prop        16
;  :arith-conflicts         18
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         17
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               66
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 303
;  :datatype-occurs-check   163
;  :datatype-splits         186
;  :decisions               330
;  :del-clause              510
;  :final-checks            92
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1475
;  :mk-clause               543
;  :num-allocs              3615996
;  :num-checks              170
;  :propagations            282
;  :quant-instantiations    135
;  :rlimit-count            157638)
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1625
;  :arith-assert-diseq      42
;  :arith-assert-lower      222
;  :arith-assert-upper      172
;  :arith-bound-prop        16
;  :arith-conflicts         18
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         17
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               66
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 303
;  :datatype-occurs-check   163
;  :datatype-splits         186
;  :decisions               330
;  :del-clause              510
;  :final-checks            92
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             1475
;  :mk-clause               543
;  :num-allocs              3615996
;  :num-checks              171
;  :propagations            282
;  :quant-instantiations    135
;  :rlimit-count            157653)
(pop) ; 4
(push) ; 4
; [else-branch: 45 | First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@61@07)))))[First:(Second:(Second:($t@61@07)))[2]] == -1 && 0 <= First:(Second:(Second:($t@61@07)))[2]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          2))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          2))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      2))))
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
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
              2))
          0)
        (=
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
              2))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
          2))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@07)))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@61@07))))
      2))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
