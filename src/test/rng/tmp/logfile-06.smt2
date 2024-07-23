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
; ---------- Rng___contract_unsatisfiable__exp2__EncodedGlobalVariables_Integer ----------
(declare-const diz@0@06 $Ref)
(declare-const __globals@1@06 $Ref)
(declare-const __exponent@2@06 Int)
(declare-const sys__result@3@06 Int)
(declare-const diz@4@06 $Ref)
(declare-const __globals@5@06 $Ref)
(declare-const __exponent@6@06 Int)
(declare-const sys__result@7@06 Int)
(push) ; 1
(declare-const $t@8@06 $Snap)
(assert (= $t@8@06 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@4@06 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.Rng_m, wildcard) && diz.Rng_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.Rng_m, __globals), write) && (true && (true && acc(diz.Rng_m.Main_process_state, write) && |diz.Rng_m.Main_process_state| == 3 && acc(diz.Rng_m.Main_event_state, write) && |diz.Rng_m.Main_event_state| == 6 && (forall i__4: Int :: { diz.Rng_m.Main_process_state[i__4] } 0 <= i__4 && i__4 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__4] == -1 || 0 <= diz.Rng_m.Main_process_state[i__4] && diz.Rng_m.Main_process_state[i__4] < |diz.Rng_m.Main_event_state|)) && acc(diz.Rng_m.Main_rn, wildcard) && diz.Rng_m.Main_rn != null && acc(diz.Rng_m.Main_rn.Rng_clk, write) && acc(diz.Rng_m.Main_rn.Rng_reset, write) && acc(diz.Rng_m.Main_rn.Rng_loadseed_i, write) && acc(diz.Rng_m.Main_rn.Rng_seed_i, write) && acc(diz.Rng_m.Main_rn.Rng_number_o, write) && acc(diz.Rng_m.Main_rn.Rng_LFSR_reg, write) && acc(diz.Rng_m.Main_rn.Rng_CASR_reg, write) && acc(diz.Rng_m.Main_rn.Rng_result, write) && acc(diz.Rng_m.Main_rn.Rng_i, write) && acc(diz.Rng_m.Main_rn.Rng_aux, write) && acc(diz.Rng_m.Main_rn_casr, wildcard) && diz.Rng_m.Main_rn_casr != null && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_var, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_out, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_plus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_CASR_minus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_bit_plus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_bit_minus, write) && acc(diz.Rng_m.Main_rn_casr.CASR_i, write) && acc(diz.Rng_m.Main_rn_lfsr, wildcard) && diz.Rng_m.Main_rn_lfsr != null && acc(diz.Rng_m.Main_rn_lfsr.LFSR_LFSR_var, write) && acc(diz.Rng_m.Main_rn_lfsr.LFSR_outbit, write) && acc(diz.Rng_m.Main_rn_combinate, wildcard) && diz.Rng_m.Main_rn_combinate != null && acc(diz.Rng_m.Main_rn_combinate.Combinate_i, write) && acc(diz.Rng_m.Main_rn.Rng_m, wildcard) && diz.Rng_m.Main_rn.Rng_m == diz.Rng_m) && diz.Rng_m.Main_rn == diz)
(declare-const $t@9@06 $Snap)
(assert (= $t@9@06 ($Snap.combine ($Snap.first $t@9@06) ($Snap.second $t@9@06))))
(assert (= ($Snap.first $t@9@06) $Snap.unit))
(assert (=
  ($Snap.second $t@9@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@9@06))
    ($Snap.second ($Snap.second $t@9@06)))))
(declare-const $k@10@06 $Perm)
(assert ($Perm.isReadVar $k@10@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@10@06 $Perm.No) (< $Perm.No $k@10@06))))
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
(assert (<= $Perm.No $k@10@06))
(assert (<= $k@10@06 $Perm.Write))
(assert (implies (< $Perm.No $k@10@06) (not (= diz@4@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@9@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@9@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@9@06))) $Snap.unit))
; [eval] diz.Rng_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@9@06))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@9@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@9@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
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
;  :num-allocs            3645051
;  :num-checks            5
;  :propagations          23
;  :quant-instantiations  2
;  :rlimit-count          115450)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
  $Snap.unit))
; [eval] |diz.Rng_m.Main_process_state| == 3
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            6
;  :propagations          23
;  :quant-instantiations  2
;  :rlimit-count          115699
;  :time                  0.00)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            7
;  :propagations          24
;  :quant-instantiations  5
;  :rlimit-count          116084)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))
  $Snap.unit))
; [eval] |diz.Rng_m.Main_event_state| == 6
; [eval] |diz.Rng_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            8
;  :propagations          24
;  :quant-instantiations  5
;  :rlimit-count          116353)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))
  $Snap.unit))
; [eval] (forall i__4: Int :: { diz.Rng_m.Main_process_state[i__4] } 0 <= i__4 && i__4 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__4] == -1 || 0 <= diz.Rng_m.Main_process_state[i__4] && diz.Rng_m.Main_process_state[i__4] < |diz.Rng_m.Main_event_state|)
(declare-const i__4@11@06 Int)
(push) ; 3
; [eval] 0 <= i__4 && i__4 < |diz.Rng_m.Main_process_state| ==> diz.Rng_m.Main_process_state[i__4] == -1 || 0 <= diz.Rng_m.Main_process_state[i__4] && diz.Rng_m.Main_process_state[i__4] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= i__4 && i__4 < |diz.Rng_m.Main_process_state|
; [eval] 0 <= i__4
(push) ; 4
; [then-branch: 0 | 0 <= i__4@11@06 | live]
; [else-branch: 0 | !(0 <= i__4@11@06) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i__4@11@06]
(assert (<= 0 i__4@11@06))
; [eval] i__4 < |diz.Rng_m.Main_process_state|
; [eval] |diz.Rng_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            9
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          116845
;  :time                  0.00)
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i__4@11@06)]
(assert (not (<= 0 i__4@11@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i__4@11@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))| && 0 <= i__4@11@06 | live]
; [else-branch: 1 | !(i__4@11@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))| && 0 <= i__4@11@06) | live]
(push) ; 5
; [then-branch: 1 | i__4@11@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))| && 0 <= i__4@11@06]
(assert (and
  (<
    i__4@11@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))
  (<= 0 i__4@11@06)))
; [eval] diz.Rng_m.Main_process_state[i__4] == -1 || 0 <= diz.Rng_m.Main_process_state[i__4] && diz.Rng_m.Main_process_state[i__4] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i__4] == -1
; [eval] diz.Rng_m.Main_process_state[i__4]
(push) ; 6
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            10
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117002)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i__4@11@06 0)))
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
;  :num-allocs            3645051
;  :num-checks            11
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117011)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))[i__4@11@06] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))[i__4@11@06] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))[i__4@11@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
    i__4@11@06)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))[i__4@11@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
      i__4@11@06)
    (- 0 1))))
; [eval] 0 <= diz.Rng_m.Main_process_state[i__4] && diz.Rng_m.Main_process_state[i__4] < |diz.Rng_m.Main_event_state|
; [eval] 0 <= diz.Rng_m.Main_process_state[i__4]
; [eval] diz.Rng_m.Main_process_state[i__4]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            12
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117261
;  :time                  0.00)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i__4@11@06 0)))
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
;  :num-allocs            3645051
;  :num-checks            13
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117270)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))[i__4@11@06] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))[i__4@11@06]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))[i__4@11@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
    i__4@11@06)))
; [eval] diz.Rng_m.Main_process_state[i__4] < |diz.Rng_m.Main_event_state|
; [eval] diz.Rng_m.Main_process_state[i__4]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            14
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117463)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__4@11@06 0)))
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
;  :num-allocs            3645051
;  :num-checks            15
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117472)
; [eval] |diz.Rng_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            16
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          117520)
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))[i__4@11@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
      i__4@11@06))))
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
; [else-branch: 1 | !(i__4@11@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@9@06)))))))| && 0 <= i__4@11@06)]
(assert (not
  (and
    (<
      i__4@11@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))
    (<= 0 i__4@11@06))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__4@11@06 Int)) (!
  (implies
    (and
      (<
        i__4@11@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))
      (<= 0 i__4@11@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
          i__4@11@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
            i__4@11@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
            i__4@11@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))
    i__4@11@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            17
;  :propagations          25
;  :quant-instantiations  8
;  :rlimit-count          118235)
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
;  :num-allocs            3645051
;  :num-checks            18
;  :propagations          26
;  :quant-instantiations  8
;  :rlimit-count          118433)
(assert (<= $Perm.No $k@12@06))
(assert (<= $k@12@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@12@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@9@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            19
;  :propagations          26
;  :quant-instantiations  8
;  :rlimit-count          118786)
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
;  :num-allocs            3645051
;  :num-checks            20
;  :propagations          26
;  :quant-instantiations  8
;  :rlimit-count          118834
;  :time                  0.00)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            21
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119220)
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
;  :num-allocs            3645051
;  :num-checks            22
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119268)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            23
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119555)
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
;  :num-allocs            3645051
;  :num-checks            24
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119603)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            25
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119900)
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
;  :num-allocs            3645051
;  :num-checks            26
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          119948)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            27
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          120255)
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
;  :num-allocs            3645051
;  :num-checks            28
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          120303)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            29
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          120620)
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
;  :num-allocs            3645051
;  :num-checks            30
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          120668)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            31
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          120995)
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
;  :num-allocs            3645051
;  :num-checks            32
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          121043)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            33
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          121380)
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
;  :num-allocs            3645051
;  :num-checks            34
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          121428)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            35
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          121775)
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
;  :num-allocs            3645051
;  :num-checks            36
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          121823)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            37
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          122180)
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
;  :num-allocs            3645051
;  :num-checks            38
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          122228)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3645051
;  :num-checks            39
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          122595)
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
;  :num-allocs            3645051
;  :num-checks            40
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          122643)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            41
;  :propagations          26
;  :quant-instantiations  9
;  :rlimit-count          123020)
(declare-const $k@13@06 $Perm)
(assert ($Perm.isReadVar $k@13@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@13@06 $Perm.No) (< $Perm.No $k@13@06))))
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
;  :num-allocs            3770107
;  :num-checks            42
;  :propagations          27
;  :quant-instantiations  9
;  :rlimit-count          123219)
(assert (<= $Perm.No $k@13@06))
(assert (<= $k@13@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@13@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@9@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_casr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            43
;  :propagations          27
;  :quant-instantiations  9
;  :rlimit-count          123692)
(push) ; 3
(assert (not (< $Perm.No $k@13@06)))
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
;  :num-allocs            3770107
;  :num-checks            44
;  :propagations          27
;  :quant-instantiations  9
;  :rlimit-count          123740)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            45
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          124264)
(push) ; 3
(assert (not (< $Perm.No $k@13@06)))
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
;  :num-allocs            3770107
;  :num-checks            46
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          124312)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            47
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          124719)
(push) ; 3
(assert (not (< $Perm.No $k@13@06)))
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
;  :num-allocs            3770107
;  :num-checks            48
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          124767)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            49
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          125184)
(push) ; 3
(assert (not (< $Perm.No $k@13@06)))
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
;  :num-allocs            3770107
;  :num-checks            50
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          125232)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            51
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          125659)
(push) ; 3
(assert (not (< $Perm.No $k@13@06)))
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
;  :num-allocs            3770107
;  :num-checks            52
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          125707)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            53
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          126144)
(push) ; 3
(assert (not (< $Perm.No $k@13@06)))
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
;  :num-allocs            3770107
;  :num-checks            54
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          126192)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            55
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          126639)
(push) ; 3
(assert (not (< $Perm.No $k@13@06)))
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
;  :num-allocs            3770107
;  :num-checks            56
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          126687)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            57
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          127144)
(push) ; 3
(assert (not (< $Perm.No $k@13@06)))
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
;  :num-allocs            3770107
;  :num-checks            58
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          127192)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            59
;  :propagations          27
;  :quant-instantiations  10
;  :rlimit-count          127659)
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
;  :num-allocs            3770107
;  :num-checks            60
;  :propagations          28
;  :quant-instantiations  10
;  :rlimit-count          127858)
(assert (<= $Perm.No $k@14@06))
(assert (<= $k@14@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@14@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@9@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_lfsr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            61
;  :propagations          28
;  :quant-instantiations  10
;  :rlimit-count          128421)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3770107
;  :num-checks            62
;  :propagations          28
;  :quant-instantiations  10
;  :rlimit-count          128469)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            63
;  :propagations          28
;  :quant-instantiations  11
;  :rlimit-count          129077)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3770107
;  :num-checks            64
;  :propagations          28
;  :quant-instantiations  11
;  :rlimit-count          129125)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            65
;  :propagations          28
;  :quant-instantiations  11
;  :rlimit-count          129622)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3770107
;  :num-checks            66
;  :propagations          28
;  :quant-instantiations  11
;  :rlimit-count          129670)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            67
;  :propagations          28
;  :quant-instantiations  11
;  :rlimit-count          130177)
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
;  :num-allocs            3770107
;  :num-checks            68
;  :propagations          29
;  :quant-instantiations  11
;  :rlimit-count          130375)
(assert (<= $Perm.No $k@15@06))
(assert (<= $k@15@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@15@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@9@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn_combinate != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            69
;  :propagations          29
;  :quant-instantiations  11
;  :rlimit-count          130978)
(push) ; 3
(assert (not (< $Perm.No $k@15@06)))
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
;  :num-allocs            3770107
;  :num-checks            70
;  :propagations          29
;  :quant-instantiations  11
;  :rlimit-count          131026)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            71
;  :propagations          29
;  :quant-instantiations  12
;  :rlimit-count          131664)
(push) ; 3
(assert (not (< $Perm.No $k@15@06)))
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
;  :num-allocs            3770107
;  :num-checks            72
;  :propagations          29
;  :quant-instantiations  12
;  :rlimit-count          131712)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs            3770107
;  :num-checks            73
;  :propagations          29
;  :quant-instantiations  12
;  :rlimit-count          132249)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3770107
;  :num-checks            74
;  :propagations          29
;  :quant-instantiations  12
;  :rlimit-count          132297)
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
;  :num-allocs            3770107
;  :num-checks            75
;  :propagations          30
;  :quant-instantiations  12
;  :rlimit-count          132496)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@4@06
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))
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
;  :num-allocs              3900985
;  :num-checks              76
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            133469)
(assert (<= $Perm.No $k@16@06))
(assert (<= $k@16@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@16@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn.Rng_m == diz.Rng_m
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs              3900985
;  :num-checks              77
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            134102)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs              3900985
;  :num-checks              78
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            134150)
(push) ; 3
(assert (not (< $Perm.No $k@16@06)))
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
;  :num-allocs              3900985
;  :num-checks              79
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            134198)
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs              3900985
;  :num-checks              80
;  :propagations            30
;  :quant-instantiations    12
;  :rlimit-count            134246)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@9@06)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Rng_m.Main_rn == diz
(push) ; 3
(assert (not (< $Perm.No $k@10@06)))
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
;  :num-allocs              3900985
;  :num-checks              81
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            134859)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs              3900985
;  :num-checks              82
;  :propagations            30
;  :quant-instantiations    13
;  :rlimit-count            134907)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))
  diz@4@06))
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
  diz@4@06
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06))))))))))))))))
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
;  :num-allocs              3900985
;  :num-checks              86
;  :propagations            32
;  :quant-instantiations    13
;  :rlimit-count            137302)
(declare-const $t@17@06 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@10@06)
    (= $t@17@06 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@9@06)))))
  (implies
    (< $Perm.No $k@16@06)
    (=
      $t@17@06
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@9@06)))))))))))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@10@06 $k@16@06)))
(assert (<= (+ $k@10@06 $k@16@06) $Perm.Write))
(assert (implies (< $Perm.No (+ $k@10@06 $k@16@06)) (not (= diz@4@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Combinate___contract_unsatisfiable__Combinate_EncodedGlobalVariables_Main ----------
(declare-const diz@18@06 $Ref)
(declare-const __globals@19@06 $Ref)
(declare-const __m_param@20@06 $Ref)
(declare-const diz@21@06 $Ref)
(declare-const __globals@22@06 $Ref)
(declare-const __m_param@23@06 $Ref)
(push) ; 1
(declare-const $t@24@06 $Snap)
(assert (= $t@24@06 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@21@06 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@25@06 $Snap)
(assert (= $t@25@06 ($Snap.combine ($Snap.first $t@25@06) ($Snap.second $t@25@06))))
(assert (= ($Snap.first $t@25@06) $Snap.unit))
(assert (= ($Snap.second $t@25@06) $Snap.unit))
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
; ---------- Combinate_joinOperator_EncodedGlobalVariables ----------
(declare-const diz@26@06 $Ref)
(declare-const globals@27@06 $Ref)
(declare-const diz@28@06 $Ref)
(declare-const globals@29@06 $Ref)
(push) ; 1
(declare-const $t@30@06 $Snap)
(assert (= $t@30@06 ($Snap.combine ($Snap.first $t@30@06) ($Snap.second $t@30@06))))
(assert (= ($Snap.first $t@30@06) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@28@06 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@31@06 $Snap)
(assert (= $t@31@06 ($Snap.combine ($Snap.first $t@31@06) ($Snap.second $t@31@06))))
(assert (=
  ($Snap.second $t@31@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@31@06))
    ($Snap.second ($Snap.second $t@31@06)))))
(declare-const $k@32@06 $Perm)
(assert ($Perm.isReadVar $k@32@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@32@06 $Perm.No) (< $Perm.No $k@32@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               639
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      18
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               80
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   36
;  :datatype-splits         69
;  :decisions               150
;  :del-clause              21
;  :final-checks            20
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             481
;  :mk-clause               24
;  :num-allocs              3900985
;  :num-checks              94
;  :propagations            34
;  :quant-instantiations    13
;  :rlimit-count            140686)
(assert (<= $Perm.No $k@32@06))
(assert (<= $k@32@06 $Perm.Write))
(assert (implies (< $Perm.No $k@32@06) (not (= diz@28@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@31@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@31@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@31@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@31@06))) $Snap.unit))
; [eval] diz.Combinate_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@32@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               645
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      19
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               81
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   36
;  :datatype-splits         69
;  :decisions               150
;  :del-clause              21
;  :final-checks            20
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             484
;  :mk-clause               24
;  :num-allocs              3900985
;  :num-checks              95
;  :propagations            34
;  :quant-instantiations    13
;  :rlimit-count            140939)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@31@06))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@31@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@31@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@06)))))))
(push) ; 3
(assert (not (< $Perm.No $k@32@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               651
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      19
;  :arith-eq-adapter        13
;  :binary-propagations     22
;  :conflicts               82
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   36
;  :datatype-splits         69
;  :decisions               150
;  :del-clause              21
;  :final-checks            20
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             487
;  :mk-clause               24
;  :num-allocs              3900985
;  :num-checks              96
;  :propagations            34
;  :quant-instantiations    14
;  :rlimit-count            141223)
(declare-const $k@33@06 $Perm)
(assert ($Perm.isReadVar $k@33@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@33@06 $Perm.No) (< $Perm.No $k@33@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               651
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      20
;  :arith-eq-adapter        14
;  :binary-propagations     22
;  :conflicts               83
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   36
;  :datatype-splits         69
;  :decisions               150
;  :del-clause              21
;  :final-checks            20
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             491
;  :mk-clause               26
;  :num-allocs              3900985
;  :num-checks              97
;  :propagations            35
;  :quant-instantiations    14
;  :rlimit-count            141422)
(assert (<= $Perm.No $k@33@06))
(assert (<= $k@33@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@33@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@31@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@06))))
  $Snap.unit))
; [eval] diz.Combinate_m.Main_rn_combinate == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@32@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               652
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-eq-adapter        14
;  :binary-propagations     22
;  :conflicts               84
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   36
;  :datatype-splits         69
;  :decisions               150
;  :del-clause              21
;  :final-checks            20
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             493
;  :mk-clause               26
;  :num-allocs              3900985
;  :num-checks              98
;  :propagations            35
;  :quant-instantiations    14
;  :rlimit-count            141608)
(push) ; 3
(assert (not (< $Perm.No $k@33@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               652
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      21
;  :arith-eq-adapter        14
;  :binary-propagations     22
;  :conflicts               85
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   36
;  :datatype-splits         69
;  :decisions               150
;  :del-clause              21
;  :final-checks            20
;  :max-generation          1
;  :max-memory              4.11
;  :memory                  4.08
;  :mk-bool-var             493
;  :mk-clause               26
;  :num-allocs              3900985
;  :num-checks              99
;  :propagations            35
;  :quant-instantiations    14
;  :rlimit-count            141656)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@31@06)))))
  diz@28@06))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main___contract_unsatisfiable__Main_EncodedGlobalVariables ----------
(declare-const diz@34@06 $Ref)
(declare-const __globals@35@06 $Ref)
(declare-const diz@36@06 $Ref)
(declare-const __globals@37@06 $Ref)
(push) ; 1
(declare-const $t@38@06 $Snap)
(assert (= $t@38@06 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@36@06 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@39@06 $Snap)
(assert (= $t@39@06 ($Snap.combine ($Snap.first $t@39@06) ($Snap.second $t@39@06))))
(assert (= ($Snap.first $t@39@06) $Snap.unit))
(assert (= ($Snap.second $t@39@06) $Snap.unit))
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
; ---------- Main_Main_EncodedGlobalVariables ----------
(declare-const __globals@40@06 $Ref)
(declare-const sys__result@41@06 $Ref)
(declare-const __globals@42@06 $Ref)
(declare-const sys__result@43@06 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@44@06 $Snap)
(assert (= $t@44@06 ($Snap.combine ($Snap.first $t@44@06) ($Snap.second $t@44@06))))
(assert (= ($Snap.first $t@44@06) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@43@06 $Ref.null)))
(assert (= ($Snap.second $t@44@06) $Snap.unit))
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
(assert (= (type_of<TYPE> sys__result@43@06) (as class_Main<TYPE>  TYPE)))
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_176__221: Ref
(declare-const __flatten_176__221@45@06 $Ref)
; [exec]
; var __flatten_174__220: Ref
(declare-const __flatten_174__220@46@06 $Ref)
; [exec]
; var __flatten_172__219: Ref
(declare-const __flatten_172__219@47@06 $Ref)
; [exec]
; var __flatten_170__218: Ref
(declare-const __flatten_170__218@48@06 $Ref)
; [exec]
; var __flatten_169__217: Seq[Int]
(declare-const __flatten_169__217@49@06 Seq<Int>)
; [exec]
; var __flatten_168__216: Seq[Int]
(declare-const __flatten_168__216@50@06 Seq<Int>)
; [exec]
; var __flatten_167__215: Seq[Int]
(declare-const __flatten_167__215@51@06 Seq<Int>)
; [exec]
; var __flatten_166__214: Seq[Int]
(declare-const __flatten_166__214@52@06 Seq<Int>)
; [exec]
; var globals__213: Ref
(declare-const globals__213@53@06 $Ref)
; [exec]
; var diz__212: Ref
(declare-const diz__212@54@06 $Ref)
; [exec]
; diz__212 := new(Main_process_state, Main_event_state, Main_rn, Main_rn_casr, Main_rn_lfsr, Main_rn_combinate)
(declare-const diz__212@55@06 $Ref)
(assert (not (= diz__212@55@06 $Ref.null)))
(declare-const Main_process_state@56@06 Seq<Int>)
(declare-const Main_event_state@57@06 Seq<Int>)
(declare-const Main_rn@58@06 $Ref)
(declare-const Main_rn_casr@59@06 $Ref)
(declare-const Main_rn_lfsr@60@06 $Ref)
(declare-const Main_rn_combinate@61@06 $Ref)
(assert (not (= diz__212@55@06 globals__213@53@06)))
(assert (not (= diz__212@55@06 sys__result@43@06)))
(assert (not (= diz__212@55@06 __flatten_176__221@45@06)))
(assert (not (= diz__212@55@06 __globals@42@06)))
(assert (not (= diz__212@55@06 __flatten_170__218@48@06)))
(assert (not (= diz__212@55@06 __flatten_172__219@47@06)))
(assert (not (= diz__212@55@06 diz__212@54@06)))
(assert (not (= diz__212@55@06 __flatten_174__220@46@06)))
; [exec]
; inhale type_of(diz__212) == class_Main()
(declare-const $t@62@06 $Snap)
(assert (= $t@62@06 $Snap.unit))
; [eval] type_of(diz__212) == class_Main()
; [eval] type_of(diz__212)
; [eval] class_Main()
(assert (= (type_of<TYPE> diz__212@55@06) (as class_Main<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; globals__213 := __globals
; [exec]
; __flatten_167__215 := Seq(-1, -1, -1)
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
(declare-const __flatten_167__215@63@06 Seq<Int>)
(assert (Seq_equal
  __flatten_167__215@63@06
  (Seq_append
    (Seq_append (Seq_singleton (- 0 1)) (Seq_singleton (- 0 1)))
    (Seq_singleton (- 0 1)))))
; [exec]
; __flatten_166__214 := __flatten_167__215
; [exec]
; diz__212.Main_process_state := __flatten_166__214
; [exec]
; __flatten_169__217 := Seq(-3, -3, -3, -3, -3, -3)
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
(declare-const __flatten_169__217@64@06 Seq<Int>)
(assert (Seq_equal
  __flatten_169__217@64@06
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
; __flatten_168__216 := __flatten_169__217
; [exec]
; diz__212.Main_event_state := __flatten_168__216
; [exec]
; __flatten_170__218 := Rng_Rng_EncodedGlobalVariables_Main(globals__213, diz__212)
(declare-const sys__result@65@06 $Ref)
(declare-const $t@66@06 $Snap)
(assert (= $t@66@06 ($Snap.combine ($Snap.first $t@66@06) ($Snap.second $t@66@06))))
(assert (= ($Snap.first $t@66@06) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@65@06 $Ref.null)))
(assert (=
  ($Snap.second $t@66@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@66@06))
    ($Snap.second ($Snap.second $t@66@06)))))
(assert (= ($Snap.first ($Snap.second $t@66@06)) $Snap.unit))
; [eval] type_of(sys__result) == class_Rng()
; [eval] type_of(sys__result)
; [eval] class_Rng()
(assert (= (type_of<TYPE> sys__result@65@06) (as class_Rng<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@66@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@66@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@66@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@66@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))))))
  $Snap.unit))
; [eval] sys__result.Rng_m == __m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@66@06))))
  diz__212@55@06))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; diz__212.Main_rn := __flatten_170__218
; [exec]
; __flatten_172__219 := CASR_CASR_EncodedGlobalVariables_Main(globals__213, diz__212)
(declare-const sys__result@67@06 $Ref)
(declare-const $t@68@06 $Snap)
(assert (= $t@68@06 ($Snap.combine ($Snap.first $t@68@06) ($Snap.second $t@68@06))))
(assert (= ($Snap.first $t@68@06) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@67@06 $Ref.null)))
(assert (=
  ($Snap.second $t@68@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@68@06))
    ($Snap.second ($Snap.second $t@68@06)))))
(assert (= ($Snap.first ($Snap.second $t@68@06)) $Snap.unit))
; [eval] type_of(sys__result) == class_CASR()
; [eval] type_of(sys__result)
; [eval] class_CASR()
(assert (= (type_of<TYPE> sys__result@67@06) (as class_CASR<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@68@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@68@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@68@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@68@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))))))
  $Snap.unit))
; [eval] sys__result.CASR_m == __m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))
  diz__212@55@06))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__212.Main_rn_casr := __flatten_172__219
; [exec]
; __flatten_174__220 := LFSR_LFSR_EncodedGlobalVariables_Main(globals__213, diz__212)
(declare-const sys__result@69@06 $Ref)
(declare-const $t@70@06 $Snap)
(assert (= $t@70@06 ($Snap.combine ($Snap.first $t@70@06) ($Snap.second $t@70@06))))
(assert (= ($Snap.first $t@70@06) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@69@06 $Ref.null)))
(assert (=
  ($Snap.second $t@70@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@70@06))
    ($Snap.second ($Snap.second $t@70@06)))))
(assert (= ($Snap.first ($Snap.second $t@70@06)) $Snap.unit))
; [eval] type_of(sys__result) == class_LFSR()
; [eval] type_of(sys__result)
; [eval] class_LFSR()
(assert (= (type_of<TYPE> sys__result@69@06) (as class_LFSR<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@70@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@70@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@70@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@70@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@06)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@06))))))
  $Snap.unit))
; [eval] sys__result.LFSR_m == __m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@06)))))
  diz__212@55@06))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__212.Main_rn_lfsr := __flatten_174__220
; [exec]
; __flatten_176__221 := Combinate_Combinate_EncodedGlobalVariables_Main(globals__213, diz__212)
(declare-const sys__result@71@06 $Ref)
(declare-const $t@72@06 $Snap)
(assert (= $t@72@06 ($Snap.combine ($Snap.first $t@72@06) ($Snap.second $t@72@06))))
(assert (= ($Snap.first $t@72@06) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@71@06 $Ref.null)))
(assert (=
  ($Snap.second $t@72@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@72@06))
    ($Snap.second ($Snap.second $t@72@06)))))
(assert (= ($Snap.first ($Snap.second $t@72@06)) $Snap.unit))
; [eval] type_of(sys__result) == class_Combinate()
; [eval] type_of(sys__result)
; [eval] class_Combinate()
(assert (= (type_of<TYPE> sys__result@71@06) (as class_Combinate<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@72@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@72@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@72@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
  $Snap.unit))
; [eval] sys__result.Combinate_m == __m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
  diz__212@55@06))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__212.Main_rn_combinate := __flatten_176__221
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz__212, globals__213), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(set-option :timeout 0)
(push) ; 3
(assert (not (= (Seq_length __flatten_167__215@63@06) 3)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1181
;  :arith-add-rows          24
;  :arith-assert-diseq      21
;  :arith-assert-lower      66
;  :arith-assert-upper      42
;  :arith-bound-prop        4
;  :arith-conflicts         1
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               95
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 231
;  :datatype-occurs-check   68
;  :datatype-splits         112
;  :decisions               235
;  :del-clause              196
;  :final-checks            35
;  :max-generation          5
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             814
;  :mk-clause               197
;  :num-allocs              4045563
;  :num-checks              111
;  :propagations            103
;  :quant-instantiations    77
;  :rlimit-count            153632)
(assert (= (Seq_length __flatten_167__215@63@06) 3))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(push) ; 3
(assert (not (= (Seq_length __flatten_169__217@64@06) 6)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1182
;  :arith-add-rows          24
;  :arith-assert-diseq      21
;  :arith-assert-lower      67
;  :arith-assert-upper      43
;  :arith-bound-prop        4
;  :arith-conflicts         1
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               96
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 231
;  :datatype-occurs-check   68
;  :datatype-splits         112
;  :decisions               235
;  :del-clause              196
;  :final-checks            35
;  :max-generation          5
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             820
;  :mk-clause               197
;  :num-allocs              4045563
;  :num-checks              112
;  :propagations            103
;  :quant-instantiations    77
;  :rlimit-count            153757)
(assert (= (Seq_length __flatten_169__217@64@06) 6))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@73@06 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@73@06 | live]
; [else-branch: 4 | !(0 <= i@73@06) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@73@06]
(assert (<= 0 i@73@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@73@06)]
(assert (not (<= 0 i@73@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@73@06 < |__flatten_167__215@63@06| && 0 <= i@73@06 | live]
; [else-branch: 5 | !(i@73@06 < |__flatten_167__215@63@06| && 0 <= i@73@06) | live]
(push) ; 5
; [then-branch: 5 | i@73@06 < |__flatten_167__215@63@06| && 0 <= i@73@06]
(assert (and (< i@73@06 (Seq_length __flatten_167__215@63@06)) (<= 0 i@73@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 6
(assert (not (>= i@73@06 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1183
;  :arith-add-rows          24
;  :arith-assert-diseq      21
;  :arith-assert-lower      69
;  :arith-assert-upper      45
;  :arith-bound-prop        4
;  :arith-conflicts         1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               96
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 231
;  :datatype-occurs-check   68
;  :datatype-splits         112
;  :decisions               235
;  :del-clause              196
;  :final-checks            35
;  :max-generation          5
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             825
;  :mk-clause               197
;  :num-allocs              4045563
;  :num-checks              113
;  :propagations            103
;  :quant-instantiations    77
;  :rlimit-count            153944)
; [eval] -1
(push) ; 6
; [then-branch: 6 | __flatten_167__215@63@06[i@73@06] == -1 | live]
; [else-branch: 6 | __flatten_167__215@63@06[i@73@06] != -1 | live]
(push) ; 7
; [then-branch: 6 | __flatten_167__215@63@06[i@73@06] == -1]
(assert (= (Seq_index __flatten_167__215@63@06 i@73@06) (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | __flatten_167__215@63@06[i@73@06] != -1]
(assert (not (= (Seq_index __flatten_167__215@63@06 i@73@06) (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@73@06 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1184
;  :arith-add-rows          26
;  :arith-assert-diseq      21
;  :arith-assert-lower      69
;  :arith-assert-upper      45
;  :arith-bound-prop        4
;  :arith-conflicts         1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               96
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 231
;  :datatype-occurs-check   68
;  :datatype-splits         112
;  :decisions               235
;  :del-clause              196
;  :final-checks            35
;  :max-generation          5
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             830
;  :mk-clause               201
;  :num-allocs              4045563
;  :num-checks              114
;  :propagations            103
;  :quant-instantiations    78
;  :rlimit-count            154111)
(push) ; 8
; [then-branch: 7 | 0 <= __flatten_167__215@63@06[i@73@06] | live]
; [else-branch: 7 | !(0 <= __flatten_167__215@63@06[i@73@06]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= __flatten_167__215@63@06[i@73@06]]
(assert (<= 0 (Seq_index __flatten_167__215@63@06 i@73@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@73@06 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1184
;  :arith-add-rows          26
;  :arith-assert-diseq      22
;  :arith-assert-lower      72
;  :arith-assert-upper      45
;  :arith-bound-prop        4
;  :arith-conflicts         1
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :binary-propagations     22
;  :conflicts               96
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 231
;  :datatype-occurs-check   68
;  :datatype-splits         112
;  :decisions               235
;  :del-clause              196
;  :final-checks            35
;  :max-generation          5
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             833
;  :mk-clause               202
;  :num-allocs              4045563
;  :num-checks              115
;  :propagations            103
;  :quant-instantiations    78
;  :rlimit-count            154185)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= __flatten_167__215@63@06[i@73@06])]
(assert (not (<= 0 (Seq_index __flatten_167__215@63@06 i@73@06))))
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
; [else-branch: 5 | !(i@73@06 < |__flatten_167__215@63@06| && 0 <= i@73@06)]
(assert (not (and (< i@73@06 (Seq_length __flatten_167__215@63@06)) (<= 0 i@73@06))))
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
(assert (not (forall ((i@73@06 Int)) (!
  (implies
    (and (< i@73@06 (Seq_length __flatten_167__215@63@06)) (<= 0 i@73@06))
    (or
      (= (Seq_index __flatten_167__215@63@06 i@73@06) (- 0 1))
      (and
        (<
          (Seq_index __flatten_167__215@63@06 i@73@06)
          (Seq_length __flatten_169__217@64@06))
        (<= 0 (Seq_index __flatten_167__215@63@06 i@73@06)))))
  :pattern ((Seq_index __flatten_167__215@63@06 i@73@06))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1326
;  :arith-add-rows          102
;  :arith-assert-diseq      29
;  :arith-assert-lower      93
;  :arith-assert-upper      55
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               117
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              401
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1044
;  :mk-clause               402
;  :num-allocs              4194714
;  :num-checks              116
;  :propagations            129
;  :quant-instantiations    89
;  :rlimit-count            156217
;  :time                    0.00)
(assert (forall ((i@73@06 Int)) (!
  (implies
    (and (< i@73@06 (Seq_length __flatten_167__215@63@06)) (<= 0 i@73@06))
    (or
      (= (Seq_index __flatten_167__215@63@06 i@73@06) (- 0 1))
      (and
        (<
          (Seq_index __flatten_167__215@63@06 i@73@06)
          (Seq_length __flatten_169__217@64@06))
        (<= 0 (Seq_index __flatten_167__215@63@06 i@73@06)))))
  :pattern ((Seq_index __flatten_167__215@63@06 i@73@06))
  :qid |prog.l<no position>|)))
(declare-const $k@74@06 $Perm)
(assert ($Perm.isReadVar $k@74@06 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@74@06 $Perm.No) (< $Perm.No $k@74@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1326
;  :arith-add-rows          102
;  :arith-assert-diseq      30
;  :arith-assert-lower      95
;  :arith-assert-upper      56
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               118
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              401
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1049
;  :mk-clause               404
;  :num-allocs              4194714
;  :num-checks              117
;  :propagations            130
;  :quant-instantiations    89
;  :rlimit-count            156688)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1326
;  :arith-add-rows          102
;  :arith-assert-diseq      30
;  :arith-assert-lower      95
;  :arith-assert-upper      56
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               118
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              401
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1049
;  :mk-clause               404
;  :num-allocs              4194714
;  :num-checks              118
;  :propagations            130
;  :quant-instantiations    89
;  :rlimit-count            156701)
(assert (< $k@74@06 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@74@06)))
(assert (<= (- $Perm.Write $k@74@06) $Perm.Write))
(assert (implies
  (< $Perm.No (- $Perm.Write $k@74@06))
  (not (= diz__212@55@06 $Ref.null))))
; [eval] diz.Main_rn != null
(declare-const $k@75@06 $Perm)
(assert ($Perm.isReadVar $k@75@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@75@06 $Perm.No) (< $Perm.No $k@75@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1326
;  :arith-add-rows          102
;  :arith-assert-diseq      31
;  :arith-assert-lower      97
;  :arith-assert-upper      58
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               119
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              401
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1054
;  :mk-clause               406
;  :num-allocs              4194714
;  :num-checks              119
;  :propagations            131
;  :quant-instantiations    89
;  :rlimit-count            156989)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1326
;  :arith-add-rows          102
;  :arith-assert-diseq      31
;  :arith-assert-lower      97
;  :arith-assert-upper      58
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               119
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              401
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1054
;  :mk-clause               406
;  :num-allocs              4194714
;  :num-checks              120
;  :propagations            131
;  :quant-instantiations    89
;  :rlimit-count            157002)
(assert (< $k@75@06 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@75@06)))
(assert (<= (- $Perm.Write $k@75@06) $Perm.Write))
(assert (implies
  (< $Perm.No (- $Perm.Write $k@75@06))
  (not (= diz__212@55@06 $Ref.null))))
; [eval] diz.Main_rn_casr != null
(declare-const $k@76@06 $Perm)
(assert ($Perm.isReadVar $k@76@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@76@06 $Perm.No) (< $Perm.No $k@76@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1326
;  :arith-add-rows          102
;  :arith-assert-diseq      32
;  :arith-assert-lower      99
;  :arith-assert-upper      60
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               120
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              401
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1059
;  :mk-clause               408
;  :num-allocs              4194714
;  :num-checks              121
;  :propagations            132
;  :quant-instantiations    89
;  :rlimit-count            157290)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1326
;  :arith-add-rows          102
;  :arith-assert-diseq      32
;  :arith-assert-lower      99
;  :arith-assert-upper      60
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               120
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              401
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1059
;  :mk-clause               408
;  :num-allocs              4194714
;  :num-checks              122
;  :propagations            132
;  :quant-instantiations    89
;  :rlimit-count            157303)
(assert (< $k@76@06 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@76@06)))
(assert (<= (- $Perm.Write $k@76@06) $Perm.Write))
(assert (implies
  (< $Perm.No (- $Perm.Write $k@76@06))
  (not (= diz__212@55@06 $Ref.null))))
; [eval] diz.Main_rn_lfsr != null
(declare-const $k@77@06 $Perm)
(assert ($Perm.isReadVar $k@77@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@77@06 $Perm.No) (< $Perm.No $k@77@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1326
;  :arith-add-rows          102
;  :arith-assert-diseq      33
;  :arith-assert-lower      101
;  :arith-assert-upper      62
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               121
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              401
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1064
;  :mk-clause               410
;  :num-allocs              4194714
;  :num-checks              123
;  :propagations            133
;  :quant-instantiations    89
;  :rlimit-count            157591)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1326
;  :arith-add-rows          102
;  :arith-assert-diseq      33
;  :arith-assert-lower      101
;  :arith-assert-upper      62
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               121
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              401
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1064
;  :mk-clause               410
;  :num-allocs              4194714
;  :num-checks              124
;  :propagations            133
;  :quant-instantiations    89
;  :rlimit-count            157604)
(assert (< $k@77@06 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@77@06)))
(assert (<= (- $Perm.Write $k@77@06) $Perm.Write))
(assert (implies
  (< $Perm.No (- $Perm.Write $k@77@06))
  (not (= diz__212@55@06 $Ref.null))))
; [eval] diz.Main_rn_combinate != null
(declare-const $k@78@06 $Perm)
(assert ($Perm.isReadVar $k@78@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@78@06 $Perm.No) (< $Perm.No $k@78@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1326
;  :arith-add-rows          102
;  :arith-assert-diseq      34
;  :arith-assert-lower      103
;  :arith-assert-upper      64
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               122
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              401
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1069
;  :mk-clause               412
;  :num-allocs              4194714
;  :num-checks              125
;  :propagations            134
;  :quant-instantiations    89
;  :rlimit-count            157892)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1326
;  :arith-add-rows          102
;  :arith-assert-diseq      34
;  :arith-assert-lower      103
;  :arith-assert-upper      64
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            24
;  :binary-propagations     22
;  :conflicts               122
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              401
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1069
;  :mk-clause               412
;  :num-allocs              4194714
;  :num-checks              126
;  :propagations            134
;  :quant-instantiations    89
;  :rlimit-count            157905)
(assert (< $k@78@06 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@78@06)))
(assert (<= (- $Perm.Write $k@78@06) $Perm.Write))
(assert (implies
  (< $Perm.No (- $Perm.Write $k@78@06))
  (not (= sys__result@65@06 $Ref.null))))
; [eval] diz.Main_rn.Rng_m == diz
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($SortWrappers.Seq<Int>To$Snap __flatten_167__215@63@06)
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($SortWrappers.Seq<Int>To$Snap __flatten_169__217@64@06)
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($SortWrappers.$RefTo$Snap sys__result@65@06)
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@66@06))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))
                                ($Snap.combine
                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))))
                                  ($Snap.combine
                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))))
                                    ($Snap.combine
                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06))))))))))))
                                      ($Snap.combine
                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@66@06)))))))))))))
                                        ($Snap.combine
                                          ($SortWrappers.$RefTo$Snap sys__result@67@06)
                                          ($Snap.combine
                                            $Snap.unit
                                            ($Snap.combine
                                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))
                                              ($Snap.combine
                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))
                                                ($Snap.combine
                                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))
                                                  ($Snap.combine
                                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))))
                                                    ($Snap.combine
                                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))))
                                                      ($Snap.combine
                                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06))))))))))
                                                        ($Snap.combine
                                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@06)))))))))))
                                                          ($Snap.combine
                                                            ($SortWrappers.$RefTo$Snap sys__result@69@06)
                                                            ($Snap.combine
                                                              $Snap.unit
                                                              ($Snap.combine
                                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@06)))))
                                                                ($Snap.combine
                                                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@06))))))
                                                                  ($Snap.combine
                                                                    ($SortWrappers.$RefTo$Snap sys__result@71@06)
                                                                    ($Snap.combine
                                                                      $Snap.unit
                                                                      ($Snap.combine
                                                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
                                                                        ($Snap.combine
                                                                          ($Snap.first ($Snap.second ($Snap.second $t@66@06)))
                                                                          $Snap.unit))))))))))))))))))))))))))))))))))))) diz__212@55@06 __globals@42@06))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz__212, globals__213), write)
; [exec]
; sys__result := diz__212
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Main()
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main_immediate_wakeup_EncodedGlobalVariables ----------
(declare-const diz@79@06 $Ref)
(declare-const globals@80@06 $Ref)
(declare-const diz@81@06 $Ref)
(declare-const globals@82@06 $Ref)
(push) ; 1
(declare-const $t@83@06 $Snap)
(assert (= $t@83@06 ($Snap.combine ($Snap.first $t@83@06) ($Snap.second $t@83@06))))
(assert (= ($Snap.first $t@83@06) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@81@06 $Ref.null)))
(assert (=
  ($Snap.second $t@83@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@83@06))
    ($Snap.second ($Snap.second $t@83@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@83@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@83@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@83@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@06))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06)))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06)))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@84@06 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 8 | 0 <= i@84@06 | live]
; [else-branch: 8 | !(0 <= i@84@06) | live]
(push) ; 4
; [then-branch: 8 | 0 <= i@84@06]
(assert (<= 0 i@84@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 8 | !(0 <= i@84@06)]
(assert (not (<= 0 i@84@06)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 9 | i@84@06 < |First:(Second:(Second:($t@83@06)))| && 0 <= i@84@06 | live]
; [else-branch: 9 | !(i@84@06 < |First:(Second:(Second:($t@83@06)))| && 0 <= i@84@06) | live]
(push) ; 4
; [then-branch: 9 | i@84@06 < |First:(Second:(Second:($t@83@06)))| && 0 <= i@84@06]
(assert (and
  (<
    i@84@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))
  (<= 0 i@84@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@84@06 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1364
;  :arith-add-rows          104
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      67
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               122
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              411
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1098
;  :mk-clause               418
;  :num-allocs              4194714
;  :num-checks              127
;  :propagations            136
;  :quant-instantiations    95
;  :rlimit-count            159346)
; [eval] -1
(push) ; 5
; [then-branch: 10 | First:(Second:(Second:($t@83@06)))[i@84@06] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:($t@83@06)))[i@84@06] != -1 | live]
(push) ; 6
; [then-branch: 10 | First:(Second:(Second:($t@83@06)))[i@84@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    i@84@06)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 10 | First:(Second:(Second:($t@83@06)))[i@84@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      i@84@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@84@06 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1364
;  :arith-add-rows          104
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      67
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               122
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              411
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1099
;  :mk-clause               418
;  :num-allocs              4194714
;  :num-checks              128
;  :propagations            136
;  :quant-instantiations    95
;  :rlimit-count            159509)
(push) ; 7
; [then-branch: 11 | 0 <= First:(Second:(Second:($t@83@06)))[i@84@06] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:($t@83@06)))[i@84@06]) | live]
(push) ; 8
; [then-branch: 11 | 0 <= First:(Second:(Second:($t@83@06)))[i@84@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    i@84@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@84@06 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1364
;  :arith-add-rows          104
;  :arith-assert-diseq      37
;  :arith-assert-lower      113
;  :arith-assert-upper      67
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               122
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 268
;  :datatype-occurs-check   78
;  :datatype-splits         138
;  :decisions               286
;  :del-clause              411
;  :final-checks            40
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1102
;  :mk-clause               419
;  :num-allocs              4194714
;  :num-checks              129
;  :propagations            136
;  :quant-instantiations    95
;  :rlimit-count            159622)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 11 | !(0 <= First:(Second:(Second:($t@83@06)))[i@84@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      i@84@06))))
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
; [else-branch: 9 | !(i@84@06 < |First:(Second:(Second:($t@83@06)))| && 0 <= i@84@06)]
(assert (not
  (and
    (<
      i@84@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))
    (<= 0 i@84@06))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@84@06 Int)) (!
  (implies
    (and
      (<
        i@84@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))
      (<= 0 i@84@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          i@84@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
            i@84@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
            i@84@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    i@84@06))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@85@06 $Snap)
(assert (= $t@85@06 ($Snap.combine ($Snap.first $t@85@06) ($Snap.second $t@85@06))))
(assert (=
  ($Snap.second $t@85@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@85@06))
    ($Snap.second ($Snap.second $t@85@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@85@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@85@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@85@06))) $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@85@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@86@06 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 12 | 0 <= i@86@06 | live]
; [else-branch: 12 | !(0 <= i@86@06) | live]
(push) ; 5
; [then-branch: 12 | 0 <= i@86@06]
(assert (<= 0 i@86@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 12 | !(0 <= i@86@06)]
(assert (not (<= 0 i@86@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 13 | i@86@06 < |First:(Second:($t@85@06))| && 0 <= i@86@06 | live]
; [else-branch: 13 | !(i@86@06 < |First:(Second:($t@85@06))| && 0 <= i@86@06) | live]
(push) ; 5
; [then-branch: 13 | i@86@06 < |First:(Second:($t@85@06))| && 0 <= i@86@06]
(assert (and
  (<
    i@86@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))
  (<= 0 i@86@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@86@06 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1419
;  :arith-add-rows          104
;  :arith-assert-diseq      37
;  :arith-assert-lower      118
;  :arith-assert-upper      70
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   81
;  :datatype-splits         143
;  :decisions               291
;  :del-clause              418
;  :final-checks            43
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1130
;  :mk-clause               420
;  :num-allocs              4194714
;  :num-checks              131
;  :propagations            136
;  :quant-instantiations    99
;  :rlimit-count            161418)
; [eval] -1
(push) ; 6
; [then-branch: 14 | First:(Second:($t@85@06))[i@86@06] == -1 | live]
; [else-branch: 14 | First:(Second:($t@85@06))[i@86@06] != -1 | live]
(push) ; 7
; [then-branch: 14 | First:(Second:($t@85@06))[i@86@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
    i@86@06)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 14 | First:(Second:($t@85@06))[i@86@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      i@86@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@86@06 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1419
;  :arith-add-rows          104
;  :arith-assert-diseq      37
;  :arith-assert-lower      118
;  :arith-assert-upper      70
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   81
;  :datatype-splits         143
;  :decisions               291
;  :del-clause              418
;  :final-checks            43
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1131
;  :mk-clause               420
;  :num-allocs              4194714
;  :num-checks              132
;  :propagations            136
;  :quant-instantiations    99
;  :rlimit-count            161569)
(push) ; 8
; [then-branch: 15 | 0 <= First:(Second:($t@85@06))[i@86@06] | live]
; [else-branch: 15 | !(0 <= First:(Second:($t@85@06))[i@86@06]) | live]
(push) ; 9
; [then-branch: 15 | 0 <= First:(Second:($t@85@06))[i@86@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
    i@86@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@86@06 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1419
;  :arith-add-rows          104
;  :arith-assert-diseq      38
;  :arith-assert-lower      121
;  :arith-assert-upper      70
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        8
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   81
;  :datatype-splits         143
;  :decisions               291
;  :del-clause              418
;  :final-checks            43
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1134
;  :mk-clause               421
;  :num-allocs              4194714
;  :num-checks              133
;  :propagations            136
;  :quant-instantiations    99
;  :rlimit-count            161672)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 15 | !(0 <= First:(Second:($t@85@06))[i@86@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      i@86@06))))
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
; [else-branch: 13 | !(i@86@06 < |First:(Second:($t@85@06))| && 0 <= i@86@06)]
(assert (not
  (and
    (<
      i@86@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))
    (<= 0 i@86@06))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@86@06 Int)) (!
  (implies
    (and
      (<
        i@86@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))
      (<= 0 i@86@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
          i@86@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
            i@86@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
            i@86@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
    i@86@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1436
;  :arith-add-rows          104
;  :arith-assert-diseq      38
;  :arith-assert-lower      122
;  :arith-assert-upper      71
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        8
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   81
;  :datatype-splits         143
;  :decisions               291
;  :del-clause              419
;  :final-checks            43
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1153
;  :mk-clause               431
;  :num-allocs              4194714
;  :num-checks              134
;  :propagations            140
;  :quant-instantiations    101
;  :rlimit-count            162731)
(push) ; 3
; [then-branch: 16 | 0 <= First:(Second:(Second:($t@83@06)))[0] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:($t@83@06)))[0]) | live]
(push) ; 4
; [then-branch: 16 | 0 <= First:(Second:(Second:($t@83@06)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1436
;  :arith-add-rows          104
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      71
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        8
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   81
;  :datatype-splits         143
;  :decisions               291
;  :del-clause              419
;  :final-checks            43
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1159
;  :mk-clause               437
;  :num-allocs              4194714
;  :num-checks              135
;  :propagations            140
;  :quant-instantiations    102
;  :rlimit-count            162894)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1436
;  :arith-add-rows          104
;  :arith-assert-diseq      38
;  :arith-assert-lower      123
;  :arith-assert-upper      71
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        8
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               123
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   81
;  :datatype-splits         143
;  :decisions               291
;  :del-clause              419
;  :final-checks            43
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1159
;  :mk-clause               437
;  :num-allocs              4194714
;  :num-checks              136
;  :propagations            140
;  :quant-instantiations    102
;  :rlimit-count            162903)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1437
;  :arith-add-rows          104
;  :arith-assert-diseq      38
;  :arith-assert-lower      124
;  :arith-assert-upper      72
;  :arith-bound-prop        9
;  :arith-conflicts         7
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        8
;  :arith-pivots            31
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   81
;  :datatype-splits         143
;  :decisions               291
;  :del-clause              419
;  :final-checks            43
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1159
;  :mk-clause               437
;  :num-allocs              4194714
;  :num-checks              137
;  :propagations            144
;  :quant-instantiations    102
;  :rlimit-count            163011)
(pop) ; 4
(push) ; 4
; [else-branch: 16 | !(0 <= First:(Second:(Second:($t@83@06)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1464
;  :arith-add-rows          104
;  :arith-assert-diseq      40
;  :arith-assert-lower      131
;  :arith-assert-upper      75
;  :arith-bound-prop        9
;  :arith-conflicts         7
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        8
;  :arith-pivots            33
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 282
;  :datatype-occurs-check   85
;  :datatype-splits         148
;  :decisions               298
;  :del-clause              440
;  :final-checks            45
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1181
;  :mk-clause               452
;  :num-allocs              4194714
;  :num-checks              138
;  :propagations            151
;  :quant-instantiations    104
;  :rlimit-count            163753)
(push) ; 4
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1487
;  :arith-add-rows          104
;  :arith-assert-diseq      40
;  :arith-assert-lower      132
;  :arith-assert-upper      77
;  :arith-bound-prop        9
;  :arith-conflicts         7
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        8
;  :arith-pivots            33
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   89
;  :datatype-splits         153
;  :decisions               306
;  :del-clause              443
;  :final-checks            47
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1194
;  :mk-clause               455
;  :num-allocs              4194714
;  :num-checks              139
;  :propagations            153
;  :quant-instantiations    105
;  :rlimit-count            164407)
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[0]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[0] | live]
; [else-branch: 17 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[0]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[0]) | live]
(push) ; 4
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[0]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1488
;  :arith-add-rows          104
;  :arith-assert-diseq      40
;  :arith-assert-lower      133
;  :arith-assert-upper      77
;  :arith-bound-prop        9
;  :arith-conflicts         7
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        8
;  :arith-pivots            33
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   89
;  :datatype-splits         153
;  :decisions               306
;  :del-clause              443
;  :final-checks            47
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1201
;  :mk-clause               461
;  :num-allocs              4194714
;  :num-checks              140
;  :propagations            153
;  :quant-instantiations    106
;  :rlimit-count            164611)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 17 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[0]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        0)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1494
;  :arith-add-rows          104
;  :arith-assert-diseq      40
;  :arith-assert-lower      133
;  :arith-assert-upper      77
;  :arith-bound-prop        9
;  :arith-conflicts         7
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        8
;  :arith-pivots            33
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   89
;  :datatype-splits         153
;  :decisions               306
;  :del-clause              449
;  :final-checks            47
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1206
;  :mk-clause               462
;  :num-allocs              4194714
;  :num-checks              141
;  :propagations            153
;  :quant-instantiations    106
;  :rlimit-count            165104)
(push) ; 3
; [then-branch: 18 | 0 <= First:(Second:(Second:($t@83@06)))[1] | live]
; [else-branch: 18 | !(0 <= First:(Second:(Second:($t@83@06)))[1]) | live]
(push) ; 4
; [then-branch: 18 | 0 <= First:(Second:(Second:($t@83@06)))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1494
;  :arith-add-rows          104
;  :arith-assert-diseq      40
;  :arith-assert-lower      134
;  :arith-assert-upper      77
;  :arith-bound-prop        9
;  :arith-conflicts         7
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        8
;  :arith-pivots            33
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   89
;  :datatype-splits         153
;  :decisions               306
;  :del-clause              449
;  :final-checks            47
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1212
;  :mk-clause               468
;  :num-allocs              4194714
;  :num-checks              142
;  :propagations            153
;  :quant-instantiations    107
;  :rlimit-count            165266)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1494
;  :arith-add-rows          104
;  :arith-assert-diseq      40
;  :arith-assert-lower      134
;  :arith-assert-upper      77
;  :arith-bound-prop        9
;  :arith-conflicts         7
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        8
;  :arith-pivots            33
;  :binary-propagations     22
;  :conflicts               124
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   89
;  :datatype-splits         153
;  :decisions               306
;  :del-clause              449
;  :final-checks            47
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1212
;  :mk-clause               468
;  :num-allocs              4194714
;  :num-checks              143
;  :propagations            153
;  :quant-instantiations    107
;  :rlimit-count            165275)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1495
;  :arith-add-rows          104
;  :arith-assert-diseq      40
;  :arith-assert-lower      135
;  :arith-assert-upper      78
;  :arith-bound-prop        9
;  :arith-conflicts         8
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        8
;  :arith-pivots            33
;  :binary-propagations     22
;  :conflicts               125
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   89
;  :datatype-splits         153
;  :decisions               306
;  :del-clause              449
;  :final-checks            47
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1212
;  :mk-clause               468
;  :num-allocs              4194714
;  :num-checks              144
;  :propagations            157
;  :quant-instantiations    107
;  :rlimit-count            165382)
(pop) ; 4
(push) ; 4
; [else-branch: 18 | !(0 <= First:(Second:(Second:($t@83@06)))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1524
;  :arith-add-rows          104
;  :arith-assert-diseq      42
;  :arith-assert-lower      143
;  :arith-assert-upper      83
;  :arith-bound-prop        9
;  :arith-conflicts         8
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :binary-propagations     22
;  :conflicts               125
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 298
;  :datatype-occurs-check   93
;  :datatype-splits         158
;  :decisions               314
;  :del-clause              472
;  :final-checks            49
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1239
;  :mk-clause               485
;  :num-allocs              4194714
;  :num-checks              145
;  :propagations            165
;  :quant-instantiations    110
;  :rlimit-count            166189)
(push) ; 4
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1551
;  :arith-add-rows          104
;  :arith-assert-diseq      42
;  :arith-assert-lower      145
;  :arith-assert-upper      87
;  :arith-bound-prop        9
;  :arith-conflicts         8
;  :arith-eq-adapter        140
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :binary-propagations     22
;  :conflicts               125
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 306
;  :datatype-occurs-check   97
;  :datatype-splits         163
;  :decisions               323
;  :del-clause              477
;  :final-checks            51
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1257
;  :mk-clause               490
;  :num-allocs              4194714
;  :num-checks              146
;  :propagations            168
;  :quant-instantiations    112
;  :rlimit-count            166907)
; [then-branch: 19 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[1]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[1] | live]
; [else-branch: 19 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[1]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[1]) | live]
(push) ; 4
; [then-branch: 19 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[1]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[1]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      1))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1552
;  :arith-add-rows          104
;  :arith-assert-diseq      42
;  :arith-assert-lower      146
;  :arith-assert-upper      87
;  :arith-bound-prop        9
;  :arith-conflicts         8
;  :arith-eq-adapter        141
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :binary-propagations     22
;  :conflicts               125
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 306
;  :datatype-occurs-check   97
;  :datatype-splits         163
;  :decisions               323
;  :del-clause              477
;  :final-checks            51
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1264
;  :mk-clause               496
;  :num-allocs              4194714
;  :num-checks              147
;  :propagations            168
;  :quant-instantiations    113
;  :rlimit-count            167111)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 19 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[1]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[1])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        1)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      1)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1558
;  :arith-add-rows          104
;  :arith-assert-diseq      42
;  :arith-assert-lower      146
;  :arith-assert-upper      87
;  :arith-bound-prop        9
;  :arith-conflicts         8
;  :arith-eq-adapter        141
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :binary-propagations     22
;  :conflicts               125
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 306
;  :datatype-occurs-check   97
;  :datatype-splits         163
;  :decisions               323
;  :del-clause              483
;  :final-checks            51
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1269
;  :mk-clause               497
;  :num-allocs              4194714
;  :num-checks              148
;  :propagations            168
;  :quant-instantiations    113
;  :rlimit-count            167614)
(push) ; 3
; [then-branch: 20 | 0 <= First:(Second:(Second:($t@83@06)))[2] | live]
; [else-branch: 20 | !(0 <= First:(Second:(Second:($t@83@06)))[2]) | live]
(push) ; 4
; [then-branch: 20 | 0 <= First:(Second:(Second:($t@83@06)))[2]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1558
;  :arith-add-rows          104
;  :arith-assert-diseq      42
;  :arith-assert-lower      147
;  :arith-assert-upper      87
;  :arith-bound-prop        9
;  :arith-conflicts         8
;  :arith-eq-adapter        142
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :binary-propagations     22
;  :conflicts               125
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 306
;  :datatype-occurs-check   97
;  :datatype-splits         163
;  :decisions               323
;  :del-clause              483
;  :final-checks            51
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1275
;  :mk-clause               503
;  :num-allocs              4194714
;  :num-checks              149
;  :propagations            168
;  :quant-instantiations    114
;  :rlimit-count            167776)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1558
;  :arith-add-rows          104
;  :arith-assert-diseq      42
;  :arith-assert-lower      147
;  :arith-assert-upper      87
;  :arith-bound-prop        9
;  :arith-conflicts         8
;  :arith-eq-adapter        142
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :binary-propagations     22
;  :conflicts               125
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 306
;  :datatype-occurs-check   97
;  :datatype-splits         163
;  :decisions               323
;  :del-clause              483
;  :final-checks            51
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1275
;  :mk-clause               503
;  :num-allocs              4194714
;  :num-checks              150
;  :propagations            168
;  :quant-instantiations    114
;  :rlimit-count            167785)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1559
;  :arith-add-rows          104
;  :arith-assert-diseq      42
;  :arith-assert-lower      148
;  :arith-assert-upper      88
;  :arith-bound-prop        9
;  :arith-conflicts         9
;  :arith-eq-adapter        142
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 306
;  :datatype-occurs-check   97
;  :datatype-splits         163
;  :decisions               323
;  :del-clause              483
;  :final-checks            51
;  :interface-eqs           3
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1275
;  :mk-clause               503
;  :num-allocs              4194714
;  :num-checks              151
;  :propagations            172
;  :quant-instantiations    114
;  :rlimit-count            167892)
(pop) ; 4
(push) ; 4
; [else-branch: 20 | !(0 <= First:(Second:(Second:($t@83@06)))[2])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          2))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        2))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1593
;  :arith-add-rows          104
;  :arith-assert-diseq      44
;  :arith-assert-lower      157
;  :arith-assert-upper      96
;  :arith-bound-prop        9
;  :arith-conflicts         9
;  :arith-eq-adapter        148
;  :arith-fixed-eqs         19
;  :arith-offset-eqs        8
;  :arith-pivots            38
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 314
;  :datatype-occurs-check   101
;  :datatype-splits         168
;  :decisions               333
;  :del-clause              510
;  :final-checks            54
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1309
;  :mk-clause               524
;  :num-allocs              4194714
;  :num-checks              152
;  :propagations            182
;  :quant-instantiations    118
;  :rlimit-count            168795)
(push) ; 4
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        2))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      2)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1625
;  :arith-add-rows          104
;  :arith-assert-diseq      46
;  :arith-assert-lower      166
;  :arith-assert-upper      103
;  :arith-bound-prop        9
;  :arith-conflicts         9
;  :arith-eq-adapter        153
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 322
;  :datatype-occurs-check   105
;  :datatype-splits         173
;  :decisions               344
;  :del-clause              540
;  :final-checks            56
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1341
;  :mk-clause               554
;  :num-allocs              4194714
;  :num-checks              153
;  :propagations            195
;  :quant-instantiations    122
;  :rlimit-count            169650)
; [then-branch: 21 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[2]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[2] | live]
; [else-branch: 21 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[2]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[2]) | live]
(push) ; 4
; [then-branch: 21 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[2]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[2]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        2))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      2))))
; [eval] diz.Main_process_state[2] == -1
; [eval] diz.Main_process_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1626
;  :arith-add-rows          104
;  :arith-assert-diseq      46
;  :arith-assert-lower      167
;  :arith-assert-upper      103
;  :arith-bound-prop        9
;  :arith-conflicts         9
;  :arith-eq-adapter        154
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 322
;  :datatype-occurs-check   105
;  :datatype-splits         173
;  :decisions               344
;  :del-clause              540
;  :final-checks            56
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1348
;  :mk-clause               560
;  :num-allocs              4194714
;  :num-checks              154
;  :propagations            195
;  :quant-instantiations    123
;  :rlimit-count            169853)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 21 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[2]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[2])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          2))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        2)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          2))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        2)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      2)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1632
;  :arith-add-rows          104
;  :arith-assert-diseq      46
;  :arith-assert-lower      167
;  :arith-assert-upper      103
;  :arith-bound-prop        9
;  :arith-conflicts         9
;  :arith-eq-adapter        154
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 322
;  :datatype-occurs-check   105
;  :datatype-splits         173
;  :decisions               344
;  :del-clause              546
;  :final-checks            56
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1353
;  :mk-clause               561
;  :num-allocs              4194714
;  :num-checks              155
;  :propagations            195
;  :quant-instantiations    123
;  :rlimit-count            170366)
(push) ; 3
; [then-branch: 22 | 0 <= First:(Second:(Second:($t@83@06)))[0] | live]
; [else-branch: 22 | !(0 <= First:(Second:(Second:($t@83@06)))[0]) | live]
(push) ; 4
; [then-branch: 22 | 0 <= First:(Second:(Second:($t@83@06)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1632
;  :arith-add-rows          104
;  :arith-assert-diseq      46
;  :arith-assert-lower      168
;  :arith-assert-upper      103
;  :arith-bound-prop        9
;  :arith-conflicts         9
;  :arith-eq-adapter        155
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 322
;  :datatype-occurs-check   105
;  :datatype-splits         173
;  :decisions               344
;  :del-clause              546
;  :final-checks            56
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1358
;  :mk-clause               567
;  :num-allocs              4194714
;  :num-checks              156
;  :propagations            195
;  :quant-instantiations    124
;  :rlimit-count            170483)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1632
;  :arith-add-rows          104
;  :arith-assert-diseq      46
;  :arith-assert-lower      168
;  :arith-assert-upper      103
;  :arith-bound-prop        9
;  :arith-conflicts         9
;  :arith-eq-adapter        155
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               126
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 322
;  :datatype-occurs-check   105
;  :datatype-splits         173
;  :decisions               344
;  :del-clause              546
;  :final-checks            56
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1358
;  :mk-clause               567
;  :num-allocs              4194714
;  :num-checks              157
;  :propagations            195
;  :quant-instantiations    124
;  :rlimit-count            170492)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1633
;  :arith-add-rows          104
;  :arith-assert-diseq      46
;  :arith-assert-lower      169
;  :arith-assert-upper      104
;  :arith-bound-prop        9
;  :arith-conflicts         10
;  :arith-eq-adapter        155
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               127
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 322
;  :datatype-occurs-check   105
;  :datatype-splits         173
;  :decisions               344
;  :del-clause              546
;  :final-checks            56
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1358
;  :mk-clause               567
;  :num-allocs              4194714
;  :num-checks              158
;  :propagations            199
;  :quant-instantiations    124
;  :rlimit-count            170600)
(pop) ; 4
(push) ; 4
; [else-branch: 22 | !(0 <= First:(Second:(Second:($t@83@06)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1666
;  :arith-add-rows          104
;  :arith-assert-diseq      46
;  :arith-assert-lower      172
;  :arith-assert-upper      109
;  :arith-bound-prop        9
;  :arith-conflicts         10
;  :arith-eq-adapter        158
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               127
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 330
;  :datatype-occurs-check   109
;  :datatype-splits         178
;  :decisions               354
;  :del-clause              561
;  :final-checks            58
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1377
;  :mk-clause               576
;  :num-allocs              4194714
;  :num-checks              159
;  :propagations            203
;  :quant-instantiations    126
;  :rlimit-count            171364
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1720
;  :arith-add-rows          104
;  :arith-assert-diseq      47
;  :arith-assert-lower      177
;  :arith-assert-upper      114
;  :arith-bound-prop        9
;  :arith-conflicts         10
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               129
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 345
;  :datatype-occurs-check   117
;  :datatype-splits         191
;  :decisions               370
;  :del-clause              569
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1416
;  :mk-clause               584
;  :num-allocs              4194714
;  :num-checks              160
;  :propagations            208
;  :quant-instantiations    129
;  :rlimit-count            172247
;  :time                    0.00)
; [then-branch: 23 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[0]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[0]) | live]
; [else-branch: 23 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[0]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[0] | live]
(push) ; 4
; [then-branch: 23 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[0]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1720
;  :arith-add-rows          104
;  :arith-assert-diseq      47
;  :arith-assert-lower      177
;  :arith-assert-upper      114
;  :arith-bound-prop        9
;  :arith-conflicts         10
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               129
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 345
;  :datatype-occurs-check   117
;  :datatype-splits         191
;  :decisions               370
;  :del-clause              569
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1416
;  :mk-clause               585
;  :num-allocs              4194714
;  :num-checks              161
;  :propagations            208
;  :quant-instantiations    129
;  :rlimit-count            172436)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1720
;  :arith-add-rows          104
;  :arith-assert-diseq      47
;  :arith-assert-lower      177
;  :arith-assert-upper      114
;  :arith-bound-prop        9
;  :arith-conflicts         10
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               129
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 345
;  :datatype-occurs-check   117
;  :datatype-splits         191
;  :decisions               370
;  :del-clause              569
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1416
;  :mk-clause               585
;  :num-allocs              4194714
;  :num-checks              162
;  :propagations            208
;  :quant-instantiations    129
;  :rlimit-count            172451)
(pop) ; 4
(push) ; 4
; [else-branch: 23 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[0]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
            0))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1726
;  :arith-add-rows          104
;  :arith-assert-diseq      47
;  :arith-assert-lower      177
;  :arith-assert-upper      114
;  :arith-bound-prop        9
;  :arith-conflicts         10
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               129
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 345
;  :datatype-occurs-check   117
;  :datatype-splits         191
;  :decisions               370
;  :del-clause              570
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1420
;  :mk-clause               589
;  :num-allocs              4194714
;  :num-checks              163
;  :propagations            208
;  :quant-instantiations    129
;  :rlimit-count            172962)
(push) ; 3
; [then-branch: 24 | 0 <= First:(Second:(Second:($t@83@06)))[1] | live]
; [else-branch: 24 | !(0 <= First:(Second:(Second:($t@83@06)))[1]) | live]
(push) ; 4
; [then-branch: 24 | 0 <= First:(Second:(Second:($t@83@06)))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1726
;  :arith-add-rows          104
;  :arith-assert-diseq      47
;  :arith-assert-lower      178
;  :arith-assert-upper      114
;  :arith-bound-prop        9
;  :arith-conflicts         10
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               129
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 345
;  :datatype-occurs-check   117
;  :datatype-splits         191
;  :decisions               370
;  :del-clause              570
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1425
;  :mk-clause               595
;  :num-allocs              4194714
;  :num-checks              164
;  :propagations            208
;  :quant-instantiations    130
;  :rlimit-count            173079)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1726
;  :arith-add-rows          104
;  :arith-assert-diseq      47
;  :arith-assert-lower      178
;  :arith-assert-upper      114
;  :arith-bound-prop        9
;  :arith-conflicts         10
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               129
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 345
;  :datatype-occurs-check   117
;  :datatype-splits         191
;  :decisions               370
;  :del-clause              570
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1425
;  :mk-clause               595
;  :num-allocs              4194714
;  :num-checks              165
;  :propagations            208
;  :quant-instantiations    130
;  :rlimit-count            173088)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1727
;  :arith-add-rows          104
;  :arith-assert-diseq      47
;  :arith-assert-lower      179
;  :arith-assert-upper      115
;  :arith-bound-prop        9
;  :arith-conflicts         11
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        8
;  :arith-pivots            40
;  :binary-propagations     22
;  :conflicts               130
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 345
;  :datatype-occurs-check   117
;  :datatype-splits         191
;  :decisions               370
;  :del-clause              570
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1425
;  :mk-clause               595
;  :num-allocs              4194714
;  :num-checks              166
;  :propagations            212
;  :quant-instantiations    130
;  :rlimit-count            173196)
(pop) ; 4
(push) ; 4
; [else-branch: 24 | !(0 <= First:(Second:(Second:($t@83@06)))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1764
;  :arith-add-rows          104
;  :arith-assert-diseq      47
;  :arith-assert-lower      183
;  :arith-assert-upper      121
;  :arith-bound-prop        11
;  :arith-conflicts         11
;  :arith-eq-adapter        166
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        8
;  :arith-pivots            42
;  :binary-propagations     22
;  :conflicts               130
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 353
;  :datatype-occurs-check   121
;  :datatype-splits         196
;  :decisions               380
;  :del-clause              593
;  :final-checks            64
;  :interface-eqs           4
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1454
;  :mk-clause               612
;  :num-allocs              4194714
;  :num-checks              167
;  :propagations            219
;  :quant-instantiations    133
;  :rlimit-count            174021
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          104
;  :arith-assert-diseq      48
;  :arith-assert-lower      189
;  :arith-assert-upper      126
;  :arith-bound-prop        13
;  :arith-conflicts         11
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        8
;  :arith-pivots            44
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 368
;  :datatype-occurs-check   129
;  :datatype-splits         205
;  :decisions               395
;  :del-clause              614
;  :final-checks            69
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1499
;  :mk-clause               633
;  :num-allocs              4194714
;  :num-checks              168
;  :propagations            228
;  :quant-instantiations    136
;  :rlimit-count            174946
;  :time                    0.00)
; [then-branch: 25 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[1]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[1]) | live]
; [else-branch: 25 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[1]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[1] | live]
(push) ; 4
; [then-branch: 25 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[1]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[1])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        1)))))
; [eval] diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          104
;  :arith-assert-diseq      48
;  :arith-assert-lower      189
;  :arith-assert-upper      126
;  :arith-bound-prop        13
;  :arith-conflicts         11
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        8
;  :arith-pivots            44
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 368
;  :datatype-occurs-check   129
;  :datatype-splits         205
;  :decisions               395
;  :del-clause              614
;  :final-checks            69
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1499
;  :mk-clause               634
;  :num-allocs              4194714
;  :num-checks              169
;  :propagations            228
;  :quant-instantiations    136
;  :rlimit-count            175135)
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          104
;  :arith-assert-diseq      48
;  :arith-assert-lower      189
;  :arith-assert-upper      126
;  :arith-bound-prop        13
;  :arith-conflicts         11
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        8
;  :arith-pivots            44
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 368
;  :datatype-occurs-check   129
;  :datatype-splits         205
;  :decisions               395
;  :del-clause              614
;  :final-checks            69
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1499
;  :mk-clause               634
;  :num-allocs              4194714
;  :num-checks              170
;  :propagations            228
;  :quant-instantiations    136
;  :rlimit-count            175150)
(pop) ; 4
(push) ; 4
; [else-branch: 25 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[1]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[1]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
            1))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1824
;  :arith-add-rows          104
;  :arith-assert-diseq      48
;  :arith-assert-lower      189
;  :arith-assert-upper      126
;  :arith-bound-prop        13
;  :arith-conflicts         11
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        8
;  :arith-pivots            44
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 368
;  :datatype-occurs-check   129
;  :datatype-splits         205
;  :decisions               395
;  :del-clause              615
;  :final-checks            69
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1502
;  :mk-clause               638
;  :num-allocs              4194714
;  :num-checks              171
;  :propagations            228
;  :quant-instantiations    136
;  :rlimit-count            175579)
(push) ; 3
; [then-branch: 26 | 0 <= First:(Second:(Second:($t@83@06)))[2] | live]
; [else-branch: 26 | !(0 <= First:(Second:(Second:($t@83@06)))[2]) | live]
(push) ; 4
; [then-branch: 26 | 0 <= First:(Second:(Second:($t@83@06)))[2]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1824
;  :arith-add-rows          104
;  :arith-assert-diseq      48
;  :arith-assert-lower      190
;  :arith-assert-upper      126
;  :arith-bound-prop        13
;  :arith-conflicts         11
;  :arith-eq-adapter        172
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        8
;  :arith-pivots            44
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 368
;  :datatype-occurs-check   129
;  :datatype-splits         205
;  :decisions               395
;  :del-clause              615
;  :final-checks            69
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1507
;  :mk-clause               644
;  :num-allocs              4194714
;  :num-checks              172
;  :propagations            228
;  :quant-instantiations    137
;  :rlimit-count            175718)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1824
;  :arith-add-rows          104
;  :arith-assert-diseq      48
;  :arith-assert-lower      190
;  :arith-assert-upper      126
;  :arith-bound-prop        13
;  :arith-conflicts         11
;  :arith-eq-adapter        172
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        8
;  :arith-pivots            44
;  :binary-propagations     22
;  :conflicts               132
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 368
;  :datatype-occurs-check   129
;  :datatype-splits         205
;  :decisions               395
;  :del-clause              615
;  :final-checks            69
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1507
;  :mk-clause               644
;  :num-allocs              4194714
;  :num-checks              173
;  :propagations            228
;  :quant-instantiations    137
;  :rlimit-count            175727)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1825
;  :arith-add-rows          104
;  :arith-assert-diseq      48
;  :arith-assert-lower      191
;  :arith-assert-upper      127
;  :arith-bound-prop        13
;  :arith-conflicts         12
;  :arith-eq-adapter        172
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        8
;  :arith-pivots            44
;  :binary-propagations     22
;  :conflicts               133
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 368
;  :datatype-occurs-check   129
;  :datatype-splits         205
;  :decisions               395
;  :del-clause              615
;  :final-checks            69
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1507
;  :mk-clause               644
;  :num-allocs              4194714
;  :num-checks              174
;  :propagations            232
;  :quant-instantiations    137
;  :rlimit-count            175835)
(pop) ; 4
(push) ; 4
; [else-branch: 26 | !(0 <= First:(Second:(Second:($t@83@06)))[2])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        2))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      2)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1885
;  :arith-add-rows          104
;  :arith-assert-diseq      49
;  :arith-assert-lower      198
;  :arith-assert-upper      134
;  :arith-bound-prop        17
;  :arith-conflicts         12
;  :arith-eq-adapter        178
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        8
;  :arith-pivots            48
;  :binary-propagations     22
;  :conflicts               135
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 382
;  :datatype-occurs-check   137
;  :datatype-splits         213
;  :decisions               411
;  :del-clause              659
;  :final-checks            73
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1563
;  :mk-clause               682
;  :num-allocs              4194714
;  :num-checks              175
;  :propagations            246
;  :quant-instantiations    142
;  :rlimit-count            176874
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          2))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        2))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1960
;  :arith-add-rows          104
;  :arith-assert-diseq      50
;  :arith-assert-lower      209
;  :arith-assert-upper      147
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        187
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 396
;  :datatype-occurs-check   145
;  :datatype-splits         224
;  :decisions               426
;  :del-clause              701
;  :final-checks            77
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1642
;  :mk-clause               724
;  :num-allocs              4194714
;  :num-checks              176
;  :propagations            273
;  :quant-instantiations    151
;  :rlimit-count            177986
;  :time                    0.00)
; [then-branch: 27 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[2]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[2]) | live]
; [else-branch: 27 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[2]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[2] | live]
(push) ; 4
; [then-branch: 27 | !(First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[2]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[2])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          2))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        2)))))
; [eval] diz.Main_process_state[2] == old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1960
;  :arith-add-rows          104
;  :arith-assert-diseq      50
;  :arith-assert-lower      209
;  :arith-assert-upper      147
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        187
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 396
;  :datatype-occurs-check   145
;  :datatype-splits         224
;  :decisions               426
;  :del-clause              701
;  :final-checks            77
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1642
;  :mk-clause               725
;  :num-allocs              4194714
;  :num-checks              177
;  :propagations            273
;  :quant-instantiations    151
;  :rlimit-count            178175)
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1960
;  :arith-add-rows          104
;  :arith-assert-diseq      50
;  :arith-assert-lower      209
;  :arith-assert-upper      147
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        187
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 396
;  :datatype-occurs-check   145
;  :datatype-splits         224
;  :decisions               426
;  :del-clause              701
;  :final-checks            77
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1642
;  :mk-clause               725
;  :num-allocs              4194714
;  :num-checks              178
;  :propagations            273
;  :quant-instantiations    151
;  :rlimit-count            178190)
(pop) ; 4
(push) ; 4
; [else-branch: 27 | First:(Second:(Second:(Second:(Second:($t@83@06)))))[First:(Second:(Second:($t@83@06)))[2]] == 0 && 0 <= First:(Second:(Second:($t@83@06)))[2]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
        2))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
            2))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
          2))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@83@06))))
      2))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main_wakeup_after_wait_EncodedGlobalVariables ----------
(declare-const diz@87@06 $Ref)
(declare-const globals@88@06 $Ref)
(declare-const diz@89@06 $Ref)
(declare-const globals@90@06 $Ref)
(push) ; 1
(declare-const $t@91@06 $Snap)
(assert (= $t@91@06 ($Snap.combine ($Snap.first $t@91@06) ($Snap.second $t@91@06))))
(assert (= ($Snap.first $t@91@06) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@89@06 $Ref.null)))
(assert (=
  ($Snap.second $t@91@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@91@06))
    ($Snap.second ($Snap.second $t@91@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@91@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@91@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@91@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@91@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@91@06))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06)))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06)))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@92@06 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 28 | 0 <= i@92@06 | live]
; [else-branch: 28 | !(0 <= i@92@06) | live]
(push) ; 4
; [then-branch: 28 | 0 <= i@92@06]
(assert (<= 0 i@92@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 28 | !(0 <= i@92@06)]
(assert (not (<= 0 i@92@06)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 29 | i@92@06 < |First:(Second:(Second:($t@91@06)))| && 0 <= i@92@06 | live]
; [else-branch: 29 | !(i@92@06 < |First:(Second:(Second:($t@91@06)))| && 0 <= i@92@06) | live]
(push) ; 4
; [then-branch: 29 | i@92@06 < |First:(Second:(Second:($t@91@06)))| && 0 <= i@92@06]
(assert (and
  (<
    i@92@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))
  (<= 0 i@92@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 5
(assert (not (>= i@92@06 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1998
;  :arith-add-rows          104
;  :arith-assert-diseq      52
;  :arith-assert-lower      216
;  :arith-assert-upper      150
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 396
;  :datatype-occurs-check   145
;  :datatype-splits         224
;  :decisions               426
;  :del-clause              724
;  :final-checks            77
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1671
;  :mk-clause               731
;  :num-allocs              4194714
;  :num-checks              179
;  :propagations            275
;  :quant-instantiations    157
;  :rlimit-count            179422)
; [eval] -1
(push) ; 5
; [then-branch: 30 | First:(Second:(Second:($t@91@06)))[i@92@06] == -1 | live]
; [else-branch: 30 | First:(Second:(Second:($t@91@06)))[i@92@06] != -1 | live]
(push) ; 6
; [then-branch: 30 | First:(Second:(Second:($t@91@06)))[i@92@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    i@92@06)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 30 | First:(Second:(Second:($t@91@06)))[i@92@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      i@92@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@92@06 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1998
;  :arith-add-rows          104
;  :arith-assert-diseq      52
;  :arith-assert-lower      216
;  :arith-assert-upper      150
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 396
;  :datatype-occurs-check   145
;  :datatype-splits         224
;  :decisions               426
;  :del-clause              724
;  :final-checks            77
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1672
;  :mk-clause               731
;  :num-allocs              4194714
;  :num-checks              180
;  :propagations            275
;  :quant-instantiations    157
;  :rlimit-count            179585)
(push) ; 7
; [then-branch: 31 | 0 <= First:(Second:(Second:($t@91@06)))[i@92@06] | live]
; [else-branch: 31 | !(0 <= First:(Second:(Second:($t@91@06)))[i@92@06]) | live]
(push) ; 8
; [then-branch: 31 | 0 <= First:(Second:(Second:($t@91@06)))[i@92@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    i@92@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@92@06 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1998
;  :arith-add-rows          104
;  :arith-assert-diseq      53
;  :arith-assert-lower      219
;  :arith-assert-upper      150
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        192
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               137
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 396
;  :datatype-occurs-check   145
;  :datatype-splits         224
;  :decisions               426
;  :del-clause              724
;  :final-checks            77
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1675
;  :mk-clause               732
;  :num-allocs              4194714
;  :num-checks              181
;  :propagations            275
;  :quant-instantiations    157
;  :rlimit-count            179699)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 31 | !(0 <= First:(Second:(Second:($t@91@06)))[i@92@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      i@92@06))))
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
; [else-branch: 29 | !(i@92@06 < |First:(Second:(Second:($t@91@06)))| && 0 <= i@92@06)]
(assert (not
  (and
    (<
      i@92@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))
    (<= 0 i@92@06))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@92@06 Int)) (!
  (implies
    (and
      (<
        i@92@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))
      (<= 0 i@92@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          i@92@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            i@92@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            i@92@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    i@92@06))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@93@06 $Snap)
(assert (= $t@93@06 ($Snap.combine ($Snap.first $t@93@06) ($Snap.second $t@93@06))))
(assert (=
  ($Snap.second $t@93@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@93@06))
    ($Snap.second ($Snap.second $t@93@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@93@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@93@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@93@06))) $Snap.unit))
; [eval] |diz.Main_process_state| == 3
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@93@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@93@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 6
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))
  6))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@94@06 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 32 | 0 <= i@94@06 | live]
; [else-branch: 32 | !(0 <= i@94@06) | live]
(push) ; 5
; [then-branch: 32 | 0 <= i@94@06]
(assert (<= 0 i@94@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 32 | !(0 <= i@94@06)]
(assert (not (<= 0 i@94@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 33 | i@94@06 < |First:(Second:($t@93@06))| && 0 <= i@94@06 | live]
; [else-branch: 33 | !(i@94@06 < |First:(Second:($t@93@06))| && 0 <= i@94@06) | live]
(push) ; 5
; [then-branch: 33 | i@94@06 < |First:(Second:($t@93@06))| && 0 <= i@94@06]
(assert (and
  (<
    i@94@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))))
  (<= 0 i@94@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@94@06 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2053
;  :arith-add-rows          104
;  :arith-assert-diseq      53
;  :arith-assert-lower      224
;  :arith-assert-upper      153
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               138
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 402
;  :datatype-occurs-check   148
;  :datatype-splits         229
;  :decisions               431
;  :del-clause              731
;  :final-checks            80
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1703
;  :mk-clause               733
;  :num-allocs              4194714
;  :num-checks              183
;  :propagations            275
;  :quant-instantiations    161
;  :rlimit-count            181495)
; [eval] -1
(push) ; 6
; [then-branch: 34 | First:(Second:($t@93@06))[i@94@06] == -1 | live]
; [else-branch: 34 | First:(Second:($t@93@06))[i@94@06] != -1 | live]
(push) ; 7
; [then-branch: 34 | First:(Second:($t@93@06))[i@94@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
    i@94@06)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 34 | First:(Second:($t@93@06))[i@94@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
      i@94@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@94@06 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2053
;  :arith-add-rows          104
;  :arith-assert-diseq      53
;  :arith-assert-lower      224
;  :arith-assert-upper      153
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               138
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 402
;  :datatype-occurs-check   148
;  :datatype-splits         229
;  :decisions               431
;  :del-clause              731
;  :final-checks            80
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1704
;  :mk-clause               733
;  :num-allocs              4194714
;  :num-checks              184
;  :propagations            275
;  :quant-instantiations    161
;  :rlimit-count            181646)
(push) ; 8
; [then-branch: 35 | 0 <= First:(Second:($t@93@06))[i@94@06] | live]
; [else-branch: 35 | !(0 <= First:(Second:($t@93@06))[i@94@06]) | live]
(push) ; 9
; [then-branch: 35 | 0 <= First:(Second:($t@93@06))[i@94@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
    i@94@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@94@06 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2053
;  :arith-add-rows          104
;  :arith-assert-diseq      54
;  :arith-assert-lower      227
;  :arith-assert-upper      153
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        195
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               138
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 402
;  :datatype-occurs-check   148
;  :datatype-splits         229
;  :decisions               431
;  :del-clause              731
;  :final-checks            80
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1707
;  :mk-clause               734
;  :num-allocs              4194714
;  :num-checks              185
;  :propagations            275
;  :quant-instantiations    161
;  :rlimit-count            181750)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 35 | !(0 <= First:(Second:($t@93@06))[i@94@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
      i@94@06))))
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
; [else-branch: 33 | !(i@94@06 < |First:(Second:($t@93@06))| && 0 <= i@94@06)]
(assert (not
  (and
    (<
      i@94@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))))
    (<= 0 i@94@06))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@94@06 Int)) (!
  (implies
    (and
      (<
        i@94@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))))
      (<= 0 i@94@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
          i@94@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
            i@94@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
            i@94@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
    i@94@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2070
;  :arith-add-rows          104
;  :arith-assert-diseq      54
;  :arith-assert-lower      228
;  :arith-assert-upper      154
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        196
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               138
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 402
;  :datatype-occurs-check   148
;  :datatype-splits         229
;  :decisions               431
;  :del-clause              732
;  :final-checks            80
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1726
;  :mk-clause               744
;  :num-allocs              4194714
;  :num-checks              186
;  :propagations            279
;  :quant-instantiations    163
;  :rlimit-count            182809)
(push) ; 3
; [then-branch: 36 | 0 <= First:(Second:(Second:($t@91@06)))[0] | live]
; [else-branch: 36 | !(0 <= First:(Second:(Second:($t@91@06)))[0]) | live]
(push) ; 4
; [then-branch: 36 | 0 <= First:(Second:(Second:($t@91@06)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2070
;  :arith-add-rows          104
;  :arith-assert-diseq      54
;  :arith-assert-lower      229
;  :arith-assert-upper      154
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               138
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 402
;  :datatype-occurs-check   148
;  :datatype-splits         229
;  :decisions               431
;  :del-clause              732
;  :final-checks            80
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1732
;  :mk-clause               750
;  :num-allocs              4194714
;  :num-checks              187
;  :propagations            279
;  :quant-instantiations    164
;  :rlimit-count            182965)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2070
;  :arith-add-rows          104
;  :arith-assert-diseq      54
;  :arith-assert-lower      229
;  :arith-assert-upper      154
;  :arith-bound-prop        21
;  :arith-conflicts         12
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               138
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 402
;  :datatype-occurs-check   148
;  :datatype-splits         229
;  :decisions               431
;  :del-clause              732
;  :final-checks            80
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1732
;  :mk-clause               750
;  :num-allocs              4194714
;  :num-checks              188
;  :propagations            279
;  :quant-instantiations    164
;  :rlimit-count            182974)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2071
;  :arith-add-rows          104
;  :arith-assert-diseq      54
;  :arith-assert-lower      230
;  :arith-assert-upper      155
;  :arith-bound-prop        21
;  :arith-conflicts         13
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               139
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 402
;  :datatype-occurs-check   148
;  :datatype-splits         229
;  :decisions               431
;  :del-clause              732
;  :final-checks            80
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1732
;  :mk-clause               750
;  :num-allocs              4194714
;  :num-checks              189
;  :propagations            283
;  :quant-instantiations    164
;  :rlimit-count            183081)
(push) ; 5
; [then-branch: 37 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0 | live]
; [else-branch: 37 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] != 0 | live]
(push) ; 6
; [then-branch: 37 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      0))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 37 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2071
;  :arith-add-rows          104
;  :arith-assert-diseq      54
;  :arith-assert-lower      230
;  :arith-assert-upper      155
;  :arith-bound-prop        21
;  :arith-conflicts         13
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               139
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 402
;  :datatype-occurs-check   148
;  :datatype-splits         229
;  :decisions               431
;  :del-clause              732
;  :final-checks            80
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1733
;  :mk-clause               750
;  :num-allocs              4194714
;  :num-checks              190
;  :propagations            283
;  :quant-instantiations    164
;  :rlimit-count            183300)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2071
;  :arith-add-rows          104
;  :arith-assert-diseq      54
;  :arith-assert-lower      230
;  :arith-assert-upper      155
;  :arith-bound-prop        21
;  :arith-conflicts         13
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               139
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 402
;  :datatype-occurs-check   148
;  :datatype-splits         229
;  :decisions               431
;  :del-clause              732
;  :final-checks            80
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1733
;  :mk-clause               750
;  :num-allocs              4194714
;  :num-checks              191
;  :propagations            283
;  :quant-instantiations    164
;  :rlimit-count            183309)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2072
;  :arith-add-rows          104
;  :arith-assert-diseq      54
;  :arith-assert-lower      231
;  :arith-assert-upper      156
;  :arith-bound-prop        21
;  :arith-conflicts         14
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        8
;  :arith-pivots            56
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 402
;  :datatype-occurs-check   148
;  :datatype-splits         229
;  :decisions               431
;  :del-clause              732
;  :final-checks            80
;  :interface-eqs           5
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1733
;  :mk-clause               750
;  :num-allocs              4194714
;  :num-checks              192
;  :propagations            287
;  :quant-instantiations    164
;  :rlimit-count            183416)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 36 | !(0 <= First:(Second:(Second:($t@91@06)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2101
;  :arith-add-rows          104
;  :arith-assert-diseq      56
;  :arith-assert-lower      238
;  :arith-assert-upper      160
;  :arith-bound-prop        21
;  :arith-conflicts         14
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        8
;  :arith-pivots            59
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 410
;  :datatype-occurs-check   152
;  :datatype-splits         234
;  :decisions               440
;  :del-clause              756
;  :final-checks            83
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1758
;  :mk-clause               768
;  :num-allocs              4194714
;  :num-checks              193
;  :propagations            295
;  :quant-instantiations    166
;  :rlimit-count            184250
;  :time                    0.00)
(push) ; 4
(assert (not (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2124
;  :arith-add-rows          104
;  :arith-assert-diseq      56
;  :arith-assert-lower      239
;  :arith-assert-upper      162
;  :arith-bound-prop        21
;  :arith-conflicts         14
;  :arith-eq-adapter        202
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        8
;  :arith-pivots            59
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   156
;  :datatype-splits         239
;  :decisions               448
;  :del-clause              762
;  :final-checks            85
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1773
;  :mk-clause               774
;  :num-allocs              4194714
;  :num-checks              194
;  :propagations            297
;  :quant-instantiations    167
;  :rlimit-count            184938)
; [then-branch: 38 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[0] | live]
; [else-branch: 38 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[0]) | live]
(push) ; 4
; [then-branch: 38 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[0]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2124
;  :arith-add-rows          104
;  :arith-assert-diseq      56
;  :arith-assert-lower      240
;  :arith-assert-upper      162
;  :arith-bound-prop        21
;  :arith-conflicts         14
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        8
;  :arith-pivots            59
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   156
;  :datatype-splits         239
;  :decisions               448
;  :del-clause              762
;  :final-checks            85
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1781
;  :mk-clause               781
;  :num-allocs              4194714
;  :num-checks              195
;  :propagations            297
;  :quant-instantiations    168
;  :rlimit-count            185163)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 38 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2130
;  :arith-add-rows          104
;  :arith-assert-diseq      56
;  :arith-assert-lower      240
;  :arith-assert-upper      162
;  :arith-bound-prop        21
;  :arith-conflicts         14
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        8
;  :arith-pivots            59
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   156
;  :datatype-splits         239
;  :decisions               448
;  :del-clause              769
;  :final-checks            85
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1788
;  :mk-clause               785
;  :num-allocs              4194714
;  :num-checks              196
;  :propagations            297
;  :quant-instantiations    168
;  :rlimit-count            185702)
(push) ; 3
; [then-branch: 39 | 0 <= First:(Second:(Second:($t@91@06)))[1] | live]
; [else-branch: 39 | !(0 <= First:(Second:(Second:($t@91@06)))[1]) | live]
(push) ; 4
; [then-branch: 39 | 0 <= First:(Second:(Second:($t@91@06)))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2130
;  :arith-add-rows          104
;  :arith-assert-diseq      56
;  :arith-assert-lower      241
;  :arith-assert-upper      162
;  :arith-bound-prop        21
;  :arith-conflicts         14
;  :arith-eq-adapter        204
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        8
;  :arith-pivots            59
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   156
;  :datatype-splits         239
;  :decisions               448
;  :del-clause              769
;  :final-checks            85
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1794
;  :mk-clause               791
;  :num-allocs              4194714
;  :num-checks              197
;  :propagations            297
;  :quant-instantiations    169
;  :rlimit-count            185858)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2130
;  :arith-add-rows          104
;  :arith-assert-diseq      56
;  :arith-assert-lower      241
;  :arith-assert-upper      162
;  :arith-bound-prop        21
;  :arith-conflicts         14
;  :arith-eq-adapter        204
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        8
;  :arith-pivots            59
;  :binary-propagations     22
;  :conflicts               140
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   156
;  :datatype-splits         239
;  :decisions               448
;  :del-clause              769
;  :final-checks            85
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1794
;  :mk-clause               791
;  :num-allocs              4194714
;  :num-checks              198
;  :propagations            297
;  :quant-instantiations    169
;  :rlimit-count            185867)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2131
;  :arith-add-rows          104
;  :arith-assert-diseq      56
;  :arith-assert-lower      242
;  :arith-assert-upper      163
;  :arith-bound-prop        21
;  :arith-conflicts         15
;  :arith-eq-adapter        204
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        8
;  :arith-pivots            59
;  :binary-propagations     22
;  :conflicts               141
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   156
;  :datatype-splits         239
;  :decisions               448
;  :del-clause              769
;  :final-checks            85
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1794
;  :mk-clause               791
;  :num-allocs              4194714
;  :num-checks              199
;  :propagations            301
;  :quant-instantiations    169
;  :rlimit-count            185974)
(push) ; 5
; [then-branch: 40 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0 | live]
; [else-branch: 40 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] != 0 | live]
(push) ; 6
; [then-branch: 40 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      1))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 40 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2131
;  :arith-add-rows          104
;  :arith-assert-diseq      56
;  :arith-assert-lower      242
;  :arith-assert-upper      163
;  :arith-bound-prop        21
;  :arith-conflicts         15
;  :arith-eq-adapter        204
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        8
;  :arith-pivots            59
;  :binary-propagations     22
;  :conflicts               141
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   156
;  :datatype-splits         239
;  :decisions               448
;  :del-clause              769
;  :final-checks            85
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1795
;  :mk-clause               791
;  :num-allocs              4194714
;  :num-checks              200
;  :propagations            301
;  :quant-instantiations    169
;  :rlimit-count            186193)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2131
;  :arith-add-rows          104
;  :arith-assert-diseq      56
;  :arith-assert-lower      242
;  :arith-assert-upper      163
;  :arith-bound-prop        21
;  :arith-conflicts         15
;  :arith-eq-adapter        204
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        8
;  :arith-pivots            59
;  :binary-propagations     22
;  :conflicts               141
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   156
;  :datatype-splits         239
;  :decisions               448
;  :del-clause              769
;  :final-checks            85
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1795
;  :mk-clause               791
;  :num-allocs              4194714
;  :num-checks              201
;  :propagations            301
;  :quant-instantiations    169
;  :rlimit-count            186202)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2132
;  :arith-add-rows          104
;  :arith-assert-diseq      56
;  :arith-assert-lower      243
;  :arith-assert-upper      164
;  :arith-bound-prop        21
;  :arith-conflicts         16
;  :arith-eq-adapter        204
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        8
;  :arith-pivots            59
;  :binary-propagations     22
;  :conflicts               142
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 418
;  :datatype-occurs-check   156
;  :datatype-splits         239
;  :decisions               448
;  :del-clause              769
;  :final-checks            85
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1795
;  :mk-clause               791
;  :num-allocs              4194714
;  :num-checks              202
;  :propagations            305
;  :quant-instantiations    169
;  :rlimit-count            186309)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 39 | !(0 <= First:(Second:(Second:($t@91@06)))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2161
;  :arith-add-rows          104
;  :arith-assert-diseq      58
;  :arith-assert-lower      251
;  :arith-assert-upper      169
;  :arith-bound-prop        21
;  :arith-conflicts         16
;  :arith-eq-adapter        208
;  :arith-fixed-eqs         31
;  :arith-offset-eqs        8
;  :arith-pivots            61
;  :binary-propagations     22
;  :conflicts               142
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 426
;  :datatype-occurs-check   160
;  :datatype-splits         244
;  :decisions               457
;  :del-clause              786
;  :final-checks            87
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1823
;  :mk-clause               802
;  :num-allocs              4194714
;  :num-checks              203
;  :propagations            311
;  :quant-instantiations    172
;  :rlimit-count            187166)
(push) ; 4
(assert (not (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2189
;  :arith-add-rows          104
;  :arith-assert-diseq      60
;  :arith-assert-lower      259
;  :arith-assert-upper      174
;  :arith-bound-prop        21
;  :arith-conflicts         16
;  :arith-eq-adapter        212
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        8
;  :arith-pivots            63
;  :binary-propagations     22
;  :conflicts               142
;  :datatype-accessor-ax    154
;  :datatype-constructor-ax 434
;  :datatype-occurs-check   164
;  :datatype-splits         249
;  :decisions               467
;  :del-clause              810
;  :final-checks            89
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1852
;  :mk-clause               826
;  :num-allocs              4194714
;  :num-checks              204
;  :propagations            323
;  :quant-instantiations    175
;  :rlimit-count            187998)
; [then-branch: 41 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[1] | live]
; [else-branch: 41 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[1]) | live]
(push) ; 4
; [then-branch: 41 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[1]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      1))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2189
;  :arith-add-rows          104
;  :arith-assert-diseq      60
;  :arith-assert-lower      260
;  :arith-assert-upper      174
;  :arith-bound-prop        21
;  :arith-conflicts         16
;  :arith-eq-adapter        213
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        8
;  :arith-pivots            63
;  :binary-propagations     22
;  :conflicts               142
;  :datatype-accessor-ax    154
;  :datatype-constructor-ax 434
;  :datatype-occurs-check   164
;  :datatype-splits         249
;  :decisions               467
;  :del-clause              810
;  :final-checks            89
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1860
;  :mk-clause               833
;  :num-allocs              4194714
;  :num-checks              205
;  :propagations            323
;  :quant-instantiations    176
;  :rlimit-count            188223)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 41 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
      1)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2195
;  :arith-add-rows          104
;  :arith-assert-diseq      60
;  :arith-assert-lower      260
;  :arith-assert-upper      174
;  :arith-bound-prop        21
;  :arith-conflicts         16
;  :arith-eq-adapter        213
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        8
;  :arith-pivots            63
;  :binary-propagations     22
;  :conflicts               142
;  :datatype-accessor-ax    155
;  :datatype-constructor-ax 434
;  :datatype-occurs-check   164
;  :datatype-splits         249
;  :decisions               467
;  :del-clause              817
;  :final-checks            89
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1867
;  :mk-clause               837
;  :num-allocs              4194714
;  :num-checks              206
;  :propagations            323
;  :quant-instantiations    176
;  :rlimit-count            188772)
(push) ; 3
; [then-branch: 42 | 0 <= First:(Second:(Second:($t@91@06)))[2] | live]
; [else-branch: 42 | !(0 <= First:(Second:(Second:($t@91@06)))[2]) | live]
(push) ; 4
; [then-branch: 42 | 0 <= First:(Second:(Second:($t@91@06)))[2]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2195
;  :arith-add-rows          104
;  :arith-assert-diseq      60
;  :arith-assert-lower      261
;  :arith-assert-upper      174
;  :arith-bound-prop        21
;  :arith-conflicts         16
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        8
;  :arith-pivots            63
;  :binary-propagations     22
;  :conflicts               142
;  :datatype-accessor-ax    155
;  :datatype-constructor-ax 434
;  :datatype-occurs-check   164
;  :datatype-splits         249
;  :decisions               467
;  :del-clause              817
;  :final-checks            89
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1873
;  :mk-clause               843
;  :num-allocs              4194714
;  :num-checks              207
;  :propagations            323
;  :quant-instantiations    177
;  :rlimit-count            188929)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2195
;  :arith-add-rows          104
;  :arith-assert-diseq      60
;  :arith-assert-lower      261
;  :arith-assert-upper      174
;  :arith-bound-prop        21
;  :arith-conflicts         16
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        8
;  :arith-pivots            63
;  :binary-propagations     22
;  :conflicts               142
;  :datatype-accessor-ax    155
;  :datatype-constructor-ax 434
;  :datatype-occurs-check   164
;  :datatype-splits         249
;  :decisions               467
;  :del-clause              817
;  :final-checks            89
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1873
;  :mk-clause               843
;  :num-allocs              4194714
;  :num-checks              208
;  :propagations            323
;  :quant-instantiations    177
;  :rlimit-count            188938)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2196
;  :arith-add-rows          104
;  :arith-assert-diseq      60
;  :arith-assert-lower      262
;  :arith-assert-upper      175
;  :arith-bound-prop        21
;  :arith-conflicts         17
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        8
;  :arith-pivots            63
;  :binary-propagations     22
;  :conflicts               143
;  :datatype-accessor-ax    155
;  :datatype-constructor-ax 434
;  :datatype-occurs-check   164
;  :datatype-splits         249
;  :decisions               467
;  :del-clause              817
;  :final-checks            89
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1873
;  :mk-clause               843
;  :num-allocs              4194714
;  :num-checks              209
;  :propagations            327
;  :quant-instantiations    177
;  :rlimit-count            189046)
(push) ; 5
; [then-branch: 43 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0 | live]
; [else-branch: 43 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] != 0 | live]
(push) ; 6
; [then-branch: 43 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      2))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 43 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2196
;  :arith-add-rows          104
;  :arith-assert-diseq      60
;  :arith-assert-lower      262
;  :arith-assert-upper      175
;  :arith-bound-prop        21
;  :arith-conflicts         17
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        8
;  :arith-pivots            63
;  :binary-propagations     22
;  :conflicts               143
;  :datatype-accessor-ax    155
;  :datatype-constructor-ax 434
;  :datatype-occurs-check   164
;  :datatype-splits         249
;  :decisions               467
;  :del-clause              817
;  :final-checks            89
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1874
;  :mk-clause               843
;  :num-allocs              4194714
;  :num-checks              210
;  :propagations            327
;  :quant-instantiations    177
;  :rlimit-count            189265)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2196
;  :arith-add-rows          104
;  :arith-assert-diseq      60
;  :arith-assert-lower      262
;  :arith-assert-upper      175
;  :arith-bound-prop        21
;  :arith-conflicts         17
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        8
;  :arith-pivots            63
;  :binary-propagations     22
;  :conflicts               143
;  :datatype-accessor-ax    155
;  :datatype-constructor-ax 434
;  :datatype-occurs-check   164
;  :datatype-splits         249
;  :decisions               467
;  :del-clause              817
;  :final-checks            89
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1874
;  :mk-clause               843
;  :num-allocs              4194714
;  :num-checks              211
;  :propagations            327
;  :quant-instantiations    177
;  :rlimit-count            189274)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2197
;  :arith-add-rows          104
;  :arith-assert-diseq      60
;  :arith-assert-lower      263
;  :arith-assert-upper      176
;  :arith-bound-prop        21
;  :arith-conflicts         18
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        8
;  :arith-pivots            63
;  :binary-propagations     22
;  :conflicts               144
;  :datatype-accessor-ax    155
;  :datatype-constructor-ax 434
;  :datatype-occurs-check   164
;  :datatype-splits         249
;  :decisions               467
;  :del-clause              817
;  :final-checks            89
;  :interface-eqs           6
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1874
;  :mk-clause               843
;  :num-allocs              4194714
;  :num-checks              212
;  :propagations            331
;  :quant-instantiations    177
;  :rlimit-count            189382)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 42 | !(0 <= First:(Second:(Second:($t@91@06)))[2])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            2))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            2))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        2))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2254
;  :arith-add-rows          106
;  :arith-assert-diseq      68
;  :arith-assert-lower      292
;  :arith-assert-upper      190
;  :arith-bound-prop        21
;  :arith-conflicts         18
;  :arith-eq-adapter        229
;  :arith-fixed-eqs         35
;  :arith-offset-eqs        8
;  :arith-pivots            71
;  :binary-propagations     22
;  :conflicts               145
;  :datatype-accessor-ax    156
;  :datatype-constructor-ax 447
;  :datatype-occurs-check   170
;  :datatype-splits         259
;  :decisions               487
;  :del-clause              878
;  :final-checks            94
;  :interface-eqs           8
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1949
;  :mk-clause               898
;  :num-allocs              4194714
;  :num-checks              213
;  :propagations            361
;  :quant-instantiations    184
;  :rlimit-count            190638)
(push) ; 4
(assert (not (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          2))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          2))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      2)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2286
;  :arith-add-rows          106
;  :arith-assert-diseq      72
;  :arith-assert-lower      306
;  :arith-assert-upper      199
;  :arith-bound-prop        21
;  :arith-conflicts         18
;  :arith-eq-adapter        237
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               145
;  :datatype-accessor-ax    157
;  :datatype-constructor-ax 455
;  :datatype-occurs-check   174
;  :datatype-splits         264
;  :decisions               500
;  :del-clause              921
;  :final-checks            97
;  :interface-eqs           9
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1992
;  :mk-clause               941
;  :num-allocs              4194714
;  :num-checks              214
;  :propagations            383
;  :quant-instantiations    189
;  :rlimit-count            191603)
; [then-branch: 44 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[2] | live]
; [else-branch: 44 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[2]) | live]
(push) ; 4
; [then-branch: 44 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[2]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          2))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          2))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      2))))
; [eval] diz.Main_process_state[2] == -1
; [eval] diz.Main_process_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2286
;  :arith-add-rows          106
;  :arith-assert-diseq      72
;  :arith-assert-lower      307
;  :arith-assert-upper      199
;  :arith-bound-prop        21
;  :arith-conflicts         18
;  :arith-eq-adapter        238
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               145
;  :datatype-accessor-ax    157
;  :datatype-constructor-ax 455
;  :datatype-occurs-check   174
;  :datatype-splits         264
;  :decisions               500
;  :del-clause              921
;  :final-checks            97
;  :interface-eqs           9
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2000
;  :mk-clause               948
;  :num-allocs              4194714
;  :num-checks              215
;  :propagations            383
;  :quant-instantiations    190
;  :rlimit-count            191828)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 44 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[2])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            2))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            2))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            2))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            2))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        2)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
      2)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2292
;  :arith-add-rows          106
;  :arith-assert-diseq      72
;  :arith-assert-lower      307
;  :arith-assert-upper      199
;  :arith-bound-prop        21
;  :arith-conflicts         18
;  :arith-eq-adapter        238
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               145
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 455
;  :datatype-occurs-check   174
;  :datatype-splits         264
;  :decisions               500
;  :del-clause              928
;  :final-checks            97
;  :interface-eqs           9
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2007
;  :mk-clause               952
;  :num-allocs              4194714
;  :num-checks              216
;  :propagations            383
;  :quant-instantiations    190
;  :rlimit-count            192387)
(push) ; 3
; [then-branch: 45 | 0 <= First:(Second:(Second:($t@91@06)))[0] | live]
; [else-branch: 45 | !(0 <= First:(Second:(Second:($t@91@06)))[0]) | live]
(push) ; 4
; [then-branch: 45 | 0 <= First:(Second:(Second:($t@91@06)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2292
;  :arith-add-rows          106
;  :arith-assert-diseq      72
;  :arith-assert-lower      308
;  :arith-assert-upper      199
;  :arith-bound-prop        21
;  :arith-conflicts         18
;  :arith-eq-adapter        239
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               145
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 455
;  :datatype-occurs-check   174
;  :datatype-splits         264
;  :decisions               500
;  :del-clause              928
;  :final-checks            97
;  :interface-eqs           9
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2012
;  :mk-clause               958
;  :num-allocs              4194714
;  :num-checks              217
;  :propagations            383
;  :quant-instantiations    191
;  :rlimit-count            192504)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2292
;  :arith-add-rows          106
;  :arith-assert-diseq      72
;  :arith-assert-lower      308
;  :arith-assert-upper      199
;  :arith-bound-prop        21
;  :arith-conflicts         18
;  :arith-eq-adapter        239
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               145
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 455
;  :datatype-occurs-check   174
;  :datatype-splits         264
;  :decisions               500
;  :del-clause              928
;  :final-checks            97
;  :interface-eqs           9
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2012
;  :mk-clause               958
;  :num-allocs              4194714
;  :num-checks              218
;  :propagations            383
;  :quant-instantiations    191
;  :rlimit-count            192513)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2293
;  :arith-add-rows          106
;  :arith-assert-diseq      72
;  :arith-assert-lower      309
;  :arith-assert-upper      200
;  :arith-bound-prop        21
;  :arith-conflicts         19
;  :arith-eq-adapter        239
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               146
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 455
;  :datatype-occurs-check   174
;  :datatype-splits         264
;  :decisions               500
;  :del-clause              928
;  :final-checks            97
;  :interface-eqs           9
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2012
;  :mk-clause               958
;  :num-allocs              4194714
;  :num-checks              219
;  :propagations            387
;  :quant-instantiations    191
;  :rlimit-count            192621)
(push) ; 5
; [then-branch: 46 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0 | live]
; [else-branch: 46 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] != 0 | live]
(push) ; 6
; [then-branch: 46 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      0))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 46 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2293
;  :arith-add-rows          106
;  :arith-assert-diseq      72
;  :arith-assert-lower      309
;  :arith-assert-upper      200
;  :arith-bound-prop        21
;  :arith-conflicts         19
;  :arith-eq-adapter        239
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               146
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 455
;  :datatype-occurs-check   174
;  :datatype-splits         264
;  :decisions               500
;  :del-clause              928
;  :final-checks            97
;  :interface-eqs           9
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2012
;  :mk-clause               958
;  :num-allocs              4194714
;  :num-checks              220
;  :propagations            387
;  :quant-instantiations    191
;  :rlimit-count            192824)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2293
;  :arith-add-rows          106
;  :arith-assert-diseq      72
;  :arith-assert-lower      309
;  :arith-assert-upper      200
;  :arith-bound-prop        21
;  :arith-conflicts         19
;  :arith-eq-adapter        239
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               146
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 455
;  :datatype-occurs-check   174
;  :datatype-splits         264
;  :decisions               500
;  :del-clause              928
;  :final-checks            97
;  :interface-eqs           9
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2012
;  :mk-clause               958
;  :num-allocs              4194714
;  :num-checks              221
;  :propagations            387
;  :quant-instantiations    191
;  :rlimit-count            192833)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2294
;  :arith-add-rows          106
;  :arith-assert-diseq      72
;  :arith-assert-lower      310
;  :arith-assert-upper      201
;  :arith-bound-prop        21
;  :arith-conflicts         20
;  :arith-eq-adapter        239
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               147
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 455
;  :datatype-occurs-check   174
;  :datatype-splits         264
;  :decisions               500
;  :del-clause              928
;  :final-checks            97
;  :interface-eqs           9
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2012
;  :mk-clause               958
;  :num-allocs              4194714
;  :num-checks              222
;  :propagations            391
;  :quant-instantiations    191
;  :rlimit-count            192941)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 45 | !(0 <= First:(Second:(Second:($t@91@06)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2327
;  :arith-add-rows          106
;  :arith-assert-diseq      74
;  :arith-assert-lower      320
;  :arith-assert-upper      209
;  :arith-bound-prop        21
;  :arith-conflicts         20
;  :arith-eq-adapter        245
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               147
;  :datatype-accessor-ax    159
;  :datatype-constructor-ax 463
;  :datatype-occurs-check   178
;  :datatype-splits         269
;  :decisions               512
;  :del-clause              960
;  :final-checks            100
;  :interface-eqs           10
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2044
;  :mk-clause               984
;  :num-allocs              4194714
;  :num-checks              223
;  :propagations            405
;  :quant-instantiations    195
;  :rlimit-count            193852)
(push) ; 4
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2381
;  :arith-add-rows          106
;  :arith-assert-diseq      76
;  :arith-assert-lower      328
;  :arith-assert-upper      215
;  :arith-bound-prop        21
;  :arith-conflicts         20
;  :arith-eq-adapter        251
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               150
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   186
;  :datatype-splits         278
;  :decisions               531
;  :del-clause              987
;  :final-checks            106
;  :interface-eqs           12
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2085
;  :mk-clause               1011
;  :num-allocs              4194714
;  :num-checks              224
;  :propagations            421
;  :quant-instantiations    198
;  :rlimit-count            194842
;  :time                    0.00)
; [then-branch: 47 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[0]) | live]
; [else-branch: 47 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[0] | live]
(push) ; 4
; [then-branch: 47 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2381
;  :arith-add-rows          106
;  :arith-assert-diseq      76
;  :arith-assert-lower      328
;  :arith-assert-upper      215
;  :arith-bound-prop        21
;  :arith-conflicts         20
;  :arith-eq-adapter        251
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               150
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   186
;  :datatype-splits         278
;  :decisions               531
;  :del-clause              987
;  :final-checks            106
;  :interface-eqs           12
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2085
;  :mk-clause               1012
;  :num-allocs              4194714
;  :num-checks              225
;  :propagations            421
;  :quant-instantiations    198
;  :rlimit-count            195057)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2381
;  :arith-add-rows          106
;  :arith-assert-diseq      76
;  :arith-assert-lower      328
;  :arith-assert-upper      215
;  :arith-bound-prop        21
;  :arith-conflicts         20
;  :arith-eq-adapter        251
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               150
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   186
;  :datatype-splits         278
;  :decisions               531
;  :del-clause              987
;  :final-checks            106
;  :interface-eqs           12
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2085
;  :mk-clause               1012
;  :num-allocs              4194714
;  :num-checks              226
;  :propagations            421
;  :quant-instantiations    198
;  :rlimit-count            195072)
(pop) ; 4
(push) ; 4
; [else-branch: 47 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[0]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
              0))
          0)
        (=
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2387
;  :arith-add-rows          106
;  :arith-assert-diseq      76
;  :arith-assert-lower      328
;  :arith-assert-upper      215
;  :arith-bound-prop        21
;  :arith-conflicts         20
;  :arith-eq-adapter        251
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               150
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   186
;  :datatype-splits         278
;  :decisions               531
;  :del-clause              988
;  :final-checks            106
;  :interface-eqs           12
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2089
;  :mk-clause               1016
;  :num-allocs              4194714
;  :num-checks              227
;  :propagations            421
;  :quant-instantiations    198
;  :rlimit-count            195619)
(push) ; 3
; [then-branch: 48 | 0 <= First:(Second:(Second:($t@91@06)))[1] | live]
; [else-branch: 48 | !(0 <= First:(Second:(Second:($t@91@06)))[1]) | live]
(push) ; 4
; [then-branch: 48 | 0 <= First:(Second:(Second:($t@91@06)))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2387
;  :arith-add-rows          106
;  :arith-assert-diseq      76
;  :arith-assert-lower      329
;  :arith-assert-upper      215
;  :arith-bound-prop        21
;  :arith-conflicts         20
;  :arith-eq-adapter        252
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               150
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   186
;  :datatype-splits         278
;  :decisions               531
;  :del-clause              988
;  :final-checks            106
;  :interface-eqs           12
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2094
;  :mk-clause               1022
;  :num-allocs              4194714
;  :num-checks              228
;  :propagations            421
;  :quant-instantiations    199
;  :rlimit-count            195735)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2387
;  :arith-add-rows          106
;  :arith-assert-diseq      76
;  :arith-assert-lower      329
;  :arith-assert-upper      215
;  :arith-bound-prop        21
;  :arith-conflicts         20
;  :arith-eq-adapter        252
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               150
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   186
;  :datatype-splits         278
;  :decisions               531
;  :del-clause              988
;  :final-checks            106
;  :interface-eqs           12
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2094
;  :mk-clause               1022
;  :num-allocs              4194714
;  :num-checks              229
;  :propagations            421
;  :quant-instantiations    199
;  :rlimit-count            195744)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2388
;  :arith-add-rows          106
;  :arith-assert-diseq      76
;  :arith-assert-lower      330
;  :arith-assert-upper      216
;  :arith-bound-prop        21
;  :arith-conflicts         21
;  :arith-eq-adapter        252
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               151
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   186
;  :datatype-splits         278
;  :decisions               531
;  :del-clause              988
;  :final-checks            106
;  :interface-eqs           12
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2094
;  :mk-clause               1022
;  :num-allocs              4194714
;  :num-checks              230
;  :propagations            425
;  :quant-instantiations    199
;  :rlimit-count            195852)
(push) ; 5
; [then-branch: 49 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0 | live]
; [else-branch: 49 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] != 0 | live]
(push) ; 6
; [then-branch: 49 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      1))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 49 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2388
;  :arith-add-rows          106
;  :arith-assert-diseq      76
;  :arith-assert-lower      330
;  :arith-assert-upper      216
;  :arith-bound-prop        21
;  :arith-conflicts         21
;  :arith-eq-adapter        252
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               151
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   186
;  :datatype-splits         278
;  :decisions               531
;  :del-clause              988
;  :final-checks            106
;  :interface-eqs           12
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2094
;  :mk-clause               1022
;  :num-allocs              4194714
;  :num-checks              231
;  :propagations            425
;  :quant-instantiations    199
;  :rlimit-count            196055)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2388
;  :arith-add-rows          106
;  :arith-assert-diseq      76
;  :arith-assert-lower      330
;  :arith-assert-upper      216
;  :arith-bound-prop        21
;  :arith-conflicts         21
;  :arith-eq-adapter        252
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               151
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   186
;  :datatype-splits         278
;  :decisions               531
;  :del-clause              988
;  :final-checks            106
;  :interface-eqs           12
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2094
;  :mk-clause               1022
;  :num-allocs              4194714
;  :num-checks              232
;  :propagations            425
;  :quant-instantiations    199
;  :rlimit-count            196064)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2389
;  :arith-add-rows          106
;  :arith-assert-diseq      76
;  :arith-assert-lower      331
;  :arith-assert-upper      217
;  :arith-bound-prop        21
;  :arith-conflicts         22
;  :arith-eq-adapter        252
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        8
;  :arith-pivots            73
;  :binary-propagations     22
;  :conflicts               152
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 478
;  :datatype-occurs-check   186
;  :datatype-splits         278
;  :decisions               531
;  :del-clause              988
;  :final-checks            106
;  :interface-eqs           12
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2094
;  :mk-clause               1022
;  :num-allocs              4194714
;  :num-checks              233
;  :propagations            429
;  :quant-instantiations    199
;  :rlimit-count            196172)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 48 | !(0 <= First:(Second:(Second:($t@91@06)))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2426
;  :arith-add-rows          106
;  :arith-assert-diseq      78
;  :arith-assert-lower      342
;  :arith-assert-upper      226
;  :arith-bound-prop        23
;  :arith-conflicts         22
;  :arith-eq-adapter        259
;  :arith-fixed-eqs         37
;  :arith-offset-eqs        8
;  :arith-pivots            75
;  :binary-propagations     22
;  :conflicts               152
;  :datatype-accessor-ax    164
;  :datatype-constructor-ax 486
;  :datatype-occurs-check   190
;  :datatype-splits         283
;  :decisions               543
;  :del-clause              1028
;  :final-checks            109
;  :interface-eqs           13
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2136
;  :mk-clause               1056
;  :num-allocs              4194714
;  :num-checks              234
;  :propagations            446
;  :quant-instantiations    204
;  :rlimit-count            197145
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2488
;  :arith-add-rows          106
;  :arith-assert-diseq      79
;  :arith-assert-lower      348
;  :arith-assert-upper      233
;  :arith-bound-prop        25
;  :arith-conflicts         22
;  :arith-eq-adapter        265
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        8
;  :arith-pivots            77
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 501
;  :datatype-occurs-check   198
;  :datatype-splits         292
;  :decisions               560
;  :del-clause              1049
;  :final-checks            114
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2184
;  :mk-clause               1077
;  :num-allocs              4194714
;  :num-checks              235
;  :propagations            457
;  :quant-instantiations    208
;  :rlimit-count            198162
;  :time                    0.00)
; [then-branch: 50 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[1]) | live]
; [else-branch: 50 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[1] | live]
(push) ; 4
; [then-branch: 50 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        1)))))
; [eval] diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2488
;  :arith-add-rows          106
;  :arith-assert-diseq      79
;  :arith-assert-lower      348
;  :arith-assert-upper      233
;  :arith-bound-prop        25
;  :arith-conflicts         22
;  :arith-eq-adapter        265
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        8
;  :arith-pivots            77
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 501
;  :datatype-occurs-check   198
;  :datatype-splits         292
;  :decisions               560
;  :del-clause              1049
;  :final-checks            114
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2184
;  :mk-clause               1078
;  :num-allocs              4194714
;  :num-checks              236
;  :propagations            457
;  :quant-instantiations    208
;  :rlimit-count            198377)
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2488
;  :arith-add-rows          106
;  :arith-assert-diseq      79
;  :arith-assert-lower      348
;  :arith-assert-upper      233
;  :arith-bound-prop        25
;  :arith-conflicts         22
;  :arith-eq-adapter        265
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        8
;  :arith-pivots            77
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 501
;  :datatype-occurs-check   198
;  :datatype-splits         292
;  :decisions               560
;  :del-clause              1049
;  :final-checks            114
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2184
;  :mk-clause               1078
;  :num-allocs              4194714
;  :num-checks              237
;  :propagations            457
;  :quant-instantiations    208
;  :rlimit-count            198392)
(pop) ; 4
(push) ; 4
; [else-branch: 50 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[1]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
              1))
          0)
        (=
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
              1))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@93@06))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2490
;  :arith-add-rows          106
;  :arith-assert-diseq      79
;  :arith-assert-lower      348
;  :arith-assert-upper      233
;  :arith-bound-prop        25
;  :arith-conflicts         22
;  :arith-eq-adapter        265
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        8
;  :arith-pivots            77
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 501
;  :datatype-occurs-check   198
;  :datatype-splits         292
;  :decisions               560
;  :del-clause              1050
;  :final-checks            114
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2187
;  :mk-clause               1082
;  :num-allocs              4194714
;  :num-checks              238
;  :propagations            457
;  :quant-instantiations    208
;  :rlimit-count            198855)
(push) ; 3
; [then-branch: 51 | 0 <= First:(Second:(Second:($t@91@06)))[2] | live]
; [else-branch: 51 | !(0 <= First:(Second:(Second:($t@91@06)))[2]) | live]
(push) ; 4
; [then-branch: 51 | 0 <= First:(Second:(Second:($t@91@06)))[2]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2490
;  :arith-add-rows          106
;  :arith-assert-diseq      79
;  :arith-assert-lower      349
;  :arith-assert-upper      233
;  :arith-bound-prop        25
;  :arith-conflicts         22
;  :arith-eq-adapter        266
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        8
;  :arith-pivots            77
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 501
;  :datatype-occurs-check   198
;  :datatype-splits         292
;  :decisions               560
;  :del-clause              1050
;  :final-checks            114
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2192
;  :mk-clause               1088
;  :num-allocs              4194714
;  :num-checks              239
;  :propagations            457
;  :quant-instantiations    209
;  :rlimit-count            198972)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2490
;  :arith-add-rows          106
;  :arith-assert-diseq      79
;  :arith-assert-lower      349
;  :arith-assert-upper      233
;  :arith-bound-prop        25
;  :arith-conflicts         22
;  :arith-eq-adapter        266
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        8
;  :arith-pivots            77
;  :binary-propagations     22
;  :conflicts               155
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 501
;  :datatype-occurs-check   198
;  :datatype-splits         292
;  :decisions               560
;  :del-clause              1050
;  :final-checks            114
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2192
;  :mk-clause               1088
;  :num-allocs              4194714
;  :num-checks              240
;  :propagations            457
;  :quant-instantiations    209
;  :rlimit-count            198981)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2491
;  :arith-add-rows          106
;  :arith-assert-diseq      79
;  :arith-assert-lower      350
;  :arith-assert-upper      234
;  :arith-bound-prop        25
;  :arith-conflicts         23
;  :arith-eq-adapter        266
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        8
;  :arith-pivots            77
;  :binary-propagations     22
;  :conflicts               156
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 501
;  :datatype-occurs-check   198
;  :datatype-splits         292
;  :decisions               560
;  :del-clause              1050
;  :final-checks            114
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2192
;  :mk-clause               1088
;  :num-allocs              4194714
;  :num-checks              241
;  :propagations            461
;  :quant-instantiations    209
;  :rlimit-count            199089)
(push) ; 5
; [then-branch: 52 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0 | live]
; [else-branch: 52 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] != 0 | live]
(push) ; 6
; [then-branch: 52 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      2))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 52 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2491
;  :arith-add-rows          106
;  :arith-assert-diseq      79
;  :arith-assert-lower      350
;  :arith-assert-upper      234
;  :arith-bound-prop        25
;  :arith-conflicts         23
;  :arith-eq-adapter        266
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        8
;  :arith-pivots            77
;  :binary-propagations     22
;  :conflicts               156
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 501
;  :datatype-occurs-check   198
;  :datatype-splits         292
;  :decisions               560
;  :del-clause              1050
;  :final-checks            114
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2192
;  :mk-clause               1088
;  :num-allocs              4194714
;  :num-checks              242
;  :propagations            461
;  :quant-instantiations    209
;  :rlimit-count            199292)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    2)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2491
;  :arith-add-rows          106
;  :arith-assert-diseq      79
;  :arith-assert-lower      350
;  :arith-assert-upper      234
;  :arith-bound-prop        25
;  :arith-conflicts         23
;  :arith-eq-adapter        266
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        8
;  :arith-pivots            77
;  :binary-propagations     22
;  :conflicts               156
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 501
;  :datatype-occurs-check   198
;  :datatype-splits         292
;  :decisions               560
;  :del-clause              1050
;  :final-checks            114
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2192
;  :mk-clause               1088
;  :num-allocs              4194714
;  :num-checks              243
;  :propagations            461
;  :quant-instantiations    209
;  :rlimit-count            199301)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
    2)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2492
;  :arith-add-rows          106
;  :arith-assert-diseq      79
;  :arith-assert-lower      351
;  :arith-assert-upper      235
;  :arith-bound-prop        25
;  :arith-conflicts         24
;  :arith-eq-adapter        266
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        8
;  :arith-pivots            77
;  :binary-propagations     22
;  :conflicts               157
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 501
;  :datatype-occurs-check   198
;  :datatype-splits         292
;  :decisions               560
;  :del-clause              1050
;  :final-checks            114
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2192
;  :mk-clause               1088
;  :num-allocs              4194714
;  :num-checks              244
;  :propagations            465
;  :quant-instantiations    209
;  :rlimit-count            199409)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 51 | !(0 <= First:(Second:(Second:($t@91@06)))[2])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          2))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          2))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      2)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2526
;  :arith-add-rows          106
;  :arith-assert-diseq      81
;  :arith-assert-lower      361
;  :arith-assert-upper      244
;  :arith-bound-prop        31
;  :arith-conflicts         24
;  :arith-eq-adapter        273
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        8
;  :arith-pivots            81
;  :binary-propagations     22
;  :conflicts               157
;  :datatype-accessor-ax    168
;  :datatype-constructor-ax 508
;  :datatype-occurs-check   202
;  :datatype-splits         296
;  :decisions               571
;  :del-clause              1093
;  :final-checks            117
;  :interface-eqs           15
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2239
;  :mk-clause               1125
;  :num-allocs              4194714
;  :num-checks              245
;  :propagations            480
;  :quant-instantiations    214
;  :rlimit-count            200398
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            2))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            2))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        2))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          106
;  :arith-assert-diseq      84
;  :arith-assert-lower      374
;  :arith-assert-upper      252
;  :arith-bound-prop        37
;  :arith-conflicts         24
;  :arith-eq-adapter        281
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        8
;  :arith-pivots            85
;  :binary-propagations     22
;  :conflicts               160
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 522
;  :datatype-occurs-check   210
;  :datatype-splits         304
;  :decisions               588
;  :del-clause              1137
;  :final-checks            122
;  :interface-eqs           16
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2303
;  :mk-clause               1169
;  :num-allocs              4194714
;  :num-checks              246
;  :propagations            499
;  :quant-instantiations    219
;  :rlimit-count            201485
;  :time                    0.00)
; [then-branch: 53 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[2]) | live]
; [else-branch: 53 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[2] | live]
(push) ; 4
; [then-branch: 53 | !(First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[2])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            2))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
            2))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
        2)))))
; [eval] diz.Main_process_state[2] == old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          106
;  :arith-assert-diseq      84
;  :arith-assert-lower      374
;  :arith-assert-upper      252
;  :arith-bound-prop        37
;  :arith-conflicts         24
;  :arith-eq-adapter        281
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        8
;  :arith-pivots            85
;  :binary-propagations     22
;  :conflicts               160
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 522
;  :datatype-occurs-check   210
;  :datatype-splits         304
;  :decisions               588
;  :del-clause              1137
;  :final-checks            122
;  :interface-eqs           16
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2303
;  :mk-clause               1170
;  :num-allocs              4194714
;  :num-checks              247
;  :propagations            499
;  :quant-instantiations    219
;  :rlimit-count            201700)
; [eval] old(diz.Main_process_state[2])
; [eval] diz.Main_process_state[2]
(push) ; 5
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          106
;  :arith-assert-diseq      84
;  :arith-assert-lower      374
;  :arith-assert-upper      252
;  :arith-bound-prop        37
;  :arith-conflicts         24
;  :arith-eq-adapter        281
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        8
;  :arith-pivots            85
;  :binary-propagations     22
;  :conflicts               160
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 522
;  :datatype-occurs-check   210
;  :datatype-splits         304
;  :decisions               588
;  :del-clause              1137
;  :final-checks            122
;  :interface-eqs           16
;  :max-generation          5
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             2303
;  :mk-clause               1170
;  :num-allocs              4194714
;  :num-checks              248
;  :propagations            499
;  :quant-instantiations    219
;  :rlimit-count            201715)
(pop) ; 4
(push) ; 4
; [else-branch: 53 | First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == 0 || First:(Second:(Second:(Second:(Second:($t@91@06)))))[First:(Second:(Second:($t@91@06)))[2]] == -1 && 0 <= First:(Second:(Second:($t@91@06)))[2]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          2))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          2))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
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
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
              2))
          0)
        (=
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@06))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
              2))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
          2))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@93@06)))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@91@06))))
      2))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
