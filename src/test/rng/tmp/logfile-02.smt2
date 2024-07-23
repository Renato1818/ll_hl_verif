(get-info :version)
; (:version "4.8.6")
; Started: 2024-07-16 14:26:43
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
(declare-fun zfrac_val<Perm> (zfrac) $Perm)
(declare-const class_Rng<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Object<TYPE> TYPE)
(declare-const class_CASR<TYPE> TYPE)
(declare-const class_LFSR<TYPE> TYPE)
(declare-const class_Combinate<TYPE> TYPE)
(declare-const class_Main<TYPE> TYPE)
(declare-const class_EncodedGlobalVariables<TYPE> TYPE)
(declare-fun directSuperclass<TYPE> (TYPE) TYPE)
(declare-fun type_of<TYPE> ($Ref) TYPE)
; /field_value_functions_declarations.smt2 [Main_process_state: Seq[Int]]
(declare-fun $FVF.domain_Main_process_state ($FVF<Seq<Int>>) Set<$Ref>)
(declare-fun $FVF.lookup_Main_process_state ($FVF<Seq<Int>> $Ref) Seq<Int>)
(declare-fun $FVF.after_Main_process_state ($FVF<Seq<Int>> $FVF<Seq<Int>>) Bool)
(declare-fun $FVF.loc_Main_process_state (Seq<Int> $Ref) Bool)
(declare-fun $FVF.perm_Main_process_state ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Main_process_state $FVF<Seq<Int>>)
; /field_value_functions_declarations.smt2 [Rng_m: Ref]
(declare-fun $FVF.domain_Rng_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Rng_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Rng_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Rng_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Rng_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Rng_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [CASR_m: Ref]
(declare-fun $FVF.domain_CASR_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_CASR_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_CASR_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_CASR_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_CASR_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_CASR_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [LFSR_m: Ref]
(declare-fun $FVF.domain_LFSR_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_LFSR_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_LFSR_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_LFSR_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_LFSR_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_LFSR_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [Combinate_m: Ref]
(declare-fun $FVF.domain_Combinate_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Combinate_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Combinate_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Combinate_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Combinate_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Combinate_m $FVF<$Ref>)
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
(declare-fun CASR_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun CASR_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun LFSR_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun LFSR_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Combinate_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Combinate_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_held_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
; ////////// Uniqueness assumptions from domains
(assert (distinct class_Rng<TYPE> class_java_DOT_lang_DOT_Object<TYPE> class_CASR<TYPE> class_LFSR<TYPE> class_Combinate<TYPE> class_Main<TYPE> class_EncodedGlobalVariables<TYPE>))
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
(assert (forall ((a zfrac) (b zfrac)) (!
  (= (= (zfrac_val<Perm> a) (zfrac_val<Perm> b)) (= a b))
  :pattern ((zfrac_val<Perm> a) (zfrac_val<Perm> b))
  :qid |prog.zfrac_eq|)))
(assert (forall ((a zfrac)) (!
  (and (<= $Perm.No (zfrac_val<Perm> a)) (<= (zfrac_val<Perm> a) $Perm.Write))
  :pattern ((zfrac_val<Perm> a))
  :qid |prog.zfrac_bound|)))
(assert (=
  (directSuperclass<TYPE> (as class_Rng<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_CASR<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_LFSR<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Combinate<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Main<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_EncodedGlobalVariables<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
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
; /field_value_functions_axioms.smt2 [Rng_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Rng_m vs) ($FVF.domain_Rng_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Rng_m vs))
            (= ($FVF.lookup_Rng_m vs x) ($FVF.lookup_Rng_m ws x)))
          :pattern (($FVF.lookup_Rng_m vs x) ($FVF.lookup_Rng_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Rng_m pm r))
    :pattern ($FVF.perm_Rng_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Rng_m f r) true)
    :pattern ($FVF.loc_Rng_m f r))))
; /field_value_functions_axioms.smt2 [CASR_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_CASR_m vs) ($FVF.domain_CASR_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_CASR_m vs))
            (= ($FVF.lookup_CASR_m vs x) ($FVF.lookup_CASR_m ws x)))
          :pattern (($FVF.lookup_CASR_m vs x) ($FVF.lookup_CASR_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_CASR_m pm r))
    :pattern ($FVF.perm_CASR_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_CASR_m f r) true)
    :pattern ($FVF.loc_CASR_m f r))))
; /field_value_functions_axioms.smt2 [LFSR_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_LFSR_m vs) ($FVF.domain_LFSR_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_LFSR_m vs))
            (= ($FVF.lookup_LFSR_m vs x) ($FVF.lookup_LFSR_m ws x)))
          :pattern (($FVF.lookup_LFSR_m vs x) ($FVF.lookup_LFSR_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_LFSR_m pm r))
    :pattern ($FVF.perm_LFSR_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_LFSR_m f r) true)
    :pattern ($FVF.loc_LFSR_m f r))))
; /field_value_functions_axioms.smt2 [Combinate_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Combinate_m vs) ($FVF.domain_Combinate_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Combinate_m vs))
            (= ($FVF.lookup_Combinate_m vs x) ($FVF.lookup_Combinate_m ws x)))
          :pattern (($FVF.lookup_Combinate_m vs x) ($FVF.lookup_Combinate_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Combinate_m pm r))
    :pattern ($FVF.perm_Combinate_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Combinate_m f r) true)
    :pattern ($FVF.loc_Combinate_m f r))))
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
; ---------- Rng___contract_unsatisfiable__xor__EncodedGlobalVariables_Integer_Integer_Integer_Integer ----------
(declare-const diz@0@02 $Ref)
(declare-const __globals@1@02 $Ref)
(declare-const __var@2@02 Int)
(declare-const __pos@3@02 Int)
(declare-const __A@4@02 Int)
(declare-const __B@5@02 Int)
(declare-const sys__result@6@02 Int)
(declare-const diz@7@02 $Ref)
(declare-const __globals@8@02 $Ref)
(declare-const __var@9@02 Int)
(declare-const __pos@10@02 Int)
(declare-const __A@11@02 Int)
(declare-const __B@12@02 Int)
(declare-const sys__result@13@02 Int)
(push) ; 1
(declare-const $t@14@02 $Snap)
(assert (= $t@14@02 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@7@02 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.Rng_m, wildcard) && diz.Rng_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.Rng_m, __globals), write) && (true && (true && acc(diz.Rng_m.Main_process_state, write) && |diz.Rng_m.Main_process_state| == 3 && acc(diz.Rng_m.Main_event_state, write) && |diz.Rng_m.Main_event_state| == 6 && (forall i__25: Int :: { diz.Rng_m.Main_process_state[i__25] } 0 <= i__25 && i__25 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__25] == -1 || 0 <= diz.Rng_m.Main_process_state[i__25] && diz.Rng_m.Main_process_state[i__25] < |diz.Rng_m.Main_event_state|)) && acc(diz.Rng_m.Main_rn, wildcard) && diz.Rng_m.Main_rn != null && acc(diz.Rng_m.Main_rn.Rng_clk, write) && acc(diz.Rng_m.Main_rn.Rng_reset, write) && acc(diz.Rng_m.Main_rn.Rng_loadseed_i, write) && acc(diz.Rng_m.Main_rn.Rng_seed_i, write) && acc(diz.Rng_m.Main_rn.Rng_number_o, write) && acc(diz.Rng_m.Main_rn.Rng_LFSR_reg, write) && acc(diz.Rng_m.Main_rn.Rng_CASR_reg, write) && acc(diz.Rng_m.Main_rn.Rng_result, write) && acc(diz.Rng_m.Main_rn.Rng_i, write) && acc(diz.Rng_m.Main_rn.Rng_aux, write) && acc(diz.Rng_m.Main_rn_casr, wildcard) && diz.Rng_m.Main_rn_casr != null && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_var, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_out, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_plus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_minus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_bit_plus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_bit_minus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_i, write) && acc(diz.Rng_m.Main_rn_lfsr, wildcard) && diz.Rng_m.Main_rn_lfsr != null && acc(diz.Rng_m.Main_rn_lfsr.LFSR_LFSR_var, write) && acc(diz.Rng_m.Main_rn_lfsr.LFSR_outbit, write) && acc(diz.Rng_m.Main_rn_combinate, wildcard) && diz.Rng_m.Main_rn_combinate != null && acc(diz.Rng_m.Main_rn_combinate.Combinate_i, write) && acc(diz.Rng_m.Main_rn.Rng_m, wildcard) && diz.Rng_m.Main_rn.Rng_m == diz.Rng_m) && diz.Rng_m.Main_rn == diz)
(declare-const $t@15@02 $Snap)
(assert (= $t@15@02 ($Snap.combine ($Snap.first $t@15@02) ($Snap.second $t@15@02))))
(assert (= ($Snap.first $t@15@02) $Snap.unit))
(assert (=
  ($Snap.second $t@15@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@15@02))
    ($Snap.second ($Snap.second $t@15@02)))))
(declare-const $k@16@02 $Perm)
(assert ($Perm.isReadVar $k@16@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@16@02 $Perm.No) (< $Perm.No $k@16@02))))
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
;  :max-memory            4.11
;  :memory                3.78
;  :mk-bool-var           275
;  :mk-clause             3
;  :num-allocs            3525731
;  :num-checks            2
;  :propagations          23
;  :quant-instantiations  1
;  :rlimit-count          114473)
(assert (<= $Perm.No $k@16@02))
(assert (<= $k@16@02 $Perm.Write))
(assert (implies (< $Perm.No $k@16@02) (not (= diz@7@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@15@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@15@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@15@02))) $Snap.unit))
; [eval] diz.Rng_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.78
;  :mk-bool-var           278
;  :mk-clause             3
;  :num-allocs            3525731
;  :num-checks            3
;  :propagations          23
;  :quant-instantiations  1
;  :rlimit-count          114726)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@15@02))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@15@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.78
;  :mk-bool-var           281
;  :mk-clause             3
;  :num-allocs            3525731
;  :num-checks            4
;  :propagations          23
;  :quant-instantiations  2
;  :rlimit-count          115010)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           286
;  :mk-clause             3
;  :num-allocs            3645037
;  :num-checks            5
;  :propagations          23
;  :quant-instantiations  2
;  :rlimit-count          115450
;  :time                  0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
  $Snap.unit))
; [eval] |diz.Rng_m.Main_process_state| == 3
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           288
;  :mk-clause             3
;  :num-allocs            3645037
;  :num-checks            6
;  :propagations          23
;  :quant-instantiations  2
;  :rlimit-count          115699)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           297
;  :mk-clause             6
;  :num-allocs            3645037
;  :num-checks            7
;  :propagations          24
;  :quant-instantiations  5
;  :rlimit-count          116084)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))
  $Snap.unit))
; [eval] |diz.Rng_m.Main_event_state| == 6
; [eval] |diz.Rng_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           299
;  :mk-clause             6
;  :num-allocs            3645037
;  :num-checks            8
;  :propagations          24
;  :quant-instantiations  5
;  :rlimit-count          116353)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))
  $Snap.unit))
; [eval] (forall i__25: Int :: { diz.Rng_m.Main_process_state[i__25] } 0 <= i__25 && i__25 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__25] == -1 || 0 <= diz.Rng_m.Main_process_state[i__25] && diz.Rng_m.Main_process_state[i__25] < |diz.Rng_m.Main_event_state|)
(declare-const i__25@17@02 Int)
(push) ; 3
; [eval] 0 <= i__25 && i__25 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__25] == -1 || 0 <= diz.Rng_m.Main_process_state[i__25] && diz.Rng_m.Main_process_state[i__25] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= i__25 && i__25 < |diz.Rng_m.Main_process_state|
; [eval] 0 <= i__25
(push) ; 4
; [then-branch: 0 | 0 <= i__25@17@02 | live]
; [else-branch: 0 | !(0 <= i__25@17@02) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i__25@17@02]
(assert (<= 0 i__25@17@02))
; [eval] i__25 < |diz.Rng_m.Main_process_state|
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           310
;  :mk-clause             9
;  :num-allocs            3645037
;  :num-checks            9
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          116845)
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i__25@17@02)]
(assert (not (<= 0 i__25@17@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i__25@17@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))| && 0 <= i__25@17@02 | live]
; [else-branch: 1 | !(i__25@17@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))| && 0 <= i__25@17@02) | live]
(push) ; 5
; [then-branch: 1 | i__25@17@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))| && 0 <= i__25@17@02]
(assert (and
  (<
    i__25@17@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))
  (<= 0 i__25@17@02)))
; [eval] diz.Rng_m.Main_process_state[i__25] == -1 || 0 <= diz.Rng_m.Main_process_state[i__25] && diz.Rng_m.Main_process_state[i__25] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i__25] == -1
; [eval] diz.Rng_m.Main_process_state[i__25]
(push) ; 6
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           312
;  :mk-clause             9
;  :num-allocs            3645037
;  :num-checks            10
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117002)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i__25@17@02 0)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           312
;  :mk-clause             9
;  :num-allocs            3645037
;  :num-checks            11
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117011)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))[i__25@17@02] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))[i__25@17@02] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))[i__25@17@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
    i__25@17@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))[i__25@17@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
      i__25@17@02)
    (- 0 1))))
; [eval] 0 <= diz.Rng_m.Main_process_state[i__25] && diz.Rng_m.Main_process_state[i__25] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= diz.Rng_m.Main_process_state[i__25]
; [eval] diz.Rng_m.Main_process_state[i__25]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           313
;  :mk-clause             9
;  :num-allocs            3645037
;  :num-checks            12
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117261)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i__25@17@02 0)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           313
;  :mk-clause             9
;  :num-allocs            3645037
;  :num-checks            13
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117270)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))[i__25@17@02] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))[i__25@17@02]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))[i__25@17@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
    i__25@17@02)))
; [eval] diz.Rng_m.Main_process_state[i__25] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i__25]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           316
;  :mk-clause             10
;  :num-allocs            3645037
;  :num-checks            14
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117463)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__25@17@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.01s
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           316
;  :mk-clause             10
;  :num-allocs            3645037
;  :num-checks            15
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117472)
; [eval] |diz.Rng_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           316
;  :mk-clause             10
;  :num-allocs            3645037
;  :num-checks            16
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117520)
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))[i__25@17@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
      i__25@17@02))))
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
; [else-branch: 1 | !(i__25@17@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@15@02)))))))| && 0 <= i__25@17@02)]
(assert (not
  (and
    (<
      i__25@17@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))
    (<= 0 i__25@17@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__25@17@02 Int)) (!
  (implies
    (and
      (<
        i__25@17@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))
      (<= 0 i__25@17@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
          i__25@17@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
            i__25@17@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
            i__25@17@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))
    i__25@17@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           318
;  :mk-clause             10
;  :num-allocs            3645037
;  :num-checks            17
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          118235)
(declare-const $k@18@02 $Perm)
(assert ($Perm.isReadVar $k@18@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@18@02 $Perm.No) (< $Perm.No $k@18@02))))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           322
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            18
;  :propagations          26
;  :quant-instantiations  8
;  :rlimit-count          118433)
(assert (<= $Perm.No $k@18@02))
(assert (<= $k@18@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@18@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@15@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           325
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            19
;  :propagations          26
;  :quant-instantiations  8
;  :rlimit-count          118786)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           325
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            20
;  :propagations          26
;  :quant-instantiations  8
;  :rlimit-count          118834)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           328
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            21
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119220)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           328
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            22
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119268)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           329
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            23
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119555)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           329
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            24
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119603)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           330
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            25
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119900)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           330
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            26
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119948)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           331
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            27
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          120255)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           331
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            28
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          120303)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           332
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            29
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          120620)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
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
;  :conflicts             26
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           332
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            30
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          120668)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           333
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            31
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          120995)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           333
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            32
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          121043)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           334
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            33
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          121380)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           334
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            34
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          121428)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           335
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            35
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          121775)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           335
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            36
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          121823)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           336
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            37
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          122180)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           336
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            38
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          122228)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           337
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            39
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          122595)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
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
;  :max-memory            4.11
;  :memory                3.88
;  :mk-bool-var           337
;  :mk-clause             12
;  :num-allocs            3645037
;  :num-checks            40
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          122643)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             142
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :binary-propagations   22
;  :conflicts             37
;  :datatype-accessor-ax  25
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           338
;  :mk-clause             12
;  :num-allocs            3770066
;  :num-checks            41
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          123020)
(declare-const $k@19@02 $Perm)
(assert ($Perm.isReadVar $k@19@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@19@02 $Perm.No) (< $Perm.No $k@19@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             142
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    9
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             38
;  :datatype-accessor-ax  25
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           342
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            42
;  :propagations          27
;  :quant-instantiations  9
;  :rlimit-count          123219)
(assert (<= $Perm.No $k@19@02))
(assert (<= $k@19@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@19@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@15@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_casr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             148
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             39
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           345
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            43
;  :propagations          27
;  :quant-instantiations  9
;  :rlimit-count          123692)
(push) ; 3
(assert (not (< $Perm.No $k@19@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             148
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             40
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           345
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            44
;  :propagations          27
;  :quant-instantiations  9
;  :rlimit-count          123740)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             154
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             41
;  :datatype-accessor-ax  27
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           348
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            45
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          124264)
(push) ; 3
(assert (not (< $Perm.No $k@19@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             154
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             42
;  :datatype-accessor-ax  27
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           348
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            46
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          124312)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             159
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             43
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           349
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            47
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          124719)
(push) ; 3
(assert (not (< $Perm.No $k@19@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             159
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             44
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           349
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            48
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          124767)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             164
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             45
;  :datatype-accessor-ax  29
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           350
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            49
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          125184)
(push) ; 3
(assert (not (< $Perm.No $k@19@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             164
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             46
;  :datatype-accessor-ax  29
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           350
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            50
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          125232)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             169
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             47
;  :datatype-accessor-ax  30
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           351
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            51
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          125659)
(push) ; 3
(assert (not (< $Perm.No $k@19@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             169
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             48
;  :datatype-accessor-ax  30
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           351
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            52
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          125707)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             174
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             49
;  :datatype-accessor-ax  31
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           352
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            53
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          126144)
(push) ; 3
(assert (not (< $Perm.No $k@19@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             174
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             50
;  :datatype-accessor-ax  31
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           352
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            54
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          126192)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             179
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             51
;  :datatype-accessor-ax  32
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           353
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            55
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          126639)
(push) ; 3
(assert (not (< $Perm.No $k@19@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             179
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             52
;  :datatype-accessor-ax  32
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           353
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            56
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          126687)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             184
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             53
;  :datatype-accessor-ax  33
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           354
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            57
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          127144)
(push) ; 3
(assert (not (< $Perm.No $k@19@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             184
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             54
;  :datatype-accessor-ax  33
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           354
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            58
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          127192)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             189
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :binary-propagations   22
;  :conflicts             55
;  :datatype-accessor-ax  34
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           355
;  :mk-clause             14
;  :num-allocs            3770066
;  :num-checks            59
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          127659)
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
; (:added-eqs             189
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    11
;  :arith-eq-adapter      10
;  :binary-propagations   22
;  :conflicts             56
;  :datatype-accessor-ax  34
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           359
;  :mk-clause             16
;  :num-allocs            3770066
;  :num-checks            60
;  :propagations          28
;  :quant-instantiations  10
;  :rlimit-count          127858)
(assert (<= $Perm.No $k@20@02))
(assert (<= $k@20@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@20@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@15@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_lfsr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             195
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :binary-propagations   22
;  :conflicts             57
;  :datatype-accessor-ax  35
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           362
;  :mk-clause             16
;  :num-allocs            3770066
;  :num-checks            61
;  :propagations          28
;  :quant-instantiations  10
;  :rlimit-count          128421)
(push) ; 3
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             195
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :binary-propagations   22
;  :conflicts             58
;  :datatype-accessor-ax  35
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           362
;  :mk-clause             16
;  :num-allocs            3770066
;  :num-checks            62
;  :propagations          28
;  :quant-instantiations  10
;  :rlimit-count          128469)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             201
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :binary-propagations   22
;  :conflicts             59
;  :datatype-accessor-ax  36
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           365
;  :mk-clause             16
;  :num-allocs            3770066
;  :num-checks            63
;  :propagations          28
;  :quant-instantiations  11
;  :rlimit-count          129077)
(push) ; 3
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             201
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :binary-propagations   22
;  :conflicts             60
;  :datatype-accessor-ax  36
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           365
;  :mk-clause             16
;  :num-allocs            3770066
;  :num-checks            64
;  :propagations          28
;  :quant-instantiations  11
;  :rlimit-count          129125)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             206
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :binary-propagations   22
;  :conflicts             61
;  :datatype-accessor-ax  37
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           366
;  :mk-clause             16
;  :num-allocs            3770066
;  :num-checks            65
;  :propagations          28
;  :quant-instantiations  11
;  :rlimit-count          129622)
(push) ; 3
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             206
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :binary-propagations   22
;  :conflicts             62
;  :datatype-accessor-ax  37
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           366
;  :mk-clause             16
;  :num-allocs            3770066
;  :num-checks            66
;  :propagations          28
;  :quant-instantiations  11
;  :rlimit-count          129670)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             211
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :binary-propagations   22
;  :conflicts             63
;  :datatype-accessor-ax  38
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           367
;  :mk-clause             16
;  :num-allocs            3770066
;  :num-checks            67
;  :propagations          28
;  :quant-instantiations  11
;  :rlimit-count          130177)
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
; (:added-eqs             211
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    13
;  :arith-eq-adapter      11
;  :binary-propagations   22
;  :conflicts             64
;  :datatype-accessor-ax  38
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           371
;  :mk-clause             18
;  :num-allocs            3770066
;  :num-checks            68
;  :propagations          29
;  :quant-instantiations  11
;  :rlimit-count          130375)
(assert (<= $Perm.No $k@21@02))
(assert (<= $k@21@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@21@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@15@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_combinate != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             217
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :binary-propagations   22
;  :conflicts             65
;  :datatype-accessor-ax  39
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           374
;  :mk-clause             18
;  :num-allocs            3770066
;  :num-checks            69
;  :propagations          29
;  :quant-instantiations  11
;  :rlimit-count          130978)
(push) ; 3
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             217
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :binary-propagations   22
;  :conflicts             66
;  :datatype-accessor-ax  39
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           374
;  :mk-clause             18
;  :num-allocs            3770066
;  :num-checks            70
;  :propagations          29
;  :quant-instantiations  11
;  :rlimit-count          131026)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             223
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :binary-propagations   22
;  :conflicts             67
;  :datatype-accessor-ax  40
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           377
;  :mk-clause             18
;  :num-allocs            3770066
;  :num-checks            71
;  :propagations          29
;  :quant-instantiations  12
;  :rlimit-count          131664)
(push) ; 3
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             223
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :binary-propagations   22
;  :conflicts             68
;  :datatype-accessor-ax  40
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           377
;  :mk-clause             18
;  :num-allocs            3770066
;  :num-checks            72
;  :propagations          29
;  :quant-instantiations  12
;  :rlimit-count          131712)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             228
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :binary-propagations   22
;  :conflicts             69
;  :datatype-accessor-ax  41
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           378
;  :mk-clause             18
;  :num-allocs            3770066
;  :num-checks            73
;  :propagations          29
;  :quant-instantiations  12
;  :rlimit-count          132249)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             228
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :binary-propagations   22
;  :conflicts             70
;  :datatype-accessor-ax  41
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           378
;  :mk-clause             18
;  :num-allocs            3770066
;  :num-checks            74
;  :propagations          29
;  :quant-instantiations  12
;  :rlimit-count          132297)
(declare-const $k@22@02 $Perm)
(assert ($Perm.isReadVar $k@22@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@22@02 $Perm.No) (< $Perm.No $k@22@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             228
;  :arith-assert-diseq    9
;  :arith-assert-lower    24
;  :arith-assert-upper    15
;  :arith-eq-adapter      12
;  :binary-propagations   22
;  :conflicts             71
;  :datatype-accessor-ax  41
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.11
;  :memory                3.98
;  :mk-bool-var           382
;  :mk-clause             20
;  :num-allocs            3770066
;  :num-checks            75
;  :propagations          30
;  :quant-instantiations  12
;  :rlimit-count          132496)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@7@02
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               308
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      15
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               72
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   7
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             416
;  :mk-clause               21
;  :num-allocs              3900946
;  :num-checks              76
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            133469)
(assert (<= $Perm.No $k@22@02))
(assert (<= $k@22@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@22@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn.Rng_m == diz.Rng_m
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               314
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               73
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   7
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             419
;  :mk-clause               21
;  :num-allocs              3900946
;  :num-checks              77
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            134102)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               314
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               74
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   7
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             419
;  :mk-clause               21
;  :num-allocs              3900946
;  :num-checks              78
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            134150)
(push) ; 3
(assert (not (< $Perm.No $k@22@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               314
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               75
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   7
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             419
;  :mk-clause               21
;  :num-allocs              3900946
;  :num-checks              79
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            134198)
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               314
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               76
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   7
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             419
;  :mk-clause               21
;  :num-allocs              3900946
;  :num-checks              80
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            134246)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@15@02)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn == diz
(push) ; 3
(assert (not (< $Perm.No $k@16@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               318
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               77
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   7
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             422
;  :mk-clause               21
;  :num-allocs              3900946
;  :num-checks              81
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            134859)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               318
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               78
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   7
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             422
;  :mk-clause               21
;  :num-allocs              3900946
;  :num-checks              82
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            134907)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))
  diz@7@02))
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
  diz@7@02
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02))))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               540
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               79
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 124
;  :datatype-occurs-check   21
;  :datatype-splits         66
;  :decisions               120
;  :del-clause              20
;  :final-checks            11
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             460
;  :mk-clause               22
;  :num-allocs              3900946
;  :num-checks              86
;  :propagations            32
;  :quant-instantiations    13
;  :rlimit-count            137302)
(declare-const $t@23@02 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@16@02)
    (=
      $t@23@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@15@02)))))
  (implies
    (< $Perm.No $k@22@02)
    (=
      $t@23@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@02)))))))))))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@16@02 $k@22@02)))
(assert (<= (+ $k@16@02 $k@22@02) $Perm.Write))
(assert (implies (< $Perm.No (+ $k@16@02 $k@22@02)) (not (= diz@7@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Combinate_Combinate_EncodedGlobalVariables_Main ----------
(declare-const __globals@24@02 $Ref)
(declare-const __m_param@25@02 $Ref)
(declare-const sys__result@26@02 $Ref)
(declare-const __globals@27@02 $Ref)
(declare-const __m_param@28@02 $Ref)
(declare-const sys__result@29@02 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@30@02 $Snap)
(assert (= $t@30@02 ($Snap.combine ($Snap.first $t@30@02) ($Snap.second $t@30@02))))
(assert (= ($Snap.first $t@30@02) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@29@02 $Ref.null)))
(assert (=
  ($Snap.second $t@30@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@30@02))
    ($Snap.second ($Snap.second $t@30@02)))))
(assert (= ($Snap.first ($Snap.second $t@30@02)) $Snap.unit))
; [eval] type_of(sys__result) == class_Combinate()
; [eval] type_of(sys__result)
; [eval] class_Combinate()
(assert (= (type_of<TYPE> sys__result@29@02) (as class_Combinate<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@30@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@30@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@30@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@30@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@30@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@02))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@02)))))
  $Snap.unit))
; [eval] sys__result.Combinate_m == __m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@30@02)))))
  __m_param@28@02))
(pop) ; 2
(push) ; 2
; [exec]
; var m_param__175: Ref
(declare-const m_param__175@31@02 $Ref)
; [exec]
; var globals__174: Ref
(declare-const globals__174@32@02 $Ref)
; [exec]
; var diz__173: Ref
(declare-const diz__173@33@02 $Ref)
; [exec]
; diz__173 := new(Combinate_m, Combinate_i)
(declare-const diz__173@34@02 $Ref)
(assert (not (= diz__173@34@02 $Ref.null)))
(declare-const Combinate_m@35@02 $Ref)
(declare-const Combinate_i@36@02 Int)
(assert (not (= diz__173@34@02 sys__result@29@02)))
(assert (not (= diz__173@34@02 diz__173@33@02)))
(assert (not (= diz__173@34@02 __m_param@28@02)))
(assert (not (= diz__173@34@02 __globals@27@02)))
(assert (not (= diz__173@34@02 m_param__175@31@02)))
(assert (not (= diz__173@34@02 globals__174@32@02)))
; [exec]
; inhale type_of(diz__173) == class_Combinate()
(declare-const $t@37@02 $Snap)
(assert (= $t@37@02 $Snap.unit))
; [eval] type_of(diz__173) == class_Combinate()
; [eval] type_of(diz__173)
; [eval] class_Combinate()
(assert (= (type_of<TYPE> diz__173@34@02) (as class_Combinate<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; globals__174 := __globals
; [exec]
; m_param__175 := __m_param
; [exec]
; diz__173.Combinate_m := m_param__175
; [exec]
; inhale acc(Combinate_idleToken_EncodedGlobalVariables(diz__173, globals__174), write)
(declare-const $t@38@02 $Snap)
; State saturation: after inhale
(check-sat)
; unknown
; [exec]
; sys__result := diz__173
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Combinate() && acc(Combinate_idleToken_EncodedGlobalVariables(sys__result, __globals), write) && acc(sys__result.Combinate_m, write) && acc(sys__result.Combinate_i, write) && sys__result.Combinate_m == __m_param
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Combinate()
; [eval] type_of(sys__result)
; [eval] class_Combinate()
; [eval] sys__result.Combinate_m == __m_param
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Combinate___contract_unsatisfiable__run_EncodedGlobalVariables ----------
(declare-const diz@39@02 $Ref)
(declare-const __globals@40@02 $Ref)
(declare-const diz@41@02 $Ref)
(declare-const __globals@42@02 $Ref)
(push) ; 1
(declare-const $t@43@02 $Snap)
(assert (= $t@43@02 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@41@02 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.Combinate_m, wildcard) && diz.Combinate_m != null && acc(diz.Combinate_m.Main_rn_combinate, wildcard) && diz.Combinate_m.Main_rn_combinate == diz)
(declare-const $t@44@02 $Snap)
(assert (= $t@44@02 ($Snap.combine ($Snap.first $t@44@02) ($Snap.second $t@44@02))))
(assert (= ($Snap.first $t@44@02) $Snap.unit))
(assert (=
  ($Snap.second $t@44@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@44@02))
    ($Snap.second ($Snap.second $t@44@02)))))
(declare-const $k@45@02 $Perm)
(assert ($Perm.isReadVar $k@45@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@45@02 $Perm.No) (< $Perm.No $k@45@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               627
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      18
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               80
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   28
;  :datatype-splits         68
;  :decisions               149
;  :del-clause              21
;  :final-checks            17
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             484
;  :mk-clause               24
;  :num-allocs              3900946
;  :num-checks              92
;  :propagations            34
;  :quant-instantiations    13
;  :rlimit-count            140369)
(assert (<= $Perm.No $k@45@02))
(assert (<= $k@45@02 $Perm.Write))
(assert (implies (< $Perm.No $k@45@02) (not (= diz@41@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@44@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@44@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@44@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@44@02))) $Snap.unit))
; [eval] diz.Combinate_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@45@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               633
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      19
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               81
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   28
;  :datatype-splits         68
;  :decisions               149
;  :del-clause              21
;  :final-checks            17
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             487
;  :mk-clause               24
;  :num-allocs              3900946
;  :num-checks              93
;  :propagations            34
;  :quant-instantiations    13
;  :rlimit-count            140622)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@44@02))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@44@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@44@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02)))))))
(push) ; 3
(assert (not (< $Perm.No $k@45@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               639
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      19
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               82
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   28
;  :datatype-splits         68
;  :decisions               149
;  :del-clause              21
;  :final-checks            17
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             490
;  :mk-clause               24
;  :num-allocs              3900946
;  :num-checks              94
;  :propagations            34
;  :quant-instantiations    14
;  :rlimit-count            140906)
(declare-const $k@46@02 $Perm)
(assert ($Perm.isReadVar $k@46@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@46@02 $Perm.No) (< $Perm.No $k@46@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               639
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      20
;  :arith-eq-adapter        14
;  :binary-propagations     22
;  :conflicts               83
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   28
;  :datatype-splits         68
;  :decisions               149
;  :del-clause              21
;  :final-checks            17
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             494
;  :mk-clause               26
;  :num-allocs              3900946
;  :num-checks              95
;  :propagations            35
;  :quant-instantiations    14
;  :rlimit-count            141105)
(assert (<= $Perm.No $k@46@02))
(assert (<= $k@46@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@46@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@44@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@02))))
  $Snap.unit))
; [eval] diz.Combinate_m.Main_rn_combinate == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@45@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               640
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-eq-adapter        14
;  :binary-propagations     22
;  :conflicts               84
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   28
;  :datatype-splits         68
;  :decisions               149
;  :del-clause              21
;  :final-checks            17
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             496
;  :mk-clause               26
;  :num-allocs              3900946
;  :num-checks              96
;  :propagations            35
;  :quant-instantiations    14
;  :rlimit-count            141291)
(push) ; 3
(assert (not (< $Perm.No $k@46@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               640
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-eq-adapter        14
;  :binary-propagations     22
;  :conflicts               85
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   28
;  :datatype-splits         68
;  :decisions               149
;  :del-clause              21
;  :final-checks            17
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             496
;  :mk-clause               26
;  :num-allocs              3900946
;  :num-checks              97
;  :propagations            35
;  :quant-instantiations    14
;  :rlimit-count            141339)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@44@02)))))
  diz@41@02))
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
(declare-const diz@47@02 $Ref)
(declare-const __globals@48@02 $Ref)
(declare-const diz@49@02 $Ref)
(declare-const __globals@50@02 $Ref)
(push) ; 1
(declare-const $t@51@02 $Snap)
(assert (= $t@51@02 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@49@02 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@52@02 $Snap)
(assert (= $t@52@02 ($Snap.combine ($Snap.first $t@52@02) ($Snap.second $t@52@02))))
(assert (= ($Snap.first $t@52@02) $Snap.unit))
(assert (= ($Snap.second $t@52@02) $Snap.unit))
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
; ---------- Main_main_EncodedGlobalVariables ----------
(declare-const diz@53@02 $Ref)
(declare-const __globals@54@02 $Ref)
(declare-const diz@55@02 $Ref)
(declare-const __globals@56@02 $Ref)
(push) ; 1
(declare-const $t@57@02 $Snap)
(assert (= $t@57@02 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@55@02 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; var min_advance__225: Int
(declare-const min_advance__225@58@02 Int)
; [exec]
; var globals__222: Ref
(declare-const globals__222@59@02 $Ref)
; [exec]
; var __flatten_184__223: Seq[Int]
(declare-const __flatten_184__223@60@02 Seq<Int>)
; [exec]
; var __flatten_185__224: Seq[Int]
(declare-const __flatten_185__224@61@02 Seq<Int>)
; [exec]
; globals__222 := __globals
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals__222), write)
(declare-const $t@62@02 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals__222), write)
(assert (= $t@62@02 ($Snap.combine ($Snap.first $t@62@02) ($Snap.second $t@62@02))))
(assert (= ($Snap.first $t@62@02) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@62@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@62@02))
    ($Snap.second ($Snap.second $t@62@02)))))
(assert (= ($Snap.first ($Snap.second $t@62@02)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@62@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@62@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@62@02))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@62@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@63@02 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@63@02 | live]
; [else-branch: 4 | !(0 <= i@63@02) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@63@02]
(assert (<= 0 i@63@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@63@02)]
(assert (not (<= 0 i@63@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@63@02 < |First:(Second:(Second:(Second:($t@62@02))))| && 0 <= i@63@02 | live]
; [else-branch: 5 | !(i@63@02 < |First:(Second:(Second:(Second:($t@62@02))))| && 0 <= i@63@02) | live]
(push) ; 5
; [then-branch: 5 | i@63@02 < |First:(Second:(Second:(Second:($t@62@02))))| && 0 <= i@63@02]
(assert (and
  (<
    i@63@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))
  (<= 0 i@63@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@63@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               725
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      24
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               85
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              25
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             539
;  :mk-clause               32
;  :num-allocs              3900946
;  :num-checks              109
;  :propagations            37
;  :quant-instantiations    21
;  :rlimit-count            146228)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:($t@62@02))))[i@63@02] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@62@02))))[i@63@02] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@62@02))))[i@63@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))
    i@63@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:($t@62@02))))[i@63@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))
      i@63@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@63@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               725
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      24
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               85
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              25
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             540
;  :mk-clause               32
;  :num-allocs              3900946
;  :num-checks              110
;  :propagations            37
;  :quant-instantiations    21
;  :rlimit-count            146403)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@62@02))))[i@63@02] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@62@02))))[i@63@02]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@62@02))))[i@63@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))
    i@63@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@63@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               725
;  :arith-assert-diseq      14
;  :arith-assert-lower      39
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :binary-propagations     22
;  :conflicts               85
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              25
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             543
;  :mk-clause               33
;  :num-allocs              3900946
;  :num-checks              111
;  :propagations            37
;  :quant-instantiations    21
;  :rlimit-count            146527)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@62@02))))[i@63@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))
      i@63@02))))
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
; [else-branch: 5 | !(i@63@02 < |First:(Second:(Second:(Second:($t@62@02))))| && 0 <= i@63@02)]
(assert (not
  (and
    (<
      i@63@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))
    (<= 0 i@63@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@63@02 Int)) (!
  (implies
    (and
      (<
        i@63@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))
      (<= 0 i@63@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))
          i@63@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))
            i@63@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))
            i@63@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))
    i@63@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))
(declare-const $k@64@02 $Perm)
(assert ($Perm.isReadVar $k@64@02 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@64@02 $Perm.No) (< $Perm.No $k@64@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               730
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      25
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               86
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             549
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              112
;  :propagations            38
;  :quant-instantiations    21
;  :rlimit-count            147295)
(assert (<= $Perm.No $k@64@02))
(assert (<= $k@64@02 $Perm.Write))
(assert (implies (< $Perm.No $k@64@02) (not (= diz@55@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))
  $Snap.unit))
; [eval] diz.Main_rn != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               736
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               87
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             552
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              113
;  :propagations            38
;  :quant-instantiations    21
;  :rlimit-count            147618)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               742
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               88
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             555
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              114
;  :propagations            38
;  :quant-instantiations    22
;  :rlimit-count            147974)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               747
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               89
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             556
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              115
;  :propagations            38
;  :quant-instantiations    22
;  :rlimit-count            148231)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               752
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               90
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             557
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              116
;  :propagations            38
;  :quant-instantiations    22
;  :rlimit-count            148498)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               757
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               91
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             558
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              117
;  :propagations            38
;  :quant-instantiations    22
;  :rlimit-count            148775)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               92
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             559
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              118
;  :propagations            38
;  :quant-instantiations    22
;  :rlimit-count            149062)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               767
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               93
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             560
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              119
;  :propagations            38
;  :quant-instantiations    22
;  :rlimit-count            149359)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               772
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               94
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             561
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              120
;  :propagations            38
;  :quant-instantiations    22
;  :rlimit-count            149666)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               777
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               95
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             562
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              121
;  :propagations            38
;  :quant-instantiations    22
;  :rlimit-count            149983)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               782
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               96
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             563
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              122
;  :propagations            38
;  :quant-instantiations    22
;  :rlimit-count            150310)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               787
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               97
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             564
;  :mk-clause               35
;  :num-allocs              3900946
;  :num-checks              123
;  :propagations            38
;  :quant-instantiations    22
;  :rlimit-count            150647)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))
(declare-const $k@65@02 $Perm)
(assert ($Perm.isReadVar $k@65@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@65@02 $Perm.No) (< $Perm.No $k@65@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               792
;  :arith-assert-diseq      16
;  :arith-assert-lower      43
;  :arith-assert-upper      27
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               98
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             569
;  :mk-clause               37
;  :num-allocs              3900946
;  :num-checks              124
;  :propagations            39
;  :quant-instantiations    22
;  :rlimit-count            151138)
(assert (<= $Perm.No $k@65@02))
(assert (<= $k@65@02 $Perm.Write))
(assert (implies (< $Perm.No $k@65@02) (not (= diz@55@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_rn_casr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@65@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               798
;  :arith-assert-diseq      16
;  :arith-assert-lower      43
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               99
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             572
;  :mk-clause               37
;  :num-allocs              3900946
;  :num-checks              125
;  :propagations            39
;  :quant-instantiations    22
;  :rlimit-count            151581)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@65@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               804
;  :arith-assert-diseq      16
;  :arith-assert-lower      43
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               100
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             575
;  :mk-clause               37
;  :num-allocs              3900946
;  :num-checks              126
;  :propagations            39
;  :quant-instantiations    23
;  :rlimit-count            152075)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@65@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               809
;  :arith-assert-diseq      16
;  :arith-assert-lower      43
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               101
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             576
;  :mk-clause               37
;  :num-allocs              3900946
;  :num-checks              127
;  :propagations            39
;  :quant-instantiations    23
;  :rlimit-count            152452)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@65@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               814
;  :arith-assert-diseq      16
;  :arith-assert-lower      43
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             577
;  :mk-clause               37
;  :num-allocs              3900946
;  :num-checks              128
;  :propagations            39
;  :quant-instantiations    23
;  :rlimit-count            152839)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@65@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               819
;  :arith-assert-diseq      16
;  :arith-assert-lower      43
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               103
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             578
;  :mk-clause               37
;  :num-allocs              3900946
;  :num-checks              129
;  :propagations            39
;  :quant-instantiations    23
;  :rlimit-count            153236)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@65@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               824
;  :arith-assert-diseq      16
;  :arith-assert-lower      43
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               104
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             579
;  :mk-clause               37
;  :num-allocs              3900946
;  :num-checks              130
;  :propagations            39
;  :quant-instantiations    23
;  :rlimit-count            153643)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@65@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               829
;  :arith-assert-diseq      16
;  :arith-assert-lower      43
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               105
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             580
;  :mk-clause               37
;  :num-allocs              3900946
;  :num-checks              131
;  :propagations            39
;  :quant-instantiations    23
;  :rlimit-count            154060)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@65@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               834
;  :arith-assert-diseq      16
;  :arith-assert-lower      43
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               106
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             581
;  :mk-clause               37
;  :num-allocs              3900946
;  :num-checks              132
;  :propagations            39
;  :quant-instantiations    23
;  :rlimit-count            154487)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))
(declare-const $k@66@02 $Perm)
(assert ($Perm.isReadVar $k@66@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@66@02 $Perm.No) (< $Perm.No $k@66@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               839
;  :arith-assert-diseq      17
;  :arith-assert-lower      45
;  :arith-assert-upper      29
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               107
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             586
;  :mk-clause               39
;  :num-allocs              3900946
;  :num-checks              133
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            155068)
(assert (<= $Perm.No $k@66@02))
(assert (<= $k@66@02 $Perm.Write))
(assert (implies (< $Perm.No $k@66@02) (not (= diz@55@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_rn_lfsr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@66@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               845
;  :arith-assert-diseq      17
;  :arith-assert-lower      45
;  :arith-assert-upper      30
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               108
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             589
;  :mk-clause               39
;  :num-allocs              3900946
;  :num-checks              134
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            155601)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@66@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               851
;  :arith-assert-diseq      17
;  :arith-assert-lower      45
;  :arith-assert-upper      30
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               109
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             592
;  :mk-clause               39
;  :num-allocs              3900946
;  :num-checks              135
;  :propagations            40
;  :quant-instantiations    24
;  :rlimit-count            156179)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@66@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               856
;  :arith-assert-diseq      17
;  :arith-assert-lower      45
;  :arith-assert-upper      30
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               110
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             593
;  :mk-clause               39
;  :num-allocs              3900946
;  :num-checks              136
;  :propagations            40
;  :quant-instantiations    24
;  :rlimit-count            156646)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))))))
(declare-const $k@67@02 $Perm)
(assert ($Perm.isReadVar $k@67@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@67@02 $Perm.No) (< $Perm.No $k@67@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               861
;  :arith-assert-diseq      18
;  :arith-assert-lower      47
;  :arith-assert-upper      31
;  :arith-eq-adapter        23
;  :binary-propagations     22
;  :conflicts               111
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             598
;  :mk-clause               41
;  :num-allocs              3900946
;  :num-checks              137
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            157267)
(assert (<= $Perm.No $k@67@02))
(assert (<= $k@67@02 $Perm.Write))
(assert (implies (< $Perm.No $k@67@02) (not (= diz@55@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_rn_combinate != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@67@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               867
;  :arith-assert-diseq      18
;  :arith-assert-lower      47
;  :arith-assert-upper      32
;  :arith-eq-adapter        23
;  :binary-propagations     22
;  :conflicts               112
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             601
;  :mk-clause               41
;  :num-allocs              3900946
;  :num-checks              138
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            157840)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@67@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               873
;  :arith-assert-diseq      18
;  :arith-assert-lower      47
;  :arith-assert-upper      32
;  :arith-eq-adapter        23
;  :binary-propagations     22
;  :conflicts               113
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             604
;  :mk-clause               41
;  :num-allocs              3900946
;  :num-checks              139
;  :propagations            41
;  :quant-instantiations    25
;  :rlimit-count            158448)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               878
;  :arith-assert-diseq      18
;  :arith-assert-lower      47
;  :arith-assert-upper      32
;  :arith-eq-adapter        23
;  :binary-propagations     22
;  :conflicts               114
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             605
;  :mk-clause               41
;  :num-allocs              3900946
;  :num-checks              140
;  :propagations            41
;  :quant-instantiations    25
;  :rlimit-count            158955)
(declare-const $k@68@02 $Perm)
(assert ($Perm.isReadVar $k@68@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@68@02 $Perm.No) (< $Perm.No $k@68@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               878
;  :arith-assert-diseq      19
;  :arith-assert-lower      49
;  :arith-assert-upper      33
;  :arith-eq-adapter        24
;  :binary-propagations     22
;  :conflicts               115
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             609
;  :mk-clause               43
;  :num-allocs              3900946
;  :num-checks              141
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            159154)
(assert (<= $Perm.No $k@68@02))
(assert (<= $k@68@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@68@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02)))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_rn.Rng_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@64@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               879
;  :arith-assert-diseq      19
;  :arith-assert-lower      49
;  :arith-assert-upper      34
;  :arith-eq-adapter        24
;  :binary-propagations     22
;  :conflicts               116
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             611
;  :mk-clause               43
;  :num-allocs              3900946
;  :num-checks              142
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            159670)
(push) ; 3
(assert (not (< $Perm.No $k@68@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               879
;  :arith-assert-diseq      19
;  :arith-assert-lower      49
;  :arith-assert-upper      34
;  :arith-eq-adapter        24
;  :binary-propagations     22
;  :conflicts               117
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 162
;  :datatype-occurs-check   49
;  :datatype-splits         70
;  :decisions               157
;  :del-clause              26
;  :final-checks            29
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             611
;  :mk-clause               43
;  :num-allocs              3900946
;  :num-checks              143
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            159718)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@02))))))))))))))))))))))))))))))))))))))
  diz@55@02))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@62@02 diz@55@02 __globals@56@02))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals__222), write)
(declare-const $t@69@02 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; CASR_forkOperator_EncodedGlobalVariables(diz.Main_rn_casr, globals__222)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@65@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1025
;  :arith-assert-diseq      19
;  :arith-assert-lower      49
;  :arith-assert-upper      34
;  :arith-eq-adapter        24
;  :binary-propagations     22
;  :conflicts               119
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 221
;  :datatype-occurs-check   59
;  :datatype-splits         101
;  :decisions               214
;  :del-clause              42
;  :final-checks            34
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             647
;  :mk-clause               44
;  :num-allocs              3900946
;  :num-checks              146
;  :propagations            43
;  :quant-instantiations    26
;  :rlimit-count            161709)
; [eval] diz != null
(declare-const $k@70@02 $Perm)
(assert ($Perm.isReadVar $k@70@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@70@02 $Perm.No) (< $Perm.No $k@70@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1025
;  :arith-assert-diseq      20
;  :arith-assert-lower      51
;  :arith-assert-upper      35
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               120
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 221
;  :datatype-occurs-check   59
;  :datatype-splits         101
;  :decisions               214
;  :del-clause              42
;  :final-checks            34
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             651
;  :mk-clause               46
;  :num-allocs              3900946
;  :num-checks              147
;  :propagations            44
;  :quant-instantiations    26
;  :rlimit-count            161908)
(set-option :timeout 10)
(check-sat)
; unknown
; [state consolidation]
; State saturation: before repetition
(check-sat)
; unknown
(check-sat)
; unknown
; [state consolidation]
; State saturation: before repetition
(check-sat)
; unknown
(declare-const $k@71@02 $Perm)
(assert ($Perm.isReadVar $k@71@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@71@02 $Perm.No) (< $Perm.No $k@71@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1305
;  :arith-assert-diseq      21
;  :arith-assert-lower      53
;  :arith-assert-upper      36
;  :arith-eq-adapter        26
;  :binary-propagations     22
;  :conflicts               121
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 337
;  :datatype-occurs-check   75
;  :datatype-splits         109
;  :decisions               326
;  :del-clause              44
;  :final-checks            42
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             667
;  :mk-clause               48
;  :num-allocs              3900946
;  :num-checks              152
;  :propagations            49
;  :quant-instantiations    26
;  :rlimit-count            164938)
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
; ---------- Main_reset_events_no_delta_EncodedGlobalVariables ----------
(declare-const diz@72@02 $Ref)
(declare-const globals@73@02 $Ref)
(declare-const diz@74@02 $Ref)
(declare-const globals@75@02 $Ref)
(push) ; 1
(declare-const $t@76@02 $Snap)
(assert (= $t@76@02 ($Snap.combine ($Snap.first $t@76@02) ($Snap.second $t@76@02))))
(assert (= ($Snap.first $t@76@02) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@74@02 $Ref.null)))
(assert (=
  ($Snap.second $t@76@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@76@02))
    ($Snap.second ($Snap.second $t@76@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@76@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@76@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@76@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@76@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@76@02))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02)))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02)))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@77@02 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 8 | 0 <= i@77@02 | live]
; [else-branch: 8 | !(0 <= i@77@02) | live]
(push) ; 4
; [then-branch: 8 | 0 <= i@77@02]
(assert (<= 0 i@77@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 8 | !(0 <= i@77@02)]
(assert (not (<= 0 i@77@02)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 9 | i@77@02 < |First:(Second:(Second:($t@76@02)))| && 0 <= i@77@02 | live]
; [else-branch: 9 | !(i@77@02 < |First:(Second:(Second:($t@76@02)))| && 0 <= i@77@02) | live]
(push) ; 4
; [then-branch: 9 | i@77@02 < |First:(Second:(Second:($t@76@02)))| && 0 <= i@77@02]
(assert (and
  (<
    i@77@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))))
  (<= 0 i@77@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@77@02 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1553
;  :arith-assert-diseq      23
;  :arith-assert-lower      60
;  :arith-assert-upper      39
;  :arith-eq-adapter        30
;  :binary-propagations     22
;  :conflicts               121
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 424
;  :datatype-occurs-check   87
;  :datatype-splits         115
;  :decisions               410
;  :del-clause              47
;  :final-checks            48
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             705
;  :mk-clause               54
;  :num-allocs              3900946
;  :num-checks              156
;  :propagations            54
;  :quant-instantiations    32
;  :rlimit-count            168232)
; [eval] -1
(push) ; 5
; [then-branch: 10 | First:(Second:(Second:($t@76@02)))[i@77@02] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:($t@76@02)))[i@77@02] != -1 | live]
(push) ; 6
; [then-branch: 10 | First:(Second:(Second:($t@76@02)))[i@77@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))
    i@77@02)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 10 | First:(Second:(Second:($t@76@02)))[i@77@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))
      i@77@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@77@02 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1553
;  :arith-assert-diseq      23
;  :arith-assert-lower      60
;  :arith-assert-upper      39
;  :arith-eq-adapter        30
;  :binary-propagations     22
;  :conflicts               121
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 424
;  :datatype-occurs-check   87
;  :datatype-splits         115
;  :decisions               410
;  :del-clause              47
;  :final-checks            48
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             706
;  :mk-clause               54
;  :num-allocs              3900946
;  :num-checks              157
;  :propagations            54
;  :quant-instantiations    32
;  :rlimit-count            168395)
(push) ; 7
; [then-branch: 11 | 0 <= First:(Second:(Second:($t@76@02)))[i@77@02] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:($t@76@02)))[i@77@02]) | live]
(push) ; 8
; [then-branch: 11 | 0 <= First:(Second:(Second:($t@76@02)))[i@77@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))
    i@77@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@77@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1553
;  :arith-assert-diseq      24
;  :arith-assert-lower      63
;  :arith-assert-upper      39
;  :arith-eq-adapter        31
;  :binary-propagations     22
;  :conflicts               121
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 424
;  :datatype-occurs-check   87
;  :datatype-splits         115
;  :decisions               410
;  :del-clause              47
;  :final-checks            48
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             709
;  :mk-clause               55
;  :num-allocs              3900946
;  :num-checks              158
;  :propagations            54
;  :quant-instantiations    32
;  :rlimit-count            168509)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 11 | !(0 <= First:(Second:(Second:($t@76@02)))[i@77@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))
      i@77@02))))
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
; [else-branch: 9 | !(i@77@02 < |First:(Second:(Second:($t@76@02)))| && 0 <= i@77@02)]
(assert (not
  (and
    (<
      i@77@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))))
    (<= 0 i@77@02))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@77@02 Int)) (!
  (implies
    (and
      (<
        i@77@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))))
      (<= 0 i@77@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))
          i@77@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))
            i@77@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))
            i@77@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))
    i@77@02))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@78@02 $Snap)
(assert (= $t@78@02 ($Snap.combine ($Snap.first $t@78@02) ($Snap.second $t@78@02))))
(assert (=
  ($Snap.second $t@78@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@78@02))
    ($Snap.second ($Snap.second $t@78@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@78@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@78@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@78@02))) $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@78@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@79@02 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 12 | 0 <= i@79@02 | live]
; [else-branch: 12 | !(0 <= i@79@02) | live]
(push) ; 5
; [then-branch: 12 | 0 <= i@79@02]
(assert (<= 0 i@79@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 12 | !(0 <= i@79@02)]
(assert (not (<= 0 i@79@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 13 | i@79@02 < |First:(Second:($t@78@02))| && 0 <= i@79@02 | live]
; [else-branch: 13 | !(i@79@02 < |First:(Second:($t@78@02))| && 0 <= i@79@02) | live]
(push) ; 5
; [then-branch: 13 | i@79@02 < |First:(Second:($t@78@02))| && 0 <= i@79@02]
(assert (and
  (<
    i@79@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))))
  (<= 0 i@79@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@79@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1608
;  :arith-assert-diseq      24
;  :arith-assert-lower      68
;  :arith-assert-upper      42
;  :arith-eq-adapter        33
;  :binary-propagations     22
;  :conflicts               122
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 430
;  :datatype-occurs-check   90
;  :datatype-splits         120
;  :decisions               415
;  :del-clause              54
;  :final-checks            51
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             737
;  :mk-clause               56
;  :num-allocs              3900946
;  :num-checks              160
;  :propagations            54
;  :quant-instantiations    36
;  :rlimit-count            170305)
; [eval] -1
(push) ; 6
; [then-branch: 14 | First:(Second:($t@78@02))[i@79@02] == -1 | live]
; [else-branch: 14 | First:(Second:($t@78@02))[i@79@02] != -1 | live]
(push) ; 7
; [then-branch: 14 | First:(Second:($t@78@02))[i@79@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))
    i@79@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 14 | First:(Second:($t@78@02))[i@79@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))
      i@79@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@79@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1608
;  :arith-assert-diseq      24
;  :arith-assert-lower      68
;  :arith-assert-upper      42
;  :arith-eq-adapter        33
;  :binary-propagations     22
;  :conflicts               122
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 430
;  :datatype-occurs-check   90
;  :datatype-splits         120
;  :decisions               415
;  :del-clause              54
;  :final-checks            51
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             738
;  :mk-clause               56
;  :num-allocs              3900946
;  :num-checks              161
;  :propagations            54
;  :quant-instantiations    36
;  :rlimit-count            170456)
(push) ; 8
; [then-branch: 15 | 0 <= First:(Second:($t@78@02))[i@79@02] | live]
; [else-branch: 15 | !(0 <= First:(Second:($t@78@02))[i@79@02]) | live]
(push) ; 9
; [then-branch: 15 | 0 <= First:(Second:($t@78@02))[i@79@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))
    i@79@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@79@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1608
;  :arith-assert-diseq      25
;  :arith-assert-lower      71
;  :arith-assert-upper      42
;  :arith-eq-adapter        34
;  :binary-propagations     22
;  :conflicts               122
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 430
;  :datatype-occurs-check   90
;  :datatype-splits         120
;  :decisions               415
;  :del-clause              54
;  :final-checks            51
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             741
;  :mk-clause               57
;  :num-allocs              3900946
;  :num-checks              162
;  :propagations            54
;  :quant-instantiations    36
;  :rlimit-count            170559)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 15 | !(0 <= First:(Second:($t@78@02))[i@79@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))
      i@79@02))))
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
; [else-branch: 13 | !(i@79@02 < |First:(Second:($t@78@02))| && 0 <= i@79@02)]
(assert (not
  (and
    (<
      i@79@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))))
    (<= 0 i@79@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@79@02 Int)) (!
  (implies
    (and
      (<
        i@79@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))))
      (<= 0 i@79@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))
          i@79@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))
            i@79@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))
            i@79@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))
    i@79@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@78@02)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@76@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1626
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               122
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 430
;  :datatype-occurs-check   90
;  :datatype-splits         120
;  :decisions               415
;  :del-clause              55
;  :final-checks            51
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             761
;  :mk-clause               68
;  :num-allocs              3900946
;  :num-checks              163
;  :propagations            58
;  :quant-instantiations    38
;  :rlimit-count            171587)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1663
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 442
;  :datatype-occurs-check   96
;  :datatype-splits         127
;  :decisions               425
;  :del-clause              56
;  :final-checks            54
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             772
;  :mk-clause               69
;  :num-allocs              3900946
;  :num-checks              164
;  :propagations            59
;  :quant-instantiations    38
;  :rlimit-count            172191)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1699
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 454
;  :datatype-occurs-check   102
;  :datatype-splits         134
;  :decisions               435
;  :del-clause              57
;  :final-checks            57
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             783
;  :mk-clause               70
;  :num-allocs              3900946
;  :num-checks              165
;  :propagations            60
;  :quant-instantiations    38
;  :rlimit-count            172800)
; [then-branch: 16 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[0] == 0 | live]
; [else-branch: 16 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[0] != 0 | live]
(push) ; 4
; [then-branch: 16 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    0)
  0))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1700
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 454
;  :datatype-occurs-check   102
;  :datatype-splits         134
;  :decisions               435
;  :del-clause              57
;  :final-checks            57
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             784
;  :mk-clause               70
;  :num-allocs              3900946
;  :num-checks              166
;  :propagations            60
;  :quant-instantiations    38
;  :rlimit-count            172936)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 16 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      0)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1706
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 454
;  :datatype-occurs-check   102
;  :datatype-splits         134
;  :decisions               435
;  :del-clause              57
;  :final-checks            57
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             788
;  :mk-clause               71
;  :num-allocs              3900946
;  :num-checks              167
;  :propagations            60
;  :quant-instantiations    38
;  :rlimit-count            173383)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1744
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               125
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 466
;  :datatype-occurs-check   108
;  :datatype-splits         145
;  :decisions               447
;  :del-clause              58
;  :final-checks            60
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             804
;  :mk-clause               72
;  :num-allocs              4063406
;  :num-checks              168
;  :propagations            61
;  :quant-instantiations    38
;  :rlimit-count            174013)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1781
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   114
;  :datatype-splits         156
;  :decisions               459
;  :del-clause              59
;  :final-checks            63
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             820
;  :mk-clause               73
;  :num-allocs              4063406
;  :num-checks              169
;  :propagations            62
;  :quant-instantiations    38
;  :rlimit-count            174652)
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[1] == 0 | live]
; [else-branch: 17 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[1] != 0 | live]
(push) ; 4
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    1)
  0))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1782
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   114
;  :datatype-splits         156
;  :decisions               459
;  :del-clause              59
;  :final-checks            63
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             821
;  :mk-clause               73
;  :num-allocs              4063406
;  :num-checks              170
;  :propagations            62
;  :quant-instantiations    38
;  :rlimit-count            174788)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 17 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      1)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[2]) == 0 ==> diz.Main_event_state[2] == -2
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 3
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1788
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    128
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   114
;  :datatype-splits         156
;  :decisions               459
;  :del-clause              59
;  :final-checks            63
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             825
;  :mk-clause               74
;  :num-allocs              4063406
;  :num-checks              171
;  :propagations            62
;  :quant-instantiations    38
;  :rlimit-count            175241)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      2)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1827
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               127
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 490
;  :datatype-occurs-check   120
;  :datatype-splits         167
;  :decisions               473
;  :del-clause              60
;  :final-checks            66
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             841
;  :mk-clause               75
;  :num-allocs              4063406
;  :num-checks              172
;  :propagations            63
;  :quant-instantiations    38
;  :rlimit-count            175901)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    2)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1865
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               128
;  :datatype-accessor-ax    132
;  :datatype-constructor-ax 502
;  :datatype-occurs-check   126
;  :datatype-splits         178
;  :decisions               487
;  :del-clause              61
;  :final-checks            69
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             857
;  :mk-clause               76
;  :num-allocs              4063406
;  :num-checks              173
;  :propagations            64
;  :quant-instantiations    38
;  :rlimit-count            176570)
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[2] == 0 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[2] != 0 | live]
(push) ; 4
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    2)
  0))
; [eval] diz.Main_event_state[2] == -2
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1866
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               128
;  :datatype-accessor-ax    132
;  :datatype-constructor-ax 502
;  :datatype-occurs-check   126
;  :datatype-splits         178
;  :decisions               487
;  :del-clause              61
;  :final-checks            69
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             858
;  :mk-clause               76
;  :num-allocs              4063406
;  :num-checks              174
;  :propagations            64
;  :quant-instantiations    38
;  :rlimit-count            176706)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 18 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      2)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      2)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[3]) == 0 ==> diz.Main_event_state[3] == -2
; [eval] old(diz.Main_event_state[3]) == 0
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 3
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1872
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               128
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 502
;  :datatype-occurs-check   126
;  :datatype-splits         178
;  :decisions               487
;  :del-clause              61
;  :final-checks            69
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             862
;  :mk-clause               77
;  :num-allocs              4063406
;  :num-checks              175
;  :propagations            64
;  :quant-instantiations    38
;  :rlimit-count            177169)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      3)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1912
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               129
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 514
;  :datatype-occurs-check   132
;  :datatype-splits         189
;  :decisions               503
;  :del-clause              62
;  :final-checks            72
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             878
;  :mk-clause               78
;  :num-allocs              4063406
;  :num-checks              176
;  :propagations            65
;  :quant-instantiations    38
;  :rlimit-count            177859
;  :time                    0.00)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    3)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1951
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               130
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 526
;  :datatype-occurs-check   138
;  :datatype-splits         200
;  :decisions               519
;  :del-clause              63
;  :final-checks            75
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             894
;  :mk-clause               79
;  :num-allocs              4063406
;  :num-checks              177
;  :propagations            66
;  :quant-instantiations    38
;  :rlimit-count            178558
;  :time                    0.00)
; [then-branch: 19 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[3] == 0 | live]
; [else-branch: 19 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[3] != 0 | live]
(push) ; 4
; [then-branch: 19 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[3] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    3)
  0))
; [eval] diz.Main_event_state[3] == -2
; [eval] diz.Main_event_state[3]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1952
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               130
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 526
;  :datatype-occurs-check   138
;  :datatype-splits         200
;  :decisions               519
;  :del-clause              63
;  :final-checks            75
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             895
;  :mk-clause               79
;  :num-allocs              4063406
;  :num-checks              178
;  :propagations            66
;  :quant-instantiations    38
;  :rlimit-count            178694)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 19 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[3] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      3)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      3)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      3)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[4]) == 0 ==> diz.Main_event_state[4] == -2
; [eval] old(diz.Main_event_state[4]) == 0
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 3
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1958
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               130
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 526
;  :datatype-occurs-check   138
;  :datatype-splits         200
;  :decisions               519
;  :del-clause              63
;  :final-checks            75
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             899
;  :mk-clause               80
;  :num-allocs              4063406
;  :num-checks              179
;  :propagations            66
;  :quant-instantiations    38
;  :rlimit-count            179167)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      4)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1999
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               131
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 538
;  :datatype-occurs-check   144
;  :datatype-splits         211
;  :decisions               537
;  :del-clause              64
;  :final-checks            78
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             915
;  :mk-clause               81
;  :num-allocs              4063406
;  :num-checks              180
;  :propagations            67
;  :quant-instantiations    38
;  :rlimit-count            179887)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    4)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2039
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    142
;  :datatype-constructor-ax 550
;  :datatype-occurs-check   150
;  :datatype-splits         222
;  :decisions               555
;  :del-clause              65
;  :final-checks            81
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             931
;  :mk-clause               82
;  :num-allocs              4063406
;  :num-checks              181
;  :propagations            68
;  :quant-instantiations    38
;  :rlimit-count            180616)
; [then-branch: 20 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[4] == 0 | live]
; [else-branch: 20 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[4] != 0 | live]
(push) ; 4
; [then-branch: 20 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[4] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    4)
  0))
; [eval] diz.Main_event_state[4] == -2
; [eval] diz.Main_event_state[4]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2040
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    142
;  :datatype-constructor-ax 550
;  :datatype-occurs-check   150
;  :datatype-splits         222
;  :decisions               555
;  :del-clause              65
;  :final-checks            81
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             932
;  :mk-clause               82
;  :num-allocs              4063406
;  :num-checks              182
;  :propagations            68
;  :quant-instantiations    38
;  :rlimit-count            180752)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 20 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[4] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      4)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      4)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      4)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[5]) == 0 ==> diz.Main_event_state[5] == -2
; [eval] old(diz.Main_event_state[5]) == 0
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 3
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2046
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    143
;  :datatype-constructor-ax 550
;  :datatype-occurs-check   150
;  :datatype-splits         222
;  :decisions               555
;  :del-clause              65
;  :final-checks            81
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             936
;  :mk-clause               83
;  :num-allocs              4063406
;  :num-checks              183
;  :propagations            68
;  :quant-instantiations    38
;  :rlimit-count            181235)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      5)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2088
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               133
;  :datatype-accessor-ax    145
;  :datatype-constructor-ax 562
;  :datatype-occurs-check   156
;  :datatype-splits         233
;  :decisions               575
;  :del-clause              66
;  :final-checks            84
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             952
;  :mk-clause               84
;  :num-allocs              4063406
;  :num-checks              184
;  :propagations            69
;  :quant-instantiations    38
;  :rlimit-count            181985
;  :time                    0.00)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    5)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2129
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               134
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 574
;  :datatype-occurs-check   162
;  :datatype-splits         244
;  :decisions               595
;  :del-clause              67
;  :final-checks            87
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             968
;  :mk-clause               85
;  :num-allocs              4063406
;  :num-checks              185
;  :propagations            70
;  :quant-instantiations    38
;  :rlimit-count            182744
;  :time                    0.00)
; [then-branch: 21 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[5] == 0 | live]
; [else-branch: 21 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[5] != 0 | live]
(push) ; 4
; [then-branch: 21 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[5] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    5)
  0))
; [eval] diz.Main_event_state[5] == -2
; [eval] diz.Main_event_state[5]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2130
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               134
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 574
;  :datatype-occurs-check   162
;  :datatype-splits         244
;  :decisions               595
;  :del-clause              67
;  :final-checks            87
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             969
;  :mk-clause               85
;  :num-allocs              4063406
;  :num-checks              186
;  :propagations            70
;  :quant-instantiations    38
;  :rlimit-count            182880)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 21 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[5] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      5)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      5)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      5)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2136
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               134
;  :datatype-accessor-ax    148
;  :datatype-constructor-ax 574
;  :datatype-occurs-check   162
;  :datatype-splits         244
;  :decisions               595
;  :del-clause              67
;  :final-checks            87
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             973
;  :mk-clause               86
;  :num-allocs              4063406
;  :num-checks              187
;  :propagations            70
;  :quant-instantiations    38
;  :rlimit-count            183373)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2178
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               135
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 586
;  :datatype-occurs-check   168
;  :datatype-splits         255
;  :decisions               615
;  :del-clause              68
;  :final-checks            90
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             988
;  :mk-clause               87
;  :num-allocs              4063406
;  :num-checks              188
;  :propagations            71
;  :quant-instantiations    38
;  :rlimit-count            184125)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2228
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 601
;  :datatype-occurs-check   176
;  :datatype-splits         268
;  :decisions               637
;  :del-clause              70
;  :final-checks            94
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1012
;  :mk-clause               89
;  :num-allocs              4063406
;  :num-checks              189
;  :propagations            73
;  :quant-instantiations    38
;  :rlimit-count            184925)
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[0] != 0 | live]
; [else-branch: 22 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[0] == 0 | live]
(push) ; 4
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      0)
    0)))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2228
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 601
;  :datatype-occurs-check   176
;  :datatype-splits         268
;  :decisions               637
;  :del-clause              70
;  :final-checks            94
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1012
;  :mk-clause               89
;  :num-allocs              4063406
;  :num-checks              190
;  :propagations            73
;  :quant-instantiations    38
;  :rlimit-count            185063)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2228
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 601
;  :datatype-occurs-check   176
;  :datatype-splits         268
;  :decisions               637
;  :del-clause              70
;  :final-checks            94
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1012
;  :mk-clause               89
;  :num-allocs              4063406
;  :num-checks              191
;  :propagations            73
;  :quant-instantiations    38
;  :rlimit-count            185078)
(pop) ; 4
(push) ; 4
; [else-branch: 22 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
        0)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2234
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    154
;  :datatype-constructor-ax 601
;  :datatype-occurs-check   176
;  :datatype-splits         268
;  :decisions               637
;  :del-clause              70
;  :final-checks            94
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1015
;  :mk-clause               90
;  :num-allocs              4063406
;  :num-checks              192
;  :propagations            73
;  :quant-instantiations    38
;  :rlimit-count            185539)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2277
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               138
;  :datatype-accessor-ax    156
;  :datatype-constructor-ax 613
;  :datatype-occurs-check   182
;  :datatype-splits         279
;  :decisions               657
;  :del-clause              71
;  :final-checks            97
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1030
;  :mk-clause               91
;  :num-allocs              4063406
;  :num-checks              193
;  :propagations            76
;  :quant-instantiations    38
;  :rlimit-count            186304)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2329
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    159
;  :datatype-constructor-ax 628
;  :datatype-occurs-check   190
;  :datatype-splits         292
;  :decisions               679
;  :del-clause              73
;  :final-checks            101
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1054
;  :mk-clause               93
;  :num-allocs              4063406
;  :num-checks              194
;  :propagations            80
;  :quant-instantiations    38
;  :rlimit-count            187115)
; [then-branch: 23 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[1] != 0 | live]
; [else-branch: 23 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[1] == 0 | live]
(push) ; 4
; [then-branch: 23 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      1)
    0)))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2329
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    159
;  :datatype-constructor-ax 628
;  :datatype-occurs-check   190
;  :datatype-splits         292
;  :decisions               679
;  :del-clause              73
;  :final-checks            101
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1054
;  :mk-clause               93
;  :num-allocs              4063406
;  :num-checks              195
;  :propagations            80
;  :quant-instantiations    38
;  :rlimit-count            187253)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2329
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    159
;  :datatype-constructor-ax 628
;  :datatype-occurs-check   190
;  :datatype-splits         292
;  :decisions               679
;  :del-clause              73
;  :final-checks            101
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1054
;  :mk-clause               93
;  :num-allocs              4063406
;  :num-checks              196
;  :propagations            80
;  :quant-instantiations    38
;  :rlimit-count            187268)
(pop) ; 4
(push) ; 4
; [else-branch: 23 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
        1)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2335
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    160
;  :datatype-constructor-ax 628
;  :datatype-occurs-check   190
;  :datatype-splits         292
;  :decisions               679
;  :del-clause              73
;  :final-checks            101
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1057
;  :mk-clause               94
;  :num-allocs              4063406
;  :num-checks              197
;  :propagations            80
;  :quant-instantiations    38
;  :rlimit-count            187739)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    2)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2379
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               141
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 640
;  :datatype-occurs-check   196
;  :datatype-splits         303
;  :decisions               699
;  :del-clause              74
;  :final-checks            104
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1072
;  :mk-clause               95
;  :num-allocs              4063406
;  :num-checks              198
;  :propagations            85
;  :quant-instantiations    38
;  :rlimit-count            188514)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      2)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2433
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               143
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 655
;  :datatype-occurs-check   204
;  :datatype-splits         316
;  :decisions               721
;  :del-clause              76
;  :final-checks            108
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1096
;  :mk-clause               97
;  :num-allocs              4063406
;  :num-checks              199
;  :propagations            91
;  :quant-instantiations    38
;  :rlimit-count            189336)
; [then-branch: 24 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[2] != 0 | live]
; [else-branch: 24 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[2] == 0 | live]
(push) ; 4
; [then-branch: 24 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      2)
    0)))
; [eval] diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2433
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               143
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 655
;  :datatype-occurs-check   204
;  :datatype-splits         316
;  :decisions               721
;  :del-clause              76
;  :final-checks            108
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1096
;  :mk-clause               97
;  :num-allocs              4063406
;  :num-checks              200
;  :propagations            91
;  :quant-instantiations    38
;  :rlimit-count            189474)
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2433
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               143
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 655
;  :datatype-occurs-check   204
;  :datatype-splits         316
;  :decisions               721
;  :del-clause              76
;  :final-checks            108
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1096
;  :mk-clause               97
;  :num-allocs              4063406
;  :num-checks              201
;  :propagations            91
;  :quant-instantiations    38
;  :rlimit-count            189489)
(pop) ; 4
(push) ; 4
; [else-branch: 24 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
        2)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2439
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               143
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 655
;  :datatype-occurs-check   204
;  :datatype-splits         316
;  :decisions               721
;  :del-clause              76
;  :final-checks            108
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1099
;  :mk-clause               98
;  :num-allocs              4063406
;  :num-checks              202
;  :propagations            91
;  :quant-instantiations    38
;  :rlimit-count            189970)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    3)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2484
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               144
;  :datatype-accessor-ax    168
;  :datatype-constructor-ax 667
;  :datatype-occurs-check   210
;  :datatype-splits         327
;  :decisions               741
;  :del-clause              77
;  :final-checks            111
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1114
;  :mk-clause               99
;  :num-allocs              4063406
;  :num-checks              203
;  :propagations            98
;  :quant-instantiations    38
;  :rlimit-count            190755)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      3)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2540
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               146
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 682
;  :datatype-occurs-check   218
;  :datatype-splits         340
;  :decisions               763
;  :del-clause              79
;  :final-checks            115
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1138
;  :mk-clause               101
;  :num-allocs              4063406
;  :num-checks              204
;  :propagations            106
;  :quant-instantiations    38
;  :rlimit-count            191588
;  :time                    0.00)
; [then-branch: 25 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[3] != 0 | live]
; [else-branch: 25 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[3] == 0 | live]
(push) ; 4
; [then-branch: 25 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[3] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      3)
    0)))
; [eval] diz.Main_event_state[3] == old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2540
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               146
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 682
;  :datatype-occurs-check   218
;  :datatype-splits         340
;  :decisions               763
;  :del-clause              79
;  :final-checks            115
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1138
;  :mk-clause               101
;  :num-allocs              4063406
;  :num-checks              205
;  :propagations            106
;  :quant-instantiations    38
;  :rlimit-count            191726)
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2540
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               146
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 682
;  :datatype-occurs-check   218
;  :datatype-splits         340
;  :decisions               763
;  :del-clause              79
;  :final-checks            115
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1138
;  :mk-clause               101
;  :num-allocs              4063406
;  :num-checks              206
;  :propagations            106
;  :quant-instantiations    38
;  :rlimit-count            191741)
(pop) ; 4
(push) ; 4
; [else-branch: 25 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[3] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
        3)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      3)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      3))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2546
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               146
;  :datatype-accessor-ax    172
;  :datatype-constructor-ax 682
;  :datatype-occurs-check   218
;  :datatype-splits         340
;  :decisions               763
;  :del-clause              79
;  :final-checks            115
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1141
;  :mk-clause               102
;  :num-allocs              4063406
;  :num-checks              207
;  :propagations            106
;  :quant-instantiations    38
;  :rlimit-count            192232)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    4)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2592
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               147
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 694
;  :datatype-occurs-check   224
;  :datatype-splits         351
;  :decisions               783
;  :del-clause              80
;  :final-checks            118
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1156
;  :mk-clause               103
;  :num-allocs              4063406
;  :num-checks              208
;  :propagations            115
;  :quant-instantiations    38
;  :rlimit-count            193027)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      4)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2650
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               149
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 709
;  :datatype-occurs-check   232
;  :datatype-splits         364
;  :decisions               805
;  :del-clause              82
;  :final-checks            122
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1180
;  :mk-clause               105
;  :num-allocs              4063406
;  :num-checks              209
;  :propagations            125
;  :quant-instantiations    38
;  :rlimit-count            193871)
; [then-branch: 26 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[4] != 0 | live]
; [else-branch: 26 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[4] == 0 | live]
(push) ; 4
; [then-branch: 26 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[4] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      4)
    0)))
; [eval] diz.Main_event_state[4] == old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2650
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               149
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 709
;  :datatype-occurs-check   232
;  :datatype-splits         364
;  :decisions               805
;  :del-clause              82
;  :final-checks            122
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1180
;  :mk-clause               105
;  :num-allocs              4063406
;  :num-checks              210
;  :propagations            125
;  :quant-instantiations    38
;  :rlimit-count            194009)
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2650
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               149
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 709
;  :datatype-occurs-check   232
;  :datatype-splits         364
;  :decisions               805
;  :del-clause              82
;  :final-checks            122
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1180
;  :mk-clause               105
;  :num-allocs              4063406
;  :num-checks              211
;  :propagations            125
;  :quant-instantiations    38
;  :rlimit-count            194024)
(pop) ; 4
(push) ; 4
; [else-branch: 26 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[4] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
        4)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      4)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      4))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2652
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               149
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 709
;  :datatype-occurs-check   232
;  :datatype-splits         364
;  :decisions               805
;  :del-clause              82
;  :final-checks            122
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1182
;  :mk-clause               106
;  :num-allocs              4063406
;  :num-checks              212
;  :propagations            125
;  :quant-instantiations    38
;  :rlimit-count            194433)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
    5)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2696
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               150
;  :datatype-accessor-ax    179
;  :datatype-constructor-ax 720
;  :datatype-occurs-check   238
;  :datatype-splits         373
;  :decisions               824
;  :del-clause              83
;  :final-checks            125
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1195
;  :mk-clause               107
;  :num-allocs              4063406
;  :num-checks              213
;  :propagations            136
;  :quant-instantiations    38
;  :rlimit-count            195224)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      5)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2753
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               152
;  :datatype-accessor-ax    182
;  :datatype-constructor-ax 734
;  :datatype-occurs-check   246
;  :datatype-splits         384
;  :decisions               845
;  :del-clause              85
;  :final-checks            129
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1217
;  :mk-clause               109
;  :num-allocs              4063406
;  :num-checks              214
;  :propagations            148
;  :quant-instantiations    38
;  :rlimit-count            196065
;  :time                    0.00)
; [then-branch: 27 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[5] != 0 | live]
; [else-branch: 27 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[5] == 0 | live]
(push) ; 4
; [then-branch: 27 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[5] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      5)
    0)))
; [eval] diz.Main_event_state[5] == old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2753
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               152
;  :datatype-accessor-ax    182
;  :datatype-constructor-ax 734
;  :datatype-occurs-check   246
;  :datatype-splits         384
;  :decisions               845
;  :del-clause              85
;  :final-checks            129
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1217
;  :mk-clause               109
;  :num-allocs              4063406
;  :num-checks              215
;  :propagations            148
;  :quant-instantiations    38
;  :rlimit-count            196203)
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2753
;  :arith-assert-diseq      25
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               152
;  :datatype-accessor-ax    182
;  :datatype-constructor-ax 734
;  :datatype-occurs-check   246
;  :datatype-splits         384
;  :decisions               845
;  :del-clause              85
;  :final-checks            129
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1217
;  :mk-clause               109
;  :num-allocs              4063406
;  :num-checks              216
;  :propagations            148
;  :quant-instantiations    38
;  :rlimit-count            196218)
(pop) ; 4
(push) ; 4
; [else-branch: 27 | First:(Second:(Second:(Second:(Second:($t@76@02)))))[5] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
        5)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
      5)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@76@02))))))
      5))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main_reset_all_events_EncodedGlobalVariables ----------
(declare-const diz@80@02 $Ref)
(declare-const globals@81@02 $Ref)
(declare-const diz@82@02 $Ref)
(declare-const globals@83@02 $Ref)
(push) ; 1
(declare-const $t@84@02 $Snap)
(assert (= $t@84@02 ($Snap.combine ($Snap.first $t@84@02) ($Snap.second $t@84@02))))
(assert (= ($Snap.first $t@84@02) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@82@02 $Ref.null)))
(assert (=
  ($Snap.second $t@84@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@84@02))
    ($Snap.second ($Snap.second $t@84@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@84@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@84@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@84@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@02))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02)))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02)))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@85@02 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 28 | 0 <= i@85@02 | live]
; [else-branch: 28 | !(0 <= i@85@02) | live]
(push) ; 4
; [then-branch: 28 | 0 <= i@85@02]
(assert (<= 0 i@85@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 28 | !(0 <= i@85@02)]
(assert (not (<= 0 i@85@02)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 29 | i@85@02 < |First:(Second:(Second:($t@84@02)))| && 0 <= i@85@02 | live]
; [else-branch: 29 | !(i@85@02 < |First:(Second:(Second:($t@84@02)))| && 0 <= i@85@02) | live]
(push) ; 4
; [then-branch: 29 | i@85@02 < |First:(Second:(Second:($t@84@02)))| && 0 <= i@85@02]
(assert (and
  (<
    i@85@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))))
  (<= 0 i@85@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 5
(assert (not (>= i@85@02 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2791
;  :arith-assert-diseq      27
;  :arith-assert-lower      79
;  :arith-assert-upper      46
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               152
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 734
;  :datatype-occurs-check   246
;  :datatype-splits         384
;  :decisions               845
;  :del-clause              108
;  :final-checks            129
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1246
;  :mk-clause               115
;  :num-allocs              4063406
;  :num-checks              217
;  :propagations            150
;  :quant-instantiations    44
;  :rlimit-count            197434)
; [eval] -1
(push) ; 5
; [then-branch: 30 | First:(Second:(Second:($t@84@02)))[i@85@02] == -1 | live]
; [else-branch: 30 | First:(Second:(Second:($t@84@02)))[i@85@02] != -1 | live]
(push) ; 6
; [then-branch: 30 | First:(Second:(Second:($t@84@02)))[i@85@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))
    i@85@02)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 30 | First:(Second:(Second:($t@84@02)))[i@85@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))
      i@85@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@85@02 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2791
;  :arith-assert-diseq      27
;  :arith-assert-lower      79
;  :arith-assert-upper      46
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               152
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 734
;  :datatype-occurs-check   246
;  :datatype-splits         384
;  :decisions               845
;  :del-clause              108
;  :final-checks            129
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1247
;  :mk-clause               115
;  :num-allocs              4063406
;  :num-checks              218
;  :propagations            150
;  :quant-instantiations    44
;  :rlimit-count            197597)
(push) ; 7
; [then-branch: 31 | 0 <= First:(Second:(Second:($t@84@02)))[i@85@02] | live]
; [else-branch: 31 | !(0 <= First:(Second:(Second:($t@84@02)))[i@85@02]) | live]
(push) ; 8
; [then-branch: 31 | 0 <= First:(Second:(Second:($t@84@02)))[i@85@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))
    i@85@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@85@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2791
;  :arith-assert-diseq      28
;  :arith-assert-lower      82
;  :arith-assert-upper      46
;  :arith-eq-adapter        40
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               152
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 734
;  :datatype-occurs-check   246
;  :datatype-splits         384
;  :decisions               845
;  :del-clause              108
;  :final-checks            129
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1250
;  :mk-clause               116
;  :num-allocs              4063406
;  :num-checks              219
;  :propagations            150
;  :quant-instantiations    44
;  :rlimit-count            197710)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 31 | !(0 <= First:(Second:(Second:($t@84@02)))[i@85@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))
      i@85@02))))
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
; [else-branch: 29 | !(i@85@02 < |First:(Second:(Second:($t@84@02)))| && 0 <= i@85@02)]
(assert (not
  (and
    (<
      i@85@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))))
    (<= 0 i@85@02))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@85@02 Int)) (!
  (implies
    (and
      (<
        i@85@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))))
      (<= 0 i@85@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))
          i@85@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))
            i@85@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))
            i@85@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))
    i@85@02))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@86@02 $Snap)
(assert (= $t@86@02 ($Snap.combine ($Snap.first $t@86@02) ($Snap.second $t@86@02))))
(assert (=
  ($Snap.second $t@86@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@86@02))
    ($Snap.second ($Snap.second $t@86@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@86@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@86@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@86@02))) $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@86@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@87@02 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 32 | 0 <= i@87@02 | live]
; [else-branch: 32 | !(0 <= i@87@02) | live]
(push) ; 5
; [then-branch: 32 | 0 <= i@87@02]
(assert (<= 0 i@87@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 32 | !(0 <= i@87@02)]
(assert (not (<= 0 i@87@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 33 | i@87@02 < |First:(Second:($t@86@02))| && 0 <= i@87@02 | live]
; [else-branch: 33 | !(i@87@02 < |First:(Second:($t@86@02))| && 0 <= i@87@02) | live]
(push) ; 5
; [then-branch: 33 | i@87@02 < |First:(Second:($t@86@02))| && 0 <= i@87@02]
(assert (and
  (<
    i@87@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))))
  (<= 0 i@87@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@87@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2846
;  :arith-assert-diseq      28
;  :arith-assert-lower      87
;  :arith-assert-upper      49
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               153
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 740
;  :datatype-occurs-check   249
;  :datatype-splits         389
;  :decisions               850
;  :del-clause              115
;  :final-checks            132
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1278
;  :mk-clause               117
;  :num-allocs              4063406
;  :num-checks              221
;  :propagations            150
;  :quant-instantiations    48
;  :rlimit-count            199507)
; [eval] -1
(push) ; 6
; [then-branch: 34 | First:(Second:($t@86@02))[i@87@02] == -1 | live]
; [else-branch: 34 | First:(Second:($t@86@02))[i@87@02] != -1 | live]
(push) ; 7
; [then-branch: 34 | First:(Second:($t@86@02))[i@87@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))
    i@87@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 34 | First:(Second:($t@86@02))[i@87@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))
      i@87@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@87@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2846
;  :arith-assert-diseq      28
;  :arith-assert-lower      87
;  :arith-assert-upper      49
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               153
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 740
;  :datatype-occurs-check   249
;  :datatype-splits         389
;  :decisions               850
;  :del-clause              115
;  :final-checks            132
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1279
;  :mk-clause               117
;  :num-allocs              4063406
;  :num-checks              222
;  :propagations            150
;  :quant-instantiations    48
;  :rlimit-count            199658)
(push) ; 8
; [then-branch: 35 | 0 <= First:(Second:($t@86@02))[i@87@02] | live]
; [else-branch: 35 | !(0 <= First:(Second:($t@86@02))[i@87@02]) | live]
(push) ; 9
; [then-branch: 35 | 0 <= First:(Second:($t@86@02))[i@87@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))
    i@87@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@87@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2846
;  :arith-assert-diseq      29
;  :arith-assert-lower      90
;  :arith-assert-upper      49
;  :arith-eq-adapter        43
;  :arith-fixed-eqs         1
;  :binary-propagations     22
;  :conflicts               153
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 740
;  :datatype-occurs-check   249
;  :datatype-splits         389
;  :decisions               850
;  :del-clause              115
;  :final-checks            132
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1282
;  :mk-clause               118
;  :num-allocs              4063406
;  :num-checks              223
;  :propagations            150
;  :quant-instantiations    48
;  :rlimit-count            199762)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 35 | !(0 <= First:(Second:($t@86@02))[i@87@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))
      i@87@02))))
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
; [else-branch: 33 | !(i@87@02 < |First:(Second:($t@86@02))| && 0 <= i@87@02)]
(assert (not
  (and
    (<
      i@87@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))))
    (<= 0 i@87@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@87@02 Int)) (!
  (implies
    (and
      (<
        i@87@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))))
      (<= 0 i@87@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))
          i@87@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))
            i@87@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))
            i@87@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))
    i@87@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@86@02)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@84@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2863
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               153
;  :datatype-accessor-ax    198
;  :datatype-constructor-ax 740
;  :datatype-occurs-check   249
;  :datatype-splits         389
;  :decisions               850
;  :del-clause              116
;  :final-checks            132
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1301
;  :mk-clause               129
;  :num-allocs              4063406
;  :num-checks              224
;  :propagations            154
;  :quant-instantiations    50
;  :rlimit-count            200787)
(push) ; 3
; [then-branch: 36 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0 | live]
; [else-branch: 36 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] != 0 | live]
(push) ; 4
; [then-branch: 36 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    0)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 36 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2863
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               153
;  :datatype-accessor-ax    198
;  :datatype-constructor-ax 740
;  :datatype-occurs-check   249
;  :datatype-splits         389
;  :decisions               850
;  :del-clause              116
;  :final-checks            132
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1302
;  :mk-clause               129
;  :num-allocs              4063406
;  :num-checks              225
;  :propagations            154
;  :quant-instantiations    50
;  :rlimit-count            200972)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2901
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               154
;  :datatype-accessor-ax    200
;  :datatype-constructor-ax 752
;  :datatype-occurs-check   255
;  :datatype-splits         400
;  :decisions               862
;  :del-clause              118
;  :final-checks            135
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1319
;  :mk-clause               131
;  :num-allocs              4063406
;  :num-checks              226
;  :propagations            155
;  :quant-instantiations    50
;  :rlimit-count            201628
;  :time                    0.00)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2937
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 764
;  :datatype-occurs-check   261
;  :datatype-splits         407
;  :decisions               872
;  :del-clause              119
;  :final-checks            138
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1331
;  :mk-clause               132
;  :num-allocs              4063406
;  :num-checks              227
;  :propagations            156
;  :quant-instantiations    50
;  :rlimit-count            202275)
; [then-branch: 37 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == -1 | live]
; [else-branch: 37 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == -1) | live]
(push) ; 4
; [then-branch: 37 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2937
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 764
;  :datatype-occurs-check   261
;  :datatype-splits         407
;  :decisions               872
;  :del-clause              119
;  :final-checks            138
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1333
;  :mk-clause               133
;  :num-allocs              4063406
;  :num-checks              228
;  :propagations            156
;  :quant-instantiations    50
;  :rlimit-count            202434)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 37 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2943
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 764
;  :datatype-occurs-check   261
;  :datatype-splits         407
;  :decisions               872
;  :del-clause              120
;  :final-checks            138
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1339
;  :mk-clause               137
;  :num-allocs              4063406
;  :num-checks              229
;  :propagations            156
;  :quant-instantiations    50
;  :rlimit-count            202929)
(push) ; 3
; [then-branch: 38 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0 | live]
; [else-branch: 38 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] != 0 | live]
(push) ; 4
; [then-branch: 38 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    1)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 38 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2943
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 764
;  :datatype-occurs-check   261
;  :datatype-splits         407
;  :decisions               872
;  :del-clause              120
;  :final-checks            138
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1340
;  :mk-clause               137
;  :num-allocs              4063406
;  :num-checks              230
;  :propagations            156
;  :quant-instantiations    50
;  :rlimit-count            203110)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2982
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               156
;  :datatype-accessor-ax    205
;  :datatype-constructor-ax 776
;  :datatype-occurs-check   267
;  :datatype-splits         418
;  :decisions               886
;  :del-clause              122
;  :final-checks            141
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1357
;  :mk-clause               139
;  :num-allocs              4063406
;  :num-checks              231
;  :propagations            161
;  :quant-instantiations    50
;  :rlimit-count            203802)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3019
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               157
;  :datatype-accessor-ax    207
;  :datatype-constructor-ax 788
;  :datatype-occurs-check   273
;  :datatype-splits         429
;  :decisions               898
;  :del-clause              123
;  :final-checks            144
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1374
;  :mk-clause               140
;  :num-allocs              4063406
;  :num-checks              232
;  :propagations            166
;  :quant-instantiations    50
;  :rlimit-count            204485)
; [then-branch: 39 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == -1 | live]
; [else-branch: 39 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == -1) | live]
(push) ; 4
; [then-branch: 39 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3019
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               157
;  :datatype-accessor-ax    207
;  :datatype-constructor-ax 788
;  :datatype-occurs-check   273
;  :datatype-splits         429
;  :decisions               898
;  :del-clause              123
;  :final-checks            144
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1376
;  :mk-clause               141
;  :num-allocs              4063406
;  :num-checks              233
;  :propagations            166
;  :quant-instantiations    50
;  :rlimit-count            204644)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 39 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3025
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               157
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 788
;  :datatype-occurs-check   273
;  :datatype-splits         429
;  :decisions               898
;  :del-clause              124
;  :final-checks            144
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1382
;  :mk-clause               145
;  :num-allocs              4063406
;  :num-checks              234
;  :propagations            166
;  :quant-instantiations    50
;  :rlimit-count            205145)
(push) ; 3
; [then-branch: 40 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0 | live]
; [else-branch: 40 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] != 0 | live]
(push) ; 4
; [then-branch: 40 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    2)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 40 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3025
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               157
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 788
;  :datatype-occurs-check   273
;  :datatype-splits         429
;  :decisions               898
;  :del-clause              124
;  :final-checks            144
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1383
;  :mk-clause               145
;  :num-allocs              4063406
;  :num-checks              235
;  :propagations            166
;  :quant-instantiations    50
;  :rlimit-count            205326)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3065
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               158
;  :datatype-accessor-ax    210
;  :datatype-constructor-ax 800
;  :datatype-occurs-check   279
;  :datatype-splits         440
;  :decisions               914
;  :del-clause              126
;  :final-checks            147
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1400
;  :mk-clause               147
;  :num-allocs              4063406
;  :num-checks              236
;  :propagations            175
;  :quant-instantiations    50
;  :rlimit-count            206054
;  :time                    0.00)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3103
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               159
;  :datatype-accessor-ax    212
;  :datatype-constructor-ax 812
;  :datatype-occurs-check   285
;  :datatype-splits         451
;  :decisions               928
;  :del-clause              127
;  :final-checks            150
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1417
;  :mk-clause               148
;  :num-allocs              4063406
;  :num-checks              237
;  :propagations            184
;  :quant-instantiations    50
;  :rlimit-count            206773)
; [then-branch: 41 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == -1 | live]
; [else-branch: 41 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == -1) | live]
(push) ; 4
; [then-branch: 41 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      2)
    (- 0 1))))
; [eval] diz.Main_event_state[2] == -2
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3103
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               159
;  :datatype-accessor-ax    212
;  :datatype-constructor-ax 812
;  :datatype-occurs-check   285
;  :datatype-splits         451
;  :decisions               928
;  :del-clause              127
;  :final-checks            150
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1419
;  :mk-clause               149
;  :num-allocs              4063406
;  :num-checks              238
;  :propagations            184
;  :quant-instantiations    50
;  :rlimit-count            206932)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 41 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        2)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      2)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3109
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               159
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 812
;  :datatype-occurs-check   285
;  :datatype-splits         451
;  :decisions               928
;  :del-clause              128
;  :final-checks            150
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1425
;  :mk-clause               153
;  :num-allocs              4063406
;  :num-checks              239
;  :propagations            184
;  :quant-instantiations    50
;  :rlimit-count            207443)
(push) ; 3
; [then-branch: 42 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0 | live]
; [else-branch: 42 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] != 0 | live]
(push) ; 4
; [then-branch: 42 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    3)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 42 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      3)
    0)))
; [eval] old(diz.Main_event_state[3]) == -1
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3109
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               159
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 812
;  :datatype-occurs-check   285
;  :datatype-splits         451
;  :decisions               928
;  :del-clause              128
;  :final-checks            150
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1426
;  :mk-clause               153
;  :num-allocs              4063406
;  :num-checks              240
;  :propagations            184
;  :quant-instantiations    50
;  :rlimit-count            207624)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        3)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        3)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3150
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               160
;  :datatype-accessor-ax    215
;  :datatype-constructor-ax 824
;  :datatype-occurs-check   291
;  :datatype-splits         462
;  :decisions               946
;  :del-clause              130
;  :final-checks            153
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1443
;  :mk-clause               155
;  :num-allocs              4063406
;  :num-checks              241
;  :propagations            197
;  :quant-instantiations    50
;  :rlimit-count            208388
;  :time                    0.00)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      3)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      3)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3189
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               161
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 836
;  :datatype-occurs-check   297
;  :datatype-splits         473
;  :decisions               962
;  :del-clause              131
;  :final-checks            156
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1460
;  :mk-clause               156
;  :num-allocs              4063406
;  :num-checks              242
;  :propagations            210
;  :quant-instantiations    50
;  :rlimit-count            209143)
; [then-branch: 43 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == -1 | live]
; [else-branch: 43 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == -1) | live]
(push) ; 4
; [then-branch: 43 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      3)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      3)
    (- 0 1))))
; [eval] diz.Main_event_state[3] == -2
; [eval] diz.Main_event_state[3]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3189
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               161
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 836
;  :datatype-occurs-check   297
;  :datatype-splits         473
;  :decisions               962
;  :del-clause              131
;  :final-checks            156
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1462
;  :mk-clause               157
;  :num-allocs              4063406
;  :num-checks              243
;  :propagations            210
;  :quant-instantiations    50
;  :rlimit-count            209302)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 43 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        3)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        3)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        3)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      3)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3195
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               161
;  :datatype-accessor-ax    218
;  :datatype-constructor-ax 836
;  :datatype-occurs-check   297
;  :datatype-splits         473
;  :decisions               962
;  :del-clause              132
;  :final-checks            156
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1468
;  :mk-clause               161
;  :num-allocs              4063406
;  :num-checks              244
;  :propagations            210
;  :quant-instantiations    50
;  :rlimit-count            209823)
(push) ; 3
; [then-branch: 44 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0 | live]
; [else-branch: 44 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] != 0 | live]
(push) ; 4
; [then-branch: 44 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    4)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 44 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      4)
    0)))
; [eval] old(diz.Main_event_state[4]) == -1
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3195
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               161
;  :datatype-accessor-ax    218
;  :datatype-constructor-ax 836
;  :datatype-occurs-check   297
;  :datatype-splits         473
;  :decisions               962
;  :del-clause              132
;  :final-checks            156
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1469
;  :mk-clause               161
;  :num-allocs              4063406
;  :num-checks              245
;  :propagations            210
;  :quant-instantiations    50
;  :rlimit-count            210004)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        4)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        4)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3237
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               162
;  :datatype-accessor-ax    220
;  :datatype-constructor-ax 848
;  :datatype-occurs-check   303
;  :datatype-splits         484
;  :decisions               982
;  :del-clause              134
;  :final-checks            159
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1486
;  :mk-clause               163
;  :num-allocs              4063406
;  :num-checks              246
;  :propagations            227
;  :quant-instantiations    50
;  :rlimit-count            210804
;  :time                    0.00)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      4)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      4)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3277
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               163
;  :datatype-accessor-ax    222
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   309
;  :datatype-splits         495
;  :decisions               1000
;  :del-clause              135
;  :final-checks            162
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1503
;  :mk-clause               164
;  :num-allocs              4063406
;  :num-checks              247
;  :propagations            244
;  :quant-instantiations    50
;  :rlimit-count            211595
;  :time                    0.00)
; [then-branch: 45 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == -1 | live]
; [else-branch: 45 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == -1) | live]
(push) ; 4
; [then-branch: 45 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      4)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      4)
    (- 0 1))))
; [eval] diz.Main_event_state[4] == -2
; [eval] diz.Main_event_state[4]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3277
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               163
;  :datatype-accessor-ax    222
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   309
;  :datatype-splits         495
;  :decisions               1000
;  :del-clause              135
;  :final-checks            162
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1505
;  :mk-clause               165
;  :num-allocs              4063406
;  :num-checks              248
;  :propagations            244
;  :quant-instantiations    50
;  :rlimit-count            211754)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 45 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        4)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        4)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        4)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      4)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3283
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               163
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   309
;  :datatype-splits         495
;  :decisions               1000
;  :del-clause              136
;  :final-checks            162
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1511
;  :mk-clause               169
;  :num-allocs              4063406
;  :num-checks              249
;  :propagations            244
;  :quant-instantiations    50
;  :rlimit-count            212285)
(push) ; 3
; [then-branch: 46 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0 | live]
; [else-branch: 46 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] != 0 | live]
(push) ; 4
; [then-branch: 46 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    5)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 46 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      5)
    0)))
; [eval] old(diz.Main_event_state[5]) == -1
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3283
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               163
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   309
;  :datatype-splits         495
;  :decisions               1000
;  :del-clause              136
;  :final-checks            162
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1512
;  :mk-clause               169
;  :num-allocs              4063406
;  :num-checks              250
;  :propagations            244
;  :quant-instantiations    50
;  :rlimit-count            212466)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        5)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        5)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3326
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               164
;  :datatype-accessor-ax    225
;  :datatype-constructor-ax 872
;  :datatype-occurs-check   315
;  :datatype-splits         506
;  :decisions               1022
;  :del-clause              138
;  :final-checks            165
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1529
;  :mk-clause               171
;  :num-allocs              4063406
;  :num-checks              251
;  :propagations            265
;  :quant-instantiations    50
;  :rlimit-count            213302)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      5)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      5)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3367
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               165
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 884
;  :datatype-occurs-check   321
;  :datatype-splits         517
;  :decisions               1042
;  :del-clause              139
;  :final-checks            168
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1546
;  :mk-clause               172
;  :num-allocs              4063406
;  :num-checks              252
;  :propagations            286
;  :quant-instantiations    50
;  :rlimit-count            214129)
; [then-branch: 47 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == -1 | live]
; [else-branch: 47 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == -1) | live]
(push) ; 4
; [then-branch: 47 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      5)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      5)
    (- 0 1))))
; [eval] diz.Main_event_state[5] == -2
; [eval] diz.Main_event_state[5]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3367
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               165
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 884
;  :datatype-occurs-check   321
;  :datatype-splits         517
;  :decisions               1042
;  :del-clause              139
;  :final-checks            168
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1548
;  :mk-clause               173
;  :num-allocs              4063406
;  :num-checks              253
;  :propagations            286
;  :quant-instantiations    50
;  :rlimit-count            214288)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 47 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        5)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        5)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        5)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      5)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3373
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               165
;  :datatype-accessor-ax    228
;  :datatype-constructor-ax 884
;  :datatype-occurs-check   321
;  :datatype-splits         517
;  :decisions               1042
;  :del-clause              140
;  :final-checks            168
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1554
;  :mk-clause               177
;  :num-allocs              4063406
;  :num-checks              254
;  :propagations            286
;  :quant-instantiations    50
;  :rlimit-count            214829)
(push) ; 3
; [then-branch: 48 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0 | live]
; [else-branch: 48 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] != 0 | live]
(push) ; 4
; [then-branch: 48 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    0)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 48 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3373
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               165
;  :datatype-accessor-ax    228
;  :datatype-constructor-ax 884
;  :datatype-occurs-check   321
;  :datatype-splits         517
;  :decisions               1042
;  :del-clause              140
;  :final-checks            168
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1554
;  :mk-clause               177
;  :num-allocs              4063406
;  :num-checks              255
;  :propagations            286
;  :quant-instantiations    50
;  :rlimit-count            214994)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3415
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               166
;  :datatype-accessor-ax    230
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   327
;  :datatype-splits         528
;  :decisions               1062
;  :del-clause              141
;  :final-checks            171
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1569
;  :mk-clause               178
;  :num-allocs              4063406
;  :num-checks              256
;  :propagations            308
;  :quant-instantiations    50
;  :rlimit-count            215827)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3466
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               169
;  :datatype-accessor-ax    233
;  :datatype-constructor-ax 911
;  :datatype-occurs-check   335
;  :datatype-splits         541
;  :decisions               1087
;  :del-clause              144
;  :final-checks            175
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1593
;  :mk-clause               181
;  :num-allocs              4063406
;  :num-checks              257
;  :propagations            332
;  :quant-instantiations    50
;  :rlimit-count            216716)
; [then-branch: 49 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == -1) | live]
; [else-branch: 49 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == -1 | live]
(push) ; 4
; [then-branch: 49 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3466
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               169
;  :datatype-accessor-ax    233
;  :datatype-constructor-ax 911
;  :datatype-occurs-check   335
;  :datatype-splits         541
;  :decisions               1087
;  :del-clause              144
;  :final-checks            175
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1593
;  :mk-clause               181
;  :num-allocs              4063406
;  :num-checks              258
;  :propagations            333
;  :quant-instantiations    50
;  :rlimit-count            216900)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3466
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               169
;  :datatype-accessor-ax    233
;  :datatype-constructor-ax 911
;  :datatype-occurs-check   335
;  :datatype-splits         541
;  :decisions               1087
;  :del-clause              144
;  :final-checks            175
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1593
;  :mk-clause               181
;  :num-allocs              4063406
;  :num-checks              259
;  :propagations            333
;  :quant-instantiations    50
;  :rlimit-count            216915)
(pop) ; 4
(push) ; 4
; [else-branch: 49 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3472
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               169
;  :datatype-accessor-ax    234
;  :datatype-constructor-ax 911
;  :datatype-occurs-check   335
;  :datatype-splits         541
;  :decisions               1087
;  :del-clause              144
;  :final-checks            175
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1596
;  :mk-clause               182
;  :num-allocs              4063406
;  :num-checks              260
;  :propagations            333
;  :quant-instantiations    50
;  :rlimit-count            217406)
(push) ; 3
; [then-branch: 50 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0 | live]
; [else-branch: 50 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] != 0 | live]
(push) ; 4
; [then-branch: 50 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    1)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 50 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3472
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               169
;  :datatype-accessor-ax    234
;  :datatype-constructor-ax 911
;  :datatype-occurs-check   335
;  :datatype-splits         541
;  :decisions               1087
;  :del-clause              144
;  :final-checks            175
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1596
;  :mk-clause               182
;  :num-allocs              4063406
;  :num-checks              261
;  :propagations            333
;  :quant-instantiations    50
;  :rlimit-count            217571)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3515
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               170
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 923
;  :datatype-occurs-check   341
;  :datatype-splits         552
;  :decisions               1107
;  :del-clause              145
;  :final-checks            178
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1611
;  :mk-clause               183
;  :num-allocs              4063406
;  :num-checks              262
;  :propagations            357
;  :quant-instantiations    50
;  :rlimit-count            218417)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3569
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               173
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 938
;  :datatype-occurs-check   349
;  :datatype-splits         565
;  :decisions               1132
;  :del-clause              148
;  :final-checks            182
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1635
;  :mk-clause               186
;  :num-allocs              4063406
;  :num-checks              263
;  :propagations            384
;  :quant-instantiations    50
;  :rlimit-count            219322
;  :time                    0.00)
; [then-branch: 51 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == -1) | live]
; [else-branch: 51 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == -1 | live]
(push) ; 4
; [then-branch: 51 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3569
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               173
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 938
;  :datatype-occurs-check   349
;  :datatype-splits         565
;  :decisions               1132
;  :del-clause              148
;  :final-checks            182
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1635
;  :mk-clause               186
;  :num-allocs              4063406
;  :num-checks              264
;  :propagations            385
;  :quant-instantiations    50
;  :rlimit-count            219506)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3569
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               173
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 938
;  :datatype-occurs-check   349
;  :datatype-splits         565
;  :decisions               1132
;  :del-clause              148
;  :final-checks            182
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1635
;  :mk-clause               186
;  :num-allocs              4063406
;  :num-checks              265
;  :propagations            385
;  :quant-instantiations    50
;  :rlimit-count            219521)
(pop) ; 4
(push) ; 4
; [else-branch: 51 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3575
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               173
;  :datatype-accessor-ax    240
;  :datatype-constructor-ax 938
;  :datatype-occurs-check   349
;  :datatype-splits         565
;  :decisions               1132
;  :del-clause              148
;  :final-checks            182
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1638
;  :mk-clause               187
;  :num-allocs              4063406
;  :num-checks              266
;  :propagations            385
;  :quant-instantiations    50
;  :rlimit-count            220022)
(push) ; 3
; [then-branch: 52 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0 | live]
; [else-branch: 52 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] != 0 | live]
(push) ; 4
; [then-branch: 52 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    2)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 52 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3575
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               173
;  :datatype-accessor-ax    240
;  :datatype-constructor-ax 938
;  :datatype-occurs-check   349
;  :datatype-splits         565
;  :decisions               1132
;  :del-clause              148
;  :final-checks            182
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1638
;  :mk-clause               187
;  :num-allocs              4063406
;  :num-checks              267
;  :propagations            385
;  :quant-instantiations    50
;  :rlimit-count            220187)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3619
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               174
;  :datatype-accessor-ax    242
;  :datatype-constructor-ax 950
;  :datatype-occurs-check   355
;  :datatype-splits         576
;  :decisions               1152
;  :del-clause              149
;  :final-checks            185
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1653
;  :mk-clause               188
;  :num-allocs              4063406
;  :num-checks              268
;  :propagations            411
;  :quant-instantiations    50
;  :rlimit-count            221043)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3675
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               177
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 965
;  :datatype-occurs-check   363
;  :datatype-splits         589
;  :decisions               1177
;  :del-clause              152
;  :final-checks            189
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1677
;  :mk-clause               191
;  :num-allocs              4063406
;  :num-checks              269
;  :propagations            440
;  :quant-instantiations    50
;  :rlimit-count            221959)
; [then-branch: 53 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == -1) | live]
; [else-branch: 53 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == -1 | live]
(push) ; 4
; [then-branch: 53 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        2)
      (- 0 1)))))
; [eval] diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3675
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               177
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 965
;  :datatype-occurs-check   363
;  :datatype-splits         589
;  :decisions               1177
;  :del-clause              152
;  :final-checks            189
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1677
;  :mk-clause               191
;  :num-allocs              4063406
;  :num-checks              270
;  :propagations            441
;  :quant-instantiations    50
;  :rlimit-count            222143)
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3675
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               177
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 965
;  :datatype-occurs-check   363
;  :datatype-splits         589
;  :decisions               1177
;  :del-clause              152
;  :final-checks            189
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1677
;  :mk-clause               191
;  :num-allocs              4063406
;  :num-checks              271
;  :propagations            441
;  :quant-instantiations    50
;  :rlimit-count            222158)
(pop) ; 4
(push) ; 4
; [else-branch: 53 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          2)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          2)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3681
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               177
;  :datatype-accessor-ax    246
;  :datatype-constructor-ax 965
;  :datatype-occurs-check   363
;  :datatype-splits         589
;  :decisions               1177
;  :del-clause              152
;  :final-checks            189
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1680
;  :mk-clause               192
;  :num-allocs              4063406
;  :num-checks              272
;  :propagations            441
;  :quant-instantiations    50
;  :rlimit-count            222669)
(push) ; 3
; [then-branch: 54 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0 | live]
; [else-branch: 54 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] != 0 | live]
(push) ; 4
; [then-branch: 54 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    3)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 54 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      3)
    0)))
; [eval] old(diz.Main_event_state[3]) == -1
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3681
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               177
;  :datatype-accessor-ax    246
;  :datatype-constructor-ax 965
;  :datatype-occurs-check   363
;  :datatype-splits         589
;  :decisions               1177
;  :del-clause              152
;  :final-checks            189
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1680
;  :mk-clause               192
;  :num-allocs              4063406
;  :num-checks              273
;  :propagations            441
;  :quant-instantiations    50
;  :rlimit-count            222834)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      3)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      3)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3726
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               178
;  :datatype-accessor-ax    248
;  :datatype-constructor-ax 977
;  :datatype-occurs-check   369
;  :datatype-splits         600
;  :decisions               1197
;  :del-clause              153
;  :final-checks            192
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1695
;  :mk-clause               193
;  :num-allocs              4063406
;  :num-checks              274
;  :propagations            469
;  :quant-instantiations    50
;  :rlimit-count            223700
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        3)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        3)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3784
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               181
;  :datatype-accessor-ax    251
;  :datatype-constructor-ax 992
;  :datatype-occurs-check   377
;  :datatype-splits         613
;  :decisions               1222
;  :del-clause              156
;  :final-checks            196
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1719
;  :mk-clause               196
;  :num-allocs              4063406
;  :num-checks              275
;  :propagations            500
;  :quant-instantiations    50
;  :rlimit-count            224627)
; [then-branch: 55 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == -1) | live]
; [else-branch: 55 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == -1 | live]
(push) ; 4
; [then-branch: 55 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        3)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        3)
      (- 0 1)))))
; [eval] diz.Main_event_state[3] == old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3784
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               181
;  :datatype-accessor-ax    251
;  :datatype-constructor-ax 992
;  :datatype-occurs-check   377
;  :datatype-splits         613
;  :decisions               1222
;  :del-clause              156
;  :final-checks            196
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1719
;  :mk-clause               196
;  :num-allocs              4063406
;  :num-checks              276
;  :propagations            501
;  :quant-instantiations    50
;  :rlimit-count            224811)
; [eval] old(diz.Main_event_state[3])
; [eval] diz.Main_event_state[3]
(push) ; 5
(assert (not (<
  3
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3784
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               181
;  :datatype-accessor-ax    251
;  :datatype-constructor-ax 992
;  :datatype-occurs-check   377
;  :datatype-splits         613
;  :decisions               1222
;  :del-clause              156
;  :final-checks            196
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1719
;  :mk-clause               196
;  :num-allocs              4063406
;  :num-checks              277
;  :propagations            501
;  :quant-instantiations    50
;  :rlimit-count            224826)
(pop) ; 4
(push) ; 4
; [else-branch: 55 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[3] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      3)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          3)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          3)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      3)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      3))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3790
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               181
;  :datatype-accessor-ax    252
;  :datatype-constructor-ax 992
;  :datatype-occurs-check   377
;  :datatype-splits         613
;  :decisions               1222
;  :del-clause              156
;  :final-checks            196
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1722
;  :mk-clause               197
;  :num-allocs              4063406
;  :num-checks              278
;  :propagations            501
;  :quant-instantiations    50
;  :rlimit-count            225347)
(push) ; 3
; [then-branch: 56 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0 | live]
; [else-branch: 56 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] != 0 | live]
(push) ; 4
; [then-branch: 56 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    4)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 56 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      4)
    0)))
; [eval] old(diz.Main_event_state[4]) == -1
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3790
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               181
;  :datatype-accessor-ax    252
;  :datatype-constructor-ax 992
;  :datatype-occurs-check   377
;  :datatype-splits         613
;  :decisions               1222
;  :del-clause              156
;  :final-checks            196
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1722
;  :mk-clause               197
;  :num-allocs              4063406
;  :num-checks              279
;  :propagations            501
;  :quant-instantiations    50
;  :rlimit-count            225512)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      4)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      4)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3836
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               182
;  :datatype-accessor-ax    254
;  :datatype-constructor-ax 1004
;  :datatype-occurs-check   383
;  :datatype-splits         624
;  :decisions               1242
;  :del-clause              157
;  :final-checks            199
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1737
;  :mk-clause               198
;  :num-allocs              4063406
;  :num-checks              280
;  :propagations            531
;  :quant-instantiations    50
;  :rlimit-count            226388)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        4)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        4)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3896
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               185
;  :datatype-accessor-ax    257
;  :datatype-constructor-ax 1019
;  :datatype-occurs-check   391
;  :datatype-splits         637
;  :decisions               1267
;  :del-clause              160
;  :final-checks            203
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1761
;  :mk-clause               201
;  :num-allocs              4063406
;  :num-checks              281
;  :propagations            564
;  :quant-instantiations    50
;  :rlimit-count            227326
;  :time                    0.00)
; [then-branch: 57 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == -1) | live]
; [else-branch: 57 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == -1 | live]
(push) ; 4
; [then-branch: 57 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        4)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        4)
      (- 0 1)))))
; [eval] diz.Main_event_state[4] == old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3896
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               185
;  :datatype-accessor-ax    257
;  :datatype-constructor-ax 1019
;  :datatype-occurs-check   391
;  :datatype-splits         637
;  :decisions               1267
;  :del-clause              160
;  :final-checks            203
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1761
;  :mk-clause               201
;  :num-allocs              4063406
;  :num-checks              282
;  :propagations            565
;  :quant-instantiations    50
;  :rlimit-count            227510)
; [eval] old(diz.Main_event_state[4])
; [eval] diz.Main_event_state[4]
(push) ; 5
(assert (not (<
  4
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3896
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               185
;  :datatype-accessor-ax    257
;  :datatype-constructor-ax 1019
;  :datatype-occurs-check   391
;  :datatype-splits         637
;  :decisions               1267
;  :del-clause              160
;  :final-checks            203
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1761
;  :mk-clause               201
;  :num-allocs              4063406
;  :num-checks              283
;  :propagations            565
;  :quant-instantiations    50
;  :rlimit-count            227525)
(pop) ; 4
(push) ; 4
; [else-branch: 57 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[4] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      4)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          4)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          4)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      4)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      4))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@86@02))))))))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3898
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               185
;  :datatype-accessor-ax    257
;  :datatype-constructor-ax 1019
;  :datatype-occurs-check   391
;  :datatype-splits         637
;  :decisions               1267
;  :del-clause              160
;  :final-checks            203
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1763
;  :mk-clause               202
;  :num-allocs              4063406
;  :num-checks              284
;  :propagations            565
;  :quant-instantiations    50
;  :rlimit-count            227964)
(push) ; 3
; [then-branch: 58 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0 | live]
; [else-branch: 58 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] != 0 | live]
(push) ; 4
; [then-branch: 58 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
    5)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 58 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      5)
    0)))
; [eval] old(diz.Main_event_state[5]) == -1
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3898
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               185
;  :datatype-accessor-ax    257
;  :datatype-constructor-ax 1019
;  :datatype-occurs-check   391
;  :datatype-splits         637
;  :decisions               1267
;  :del-clause              160
;  :final-checks            203
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1763
;  :mk-clause               202
;  :num-allocs              4063406
;  :num-checks              285
;  :propagations            565
;  :quant-instantiations    50
;  :rlimit-count            228129)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      5)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      5)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3942
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               186
;  :datatype-accessor-ax    259
;  :datatype-constructor-ax 1030
;  :datatype-occurs-check   397
;  :datatype-splits         646
;  :decisions               1286
;  :del-clause              161
;  :final-checks            206
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1776
;  :mk-clause               203
;  :num-allocs              4063406
;  :num-checks              286
;  :propagations            597
;  :quant-instantiations    50
;  :rlimit-count            229001)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        5)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        5)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4001
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               189
;  :datatype-accessor-ax    262
;  :datatype-constructor-ax 1044
;  :datatype-occurs-check   405
;  :datatype-splits         657
;  :decisions               1310
;  :del-clause              164
;  :final-checks            210
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1798
;  :mk-clause               206
;  :num-allocs              4063406
;  :num-checks              287
;  :propagations            632
;  :quant-instantiations    50
;  :rlimit-count            229936)
; [then-branch: 59 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == -1) | live]
; [else-branch: 59 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == -1 | live]
(push) ; 4
; [then-branch: 59 | !(First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        5)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
        5)
      (- 0 1)))))
; [eval] diz.Main_event_state[5] == old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4001
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               189
;  :datatype-accessor-ax    262
;  :datatype-constructor-ax 1044
;  :datatype-occurs-check   405
;  :datatype-splits         657
;  :decisions               1310
;  :del-clause              164
;  :final-checks            210
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1798
;  :mk-clause               206
;  :num-allocs              4063406
;  :num-checks              288
;  :propagations            633
;  :quant-instantiations    50
;  :rlimit-count            230120)
; [eval] old(diz.Main_event_state[5])
; [eval] diz.Main_event_state[5]
(push) ; 5
(assert (not (<
  5
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4001
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      50
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         2
;  :binary-propagations     22
;  :conflicts               189
;  :datatype-accessor-ax    262
;  :datatype-constructor-ax 1044
;  :datatype-occurs-check   405
;  :datatype-splits         657
;  :decisions               1310
;  :del-clause              164
;  :final-checks            210
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             1798
;  :mk-clause               206
;  :num-allocs              4063406
;  :num-checks              289
;  :propagations            633
;  :quant-instantiations    50
;  :rlimit-count            230135)
(pop) ; 4
(push) ; 4
; [else-branch: 59 | First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == 0 || First:(Second:(Second:(Second:(Second:($t@84@02)))))[5] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      5)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          5)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
          5)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@86@02)))))
      5)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@02))))))
      5))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
