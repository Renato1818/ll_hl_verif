(get-info :version)
; (:version "4.8.6")
; Started: 2024-06-26 20:03:53
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
(declare-sort Set<Int>)
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
(declare-const class_Controller<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Object<TYPE> TYPE)
(declare-const class_Main<TYPE> TYPE)
(declare-const class_Robot<TYPE> TYPE)
(declare-const class_Sensor<TYPE> TYPE)
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
; /field_value_functions_declarations.smt2 [Controller_m: Ref]
(declare-fun $FVF.domain_Controller_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Controller_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Controller_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Controller_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Controller_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Controller_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [Sensor_m: Ref]
(declare-fun $FVF.domain_Sensor_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Sensor_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Sensor_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Sensor_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Sensor_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Sensor_m $FVF<$Ref>)
; Declaring symbols related to program functions (from program analysis)
(declare-fun Main_find_minimum_advance_Sequence$Integer$ ($Snap $Ref Seq<Int>) Int)
(declare-fun Main_find_minimum_advance_Sequence$Integer$%limited ($Snap $Ref Seq<Int>) Int)
(declare-fun Main_find_minimum_advance_Sequence$Integer$%stateless ($Ref Seq<Int>) Bool)
(declare-fun instanceof_TYPE_TYPE ($Snap TYPE TYPE) Bool)
(declare-fun instanceof_TYPE_TYPE%limited ($Snap TYPE TYPE) Bool)
(declare-fun instanceof_TYPE_TYPE%stateless (TYPE TYPE) Bool)
(declare-fun new_frac ($Snap $Perm) frac)
(declare-fun new_frac%limited ($Snap $Perm) frac)
(declare-fun new_frac%stateless ($Perm) Bool)
(declare-fun Sensor_rand__randomize_0 ($Snap $Ref) Int)
(declare-fun Sensor_rand__randomize_0%limited ($Snap $Ref) Int)
(declare-fun Sensor_rand__randomize_0%stateless ($Ref) Bool)
(declare-fun new_zfrac ($Snap $Perm) zfrac)
(declare-fun new_zfrac%limited ($Snap $Perm) zfrac)
(declare-fun new_zfrac%stateless ($Perm) Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
(declare-fun Controller_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Controller_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_held_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Sensor_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Sensor_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
; ////////// Uniqueness assumptions from domains
(assert (distinct class_Controller<TYPE> class_java_DOT_lang_DOT_Object<TYPE> class_Main<TYPE> class_Robot<TYPE> class_Sensor<TYPE> class_EncodedGlobalVariables<TYPE>))
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
  (directSuperclass<TYPE> (as class_Controller<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Main<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Robot<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Sensor<TYPE>  TYPE))
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
; /field_value_functions_axioms.smt2 [Controller_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Controller_m vs) ($FVF.domain_Controller_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Controller_m vs))
            (= ($FVF.lookup_Controller_m vs x) ($FVF.lookup_Controller_m ws x)))
          :pattern (($FVF.lookup_Controller_m vs x) ($FVF.lookup_Controller_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Controller_m pm r))
    :pattern ($FVF.perm_Controller_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Controller_m f r) true)
    :pattern ($FVF.loc_Controller_m f r))))
; /field_value_functions_axioms.smt2 [Sensor_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Sensor_m vs) ($FVF.domain_Sensor_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Sensor_m vs))
            (= ($FVF.lookup_Sensor_m vs x) ($FVF.lookup_Sensor_m ws x)))
          :pattern (($FVF.lookup_Sensor_m vs x) ($FVF.lookup_Sensor_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Sensor_m pm r))
    :pattern ($FVF.perm_Sensor_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Sensor_m f r) true)
    :pattern ($FVF.loc_Sensor_m f r))))
; End preamble
; ------------------------------------------------------------
; State saturation: after preamble
(set-option :timeout 100)
(check-sat)
; unknown
; ---------- FUNCTION Main_find_minimum_advance_Sequence$Integer$----------
(declare-fun diz@0@00 () $Ref)
(declare-fun vals@1@00 () Seq<Int>)
(declare-fun result@2@00 () Int)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@0@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] |vals| == 3
; [eval] |vals|
(assert (= (Seq_length vals@1@00) 3))
(declare-const $t@12@00 $Snap)
(assert (= $t@12@00 ($Snap.combine ($Snap.first $t@12@00) ($Snap.second $t@12@00))))
(assert (= ($Snap.first $t@12@00) $Snap.unit))
; [eval] vals[0] < -1 || result <= vals[0]
; [eval] vals[0] < -1
; [eval] vals[0]
(set-option :timeout 0)
(push) ; 2
(assert (not (< 0 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            20
;  :arith-assert-diseq   1
;  :arith-assert-lower   4
;  :arith-assert-upper   2
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :datatype-accessor-ax 3
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.69
;  :mk-bool-var          254
;  :mk-clause            4
;  :num-allocs           3406257
;  :num-checks           1
;  :propagations         17
;  :quant-instantiations 3
;  :rlimit-count         108235)
; [eval] -1
(push) ; 2
; [then-branch: 0 | vals@1@00[0] < -1 | live]
; [else-branch: 0 | !(vals@1@00[0] < -1) | live]
(push) ; 3
; [then-branch: 0 | vals@1@00[0] < -1]
(assert (< (Seq_index vals@1@00 0) (- 0 1)))
(pop) ; 3
(push) ; 3
; [else-branch: 0 | !(vals@1@00[0] < -1)]
(assert (not (< (Seq_index vals@1@00 0) (- 0 1))))
; [eval] result <= vals[0]
; [eval] vals[0]
(push) ; 4
(assert (not (< 0 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            20
;  :arith-assert-diseq   1
;  :arith-assert-lower   5
;  :arith-assert-upper   2
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :datatype-accessor-ax 3
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.69
;  :mk-bool-var          255
;  :mk-clause            4
;  :num-allocs           3406257
;  :num-checks           2
;  :propagations         17
;  :quant-instantiations 3
;  :rlimit-count         108345)
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (or (< (Seq_index vals@1@00 0) (- 0 1)) (<= result@2@00 (Seq_index vals@1@00 0))))
(assert (=
  ($Snap.second $t@12@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@12@00))
    ($Snap.second ($Snap.second $t@12@00)))))
(assert (= ($Snap.first ($Snap.second $t@12@00)) $Snap.unit))
; [eval] vals[1] < -1 || result <= vals[1]
; [eval] vals[1] < -1
; [eval] vals[1]
(push) ; 2
(assert (not (< 1 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            26
;  :arith-assert-diseq   1
;  :arith-assert-lower   5
;  :arith-assert-upper   2
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :datatype-accessor-ax 4
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.69
;  :mk-bool-var          259
;  :mk-clause            5
;  :num-allocs           3406257
;  :num-checks           3
;  :propagations         17
;  :quant-instantiations 3
;  :rlimit-count         108642)
; [eval] -1
(push) ; 2
; [then-branch: 1 | vals@1@00[1] < -1 | live]
; [else-branch: 1 | !(vals@1@00[1] < -1) | live]
(push) ; 3
; [then-branch: 1 | vals@1@00[1] < -1]
(assert (< (Seq_index vals@1@00 1) (- 0 1)))
(pop) ; 3
(push) ; 3
; [else-branch: 1 | !(vals@1@00[1] < -1)]
(assert (not (< (Seq_index vals@1@00 1) (- 0 1))))
; [eval] result <= vals[1]
; [eval] vals[1]
(push) ; 4
(assert (not (< 1 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            26
;  :arith-assert-diseq   1
;  :arith-assert-lower   6
;  :arith-assert-upper   2
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :datatype-accessor-ax 4
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.69
;  :mk-bool-var          260
;  :mk-clause            5
;  :num-allocs           3406257
;  :num-checks           4
;  :propagations         17
;  :quant-instantiations 3
;  :rlimit-count         108751)
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (or (< (Seq_index vals@1@00 1) (- 0 1)) (<= result@2@00 (Seq_index vals@1@00 1))))
(assert (=
  ($Snap.second ($Snap.second $t@12@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@12@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@12@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@12@00))) $Snap.unit))
; [eval] vals[2] < -1 || result <= vals[2]
; [eval] vals[2] < -1
; [eval] vals[2]
(push) ; 2
(assert (not (< 2 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            32
;  :arith-assert-diseq   1
;  :arith-assert-lower   6
;  :arith-assert-upper   2
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :datatype-accessor-ax 5
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.69
;  :mk-bool-var          264
;  :mk-clause            6
;  :num-allocs           3406257
;  :num-checks           5
;  :propagations         17
;  :quant-instantiations 3
;  :rlimit-count         109058)
; [eval] -1
(push) ; 2
; [then-branch: 2 | vals@1@00[2] < -1 | live]
; [else-branch: 2 | !(vals@1@00[2] < -1) | live]
(push) ; 3
; [then-branch: 2 | vals@1@00[2] < -1]
(assert (< (Seq_index vals@1@00 2) (- 0 1)))
(pop) ; 3
(push) ; 3
; [else-branch: 2 | !(vals@1@00[2] < -1)]
(assert (not (< (Seq_index vals@1@00 2) (- 0 1))))
; [eval] result <= vals[2]
; [eval] vals[2]
(push) ; 4
(assert (not (< 2 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            32
;  :arith-assert-diseq   1
;  :arith-assert-lower   7
;  :arith-assert-upper   2
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :datatype-accessor-ax 5
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.69
;  :mk-bool-var          265
;  :mk-clause            6
;  :num-allocs           3406257
;  :num-checks           6
;  :propagations         17
;  :quant-instantiations 3
;  :rlimit-count         109167)
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (or (< (Seq_index vals@1@00 2) (- 0 1)) (<= result@2@00 (Seq_index vals@1@00 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@12@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@00)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@00))))
  $Snap.unit))
; [eval] vals[0] < -1 && vals[1] < -1 && vals[2] < -1 ==> result == 0
; [eval] vals[0] < -1 && vals[1] < -1 && vals[2] < -1
; [eval] vals[0] < -1
; [eval] vals[0]
(push) ; 2
(assert (not (< 0 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            38
;  :arith-assert-diseq   1
;  :arith-assert-lower   7
;  :arith-assert-upper   2
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :datatype-accessor-ax 6
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.69
;  :mk-bool-var          269
;  :mk-clause            7
;  :num-allocs           3406257
;  :num-checks           7
;  :propagations         17
;  :quant-instantiations 3
;  :rlimit-count         109484)
; [eval] -1
(push) ; 2
; [then-branch: 3 | vals@1@00[0] < -1 | live]
; [else-branch: 3 | !(vals@1@00[0] < -1) | live]
(push) ; 3
; [then-branch: 3 | vals@1@00[0] < -1]
(assert (< (Seq_index vals@1@00 0) (- 0 1)))
; [eval] vals[1] < -1
; [eval] vals[1]
(push) ; 4
(assert (not (< 1 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            38
;  :arith-assert-diseq   1
;  :arith-assert-lower   7
;  :arith-assert-upper   3
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :datatype-accessor-ax 6
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.69
;  :mk-bool-var          269
;  :mk-clause            7
;  :num-allocs           3406257
;  :num-checks           8
;  :propagations         17
;  :quant-instantiations 3
;  :rlimit-count         109581)
; [eval] -1
(push) ; 4
; [then-branch: 4 | vals@1@00[1] < -1 | live]
; [else-branch: 4 | !(vals@1@00[1] < -1) | live]
(push) ; 5
; [then-branch: 4 | vals@1@00[1] < -1]
(assert (< (Seq_index vals@1@00 1) (- 0 1)))
; [eval] vals[2] < -1
; [eval] vals[2]
(push) ; 6
(assert (not (< 2 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            38
;  :arith-assert-diseq   1
;  :arith-assert-lower   7
;  :arith-assert-upper   4
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :datatype-accessor-ax 6
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.69
;  :mk-bool-var          269
;  :mk-clause            7
;  :num-allocs           3406257
;  :num-checks           9
;  :propagations         17
;  :quant-instantiations 3
;  :rlimit-count         109678)
; [eval] -1
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(vals@1@00[1] < -1)]
(assert (not (< (Seq_index vals@1@00 1) (- 0 1))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 3 | !(vals@1@00[0] < -1)]
(assert (not (< (Seq_index vals@1@00 0) (- 0 1))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not
  (and
    (and (< (Seq_index vals@1@00 2) (- 0 1)) (< (Seq_index vals@1@00 1) (- 0 1)))
    (< (Seq_index vals@1@00 0) (- 0 1))))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               41
;  :arith-assert-diseq      1
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        3
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   4
;  :datatype-splits         1
;  :decisions               1
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             270
;  :mk-clause               7
;  :num-allocs              3522170
;  :num-checks              10
;  :propagations            17
;  :quant-instantiations    3
;  :rlimit-count            110200)
(push) ; 3
(assert (not (and
  (and (< (Seq_index vals@1@00 2) (- 0 1)) (< (Seq_index vals@1@00 1) (- 0 1)))
  (< (Seq_index vals@1@00 0) (- 0 1)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               44
;  :arith-assert-diseq      1
;  :arith-assert-lower      8
;  :arith-assert-upper      10
;  :arith-eq-adapter        3
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   8
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              1
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             271
;  :mk-clause               8
;  :num-allocs              3522170
;  :num-checks              11
;  :propagations            19
;  :quant-instantiations    3
;  :rlimit-count            110671)
; [then-branch: 5 | vals@1@00[2] < -1 && vals@1@00[1] < -1 && vals@1@00[0] < -1 | live]
; [else-branch: 5 | !(vals@1@00[2] < -1 && vals@1@00[1] < -1 && vals@1@00[0] < -1) | live]
(push) ; 3
; [then-branch: 5 | vals@1@00[2] < -1 && vals@1@00[1] < -1 && vals@1@00[0] < -1]
(assert (and
  (and (< (Seq_index vals@1@00 2) (- 0 1)) (< (Seq_index vals@1@00 1) (- 0 1)))
  (< (Seq_index vals@1@00 0) (- 0 1))))
; [eval] result == 0
(pop) ; 3
(push) ; 3
; [else-branch: 5 | !(vals@1@00[2] < -1 && vals@1@00[1] < -1 && vals@1@00[0] < -1)]
(assert (not
  (and
    (and (< (Seq_index vals@1@00 2) (- 0 1)) (< (Seq_index vals@1@00 1) (- 0 1)))
    (< (Seq_index vals@1@00 0) (- 0 1)))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (and
    (and (< (Seq_index vals@1@00 2) (- 0 1)) (< (Seq_index vals@1@00 1) (- 0 1)))
    (< (Seq_index vals@1@00 0) (- 0 1)))
  (and
    (< (Seq_index vals@1@00 2) (- 0 1))
    (< (Seq_index vals@1@00 1) (- 0 1))
    (< (Seq_index vals@1@00 0) (- 0 1)))))
; Joined path conditions
(assert (implies
  (and
    (and (< (Seq_index vals@1@00 2) (- 0 1)) (< (Seq_index vals@1@00 1) (- 0 1)))
    (< (Seq_index vals@1@00 0) (- 0 1)))
  (= result@2@00 0)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@00))))
  $Snap.unit))
; [eval] -1 <= vals[0] || -1 <= vals[1] || -1 <= vals[2] ==> -1 <= vals[0] && result == vals[0] || -1 <= vals[1] && result == vals[1] || -1 <= vals[2] && result == vals[2]
; [eval] -1 <= vals[0] || -1 <= vals[1] || -1 <= vals[2]
; [eval] -1 <= vals[0]
; [eval] -1
; [eval] vals[0]
(set-option :timeout 0)
(push) ; 2
(assert (not (< 0 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46
;  :arith-assert-diseq      1
;  :arith-assert-lower      8
;  :arith-assert-upper      10
;  :arith-eq-adapter        4
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   8
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              1
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             275
;  :mk-clause               13
;  :num-allocs              3522170
;  :num-checks              12
;  :propagations            19
;  :quant-instantiations    3
;  :rlimit-count            111023)
(push) ; 2
; [then-branch: 6 | -1 <= vals@1@00[0] | live]
; [else-branch: 6 | !(-1 <= vals@1@00[0]) | live]
(push) ; 3
; [then-branch: 6 | -1 <= vals@1@00[0]]
(assert (<= (- 0 1) (Seq_index vals@1@00 0)))
(pop) ; 3
(push) ; 3
; [else-branch: 6 | !(-1 <= vals@1@00[0])]
(assert (not (<= (- 0 1) (Seq_index vals@1@00 0))))
; [eval] -1 <= vals[1]
; [eval] -1
; [eval] vals[1]
(push) ; 4
(assert (not (< 1 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46
;  :arith-assert-diseq      1
;  :arith-assert-lower      8
;  :arith-assert-upper      11
;  :arith-eq-adapter        4
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   8
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              1
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             275
;  :mk-clause               13
;  :num-allocs              3522170
;  :num-checks              13
;  :propagations            19
;  :quant-instantiations    3
;  :rlimit-count            111128)
(push) ; 4
; [then-branch: 7 | -1 <= vals@1@00[1] | live]
; [else-branch: 7 | !(-1 <= vals@1@00[1]) | live]
(push) ; 5
; [then-branch: 7 | -1 <= vals@1@00[1]]
(assert (<= (- 0 1) (Seq_index vals@1@00 1)))
(pop) ; 5
(push) ; 5
; [else-branch: 7 | !(-1 <= vals@1@00[1])]
(assert (not (<= (- 0 1) (Seq_index vals@1@00 1))))
; [eval] -1 <= vals[2]
; [eval] -1
; [eval] vals[2]
(push) ; 6
(assert (not (< 2 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46
;  :arith-assert-diseq      1
;  :arith-assert-lower      8
;  :arith-assert-upper      12
;  :arith-eq-adapter        4
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   8
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              1
;  :final-checks            4
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             275
;  :mk-clause               13
;  :num-allocs              3522170
;  :num-checks              14
;  :propagations            19
;  :quant-instantiations    3
;  :rlimit-count            111233)
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not
  (or
    (<= (- 0 1) (Seq_index vals@1@00 0))
    (or
      (<= (- 0 1) (Seq_index vals@1@00 1))
      (<= (- 0 1) (Seq_index vals@1@00 2)))))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46
;  :arith-assert-diseq      2
;  :arith-assert-lower      11
;  :arith-assert-upper      15
;  :arith-bound-prop        2
;  :arith-eq-adapter        4
;  :arith-pivots            1
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   10
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              4
;  :final-checks            5
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             275
;  :mk-clause               16
;  :num-allocs              3522170
;  :num-checks              15
;  :propagations            22
;  :quant-instantiations    3
;  :rlimit-count            111681
;  :time                    0.00)
(push) ; 3
(assert (not (or
  (<= (- 0 1) (Seq_index vals@1@00 0))
  (or (<= (- 0 1) (Seq_index vals@1@00 1)) (<= (- 0 1) (Seq_index vals@1@00 2))))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47
;  :arith-assert-diseq      2
;  :arith-assert-lower      12
;  :arith-assert-upper      19
;  :arith-bound-prop        5
;  :arith-eq-adapter        4
;  :arith-pivots            2
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              7
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             275
;  :mk-clause               19
;  :num-allocs              3522170
;  :num-checks              16
;  :propagations            25
;  :quant-instantiations    3
;  :rlimit-count            112135)
; [then-branch: 8 | -1 <= vals@1@00[0] || -1 <= vals@1@00[1] || -1 <= vals@1@00[2] | live]
; [else-branch: 8 | !(-1 <= vals@1@00[0] || -1 <= vals@1@00[1] || -1 <= vals@1@00[2]) | live]
(push) ; 3
; [then-branch: 8 | -1 <= vals@1@00[0] || -1 <= vals@1@00[1] || -1 <= vals@1@00[2]]
(assert (or
  (<= (- 0 1) (Seq_index vals@1@00 0))
  (or (<= (- 0 1) (Seq_index vals@1@00 1)) (<= (- 0 1) (Seq_index vals@1@00 2)))))
; [eval] -1 <= vals[0] && result == vals[0] || -1 <= vals[1] && result == vals[1] || -1 <= vals[2] && result == vals[2]
; [eval] -1 <= vals[0] && result == vals[0]
; [eval] -1 <= vals[0]
; [eval] -1
; [eval] vals[0]
(set-option :timeout 0)
(push) ; 4
(assert (not (< 0 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47
;  :arith-assert-diseq      2
;  :arith-assert-lower      12
;  :arith-assert-upper      19
;  :arith-bound-prop        5
;  :arith-eq-adapter        4
;  :arith-pivots            2
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              7
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             275
;  :mk-clause               20
;  :num-allocs              3522170
;  :num-checks              17
;  :propagations            25
;  :quant-instantiations    3
;  :rlimit-count            112260)
(push) ; 4
; [then-branch: 9 | -1 <= vals@1@00[0] | live]
; [else-branch: 9 | !(-1 <= vals@1@00[0]) | live]
(push) ; 5
; [then-branch: 9 | -1 <= vals@1@00[0]]
(assert (<= (- 0 1) (Seq_index vals@1@00 0)))
; [eval] result == vals[0]
; [eval] vals[0]
(push) ; 6
(assert (not (< 0 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47
;  :arith-add-rows          2
;  :arith-assert-diseq      2
;  :arith-assert-lower      13
;  :arith-assert-upper      20
;  :arith-bound-prop        5
;  :arith-eq-adapter        4
;  :arith-pivots            3
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              7
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             275
;  :mk-clause               20
;  :num-allocs              3522170
;  :num-checks              18
;  :propagations            26
;  :quant-instantiations    3
;  :rlimit-count            112379)
(pop) ; 5
(push) ; 5
; [else-branch: 9 | !(-1 <= vals@1@00[0])]
(assert (not (<= (- 0 1) (Seq_index vals@1@00 0))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 10 | result@2@00 == vals@1@00[0] && -1 <= vals@1@00[0] | live]
; [else-branch: 10 | !(result@2@00 == vals@1@00[0] && -1 <= vals@1@00[0]) | live]
(push) ; 5
; [then-branch: 10 | result@2@00 == vals@1@00[0] && -1 <= vals@1@00[0]]
(assert (and
  (= result@2@00 (Seq_index vals@1@00 0))
  (<= (- 0 1) (Seq_index vals@1@00 0))))
(pop) ; 5
(push) ; 5
; [else-branch: 10 | !(result@2@00 == vals@1@00[0] && -1 <= vals@1@00[0])]
(assert (not
  (and
    (= result@2@00 (Seq_index vals@1@00 0))
    (<= (- 0 1) (Seq_index vals@1@00 0)))))
; [eval] -1 <= vals[1] && result == vals[1]
; [eval] -1 <= vals[1]
; [eval] -1
; [eval] vals[1]
(push) ; 6
(assert (not (< 1 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47
;  :arith-add-rows          2
;  :arith-assert-diseq      2
;  :arith-assert-lower      13
;  :arith-assert-upper      20
;  :arith-bound-prop        5
;  :arith-eq-adapter        5
;  :arith-pivots            3
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              7
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             277
;  :mk-clause               25
;  :num-allocs              3522170
;  :num-checks              19
;  :propagations            26
;  :quant-instantiations    3
;  :rlimit-count            112541)
(push) ; 6
; [then-branch: 11 | -1 <= vals@1@00[1] | live]
; [else-branch: 11 | !(-1 <= vals@1@00[1]) | live]
(push) ; 7
; [then-branch: 11 | -1 <= vals@1@00[1]]
(assert (<= (- 0 1) (Seq_index vals@1@00 1)))
; [eval] result == vals[1]
; [eval] vals[1]
(push) ; 8
(assert (not (< 1 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47
;  :arith-add-rows          2
;  :arith-assert-diseq      2
;  :arith-assert-lower      14
;  :arith-assert-upper      21
;  :arith-bound-prop        5
;  :arith-eq-adapter        5
;  :arith-pivots            3
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              7
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             277
;  :mk-clause               25
;  :num-allocs              3522170
;  :num-checks              20
;  :propagations            27
;  :quant-instantiations    3
;  :rlimit-count            112624)
(pop) ; 7
(push) ; 7
; [else-branch: 11 | !(-1 <= vals@1@00[1])]
(assert (not (<= (- 0 1) (Seq_index vals@1@00 1))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 12 | result@2@00 == vals@1@00[1] && -1 <= vals@1@00[1] | live]
; [else-branch: 12 | !(result@2@00 == vals@1@00[1] && -1 <= vals@1@00[1]) | live]
(push) ; 7
; [then-branch: 12 | result@2@00 == vals@1@00[1] && -1 <= vals@1@00[1]]
(assert (and
  (= result@2@00 (Seq_index vals@1@00 1))
  (<= (- 0 1) (Seq_index vals@1@00 1))))
(pop) ; 7
(push) ; 7
; [else-branch: 12 | !(result@2@00 == vals@1@00[1] && -1 <= vals@1@00[1])]
(assert (not
  (and
    (= result@2@00 (Seq_index vals@1@00 1))
    (<= (- 0 1) (Seq_index vals@1@00 1)))))
; [eval] -1 <= vals[2] && result == vals[2]
; [eval] -1 <= vals[2]
; [eval] -1
; [eval] vals[2]
(push) ; 8
(assert (not (< 2 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47
;  :arith-add-rows          2
;  :arith-assert-diseq      2
;  :arith-assert-lower      14
;  :arith-assert-upper      21
;  :arith-bound-prop        5
;  :arith-eq-adapter        6
;  :arith-pivots            3
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              7
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             279
;  :mk-clause               30
;  :num-allocs              3522170
;  :num-checks              21
;  :propagations            27
;  :quant-instantiations    3
;  :rlimit-count            112786)
(push) ; 8
; [then-branch: 13 | -1 <= vals@1@00[2] | live]
; [else-branch: 13 | !(-1 <= vals@1@00[2]) | live]
(push) ; 9
; [then-branch: 13 | -1 <= vals@1@00[2]]
(assert (<= (- 0 1) (Seq_index vals@1@00 2)))
; [eval] result == vals[2]
; [eval] vals[2]
(push) ; 10
(assert (not (< 2 (Seq_length vals@1@00))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47
;  :arith-add-rows          2
;  :arith-assert-diseq      2
;  :arith-assert-lower      15
;  :arith-assert-upper      22
;  :arith-bound-prop        5
;  :arith-eq-adapter        6
;  :arith-pivots            3
;  :binary-propagations     16
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              7
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             279
;  :mk-clause               30
;  :num-allocs              3522170
;  :num-checks              22
;  :propagations            28
;  :quant-instantiations    3
;  :rlimit-count            112869)
(pop) ; 9
(push) ; 9
; [else-branch: 13 | !(-1 <= vals@1@00[2])]
(assert (not (<= (- 0 1) (Seq_index vals@1@00 2))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 8 | !(-1 <= vals@1@00[0] || -1 <= vals@1@00[1] || -1 <= vals@1@00[2])]
(assert (not
  (or
    (<= (- 0 1) (Seq_index vals@1@00 0))
    (or
      (<= (- 0 1) (Seq_index vals@1@00 1))
      (<= (- 0 1) (Seq_index vals@1@00 2))))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (<= (- 0 1) (Seq_index vals@1@00 0))
    (or
      (<= (- 0 1) (Seq_index vals@1@00 1))
      (<= (- 0 1) (Seq_index vals@1@00 2))))
  (or
    (and
      (= result@2@00 (Seq_index vals@1@00 0))
      (<= (- 0 1) (Seq_index vals@1@00 0)))
    (or
      (and
        (= result@2@00 (Seq_index vals@1@00 1))
        (<= (- 0 1) (Seq_index vals@1@00 1)))
      (and
        (= result@2@00 (Seq_index vals@1@00 2))
        (<= (- 0 1) (Seq_index vals@1@00 2)))))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (diz@0@00 $Ref) (vals@1@00 Seq<Int>)) (!
  (=
    (Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@0@00 vals@1@00)
    (Main_find_minimum_advance_Sequence$Integer$ s@$ diz@0@00 vals@1@00))
  :pattern ((Main_find_minimum_advance_Sequence$Integer$ s@$ diz@0@00 vals@1@00))
  )))
(assert (forall ((s@$ $Snap) (diz@0@00 $Ref) (vals@1@00 Seq<Int>)) (!
  (Main_find_minimum_advance_Sequence$Integer$%stateless diz@0@00 vals@1@00)
  :pattern ((Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@0@00 vals@1@00))
  )))
(assert (forall ((s@$ $Snap) (diz@0@00 $Ref) (vals@1@00 Seq<Int>)) (!
  (let ((result@2@00 (Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@0@00 vals@1@00))) (implies
    (and (not (= diz@0@00 $Ref.null)) (= (Seq_length vals@1@00) 3))
    (and
      (and
        (and
          (or
            (< (Seq_index vals@1@00 0) (- 0 1))
            (<= result@2@00 (Seq_index vals@1@00 0)))
          (or
            (< (Seq_index vals@1@00 1) (- 0 1))
            (<= result@2@00 (Seq_index vals@1@00 1))))
        (or
          (< (Seq_index vals@1@00 2) (- 0 1))
          (<= result@2@00 (Seq_index vals@1@00 2))))
      (and
        (implies
          (and
            (and
              (< (Seq_index vals@1@00 0) (- 0 1))
              (< (Seq_index vals@1@00 1) (- 0 1)))
            (< (Seq_index vals@1@00 2) (- 0 1)))
          (= result@2@00 0))
        (implies
          (or
            (or
              (<= (- 0 1) (Seq_index vals@1@00 0))
              (<= (- 0 1) (Seq_index vals@1@00 1)))
            (<= (- 0 1) (Seq_index vals@1@00 2)))
          (or
            (or
              (and
                (<= (- 0 1) (Seq_index vals@1@00 0))
                (= result@2@00 (Seq_index vals@1@00 0)))
              (and
                (<= (- 0 1) (Seq_index vals@1@00 1))
                (= result@2@00 (Seq_index vals@1@00 1))))
            (and
              (<= (- 0 1) (Seq_index vals@1@00 2))
              (= result@2@00 (Seq_index vals@1@00 2)))))))))
  :pattern ((Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@0@00 vals@1@00))
  )))
; ---------- FUNCTION instanceof_TYPE_TYPE----------
(declare-fun t@3@00 () TYPE)
(declare-fun u@4@00 () TYPE)
(declare-fun result@5@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(declare-const $t@13@00 $Snap)
(assert (= $t@13@00 $Snap.unit))
; [eval] result == (t == u || directSuperclass(t) == u)
; [eval] t == u || directSuperclass(t) == u
; [eval] t == u
(push) ; 2
; [then-branch: 14 | t@3@00 == u@4@00 | live]
; [else-branch: 14 | t@3@00 != u@4@00 | live]
(push) ; 3
; [then-branch: 14 | t@3@00 == u@4@00]
(assert (= t@3@00 u@4@00))
(pop) ; 3
(push) ; 3
; [else-branch: 14 | t@3@00 != u@4@00]
(assert (not (= t@3@00 u@4@00)))
; [eval] directSuperclass(t) == u
; [eval] directSuperclass(t)
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (= result@5@00 (or (= t@3@00 u@4@00) (= (directSuperclass<TYPE> t@3@00) u@4@00))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (t@3@00 TYPE) (u@4@00 TYPE)) (!
  (=
    (instanceof_TYPE_TYPE%limited s@$ t@3@00 u@4@00)
    (instanceof_TYPE_TYPE s@$ t@3@00 u@4@00))
  :pattern ((instanceof_TYPE_TYPE s@$ t@3@00 u@4@00))
  )))
(assert (forall ((s@$ $Snap) (t@3@00 TYPE) (u@4@00 TYPE)) (!
  (instanceof_TYPE_TYPE%stateless t@3@00 u@4@00)
  :pattern ((instanceof_TYPE_TYPE%limited s@$ t@3@00 u@4@00))
  )))
(assert (forall ((s@$ $Snap) (t@3@00 TYPE) (u@4@00 TYPE)) (!
  (let ((result@5@00 (instanceof_TYPE_TYPE%limited s@$ t@3@00 u@4@00))) (=
    result@5@00
    (or (= t@3@00 u@4@00) (= (directSuperclass<TYPE> t@3@00) u@4@00))))
  :pattern ((instanceof_TYPE_TYPE%limited s@$ t@3@00 u@4@00))
  )))
; ---------- FUNCTION new_frac----------
(declare-fun x@6@00 () $Perm)
(declare-fun result@7@00 () frac)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] 0 / 1 < x
(push) ; 2
(assert (not (not (= 1 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               54
;  :arith-add-rows          2
;  :arith-assert-diseq      2
;  :arith-assert-lower      15
;  :arith-assert-upper      22
;  :arith-bound-prop        5
;  :arith-eq-adapter        6
;  :arith-pivots            4
;  :binary-propagations     16
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              29
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             288
;  :mk-clause               30
;  :num-allocs              3522170
;  :num-checks              23
;  :propagations            28
;  :quant-instantiations    3
;  :rlimit-count            114642)
(assert (< $Perm.No x@6@00))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] x <= 1 / 1
(push) ; 2
(assert (not (not (= 1 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               55
;  :arith-add-rows          2
;  :arith-assert-diseq      2
;  :arith-assert-lower      16
;  :arith-assert-upper      22
;  :arith-bound-prop        5
;  :arith-eq-adapter        6
;  :arith-pivots            4
;  :binary-propagations     16
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              29
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             290
;  :mk-clause               30
;  :num-allocs              3522170
;  :num-checks              24
;  :propagations            28
;  :quant-instantiations    3
;  :rlimit-count            114753)
(assert (<= x@6@00 $Perm.Write))
(declare-const $t@14@00 $Snap)
(assert (= $t@14@00 $Snap.unit))
; [eval] frac_val(result) == x
; [eval] frac_val(result)
(assert (= (frac_val<Perm> result@7@00) x@6@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (x@6@00 $Perm)) (!
  (= (new_frac%limited s@$ x@6@00) (new_frac s@$ x@6@00))
  :pattern ((new_frac s@$ x@6@00))
  )))
(assert (forall ((s@$ $Snap) (x@6@00 $Perm)) (!
  (new_frac%stateless x@6@00)
  :pattern ((new_frac%limited s@$ x@6@00))
  )))
(assert (forall ((s@$ $Snap) (x@6@00 $Perm)) (!
  (let ((result@7@00 (new_frac%limited s@$ x@6@00))) (implies
    (and (< $Perm.No x@6@00) (<= x@6@00 $Perm.Write))
    (= (frac_val<Perm> result@7@00) x@6@00)))
  :pattern ((new_frac%limited s@$ x@6@00))
  )))
; ---------- FUNCTION Sensor_rand__randomize_0----------
(declare-fun diz@8@00 () $Ref)
(declare-fun result@9@00 () Int)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ $Snap.unit))
; [eval] diz != null
(assert (not (= diz@8@00 $Ref.null)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (diz@8@00 $Ref)) (!
  (=
    (Sensor_rand__randomize_0%limited s@$ diz@8@00)
    (Sensor_rand__randomize_0 s@$ diz@8@00))
  :pattern ((Sensor_rand__randomize_0 s@$ diz@8@00))
  )))
(assert (forall ((s@$ $Snap) (diz@8@00 $Ref)) (!
  (Sensor_rand__randomize_0%stateless diz@8@00)
  :pattern ((Sensor_rand__randomize_0%limited s@$ diz@8@00))
  )))
; ---------- FUNCTION new_zfrac----------
(declare-fun x@10@00 () $Perm)
(declare-fun result@11@00 () zfrac)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] 0 / 1 <= x
(push) ; 2
(assert (not (not (= 1 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               61
;  :arith-add-rows          2
;  :arith-assert-diseq      2
;  :arith-assert-lower      16
;  :arith-assert-upper      22
;  :arith-bound-prop        5
;  :arith-eq-adapter        6
;  :arith-pivots            4
;  :binary-propagations     16
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              29
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             297
;  :mk-clause               30
;  :num-allocs              3522170
;  :num-checks              25
;  :propagations            28
;  :quant-instantiations    3
;  :rlimit-count            115504)
(assert (<= $Perm.No x@10@00))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] x <= 1 / 1
(push) ; 2
(assert (not (not (= 1 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               62
;  :arith-add-rows          2
;  :arith-assert-diseq      2
;  :arith-assert-lower      17
;  :arith-assert-upper      22
;  :arith-bound-prop        5
;  :arith-eq-adapter        6
;  :arith-pivots            4
;  :binary-propagations     16
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              29
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.78
;  :mk-bool-var             299
;  :mk-clause               30
;  :num-allocs              3522170
;  :num-checks              26
;  :propagations            28
;  :quant-instantiations    3
;  :rlimit-count            115595)
(assert (<= x@10@00 $Perm.Write))
(declare-const $t@15@00 $Snap)
(assert (= $t@15@00 $Snap.unit))
; [eval] zfrac_val(result) == x
; [eval] zfrac_val(result)
(assert (= (zfrac_val<Perm> result@11@00) x@10@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (x@10@00 $Perm)) (!
  (= (new_zfrac%limited s@$ x@10@00) (new_zfrac s@$ x@10@00))
  :pattern ((new_zfrac s@$ x@10@00))
  )))
(assert (forall ((s@$ $Snap) (x@10@00 $Perm)) (!
  (new_zfrac%stateless x@10@00)
  :pattern ((new_zfrac%limited s@$ x@10@00))
  )))
(assert (forall ((s@$ $Snap) (x@10@00 $Perm)) (!
  (let ((result@11@00 (new_zfrac%limited s@$ x@10@00))) (implies
    (and (<= $Perm.No x@10@00) (<= x@10@00 $Perm.Write))
    (= (zfrac_val<Perm> result@11@00) x@10@00)))
  :pattern ((new_zfrac%limited s@$ x@10@00))
  )))
; ---------- Controller_joinToken_EncodedGlobalVariables ----------
(declare-const diz@16@00 $Ref)
(declare-const globals@17@00 $Ref)
; ---------- Controller_idleToken_EncodedGlobalVariables ----------
(declare-const diz@18@00 $Ref)
(declare-const globals@19@00 $Ref)
; ---------- Main_lock_held_EncodedGlobalVariables ----------
(declare-const diz@20@00 $Ref)
(declare-const globals@21@00 $Ref)
; ---------- Main_lock_invariant_EncodedGlobalVariables ----------
(declare-const diz@22@00 $Ref)
(declare-const globals@23@00 $Ref)
(push) ; 1
(declare-const $t@24@00 $Snap)
(assert (= $t@24@00 ($Snap.combine ($Snap.first $t@24@00) ($Snap.second $t@24@00))))
(assert (= ($Snap.first $t@24@00) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@22@00 $Ref.null)))
(assert (=
  ($Snap.second $t@24@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@24@00))
    ($Snap.second ($Snap.second $t@24@00)))))
(assert (= ($Snap.first ($Snap.second $t@24@00)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@24@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@24@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@24@00))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@24@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@25@00 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 15 | 0 <= i@25@00 | live]
; [else-branch: 15 | !(0 <= i@25@00) | live]
(push) ; 4
; [then-branch: 15 | 0 <= i@25@00]
(assert (<= 0 i@25@00))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 15 | !(0 <= i@25@00)]
(assert (not (<= 0 i@25@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 16 | i@25@00 < |First:(Second:(Second:(Second:($t@24@00))))| && 0 <= i@25@00 | live]
; [else-branch: 16 | !(i@25@00 < |First:(Second:(Second:(Second:($t@24@00))))| && 0 <= i@25@00) | live]
(push) ; 4
; [then-branch: 16 | i@25@00 < |First:(Second:(Second:(Second:($t@24@00))))| && 0 <= i@25@00]
(assert (and
  (<
    i@25@00
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))
  (<= 0 i@25@00)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 5
(assert (not (>= i@25@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               112
;  :arith-add-rows          2
;  :arith-assert-diseq      4
;  :arith-assert-lower      24
;  :arith-assert-upper      25
;  :arith-bound-prop        5
;  :arith-eq-adapter        10
;  :arith-pivots            4
;  :binary-propagations     16
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              29
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             335
;  :mk-clause               36
;  :num-allocs              3643811
;  :num-checks              27
;  :propagations            30
;  :quant-instantiations    9
;  :rlimit-count            117403)
; [eval] -1
(push) ; 5
; [then-branch: 17 | First:(Second:(Second:(Second:($t@24@00))))[i@25@00] == -1 | live]
; [else-branch: 17 | First:(Second:(Second:(Second:($t@24@00))))[i@25@00] != -1 | live]
(push) ; 6
; [then-branch: 17 | First:(Second:(Second:(Second:($t@24@00))))[i@25@00] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))
    i@25@00)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 17 | First:(Second:(Second:(Second:($t@24@00))))[i@25@00] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))
      i@25@00)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@25@00 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               112
;  :arith-add-rows          2
;  :arith-assert-diseq      4
;  :arith-assert-lower      24
;  :arith-assert-upper      25
;  :arith-bound-prop        5
;  :arith-eq-adapter        10
;  :arith-pivots            4
;  :binary-propagations     16
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              29
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             336
;  :mk-clause               36
;  :num-allocs              3643811
;  :num-checks              28
;  :propagations            30
;  :quant-instantiations    9
;  :rlimit-count            117578)
(push) ; 7
; [then-branch: 18 | 0 <= First:(Second:(Second:(Second:($t@24@00))))[i@25@00] | live]
; [else-branch: 18 | !(0 <= First:(Second:(Second:(Second:($t@24@00))))[i@25@00]) | live]
(push) ; 8
; [then-branch: 18 | 0 <= First:(Second:(Second:(Second:($t@24@00))))[i@25@00]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))
    i@25@00)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@25@00 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               112
;  :arith-add-rows          2
;  :arith-assert-diseq      5
;  :arith-assert-lower      27
;  :arith-assert-upper      25
;  :arith-bound-prop        5
;  :arith-eq-adapter        11
;  :arith-pivots            4
;  :binary-propagations     16
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              29
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             339
;  :mk-clause               37
;  :num-allocs              3643811
;  :num-checks              29
;  :propagations            30
;  :quant-instantiations    9
;  :rlimit-count            117702)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 18 | !(0 <= First:(Second:(Second:(Second:($t@24@00))))[i@25@00])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))
      i@25@00))))
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
; [else-branch: 16 | !(i@25@00 < |First:(Second:(Second:(Second:($t@24@00))))| && 0 <= i@25@00)]
(assert (not
  (and
    (<
      i@25@00
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))
    (<= 0 i@25@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@25@00 Int)) (!
  (implies
    (and
      (<
        i@25@00
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))
      (<= 0 i@25@00))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))
          i@25@00)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))
            i@25@00)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))
            i@25@00)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))
    i@25@00))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))
(declare-const $k@26@00 $Perm)
(assert ($Perm.isReadVar $k@26@00 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@26@00 $Perm.No) (< $Perm.No $k@26@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               117
;  :arith-add-rows          2
;  :arith-assert-diseq      6
;  :arith-assert-lower      29
;  :arith-assert-upper      26
;  :arith-bound-prop        5
;  :arith-eq-adapter        12
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               1
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             345
;  :mk-clause               39
;  :num-allocs              3643811
;  :num-checks              30
;  :propagations            31
;  :quant-instantiations    9
;  :rlimit-count            118470)
(assert (<= $Perm.No $k@26@00))
(assert (<= $k@26@00 $Perm.Write))
(assert (implies (< $Perm.No $k@26@00) (not (= diz@22@00 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))
  $Snap.unit))
; [eval] diz.Main_robot != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@26@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               123
;  :arith-add-rows          2
;  :arith-assert-diseq      6
;  :arith-assert-lower      29
;  :arith-assert-upper      27
;  :arith-bound-prop        5
;  :arith-eq-adapter        12
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               2
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             348
;  :mk-clause               39
;  :num-allocs              3643811
;  :num-checks              31
;  :propagations            31
;  :quant-instantiations    9
;  :rlimit-count            118793)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))))
(declare-const $k@27@00 $Perm)
(assert ($Perm.isReadVar $k@27@00 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@27@00 $Perm.No) (< $Perm.No $k@27@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               129
;  :arith-add-rows          2
;  :arith-assert-diseq      7
;  :arith-assert-lower      31
;  :arith-assert-upper      28
;  :arith-bound-prop        5
;  :arith-eq-adapter        13
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               3
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             355
;  :mk-clause               41
;  :num-allocs              3643811
;  :num-checks              32
;  :propagations            32
;  :quant-instantiations    10
;  :rlimit-count            119293)
(assert (<= $Perm.No $k@27@00))
(assert (<= $k@27@00 $Perm.Write))
(assert (implies (< $Perm.No $k@27@00) (not (= diz@22@00 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot_sensor != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@27@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               135
;  :arith-add-rows          2
;  :arith-assert-diseq      7
;  :arith-assert-lower      31
;  :arith-assert-upper      29
;  :arith-bound-prop        5
;  :arith-eq-adapter        13
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               4
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             358
;  :mk-clause               41
;  :num-allocs              3643811
;  :num-checks              33
;  :propagations            32
;  :quant-instantiations    10
;  :rlimit-count            119636)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@27@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               141
;  :arith-add-rows          2
;  :arith-assert-diseq      7
;  :arith-assert-lower      31
;  :arith-assert-upper      29
;  :arith-bound-prop        5
;  :arith-eq-adapter        13
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               5
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             361
;  :mk-clause               41
;  :num-allocs              3643811
;  :num-checks              34
;  :propagations            32
;  :quant-instantiations    11
;  :rlimit-count            120010)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))))))
(declare-const $k@28@00 $Perm)
(assert ($Perm.isReadVar $k@28@00 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@28@00 $Perm.No) (< $Perm.No $k@28@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               146
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      33
;  :arith-assert-upper      30
;  :arith-bound-prop        5
;  :arith-eq-adapter        14
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               6
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             366
;  :mk-clause               43
;  :num-allocs              3643811
;  :num-checks              35
;  :propagations            33
;  :quant-instantiations    11
;  :rlimit-count            120431)
(assert (<= $Perm.No $k@28@00))
(assert (<= $k@28@00 $Perm.Write))
(assert (implies (< $Perm.No $k@28@00) (not (= diz@22@00 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot_controller != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@28@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               152
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      33
;  :arith-assert-upper      31
;  :arith-bound-prop        5
;  :arith-eq-adapter        14
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               7
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             369
;  :mk-clause               43
;  :num-allocs              3643811
;  :num-checks              36
;  :propagations            33
;  :quant-instantiations    11
;  :rlimit-count            120804)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@28@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               158
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      33
;  :arith-assert-upper      31
;  :arith-bound-prop        5
;  :arith-eq-adapter        14
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               8
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             372
;  :mk-clause               43
;  :num-allocs              3643811
;  :num-checks              37
;  :propagations            33
;  :quant-instantiations    12
;  :rlimit-count            121210)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@26@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               163
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      33
;  :arith-assert-upper      31
;  :arith-bound-prop        5
;  :arith-eq-adapter        14
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               9
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             373
;  :mk-clause               43
;  :num-allocs              3643811
;  :num-checks              38
;  :propagations            33
;  :quant-instantiations    12
;  :rlimit-count            121517)
(declare-const $k@29@00 $Perm)
(assert ($Perm.isReadVar $k@29@00 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@29@00 $Perm.No) (< $Perm.No $k@29@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               163
;  :arith-add-rows          2
;  :arith-assert-diseq      9
;  :arith-assert-lower      35
;  :arith-assert-upper      32
;  :arith-bound-prop        5
;  :arith-eq-adapter        15
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               10
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             377
;  :mk-clause               45
;  :num-allocs              3643811
;  :num-checks              39
;  :propagations            34
;  :quant-instantiations    12
;  :rlimit-count            121716)
(assert (<= $Perm.No $k@29@00))
(assert (<= $k@29@00 $Perm.Write))
(assert (implies
  (< $Perm.No $k@29@00)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00)))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot.Robot_m == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@26@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               164
;  :arith-add-rows          2
;  :arith-assert-diseq      9
;  :arith-assert-lower      35
;  :arith-assert-upper      33
;  :arith-bound-prop        5
;  :arith-eq-adapter        15
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               11
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             379
;  :mk-clause               45
;  :num-allocs              3643811
;  :num-checks              40
;  :propagations            34
;  :quant-instantiations    12
;  :rlimit-count            122032)
(push) ; 2
(assert (not (< $Perm.No $k@29@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               164
;  :arith-add-rows          2
;  :arith-assert-diseq      9
;  :arith-assert-lower      35
;  :arith-assert-upper      33
;  :arith-bound-prop        5
;  :arith-eq-adapter        15
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               12
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   12
;  :datatype-splits         2
;  :decisions               8
;  :del-clause              30
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.94
;  :mk-bool-var             379
;  :mk-clause               45
;  :num-allocs              3643811
;  :num-checks              41
;  :propagations            34
;  :quant-instantiations    12
;  :rlimit-count            122080)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@00))))))))))))))))))
  diz@22@00))
(pop) ; 1
; ---------- Sensor_joinToken_EncodedGlobalVariables ----------
(declare-const diz@30@00 $Ref)
(declare-const globals@31@00 $Ref)
; ---------- Sensor_idleToken_EncodedGlobalVariables ----------
(declare-const diz@32@00 $Ref)
(declare-const globals@33@00 $Ref)
