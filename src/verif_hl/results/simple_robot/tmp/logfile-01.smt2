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
; ------------------------------------------------------------
; Begin function- and predicate-related preamble
; Declaring symbols related to program functions (from verification)
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
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- Main_Main_EncodedGlobalVariables ----------
(declare-const globals@0@01 $Ref)
(declare-const sys__result@1@01 $Ref)
(declare-const globals@2@01 $Ref)
(declare-const sys__result@3@01 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@4@01 $Snap)
(assert (= $t@4@01 ($Snap.combine ($Snap.first $t@4@01) ($Snap.second $t@4@01))))
(assert (= ($Snap.first $t@4@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@3@01 $Ref.null)))
(assert (= ($Snap.second $t@4@01) $Snap.unit))
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
(assert (= (type_of<TYPE> sys__result@3@01) (as class_Main<TYPE>  TYPE)))
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_12__14: Ref
(declare-const __flatten_12__14@5@01 $Ref)
; [exec]
; var __flatten_10__13: Ref
(declare-const __flatten_10__13@6@01 $Ref)
; [exec]
; var __flatten_8__12: Ref
(declare-const __flatten_8__12@7@01 $Ref)
; [exec]
; var __flatten_7__11: Seq[Int]
(declare-const __flatten_7__11@8@01 Seq<Int>)
; [exec]
; var __flatten_6__10: Seq[Int]
(declare-const __flatten_6__10@9@01 Seq<Int>)
; [exec]
; var __flatten_5__9: Seq[Int]
(declare-const __flatten_5__9@10@01 Seq<Int>)
; [exec]
; var __flatten_4__8: Seq[Int]
(declare-const __flatten_4__8@11@01 Seq<Int>)
; [exec]
; var diz__7: Ref
(declare-const diz__7@12@01 $Ref)
; [exec]
; diz__7 := new(Main_process_state, Main_event_state, Main_robot, Main_robot_sensor, Main_robot_controller)
(declare-const diz__7@13@01 $Ref)
(assert (not (= diz__7@13@01 $Ref.null)))
(declare-const Main_process_state@14@01 Seq<Int>)
(declare-const Main_event_state@15@01 Seq<Int>)
(declare-const Main_robot@16@01 $Ref)
(declare-const Main_robot_sensor@17@01 $Ref)
(declare-const Main_robot_controller@18@01 $Ref)
(assert (not (= diz__7@13@01 sys__result@3@01)))
(assert (not (= diz__7@13@01 diz__7@12@01)))
(assert (not (= diz__7@13@01 __flatten_12__14@5@01)))
(assert (not (= diz__7@13@01 globals@2@01)))
(assert (not (= diz__7@13@01 __flatten_10__13@6@01)))
(assert (not (= diz__7@13@01 __flatten_8__12@7@01)))
; [exec]
; inhale type_of(diz__7) == class_Main()
(declare-const $t@19@01 $Snap)
(assert (= $t@19@01 $Snap.unit))
; [eval] type_of(diz__7) == class_Main()
; [eval] type_of(diz__7)
; [eval] class_Main()
(assert (= (type_of<TYPE> diz__7@13@01) (as class_Main<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; __flatten_5__9 := Seq(-1, -1)
; [eval] Seq(-1, -1)
; [eval] -1
; [eval] -1
(assert (= (Seq_length (Seq_append (Seq_singleton (- 0 1)) (Seq_singleton (- 0 1)))) 2))
(declare-const __flatten_5__9@20@01 Seq<Int>)
(assert (Seq_equal
  __flatten_5__9@20@01
  (Seq_append (Seq_singleton (- 0 1)) (Seq_singleton (- 0 1)))))
; [exec]
; __flatten_4__8 := __flatten_5__9
; [exec]
; diz__7.Main_process_state := __flatten_4__8
; [exec]
; __flatten_7__11 := Seq(-3, -3, -3)
; [eval] Seq(-3, -3, -3)
; [eval] -3
; [eval] -3
; [eval] -3
(assert (=
  (Seq_length
    (Seq_append
      (Seq_append (Seq_singleton (- 0 3)) (Seq_singleton (- 0 3)))
      (Seq_singleton (- 0 3))))
  3))
(declare-const __flatten_7__11@21@01 Seq<Int>)
(assert (Seq_equal
  __flatten_7__11@21@01
  (Seq_append
    (Seq_append (Seq_singleton (- 0 3)) (Seq_singleton (- 0 3)))
    (Seq_singleton (- 0 3)))))
; [exec]
; __flatten_6__10 := __flatten_7__11
; [exec]
; diz__7.Main_event_state := __flatten_6__10
; [exec]
; __flatten_8__12 := Robot_Robot_EncodedGlobalVariables_Main(globals, diz__7)
(declare-const sys__result@22@01 $Ref)
(declare-const $t@23@01 $Snap)
(assert (= $t@23@01 ($Snap.combine ($Snap.first $t@23@01) ($Snap.second $t@23@01))))
(assert (= ($Snap.first $t@23@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@22@01 $Ref.null)))
(assert (=
  ($Snap.second $t@23@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@23@01))
    ($Snap.second ($Snap.second $t@23@01)))))
(assert (= ($Snap.first ($Snap.second $t@23@01)) $Snap.unit))
; [eval] type_of(sys__result) == class_Robot()
; [eval] type_of(sys__result)
; [eval] class_Robot()
(assert (= (type_of<TYPE> sys__result@22@01) (as class_Robot<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@23@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@23@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@23@01))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@23@01))) $Snap.unit))
; [eval] sys__result.Robot_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@23@01))))
  diz__7@13@01))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; diz__7.Main_robot := __flatten_8__12
; [exec]
; __flatten_10__13 := Sensor_Sensor_EncodedGlobalVariables_Main(globals, diz__7)
(declare-const sys__result@24@01 $Ref)
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
; [eval] type_of(sys__result) == class_Sensor()
; [eval] type_of(sys__result)
; [eval] class_Sensor()
(assert (= (type_of<TYPE> sys__result@24@01) (as class_Sensor<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@25@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@25@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@25@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@25@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))
  $Snap.unit))
; [eval] sys__result.Sensor_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))
  diz__7@13@01))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__7.Main_robot_sensor := __flatten_10__13
; [exec]
; __flatten_12__14 := Controller_Controller_EncodedGlobalVariables_Main(globals, diz__7)
(declare-const sys__result@26@01 $Ref)
(declare-const $t@27@01 $Snap)
(assert (= $t@27@01 ($Snap.combine ($Snap.first $t@27@01) ($Snap.second $t@27@01))))
(assert (= ($Snap.first $t@27@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@26@01 $Ref.null)))
(assert (=
  ($Snap.second $t@27@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@27@01))
    ($Snap.second ($Snap.second $t@27@01)))))
(assert (= ($Snap.first ($Snap.second $t@27@01)) $Snap.unit))
; [eval] type_of(sys__result) == class_Controller()
; [eval] type_of(sys__result)
; [eval] class_Controller()
(assert (= (type_of<TYPE> sys__result@26@01) (as class_Controller<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@27@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@27@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@27@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@27@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@27@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@01)))))
  $Snap.unit))
; [eval] sys__result.Controller_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@27@01)))))
  diz__7@13@01))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__7.Main_robot_controller := __flatten_12__14
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz__7, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(set-option :timeout 0)
(push) ; 3
(assert (not (= (Seq_length __flatten_5__9@20@01) 2)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               177
;  :arith-add-rows          13
;  :arith-assert-diseq      9
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-bound-prop        2
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        4
;  :arith-pivots            9
;  :binary-propagations     16
;  :conflicts               3
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   17
;  :datatype-splits         9
;  :decisions               14
;  :del-clause              118
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :mk-bool-var             428
;  :mk-clause               124
;  :num-allocs              3647888
;  :num-checks              6
;  :propagations            72
;  :quant-instantiations    42
;  :rlimit-count            116029)
(assert (= (Seq_length __flatten_5__9@20@01) 2))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(push) ; 3
(assert (not (= (Seq_length __flatten_7__11@21@01) 3)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               178
;  :arith-add-rows          13
;  :arith-assert-diseq      9
;  :arith-assert-lower      38
;  :arith-assert-upper      20
;  :arith-bound-prop        2
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        4
;  :arith-pivots            9
;  :binary-propagations     16
;  :conflicts               4
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   17
;  :datatype-splits         9
;  :decisions               14
;  :del-clause              118
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :mk-bool-var             434
;  :mk-clause               124
;  :num-allocs              3647888
;  :num-checks              7
;  :propagations            72
;  :quant-instantiations    42
;  :rlimit-count            116154)
(assert (= (Seq_length __flatten_7__11@21@01) 3))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@28@01 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@28@01 | live]
; [else-branch: 0 | !(0 <= i@28@01) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@28@01]
(assert (<= 0 i@28@01))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@28@01)]
(assert (not (<= 0 i@28@01)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@28@01 < |__flatten_5__9@20@01| && 0 <= i@28@01 | live]
; [else-branch: 1 | !(i@28@01 < |__flatten_5__9@20@01| && 0 <= i@28@01) | live]
(push) ; 5
; [then-branch: 1 | i@28@01 < |__flatten_5__9@20@01| && 0 <= i@28@01]
(assert (and (< i@28@01 (Seq_length __flatten_5__9@20@01)) (<= 0 i@28@01)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 6
(assert (not (>= i@28@01 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               179
;  :arith-add-rows          13
;  :arith-assert-diseq      9
;  :arith-assert-lower      40
;  :arith-assert-upper      22
;  :arith-bound-prop        2
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        4
;  :arith-pivots            9
;  :binary-propagations     16
;  :conflicts               4
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   17
;  :datatype-splits         9
;  :decisions               14
;  :del-clause              118
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :mk-bool-var             439
;  :mk-clause               124
;  :num-allocs              3647888
;  :num-checks              8
;  :propagations            72
;  :quant-instantiations    42
;  :rlimit-count            116341)
; [eval] -1
(push) ; 6
; [then-branch: 2 | __flatten_5__9@20@01[i@28@01] == -1 | live]
; [else-branch: 2 | __flatten_5__9@20@01[i@28@01] != -1 | live]
(push) ; 7
; [then-branch: 2 | __flatten_5__9@20@01[i@28@01] == -1]
(assert (= (Seq_index __flatten_5__9@20@01 i@28@01) (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | __flatten_5__9@20@01[i@28@01] != -1]
(assert (not (= (Seq_index __flatten_5__9@20@01 i@28@01) (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@28@01 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               180
;  :arith-add-rows          15
;  :arith-assert-diseq      9
;  :arith-assert-lower      40
;  :arith-assert-upper      22
;  :arith-bound-prop        2
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        4
;  :arith-pivots            9
;  :binary-propagations     16
;  :conflicts               4
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   17
;  :datatype-splits         9
;  :decisions               14
;  :del-clause              118
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :mk-bool-var             444
;  :mk-clause               129
;  :num-allocs              3647888
;  :num-checks              9
;  :propagations            72
;  :quant-instantiations    43
;  :rlimit-count            116509)
(push) ; 8
; [then-branch: 3 | 0 <= __flatten_5__9@20@01[i@28@01] | live]
; [else-branch: 3 | !(0 <= __flatten_5__9@20@01[i@28@01]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= __flatten_5__9@20@01[i@28@01]]
(assert (<= 0 (Seq_index __flatten_5__9@20@01 i@28@01)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@28@01 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               180
;  :arith-add-rows          15
;  :arith-assert-diseq      10
;  :arith-assert-lower      43
;  :arith-assert-upper      22
;  :arith-bound-prop        2
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        4
;  :arith-pivots            9
;  :binary-propagations     16
;  :conflicts               4
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   17
;  :datatype-splits         9
;  :decisions               14
;  :del-clause              118
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :mk-bool-var             447
;  :mk-clause               130
;  :num-allocs              3647888
;  :num-checks              10
;  :propagations            72
;  :quant-instantiations    43
;  :rlimit-count            116582)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= __flatten_5__9@20@01[i@28@01])]
(assert (not (<= 0 (Seq_index __flatten_5__9@20@01 i@28@01))))
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
; [else-branch: 1 | !(i@28@01 < |__flatten_5__9@20@01| && 0 <= i@28@01)]
(assert (not (and (< i@28@01 (Seq_length __flatten_5__9@20@01)) (<= 0 i@28@01))))
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
(assert (not (forall ((i@28@01 Int)) (!
  (implies
    (and (< i@28@01 (Seq_length __flatten_5__9@20@01)) (<= 0 i@28@01))
    (or
      (= (Seq_index __flatten_5__9@20@01 i@28@01) (- 0 1))
      (and
        (<
          (Seq_index __flatten_5__9@20@01 i@28@01)
          (Seq_length __flatten_7__11@21@01))
        (<= 0 (Seq_index __flatten_5__9@20@01 i@28@01)))))
  :pattern ((Seq_index __flatten_5__9@20@01 i@28@01))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               223
;  :arith-add-rows          25
;  :arith-assert-diseq      15
;  :arith-assert-lower      56
;  :arith-assert-upper      28
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               11
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              180
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             495
;  :mk-clause               186
;  :num-allocs              3647888
;  :num-checks              11
;  :propagations            88
;  :quant-instantiations    50
;  :rlimit-count            117455
;  :time                    0.00)
(assert (forall ((i@28@01 Int)) (!
  (implies
    (and (< i@28@01 (Seq_length __flatten_5__9@20@01)) (<= 0 i@28@01))
    (or
      (= (Seq_index __flatten_5__9@20@01 i@28@01) (- 0 1))
      (and
        (<
          (Seq_index __flatten_5__9@20@01 i@28@01)
          (Seq_length __flatten_7__11@21@01))
        (<= 0 (Seq_index __flatten_5__9@20@01 i@28@01)))))
  :pattern ((Seq_index __flatten_5__9@20@01 i@28@01))
  :qid |prog.l<no position>|)))
(declare-const $k@29@01 $Perm)
(assert ($Perm.isReadVar $k@29@01 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@29@01 $Perm.No) (< $Perm.No $k@29@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               223
;  :arith-add-rows          25
;  :arith-assert-diseq      16
;  :arith-assert-lower      58
;  :arith-assert-upper      29
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               12
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              180
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             500
;  :mk-clause               188
;  :num-allocs              3647888
;  :num-checks              12
;  :propagations            89
;  :quant-instantiations    50
;  :rlimit-count            117926)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               223
;  :arith-add-rows          25
;  :arith-assert-diseq      16
;  :arith-assert-lower      58
;  :arith-assert-upper      29
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               12
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              180
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             500
;  :mk-clause               188
;  :num-allocs              3647888
;  :num-checks              13
;  :propagations            89
;  :quant-instantiations    50
;  :rlimit-count            117939)
(assert (< $k@29@01 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@29@01)))
(assert (<= (- $Perm.Write $k@29@01) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@29@01)) (not (= diz__7@13@01 $Ref.null))))
; [eval] diz.Main_robot != null
(declare-const $k@30@01 $Perm)
(assert ($Perm.isReadVar $k@30@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@30@01 $Perm.No) (< $Perm.No $k@30@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               223
;  :arith-add-rows          25
;  :arith-assert-diseq      17
;  :arith-assert-lower      60
;  :arith-assert-upper      31
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               13
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              180
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             505
;  :mk-clause               190
;  :num-allocs              3647888
;  :num-checks              14
;  :propagations            90
;  :quant-instantiations    50
;  :rlimit-count            118227)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               223
;  :arith-add-rows          25
;  :arith-assert-diseq      17
;  :arith-assert-lower      60
;  :arith-assert-upper      31
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               13
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              180
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             505
;  :mk-clause               190
;  :num-allocs              3647888
;  :num-checks              15
;  :propagations            90
;  :quant-instantiations    50
;  :rlimit-count            118240)
(assert (< $k@30@01 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@30@01)))
(assert (<= (- $Perm.Write $k@30@01) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@30@01)) (not (= diz__7@13@01 $Ref.null))))
; [eval] diz.Main_robot_sensor != null
(declare-const $k@31@01 $Perm)
(assert ($Perm.isReadVar $k@31@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@31@01 $Perm.No) (< $Perm.No $k@31@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               223
;  :arith-add-rows          25
;  :arith-assert-diseq      18
;  :arith-assert-lower      62
;  :arith-assert-upper      33
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               14
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              180
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             510
;  :mk-clause               192
;  :num-allocs              3647888
;  :num-checks              16
;  :propagations            91
;  :quant-instantiations    50
;  :rlimit-count            118529)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               223
;  :arith-add-rows          25
;  :arith-assert-diseq      18
;  :arith-assert-lower      62
;  :arith-assert-upper      33
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               14
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              180
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             510
;  :mk-clause               192
;  :num-allocs              3647888
;  :num-checks              17
;  :propagations            91
;  :quant-instantiations    50
;  :rlimit-count            118542)
(assert (< $k@31@01 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@31@01)))
(assert (<= (- $Perm.Write $k@31@01) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@31@01)) (not (= diz__7@13@01 $Ref.null))))
; [eval] diz.Main_robot_controller != null
(declare-const $k@32@01 $Perm)
(assert ($Perm.isReadVar $k@32@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@32@01 $Perm.No) (< $Perm.No $k@32@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               223
;  :arith-add-rows          25
;  :arith-assert-diseq      19
;  :arith-assert-lower      64
;  :arith-assert-upper      35
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               15
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              180
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             515
;  :mk-clause               194
;  :num-allocs              3647888
;  :num-checks              18
;  :propagations            92
;  :quant-instantiations    50
;  :rlimit-count            118831)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               223
;  :arith-add-rows          25
;  :arith-assert-diseq      19
;  :arith-assert-lower      64
;  :arith-assert-upper      35
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               15
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              180
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             515
;  :mk-clause               194
;  :num-allocs              3647888
;  :num-checks              19
;  :propagations            92
;  :quant-instantiations    50
;  :rlimit-count            118844
;  :time                    0.00)
(assert (< $k@32@01 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@32@01)))
(assert (<= (- $Perm.Write $k@32@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $Perm.Write $k@32@01))
  (not (= sys__result@22@01 $Ref.null))))
; [eval] diz.Main_robot.Robot_m == diz
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($SortWrappers.Seq<Int>To$Snap __flatten_5__9@20@01)
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($SortWrappers.Seq<Int>To$Snap __flatten_7__11@21@01)
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($SortWrappers.$RefTo$Snap sys__result@22@01)
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($SortWrappers.$RefTo$Snap sys__result@24@01)
                      ($Snap.combine
                        $Snap.unit
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@25@01)))))
                          ($Snap.combine
                            ($SortWrappers.$RefTo$Snap sys__result@26@01)
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@01)))))
                                ($Snap.combine
                                  ($Snap.first ($Snap.second ($Snap.second $t@23@01)))
                                  $Snap.unit))))))))))))))))) diz__7@13@01 globals@2@01))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz__7, globals), write)
; [exec]
; sys__result := diz__7
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
; ---------- Sensor_run_EncodedGlobalVariables ----------
(declare-const diz@33@01 $Ref)
(declare-const globals@34@01 $Ref)
(declare-const diz@35@01 $Ref)
(declare-const globals@36@01 $Ref)
(push) ; 1
(declare-const $t@37@01 $Snap)
(assert (= $t@37@01 ($Snap.combine ($Snap.first $t@37@01) ($Snap.second $t@37@01))))
(assert (= ($Snap.first $t@37@01) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@35@01 $Ref.null)))
(assert (=
  ($Snap.second $t@37@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@37@01))
    ($Snap.second ($Snap.second $t@37@01)))))
(declare-const $k@38@01 $Perm)
(assert ($Perm.isReadVar $k@38@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@38@01 $Perm.No) (< $Perm.No $k@38@01))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               234
;  :arith-add-rows          27
;  :arith-assert-diseq      20
;  :arith-assert-lower      66
;  :arith-assert-upper      36
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               16
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              193
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             523
;  :mk-clause               196
;  :num-allocs              3647888
;  :num-checks              20
;  :propagations            93
;  :quant-instantiations    50
;  :rlimit-count            119466)
(assert (<= $Perm.No $k@38@01))
(assert (<= $k@38@01 $Perm.Write))
(assert (implies (< $Perm.No $k@38@01) (not (= diz@35@01 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@37@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@37@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@37@01))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@37@01))) $Snap.unit))
; [eval] diz.Sensor_m != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               240
;  :arith-add-rows          27
;  :arith-assert-diseq      20
;  :arith-assert-lower      66
;  :arith-assert-upper      37
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               17
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              193
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             526
;  :mk-clause               196
;  :num-allocs              3647888
;  :num-checks              21
;  :propagations            93
;  :quant-instantiations    50
;  :rlimit-count            119719)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@37@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@01)))))))
(push) ; 2
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               246
;  :arith-add-rows          27
;  :arith-assert-diseq      20
;  :arith-assert-lower      66
;  :arith-assert-upper      37
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               18
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              193
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             529
;  :mk-clause               196
;  :num-allocs              3647888
;  :num-checks              22
;  :propagations            93
;  :quant-instantiations    51
;  :rlimit-count            120003)
(declare-const $k@39@01 $Perm)
(assert ($Perm.isReadVar $k@39@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@39@01 $Perm.No) (< $Perm.No $k@39@01))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               246
;  :arith-add-rows          27
;  :arith-assert-diseq      21
;  :arith-assert-lower      68
;  :arith-assert-upper      38
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               19
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              193
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             533
;  :mk-clause               198
;  :num-allocs              3647888
;  :num-checks              23
;  :propagations            94
;  :quant-instantiations    51
;  :rlimit-count            120201)
(assert (<= $Perm.No $k@39@01))
(assert (<= $k@39@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@39@01)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@01))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_robot_sensor == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               247
;  :arith-add-rows          27
;  :arith-assert-diseq      21
;  :arith-assert-lower      68
;  :arith-assert-upper      39
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               20
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              193
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             535
;  :mk-clause               198
;  :num-allocs              3647888
;  :num-checks              24
;  :propagations            94
;  :quant-instantiations    51
;  :rlimit-count            120387
;  :time                    0.00)
(push) ; 2
(assert (not (< $Perm.No $k@39@01)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               247
;  :arith-add-rows          27
;  :arith-assert-diseq      21
;  :arith-assert-lower      68
;  :arith-assert-upper      39
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               21
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   21
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              193
;  :final-checks            11
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             535
;  :mk-clause               198
;  :num-allocs              3647888
;  :num-checks              25
;  :propagations            94
;  :quant-instantiations    51
;  :rlimit-count            120435
;  :time                    0.00)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@01)))))
  diz@35@01))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@40@01 $Snap)
(assert (= $t@40@01 ($Snap.combine ($Snap.first $t@40@01) ($Snap.second $t@40@01))))
(declare-const $k@41@01 $Perm)
(assert ($Perm.isReadVar $k@41@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@41@01 $Perm.No) (< $Perm.No $k@41@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               260
;  :arith-add-rows          27
;  :arith-assert-diseq      22
;  :arith-assert-lower      70
;  :arith-assert-upper      40
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               22
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   23
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              197
;  :final-checks            13
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             544
;  :mk-clause               200
;  :num-allocs              3647888
;  :num-checks              27
;  :propagations            95
;  :quant-instantiations    52
;  :rlimit-count            121168)
(assert (<= $Perm.No $k@41@01))
(assert (<= $k@41@01 $Perm.Write))
(assert (implies (< $Perm.No $k@41@01) (not (= diz@35@01 $Ref.null))))
(assert (=
  ($Snap.second $t@40@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@40@01))
    ($Snap.second ($Snap.second $t@40@01)))))
(assert (= ($Snap.first ($Snap.second $t@40@01)) $Snap.unit))
; [eval] diz.Sensor_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@41@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               266
;  :arith-add-rows          27
;  :arith-assert-diseq      22
;  :arith-assert-lower      70
;  :arith-assert-upper      41
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               23
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   23
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              197
;  :final-checks            13
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             547
;  :mk-clause               200
;  :num-allocs              3647888
;  :num-checks              28
;  :propagations            95
;  :quant-instantiations    52
;  :rlimit-count            121411)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@01)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@40@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@40@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@40@01))))))
(push) ; 3
(assert (not (< $Perm.No $k@41@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               272
;  :arith-add-rows          27
;  :arith-assert-diseq      22
;  :arith-assert-lower      70
;  :arith-assert-upper      41
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               24
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   23
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              197
;  :final-checks            13
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             550
;  :mk-clause               200
;  :num-allocs              3647888
;  :num-checks              29
;  :propagations            95
;  :quant-instantiations    53
;  :rlimit-count            121683
;  :time                    0.00)
(declare-const $k@42@01 $Perm)
(assert ($Perm.isReadVar $k@42@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@42@01 $Perm.No) (< $Perm.No $k@42@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               272
;  :arith-add-rows          27
;  :arith-assert-diseq      23
;  :arith-assert-lower      72
;  :arith-assert-upper      42
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               25
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   23
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              197
;  :final-checks            13
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             554
;  :mk-clause               202
;  :num-allocs              3647888
;  :num-checks              30
;  :propagations            96
;  :quant-instantiations    53
;  :rlimit-count            121881)
(assert (<= $Perm.No $k@42@01))
(assert (<= $k@42@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@42@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@01)) $Ref.null))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@40@01))) $Snap.unit))
; [eval] diz.Sensor_m.Main_robot_sensor == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@41@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               273
;  :arith-add-rows          27
;  :arith-assert-diseq      23
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               26
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   23
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              197
;  :final-checks            13
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             556
;  :mk-clause               202
;  :num-allocs              3647888
;  :num-checks              31
;  :propagations            96
;  :quant-instantiations    53
;  :rlimit-count            122057)
(push) ; 3
(assert (not (< $Perm.No $k@42@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               273
;  :arith-add-rows          27
;  :arith-assert-diseq      23
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               27
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   23
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              197
;  :final-checks            13
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             556
;  :mk-clause               202
;  :num-allocs              3647888
;  :num-checks              32
;  :propagations            96
;  :quant-instantiations    53
;  :rlimit-count            122105)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@40@01))))
  diz@35@01))
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_25__20: Ref
(declare-const __flatten_25__20@43@01 $Ref)
; [exec]
; var __flatten_26__21: Seq[Int]
(declare-const __flatten_26__21@44@01 Seq<Int>)
; [exec]
; var __flatten_27__22: Ref
(declare-const __flatten_27__22@45@01 $Ref)
; [exec]
; var __flatten_28__23: Ref
(declare-const __flatten_28__23@46@01 $Ref)
; [exec]
; var __flatten_29__24: Seq[Int]
(declare-const __flatten_29__24@47@01 Seq<Int>)
; [exec]
; var __flatten_30__25: Ref
(declare-const __flatten_30__25@48@01 $Ref)
; [exec]
; var __flatten_31__26: Int
(declare-const __flatten_31__26@49@01 Int)
; [exec]
; var __flatten_32__27: Int
(declare-const __flatten_32__27@50@01 Int)
; [exec]
; var __flatten_33__28: Ref
(declare-const __flatten_33__28@51@01 $Ref)
; [exec]
; var __flatten_34__29: Seq[Int]
(declare-const __flatten_34__29@52@01 Seq<Int>)
; [exec]
; var __flatten_35__30: Ref
(declare-const __flatten_35__30@53@01 $Ref)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(push) ; 3
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               273
;  :arith-add-rows          27
;  :arith-assert-diseq      23
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               28
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   23
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              201
;  :final-checks            13
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             556
;  :mk-clause               202
;  :num-allocs              3647888
;  :num-checks              33
;  :propagations            96
;  :quant-instantiations    53
;  :rlimit-count            122169)
(declare-const $t@54@01 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               279
;  :arith-add-rows          27
;  :arith-assert-diseq      23
;  :arith-assert-lower      72
;  :arith-assert-upper      43
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               29
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              201
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             556
;  :mk-clause               202
;  :num-allocs              3647888
;  :num-checks              35
;  :propagations            96
;  :quant-instantiations    53
;  :rlimit-count            122513)
(assert (= $t@54@01 ($Snap.combine ($Snap.first $t@54@01) ($Snap.second $t@54@01))))
(assert (= ($Snap.first $t@54@01) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@54@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@54@01))
    ($Snap.second ($Snap.second $t@54@01)))))
(assert (= ($Snap.first ($Snap.second $t@54@01)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@54@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@54@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@54@01))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@54@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@55@01 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@55@01 | live]
; [else-branch: 4 | !(0 <= i@55@01) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@55@01]
(assert (<= 0 i@55@01))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@55@01)]
(assert (not (<= 0 i@55@01)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@55@01 < |First:(Second:(Second:(Second:($t@54@01))))| && 0 <= i@55@01 | live]
; [else-branch: 5 | !(i@55@01 < |First:(Second:(Second:(Second:($t@54@01))))| && 0 <= i@55@01) | live]
(push) ; 5
; [then-branch: 5 | i@55@01 < |First:(Second:(Second:(Second:($t@54@01))))| && 0 <= i@55@01]
(assert (and
  (<
    i@55@01
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))
  (<= 0 i@55@01)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@55@01 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-add-rows          27
;  :arith-assert-diseq      25
;  :arith-assert-lower      79
;  :arith-assert-upper      46
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               29
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              201
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             588
;  :mk-clause               208
;  :num-allocs              3647888
;  :num-checks              36
;  :propagations            98
;  :quant-instantiations    59
;  :rlimit-count            123861)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:($t@54@01))))[i@55@01] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@54@01))))[i@55@01] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@54@01))))[i@55@01] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
    i@55@01)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:($t@54@01))))[i@55@01] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
      i@55@01)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@55@01 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-add-rows          27
;  :arith-assert-diseq      25
;  :arith-assert-lower      79
;  :arith-assert-upper      46
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               29
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              201
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             589
;  :mk-clause               208
;  :num-allocs              3647888
;  :num-checks              37
;  :propagations            98
;  :quant-instantiations    59
;  :rlimit-count            124036)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@54@01))))[i@55@01] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@54@01))))[i@55@01]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@54@01))))[i@55@01]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
    i@55@01)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@55@01 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-add-rows          27
;  :arith-assert-diseq      26
;  :arith-assert-lower      82
;  :arith-assert-upper      46
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               29
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              201
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             592
;  :mk-clause               209
;  :num-allocs              3647888
;  :num-checks              38
;  :propagations            98
;  :quant-instantiations    59
;  :rlimit-count            124160)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@54@01))))[i@55@01])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
      i@55@01))))
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
; [else-branch: 5 | !(i@55@01 < |First:(Second:(Second:(Second:($t@54@01))))| && 0 <= i@55@01)]
(assert (not
  (and
    (<
      i@55@01
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))
    (<= 0 i@55@01))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@55@01 Int)) (!
  (implies
    (and
      (<
        i@55@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))
      (<= 0 i@55@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
          i@55@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
            i@55@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
            i@55@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
    i@55@01))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))
(declare-const $k@56@01 $Perm)
(assert ($Perm.isReadVar $k@56@01 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@56@01 $Perm.No) (< $Perm.No $k@56@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               334
;  :arith-add-rows          27
;  :arith-assert-diseq      27
;  :arith-assert-lower      84
;  :arith-assert-upper      47
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               30
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             598
;  :mk-clause               211
;  :num-allocs              3647888
;  :num-checks              39
;  :propagations            99
;  :quant-instantiations    59
;  :rlimit-count            124928)
(assert (<= $Perm.No $k@56@01))
(assert (<= $k@56@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@56@01)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))
  $Snap.unit))
; [eval] diz.Main_robot != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@56@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               340
;  :arith-add-rows          27
;  :arith-assert-diseq      27
;  :arith-assert-lower      84
;  :arith-assert-upper      48
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               31
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             601
;  :mk-clause               211
;  :num-allocs              3647888
;  :num-checks              40
;  :propagations            99
;  :quant-instantiations    59
;  :rlimit-count            125251)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))))
(declare-const $k@57@01 $Perm)
(assert ($Perm.isReadVar $k@57@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@57@01 $Perm.No) (< $Perm.No $k@57@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               346
;  :arith-add-rows          27
;  :arith-assert-diseq      28
;  :arith-assert-lower      86
;  :arith-assert-upper      49
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        5
;  :arith-pivots            15
;  :binary-propagations     16
;  :conflicts               32
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             608
;  :mk-clause               213
;  :num-allocs              3647888
;  :num-checks              41
;  :propagations            100
;  :quant-instantiations    60
;  :rlimit-count            125751)
(declare-const $t@58@01 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@39@01)
    (=
      $t@58@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@01)))))))
  (implies
    (< $Perm.No $k@57@01)
    (=
      $t@58@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))))))
(assert (<= $Perm.No (+ $k@39@01 $k@57@01)))
(assert (<= (+ $k@39@01 $k@57@01) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@39@01 $k@57@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot_sensor != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@39@01 $k@57@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-add-rows          27
;  :arith-assert-diseq      28
;  :arith-assert-lower      87
;  :arith-assert-upper      51
;  :arith-bound-prop        5
;  :arith-conflicts         2
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               33
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             616
;  :mk-clause               213
;  :num-allocs              3647888
;  :num-checks              42
;  :propagations            100
;  :quant-instantiations    61
;  :rlimit-count            126346
;  :time                    0.00)
(assert (not (= $t@58@01 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@39@01 $k@57@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               362
;  :arith-add-rows          27
;  :arith-assert-diseq      28
;  :arith-assert-lower      87
;  :arith-assert-upper      52
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               34
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             619
;  :mk-clause               213
;  :num-allocs              3647888
;  :num-checks              43
;  :propagations            100
;  :quant-instantiations    61
;  :rlimit-count            126672)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))))))
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
; (:added-eqs               367
;  :arith-add-rows          27
;  :arith-assert-diseq      29
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               35
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             624
;  :mk-clause               215
;  :num-allocs              3647888
;  :num-checks              44
;  :propagations            101
;  :quant-instantiations    61
;  :rlimit-count            127093)
(assert (<= $Perm.No $k@59@01))
(assert (<= $k@59@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@59@01)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot_controller != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@59@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               373
;  :arith-add-rows          27
;  :arith-assert-diseq      29
;  :arith-assert-lower      89
;  :arith-assert-upper      54
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               36
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             627
;  :mk-clause               215
;  :num-allocs              3647888
;  :num-checks              45
;  :propagations            101
;  :quant-instantiations    61
;  :rlimit-count            127466)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@59@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               379
;  :arith-add-rows          27
;  :arith-assert-diseq      29
;  :arith-assert-lower      89
;  :arith-assert-upper      54
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               37
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             630
;  :mk-clause               215
;  :num-allocs              3647888
;  :num-checks              46
;  :propagations            101
;  :quant-instantiations    62
;  :rlimit-count            127872)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@56@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               384
;  :arith-add-rows          27
;  :arith-assert-diseq      29
;  :arith-assert-lower      89
;  :arith-assert-upper      54
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               38
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             631
;  :mk-clause               215
;  :num-allocs              3647888
;  :num-checks              47
;  :propagations            101
;  :quant-instantiations    62
;  :rlimit-count            128179)
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
; (:added-eqs               384
;  :arith-add-rows          27
;  :arith-assert-diseq      30
;  :arith-assert-lower      91
;  :arith-assert-upper      55
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               39
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             635
;  :mk-clause               217
;  :num-allocs              3647888
;  :num-checks              48
;  :propagations            102
;  :quant-instantiations    62
;  :rlimit-count            128377)
(assert (<= $Perm.No $k@60@01))
(assert (<= $k@60@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@60@01)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot.Robot_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@56@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               385
;  :arith-add-rows          27
;  :arith-assert-diseq      30
;  :arith-assert-lower      91
;  :arith-assert-upper      56
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               40
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             637
;  :mk-clause               217
;  :num-allocs              3647888
;  :num-checks              49
;  :propagations            102
;  :quant-instantiations    62
;  :rlimit-count            128693)
(push) ; 3
(assert (not (< $Perm.No $k@60@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               385
;  :arith-add-rows          27
;  :arith-assert-diseq      30
;  :arith-assert-lower      91
;  :arith-assert-upper      56
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               41
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               29
;  :del-clause              202
;  :final-checks            14
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             637
;  :mk-clause               217
;  :num-allocs              3647888
;  :num-checks              50
;  :propagations            102
;  :quant-instantiations    62
;  :rlimit-count            128741)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01)))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@54@01 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01))) globals@36@01))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               426
;  :arith-add-rows          27
;  :arith-assert-diseq      30
;  :arith-assert-lower      91
;  :arith-assert-upper      56
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               43
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   32
;  :datatype-splits         24
;  :decisions               39
;  :del-clause              216
;  :final-checks            17
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             651
;  :mk-clause               218
;  :num-allocs              3647888
;  :num-checks              52
;  :propagations            102
;  :quant-instantiations    63
;  :rlimit-count            129651)
(declare-const $t@61@01 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz.Sensor_dist := 256
(set-option :timeout 10)
(push) ; 3
(assert (not (= $t@58@01 diz@35@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               460
;  :arith-add-rows          27
;  :arith-assert-diseq      30
;  :arith-assert-lower      91
;  :arith-assert-upper      56
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               44
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             658
;  :mk-clause               218
;  :num-allocs              3647888
;  :num-checks              54
;  :propagations            103
;  :quant-instantiations    63
;  :rlimit-count            130187)
(declare-const __flatten_25__20@62@01 $Ref)
(declare-const __flatten_27__22@63@01 $Ref)
(declare-const __flatten_26__21@64@01 Seq<Int>)
(declare-const __flatten_28__23@65@01 $Ref)
(declare-const __flatten_30__25@66@01 $Ref)
(declare-const __flatten_29__24@67@01 Seq<Int>)
(declare-const __flatten_32__27@68@01 Int)
(declare-const __flatten_31__26@69@01 Int)
(declare-const __flatten_33__28@70@01 $Ref)
(declare-const __flatten_35__30@71@01 $Ref)
(declare-const __flatten_34__29@72@01 Seq<Int>)
(push) ; 3
; Loop head block: Check well-definedness of invariant
(declare-const $t@73@01 $Snap)
(assert (= $t@73@01 ($Snap.combine ($Snap.first $t@73@01) ($Snap.second $t@73@01))))
(declare-const $k@74@01 $Perm)
(assert ($Perm.isReadVar $k@74@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@74@01 $Perm.No) (< $Perm.No $k@74@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               465
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      57
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               45
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             663
;  :mk-clause               220
;  :num-allocs              3647888
;  :num-checks              55
;  :propagations            104
;  :quant-instantiations    63
;  :rlimit-count            130478)
(assert (<= $Perm.No $k@74@01))
(assert (<= $k@74@01 $Perm.Write))
(assert (implies (< $Perm.No $k@74@01) (not (= diz@35@01 $Ref.null))))
(assert (=
  ($Snap.second $t@73@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@73@01))
    ($Snap.second ($Snap.second $t@73@01)))))
(assert (= ($Snap.first ($Snap.second $t@73@01)) $Snap.unit))
; [eval] diz.Sensor_m != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               471
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      58
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               46
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             666
;  :mk-clause               220
;  :num-allocs              3647888
;  :num-checks              56
;  :propagations            104
;  :quant-instantiations    63
;  :rlimit-count            130721)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@73@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@73@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      58
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               47
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             669
;  :mk-clause               220
;  :num-allocs              3647888
;  :num-checks              57
;  :propagations            104
;  :quant-instantiations    64
;  :rlimit-count            130993)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@73@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               482
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      58
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               48
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             670
;  :mk-clause               220
;  :num-allocs              3647888
;  :num-checks              58
;  :propagations            104
;  :quant-instantiations    64
;  :rlimit-count            131170)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
  $Snap.unit))
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               488
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      58
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               49
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             672
;  :mk-clause               220
;  :num-allocs              3647888
;  :num-checks              59
;  :propagations            104
;  :quant-instantiations    64
;  :rlimit-count            131389)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               495
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      95
;  :arith-assert-upper      59
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               50
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             678
;  :mk-clause               220
;  :num-allocs              3647888
;  :num-checks              60
;  :propagations            104
;  :quant-instantiations    66
;  :rlimit-count            131719)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
  $Snap.unit))
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               501
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      95
;  :arith-assert-upper      59
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               51
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             680
;  :mk-clause               220
;  :num-allocs              3647888
;  :num-checks              61
;  :propagations            104
;  :quant-instantiations    66
;  :rlimit-count            131958)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))
  $Snap.unit))
; [eval] (forall i__31: Int :: { diz.Sensor_m.Main_process_state[i__31] } 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|)
(declare-const i__31@75@01 Int)
(push) ; 4
; [eval] 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__31
(push) ; 5
; [then-branch: 8 | 0 <= i__31@75@01 | live]
; [else-branch: 8 | !(0 <= i__31@75@01) | live]
(push) ; 6
; [then-branch: 8 | 0 <= i__31@75@01]
(assert (<= 0 i__31@75@01))
; [eval] i__31 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               509
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      98
;  :arith-assert-upper      60
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               52
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             688
;  :mk-clause               220
;  :num-allocs              3647888
;  :num-checks              62
;  :propagations            104
;  :quant-instantiations    68
;  :rlimit-count            132397)
(pop) ; 6
(push) ; 6
; [else-branch: 8 | !(0 <= i__31@75@01)]
(assert (not (<= 0 i__31@75@01)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 9 | i__31@75@01 < |First:(Second:(Second:(Second:($t@73@01))))| && 0 <= i__31@75@01 | live]
; [else-branch: 9 | !(i__31@75@01 < |First:(Second:(Second:(Second:($t@73@01))))| && 0 <= i__31@75@01) | live]
(push) ; 6
; [then-branch: 9 | i__31@75@01 < |First:(Second:(Second:(Second:($t@73@01))))| && 0 <= i__31@75@01]
(assert (and
  (<
    i__31@75@01
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
  (<= 0 i__31@75@01)))
; [eval] diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__31] == -1
; [eval] diz.Sensor_m.Main_process_state[i__31]
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               509
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      99
;  :arith-assert-upper      61
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               53
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             690
;  :mk-clause               220
;  :num-allocs              3647888
;  :num-checks              63
;  :propagations            104
;  :quant-instantiations    68
;  :rlimit-count            132554)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i__31@75@01 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               509
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      99
;  :arith-assert-upper      61
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               53
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.01
;  :memory                  4.01
;  :minimized-lits          1
;  :mk-bool-var             690
;  :mk-clause               220
;  :num-allocs              3647888
;  :num-checks              64
;  :propagations            104
;  :quant-instantiations    68
;  :rlimit-count            132563)
; [eval] -1
(push) ; 7
; [then-branch: 10 | First:(Second:(Second:(Second:($t@73@01))))[i__31@75@01] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:(Second:($t@73@01))))[i__31@75@01] != -1 | live]
(push) ; 8
; [then-branch: 10 | First:(Second:(Second:(Second:($t@73@01))))[i__31@75@01] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
    i__31@75@01)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 10 | First:(Second:(Second:(Second:($t@73@01))))[i__31@75@01] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
      i__31@75@01)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__31]
; [eval] diz.Sensor_m.Main_process_state[i__31]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               509
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      99
;  :arith-assert-upper      61
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               54
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             691
;  :mk-clause               220
;  :num-allocs              3781722
;  :num-checks              65
;  :propagations            104
;  :quant-instantiations    68
;  :rlimit-count            132777)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i__31@75@01 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               509
;  :arith-add-rows          27
;  :arith-assert-diseq      31
;  :arith-assert-lower      99
;  :arith-assert-upper      61
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               54
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             691
;  :mk-clause               220
;  :num-allocs              3781722
;  :num-checks              66
;  :propagations            104
;  :quant-instantiations    68
;  :rlimit-count            132786)
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@73@01))))[i__31@75@01] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@73@01))))[i__31@75@01]) | live]
(push) ; 10
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@73@01))))[i__31@75@01]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
    i__31@75@01)))
; [eval] diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__31]
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               509
;  :arith-add-rows          27
;  :arith-assert-diseq      32
;  :arith-assert-lower      102
;  :arith-assert-upper      61
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               55
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             694
;  :mk-clause               221
;  :num-allocs              3781722
;  :num-checks              67
;  :propagations            104
;  :quant-instantiations    68
;  :rlimit-count            132949)
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i__31@75@01 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               509
;  :arith-add-rows          27
;  :arith-assert-diseq      32
;  :arith-assert-lower      102
;  :arith-assert-upper      61
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               55
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             694
;  :mk-clause               221
;  :num-allocs              3781722
;  :num-checks              68
;  :propagations            104
;  :quant-instantiations    68
;  :rlimit-count            132958)
; [eval] |diz.Sensor_m.Main_event_state|
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               509
;  :arith-add-rows          27
;  :arith-assert-diseq      32
;  :arith-assert-lower      102
;  :arith-assert-upper      61
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               56
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              216
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             694
;  :mk-clause               221
;  :num-allocs              3781722
;  :num-checks              69
;  :propagations            104
;  :quant-instantiations    68
;  :rlimit-count            133006)
(pop) ; 10
(push) ; 10
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@73@01))))[i__31@75@01])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
      i__31@75@01))))
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
; [else-branch: 9 | !(i__31@75@01 < |First:(Second:(Second:(Second:($t@73@01))))| && 0 <= i__31@75@01)]
(assert (not
  (and
    (<
      i__31@75@01
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
    (<= 0 i__31@75@01))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__31@75@01 Int)) (!
  (implies
    (and
      (<
        i__31@75@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
      (<= 0 i__31@75@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
          i__31@75@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
            i__31@75@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
            i__31@75@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
    i__31@75@01))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               514
;  :arith-add-rows          27
;  :arith-assert-diseq      32
;  :arith-assert-lower      102
;  :arith-assert-upper      61
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               57
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             696
;  :mk-clause               221
;  :num-allocs              3781722
;  :num-checks              70
;  :propagations            104
;  :quant-instantiations    68
;  :rlimit-count            133631)
(declare-const $k@76@01 $Perm)
(assert ($Perm.isReadVar $k@76@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@76@01 $Perm.No) (< $Perm.No $k@76@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               514
;  :arith-add-rows          27
;  :arith-assert-diseq      33
;  :arith-assert-lower      104
;  :arith-assert-upper      62
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               58
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             700
;  :mk-clause               223
;  :num-allocs              3781722
;  :num-checks              71
;  :propagations            105
;  :quant-instantiations    68
;  :rlimit-count            133829)
(assert (<= $Perm.No $k@76@01))
(assert (<= $k@76@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@76@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_robot != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               520
;  :arith-add-rows          27
;  :arith-assert-diseq      33
;  :arith-assert-lower      104
;  :arith-assert-upper      63
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               59
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             703
;  :mk-clause               223
;  :num-allocs              3781722
;  :num-checks              72
;  :propagations            105
;  :quant-instantiations    68
;  :rlimit-count            134152)
(push) ; 4
(assert (not (< $Perm.No $k@76@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               520
;  :arith-add-rows          27
;  :arith-assert-diseq      33
;  :arith-assert-lower      104
;  :arith-assert-upper      63
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               60
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             703
;  :mk-clause               223
;  :num-allocs              3781722
;  :num-checks              73
;  :propagations            105
;  :quant-instantiations    68
;  :rlimit-count            134200)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               526
;  :arith-add-rows          27
;  :arith-assert-diseq      33
;  :arith-assert-lower      104
;  :arith-assert-upper      63
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               61
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             706
;  :mk-clause               223
;  :num-allocs              3781722
;  :num-checks              74
;  :propagations            105
;  :quant-instantiations    69
;  :rlimit-count            134556)
(declare-const $k@77@01 $Perm)
(assert ($Perm.isReadVar $k@77@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@77@01 $Perm.No) (< $Perm.No $k@77@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               526
;  :arith-add-rows          27
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      64
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               62
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             710
;  :mk-clause               225
;  :num-allocs              3781722
;  :num-checks              75
;  :propagations            106
;  :quant-instantiations    69
;  :rlimit-count            134755)
(assert (<= $Perm.No $k@77@01))
(assert (<= $k@77@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@77@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_robot_sensor != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               532
;  :arith-add-rows          27
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      65
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               63
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             713
;  :mk-clause               225
;  :num-allocs              3781722
;  :num-checks              76
;  :propagations            106
;  :quant-instantiations    69
;  :rlimit-count            135098)
(push) ; 4
(assert (not (< $Perm.No $k@77@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               532
;  :arith-add-rows          27
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      65
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               64
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             713
;  :mk-clause               225
;  :num-allocs              3781722
;  :num-checks              77
;  :propagations            106
;  :quant-instantiations    69
;  :rlimit-count            135146)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               538
;  :arith-add-rows          27
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      65
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               65
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             716
;  :mk-clause               225
;  :num-allocs              3781722
;  :num-checks              78
;  :propagations            106
;  :quant-instantiations    70
;  :rlimit-count            135520)
(push) ; 4
(assert (not (< $Perm.No $k@77@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               538
;  :arith-add-rows          27
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      65
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               66
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             716
;  :mk-clause               225
;  :num-allocs              3781722
;  :num-checks              79
;  :propagations            106
;  :quant-instantiations    70
;  :rlimit-count            135568)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               543
;  :arith-add-rows          27
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      65
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               67
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             717
;  :mk-clause               225
;  :num-allocs              3781722
;  :num-checks              80
;  :propagations            106
;  :quant-instantiations    70
;  :rlimit-count            135845)
(declare-const $k@78@01 $Perm)
(assert ($Perm.isReadVar $k@78@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@78@01 $Perm.No) (< $Perm.No $k@78@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               543
;  :arith-add-rows          27
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      66
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               68
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             721
;  :mk-clause               227
;  :num-allocs              3781722
;  :num-checks              81
;  :propagations            107
;  :quant-instantiations    70
;  :rlimit-count            136044)
(assert (<= $Perm.No $k@78@01))
(assert (<= $k@78@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@78@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_robot_controller != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               549
;  :arith-add-rows          27
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      67
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               69
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             724
;  :mk-clause               227
;  :num-allocs              3781722
;  :num-checks              82
;  :propagations            107
;  :quant-instantiations    70
;  :rlimit-count            136417)
(push) ; 4
(assert (not (< $Perm.No $k@78@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               549
;  :arith-add-rows          27
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      67
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               70
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             724
;  :mk-clause               227
;  :num-allocs              3781722
;  :num-checks              83
;  :propagations            107
;  :quant-instantiations    70
;  :rlimit-count            136465)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               555
;  :arith-add-rows          27
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      67
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               71
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             727
;  :mk-clause               227
;  :num-allocs              3781722
;  :num-checks              84
;  :propagations            107
;  :quant-instantiations    71
;  :rlimit-count            136871)
(push) ; 4
(assert (not (< $Perm.No $k@78@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               555
;  :arith-add-rows          27
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      67
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               72
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             727
;  :mk-clause               227
;  :num-allocs              3781722
;  :num-checks              85
;  :propagations            107
;  :quant-instantiations    71
;  :rlimit-count            136919)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               560
;  :arith-add-rows          27
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      67
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               73
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             728
;  :mk-clause               227
;  :num-allocs              3781722
;  :num-checks              86
;  :propagations            107
;  :quant-instantiations    71
;  :rlimit-count            137226)
(push) ; 4
(assert (not (< $Perm.No $k@76@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               560
;  :arith-add-rows          27
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      67
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               74
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             728
;  :mk-clause               227
;  :num-allocs              3781722
;  :num-checks              87
;  :propagations            107
;  :quant-instantiations    71
;  :rlimit-count            137274)
(declare-const $k@79@01 $Perm)
(assert ($Perm.isReadVar $k@79@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@79@01 $Perm.No) (< $Perm.No $k@79@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               560
;  :arith-add-rows          27
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      68
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               75
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             732
;  :mk-clause               229
;  :num-allocs              3781722
;  :num-checks              88
;  :propagations            108
;  :quant-instantiations    71
;  :rlimit-count            137472)
(assert (<= $Perm.No $k@79@01))
(assert (<= $k@79@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@79@01)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_robot.Robot_m == diz.Sensor_m
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-add-rows          27
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      69
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             735
;  :mk-clause               229
;  :num-allocs              3781722
;  :num-checks              89
;  :propagations            108
;  :quant-instantiations    71
;  :rlimit-count            137875)
(push) ; 4
(assert (not (< $Perm.No $k@76@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-add-rows          27
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      69
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             735
;  :mk-clause               229
;  :num-allocs              3781722
;  :num-checks              90
;  :propagations            108
;  :quant-instantiations    71
;  :rlimit-count            137923)
(push) ; 4
(assert (not (< $Perm.No $k@79@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-add-rows          27
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      69
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               78
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             735
;  :mk-clause               229
;  :num-allocs              3781722
;  :num-checks              91
;  :propagations            108
;  :quant-instantiations    71
;  :rlimit-count            137971)
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-add-rows          27
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      69
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             735
;  :mk-clause               229
;  :num-allocs              3781722
;  :num-checks              92
;  :propagations            108
;  :quant-instantiations    71
;  :rlimit-count            138019)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_robot_sensor == diz
(push) ; 4
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               570
;  :arith-add-rows          27
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      69
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               80
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             738
;  :mk-clause               229
;  :num-allocs              3781722
;  :num-checks              93
;  :propagations            108
;  :quant-instantiations    72
;  :rlimit-count            138402)
(push) ; 4
(assert (not (< $Perm.No $k@77@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               570
;  :arith-add-rows          27
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      69
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               81
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              217
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             738
;  :mk-clause               229
;  :num-allocs              3781722
;  :num-checks              94
;  :propagations            108
;  :quant-instantiations    72
;  :rlimit-count            138450)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
  diz@35@01))
; Loop head block: Check well-definedness of edge conditions
(push) ; 4
(pop) ; 4
(push) ; 4
; [eval] !true
(pop) ; 4
(pop) ; 3
(push) ; 3
; Loop head block: Establish invariant
(declare-const $k@80@01 $Perm)
(assert ($Perm.isReadVar $k@80@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@80@01 $Perm.No) (< $Perm.No $k@80@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      37
;  :arith-assert-lower      112
;  :arith-assert-upper      70
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               82
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             743
;  :mk-clause               231
;  :num-allocs              3781722
;  :num-checks              95
;  :propagations            109
;  :quant-instantiations    72
;  :rlimit-count            138826)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@38@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      37
;  :arith-assert-lower      112
;  :arith-assert-upper      70
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               82
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             743
;  :mk-clause               231
;  :num-allocs              3781722
;  :num-checks              96
;  :propagations            109
;  :quant-instantiations    72
;  :rlimit-count            138837)
(assert (< $k@80@01 $k@38@01))
(assert (<= $Perm.No (- $k@38@01 $k@80@01)))
(assert (<= (- $k@38@01 $k@80@01) $Perm.Write))
(assert (implies (< $Perm.No (- $k@38@01 $k@80@01)) (not (= diz@35@01 $Ref.null))))
; [eval] diz.Sensor_m != null
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      37
;  :arith-assert-lower      114
;  :arith-assert-upper      71
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               83
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             746
;  :mk-clause               231
;  :num-allocs              3781722
;  :num-checks              97
;  :propagations            109
;  :quant-instantiations    72
;  :rlimit-count            139051)
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      37
;  :arith-assert-lower      114
;  :arith-assert-upper      71
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               84
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             746
;  :mk-clause               231
;  :num-allocs              3781722
;  :num-checks              98
;  :propagations            109
;  :quant-instantiations    72
;  :rlimit-count            139099)
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      37
;  :arith-assert-lower      114
;  :arith-assert-upper      71
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             746
;  :mk-clause               231
;  :num-allocs              3781722
;  :num-checks              99
;  :propagations            109
;  :quant-instantiations    72
;  :rlimit-count            139147)
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      37
;  :arith-assert-lower      114
;  :arith-assert-upper      71
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               86
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             746
;  :mk-clause               231
;  :num-allocs              3781722
;  :num-checks              100
;  :propagations            109
;  :quant-instantiations    72
;  :rlimit-count            139195)
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      37
;  :arith-assert-lower      114
;  :arith-assert-upper      71
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             746
;  :mk-clause               231
;  :num-allocs              3781722
;  :num-checks              101
;  :propagations            109
;  :quant-instantiations    72
;  :rlimit-count            139243)
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      37
;  :arith-assert-lower      114
;  :arith-assert-upper      71
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             746
;  :mk-clause               231
;  :num-allocs              3781722
;  :num-checks              102
;  :propagations            109
;  :quant-instantiations    72
;  :rlimit-count            139291)
; [eval] (forall i__31: Int :: { diz.Sensor_m.Main_process_state[i__31] } 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|)
(declare-const i__31@81@01 Int)
(push) ; 4
; [eval] 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__31
(push) ; 5
; [then-branch: 12 | 0 <= i__31@81@01 | live]
; [else-branch: 12 | !(0 <= i__31@81@01) | live]
(push) ; 6
; [then-branch: 12 | 0 <= i__31@81@01]
(assert (<= 0 i__31@81@01))
; [eval] i__31 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      37
;  :arith-assert-lower      115
;  :arith-assert-upper      71
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               89
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             747
;  :mk-clause               231
;  :num-allocs              3781722
;  :num-checks              103
;  :propagations            109
;  :quant-instantiations    72
;  :rlimit-count            139392)
(pop) ; 6
(push) ; 6
; [else-branch: 12 | !(0 <= i__31@81@01)]
(assert (not (<= 0 i__31@81@01)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 13 | i__31@81@01 < |First:(Second:(Second:(Second:($t@54@01))))| && 0 <= i__31@81@01 | live]
; [else-branch: 13 | !(i__31@81@01 < |First:(Second:(Second:(Second:($t@54@01))))| && 0 <= i__31@81@01) | live]
(push) ; 6
; [then-branch: 13 | i__31@81@01 < |First:(Second:(Second:(Second:($t@54@01))))| && 0 <= i__31@81@01]
(assert (and
  (<
    i__31@81@01
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))
  (<= 0 i__31@81@01)))
; [eval] diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__31] == -1
; [eval] diz.Sensor_m.Main_process_state[i__31]
(push) ; 7
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      37
;  :arith-assert-lower      116
;  :arith-assert-upper      72
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             749
;  :mk-clause               231
;  :num-allocs              3781722
;  :num-checks              104
;  :propagations            109
;  :quant-instantiations    72
;  :rlimit-count            139549)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i__31@81@01 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      37
;  :arith-assert-lower      116
;  :arith-assert-upper      72
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             749
;  :mk-clause               231
;  :num-allocs              3781722
;  :num-checks              105
;  :propagations            109
;  :quant-instantiations    72
;  :rlimit-count            139558)
; [eval] -1
(push) ; 7
; [then-branch: 14 | First:(Second:(Second:(Second:($t@54@01))))[i__31@81@01] == -1 | live]
; [else-branch: 14 | First:(Second:(Second:(Second:($t@54@01))))[i__31@81@01] != -1 | live]
(push) ; 8
; [then-branch: 14 | First:(Second:(Second:(Second:($t@54@01))))[i__31@81@01] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
    i__31@81@01)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 14 | First:(Second:(Second:(Second:($t@54@01))))[i__31@81@01] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
      i__31@81@01)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__31]
; [eval] diz.Sensor_m.Main_process_state[i__31]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      38
;  :arith-assert-lower      119
;  :arith-assert-upper      73
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               91
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             755
;  :mk-clause               235
;  :num-allocs              3781722
;  :num-checks              106
;  :propagations            111
;  :quant-instantiations    73
;  :rlimit-count            139829)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i__31@81@01 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      38
;  :arith-assert-lower      119
;  :arith-assert-upper      73
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               91
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             755
;  :mk-clause               235
;  :num-allocs              3781722
;  :num-checks              107
;  :propagations            111
;  :quant-instantiations    73
;  :rlimit-count            139838)
(push) ; 9
; [then-branch: 15 | 0 <= First:(Second:(Second:(Second:($t@54@01))))[i__31@81@01] | live]
; [else-branch: 15 | !(0 <= First:(Second:(Second:(Second:($t@54@01))))[i__31@81@01]) | live]
(push) ; 10
; [then-branch: 15 | 0 <= First:(Second:(Second:(Second:($t@54@01))))[i__31@81@01]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
    i__31@81@01)))
; [eval] diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__31]
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      38
;  :arith-assert-lower      119
;  :arith-assert-upper      73
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               92
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             755
;  :mk-clause               235
;  :num-allocs              3781722
;  :num-checks              108
;  :propagations            111
;  :quant-instantiations    73
;  :rlimit-count            139991)
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i__31@81@01 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      38
;  :arith-assert-lower      119
;  :arith-assert-upper      73
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               92
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             755
;  :mk-clause               235
;  :num-allocs              3781722
;  :num-checks              109
;  :propagations            111
;  :quant-instantiations    73
;  :rlimit-count            140000)
; [eval] |diz.Sensor_m.Main_event_state|
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      38
;  :arith-assert-lower      119
;  :arith-assert-upper      73
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               93
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              227
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             755
;  :mk-clause               235
;  :num-allocs              3781722
;  :num-checks              110
;  :propagations            111
;  :quant-instantiations    73
;  :rlimit-count            140048)
(pop) ; 10
(push) ; 10
; [else-branch: 15 | !(0 <= First:(Second:(Second:(Second:($t@54@01))))[i__31@81@01])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
      i__31@81@01))))
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
; [else-branch: 13 | !(i__31@81@01 < |First:(Second:(Second:(Second:($t@54@01))))| && 0 <= i__31@81@01)]
(assert (not
  (and
    (<
      i__31@81@01
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))
    (<= 0 i__31@81@01))))
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
(assert (not (forall ((i__31@81@01 Int)) (!
  (implies
    (and
      (<
        i__31@81@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))
      (<= 0 i__31@81@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
          i__31@81@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
            i__31@81@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
            i__31@81@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
    i__31@81@01))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      40
;  :arith-assert-lower      120
;  :arith-assert-upper      74
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               94
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              245
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             763
;  :mk-clause               249
;  :num-allocs              3781722
;  :num-checks              111
;  :propagations            113
;  :quant-instantiations    74
;  :rlimit-count            140494)
(assert (forall ((i__31@81@01 Int)) (!
  (implies
    (and
      (<
        i__31@81@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))
      (<= 0 i__31@81@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
          i__31@81@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
            i__31@81@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
            i__31@81@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))
    i__31@81@01))
  :qid |prog.l<no position>|)))
(declare-const $k@82@01 $Perm)
(assert ($Perm.isReadVar $k@82@01 $Perm.Write))
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      41
;  :arith-assert-lower      122
;  :arith-assert-upper      75
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               95
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              245
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             768
;  :mk-clause               251
;  :num-allocs              3781722
;  :num-checks              112
;  :propagations            114
;  :quant-instantiations    74
;  :rlimit-count            141053)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@82@01 $Perm.No) (< $Perm.No $k@82@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      41
;  :arith-assert-lower      122
;  :arith-assert-upper      75
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              245
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             768
;  :mk-clause               251
;  :num-allocs              3781722
;  :num-checks              113
;  :propagations            114
;  :quant-instantiations    74
;  :rlimit-count            141103)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@56@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      41
;  :arith-assert-lower      122
;  :arith-assert-upper      75
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              245
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             768
;  :mk-clause               251
;  :num-allocs              3781722
;  :num-checks              114
;  :propagations            114
;  :quant-instantiations    74
;  :rlimit-count            141114)
(assert (< $k@82@01 $k@56@01))
(assert (<= $Perm.No (- $k@56@01 $k@82@01)))
(assert (<= (- $k@56@01 $k@82@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@56@01 $k@82@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01)))
      $Ref.null))))
; [eval] diz.Sensor_m.Main_robot != null
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      41
;  :arith-assert-lower      124
;  :arith-assert-upper      76
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              245
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             771
;  :mk-clause               251
;  :num-allocs              3781722
;  :num-checks              115
;  :propagations            114
;  :quant-instantiations    74
;  :rlimit-count            141322)
(push) ; 4
(assert (not (< $Perm.No $k@56@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      41
;  :arith-assert-lower      124
;  :arith-assert-upper      76
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               98
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              245
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             771
;  :mk-clause               251
;  :num-allocs              3781722
;  :num-checks              116
;  :propagations            114
;  :quant-instantiations    74
;  :rlimit-count            141370)
(declare-const $k@83@01 $Perm)
(assert ($Perm.isReadVar $k@83@01 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      42
;  :arith-assert-lower      126
;  :arith-assert-upper      77
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               99
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              245
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             775
;  :mk-clause               253
;  :num-allocs              3781722
;  :num-checks              117
;  :propagations            115
;  :quant-instantiations    74
;  :rlimit-count            141567)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@83@01 $Perm.No) (< $Perm.No $k@83@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          27
;  :arith-assert-diseq      42
;  :arith-assert-lower      126
;  :arith-assert-upper      77
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               100
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              245
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             775
;  :mk-clause               253
;  :num-allocs              3781722
;  :num-checks              118
;  :propagations            115
;  :quant-instantiations    74
;  :rlimit-count            141617)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= (+ $k@39@01 $k@57@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          27
;  :arith-assert-diseq      42
;  :arith-assert-lower      126
;  :arith-assert-upper      78
;  :arith-bound-prop        5
;  :arith-conflicts         4
;  :arith-eq-adapter        76
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               101
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             777
;  :mk-clause               255
;  :num-allocs              3781722
;  :num-checks              119
;  :propagations            116
;  :quant-instantiations    74
;  :rlimit-count            141679)
(assert (< $k@83@01 (+ $k@39@01 $k@57@01)))
(assert (<= $Perm.No (- (+ $k@39@01 $k@57@01) $k@83@01)))
(assert (<= (- (+ $k@39@01 $k@57@01) $k@83@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@39@01 $k@57@01) $k@83@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01)))
      $Ref.null))))
; [eval] diz.Sensor_m.Main_robot_sensor != null
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      42
;  :arith-assert-lower      128
;  :arith-assert-upper      79
;  :arith-bound-prop        5
;  :arith-conflicts         4
;  :arith-eq-adapter        76
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               102
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             780
;  :mk-clause               255
;  :num-allocs              3781722
;  :num-checks              120
;  :propagations            116
;  :quant-instantiations    74
;  :rlimit-count            141898)
(push) ; 4
(assert (not (< $Perm.No (+ $k@39@01 $k@57@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      42
;  :arith-assert-lower      128
;  :arith-assert-upper      80
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        76
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               103
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             781
;  :mk-clause               255
;  :num-allocs              3781722
;  :num-checks              121
;  :propagations            116
;  :quant-instantiations    74
;  :rlimit-count            141961)
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      42
;  :arith-assert-lower      128
;  :arith-assert-upper      80
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        76
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               104
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             781
;  :mk-clause               255
;  :num-allocs              3781722
;  :num-checks              122
;  :propagations            116
;  :quant-instantiations    74
;  :rlimit-count            142009)
(push) ; 4
(assert (not (< $Perm.No (+ $k@39@01 $k@57@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      42
;  :arith-assert-lower      128
;  :arith-assert-upper      81
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        76
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               105
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             782
;  :mk-clause               255
;  :num-allocs              3781722
;  :num-checks              123
;  :propagations            116
;  :quant-instantiations    74
;  :rlimit-count            142072)
(push) ; 4
(assert (not (= diz@35@01 $t@58@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      42
;  :arith-assert-lower      128
;  :arith-assert-upper      81
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        76
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             783
;  :mk-clause               255
;  :num-allocs              3781722
;  :num-checks              124
;  :propagations            116
;  :quant-instantiations    74
;  :rlimit-count            142132)
(declare-const $k@84@01 $Perm)
(assert ($Perm.isReadVar $k@84@01 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      43
;  :arith-assert-lower      130
;  :arith-assert-upper      82
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             787
;  :mk-clause               257
;  :num-allocs              3781722
;  :num-checks              125
;  :propagations            117
;  :quant-instantiations    74
;  :rlimit-count            142329)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@84@01 $Perm.No) (< $Perm.No $k@84@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      43
;  :arith-assert-lower      130
;  :arith-assert-upper      82
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               108
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             787
;  :mk-clause               257
;  :num-allocs              3781722
;  :num-checks              126
;  :propagations            117
;  :quant-instantiations    74
;  :rlimit-count            142379)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@59@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      43
;  :arith-assert-lower      130
;  :arith-assert-upper      82
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               108
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             787
;  :mk-clause               257
;  :num-allocs              3781722
;  :num-checks              127
;  :propagations            117
;  :quant-instantiations    74
;  :rlimit-count            142390)
(assert (< $k@84@01 $k@59@01))
(assert (<= $Perm.No (- $k@59@01 $k@84@01)))
(assert (<= (- $k@59@01 $k@84@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@59@01 $k@84@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01)))
      $Ref.null))))
; [eval] diz.Sensor_m.Main_robot_controller != null
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      43
;  :arith-assert-lower      132
;  :arith-assert-upper      83
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             790
;  :mk-clause               257
;  :num-allocs              3781722
;  :num-checks              128
;  :propagations            117
;  :quant-instantiations    74
;  :rlimit-count            142604)
(push) ; 4
(assert (not (< $Perm.No $k@59@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      43
;  :arith-assert-lower      132
;  :arith-assert-upper      83
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             790
;  :mk-clause               257
;  :num-allocs              3781722
;  :num-checks              129
;  :propagations            117
;  :quant-instantiations    74
;  :rlimit-count            142652)
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      43
;  :arith-assert-lower      132
;  :arith-assert-upper      83
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               111
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             790
;  :mk-clause               257
;  :num-allocs              3781722
;  :num-checks              130
;  :propagations            117
;  :quant-instantiations    74
;  :rlimit-count            142700)
(push) ; 4
(assert (not (< $Perm.No $k@59@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      43
;  :arith-assert-lower      132
;  :arith-assert-upper      83
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               112
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             790
;  :mk-clause               257
;  :num-allocs              3781722
;  :num-checks              131
;  :propagations            117
;  :quant-instantiations    74
;  :rlimit-count            142748)
(declare-const $k@85@01 $Perm)
(assert ($Perm.isReadVar $k@85@01 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      44
;  :arith-assert-lower      134
;  :arith-assert-upper      84
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               113
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             794
;  :mk-clause               259
;  :num-allocs              3781722
;  :num-checks              132
;  :propagations            118
;  :quant-instantiations    74
;  :rlimit-count            142944)
(push) ; 4
(assert (not (< $Perm.No $k@56@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      44
;  :arith-assert-lower      134
;  :arith-assert-upper      84
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               114
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             794
;  :mk-clause               259
;  :num-allocs              3781722
;  :num-checks              133
;  :propagations            118
;  :quant-instantiations    74
;  :rlimit-count            142992)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@85@01 $Perm.No) (< $Perm.No $k@85@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      44
;  :arith-assert-lower      134
;  :arith-assert-upper      84
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               115
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             794
;  :mk-clause               259
;  :num-allocs              3781722
;  :num-checks              134
;  :propagations            118
;  :quant-instantiations    74
;  :rlimit-count            143042)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@60@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      44
;  :arith-assert-lower      134
;  :arith-assert-upper      84
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               115
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             794
;  :mk-clause               259
;  :num-allocs              3781722
;  :num-checks              135
;  :propagations            118
;  :quant-instantiations    74
;  :rlimit-count            143053)
(assert (< $k@85@01 $k@60@01))
(assert (<= $Perm.No (- $k@60@01 $k@85@01)))
(assert (<= (- $k@60@01 $k@85@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@60@01 $k@85@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01))))))))))
      $Ref.null))))
; [eval] diz.Sensor_m.Main_robot.Robot_m == diz.Sensor_m
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      44
;  :arith-assert-lower      136
;  :arith-assert-upper      85
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               116
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             797
;  :mk-clause               259
;  :num-allocs              3781722
;  :num-checks              136
;  :propagations            118
;  :quant-instantiations    74
;  :rlimit-count            143267)
(push) ; 4
(assert (not (< $Perm.No $k@56@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      44
;  :arith-assert-lower      136
;  :arith-assert-upper      85
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               117
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             797
;  :mk-clause               259
;  :num-allocs              3781722
;  :num-checks              137
;  :propagations            118
;  :quant-instantiations    74
;  :rlimit-count            143315)
(push) ; 4
(assert (not (< $Perm.No $k@60@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      44
;  :arith-assert-lower      136
;  :arith-assert-upper      85
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               118
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             797
;  :mk-clause               259
;  :num-allocs              3781722
;  :num-checks              138
;  :propagations            118
;  :quant-instantiations    74
;  :rlimit-count            143363)
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      44
;  :arith-assert-lower      136
;  :arith-assert-upper      85
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               119
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             797
;  :mk-clause               259
;  :num-allocs              3781722
;  :num-checks              139
;  :propagations            118
;  :quant-instantiations    74
;  :rlimit-count            143411)
; [eval] diz.Sensor_m.Main_robot_sensor == diz
(push) ; 4
(assert (not (< $Perm.No $k@38@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      44
;  :arith-assert-lower      136
;  :arith-assert-upper      85
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               120
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             797
;  :mk-clause               259
;  :num-allocs              3781722
;  :num-checks              140
;  :propagations            118
;  :quant-instantiations    74
;  :rlimit-count            143459)
(push) ; 4
(assert (not (< $Perm.No (+ $k@39@01 $k@57@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      44
;  :arith-assert-lower      136
;  :arith-assert-upper      86
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             798
;  :mk-clause               259
;  :num-allocs              3781722
;  :num-checks              141
;  :propagations            118
;  :quant-instantiations    74
;  :rlimit-count            143522)
(set-option :timeout 0)
(push) ; 4
(assert (not (= $t@58@01 diz@35@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               574
;  :arith-add-rows          28
;  :arith-assert-diseq      44
;  :arith-assert-lower      136
;  :arith-assert-upper      86
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               122
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   40
;  :datatype-splits         32
;  :decisions               48
;  :del-clause              247
;  :final-checks            20
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.11
;  :memory                  4.11
;  :minimized-lits          1
;  :mk-bool-var             798
;  :mk-clause               259
;  :num-allocs              3781722
;  :num-checks              142
;  :propagations            118
;  :quant-instantiations    74
;  :rlimit-count            143574)
(assert (= $t@58@01 diz@35@01))
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
(assert ($Perm.isReadVar $k@74@01 $Perm.Write))
(assert ($Perm.isReadVar $k@76@01 $Perm.Write))
(assert ($Perm.isReadVar $k@77@01 $Perm.Write))
(assert ($Perm.isReadVar $k@78@01 $Perm.Write))
(assert ($Perm.isReadVar $k@79@01 $Perm.Write))
(assert (= $t@73@01 ($Snap.combine ($Snap.first $t@73@01) ($Snap.second $t@73@01))))
(assert (<= $Perm.No $k@74@01))
(assert (<= $k@74@01 $Perm.Write))
(assert (implies (< $Perm.No $k@74@01) (not (= diz@35@01 $Ref.null))))
(assert (=
  ($Snap.second $t@73@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@73@01))
    ($Snap.second ($Snap.second $t@73@01)))))
(assert (= ($Snap.first ($Snap.second $t@73@01)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@73@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@73@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@73@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))
  $Snap.unit))
(assert (forall ((i__31@75@01 Int)) (!
  (implies
    (and
      (<
        i__31@75@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
      (<= 0 i__31@75@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
          i__31@75@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
            i__31@75@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
            i__31@75@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
    i__31@75@01))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
(assert (<= $Perm.No $k@76@01))
(assert (<= $k@76@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@76@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))
(assert (<= $Perm.No $k@77@01))
(assert (<= $k@77@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@77@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))))
(assert (<= $Perm.No $k@78@01))
(assert (<= $k@78@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@78@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))))
(assert (<= $Perm.No $k@79@01))
(assert (<= $k@79@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@79@01)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
  diz@35@01))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 10)
(check-sat)
; unknown
; Loop head block: Follow loop-internal edges
(push) ; 5
(assert (not false))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               941
;  :arith-add-rows          28
;  :arith-assert-diseq      49
;  :arith-assert-lower      150
;  :arith-assert-upper      98
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               123
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             924
;  :mk-clause               272
;  :num-allocs              3927059
;  :num-checks              145
;  :propagations            128
;  :quant-instantiations    83
;  :rlimit-count            149624
;  :time                    0.00)
; [then-branch: 16 | True | live]
; [else-branch: 16 | False | dead]
(push) ; 5
; [then-branch: 16 | True]
; [exec]
; __flatten_25__20 := diz.Sensor_m
(push) ; 6
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               941
;  :arith-add-rows          28
;  :arith-assert-diseq      49
;  :arith-assert-lower      150
;  :arith-assert-upper      98
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               124
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             924
;  :mk-clause               272
;  :num-allocs              3927059
;  :num-checks              146
;  :propagations            128
;  :quant-instantiations    83
;  :rlimit-count            149677)
(declare-const __flatten_25__20@86@01 $Ref)
(assert (= __flatten_25__20@86@01 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))))
; [exec]
; __flatten_27__22 := diz.Sensor_m
(push) ; 6
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               942
;  :arith-add-rows          28
;  :arith-assert-diseq      49
;  :arith-assert-lower      150
;  :arith-assert-upper      98
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             925
;  :mk-clause               272
;  :num-allocs              3927059
;  :num-checks              147
;  :propagations            128
;  :quant-instantiations    83
;  :rlimit-count            149782)
(declare-const __flatten_27__22@87@01 $Ref)
(assert (= __flatten_27__22@87@01 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))))
; [exec]
; __flatten_26__21 := __flatten_27__22.Main_process_state[0 := 0]
; [eval] __flatten_27__22.Main_process_state[0 := 0]
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) __flatten_27__22@87@01)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               943
;  :arith-add-rows          28
;  :arith-assert-diseq      49
;  :arith-assert-lower      150
;  :arith-assert-upper      98
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             926
;  :mk-clause               272
;  :num-allocs              3927059
;  :num-checks              148
;  :propagations            128
;  :quant-instantiations    83
;  :rlimit-count            149830)
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               943
;  :arith-add-rows          28
;  :arith-assert-diseq      49
;  :arith-assert-lower      150
;  :arith-assert-upper      98
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        5
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             926
;  :mk-clause               272
;  :num-allocs              3927059
;  :num-checks              149
;  :propagations            128
;  :quant-instantiations    83
;  :rlimit-count            149845)
(declare-const __flatten_26__21@88@01 Seq<Int>)
(assert (Seq_equal
  __flatten_26__21@88@01
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))
    0
    0)))
; [exec]
; __flatten_25__20.Main_process_state := __flatten_26__21
(set-option :timeout 10)
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) __flatten_25__20@86@01)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               953
;  :arith-add-rows          31
;  :arith-assert-diseq      50
;  :arith-assert-lower      154
;  :arith-assert-upper      100
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        5
;  :arith-pivots            21
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             949
;  :mk-clause               291
;  :num-allocs              3927059
;  :num-checks              150
;  :propagations            137
;  :quant-instantiations    88
;  :rlimit-count            150323)
(assert (not (= __flatten_25__20@86@01 $Ref.null)))
; [exec]
; __flatten_28__23 := diz.Sensor_m
(push) ; 6
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               954
;  :arith-add-rows          31
;  :arith-assert-diseq      50
;  :arith-assert-lower      154
;  :arith-assert-upper      100
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        5
;  :arith-pivots            21
;  :binary-propagations     16
;  :conflicts               126
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             950
;  :mk-clause               291
;  :num-allocs              3927059
;  :num-checks              151
;  :propagations            137
;  :quant-instantiations    88
;  :rlimit-count            150427)
(declare-const __flatten_28__23@89@01 $Ref)
(assert (= __flatten_28__23@89@01 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))))
; [exec]
; __flatten_30__25 := diz.Sensor_m
(push) ; 6
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 6
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               955
;  :arith-add-rows          31
;  :arith-assert-diseq      50
;  :arith-assert-lower      154
;  :arith-assert-upper      100
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        5
;  :arith-pivots            21
;  :binary-propagations     16
;  :conflicts               127
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             951
;  :mk-clause               291
;  :num-allocs              3927059
;  :num-checks              152
;  :propagations            137
;  :quant-instantiations    88
;  :rlimit-count            150512)
(declare-const __flatten_30__25@90@01 $Ref)
(assert (= __flatten_30__25@90@01 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))))
; [exec]
; __flatten_29__24 := __flatten_30__25.Main_event_state[0 := 2]
; [eval] __flatten_30__25.Main_event_state[0 := 2]
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) __flatten_30__25@90@01)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               956
;  :arith-add-rows          31
;  :arith-assert-diseq      50
;  :arith-assert-lower      154
;  :arith-assert-upper      100
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        5
;  :arith-pivots            21
;  :binary-propagations     16
;  :conflicts               127
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             952
;  :mk-clause               291
;  :num-allocs              3927059
;  :num-checks              153
;  :propagations            137
;  :quant-instantiations    88
;  :rlimit-count            150560)
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               956
;  :arith-add-rows          31
;  :arith-assert-diseq      50
;  :arith-assert-lower      154
;  :arith-assert-upper      100
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        5
;  :arith-pivots            21
;  :binary-propagations     16
;  :conflicts               127
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             952
;  :mk-clause               291
;  :num-allocs              3927059
;  :num-checks              154
;  :propagations            137
;  :quant-instantiations    88
;  :rlimit-count            150575)
(declare-const __flatten_29__24@91@01 Seq<Int>)
(assert (Seq_equal
  __flatten_29__24@91@01
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))
    0
    2)))
; [exec]
; __flatten_28__23.Main_event_state := __flatten_29__24
(set-option :timeout 10)
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) __flatten_28__23@89@01)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               966
;  :arith-add-rows          34
;  :arith-assert-diseq      51
;  :arith-assert-lower      158
;  :arith-assert-upper      102
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        91
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               127
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             975
;  :mk-clause               310
;  :num-allocs              3927059
;  :num-checks              155
;  :propagations            146
;  :quant-instantiations    93
;  :rlimit-count            151080)
(assert (not (= __flatten_28__23@89@01 $Ref.null)))
(push) ; 6
; Loop head block: Check well-definedness of invariant
(declare-const $t@92@01 $Snap)
(assert (= $t@92@01 ($Snap.combine ($Snap.first $t@92@01) ($Snap.second $t@92@01))))
(declare-const $k@93@01 $Perm)
(assert ($Perm.isReadVar $k@93@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@93@01 $Perm.No) (< $Perm.No $k@93@01))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               971
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      160
;  :arith-assert-upper      103
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               128
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             980
;  :mk-clause               312
;  :num-allocs              3927059
;  :num-checks              156
;  :propagations            147
;  :quant-instantiations    93
;  :rlimit-count            151391)
(assert (<= $Perm.No $k@93@01))
(assert (<= $k@93@01 $Perm.Write))
(assert (implies (< $Perm.No $k@93@01) (not (= diz@35@01 $Ref.null))))
(assert (=
  ($Snap.second $t@92@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@92@01))
    ($Snap.second ($Snap.second $t@92@01)))))
(assert (= ($Snap.first ($Snap.second $t@92@01)) $Snap.unit))
; [eval] diz.Sensor_m != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               977
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      160
;  :arith-assert-upper      104
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               129
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.21
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             983
;  :mk-clause               312
;  :num-allocs              3927059
;  :num-checks              157
;  :propagations            147
;  :quant-instantiations    93
;  :rlimit-count            151634)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@92@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@92@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               983
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      160
;  :arith-assert-upper      104
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               130
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             986
;  :mk-clause               312
;  :num-allocs              4076855
;  :num-checks              158
;  :propagations            147
;  :quant-instantiations    94
;  :rlimit-count            151906)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@92@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               988
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      160
;  :arith-assert-upper      104
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               131
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             987
;  :mk-clause               312
;  :num-allocs              4076855
;  :num-checks              159
;  :propagations            147
;  :quant-instantiations    94
;  :rlimit-count            152083)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
  $Snap.unit))
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               994
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      160
;  :arith-assert-upper      104
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               132
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             989
;  :mk-clause               312
;  :num-allocs              4076855
;  :num-checks              160
;  :propagations            147
;  :quant-instantiations    94
;  :rlimit-count            152302)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1001
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      162
;  :arith-assert-upper      105
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        93
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               133
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             995
;  :mk-clause               312
;  :num-allocs              4076855
;  :num-checks              161
;  :propagations            147
;  :quant-instantiations    96
;  :rlimit-count            152632)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
  $Snap.unit))
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1007
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      162
;  :arith-assert-upper      105
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        93
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               134
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             997
;  :mk-clause               312
;  :num-allocs              4076855
;  :num-checks              162
;  :propagations            147
;  :quant-instantiations    96
;  :rlimit-count            152871)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))
  $Snap.unit))
; [eval] (forall i__32: Int :: { diz.Sensor_m.Main_process_state[i__32] } 0 <= i__32 && i__32 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__32] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|)
(declare-const i__32@94@01 Int)
(push) ; 7
; [eval] 0 <= i__32 && i__32 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__32] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__32 && i__32 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__32
(push) ; 8
; [then-branch: 17 | 0 <= i__32@94@01 | live]
; [else-branch: 17 | !(0 <= i__32@94@01) | live]
(push) ; 9
; [then-branch: 17 | 0 <= i__32@94@01]
(assert (<= 0 i__32@94@01))
; [eval] i__32 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 10
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1015
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      165
;  :arith-assert-upper      106
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               135
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1005
;  :mk-clause               312
;  :num-allocs              4076855
;  :num-checks              163
;  :propagations            147
;  :quant-instantiations    98
;  :rlimit-count            153311)
(pop) ; 9
(push) ; 9
; [else-branch: 17 | !(0 <= i__32@94@01)]
(assert (not (<= 0 i__32@94@01)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 18 | i__32@94@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__32@94@01 | live]
; [else-branch: 18 | !(i__32@94@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__32@94@01) | live]
(push) ; 9
; [then-branch: 18 | i__32@94@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__32@94@01]
(assert (and
  (<
    i__32@94@01
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
  (<= 0 i__32@94@01)))
; [eval] diz.Sensor_m.Main_process_state[i__32] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__32] == -1
; [eval] diz.Sensor_m.Main_process_state[i__32]
(push) ; 10
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1015
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      166
;  :arith-assert-upper      107
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               136
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1007
;  :mk-clause               312
;  :num-allocs              4076855
;  :num-checks              164
;  :propagations            147
;  :quant-instantiations    98
;  :rlimit-count            153468)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__32@94@01 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1015
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      166
;  :arith-assert-upper      107
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               136
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1007
;  :mk-clause               312
;  :num-allocs              4076855
;  :num-checks              165
;  :propagations            147
;  :quant-instantiations    98
;  :rlimit-count            153477)
; [eval] -1
(push) ; 10
; [then-branch: 19 | First:(Second:(Second:(Second:($t@92@01))))[i__32@94@01] == -1 | live]
; [else-branch: 19 | First:(Second:(Second:(Second:($t@92@01))))[i__32@94@01] != -1 | live]
(push) ; 11
; [then-branch: 19 | First:(Second:(Second:(Second:($t@92@01))))[i__32@94@01] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__32@94@01)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 19 | First:(Second:(Second:(Second:($t@92@01))))[i__32@94@01] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      i__32@94@01)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__32]
; [eval] diz.Sensor_m.Main_process_state[i__32]
(set-option :timeout 10)
(push) ; 12
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1015
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      166
;  :arith-assert-upper      107
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               137
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1008
;  :mk-clause               312
;  :num-allocs              4076855
;  :num-checks              166
;  :propagations            147
;  :quant-instantiations    98
;  :rlimit-count            153691)
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i__32@94@01 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1015
;  :arith-add-rows          34
;  :arith-assert-diseq      52
;  :arith-assert-lower      166
;  :arith-assert-upper      107
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               137
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1008
;  :mk-clause               312
;  :num-allocs              4076855
;  :num-checks              167
;  :propagations            147
;  :quant-instantiations    98
;  :rlimit-count            153700)
(push) ; 12
; [then-branch: 20 | 0 <= First:(Second:(Second:(Second:($t@92@01))))[i__32@94@01] | live]
; [else-branch: 20 | !(0 <= First:(Second:(Second:(Second:($t@92@01))))[i__32@94@01]) | live]
(push) ; 13
; [then-branch: 20 | 0 <= First:(Second:(Second:(Second:($t@92@01))))[i__32@94@01]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__32@94@01)))
; [eval] diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__32]
(set-option :timeout 10)
(push) ; 14
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1015
;  :arith-add-rows          34
;  :arith-assert-diseq      53
;  :arith-assert-lower      169
;  :arith-assert-upper      107
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               138
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1011
;  :mk-clause               313
;  :num-allocs              4076855
;  :num-checks              168
;  :propagations            147
;  :quant-instantiations    98
;  :rlimit-count            153863)
(set-option :timeout 0)
(push) ; 14
(assert (not (>= i__32@94@01 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1015
;  :arith-add-rows          34
;  :arith-assert-diseq      53
;  :arith-assert-lower      169
;  :arith-assert-upper      107
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               138
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1011
;  :mk-clause               313
;  :num-allocs              4076855
;  :num-checks              169
;  :propagations            147
;  :quant-instantiations    98
;  :rlimit-count            153872)
; [eval] |diz.Sensor_m.Main_event_state|
(set-option :timeout 10)
(push) ; 14
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1015
;  :arith-add-rows          34
;  :arith-assert-diseq      53
;  :arith-assert-lower      169
;  :arith-assert-upper      107
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               139
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              259
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1011
;  :mk-clause               313
;  :num-allocs              4076855
;  :num-checks              170
;  :propagations            147
;  :quant-instantiations    98
;  :rlimit-count            153920)
(pop) ; 13
(push) ; 13
; [else-branch: 20 | !(0 <= First:(Second:(Second:(Second:($t@92@01))))[i__32@94@01])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      i__32@94@01))))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 18 | !(i__32@94@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__32@94@01)]
(assert (not
  (and
    (<
      i__32@94@01
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
    (<= 0 i__32@94@01))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__32@94@01 Int)) (!
  (implies
    (and
      (<
        i__32@94@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
      (<= 0 i__32@94@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          i__32@94@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__32@94@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__32@94@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__32@94@01))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1020
;  :arith-add-rows          34
;  :arith-assert-diseq      53
;  :arith-assert-lower      169
;  :arith-assert-upper      107
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               140
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1013
;  :mk-clause               313
;  :num-allocs              4076855
;  :num-checks              171
;  :propagations            147
;  :quant-instantiations    98
;  :rlimit-count            154545)
(declare-const $k@95@01 $Perm)
(assert ($Perm.isReadVar $k@95@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@95@01 $Perm.No) (< $Perm.No $k@95@01))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1020
;  :arith-add-rows          34
;  :arith-assert-diseq      54
;  :arith-assert-lower      171
;  :arith-assert-upper      108
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               141
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1017
;  :mk-clause               315
;  :num-allocs              4076855
;  :num-checks              172
;  :propagations            148
;  :quant-instantiations    98
;  :rlimit-count            154743)
(assert (<= $Perm.No $k@95@01))
(assert (<= $k@95@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@95@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_robot != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1026
;  :arith-add-rows          34
;  :arith-assert-diseq      54
;  :arith-assert-lower      171
;  :arith-assert-upper      109
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               142
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1020
;  :mk-clause               315
;  :num-allocs              4076855
;  :num-checks              173
;  :propagations            148
;  :quant-instantiations    98
;  :rlimit-count            155066)
(push) ; 7
(assert (not (< $Perm.No $k@95@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1026
;  :arith-add-rows          34
;  :arith-assert-diseq      54
;  :arith-assert-lower      171
;  :arith-assert-upper      109
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               143
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1020
;  :mk-clause               315
;  :num-allocs              4076855
;  :num-checks              174
;  :propagations            148
;  :quant-instantiations    98
;  :rlimit-count            155114)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1032
;  :arith-add-rows          34
;  :arith-assert-diseq      54
;  :arith-assert-lower      171
;  :arith-assert-upper      109
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               144
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1023
;  :mk-clause               315
;  :num-allocs              4076855
;  :num-checks              175
;  :propagations            148
;  :quant-instantiations    99
;  :rlimit-count            155470)
(declare-const $k@96@01 $Perm)
(assert ($Perm.isReadVar $k@96@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@96@01 $Perm.No) (< $Perm.No $k@96@01))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1032
;  :arith-add-rows          34
;  :arith-assert-diseq      55
;  :arith-assert-lower      173
;  :arith-assert-upper      110
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               145
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1027
;  :mk-clause               317
;  :num-allocs              4076855
;  :num-checks              176
;  :propagations            149
;  :quant-instantiations    99
;  :rlimit-count            155668)
(assert (<= $Perm.No $k@96@01))
(assert (<= $k@96@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@96@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_robot_sensor != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1038
;  :arith-add-rows          34
;  :arith-assert-diseq      55
;  :arith-assert-lower      173
;  :arith-assert-upper      111
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               146
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1030
;  :mk-clause               317
;  :num-allocs              4076855
;  :num-checks              177
;  :propagations            149
;  :quant-instantiations    99
;  :rlimit-count            156011)
(push) ; 7
(assert (not (< $Perm.No $k@96@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1038
;  :arith-add-rows          34
;  :arith-assert-diseq      55
;  :arith-assert-lower      173
;  :arith-assert-upper      111
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               147
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1030
;  :mk-clause               317
;  :num-allocs              4076855
;  :num-checks              178
;  :propagations            149
;  :quant-instantiations    99
;  :rlimit-count            156059)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1044
;  :arith-add-rows          34
;  :arith-assert-diseq      55
;  :arith-assert-lower      173
;  :arith-assert-upper      111
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               148
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1033
;  :mk-clause               317
;  :num-allocs              4076855
;  :num-checks              179
;  :propagations            149
;  :quant-instantiations    100
;  :rlimit-count            156433)
(push) ; 7
(assert (not (< $Perm.No $k@96@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1044
;  :arith-add-rows          34
;  :arith-assert-diseq      55
;  :arith-assert-lower      173
;  :arith-assert-upper      111
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1033
;  :mk-clause               317
;  :num-allocs              4076855
;  :num-checks              180
;  :propagations            149
;  :quant-instantiations    100
;  :rlimit-count            156481)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1049
;  :arith-add-rows          34
;  :arith-assert-diseq      55
;  :arith-assert-lower      173
;  :arith-assert-upper      111
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               150
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1034
;  :mk-clause               317
;  :num-allocs              4076855
;  :num-checks              181
;  :propagations            149
;  :quant-instantiations    100
;  :rlimit-count            156758)
(declare-const $k@97@01 $Perm)
(assert ($Perm.isReadVar $k@97@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@97@01 $Perm.No) (< $Perm.No $k@97@01))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1049
;  :arith-add-rows          34
;  :arith-assert-diseq      56
;  :arith-assert-lower      175
;  :arith-assert-upper      112
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               151
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1038
;  :mk-clause               319
;  :num-allocs              4076855
;  :num-checks              182
;  :propagations            150
;  :quant-instantiations    100
;  :rlimit-count            156956)
(assert (<= $Perm.No $k@97@01))
(assert (<= $k@97@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@97@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_robot_controller != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1055
;  :arith-add-rows          34
;  :arith-assert-diseq      56
;  :arith-assert-lower      175
;  :arith-assert-upper      113
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               152
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1041
;  :mk-clause               319
;  :num-allocs              4076855
;  :num-checks              183
;  :propagations            150
;  :quant-instantiations    100
;  :rlimit-count            157329)
(push) ; 7
(assert (not (< $Perm.No $k@97@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1055
;  :arith-add-rows          34
;  :arith-assert-diseq      56
;  :arith-assert-lower      175
;  :arith-assert-upper      113
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               153
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1041
;  :mk-clause               319
;  :num-allocs              4076855
;  :num-checks              184
;  :propagations            150
;  :quant-instantiations    100
;  :rlimit-count            157377)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1061
;  :arith-add-rows          34
;  :arith-assert-diseq      56
;  :arith-assert-lower      175
;  :arith-assert-upper      113
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1044
;  :mk-clause               319
;  :num-allocs              4076855
;  :num-checks              185
;  :propagations            150
;  :quant-instantiations    101
;  :rlimit-count            157783)
(push) ; 7
(assert (not (< $Perm.No $k@97@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1061
;  :arith-add-rows          34
;  :arith-assert-diseq      56
;  :arith-assert-lower      175
;  :arith-assert-upper      113
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1044
;  :mk-clause               319
;  :num-allocs              4076855
;  :num-checks              186
;  :propagations            150
;  :quant-instantiations    101
;  :rlimit-count            157831)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1066
;  :arith-add-rows          34
;  :arith-assert-diseq      56
;  :arith-assert-lower      175
;  :arith-assert-upper      113
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               156
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1045
;  :mk-clause               319
;  :num-allocs              4076855
;  :num-checks              187
;  :propagations            150
;  :quant-instantiations    101
;  :rlimit-count            158138)
(push) ; 7
(assert (not (< $Perm.No $k@95@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1066
;  :arith-add-rows          34
;  :arith-assert-diseq      56
;  :arith-assert-lower      175
;  :arith-assert-upper      113
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               157
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1045
;  :mk-clause               319
;  :num-allocs              4076855
;  :num-checks              188
;  :propagations            150
;  :quant-instantiations    101
;  :rlimit-count            158186)
(declare-const $k@98@01 $Perm)
(assert ($Perm.isReadVar $k@98@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@98@01 $Perm.No) (< $Perm.No $k@98@01))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1066
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      114
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               158
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1049
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              189
;  :propagations            151
;  :quant-instantiations    101
;  :rlimit-count            158384)
(assert (<= $Perm.No $k@98@01))
(assert (<= $k@98@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@98@01)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_robot.Robot_m == diz.Sensor_m
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1072
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               159
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1052
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              190
;  :propagations            151
;  :quant-instantiations    101
;  :rlimit-count            158787)
(push) ; 7
(assert (not (< $Perm.No $k@95@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1072
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               160
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1052
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              191
;  :propagations            151
;  :quant-instantiations    101
;  :rlimit-count            158835)
(push) ; 7
(assert (not (< $Perm.No $k@98@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1072
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               161
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1052
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              192
;  :propagations            151
;  :quant-instantiations    101
;  :rlimit-count            158883)
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1072
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               162
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1052
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              193
;  :propagations            151
;  :quant-instantiations    101
;  :rlimit-count            158931)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_robot_sensor == diz
(push) ; 7
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1077
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               163
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1055
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              194
;  :propagations            151
;  :quant-instantiations    102
;  :rlimit-count            159315)
(push) ; 7
(assert (not (< $Perm.No $k@96@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1077
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               164
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1055
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              195
;  :propagations            151
;  :quant-instantiations    102
;  :rlimit-count            159363)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
  diz@35@01))
; Loop head block: Check well-definedness of edge conditions
(push) ; 7
; [eval] diz.Sensor_m.Main_process_state[0] != -1 || diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_process_state[0] != -1
; [eval] diz.Sensor_m.Main_process_state[0]
(push) ; 8
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1080
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               165
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1056
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              196
;  :propagations            151
;  :quant-instantiations    102
;  :rlimit-count            159579)
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1080
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               165
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1056
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              197
;  :propagations            151
;  :quant-instantiations    102
;  :rlimit-count            159594)
; [eval] -1
(push) ; 8
; [then-branch: 21 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1 | live]
; [else-branch: 21 | First:(Second:(Second:(Second:($t@92@01))))[0] == -1 | live]
(push) ; 9
; [then-branch: 21 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 21 | First:(Second:(Second:(Second:($t@92@01))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    0)
  (- 0 1)))
; [eval] diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_event_state[0]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1081
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               166
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1057
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              198
;  :propagations            151
;  :quant-instantiations    102
;  :rlimit-count            159789)
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1081
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               166
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1057
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              199
;  :propagations            151
;  :quant-instantiations    102
;  :rlimit-count            159804)
; [eval] -2
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(push) ; 7
; [eval] !(diz.Sensor_m.Main_process_state[0] != -1 || diz.Sensor_m.Main_event_state[0] != -2)
; [eval] diz.Sensor_m.Main_process_state[0] != -1 || diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_process_state[0] != -1
; [eval] diz.Sensor_m.Main_process_state[0]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1081
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               167
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1057
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              200
;  :propagations            151
;  :quant-instantiations    102
;  :rlimit-count            159857)
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1081
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               167
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1057
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              201
;  :propagations            151
;  :quant-instantiations    102
;  :rlimit-count            159872)
; [eval] -1
(push) ; 8
; [then-branch: 22 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1 | live]
; [else-branch: 22 | First:(Second:(Second:(Second:($t@92@01))))[0] == -1 | live]
(push) ; 9
; [then-branch: 22 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 22 | First:(Second:(Second:(Second:($t@92@01))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    0)
  (- 0 1)))
; [eval] diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_event_state[0]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1082
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               168
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1058
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              202
;  :propagations            151
;  :quant-instantiations    102
;  :rlimit-count            160063)
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1082
;  :arith-add-rows          34
;  :arith-assert-diseq      57
;  :arith-assert-lower      177
;  :arith-assert-upper      115
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               168
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              260
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1058
;  :mk-clause               321
;  :num-allocs              4076855
;  :num-checks              203
;  :propagations            151
;  :quant-instantiations    102
;  :rlimit-count            160078)
; [eval] -2
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(pop) ; 6
(push) ; 6
; Loop head block: Establish invariant
(declare-const $k@99@01 $Perm)
(assert ($Perm.isReadVar $k@99@01 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@99@01 $Perm.No) (< $Perm.No $k@99@01))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1082
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      179
;  :arith-assert-upper      116
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               169
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1062
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              204
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            160281)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@74@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1082
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      179
;  :arith-assert-upper      116
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               169
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1062
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              205
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            160292)
(assert (< $k@99@01 $k@74@01))
(assert (<= $Perm.No (- $k@74@01 $k@99@01)))
(assert (<= (- $k@74@01 $k@99@01) $Perm.Write))
(assert (implies (< $Perm.No (- $k@74@01 $k@99@01)) (not (= diz@35@01 $Ref.null))))
; [eval] diz.Sensor_m != null
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1082
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      181
;  :arith-assert-upper      117
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               170
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1065
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              206
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            160506)
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1082
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      181
;  :arith-assert-upper      117
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               171
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1065
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              207
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            160554)
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1082
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      181
;  :arith-assert-upper      117
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               172
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1065
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              208
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            160602)
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1082
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      181
;  :arith-assert-upper      117
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               173
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1065
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              209
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            160650)
(set-option :timeout 0)
(push) ; 7
(assert (not (= (Seq_length __flatten_26__21@88@01) 2)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1082
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      181
;  :arith-assert-upper      117
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        101
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               174
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1068
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              210
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            160724)
(assert (= (Seq_length __flatten_26__21@88@01) 2))
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1083
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      182
;  :arith-assert-upper      118
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               175
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1071
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              211
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            160823)
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1083
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      182
;  :arith-assert-upper      118
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               176
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1071
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              212
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            160871)
(set-option :timeout 0)
(push) ; 7
(assert (not (= (Seq_length __flatten_29__24@91@01) 3)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1083
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      182
;  :arith-assert-upper      118
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        103
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               177
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1074
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              213
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            160945)
(assert (= (Seq_length __flatten_29__24@91@01) 3))
; [eval] (forall i__32: Int :: { diz.Sensor_m.Main_process_state[i__32] } 0 <= i__32 && i__32 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__32] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|)
(declare-const i__32@100@01 Int)
(push) ; 7
; [eval] 0 <= i__32 && i__32 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__32] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__32 && i__32 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__32
(push) ; 8
; [then-branch: 23 | 0 <= i__32@100@01 | live]
; [else-branch: 23 | !(0 <= i__32@100@01) | live]
(push) ; 9
; [then-branch: 23 | 0 <= i__32@100@01]
(assert (<= 0 i__32@100@01))
; [eval] i__32 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1084
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      184
;  :arith-assert-upper      119
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               178
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1078
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              214
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            161096)
(pop) ; 9
(push) ; 9
; [else-branch: 23 | !(0 <= i__32@100@01)]
(assert (not (<= 0 i__32@100@01)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 24 | i__32@100@01 < |__flatten_26__21@88@01| && 0 <= i__32@100@01 | live]
; [else-branch: 24 | !(i__32@100@01 < |__flatten_26__21@88@01| && 0 <= i__32@100@01) | live]
(push) ; 9
; [then-branch: 24 | i__32@100@01 < |__flatten_26__21@88@01| && 0 <= i__32@100@01]
(assert (and (< i__32@100@01 (Seq_length __flatten_26__21@88@01)) (<= 0 i__32@100@01)))
; [eval] diz.Sensor_m.Main_process_state[i__32] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__32] == -1
; [eval] diz.Sensor_m.Main_process_state[i__32]
(push) ; 10
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1084
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      185
;  :arith-assert-upper      120
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               179
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1080
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              215
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            161253)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__32@100@01 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1084
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      185
;  :arith-assert-upper      120
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               179
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1080
;  :mk-clause               323
;  :num-allocs              4076855
;  :num-checks              216
;  :propagations            152
;  :quant-instantiations    102
;  :rlimit-count            161262)
; [eval] -1
(push) ; 10
; [then-branch: 25 | __flatten_26__21@88@01[i__32@100@01] == -1 | live]
; [else-branch: 25 | __flatten_26__21@88@01[i__32@100@01] != -1 | live]
(push) ; 11
; [then-branch: 25 | __flatten_26__21@88@01[i__32@100@01] == -1]
(assert (= (Seq_index __flatten_26__21@88@01 i__32@100@01) (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 25 | __flatten_26__21@88@01[i__32@100@01] != -1]
(assert (not (= (Seq_index __flatten_26__21@88@01 i__32@100@01) (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__32]
; [eval] diz.Sensor_m.Main_process_state[i__32]
(set-option :timeout 10)
(push) ; 12
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1085
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      185
;  :arith-assert-upper      120
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               180
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1087
;  :mk-clause               331
;  :num-allocs              4076855
;  :num-checks              217
;  :propagations            152
;  :quant-instantiations    103
;  :rlimit-count            161464)
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i__32@100@01 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1085
;  :arith-add-rows          34
;  :arith-assert-diseq      58
;  :arith-assert-lower      185
;  :arith-assert-upper      120
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               180
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1087
;  :mk-clause               331
;  :num-allocs              4076855
;  :num-checks              218
;  :propagations            152
;  :quant-instantiations    103
;  :rlimit-count            161473)
(push) ; 12
; [then-branch: 26 | 0 <= __flatten_26__21@88@01[i__32@100@01] | live]
; [else-branch: 26 | !(0 <= __flatten_26__21@88@01[i__32@100@01]) | live]
(push) ; 13
; [then-branch: 26 | 0 <= __flatten_26__21@88@01[i__32@100@01]]
(assert (<= 0 (Seq_index __flatten_26__21@88@01 i__32@100@01)))
; [eval] diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__32]
(set-option :timeout 10)
(push) ; 14
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1085
;  :arith-add-rows          34
;  :arith-assert-diseq      59
;  :arith-assert-lower      188
;  :arith-assert-upper      120
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               181
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1090
;  :mk-clause               332
;  :num-allocs              4076855
;  :num-checks              219
;  :propagations            152
;  :quant-instantiations    103
;  :rlimit-count            161586)
(set-option :timeout 0)
(push) ; 14
(assert (not (>= i__32@100@01 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1085
;  :arith-add-rows          34
;  :arith-assert-diseq      59
;  :arith-assert-lower      188
;  :arith-assert-upper      120
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               181
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1090
;  :mk-clause               332
;  :num-allocs              4076855
;  :num-checks              220
;  :propagations            152
;  :quant-instantiations    103
;  :rlimit-count            161595)
; [eval] |diz.Sensor_m.Main_event_state|
(set-option :timeout 10)
(push) ; 14
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1085
;  :arith-add-rows          34
;  :arith-assert-diseq      59
;  :arith-assert-lower      188
;  :arith-assert-upper      120
;  :arith-bound-prop        5
;  :arith-conflicts         7
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :binary-propagations     16
;  :conflicts               182
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 106
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               109
;  :del-clause              270
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1090
;  :mk-clause               332
;  :num-allocs              4076855
;  :num-checks              221
;  :propagations            152
;  :quant-instantiations    103
;  :rlimit-count            161643)
(pop) ; 13
(push) ; 13
; [else-branch: 26 | !(0 <= __flatten_26__21@88@01[i__32@100@01])]
(assert (not (<= 0 (Seq_index __flatten_26__21@88@01 i__32@100@01))))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 24 | !(i__32@100@01 < |__flatten_26__21@88@01| && 0 <= i__32@100@01)]
(assert (not
  (and (< i__32@100@01 (Seq_length __flatten_26__21@88@01)) (<= 0 i__32@100@01))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(set-option :timeout 0)
(push) ; 7
(assert (not (forall ((i__32@100@01 Int)) (!
  (implies
    (and
      (< i__32@100@01 (Seq_length __flatten_26__21@88@01))
      (<= 0 i__32@100@01))
    (or
      (= (Seq_index __flatten_26__21@88@01 i__32@100@01) (- 0 1))
      (and
        (<
          (Seq_index __flatten_26__21@88@01 i__32@100@01)
          (Seq_length __flatten_29__24@91@01))
        (<= 0 (Seq_index __flatten_26__21@88@01 i__32@100@01)))))
  :pattern ((Seq_index __flatten_26__21@88@01 i__32@100@01))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      66
;  :arith-assert-lower      205
;  :arith-assert-upper      130
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            27
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1131
;  :mk-clause               388
;  :num-allocs              4076855
;  :num-checks              222
;  :propagations            182
;  :quant-instantiations    107
;  :rlimit-count            162329)
(assert (forall ((i__32@100@01 Int)) (!
  (implies
    (and
      (< i__32@100@01 (Seq_length __flatten_26__21@88@01))
      (<= 0 i__32@100@01))
    (or
      (= (Seq_index __flatten_26__21@88@01 i__32@100@01) (- 0 1))
      (and
        (<
          (Seq_index __flatten_26__21@88@01 i__32@100@01)
          (Seq_length __flatten_29__24@91@01))
        (<= 0 (Seq_index __flatten_26__21@88@01 i__32@100@01)))))
  :pattern ((Seq_index __flatten_26__21@88@01 i__32@100@01))
  :qid |prog.l<no position>|)))
(declare-const $k@101@01 $Perm)
(assert ($Perm.isReadVar $k@101@01 $Perm.Write))
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      67
;  :arith-assert-lower      207
;  :arith-assert-upper      131
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            27
;  :binary-propagations     16
;  :conflicts               189
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1136
;  :mk-clause               390
;  :num-allocs              4076855
;  :num-checks              223
;  :propagations            183
;  :quant-instantiations    107
;  :rlimit-count            162797)
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@101@01 $Perm.No) (< $Perm.No $k@101@01))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      67
;  :arith-assert-lower      207
;  :arith-assert-upper      131
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            27
;  :binary-propagations     16
;  :conflicts               190
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1136
;  :mk-clause               390
;  :num-allocs              4076855
;  :num-checks              224
;  :propagations            183
;  :quant-instantiations    107
;  :rlimit-count            162847)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@76@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      67
;  :arith-assert-lower      207
;  :arith-assert-upper      131
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            27
;  :binary-propagations     16
;  :conflicts               190
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1136
;  :mk-clause               390
;  :num-allocs              4076855
;  :num-checks              225
;  :propagations            183
;  :quant-instantiations    107
;  :rlimit-count            162858)
(assert (< $k@101@01 $k@76@01))
(assert (<= $Perm.No (- $k@76@01 $k@101@01)))
(assert (<= (- $k@76@01 $k@101@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@76@01 $k@101@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot != null
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      67
;  :arith-assert-lower      209
;  :arith-assert-upper      132
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            28
;  :binary-propagations     16
;  :conflicts               191
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1139
;  :mk-clause               390
;  :num-allocs              4076855
;  :num-checks              226
;  :propagations            183
;  :quant-instantiations    107
;  :rlimit-count            163072)
(push) ; 7
(assert (not (< $Perm.No $k@76@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      67
;  :arith-assert-lower      209
;  :arith-assert-upper      132
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            28
;  :binary-propagations     16
;  :conflicts               192
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1139
;  :mk-clause               390
;  :num-allocs              4076855
;  :num-checks              227
;  :propagations            183
;  :quant-instantiations    107
;  :rlimit-count            163120)
(declare-const $k@102@01 $Perm)
(assert ($Perm.isReadVar $k@102@01 $Perm.Write))
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      68
;  :arith-assert-lower      211
;  :arith-assert-upper      133
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            28
;  :binary-propagations     16
;  :conflicts               193
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1143
;  :mk-clause               392
;  :num-allocs              4076855
;  :num-checks              228
;  :propagations            184
;  :quant-instantiations    107
;  :rlimit-count            163316)
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@102@01 $Perm.No) (< $Perm.No $k@102@01))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      68
;  :arith-assert-lower      211
;  :arith-assert-upper      133
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            28
;  :binary-propagations     16
;  :conflicts               194
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1143
;  :mk-clause               392
;  :num-allocs              4076855
;  :num-checks              229
;  :propagations            184
;  :quant-instantiations    107
;  :rlimit-count            163366)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@77@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      68
;  :arith-assert-lower      211
;  :arith-assert-upper      133
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            28
;  :binary-propagations     16
;  :conflicts               194
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1143
;  :mk-clause               392
;  :num-allocs              4076855
;  :num-checks              230
;  :propagations            184
;  :quant-instantiations    107
;  :rlimit-count            163377)
(assert (< $k@102@01 $k@77@01))
(assert (<= $Perm.No (- $k@77@01 $k@102@01)))
(assert (<= (- $k@77@01 $k@102@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@77@01 $k@102@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot_sensor != null
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      68
;  :arith-assert-lower      213
;  :arith-assert-upper      134
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            29
;  :binary-propagations     16
;  :conflicts               195
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1146
;  :mk-clause               392
;  :num-allocs              4076855
;  :num-checks              231
;  :propagations            184
;  :quant-instantiations    107
;  :rlimit-count            163591)
(push) ; 7
(assert (not (< $Perm.No $k@77@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      68
;  :arith-assert-lower      213
;  :arith-assert-upper      134
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            29
;  :binary-propagations     16
;  :conflicts               196
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1146
;  :mk-clause               392
;  :num-allocs              4076855
;  :num-checks              232
;  :propagations            184
;  :quant-instantiations    107
;  :rlimit-count            163639)
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      68
;  :arith-assert-lower      213
;  :arith-assert-upper      134
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            29
;  :binary-propagations     16
;  :conflicts               197
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1146
;  :mk-clause               392
;  :num-allocs              4076855
;  :num-checks              233
;  :propagations            184
;  :quant-instantiations    107
;  :rlimit-count            163687)
(push) ; 7
(assert (not (< $Perm.No $k@77@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      68
;  :arith-assert-lower      213
;  :arith-assert-upper      134
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            29
;  :binary-propagations     16
;  :conflicts               198
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1146
;  :mk-clause               392
;  :num-allocs              4076855
;  :num-checks              234
;  :propagations            184
;  :quant-instantiations    107
;  :rlimit-count            163735)
(declare-const $k@103@01 $Perm)
(assert ($Perm.isReadVar $k@103@01 $Perm.Write))
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      69
;  :arith-assert-lower      215
;  :arith-assert-upper      135
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            29
;  :binary-propagations     16
;  :conflicts               199
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1150
;  :mk-clause               394
;  :num-allocs              4076855
;  :num-checks              235
;  :propagations            185
;  :quant-instantiations    107
;  :rlimit-count            163931)
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@103@01 $Perm.No) (< $Perm.No $k@103@01))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      69
;  :arith-assert-lower      215
;  :arith-assert-upper      135
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            29
;  :binary-propagations     16
;  :conflicts               200
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1150
;  :mk-clause               394
;  :num-allocs              4076855
;  :num-checks              236
;  :propagations            185
;  :quant-instantiations    107
;  :rlimit-count            163981)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@78@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      69
;  :arith-assert-lower      215
;  :arith-assert-upper      135
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            29
;  :binary-propagations     16
;  :conflicts               200
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1150
;  :mk-clause               394
;  :num-allocs              4076855
;  :num-checks              237
;  :propagations            185
;  :quant-instantiations    107
;  :rlimit-count            163992)
(assert (< $k@103@01 $k@78@01))
(assert (<= $Perm.No (- $k@78@01 $k@103@01)))
(assert (<= (- $k@78@01 $k@103@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@78@01 $k@103@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot_controller != null
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      69
;  :arith-assert-lower      217
;  :arith-assert-upper      136
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               201
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1153
;  :mk-clause               394
;  :num-allocs              4076855
;  :num-checks              238
;  :propagations            185
;  :quant-instantiations    107
;  :rlimit-count            164212)
(push) ; 7
(assert (not (< $Perm.No $k@78@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      69
;  :arith-assert-lower      217
;  :arith-assert-upper      136
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               202
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1153
;  :mk-clause               394
;  :num-allocs              4076855
;  :num-checks              239
;  :propagations            185
;  :quant-instantiations    107
;  :rlimit-count            164260)
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      69
;  :arith-assert-lower      217
;  :arith-assert-upper      136
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               203
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1153
;  :mk-clause               394
;  :num-allocs              4076855
;  :num-checks              240
;  :propagations            185
;  :quant-instantiations    107
;  :rlimit-count            164308)
(push) ; 7
(assert (not (< $Perm.No $k@78@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      69
;  :arith-assert-lower      217
;  :arith-assert-upper      136
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               204
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1153
;  :mk-clause               394
;  :num-allocs              4076855
;  :num-checks              241
;  :propagations            185
;  :quant-instantiations    107
;  :rlimit-count            164356)
(declare-const $k@104@01 $Perm)
(assert ($Perm.isReadVar $k@104@01 $Perm.Write))
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      70
;  :arith-assert-lower      219
;  :arith-assert-upper      137
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               205
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1157
;  :mk-clause               396
;  :num-allocs              4076855
;  :num-checks              242
;  :propagations            186
;  :quant-instantiations    107
;  :rlimit-count            164552)
(push) ; 7
(assert (not (< $Perm.No $k@76@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      70
;  :arith-assert-lower      219
;  :arith-assert-upper      137
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               206
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1157
;  :mk-clause               396
;  :num-allocs              4076855
;  :num-checks              243
;  :propagations            186
;  :quant-instantiations    107
;  :rlimit-count            164600)
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@104@01 $Perm.No) (< $Perm.No $k@104@01))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      70
;  :arith-assert-lower      219
;  :arith-assert-upper      137
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1157
;  :mk-clause               396
;  :num-allocs              4076855
;  :num-checks              244
;  :propagations            186
;  :quant-instantiations    107
;  :rlimit-count            164650)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@79@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      70
;  :arith-assert-lower      219
;  :arith-assert-upper      137
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1157
;  :mk-clause               396
;  :num-allocs              4076855
;  :num-checks              245
;  :propagations            186
;  :quant-instantiations    107
;  :rlimit-count            164661)
(assert (< $k@104@01 $k@79@01))
(assert (<= $Perm.No (- $k@79@01 $k@104@01)))
(assert (<= (- $k@79@01 $k@104@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@79@01 $k@104@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
      $Ref.null))))
; [eval] diz.Sensor_m.Main_robot.Robot_m == diz.Sensor_m
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      70
;  :arith-assert-lower      221
;  :arith-assert-upper      138
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               208
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1160
;  :mk-clause               396
;  :num-allocs              4076855
;  :num-checks              246
;  :propagations            186
;  :quant-instantiations    107
;  :rlimit-count            164875)
(push) ; 7
(assert (not (< $Perm.No $k@76@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      70
;  :arith-assert-lower      221
;  :arith-assert-upper      138
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               209
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1160
;  :mk-clause               396
;  :num-allocs              4076855
;  :num-checks              247
;  :propagations            186
;  :quant-instantiations    107
;  :rlimit-count            164923)
(push) ; 7
(assert (not (< $Perm.No $k@79@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      70
;  :arith-assert-lower      221
;  :arith-assert-upper      138
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               210
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1160
;  :mk-clause               396
;  :num-allocs              4076855
;  :num-checks              248
;  :propagations            186
;  :quant-instantiations    107
;  :rlimit-count            164971)
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      70
;  :arith-assert-lower      221
;  :arith-assert-upper      138
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               211
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1160
;  :mk-clause               396
;  :num-allocs              4076855
;  :num-checks              249
;  :propagations            186
;  :quant-instantiations    107
;  :rlimit-count            165019)
; [eval] diz.Sensor_m.Main_robot_sensor == diz
(push) ; 7
(assert (not (< $Perm.No $k@74@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      70
;  :arith-assert-lower      221
;  :arith-assert-upper      138
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               212
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1160
;  :mk-clause               396
;  :num-allocs              4076855
;  :num-checks              250
;  :propagations            186
;  :quant-instantiations    107
;  :rlimit-count            165067)
(push) ; 7
(assert (not (< $Perm.No $k@77@01)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-add-rows          34
;  :arith-assert-diseq      70
;  :arith-assert-lower      221
;  :arith-assert-upper      138
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               213
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   67
;  :datatype-splits         86
;  :decisions               114
;  :del-clause              335
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :minimized-lits          1
;  :mk-bool-var             1160
;  :mk-clause               396
;  :num-allocs              4076855
;  :num-checks              251
;  :propagations            186
;  :quant-instantiations    107
;  :rlimit-count            165115)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 7
(assert ($Perm.isReadVar $k@93@01 $Perm.Write))
(assert ($Perm.isReadVar $k@95@01 $Perm.Write))
(assert ($Perm.isReadVar $k@96@01 $Perm.Write))
(assert ($Perm.isReadVar $k@97@01 $Perm.Write))
(assert ($Perm.isReadVar $k@98@01 $Perm.Write))
(assert (= $t@92@01 ($Snap.combine ($Snap.first $t@92@01) ($Snap.second $t@92@01))))
(assert (<= $Perm.No $k@93@01))
(assert (<= $k@93@01 $Perm.Write))
(assert (implies (< $Perm.No $k@93@01) (not (= diz@35@01 $Ref.null))))
(assert (=
  ($Snap.second $t@92@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@92@01))
    ($Snap.second ($Snap.second $t@92@01)))))
(assert (= ($Snap.first ($Snap.second $t@92@01)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@92@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@92@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@92@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))
  $Snap.unit))
(assert (forall ((i__32@94@01 Int)) (!
  (implies
    (and
      (<
        i__32@94@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
      (<= 0 i__32@94@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          i__32@94@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__32@94@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__32@94@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__32@94@01))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
(assert (<= $Perm.No $k@95@01))
(assert (<= $k@95@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@95@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))
(assert (<= $Perm.No $k@96@01))
(assert (<= $k@96@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@96@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))
(assert (<= $Perm.No $k@97@01))
(assert (<= $k@97@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@97@01)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))))
(assert (<= $Perm.No $k@98@01))
(assert (<= $k@98@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@98@01)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
  diz@35@01))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 10)
(check-sat)
; unknown
; Loop head block: Follow loop-internal edges
; [eval] diz.Sensor_m.Main_process_state[0] != -1 || diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_process_state[0] != -1
; [eval] diz.Sensor_m.Main_process_state[0]
(push) ; 8
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1523
;  :arith-add-rows          34
;  :arith-assert-diseq      75
;  :arith-assert-lower      235
;  :arith-assert-upper      150
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               215
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 182
;  :datatype-occurs-check   89
;  :datatype-splits         142
;  :decisions               182
;  :del-clause              347
;  :final-checks            35
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1289
;  :mk-clause               409
;  :num-allocs              4403714
;  :num-checks              254
;  :propagations            196
;  :quant-instantiations    116
;  :rlimit-count            171040)
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1523
;  :arith-add-rows          34
;  :arith-assert-diseq      75
;  :arith-assert-lower      235
;  :arith-assert-upper      150
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               215
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 182
;  :datatype-occurs-check   89
;  :datatype-splits         142
;  :decisions               182
;  :del-clause              347
;  :final-checks            35
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1289
;  :mk-clause               409
;  :num-allocs              4403714
;  :num-checks              255
;  :propagations            196
;  :quant-instantiations    116
;  :rlimit-count            171055)
; [eval] -1
(push) ; 8
; [then-branch: 27 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1 | live]
; [else-branch: 27 | First:(Second:(Second:(Second:($t@92@01))))[0] == -1 | live]
(push) ; 9
; [then-branch: 27 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 27 | First:(Second:(Second:(Second:($t@92@01))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    0)
  (- 0 1)))
; [eval] diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_event_state[0]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1524
;  :arith-add-rows          34
;  :arith-assert-diseq      75
;  :arith-assert-lower      235
;  :arith-assert-upper      150
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               216
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 182
;  :datatype-occurs-check   89
;  :datatype-splits         142
;  :decisions               182
;  :del-clause              347
;  :final-checks            35
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1290
;  :mk-clause               409
;  :num-allocs              4403714
;  :num-checks              256
;  :propagations            196
;  :quant-instantiations    116
;  :rlimit-count            171246)
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1524
;  :arith-add-rows          34
;  :arith-assert-diseq      75
;  :arith-assert-lower      235
;  :arith-assert-upper      150
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        5
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               216
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 182
;  :datatype-occurs-check   89
;  :datatype-splits         142
;  :decisions               182
;  :del-clause              347
;  :final-checks            35
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1290
;  :mk-clause               409
;  :num-allocs              4403714
;  :num-checks              257
;  :propagations            196
;  :quant-instantiations    116
;  :rlimit-count            171261)
; [eval] -2
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 8
(assert (not (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
          0)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1658
;  :arith-add-rows          34
;  :arith-assert-diseq      78
;  :arith-assert-lower      246
;  :arith-assert-upper      155
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            36
;  :binary-propagations     16
;  :conflicts               216
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 212
;  :datatype-occurs-check   100
;  :datatype-splits         170
;  :decisions               210
;  :del-clause              372
;  :final-checks            38
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1342
;  :mk-clause               434
;  :num-allocs              4403714
;  :num-checks              258
;  :propagations            209
;  :quant-instantiations    120
;  :rlimit-count            172689
;  :time                    0.00)
(push) ; 8
(assert (not (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
        0)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      78
;  :arith-assert-lower      246
;  :arith-assert-upper      155
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            36
;  :binary-propagations     16
;  :conflicts               216
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              372
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1371
;  :mk-clause               434
;  :num-allocs              4403714
;  :num-checks              259
;  :propagations            212
;  :quant-instantiations    120
;  :rlimit-count            173853
;  :time                    0.00)
; [then-branch: 28 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@92@01))))))[0] != -2 | live]
; [else-branch: 28 | !(First:(Second:(Second:(Second:($t@92@01))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@92@01))))))[0] != -2) | live]
(push) ; 8
; [then-branch: 28 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@92@01))))))[0] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
        0)
      (- 0 2)))))
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      78
;  :arith-assert-lower      246
;  :arith-assert-upper      155
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            36
;  :binary-propagations     16
;  :conflicts               217
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              372
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1373
;  :mk-clause               435
;  :num-allocs              4403714
;  :num-checks              260
;  :propagations            212
;  :quant-instantiations    120
;  :rlimit-count            174131)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      78
;  :arith-assert-lower      246
;  :arith-assert-upper      155
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            36
;  :binary-propagations     16
;  :conflicts               218
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              372
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1373
;  :mk-clause               435
;  :num-allocs              4403714
;  :num-checks              261
;  :propagations            212
;  :quant-instantiations    120
;  :rlimit-count            174179)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@105@01 Int)
(push) ; 9
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 10
; [then-branch: 29 | 0 <= i@105@01 | live]
; [else-branch: 29 | !(0 <= i@105@01) | live]
(push) ; 11
; [then-branch: 29 | 0 <= i@105@01]
(assert (<= 0 i@105@01))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 29 | !(0 <= i@105@01)]
(assert (not (<= 0 i@105@01)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 30 | i@105@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i@105@01 | live]
; [else-branch: 30 | !(i@105@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i@105@01) | live]
(push) ; 11
; [then-branch: 30 | i@105@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i@105@01]
(assert (and
  (<
    i@105@01
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
  (<= 0 i@105@01)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i@105@01 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      78
;  :arith-assert-lower      247
;  :arith-assert-upper      156
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            36
;  :binary-propagations     16
;  :conflicts               218
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              372
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1375
;  :mk-clause               435
;  :num-allocs              4403714
;  :num-checks              262
;  :propagations            212
;  :quant-instantiations    120
;  :rlimit-count            174315)
; [eval] -1
(push) ; 12
; [then-branch: 31 | First:(Second:(Second:(Second:($t@92@01))))[i@105@01] == -1 | live]
; [else-branch: 31 | First:(Second:(Second:(Second:($t@92@01))))[i@105@01] != -1 | live]
(push) ; 13
; [then-branch: 31 | First:(Second:(Second:(Second:($t@92@01))))[i@105@01] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i@105@01)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 31 | First:(Second:(Second:(Second:($t@92@01))))[i@105@01] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      i@105@01)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@105@01 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      79
;  :arith-assert-lower      250
;  :arith-assert-upper      157
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            36
;  :binary-propagations     16
;  :conflicts               218
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              372
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1381
;  :mk-clause               439
;  :num-allocs              4403714
;  :num-checks              263
;  :propagations            214
;  :quant-instantiations    121
;  :rlimit-count            174547)
(push) ; 14
; [then-branch: 32 | 0 <= First:(Second:(Second:(Second:($t@92@01))))[i@105@01] | live]
; [else-branch: 32 | !(0 <= First:(Second:(Second:(Second:($t@92@01))))[i@105@01]) | live]
(push) ; 15
; [then-branch: 32 | 0 <= First:(Second:(Second:(Second:($t@92@01))))[i@105@01]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i@105@01)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 16
(assert (not (>= i@105@01 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      79
;  :arith-assert-lower      250
;  :arith-assert-upper      157
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            36
;  :binary-propagations     16
;  :conflicts               218
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              372
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1381
;  :mk-clause               439
;  :num-allocs              4403714
;  :num-checks              264
;  :propagations            214
;  :quant-instantiations    121
;  :rlimit-count            174661)
; [eval] |diz.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 32 | !(0 <= First:(Second:(Second:(Second:($t@92@01))))[i@105@01])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      i@105@01))))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 30 | !(i@105@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i@105@01)]
(assert (not
  (and
    (<
      i@105@01
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
    (<= 0 i@105@01))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 9
(assert (not (forall ((i@105@01 Int)) (!
  (implies
    (and
      (<
        i@105@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
      (<= 0 i@105@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          i@105@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i@105@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i@105@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i@105@01))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      81
;  :arith-assert-lower      251
;  :arith-assert-upper      158
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            36
;  :binary-propagations     16
;  :conflicts               219
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1389
;  :mk-clause               453
;  :num-allocs              4403714
;  :num-checks              265
;  :propagations            216
;  :quant-instantiations    122
;  :rlimit-count            175107)
(assert (forall ((i@105@01 Int)) (!
  (implies
    (and
      (<
        i@105@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
      (<= 0 i@105@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          i@105@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i@105@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i@105@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i@105@01))
  :qid |prog.l<no position>|)))
(declare-const $k@106@01 $Perm)
(assert ($Perm.isReadVar $k@106@01 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@106@01 $Perm.No) (< $Perm.No $k@106@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      82
;  :arith-assert-lower      253
;  :arith-assert-upper      159
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            36
;  :binary-propagations     16
;  :conflicts               220
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1394
;  :mk-clause               455
;  :num-allocs              4403714
;  :num-checks              266
;  :propagations            217
;  :quant-instantiations    122
;  :rlimit-count            175667)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@95@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.07s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      82
;  :arith-assert-lower      253
;  :arith-assert-upper      159
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            36
;  :binary-propagations     16
;  :conflicts               220
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1394
;  :mk-clause               455
;  :num-allocs              4403714
;  :num-checks              267
;  :propagations            217
;  :quant-instantiations    122
;  :rlimit-count            175678)
(assert (< $k@106@01 $k@95@01))
(assert (<= $Perm.No (- $k@95@01 $k@106@01)))
(assert (<= (- $k@95@01 $k@106@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@95@01 $k@106@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
; [eval] diz.Main_robot != null
(push) ; 9
(assert (not (< $Perm.No $k@95@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      82
;  :arith-assert-lower      255
;  :arith-assert-upper      160
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            37
;  :binary-propagations     16
;  :conflicts               221
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1397
;  :mk-clause               455
;  :num-allocs              4403714
;  :num-checks              268
;  :propagations            217
;  :quant-instantiations    122
;  :rlimit-count            175892)
(declare-const $k@107@01 $Perm)
(assert ($Perm.isReadVar $k@107@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@107@01 $Perm.No) (< $Perm.No $k@107@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      83
;  :arith-assert-lower      257
;  :arith-assert-upper      161
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            37
;  :binary-propagations     16
;  :conflicts               222
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1401
;  :mk-clause               457
;  :num-allocs              4403714
;  :num-checks              269
;  :propagations            218
;  :quant-instantiations    122
;  :rlimit-count            176091)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@96@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      83
;  :arith-assert-lower      257
;  :arith-assert-upper      161
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            37
;  :binary-propagations     16
;  :conflicts               222
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1401
;  :mk-clause               457
;  :num-allocs              4403714
;  :num-checks              270
;  :propagations            218
;  :quant-instantiations    122
;  :rlimit-count            176102)
(assert (< $k@107@01 $k@96@01))
(assert (<= $Perm.No (- $k@96@01 $k@107@01)))
(assert (<= (- $k@96@01 $k@107@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@96@01 $k@107@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
; [eval] diz.Main_robot_sensor != null
(push) ; 9
(assert (not (< $Perm.No $k@96@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      83
;  :arith-assert-lower      259
;  :arith-assert-upper      162
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            37
;  :binary-propagations     16
;  :conflicts               223
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1404
;  :mk-clause               457
;  :num-allocs              4403714
;  :num-checks              271
;  :propagations            218
;  :quant-instantiations    122
;  :rlimit-count            176310)
(push) ; 9
(assert (not (< $Perm.No $k@96@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      83
;  :arith-assert-lower      259
;  :arith-assert-upper      162
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            37
;  :binary-propagations     16
;  :conflicts               224
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1404
;  :mk-clause               457
;  :num-allocs              4403714
;  :num-checks              272
;  :propagations            218
;  :quant-instantiations    122
;  :rlimit-count            176358)
(declare-const $k@108@01 $Perm)
(assert ($Perm.isReadVar $k@108@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@108@01 $Perm.No) (< $Perm.No $k@108@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      84
;  :arith-assert-lower      261
;  :arith-assert-upper      163
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            37
;  :binary-propagations     16
;  :conflicts               225
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1408
;  :mk-clause               459
;  :num-allocs              4403714
;  :num-checks              273
;  :propagations            219
;  :quant-instantiations    122
;  :rlimit-count            176556)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@97@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      84
;  :arith-assert-lower      261
;  :arith-assert-upper      163
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            37
;  :binary-propagations     16
;  :conflicts               225
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1408
;  :mk-clause               459
;  :num-allocs              4403714
;  :num-checks              274
;  :propagations            219
;  :quant-instantiations    122
;  :rlimit-count            176567)
(assert (< $k@108@01 $k@97@01))
(assert (<= $Perm.No (- $k@97@01 $k@108@01)))
(assert (<= (- $k@97@01 $k@108@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@97@01 $k@108@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
; [eval] diz.Main_robot_controller != null
(push) ; 9
(assert (not (< $Perm.No $k@97@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      84
;  :arith-assert-lower      263
;  :arith-assert-upper      164
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :binary-propagations     16
;  :conflicts               226
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1411
;  :mk-clause               459
;  :num-allocs              4403714
;  :num-checks              275
;  :propagations            219
;  :quant-instantiations    122
;  :rlimit-count            176781)
(push) ; 9
(assert (not (< $Perm.No $k@97@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      84
;  :arith-assert-lower      263
;  :arith-assert-upper      164
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :binary-propagations     16
;  :conflicts               227
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1411
;  :mk-clause               459
;  :num-allocs              4403714
;  :num-checks              276
;  :propagations            219
;  :quant-instantiations    122
;  :rlimit-count            176829)
(declare-const $k@109@01 $Perm)
(assert ($Perm.isReadVar $k@109@01 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No $k@95@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      85
;  :arith-assert-lower      265
;  :arith-assert-upper      165
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :binary-propagations     16
;  :conflicts               228
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1415
;  :mk-clause               461
;  :num-allocs              4403714
;  :num-checks              277
;  :propagations            220
;  :quant-instantiations    122
;  :rlimit-count            177026)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@109@01 $Perm.No) (< $Perm.No $k@109@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      85
;  :arith-assert-lower      265
;  :arith-assert-upper      165
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :binary-propagations     16
;  :conflicts               229
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1415
;  :mk-clause               461
;  :num-allocs              4403714
;  :num-checks              278
;  :propagations            220
;  :quant-instantiations    122
;  :rlimit-count            177076)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@98@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      85
;  :arith-assert-lower      265
;  :arith-assert-upper      165
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :binary-propagations     16
;  :conflicts               229
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1415
;  :mk-clause               461
;  :num-allocs              4403714
;  :num-checks              279
;  :propagations            220
;  :quant-instantiations    122
;  :rlimit-count            177087)
(assert (< $k@109@01 $k@98@01))
(assert (<= $Perm.No (- $k@98@01 $k@109@01)))
(assert (<= (- $k@98@01 $k@109@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@98@01 $k@109@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
      $Ref.null))))
; [eval] diz.Main_robot.Robot_m == diz
(push) ; 9
(assert (not (< $Perm.No $k@95@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      85
;  :arith-assert-lower      267
;  :arith-assert-upper      166
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :binary-propagations     16
;  :conflicts               230
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1418
;  :mk-clause               461
;  :num-allocs              4403714
;  :num-checks              280
;  :propagations            220
;  :quant-instantiations    122
;  :rlimit-count            177295)
(push) ; 9
(assert (not (< $Perm.No $k@98@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1786
;  :arith-add-rows          34
;  :arith-assert-diseq      85
;  :arith-assert-lower      267
;  :arith-assert-upper      166
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :binary-propagations     16
;  :conflicts               231
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1418
;  :mk-clause               461
;  :num-allocs              4403714
;  :num-checks              281
;  :propagations            220
;  :quant-instantiations    122
;  :rlimit-count            177343)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
                      ($Snap.combine
                        $Snap.unit
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))
                                ($Snap.combine
                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))
                                  $Snap.unit))))))))))))))))) ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) globals@36@01))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1820
;  :arith-add-rows          34
;  :arith-assert-diseq      85
;  :arith-assert-lower      267
;  :arith-assert-upper      166
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :binary-propagations     16
;  :conflicts               232
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1419
;  :mk-clause               461
;  :num-allocs              4403714
;  :num-checks              282
;  :propagations            220
;  :quant-instantiations    122
;  :rlimit-count            178036)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1820
;  :arith-add-rows          34
;  :arith-assert-diseq      85
;  :arith-assert-lower      267
;  :arith-assert-upper      166
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :binary-propagations     16
;  :conflicts               233
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 242
;  :datatype-occurs-check   111
;  :datatype-splits         198
;  :decisions               237
;  :del-clause              390
;  :final-checks            41
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             1419
;  :mk-clause               461
;  :num-allocs              4403714
;  :num-checks              283
;  :propagations            220
;  :quant-instantiations    122
;  :rlimit-count            178084)
(declare-const $t@110@01 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1972
;  :arith-add-rows          35
;  :arith-assert-diseq      88
;  :arith-assert-lower      278
;  :arith-assert-upper      171
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        142
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        5
;  :arith-pivots            42
;  :binary-propagations     16
;  :conflicts               234
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              422
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1469
;  :mk-clause               485
;  :num-allocs              4576083
;  :num-checks              285
;  :propagations            233
;  :quant-instantiations    127
;  :rlimit-count            179372)
(assert (= $t@110@01 ($Snap.combine ($Snap.first $t@110@01) ($Snap.second $t@110@01))))
(assert (= ($Snap.first $t@110@01) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@110@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@110@01))
    ($Snap.second ($Snap.second $t@110@01)))))
(assert (= ($Snap.first ($Snap.second $t@110@01)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@110@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@110@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@110@01))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@110@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@111@01 Int)
(push) ; 9
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 10
; [then-branch: 33 | 0 <= i@111@01 | live]
; [else-branch: 33 | !(0 <= i@111@01) | live]
(push) ; 11
; [then-branch: 33 | 0 <= i@111@01]
(assert (<= 0 i@111@01))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 33 | !(0 <= i@111@01)]
(assert (not (<= 0 i@111@01)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 34 | i@111@01 < |First:(Second:(Second:(Second:($t@110@01))))| && 0 <= i@111@01 | live]
; [else-branch: 34 | !(i@111@01 < |First:(Second:(Second:(Second:($t@110@01))))| && 0 <= i@111@01) | live]
(push) ; 11
; [then-branch: 34 | i@111@01 < |First:(Second:(Second:(Second:($t@110@01))))| && 0 <= i@111@01]
(assert (and
  (<
    i@111@01
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))
  (<= 0 i@111@01)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i@111@01 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2022
;  :arith-add-rows          35
;  :arith-assert-diseq      88
;  :arith-assert-lower      283
;  :arith-assert-upper      174
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        144
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        5
;  :arith-pivots            42
;  :binary-propagations     16
;  :conflicts               234
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              422
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1495
;  :mk-clause               485
;  :num-allocs              4576083
;  :num-checks              286
;  :propagations            233
;  :quant-instantiations    131
;  :rlimit-count            180675)
; [eval] -1
(push) ; 12
; [then-branch: 35 | First:(Second:(Second:(Second:($t@110@01))))[i@111@01] == -1 | live]
; [else-branch: 35 | First:(Second:(Second:(Second:($t@110@01))))[i@111@01] != -1 | live]
(push) ; 13
; [then-branch: 35 | First:(Second:(Second:(Second:($t@110@01))))[i@111@01] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
    i@111@01)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 35 | First:(Second:(Second:(Second:($t@110@01))))[i@111@01] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
      i@111@01)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@111@01 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2022
;  :arith-add-rows          35
;  :arith-assert-diseq      88
;  :arith-assert-lower      283
;  :arith-assert-upper      174
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        144
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        5
;  :arith-pivots            42
;  :binary-propagations     16
;  :conflicts               234
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              422
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1496
;  :mk-clause               485
;  :num-allocs              4576083
;  :num-checks              287
;  :propagations            233
;  :quant-instantiations    131
;  :rlimit-count            180850)
(push) ; 14
; [then-branch: 36 | 0 <= First:(Second:(Second:(Second:($t@110@01))))[i@111@01] | live]
; [else-branch: 36 | !(0 <= First:(Second:(Second:(Second:($t@110@01))))[i@111@01]) | live]
(push) ; 15
; [then-branch: 36 | 0 <= First:(Second:(Second:(Second:($t@110@01))))[i@111@01]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
    i@111@01)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 16
(assert (not (>= i@111@01 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2022
;  :arith-add-rows          35
;  :arith-assert-diseq      89
;  :arith-assert-lower      286
;  :arith-assert-upper      174
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        5
;  :arith-pivots            42
;  :binary-propagations     16
;  :conflicts               234
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              422
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1499
;  :mk-clause               486
;  :num-allocs              4576083
;  :num-checks              288
;  :propagations            233
;  :quant-instantiations    131
;  :rlimit-count            180974)
; [eval] |diz.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 36 | !(0 <= First:(Second:(Second:(Second:($t@110@01))))[i@111@01])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
      i@111@01))))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 34 | !(i@111@01 < |First:(Second:(Second:(Second:($t@110@01))))| && 0 <= i@111@01)]
(assert (not
  (and
    (<
      i@111@01
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))
    (<= 0 i@111@01))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@111@01 Int)) (!
  (implies
    (and
      (<
        i@111@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))
      (<= 0 i@111@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
          i@111@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
            i@111@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
            i@111@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
    i@111@01))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))
(declare-const $k@112@01 $Perm)
(assert ($Perm.isReadVar $k@112@01 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@112@01 $Perm.No) (< $Perm.No $k@112@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2027
;  :arith-add-rows          35
;  :arith-assert-diseq      90
;  :arith-assert-lower      288
;  :arith-assert-upper      175
;  :arith-bound-prop        5
;  :arith-conflicts         10
;  :arith-eq-adapter        146
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        5
;  :arith-pivots            42
;  :binary-propagations     16
;  :conflicts               235
;  :datatype-accessor-ax    159
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1505
;  :mk-clause               488
;  :num-allocs              4576083
;  :num-checks              289
;  :propagations            234
;  :quant-instantiations    131
;  :rlimit-count            181743)
(declare-const $t@113@01 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@95@01 $k@106@01))
    (=
      $t@113@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))
  (implies
    (< $Perm.No $k@112@01)
    (=
      $t@113@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))))
(assert (<= $Perm.No (+ (- $k@95@01 $k@106@01) $k@112@01)))
(assert (<= (+ (- $k@95@01 $k@106@01) $k@112@01) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@95@01 $k@106@01) $k@112@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))
  $Snap.unit))
; [eval] diz.Main_robot != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@95@01 $k@106@01) $k@112@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2037
;  :arith-add-rows          36
;  :arith-assert-diseq      90
;  :arith-assert-lower      289
;  :arith-assert-upper      177
;  :arith-bound-prop        5
;  :arith-conflicts         11
;  :arith-eq-adapter        146
;  :arith-fixed-eqs         37
;  :arith-offset-eqs        5
;  :arith-pivots            42
;  :binary-propagations     16
;  :conflicts               236
;  :datatype-accessor-ax    160
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1513
;  :mk-clause               488
;  :num-allocs              4576083
;  :num-checks              290
;  :propagations            234
;  :quant-instantiations    132
;  :rlimit-count            182423)
(assert (not (= $t@113@01 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))))
(declare-const $k@114@01 $Perm)
(assert ($Perm.isReadVar $k@114@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@114@01 $Perm.No) (< $Perm.No $k@114@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2043
;  :arith-add-rows          36
;  :arith-assert-diseq      91
;  :arith-assert-lower      291
;  :arith-assert-upper      178
;  :arith-bound-prop        5
;  :arith-conflicts         11
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         37
;  :arith-offset-eqs        5
;  :arith-pivots            42
;  :binary-propagations     16
;  :conflicts               237
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1519
;  :mk-clause               490
;  :num-allocs              4576083
;  :num-checks              291
;  :propagations            235
;  :quant-instantiations    132
;  :rlimit-count            182858)
(declare-const $t@115@01 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@96@01 $k@107@01))
    (=
      $t@115@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))
  (implies
    (< $Perm.No $k@114@01)
    (=
      $t@115@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))))))
(assert (<= $Perm.No (+ (- $k@96@01 $k@107@01) $k@114@01)))
(assert (<= (+ (- $k@96@01 $k@107@01) $k@114@01) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@96@01 $k@107@01) $k@114@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot_sensor != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@96@01 $k@107@01) $k@114@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2053
;  :arith-add-rows          37
;  :arith-assert-diseq      91
;  :arith-assert-lower      292
;  :arith-assert-upper      180
;  :arith-bound-prop        5
;  :arith-conflicts         12
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        5
;  :arith-pivots            45
;  :binary-propagations     16
;  :conflicts               238
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1527
;  :mk-clause               490
;  :num-allocs              4576083
;  :num-checks              292
;  :propagations            235
;  :quant-instantiations    133
;  :rlimit-count            183499)
(assert (not (= $t@115@01 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@96@01 $k@107@01) $k@114@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2058
;  :arith-add-rows          38
;  :arith-assert-diseq      91
;  :arith-assert-lower      292
;  :arith-assert-upper      181
;  :arith-bound-prop        5
;  :arith-conflicts         13
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         39
;  :arith-offset-eqs        5
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               239
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1529
;  :mk-clause               490
;  :num-allocs              4576083
;  :num-checks              293
;  :propagations            235
;  :quant-instantiations    133
;  :rlimit-count            183849)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))))))
(declare-const $k@116@01 $Perm)
(assert ($Perm.isReadVar $k@116@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@116@01 $Perm.No) (< $Perm.No $k@116@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2063
;  :arith-add-rows          38
;  :arith-assert-diseq      92
;  :arith-assert-lower      294
;  :arith-assert-upper      182
;  :arith-bound-prop        5
;  :arith-conflicts         13
;  :arith-eq-adapter        148
;  :arith-fixed-eqs         39
;  :arith-offset-eqs        5
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               240
;  :datatype-accessor-ax    164
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1534
;  :mk-clause               492
;  :num-allocs              4576083
;  :num-checks              294
;  :propagations            236
;  :quant-instantiations    133
;  :rlimit-count            184270)
(declare-const $t@117@01 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@97@01 $k@108@01))
    (=
      $t@117@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))
  (implies
    (< $Perm.No $k@116@01)
    (=
      $t@117@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@97@01 $k@108@01) $k@116@01)))
(assert (<= (+ (- $k@97@01 $k@108@01) $k@116@01) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@97@01 $k@108@01) $k@116@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot_controller != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@97@01 $k@108@01) $k@116@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2073
;  :arith-add-rows          39
;  :arith-assert-diseq      92
;  :arith-assert-lower      295
;  :arith-assert-upper      184
;  :arith-bound-prop        5
;  :arith-conflicts         14
;  :arith-eq-adapter        148
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        5
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               241
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1542
;  :mk-clause               492
;  :num-allocs              4576083
;  :num-checks              295
;  :propagations            236
;  :quant-instantiations    134
;  :rlimit-count            185050)
(assert (not (= $t@117@01 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@97@01 $k@108@01) $k@116@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2079
;  :arith-add-rows          39
;  :arith-assert-diseq      92
;  :arith-assert-lower      295
;  :arith-assert-upper      185
;  :arith-bound-prop        5
;  :arith-conflicts         15
;  :arith-eq-adapter        148
;  :arith-fixed-eqs         41
;  :arith-offset-eqs        5
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               242
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1545
;  :mk-clause               492
;  :num-allocs              4576083
;  :num-checks              296
;  :propagations            236
;  :quant-instantiations    134
;  :rlimit-count            185422)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@95@01 $k@106@01) $k@112@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2084
;  :arith-add-rows          39
;  :arith-assert-diseq      92
;  :arith-assert-lower      295
;  :arith-assert-upper      186
;  :arith-bound-prop        5
;  :arith-conflicts         16
;  :arith-eq-adapter        148
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        5
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               243
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1547
;  :mk-clause               492
;  :num-allocs              4576083
;  :num-checks              297
;  :propagations            236
;  :quant-instantiations    134
;  :rlimit-count            185759)
(declare-const $k@118@01 $Perm)
(assert ($Perm.isReadVar $k@118@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@118@01 $Perm.No) (< $Perm.No $k@118@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2084
;  :arith-add-rows          39
;  :arith-assert-diseq      93
;  :arith-assert-lower      297
;  :arith-assert-upper      187
;  :arith-bound-prop        5
;  :arith-conflicts         16
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        5
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               244
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1551
;  :mk-clause               494
;  :num-allocs              4576083
;  :num-checks              298
;  :propagations            237
;  :quant-instantiations    134
;  :rlimit-count            185957)
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
  $t@113@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2084
;  :arith-add-rows          39
;  :arith-assert-diseq      93
;  :arith-assert-lower      297
;  :arith-assert-upper      187
;  :arith-bound-prop        5
;  :arith-conflicts         16
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        5
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               244
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1551
;  :mk-clause               494
;  :num-allocs              4576083
;  :num-checks              299
;  :propagations            237
;  :quant-instantiations    134
;  :rlimit-count            185968)
(declare-const $t@119@01 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@98@01 $k@109@01))
    (=
      $t@119@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))))
  (implies
    (< $Perm.No $k@118@01)
    (=
      $t@119@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01))))))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@98@01 $k@109@01) $k@118@01)))
(assert (<= (+ (- $k@98@01 $k@109@01) $k@118@01) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@98@01 $k@109@01) $k@118@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot.Robot_m == diz
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@95@01 $k@106@01) $k@112@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2090
;  :arith-add-rows          39
;  :arith-assert-diseq      93
;  :arith-assert-lower      298
;  :arith-assert-upper      189
;  :arith-bound-prop        5
;  :arith-conflicts         17
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         43
;  :arith-offset-eqs        5
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               245
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1558
;  :mk-clause               494
;  :num-allocs              4576083
;  :num-checks              300
;  :propagations            237
;  :quant-instantiations    135
;  :rlimit-count            186549)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
  $t@113@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2090
;  :arith-add-rows          39
;  :arith-assert-diseq      93
;  :arith-assert-lower      298
;  :arith-assert-upper      189
;  :arith-bound-prop        5
;  :arith-conflicts         17
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         43
;  :arith-offset-eqs        5
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               245
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1558
;  :mk-clause               494
;  :num-allocs              4576083
;  :num-checks              301
;  :propagations            237
;  :quant-instantiations    135
;  :rlimit-count            186560)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@98@01 $k@109@01) $k@118@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2090
;  :arith-add-rows          40
;  :arith-assert-diseq      93
;  :arith-assert-lower      298
;  :arith-assert-upper      190
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         44
;  :arith-offset-eqs        5
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               246
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 272
;  :datatype-occurs-check   145
;  :datatype-splits         226
;  :decisions               265
;  :del-clause              423
;  :final-checks            44
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             1559
;  :mk-clause               494
;  :num-allocs              4576083
;  :num-checks              302
;  :propagations            237
;  :quant-instantiations    135
;  :rlimit-count            186669)
(assert (= $t@119@01 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@110@01 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) globals@36@01))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2388
;  :arith-add-rows          42
;  :arith-assert-diseq      100
;  :arith-assert-lower      325
;  :arith-assert-upper      203
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        5
;  :arith-pivots            59
;  :binary-propagations     16
;  :conflicts               248
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 328
;  :datatype-occurs-check   180
;  :datatype-splits         260
;  :decisions               318
;  :del-clause              487
;  :final-checks            47
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1654
;  :mk-clause               551
;  :num-allocs              4754112
;  :num-checks              304
;  :propagations            264
;  :quant-instantiations    145
;  :rlimit-count            188681)
(declare-const $t@120@01 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; Loop head block: Re-establish invariant
(declare-const $k@121@01 $Perm)
(assert ($Perm.isReadVar $k@121@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@121@01 $Perm.No) (< $Perm.No $k@121@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      105
;  :arith-assert-lower      342
;  :arith-assert-upper      211
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               249
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1723
;  :mk-clause               583
;  :num-allocs              4754112
;  :num-checks              306
;  :propagations            282
;  :quant-instantiations    151
;  :rlimit-count            190330)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@93@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      105
;  :arith-assert-lower      342
;  :arith-assert-upper      211
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               249
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1723
;  :mk-clause               583
;  :num-allocs              4754112
;  :num-checks              307
;  :propagations            282
;  :quant-instantiations    151
;  :rlimit-count            190341)
(assert (< $k@121@01 $k@93@01))
(assert (<= $Perm.No (- $k@93@01 $k@121@01)))
(assert (<= (- $k@93@01 $k@121@01) $Perm.Write))
(assert (implies (< $Perm.No (- $k@93@01 $k@121@01)) (not (= diz@35@01 $Ref.null))))
; [eval] diz.Sensor_m != null
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      105
;  :arith-assert-lower      344
;  :arith-assert-upper      212
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               250
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1726
;  :mk-clause               583
;  :num-allocs              4754112
;  :num-checks              308
;  :propagations            282
;  :quant-instantiations    151
;  :rlimit-count            190555)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      105
;  :arith-assert-lower      344
;  :arith-assert-upper      212
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               251
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1726
;  :mk-clause               583
;  :num-allocs              4754112
;  :num-checks              309
;  :propagations            282
;  :quant-instantiations    151
;  :rlimit-count            190603)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      105
;  :arith-assert-lower      344
;  :arith-assert-upper      212
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               252
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1726
;  :mk-clause               583
;  :num-allocs              4754112
;  :num-checks              310
;  :propagations            282
;  :quant-instantiations    151
;  :rlimit-count            190651)
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      105
;  :arith-assert-lower      344
;  :arith-assert-upper      212
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               253
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1726
;  :mk-clause               583
;  :num-allocs              4754112
;  :num-checks              311
;  :propagations            282
;  :quant-instantiations    151
;  :rlimit-count            190699)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      105
;  :arith-assert-lower      344
;  :arith-assert-upper      212
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               254
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1726
;  :mk-clause               583
;  :num-allocs              4754112
;  :num-checks              312
;  :propagations            282
;  :quant-instantiations    151
;  :rlimit-count            190747)
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      105
;  :arith-assert-lower      344
;  :arith-assert-upper      212
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               255
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1726
;  :mk-clause               583
;  :num-allocs              4754112
;  :num-checks              313
;  :propagations            282
;  :quant-instantiations    151
;  :rlimit-count            190795)
; [eval] (forall i__32: Int :: { diz.Sensor_m.Main_process_state[i__32] } 0 <= i__32 && i__32 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__32] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|)
(declare-const i__32@122@01 Int)
(push) ; 9
; [eval] 0 <= i__32 && i__32 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__32] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__32 && i__32 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__32
(push) ; 10
; [then-branch: 37 | 0 <= i__32@122@01 | live]
; [else-branch: 37 | !(0 <= i__32@122@01) | live]
(push) ; 11
; [then-branch: 37 | 0 <= i__32@122@01]
(assert (<= 0 i__32@122@01))
; [eval] i__32 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 12
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      105
;  :arith-assert-lower      345
;  :arith-assert-upper      212
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               256
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1727
;  :mk-clause               583
;  :num-allocs              4754112
;  :num-checks              314
;  :propagations            282
;  :quant-instantiations    151
;  :rlimit-count            190895)
(pop) ; 11
(push) ; 11
; [else-branch: 37 | !(0 <= i__32@122@01)]
(assert (not (<= 0 i__32@122@01)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 38 | i__32@122@01 < |First:(Second:(Second:(Second:($t@110@01))))| && 0 <= i__32@122@01 | live]
; [else-branch: 38 | !(i__32@122@01 < |First:(Second:(Second:(Second:($t@110@01))))| && 0 <= i__32@122@01) | live]
(push) ; 11
; [then-branch: 38 | i__32@122@01 < |First:(Second:(Second:(Second:($t@110@01))))| && 0 <= i__32@122@01]
(assert (and
  (<
    i__32@122@01
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))
  (<= 0 i__32@122@01)))
; [eval] diz.Sensor_m.Main_process_state[i__32] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__32] == -1
; [eval] diz.Sensor_m.Main_process_state[i__32]
(push) ; 12
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      105
;  :arith-assert-lower      346
;  :arith-assert-upper      213
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               257
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1729
;  :mk-clause               583
;  :num-allocs              4754112
;  :num-checks              315
;  :propagations            282
;  :quant-instantiations    151
;  :rlimit-count            191052)
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i__32@122@01 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      105
;  :arith-assert-lower      346
;  :arith-assert-upper      213
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               257
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1729
;  :mk-clause               583
;  :num-allocs              4754112
;  :num-checks              316
;  :propagations            282
;  :quant-instantiations    151
;  :rlimit-count            191061)
; [eval] -1
(push) ; 12
; [then-branch: 39 | First:(Second:(Second:(Second:($t@110@01))))[i__32@122@01] == -1 | live]
; [else-branch: 39 | First:(Second:(Second:(Second:($t@110@01))))[i__32@122@01] != -1 | live]
(push) ; 13
; [then-branch: 39 | First:(Second:(Second:(Second:($t@110@01))))[i__32@122@01] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
    i__32@122@01)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 39 | First:(Second:(Second:(Second:($t@110@01))))[i__32@122@01] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
      i__32@122@01)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__32] && diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__32]
; [eval] diz.Sensor_m.Main_process_state[i__32]
(set-option :timeout 10)
(push) ; 14
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      106
;  :arith-assert-lower      349
;  :arith-assert-upper      214
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               258
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1735
;  :mk-clause               587
;  :num-allocs              4754112
;  :num-checks              317
;  :propagations            284
;  :quant-instantiations    152
;  :rlimit-count            191332)
(set-option :timeout 0)
(push) ; 14
(assert (not (>= i__32@122@01 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      106
;  :arith-assert-lower      349
;  :arith-assert-upper      214
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               258
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1735
;  :mk-clause               587
;  :num-allocs              4754112
;  :num-checks              318
;  :propagations            284
;  :quant-instantiations    152
;  :rlimit-count            191341)
(push) ; 14
; [then-branch: 40 | 0 <= First:(Second:(Second:(Second:($t@110@01))))[i__32@122@01] | live]
; [else-branch: 40 | !(0 <= First:(Second:(Second:(Second:($t@110@01))))[i__32@122@01]) | live]
(push) ; 15
; [then-branch: 40 | 0 <= First:(Second:(Second:(Second:($t@110@01))))[i__32@122@01]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
    i__32@122@01)))
; [eval] diz.Sensor_m.Main_process_state[i__32] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__32]
(set-option :timeout 10)
(push) ; 16
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      106
;  :arith-assert-lower      349
;  :arith-assert-upper      214
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               259
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1735
;  :mk-clause               587
;  :num-allocs              4754112
;  :num-checks              319
;  :propagations            284
;  :quant-instantiations    152
;  :rlimit-count            191494)
(set-option :timeout 0)
(push) ; 16
(assert (not (>= i__32@122@01 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      106
;  :arith-assert-lower      349
;  :arith-assert-upper      214
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               259
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1735
;  :mk-clause               587
;  :num-allocs              4754112
;  :num-checks              320
;  :propagations            284
;  :quant-instantiations    152
;  :rlimit-count            191503)
; [eval] |diz.Sensor_m.Main_event_state|
(set-option :timeout 10)
(push) ; 16
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      106
;  :arith-assert-lower      349
;  :arith-assert-upper      214
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               260
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              517
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1735
;  :mk-clause               587
;  :num-allocs              4754112
;  :num-checks              321
;  :propagations            284
;  :quant-instantiations    152
;  :rlimit-count            191551)
(pop) ; 15
(push) ; 15
; [else-branch: 40 | !(0 <= First:(Second:(Second:(Second:($t@110@01))))[i__32@122@01])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
      i__32@122@01))))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 38 | !(i__32@122@01 < |First:(Second:(Second:(Second:($t@110@01))))| && 0 <= i__32@122@01)]
(assert (not
  (and
    (<
      i__32@122@01
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))
    (<= 0 i__32@122@01))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(set-option :timeout 0)
(push) ; 9
(assert (not (forall ((i__32@122@01 Int)) (!
  (implies
    (and
      (<
        i__32@122@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))
      (<= 0 i__32@122@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
          i__32@122@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
            i__32@122@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
            i__32@122@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
    i__32@122@01))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      108
;  :arith-assert-lower      350
;  :arith-assert-upper      215
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        172
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               261
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              535
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1743
;  :mk-clause               601
;  :num-allocs              4754112
;  :num-checks              322
;  :propagations            286
;  :quant-instantiations    153
;  :rlimit-count            191997)
(assert (forall ((i__32@122@01 Int)) (!
  (implies
    (and
      (<
        i__32@122@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))
      (<= 0 i__32@122@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
          i__32@122@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
            i__32@122@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
            i__32@122@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@01)))))
    i__32@122@01))
  :qid |prog.l<no position>|)))
(declare-const $k@123@01 $Perm)
(assert ($Perm.isReadVar $k@123@01 $Perm.Write))
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      109
;  :arith-assert-lower      352
;  :arith-assert-upper      216
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        173
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               262
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              535
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1748
;  :mk-clause               603
;  :num-allocs              4754112
;  :num-checks              323
;  :propagations            287
;  :quant-instantiations    153
;  :rlimit-count            192556)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@123@01 $Perm.No) (< $Perm.No $k@123@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          42
;  :arith-assert-diseq      109
;  :arith-assert-lower      352
;  :arith-assert-upper      216
;  :arith-bound-prop        5
;  :arith-conflicts         18
;  :arith-eq-adapter        173
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               263
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              535
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1748
;  :mk-clause               603
;  :num-allocs              4754112
;  :num-checks              324
;  :propagations            287
;  :quant-instantiations    153
;  :rlimit-count            192606)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@95@01 $k@106@01) $k@112@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2580
;  :arith-add-rows          42
;  :arith-assert-diseq      109
;  :arith-assert-lower      352
;  :arith-assert-upper      217
;  :arith-bound-prop        5
;  :arith-conflicts         19
;  :arith-eq-adapter        174
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               264
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              537
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1750
;  :mk-clause               605
;  :num-allocs              4754112
;  :num-checks              325
;  :propagations            288
;  :quant-instantiations    153
;  :rlimit-count            192684)
(assert (< $k@123@01 (+ (- $k@95@01 $k@106@01) $k@112@01)))
(assert (<= $Perm.No (- (+ (- $k@95@01 $k@106@01) $k@112@01) $k@123@01)))
(assert (<= (- (+ (- $k@95@01 $k@106@01) $k@112@01) $k@123@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@95@01 $k@106@01) $k@112@01) $k@123@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot != null
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2580
;  :arith-add-rows          43
;  :arith-assert-diseq      109
;  :arith-assert-lower      354
;  :arith-assert-upper      218
;  :arith-bound-prop        5
;  :arith-conflicts         19
;  :arith-eq-adapter        174
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               265
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              537
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1753
;  :mk-clause               605
;  :num-allocs              4754112
;  :num-checks              326
;  :propagations            288
;  :quant-instantiations    153
;  :rlimit-count            192919)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@95@01 $k@106@01) $k@112@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2580
;  :arith-add-rows          43
;  :arith-assert-diseq      109
;  :arith-assert-lower      354
;  :arith-assert-upper      219
;  :arith-bound-prop        5
;  :arith-conflicts         20
;  :arith-eq-adapter        174
;  :arith-fixed-eqs         54
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               266
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              537
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1754
;  :mk-clause               605
;  :num-allocs              4754112
;  :num-checks              327
;  :propagations            288
;  :quant-instantiations    153
;  :rlimit-count            192997)
(declare-const $k@124@01 $Perm)
(assert ($Perm.isReadVar $k@124@01 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2580
;  :arith-add-rows          43
;  :arith-assert-diseq      110
;  :arith-assert-lower      356
;  :arith-assert-upper      220
;  :arith-bound-prop        5
;  :arith-conflicts         20
;  :arith-eq-adapter        175
;  :arith-fixed-eqs         54
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               267
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              537
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1758
;  :mk-clause               607
;  :num-allocs              4754112
;  :num-checks              328
;  :propagations            289
;  :quant-instantiations    153
;  :rlimit-count            193194)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@124@01 $Perm.No) (< $Perm.No $k@124@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2580
;  :arith-add-rows          43
;  :arith-assert-diseq      110
;  :arith-assert-lower      356
;  :arith-assert-upper      220
;  :arith-bound-prop        5
;  :arith-conflicts         20
;  :arith-eq-adapter        175
;  :arith-fixed-eqs         54
;  :arith-offset-eqs        5
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               268
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              537
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1758
;  :mk-clause               607
;  :num-allocs              4754112
;  :num-checks              329
;  :propagations            289
;  :quant-instantiations    153
;  :rlimit-count            193244)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@96@01 $k@107@01) $k@114@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2581
;  :arith-add-rows          44
;  :arith-assert-diseq      110
;  :arith-assert-lower      356
;  :arith-assert-upper      221
;  :arith-bound-prop        5
;  :arith-conflicts         21
;  :arith-eq-adapter        176
;  :arith-fixed-eqs         54
;  :arith-offset-eqs        5
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               269
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              539
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1760
;  :mk-clause               609
;  :num-allocs              4754112
;  :num-checks              330
;  :propagations            290
;  :quant-instantiations    153
;  :rlimit-count            193352)
(assert (< $k@124@01 (+ (- $k@96@01 $k@107@01) $k@114@01)))
(assert (<= $Perm.No (- (+ (- $k@96@01 $k@107@01) $k@114@01) $k@124@01)))
(assert (<= (- (+ (- $k@96@01 $k@107@01) $k@114@01) $k@124@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@96@01 $k@107@01) $k@114@01) $k@124@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot_sensor != null
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2581
;  :arith-add-rows          45
;  :arith-assert-diseq      110
;  :arith-assert-lower      358
;  :arith-assert-upper      222
;  :arith-bound-prop        5
;  :arith-conflicts         21
;  :arith-eq-adapter        176
;  :arith-fixed-eqs         54
;  :arith-offset-eqs        5
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               270
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              539
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1763
;  :mk-clause               609
;  :num-allocs              4754112
;  :num-checks              331
;  :propagations            290
;  :quant-instantiations    153
;  :rlimit-count            193587)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@96@01 $k@107@01) $k@114@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2581
;  :arith-add-rows          46
;  :arith-assert-diseq      110
;  :arith-assert-lower      358
;  :arith-assert-upper      223
;  :arith-bound-prop        5
;  :arith-conflicts         22
;  :arith-eq-adapter        176
;  :arith-fixed-eqs         55
;  :arith-offset-eqs        5
;  :arith-pivots            71
;  :binary-propagations     16
;  :conflicts               271
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              539
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1764
;  :mk-clause               609
;  :num-allocs              4754112
;  :num-checks              332
;  :propagations            290
;  :quant-instantiations    153
;  :rlimit-count            193701)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2581
;  :arith-add-rows          46
;  :arith-assert-diseq      110
;  :arith-assert-lower      358
;  :arith-assert-upper      223
;  :arith-bound-prop        5
;  :arith-conflicts         22
;  :arith-eq-adapter        176
;  :arith-fixed-eqs         55
;  :arith-offset-eqs        5
;  :arith-pivots            71
;  :binary-propagations     16
;  :conflicts               272
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              539
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1764
;  :mk-clause               609
;  :num-allocs              4754112
;  :num-checks              333
;  :propagations            290
;  :quant-instantiations    153
;  :rlimit-count            193749)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@96@01 $k@107@01) $k@114@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2581
;  :arith-add-rows          47
;  :arith-assert-diseq      110
;  :arith-assert-lower      358
;  :arith-assert-upper      224
;  :arith-bound-prop        5
;  :arith-conflicts         23
;  :arith-eq-adapter        176
;  :arith-fixed-eqs         56
;  :arith-offset-eqs        5
;  :arith-pivots            73
;  :binary-propagations     16
;  :conflicts               273
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              539
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1765
;  :mk-clause               609
;  :num-allocs              4754112
;  :num-checks              334
;  :propagations            290
;  :quant-instantiations    153
;  :rlimit-count            193858)
(declare-const $k@125@01 $Perm)
(assert ($Perm.isReadVar $k@125@01 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2581
;  :arith-add-rows          47
;  :arith-assert-diseq      111
;  :arith-assert-lower      360
;  :arith-assert-upper      225
;  :arith-bound-prop        5
;  :arith-conflicts         23
;  :arith-eq-adapter        177
;  :arith-fixed-eqs         56
;  :arith-offset-eqs        5
;  :arith-pivots            73
;  :binary-propagations     16
;  :conflicts               274
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              539
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1769
;  :mk-clause               611
;  :num-allocs              4754112
;  :num-checks              335
;  :propagations            291
;  :quant-instantiations    153
;  :rlimit-count            194054)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@125@01 $Perm.No) (< $Perm.No $k@125@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2581
;  :arith-add-rows          47
;  :arith-assert-diseq      111
;  :arith-assert-lower      360
;  :arith-assert-upper      225
;  :arith-bound-prop        5
;  :arith-conflicts         23
;  :arith-eq-adapter        177
;  :arith-fixed-eqs         56
;  :arith-offset-eqs        5
;  :arith-pivots            73
;  :binary-propagations     16
;  :conflicts               275
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              539
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1769
;  :mk-clause               611
;  :num-allocs              4754112
;  :num-checks              336
;  :propagations            291
;  :quant-instantiations    153
;  :rlimit-count            194104)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@97@01 $k@108@01) $k@116@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2582
;  :arith-add-rows          47
;  :arith-assert-diseq      111
;  :arith-assert-lower      360
;  :arith-assert-upper      226
;  :arith-bound-prop        5
;  :arith-conflicts         24
;  :arith-eq-adapter        178
;  :arith-fixed-eqs         56
;  :arith-offset-eqs        5
;  :arith-pivots            73
;  :binary-propagations     16
;  :conflicts               276
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              541
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1771
;  :mk-clause               613
;  :num-allocs              4754112
;  :num-checks              337
;  :propagations            292
;  :quant-instantiations    153
;  :rlimit-count            194182)
(assert (< $k@125@01 (+ (- $k@97@01 $k@108@01) $k@116@01)))
(assert (<= $Perm.No (- (+ (- $k@97@01 $k@108@01) $k@116@01) $k@125@01)))
(assert (<= (- (+ (- $k@97@01 $k@108@01) $k@116@01) $k@125@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@97@01 $k@108@01) $k@116@01) $k@125@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot_controller != null
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2582
;  :arith-add-rows          48
;  :arith-assert-diseq      111
;  :arith-assert-lower      362
;  :arith-assert-upper      227
;  :arith-bound-prop        5
;  :arith-conflicts         24
;  :arith-eq-adapter        178
;  :arith-fixed-eqs         56
;  :arith-offset-eqs        5
;  :arith-pivots            74
;  :binary-propagations     16
;  :conflicts               277
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              541
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1774
;  :mk-clause               613
;  :num-allocs              4754112
;  :num-checks              338
;  :propagations            292
;  :quant-instantiations    153
;  :rlimit-count            194424)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@97@01 $k@108@01) $k@116@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2582
;  :arith-add-rows          48
;  :arith-assert-diseq      111
;  :arith-assert-lower      362
;  :arith-assert-upper      228
;  :arith-bound-prop        5
;  :arith-conflicts         25
;  :arith-eq-adapter        178
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        5
;  :arith-pivots            74
;  :binary-propagations     16
;  :conflicts               278
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              541
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1775
;  :mk-clause               613
;  :num-allocs              4754112
;  :num-checks              339
;  :propagations            292
;  :quant-instantiations    153
;  :rlimit-count            194502)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2582
;  :arith-add-rows          48
;  :arith-assert-diseq      111
;  :arith-assert-lower      362
;  :arith-assert-upper      228
;  :arith-bound-prop        5
;  :arith-conflicts         25
;  :arith-eq-adapter        178
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        5
;  :arith-pivots            74
;  :binary-propagations     16
;  :conflicts               279
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              541
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1775
;  :mk-clause               613
;  :num-allocs              4754112
;  :num-checks              340
;  :propagations            292
;  :quant-instantiations    153
;  :rlimit-count            194550)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@97@01 $k@108@01) $k@116@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2582
;  :arith-add-rows          48
;  :arith-assert-diseq      111
;  :arith-assert-lower      362
;  :arith-assert-upper      229
;  :arith-bound-prop        5
;  :arith-conflicts         26
;  :arith-eq-adapter        178
;  :arith-fixed-eqs         58
;  :arith-offset-eqs        5
;  :arith-pivots            74
;  :binary-propagations     16
;  :conflicts               280
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              541
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1776
;  :mk-clause               613
;  :num-allocs              4754112
;  :num-checks              341
;  :propagations            292
;  :quant-instantiations    153
;  :rlimit-count            194628)
(declare-const $k@126@01 $Perm)
(assert ($Perm.isReadVar $k@126@01 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2582
;  :arith-add-rows          48
;  :arith-assert-diseq      112
;  :arith-assert-lower      364
;  :arith-assert-upper      230
;  :arith-bound-prop        5
;  :arith-conflicts         26
;  :arith-eq-adapter        179
;  :arith-fixed-eqs         58
;  :arith-offset-eqs        5
;  :arith-pivots            74
;  :binary-propagations     16
;  :conflicts               281
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              541
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1780
;  :mk-clause               615
;  :num-allocs              4754112
;  :num-checks              342
;  :propagations            293
;  :quant-instantiations    153
;  :rlimit-count            194825)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@95@01 $k@106@01) $k@112@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2582
;  :arith-add-rows          48
;  :arith-assert-diseq      112
;  :arith-assert-lower      364
;  :arith-assert-upper      231
;  :arith-bound-prop        5
;  :arith-conflicts         27
;  :arith-eq-adapter        179
;  :arith-fixed-eqs         59
;  :arith-offset-eqs        5
;  :arith-pivots            74
;  :binary-propagations     16
;  :conflicts               282
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              541
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1781
;  :mk-clause               615
;  :num-allocs              4754112
;  :num-checks              343
;  :propagations            293
;  :quant-instantiations    153
;  :rlimit-count            194903)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@126@01 $Perm.No) (< $Perm.No $k@126@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2582
;  :arith-add-rows          48
;  :arith-assert-diseq      112
;  :arith-assert-lower      364
;  :arith-assert-upper      231
;  :arith-bound-prop        5
;  :arith-conflicts         27
;  :arith-eq-adapter        179
;  :arith-fixed-eqs         59
;  :arith-offset-eqs        5
;  :arith-pivots            74
;  :binary-propagations     16
;  :conflicts               283
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              541
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1781
;  :mk-clause               615
;  :num-allocs              4754112
;  :num-checks              344
;  :propagations            293
;  :quant-instantiations    153
;  :rlimit-count            194953)
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
  $t@113@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2582
;  :arith-add-rows          48
;  :arith-assert-diseq      112
;  :arith-assert-lower      364
;  :arith-assert-upper      231
;  :arith-bound-prop        5
;  :arith-conflicts         27
;  :arith-eq-adapter        179
;  :arith-fixed-eqs         59
;  :arith-offset-eqs        5
;  :arith-pivots            74
;  :binary-propagations     16
;  :conflicts               283
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              541
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1781
;  :mk-clause               615
;  :num-allocs              4754112
;  :num-checks              345
;  :propagations            293
;  :quant-instantiations    153
;  :rlimit-count            194964)
(push) ; 9
(assert (not (not (= (+ (- $k@98@01 $k@109@01) $k@118@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          49
;  :arith-assert-diseq      112
;  :arith-assert-lower      364
;  :arith-assert-upper      232
;  :arith-bound-prop        5
;  :arith-conflicts         28
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         59
;  :arith-offset-eqs        5
;  :arith-pivots            77
;  :binary-propagations     16
;  :conflicts               284
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              543
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1783
;  :mk-clause               617
;  :num-allocs              4754112
;  :num-checks              346
;  :propagations            294
;  :quant-instantiations    153
;  :rlimit-count            195077)
(assert (< $k@126@01 (+ (- $k@98@01 $k@109@01) $k@118@01)))
(assert (<= $Perm.No (- (+ (- $k@98@01 $k@109@01) $k@118@01) $k@126@01)))
(assert (<= (- (+ (- $k@98@01 $k@109@01) $k@118@01) $k@126@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@98@01 $k@109@01) $k@118@01) $k@126@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
      $Ref.null))))
; [eval] diz.Sensor_m.Main_robot.Robot_m == diz.Sensor_m
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          51
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      233
;  :arith-bound-prop        5
;  :arith-conflicts         28
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         59
;  :arith-offset-eqs        5
;  :arith-pivots            77
;  :binary-propagations     16
;  :conflicts               285
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              543
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1786
;  :mk-clause               617
;  :num-allocs              4754112
;  :num-checks              347
;  :propagations            294
;  :quant-instantiations    153
;  :rlimit-count            195313)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@95@01 $k@106@01) $k@112@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          51
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      234
;  :arith-bound-prop        5
;  :arith-conflicts         29
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         60
;  :arith-offset-eqs        5
;  :arith-pivots            77
;  :binary-propagations     16
;  :conflicts               286
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              543
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1787
;  :mk-clause               617
;  :num-allocs              4754112
;  :num-checks              348
;  :propagations            294
;  :quant-instantiations    153
;  :rlimit-count            195391)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
  $t@113@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          51
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      234
;  :arith-bound-prop        5
;  :arith-conflicts         29
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         60
;  :arith-offset-eqs        5
;  :arith-pivots            77
;  :binary-propagations     16
;  :conflicts               286
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              543
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1787
;  :mk-clause               617
;  :num-allocs              4754112
;  :num-checks              349
;  :propagations            294
;  :quant-instantiations    153
;  :rlimit-count            195402)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@98@01 $k@109@01) $k@118@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          52
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      235
;  :arith-bound-prop        5
;  :arith-conflicts         30
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         61
;  :arith-offset-eqs        5
;  :arith-pivots            79
;  :binary-propagations     16
;  :conflicts               287
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              543
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1788
;  :mk-clause               617
;  :num-allocs              4754112
;  :num-checks              350
;  :propagations            294
;  :quant-instantiations    153
;  :rlimit-count            195511)
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          52
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      235
;  :arith-bound-prop        5
;  :arith-conflicts         30
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         61
;  :arith-offset-eqs        5
;  :arith-pivots            79
;  :binary-propagations     16
;  :conflicts               288
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              543
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1788
;  :mk-clause               617
;  :num-allocs              4754112
;  :num-checks              351
;  :propagations            294
;  :quant-instantiations    153
;  :rlimit-count            195559)
; [eval] diz.Sensor_m.Main_robot_sensor == diz
(push) ; 9
(assert (not (< $Perm.No $k@93@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          52
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      235
;  :arith-bound-prop        5
;  :arith-conflicts         30
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         61
;  :arith-offset-eqs        5
;  :arith-pivots            79
;  :binary-propagations     16
;  :conflicts               289
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              543
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1788
;  :mk-clause               617
;  :num-allocs              4754112
;  :num-checks              352
;  :propagations            294
;  :quant-instantiations    153
;  :rlimit-count            195607)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@96@01 $k@107@01) $k@114@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          53
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      236
;  :arith-bound-prop        5
;  :arith-conflicts         31
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         62
;  :arith-offset-eqs        5
;  :arith-pivots            82
;  :binary-propagations     16
;  :conflicts               290
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              543
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1789
;  :mk-clause               617
;  :num-allocs              4754112
;  :num-checks              353
;  :propagations            294
;  :quant-instantiations    153
;  :rlimit-count            195721)
(set-option :timeout 0)
(push) ; 9
(assert (not (= $t@115@01 diz@35@01)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2583
;  :arith-add-rows          53
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      236
;  :arith-bound-prop        5
;  :arith-conflicts         31
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         62
;  :arith-offset-eqs        5
;  :arith-pivots            82
;  :binary-propagations     16
;  :conflicts               290
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 364
;  :datatype-occurs-check   215
;  :datatype-splits         294
;  :decisions               351
;  :del-clause              543
;  :final-checks            50
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1789
;  :mk-clause               617
;  :num-allocs              4754112
;  :num-checks              354
;  :propagations            294
;  :quant-instantiations    153
;  :rlimit-count            195732)
(assert (= $t@115@01 diz@35@01))
(pop) ; 8
(push) ; 8
; [else-branch: 28 | !(First:(Second:(Second:(Second:($t@92@01))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@92@01))))))[0] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
          0)
        (- 0 2))))))
(pop) ; 8
(set-option :timeout 10)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2736
;  :arith-add-rows          54
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      236
;  :arith-bound-prop        5
;  :arith-conflicts         31
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         62
;  :arith-offset-eqs        5
;  :arith-pivots            90
;  :binary-propagations     16
;  :conflicts               291
;  :datatype-accessor-ax    179
;  :datatype-constructor-ax 403
;  :datatype-occurs-check   227
;  :datatype-splits         324
;  :decisions               386
;  :del-clause              556
;  :final-checks            53
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1822
;  :mk-clause               618
;  :num-allocs              4754112
;  :num-checks              355
;  :propagations            297
;  :quant-instantiations    153
;  :rlimit-count            197150
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2871
;  :arith-add-rows          54
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      236
;  :arith-bound-prop        5
;  :arith-conflicts         31
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         62
;  :arith-offset-eqs        5
;  :arith-pivots            90
;  :binary-propagations     16
;  :conflicts               292
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 442
;  :datatype-occurs-check   239
;  :datatype-splits         354
;  :decisions               421
;  :del-clause              557
;  :final-checks            56
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1855
;  :mk-clause               619
;  :num-allocs              4754112
;  :num-checks              356
;  :propagations            300
;  :quant-instantiations    153
;  :rlimit-count            198278
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3006
;  :arith-add-rows          54
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      236
;  :arith-bound-prop        5
;  :arith-conflicts         31
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         62
;  :arith-offset-eqs        5
;  :arith-pivots            90
;  :binary-propagations     16
;  :conflicts               293
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 481
;  :datatype-occurs-check   251
;  :datatype-splits         384
;  :decisions               456
;  :del-clause              558
;  :final-checks            59
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1888
;  :mk-clause               620
;  :num-allocs              4754112
;  :num-checks              357
;  :propagations            303
;  :quant-instantiations    153
;  :rlimit-count            199406
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3141
;  :arith-add-rows          54
;  :arith-assert-diseq      112
;  :arith-assert-lower      366
;  :arith-assert-upper      236
;  :arith-bound-prop        5
;  :arith-conflicts         31
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         62
;  :arith-offset-eqs        5
;  :arith-pivots            90
;  :binary-propagations     16
;  :conflicts               294
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 520
;  :datatype-occurs-check   263
;  :datatype-splits         414
;  :decisions               491
;  :del-clause              559
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1921
;  :mk-clause               621
;  :num-allocs              4754112
;  :num-checks              358
;  :propagations            306
;  :quant-instantiations    153
;  :rlimit-count            200534
;  :time                    0.00)
(declare-const $t@127@01 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@93@01)
    (= $t@127@01 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01))))
  (implies
    (< $Perm.No (- $k@74@01 $k@99@01))
    (= $t@127@01 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))))))
(assert (<= $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01))))
(assert (<= (+ $k@93@01 (- $k@74@01 $k@99@01)) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))
  (not (= diz@35@01 $Ref.null))))
; [eval] !(diz.Sensor_m.Main_process_state[0] != -1 || diz.Sensor_m.Main_event_state[0] != -2)
; [eval] diz.Sensor_m.Main_process_state[0] != -1 || diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_process_state[0] != -1
; [eval] diz.Sensor_m.Main_process_state[0]
(push) ; 8
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3146
;  :arith-add-rows          55
;  :arith-assert-diseq      112
;  :arith-assert-lower      367
;  :arith-assert-upper      238
;  :arith-bound-prop        5
;  :arith-conflicts         32
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        5
;  :arith-pivots            91
;  :binary-propagations     16
;  :conflicts               295
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 520
;  :datatype-occurs-check   263
;  :datatype-splits         414
;  :decisions               491
;  :del-clause              559
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1926
;  :mk-clause               621
;  :num-allocs              4754112
;  :num-checks              359
;  :propagations            306
;  :quant-instantiations    153
;  :rlimit-count            200875)
(push) ; 8
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3146
;  :arith-add-rows          55
;  :arith-assert-diseq      112
;  :arith-assert-lower      367
;  :arith-assert-upper      238
;  :arith-bound-prop        5
;  :arith-conflicts         32
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        5
;  :arith-pivots            91
;  :binary-propagations     16
;  :conflicts               296
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 520
;  :datatype-occurs-check   263
;  :datatype-splits         414
;  :decisions               491
;  :del-clause              559
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1927
;  :mk-clause               621
;  :num-allocs              4754112
;  :num-checks              360
;  :propagations            306
;  :quant-instantiations    153
;  :rlimit-count            200955)
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3146
;  :arith-add-rows          55
;  :arith-assert-diseq      112
;  :arith-assert-lower      367
;  :arith-assert-upper      238
;  :arith-bound-prop        5
;  :arith-conflicts         32
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        5
;  :arith-pivots            91
;  :binary-propagations     16
;  :conflicts               296
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 520
;  :datatype-occurs-check   263
;  :datatype-splits         414
;  :decisions               491
;  :del-clause              559
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1927
;  :mk-clause               621
;  :num-allocs              4754112
;  :num-checks              361
;  :propagations            306
;  :quant-instantiations    153
;  :rlimit-count            200970)
; [eval] -1
(push) ; 8
; [then-branch: 41 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1 | live]
; [else-branch: 41 | First:(Second:(Second:(Second:($t@92@01))))[0] == -1 | live]
(push) ; 9
; [then-branch: 41 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 41 | First:(Second:(Second:(Second:($t@92@01))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    0)
  (- 0 1)))
; [eval] diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_event_state[0]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3147
;  :arith-add-rows          55
;  :arith-assert-diseq      112
;  :arith-assert-lower      367
;  :arith-assert-upper      239
;  :arith-bound-prop        5
;  :arith-conflicts         33
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         64
;  :arith-offset-eqs        5
;  :arith-pivots            91
;  :binary-propagations     16
;  :conflicts               297
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 520
;  :datatype-occurs-check   263
;  :datatype-splits         414
;  :decisions               491
;  :del-clause              559
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1929
;  :mk-clause               621
;  :num-allocs              4754112
;  :num-checks              362
;  :propagations            306
;  :quant-instantiations    153
;  :rlimit-count            201193)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3147
;  :arith-add-rows          55
;  :arith-assert-diseq      112
;  :arith-assert-lower      367
;  :arith-assert-upper      239
;  :arith-bound-prop        5
;  :arith-conflicts         33
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         64
;  :arith-offset-eqs        5
;  :arith-pivots            91
;  :binary-propagations     16
;  :conflicts               298
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 520
;  :datatype-occurs-check   263
;  :datatype-splits         414
;  :decisions               491
;  :del-clause              559
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1930
;  :mk-clause               621
;  :num-allocs              4754112
;  :num-checks              363
;  :propagations            306
;  :quant-instantiations    153
;  :rlimit-count            201273)
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3147
;  :arith-add-rows          55
;  :arith-assert-diseq      112
;  :arith-assert-lower      367
;  :arith-assert-upper      239
;  :arith-bound-prop        5
;  :arith-conflicts         33
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         64
;  :arith-offset-eqs        5
;  :arith-pivots            91
;  :binary-propagations     16
;  :conflicts               298
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 520
;  :datatype-occurs-check   263
;  :datatype-splits         414
;  :decisions               491
;  :del-clause              559
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1930
;  :mk-clause               621
;  :num-allocs              4754112
;  :num-checks              364
;  :propagations            306
;  :quant-instantiations    153
;  :rlimit-count            201288)
; [eval] -2
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 8
(assert (not (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
        0)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3270
;  :arith-add-rows          55
;  :arith-assert-diseq      112
;  :arith-assert-lower      367
;  :arith-assert-upper      239
;  :arith-bound-prop        5
;  :arith-conflicts         33
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         64
;  :arith-offset-eqs        5
;  :arith-pivots            91
;  :binary-propagations     16
;  :conflicts               298
;  :datatype-accessor-ax    194
;  :datatype-constructor-ax 549
;  :datatype-occurs-check   274
;  :datatype-splits         441
;  :decisions               517
;  :del-clause              559
;  :final-checks            65
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1958
;  :mk-clause               621
;  :num-allocs              4754112
;  :num-checks              365
;  :propagations            309
;  :quant-instantiations    153
;  :rlimit-count            202441
;  :time                    0.00)
(push) ; 8
(assert (not (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
          0)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3399
;  :arith-add-rows          56
;  :arith-assert-diseq      115
;  :arith-assert-lower      378
;  :arith-assert-upper      244
;  :arith-bound-prop        5
;  :arith-conflicts         33
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         66
;  :arith-offset-eqs        5
;  :arith-pivots            95
;  :binary-propagations     16
;  :conflicts               298
;  :datatype-accessor-ax    197
;  :datatype-constructor-ax 578
;  :datatype-occurs-check   285
;  :datatype-splits         468
;  :decisions               544
;  :del-clause              584
;  :final-checks            68
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2009
;  :mk-clause               646
;  :num-allocs              4754112
;  :num-checks              366
;  :propagations            322
;  :quant-instantiations    157
;  :rlimit-count            203830
;  :time                    0.00)
; [then-branch: 42 | !(First:(Second:(Second:(Second:($t@92@01))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@92@01))))))[0] != -2) | live]
; [else-branch: 42 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@92@01))))))[0] != -2 | live]
(push) ; 8
; [then-branch: 42 | !(First:(Second:(Second:(Second:($t@92@01))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@92@01))))))[0] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
          0)
        (- 0 2))))))
; [exec]
; __flatten_32__27 := Sensor_rand__randomize_0(diz)
; [eval] Sensor_rand__randomize_0(diz)
(push) ; 9
; [eval] diz != null
(pop) ; 9
; Joined path conditions
(declare-const __flatten_32__27@128@01 Int)
(assert (= __flatten_32__27@128@01 (Sensor_rand__randomize_0 $Snap.unit diz@35@01)))
; [exec]
; __flatten_31__26 := __flatten_32__27 % 256
; [eval] __flatten_32__27 % 256
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 256 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3403
;  :arith-add-rows          56
;  :arith-assert-diseq      115
;  :arith-assert-lower      378
;  :arith-assert-upper      244
;  :arith-bound-prop        5
;  :arith-conflicts         33
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         66
;  :arith-offset-eqs        5
;  :arith-pivots            95
;  :binary-propagations     16
;  :conflicts               298
;  :datatype-accessor-ax    197
;  :datatype-constructor-ax 578
;  :datatype-occurs-check   285
;  :datatype-splits         468
;  :decisions               544
;  :del-clause              584
;  :final-checks            68
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2014
;  :mk-clause               646
;  :num-allocs              4754112
;  :num-checks              367
;  :propagations            322
;  :quant-instantiations    159
;  :rlimit-count            204137)
(declare-const __flatten_31__26@129@01 Int)
(assert (= __flatten_31__26@129@01 (mod __flatten_32__27@128@01 256)))
; [exec]
; diz.Sensor_dist := __flatten_31__26
; [eval] diz.Sensor_dist < 50
(set-option :timeout 10)
(push) ; 9
(assert (not (not (< __flatten_31__26@129@01 50))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3530
;  :arith-add-rows          57
;  :arith-assert-diseq      115
;  :arith-assert-lower      380
;  :arith-assert-upper      247
;  :arith-bound-prop        5
;  :arith-conflicts         33
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         66
;  :arith-offset-eqs        6
;  :arith-pivots            97
;  :binary-propagations     16
;  :conflicts               298
;  :datatype-accessor-ax    200
;  :datatype-constructor-ax 607
;  :datatype-occurs-check   296
;  :datatype-splits         495
;  :decisions               570
;  :del-clause              584
;  :final-checks            71
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2047
;  :mk-clause               649
;  :num-allocs              4754112
;  :num-checks              368
;  :propagations            327
;  :quant-instantiations    159
;  :rlimit-count            205306
;  :time                    0.00)
(push) ; 9
(assert (not (< __flatten_31__26@129@01 50)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3651
;  :arith-add-rows          57
;  :arith-assert-diseq      115
;  :arith-assert-lower      381
;  :arith-assert-upper      247
;  :arith-bound-prop        5
;  :arith-conflicts         33
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         66
;  :arith-offset-eqs        6
;  :arith-pivots            97
;  :binary-propagations     16
;  :conflicts               298
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              584
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2074
;  :mk-clause               649
;  :num-allocs              4754112
;  :num-checks              369
;  :propagations            330
;  :quant-instantiations    159
;  :rlimit-count            206307
;  :time                    0.00)
; [then-branch: 43 | __flatten_31__26@129@01 < 50 | live]
; [else-branch: 43 | !(__flatten_31__26@129@01 < 50) | live]
(push) ; 9
; [then-branch: 43 | __flatten_31__26@129@01 < 50]
(assert (< __flatten_31__26@129@01 50))
; [exec]
; __flatten_33__28 := diz.Sensor_m
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3651
;  :arith-add-rows          57
;  :arith-assert-diseq      115
;  :arith-assert-lower      381
;  :arith-assert-upper      249
;  :arith-bound-prop        5
;  :arith-conflicts         34
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         67
;  :arith-offset-eqs        6
;  :arith-pivots            97
;  :binary-propagations     16
;  :conflicts               299
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              584
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2076
;  :mk-clause               649
;  :num-allocs              4754112
;  :num-checks              370
;  :propagations            330
;  :quant-instantiations    159
;  :rlimit-count            206452)
; [exec]
; __flatten_35__30 := diz.Sensor_m
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3651
;  :arith-add-rows          57
;  :arith-assert-diseq      115
;  :arith-assert-lower      381
;  :arith-assert-upper      250
;  :arith-bound-prop        5
;  :arith-conflicts         35
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        6
;  :arith-pivots            97
;  :binary-propagations     16
;  :conflicts               300
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              584
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2077
;  :mk-clause               649
;  :num-allocs              4754112
;  :num-checks              371
;  :propagations            330
;  :quant-instantiations    159
;  :rlimit-count            206532)
; [exec]
; __flatten_34__29 := __flatten_35__30.Main_event_state[1 := -1]
; [eval] __flatten_35__30.Main_event_state[1 := -1]
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3651
;  :arith-add-rows          57
;  :arith-assert-diseq      115
;  :arith-assert-lower      381
;  :arith-assert-upper      250
;  :arith-bound-prop        5
;  :arith-conflicts         35
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        6
;  :arith-pivots            97
;  :binary-propagations     16
;  :conflicts               301
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              584
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2078
;  :mk-clause               649
;  :num-allocs              4754112
;  :num-checks              372
;  :propagations            330
;  :quant-instantiations    159
;  :rlimit-count            206612)
; [eval] -1
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3651
;  :arith-add-rows          57
;  :arith-assert-diseq      115
;  :arith-assert-lower      381
;  :arith-assert-upper      250
;  :arith-bound-prop        5
;  :arith-conflicts         35
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        6
;  :arith-pivots            97
;  :binary-propagations     16
;  :conflicts               301
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              584
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2078
;  :mk-clause               649
;  :num-allocs              4754112
;  :num-checks              373
;  :propagations            330
;  :quant-instantiations    159
;  :rlimit-count            206627)
(declare-const __flatten_34__29@130@01 Seq<Int>)
(assert (Seq_equal
  __flatten_34__29@130@01
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
    1
    (- 0 1))))
; [exec]
; __flatten_33__28.Main_event_state := __flatten_34__29
(set-option :timeout 10)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3662
;  :arith-add-rows          60
;  :arith-assert-diseq      116
;  :arith-assert-lower      385
;  :arith-assert-upper      252
;  :arith-bound-prop        5
;  :arith-conflicts         35
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               302
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              584
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2103
;  :mk-clause               670
;  :num-allocs              4754112
;  :num-checks              374
;  :propagations            339
;  :quant-instantiations    164
;  :rlimit-count            207213)
(assert (not (= $t@127@01 $Ref.null)))
; Loop head block: Re-establish invariant
(declare-const $k@131@01 $Perm)
(assert ($Perm.isReadVar $k@131@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@131@01 $Perm.No) (< $Perm.No $k@131@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3662
;  :arith-add-rows          60
;  :arith-assert-diseq      117
;  :arith-assert-lower      387
;  :arith-assert-upper      253
;  :arith-bound-prop        5
;  :arith-conflicts         35
;  :arith-eq-adapter        190
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               303
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              584
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2107
;  :mk-clause               672
;  :num-allocs              4754112
;  :num-checks              375
;  :propagations            340
;  :quant-instantiations    164
;  :rlimit-count            207438)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= (+ $k@93@01 (- $k@74@01 $k@99@01)) $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3663
;  :arith-add-rows          60
;  :arith-assert-diseq      117
;  :arith-assert-lower      387
;  :arith-assert-upper      254
;  :arith-bound-prop        5
;  :arith-conflicts         36
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               304
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2109
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              376
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            207518)
(assert (< $k@131@01 (+ $k@93@01 (- $k@74@01 $k@99@01))))
(assert (<= $Perm.No (- (+ $k@93@01 (- $k@74@01 $k@99@01)) $k@131@01)))
(assert (<= (- (+ $k@93@01 (- $k@74@01 $k@99@01)) $k@131@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@93@01 (- $k@74@01 $k@99@01)) $k@131@01))
  (not (= diz@35@01 $Ref.null))))
; [eval] diz.Sensor_m != null
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3663
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      389
;  :arith-assert-upper      256
;  :arith-bound-prop        5
;  :arith-conflicts         37
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               305
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2113
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              377
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            207787)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3663
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      389
;  :arith-assert-upper      257
;  :arith-bound-prop        5
;  :arith-conflicts         38
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         72
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               306
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2114
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              378
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            207868)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3663
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      389
;  :arith-assert-upper      257
;  :arith-bound-prop        5
;  :arith-conflicts         38
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         72
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               307
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2115
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              379
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            207948)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3663
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      389
;  :arith-assert-upper      258
;  :arith-bound-prop        5
;  :arith-conflicts         39
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               308
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2116
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              380
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            208029)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3663
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      389
;  :arith-assert-upper      258
;  :arith-bound-prop        5
;  :arith-conflicts         39
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               309
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2117
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              381
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            208109)
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3663
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      389
;  :arith-assert-upper      259
;  :arith-bound-prop        5
;  :arith-conflicts         40
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         74
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               310
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2118
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              382
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            208190)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3663
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      389
;  :arith-assert-upper      259
;  :arith-bound-prop        5
;  :arith-conflicts         40
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         74
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               311
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2119
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              383
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            208270)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3663
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      389
;  :arith-assert-upper      260
;  :arith-bound-prop        5
;  :arith-conflicts         41
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         75
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               312
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2120
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              384
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            208351)
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3663
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      389
;  :arith-assert-upper      261
;  :arith-bound-prop        5
;  :arith-conflicts         42
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         76
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               313
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2121
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              385
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            208432)
(set-option :timeout 0)
(push) ; 10
(assert (not (= (Seq_length __flatten_34__29@130@01) 3)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3663
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      389
;  :arith-assert-upper      261
;  :arith-bound-prop        5
;  :arith-conflicts         42
;  :arith-eq-adapter        192
;  :arith-fixed-eqs         76
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               314
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2124
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              386
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            208506)
(assert (= (Seq_length __flatten_34__29@130@01) 3))
; [eval] (forall i__31: Int :: { diz.Sensor_m.Main_process_state[i__31] } 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|)
(declare-const i__31@132@01 Int)
(push) ; 10
; [eval] 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__31
(push) ; 11
; [then-branch: 44 | 0 <= i__31@132@01 | live]
; [else-branch: 44 | !(0 <= i__31@132@01) | live]
(push) ; 12
; [then-branch: 44 | 0 <= i__31@132@01]
(assert (<= 0 i__31@132@01))
; [eval] i__31 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(set-option :timeout 10)
(push) ; 13
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      391
;  :arith-assert-upper      263
;  :arith-bound-prop        5
;  :arith-conflicts         43
;  :arith-eq-adapter        193
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               315
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2129
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              387
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            208690)
(push) ; 13
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      391
;  :arith-assert-upper      263
;  :arith-bound-prop        5
;  :arith-conflicts         43
;  :arith-eq-adapter        193
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               316
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2130
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              388
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            208770)
(pop) ; 12
(push) ; 12
; [else-branch: 44 | !(0 <= i__31@132@01)]
(assert (not (<= 0 i__31@132@01)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(push) ; 11
; [then-branch: 45 | i__31@132@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__31@132@01 | live]
; [else-branch: 45 | !(i__31@132@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__31@132@01) | live]
(push) ; 12
; [then-branch: 45 | i__31@132@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__31@132@01]
(assert (and
  (<
    i__31@132@01
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
  (<= 0 i__31@132@01)))
; [eval] diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__31] == -1
; [eval] diz.Sensor_m.Main_process_state[i__31]
(push) ; 13
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      392
;  :arith-assert-upper      265
;  :arith-bound-prop        5
;  :arith-conflicts         44
;  :arith-eq-adapter        193
;  :arith-fixed-eqs         78
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               317
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2133
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              389
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            208960)
(push) ; 13
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      392
;  :arith-assert-upper      265
;  :arith-bound-prop        5
;  :arith-conflicts         44
;  :arith-eq-adapter        193
;  :arith-fixed-eqs         78
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               318
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2134
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              390
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            209040)
(set-option :timeout 0)
(push) ; 13
(assert (not (>= i__31@132@01 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      117
;  :arith-assert-lower      392
;  :arith-assert-upper      265
;  :arith-bound-prop        5
;  :arith-conflicts         44
;  :arith-eq-adapter        193
;  :arith-fixed-eqs         78
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               318
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2134
;  :mk-clause               674
;  :num-allocs              4754112
;  :num-checks              391
;  :propagations            341
;  :quant-instantiations    164
;  :rlimit-count            209049)
; [eval] -1
(push) ; 13
; [then-branch: 46 | First:(Second:(Second:(Second:($t@92@01))))[i__31@132@01] == -1 | live]
; [else-branch: 46 | First:(Second:(Second:(Second:($t@92@01))))[i__31@132@01] != -1 | live]
(push) ; 14
; [then-branch: 46 | First:(Second:(Second:(Second:($t@92@01))))[i__31@132@01] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__31@132@01)
  (- 0 1)))
(pop) ; 14
(push) ; 14
; [else-branch: 46 | First:(Second:(Second:(Second:($t@92@01))))[i__31@132@01] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      i__31@132@01)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__31]
; [eval] diz.Sensor_m.Main_process_state[i__31]
(set-option :timeout 10)
(push) ; 15
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      118
;  :arith-assert-lower      395
;  :arith-assert-upper      267
;  :arith-bound-prop        5
;  :arith-conflicts         45
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         79
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               319
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2141
;  :mk-clause               678
;  :num-allocs              4754112
;  :num-checks              392
;  :propagations            343
;  :quant-instantiations    165
;  :rlimit-count            209353)
(push) ; 15
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      118
;  :arith-assert-lower      395
;  :arith-assert-upper      267
;  :arith-bound-prop        5
;  :arith-conflicts         45
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         79
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               320
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2142
;  :mk-clause               678
;  :num-allocs              4754112
;  :num-checks              393
;  :propagations            343
;  :quant-instantiations    165
;  :rlimit-count            209433)
(set-option :timeout 0)
(push) ; 15
(assert (not (>= i__31@132@01 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      118
;  :arith-assert-lower      395
;  :arith-assert-upper      267
;  :arith-bound-prop        5
;  :arith-conflicts         45
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         79
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               320
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2142
;  :mk-clause               678
;  :num-allocs              4754112
;  :num-checks              394
;  :propagations            343
;  :quant-instantiations    165
;  :rlimit-count            209442)
(push) ; 15
; [then-branch: 47 | 0 <= First:(Second:(Second:(Second:($t@92@01))))[i__31@132@01] | live]
; [else-branch: 47 | !(0 <= First:(Second:(Second:(Second:($t@92@01))))[i__31@132@01]) | live]
(push) ; 16
; [then-branch: 47 | 0 <= First:(Second:(Second:(Second:($t@92@01))))[i__31@132@01]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__31@132@01)))
; [eval] diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__31]
(set-option :timeout 10)
(push) ; 17
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      118
;  :arith-assert-lower      395
;  :arith-assert-upper      268
;  :arith-bound-prop        5
;  :arith-conflicts         46
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         80
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               321
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2143
;  :mk-clause               678
;  :num-allocs              4754112
;  :num-checks              395
;  :propagations            343
;  :quant-instantiations    165
;  :rlimit-count            209628)
(push) ; 17
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      118
;  :arith-assert-lower      395
;  :arith-assert-upper      268
;  :arith-bound-prop        5
;  :arith-conflicts         46
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         80
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               322
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2144
;  :mk-clause               678
;  :num-allocs              4754112
;  :num-checks              396
;  :propagations            343
;  :quant-instantiations    165
;  :rlimit-count            209708)
(set-option :timeout 0)
(push) ; 17
(assert (not (>= i__31@132@01 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      118
;  :arith-assert-lower      395
;  :arith-assert-upper      268
;  :arith-bound-prop        5
;  :arith-conflicts         46
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         80
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               322
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2144
;  :mk-clause               678
;  :num-allocs              4754112
;  :num-checks              397
;  :propagations            343
;  :quant-instantiations    165
;  :rlimit-count            209717)
; [eval] |diz.Sensor_m.Main_event_state|
(set-option :timeout 10)
(push) ; 17
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      118
;  :arith-assert-lower      395
;  :arith-assert-upper      269
;  :arith-bound-prop        5
;  :arith-conflicts         47
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         81
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               323
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              586
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2145
;  :mk-clause               678
;  :num-allocs              4754112
;  :num-checks              398
;  :propagations            343
;  :quant-instantiations    165
;  :rlimit-count            209798)
(pop) ; 16
(push) ; 16
; [else-branch: 47 | !(0 <= First:(Second:(Second:(Second:($t@92@01))))[i__31@132@01])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      i__31@132@01))))
(pop) ; 16
(pop) ; 15
; Joined path conditions
; Joined path conditions
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 45 | !(i__31@132@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__31@132@01)]
(assert (not
  (and
    (<
      i__31@132@01
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
    (<= 0 i__31@132@01))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(set-option :timeout 0)
(push) ; 10
(assert (not (forall ((i__31@132@01 Int)) (!
  (implies
    (and
      (<
        i__31@132@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
      (<= 0 i__31@132@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          i__31@132@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__31@132@01)
          (Seq_length __flatten_34__29@130@01))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__31@132@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__31@132@01))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      119
;  :arith-assert-lower      396
;  :arith-assert-upper      270
;  :arith-bound-prop        5
;  :arith-conflicts         47
;  :arith-eq-adapter        195
;  :arith-fixed-eqs         81
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               324
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2153
;  :mk-clause               690
;  :num-allocs              4754112
;  :num-checks              399
;  :propagations            345
;  :quant-instantiations    166
;  :rlimit-count            210244)
(assert (forall ((i__31@132@01 Int)) (!
  (implies
    (and
      (<
        i__31@132@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
      (<= 0 i__31@132@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          i__31@132@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__31@132@01)
          (Seq_length __flatten_34__29@130@01))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__31@132@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__31@132@01))
  :qid |prog.l<no position>|)))
(declare-const $k@133@01 $Perm)
(assert ($Perm.isReadVar $k@133@01 $Perm.Write))
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      120
;  :arith-assert-lower      398
;  :arith-assert-upper      272
;  :arith-bound-prop        5
;  :arith-conflicts         48
;  :arith-eq-adapter        196
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               325
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2159
;  :mk-clause               692
;  :num-allocs              4754112
;  :num-checks              400
;  :propagations            346
;  :quant-instantiations    166
;  :rlimit-count            210837)
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@133@01 $Perm.No) (< $Perm.No $k@133@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      120
;  :arith-assert-lower      398
;  :arith-assert-upper      272
;  :arith-bound-prop        5
;  :arith-conflicts         48
;  :arith-eq-adapter        196
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               326
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2159
;  :mk-clause               692
;  :num-allocs              4754112
;  :num-checks              401
;  :propagations            346
;  :quant-instantiations    166
;  :rlimit-count            210887)
(set-option :timeout 10)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      120
;  :arith-assert-lower      398
;  :arith-assert-upper      272
;  :arith-bound-prop        5
;  :arith-conflicts         48
;  :arith-eq-adapter        196
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               326
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2159
;  :mk-clause               692
;  :num-allocs              4754112
;  :num-checks              402
;  :propagations            346
;  :quant-instantiations    166
;  :rlimit-count            210898)
(push) ; 10
(assert (not (not (= (- $k@76@01 $k@101@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          62
;  :arith-assert-diseq      120
;  :arith-assert-lower      398
;  :arith-assert-upper      272
;  :arith-bound-prop        5
;  :arith-conflicts         48
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        6
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               327
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2160
;  :mk-clause               692
;  :num-allocs              4754112
;  :num-checks              403
;  :propagations            346
;  :quant-instantiations    166
;  :rlimit-count            210966)
(assert (< $k@133@01 (- $k@76@01 $k@101@01)))
(assert (<= $Perm.No (- (- $k@76@01 $k@101@01) $k@133@01)))
(assert (<= (- (- $k@76@01 $k@101@01) $k@133@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- $k@76@01 $k@101@01) $k@133@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot != null
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          64
;  :arith-assert-diseq      120
;  :arith-assert-lower      400
;  :arith-assert-upper      274
;  :arith-bound-prop        5
;  :arith-conflicts         49
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        6
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               328
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2164
;  :mk-clause               692
;  :num-allocs              4754112
;  :num-checks              404
;  :propagations            346
;  :quant-instantiations    166
;  :rlimit-count            211253)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          64
;  :arith-assert-diseq      120
;  :arith-assert-lower      400
;  :arith-assert-upper      274
;  :arith-bound-prop        5
;  :arith-conflicts         49
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        6
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               328
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2164
;  :mk-clause               692
;  :num-allocs              4754112
;  :num-checks              405
;  :propagations            346
;  :quant-instantiations    166
;  :rlimit-count            211264)
(push) ; 10
(assert (not (< $Perm.No (- $k@76@01 $k@101@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          64
;  :arith-assert-diseq      120
;  :arith-assert-lower      400
;  :arith-assert-upper      274
;  :arith-bound-prop        5
;  :arith-conflicts         49
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        6
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               328
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2164
;  :mk-clause               692
;  :num-allocs              4754112
;  :num-checks              406
;  :propagations            346
;  :quant-instantiations    166
;  :rlimit-count            211283)
(declare-const $k@134@01 $Perm)
(assert ($Perm.isReadVar $k@134@01 $Perm.Write))
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          64
;  :arith-assert-diseq      121
;  :arith-assert-lower      402
;  :arith-assert-upper      276
;  :arith-bound-prop        5
;  :arith-conflicts         50
;  :arith-eq-adapter        198
;  :arith-fixed-eqs         84
;  :arith-offset-eqs        6
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               329
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2169
;  :mk-clause               694
;  :num-allocs              4754112
;  :num-checks              407
;  :propagations            347
;  :quant-instantiations    166
;  :rlimit-count            211512)
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@134@01 $Perm.No) (< $Perm.No $k@134@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          64
;  :arith-assert-diseq      121
;  :arith-assert-lower      402
;  :arith-assert-upper      276
;  :arith-bound-prop        5
;  :arith-conflicts         50
;  :arith-eq-adapter        198
;  :arith-fixed-eqs         84
;  :arith-offset-eqs        6
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               330
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2169
;  :mk-clause               694
;  :num-allocs              4754112
;  :num-checks              408
;  :propagations            347
;  :quant-instantiations    166
;  :rlimit-count            211562)
(set-option :timeout 10)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          64
;  :arith-assert-diseq      121
;  :arith-assert-lower      402
;  :arith-assert-upper      276
;  :arith-bound-prop        5
;  :arith-conflicts         50
;  :arith-eq-adapter        198
;  :arith-fixed-eqs         84
;  :arith-offset-eqs        6
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               330
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2169
;  :mk-clause               694
;  :num-allocs              4754112
;  :num-checks              409
;  :propagations            347
;  :quant-instantiations    166
;  :rlimit-count            211573)
(push) ; 10
(assert (not (not (= (- $k@77@01 $k@102@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          64
;  :arith-assert-diseq      121
;  :arith-assert-lower      402
;  :arith-assert-upper      276
;  :arith-bound-prop        5
;  :arith-conflicts         50
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         84
;  :arith-offset-eqs        6
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               331
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2170
;  :mk-clause               694
;  :num-allocs              4754112
;  :num-checks              410
;  :propagations            347
;  :quant-instantiations    166
;  :rlimit-count            211641)
(assert (< $k@134@01 (- $k@77@01 $k@102@01)))
(assert (<= $Perm.No (- (- $k@77@01 $k@102@01) $k@134@01)))
(assert (<= (- (- $k@77@01 $k@102@01) $k@134@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- $k@77@01 $k@102@01) $k@134@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot_sensor != null
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          66
;  :arith-assert-diseq      121
;  :arith-assert-lower      404
;  :arith-assert-upper      278
;  :arith-bound-prop        5
;  :arith-conflicts         51
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         85
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :binary-propagations     16
;  :conflicts               332
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2174
;  :mk-clause               694
;  :num-allocs              4754112
;  :num-checks              411
;  :propagations            347
;  :quant-instantiations    166
;  :rlimit-count            211934)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          66
;  :arith-assert-diseq      121
;  :arith-assert-lower      404
;  :arith-assert-upper      278
;  :arith-bound-prop        5
;  :arith-conflicts         51
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         85
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :binary-propagations     16
;  :conflicts               332
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2174
;  :mk-clause               694
;  :num-allocs              4754112
;  :num-checks              412
;  :propagations            347
;  :quant-instantiations    166
;  :rlimit-count            211945)
(push) ; 10
(assert (not (< $Perm.No (- $k@77@01 $k@102@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          66
;  :arith-assert-diseq      121
;  :arith-assert-lower      404
;  :arith-assert-upper      278
;  :arith-bound-prop        5
;  :arith-conflicts         51
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         85
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :binary-propagations     16
;  :conflicts               332
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2174
;  :mk-clause               694
;  :num-allocs              4754112
;  :num-checks              413
;  :propagations            347
;  :quant-instantiations    166
;  :rlimit-count            211964)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          66
;  :arith-assert-diseq      121
;  :arith-assert-lower      404
;  :arith-assert-upper      279
;  :arith-bound-prop        5
;  :arith-conflicts         52
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         86
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :binary-propagations     16
;  :conflicts               333
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2175
;  :mk-clause               694
;  :num-allocs              4754112
;  :num-checks              414
;  :propagations            347
;  :quant-instantiations    166
;  :rlimit-count            212045)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          66
;  :arith-assert-diseq      121
;  :arith-assert-lower      404
;  :arith-assert-upper      279
;  :arith-bound-prop        5
;  :arith-conflicts         52
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         86
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :binary-propagations     16
;  :conflicts               333
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2175
;  :mk-clause               694
;  :num-allocs              4754112
;  :num-checks              415
;  :propagations            347
;  :quant-instantiations    166
;  :rlimit-count            212056)
(push) ; 10
(assert (not (< $Perm.No (- $k@77@01 $k@102@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          66
;  :arith-assert-diseq      121
;  :arith-assert-lower      404
;  :arith-assert-upper      279
;  :arith-bound-prop        5
;  :arith-conflicts         52
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         86
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :binary-propagations     16
;  :conflicts               333
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2175
;  :mk-clause               694
;  :num-allocs              4754112
;  :num-checks              416
;  :propagations            347
;  :quant-instantiations    166
;  :rlimit-count            212075)
(push) ; 10
(assert (not (=
  diz@35@01
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          66
;  :arith-assert-diseq      121
;  :arith-assert-lower      404
;  :arith-assert-upper      279
;  :arith-bound-prop        5
;  :arith-conflicts         52
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         86
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :binary-propagations     16
;  :conflicts               333
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2175
;  :mk-clause               694
;  :num-allocs              4754112
;  :num-checks              417
;  :propagations            347
;  :quant-instantiations    166
;  :rlimit-count            212086)
(declare-const $k@135@01 $Perm)
(assert ($Perm.isReadVar $k@135@01 $Perm.Write))
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          66
;  :arith-assert-diseq      122
;  :arith-assert-lower      406
;  :arith-assert-upper      281
;  :arith-bound-prop        5
;  :arith-conflicts         53
;  :arith-eq-adapter        200
;  :arith-fixed-eqs         87
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :binary-propagations     16
;  :conflicts               334
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2180
;  :mk-clause               696
;  :num-allocs              4754112
;  :num-checks              418
;  :propagations            348
;  :quant-instantiations    166
;  :rlimit-count            212316)
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@135@01 $Perm.No) (< $Perm.No $k@135@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          66
;  :arith-assert-diseq      122
;  :arith-assert-lower      406
;  :arith-assert-upper      281
;  :arith-bound-prop        5
;  :arith-conflicts         53
;  :arith-eq-adapter        200
;  :arith-fixed-eqs         87
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :binary-propagations     16
;  :conflicts               335
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2180
;  :mk-clause               696
;  :num-allocs              4754112
;  :num-checks              419
;  :propagations            348
;  :quant-instantiations    166
;  :rlimit-count            212366)
(set-option :timeout 10)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          66
;  :arith-assert-diseq      122
;  :arith-assert-lower      406
;  :arith-assert-upper      281
;  :arith-bound-prop        5
;  :arith-conflicts         53
;  :arith-eq-adapter        200
;  :arith-fixed-eqs         87
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :binary-propagations     16
;  :conflicts               335
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2180
;  :mk-clause               696
;  :num-allocs              4754112
;  :num-checks              420
;  :propagations            348
;  :quant-instantiations    166
;  :rlimit-count            212377)
(push) ; 10
(assert (not (not (= (- $k@78@01 $k@103@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          66
;  :arith-assert-diseq      122
;  :arith-assert-lower      406
;  :arith-assert-upper      281
;  :arith-bound-prop        5
;  :arith-conflicts         53
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         87
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :binary-propagations     16
;  :conflicts               336
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2181
;  :mk-clause               696
;  :num-allocs              4754112
;  :num-checks              421
;  :propagations            348
;  :quant-instantiations    166
;  :rlimit-count            212445)
(assert (< $k@135@01 (- $k@78@01 $k@103@01)))
(assert (<= $Perm.No (- (- $k@78@01 $k@103@01) $k@135@01)))
(assert (<= (- (- $k@78@01 $k@103@01) $k@135@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- $k@78@01 $k@103@01) $k@135@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot_controller != null
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      283
;  :arith-bound-prop        5
;  :arith-conflicts         54
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         88
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               337
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2185
;  :mk-clause               696
;  :num-allocs              4754112
;  :num-checks              422
;  :propagations            348
;  :quant-instantiations    166
;  :rlimit-count            212732)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      283
;  :arith-bound-prop        5
;  :arith-conflicts         54
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         88
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               337
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2185
;  :mk-clause               696
;  :num-allocs              4754112
;  :num-checks              423
;  :propagations            348
;  :quant-instantiations    166
;  :rlimit-count            212743)
(push) ; 10
(assert (not (< $Perm.No (- $k@78@01 $k@103@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      283
;  :arith-bound-prop        5
;  :arith-conflicts         54
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         88
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               337
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2185
;  :mk-clause               696
;  :num-allocs              4754112
;  :num-checks              424
;  :propagations            348
;  :quant-instantiations    166
;  :rlimit-count            212762)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      284
;  :arith-bound-prop        5
;  :arith-conflicts         55
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               338
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2186
;  :mk-clause               696
;  :num-allocs              4754112
;  :num-checks              425
;  :propagations            348
;  :quant-instantiations    166
;  :rlimit-count            212843)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      284
;  :arith-bound-prop        5
;  :arith-conflicts         55
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               338
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2186
;  :mk-clause               696
;  :num-allocs              4754112
;  :num-checks              426
;  :propagations            348
;  :quant-instantiations    166
;  :rlimit-count            212854)
(push) ; 10
(assert (not (< $Perm.No (- $k@78@01 $k@103@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3664
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      284
;  :arith-bound-prop        5
;  :arith-conflicts         55
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               338
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 636
;  :datatype-occurs-check   307
;  :datatype-splits         522
;  :decisions               596
;  :del-clause              602
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2186
;  :mk-clause               696
;  :num-allocs              4754112
;  :num-checks              427
;  :propagations            348
;  :quant-instantiations    166
;  :rlimit-count            212873)
(push) ; 10
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3793
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      284
;  :arith-bound-prop        5
;  :arith-conflicts         55
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               339
;  :datatype-accessor-ax    207
;  :datatype-constructor-ax 673
;  :datatype-occurs-check   319
;  :datatype-splits         551
;  :decisions               629
;  :del-clause              603
;  :final-checks            77
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2218
;  :mk-clause               697
;  :num-allocs              4754112
;  :num-checks              428
;  :propagations            351
;  :quant-instantiations    166
;  :rlimit-count            214310
;  :time                    0.00)
(check-sat)
; unknown
; [state consolidation]
; State saturation: before repetition
(check-sat)
; unknown
(push) ; 10
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4035
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      284
;  :arith-bound-prop        5
;  :arith-conflicts         55
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               340
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 731
;  :datatype-occurs-check   341
;  :datatype-splits         605
;  :decisions               681
;  :del-clause              632
;  :final-checks            83
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2270
;  :mk-clause               697
;  :num-allocs              4754112
;  :num-checks              431
;  :propagations            357
;  :quant-instantiations    166
;  :rlimit-count            216340)
(declare-const $t@136@01 $Ref)
(push) ; 10
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4035
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      284
;  :arith-bound-prop        5
;  :arith-conflicts         55
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               341
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 731
;  :datatype-occurs-check   341
;  :datatype-splits         605
;  :decisions               681
;  :del-clause              632
;  :final-checks            83
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2270
;  :mk-clause               697
;  :num-allocs              4754112
;  :num-checks              432
;  :propagations            357
;  :quant-instantiations    166
;  :rlimit-count            216412)
(declare-const $t@137@01 $Ref)
(push) ; 10
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4035
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      284
;  :arith-bound-prop        5
;  :arith-conflicts         55
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               342
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 731
;  :datatype-occurs-check   341
;  :datatype-splits         605
;  :decisions               681
;  :del-clause              632
;  :final-checks            83
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2270
;  :mk-clause               697
;  :num-allocs              4754112
;  :num-checks              433
;  :propagations            357
;  :quant-instantiations    166
;  :rlimit-count            216484)
(declare-const $t@138@01 $Ref)
(push) ; 10
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4169
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      284
;  :arith-bound-prop        5
;  :arith-conflicts         55
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               343
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              633
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2302
;  :mk-clause               698
;  :num-allocs              4754112
;  :num-checks              434
;  :propagations            360
;  :quant-instantiations    166
;  :rlimit-count            217826
;  :time                    0.00)
(assert (and
  (implies
    (< $Perm.No (- (- $k@78@01 $k@103@01) $k@135@01))
    (=
      $t@136@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01)))))))))))))))))
  (implies
    (< $Perm.No $k@97@01)
    (=
      $t@136@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))))))
(assert (and
  (implies
    (< $Perm.No (- (- $k@77@01 $k@102@01) $k@134@01))
    (=
      $t@137@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))
  (implies
    (< $Perm.No $k@96@01)
    (=
      $t@137@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))
(assert (and
  (implies
    (< $Perm.No (- (- $k@76@01 $k@101@01) $k@133@01))
    (=
      $t@138@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))
  (implies
    (< $Perm.No $k@95@01)
    (=
      $t@138@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))
(push) ; 10
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4178
;  :arith-add-rows          68
;  :arith-assert-diseq      122
;  :arith-assert-lower      408
;  :arith-assert-upper      284
;  :arith-bound-prop        5
;  :arith-conflicts         55
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               344
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              633
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2307
;  :mk-clause               698
;  :num-allocs              4754112
;  :num-checks              435
;  :propagations            360
;  :quant-instantiations    166
;  :rlimit-count            218638)
(declare-const $t@139@01 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@79@01 $k@104@01))
    (=
      $t@139@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))))
  (implies
    (< $Perm.No $k@98@01)
    (=
      $t@139@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))))))
(assert (<= $Perm.No (+ (- (- $k@76@01 $k@101@01) $k@133@01) $k@95@01)))
(assert (<= (+ (- (- $k@76@01 $k@101@01) $k@133@01) $k@95@01) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- (- $k@76@01 $k@101@01) $k@133@01) $k@95@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
(assert (<= $Perm.No (+ (- (- $k@77@01 $k@102@01) $k@134@01) $k@96@01)))
(assert (<= (+ (- (- $k@77@01 $k@102@01) $k@134@01) $k@96@01) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- (- $k@77@01 $k@102@01) $k@134@01) $k@96@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
(assert (<= $Perm.No (+ (- (- $k@78@01 $k@103@01) $k@135@01) $k@97@01)))
(assert (<= (+ (- (- $k@78@01 $k@103@01) $k@135@01) $k@97@01) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- (- $k@78@01 $k@103@01) $k@135@01) $k@97@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $Ref.null))))
(assert (<= $Perm.No (+ (- $k@79@01 $k@104@01) $k@98@01)))
(assert (<= (+ (- $k@79@01 $k@104@01) $k@98@01) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@79@01 $k@104@01) $k@98@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
      $Ref.null))))
(push) ; 10
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4179
;  :arith-add-rows          72
;  :arith-assert-diseq      122
;  :arith-assert-lower      412
;  :arith-assert-upper      288
;  :arith-bound-prop        5
;  :arith-conflicts         55
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               345
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              633
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2317
;  :mk-clause               698
;  :num-allocs              4754112
;  :num-checks              436
;  :propagations            360
;  :quant-instantiations    166
;  :rlimit-count            219478)
(declare-const $k@140@01 $Perm)
(assert ($Perm.isReadVar $k@140@01 $Perm.Write))
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4179
;  :arith-add-rows          72
;  :arith-assert-diseq      123
;  :arith-assert-lower      414
;  :arith-assert-upper      290
;  :arith-bound-prop        5
;  :arith-conflicts         56
;  :arith-eq-adapter        202
;  :arith-fixed-eqs         90
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               346
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              633
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2322
;  :mk-clause               700
;  :num-allocs              4754112
;  :num-checks              437
;  :propagations            361
;  :quant-instantiations    166
;  :rlimit-count            219708)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4179
;  :arith-add-rows          72
;  :arith-assert-diseq      123
;  :arith-assert-lower      414
;  :arith-assert-upper      290
;  :arith-bound-prop        5
;  :arith-conflicts         56
;  :arith-eq-adapter        202
;  :arith-fixed-eqs         90
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               346
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              633
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2322
;  :mk-clause               700
;  :num-allocs              4754112
;  :num-checks              438
;  :propagations            361
;  :quant-instantiations    166
;  :rlimit-count            219719)
(push) ; 10
(assert (not (< $Perm.No (- $k@76@01 $k@101@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4179
;  :arith-add-rows          72
;  :arith-assert-diseq      123
;  :arith-assert-lower      414
;  :arith-assert-upper      290
;  :arith-bound-prop        5
;  :arith-conflicts         56
;  :arith-eq-adapter        202
;  :arith-fixed-eqs         90
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               346
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              633
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2322
;  :mk-clause               700
;  :num-allocs              4754112
;  :num-checks              439
;  :propagations            361
;  :quant-instantiations    166
;  :rlimit-count            219738)
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@140@01 $Perm.No) (< $Perm.No $k@140@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4179
;  :arith-add-rows          72
;  :arith-assert-diseq      123
;  :arith-assert-lower      414
;  :arith-assert-upper      290
;  :arith-bound-prop        5
;  :arith-conflicts         56
;  :arith-eq-adapter        202
;  :arith-fixed-eqs         90
;  :arith-offset-eqs        6
;  :arith-pivots            103
;  :binary-propagations     16
;  :conflicts               347
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              633
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2322
;  :mk-clause               700
;  :num-allocs              4754112
;  :num-checks              440
;  :propagations            361
;  :quant-instantiations    166
;  :rlimit-count            219788)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= (+ (- $k@79@01 $k@104@01) $k@98@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4180
;  :arith-add-rows          72
;  :arith-assert-diseq      123
;  :arith-assert-lower      414
;  :arith-assert-upper      291
;  :arith-bound-prop        5
;  :arith-conflicts         57
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         90
;  :arith-offset-eqs        6
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               348
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              635
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2324
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              441
;  :propagations            362
;  :quant-instantiations    166
;  :rlimit-count            219872)
(assert (< $k@140@01 (+ (- $k@79@01 $k@104@01) $k@98@01)))
(assert (<= $Perm.No (- (+ (- $k@79@01 $k@104@01) $k@98@01) $k@140@01)))
(assert (<= (- (+ (- $k@79@01 $k@104@01) $k@98@01) $k@140@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@79@01 $k@104@01) $k@98@01) $k@140@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
      $Ref.null))))
; [eval] diz.Sensor_m.Main_robot.Robot_m == diz.Sensor_m
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4180
;  :arith-add-rows          74
;  :arith-assert-diseq      123
;  :arith-assert-lower      416
;  :arith-assert-upper      293
;  :arith-bound-prop        5
;  :arith-conflicts         58
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         91
;  :arith-offset-eqs        6
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               349
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              635
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2328
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              442
;  :propagations            362
;  :quant-instantiations    166
;  :rlimit-count            220141)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4180
;  :arith-add-rows          74
;  :arith-assert-diseq      123
;  :arith-assert-lower      416
;  :arith-assert-upper      293
;  :arith-bound-prop        5
;  :arith-conflicts         58
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         91
;  :arith-offset-eqs        6
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               349
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              635
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2328
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              443
;  :propagations            362
;  :quant-instantiations    166
;  :rlimit-count            220152)
(push) ; 10
(assert (not (< $Perm.No (- $k@76@01 $k@101@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4180
;  :arith-add-rows          74
;  :arith-assert-diseq      123
;  :arith-assert-lower      416
;  :arith-assert-upper      293
;  :arith-bound-prop        5
;  :arith-conflicts         58
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         91
;  :arith-offset-eqs        6
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               349
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              635
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2328
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              444
;  :propagations            362
;  :quant-instantiations    166
;  :rlimit-count            220171)
(push) ; 10
(assert (not (< $Perm.No (- $k@79@01 $k@104@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4180
;  :arith-add-rows          74
;  :arith-assert-diseq      123
;  :arith-assert-lower      416
;  :arith-assert-upper      293
;  :arith-bound-prop        5
;  :arith-conflicts         58
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         91
;  :arith-offset-eqs        6
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               349
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              635
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2328
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              445
;  :propagations            362
;  :quant-instantiations    166
;  :rlimit-count            220190)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4180
;  :arith-add-rows          74
;  :arith-assert-diseq      123
;  :arith-assert-lower      416
;  :arith-assert-upper      294
;  :arith-bound-prop        5
;  :arith-conflicts         59
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         92
;  :arith-offset-eqs        6
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               350
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              635
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2329
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              446
;  :propagations            362
;  :quant-instantiations    166
;  :rlimit-count            220271)
(set-option :timeout 0)
(push) ; 10
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
  $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4180
;  :arith-add-rows          74
;  :arith-assert-diseq      123
;  :arith-assert-lower      416
;  :arith-assert-upper      294
;  :arith-bound-prop        5
;  :arith-conflicts         59
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         92
;  :arith-offset-eqs        6
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               350
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              635
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2329
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              447
;  :propagations            362
;  :quant-instantiations    166
;  :rlimit-count            220290)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))))))))))
  $t@127@01))
; [eval] diz.Sensor_m.Main_robot_sensor == diz
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4180
;  :arith-add-rows          74
;  :arith-assert-diseq      123
;  :arith-assert-lower      416
;  :arith-assert-upper      295
;  :arith-bound-prop        5
;  :arith-conflicts         60
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         93
;  :arith-offset-eqs        6
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               351
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              635
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2330
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              448
;  :propagations            362
;  :quant-instantiations    166
;  :rlimit-count            220389)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4180
;  :arith-add-rows          74
;  :arith-assert-diseq      123
;  :arith-assert-lower      416
;  :arith-assert-upper      295
;  :arith-bound-prop        5
;  :arith-conflicts         60
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         93
;  :arith-offset-eqs        6
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               351
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              635
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2330
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              449
;  :propagations            362
;  :quant-instantiations    166
;  :rlimit-count            220400)
(push) ; 10
(assert (not (< $Perm.No (- $k@77@01 $k@102@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4180
;  :arith-add-rows          74
;  :arith-assert-diseq      123
;  :arith-assert-lower      416
;  :arith-assert-upper      295
;  :arith-bound-prop        5
;  :arith-conflicts         60
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         93
;  :arith-offset-eqs        6
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               351
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 768
;  :datatype-occurs-check   353
;  :datatype-splits         634
;  :decisions               714
;  :del-clause              635
;  :final-checks            86
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2330
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              450
;  :propagations            362
;  :quant-instantiations    166
;  :rlimit-count            220419)
(pop) ; 9
(push) ; 9
; [else-branch: 43 | !(__flatten_31__26@129@01 < 50)]
(assert (not (< __flatten_31__26@129@01 50)))
(pop) ; 9
; [eval] !(diz.Sensor_dist < 50)
; [eval] diz.Sensor_dist < 50
(push) ; 9
(assert (not (< __flatten_31__26@129@01 50)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4301
;  :arith-add-rows          78
;  :arith-assert-diseq      123
;  :arith-assert-lower      417
;  :arith-assert-upper      295
;  :arith-bound-prop        5
;  :arith-conflicts         60
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         93
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               351
;  :datatype-accessor-ax    220
;  :datatype-constructor-ax 797
;  :datatype-occurs-check   364
;  :datatype-splits         661
;  :decisions               740
;  :del-clause              637
;  :final-checks            89
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2357
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              451
;  :propagations            365
;  :quant-instantiations    166
;  :rlimit-count            221503
;  :time                    0.00)
(push) ; 9
(assert (not (not (< __flatten_31__26@129@01 50))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4422
;  :arith-add-rows          78
;  :arith-assert-diseq      123
;  :arith-assert-lower      417
;  :arith-assert-upper      296
;  :arith-bound-prop        5
;  :arith-conflicts         60
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         93
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               351
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              637
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2384
;  :mk-clause               702
;  :num-allocs              4754112
;  :num-checks              452
;  :propagations            368
;  :quant-instantiations    166
;  :rlimit-count            222522
;  :time                    0.00)
; [then-branch: 48 | !(__flatten_31__26@129@01 < 50) | live]
; [else-branch: 48 | __flatten_31__26@129@01 < 50 | live]
(push) ; 9
; [then-branch: 48 | !(__flatten_31__26@129@01 < 50)]
(assert (not (< __flatten_31__26@129@01 50)))
; Loop head block: Re-establish invariant
(declare-const $k@141@01 $Perm)
(assert ($Perm.isReadVar $k@141@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@141@01 $Perm.No) (< $Perm.No $k@141@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4422
;  :arith-add-rows          78
;  :arith-assert-diseq      124
;  :arith-assert-lower      420
;  :arith-assert-upper      297
;  :arith-bound-prop        5
;  :arith-conflicts         60
;  :arith-eq-adapter        204
;  :arith-fixed-eqs         93
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               352
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              637
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2389
;  :mk-clause               704
;  :num-allocs              4754112
;  :num-checks              453
;  :propagations            369
;  :quant-instantiations    166
;  :rlimit-count            222765)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= (+ $k@93@01 (- $k@74@01 $k@99@01)) $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          78
;  :arith-assert-diseq      124
;  :arith-assert-lower      420
;  :arith-assert-upper      298
;  :arith-bound-prop        5
;  :arith-conflicts         61
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         93
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               353
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2391
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              454
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            222845)
(assert (< $k@141@01 (+ $k@93@01 (- $k@74@01 $k@99@01))))
(assert (<= $Perm.No (- (+ $k@93@01 (- $k@74@01 $k@99@01)) $k@141@01)))
(assert (<= (- (+ $k@93@01 (- $k@74@01 $k@99@01)) $k@141@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@93@01 (- $k@74@01 $k@99@01)) $k@141@01))
  (not (= diz@35@01 $Ref.null))))
; [eval] diz.Sensor_m != null
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      300
;  :arith-bound-prop        5
;  :arith-conflicts         62
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         94
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               354
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2395
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              455
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223114)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= $t@127@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      300
;  :arith-bound-prop        5
;  :arith-conflicts         62
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         94
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               354
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2395
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              456
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223132)
(assert (not (= $t@127@01 $Ref.null)))
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      301
;  :arith-bound-prop        5
;  :arith-conflicts         63
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         95
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               355
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2396
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              457
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223233)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      301
;  :arith-bound-prop        5
;  :arith-conflicts         63
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         95
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               356
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2397
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              458
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223313)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      302
;  :arith-bound-prop        5
;  :arith-conflicts         64
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         96
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               357
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2398
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              459
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223394)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      302
;  :arith-bound-prop        5
;  :arith-conflicts         64
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         96
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               358
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2399
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              460
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223474)
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      303
;  :arith-bound-prop        5
;  :arith-conflicts         65
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         97
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               359
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2400
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              461
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223555)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      303
;  :arith-bound-prop        5
;  :arith-conflicts         65
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         97
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               360
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2401
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              462
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223635)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      304
;  :arith-bound-prop        5
;  :arith-conflicts         66
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         98
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               361
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2402
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              463
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223716)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      304
;  :arith-bound-prop        5
;  :arith-conflicts         66
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         98
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               362
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2403
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              464
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223796)
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      305
;  :arith-bound-prop        5
;  :arith-conflicts         67
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         99
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               363
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2404
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              465
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223877)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      422
;  :arith-assert-upper      305
;  :arith-bound-prop        5
;  :arith-conflicts         67
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         99
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               364
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2405
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              466
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            223957)
; [eval] (forall i__31: Int :: { diz.Sensor_m.Main_process_state[i__31] } 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|)
(declare-const i__31@142@01 Int)
(push) ; 10
; [eval] 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__31 && i__31 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__31
(push) ; 11
; [then-branch: 49 | 0 <= i__31@142@01 | live]
; [else-branch: 49 | !(0 <= i__31@142@01) | live]
(push) ; 12
; [then-branch: 49 | 0 <= i__31@142@01]
(assert (<= 0 i__31@142@01))
; [eval] i__31 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 13
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      423
;  :arith-assert-upper      306
;  :arith-bound-prop        5
;  :arith-conflicts         68
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         100
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               365
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2407
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              467
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            224090)
(push) ; 13
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      423
;  :arith-assert-upper      306
;  :arith-bound-prop        5
;  :arith-conflicts         68
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         100
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               366
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2408
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              468
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            224170)
(pop) ; 12
(push) ; 12
; [else-branch: 49 | !(0 <= i__31@142@01)]
(assert (not (<= 0 i__31@142@01)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(push) ; 11
; [then-branch: 50 | i__31@142@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__31@142@01 | live]
; [else-branch: 50 | !(i__31@142@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__31@142@01) | live]
(push) ; 12
; [then-branch: 50 | i__31@142@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__31@142@01]
(assert (and
  (<
    i__31@142@01
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
  (<= 0 i__31@142@01)))
; [eval] diz.Sensor_m.Main_process_state[i__31] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__31] == -1
; [eval] diz.Sensor_m.Main_process_state[i__31]
(push) ; 13
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      424
;  :arith-assert-upper      308
;  :arith-bound-prop        5
;  :arith-conflicts         69
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         101
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               367
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2411
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              469
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            224360)
(push) ; 13
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      424
;  :arith-assert-upper      308
;  :arith-bound-prop        5
;  :arith-conflicts         69
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         101
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               368
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2412
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              470
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            224440)
(set-option :timeout 0)
(push) ; 13
(assert (not (>= i__31@142@01 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      124
;  :arith-assert-lower      424
;  :arith-assert-upper      308
;  :arith-bound-prop        5
;  :arith-conflicts         69
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         101
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               368
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2412
;  :mk-clause               706
;  :num-allocs              4754112
;  :num-checks              471
;  :propagations            370
;  :quant-instantiations    166
;  :rlimit-count            224449)
; [eval] -1
(push) ; 13
; [then-branch: 51 | First:(Second:(Second:(Second:($t@92@01))))[i__31@142@01] == -1 | live]
; [else-branch: 51 | First:(Second:(Second:(Second:($t@92@01))))[i__31@142@01] != -1 | live]
(push) ; 14
; [then-branch: 51 | First:(Second:(Second:(Second:($t@92@01))))[i__31@142@01] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__31@142@01)
  (- 0 1)))
(pop) ; 14
(push) ; 14
; [else-branch: 51 | First:(Second:(Second:(Second:($t@92@01))))[i__31@142@01] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      i__31@142@01)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__31] && diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__31]
; [eval] diz.Sensor_m.Main_process_state[i__31]
(set-option :timeout 10)
(push) ; 15
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      125
;  :arith-assert-lower      427
;  :arith-assert-upper      310
;  :arith-bound-prop        5
;  :arith-conflicts         70
;  :arith-eq-adapter        206
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               369
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2419
;  :mk-clause               710
;  :num-allocs              4754112
;  :num-checks              472
;  :propagations            372
;  :quant-instantiations    167
;  :rlimit-count            224753)
(push) ; 15
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      125
;  :arith-assert-lower      427
;  :arith-assert-upper      310
;  :arith-bound-prop        5
;  :arith-conflicts         70
;  :arith-eq-adapter        206
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               370
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2420
;  :mk-clause               710
;  :num-allocs              4754112
;  :num-checks              473
;  :propagations            372
;  :quant-instantiations    167
;  :rlimit-count            224833)
(set-option :timeout 0)
(push) ; 15
(assert (not (>= i__31@142@01 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      125
;  :arith-assert-lower      427
;  :arith-assert-upper      310
;  :arith-bound-prop        5
;  :arith-conflicts         70
;  :arith-eq-adapter        206
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               370
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2420
;  :mk-clause               710
;  :num-allocs              4754112
;  :num-checks              474
;  :propagations            372
;  :quant-instantiations    167
;  :rlimit-count            224842)
(push) ; 15
; [then-branch: 52 | 0 <= First:(Second:(Second:(Second:($t@92@01))))[i__31@142@01] | live]
; [else-branch: 52 | !(0 <= First:(Second:(Second:(Second:($t@92@01))))[i__31@142@01]) | live]
(push) ; 16
; [then-branch: 52 | 0 <= First:(Second:(Second:(Second:($t@92@01))))[i__31@142@01]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__31@142@01)))
; [eval] diz.Sensor_m.Main_process_state[i__31] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__31]
(set-option :timeout 10)
(push) ; 17
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      125
;  :arith-assert-lower      427
;  :arith-assert-upper      311
;  :arith-bound-prop        5
;  :arith-conflicts         71
;  :arith-eq-adapter        206
;  :arith-fixed-eqs         103
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               371
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2421
;  :mk-clause               710
;  :num-allocs              4754112
;  :num-checks              475
;  :propagations            372
;  :quant-instantiations    167
;  :rlimit-count            225028)
(push) ; 17
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      125
;  :arith-assert-lower      427
;  :arith-assert-upper      311
;  :arith-bound-prop        5
;  :arith-conflicts         71
;  :arith-eq-adapter        206
;  :arith-fixed-eqs         103
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               372
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2422
;  :mk-clause               710
;  :num-allocs              4754112
;  :num-checks              476
;  :propagations            372
;  :quant-instantiations    167
;  :rlimit-count            225108)
(set-option :timeout 0)
(push) ; 17
(assert (not (>= i__31@142@01 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      125
;  :arith-assert-lower      427
;  :arith-assert-upper      311
;  :arith-bound-prop        5
;  :arith-conflicts         71
;  :arith-eq-adapter        206
;  :arith-fixed-eqs         103
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               372
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2422
;  :mk-clause               710
;  :num-allocs              4754112
;  :num-checks              477
;  :propagations            372
;  :quant-instantiations    167
;  :rlimit-count            225117)
; [eval] |diz.Sensor_m.Main_event_state|
(set-option :timeout 10)
(push) ; 17
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      125
;  :arith-assert-lower      427
;  :arith-assert-upper      312
;  :arith-bound-prop        5
;  :arith-conflicts         72
;  :arith-eq-adapter        206
;  :arith-fixed-eqs         104
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               373
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2423
;  :mk-clause               710
;  :num-allocs              4754112
;  :num-checks              478
;  :propagations            372
;  :quant-instantiations    167
;  :rlimit-count            225198)
(push) ; 17
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      125
;  :arith-assert-lower      427
;  :arith-assert-upper      312
;  :arith-bound-prop        5
;  :arith-conflicts         72
;  :arith-eq-adapter        206
;  :arith-fixed-eqs         104
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               374
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              639
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2424
;  :mk-clause               710
;  :num-allocs              4754112
;  :num-checks              479
;  :propagations            372
;  :quant-instantiations    167
;  :rlimit-count            225278)
(pop) ; 16
(push) ; 16
; [else-branch: 52 | !(0 <= First:(Second:(Second:(Second:($t@92@01))))[i__31@142@01])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
      i__31@142@01))))
(pop) ; 16
(pop) ; 15
; Joined path conditions
; Joined path conditions
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 50 | !(i__31@142@01 < |First:(Second:(Second:(Second:($t@92@01))))| && 0 <= i__31@142@01)]
(assert (not
  (and
    (<
      i__31@142@01
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
    (<= 0 i__31@142@01))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(set-option :timeout 0)
(push) ; 10
(assert (not (forall ((i__31@142@01 Int)) (!
  (implies
    (and
      (<
        i__31@142@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
      (<= 0 i__31@142@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          i__31@142@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__31@142@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__31@142@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__31@142@01))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      127
;  :arith-assert-lower      428
;  :arith-assert-upper      313
;  :arith-bound-prop        5
;  :arith-conflicts         72
;  :arith-eq-adapter        207
;  :arith-fixed-eqs         104
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               375
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2432
;  :mk-clause               724
;  :num-allocs              4754112
;  :num-checks              480
;  :propagations            374
;  :quant-instantiations    168
;  :rlimit-count            225724)
(assert (forall ((i__31@142@01 Int)) (!
  (implies
    (and
      (<
        i__31@142@01
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
      (<= 0 i__31@142@01))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
          i__31@142@01)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__31@142@01)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
            i__31@142@01)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
    i__31@142@01))
  :qid |prog.l<no position>|)))
(declare-const $k@143@01 $Perm)
(assert ($Perm.isReadVar $k@143@01 $Perm.Write))
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      128
;  :arith-assert-lower      430
;  :arith-assert-upper      315
;  :arith-bound-prop        5
;  :arith-conflicts         73
;  :arith-eq-adapter        208
;  :arith-fixed-eqs         105
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               376
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2438
;  :mk-clause               726
;  :num-allocs              4754112
;  :num-checks              481
;  :propagations            375
;  :quant-instantiations    168
;  :rlimit-count            226317)
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@143@01 $Perm.No) (< $Perm.No $k@143@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      128
;  :arith-assert-lower      430
;  :arith-assert-upper      315
;  :arith-bound-prop        5
;  :arith-conflicts         73
;  :arith-eq-adapter        208
;  :arith-fixed-eqs         105
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               377
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2438
;  :mk-clause               726
;  :num-allocs              4754112
;  :num-checks              482
;  :propagations            375
;  :quant-instantiations    168
;  :rlimit-count            226367)
(set-option :timeout 10)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      128
;  :arith-assert-lower      430
;  :arith-assert-upper      315
;  :arith-bound-prop        5
;  :arith-conflicts         73
;  :arith-eq-adapter        208
;  :arith-fixed-eqs         105
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               378
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2439
;  :mk-clause               726
;  :num-allocs              4754112
;  :num-checks              483
;  :propagations            375
;  :quant-instantiations    168
;  :rlimit-count            226447)
(push) ; 10
(assert (not (not (= $k@95@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      128
;  :arith-assert-lower      430
;  :arith-assert-upper      315
;  :arith-bound-prop        5
;  :arith-conflicts         73
;  :arith-eq-adapter        208
;  :arith-fixed-eqs         105
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               378
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2439
;  :mk-clause               726
;  :num-allocs              4754112
;  :num-checks              484
;  :propagations            375
;  :quant-instantiations    168
;  :rlimit-count            226458)
(assert (< $k@143@01 $k@95@01))
(assert (<= $Perm.No (- $k@95@01 $k@143@01)))
(assert (<= (- $k@95@01 $k@143@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@95@01 $k@143@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot != null
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      128
;  :arith-assert-lower      432
;  :arith-assert-upper      317
;  :arith-bound-prop        5
;  :arith-conflicts         74
;  :arith-eq-adapter        208
;  :arith-fixed-eqs         106
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               379
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2443
;  :mk-clause               726
;  :num-allocs              4754112
;  :num-checks              485
;  :propagations            375
;  :quant-instantiations    168
;  :rlimit-count            226699)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      128
;  :arith-assert-lower      432
;  :arith-assert-upper      317
;  :arith-bound-prop        5
;  :arith-conflicts         74
;  :arith-eq-adapter        208
;  :arith-fixed-eqs         106
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               380
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2444
;  :mk-clause               726
;  :num-allocs              4754112
;  :num-checks              486
;  :propagations            375
;  :quant-instantiations    168
;  :rlimit-count            226779)
(push) ; 10
(assert (not (< $Perm.No $k@95@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      128
;  :arith-assert-lower      432
;  :arith-assert-upper      317
;  :arith-bound-prop        5
;  :arith-conflicts         74
;  :arith-eq-adapter        208
;  :arith-fixed-eqs         106
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               381
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2444
;  :mk-clause               726
;  :num-allocs              4754112
;  :num-checks              487
;  :propagations            375
;  :quant-instantiations    168
;  :rlimit-count            226827)
(declare-const $k@144@01 $Perm)
(assert ($Perm.isReadVar $k@144@01 $Perm.Write))
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      129
;  :arith-assert-lower      434
;  :arith-assert-upper      319
;  :arith-bound-prop        5
;  :arith-conflicts         75
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         107
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               382
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2449
;  :mk-clause               728
;  :num-allocs              4754112
;  :num-checks              488
;  :propagations            376
;  :quant-instantiations    168
;  :rlimit-count            227056)
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@144@01 $Perm.No) (< $Perm.No $k@144@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      129
;  :arith-assert-lower      434
;  :arith-assert-upper      319
;  :arith-bound-prop        5
;  :arith-conflicts         75
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         107
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               383
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2449
;  :mk-clause               728
;  :num-allocs              4754112
;  :num-checks              489
;  :propagations            376
;  :quant-instantiations    168
;  :rlimit-count            227106)
(set-option :timeout 10)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      129
;  :arith-assert-lower      434
;  :arith-assert-upper      319
;  :arith-bound-prop        5
;  :arith-conflicts         75
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         107
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               384
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2450
;  :mk-clause               728
;  :num-allocs              4754112
;  :num-checks              490
;  :propagations            376
;  :quant-instantiations    168
;  :rlimit-count            227186)
(push) ; 10
(assert (not (not (= $k@96@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      129
;  :arith-assert-lower      434
;  :arith-assert-upper      319
;  :arith-bound-prop        5
;  :arith-conflicts         75
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         107
;  :arith-offset-eqs        6
;  :arith-pivots            110
;  :binary-propagations     16
;  :conflicts               384
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2450
;  :mk-clause               728
;  :num-allocs              4754112
;  :num-checks              491
;  :propagations            376
;  :quant-instantiations    168
;  :rlimit-count            227197)
(assert (< $k@144@01 $k@96@01))
(assert (<= $Perm.No (- $k@96@01 $k@144@01)))
(assert (<= (- $k@96@01 $k@144@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@96@01 $k@144@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot_sensor != null
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      129
;  :arith-assert-lower      436
;  :arith-assert-upper      321
;  :arith-bound-prop        5
;  :arith-conflicts         76
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         108
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :binary-propagations     16
;  :conflicts               385
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2454
;  :mk-clause               728
;  :num-allocs              4754112
;  :num-checks              492
;  :propagations            376
;  :quant-instantiations    168
;  :rlimit-count            227444)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      129
;  :arith-assert-lower      436
;  :arith-assert-upper      321
;  :arith-bound-prop        5
;  :arith-conflicts         76
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         108
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :binary-propagations     16
;  :conflicts               386
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2455
;  :mk-clause               728
;  :num-allocs              4754112
;  :num-checks              493
;  :propagations            376
;  :quant-instantiations    168
;  :rlimit-count            227524)
(push) ; 10
(assert (not (< $Perm.No $k@96@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      129
;  :arith-assert-lower      436
;  :arith-assert-upper      321
;  :arith-bound-prop        5
;  :arith-conflicts         76
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         108
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :binary-propagations     16
;  :conflicts               387
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2455
;  :mk-clause               728
;  :num-allocs              4754112
;  :num-checks              494
;  :propagations            376
;  :quant-instantiations    168
;  :rlimit-count            227572)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      129
;  :arith-assert-lower      436
;  :arith-assert-upper      322
;  :arith-bound-prop        5
;  :arith-conflicts         77
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         109
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :binary-propagations     16
;  :conflicts               388
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2456
;  :mk-clause               728
;  :num-allocs              4754112
;  :num-checks              495
;  :propagations            376
;  :quant-instantiations    168
;  :rlimit-count            227653)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      129
;  :arith-assert-lower      436
;  :arith-assert-upper      322
;  :arith-bound-prop        5
;  :arith-conflicts         77
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         109
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :binary-propagations     16
;  :conflicts               389
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2457
;  :mk-clause               728
;  :num-allocs              4754112
;  :num-checks              496
;  :propagations            376
;  :quant-instantiations    168
;  :rlimit-count            227733)
(push) ; 10
(assert (not (< $Perm.No $k@96@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      129
;  :arith-assert-lower      436
;  :arith-assert-upper      322
;  :arith-bound-prop        5
;  :arith-conflicts         77
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         109
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :binary-propagations     16
;  :conflicts               390
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2457
;  :mk-clause               728
;  :num-allocs              4754112
;  :num-checks              497
;  :propagations            376
;  :quant-instantiations    168
;  :rlimit-count            227781)
(push) ; 10
(assert (not (=
  diz@35@01
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      129
;  :arith-assert-lower      436
;  :arith-assert-upper      322
;  :arith-bound-prop        5
;  :arith-conflicts         77
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         109
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :binary-propagations     16
;  :conflicts               390
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2457
;  :mk-clause               728
;  :num-allocs              4754112
;  :num-checks              498
;  :propagations            376
;  :quant-instantiations    168
;  :rlimit-count            227792)
(declare-const $k@145@01 $Perm)
(assert ($Perm.isReadVar $k@145@01 $Perm.Write))
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      130
;  :arith-assert-lower      438
;  :arith-assert-upper      324
;  :arith-bound-prop        5
;  :arith-conflicts         78
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         110
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :binary-propagations     16
;  :conflicts               391
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2462
;  :mk-clause               730
;  :num-allocs              4754112
;  :num-checks              499
;  :propagations            377
;  :quant-instantiations    168
;  :rlimit-count            228021)
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@145@01 $Perm.No) (< $Perm.No $k@145@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      130
;  :arith-assert-lower      438
;  :arith-assert-upper      324
;  :arith-bound-prop        5
;  :arith-conflicts         78
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         110
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :binary-propagations     16
;  :conflicts               392
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2462
;  :mk-clause               730
;  :num-allocs              4754112
;  :num-checks              500
;  :propagations            377
;  :quant-instantiations    168
;  :rlimit-count            228071)
(set-option :timeout 10)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      130
;  :arith-assert-lower      438
;  :arith-assert-upper      324
;  :arith-bound-prop        5
;  :arith-conflicts         78
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         110
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :binary-propagations     16
;  :conflicts               393
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2463
;  :mk-clause               730
;  :num-allocs              4754112
;  :num-checks              501
;  :propagations            377
;  :quant-instantiations    168
;  :rlimit-count            228151)
(push) ; 10
(assert (not (not (= $k@97@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      130
;  :arith-assert-lower      438
;  :arith-assert-upper      324
;  :arith-bound-prop        5
;  :arith-conflicts         78
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         110
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :binary-propagations     16
;  :conflicts               393
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2463
;  :mk-clause               730
;  :num-allocs              4754112
;  :num-checks              502
;  :propagations            377
;  :quant-instantiations    168
;  :rlimit-count            228162)
(assert (< $k@145@01 $k@97@01))
(assert (<= $Perm.No (- $k@97@01 $k@145@01)))
(assert (<= (- $k@97@01 $k@145@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@97@01 $k@145@01))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $Ref.null))))
; [eval] diz.Sensor_m.Main_robot_controller != null
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      130
;  :arith-assert-lower      440
;  :arith-assert-upper      326
;  :arith-bound-prop        5
;  :arith-conflicts         79
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         111
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               394
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2467
;  :mk-clause               730
;  :num-allocs              4754112
;  :num-checks              503
;  :propagations            377
;  :quant-instantiations    168
;  :rlimit-count            228409)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      130
;  :arith-assert-lower      440
;  :arith-assert-upper      326
;  :arith-bound-prop        5
;  :arith-conflicts         79
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         111
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               395
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2468
;  :mk-clause               730
;  :num-allocs              4754112
;  :num-checks              504
;  :propagations            377
;  :quant-instantiations    168
;  :rlimit-count            228489)
(push) ; 10
(assert (not (< $Perm.No $k@97@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      130
;  :arith-assert-lower      440
;  :arith-assert-upper      326
;  :arith-bound-prop        5
;  :arith-conflicts         79
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         111
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               396
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2468
;  :mk-clause               730
;  :num-allocs              4754112
;  :num-checks              505
;  :propagations            377
;  :quant-instantiations    168
;  :rlimit-count            228537)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      130
;  :arith-assert-lower      440
;  :arith-assert-upper      327
;  :arith-bound-prop        5
;  :arith-conflicts         80
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         112
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               397
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2469
;  :mk-clause               730
;  :num-allocs              4754112
;  :num-checks              506
;  :propagations            377
;  :quant-instantiations    168
;  :rlimit-count            228618)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      130
;  :arith-assert-lower      440
;  :arith-assert-upper      327
;  :arith-bound-prop        5
;  :arith-conflicts         80
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         112
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               398
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2470
;  :mk-clause               730
;  :num-allocs              4754112
;  :num-checks              507
;  :propagations            377
;  :quant-instantiations    168
;  :rlimit-count            228698)
(push) ; 10
(assert (not (< $Perm.No $k@97@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      130
;  :arith-assert-lower      440
;  :arith-assert-upper      327
;  :arith-bound-prop        5
;  :arith-conflicts         80
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         112
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               399
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2470
;  :mk-clause               730
;  :num-allocs              4754112
;  :num-checks              508
;  :propagations            377
;  :quant-instantiations    168
;  :rlimit-count            228746)
(declare-const $k@146@01 $Perm)
(assert ($Perm.isReadVar $k@146@01 $Perm.Write))
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      442
;  :arith-assert-upper      329
;  :arith-bound-prop        5
;  :arith-conflicts         81
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         113
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               400
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2475
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              509
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            228976)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      442
;  :arith-assert-upper      329
;  :arith-bound-prop        5
;  :arith-conflicts         81
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         113
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               401
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2476
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              510
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229056)
(push) ; 10
(assert (not (< $Perm.No $k@95@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      442
;  :arith-assert-upper      329
;  :arith-bound-prop        5
;  :arith-conflicts         81
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         113
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               402
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2476
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              511
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229104)
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@146@01 $Perm.No) (< $Perm.No $k@146@01))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      442
;  :arith-assert-upper      329
;  :arith-bound-prop        5
;  :arith-conflicts         81
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         113
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               403
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2476
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              512
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229154)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= $k@98@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      442
;  :arith-assert-upper      329
;  :arith-bound-prop        5
;  :arith-conflicts         81
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         113
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               403
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2476
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              513
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229165)
(assert (< $k@146@01 $k@98@01))
(assert (<= $Perm.No (- $k@98@01 $k@146@01)))
(assert (<= (- $k@98@01 $k@146@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@98@01 $k@146@01))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))
      $Ref.null))))
; [eval] diz.Sensor_m.Main_robot.Robot_m == diz.Sensor_m
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      331
;  :arith-bound-prop        5
;  :arith-conflicts         82
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         114
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               404
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2480
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              514
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229406)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      331
;  :arith-bound-prop        5
;  :arith-conflicts         82
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         114
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               405
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2481
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              515
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229486)
(push) ; 10
(assert (not (< $Perm.No $k@95@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      331
;  :arith-bound-prop        5
;  :arith-conflicts         82
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         114
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               406
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2481
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              516
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229534)
(push) ; 10
(assert (not (< $Perm.No $k@98@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      331
;  :arith-bound-prop        5
;  :arith-conflicts         82
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         114
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               407
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2481
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              517
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229582)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      332
;  :arith-bound-prop        5
;  :arith-conflicts         83
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         115
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               408
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2482
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              518
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229663)
(set-option :timeout 0)
(push) ; 10
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
  $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4423
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      332
;  :arith-bound-prop        5
;  :arith-conflicts         83
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         115
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               409
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2483
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              519
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229739)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01))))))))))))))))))
  $t@127@01))
; [eval] diz.Sensor_m.Main_robot_sensor == diz
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No (+ $k@93@01 (- $k@74@01 $k@99@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4424
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      333
;  :arith-bound-prop        5
;  :arith-conflicts         84
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         116
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               410
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2485
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              520
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229873)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@92@01)) $t@127@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4424
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      333
;  :arith-bound-prop        5
;  :arith-conflicts         84
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         116
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               410
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2485
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              521
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229884)
(push) ; 10
(assert (not (< $Perm.No $k@96@01)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4424
;  :arith-add-rows          80
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      333
;  :arith-bound-prop        5
;  :arith-conflicts         84
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         116
;  :arith-offset-eqs        6
;  :arith-pivots            112
;  :binary-propagations     16
;  :conflicts               411
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 826
;  :datatype-occurs-check   375
;  :datatype-splits         688
;  :decisions               766
;  :del-clause              657
;  :final-checks            92
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2485
;  :mk-clause               732
;  :num-allocs              4754112
;  :num-checks              522
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            229932)
(pop) ; 9
(push) ; 9
; [else-branch: 48 | __flatten_31__26@129@01 < 50]
(assert (< __flatten_31__26@129@01 50))
(pop) ; 9
(pop) ; 8
(push) ; 8
; [else-branch: 42 | First:(Second:(Second:(Second:($t@92@01))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@92@01))))))[0] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@92@01)))))))
        0)
      (- 0 2)))))
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@01))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@01)))))))))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4524
;  :arith-add-rows          82
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      333
;  :arith-bound-prop        5
;  :arith-conflicts         84
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         116
;  :arith-offset-eqs        6
;  :arith-pivots            125
;  :binary-propagations     16
;  :conflicts               412
;  :datatype-accessor-ax    226
;  :datatype-constructor-ax 854
;  :datatype-occurs-check   384
;  :datatype-splits         708
;  :decisions               791
;  :del-clause              720
;  :final-checks            95
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2508
;  :mk-clause               733
;  :num-allocs              4754112
;  :num-checks              523
;  :propagations            380
;  :quant-instantiations    168
;  :rlimit-count            231139)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4649
;  :arith-add-rows          82
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      333
;  :arith-bound-prop        5
;  :arith-conflicts         84
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         116
;  :arith-offset-eqs        6
;  :arith-pivots            125
;  :binary-propagations     16
;  :conflicts               413
;  :datatype-accessor-ax    231
;  :datatype-constructor-ax 891
;  :datatype-occurs-check   396
;  :datatype-splits         741
;  :decisions               823
;  :del-clause              721
;  :final-checks            99
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2543
;  :mk-clause               734
;  :num-allocs              4754112
;  :num-checks              524
;  :propagations            384
;  :quant-instantiations    168
;  :rlimit-count            232177)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4774
;  :arith-add-rows          82
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      333
;  :arith-bound-prop        5
;  :arith-conflicts         84
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         116
;  :arith-offset-eqs        6
;  :arith-pivots            125
;  :binary-propagations     16
;  :conflicts               414
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 928
;  :datatype-occurs-check   408
;  :datatype-splits         774
;  :decisions               855
;  :del-clause              722
;  :final-checks            103
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2578
;  :mk-clause               735
;  :num-allocs              4754112
;  :num-checks              525
;  :propagations            388
;  :quant-instantiations    168
;  :rlimit-count            233215
;  :time                    0.00)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4899
;  :arith-add-rows          82
;  :arith-assert-diseq      131
;  :arith-assert-lower      444
;  :arith-assert-upper      333
;  :arith-bound-prop        5
;  :arith-conflicts         84
;  :arith-eq-adapter        211
;  :arith-fixed-eqs         116
;  :arith-offset-eqs        6
;  :arith-pivots            125
;  :binary-propagations     16
;  :conflicts               415
;  :datatype-accessor-ax    241
;  :datatype-constructor-ax 965
;  :datatype-occurs-check   420
;  :datatype-splits         807
;  :decisions               887
;  :del-clause              723
;  :final-checks            107
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             2613
;  :mk-clause               736
;  :num-allocs              4754112
;  :num-checks              526
;  :propagations            392
;  :quant-instantiations    168
;  :rlimit-count            234253)
(declare-const $t@147@01 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@74@01)
    (= $t@147@01 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@73@01))))
  (implies
    (< $Perm.No (- $k@38@01 $k@80@01))
    (=
      $t@147@01
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@37@01)))))))
(assert (<= $Perm.No (+ $k@74@01 (- $k@38@01 $k@80@01))))
(assert (<= (+ $k@74@01 (- $k@38@01 $k@80@01)) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@74@01 (- $k@38@01 $k@80@01)))
  (not (= diz@35@01 $Ref.null))))
; [eval] !true
; [then-branch: 53 | False | dead]
; [else-branch: 53 | True | live]
(push) ; 5
; [else-branch: 53 | True]
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
