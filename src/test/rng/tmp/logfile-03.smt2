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
; ---------- Rng_bit__EncodedGlobalVariables_Integer_Integer ----------
(declare-const diz@0@03 $Ref)
(declare-const __globals@1@03 $Ref)
(declare-const __var@2@03 Int)
(declare-const __pos@3@03 Int)
(declare-const sys__result@4@03 Int)
(declare-const diz@5@03 $Ref)
(declare-const __globals@6@03 $Ref)
(declare-const __var@7@03 Int)
(declare-const __pos@8@03 Int)
(declare-const sys__result@9@03 Int)
(push) ; 1
(declare-const $t@10@03 $Snap)
(assert (= $t@10@03 ($Snap.combine ($Snap.first $t@10@03) ($Snap.second $t@10@03))))
(assert (= ($Snap.first $t@10@03) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@5@03 $Ref.null)))
(assert (=
  ($Snap.second $t@10@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@10@03))
    ($Snap.second ($Snap.second $t@10@03)))))
(declare-const $k@11@03 $Perm)
(assert ($Perm.isReadVar $k@11@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@11@03 $Perm.No) (< $Perm.No $k@11@03))))
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
;  :max-memory           4.11
;  :memory               3.78
;  :mk-bool-var          274
;  :mk-clause            3
;  :num-allocs           3525731
;  :num-checks           1
;  :propagations         23
;  :quant-instantiations 1
;  :rlimit-count         114172)
(assert (<= $Perm.No $k@11@03))
(assert (<= $k@11@03 $Perm.Write))
(assert (implies (< $Perm.No $k@11@03) (not (= diz@5@03 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@10@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@10@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@10@03))) $Snap.unit))
; [eval] diz.Rng_m != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.02s
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
;  :max-memory           4.11
;  :memory               3.78
;  :mk-bool-var          277
;  :mk-clause            3
;  :num-allocs           3525731
;  :num-checks           2
;  :propagations         23
;  :quant-instantiations 1
;  :rlimit-count         114425)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@10@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
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
;  :max-memory           4.11
;  :memory               3.78
;  :mk-bool-var          280
;  :mk-clause            3
;  :num-allocs           3525731
;  :num-checks           3
;  :propagations         23
;  :quant-instantiations 2
;  :rlimit-count         114709)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.78
;  :mk-bool-var          281
;  :mk-clause            3
;  :num-allocs           3525731
;  :num-checks           4
;  :propagations         23
;  :quant-instantiations 2
;  :rlimit-count         114896)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
  $Snap.unit))
; [eval] |diz.Rng_m.Main_process_state| == 3
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.78
;  :mk-bool-var          283
;  :mk-clause            3
;  :num-allocs           3525731
;  :num-checks           5
;  :propagations         23
;  :quant-instantiations 2
;  :rlimit-count         115125)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.78
;  :mk-bool-var          292
;  :mk-clause            6
;  :num-allocs           3525731
;  :num-checks           6
;  :propagations         24
;  :quant-instantiations 5
;  :rlimit-count         115486)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
  $Snap.unit))
; [eval] |diz.Rng_m.Main_event_state| == 6
; [eval] |diz.Rng_m.Main_event_state|
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.78
;  :mk-bool-var          294
;  :mk-clause            6
;  :num-allocs           3525731
;  :num-checks           7
;  :propagations         24
;  :quant-instantiations 5
;  :rlimit-count         115735
;  :time                 0.00)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Rng_m.Main_process_state[i] } 0 <= i && i < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|)
(declare-const i@12@03 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= i && i < |diz.Rng_m.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 0 | 0 <= i@12@03 | live]
; [else-branch: 0 | !(0 <= i@12@03) | live]
(push) ; 4
; [then-branch: 0 | 0 <= i@12@03]
(assert (<= 0 i@12@03))
; [eval] i < |diz.Rng_m.Main_process_state|
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 5
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          305
;  :mk-clause            9
;  :num-allocs           3645493
;  :num-checks           8
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         116207)
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(0 <= i@12@03)]
(assert (not (<= 0 i@12@03)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 1 | i@12@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i@12@03 | live]
; [else-branch: 1 | !(i@12@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i@12@03) | live]
(push) ; 4
; [then-branch: 1 | i@12@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i@12@03]
(assert (and
  (<
    i@12@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
  (<= 0 i@12@03)))
; [eval] diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i] == -1
; [eval] diz.Rng_m.Main_process_state[i]
(push) ; 5
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          307
;  :mk-clause            9
;  :num-allocs           3645493
;  :num-checks           9
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         116364)
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@12@03 0)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          307
;  :mk-clause            9
;  :num-allocs           3645493
;  :num-checks           10
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         116373)
; [eval] -1
(push) ; 5
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@12@03] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@12@03] != -1 | live]
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@12@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i@12@03)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@12@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
      i@12@03)
    (- 0 1))))
; [eval] 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= diz.Rng_m.Main_process_state[i]
; [eval] diz.Rng_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          308
;  :mk-clause            9
;  :num-allocs           3645493
;  :num-checks           11
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         116599)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i@12@03 0)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          308
;  :mk-clause            9
;  :num-allocs           3645493
;  :num-checks           12
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         116608)
(push) ; 7
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@12@03] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@12@03]) | live]
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@12@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i@12@03)))
; [eval] diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          311
;  :mk-clause            10
;  :num-allocs           3645493
;  :num-checks           13
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         116781)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@12@03 0)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          311
;  :mk-clause            10
;  :num-allocs           3645493
;  :num-checks           14
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         116790)
; [eval] |diz.Rng_m.Main_event_state|
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          311
;  :mk-clause            10
;  :num-allocs           3645493
;  :num-checks           15
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         116838)
(pop) ; 8
(push) ; 8
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@12@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
      i@12@03))))
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
; [else-branch: 1 | !(i@12@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i@12@03)]
(assert (not
  (and
    (<
      i@12@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
    (<= 0 i@12@03))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@12@03 Int)) (!
  (implies
    (and
      (<
        i@12@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
      (<= 0 i@12@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
          i@12@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i@12@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i@12@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i@12@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          313
;  :mk-clause            10
;  :num-allocs           3645493
;  :num-checks           16
;  :propagations         25
;  :quant-instantiations 8
;  :rlimit-count         117493)
(declare-const $k@13@03 $Perm)
(assert ($Perm.isReadVar $k@13@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@13@03 $Perm.No) (< $Perm.No $k@13@03))))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          317
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           17
;  :propagations         26
;  :quant-instantiations 8
;  :rlimit-count         117691)
(assert (<= $Perm.No $k@13@03))
(assert (<= $k@13@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@13@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          320
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           18
;  :propagations         26
;  :quant-instantiations 8
;  :rlimit-count         118024)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          320
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           19
;  :propagations         26
;  :quant-instantiations 8
;  :rlimit-count         118072)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          323
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           20
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         118438
;  :time                 0.00)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          323
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           21
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         118486)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          324
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           22
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         118753)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          324
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           23
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         118801)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          325
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           24
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         119078)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          325
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           25
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         119126)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          326
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           26
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         119413)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          326
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           27
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         119461)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          327
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           28
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         119758)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          327
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           29
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         119806)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          328
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           30
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         120113)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          328
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           31
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         120161)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :conflicts            29
;  :datatype-accessor-ax 19
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          329
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           32
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         120478)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          329
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           33
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         120526)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          330
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           34
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         120853)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          330
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           35
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         120901)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          331
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           36
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         121238)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          331
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           37
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         121286)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          332
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           38
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         121633)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
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
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          332
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           39
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         121681)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            129
;  :arith-assert-diseq   5
;  :arith-assert-lower   16
;  :arith-assert-upper   8
;  :arith-eq-adapter     8
;  :binary-propagations  22
;  :conflicts            37
;  :datatype-accessor-ax 23
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          333
;  :mk-clause            12
;  :num-allocs           3645493
;  :num-checks           40
;  :propagations         26
;  :quant-instantiations 9
;  :rlimit-count         122038)
(declare-const $k@14@03 $Perm)
(assert ($Perm.isReadVar $k@14@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@14@03 $Perm.No) (< $Perm.No $k@14@03))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            129
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   9
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            38
;  :datatype-accessor-ax 23
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          337
;  :mk-clause            14
;  :num-allocs           3645493
;  :num-checks           41
;  :propagations         27
;  :quant-instantiations 9
;  :rlimit-count         122237)
(assert (<= $Perm.No $k@14@03))
(assert (<= $k@14@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@14@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_casr != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            135
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            39
;  :datatype-accessor-ax 24
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          340
;  :mk-clause            14
;  :num-allocs           3645493
;  :num-checks           42
;  :propagations         27
;  :quant-instantiations 9
;  :rlimit-count         122690)
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            135
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            40
;  :datatype-accessor-ax 24
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          340
;  :mk-clause            14
;  :num-allocs           3645493
;  :num-checks           43
;  :propagations         27
;  :quant-instantiations 9
;  :rlimit-count         122738)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            141
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            41
;  :datatype-accessor-ax 25
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          343
;  :mk-clause            14
;  :num-allocs           3645493
;  :num-checks           44
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         123242)
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            141
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            42
;  :datatype-accessor-ax 25
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          343
;  :mk-clause            14
;  :num-allocs           3645493
;  :num-checks           45
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         123290)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            146
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            43
;  :datatype-accessor-ax 26
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          344
;  :mk-clause            14
;  :num-allocs           3645493
;  :num-checks           46
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         123677)
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            146
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            44
;  :datatype-accessor-ax 26
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          344
;  :mk-clause            14
;  :num-allocs           3645493
;  :num-checks           47
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         123725)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            151
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            45
;  :datatype-accessor-ax 27
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          345
;  :mk-clause            14
;  :num-allocs           3645493
;  :num-checks           48
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         124122)
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            151
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            46
;  :datatype-accessor-ax 27
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          345
;  :mk-clause            14
;  :num-allocs           3645493
;  :num-checks           49
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         124170)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            156
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            47
;  :datatype-accessor-ax 28
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          346
;  :mk-clause            14
;  :num-allocs           3645493
;  :num-checks           50
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         124577)
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            156
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            48
;  :datatype-accessor-ax 28
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.88
;  :mk-bool-var          346
;  :mk-clause            14
;  :num-allocs           3645493
;  :num-checks           51
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         124625)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            161
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            49
;  :datatype-accessor-ax 29
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          347
;  :mk-clause            14
;  :num-allocs           3771678
;  :num-checks           52
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         125042)
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            161
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            50
;  :datatype-accessor-ax 29
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          347
;  :mk-clause            14
;  :num-allocs           3771678
;  :num-checks           53
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         125090)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            166
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            51
;  :datatype-accessor-ax 30
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          348
;  :mk-clause            14
;  :num-allocs           3771678
;  :num-checks           54
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         125517)
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            166
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            52
;  :datatype-accessor-ax 30
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          348
;  :mk-clause            14
;  :num-allocs           3771678
;  :num-checks           55
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         125565)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            171
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            53
;  :datatype-accessor-ax 31
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          349
;  :mk-clause            14
;  :num-allocs           3771678
;  :num-checks           56
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         126002)
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            171
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            54
;  :datatype-accessor-ax 31
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          349
;  :mk-clause            14
;  :num-allocs           3771678
;  :num-checks           57
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         126050)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            176
;  :arith-assert-diseq   6
;  :arith-assert-lower   18
;  :arith-assert-upper   10
;  :arith-eq-adapter     9
;  :binary-propagations  22
;  :conflicts            55
;  :datatype-accessor-ax 32
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          350
;  :mk-clause            14
;  :num-allocs           3771678
;  :num-checks           58
;  :propagations         27
;  :quant-instantiations 10
;  :rlimit-count         126497)
(declare-const $k@15@03 $Perm)
(assert ($Perm.isReadVar $k@15@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@15@03 $Perm.No) (< $Perm.No $k@15@03))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            176
;  :arith-assert-diseq   7
;  :arith-assert-lower   20
;  :arith-assert-upper   11
;  :arith-eq-adapter     10
;  :binary-propagations  22
;  :conflicts            56
;  :datatype-accessor-ax 32
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          354
;  :mk-clause            16
;  :num-allocs           3771678
;  :num-checks           59
;  :propagations         28
;  :quant-instantiations 10
;  :rlimit-count         126696)
(assert (<= $Perm.No $k@15@03))
(assert (<= $k@15@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@15@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_lfsr != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            182
;  :arith-assert-diseq   7
;  :arith-assert-lower   20
;  :arith-assert-upper   12
;  :arith-eq-adapter     10
;  :binary-propagations  22
;  :conflicts            57
;  :datatype-accessor-ax 33
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          357
;  :mk-clause            16
;  :num-allocs           3771678
;  :num-checks           60
;  :propagations         28
;  :quant-instantiations 10
;  :rlimit-count         127239)
(push) ; 2
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            182
;  :arith-assert-diseq   7
;  :arith-assert-lower   20
;  :arith-assert-upper   12
;  :arith-eq-adapter     10
;  :binary-propagations  22
;  :conflicts            58
;  :datatype-accessor-ax 33
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          357
;  :mk-clause            16
;  :num-allocs           3771678
;  :num-checks           61
;  :propagations         28
;  :quant-instantiations 10
;  :rlimit-count         127287)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            188
;  :arith-assert-diseq   7
;  :arith-assert-lower   20
;  :arith-assert-upper   12
;  :arith-eq-adapter     10
;  :binary-propagations  22
;  :conflicts            59
;  :datatype-accessor-ax 34
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          360
;  :mk-clause            16
;  :num-allocs           3771678
;  :num-checks           62
;  :propagations         28
;  :quant-instantiations 11
;  :rlimit-count         127875)
(push) ; 2
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            188
;  :arith-assert-diseq   7
;  :arith-assert-lower   20
;  :arith-assert-upper   12
;  :arith-eq-adapter     10
;  :binary-propagations  22
;  :conflicts            60
;  :datatype-accessor-ax 34
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          360
;  :mk-clause            16
;  :num-allocs           3771678
;  :num-checks           63
;  :propagations         28
;  :quant-instantiations 11
;  :rlimit-count         127923)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            193
;  :arith-assert-diseq   7
;  :arith-assert-lower   20
;  :arith-assert-upper   12
;  :arith-eq-adapter     10
;  :binary-propagations  22
;  :conflicts            61
;  :datatype-accessor-ax 35
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          361
;  :mk-clause            16
;  :num-allocs           3771678
;  :num-checks           64
;  :propagations         28
;  :quant-instantiations 11
;  :rlimit-count         128400)
(push) ; 2
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            193
;  :arith-assert-diseq   7
;  :arith-assert-lower   20
;  :arith-assert-upper   12
;  :arith-eq-adapter     10
;  :binary-propagations  22
;  :conflicts            62
;  :datatype-accessor-ax 35
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          361
;  :mk-clause            16
;  :num-allocs           3771678
;  :num-checks           65
;  :propagations         28
;  :quant-instantiations 11
;  :rlimit-count         128448)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            198
;  :arith-assert-diseq   7
;  :arith-assert-lower   20
;  :arith-assert-upper   12
;  :arith-eq-adapter     10
;  :binary-propagations  22
;  :conflicts            63
;  :datatype-accessor-ax 36
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          362
;  :mk-clause            16
;  :num-allocs           3771678
;  :num-checks           66
;  :propagations         28
;  :quant-instantiations 11
;  :rlimit-count         128935)
(declare-const $k@16@03 $Perm)
(assert ($Perm.isReadVar $k@16@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@16@03 $Perm.No) (< $Perm.No $k@16@03))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            198
;  :arith-assert-diseq   8
;  :arith-assert-lower   22
;  :arith-assert-upper   13
;  :arith-eq-adapter     11
;  :binary-propagations  22
;  :conflicts            64
;  :datatype-accessor-ax 36
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          366
;  :mk-clause            18
;  :num-allocs           3771678
;  :num-checks           67
;  :propagations         29
;  :quant-instantiations 11
;  :rlimit-count         129133)
(assert (<= $Perm.No $k@16@03))
(assert (<= $k@16@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@16@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_combinate != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            204
;  :arith-assert-diseq   8
;  :arith-assert-lower   22
;  :arith-assert-upper   14
;  :arith-eq-adapter     11
;  :binary-propagations  22
;  :conflicts            65
;  :datatype-accessor-ax 37
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          369
;  :mk-clause            18
;  :num-allocs           3771678
;  :num-checks           68
;  :propagations         29
;  :quant-instantiations 11
;  :rlimit-count         129716)
(push) ; 2
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            204
;  :arith-assert-diseq   8
;  :arith-assert-lower   22
;  :arith-assert-upper   14
;  :arith-eq-adapter     11
;  :binary-propagations  22
;  :conflicts            66
;  :datatype-accessor-ax 37
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          369
;  :mk-clause            18
;  :num-allocs           3771678
;  :num-checks           69
;  :propagations         29
;  :quant-instantiations 11
;  :rlimit-count         129764)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            210
;  :arith-assert-diseq   8
;  :arith-assert-lower   22
;  :arith-assert-upper   14
;  :arith-eq-adapter     11
;  :binary-propagations  22
;  :conflicts            67
;  :datatype-accessor-ax 38
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          372
;  :mk-clause            18
;  :num-allocs           3771678
;  :num-checks           70
;  :propagations         29
;  :quant-instantiations 12
;  :rlimit-count         130382)
(push) ; 2
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            210
;  :arith-assert-diseq   8
;  :arith-assert-lower   22
;  :arith-assert-upper   14
;  :arith-eq-adapter     11
;  :binary-propagations  22
;  :conflicts            68
;  :datatype-accessor-ax 38
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          372
;  :mk-clause            18
;  :num-allocs           3771678
;  :num-checks           71
;  :propagations         29
;  :quant-instantiations 12
;  :rlimit-count         130430)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            215
;  :arith-assert-diseq   8
;  :arith-assert-lower   22
;  :arith-assert-upper   14
;  :arith-eq-adapter     11
;  :binary-propagations  22
;  :conflicts            69
;  :datatype-accessor-ax 39
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          373
;  :mk-clause            18
;  :num-allocs           3771678
;  :num-checks           72
;  :propagations         29
;  :quant-instantiations 12
;  :rlimit-count         130947)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            215
;  :arith-assert-diseq   8
;  :arith-assert-lower   22
;  :arith-assert-upper   14
;  :arith-eq-adapter     11
;  :binary-propagations  22
;  :conflicts            70
;  :datatype-accessor-ax 39
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          373
;  :mk-clause            18
;  :num-allocs           3771678
;  :num-checks           73
;  :propagations         29
;  :quant-instantiations 12
;  :rlimit-count         130995)
(declare-const $k@17@03 $Perm)
(assert ($Perm.isReadVar $k@17@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@17@03 $Perm.No) (< $Perm.No $k@17@03))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            215
;  :arith-assert-diseq   9
;  :arith-assert-lower   24
;  :arith-assert-upper   15
;  :arith-eq-adapter     12
;  :binary-propagations  22
;  :conflicts            71
;  :datatype-accessor-ax 39
;  :del-clause           1
;  :max-generation       1
;  :max-memory           4.11
;  :memory               3.97
;  :mk-bool-var          377
;  :mk-clause            20
;  :num-allocs           3771678
;  :num-checks           74
;  :propagations         30
;  :quant-instantiations 12
;  :rlimit-count         131194)
(set-option :timeout 10)
(push) ; 2
(assert (not (=
  diz@5@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               295
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      15
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               72
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   3
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             411
;  :mk-clause               21
;  :num-allocs              3902218
;  :num-checks              75
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            132142)
(assert (<= $Perm.No $k@17@03))
(assert (<= $k@17@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@17@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn.Rng_m == diz.Rng_m
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               301
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               73
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   3
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             414
;  :mk-clause               21
;  :num-allocs              3902218
;  :num-checks              76
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            132755)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               301
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               74
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   3
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             414
;  :mk-clause               21
;  :num-allocs              3902218
;  :num-checks              77
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            132803)
(push) ; 2
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               301
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               75
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   3
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             414
;  :mk-clause               21
;  :num-allocs              3902218
;  :num-checks              78
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            132851)
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               301
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               76
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   3
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             414
;  :mk-clause               21
;  :num-allocs              3902218
;  :num-checks              79
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            132899)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn == diz
(push) ; 2
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               305
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               77
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   3
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             417
;  :mk-clause               21
;  :num-allocs              3902218
;  :num-checks              80
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            133492)
(push) ; 2
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               305
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     22
;  :conflicts               78
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   3
;  :datatype-splits         32
;  :decisions               32
;  :del-clause              2
;  :final-checks            3
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             417
;  :mk-clause               21
;  :num-allocs              3902218
;  :num-checks              81
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            133540)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
  diz@5@03))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@18@03 $Snap)
(assert (= $t@18@03 ($Snap.combine ($Snap.first $t@18@03) ($Snap.second $t@18@03))))
(declare-const $k@19@03 $Perm)
(assert ($Perm.isReadVar $k@19@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@19@03 $Perm.No) (< $Perm.No $k@19@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               388
;  :arith-assert-diseq      10
;  :arith-assert-lower      26
;  :arith-assert-upper      17
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               80
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             454
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              83
;  :propagations            31
;  :quant-instantiations    13
;  :rlimit-count            134735)
(assert (<= $Perm.No $k@19@03))
(assert (<= $k@19@03 $Perm.Write))
(assert (implies (< $Perm.No $k@19@03) (not (= diz@5@03 $Ref.null))))
(assert (=
  ($Snap.second $t@18@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@18@03))
    ($Snap.second ($Snap.second $t@18@03)))))
(assert (= ($Snap.first ($Snap.second $t@18@03)) $Snap.unit))
; [eval] diz.Rng_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               394
;  :arith-assert-diseq      10
;  :arith-assert-lower      26
;  :arith-assert-upper      18
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               81
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             457
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              84
;  :propagations            31
;  :quant-instantiations    13
;  :rlimit-count            134978)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@18@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@18@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@18@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               400
;  :arith-assert-diseq      10
;  :arith-assert-lower      26
;  :arith-assert-upper      18
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               82
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             460
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              85
;  :propagations            31
;  :quant-instantiations    14
;  :rlimit-count            135250)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@18@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               405
;  :arith-assert-diseq      10
;  :arith-assert-lower      26
;  :arith-assert-upper      18
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               83
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             461
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              86
;  :propagations            31
;  :quant-instantiations    14
;  :rlimit-count            135427)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))
  $Snap.unit))
; [eval] |diz.Rng_m.Main_process_state| == 3
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               411
;  :arith-assert-diseq      10
;  :arith-assert-lower      26
;  :arith-assert-upper      18
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               84
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             463
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              87
;  :propagations            31
;  :quant-instantiations    14
;  :rlimit-count            135646)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               418
;  :arith-assert-diseq      10
;  :arith-assert-lower      28
;  :arith-assert-upper      19
;  :arith-eq-adapter        14
;  :binary-propagations     22
;  :conflicts               85
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             469
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              88
;  :propagations            31
;  :quant-instantiations    16
;  :rlimit-count            135976)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))
  $Snap.unit))
; [eval] |diz.Rng_m.Main_event_state| == 6
; [eval] |diz.Rng_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               424
;  :arith-assert-diseq      10
;  :arith-assert-lower      28
;  :arith-assert-upper      19
;  :arith-eq-adapter        14
;  :binary-propagations     22
;  :conflicts               86
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             471
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              89
;  :propagations            31
;  :quant-instantiations    16
;  :rlimit-count            136215)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Rng_m.Main_process_state[i] } 0 <= i && i < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|)
(declare-const i@20@03 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= i && i < |diz.Rng_m.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@20@03 | live]
; [else-branch: 4 | !(0 <= i@20@03) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@20@03]
(assert (<= 0 i@20@03))
; [eval] i < |diz.Rng_m.Main_process_state|
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               432
;  :arith-assert-diseq      10
;  :arith-assert-lower      31
;  :arith-assert-upper      20
;  :arith-eq-adapter        15
;  :binary-propagations     22
;  :conflicts               87
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             479
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              90
;  :propagations            31
;  :quant-instantiations    18
;  :rlimit-count            136655)
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@20@03)]
(assert (not (<= 0 i@20@03)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@20@03 < |First:(Second:(Second:(Second:($t@18@03))))| && 0 <= i@20@03 | live]
; [else-branch: 5 | !(i@20@03 < |First:(Second:(Second:(Second:($t@18@03))))| && 0 <= i@20@03) | live]
(push) ; 5
; [then-branch: 5 | i@20@03 < |First:(Second:(Second:(Second:($t@18@03))))| && 0 <= i@20@03]
(assert (and
  (<
    i@20@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))
  (<= 0 i@20@03)))
; [eval] diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i] == -1
; [eval] diz.Rng_m.Main_process_state[i]
(push) ; 6
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               432
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      21
;  :arith-eq-adapter        15
;  :binary-propagations     22
;  :conflicts               88
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             481
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              91
;  :propagations            31
;  :quant-instantiations    18
;  :rlimit-count            136812)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@20@03 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               432
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      21
;  :arith-eq-adapter        15
;  :binary-propagations     22
;  :conflicts               88
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             481
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              92
;  :propagations            31
;  :quant-instantiations    18
;  :rlimit-count            136821)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:($t@18@03))))[i@20@03] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@18@03))))[i@20@03] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@18@03))))[i@20@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))
    i@20@03)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:($t@18@03))))[i@20@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))
      i@20@03)
    (- 0 1))))
; [eval] 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= diz.Rng_m.Main_process_state[i]
; [eval] diz.Rng_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               432
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      21
;  :arith-eq-adapter        15
;  :binary-propagations     22
;  :conflicts               89
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             482
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              93
;  :propagations            31
;  :quant-instantiations    18
;  :rlimit-count            137035)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i@20@03 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               432
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      21
;  :arith-eq-adapter        15
;  :binary-propagations     22
;  :conflicts               89
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             482
;  :mk-clause               24
;  :num-allocs              3902218
;  :num-checks              94
;  :propagations            31
;  :quant-instantiations    18
;  :rlimit-count            137044)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@18@03))))[i@20@03] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@18@03))))[i@20@03]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@18@03))))[i@20@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))
    i@20@03)))
; [eval] diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               432
;  :arith-assert-diseq      11
;  :arith-assert-lower      35
;  :arith-assert-upper      21
;  :arith-eq-adapter        16
;  :binary-propagations     22
;  :conflicts               90
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             485
;  :mk-clause               25
;  :num-allocs              3902218
;  :num-checks              95
;  :propagations            31
;  :quant-instantiations    18
;  :rlimit-count            137206)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i@20@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               432
;  :arith-assert-diseq      11
;  :arith-assert-lower      35
;  :arith-assert-upper      21
;  :arith-eq-adapter        16
;  :binary-propagations     22
;  :conflicts               90
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             485
;  :mk-clause               25
;  :num-allocs              3902218
;  :num-checks              96
;  :propagations            31
;  :quant-instantiations    18
;  :rlimit-count            137215)
; [eval] |diz.Rng_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               432
;  :arith-assert-diseq      11
;  :arith-assert-lower      35
;  :arith-assert-upper      21
;  :arith-eq-adapter        16
;  :binary-propagations     22
;  :conflicts               91
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              20
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             485
;  :mk-clause               25
;  :num-allocs              3902218
;  :num-checks              97
;  :propagations            31
;  :quant-instantiations    18
;  :rlimit-count            137263)
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@18@03))))[i@20@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))
      i@20@03))))
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
; [else-branch: 5 | !(i@20@03 < |First:(Second:(Second:(Second:($t@18@03))))| && 0 <= i@20@03)]
(assert (not
  (and
    (<
      i@20@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))
    (<= 0 i@20@03))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@20@03 Int)) (!
  (implies
    (and
      (<
        i@20@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))
      (<= 0 i@20@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))
          i@20@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))
            i@20@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))
            i@20@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))
    i@20@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               437
;  :arith-assert-diseq      11
;  :arith-assert-lower      35
;  :arith-assert-upper      21
;  :arith-eq-adapter        16
;  :binary-propagations     22
;  :conflicts               92
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             487
;  :mk-clause               25
;  :num-allocs              3902218
;  :num-checks              98
;  :propagations            31
;  :quant-instantiations    18
;  :rlimit-count            137888)
(declare-const $k@21@03 $Perm)
(assert ($Perm.isReadVar $k@21@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@21@03 $Perm.No) (< $Perm.No $k@21@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               437
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      22
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               93
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             491
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              99
;  :propagations            32
;  :quant-instantiations    18
;  :rlimit-count            138087)
(assert (<= $Perm.No $k@21@03))
(assert (<= $k@21@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@21@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@18@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               443
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               94
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             494
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              100
;  :propagations            32
;  :quant-instantiations    18
;  :rlimit-count            138410)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               443
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               95
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             494
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              101
;  :propagations            32
;  :quant-instantiations    18
;  :rlimit-count            138458)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               449
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               96
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             497
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              102
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            138814)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               449
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               97
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             497
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              103
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            138862)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               454
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               98
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             498
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              104
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            139119)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               454
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               99
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             498
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              105
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            139167)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               459
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               100
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             499
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              106
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            139434)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               459
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               101
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             499
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              107
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            139482)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               464
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               102
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             500
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              108
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            139759)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               464
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               103
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             500
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              109
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            139807)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               469
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               104
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             501
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              110
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            140094)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               469
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               105
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             501
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              111
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            140142)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               474
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               106
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             502
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              112
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            140439)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               474
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               107
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             502
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              113
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            140487)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               108
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             503
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              114
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            140794)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               109
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             503
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              115
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            140842)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               484
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               110
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             504
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              116
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            141159)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               484
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               111
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             504
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              117
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            141207)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               489
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               112
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             505
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              118
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            141534)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               489
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               113
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             505
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              119
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            141582)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               494
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               114
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             506
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              120
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            141919)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               494
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               115
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.07
;  :mk-bool-var             506
;  :mk-clause               27
;  :num-allocs              3902218
;  :num-checks              121
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            141967)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               499
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      23
;  :arith-eq-adapter        17
;  :binary-propagations     22
;  :conflicts               116
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             507
;  :mk-clause               27
;  :num-allocs              4040817
;  :num-checks              122
;  :propagations            32
;  :quant-instantiations    19
;  :rlimit-count            142314)
(declare-const $k@22@03 $Perm)
(assert ($Perm.isReadVar $k@22@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@22@03 $Perm.No) (< $Perm.No $k@22@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               499
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      24
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               117
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             511
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              123
;  :propagations            33
;  :quant-instantiations    19
;  :rlimit-count            142512)
(assert (<= $Perm.No $k@22@03))
(assert (<= $k@22@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@22@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@18@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_casr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               505
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               118
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             514
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              124
;  :propagations            33
;  :quant-instantiations    19
;  :rlimit-count            142955)
(push) ; 3
(assert (not (< $Perm.No $k@22@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               505
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               119
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             514
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              125
;  :propagations            33
;  :quant-instantiations    19
;  :rlimit-count            143003)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               511
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               120
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             517
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              126
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            143497)
(push) ; 3
(assert (not (< $Perm.No $k@22@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               511
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               121
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             517
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              127
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            143545)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               516
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               122
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             518
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              128
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            143922)
(push) ; 3
(assert (not (< $Perm.No $k@22@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               516
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             518
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              129
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            143970)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               521
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             519
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              130
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            144357)
(push) ; 3
(assert (not (< $Perm.No $k@22@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               521
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               125
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             519
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              131
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            144405)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               526
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             520
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              132
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            144802)
(push) ; 3
(assert (not (< $Perm.No $k@22@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               526
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               127
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             520
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              133
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            144850)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               531
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               128
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             521
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              134
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            145257)
(push) ; 3
(assert (not (< $Perm.No $k@22@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               531
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               129
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             521
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              135
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            145305)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               536
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               130
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             522
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              136
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            145722)
(push) ; 3
(assert (not (< $Perm.No $k@22@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               536
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               131
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             522
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              137
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            145770)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               541
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             523
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              138
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            146197)
(push) ; 3
(assert (not (< $Perm.No $k@22@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               541
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               133
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             523
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              139
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            146245)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               546
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      25
;  :arith-eq-adapter        18
;  :binary-propagations     22
;  :conflicts               134
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             524
;  :mk-clause               29
;  :num-allocs              4040817
;  :num-checks              140
;  :propagations            33
;  :quant-instantiations    20
;  :rlimit-count            146682)
(declare-const $k@23@03 $Perm)
(assert ($Perm.isReadVar $k@23@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@23@03 $Perm.No) (< $Perm.No $k@23@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               546
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        19
;  :binary-propagations     22
;  :conflicts               135
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             528
;  :mk-clause               31
;  :num-allocs              4040817
;  :num-checks              141
;  :propagations            34
;  :quant-instantiations    20
;  :rlimit-count            146881)
(assert (<= $Perm.No $k@23@03))
(assert (<= $k@23@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@23@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@18@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_lfsr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               552
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-eq-adapter        19
;  :binary-propagations     22
;  :conflicts               136
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             531
;  :mk-clause               31
;  :num-allocs              4040817
;  :num-checks              142
;  :propagations            34
;  :quant-instantiations    20
;  :rlimit-count            147414)
(push) ; 3
(assert (not (< $Perm.No $k@23@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               552
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-eq-adapter        19
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             531
;  :mk-clause               31
;  :num-allocs              4040817
;  :num-checks              143
;  :propagations            34
;  :quant-instantiations    20
;  :rlimit-count            147462)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               558
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-eq-adapter        19
;  :binary-propagations     22
;  :conflicts               138
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             534
;  :mk-clause               31
;  :num-allocs              4040817
;  :num-checks              144
;  :propagations            34
;  :quant-instantiations    21
;  :rlimit-count            148040)
(push) ; 3
(assert (not (< $Perm.No $k@23@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               558
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-eq-adapter        19
;  :binary-propagations     22
;  :conflicts               139
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             534
;  :mk-clause               31
;  :num-allocs              4040817
;  :num-checks              145
;  :propagations            34
;  :quant-instantiations    21
;  :rlimit-count            148088)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               563
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-eq-adapter        19
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             535
;  :mk-clause               31
;  :num-allocs              4040817
;  :num-checks              146
;  :propagations            34
;  :quant-instantiations    21
;  :rlimit-count            148555)
(push) ; 3
(assert (not (< $Perm.No $k@23@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               563
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-eq-adapter        19
;  :binary-propagations     22
;  :conflicts               141
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             535
;  :mk-clause               31
;  :num-allocs              4040817
;  :num-checks              147
;  :propagations            34
;  :quant-instantiations    21
;  :rlimit-count            148603)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               568
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-eq-adapter        19
;  :binary-propagations     22
;  :conflicts               142
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             536
;  :mk-clause               31
;  :num-allocs              4040817
;  :num-checks              148
;  :propagations            34
;  :quant-instantiations    21
;  :rlimit-count            149080)
(declare-const $k@24@03 $Perm)
(assert ($Perm.isReadVar $k@24@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@24@03 $Perm.No) (< $Perm.No $k@24@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               568
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      28
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               143
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             540
;  :mk-clause               33
;  :num-allocs              4040817
;  :num-checks              149
;  :propagations            35
;  :quant-instantiations    21
;  :rlimit-count            149279)
(assert (<= $Perm.No $k@24@03))
(assert (<= $k@24@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@24@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@18@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_combinate != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      29
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               144
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             543
;  :mk-clause               33
;  :num-allocs              4040817
;  :num-checks              150
;  :propagations            35
;  :quant-instantiations    21
;  :rlimit-count            149852)
(push) ; 3
(assert (not (< $Perm.No $k@24@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      29
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               145
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             543
;  :mk-clause               33
;  :num-allocs              4040817
;  :num-checks              151
;  :propagations            35
;  :quant-instantiations    21
;  :rlimit-count            149900)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               580
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      29
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               146
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             546
;  :mk-clause               33
;  :num-allocs              4040817
;  :num-checks              152
;  :propagations            35
;  :quant-instantiations    22
;  :rlimit-count            150508)
(push) ; 3
(assert (not (< $Perm.No $k@24@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               580
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      29
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               147
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             546
;  :mk-clause               33
;  :num-allocs              4040817
;  :num-checks              153
;  :propagations            35
;  :quant-instantiations    22
;  :rlimit-count            150556)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               585
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      29
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               148
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             547
;  :mk-clause               33
;  :num-allocs              4184454
;  :num-checks              154
;  :propagations            35
;  :quant-instantiations    22
;  :rlimit-count            151063)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               585
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      29
;  :arith-eq-adapter        20
;  :binary-propagations     22
;  :conflicts               149
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             547
;  :mk-clause               33
;  :num-allocs              4184454
;  :num-checks              155
;  :propagations            35
;  :quant-instantiations    22
;  :rlimit-count            151111)
(declare-const $k@25@03 $Perm)
(assert ($Perm.isReadVar $k@25@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@25@03 $Perm.No) (< $Perm.No $k@25@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               585
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      30
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               150
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   6
;  :datatype-splits         62
;  :decisions               62
;  :del-clause              21
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             551
;  :mk-clause               35
;  :num-allocs              4184454
;  :num-checks              156
;  :propagations            36
;  :quant-instantiations    22
;  :rlimit-count            151309)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@5@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               910
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      30
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               152
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   14
;  :datatype-splits         161
;  :decisions               180
;  :del-clause              23
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             658
;  :mk-clause               37
;  :num-allocs              4329468
;  :num-checks              157
;  :propagations            37
;  :quant-instantiations    22
;  :rlimit-count            153478
;  :time                    0.00)
(assert (<= $Perm.No $k@25@03))
(assert (<= $k@25@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@25@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03)))))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn.Rng_m == diz.Rng_m
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               916
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      31
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               153
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   14
;  :datatype-splits         161
;  :decisions               180
;  :del-clause              23
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             661
;  :mk-clause               37
;  :num-allocs              4329468
;  :num-checks              158
;  :propagations            37
;  :quant-instantiations    22
;  :rlimit-count            154081)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               916
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      31
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               154
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   14
;  :datatype-splits         161
;  :decisions               180
;  :del-clause              23
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             661
;  :mk-clause               37
;  :num-allocs              4329468
;  :num-checks              159
;  :propagations            37
;  :quant-instantiations    22
;  :rlimit-count            154129)
(push) ; 3
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               916
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      31
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   14
;  :datatype-splits         161
;  :decisions               180
;  :del-clause              23
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             661
;  :mk-clause               37
;  :num-allocs              4329468
;  :num-checks              160
;  :propagations            37
;  :quant-instantiations    22
;  :rlimit-count            154177)
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               916
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      31
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               156
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   14
;  :datatype-splits         161
;  :decisions               180
;  :del-clause              23
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             661
;  :mk-clause               37
;  :num-allocs              4329468
;  :num-checks              161
;  :propagations            37
;  :quant-instantiations    22
;  :rlimit-count            154225)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@18@03))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn == diz
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               921
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      31
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               157
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   14
;  :datatype-splits         161
;  :decisions               180
;  :del-clause              23
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             664
;  :mk-clause               37
;  :num-allocs              4329468
;  :num-checks              162
;  :propagations            37
;  :quant-instantiations    23
;  :rlimit-count            154809)
(push) ; 3
(assert (not (< $Perm.No $k@21@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               921
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      31
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               158
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   14
;  :datatype-splits         161
;  :decisions               180
;  :del-clause              23
;  :final-checks            10
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             664
;  :mk-clause               37
;  :num-allocs              4329468
;  :num-checks              163
;  :propagations            37
;  :quant-instantiations    23
;  :rlimit-count            154857)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@03))))))))))
  diz@5@03))
(pop) ; 2
(push) ; 2
; [exec]
; var sys__local__result__14: Int
(declare-const sys__local__result__14@26@03 Int)
; [exec]
; var globals__15: Ref
(declare-const globals__15@27@03 $Ref)
; [exec]
; var var__16: Int
(declare-const var__16@28@03 Int)
; [exec]
; var pos__17: Int
(declare-const pos__17@29@03 Int)
; [exec]
; var __flatten_3__18: Int
(declare-const __flatten_3__18@30@03 Int)
; [exec]
; var __flatten_4__19: Int
(declare-const __flatten_4__19@31@03 Int)
; [exec]
; var __flatten_5__22: Int
(declare-const __flatten_5__22@32@03 Int)
; [exec]
; globals__15 := __globals
; [exec]
; var__16 := __var
; [exec]
; pos__17 := __pos
; [eval] var__16 == 0
(push) ; 3
(assert (not (not (= __var@7@03 0))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               994
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      31
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               158
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 215
;  :datatype-occurs-check   16
;  :datatype-splits         163
;  :decisions               209
;  :del-clause              35
;  :final-checks            12
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             668
;  :mk-clause               37
;  :num-allocs              4329468
;  :num-checks              164
;  :propagations            38
;  :quant-instantiations    23
;  :rlimit-count            155655)
(push) ; 3
(assert (not (= __var@7@03 0)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1066
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      31
;  :arith-eq-adapter        21
;  :binary-propagations     22
;  :conflicts               158
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             672
;  :mk-clause               37
;  :num-allocs              4329468
;  :num-checks              165
;  :propagations            39
;  :quant-instantiations    23
;  :rlimit-count            156439
;  :time                    0.00)
; [then-branch: 8 | __var@7@03 == 0 | live]
; [else-branch: 8 | __var@7@03 != 0 | live]
(push) ; 3
; [then-branch: 8 | __var@7@03 == 0]
(assert (= __var@7@03 0))
; [exec]
; sys__local__result__14 := 0
; [exec]
; // assert
; assert acc(diz.Rng_m, wildcard) && diz.Rng_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.Rng_m, __globals), write) && (true && (true && acc(diz.Rng_m.Main_process_state, write) && |diz.Rng_m.Main_process_state| == 3 && acc(diz.Rng_m.Main_event_state, write) && |diz.Rng_m.Main_event_state| == 6 && (forall i__20: Int :: { diz.Rng_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__20] == -1 || 0 <= diz.Rng_m.Main_process_state[i__20] && diz.Rng_m.Main_process_state[i__20] < |diz.Rng_m.Main_event_state|)) && acc(diz.Rng_m.Main_rn, wildcard) && diz.Rng_m.Main_rn != null && acc(diz.Rng_m.Main_rn.Rng_clk, write) && acc(diz.Rng_m.Main_rn.Rng_reset, write) && acc(diz.Rng_m.Main_rn.Rng_loadseed_i, write) && acc(diz.Rng_m.Main_rn.Rng_seed_i, write) && acc(diz.Rng_m.Main_rn.Rng_number_o, write) && acc(diz.Rng_m.Main_rn.Rng_LFSR_reg, write) && acc(diz.Rng_m.Main_rn.Rng_CASR_reg, write) && acc(diz.Rng_m.Main_rn.Rng_result, write) && acc(diz.Rng_m.Main_rn.Rng_i, write) && acc(diz.Rng_m.Main_rn.Rng_aux, write) && acc(diz.Rng_m.Main_rn_casr, wildcard) && diz.Rng_m.Main_rn_casr != null && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_var, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_out, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_plus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_minus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_bit_plus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_bit_minus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_i, write) && acc(diz.Rng_m.Main_rn_lfsr, wildcard) && diz.Rng_m.Main_rn_lfsr != null && acc(diz.Rng_m.Main_rn_lfsr.LFSR_LFSR_var, write) && acc(diz.Rng_m.Main_rn_lfsr.LFSR_outbit, write) && acc(diz.Rng_m.Main_rn_combinate, wildcard) && diz.Rng_m.Main_rn_combinate != null && acc(diz.Rng_m.Main_rn_combinate.Combinate_i, write) && acc(diz.Rng_m.Main_rn.Rng_m, wildcard) && diz.Rng_m.Main_rn.Rng_m == diz.Rng_m) && diz.Rng_m.Main_rn == diz
(declare-const $k@33@03 $Perm)
(assert ($Perm.isReadVar $k@33@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@33@03 $Perm.No) (< $Perm.No $k@33@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      17
;  :arith-assert-lower      47
;  :arith-assert-upper      32
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               159
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             677
;  :mk-clause               39
;  :num-allocs              4329468
;  :num-checks              166
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            156673)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@11@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      17
;  :arith-assert-lower      47
;  :arith-assert-upper      32
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               159
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             677
;  :mk-clause               39
;  :num-allocs              4329468
;  :num-checks              167
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            156684)
(assert (< $k@33@03 $k@11@03))
(assert (<= $Perm.No (- $k@11@03 $k@33@03)))
(assert (<= (- $k@11@03 $k@33@03) $Perm.Write))
(assert (implies (< $Perm.No (- $k@11@03 $k@33@03)) (not (= diz@5@03 $Ref.null))))
; [eval] diz.Rng_m != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      17
;  :arith-assert-lower      49
;  :arith-assert-upper      33
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               160
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             680
;  :mk-clause               39
;  :num-allocs              4329468
;  :num-checks              168
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            156892)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      17
;  :arith-assert-lower      49
;  :arith-assert-upper      33
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               161
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             680
;  :mk-clause               39
;  :num-allocs              4329468
;  :num-checks              169
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            156940)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      17
;  :arith-assert-lower      49
;  :arith-assert-upper      33
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               162
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             680
;  :mk-clause               39
;  :num-allocs              4329468
;  :num-checks              170
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            156988)
; [eval] |diz.Rng_m.Main_process_state| == 3
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      17
;  :arith-assert-lower      49
;  :arith-assert-upper      33
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               163
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             680
;  :mk-clause               39
;  :num-allocs              4329468
;  :num-checks              171
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            157036)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      17
;  :arith-assert-lower      49
;  :arith-assert-upper      33
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               164
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             680
;  :mk-clause               39
;  :num-allocs              4329468
;  :num-checks              172
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            157084)
; [eval] |diz.Rng_m.Main_event_state| == 6
; [eval] |diz.Rng_m.Main_event_state|
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      17
;  :arith-assert-lower      49
;  :arith-assert-upper      33
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               165
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             680
;  :mk-clause               39
;  :num-allocs              4329468
;  :num-checks              173
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            157132
;  :time                    0.00)
; [eval] (forall i__20: Int :: { diz.Rng_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__20] == -1 || 0 <= diz.Rng_m.Main_process_state[i__20] && diz.Rng_m.Main_process_state[i__20] < |diz.Rng_m.Main_event_state|)
(declare-const i__20@34@03 Int)
(push) ; 4
; [eval] 0 <= i__20 && i__20 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__20] == -1 || 0 <= diz.Rng_m.Main_process_state[i__20] && diz.Rng_m.Main_process_state[i__20] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= i__20 && i__20 < |diz.Rng_m.Main_process_state|
; [eval] 0 <= i__20
(push) ; 5
; [then-branch: 9 | 0 <= i__20@34@03 | live]
; [else-branch: 9 | !(0 <= i__20@34@03) | live]
(push) ; 6
; [then-branch: 9 | 0 <= i__20@34@03]
(assert (<= 0 i__20@34@03))
; [eval] i__20 < |diz.Rng_m.Main_process_state|
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      17
;  :arith-assert-lower      50
;  :arith-assert-upper      33
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               166
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             681
;  :mk-clause               39
;  :num-allocs              4329468
;  :num-checks              174
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            157233)
(pop) ; 6
(push) ; 6
; [else-branch: 9 | !(0 <= i__20@34@03)]
(assert (not (<= 0 i__20@34@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 10 | i__20@34@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i__20@34@03 | live]
; [else-branch: 10 | !(i__20@34@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i__20@34@03) | live]
(push) ; 6
; [then-branch: 10 | i__20@34@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i__20@34@03]
(assert (and
  (<
    i__20@34@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
  (<= 0 i__20@34@03)))
; [eval] diz.Rng_m.Main_process_state[i__20] == -1 || 0 <= diz.Rng_m.Main_process_state[i__20] && diz.Rng_m.Main_process_state[i__20] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i__20] == -1
; [eval] diz.Rng_m.Main_process_state[i__20]
(push) ; 7
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      17
;  :arith-assert-lower      51
;  :arith-assert-upper      34
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               167
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             683
;  :mk-clause               39
;  :num-allocs              4329468
;  :num-checks              175
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            157390)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i__20@34@03 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      17
;  :arith-assert-lower      51
;  :arith-assert-upper      34
;  :arith-eq-adapter        22
;  :binary-propagations     22
;  :conflicts               167
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             683
;  :mk-clause               39
;  :num-allocs              4329468
;  :num-checks              176
;  :propagations            40
;  :quant-instantiations    23
;  :rlimit-count            157399)
; [eval] -1
(push) ; 7
; [then-branch: 11 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__20@34@03] == -1 | live]
; [else-branch: 11 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__20@34@03] != -1 | live]
(push) ; 8
; [then-branch: 11 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__20@34@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i__20@34@03)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 11 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__20@34@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
      i__20@34@03)
    (- 0 1))))
; [eval] 0 <= diz.Rng_m.Main_process_state[i__20] && diz.Rng_m.Main_process_state[i__20] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= diz.Rng_m.Main_process_state[i__20]
; [eval] diz.Rng_m.Main_process_state[i__20]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      18
;  :arith-assert-lower      54
;  :arith-assert-upper      35
;  :arith-eq-adapter        23
;  :binary-propagations     22
;  :conflicts               168
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             689
;  :mk-clause               43
;  :num-allocs              4329468
;  :num-checks              177
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            157682)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i__20@34@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      18
;  :arith-assert-lower      54
;  :arith-assert-upper      35
;  :arith-eq-adapter        23
;  :binary-propagations     22
;  :conflicts               168
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             689
;  :mk-clause               43
;  :num-allocs              4329468
;  :num-checks              178
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            157691)
(push) ; 9
; [then-branch: 12 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__20@34@03] | live]
; [else-branch: 12 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__20@34@03]) | live]
(push) ; 10
; [then-branch: 12 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__20@34@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i__20@34@03)))
; [eval] diz.Rng_m.Main_process_state[i__20] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i__20]
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      18
;  :arith-assert-lower      54
;  :arith-assert-upper      35
;  :arith-eq-adapter        23
;  :binary-propagations     22
;  :conflicts               169
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             689
;  :mk-clause               43
;  :num-allocs              4329468
;  :num-checks              179
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            157854)
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i__20@34@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      18
;  :arith-assert-lower      54
;  :arith-assert-upper      35
;  :arith-eq-adapter        23
;  :binary-propagations     22
;  :conflicts               169
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             689
;  :mk-clause               43
;  :num-allocs              4329468
;  :num-checks              180
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            157863)
; [eval] |diz.Rng_m.Main_event_state|
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      18
;  :arith-assert-lower      54
;  :arith-assert-upper      35
;  :arith-eq-adapter        23
;  :binary-propagations     22
;  :conflicts               170
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              35
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             689
;  :mk-clause               43
;  :num-allocs              4329468
;  :num-checks              181
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            157911)
(pop) ; 10
(push) ; 10
; [else-branch: 12 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__20@34@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
      i__20@34@03))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 10 | !(i__20@34@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i__20@34@03)]
(assert (not
  (and
    (<
      i__20@34@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
    (<= 0 i__20@34@03))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(set-option :timeout 0)
(push) ; 4
(assert (not (forall ((i__20@34@03 Int)) (!
  (implies
    (and
      (<
        i__20@34@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
      (<= 0 i__20@34@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
          i__20@34@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i__20@34@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i__20@34@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i__20@34@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      19
;  :arith-assert-lower      55
;  :arith-assert-upper      36
;  :arith-eq-adapter        24
;  :binary-propagations     22
;  :conflicts               171
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             697
;  :mk-clause               55
;  :num-allocs              4329468
;  :num-checks              182
;  :propagations            44
;  :quant-instantiations    25
;  :rlimit-count            158369)
(assert (forall ((i__20@34@03 Int)) (!
  (implies
    (and
      (<
        i__20@34@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
      (<= 0 i__20@34@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
          i__20@34@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i__20@34@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i__20@34@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i__20@34@03))
  :qid |prog.l<no position>|)))
(declare-const $k@35@03 $Perm)
(assert ($Perm.isReadVar $k@35@03 $Perm.Write))
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      57
;  :arith-assert-upper      37
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               172
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             702
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              183
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            158946)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@35@03 $Perm.No) (< $Perm.No $k@35@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      57
;  :arith-assert-upper      37
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               173
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             702
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              184
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            158996)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@13@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      57
;  :arith-assert-upper      37
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               173
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             702
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              185
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159007)
(assert (< $k@35@03 $k@13@03))
(assert (<= $Perm.No (- $k@13@03 $k@35@03)))
(assert (<= (- $k@13@03 $k@35@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@13@03 $k@35@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               174
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              186
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159215)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               175
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              187
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159263)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               176
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              188
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159311)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               177
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              189
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159359)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               178
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              190
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159407)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               179
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              191
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159455)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               180
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              192
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159503)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               181
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              193
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159551)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               182
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              194
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159599)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               183
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              195
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159647)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               184
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              196
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159695)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               185
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              197
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159743)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               186
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              198
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159791)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               187
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              199
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159839)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               188
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              200
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159887)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               189
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              201
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159935)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               190
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              202
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            159983)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               191
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              203
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            160031)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               192
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              204
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            160079)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               193
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              205
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            160127)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               194
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              206
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            160175)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      38
;  :arith-eq-adapter        25
;  :binary-propagations     22
;  :conflicts               195
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             705
;  :mk-clause               57
;  :num-allocs              4329468
;  :num-checks              207
;  :propagations            45
;  :quant-instantiations    25
;  :rlimit-count            160223)
(declare-const $k@36@03 $Perm)
(assert ($Perm.isReadVar $k@36@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      39
;  :arith-eq-adapter        26
;  :binary-propagations     22
;  :conflicts               196
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             709
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              208
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            160420)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@36@03 $Perm.No) (< $Perm.No $k@36@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      39
;  :arith-eq-adapter        26
;  :binary-propagations     22
;  :conflicts               197
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             709
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              209
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            160470)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@14@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      39
;  :arith-eq-adapter        26
;  :binary-propagations     22
;  :conflicts               197
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             709
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              210
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            160481)
(assert (< $k@36@03 $k@14@03))
(assert (<= $Perm.No (- $k@14@03 $k@36@03)))
(assert (<= (- $k@14@03 $k@36@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@14@03 $k@36@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn_casr != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               198
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              211
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            160695)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               199
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              212
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            160743)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               200
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              213
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            160791)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               201
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              214
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            160839)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               202
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              215
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            160887)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               203
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              216
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            160935)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               204
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              217
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            160983)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               205
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              218
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            161031)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               206
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              219
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            161079)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               207
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              220
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            161127)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               208
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              221
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            161175)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               209
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              222
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            161223)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               210
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              223
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            161271)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               211
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              224
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            161319)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               212
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              225
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            161367)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      21
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        26
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               213
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             712
;  :mk-clause               59
;  :num-allocs              4329468
;  :num-checks              226
;  :propagations            46
;  :quant-instantiations    25
;  :rlimit-count            161415)
(declare-const $k@37@03 $Perm)
(assert ($Perm.isReadVar $k@37@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      41
;  :arith-eq-adapter        27
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               214
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             716
;  :mk-clause               61
;  :num-allocs              4329468
;  :num-checks              227
;  :propagations            47
;  :quant-instantiations    25
;  :rlimit-count            161611)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@37@03 $Perm.No) (< $Perm.No $k@37@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      41
;  :arith-eq-adapter        27
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               215
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             716
;  :mk-clause               61
;  :num-allocs              4329468
;  :num-checks              228
;  :propagations            47
;  :quant-instantiations    25
;  :rlimit-count            161661)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@15@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      41
;  :arith-eq-adapter        27
;  :arith-pivots            1
;  :binary-propagations     22
;  :conflicts               215
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             716
;  :mk-clause               61
;  :num-allocs              4329468
;  :num-checks              229
;  :propagations            47
;  :quant-instantiations    25
;  :rlimit-count            161672)
(assert (< $k@37@03 $k@15@03))
(assert (<= $Perm.No (- $k@15@03 $k@37@03)))
(assert (<= (- $k@15@03 $k@37@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@15@03 $k@37@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn_lfsr != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      22
;  :arith-assert-lower      67
;  :arith-assert-upper      42
;  :arith-eq-adapter        27
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               216
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             719
;  :mk-clause               61
;  :num-allocs              4329468
;  :num-checks              230
;  :propagations            47
;  :quant-instantiations    25
;  :rlimit-count            161892)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      22
;  :arith-assert-lower      67
;  :arith-assert-upper      42
;  :arith-eq-adapter        27
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               217
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             719
;  :mk-clause               61
;  :num-allocs              4329468
;  :num-checks              231
;  :propagations            47
;  :quant-instantiations    25
;  :rlimit-count            161940)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      22
;  :arith-assert-lower      67
;  :arith-assert-upper      42
;  :arith-eq-adapter        27
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               218
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             719
;  :mk-clause               61
;  :num-allocs              4329468
;  :num-checks              232
;  :propagations            47
;  :quant-instantiations    25
;  :rlimit-count            161988)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      22
;  :arith-assert-lower      67
;  :arith-assert-upper      42
;  :arith-eq-adapter        27
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               219
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             719
;  :mk-clause               61
;  :num-allocs              4329468
;  :num-checks              233
;  :propagations            47
;  :quant-instantiations    25
;  :rlimit-count            162036)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      22
;  :arith-assert-lower      67
;  :arith-assert-upper      42
;  :arith-eq-adapter        27
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               220
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             719
;  :mk-clause               61
;  :num-allocs              4329468
;  :num-checks              234
;  :propagations            47
;  :quant-instantiations    25
;  :rlimit-count            162084)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      22
;  :arith-assert-lower      67
;  :arith-assert-upper      42
;  :arith-eq-adapter        27
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               221
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             719
;  :mk-clause               61
;  :num-allocs              4329468
;  :num-checks              235
;  :propagations            47
;  :quant-instantiations    25
;  :rlimit-count            162132)
(declare-const $k@38@03 $Perm)
(assert ($Perm.isReadVar $k@38@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      43
;  :arith-eq-adapter        28
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               222
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             723
;  :mk-clause               63
;  :num-allocs              4329468
;  :num-checks              236
;  :propagations            48
;  :quant-instantiations    25
;  :rlimit-count            162329)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@38@03 $Perm.No) (< $Perm.No $k@38@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      43
;  :arith-eq-adapter        28
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               223
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             723
;  :mk-clause               63
;  :num-allocs              4329468
;  :num-checks              237
;  :propagations            48
;  :quant-instantiations    25
;  :rlimit-count            162379)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@16@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      43
;  :arith-eq-adapter        28
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               223
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             723
;  :mk-clause               63
;  :num-allocs              4329468
;  :num-checks              238
;  :propagations            48
;  :quant-instantiations    25
;  :rlimit-count            162390)
(assert (< $k@38@03 $k@16@03))
(assert (<= $Perm.No (- $k@16@03 $k@38@03)))
(assert (<= (- $k@16@03 $k@38@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@16@03 $k@38@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn_combinate != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      23
;  :arith-assert-lower      71
;  :arith-assert-upper      44
;  :arith-eq-adapter        28
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               224
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             726
;  :mk-clause               63
;  :num-allocs              4329468
;  :num-checks              239
;  :propagations            48
;  :quant-instantiations    25
;  :rlimit-count            162598)
(push) ; 4
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      23
;  :arith-assert-lower      71
;  :arith-assert-upper      44
;  :arith-eq-adapter        28
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               225
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             726
;  :mk-clause               63
;  :num-allocs              4329468
;  :num-checks              240
;  :propagations            48
;  :quant-instantiations    25
;  :rlimit-count            162646)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      23
;  :arith-assert-lower      71
;  :arith-assert-upper      44
;  :arith-eq-adapter        28
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               226
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             726
;  :mk-clause               63
;  :num-allocs              4329468
;  :num-checks              241
;  :propagations            48
;  :quant-instantiations    25
;  :rlimit-count            162694)
(push) ; 4
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      23
;  :arith-assert-lower      71
;  :arith-assert-upper      44
;  :arith-eq-adapter        28
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               227
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             726
;  :mk-clause               63
;  :num-allocs              4329468
;  :num-checks              242
;  :propagations            48
;  :quant-instantiations    25
;  :rlimit-count            162742)
(declare-const $k@39@03 $Perm)
(assert ($Perm.isReadVar $k@39@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      45
;  :arith-eq-adapter        29
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               228
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             730
;  :mk-clause               65
;  :num-allocs              4329468
;  :num-checks              243
;  :propagations            49
;  :quant-instantiations    25
;  :rlimit-count            162938)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      45
;  :arith-eq-adapter        29
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               229
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             730
;  :mk-clause               65
;  :num-allocs              4329468
;  :num-checks              244
;  :propagations            49
;  :quant-instantiations    25
;  :rlimit-count            162986)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@39@03 $Perm.No) (< $Perm.No $k@39@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      45
;  :arith-eq-adapter        29
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               230
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             730
;  :mk-clause               65
;  :num-allocs              4329468
;  :num-checks              245
;  :propagations            49
;  :quant-instantiations    25
;  :rlimit-count            163036)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@17@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      45
;  :arith-eq-adapter        29
;  :arith-pivots            3
;  :binary-propagations     22
;  :conflicts               230
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             730
;  :mk-clause               65
;  :num-allocs              4329468
;  :num-checks              246
;  :propagations            49
;  :quant-instantiations    25
;  :rlimit-count            163047)
(assert (< $k@39@03 $k@17@03))
(assert (<= $Perm.No (- $k@17@03 $k@39@03)))
(assert (<= (- $k@17@03 $k@39@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@17@03 $k@39@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn.Rng_m == diz.Rng_m
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      24
;  :arith-assert-lower      75
;  :arith-assert-upper      46
;  :arith-eq-adapter        29
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               231
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             733
;  :mk-clause               65
;  :num-allocs              4329468
;  :num-checks              247
;  :propagations            49
;  :quant-instantiations    25
;  :rlimit-count            163267)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      24
;  :arith-assert-lower      75
;  :arith-assert-upper      46
;  :arith-eq-adapter        29
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               232
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             733
;  :mk-clause               65
;  :num-allocs              4329468
;  :num-checks              248
;  :propagations            49
;  :quant-instantiations    25
;  :rlimit-count            163315)
(push) ; 4
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      24
;  :arith-assert-lower      75
;  :arith-assert-upper      46
;  :arith-eq-adapter        29
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               233
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             733
;  :mk-clause               65
;  :num-allocs              4329468
;  :num-checks              249
;  :propagations            49
;  :quant-instantiations    25
;  :rlimit-count            163363)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      24
;  :arith-assert-lower      75
;  :arith-assert-upper      46
;  :arith-eq-adapter        29
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               234
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             733
;  :mk-clause               65
;  :num-allocs              4329468
;  :num-checks              250
;  :propagations            49
;  :quant-instantiations    25
;  :rlimit-count            163411)
; [eval] diz.Rng_m.Main_rn == diz
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      24
;  :arith-assert-lower      75
;  :arith-assert-upper      46
;  :arith-eq-adapter        29
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               235
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             733
;  :mk-clause               65
;  :num-allocs              4329468
;  :num-checks              251
;  :propagations            49
;  :quant-instantiations    25
;  :rlimit-count            163459)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      24
;  :arith-assert-lower      75
;  :arith-assert-upper      46
;  :arith-eq-adapter        29
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               236
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             733
;  :mk-clause               65
;  :num-allocs              4329468
;  :num-checks              252
;  :propagations            49
;  :quant-instantiations    25
;  :rlimit-count            163507)
; [exec]
; label __return_bit_
; [exec]
; sys__result := sys__local__result__14
; [exec]
; // assert
; assert acc(diz.Rng_m, wildcard) && diz.Rng_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.Rng_m, __globals), write) && acc(diz.Rng_m.Main_process_state, write) && |diz.Rng_m.Main_process_state| == 3 && acc(diz.Rng_m.Main_event_state, write) && |diz.Rng_m.Main_event_state| == 6 && (forall i__24: Int :: { diz.Rng_m.Main_process_state[i__24] } 0 <= i__24 && i__24 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__24] == -1 || 0 <= diz.Rng_m.Main_process_state[i__24] && diz.Rng_m.Main_process_state[i__24] < |diz.Rng_m.Main_event_state|) && acc(diz.Rng_m.Main_rn, wildcard) && diz.Rng_m.Main_rn != null && acc(diz.Rng_m.Main_rn.Rng_clk, write) && acc(diz.Rng_m.Main_rn.Rng_reset, write) && acc(diz.Rng_m.Main_rn.Rng_loadseed_i, write) && acc(diz.Rng_m.Main_rn.Rng_seed_i, write) && acc(diz.Rng_m.Main_rn.Rng_number_o, write) && acc(diz.Rng_m.Main_rn.Rng_LFSR_reg, write) && acc(diz.Rng_m.Main_rn.Rng_CASR_reg, write) && acc(diz.Rng_m.Main_rn.Rng_result, write) && acc(diz.Rng_m.Main_rn.Rng_i, write) && acc(diz.Rng_m.Main_rn.Rng_aux, write) && acc(diz.Rng_m.Main_rn_casr, wildcard) && diz.Rng_m.Main_rn_casr != null && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_var, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_out, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_plus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_minus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_bit_plus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_bit_minus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_i, write) && acc(diz.Rng_m.Main_rn_lfsr, wildcard) && diz.Rng_m.Main_rn_lfsr != null && acc(diz.Rng_m.Main_rn_lfsr.LFSR_LFSR_var, write) && acc(diz.Rng_m.Main_rn_lfsr.LFSR_outbit, write) && acc(diz.Rng_m.Main_rn_combinate, wildcard) && diz.Rng_m.Main_rn_combinate != null && acc(diz.Rng_m.Main_rn_combinate.Combinate_i, write) && acc(diz.Rng_m.Main_rn.Rng_m, wildcard) && diz.Rng_m.Main_rn.Rng_m == diz.Rng_m && diz.Rng_m.Main_rn == diz
(declare-const $k@40@03 $Perm)
(assert ($Perm.isReadVar $k@40@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@40@03 $Perm.No) (< $Perm.No $k@40@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      25
;  :arith-assert-lower      77
;  :arith-assert-upper      47
;  :arith-eq-adapter        30
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               237
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             737
;  :mk-clause               67
;  :num-allocs              4329468
;  :num-checks              253
;  :propagations            50
;  :quant-instantiations    25
;  :rlimit-count            163705)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@11@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      25
;  :arith-assert-lower      77
;  :arith-assert-upper      47
;  :arith-eq-adapter        30
;  :arith-pivots            5
;  :binary-propagations     22
;  :conflicts               237
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             737
;  :mk-clause               67
;  :num-allocs              4329468
;  :num-checks              254
;  :propagations            50
;  :quant-instantiations    25
;  :rlimit-count            163716)
(assert (< $k@40@03 $k@11@03))
(assert (<= $Perm.No (- $k@11@03 $k@40@03)))
(assert (<= (- $k@11@03 $k@40@03) $Perm.Write))
(assert (implies (< $Perm.No (- $k@11@03 $k@40@03)) (not (= diz@5@03 $Ref.null))))
; [eval] diz.Rng_m != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      25
;  :arith-assert-lower      79
;  :arith-assert-upper      48
;  :arith-eq-adapter        30
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               238
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             740
;  :mk-clause               67
;  :num-allocs              4329468
;  :num-checks              255
;  :propagations            50
;  :quant-instantiations    25
;  :rlimit-count            163930)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      25
;  :arith-assert-lower      79
;  :arith-assert-upper      48
;  :arith-eq-adapter        30
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               239
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             740
;  :mk-clause               67
;  :num-allocs              4329468
;  :num-checks              256
;  :propagations            50
;  :quant-instantiations    25
;  :rlimit-count            163978)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      25
;  :arith-assert-lower      79
;  :arith-assert-upper      48
;  :arith-eq-adapter        30
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               240
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             740
;  :mk-clause               67
;  :num-allocs              4329468
;  :num-checks              257
;  :propagations            50
;  :quant-instantiations    25
;  :rlimit-count            164026)
; [eval] |diz.Rng_m.Main_process_state| == 3
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      25
;  :arith-assert-lower      79
;  :arith-assert-upper      48
;  :arith-eq-adapter        30
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               241
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             740
;  :mk-clause               67
;  :num-allocs              4329468
;  :num-checks              258
;  :propagations            50
;  :quant-instantiations    25
;  :rlimit-count            164074)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      25
;  :arith-assert-lower      79
;  :arith-assert-upper      48
;  :arith-eq-adapter        30
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               242
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             740
;  :mk-clause               67
;  :num-allocs              4329468
;  :num-checks              259
;  :propagations            50
;  :quant-instantiations    25
;  :rlimit-count            164122)
; [eval] |diz.Rng_m.Main_event_state| == 6
; [eval] |diz.Rng_m.Main_event_state|
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      25
;  :arith-assert-lower      79
;  :arith-assert-upper      48
;  :arith-eq-adapter        30
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               243
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             740
;  :mk-clause               67
;  :num-allocs              4329468
;  :num-checks              260
;  :propagations            50
;  :quant-instantiations    25
;  :rlimit-count            164170)
; [eval] (forall i__24: Int :: { diz.Rng_m.Main_process_state[i__24] } 0 <= i__24 && i__24 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__24] == -1 || 0 <= diz.Rng_m.Main_process_state[i__24] && diz.Rng_m.Main_process_state[i__24] < |diz.Rng_m.Main_event_state|)
(declare-const i__24@41@03 Int)
(push) ; 4
; [eval] 0 <= i__24 && i__24 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__24] == -1 || 0 <= diz.Rng_m.Main_process_state[i__24] && diz.Rng_m.Main_process_state[i__24] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= i__24 && i__24 < |diz.Rng_m.Main_process_state|
; [eval] 0 <= i__24
(push) ; 5
; [then-branch: 13 | 0 <= i__24@41@03 | live]
; [else-branch: 13 | !(0 <= i__24@41@03) | live]
(push) ; 6
; [then-branch: 13 | 0 <= i__24@41@03]
(assert (<= 0 i__24@41@03))
; [eval] i__24 < |diz.Rng_m.Main_process_state|
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      25
;  :arith-assert-lower      80
;  :arith-assert-upper      48
;  :arith-eq-adapter        30
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               244
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             741
;  :mk-clause               67
;  :num-allocs              4329468
;  :num-checks              261
;  :propagations            50
;  :quant-instantiations    25
;  :rlimit-count            164270)
(pop) ; 6
(push) ; 6
; [else-branch: 13 | !(0 <= i__24@41@03)]
(assert (not (<= 0 i__24@41@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 14 | i__24@41@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i__24@41@03 | live]
; [else-branch: 14 | !(i__24@41@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i__24@41@03) | live]
(push) ; 6
; [then-branch: 14 | i__24@41@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i__24@41@03]
(assert (and
  (<
    i__24@41@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
  (<= 0 i__24@41@03)))
; [eval] diz.Rng_m.Main_process_state[i__24] == -1 || 0 <= diz.Rng_m.Main_process_state[i__24] && diz.Rng_m.Main_process_state[i__24] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i__24] == -1
; [eval] diz.Rng_m.Main_process_state[i__24]
(push) ; 7
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      25
;  :arith-assert-lower      81
;  :arith-assert-upper      49
;  :arith-eq-adapter        30
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               245
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             743
;  :mk-clause               67
;  :num-allocs              4329468
;  :num-checks              262
;  :propagations            50
;  :quant-instantiations    25
;  :rlimit-count            164427)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i__24@41@03 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      25
;  :arith-assert-lower      81
;  :arith-assert-upper      49
;  :arith-eq-adapter        30
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               245
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             743
;  :mk-clause               67
;  :num-allocs              4329468
;  :num-checks              263
;  :propagations            50
;  :quant-instantiations    25
;  :rlimit-count            164436)
; [eval] -1
(push) ; 7
; [then-branch: 15 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__24@41@03] == -1 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__24@41@03] != -1 | live]
(push) ; 8
; [then-branch: 15 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__24@41@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i__24@41@03)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 15 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__24@41@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
      i__24@41@03)
    (- 0 1))))
; [eval] 0 <= diz.Rng_m.Main_process_state[i__24] && diz.Rng_m.Main_process_state[i__24] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= diz.Rng_m.Main_process_state[i__24]
; [eval] diz.Rng_m.Main_process_state[i__24]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      26
;  :arith-assert-lower      84
;  :arith-assert-upper      50
;  :arith-eq-adapter        31
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               246
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             749
;  :mk-clause               71
;  :num-allocs              4329468
;  :num-checks              264
;  :propagations            52
;  :quant-instantiations    27
;  :rlimit-count            164744)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i__24@41@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      26
;  :arith-assert-lower      84
;  :arith-assert-upper      50
;  :arith-eq-adapter        31
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               246
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             749
;  :mk-clause               71
;  :num-allocs              4329468
;  :num-checks              265
;  :propagations            52
;  :quant-instantiations    27
;  :rlimit-count            164753)
(push) ; 9
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__24@41@03] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__24@41@03]) | live]
(push) ; 10
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__24@41@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i__24@41@03)))
; [eval] diz.Rng_m.Main_process_state[i__24] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i__24]
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      26
;  :arith-assert-lower      84
;  :arith-assert-upper      50
;  :arith-eq-adapter        31
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               247
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             749
;  :mk-clause               71
;  :num-allocs              4329468
;  :num-checks              266
;  :propagations            52
;  :quant-instantiations    27
;  :rlimit-count            164916)
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i__24@41@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      26
;  :arith-assert-lower      84
;  :arith-assert-upper      50
;  :arith-eq-adapter        31
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               247
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             749
;  :mk-clause               71
;  :num-allocs              4329468
;  :num-checks              267
;  :propagations            52
;  :quant-instantiations    27
;  :rlimit-count            164925)
; [eval] |diz.Rng_m.Main_event_state|
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      26
;  :arith-assert-lower      84
;  :arith-assert-upper      50
;  :arith-eq-adapter        31
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               248
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              51
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             749
;  :mk-clause               71
;  :num-allocs              4329468
;  :num-checks              268
;  :propagations            52
;  :quant-instantiations    27
;  :rlimit-count            164973)
(pop) ; 10
(push) ; 10
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i__24@41@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
      i__24@41@03))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 14 | !(i__24@41@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i__24@41@03)]
(assert (not
  (and
    (<
      i__24@41@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
    (<= 0 i__24@41@03))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(set-option :timeout 0)
(push) ; 4
(assert (not (forall ((i__24@41@03 Int)) (!
  (implies
    (and
      (<
        i__24@41@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
      (<= 0 i__24@41@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
          i__24@41@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i__24@41@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i__24@41@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i__24@41@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      27
;  :arith-assert-lower      85
;  :arith-assert-upper      51
;  :arith-eq-adapter        32
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               249
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             757
;  :mk-clause               83
;  :num-allocs              4329468
;  :num-checks              269
;  :propagations            54
;  :quant-instantiations    29
;  :rlimit-count            165456)
(assert (forall ((i__24@41@03 Int)) (!
  (implies
    (and
      (<
        i__24@41@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
      (<= 0 i__24@41@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
          i__24@41@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i__24@41@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i__24@41@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i__24@41@03))
  :qid |prog.l<no position>|)))
(declare-const $k@42@03 $Perm)
(assert ($Perm.isReadVar $k@42@03 $Perm.Write))
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      87
;  :arith-assert-upper      52
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               250
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             762
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              270
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166033)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@42@03 $Perm.No) (< $Perm.No $k@42@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      87
;  :arith-assert-upper      52
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               251
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             762
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              271
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166083)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@13@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      87
;  :arith-assert-upper      52
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               251
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             762
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              272
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166094)
(assert (< $k@42@03 $k@13@03))
(assert (<= $Perm.No (- $k@13@03 $k@42@03)))
(assert (<= (- $k@13@03 $k@42@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@13@03 $k@42@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               252
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              273
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166302)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               253
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              274
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166350)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               254
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              275
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166398)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               255
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              276
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166446)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               256
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              277
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166494)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               257
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              278
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166542)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               258
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              279
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166590)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               259
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              280
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166638)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               260
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              281
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166686)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               261
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              282
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166734)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               262
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              283
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166782)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               263
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              284
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166830)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               264
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              285
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166878)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               265
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              286
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166926)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               266
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              287
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            166974)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               267
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              288
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            167022)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               268
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              289
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            167070)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               269
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              290
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            167118)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               270
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              291
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            167166)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               271
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              292
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            167214)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               272
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              293
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            167262)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      28
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-eq-adapter        33
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               273
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             765
;  :mk-clause               85
;  :num-allocs              4329468
;  :num-checks              294
;  :propagations            55
;  :quant-instantiations    29
;  :rlimit-count            167310)
(declare-const $k@43@03 $Perm)
(assert ($Perm.isReadVar $k@43@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      54
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               274
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             769
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              295
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            167507)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@43@03 $Perm.No) (< $Perm.No $k@43@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      54
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               275
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             769
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              296
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            167557)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@14@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-assert-diseq      29
;  :arith-assert-lower      91
;  :arith-assert-upper      54
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               275
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             769
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              297
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            167568)
(assert (< $k@43@03 $k@14@03))
(assert (<= $Perm.No (- $k@14@03 $k@43@03)))
(assert (<= (- $k@14@03 $k@43@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@14@03 $k@43@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn_casr != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               276
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              298
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            167777)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               277
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              299
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            167825)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               278
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              300
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            167873)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               279
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              301
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            167921)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               280
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              302
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            167969)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               281
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              303
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            168017)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               282
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              304
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            168065)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               283
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              305
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            168113)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               284
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              306
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            168161)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               285
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              307
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            168209)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               286
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              308
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            168257)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               287
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              309
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            168305)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               288
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              310
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            168353)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               289
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              311
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            168401)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               290
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              312
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            168449)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-eq-adapter        34
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               291
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             772
;  :mk-clause               87
;  :num-allocs              4329468
;  :num-checks              313
;  :propagations            56
;  :quant-instantiations    29
;  :rlimit-count            168497)
(declare-const $k@44@03 $Perm)
(assert ($Perm.isReadVar $k@44@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      30
;  :arith-assert-lower      95
;  :arith-assert-upper      56
;  :arith-eq-adapter        35
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               292
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             776
;  :mk-clause               89
;  :num-allocs              4329468
;  :num-checks              314
;  :propagations            57
;  :quant-instantiations    29
;  :rlimit-count            168693)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@44@03 $Perm.No) (< $Perm.No $k@44@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      30
;  :arith-assert-lower      95
;  :arith-assert-upper      56
;  :arith-eq-adapter        35
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               293
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             776
;  :mk-clause               89
;  :num-allocs              4329468
;  :num-checks              315
;  :propagations            57
;  :quant-instantiations    29
;  :rlimit-count            168743)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@15@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          1
;  :arith-assert-diseq      30
;  :arith-assert-lower      95
;  :arith-assert-upper      56
;  :arith-eq-adapter        35
;  :arith-pivots            6
;  :binary-propagations     22
;  :conflicts               293
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             776
;  :mk-clause               89
;  :num-allocs              4329468
;  :num-checks              316
;  :propagations            57
;  :quant-instantiations    29
;  :rlimit-count            168754)
(assert (< $k@44@03 $k@15@03))
(assert (<= $Perm.No (- $k@15@03 $k@44@03)))
(assert (<= (- $k@15@03 $k@44@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@15@03 $k@44@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn_lfsr != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      30
;  :arith-assert-lower      97
;  :arith-assert-upper      57
;  :arith-eq-adapter        35
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               294
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             779
;  :mk-clause               89
;  :num-allocs              4329468
;  :num-checks              317
;  :propagations            57
;  :quant-instantiations    29
;  :rlimit-count            168970)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      30
;  :arith-assert-lower      97
;  :arith-assert-upper      57
;  :arith-eq-adapter        35
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               295
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             779
;  :mk-clause               89
;  :num-allocs              4329468
;  :num-checks              318
;  :propagations            57
;  :quant-instantiations    29
;  :rlimit-count            169018)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      30
;  :arith-assert-lower      97
;  :arith-assert-upper      57
;  :arith-eq-adapter        35
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               296
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             779
;  :mk-clause               89
;  :num-allocs              4329468
;  :num-checks              319
;  :propagations            57
;  :quant-instantiations    29
;  :rlimit-count            169066)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      30
;  :arith-assert-lower      97
;  :arith-assert-upper      57
;  :arith-eq-adapter        35
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               297
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             779
;  :mk-clause               89
;  :num-allocs              4329468
;  :num-checks              320
;  :propagations            57
;  :quant-instantiations    29
;  :rlimit-count            169114)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      30
;  :arith-assert-lower      97
;  :arith-assert-upper      57
;  :arith-eq-adapter        35
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               298
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             779
;  :mk-clause               89
;  :num-allocs              4329468
;  :num-checks              321
;  :propagations            57
;  :quant-instantiations    29
;  :rlimit-count            169162)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      30
;  :arith-assert-lower      97
;  :arith-assert-upper      57
;  :arith-eq-adapter        35
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               299
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             779
;  :mk-clause               89
;  :num-allocs              4329468
;  :num-checks              322
;  :propagations            57
;  :quant-instantiations    29
;  :rlimit-count            169210)
(declare-const $k@45@03 $Perm)
(assert ($Perm.isReadVar $k@45@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      31
;  :arith-assert-lower      99
;  :arith-assert-upper      58
;  :arith-eq-adapter        36
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               300
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             783
;  :mk-clause               91
;  :num-allocs              4329468
;  :num-checks              323
;  :propagations            58
;  :quant-instantiations    29
;  :rlimit-count            169407)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@45@03 $Perm.No) (< $Perm.No $k@45@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      31
;  :arith-assert-lower      99
;  :arith-assert-upper      58
;  :arith-eq-adapter        36
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               301
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             783
;  :mk-clause               91
;  :num-allocs              4329468
;  :num-checks              324
;  :propagations            58
;  :quant-instantiations    29
;  :rlimit-count            169457)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@16@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      31
;  :arith-assert-lower      99
;  :arith-assert-upper      58
;  :arith-eq-adapter        36
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               301
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             783
;  :mk-clause               91
;  :num-allocs              4329468
;  :num-checks              325
;  :propagations            58
;  :quant-instantiations    29
;  :rlimit-count            169468)
(assert (< $k@45@03 $k@16@03))
(assert (<= $Perm.No (- $k@16@03 $k@45@03)))
(assert (<= (- $k@16@03 $k@45@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@16@03 $k@45@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn_combinate != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      31
;  :arith-assert-lower      101
;  :arith-assert-upper      59
;  :arith-eq-adapter        36
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               302
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             786
;  :mk-clause               91
;  :num-allocs              4329468
;  :num-checks              326
;  :propagations            58
;  :quant-instantiations    29
;  :rlimit-count            169676)
(push) ; 4
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      31
;  :arith-assert-lower      101
;  :arith-assert-upper      59
;  :arith-eq-adapter        36
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               303
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             786
;  :mk-clause               91
;  :num-allocs              4329468
;  :num-checks              327
;  :propagations            58
;  :quant-instantiations    29
;  :rlimit-count            169724)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      31
;  :arith-assert-lower      101
;  :arith-assert-upper      59
;  :arith-eq-adapter        36
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               304
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             786
;  :mk-clause               91
;  :num-allocs              4329468
;  :num-checks              328
;  :propagations            58
;  :quant-instantiations    29
;  :rlimit-count            169772)
(push) ; 4
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      31
;  :arith-assert-lower      101
;  :arith-assert-upper      59
;  :arith-eq-adapter        36
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               305
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             786
;  :mk-clause               91
;  :num-allocs              4329468
;  :num-checks              329
;  :propagations            58
;  :quant-instantiations    29
;  :rlimit-count            169820)
(declare-const $k@46@03 $Perm)
(assert ($Perm.isReadVar $k@46@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      103
;  :arith-assert-upper      60
;  :arith-eq-adapter        37
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               306
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             790
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              330
;  :propagations            59
;  :quant-instantiations    29
;  :rlimit-count            170016)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      103
;  :arith-assert-upper      60
;  :arith-eq-adapter        37
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               307
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             790
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              331
;  :propagations            59
;  :quant-instantiations    29
;  :rlimit-count            170064)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@46@03 $Perm.No) (< $Perm.No $k@46@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      103
;  :arith-assert-upper      60
;  :arith-eq-adapter        37
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               308
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             790
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              332
;  :propagations            59
;  :quant-instantiations    29
;  :rlimit-count            170114)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@17@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      103
;  :arith-assert-upper      60
;  :arith-eq-adapter        37
;  :arith-pivots            7
;  :binary-propagations     22
;  :conflicts               308
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             790
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              333
;  :propagations            59
;  :quant-instantiations    29
;  :rlimit-count            170125)
(assert (< $k@46@03 $k@17@03))
(assert (<= $Perm.No (- $k@17@03 $k@46@03)))
(assert (<= (- $k@17@03 $k@46@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@17@03 $k@46@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn.Rng_m == diz.Rng_m
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      105
;  :arith-assert-upper      61
;  :arith-eq-adapter        37
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               309
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             793
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              334
;  :propagations            59
;  :quant-instantiations    29
;  :rlimit-count            170339)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      105
;  :arith-assert-upper      61
;  :arith-eq-adapter        37
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               310
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             793
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              335
;  :propagations            59
;  :quant-instantiations    29
;  :rlimit-count            170387)
(push) ; 4
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      105
;  :arith-assert-upper      61
;  :arith-eq-adapter        37
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               311
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             793
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              336
;  :propagations            59
;  :quant-instantiations    29
;  :rlimit-count            170435)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      105
;  :arith-assert-upper      61
;  :arith-eq-adapter        37
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               312
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             793
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              337
;  :propagations            59
;  :quant-instantiations    29
;  :rlimit-count            170483)
; [eval] diz.Rng_m.Main_rn == diz
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      105
;  :arith-assert-upper      61
;  :arith-eq-adapter        37
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               313
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             793
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              338
;  :propagations            59
;  :quant-instantiations    29
;  :rlimit-count            170531)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1067
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      105
;  :arith-assert-upper      61
;  :arith-eq-adapter        37
;  :arith-pivots            8
;  :binary-propagations     22
;  :conflicts               314
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 245
;  :datatype-occurs-check   18
;  :datatype-splits         165
;  :decisions               238
;  :del-clause              67
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             793
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              339
;  :propagations            59
;  :quant-instantiations    29
;  :rlimit-count            170579)
; [exec]
; inhale false
(pop) ; 3
(push) ; 3
; [else-branch: 8 | __var@7@03 != 0]
(assert (not (= __var@7@03 0)))
(pop) ; 3
; [eval] !(var__16 == 0)
; [eval] var__16 == 0
(push) ; 3
(assert (not (= __var@7@03 0)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1139
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      105
;  :arith-assert-upper      61
;  :arith-eq-adapter        37
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               314
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 275
;  :datatype-occurs-check   20
;  :datatype-splits         167
;  :decisions               267
;  :del-clause              91
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             797
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              340
;  :propagations            60
;  :quant-instantiations    29
;  :rlimit-count            171392
;  :time                    0.00)
(push) ; 3
(assert (not (not (= __var@7@03 0))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      32
;  :arith-assert-lower      105
;  :arith-assert-upper      61
;  :arith-eq-adapter        37
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               314
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             801
;  :mk-clause               93
;  :num-allocs              4329468
;  :num-checks              341
;  :propagations            61
;  :quant-instantiations    29
;  :rlimit-count            172162
;  :time                    0.00)
; [then-branch: 17 | __var@7@03 != 0 | live]
; [else-branch: 17 | __var@7@03 == 0 | live]
(push) ; 3
; [then-branch: 17 | __var@7@03 != 0]
(assert (not (= __var@7@03 0)))
; [exec]
; __flatten_4__19 := Rng_exp2__EncodedGlobalVariables_Integer(diz, globals__15, pos__17 + 1)
; [eval] pos__17 + 1
; [eval] diz != null
(declare-const $k@47@03 $Perm)
(assert ($Perm.isReadVar $k@47@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@47@03 $Perm.No) (< $Perm.No $k@47@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      33
;  :arith-assert-lower      107
;  :arith-assert-upper      62
;  :arith-eq-adapter        38
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               315
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             806
;  :mk-clause               95
;  :num-allocs              4329468
;  :num-checks              342
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            172414)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@11@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      33
;  :arith-assert-lower      107
;  :arith-assert-upper      62
;  :arith-eq-adapter        38
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               315
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             806
;  :mk-clause               95
;  :num-allocs              4329468
;  :num-checks              343
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            172425)
(assert (< $k@47@03 $k@11@03))
(assert (<= $Perm.No (- $k@11@03 $k@47@03)))
(assert (<= (- $k@11@03 $k@47@03) $Perm.Write))
(assert (implies (< $Perm.No (- $k@11@03 $k@47@03)) (not (= diz@5@03 $Ref.null))))
; [eval] diz.Rng_m != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      33
;  :arith-assert-lower      109
;  :arith-assert-upper      63
;  :arith-eq-adapter        38
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               316
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             809
;  :mk-clause               95
;  :num-allocs              4329468
;  :num-checks              344
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            172633)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      33
;  :arith-assert-lower      109
;  :arith-assert-upper      63
;  :arith-eq-adapter        38
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               317
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             809
;  :mk-clause               95
;  :num-allocs              4329468
;  :num-checks              345
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            172681)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      33
;  :arith-assert-lower      109
;  :arith-assert-upper      63
;  :arith-eq-adapter        38
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               318
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             809
;  :mk-clause               95
;  :num-allocs              4329468
;  :num-checks              346
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            172729)
; [eval] |diz.Rng_m.Main_process_state| == 3
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      33
;  :arith-assert-lower      109
;  :arith-assert-upper      63
;  :arith-eq-adapter        38
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               319
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             809
;  :mk-clause               95
;  :num-allocs              4329468
;  :num-checks              347
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            172777)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      33
;  :arith-assert-lower      109
;  :arith-assert-upper      63
;  :arith-eq-adapter        38
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               320
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             809
;  :mk-clause               95
;  :num-allocs              4329468
;  :num-checks              348
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            172825)
; [eval] |diz.Rng_m.Main_event_state| == 6
; [eval] |diz.Rng_m.Main_event_state|
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      33
;  :arith-assert-lower      109
;  :arith-assert-upper      63
;  :arith-eq-adapter        38
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               321
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             809
;  :mk-clause               95
;  :num-allocs              4329468
;  :num-checks              349
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            172873)
; [eval] (forall i: Int :: { diz.Rng_m.Main_process_state[i] } 0 <= i && i < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|)
(declare-const i@48@03 Int)
(push) ; 4
; [eval] 0 <= i && i < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= i && i < |diz.Rng_m.Main_process_state|
; [eval] 0 <= i
(push) ; 5
; [then-branch: 18 | 0 <= i@48@03 | live]
; [else-branch: 18 | !(0 <= i@48@03) | live]
(push) ; 6
; [then-branch: 18 | 0 <= i@48@03]
(assert (<= 0 i@48@03))
; [eval] i < |diz.Rng_m.Main_process_state|
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      33
;  :arith-assert-lower      110
;  :arith-assert-upper      63
;  :arith-eq-adapter        38
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               322
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             810
;  :mk-clause               95
;  :num-allocs              4329468
;  :num-checks              350
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            172974)
(pop) ; 6
(push) ; 6
; [else-branch: 18 | !(0 <= i@48@03)]
(assert (not (<= 0 i@48@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 19 | i@48@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i@48@03 | live]
; [else-branch: 19 | !(i@48@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i@48@03) | live]
(push) ; 6
; [then-branch: 19 | i@48@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i@48@03]
(assert (and
  (<
    i@48@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
  (<= 0 i@48@03)))
; [eval] diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i] == -1
; [eval] diz.Rng_m.Main_process_state[i]
(push) ; 7
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      33
;  :arith-assert-lower      111
;  :arith-assert-upper      64
;  :arith-eq-adapter        38
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               323
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             812
;  :mk-clause               95
;  :num-allocs              4329468
;  :num-checks              351
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            173131)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i@48@03 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      33
;  :arith-assert-lower      111
;  :arith-assert-upper      64
;  :arith-eq-adapter        38
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               323
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             812
;  :mk-clause               95
;  :num-allocs              4329468
;  :num-checks              352
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            173140)
; [eval] -1
(push) ; 7
; [then-branch: 20 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@48@03] == -1 | live]
; [else-branch: 20 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@48@03] != -1 | live]
(push) ; 8
; [then-branch: 20 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@48@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i@48@03)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 20 | First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@48@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
      i@48@03)
    (- 0 1))))
; [eval] 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= diz.Rng_m.Main_process_state[i]
; [eval] diz.Rng_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      34
;  :arith-assert-lower      114
;  :arith-assert-upper      65
;  :arith-eq-adapter        39
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               324
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             818
;  :mk-clause               99
;  :num-allocs              4329468
;  :num-checks              353
;  :propagations            64
;  :quant-instantiations    30
;  :rlimit-count            173423)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@48@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      34
;  :arith-assert-lower      114
;  :arith-assert-upper      65
;  :arith-eq-adapter        39
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               324
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             818
;  :mk-clause               99
;  :num-allocs              4329468
;  :num-checks              354
;  :propagations            64
;  :quant-instantiations    30
;  :rlimit-count            173432)
(push) ; 9
; [then-branch: 21 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@48@03] | live]
; [else-branch: 21 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@48@03]) | live]
(push) ; 10
; [then-branch: 21 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@48@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i@48@03)))
; [eval] diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      34
;  :arith-assert-lower      114
;  :arith-assert-upper      65
;  :arith-eq-adapter        39
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               325
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             818
;  :mk-clause               99
;  :num-allocs              4329468
;  :num-checks              355
;  :propagations            64
;  :quant-instantiations    30
;  :rlimit-count            173595)
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@48@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      34
;  :arith-assert-lower      114
;  :arith-assert-upper      65
;  :arith-eq-adapter        39
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               325
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             818
;  :mk-clause               99
;  :num-allocs              4329468
;  :num-checks              356
;  :propagations            64
;  :quant-instantiations    30
;  :rlimit-count            173604)
; [eval] |diz.Rng_m.Main_event_state|
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      34
;  :arith-assert-lower      114
;  :arith-assert-upper      65
;  :arith-eq-adapter        39
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               326
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              91
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             818
;  :mk-clause               99
;  :num-allocs              4329468
;  :num-checks              357
;  :propagations            64
;  :quant-instantiations    30
;  :rlimit-count            173652)
(pop) ; 10
(push) ; 10
; [else-branch: 21 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@03)))))[i@48@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
      i@48@03))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 19 | !(i@48@03 < |First:(Second:(Second:(Second:(Second:($t@10@03)))))| && 0 <= i@48@03)]
(assert (not
  (and
    (<
      i@48@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
    (<= 0 i@48@03))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(set-option :timeout 0)
(push) ; 4
(assert (not (forall ((i@48@03 Int)) (!
  (implies
    (and
      (<
        i@48@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
      (<= 0 i@48@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
          i@48@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i@48@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i@48@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i@48@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      66
;  :arith-eq-adapter        40
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               327
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             826
;  :mk-clause               113
;  :num-allocs              4329468
;  :num-checks              358
;  :propagations            66
;  :quant-instantiations    31
;  :rlimit-count            174110)
(assert (forall ((i@48@03 Int)) (!
  (implies
    (and
      (<
        i@48@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
      (<= 0 i@48@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
          i@48@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i@48@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
            i@48@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    i@48@03))
  :qid |prog.l<no position>|)))
(declare-const $k@49@03 $Perm)
(assert ($Perm.isReadVar $k@49@03 $Perm.Write))
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      117
;  :arith-assert-upper      67
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               328
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             831
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              359
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            174687)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@49@03 $Perm.No) (< $Perm.No $k@49@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      117
;  :arith-assert-upper      67
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               329
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             831
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              360
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            174737)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@13@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      117
;  :arith-assert-upper      67
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               329
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             831
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              361
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            174748)
(assert (< $k@49@03 $k@13@03))
(assert (<= $Perm.No (- $k@13@03 $k@49@03)))
(assert (<= (- $k@13@03 $k@49@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@13@03 $k@49@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               330
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              362
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            174956)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               331
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              363
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175004)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               332
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              364
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175052)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               333
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              365
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175100)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               334
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              366
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175148)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               335
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              367
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175196)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               336
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              368
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175244)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               337
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              369
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175292)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               338
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              370
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175340)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               339
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              371
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175388)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               340
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              372
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175436)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               341
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              373
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175484)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               342
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              374
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175532)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               343
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              375
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175580)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               344
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              376
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175628)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               345
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              377
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175676)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               346
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              378
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175724)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               347
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              379
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175772)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               348
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              380
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175820)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               349
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              381
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175868)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               350
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              382
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175916)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      37
;  :arith-assert-lower      119
;  :arith-assert-upper      68
;  :arith-eq-adapter        41
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               351
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             834
;  :mk-clause               115
;  :num-allocs              4329468
;  :num-checks              383
;  :propagations            67
;  :quant-instantiations    31
;  :rlimit-count            175964)
(declare-const $k@50@03 $Perm)
(assert ($Perm.isReadVar $k@50@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      121
;  :arith-assert-upper      69
;  :arith-eq-adapter        42
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               352
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             838
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              384
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176160)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@50@03 $Perm.No) (< $Perm.No $k@50@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      121
;  :arith-assert-upper      69
;  :arith-eq-adapter        42
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               353
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             838
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              385
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176210)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@14@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      121
;  :arith-assert-upper      69
;  :arith-eq-adapter        42
;  :arith-pivots            14
;  :binary-propagations     22
;  :conflicts               353
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             838
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              386
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176221)
(assert (< $k@50@03 $k@14@03))
(assert (<= $Perm.No (- $k@14@03 $k@50@03)))
(assert (<= (- $k@14@03 $k@50@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@14@03 $k@50@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn_casr != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               354
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              387
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176441)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               355
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              388
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176489)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               356
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              389
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176537)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               357
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              390
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176585)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               358
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              391
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176633)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               359
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              392
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176681)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               360
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              393
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176729)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               361
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              394
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176777)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               362
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              395
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176825)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               363
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              396
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176873)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               364
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              397
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176921)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               365
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              398
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            176969)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               366
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              399
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            177017)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               367
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              400
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            177065)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               368
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              401
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            177113)
(push) ; 4
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      70
;  :arith-eq-adapter        42
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               369
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             841
;  :mk-clause               117
;  :num-allocs              4329468
;  :num-checks              402
;  :propagations            68
;  :quant-instantiations    31
;  :rlimit-count            177161)
(declare-const $k@51@03 $Perm)
(assert ($Perm.isReadVar $k@51@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      39
;  :arith-assert-lower      125
;  :arith-assert-upper      71
;  :arith-eq-adapter        43
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               370
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             845
;  :mk-clause               119
;  :num-allocs              4329468
;  :num-checks              403
;  :propagations            69
;  :quant-instantiations    31
;  :rlimit-count            177358)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@51@03 $Perm.No) (< $Perm.No $k@51@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      39
;  :arith-assert-lower      125
;  :arith-assert-upper      71
;  :arith-eq-adapter        43
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               371
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             845
;  :mk-clause               119
;  :num-allocs              4329468
;  :num-checks              404
;  :propagations            69
;  :quant-instantiations    31
;  :rlimit-count            177408)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@15@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      39
;  :arith-assert-lower      125
;  :arith-assert-upper      71
;  :arith-eq-adapter        43
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               371
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             845
;  :mk-clause               119
;  :num-allocs              4329468
;  :num-checks              405
;  :propagations            69
;  :quant-instantiations    31
;  :rlimit-count            177419)
(assert (< $k@51@03 $k@15@03))
(assert (<= $Perm.No (- $k@15@03 $k@51@03)))
(assert (<= (- $k@15@03 $k@51@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@15@03 $k@51@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn_lfsr != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      39
;  :arith-assert-lower      127
;  :arith-assert-upper      72
;  :arith-eq-adapter        43
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               372
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             848
;  :mk-clause               119
;  :num-allocs              4329468
;  :num-checks              406
;  :propagations            69
;  :quant-instantiations    31
;  :rlimit-count            177627)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      39
;  :arith-assert-lower      127
;  :arith-assert-upper      72
;  :arith-eq-adapter        43
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               373
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             848
;  :mk-clause               119
;  :num-allocs              4329468
;  :num-checks              407
;  :propagations            69
;  :quant-instantiations    31
;  :rlimit-count            177675
;  :time                    0.00)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      39
;  :arith-assert-lower      127
;  :arith-assert-upper      72
;  :arith-eq-adapter        43
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               374
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             848
;  :mk-clause               119
;  :num-allocs              4329468
;  :num-checks              408
;  :propagations            69
;  :quant-instantiations    31
;  :rlimit-count            177723)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      39
;  :arith-assert-lower      127
;  :arith-assert-upper      72
;  :arith-eq-adapter        43
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               375
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             848
;  :mk-clause               119
;  :num-allocs              4329468
;  :num-checks              409
;  :propagations            69
;  :quant-instantiations    31
;  :rlimit-count            177771)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      39
;  :arith-assert-lower      127
;  :arith-assert-upper      72
;  :arith-eq-adapter        43
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               376
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             848
;  :mk-clause               119
;  :num-allocs              4329468
;  :num-checks              410
;  :propagations            69
;  :quant-instantiations    31
;  :rlimit-count            177819)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      39
;  :arith-assert-lower      127
;  :arith-assert-upper      72
;  :arith-eq-adapter        43
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               377
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             848
;  :mk-clause               119
;  :num-allocs              4329468
;  :num-checks              411
;  :propagations            69
;  :quant-instantiations    31
;  :rlimit-count            177867)
(declare-const $k@52@03 $Perm)
(assert ($Perm.isReadVar $k@52@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      40
;  :arith-assert-lower      129
;  :arith-assert-upper      73
;  :arith-eq-adapter        44
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               378
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             852
;  :mk-clause               121
;  :num-allocs              4329468
;  :num-checks              412
;  :propagations            70
;  :quant-instantiations    31
;  :rlimit-count            178064)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@52@03 $Perm.No) (< $Perm.No $k@52@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      40
;  :arith-assert-lower      129
;  :arith-assert-upper      73
;  :arith-eq-adapter        44
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               379
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             852
;  :mk-clause               121
;  :num-allocs              4329468
;  :num-checks              413
;  :propagations            70
;  :quant-instantiations    31
;  :rlimit-count            178114)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@16@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      40
;  :arith-assert-lower      129
;  :arith-assert-upper      73
;  :arith-eq-adapter        44
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               379
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             852
;  :mk-clause               121
;  :num-allocs              4329468
;  :num-checks              414
;  :propagations            70
;  :quant-instantiations    31
;  :rlimit-count            178125)
(assert (< $k@52@03 $k@16@03))
(assert (<= $Perm.No (- $k@16@03 $k@52@03)))
(assert (<= (- $k@16@03 $k@52@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@16@03 $k@52@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn_combinate != null
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      40
;  :arith-assert-lower      131
;  :arith-assert-upper      74
;  :arith-eq-adapter        44
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               380
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             855
;  :mk-clause               121
;  :num-allocs              4329468
;  :num-checks              415
;  :propagations            70
;  :quant-instantiations    31
;  :rlimit-count            178333)
(push) ; 4
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      40
;  :arith-assert-lower      131
;  :arith-assert-upper      74
;  :arith-eq-adapter        44
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               381
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             855
;  :mk-clause               121
;  :num-allocs              4329468
;  :num-checks              416
;  :propagations            70
;  :quant-instantiations    31
;  :rlimit-count            178381)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      40
;  :arith-assert-lower      131
;  :arith-assert-upper      74
;  :arith-eq-adapter        44
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               382
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             855
;  :mk-clause               121
;  :num-allocs              4329468
;  :num-checks              417
;  :propagations            70
;  :quant-instantiations    31
;  :rlimit-count            178429)
(push) ; 4
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      40
;  :arith-assert-lower      131
;  :arith-assert-upper      74
;  :arith-eq-adapter        44
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               383
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             855
;  :mk-clause               121
;  :num-allocs              4329468
;  :num-checks              418
;  :propagations            70
;  :quant-instantiations    31
;  :rlimit-count            178477)
(declare-const $k@53@03 $Perm)
(assert ($Perm.isReadVar $k@53@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      41
;  :arith-assert-lower      133
;  :arith-assert-upper      75
;  :arith-eq-adapter        45
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               384
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             859
;  :mk-clause               123
;  :num-allocs              4329468
;  :num-checks              419
;  :propagations            71
;  :quant-instantiations    31
;  :rlimit-count            178674)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      41
;  :arith-assert-lower      133
;  :arith-assert-upper      75
;  :arith-eq-adapter        45
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               385
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             859
;  :mk-clause               123
;  :num-allocs              4329468
;  :num-checks              420
;  :propagations            71
;  :quant-instantiations    31
;  :rlimit-count            178722)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@53@03 $Perm.No) (< $Perm.No $k@53@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      41
;  :arith-assert-lower      133
;  :arith-assert-upper      75
;  :arith-eq-adapter        45
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               386
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             859
;  :mk-clause               123
;  :num-allocs              4329468
;  :num-checks              421
;  :propagations            71
;  :quant-instantiations    31
;  :rlimit-count            178772)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@17@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      41
;  :arith-assert-lower      133
;  :arith-assert-upper      75
;  :arith-eq-adapter        45
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               386
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             859
;  :mk-clause               123
;  :num-allocs              4329468
;  :num-checks              422
;  :propagations            71
;  :quant-instantiations    31
;  :rlimit-count            178783)
(assert (< $k@53@03 $k@17@03))
(assert (<= $Perm.No (- $k@17@03 $k@53@03)))
(assert (<= (- $k@17@03 $k@53@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@17@03 $k@53@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
      $Ref.null))))
; [eval] diz.Rng_m.Main_rn.Rng_m == diz.Rng_m
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      41
;  :arith-assert-lower      135
;  :arith-assert-upper      76
;  :arith-eq-adapter        45
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               387
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             862
;  :mk-clause               123
;  :num-allocs              4329468
;  :num-checks              423
;  :propagations            71
;  :quant-instantiations    31
;  :rlimit-count            178991)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      41
;  :arith-assert-lower      135
;  :arith-assert-upper      76
;  :arith-eq-adapter        45
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               388
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             862
;  :mk-clause               123
;  :num-allocs              4329468
;  :num-checks              424
;  :propagations            71
;  :quant-instantiations    31
;  :rlimit-count            179039)
(push) ; 4
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      41
;  :arith-assert-lower      135
;  :arith-assert-upper      76
;  :arith-eq-adapter        45
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               389
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             862
;  :mk-clause               123
;  :num-allocs              4329468
;  :num-checks              425
;  :propagations            71
;  :quant-instantiations    31
;  :rlimit-count            179087)
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      41
;  :arith-assert-lower      135
;  :arith-assert-upper      76
;  :arith-eq-adapter        45
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               390
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             862
;  :mk-clause               123
;  :num-allocs              4329468
;  :num-checks              426
;  :propagations            71
;  :quant-instantiations    31
;  :rlimit-count            179135)
; [eval] diz.Rng_m.Main_rn == diz
(push) ; 4
(assert (not (< $Perm.No $k@11@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      41
;  :arith-assert-lower      135
;  :arith-assert-upper      76
;  :arith-eq-adapter        45
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               391
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             862
;  :mk-clause               123
;  :num-allocs              4329468
;  :num-checks              427
;  :propagations            71
;  :quant-instantiations    31
;  :rlimit-count            179183)
(push) ; 4
(assert (not (< $Perm.No $k@13@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1212
;  :arith-add-rows          2
;  :arith-assert-diseq      41
;  :arith-assert-lower      135
;  :arith-assert-upper      76
;  :arith-eq-adapter        45
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               392
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             862
;  :mk-clause               123
;  :num-allocs              4329468
;  :num-checks              428
;  :propagations            71
;  :quant-instantiations    31
;  :rlimit-count            179231)
(declare-const sys__result@54@03 Int)
(declare-const $t@55@03 $Snap)
(assert (= $t@55@03 ($Snap.combine ($Snap.first $t@55@03) ($Snap.second $t@55@03))))
(declare-const $k@56@03 $Perm)
(assert ($Perm.isReadVar $k@56@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@56@03 $Perm.No) (< $Perm.No $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1217
;  :arith-add-rows          2
;  :arith-assert-diseq      42
;  :arith-assert-lower      137
;  :arith-assert-upper      77
;  :arith-eq-adapter        46
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               393
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             867
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              429
;  :propagations            72
;  :quant-instantiations    31
;  :rlimit-count            179517)
(declare-const $t@57@03 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@11@03 $k@47@03))
    (=
      $t@57@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))))
  (implies
    (< $Perm.No $k@56@03)
    (= $t@57@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@55@03))))))
(assert (<= $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03)))
(assert (<= (+ (- $k@11@03 $k@47@03) $k@56@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))
  (not (= diz@5@03 $Ref.null))))
(assert (=
  ($Snap.second $t@55@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@55@03))
    ($Snap.second ($Snap.second $t@55@03)))))
(assert (= ($Snap.first ($Snap.second $t@55@03)) $Snap.unit))
; [eval] diz.Rng_m != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1227
;  :arith-add-rows          3
;  :arith-assert-diseq      42
;  :arith-assert-lower      138
;  :arith-assert-upper      79
;  :arith-conflicts         1
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         1
;  :arith-pivots            19
;  :binary-propagations     22
;  :conflicts               394
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             875
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              430
;  :propagations            72
;  :quant-instantiations    32
;  :rlimit-count            180080)
(assert (not (= $t@57@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@55@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@55@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1233
;  :arith-add-rows          4
;  :arith-assert-diseq      42
;  :arith-assert-lower      138
;  :arith-assert-upper      80
;  :arith-conflicts         2
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         2
;  :arith-pivots            22
;  :binary-propagations     22
;  :conflicts               395
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             878
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              431
;  :propagations            72
;  :quant-instantiations    32
;  :rlimit-count            180357)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@55@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1238
;  :arith-add-rows          5
;  :arith-assert-diseq      42
;  :arith-assert-lower      138
;  :arith-assert-upper      81
;  :arith-conflicts         3
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         3
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               396
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             880
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              432
;  :propagations            72
;  :quant-instantiations    32
;  :rlimit-count            180594)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))
  $Snap.unit))
; [eval] |diz.Rng_m.Main_process_state| == 3
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1244
;  :arith-add-rows          6
;  :arith-assert-diseq      42
;  :arith-assert-lower      138
;  :arith-assert-upper      82
;  :arith-conflicts         4
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         4
;  :arith-pivots            27
;  :binary-propagations     22
;  :conflicts               397
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             883
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              433
;  :propagations            72
;  :quant-instantiations    32
;  :rlimit-count            180878)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1251
;  :arith-add-rows          7
;  :arith-assert-diseq      42
;  :arith-assert-lower      140
;  :arith-assert-upper      84
;  :arith-conflicts         5
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         5
;  :arith-pivots            29
;  :binary-propagations     22
;  :conflicts               398
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             890
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              434
;  :propagations            72
;  :quant-instantiations    34
;  :rlimit-count            181267)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))
  $Snap.unit))
; [eval] |diz.Rng_m.Main_event_state| == 6
; [eval] |diz.Rng_m.Main_event_state|
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1257
;  :arith-add-rows          8
;  :arith-assert-diseq      42
;  :arith-assert-lower      140
;  :arith-assert-upper      85
;  :arith-conflicts         6
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         6
;  :arith-pivots            32
;  :binary-propagations     22
;  :conflicts               399
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             893
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              435
;  :propagations            72
;  :quant-instantiations    34
;  :rlimit-count            181571)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Rng_m.Main_process_state[i] } 0 <= i && i < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|)
(declare-const i@58@03 Int)
(push) ; 4
; [eval] 0 <= i && i < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= i && i < |diz.Rng_m.Main_process_state|
; [eval] 0 <= i
(push) ; 5
; [then-branch: 22 | 0 <= i@58@03 | live]
; [else-branch: 22 | !(0 <= i@58@03) | live]
(push) ; 6
; [then-branch: 22 | 0 <= i@58@03]
(assert (<= 0 i@58@03))
; [eval] i < |diz.Rng_m.Main_process_state|
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1265
;  :arith-add-rows          9
;  :arith-assert-diseq      42
;  :arith-assert-lower      143
;  :arith-assert-upper      87
;  :arith-conflicts         7
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            34
;  :binary-propagations     22
;  :conflicts               400
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             902
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              436
;  :propagations            72
;  :quant-instantiations    36
;  :rlimit-count            182070)
(pop) ; 6
(push) ; 6
; [else-branch: 22 | !(0 <= i@58@03)]
(assert (not (<= 0 i@58@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 23 | i@58@03 < |First:(Second:(Second:(Second:($t@55@03))))| && 0 <= i@58@03 | live]
; [else-branch: 23 | !(i@58@03 < |First:(Second:(Second:(Second:($t@55@03))))| && 0 <= i@58@03) | live]
(push) ; 6
; [then-branch: 23 | i@58@03 < |First:(Second:(Second:(Second:($t@55@03))))| && 0 <= i@58@03]
(assert (and
  (<
    i@58@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))
  (<= 0 i@58@03)))
; [eval] diz.Rng_m.Main_process_state[i] == -1 || 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i] == -1
; [eval] diz.Rng_m.Main_process_state[i]
(push) ; 7
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1265
;  :arith-add-rows          10
;  :arith-assert-diseq      42
;  :arith-assert-lower      144
;  :arith-assert-upper      89
;  :arith-conflicts         8
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         8
;  :arith-pivots            37
;  :binary-propagations     22
;  :conflicts               401
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             905
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              437
;  :propagations            72
;  :quant-instantiations    36
;  :rlimit-count            182292)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i@58@03 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1265
;  :arith-add-rows          10
;  :arith-assert-diseq      42
;  :arith-assert-lower      144
;  :arith-assert-upper      89
;  :arith-conflicts         8
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         8
;  :arith-pivots            37
;  :binary-propagations     22
;  :conflicts               401
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             905
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              438
;  :propagations            72
;  :quant-instantiations    36
;  :rlimit-count            182301)
; [eval] -1
(push) ; 7
; [then-branch: 24 | First:(Second:(Second:(Second:($t@55@03))))[i@58@03] == -1 | live]
; [else-branch: 24 | First:(Second:(Second:(Second:($t@55@03))))[i@58@03] != -1 | live]
(push) ; 8
; [then-branch: 24 | First:(Second:(Second:(Second:($t@55@03))))[i@58@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))
    i@58@03)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 24 | First:(Second:(Second:(Second:($t@55@03))))[i@58@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))
      i@58@03)
    (- 0 1))))
; [eval] 0 <= diz.Rng_m.Main_process_state[i] && diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= diz.Rng_m.Main_process_state[i]
; [eval] diz.Rng_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1265
;  :arith-add-rows          11
;  :arith-assert-diseq      42
;  :arith-assert-lower      144
;  :arith-assert-upper      90
;  :arith-conflicts         9
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         9
;  :arith-pivots            39
;  :binary-propagations     22
;  :conflicts               402
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             907
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              439
;  :propagations            72
;  :quant-instantiations    36
;  :rlimit-count            182575)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@58@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1265
;  :arith-add-rows          11
;  :arith-assert-diseq      42
;  :arith-assert-lower      144
;  :arith-assert-upper      90
;  :arith-conflicts         9
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         9
;  :arith-pivots            39
;  :binary-propagations     22
;  :conflicts               402
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             907
;  :mk-clause               125
;  :num-allocs              4329468
;  :num-checks              440
;  :propagations            72
;  :quant-instantiations    36
;  :rlimit-count            182584)
(push) ; 9
; [then-branch: 25 | 0 <= First:(Second:(Second:(Second:($t@55@03))))[i@58@03] | live]
; [else-branch: 25 | !(0 <= First:(Second:(Second:(Second:($t@55@03))))[i@58@03]) | live]
(push) ; 10
; [then-branch: 25 | 0 <= First:(Second:(Second:(Second:($t@55@03))))[i@58@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))
    i@58@03)))
; [eval] diz.Rng_m.Main_process_state[i] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1265
;  :arith-add-rows          12
;  :arith-assert-diseq      43
;  :arith-assert-lower      147
;  :arith-assert-upper      91
;  :arith-conflicts         10
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         10
;  :arith-pivots            42
;  :binary-propagations     22
;  :conflicts               403
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             911
;  :mk-clause               126
;  :num-allocs              4329468
;  :num-checks              441
;  :propagations            72
;  :quant-instantiations    36
;  :rlimit-count            182812)
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@58@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1265
;  :arith-add-rows          12
;  :arith-assert-diseq      43
;  :arith-assert-lower      147
;  :arith-assert-upper      91
;  :arith-conflicts         10
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         10
;  :arith-pivots            42
;  :binary-propagations     22
;  :conflicts               403
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             911
;  :mk-clause               126
;  :num-allocs              4329468
;  :num-checks              442
;  :propagations            72
;  :quant-instantiations    36
;  :rlimit-count            182821)
; [eval] |diz.Rng_m.Main_event_state|
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1265
;  :arith-add-rows          13
;  :arith-assert-diseq      43
;  :arith-assert-lower      147
;  :arith-assert-upper      92
;  :arith-conflicts         11
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         11
;  :arith-pivots            44
;  :binary-propagations     22
;  :conflicts               404
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              109
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             912
;  :mk-clause               126
;  :num-allocs              4329468
;  :num-checks              443
;  :propagations            72
;  :quant-instantiations    36
;  :rlimit-count            182929)
(pop) ; 10
(push) ; 10
; [else-branch: 25 | !(0 <= First:(Second:(Second:(Second:($t@55@03))))[i@58@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))
      i@58@03))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 23 | !(i@58@03 < |First:(Second:(Second:(Second:($t@55@03))))| && 0 <= i@58@03)]
(assert (not
  (and
    (<
      i@58@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))
    (<= 0 i@58@03))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@58@03 Int)) (!
  (implies
    (and
      (<
        i@58@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))
      (<= 0 i@58@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))
          i@58@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))
            i@58@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))
            i@58@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))
    i@58@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1270
;  :arith-add-rows          14
;  :arith-assert-diseq      43
;  :arith-assert-lower      147
;  :arith-assert-upper      93
;  :arith-conflicts         12
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         12
;  :arith-pivots            47
;  :binary-propagations     22
;  :conflicts               405
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             915
;  :mk-clause               126
;  :num-allocs              4329468
;  :num-checks              444
;  :propagations            72
;  :quant-instantiations    36
;  :rlimit-count            183619)
(declare-const $k@59@03 $Perm)
(assert ($Perm.isReadVar $k@59@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@59@03 $Perm.No) (< $Perm.No $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1270
;  :arith-add-rows          14
;  :arith-assert-diseq      44
;  :arith-assert-lower      149
;  :arith-assert-upper      94
;  :arith-conflicts         12
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         12
;  :arith-pivots            47
;  :binary-propagations     22
;  :conflicts               406
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             919
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              445
;  :propagations            73
;  :quant-instantiations    36
;  :rlimit-count            183818)
(set-option :timeout 10)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1270
;  :arith-add-rows          14
;  :arith-assert-diseq      44
;  :arith-assert-lower      149
;  :arith-assert-upper      94
;  :arith-conflicts         12
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         12
;  :arith-pivots            47
;  :binary-propagations     22
;  :conflicts               406
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             919
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              446
;  :propagations            73
;  :quant-instantiations    36
;  :rlimit-count            183829)
(declare-const $t@60@03 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@13@03 $k@49@03))
    (=
      $t@60@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))
  (implies
    (< $Perm.No $k@59@03)
    (=
      $t@60@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))
(assert (<= $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03)))
(assert (<= (+ (- $k@13@03 $k@49@03) $k@59@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn != null
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1280
;  :arith-add-rows          15
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      96
;  :arith-conflicts         13
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         13
;  :arith-pivots            49
;  :binary-propagations     22
;  :conflicts               407
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             927
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              447
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            184444)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1280
;  :arith-add-rows          15
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      96
;  :arith-conflicts         13
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         13
;  :arith-pivots            49
;  :binary-propagations     22
;  :conflicts               407
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             927
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              448
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            184455)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1280
;  :arith-add-rows          16
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      97
;  :arith-conflicts         14
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         14
;  :arith-pivots            51
;  :binary-propagations     22
;  :conflicts               408
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             928
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              449
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            184562)
(assert (not (= $t@60@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1285
;  :arith-add-rows          17
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      98
;  :arith-conflicts         15
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         15
;  :arith-pivots            54
;  :binary-propagations     22
;  :conflicts               409
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             930
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              450
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            184892)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1285
;  :arith-add-rows          17
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      98
;  :arith-conflicts         15
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         15
;  :arith-pivots            54
;  :binary-propagations     22
;  :conflicts               409
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             930
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              451
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            184903)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1285
;  :arith-add-rows          17
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      99
;  :arith-conflicts         16
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         16
;  :arith-pivots            55
;  :binary-propagations     22
;  :conflicts               410
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             931
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              452
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            184991)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1290
;  :arith-add-rows          18
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      100
;  :arith-conflicts         17
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         17
;  :arith-pivots            57
;  :binary-propagations     22
;  :conflicts               411
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             933
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              453
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            185308)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1290
;  :arith-add-rows          18
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      100
;  :arith-conflicts         17
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         17
;  :arith-pivots            57
;  :binary-propagations     22
;  :conflicts               411
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             933
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              454
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            185319)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1290
;  :arith-add-rows          18
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      101
;  :arith-conflicts         18
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         18
;  :arith-pivots            58
;  :binary-propagations     22
;  :conflicts               412
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             934
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              455
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            185407)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1295
;  :arith-add-rows          19
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      102
;  :arith-conflicts         19
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         19
;  :arith-pivots            61
;  :binary-propagations     22
;  :conflicts               413
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             936
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              456
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            185739)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1295
;  :arith-add-rows          19
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      102
;  :arith-conflicts         19
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         19
;  :arith-pivots            61
;  :binary-propagations     22
;  :conflicts               413
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             936
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              457
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            185750)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1295
;  :arith-add-rows          19
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      103
;  :arith-conflicts         20
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         20
;  :arith-pivots            62
;  :binary-propagations     22
;  :conflicts               414
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             937
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              458
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            185838)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1300
;  :arith-add-rows          20
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      104
;  :arith-conflicts         21
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         21
;  :arith-pivots            64
;  :binary-propagations     22
;  :conflicts               415
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             939
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              459
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            186175)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1300
;  :arith-add-rows          20
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      104
;  :arith-conflicts         21
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         21
;  :arith-pivots            64
;  :binary-propagations     22
;  :conflicts               415
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             939
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              460
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            186186)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1300
;  :arith-add-rows          20
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      105
;  :arith-conflicts         22
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         22
;  :arith-pivots            65
;  :binary-propagations     22
;  :conflicts               416
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             940
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              461
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            186274)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1305
;  :arith-add-rows          21
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      106
;  :arith-conflicts         23
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         23
;  :arith-pivots            68
;  :binary-propagations     22
;  :conflicts               417
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             942
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              462
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            186626)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1305
;  :arith-add-rows          21
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      106
;  :arith-conflicts         23
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         23
;  :arith-pivots            68
;  :binary-propagations     22
;  :conflicts               417
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             942
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              463
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            186637)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1305
;  :arith-add-rows          21
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      107
;  :arith-conflicts         24
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         24
;  :arith-pivots            69
;  :binary-propagations     22
;  :conflicts               418
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             943
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              464
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            186725)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1310
;  :arith-add-rows          22
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      108
;  :arith-conflicts         25
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         25
;  :arith-pivots            71
;  :binary-propagations     22
;  :conflicts               419
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             945
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              465
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            187082)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1310
;  :arith-add-rows          22
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      108
;  :arith-conflicts         25
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         25
;  :arith-pivots            71
;  :binary-propagations     22
;  :conflicts               419
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             945
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              466
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            187093)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1310
;  :arith-add-rows          22
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      109
;  :arith-conflicts         26
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         26
;  :arith-pivots            72
;  :binary-propagations     22
;  :conflicts               420
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             946
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              467
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            187181)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1315
;  :arith-add-rows          23
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      110
;  :arith-conflicts         27
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         27
;  :arith-pivots            75
;  :binary-propagations     22
;  :conflicts               421
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             948
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              468
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            187553)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1315
;  :arith-add-rows          23
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      110
;  :arith-conflicts         27
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         27
;  :arith-pivots            75
;  :binary-propagations     22
;  :conflicts               421
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             948
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              469
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            187564)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1315
;  :arith-add-rows          23
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      111
;  :arith-conflicts         28
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         28
;  :arith-pivots            76
;  :binary-propagations     22
;  :conflicts               422
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             949
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              470
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            187652)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1320
;  :arith-add-rows          24
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      112
;  :arith-conflicts         29
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         29
;  :arith-pivots            78
;  :binary-propagations     22
;  :conflicts               423
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             951
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              471
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            188029)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1320
;  :arith-add-rows          24
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      112
;  :arith-conflicts         29
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         29
;  :arith-pivots            78
;  :binary-propagations     22
;  :conflicts               423
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             951
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              472
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            188040)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1320
;  :arith-add-rows          24
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      113
;  :arith-conflicts         30
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         30
;  :arith-pivots            79
;  :binary-propagations     22
;  :conflicts               424
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             952
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              473
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            188128)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1325
;  :arith-add-rows          25
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      114
;  :arith-conflicts         31
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         31
;  :arith-pivots            82
;  :binary-propagations     22
;  :conflicts               425
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             954
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              474
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            188520)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1325
;  :arith-add-rows          25
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      114
;  :arith-conflicts         31
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         31
;  :arith-pivots            82
;  :binary-propagations     22
;  :conflicts               425
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             954
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              475
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            188531)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1325
;  :arith-add-rows          25
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      115
;  :arith-conflicts         32
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         32
;  :arith-pivots            83
;  :binary-propagations     22
;  :conflicts               426
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             955
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              476
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            188619)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1330
;  :arith-add-rows          26
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      116
;  :arith-conflicts         33
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         33
;  :arith-pivots            85
;  :binary-propagations     22
;  :conflicts               427
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             957
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              477
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            189016)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1330
;  :arith-add-rows          26
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      116
;  :arith-conflicts         33
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         33
;  :arith-pivots            85
;  :binary-propagations     22
;  :conflicts               427
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             957
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              478
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            189027)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1330
;  :arith-add-rows          26
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      117
;  :arith-conflicts         34
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         34
;  :arith-pivots            86
;  :binary-propagations     22
;  :conflicts               428
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             958
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              479
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            189115)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1335
;  :arith-add-rows          27
;  :arith-assert-diseq      44
;  :arith-assert-lower      150
;  :arith-assert-upper      118
;  :arith-conflicts         35
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         35
;  :arith-pivots            89
;  :binary-propagations     22
;  :conflicts               429
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             960
;  :mk-clause               128
;  :num-allocs              4329468
;  :num-checks              480
;  :propagations            73
;  :quant-instantiations    37
;  :rlimit-count            189527)
(declare-const $k@61@03 $Perm)
(assert ($Perm.isReadVar $k@61@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@61@03 $Perm.No) (< $Perm.No $k@61@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1335
;  :arith-add-rows          27
;  :arith-assert-diseq      45
;  :arith-assert-lower      152
;  :arith-assert-upper      119
;  :arith-conflicts         35
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         35
;  :arith-pivots            89
;  :binary-propagations     22
;  :conflicts               430
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             964
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              481
;  :propagations            74
;  :quant-instantiations    37
;  :rlimit-count            189725)
(set-option :timeout 10)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1335
;  :arith-add-rows          27
;  :arith-assert-diseq      45
;  :arith-assert-lower      152
;  :arith-assert-upper      119
;  :arith-conflicts         35
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         35
;  :arith-pivots            89
;  :binary-propagations     22
;  :conflicts               430
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             964
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              482
;  :propagations            74
;  :quant-instantiations    37
;  :rlimit-count            189736)
(declare-const $t@62@03 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@14@03 $k@50@03))
    (=
      $t@62@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))))))))))))
  (implies
    (< $Perm.No $k@61@03)
    (=
      $t@62@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@14@03 $k@50@03) $k@61@03)))
(assert (<= (+ (- $k@14@03 $k@50@03) $k@61@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@14@03 $k@50@03) $k@61@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_casr != null
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1345
;  :arith-add-rows          29
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      121
;  :arith-conflicts         36
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         36
;  :arith-pivots            91
;  :binary-propagations     22
;  :conflicts               431
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             972
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              483
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            190718)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1345
;  :arith-add-rows          29
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      121
;  :arith-conflicts         36
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         36
;  :arith-pivots            91
;  :binary-propagations     22
;  :conflicts               431
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             972
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              484
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            190729)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@14@03 $k@50@03) $k@61@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1345
;  :arith-add-rows          29
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      122
;  :arith-conflicts         37
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         37
;  :arith-pivots            92
;  :binary-propagations     22
;  :conflicts               432
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             973
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              485
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            190813)
(assert (not (= $t@62@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1351
;  :arith-add-rows          30
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      123
;  :arith-conflicts         38
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         38
;  :arith-pivots            95
;  :binary-propagations     22
;  :conflicts               433
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             976
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              486
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            191290)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1351
;  :arith-add-rows          30
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      123
;  :arith-conflicts         38
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         38
;  :arith-pivots            95
;  :binary-propagations     22
;  :conflicts               433
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             976
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              487
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            191301)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@14@03 $k@50@03) $k@61@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1351
;  :arith-add-rows          30
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      124
;  :arith-conflicts         39
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         39
;  :arith-pivots            95
;  :binary-propagations     22
;  :conflicts               434
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             977
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              488
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            191381)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1356
;  :arith-add-rows          31
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      125
;  :arith-conflicts         40
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         40
;  :arith-pivots            97
;  :binary-propagations     22
;  :conflicts               435
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             979
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              489
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            191818)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1356
;  :arith-add-rows          31
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      125
;  :arith-conflicts         40
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         40
;  :arith-pivots            97
;  :binary-propagations     22
;  :conflicts               435
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             979
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              490
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            191829)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@14@03 $k@50@03) $k@61@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1356
;  :arith-add-rows          31
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      126
;  :arith-conflicts         41
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         41
;  :arith-pivots            97
;  :binary-propagations     22
;  :conflicts               436
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             980
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              491
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            191909)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1361
;  :arith-add-rows          32
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      127
;  :arith-conflicts         42
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         42
;  :arith-pivots            100
;  :binary-propagations     22
;  :conflicts               437
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             982
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              492
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            192361)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1361
;  :arith-add-rows          32
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      127
;  :arith-conflicts         42
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         42
;  :arith-pivots            100
;  :binary-propagations     22
;  :conflicts               437
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             982
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              493
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            192372)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@14@03 $k@50@03) $k@61@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1361
;  :arith-add-rows          32
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      128
;  :arith-conflicts         43
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         43
;  :arith-pivots            100
;  :binary-propagations     22
;  :conflicts               438
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             983
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              494
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            192452)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1366
;  :arith-add-rows          33
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      129
;  :arith-conflicts         44
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         44
;  :arith-pivots            102
;  :binary-propagations     22
;  :conflicts               439
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             985
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              495
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            192909)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1366
;  :arith-add-rows          33
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      129
;  :arith-conflicts         44
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         44
;  :arith-pivots            102
;  :binary-propagations     22
;  :conflicts               439
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             985
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              496
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            192920)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@14@03 $k@50@03) $k@61@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1366
;  :arith-add-rows          33
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      130
;  :arith-conflicts         45
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         45
;  :arith-pivots            102
;  :binary-propagations     22
;  :conflicts               440
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             986
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              497
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            193000)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1371
;  :arith-add-rows          34
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      131
;  :arith-conflicts         46
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         46
;  :arith-pivots            105
;  :binary-propagations     22
;  :conflicts               441
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             988
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              498
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            193472)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1371
;  :arith-add-rows          34
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      131
;  :arith-conflicts         46
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         46
;  :arith-pivots            105
;  :binary-propagations     22
;  :conflicts               441
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             988
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              499
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            193483)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@14@03 $k@50@03) $k@61@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1371
;  :arith-add-rows          34
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      132
;  :arith-conflicts         47
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         47
;  :arith-pivots            105
;  :binary-propagations     22
;  :conflicts               442
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             989
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              500
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            193563)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1376
;  :arith-add-rows          35
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      133
;  :arith-conflicts         48
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         48
;  :arith-pivots            107
;  :binary-propagations     22
;  :conflicts               443
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             991
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              501
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            194040)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1376
;  :arith-add-rows          35
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      133
;  :arith-conflicts         48
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         48
;  :arith-pivots            107
;  :binary-propagations     22
;  :conflicts               443
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             991
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              502
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            194051)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@14@03 $k@50@03) $k@61@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1376
;  :arith-add-rows          35
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      134
;  :arith-conflicts         49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         49
;  :arith-pivots            107
;  :binary-propagations     22
;  :conflicts               444
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             992
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              503
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            194131)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1381
;  :arith-add-rows          36
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      135
;  :arith-conflicts         50
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         50
;  :arith-pivots            110
;  :binary-propagations     22
;  :conflicts               445
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             994
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              504
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            194623)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1381
;  :arith-add-rows          36
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      135
;  :arith-conflicts         50
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         50
;  :arith-pivots            110
;  :binary-propagations     22
;  :conflicts               445
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             994
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              505
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            194634)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@14@03 $k@50@03) $k@61@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1381
;  :arith-add-rows          36
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      136
;  :arith-conflicts         51
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         51
;  :arith-pivots            110
;  :binary-propagations     22
;  :conflicts               446
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             995
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              506
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            194714)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1386
;  :arith-add-rows          37
;  :arith-assert-diseq      45
;  :arith-assert-lower      153
;  :arith-assert-upper      137
;  :arith-conflicts         52
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         52
;  :arith-pivots            112
;  :binary-propagations     22
;  :conflicts               447
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             997
;  :mk-clause               130
;  :num-allocs              4329468
;  :num-checks              507
;  :propagations            74
;  :quant-instantiations    38
;  :rlimit-count            195211)
(declare-const $k@63@03 $Perm)
(assert ($Perm.isReadVar $k@63@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@63@03 $Perm.No) (< $Perm.No $k@63@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1386
;  :arith-add-rows          37
;  :arith-assert-diseq      46
;  :arith-assert-lower      155
;  :arith-assert-upper      138
;  :arith-conflicts         52
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         52
;  :arith-pivots            112
;  :binary-propagations     22
;  :conflicts               448
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1001
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              508
;  :propagations            75
;  :quant-instantiations    38
;  :rlimit-count            195410)
(set-option :timeout 10)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1386
;  :arith-add-rows          37
;  :arith-assert-diseq      46
;  :arith-assert-lower      155
;  :arith-assert-upper      138
;  :arith-conflicts         52
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         52
;  :arith-pivots            112
;  :binary-propagations     22
;  :conflicts               448
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1001
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              509
;  :propagations            75
;  :quant-instantiations    38
;  :rlimit-count            195421)
(declare-const $t@64@03 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@15@03 $k@51@03))
    (=
      $t@64@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))
  (implies
    (< $Perm.No $k@63@03)
    (=
      $t@64@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@15@03 $k@51@03) $k@63@03)))
(assert (<= (+ (- $k@15@03 $k@51@03) $k@63@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@15@03 $k@51@03) $k@63@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_lfsr != null
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1396
;  :arith-add-rows          38
;  :arith-assert-diseq      46
;  :arith-assert-lower      156
;  :arith-assert-upper      140
;  :arith-conflicts         53
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         53
;  :arith-pivots            115
;  :binary-propagations     22
;  :conflicts               449
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1009
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              510
;  :propagations            75
;  :quant-instantiations    39
;  :rlimit-count            196581)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1396
;  :arith-add-rows          38
;  :arith-assert-diseq      46
;  :arith-assert-lower      156
;  :arith-assert-upper      140
;  :arith-conflicts         53
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         53
;  :arith-pivots            115
;  :binary-propagations     22
;  :conflicts               449
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1009
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              511
;  :propagations            75
;  :quant-instantiations    39
;  :rlimit-count            196592)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@15@03 $k@51@03) $k@63@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1396
;  :arith-add-rows          39
;  :arith-assert-diseq      46
;  :arith-assert-lower      156
;  :arith-assert-upper      141
;  :arith-conflicts         54
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         54
;  :arith-pivots            116
;  :binary-propagations     22
;  :conflicts               450
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1010
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              512
;  :propagations            75
;  :quant-instantiations    39
;  :rlimit-count            196692)
(assert (not (= $t@64@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1402
;  :arith-add-rows          40
;  :arith-assert-diseq      46
;  :arith-assert-lower      156
;  :arith-assert-upper      142
;  :arith-conflicts         55
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         55
;  :arith-pivots            118
;  :binary-propagations     22
;  :conflicts               451
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1013
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              513
;  :propagations            75
;  :quant-instantiations    39
;  :rlimit-count            197254)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1402
;  :arith-add-rows          40
;  :arith-assert-diseq      46
;  :arith-assert-lower      156
;  :arith-assert-upper      142
;  :arith-conflicts         55
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         55
;  :arith-pivots            118
;  :binary-propagations     22
;  :conflicts               451
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1013
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              514
;  :propagations            75
;  :quant-instantiations    39
;  :rlimit-count            197265)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@15@03 $k@51@03) $k@63@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1402
;  :arith-add-rows          40
;  :arith-assert-diseq      46
;  :arith-assert-lower      156
;  :arith-assert-upper      143
;  :arith-conflicts         56
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         56
;  :arith-pivots            118
;  :binary-propagations     22
;  :conflicts               452
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1014
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              515
;  :propagations            75
;  :quant-instantiations    39
;  :rlimit-count            197346)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1407
;  :arith-add-rows          41
;  :arith-assert-diseq      46
;  :arith-assert-lower      156
;  :arith-assert-upper      144
;  :arith-conflicts         57
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         57
;  :arith-pivots            121
;  :binary-propagations     22
;  :conflicts               453
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1016
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              516
;  :propagations            75
;  :quant-instantiations    39
;  :rlimit-count            197878)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1407
;  :arith-add-rows          41
;  :arith-assert-diseq      46
;  :arith-assert-lower      156
;  :arith-assert-upper      144
;  :arith-conflicts         57
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         57
;  :arith-pivots            121
;  :binary-propagations     22
;  :conflicts               453
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1016
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              517
;  :propagations            75
;  :quant-instantiations    39
;  :rlimit-count            197889)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@15@03 $k@51@03) $k@63@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1407
;  :arith-add-rows          41
;  :arith-assert-diseq      46
;  :arith-assert-lower      156
;  :arith-assert-upper      145
;  :arith-conflicts         58
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         58
;  :arith-pivots            121
;  :binary-propagations     22
;  :conflicts               454
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1017
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              518
;  :propagations            75
;  :quant-instantiations    39
;  :rlimit-count            197970)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1412
;  :arith-add-rows          42
;  :arith-assert-diseq      46
;  :arith-assert-lower      156
;  :arith-assert-upper      146
;  :arith-conflicts         59
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         59
;  :arith-pivots            123
;  :binary-propagations     22
;  :conflicts               455
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1019
;  :mk-clause               132
;  :num-allocs              4329468
;  :num-checks              519
;  :propagations            75
;  :quant-instantiations    39
;  :rlimit-count            198507)
(declare-const $k@65@03 $Perm)
(assert ($Perm.isReadVar $k@65@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@65@03 $Perm.No) (< $Perm.No $k@65@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1412
;  :arith-add-rows          42
;  :arith-assert-diseq      47
;  :arith-assert-lower      158
;  :arith-assert-upper      147
;  :arith-conflicts         59
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         59
;  :arith-pivots            123
;  :binary-propagations     22
;  :conflicts               456
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1023
;  :mk-clause               134
;  :num-allocs              4329468
;  :num-checks              520
;  :propagations            76
;  :quant-instantiations    39
;  :rlimit-count            198706)
(set-option :timeout 10)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1412
;  :arith-add-rows          42
;  :arith-assert-diseq      47
;  :arith-assert-lower      158
;  :arith-assert-upper      147
;  :arith-conflicts         59
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         59
;  :arith-pivots            123
;  :binary-propagations     22
;  :conflicts               456
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1023
;  :mk-clause               134
;  :num-allocs              4329468
;  :num-checks              521
;  :propagations            76
;  :quant-instantiations    39
;  :rlimit-count            198717)
(declare-const $t@66@03 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@16@03 $k@52@03))
    (=
      $t@66@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))))))))))))))))))))))))
  (implies
    (< $Perm.No $k@65@03)
    (=
      $t@66@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@16@03 $k@52@03) $k@65@03)))
(assert (<= (+ (- $k@16@03 $k@52@03) $k@65@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@16@03 $k@52@03) $k@65@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_combinate != null
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1422
;  :arith-add-rows          43
;  :arith-assert-diseq      47
;  :arith-assert-lower      159
;  :arith-assert-upper      149
;  :arith-conflicts         60
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         60
;  :arith-pivots            126
;  :binary-propagations     22
;  :conflicts               457
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1031
;  :mk-clause               134
;  :num-allocs              4329468
;  :num-checks              522
;  :propagations            76
;  :quant-instantiations    40
;  :rlimit-count            199947)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1422
;  :arith-add-rows          43
;  :arith-assert-diseq      47
;  :arith-assert-lower      159
;  :arith-assert-upper      149
;  :arith-conflicts         60
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         60
;  :arith-pivots            126
;  :binary-propagations     22
;  :conflicts               457
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1031
;  :mk-clause               134
;  :num-allocs              4329468
;  :num-checks              523
;  :propagations            76
;  :quant-instantiations    40
;  :rlimit-count            199958)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@16@03 $k@52@03) $k@65@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1422
;  :arith-add-rows          44
;  :arith-assert-diseq      47
;  :arith-assert-lower      159
;  :arith-assert-upper      150
;  :arith-conflicts         61
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         61
;  :arith-pivots            128
;  :binary-propagations     22
;  :conflicts               458
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1032
;  :mk-clause               134
;  :num-allocs              4329468
;  :num-checks              524
;  :propagations            76
;  :quant-instantiations    40
;  :rlimit-count            200065)
(assert (not (= $t@66@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1428
;  :arith-add-rows          45
;  :arith-assert-diseq      47
;  :arith-assert-lower      159
;  :arith-assert-upper      151
;  :arith-conflicts         62
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         62
;  :arith-pivots            130
;  :binary-propagations     22
;  :conflicts               459
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1035
;  :mk-clause               134
;  :num-allocs              4329468
;  :num-checks              525
;  :propagations            76
;  :quant-instantiations    40
;  :rlimit-count            200667)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1428
;  :arith-add-rows          45
;  :arith-assert-diseq      47
;  :arith-assert-lower      159
;  :arith-assert-upper      151
;  :arith-conflicts         62
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         62
;  :arith-pivots            130
;  :binary-propagations     22
;  :conflicts               459
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1035
;  :mk-clause               134
;  :num-allocs              4329468
;  :num-checks              526
;  :propagations            76
;  :quant-instantiations    40
;  :rlimit-count            200678)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@16@03 $k@52@03) $k@65@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1428
;  :arith-add-rows          45
;  :arith-assert-diseq      47
;  :arith-assert-lower      159
;  :arith-assert-upper      152
;  :arith-conflicts         63
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         63
;  :arith-pivots            131
;  :binary-propagations     22
;  :conflicts               460
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1036
;  :mk-clause               134
;  :num-allocs              4329468
;  :num-checks              527
;  :propagations            76
;  :quant-instantiations    40
;  :rlimit-count            200766)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1433
;  :arith-add-rows          46
;  :arith-assert-diseq      47
;  :arith-assert-lower      159
;  :arith-assert-upper      153
;  :arith-conflicts         64
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         64
;  :arith-pivots            134
;  :binary-propagations     22
;  :conflicts               461
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1038
;  :mk-clause               134
;  :num-allocs              4329468
;  :num-checks              528
;  :propagations            76
;  :quant-instantiations    40
;  :rlimit-count            201338)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@57@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1433
;  :arith-add-rows          46
;  :arith-assert-diseq      47
;  :arith-assert-lower      159
;  :arith-assert-upper      153
;  :arith-conflicts         64
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         64
;  :arith-pivots            134
;  :binary-propagations     22
;  :conflicts               461
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1038
;  :mk-clause               134
;  :num-allocs              4329468
;  :num-checks              529
;  :propagations            76
;  :quant-instantiations    40
;  :rlimit-count            201349)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1433
;  :arith-add-rows          46
;  :arith-assert-diseq      47
;  :arith-assert-lower      159
;  :arith-assert-upper      154
;  :arith-conflicts         65
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         65
;  :arith-pivots            135
;  :binary-propagations     22
;  :conflicts               462
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1039
;  :mk-clause               134
;  :num-allocs              4329468
;  :num-checks              530
;  :propagations            76
;  :quant-instantiations    40
;  :rlimit-count            201437)
(declare-const $k@67@03 $Perm)
(assert ($Perm.isReadVar $k@67@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@67@03 $Perm.No) (< $Perm.No $k@67@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1433
;  :arith-add-rows          46
;  :arith-assert-diseq      48
;  :arith-assert-lower      161
;  :arith-assert-upper      155
;  :arith-conflicts         65
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         65
;  :arith-pivots            135
;  :binary-propagations     22
;  :conflicts               463
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1043
;  :mk-clause               136
;  :num-allocs              4329468
;  :num-checks              531
;  :propagations            77
;  :quant-instantiations    40
;  :rlimit-count            201635)
(set-option :timeout 10)
(push) ; 4
(assert (not (= diz@5@03 $t@60@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1433
;  :arith-add-rows          46
;  :arith-assert-diseq      48
;  :arith-assert-lower      161
;  :arith-assert-upper      155
;  :arith-conflicts         65
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         65
;  :arith-pivots            135
;  :binary-propagations     22
;  :conflicts               463
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1043
;  :mk-clause               136
;  :num-allocs              4329468
;  :num-checks              532
;  :propagations            77
;  :quant-instantiations    40
;  :rlimit-count            201646)
(declare-const $t@68@03 $Ref)
(assert (and
  (implies (< $Perm.No (+ (- $k@11@03 $k@47@03) $k@56@03)) (= $t@68@03 $t@57@03))
  (implies
    (< $Perm.No $k@67@03)
    (=
      $t@68@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ (+ (- $k@11@03 $k@47@03) $k@56@03) $k@67@03)))
(assert (<= (+ (+ (- $k@11@03 $k@47@03) $k@56@03) $k@67@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (+ (- $k@11@03 $k@47@03) $k@56@03) $k@67@03))
  (not (= diz@5@03 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03)))))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn.Rng_m == diz.Rng_m
(push) ; 4
(assert (not (< $Perm.No (+ (+ (- $k@11@03 $k@47@03) $k@56@03) $k@67@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1441
;  :arith-add-rows          50
;  :arith-assert-diseq      48
;  :arith-assert-lower      162
;  :arith-assert-upper      157
;  :arith-conflicts         66
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         66
;  :arith-pivots            139
;  :binary-propagations     22
;  :conflicts               464
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1052
;  :mk-clause               137
;  :num-allocs              4329468
;  :num-checks              533
;  :propagations            77
;  :quant-instantiations    41
;  :rlimit-count            202614)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@68@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1442
;  :arith-add-rows          52
;  :arith-assert-diseq      48
;  :arith-assert-lower      162
;  :arith-assert-upper      158
;  :arith-conflicts         67
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         67
;  :arith-pivots            141
;  :binary-propagations     22
;  :conflicts               465
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1053
;  :mk-clause               137
;  :num-allocs              4329468
;  :num-checks              534
;  :propagations            78
;  :quant-instantiations    41
;  :rlimit-count            202726)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1442
;  :arith-add-rows          52
;  :arith-assert-diseq      48
;  :arith-assert-lower      162
;  :arith-assert-upper      159
;  :arith-conflicts         68
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         68
;  :arith-pivots            142
;  :binary-propagations     22
;  :conflicts               466
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1054
;  :mk-clause               137
;  :num-allocs              4329468
;  :num-checks              535
;  :propagations            78
;  :quant-instantiations    41
;  :rlimit-count            202814)
(push) ; 4
(assert (not (= diz@5@03 $t@60@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1442
;  :arith-add-rows          52
;  :arith-assert-diseq      48
;  :arith-assert-lower      162
;  :arith-assert-upper      159
;  :arith-conflicts         68
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         68
;  :arith-pivots            142
;  :binary-propagations     22
;  :conflicts               466
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1054
;  :mk-clause               137
;  :num-allocs              4329468
;  :num-checks              536
;  :propagations            78
;  :quant-instantiations    41
;  :rlimit-count            202825)
(push) ; 4
(assert (not (< $Perm.No (+ (+ (- $k@11@03 $k@47@03) $k@56@03) $k@67@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1442
;  :arith-add-rows          54
;  :arith-assert-diseq      48
;  :arith-assert-lower      162
;  :arith-assert-upper      160
;  :arith-conflicts         69
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         69
;  :arith-pivots            144
;  :binary-propagations     22
;  :conflicts               467
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1055
;  :mk-clause               137
;  :num-allocs              4329468
;  :num-checks              537
;  :propagations            78
;  :quant-instantiations    41
;  :rlimit-count            202955)
(push) ; 4
(assert (not (< $Perm.No (+ (+ (- $k@11@03 $k@47@03) $k@56@03) $k@67@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1442
;  :arith-add-rows          54
;  :arith-assert-diseq      48
;  :arith-assert-lower      162
;  :arith-assert-upper      161
;  :arith-conflicts         70
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         70
;  :arith-pivots            145
;  :binary-propagations     22
;  :conflicts               468
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1056
;  :mk-clause               137
;  :num-allocs              4329468
;  :num-checks              538
;  :propagations            78
;  :quant-instantiations    41
;  :rlimit-count            203049)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@55@03))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn == diz
(push) ; 4
(assert (not (< $Perm.No (+ (+ (- $k@11@03 $k@47@03) $k@56@03) $k@67@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1444
;  :arith-add-rows          54
;  :arith-assert-diseq      48
;  :arith-assert-lower      162
;  :arith-assert-upper      162
;  :arith-conflicts         71
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         71
;  :arith-pivots            146
;  :binary-propagations     22
;  :conflicts               469
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1058
;  :mk-clause               137
;  :num-allocs              4329468
;  :num-checks              539
;  :propagations            78
;  :quant-instantiations    41
;  :rlimit-count            203561)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@03))) $t@68@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1445
;  :arith-add-rows          56
;  :arith-assert-diseq      48
;  :arith-assert-lower      162
;  :arith-assert-upper      163
;  :arith-conflicts         72
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         72
;  :arith-pivots            148
;  :binary-propagations     22
;  :conflicts               470
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1059
;  :mk-clause               137
;  :num-allocs              4329468
;  :num-checks              540
;  :propagations            79
;  :quant-instantiations    41
;  :rlimit-count            203673)
(push) ; 4
(assert (not (< $Perm.No (+ (- $k@13@03 $k@49@03) $k@59@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1445
;  :arith-add-rows          56
;  :arith-assert-diseq      48
;  :arith-assert-lower      162
;  :arith-assert-upper      164
;  :arith-conflicts         73
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         73
;  :arith-pivots            149
;  :binary-propagations     22
;  :conflicts               471
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   22
;  :datatype-splits         169
;  :decisions               296
;  :del-clause              110
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1060
;  :mk-clause               137
;  :num-allocs              4329468
;  :num-checks              541
;  :propagations            79
;  :quant-instantiations    41
;  :rlimit-count            203761)
(assert (= $t@60@03 diz@5@03))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; __flatten_3__18 := var__16 % __flatten_4__19
; [eval] var__16 % __flatten_4__19
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= sys__result@54@03 0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1850
;  :arith-add-rows          56
;  :arith-assert-diseq      48
;  :arith-assert-lower      162
;  :arith-assert-upper      164
;  :arith-conflicts         73
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         73
;  :arith-pivots            149
;  :binary-propagations     22
;  :conflicts               472
;  :datatype-accessor-ax    129
;  :datatype-constructor-ax 443
;  :datatype-occurs-check   32
;  :datatype-splits         247
;  :decisions               433
;  :del-clause              134
;  :final-checks            24
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1144
;  :mk-clause               138
;  :num-allocs              4519601
;  :num-checks              543
;  :propagations            82
;  :quant-instantiations    41
;  :rlimit-count            206627)
(pop) ; 3
(pop) ; 2
(pop) ; 1
