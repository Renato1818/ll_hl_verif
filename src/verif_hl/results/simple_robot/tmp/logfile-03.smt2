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
; ---------- Controller_run_EncodedGlobalVariables ----------
(declare-const diz@0@03 $Ref)
(declare-const globals@1@03 $Ref)
(declare-const diz@2@03 $Ref)
(declare-const globals@3@03 $Ref)
(push) ; 1
(declare-const $t@4@03 $Snap)
(assert (= $t@4@03 ($Snap.combine ($Snap.first $t@4@03) ($Snap.second $t@4@03))))
(assert (= ($Snap.first $t@4@03) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@2@03 $Ref.null)))
(assert (=
  ($Snap.second $t@4@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@4@03))
    ($Snap.second ($Snap.second $t@4@03)))))
(declare-const $k@5@03 $Perm)
(assert ($Perm.isReadVar $k@5@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@5@03 $Perm.No) (< $Perm.No $k@5@03))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            17
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   2
;  :arith-eq-adapter     2
;  :binary-propagations  16
;  :conflicts            1
;  :datatype-accessor-ax 3
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.70
;  :mk-bool-var          263
;  :mk-clause            3
;  :num-allocs           3411745
;  :num-checks           1
;  :propagations         17
;  :quant-instantiations 1
;  :rlimit-count         110666)
(assert (<= $Perm.No $k@5@03))
(assert (<= $k@5@03 $Perm.Write))
(assert (implies (< $Perm.No $k@5@03) (not (= diz@2@03 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@4@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@4@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@4@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@4@03))) $Snap.unit))
; [eval] diz.Controller_m != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            23
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  16
;  :conflicts            2
;  :datatype-accessor-ax 4
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.70
;  :mk-bool-var          266
;  :mk-clause            3
;  :num-allocs           3411745
;  :num-checks           2
;  :propagations         17
;  :quant-instantiations 1
;  :rlimit-count         110919)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@4@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))))
(push) ; 2
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            29
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  16
;  :conflicts            3
;  :datatype-accessor-ax 5
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.70
;  :mk-bool-var          269
;  :mk-clause            3
;  :num-allocs           3411745
;  :num-checks           3
;  :propagations         17
;  :quant-instantiations 2
;  :rlimit-count         111203)
(declare-const $k@6@03 $Perm)
(assert ($Perm.isReadVar $k@6@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@6@03 $Perm.No) (< $Perm.No $k@6@03))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            29
;  :arith-assert-diseq   2
;  :arith-assert-lower   5
;  :arith-assert-upper   4
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :conflicts            4
;  :datatype-accessor-ax 5
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.70
;  :mk-bool-var          273
;  :mk-clause            5
;  :num-allocs           3411745
;  :num-checks           4
;  :propagations         18
;  :quant-instantiations 2
;  :rlimit-count         111402)
(assert (<= $Perm.No $k@6@03))
(assert (<= $k@6@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@6@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_robot_controller == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            30
;  :arith-assert-diseq   2
;  :arith-assert-lower   5
;  :arith-assert-upper   5
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :conflicts            5
;  :datatype-accessor-ax 5
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.70
;  :mk-bool-var          275
;  :mk-clause            5
;  :num-allocs           3411745
;  :num-checks           5
;  :propagations         18
;  :quant-instantiations 2
;  :rlimit-count         111588)
(push) ; 2
(assert (not (< $Perm.No $k@6@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            30
;  :arith-assert-diseq   2
;  :arith-assert-lower   5
;  :arith-assert-upper   5
;  :arith-eq-adapter     3
;  :binary-propagations  16
;  :conflicts            6
;  :datatype-accessor-ax 5
;  :max-generation       1
;  :max-memory           3.97
;  :memory               3.70
;  :mk-bool-var          275
;  :mk-clause            5
;  :num-allocs           3411745
;  :num-checks           6
;  :propagations         18
;  :quant-instantiations 2
;  :rlimit-count         111636)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))
  diz@2@03))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@7@03 $Snap)
(assert (= $t@7@03 ($Snap.combine ($Snap.first $t@7@03) ($Snap.second $t@7@03))))
(declare-const $k@8@03 $Perm)
(assert ($Perm.isReadVar $k@8@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@8@03 $Perm.No) (< $Perm.No $k@8@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      6
;  :arith-eq-adapter        4
;  :binary-propagations     16
;  :conflicts               7
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   2
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              4
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.79
;  :mk-bool-var             284
;  :mk-clause               7
;  :num-allocs              3529098
;  :num-checks              8
;  :propagations            19
;  :quant-instantiations    3
;  :rlimit-count            112369)
(assert (<= $Perm.No $k@8@03))
(assert (<= $k@8@03 $Perm.Write))
(assert (implies (< $Perm.No $k@8@03) (not (= diz@2@03 $Ref.null))))
(assert (=
  ($Snap.second $t@7@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@7@03))
    ($Snap.second ($Snap.second $t@7@03)))))
(assert (= ($Snap.first ($Snap.second $t@7@03)) $Snap.unit))
; [eval] diz.Controller_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@8@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     16
;  :conflicts               8
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   2
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              4
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             287
;  :mk-clause               7
;  :num-allocs              3646983
;  :num-checks              9
;  :propagations            19
;  :quant-instantiations    3
;  :rlimit-count            112612)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@7@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@7@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@7@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@7@03))))))
(push) ; 3
(assert (not (< $Perm.No $k@8@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               55
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     16
;  :conflicts               9
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   2
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              4
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             290
;  :mk-clause               7
;  :num-allocs              3646983
;  :num-checks              10
;  :propagations            19
;  :quant-instantiations    4
;  :rlimit-count            112884
;  :time                    0.00)
(declare-const $k@9@03 $Perm)
(assert ($Perm.isReadVar $k@9@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@9@03 $Perm.No) (< $Perm.No $k@9@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               55
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      8
;  :arith-eq-adapter        5
;  :binary-propagations     16
;  :conflicts               10
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   2
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              4
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             294
;  :mk-clause               9
;  :num-allocs              3646983
;  :num-checks              11
;  :propagations            20
;  :quant-instantiations    4
;  :rlimit-count            113083)
(assert (<= $Perm.No $k@9@03))
(assert (<= $k@9@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@9@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@7@03)) $Ref.null))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@7@03))) $Snap.unit))
; [eval] diz.Controller_m.Main_robot_controller == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@8@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               56
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     16
;  :conflicts               11
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   2
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              4
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             296
;  :mk-clause               9
;  :num-allocs              3646983
;  :num-checks              12
;  :propagations            20
;  :quant-instantiations    4
;  :rlimit-count            113259
;  :time                    0.00)
(push) ; 3
(assert (not (< $Perm.No $k@9@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               56
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     16
;  :conflicts               12
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   2
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              4
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             296
;  :mk-clause               9
;  :num-allocs              3646983
;  :num-checks              13
;  :propagations            20
;  :quant-instantiations    4
;  :rlimit-count            113307
;  :time                    0.00)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@7@03))))
  diz@2@03))
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_1__2: Ref
(declare-const __flatten_1__2@10@03 $Ref)
; [exec]
; var __flatten_2__3: Seq[Int]
(declare-const __flatten_2__3@11@03 Seq<Int>)
; [exec]
; var __flatten_3__4: Ref
(declare-const __flatten_3__4@12@03 $Ref)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
(push) ; 3
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               56
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     16
;  :conflicts               13
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   2
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              8
;  :final-checks            2
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             296
;  :mk-clause               9
;  :num-allocs              3646983
;  :num-checks              14
;  :propagations            20
;  :quant-instantiations    4
;  :rlimit-count            113371)
(declare-const $t@13@03 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               62
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     16
;  :conflicts               14
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              8
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.86
;  :mk-bool-var             296
;  :mk-clause               9
;  :num-allocs              3765742
;  :num-checks              16
;  :propagations            20
;  :quant-instantiations    4
;  :rlimit-count            113715)
(assert (= $t@13@03 ($Snap.combine ($Snap.first $t@13@03) ($Snap.second $t@13@03))))
(assert (= ($Snap.first $t@13@03) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@13@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@13@03))
    ($Snap.second ($Snap.second $t@13@03)))))
(assert (= ($Snap.first ($Snap.second $t@13@03)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@13@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@13@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@13@03))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@13@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@14@03 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@14@03 | live]
; [else-branch: 0 | !(0 <= i@14@03) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@14@03]
(assert (<= 0 i@14@03))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@14@03)]
(assert (not (<= 0 i@14@03)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@14@03 < |First:(Second:(Second:(Second:($t@13@03))))| && 0 <= i@14@03 | live]
; [else-branch: 1 | !(i@14@03 < |First:(Second:(Second:(Second:($t@13@03))))| && 0 <= i@14@03) | live]
(push) ; 5
; [then-branch: 1 | i@14@03 < |First:(Second:(Second:(Second:($t@13@03))))| && 0 <= i@14@03]
(assert (and
  (<
    i@14@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))
  (<= 0 i@14@03)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@14@03 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               112
;  :arith-assert-diseq      6
;  :arith-assert-lower      16
;  :arith-assert-upper      12
;  :arith-eq-adapter        9
;  :binary-propagations     16
;  :conflicts               14
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              8
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.86
;  :mk-bool-var             328
;  :mk-clause               15
;  :num-allocs              3765742
;  :num-checks              17
;  :propagations            22
;  :quant-instantiations    10
;  :rlimit-count            115063)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:($t@13@03))))[i@14@03] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:($t@13@03))))[i@14@03] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:($t@13@03))))[i@14@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
    i@14@03)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:($t@13@03))))[i@14@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
      i@14@03)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@14@03 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               112
;  :arith-assert-diseq      6
;  :arith-assert-lower      16
;  :arith-assert-upper      12
;  :arith-eq-adapter        9
;  :binary-propagations     16
;  :conflicts               14
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              8
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.86
;  :mk-bool-var             329
;  :mk-clause               15
;  :num-allocs              3765742
;  :num-checks              18
;  :propagations            22
;  :quant-instantiations    10
;  :rlimit-count            115238)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@13@03))))[i@14@03] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@13@03))))[i@14@03]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@13@03))))[i@14@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
    i@14@03)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@14@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               112
;  :arith-assert-diseq      7
;  :arith-assert-lower      19
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     16
;  :conflicts               14
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              8
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.86
;  :mk-bool-var             332
;  :mk-clause               16
;  :num-allocs              3765742
;  :num-checks              19
;  :propagations            22
;  :quant-instantiations    10
;  :rlimit-count            115362
;  :time                    0.00)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@13@03))))[i@14@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
      i@14@03))))
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
; [else-branch: 1 | !(i@14@03 < |First:(Second:(Second:(Second:($t@13@03))))| && 0 <= i@14@03)]
(assert (not
  (and
    (<
      i@14@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))
    (<= 0 i@14@03))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@14@03 Int)) (!
  (implies
    (and
      (<
        i@14@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))
      (<= 0 i@14@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
          i@14@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
            i@14@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
            i@14@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
    i@14@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))
(declare-const $k@15@03 $Perm)
(assert ($Perm.isReadVar $k@15@03 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@15@03 $Perm.No) (< $Perm.No $k@15@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               117
;  :arith-assert-diseq      8
;  :arith-assert-lower      21
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :binary-propagations     16
;  :conflicts               15
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.86
;  :mk-bool-var             338
;  :mk-clause               18
;  :num-allocs              3765742
;  :num-checks              20
;  :propagations            23
;  :quant-instantiations    10
;  :rlimit-count            116131)
(assert (<= $Perm.No $k@15@03))
(assert (<= $k@15@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@15@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))
  $Snap.unit))
; [eval] diz.Main_robot != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               123
;  :arith-assert-diseq      8
;  :arith-assert-lower      21
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     16
;  :conflicts               16
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.86
;  :mk-bool-var             341
;  :mk-clause               18
;  :num-allocs              3765742
;  :num-checks              21
;  :propagations            23
;  :quant-instantiations    10
;  :rlimit-count            116454)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))))
(declare-const $k@16@03 $Perm)
(assert ($Perm.isReadVar $k@16@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@16@03 $Perm.No) (< $Perm.No $k@16@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               129
;  :arith-assert-diseq      9
;  :arith-assert-lower      23
;  :arith-assert-upper      15
;  :arith-eq-adapter        12
;  :binary-propagations     16
;  :conflicts               17
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.86
;  :mk-bool-var             348
;  :mk-clause               20
;  :num-allocs              3765742
;  :num-checks              22
;  :propagations            24
;  :quant-instantiations    11
;  :rlimit-count            116953)
(assert (<= $Perm.No $k@16@03))
(assert (<= $k@16@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@16@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot_sensor != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               135
;  :arith-assert-diseq      9
;  :arith-assert-lower      23
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     16
;  :conflicts               18
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.86
;  :mk-bool-var             351
;  :mk-clause               20
;  :num-allocs              3765742
;  :num-checks              23
;  :propagations            24
;  :quant-instantiations    11
;  :rlimit-count            117296)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               141
;  :arith-assert-diseq      9
;  :arith-assert-lower      23
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :binary-propagations     16
;  :conflicts               19
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             354
;  :mk-clause               20
;  :num-allocs              3887312
;  :num-checks              24
;  :propagations            24
;  :quant-instantiations    12
;  :rlimit-count            117670)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))))))
(declare-const $k@17@03 $Perm)
(assert ($Perm.isReadVar $k@17@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@17@03 $Perm.No) (< $Perm.No $k@17@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               146
;  :arith-assert-diseq      10
;  :arith-assert-lower      25
;  :arith-assert-upper      17
;  :arith-eq-adapter        13
;  :binary-propagations     16
;  :conflicts               20
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             359
;  :mk-clause               22
;  :num-allocs              3887312
;  :num-checks              25
;  :propagations            25
;  :quant-instantiations    12
;  :rlimit-count            118091)
(declare-const $t@18@03 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@6@03)
    (=
      $t@18@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))))
  (implies
    (< $Perm.No $k@17@03)
    (=
      $t@18@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))))))))
(assert (<= $Perm.No (+ $k@6@03 $k@17@03)))
(assert (<= (+ $k@6@03 $k@17@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@6@03 $k@17@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot_controller != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@6@03 $k@17@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               156
;  :arith-assert-diseq      10
;  :arith-assert-lower      26
;  :arith-assert-upper      19
;  :arith-conflicts         1
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               21
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             367
;  :mk-clause               22
;  :num-allocs              3887312
;  :num-checks              26
;  :propagations            25
;  :quant-instantiations    13
;  :rlimit-count            118712)
(assert (not (= $t@18@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@6@03 $k@17@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               162
;  :arith-assert-diseq      10
;  :arith-assert-lower      26
;  :arith-assert-upper      20
;  :arith-conflicts         2
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               22
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             370
;  :mk-clause               22
;  :num-allocs              3887312
;  :num-checks              27
;  :propagations            25
;  :quant-instantiations    13
;  :rlimit-count            119066)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               167
;  :arith-assert-diseq      10
;  :arith-assert-lower      26
;  :arith-assert-upper      20
;  :arith-conflicts         2
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               23
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             371
;  :mk-clause               22
;  :num-allocs              3887312
;  :num-checks              28
;  :propagations            25
;  :quant-instantiations    13
;  :rlimit-count            119373)
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
; (:added-eqs               167
;  :arith-assert-diseq      11
;  :arith-assert-lower      28
;  :arith-assert-upper      21
;  :arith-conflicts         2
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               24
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             375
;  :mk-clause               24
;  :num-allocs              3887312
;  :num-checks              29
;  :propagations            26
;  :quant-instantiations    13
;  :rlimit-count            119572)
(assert (<= $Perm.No $k@19@03))
(assert (<= $k@19@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@19@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot.Robot_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               168
;  :arith-assert-diseq      11
;  :arith-assert-lower      28
;  :arith-assert-upper      22
;  :arith-conflicts         2
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               25
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             377
;  :mk-clause               24
;  :num-allocs              3887312
;  :num-checks              30
;  :propagations            26
;  :quant-instantiations    13
;  :rlimit-count            119888)
(push) ; 3
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               168
;  :arith-assert-diseq      11
;  :arith-assert-lower      28
;  :arith-assert-upper      22
;  :arith-conflicts         2
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               26
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              9
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             377
;  :mk-clause               24
;  :num-allocs              3887312
;  :num-checks              31
;  :propagations            26
;  :quant-instantiations    13
;  :rlimit-count            119936
;  :time                    0.00)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@13@03 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03))) globals@3@03))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Controller_m, globals), write)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               209
;  :arith-assert-diseq      11
;  :arith-assert-lower      28
;  :arith-assert-upper      22
;  :arith-conflicts         2
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               28
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   11
;  :datatype-splits         10
;  :decisions               14
;  :del-clause              23
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             391
;  :mk-clause               25
;  :num-allocs              3887312
;  :num-checks              33
;  :propagations            26
;  :quant-instantiations    14
;  :rlimit-count            120846)
(declare-const $t@20@03 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz.Controller_alarm_flag := false
(set-option :timeout 10)
(push) ; 3
(assert (not (= $t@18@03 diz@2@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               243
;  :arith-assert-diseq      11
;  :arith-assert-lower      28
;  :arith-assert-upper      22
;  :arith-conflicts         2
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               29
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             398
;  :mk-clause               25
;  :num-allocs              3887312
;  :num-checks              35
;  :propagations            27
;  :quant-instantiations    14
;  :rlimit-count            121382)
(declare-const __flatten_1__2@21@03 $Ref)
(declare-const __flatten_3__4@22@03 $Ref)
(declare-const __flatten_2__3@23@03 Seq<Int>)
(push) ; 3
; Loop head block: Check well-definedness of invariant
(declare-const $t@24@03 $Snap)
(assert (= $t@24@03 ($Snap.combine ($Snap.first $t@24@03) ($Snap.second $t@24@03))))
(declare-const $k@25@03 $Perm)
(assert ($Perm.isReadVar $k@25@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@25@03 $Perm.No) (< $Perm.No $k@25@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               248
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      23
;  :arith-conflicts         2
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               30
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             403
;  :mk-clause               27
;  :num-allocs              3887312
;  :num-checks              36
;  :propagations            28
;  :quant-instantiations    14
;  :rlimit-count            121674)
(assert (<= $Perm.No $k@25@03))
(assert (<= $k@25@03 $Perm.Write))
(assert (implies (< $Perm.No $k@25@03) (not (= diz@2@03 $Ref.null))))
(assert (=
  ($Snap.second $t@24@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@24@03))
    ($Snap.second ($Snap.second $t@24@03)))))
(assert (= ($Snap.first ($Snap.second $t@24@03)) $Snap.unit))
; [eval] diz.Controller_m != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               254
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      24
;  :arith-conflicts         2
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               31
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             406
;  :mk-clause               27
;  :num-allocs              3887312
;  :num-checks              37
;  :propagations            28
;  :quant-instantiations    14
;  :rlimit-count            121917)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@24@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@24@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               260
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      24
;  :arith-conflicts         2
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               32
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             409
;  :mk-clause               27
;  :num-allocs              3887312
;  :num-checks              38
;  :propagations            28
;  :quant-instantiations    15
;  :rlimit-count            122189)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@24@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               265
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      24
;  :arith-conflicts         2
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               33
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             410
;  :mk-clause               27
;  :num-allocs              3887312
;  :num-checks              39
;  :propagations            28
;  :quant-instantiations    15
;  :rlimit-count            122366)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
  $Snap.unit))
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               271
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      24
;  :arith-conflicts         2
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               34
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             412
;  :mk-clause               27
;  :num-allocs              3887312
;  :num-checks              40
;  :propagations            28
;  :quant-instantiations    15
;  :rlimit-count            122585)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               278
;  :arith-assert-diseq      12
;  :arith-assert-lower      32
;  :arith-assert-upper      25
;  :arith-conflicts         2
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               35
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             418
;  :mk-clause               27
;  :num-allocs              3887312
;  :num-checks              41
;  :propagations            28
;  :quant-instantiations    17
;  :rlimit-count            122915)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
  $Snap.unit))
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               284
;  :arith-assert-diseq      12
;  :arith-assert-lower      32
;  :arith-assert-upper      25
;  :arith-conflicts         2
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               36
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             420
;  :mk-clause               27
;  :num-allocs              3887312
;  :num-checks              42
;  :propagations            28
;  :quant-instantiations    17
;  :rlimit-count            123154)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
  $Snap.unit))
; [eval] (forall i__5: Int :: { diz.Controller_m.Main_process_state[i__5] } 0 <= i__5 && i__5 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__5] == -1 || 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|)
(declare-const i__5@26@03 Int)
(push) ; 4
; [eval] 0 <= i__5 && i__5 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__5] == -1 || 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__5 && i__5 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__5
(push) ; 5
; [then-branch: 4 | 0 <= i__5@26@03 | live]
; [else-branch: 4 | !(0 <= i__5@26@03) | live]
(push) ; 6
; [then-branch: 4 | 0 <= i__5@26@03]
(assert (<= 0 i__5@26@03))
; [eval] i__5 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               292
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      26
;  :arith-conflicts         2
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               37
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             428
;  :mk-clause               27
;  :num-allocs              3887312
;  :num-checks              43
;  :propagations            28
;  :quant-instantiations    19
;  :rlimit-count            123592)
(pop) ; 6
(push) ; 6
; [else-branch: 4 | !(0 <= i__5@26@03)]
(assert (not (<= 0 i__5@26@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 5 | i__5@26@03 < |First:(Second:(Second:(Second:($t@24@03))))| && 0 <= i__5@26@03 | live]
; [else-branch: 5 | !(i__5@26@03 < |First:(Second:(Second:(Second:($t@24@03))))| && 0 <= i__5@26@03) | live]
(push) ; 6
; [then-branch: 5 | i__5@26@03 < |First:(Second:(Second:(Second:($t@24@03))))| && 0 <= i__5@26@03]
(assert (and
  (<
    i__5@26@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
  (<= 0 i__5@26@03)))
; [eval] diz.Controller_m.Main_process_state[i__5] == -1 || 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__5] == -1
; [eval] diz.Controller_m.Main_process_state[i__5]
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               292
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               38
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             430
;  :mk-clause               27
;  :num-allocs              3887312
;  :num-checks              44
;  :propagations            28
;  :quant-instantiations    19
;  :rlimit-count            123749)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i__5@26@03 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               292
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               38
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.97
;  :memory                  3.96
;  :mk-bool-var             430
;  :mk-clause               27
;  :num-allocs              3887312
;  :num-checks              45
;  :propagations            28
;  :quant-instantiations    19
;  :rlimit-count            123758)
; [eval] -1
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@24@03))))[i__5@26@03] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@24@03))))[i__5@26@03] != -1 | live]
(push) ; 8
; [then-branch: 6 | First:(Second:(Second:(Second:($t@24@03))))[i__5@26@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    i__5@26@03)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 6 | First:(Second:(Second:(Second:($t@24@03))))[i__5@26@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
      i__5@26@03)
    (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__5]
; [eval] diz.Controller_m.Main_process_state[i__5]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               292
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               39
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             431
;  :mk-clause               27
;  :num-allocs              4014091
;  :num-checks              46
;  :propagations            28
;  :quant-instantiations    19
;  :rlimit-count            123972)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i__5@26@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               292
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               39
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             431
;  :mk-clause               27
;  :num-allocs              4014091
;  :num-checks              47
;  :propagations            28
;  :quant-instantiations    19
;  :rlimit-count            123981)
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@24@03))))[i__5@26@03] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@24@03))))[i__5@26@03]) | live]
(push) ; 10
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@24@03))))[i__5@26@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    i__5@26@03)))
; [eval] diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__5]
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               292
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               40
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             434
;  :mk-clause               28
;  :num-allocs              4014091
;  :num-checks              48
;  :propagations            28
;  :quant-instantiations    19
;  :rlimit-count            124143)
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i__5@26@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               292
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               40
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             434
;  :mk-clause               28
;  :num-allocs              4014091
;  :num-checks              49
;  :propagations            28
;  :quant-instantiations    19
;  :rlimit-count            124152)
; [eval] |diz.Controller_m.Main_event_state|
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               292
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               41
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              23
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             434
;  :mk-clause               28
;  :num-allocs              4014091
;  :num-checks              50
;  :propagations            28
;  :quant-instantiations    19
;  :rlimit-count            124200)
(pop) ; 10
(push) ; 10
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@24@03))))[i__5@26@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
      i__5@26@03))))
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
; [else-branch: 5 | !(i__5@26@03 < |First:(Second:(Second:(Second:($t@24@03))))| && 0 <= i__5@26@03)]
(assert (not
  (and
    (<
      i__5@26@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
    (<= 0 i__5@26@03))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__5@26@03 Int)) (!
  (implies
    (and
      (<
        i__5@26@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
      (<= 0 i__5@26@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
          i__5@26@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
            i__5@26@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
            i__5@26@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    i__5@26@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               297
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               42
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             436
;  :mk-clause               28
;  :num-allocs              4014091
;  :num-checks              51
;  :propagations            28
;  :quant-instantiations    19
;  :rlimit-count            124825)
(declare-const $k@27@03 $Perm)
(assert ($Perm.isReadVar $k@27@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@27@03 $Perm.No) (< $Perm.No $k@27@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               297
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      28
;  :arith-conflicts         2
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               43
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             440
;  :mk-clause               30
;  :num-allocs              4014091
;  :num-checks              52
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            125024)
(assert (<= $Perm.No $k@27@03))
(assert (<= $k@27@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@27@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_robot != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               303
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      29
;  :arith-conflicts         2
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               44
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             443
;  :mk-clause               30
;  :num-allocs              4014091
;  :num-checks              53
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            125347
;  :time                    0.00)
(push) ; 4
(assert (not (< $Perm.No $k@27@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               303
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      29
;  :arith-conflicts         2
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               45
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             443
;  :mk-clause               30
;  :num-allocs              4014091
;  :num-checks              54
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            125395)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      14
;  :arith-assert-lower      41
;  :arith-assert-upper      29
;  :arith-conflicts         2
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               46
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             446
;  :mk-clause               30
;  :num-allocs              4014091
;  :num-checks              55
;  :propagations            29
;  :quant-instantiations    20
;  :rlimit-count            125751)
(declare-const $k@28@03 $Perm)
(assert ($Perm.isReadVar $k@28@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@28@03 $Perm.No) (< $Perm.No $k@28@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      30
;  :arith-conflicts         2
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               47
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             450
;  :mk-clause               32
;  :num-allocs              4014091
;  :num-checks              56
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            125950)
(assert (<= $Perm.No $k@28@03))
(assert (<= $k@28@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@28@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_robot_sensor != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               315
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      31
;  :arith-conflicts         2
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               48
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             453
;  :mk-clause               32
;  :num-allocs              4014091
;  :num-checks              57
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            126293)
(push) ; 4
(assert (not (< $Perm.No $k@28@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               315
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      31
;  :arith-conflicts         2
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               49
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             453
;  :mk-clause               32
;  :num-allocs              4014091
;  :num-checks              58
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            126341)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               321
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      31
;  :arith-conflicts         2
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               50
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             456
;  :mk-clause               32
;  :num-allocs              4014091
;  :num-checks              59
;  :propagations            30
;  :quant-instantiations    21
;  :rlimit-count            126715)
(push) ; 4
(assert (not (< $Perm.No $k@28@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               321
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      31
;  :arith-conflicts         2
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               51
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             456
;  :mk-clause               32
;  :num-allocs              4014091
;  :num-checks              60
;  :propagations            30
;  :quant-instantiations    21
;  :rlimit-count            126763)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               326
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      31
;  :arith-conflicts         2
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               52
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             457
;  :mk-clause               32
;  :num-allocs              4014091
;  :num-checks              61
;  :propagations            30
;  :quant-instantiations    21
;  :rlimit-count            127040)
(declare-const $k@29@03 $Perm)
(assert ($Perm.isReadVar $k@29@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@29@03 $Perm.No) (< $Perm.No $k@29@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               326
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      32
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               53
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             461
;  :mk-clause               34
;  :num-allocs              4014091
;  :num-checks              62
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            127238)
(assert (<= $Perm.No $k@29@03))
(assert (<= $k@29@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@29@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_robot_controller != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               332
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               54
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             464
;  :mk-clause               34
;  :num-allocs              4014091
;  :num-checks              63
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            127611)
(push) ; 4
(assert (not (< $Perm.No $k@29@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               332
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               55
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             464
;  :mk-clause               34
;  :num-allocs              4014091
;  :num-checks              64
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            127659)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               338
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               56
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             467
;  :mk-clause               34
;  :num-allocs              4014091
;  :num-checks              65
;  :propagations            31
;  :quant-instantiations    22
;  :rlimit-count            128065)
(push) ; 4
(assert (not (< $Perm.No $k@29@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               338
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               57
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             467
;  :mk-clause               34
;  :num-allocs              4014091
;  :num-checks              66
;  :propagations            31
;  :quant-instantiations    22
;  :rlimit-count            128113)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               343
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               58
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             468
;  :mk-clause               34
;  :num-allocs              4014091
;  :num-checks              67
;  :propagations            31
;  :quant-instantiations    22
;  :rlimit-count            128420)
(push) ; 4
(assert (not (< $Perm.No $k@27@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               343
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               59
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             468
;  :mk-clause               34
;  :num-allocs              4014091
;  :num-checks              68
;  :propagations            31
;  :quant-instantiations    22
;  :rlimit-count            128468)
(declare-const $k@30@03 $Perm)
(assert ($Perm.isReadVar $k@30@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@30@03 $Perm.No) (< $Perm.No $k@30@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               343
;  :arith-assert-diseq      17
;  :arith-assert-lower      47
;  :arith-assert-upper      34
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               60
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             472
;  :mk-clause               36
;  :num-allocs              4014091
;  :num-checks              69
;  :propagations            32
;  :quant-instantiations    22
;  :rlimit-count            128667)
(assert (<= $Perm.No $k@30@03))
(assert (<= $k@30@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@30@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_robot.Robot_m == diz.Controller_m
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               349
;  :arith-assert-diseq      17
;  :arith-assert-lower      47
;  :arith-assert-upper      35
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               61
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             475
;  :mk-clause               36
;  :num-allocs              4014091
;  :num-checks              70
;  :propagations            32
;  :quant-instantiations    22
;  :rlimit-count            129070)
(push) ; 4
(assert (not (< $Perm.No $k@27@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               349
;  :arith-assert-diseq      17
;  :arith-assert-lower      47
;  :arith-assert-upper      35
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               62
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             475
;  :mk-clause               36
;  :num-allocs              4014091
;  :num-checks              71
;  :propagations            32
;  :quant-instantiations    22
;  :rlimit-count            129118)
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               349
;  :arith-assert-diseq      17
;  :arith-assert-lower      47
;  :arith-assert-upper      35
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               63
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             475
;  :mk-clause               36
;  :num-allocs              4014091
;  :num-checks              72
;  :propagations            32
;  :quant-instantiations    22
;  :rlimit-count            129166)
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               349
;  :arith-assert-diseq      17
;  :arith-assert-lower      47
;  :arith-assert-upper      35
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               64
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             475
;  :mk-clause               36
;  :num-allocs              4014091
;  :num-checks              73
;  :propagations            32
;  :quant-instantiations    22
;  :rlimit-count            129214)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_robot_controller == diz
(push) ; 4
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               353
;  :arith-assert-diseq      17
;  :arith-assert-lower      47
;  :arith-assert-upper      35
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               65
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             478
;  :mk-clause               36
;  :num-allocs              4014091
;  :num-checks              74
;  :propagations            32
;  :quant-instantiations    23
;  :rlimit-count            129597)
(push) ; 4
(assert (not (< $Perm.No $k@29@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               353
;  :arith-assert-diseq      17
;  :arith-assert-lower      47
;  :arith-assert-upper      35
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               66
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              24
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             478
;  :mk-clause               36
;  :num-allocs              4014091
;  :num-checks              75
;  :propagations            32
;  :quant-instantiations    23
;  :rlimit-count            129645)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
  diz@2@03))
; Loop head block: Check well-definedness of edge conditions
(push) ; 4
(pop) ; 4
(push) ; 4
; [eval] !true
(pop) ; 4
(pop) ; 3
(push) ; 3
; Loop head block: Establish invariant
(declare-const $k@31@03 $Perm)
(assert ($Perm.isReadVar $k@31@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@31@03 $Perm.No) (< $Perm.No $k@31@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      18
;  :arith-assert-lower      49
;  :arith-assert-upper      36
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               67
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             483
;  :mk-clause               38
;  :num-allocs              4014091
;  :num-checks              76
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            130052)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@5@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      18
;  :arith-assert-lower      49
;  :arith-assert-upper      36
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               67
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             483
;  :mk-clause               38
;  :num-allocs              4014091
;  :num-checks              77
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            130063)
(assert (< $k@31@03 $k@5@03))
(assert (<= $Perm.No (- $k@5@03 $k@31@03)))
(assert (<= (- $k@5@03 $k@31@03) $Perm.Write))
(assert (implies (< $Perm.No (- $k@5@03 $k@31@03)) (not (= diz@2@03 $Ref.null))))
; [eval] diz.Controller_m != null
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      18
;  :arith-assert-lower      51
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               68
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             486
;  :mk-clause               38
;  :num-allocs              4014091
;  :num-checks              78
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            130271)
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      18
;  :arith-assert-lower      51
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               69
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             486
;  :mk-clause               38
;  :num-allocs              4014091
;  :num-checks              79
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            130319)
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      18
;  :arith-assert-lower      51
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               70
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             486
;  :mk-clause               38
;  :num-allocs              4014091
;  :num-checks              80
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            130367)
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      18
;  :arith-assert-lower      51
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               71
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             486
;  :mk-clause               38
;  :num-allocs              4014091
;  :num-checks              81
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            130415)
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      18
;  :arith-assert-lower      51
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               72
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             486
;  :mk-clause               38
;  :num-allocs              4014091
;  :num-checks              82
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            130463)
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      18
;  :arith-assert-lower      51
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               73
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             486
;  :mk-clause               38
;  :num-allocs              4014091
;  :num-checks              83
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            130511)
; [eval] (forall i__5: Int :: { diz.Controller_m.Main_process_state[i__5] } 0 <= i__5 && i__5 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__5] == -1 || 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|)
(declare-const i__5@32@03 Int)
(push) ; 4
; [eval] 0 <= i__5 && i__5 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__5] == -1 || 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__5 && i__5 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__5
(push) ; 5
; [then-branch: 8 | 0 <= i__5@32@03 | live]
; [else-branch: 8 | !(0 <= i__5@32@03) | live]
(push) ; 6
; [then-branch: 8 | 0 <= i__5@32@03]
(assert (<= 0 i__5@32@03))
; [eval] i__5 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      18
;  :arith-assert-lower      52
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               74
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             487
;  :mk-clause               38
;  :num-allocs              4014091
;  :num-checks              84
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            130612)
(pop) ; 6
(push) ; 6
; [else-branch: 8 | !(0 <= i__5@32@03)]
(assert (not (<= 0 i__5@32@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 9 | i__5@32@03 < |First:(Second:(Second:(Second:($t@13@03))))| && 0 <= i__5@32@03 | live]
; [else-branch: 9 | !(i__5@32@03 < |First:(Second:(Second:(Second:($t@13@03))))| && 0 <= i__5@32@03) | live]
(push) ; 6
; [then-branch: 9 | i__5@32@03 < |First:(Second:(Second:(Second:($t@13@03))))| && 0 <= i__5@32@03]
(assert (and
  (<
    i__5@32@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))
  (<= 0 i__5@32@03)))
; [eval] diz.Controller_m.Main_process_state[i__5] == -1 || 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__5] == -1
; [eval] diz.Controller_m.Main_process_state[i__5]
(push) ; 7
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      18
;  :arith-assert-lower      53
;  :arith-assert-upper      38
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               75
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             489
;  :mk-clause               38
;  :num-allocs              4014091
;  :num-checks              85
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            130769)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i__5@32@03 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      18
;  :arith-assert-lower      53
;  :arith-assert-upper      38
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               75
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             489
;  :mk-clause               38
;  :num-allocs              4014091
;  :num-checks              86
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            130778)
; [eval] -1
(push) ; 7
; [then-branch: 10 | First:(Second:(Second:(Second:($t@13@03))))[i__5@32@03] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:(Second:($t@13@03))))[i__5@32@03] != -1 | live]
(push) ; 8
; [then-branch: 10 | First:(Second:(Second:(Second:($t@13@03))))[i__5@32@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
    i__5@32@03)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 10 | First:(Second:(Second:(Second:($t@13@03))))[i__5@32@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
      i__5@32@03)
    (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__5]
; [eval] diz.Controller_m.Main_process_state[i__5]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      19
;  :arith-assert-lower      56
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             495
;  :mk-clause               42
;  :num-allocs              4014091
;  :num-checks              87
;  :propagations            35
;  :quant-instantiations    24
;  :rlimit-count            131049)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i__5@32@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      19
;  :arith-assert-lower      56
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             495
;  :mk-clause               42
;  :num-allocs              4014091
;  :num-checks              88
;  :propagations            35
;  :quant-instantiations    24
;  :rlimit-count            131058)
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@13@03))))[i__5@32@03] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@13@03))))[i__5@32@03]) | live]
(push) ; 10
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@13@03))))[i__5@32@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
    i__5@32@03)))
; [eval] diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__5]
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      19
;  :arith-assert-lower      56
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             495
;  :mk-clause               42
;  :num-allocs              4014091
;  :num-checks              89
;  :propagations            35
;  :quant-instantiations    24
;  :rlimit-count            131211)
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i__5@32@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      19
;  :arith-assert-lower      56
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             495
;  :mk-clause               42
;  :num-allocs              4014091
;  :num-checks              90
;  :propagations            35
;  :quant-instantiations    24
;  :rlimit-count            131220)
; [eval] |diz.Controller_m.Main_event_state|
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      19
;  :arith-assert-lower      56
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               78
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              34
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             495
;  :mk-clause               42
;  :num-allocs              4014091
;  :num-checks              91
;  :propagations            35
;  :quant-instantiations    24
;  :rlimit-count            131268)
(pop) ; 10
(push) ; 10
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@13@03))))[i__5@32@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
      i__5@32@03))))
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
; [else-branch: 9 | !(i__5@32@03 < |First:(Second:(Second:(Second:($t@13@03))))| && 0 <= i__5@32@03)]
(assert (not
  (and
    (<
      i__5@32@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))
    (<= 0 i__5@32@03))))
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
(assert (not (forall ((i__5@32@03 Int)) (!
  (implies
    (and
      (<
        i__5@32@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))
      (<= 0 i__5@32@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
          i__5@32@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
            i__5@32@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
            i__5@32@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
    i__5@32@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      20
;  :arith-assert-lower      57
;  :arith-assert-upper      40
;  :arith-conflicts         2
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             503
;  :mk-clause               54
;  :num-allocs              4014091
;  :num-checks              92
;  :propagations            37
;  :quant-instantiations    25
;  :rlimit-count            131714)
(assert (forall ((i__5@32@03 Int)) (!
  (implies
    (and
      (<
        i__5@32@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))
      (<= 0 i__5@32@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
          i__5@32@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
            i__5@32@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
            i__5@32@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))
    i__5@32@03))
  :qid |prog.l<no position>|)))
(declare-const $k@33@03 $Perm)
(assert ($Perm.isReadVar $k@33@03 $Perm.Write))
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               80
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             508
;  :mk-clause               56
;  :num-allocs              4014091
;  :num-checks              93
;  :propagations            38
;  :quant-instantiations    25
;  :rlimit-count            132272)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@33@03 $Perm.No) (< $Perm.No $k@33@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               81
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             508
;  :mk-clause               56
;  :num-allocs              4014091
;  :num-checks              94
;  :propagations            38
;  :quant-instantiations    25
;  :rlimit-count            132322)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@15@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         2
;  :binary-propagations     16
;  :conflicts               81
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             508
;  :mk-clause               56
;  :num-allocs              4014091
;  :num-checks              95
;  :propagations            38
;  :quant-instantiations    25
;  :rlimit-count            132333)
(assert (< $k@33@03 $k@15@03))
(assert (<= $Perm.No (- $k@15@03 $k@33@03)))
(assert (<= (- $k@15@03 $k@33@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@15@03 $k@33@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
      $Ref.null))))
; [eval] diz.Controller_m.Main_robot != null
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      42
;  :arith-conflicts         2
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               82
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             511
;  :mk-clause               56
;  :num-allocs              4014091
;  :num-checks              96
;  :propagations            38
;  :quant-instantiations    25
;  :rlimit-count            132553)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      42
;  :arith-conflicts         2
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               83
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             511
;  :mk-clause               56
;  :num-allocs              4014091
;  :num-checks              97
;  :propagations            38
;  :quant-instantiations    25
;  :rlimit-count            132601)
(declare-const $k@34@03 $Perm)
(assert ($Perm.isReadVar $k@34@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      43
;  :arith-conflicts         2
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               84
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             515
;  :mk-clause               58
;  :num-allocs              4014091
;  :num-checks              98
;  :propagations            39
;  :quant-instantiations    25
;  :rlimit-count            132797)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@34@03 $Perm.No) (< $Perm.No $k@34@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      43
;  :arith-conflicts         2
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             515
;  :mk-clause               58
;  :num-allocs              4014091
;  :num-checks              99
;  :propagations            39
;  :quant-instantiations    25
;  :rlimit-count            132847)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@16@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      43
;  :arith-conflicts         2
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             515
;  :mk-clause               58
;  :num-allocs              4014091
;  :num-checks              100
;  :propagations            39
;  :quant-instantiations    25
;  :rlimit-count            132858)
(assert (< $k@34@03 $k@16@03))
(assert (<= $Perm.No (- $k@16@03 $k@34@03)))
(assert (<= (- $k@16@03 $k@34@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@16@03 $k@34@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
      $Ref.null))))
; [eval] diz.Controller_m.Main_robot_sensor != null
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      44
;  :arith-conflicts         2
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         2
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               86
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             518
;  :mk-clause               58
;  :num-allocs              4014091
;  :num-checks              101
;  :propagations            39
;  :quant-instantiations    25
;  :rlimit-count            133072)
(push) ; 4
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      44
;  :arith-conflicts         2
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         2
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             518
;  :mk-clause               58
;  :num-allocs              4014091
;  :num-checks              102
;  :propagations            39
;  :quant-instantiations    25
;  :rlimit-count            133120)
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      44
;  :arith-conflicts         2
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         2
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             518
;  :mk-clause               58
;  :num-allocs              4014091
;  :num-checks              103
;  :propagations            39
;  :quant-instantiations    25
;  :rlimit-count            133168)
(push) ; 4
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      22
;  :arith-assert-lower      65
;  :arith-assert-upper      44
;  :arith-conflicts         2
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         2
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               89
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             518
;  :mk-clause               58
;  :num-allocs              4014091
;  :num-checks              104
;  :propagations            39
;  :quant-instantiations    25
;  :rlimit-count            133216)
(declare-const $k@35@03 $Perm)
(assert ($Perm.isReadVar $k@35@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      23
;  :arith-assert-lower      67
;  :arith-assert-upper      45
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         2
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             522
;  :mk-clause               60
;  :num-allocs              4014091
;  :num-checks              105
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            133413)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@35@03 $Perm.No) (< $Perm.No $k@35@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-assert-diseq      23
;  :arith-assert-lower      67
;  :arith-assert-upper      45
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         2
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               91
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              50
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             522
;  :mk-clause               60
;  :num-allocs              4014091
;  :num-checks              106
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            133463)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= (+ $k@6@03 $k@17@03) $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      23
;  :arith-assert-lower      67
;  :arith-assert-upper      46
;  :arith-conflicts         3
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         2
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               92
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             524
;  :mk-clause               62
;  :num-allocs              4014091
;  :num-checks              107
;  :propagations            41
;  :quant-instantiations    25
;  :rlimit-count            133523)
(assert (< $k@35@03 (+ $k@6@03 $k@17@03)))
(assert (<= $Perm.No (- (+ $k@6@03 $k@17@03) $k@35@03)))
(assert (<= (- (+ $k@6@03 $k@17@03) $k@35@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@6@03 $k@17@03) $k@35@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
      $Ref.null))))
; [eval] diz.Controller_m.Main_robot_controller != null
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      47
;  :arith-conflicts         3
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         2
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               93
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             527
;  :mk-clause               62
;  :num-allocs              4014091
;  :num-checks              108
;  :propagations            41
;  :quant-instantiations    25
;  :rlimit-count            133739)
(push) ; 4
(assert (not (< $Perm.No (+ $k@6@03 $k@17@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      48
;  :arith-conflicts         4
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               94
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             528
;  :mk-clause               62
;  :num-allocs              4014091
;  :num-checks              109
;  :propagations            41
;  :quant-instantiations    25
;  :rlimit-count            133799)
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      48
;  :arith-conflicts         4
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               95
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             528
;  :mk-clause               62
;  :num-allocs              4014091
;  :num-checks              110
;  :propagations            41
;  :quant-instantiations    25
;  :rlimit-count            133847)
(push) ; 4
(assert (not (< $Perm.No (+ $k@6@03 $k@17@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         5
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         4
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             529
;  :mk-clause               62
;  :num-allocs              4014091
;  :num-checks              111
;  :propagations            41
;  :quant-instantiations    25
;  :rlimit-count            133907)
(push) ; 4
(assert (not (= diz@2@03 $t@18@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         5
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         4
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             530
;  :mk-clause               62
;  :num-allocs              4014091
;  :num-checks              112
;  :propagations            41
;  :quant-instantiations    25
;  :rlimit-count            133967)
(declare-const $k@36@03 $Perm)
(assert ($Perm.isReadVar $k@36@03 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      24
;  :arith-assert-lower      71
;  :arith-assert-upper      50
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               98
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             534
;  :mk-clause               64
;  :num-allocs              4014091
;  :num-checks              113
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            134163)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      24
;  :arith-assert-lower      71
;  :arith-assert-upper      50
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               99
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             534
;  :mk-clause               64
;  :num-allocs              4014091
;  :num-checks              114
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            134211)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@36@03 $Perm.No) (< $Perm.No $k@36@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      24
;  :arith-assert-lower      71
;  :arith-assert-upper      50
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               100
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             534
;  :mk-clause               64
;  :num-allocs              4014091
;  :num-checks              115
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            134261)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@19@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      24
;  :arith-assert-lower      71
;  :arith-assert-upper      50
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               100
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             534
;  :mk-clause               64
;  :num-allocs              4014091
;  :num-checks              116
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            134272)
(assert (< $k@36@03 $k@19@03))
(assert (<= $Perm.No (- $k@19@03 $k@36@03)))
(assert (<= (- $k@19@03 $k@36@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@19@03 $k@36@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))))))
      $Ref.null))))
; [eval] diz.Controller_m.Main_robot.Robot_m == diz.Controller_m
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      51
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               101
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             537
;  :mk-clause               64
;  :num-allocs              4014091
;  :num-checks              117
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            134492)
(push) ; 4
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      51
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               102
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             537
;  :mk-clause               64
;  :num-allocs              4014091
;  :num-checks              118
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            134540)
(push) ; 4
(assert (not (< $Perm.No $k@19@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      51
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               103
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             537
;  :mk-clause               64
;  :num-allocs              4014091
;  :num-checks              119
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            134588)
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      51
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               104
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             537
;  :mk-clause               64
;  :num-allocs              4014091
;  :num-checks              120
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            134636)
; [eval] diz.Controller_m.Main_robot_controller == diz
(push) ; 4
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      51
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               105
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             537
;  :mk-clause               64
;  :num-allocs              4014091
;  :num-checks              121
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            134684)
(push) ; 4
(assert (not (< $Perm.No (+ $k@6@03 $k@17@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      52
;  :arith-conflicts         6
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         5
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             538
;  :mk-clause               64
;  :num-allocs              4014091
;  :num-checks              122
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            134744)
(set-option :timeout 0)
(push) ; 4
(assert (not (= $t@18@03 diz@2@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      52
;  :arith-conflicts         6
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         5
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   19
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              52
;  :final-checks            9
;  :max-generation          1
;  :max-memory              4.05
;  :memory                  4.05
;  :mk-bool-var             538
;  :mk-clause               64
;  :num-allocs              4014091
;  :num-checks              123
;  :propagations            42
;  :quant-instantiations    25
;  :rlimit-count            134796)
(assert (= $t@18@03 diz@2@03))
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
(assert ($Perm.isReadVar $k@25@03 $Perm.Write))
(assert ($Perm.isReadVar $k@27@03 $Perm.Write))
(assert ($Perm.isReadVar $k@28@03 $Perm.Write))
(assert ($Perm.isReadVar $k@29@03 $Perm.Write))
(assert ($Perm.isReadVar $k@30@03 $Perm.Write))
(assert (= $t@24@03 ($Snap.combine ($Snap.first $t@24@03) ($Snap.second $t@24@03))))
(assert (<= $Perm.No $k@25@03))
(assert (<= $k@25@03 $Perm.Write))
(assert (implies (< $Perm.No $k@25@03) (not (= diz@2@03 $Ref.null))))
(assert (=
  ($Snap.second $t@24@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@24@03))
    ($Snap.second ($Snap.second $t@24@03)))))
(assert (= ($Snap.first ($Snap.second $t@24@03)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@24@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@24@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@24@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
  $Snap.unit))
(assert (forall ((i__5@26@03 Int)) (!
  (implies
    (and
      (<
        i__5@26@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
      (<= 0 i__5@26@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
          i__5@26@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
            i__5@26@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
            i__5@26@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    i__5@26@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
(assert (<= $Perm.No $k@27@03))
(assert (<= $k@27@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@27@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))
(assert (<= $Perm.No $k@28@03))
(assert (<= $k@28@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@28@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))
(assert (<= $Perm.No $k@29@03))
(assert (<= $k@29@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@29@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))))
(assert (<= $Perm.No $k@30@03))
(assert (<= $k@30@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@30@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
  diz@2@03))
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
; (:added-eqs               724
;  :arith-assert-diseq      29
;  :arith-assert-lower      87
;  :arith-assert-upper      64
;  :arith-conflicts         6
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         5
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               108
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             664
;  :mk-clause               77
;  :num-allocs              4152495
;  :num-checks              126
;  :propagations            52
;  :quant-instantiations    34
;  :rlimit-count            140847
;  :time                    0.00)
; [then-branch: 12 | True | live]
; [else-branch: 12 | False | dead]
(push) ; 5
; [then-branch: 12 | True]
; [exec]
; __flatten_1__2 := diz.Controller_m
(push) ; 6
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               724
;  :arith-assert-diseq      29
;  :arith-assert-lower      87
;  :arith-assert-upper      64
;  :arith-conflicts         6
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         5
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             664
;  :mk-clause               77
;  :num-allocs              4152495
;  :num-checks              127
;  :propagations            52
;  :quant-instantiations    34
;  :rlimit-count            140900)
(declare-const __flatten_1__2@37@03 $Ref)
(assert (= __flatten_1__2@37@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03))))
; [exec]
; __flatten_3__4 := diz.Controller_m
(push) ; 6
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               725
;  :arith-assert-diseq      29
;  :arith-assert-lower      87
;  :arith-assert-upper      64
;  :arith-conflicts         6
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         5
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             665
;  :mk-clause               77
;  :num-allocs              4152495
;  :num-checks              128
;  :propagations            52
;  :quant-instantiations    34
;  :rlimit-count            141005)
(declare-const __flatten_3__4@38@03 $Ref)
(assert (= __flatten_3__4@38@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03))))
; [exec]
; __flatten_2__3 := __flatten_3__4.Main_process_state[1 := 2]
; [eval] __flatten_3__4.Main_process_state[1 := 2]
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) __flatten_3__4@38@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               726
;  :arith-assert-diseq      29
;  :arith-assert-lower      87
;  :arith-assert-upper      64
;  :arith-conflicts         6
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         5
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             666
;  :mk-clause               77
;  :num-allocs              4152495
;  :num-checks              129
;  :propagations            52
;  :quant-instantiations    34
;  :rlimit-count            141053)
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               726
;  :arith-assert-diseq      29
;  :arith-assert-lower      87
;  :arith-assert-upper      64
;  :arith-conflicts         6
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         5
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             666
;  :mk-clause               77
;  :num-allocs              4152495
;  :num-checks              130
;  :propagations            52
;  :quant-instantiations    34
;  :rlimit-count            141068)
(declare-const __flatten_2__3@39@03 Seq<Int>)
(assert (Seq_equal
  __flatten_2__3@39@03
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    1
    2)))
; [exec]
; __flatten_1__2.Main_process_state := __flatten_2__3
(set-option :timeout 10)
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) __flatten_1__2@37@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               736
;  :arith-add-rows          3
;  :arith-assert-diseq      30
;  :arith-assert-lower      91
;  :arith-assert-upper      66
;  :arith-conflicts         6
;  :arith-eq-adapter        40
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             689
;  :mk-clause               96
;  :num-allocs              4152495
;  :num-checks              131
;  :propagations            61
;  :quant-instantiations    39
;  :rlimit-count            141553)
(assert (not (= __flatten_1__2@37@03 $Ref.null)))
(push) ; 6
; Loop head block: Check well-definedness of invariant
(declare-const $t@40@03 $Snap)
(assert (= $t@40@03 ($Snap.combine ($Snap.first $t@40@03) ($Snap.second $t@40@03))))
(declare-const $k@41@03 $Perm)
(assert ($Perm.isReadVar $k@41@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@41@03 $Perm.No) (< $Perm.No $k@41@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               742
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      67
;  :arith-conflicts         6
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               111
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             695
;  :mk-clause               98
;  :num-allocs              4152495
;  :num-checks              132
;  :propagations            62
;  :quant-instantiations    39
;  :rlimit-count            141901)
(assert (<= $Perm.No $k@41@03))
(assert (<= $k@41@03 $Perm.Write))
(assert (implies (< $Perm.No $k@41@03) (not (= diz@2@03 $Ref.null))))
(assert (=
  ($Snap.second $t@40@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@40@03))
    ($Snap.second ($Snap.second $t@40@03)))))
(assert (= ($Snap.first ($Snap.second $t@40@03)) $Snap.unit))
; [eval] diz.Controller_m != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               748
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      68
;  :arith-conflicts         6
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               112
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             698
;  :mk-clause               98
;  :num-allocs              4152495
;  :num-checks              133
;  :propagations            62
;  :quant-instantiations    39
;  :rlimit-count            142144)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@40@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@40@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               754
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      68
;  :arith-conflicts         6
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               113
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             701
;  :mk-clause               98
;  :num-allocs              4152495
;  :num-checks              134
;  :propagations            62
;  :quant-instantiations    40
;  :rlimit-count            142416)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@40@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               759
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      68
;  :arith-conflicts         6
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               114
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             702
;  :mk-clause               98
;  :num-allocs              4152495
;  :num-checks              135
;  :propagations            62
;  :quant-instantiations    40
;  :rlimit-count            142593)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
  $Snap.unit))
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               765
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      93
;  :arith-assert-upper      68
;  :arith-conflicts         6
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               115
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             704
;  :mk-clause               98
;  :num-allocs              4295029
;  :num-checks              136
;  :propagations            62
;  :quant-instantiations    40
;  :rlimit-count            142812)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               772
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      95
;  :arith-assert-upper      69
;  :arith-conflicts         6
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               116
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             710
;  :mk-clause               98
;  :num-allocs              4295029
;  :num-checks              137
;  :propagations            62
;  :quant-instantiations    42
;  :rlimit-count            143142)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
  $Snap.unit))
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               778
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      95
;  :arith-assert-upper      69
;  :arith-conflicts         6
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               117
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             712
;  :mk-clause               98
;  :num-allocs              4295029
;  :num-checks              138
;  :propagations            62
;  :quant-instantiations    42
;  :rlimit-count            143381)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))
  $Snap.unit))
; [eval] (forall i__6: Int :: { diz.Controller_m.Main_process_state[i__6] } 0 <= i__6 && i__6 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__6] == -1 || 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|)
(declare-const i__6@42@03 Int)
(push) ; 7
; [eval] 0 <= i__6 && i__6 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__6] == -1 || 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__6 && i__6 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__6
(push) ; 8
; [then-branch: 13 | 0 <= i__6@42@03 | live]
; [else-branch: 13 | !(0 <= i__6@42@03) | live]
(push) ; 9
; [then-branch: 13 | 0 <= i__6@42@03]
(assert (<= 0 i__6@42@03))
; [eval] i__6 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 10
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               786
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      98
;  :arith-assert-upper      70
;  :arith-conflicts         6
;  :arith-eq-adapter        43
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               118
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             720
;  :mk-clause               98
;  :num-allocs              4295029
;  :num-checks              139
;  :propagations            62
;  :quant-instantiations    44
;  :rlimit-count            143819)
(pop) ; 9
(push) ; 9
; [else-branch: 13 | !(0 <= i__6@42@03)]
(assert (not (<= 0 i__6@42@03)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 14 | i__6@42@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i__6@42@03 | live]
; [else-branch: 14 | !(i__6@42@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i__6@42@03) | live]
(push) ; 9
; [then-branch: 14 | i__6@42@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i__6@42@03]
(assert (and
  (<
    i__6@42@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
  (<= 0 i__6@42@03)))
; [eval] diz.Controller_m.Main_process_state[i__6] == -1 || 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__6] == -1
; [eval] diz.Controller_m.Main_process_state[i__6]
(push) ; 10
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               786
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      99
;  :arith-assert-upper      71
;  :arith-conflicts         6
;  :arith-eq-adapter        43
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               119
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             722
;  :mk-clause               98
;  :num-allocs              4295029
;  :num-checks              140
;  :propagations            62
;  :quant-instantiations    44
;  :rlimit-count            143976)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__6@42@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               786
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      99
;  :arith-assert-upper      71
;  :arith-conflicts         6
;  :arith-eq-adapter        43
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               119
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             722
;  :mk-clause               98
;  :num-allocs              4295029
;  :num-checks              141
;  :propagations            62
;  :quant-instantiations    44
;  :rlimit-count            143985)
; [eval] -1
(push) ; 10
; [then-branch: 15 | First:(Second:(Second:(Second:($t@40@03))))[i__6@42@03] == -1 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:($t@40@03))))[i__6@42@03] != -1 | live]
(push) ; 11
; [then-branch: 15 | First:(Second:(Second:(Second:($t@40@03))))[i__6@42@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i__6@42@03)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 15 | First:(Second:(Second:(Second:($t@40@03))))[i__6@42@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
      i__6@42@03)
    (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__6]
; [eval] diz.Controller_m.Main_process_state[i__6]
(set-option :timeout 10)
(push) ; 12
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               786
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      99
;  :arith-assert-upper      71
;  :arith-conflicts         6
;  :arith-eq-adapter        43
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               120
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             723
;  :mk-clause               98
;  :num-allocs              4295029
;  :num-checks              142
;  :propagations            62
;  :quant-instantiations    44
;  :rlimit-count            144199)
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i__6@42@03 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               786
;  :arith-add-rows          3
;  :arith-assert-diseq      31
;  :arith-assert-lower      99
;  :arith-assert-upper      71
;  :arith-conflicts         6
;  :arith-eq-adapter        43
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               120
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             723
;  :mk-clause               98
;  :num-allocs              4295029
;  :num-checks              143
;  :propagations            62
;  :quant-instantiations    44
;  :rlimit-count            144208)
(push) ; 12
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@40@03))))[i__6@42@03] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@40@03))))[i__6@42@03]) | live]
(push) ; 13
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@40@03))))[i__6@42@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i__6@42@03)))
; [eval] diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__6]
(set-option :timeout 10)
(push) ; 14
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               786
;  :arith-add-rows          3
;  :arith-assert-diseq      32
;  :arith-assert-lower      102
;  :arith-assert-upper      71
;  :arith-conflicts         6
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             726
;  :mk-clause               99
;  :num-allocs              4295029
;  :num-checks              144
;  :propagations            62
;  :quant-instantiations    44
;  :rlimit-count            144371)
(set-option :timeout 0)
(push) ; 14
(assert (not (>= i__6@42@03 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               786
;  :arith-add-rows          3
;  :arith-assert-diseq      32
;  :arith-assert-lower      102
;  :arith-assert-upper      71
;  :arith-conflicts         6
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             726
;  :mk-clause               99
;  :num-allocs              4295029
;  :num-checks              145
;  :propagations            62
;  :quant-instantiations    44
;  :rlimit-count            144380)
; [eval] |diz.Controller_m.Main_event_state|
(set-option :timeout 10)
(push) ; 14
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               786
;  :arith-add-rows          3
;  :arith-assert-diseq      32
;  :arith-assert-lower      102
;  :arith-assert-upper      71
;  :arith-conflicts         6
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               122
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              64
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             726
;  :mk-clause               99
;  :num-allocs              4295029
;  :num-checks              146
;  :propagations            62
;  :quant-instantiations    44
;  :rlimit-count            144428)
(pop) ; 13
(push) ; 13
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@40@03))))[i__6@42@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
      i__6@42@03))))
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
; [else-branch: 14 | !(i__6@42@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i__6@42@03)]
(assert (not
  (and
    (<
      i__6@42@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
    (<= 0 i__6@42@03))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__6@42@03 Int)) (!
  (implies
    (and
      (<
        i__6@42@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
      (<= 0 i__6@42@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
          i__6@42@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i__6@42@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i__6@42@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i__6@42@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               791
;  :arith-add-rows          3
;  :arith-assert-diseq      32
;  :arith-assert-lower      102
;  :arith-assert-upper      71
;  :arith-conflicts         6
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               123
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             728
;  :mk-clause               99
;  :num-allocs              4295029
;  :num-checks              147
;  :propagations            62
;  :quant-instantiations    44
;  :rlimit-count            145053)
(declare-const $k@43@03 $Perm)
(assert ($Perm.isReadVar $k@43@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@43@03 $Perm.No) (< $Perm.No $k@43@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               791
;  :arith-add-rows          3
;  :arith-assert-diseq      33
;  :arith-assert-lower      104
;  :arith-assert-upper      72
;  :arith-conflicts         6
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               124
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             732
;  :mk-clause               101
;  :num-allocs              4295029
;  :num-checks              148
;  :propagations            63
;  :quant-instantiations    44
;  :rlimit-count            145251)
(assert (<= $Perm.No $k@43@03))
(assert (<= $k@43@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@43@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_robot != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               797
;  :arith-add-rows          3
;  :arith-assert-diseq      33
;  :arith-assert-lower      104
;  :arith-assert-upper      73
;  :arith-conflicts         6
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             735
;  :mk-clause               101
;  :num-allocs              4295029
;  :num-checks              149
;  :propagations            63
;  :quant-instantiations    44
;  :rlimit-count            145574)
(push) ; 7
(assert (not (< $Perm.No $k@43@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               797
;  :arith-add-rows          3
;  :arith-assert-diseq      33
;  :arith-assert-lower      104
;  :arith-assert-upper      73
;  :arith-conflicts         6
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               126
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             735
;  :mk-clause               101
;  :num-allocs              4295029
;  :num-checks              150
;  :propagations            63
;  :quant-instantiations    44
;  :rlimit-count            145622)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               803
;  :arith-add-rows          3
;  :arith-assert-diseq      33
;  :arith-assert-lower      104
;  :arith-assert-upper      73
;  :arith-conflicts         6
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               127
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             738
;  :mk-clause               101
;  :num-allocs              4295029
;  :num-checks              151
;  :propagations            63
;  :quant-instantiations    45
;  :rlimit-count            145978)
(declare-const $k@44@03 $Perm)
(assert ($Perm.isReadVar $k@44@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@44@03 $Perm.No) (< $Perm.No $k@44@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               803
;  :arith-add-rows          3
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      74
;  :arith-conflicts         6
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               128
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             742
;  :mk-clause               103
;  :num-allocs              4295029
;  :num-checks              152
;  :propagations            64
;  :quant-instantiations    45
;  :rlimit-count            146177)
(assert (<= $Perm.No $k@44@03))
(assert (<= $k@44@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@44@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_robot_sensor != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               809
;  :arith-add-rows          3
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      75
;  :arith-conflicts         6
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               129
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             745
;  :mk-clause               103
;  :num-allocs              4295029
;  :num-checks              153
;  :propagations            64
;  :quant-instantiations    45
;  :rlimit-count            146520)
(push) ; 7
(assert (not (< $Perm.No $k@44@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               809
;  :arith-add-rows          3
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      75
;  :arith-conflicts         6
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               130
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             745
;  :mk-clause               103
;  :num-allocs              4295029
;  :num-checks              154
;  :propagations            64
;  :quant-instantiations    45
;  :rlimit-count            146568)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               815
;  :arith-add-rows          3
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      75
;  :arith-conflicts         6
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               131
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             748
;  :mk-clause               103
;  :num-allocs              4295029
;  :num-checks              155
;  :propagations            64
;  :quant-instantiations    46
;  :rlimit-count            146942)
(push) ; 7
(assert (not (< $Perm.No $k@44@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               815
;  :arith-add-rows          3
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      75
;  :arith-conflicts         6
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               132
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             748
;  :mk-clause               103
;  :num-allocs              4295029
;  :num-checks              156
;  :propagations            64
;  :quant-instantiations    46
;  :rlimit-count            146990)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               820
;  :arith-add-rows          3
;  :arith-assert-diseq      34
;  :arith-assert-lower      106
;  :arith-assert-upper      75
;  :arith-conflicts         6
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               133
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             749
;  :mk-clause               103
;  :num-allocs              4295029
;  :num-checks              157
;  :propagations            64
;  :quant-instantiations    46
;  :rlimit-count            147267)
(declare-const $k@45@03 $Perm)
(assert ($Perm.isReadVar $k@45@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@45@03 $Perm.No) (< $Perm.No $k@45@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               820
;  :arith-add-rows          3
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      76
;  :arith-conflicts         6
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               134
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             753
;  :mk-clause               105
;  :num-allocs              4295029
;  :num-checks              158
;  :propagations            65
;  :quant-instantiations    46
;  :rlimit-count            147466)
(assert (<= $Perm.No $k@45@03))
(assert (<= $k@45@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@45@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_robot_controller != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               826
;  :arith-add-rows          3
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      77
;  :arith-conflicts         6
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               135
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             756
;  :mk-clause               105
;  :num-allocs              4295029
;  :num-checks              159
;  :propagations            65
;  :quant-instantiations    46
;  :rlimit-count            147839)
(push) ; 7
(assert (not (< $Perm.No $k@45@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               826
;  :arith-add-rows          3
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      77
;  :arith-conflicts         6
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               136
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             756
;  :mk-clause               105
;  :num-allocs              4295029
;  :num-checks              160
;  :propagations            65
;  :quant-instantiations    46
;  :rlimit-count            147887)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               832
;  :arith-add-rows          3
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      77
;  :arith-conflicts         6
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               137
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             759
;  :mk-clause               105
;  :num-allocs              4295029
;  :num-checks              161
;  :propagations            65
;  :quant-instantiations    47
;  :rlimit-count            148293)
(push) ; 7
(assert (not (< $Perm.No $k@45@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               832
;  :arith-add-rows          3
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      77
;  :arith-conflicts         6
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               138
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             759
;  :mk-clause               105
;  :num-allocs              4295029
;  :num-checks              162
;  :propagations            65
;  :quant-instantiations    47
;  :rlimit-count            148341)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               837
;  :arith-add-rows          3
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      77
;  :arith-conflicts         6
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               139
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             760
;  :mk-clause               105
;  :num-allocs              4295029
;  :num-checks              163
;  :propagations            65
;  :quant-instantiations    47
;  :rlimit-count            148648)
(push) ; 7
(assert (not (< $Perm.No $k@43@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               837
;  :arith-add-rows          3
;  :arith-assert-diseq      35
;  :arith-assert-lower      108
;  :arith-assert-upper      77
;  :arith-conflicts         6
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               140
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             760
;  :mk-clause               105
;  :num-allocs              4295029
;  :num-checks              164
;  :propagations            65
;  :quant-instantiations    47
;  :rlimit-count            148696)
(declare-const $k@46@03 $Perm)
(assert ($Perm.isReadVar $k@46@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@46@03 $Perm.No) (< $Perm.No $k@46@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               837
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      78
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               141
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             764
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              165
;  :propagations            66
;  :quant-instantiations    47
;  :rlimit-count            148894)
(assert (<= $Perm.No $k@46@03))
(assert (<= $k@46@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@46@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_robot.Robot_m == diz.Controller_m
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               843
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               142
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             767
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              166
;  :propagations            66
;  :quant-instantiations    47
;  :rlimit-count            149297)
(push) ; 7
(assert (not (< $Perm.No $k@43@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               843
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               143
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             767
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              167
;  :propagations            66
;  :quant-instantiations    47
;  :rlimit-count            149345)
(push) ; 7
(assert (not (< $Perm.No $k@46@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               843
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               144
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             767
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              168
;  :propagations            66
;  :quant-instantiations    47
;  :rlimit-count            149393)
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               843
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               145
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             767
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              169
;  :propagations            66
;  :quant-instantiations    47
;  :rlimit-count            149441)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_robot_controller == diz
(push) ; 7
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               848
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               146
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             770
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              170
;  :propagations            66
;  :quant-instantiations    48
;  :rlimit-count            149825)
(push) ; 7
(assert (not (< $Perm.No $k@45@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               848
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               147
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             770
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              171
;  :propagations            66
;  :quant-instantiations    48
;  :rlimit-count            149873)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
  diz@2@03))
; Loop head block: Check well-definedness of edge conditions
(push) ; 7
; [eval] diz.Controller_m.Main_process_state[1] != -1 || diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_process_state[1] != -1
; [eval] diz.Controller_m.Main_process_state[1]
(push) ; 8
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               851
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               148
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             771
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              172
;  :propagations            66
;  :quant-instantiations    48
;  :rlimit-count            150119)
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               851
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               148
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             771
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              173
;  :propagations            66
;  :quant-instantiations    48
;  :rlimit-count            150134)
; [eval] -1
(push) ; 8
; [then-branch: 17 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1 | live]
; [else-branch: 17 | First:(Second:(Second:(Second:($t@40@03))))[1] == -1 | live]
(push) ; 9
; [then-branch: 17 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
      1)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 17 | First:(Second:(Second:(Second:($t@40@03))))[1] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    1)
  (- 0 1)))
; [eval] diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_event_state[2]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               852
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             772
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              174
;  :propagations            66
;  :quant-instantiations    48
;  :rlimit-count            150329)
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               852
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             772
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              175
;  :propagations            66
;  :quant-instantiations    48
;  :rlimit-count            150344)
; [eval] -2
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(push) ; 7
; [eval] !(diz.Controller_m.Main_process_state[1] != -1 || diz.Controller_m.Main_event_state[2] != -2)
; [eval] diz.Controller_m.Main_process_state[1] != -1 || diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_process_state[1] != -1
; [eval] diz.Controller_m.Main_process_state[1]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               852
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               150
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             772
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              176
;  :propagations            66
;  :quant-instantiations    48
;  :rlimit-count            150397)
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               852
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               150
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             772
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              177
;  :propagations            66
;  :quant-instantiations    48
;  :rlimit-count            150412)
; [eval] -1
(push) ; 8
; [then-branch: 18 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:($t@40@03))))[1] == -1 | live]
(push) ; 9
; [then-branch: 18 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
      1)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 18 | First:(Second:(Second:(Second:($t@40@03))))[1] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    1)
  (- 0 1)))
; [eval] diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_event_state[2]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               853
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               151
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             773
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              178
;  :propagations            66
;  :quant-instantiations    48
;  :rlimit-count            150603)
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               853
;  :arith-add-rows          3
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               151
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              65
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             773
;  :mk-clause               107
;  :num-allocs              4295029
;  :num-checks              179
;  :propagations            66
;  :quant-instantiations    48
;  :rlimit-count            150618)
; [eval] -2
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(pop) ; 6
(push) ; 6
; Loop head block: Establish invariant
(declare-const $k@47@03 $Perm)
(assert ($Perm.isReadVar $k@47@03 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@47@03 $Perm.No) (< $Perm.No $k@47@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               853
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      112
;  :arith-assert-upper      80
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               152
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             777
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              180
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            150821)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@25@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               853
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      112
;  :arith-assert-upper      80
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         7
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               152
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             777
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              181
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            150832)
(assert (< $k@47@03 $k@25@03))
(assert (<= $Perm.No (- $k@25@03 $k@47@03)))
(assert (<= (- $k@25@03 $k@47@03) $Perm.Write))
(assert (implies (< $Perm.No (- $k@25@03 $k@47@03)) (not (= diz@2@03 $Ref.null))))
; [eval] diz.Controller_m != null
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.03s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               853
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      114
;  :arith-assert-upper      81
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               153
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             780
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              182
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            151046)
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               853
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      114
;  :arith-assert-upper      81
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             780
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              183
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            151094)
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               853
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      114
;  :arith-assert-upper      81
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             780
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              184
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            151142)
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               853
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      114
;  :arith-assert-upper      81
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               156
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             780
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              185
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            151190)
(set-option :timeout 0)
(push) ; 7
(assert (not (= (Seq_length __flatten_2__3@39@03) 2)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               853
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      114
;  :arith-assert-upper      81
;  :arith-conflicts         6
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               157
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             783
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              186
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            151264)
(assert (= (Seq_length __flatten_2__3@39@03) 2))
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               854
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      115
;  :arith-assert-upper      82
;  :arith-conflicts         6
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               158
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             786
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              187
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            151363)
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               854
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      115
;  :arith-assert-upper      82
;  :arith-conflicts         6
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               159
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             786
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              188
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            151411)
; [eval] (forall i__6: Int :: { diz.Controller_m.Main_process_state[i__6] } 0 <= i__6 && i__6 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__6] == -1 || 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|)
(declare-const i__6@48@03 Int)
(push) ; 7
; [eval] 0 <= i__6 && i__6 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__6] == -1 || 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__6 && i__6 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__6
(push) ; 8
; [then-branch: 19 | 0 <= i__6@48@03 | live]
; [else-branch: 19 | !(0 <= i__6@48@03) | live]
(push) ; 9
; [then-branch: 19 | 0 <= i__6@48@03]
(assert (<= 0 i__6@48@03))
; [eval] i__6 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 10
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               854
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      116
;  :arith-assert-upper      82
;  :arith-conflicts         6
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               160
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             787
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              189
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            151511)
(pop) ; 9
(push) ; 9
; [else-branch: 19 | !(0 <= i__6@48@03)]
(assert (not (<= 0 i__6@48@03)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 20 | i__6@48@03 < |__flatten_2__3@39@03| && 0 <= i__6@48@03 | live]
; [else-branch: 20 | !(i__6@48@03 < |__flatten_2__3@39@03| && 0 <= i__6@48@03) | live]
(push) ; 9
; [then-branch: 20 | i__6@48@03 < |__flatten_2__3@39@03| && 0 <= i__6@48@03]
(assert (and (< i__6@48@03 (Seq_length __flatten_2__3@39@03)) (<= 0 i__6@48@03)))
; [eval] diz.Controller_m.Main_process_state[i__6] == -1 || 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__6] == -1
; [eval] diz.Controller_m.Main_process_state[i__6]
(push) ; 10
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               854
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      117
;  :arith-assert-upper      83
;  :arith-conflicts         6
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               161
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             789
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              190
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            151668)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__6@48@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               854
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      117
;  :arith-assert-upper      83
;  :arith-conflicts         6
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               161
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             789
;  :mk-clause               109
;  :num-allocs              4295029
;  :num-checks              191
;  :propagations            67
;  :quant-instantiations    48
;  :rlimit-count            151677)
; [eval] -1
(push) ; 10
; [then-branch: 21 | __flatten_2__3@39@03[i__6@48@03] == -1 | live]
; [else-branch: 21 | __flatten_2__3@39@03[i__6@48@03] != -1 | live]
(push) ; 11
; [then-branch: 21 | __flatten_2__3@39@03[i__6@48@03] == -1]
(assert (= (Seq_index __flatten_2__3@39@03 i__6@48@03) (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 21 | __flatten_2__3@39@03[i__6@48@03] != -1]
(assert (not (= (Seq_index __flatten_2__3@39@03 i__6@48@03) (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__6]
; [eval] diz.Controller_m.Main_process_state[i__6]
(set-option :timeout 10)
(push) ; 12
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               855
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      117
;  :arith-assert-upper      84
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               162
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             797
;  :mk-clause               119
;  :num-allocs              4295029
;  :num-checks              192
;  :propagations            67
;  :quant-instantiations    49
;  :rlimit-count            151884)
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i__6@48@03 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               855
;  :arith-add-rows          3
;  :arith-assert-diseq      37
;  :arith-assert-lower      117
;  :arith-assert-upper      84
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               162
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             797
;  :mk-clause               119
;  :num-allocs              4295029
;  :num-checks              193
;  :propagations            67
;  :quant-instantiations    49
;  :rlimit-count            151893)
(push) ; 12
; [then-branch: 22 | 0 <= __flatten_2__3@39@03[i__6@48@03] | live]
; [else-branch: 22 | !(0 <= __flatten_2__3@39@03[i__6@48@03]) | live]
(push) ; 13
; [then-branch: 22 | 0 <= __flatten_2__3@39@03[i__6@48@03]]
(assert (<= 0 (Seq_index __flatten_2__3@39@03 i__6@48@03)))
; [eval] diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__6]
(set-option :timeout 10)
(push) ; 14
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               855
;  :arith-add-rows          3
;  :arith-assert-diseq      38
;  :arith-assert-lower      120
;  :arith-assert-upper      84
;  :arith-conflicts         6
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               163
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             800
;  :mk-clause               120
;  :num-allocs              4295029
;  :num-checks              194
;  :propagations            67
;  :quant-instantiations    49
;  :rlimit-count            152006)
(set-option :timeout 0)
(push) ; 14
(assert (not (>= i__6@48@03 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               855
;  :arith-add-rows          3
;  :arith-assert-diseq      38
;  :arith-assert-lower      120
;  :arith-assert-upper      84
;  :arith-conflicts         6
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               163
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             800
;  :mk-clause               120
;  :num-allocs              4295029
;  :num-checks              195
;  :propagations            67
;  :quant-instantiations    49
;  :rlimit-count            152015)
; [eval] |diz.Controller_m.Main_event_state|
(set-option :timeout 10)
(push) ; 14
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               855
;  :arith-add-rows          3
;  :arith-assert-diseq      38
;  :arith-assert-lower      120
;  :arith-assert-upper      84
;  :arith-conflicts         6
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         7
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               164
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               84
;  :del-clause              75
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             800
;  :mk-clause               120
;  :num-allocs              4295029
;  :num-checks              196
;  :propagations            67
;  :quant-instantiations    49
;  :rlimit-count            152063)
(pop) ; 13
(push) ; 13
; [else-branch: 22 | !(0 <= __flatten_2__3@39@03[i__6@48@03])]
(assert (not (<= 0 (Seq_index __flatten_2__3@39@03 i__6@48@03))))
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
; [else-branch: 20 | !(i__6@48@03 < |__flatten_2__3@39@03| && 0 <= i__6@48@03)]
(assert (not (and (< i__6@48@03 (Seq_length __flatten_2__3@39@03)) (<= 0 i__6@48@03))))
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
(assert (not (forall ((i__6@48@03 Int)) (!
  (implies
    (and (< i__6@48@03 (Seq_length __flatten_2__3@39@03)) (<= 0 i__6@48@03))
    (or
      (= (Seq_index __flatten_2__3@39@03 i__6@48@03) (- 0 1))
      (and
        (<
          (Seq_index __flatten_2__3@39@03 i__6@48@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
        (<= 0 (Seq_index __flatten_2__3@39@03 i__6@48@03)))))
  :pattern ((Seq_index __flatten_2__3@39@03 i__6@48@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      43
;  :arith-assert-lower      134
;  :arith-assert-upper      96
;  :arith-conflicts         8
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               170
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             838
;  :mk-clause               165
;  :num-allocs              4295029
;  :num-checks              197
;  :propagations            97
;  :quant-instantiations    52
;  :rlimit-count            152693)
(assert (forall ((i__6@48@03 Int)) (!
  (implies
    (and (< i__6@48@03 (Seq_length __flatten_2__3@39@03)) (<= 0 i__6@48@03))
    (or
      (= (Seq_index __flatten_2__3@39@03 i__6@48@03) (- 0 1))
      (and
        (<
          (Seq_index __flatten_2__3@39@03 i__6@48@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
        (<= 0 (Seq_index __flatten_2__3@39@03 i__6@48@03)))))
  :pattern ((Seq_index __flatten_2__3@39@03 i__6@48@03))
  :qid |prog.l<no position>|)))
(declare-const $k@49@03 $Perm)
(assert ($Perm.isReadVar $k@49@03 $Perm.Write))
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      44
;  :arith-assert-lower      136
;  :arith-assert-upper      97
;  :arith-conflicts         8
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               171
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             843
;  :mk-clause               167
;  :num-allocs              4295029
;  :num-checks              198
;  :propagations            98
;  :quant-instantiations    52
;  :rlimit-count            153162)
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@49@03 $Perm.No) (< $Perm.No $k@49@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      44
;  :arith-assert-lower      136
;  :arith-assert-upper      97
;  :arith-conflicts         8
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               172
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             843
;  :mk-clause               167
;  :num-allocs              4295029
;  :num-checks              199
;  :propagations            98
;  :quant-instantiations    52
;  :rlimit-count            153212)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@27@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      44
;  :arith-assert-lower      136
;  :arith-assert-upper      97
;  :arith-conflicts         8
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               172
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             843
;  :mk-clause               167
;  :num-allocs              4295029
;  :num-checks              200
;  :propagations            98
;  :quant-instantiations    52
;  :rlimit-count            153223)
(assert (< $k@49@03 $k@27@03))
(assert (<= $Perm.No (- $k@27@03 $k@49@03)))
(assert (<= (- $k@27@03 $k@49@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@27@03 $k@49@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) $Ref.null))))
; [eval] diz.Controller_m.Main_robot != null
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      44
;  :arith-assert-lower      138
;  :arith-assert-upper      98
;  :arith-conflicts         8
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               173
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             846
;  :mk-clause               167
;  :num-allocs              4295029
;  :num-checks              201
;  :propagations            98
;  :quant-instantiations    52
;  :rlimit-count            153431)
(push) ; 7
(assert (not (< $Perm.No $k@27@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      44
;  :arith-assert-lower      138
;  :arith-assert-upper      98
;  :arith-conflicts         8
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               174
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             846
;  :mk-clause               167
;  :num-allocs              4295029
;  :num-checks              202
;  :propagations            98
;  :quant-instantiations    52
;  :rlimit-count            153479)
(declare-const $k@50@03 $Perm)
(assert ($Perm.isReadVar $k@50@03 $Perm.Write))
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      45
;  :arith-assert-lower      140
;  :arith-assert-upper      99
;  :arith-conflicts         8
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               175
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             850
;  :mk-clause               169
;  :num-allocs              4295029
;  :num-checks              203
;  :propagations            99
;  :quant-instantiations    52
;  :rlimit-count            153675)
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@50@03 $Perm.No) (< $Perm.No $k@50@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      45
;  :arith-assert-lower      140
;  :arith-assert-upper      99
;  :arith-conflicts         8
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               176
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             850
;  :mk-clause               169
;  :num-allocs              4295029
;  :num-checks              204
;  :propagations            99
;  :quant-instantiations    52
;  :rlimit-count            153725)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@28@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      45
;  :arith-assert-lower      140
;  :arith-assert-upper      99
;  :arith-conflicts         8
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               176
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             850
;  :mk-clause               169
;  :num-allocs              4295029
;  :num-checks              205
;  :propagations            99
;  :quant-instantiations    52
;  :rlimit-count            153736)
(assert (< $k@50@03 $k@28@03))
(assert (<= $Perm.No (- $k@28@03 $k@50@03)))
(assert (<= (- $k@28@03 $k@50@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@28@03 $k@50@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) $Ref.null))))
; [eval] diz.Controller_m.Main_robot_sensor != null
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      45
;  :arith-assert-lower      142
;  :arith-assert-upper      100
;  :arith-conflicts         8
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         11
;  :arith-pivots            10
;  :binary-propagations     16
;  :conflicts               177
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             853
;  :mk-clause               169
;  :num-allocs              4295029
;  :num-checks              206
;  :propagations            99
;  :quant-instantiations    52
;  :rlimit-count            153956)
(push) ; 7
(assert (not (< $Perm.No $k@28@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      45
;  :arith-assert-lower      142
;  :arith-assert-upper      100
;  :arith-conflicts         8
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         11
;  :arith-pivots            10
;  :binary-propagations     16
;  :conflicts               178
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             853
;  :mk-clause               169
;  :num-allocs              4295029
;  :num-checks              207
;  :propagations            99
;  :quant-instantiations    52
;  :rlimit-count            154004)
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      45
;  :arith-assert-lower      142
;  :arith-assert-upper      100
;  :arith-conflicts         8
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         11
;  :arith-pivots            10
;  :binary-propagations     16
;  :conflicts               179
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             853
;  :mk-clause               169
;  :num-allocs              4295029
;  :num-checks              208
;  :propagations            99
;  :quant-instantiations    52
;  :rlimit-count            154052)
(push) ; 7
(assert (not (< $Perm.No $k@28@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      45
;  :arith-assert-lower      142
;  :arith-assert-upper      100
;  :arith-conflicts         8
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         11
;  :arith-pivots            10
;  :binary-propagations     16
;  :conflicts               180
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             853
;  :mk-clause               169
;  :num-allocs              4295029
;  :num-checks              209
;  :propagations            99
;  :quant-instantiations    52
;  :rlimit-count            154100)
(declare-const $k@51@03 $Perm)
(assert ($Perm.isReadVar $k@51@03 $Perm.Write))
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      46
;  :arith-assert-lower      144
;  :arith-assert-upper      101
;  :arith-conflicts         8
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         11
;  :arith-pivots            10
;  :binary-propagations     16
;  :conflicts               181
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             857
;  :mk-clause               171
;  :num-allocs              4295029
;  :num-checks              210
;  :propagations            100
;  :quant-instantiations    52
;  :rlimit-count            154296)
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@51@03 $Perm.No) (< $Perm.No $k@51@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      46
;  :arith-assert-lower      144
;  :arith-assert-upper      101
;  :arith-conflicts         8
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         11
;  :arith-pivots            10
;  :binary-propagations     16
;  :conflicts               182
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             857
;  :mk-clause               171
;  :num-allocs              4295029
;  :num-checks              211
;  :propagations            100
;  :quant-instantiations    52
;  :rlimit-count            154346)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@29@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      46
;  :arith-assert-lower      144
;  :arith-assert-upper      101
;  :arith-conflicts         8
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         11
;  :arith-pivots            10
;  :binary-propagations     16
;  :conflicts               182
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             857
;  :mk-clause               171
;  :num-allocs              4295029
;  :num-checks              212
;  :propagations            100
;  :quant-instantiations    52
;  :rlimit-count            154357)
(assert (< $k@51@03 $k@29@03))
(assert (<= $Perm.No (- $k@29@03 $k@51@03)))
(assert (<= (- $k@29@03 $k@51@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@29@03 $k@51@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)) $Ref.null))))
; [eval] diz.Controller_m.Main_robot_controller != null
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      46
;  :arith-assert-lower      146
;  :arith-assert-upper      102
;  :arith-conflicts         8
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         11
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               183
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             860
;  :mk-clause               171
;  :num-allocs              4295029
;  :num-checks              213
;  :propagations            100
;  :quant-instantiations    52
;  :rlimit-count            154571)
(push) ; 7
(assert (not (< $Perm.No $k@29@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      46
;  :arith-assert-lower      146
;  :arith-assert-upper      102
;  :arith-conflicts         8
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         11
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               184
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             860
;  :mk-clause               171
;  :num-allocs              4295029
;  :num-checks              214
;  :propagations            100
;  :quant-instantiations    52
;  :rlimit-count            154619)
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      46
;  :arith-assert-lower      146
;  :arith-assert-upper      102
;  :arith-conflicts         8
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         11
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               185
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             860
;  :mk-clause               171
;  :num-allocs              4295029
;  :num-checks              215
;  :propagations            100
;  :quant-instantiations    52
;  :rlimit-count            154667)
(push) ; 7
(assert (not (< $Perm.No $k@29@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      46
;  :arith-assert-lower      146
;  :arith-assert-upper      102
;  :arith-conflicts         8
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         11
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               186
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             860
;  :mk-clause               171
;  :num-allocs              4295029
;  :num-checks              216
;  :propagations            100
;  :quant-instantiations    52
;  :rlimit-count            154715)
(declare-const $k@52@03 $Perm)
(assert ($Perm.isReadVar $k@52@03 $Perm.Write))
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      47
;  :arith-assert-lower      148
;  :arith-assert-upper      103
;  :arith-conflicts         8
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         11
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               187
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             864
;  :mk-clause               173
;  :num-allocs              4295029
;  :num-checks              217
;  :propagations            101
;  :quant-instantiations    52
;  :rlimit-count            154911)
(push) ; 7
(assert (not (< $Perm.No $k@27@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      47
;  :arith-assert-lower      148
;  :arith-assert-upper      103
;  :arith-conflicts         8
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         11
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             864
;  :mk-clause               173
;  :num-allocs              4295029
;  :num-checks              218
;  :propagations            101
;  :quant-instantiations    52
;  :rlimit-count            154959)
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@52@03 $Perm.No) (< $Perm.No $k@52@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      47
;  :arith-assert-lower      148
;  :arith-assert-upper      103
;  :arith-conflicts         8
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         11
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               189
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             864
;  :mk-clause               173
;  :num-allocs              4295029
;  :num-checks              219
;  :propagations            101
;  :quant-instantiations    52
;  :rlimit-count            155009)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@30@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      47
;  :arith-assert-lower      148
;  :arith-assert-upper      103
;  :arith-conflicts         8
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         11
;  :arith-pivots            11
;  :binary-propagations     16
;  :conflicts               189
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             864
;  :mk-clause               173
;  :num-allocs              4295029
;  :num-checks              220
;  :propagations            101
;  :quant-instantiations    52
;  :rlimit-count            155020)
(assert (< $k@52@03 $k@30@03))
(assert (<= $Perm.No (- $k@30@03 $k@52@03)))
(assert (<= (- $k@30@03 $k@52@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@30@03 $k@52@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
      $Ref.null))))
; [eval] diz.Controller_m.Main_robot.Robot_m == diz.Controller_m
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.03s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      47
;  :arith-assert-lower      150
;  :arith-assert-upper      104
;  :arith-conflicts         8
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         11
;  :arith-pivots            13
;  :binary-propagations     16
;  :conflicts               190
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             867
;  :mk-clause               173
;  :num-allocs              4295029
;  :num-checks              221
;  :propagations            101
;  :quant-instantiations    52
;  :rlimit-count            155240)
(push) ; 7
(assert (not (< $Perm.No $k@27@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      47
;  :arith-assert-lower      150
;  :arith-assert-upper      104
;  :arith-conflicts         8
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         11
;  :arith-pivots            13
;  :binary-propagations     16
;  :conflicts               191
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             867
;  :mk-clause               173
;  :num-allocs              4295029
;  :num-checks              222
;  :propagations            101
;  :quant-instantiations    52
;  :rlimit-count            155288)
(push) ; 7
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      47
;  :arith-assert-lower      150
;  :arith-assert-upper      104
;  :arith-conflicts         8
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         11
;  :arith-pivots            13
;  :binary-propagations     16
;  :conflicts               192
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             867
;  :mk-clause               173
;  :num-allocs              4295029
;  :num-checks              223
;  :propagations            101
;  :quant-instantiations    52
;  :rlimit-count            155336)
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      47
;  :arith-assert-lower      150
;  :arith-assert-upper      104
;  :arith-conflicts         8
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         11
;  :arith-pivots            13
;  :binary-propagations     16
;  :conflicts               193
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             867
;  :mk-clause               173
;  :num-allocs              4295029
;  :num-checks              224
;  :propagations            101
;  :quant-instantiations    52
;  :rlimit-count            155384)
; [eval] diz.Controller_m.Main_robot_controller == diz
(push) ; 7
(assert (not (< $Perm.No $k@25@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      47
;  :arith-assert-lower      150
;  :arith-assert-upper      104
;  :arith-conflicts         8
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         11
;  :arith-pivots            13
;  :binary-propagations     16
;  :conflicts               194
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             867
;  :mk-clause               173
;  :num-allocs              4295029
;  :num-checks              225
;  :propagations            101
;  :quant-instantiations    52
;  :rlimit-count            155432)
(push) ; 7
(assert (not (< $Perm.No $k@29@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               876
;  :arith-add-rows          3
;  :arith-assert-diseq      47
;  :arith-assert-lower      150
;  :arith-assert-upper      104
;  :arith-conflicts         8
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         11
;  :arith-pivots            13
;  :binary-propagations     16
;  :conflicts               195
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   46
;  :datatype-splits         72
;  :decisions               89
;  :del-clause              131
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             867
;  :mk-clause               173
;  :num-allocs              4295029
;  :num-checks              226
;  :propagations            101
;  :quant-instantiations    52
;  :rlimit-count            155480)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 7
(assert ($Perm.isReadVar $k@41@03 $Perm.Write))
(assert ($Perm.isReadVar $k@43@03 $Perm.Write))
(assert ($Perm.isReadVar $k@44@03 $Perm.Write))
(assert ($Perm.isReadVar $k@45@03 $Perm.Write))
(assert ($Perm.isReadVar $k@46@03 $Perm.Write))
(assert (= $t@40@03 ($Snap.combine ($Snap.first $t@40@03) ($Snap.second $t@40@03))))
(assert (<= $Perm.No $k@41@03))
(assert (<= $k@41@03 $Perm.Write))
(assert (implies (< $Perm.No $k@41@03) (not (= diz@2@03 $Ref.null))))
(assert (=
  ($Snap.second $t@40@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@40@03))
    ($Snap.second ($Snap.second $t@40@03)))))
(assert (= ($Snap.first ($Snap.second $t@40@03)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@40@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@40@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@40@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))
  $Snap.unit))
(assert (forall ((i__6@42@03 Int)) (!
  (implies
    (and
      (<
        i__6@42@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
      (<= 0 i__6@42@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
          i__6@42@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i__6@42@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i__6@42@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i__6@42@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))
(assert (<= $Perm.No $k@43@03))
(assert (<= $k@43@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@43@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))
(assert (<= $Perm.No $k@44@03))
(assert (<= $k@44@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@44@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))
(assert (<= $Perm.No $k@45@03))
(assert (<= $k@45@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@45@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))))
(assert (<= $Perm.No $k@46@03))
(assert (<= $k@46@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@46@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))
  diz@2@03))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 10)
(check-sat)
; unknown
; Loop head block: Follow loop-internal edges
; [eval] diz.Controller_m.Main_process_state[1] != -1 || diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_process_state[1] != -1
; [eval] diz.Controller_m.Main_process_state[1]
(push) ; 8
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1293
;  :arith-add-rows          3
;  :arith-assert-diseq      52
;  :arith-assert-lower      164
;  :arith-assert-upper      116
;  :arith-conflicts         8
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         11
;  :arith-pivots            13
;  :binary-propagations     16
;  :conflicts               197
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 168
;  :datatype-occurs-check   68
;  :datatype-splits         128
;  :decisions               157
;  :del-clause              143
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             996
;  :mk-clause               186
;  :num-allocs              4606378
;  :num-checks              229
;  :propagations            111
;  :quant-instantiations    61
;  :rlimit-count            161399)
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1293
;  :arith-add-rows          3
;  :arith-assert-diseq      52
;  :arith-assert-lower      164
;  :arith-assert-upper      116
;  :arith-conflicts         8
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         11
;  :arith-pivots            13
;  :binary-propagations     16
;  :conflicts               197
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 168
;  :datatype-occurs-check   68
;  :datatype-splits         128
;  :decisions               157
;  :del-clause              143
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             996
;  :mk-clause               186
;  :num-allocs              4606378
;  :num-checks              230
;  :propagations            111
;  :quant-instantiations    61
;  :rlimit-count            161414)
; [eval] -1
(push) ; 8
; [then-branch: 23 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1 | live]
; [else-branch: 23 | First:(Second:(Second:(Second:($t@40@03))))[1] == -1 | live]
(push) ; 9
; [then-branch: 23 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
      1)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 23 | First:(Second:(Second:(Second:($t@40@03))))[1] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    1)
  (- 0 1)))
; [eval] diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_event_state[2]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1294
;  :arith-add-rows          3
;  :arith-assert-diseq      52
;  :arith-assert-lower      164
;  :arith-assert-upper      116
;  :arith-conflicts         8
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         11
;  :arith-pivots            13
;  :binary-propagations     16
;  :conflicts               198
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 168
;  :datatype-occurs-check   68
;  :datatype-splits         128
;  :decisions               157
;  :del-clause              143
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             997
;  :mk-clause               186
;  :num-allocs              4606378
;  :num-checks              231
;  :propagations            111
;  :quant-instantiations    61
;  :rlimit-count            161605)
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1294
;  :arith-add-rows          3
;  :arith-assert-diseq      52
;  :arith-assert-lower      164
;  :arith-assert-upper      116
;  :arith-conflicts         8
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         11
;  :arith-pivots            13
;  :binary-propagations     16
;  :conflicts               198
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 168
;  :datatype-occurs-check   68
;  :datatype-splits         128
;  :decisions               157
;  :del-clause              143
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             997
;  :mk-clause               186
;  :num-allocs              4606378
;  :num-checks              232
;  :propagations            111
;  :quant-instantiations    61
;  :rlimit-count            161620)
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
          2)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1428
;  :arith-add-rows          4
;  :arith-assert-diseq      55
;  :arith-assert-lower      175
;  :arith-assert-upper      121
;  :arith-conflicts         8
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               198
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 198
;  :datatype-occurs-check   79
;  :datatype-splits         156
;  :decisions               185
;  :del-clause              161
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1049
;  :mk-clause               204
;  :num-allocs              4606378
;  :num-checks              233
;  :propagations            122
;  :quant-instantiations    65
;  :rlimit-count            163073
;  :time                    0.00)
(push) ; 8
(assert (not (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
        2)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      55
;  :arith-assert-lower      175
;  :arith-assert-upper      121
;  :arith-conflicts         8
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               198
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              161
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1078
;  :mk-clause               204
;  :num-allocs              4606378
;  :num-checks              234
;  :propagations            125
;  :quant-instantiations    65
;  :rlimit-count            164233
;  :time                    0.00)
; [then-branch: 24 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@40@03))))))[2] != -2 | live]
; [else-branch: 24 | !(First:(Second:(Second:(Second:($t@40@03))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@40@03))))))[2] != -2) | live]
(push) ; 8
; [then-branch: 24 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@40@03))))))[2] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
        2)
      (- 0 2)))))
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz.Controller_m, globals), write)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      55
;  :arith-assert-lower      175
;  :arith-assert-upper      121
;  :arith-conflicts         8
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               199
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              161
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1080
;  :mk-clause               205
;  :num-allocs              4606378
;  :num-checks              235
;  :propagations            125
;  :quant-instantiations    65
;  :rlimit-count            164511)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      55
;  :arith-assert-lower      175
;  :arith-assert-upper      121
;  :arith-conflicts         8
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               200
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              161
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1080
;  :mk-clause               205
;  :num-allocs              4606378
;  :num-checks              236
;  :propagations            125
;  :quant-instantiations    65
;  :rlimit-count            164559)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@53@03 Int)
(push) ; 9
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 10
; [then-branch: 25 | 0 <= i@53@03 | live]
; [else-branch: 25 | !(0 <= i@53@03) | live]
(push) ; 11
; [then-branch: 25 | 0 <= i@53@03]
(assert (<= 0 i@53@03))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 25 | !(0 <= i@53@03)]
(assert (not (<= 0 i@53@03)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 26 | i@53@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i@53@03 | live]
; [else-branch: 26 | !(i@53@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i@53@03) | live]
(push) ; 11
; [then-branch: 26 | i@53@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i@53@03]
(assert (and
  (<
    i@53@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
  (<= 0 i@53@03)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i@53@03 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      55
;  :arith-assert-lower      176
;  :arith-assert-upper      122
;  :arith-conflicts         8
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               200
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              161
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1082
;  :mk-clause               205
;  :num-allocs              4606378
;  :num-checks              237
;  :propagations            125
;  :quant-instantiations    65
;  :rlimit-count            164695)
; [eval] -1
(push) ; 12
; [then-branch: 27 | First:(Second:(Second:(Second:($t@40@03))))[i@53@03] == -1 | live]
; [else-branch: 27 | First:(Second:(Second:(Second:($t@40@03))))[i@53@03] != -1 | live]
(push) ; 13
; [then-branch: 27 | First:(Second:(Second:(Second:($t@40@03))))[i@53@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i@53@03)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 27 | First:(Second:(Second:(Second:($t@40@03))))[i@53@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
      i@53@03)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@53@03 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      56
;  :arith-assert-lower      179
;  :arith-assert-upper      123
;  :arith-conflicts         8
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               200
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              161
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1088
;  :mk-clause               209
;  :num-allocs              4606378
;  :num-checks              238
;  :propagations            127
;  :quant-instantiations    66
;  :rlimit-count            164927)
(push) ; 14
; [then-branch: 28 | 0 <= First:(Second:(Second:(Second:($t@40@03))))[i@53@03] | live]
; [else-branch: 28 | !(0 <= First:(Second:(Second:(Second:($t@40@03))))[i@53@03]) | live]
(push) ; 15
; [then-branch: 28 | 0 <= First:(Second:(Second:(Second:($t@40@03))))[i@53@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i@53@03)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 16
(assert (not (>= i@53@03 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      56
;  :arith-assert-lower      179
;  :arith-assert-upper      123
;  :arith-conflicts         8
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               200
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              161
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1088
;  :mk-clause               209
;  :num-allocs              4606378
;  :num-checks              239
;  :propagations            127
;  :quant-instantiations    66
;  :rlimit-count            165041)
; [eval] |diz.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 28 | !(0 <= First:(Second:(Second:(Second:($t@40@03))))[i@53@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
      i@53@03))))
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
; [else-branch: 26 | !(i@53@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i@53@03)]
(assert (not
  (and
    (<
      i@53@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
    (<= 0 i@53@03))))
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
(assert (not (forall ((i@53@03 Int)) (!
  (implies
    (and
      (<
        i@53@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
      (<= 0 i@53@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
          i@53@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i@53@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i@53@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i@53@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      58
;  :arith-assert-lower      180
;  :arith-assert-upper      124
;  :arith-conflicts         8
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               201
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1096
;  :mk-clause               223
;  :num-allocs              4606378
;  :num-checks              240
;  :propagations            129
;  :quant-instantiations    67
;  :rlimit-count            165487)
(assert (forall ((i@53@03 Int)) (!
  (implies
    (and
      (<
        i@53@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
      (<= 0 i@53@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
          i@53@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i@53@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i@53@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i@53@03))
  :qid |prog.l<no position>|)))
(declare-const $k@54@03 $Perm)
(assert ($Perm.isReadVar $k@54@03 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@54@03 $Perm.No) (< $Perm.No $k@54@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      59
;  :arith-assert-lower      182
;  :arith-assert-upper      125
;  :arith-conflicts         8
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               202
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1101
;  :mk-clause               225
;  :num-allocs              4606378
;  :num-checks              241
;  :propagations            130
;  :quant-instantiations    67
;  :rlimit-count            166048)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@43@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      59
;  :arith-assert-lower      182
;  :arith-assert-upper      125
;  :arith-conflicts         8
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               202
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1101
;  :mk-clause               225
;  :num-allocs              4606378
;  :num-checks              242
;  :propagations            130
;  :quant-instantiations    67
;  :rlimit-count            166059)
(assert (< $k@54@03 $k@43@03))
(assert (<= $Perm.No (- $k@43@03 $k@54@03)))
(assert (<= (- $k@43@03 $k@54@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@43@03 $k@54@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
; [eval] diz.Main_robot != null
(push) ; 9
(assert (not (< $Perm.No $k@43@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      59
;  :arith-assert-lower      184
;  :arith-assert-upper      126
;  :arith-conflicts         8
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               203
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1104
;  :mk-clause               225
;  :num-allocs              4606378
;  :num-checks              243
;  :propagations            130
;  :quant-instantiations    67
;  :rlimit-count            166267)
(declare-const $k@55@03 $Perm)
(assert ($Perm.isReadVar $k@55@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@55@03 $Perm.No) (< $Perm.No $k@55@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      60
;  :arith-assert-lower      186
;  :arith-assert-upper      127
;  :arith-conflicts         8
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               204
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1108
;  :mk-clause               227
;  :num-allocs              4606378
;  :num-checks              244
;  :propagations            131
;  :quant-instantiations    67
;  :rlimit-count            166465)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@44@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      60
;  :arith-assert-lower      186
;  :arith-assert-upper      127
;  :arith-conflicts         8
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         13
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               204
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1108
;  :mk-clause               227
;  :num-allocs              4606378
;  :num-checks              245
;  :propagations            131
;  :quant-instantiations    67
;  :rlimit-count            166476)
(assert (< $k@55@03 $k@44@03))
(assert (<= $Perm.No (- $k@44@03 $k@55@03)))
(assert (<= (- $k@44@03 $k@55@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@44@03 $k@55@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
; [eval] diz.Main_robot_sensor != null
(push) ; 9
(assert (not (< $Perm.No $k@44@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      60
;  :arith-assert-lower      188
;  :arith-assert-upper      128
;  :arith-conflicts         8
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               205
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1111
;  :mk-clause               227
;  :num-allocs              4606378
;  :num-checks              246
;  :propagations            131
;  :quant-instantiations    67
;  :rlimit-count            166690)
(push) ; 9
(assert (not (< $Perm.No $k@44@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      60
;  :arith-assert-lower      188
;  :arith-assert-upper      128
;  :arith-conflicts         8
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               206
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1111
;  :mk-clause               227
;  :num-allocs              4606378
;  :num-checks              247
;  :propagations            131
;  :quant-instantiations    67
;  :rlimit-count            166738)
(declare-const $k@56@03 $Perm)
(assert ($Perm.isReadVar $k@56@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@56@03 $Perm.No) (< $Perm.No $k@56@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      61
;  :arith-assert-lower      190
;  :arith-assert-upper      129
;  :arith-conflicts         8
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1115
;  :mk-clause               229
;  :num-allocs              4606378
;  :num-checks              248
;  :propagations            132
;  :quant-instantiations    67
;  :rlimit-count            166936)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@45@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      61
;  :arith-assert-lower      190
;  :arith-assert-upper      129
;  :arith-conflicts         8
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1115
;  :mk-clause               229
;  :num-allocs              4606378
;  :num-checks              249
;  :propagations            132
;  :quant-instantiations    67
;  :rlimit-count            166947)
(assert (< $k@56@03 $k@45@03))
(assert (<= $Perm.No (- $k@45@03 $k@56@03)))
(assert (<= (- $k@45@03 $k@56@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@45@03 $k@56@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
; [eval] diz.Main_robot_controller != null
(push) ; 9
(assert (not (< $Perm.No $k@45@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      61
;  :arith-assert-lower      192
;  :arith-assert-upper      130
;  :arith-conflicts         8
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         13
;  :arith-pivots            20
;  :binary-propagations     16
;  :conflicts               208
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1118
;  :mk-clause               229
;  :num-allocs              4606378
;  :num-checks              250
;  :propagations            132
;  :quant-instantiations    67
;  :rlimit-count            167167)
(push) ; 9
(assert (not (< $Perm.No $k@45@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      61
;  :arith-assert-lower      192
;  :arith-assert-upper      130
;  :arith-conflicts         8
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         13
;  :arith-pivots            20
;  :binary-propagations     16
;  :conflicts               209
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1118
;  :mk-clause               229
;  :num-allocs              4606378
;  :num-checks              251
;  :propagations            132
;  :quant-instantiations    67
;  :rlimit-count            167215)
(declare-const $k@57@03 $Perm)
(assert ($Perm.isReadVar $k@57@03 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No $k@43@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      62
;  :arith-assert-lower      194
;  :arith-assert-upper      131
;  :arith-conflicts         8
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         13
;  :arith-pivots            20
;  :binary-propagations     16
;  :conflicts               210
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1122
;  :mk-clause               231
;  :num-allocs              4606378
;  :num-checks              252
;  :propagations            133
;  :quant-instantiations    67
;  :rlimit-count            167411)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@57@03 $Perm.No) (< $Perm.No $k@57@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      62
;  :arith-assert-lower      194
;  :arith-assert-upper      131
;  :arith-conflicts         8
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         13
;  :arith-pivots            20
;  :binary-propagations     16
;  :conflicts               211
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1122
;  :mk-clause               231
;  :num-allocs              4606378
;  :num-checks              253
;  :propagations            133
;  :quant-instantiations    67
;  :rlimit-count            167461)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@46@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      62
;  :arith-assert-lower      194
;  :arith-assert-upper      131
;  :arith-conflicts         8
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         13
;  :arith-pivots            20
;  :binary-propagations     16
;  :conflicts               211
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1122
;  :mk-clause               231
;  :num-allocs              4606378
;  :num-checks              254
;  :propagations            133
;  :quant-instantiations    67
;  :rlimit-count            167472)
(assert (< $k@57@03 $k@46@03))
(assert (<= $Perm.No (- $k@46@03 $k@57@03)))
(assert (<= (- $k@46@03 $k@57@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@46@03 $k@57@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
      $Ref.null))))
; [eval] diz.Main_robot.Robot_m == diz
(push) ; 9
(assert (not (< $Perm.No $k@43@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      62
;  :arith-assert-lower      196
;  :arith-assert-upper      132
;  :arith-conflicts         8
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         13
;  :arith-pivots            22
;  :binary-propagations     16
;  :conflicts               212
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1125
;  :mk-clause               231
;  :num-allocs              4606378
;  :num-checks              255
;  :propagations            133
;  :quant-instantiations    67
;  :rlimit-count            167692)
(push) ; 9
(assert (not (< $Perm.No $k@46@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1556
;  :arith-add-rows          4
;  :arith-assert-diseq      62
;  :arith-assert-lower      196
;  :arith-assert-upper      132
;  :arith-conflicts         8
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         13
;  :arith-pivots            22
;  :binary-propagations     16
;  :conflicts               213
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1125
;  :mk-clause               231
;  :num-allocs              4606378
;  :num-checks              256
;  :propagations            133
;  :quant-instantiations    67
;  :rlimit-count            167740)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))
                      ($Snap.combine
                        $Snap.unit
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))
                                ($Snap.combine
                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))
                                  $Snap.unit))))))))))))))))) ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) globals@3@03))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1590
;  :arith-add-rows          4
;  :arith-assert-diseq      62
;  :arith-assert-lower      196
;  :arith-assert-upper      132
;  :arith-conflicts         8
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         13
;  :arith-pivots            22
;  :binary-propagations     16
;  :conflicts               214
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1126
;  :mk-clause               231
;  :num-allocs              4606378
;  :num-checks              257
;  :propagations            133
;  :quant-instantiations    67
;  :rlimit-count            168433)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1590
;  :arith-add-rows          4
;  :arith-assert-diseq      62
;  :arith-assert-lower      196
;  :arith-assert-upper      132
;  :arith-conflicts         8
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         13
;  :arith-pivots            22
;  :binary-propagations     16
;  :conflicts               215
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   90
;  :datatype-splits         184
;  :decisions               212
;  :del-clause              179
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :mk-bool-var             1126
;  :mk-clause               231
;  :num-allocs              4606378
;  :num-checks              258
;  :propagations            133
;  :quant-instantiations    67
;  :rlimit-count            168481)
(declare-const $t@58@03 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1742
;  :arith-add-rows          4
;  :arith-assert-diseq      65
;  :arith-assert-lower      207
;  :arith-assert-upper      137
;  :arith-conflicts         8
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         15
;  :arith-pivots            26
;  :binary-propagations     16
;  :conflicts               216
;  :datatype-accessor-ax    136
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              204
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1176
;  :mk-clause               248
;  :num-allocs              4771406
;  :num-checks              260
;  :propagations            144
;  :quant-instantiations    72
;  :rlimit-count            169752)
(assert (= $t@58@03 ($Snap.combine ($Snap.first $t@58@03) ($Snap.second $t@58@03))))
(assert (= ($Snap.first $t@58@03) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@58@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@58@03))
    ($Snap.second ($Snap.second $t@58@03)))))
(assert (= ($Snap.first ($Snap.second $t@58@03)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@58@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@58@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@58@03))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@58@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@59@03 Int)
(push) ; 9
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 10
; [then-branch: 29 | 0 <= i@59@03 | live]
; [else-branch: 29 | !(0 <= i@59@03) | live]
(push) ; 11
; [then-branch: 29 | 0 <= i@59@03]
(assert (<= 0 i@59@03))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 29 | !(0 <= i@59@03)]
(assert (not (<= 0 i@59@03)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 30 | i@59@03 < |First:(Second:(Second:(Second:($t@58@03))))| && 0 <= i@59@03 | live]
; [else-branch: 30 | !(i@59@03 < |First:(Second:(Second:(Second:($t@58@03))))| && 0 <= i@59@03) | live]
(push) ; 11
; [then-branch: 30 | i@59@03 < |First:(Second:(Second:(Second:($t@58@03))))| && 0 <= i@59@03]
(assert (and
  (<
    i@59@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))
  (<= 0 i@59@03)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i@59@03 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1792
;  :arith-add-rows          4
;  :arith-assert-diseq      65
;  :arith-assert-lower      212
;  :arith-assert-upper      140
;  :arith-conflicts         8
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         15
;  :arith-pivots            26
;  :binary-propagations     16
;  :conflicts               216
;  :datatype-accessor-ax    144
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              204
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1202
;  :mk-clause               248
;  :num-allocs              4771406
;  :num-checks              261
;  :propagations            144
;  :quant-instantiations    76
;  :rlimit-count            171055)
; [eval] -1
(push) ; 12
; [then-branch: 31 | First:(Second:(Second:(Second:($t@58@03))))[i@59@03] == -1 | live]
; [else-branch: 31 | First:(Second:(Second:(Second:($t@58@03))))[i@59@03] != -1 | live]
(push) ; 13
; [then-branch: 31 | First:(Second:(Second:(Second:($t@58@03))))[i@59@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
    i@59@03)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 31 | First:(Second:(Second:(Second:($t@58@03))))[i@59@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
      i@59@03)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@59@03 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1792
;  :arith-add-rows          4
;  :arith-assert-diseq      65
;  :arith-assert-lower      212
;  :arith-assert-upper      140
;  :arith-conflicts         8
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         15
;  :arith-pivots            26
;  :binary-propagations     16
;  :conflicts               216
;  :datatype-accessor-ax    144
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              204
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1203
;  :mk-clause               248
;  :num-allocs              4771406
;  :num-checks              262
;  :propagations            144
;  :quant-instantiations    76
;  :rlimit-count            171230)
(push) ; 14
; [then-branch: 32 | 0 <= First:(Second:(Second:(Second:($t@58@03))))[i@59@03] | live]
; [else-branch: 32 | !(0 <= First:(Second:(Second:(Second:($t@58@03))))[i@59@03]) | live]
(push) ; 15
; [then-branch: 32 | 0 <= First:(Second:(Second:(Second:($t@58@03))))[i@59@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
    i@59@03)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 16
(assert (not (>= i@59@03 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1792
;  :arith-add-rows          4
;  :arith-assert-diseq      66
;  :arith-assert-lower      215
;  :arith-assert-upper      140
;  :arith-conflicts         8
;  :arith-eq-adapter        91
;  :arith-fixed-eqs         15
;  :arith-pivots            26
;  :binary-propagations     16
;  :conflicts               216
;  :datatype-accessor-ax    144
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              204
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1206
;  :mk-clause               249
;  :num-allocs              4771406
;  :num-checks              263
;  :propagations            144
;  :quant-instantiations    76
;  :rlimit-count            171353)
; [eval] |diz.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 32 | !(0 <= First:(Second:(Second:(Second:($t@58@03))))[i@59@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
      i@59@03))))
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
; [else-branch: 30 | !(i@59@03 < |First:(Second:(Second:(Second:($t@58@03))))| && 0 <= i@59@03)]
(assert (not
  (and
    (<
      i@59@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))
    (<= 0 i@59@03))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@59@03 Int)) (!
  (implies
    (and
      (<
        i@59@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))
      (<= 0 i@59@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
          i@59@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
            i@59@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
            i@59@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
    i@59@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))
(declare-const $k@60@03 $Perm)
(assert ($Perm.isReadVar $k@60@03 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@60@03 $Perm.No) (< $Perm.No $k@60@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1797
;  :arith-add-rows          4
;  :arith-assert-diseq      67
;  :arith-assert-lower      217
;  :arith-assert-upper      141
;  :arith-conflicts         8
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         15
;  :arith-pivots            26
;  :binary-propagations     16
;  :conflicts               217
;  :datatype-accessor-ax    145
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1212
;  :mk-clause               251
;  :num-allocs              4771406
;  :num-checks              264
;  :propagations            145
;  :quant-instantiations    76
;  :rlimit-count            172122)
(declare-const $t@61@03 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@43@03 $k@54@03))
    (=
      $t@61@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))
  (implies
    (< $Perm.No $k@60@03)
    (=
      $t@61@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))))
(assert (<= $Perm.No (+ (- $k@43@03 $k@54@03) $k@60@03)))
(assert (<= (+ (- $k@43@03 $k@54@03) $k@60@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@43@03 $k@54@03) $k@60@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))
  $Snap.unit))
; [eval] diz.Main_robot != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@43@03 $k@54@03) $k@60@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1807
;  :arith-add-rows          5
;  :arith-assert-diseq      67
;  :arith-assert-lower      218
;  :arith-assert-upper      143
;  :arith-conflicts         9
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         16
;  :arith-pivots            28
;  :binary-propagations     16
;  :conflicts               218
;  :datatype-accessor-ax    146
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1220
;  :mk-clause               251
;  :num-allocs              4771406
;  :num-checks              265
;  :propagations            145
;  :quant-instantiations    77
;  :rlimit-count            172830)
(assert (not (= $t@61@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))))
(declare-const $k@62@03 $Perm)
(assert ($Perm.isReadVar $k@62@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@62@03 $Perm.No) (< $Perm.No $k@62@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1813
;  :arith-add-rows          5
;  :arith-assert-diseq      68
;  :arith-assert-lower      220
;  :arith-assert-upper      144
;  :arith-conflicts         9
;  :arith-eq-adapter        93
;  :arith-fixed-eqs         16
;  :arith-pivots            28
;  :binary-propagations     16
;  :conflicts               219
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1226
;  :mk-clause               253
;  :num-allocs              4771406
;  :num-checks              266
;  :propagations            146
;  :quant-instantiations    77
;  :rlimit-count            173265)
(declare-const $t@63@03 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@44@03 $k@55@03))
    (=
      $t@63@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))
  (implies
    (< $Perm.No $k@62@03)
    (=
      $t@63@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))))))
(assert (<= $Perm.No (+ (- $k@44@03 $k@55@03) $k@62@03)))
(assert (<= (+ (- $k@44@03 $k@55@03) $k@62@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@44@03 $k@55@03) $k@62@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot_sensor != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@44@03 $k@55@03) $k@62@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1823
;  :arith-add-rows          6
;  :arith-assert-diseq      68
;  :arith-assert-lower      221
;  :arith-assert-upper      146
;  :arith-conflicts         10
;  :arith-eq-adapter        93
;  :arith-fixed-eqs         17
;  :arith-pivots            29
;  :binary-propagations     16
;  :conflicts               220
;  :datatype-accessor-ax    148
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1234
;  :mk-clause               253
;  :num-allocs              4771406
;  :num-checks              267
;  :propagations            146
;  :quant-instantiations    78
;  :rlimit-count            173989)
(assert (not (= $t@63@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@44@03 $k@55@03) $k@62@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1829
;  :arith-add-rows          6
;  :arith-assert-diseq      68
;  :arith-assert-lower      221
;  :arith-assert-upper      147
;  :arith-conflicts         11
;  :arith-eq-adapter        93
;  :arith-fixed-eqs         18
;  :arith-pivots            29
;  :binary-propagations     16
;  :conflicts               221
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1237
;  :mk-clause               253
;  :num-allocs              4771406
;  :num-checks              268
;  :propagations            146
;  :quant-instantiations    78
;  :rlimit-count            174333)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))))))
(declare-const $k@64@03 $Perm)
(assert ($Perm.isReadVar $k@64@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@64@03 $Perm.No) (< $Perm.No $k@64@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1834
;  :arith-add-rows          6
;  :arith-assert-diseq      69
;  :arith-assert-lower      223
;  :arith-assert-upper      148
;  :arith-conflicts         11
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         18
;  :arith-pivots            29
;  :binary-propagations     16
;  :conflicts               222
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1242
;  :mk-clause               255
;  :num-allocs              4771406
;  :num-checks              269
;  :propagations            147
;  :quant-instantiations    78
;  :rlimit-count            174753)
(declare-const $t@65@03 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@45@03 $k@56@03))
    (=
      $t@65@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))))))))
  (implies
    (< $Perm.No $k@64@03)
    (=
      $t@65@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@45@03 $k@56@03) $k@64@03)))
(assert (<= (+ (- $k@45@03 $k@56@03) $k@64@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@45@03 $k@56@03) $k@64@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot_controller != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@45@03 $k@56@03) $k@64@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1844
;  :arith-add-rows          7
;  :arith-assert-diseq      69
;  :arith-assert-lower      224
;  :arith-assert-upper      150
;  :arith-conflicts         12
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         19
;  :arith-pivots            30
;  :binary-propagations     16
;  :conflicts               223
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1250
;  :mk-clause               255
;  :num-allocs              4771406
;  :num-checks              270
;  :propagations            147
;  :quant-instantiations    79
;  :rlimit-count            175395)
(assert (not (= $t@65@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@45@03 $k@56@03) $k@64@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1849
;  :arith-add-rows          7
;  :arith-assert-diseq      69
;  :arith-assert-lower      224
;  :arith-assert-upper      151
;  :arith-conflicts         13
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         20
;  :arith-pivots            30
;  :binary-propagations     16
;  :conflicts               224
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1252
;  :mk-clause               255
;  :num-allocs              4771406
;  :num-checks              271
;  :propagations            147
;  :quant-instantiations    79
;  :rlimit-count            175742)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@43@03 $k@54@03) $k@60@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1854
;  :arith-add-rows          7
;  :arith-assert-diseq      69
;  :arith-assert-lower      224
;  :arith-assert-upper      152
;  :arith-conflicts         14
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         21
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               225
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1254
;  :mk-clause               255
;  :num-allocs              4771406
;  :num-checks              272
;  :propagations            147
;  :quant-instantiations    79
;  :rlimit-count            176089)
(declare-const $k@66@03 $Perm)
(assert ($Perm.isReadVar $k@66@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@66@03 $Perm.No) (< $Perm.No $k@66@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1854
;  :arith-add-rows          7
;  :arith-assert-diseq      70
;  :arith-assert-lower      226
;  :arith-assert-upper      153
;  :arith-conflicts         14
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         21
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               226
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1258
;  :mk-clause               257
;  :num-allocs              4771406
;  :num-checks              273
;  :propagations            148
;  :quant-instantiations    79
;  :rlimit-count            176288)
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
  $t@61@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1854
;  :arith-add-rows          7
;  :arith-assert-diseq      70
;  :arith-assert-lower      226
;  :arith-assert-upper      153
;  :arith-conflicts         14
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         21
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               226
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1258
;  :mk-clause               257
;  :num-allocs              4771406
;  :num-checks              274
;  :propagations            148
;  :quant-instantiations    79
;  :rlimit-count            176299)
(declare-const $t@67@03 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@46@03 $k@57@03))
    (=
      $t@67@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))))
  (implies
    (< $Perm.No $k@66@03)
    (=
      $t@67@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03))))))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@46@03 $k@57@03) $k@66@03)))
(assert (<= (+ (- $k@46@03 $k@57@03) $k@66@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@46@03 $k@57@03) $k@66@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_robot.Robot_m == diz
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@43@03 $k@54@03) $k@60@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1860
;  :arith-add-rows          8
;  :arith-assert-diseq      70
;  :arith-assert-lower      227
;  :arith-assert-upper      155
;  :arith-conflicts         15
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         22
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               227
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1265
;  :mk-clause               257
;  :num-allocs              4771406
;  :num-checks              275
;  :propagations            148
;  :quant-instantiations    80
;  :rlimit-count            176884)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
  $t@61@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1860
;  :arith-add-rows          8
;  :arith-assert-diseq      70
;  :arith-assert-lower      227
;  :arith-assert-upper      155
;  :arith-conflicts         15
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         22
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               227
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1265
;  :mk-clause               257
;  :num-allocs              4771406
;  :num-checks              276
;  :propagations            148
;  :quant-instantiations    80
;  :rlimit-count            176895)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@46@03 $k@57@03) $k@66@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1860
;  :arith-add-rows          8
;  :arith-assert-diseq      70
;  :arith-assert-lower      227
;  :arith-assert-upper      156
;  :arith-conflicts         16
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         23
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               228
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 258
;  :datatype-occurs-check   124
;  :datatype-splits         212
;  :decisions               240
;  :del-clause              205
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1266
;  :mk-clause               257
;  :num-allocs              4771406
;  :num-checks              277
;  :propagations            148
;  :quant-instantiations    80
;  :rlimit-count            176973)
(assert (= $t@67@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@58@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) globals@3@03))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Controller_m, globals), write)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2158
;  :arith-add-rows          11
;  :arith-assert-diseq      77
;  :arith-assert-lower      254
;  :arith-assert-upper      169
;  :arith-conflicts         16
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         29
;  :arith-pivots            42
;  :binary-propagations     16
;  :conflicts               230
;  :datatype-accessor-ax    157
;  :datatype-constructor-ax 314
;  :datatype-occurs-check   159
;  :datatype-splits         246
;  :decisions               293
;  :del-clause              255
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1361
;  :mk-clause               300
;  :num-allocs              4941961
;  :num-checks              279
;  :propagations            171
;  :quant-instantiations    90
;  :rlimit-count            179002)
(declare-const $t@68@03 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; Loop head block: Re-establish invariant
(declare-const $k@69@03 $Perm)
(assert ($Perm.isReadVar $k@69@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@69@03 $Perm.No) (< $Perm.No $k@69@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      82
;  :arith-assert-lower      271
;  :arith-assert-upper      177
;  :arith-conflicts         16
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               231
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1430
;  :mk-clause               325
;  :num-allocs              4941961
;  :num-checks              281
;  :propagations            187
;  :quant-instantiations    96
;  :rlimit-count            180697)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@41@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      82
;  :arith-assert-lower      271
;  :arith-assert-upper      177
;  :arith-conflicts         16
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               231
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1430
;  :mk-clause               325
;  :num-allocs              4941961
;  :num-checks              282
;  :propagations            187
;  :quant-instantiations    96
;  :rlimit-count            180708)
(assert (< $k@69@03 $k@41@03))
(assert (<= $Perm.No (- $k@41@03 $k@69@03)))
(assert (<= (- $k@41@03 $k@69@03) $Perm.Write))
(assert (implies (< $Perm.No (- $k@41@03 $k@69@03)) (not (= diz@2@03 $Ref.null))))
; [eval] diz.Controller_m != null
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      82
;  :arith-assert-lower      273
;  :arith-assert-upper      178
;  :arith-conflicts         16
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               232
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1433
;  :mk-clause               325
;  :num-allocs              4941961
;  :num-checks              283
;  :propagations            187
;  :quant-instantiations    96
;  :rlimit-count            180922)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      82
;  :arith-assert-lower      273
;  :arith-assert-upper      178
;  :arith-conflicts         16
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               233
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1433
;  :mk-clause               325
;  :num-allocs              4941961
;  :num-checks              284
;  :propagations            187
;  :quant-instantiations    96
;  :rlimit-count            180970)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      82
;  :arith-assert-lower      273
;  :arith-assert-upper      178
;  :arith-conflicts         16
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               234
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1433
;  :mk-clause               325
;  :num-allocs              4941961
;  :num-checks              285
;  :propagations            187
;  :quant-instantiations    96
;  :rlimit-count            181018)
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      82
;  :arith-assert-lower      273
;  :arith-assert-upper      178
;  :arith-conflicts         16
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               235
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1433
;  :mk-clause               325
;  :num-allocs              4941961
;  :num-checks              286
;  :propagations            187
;  :quant-instantiations    96
;  :rlimit-count            181066)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      82
;  :arith-assert-lower      273
;  :arith-assert-upper      178
;  :arith-conflicts         16
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               236
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1433
;  :mk-clause               325
;  :num-allocs              4941961
;  :num-checks              287
;  :propagations            187
;  :quant-instantiations    96
;  :rlimit-count            181114)
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      82
;  :arith-assert-lower      273
;  :arith-assert-upper      178
;  :arith-conflicts         16
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               237
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1433
;  :mk-clause               325
;  :num-allocs              4941961
;  :num-checks              288
;  :propagations            187
;  :quant-instantiations    96
;  :rlimit-count            181162)
; [eval] (forall i__6: Int :: { diz.Controller_m.Main_process_state[i__6] } 0 <= i__6 && i__6 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__6] == -1 || 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|)
(declare-const i__6@70@03 Int)
(push) ; 9
; [eval] 0 <= i__6 && i__6 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__6] == -1 || 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__6 && i__6 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__6
(push) ; 10
; [then-branch: 33 | 0 <= i__6@70@03 | live]
; [else-branch: 33 | !(0 <= i__6@70@03) | live]
(push) ; 11
; [then-branch: 33 | 0 <= i__6@70@03]
(assert (<= 0 i__6@70@03))
; [eval] i__6 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 12
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      82
;  :arith-assert-lower      274
;  :arith-assert-upper      178
;  :arith-conflicts         16
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               238
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1434
;  :mk-clause               325
;  :num-allocs              4941961
;  :num-checks              289
;  :propagations            187
;  :quant-instantiations    96
;  :rlimit-count            181262)
(pop) ; 11
(push) ; 11
; [else-branch: 33 | !(0 <= i__6@70@03)]
(assert (not (<= 0 i__6@70@03)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 34 | i__6@70@03 < |First:(Second:(Second:(Second:($t@58@03))))| && 0 <= i__6@70@03 | live]
; [else-branch: 34 | !(i__6@70@03 < |First:(Second:(Second:(Second:($t@58@03))))| && 0 <= i__6@70@03) | live]
(push) ; 11
; [then-branch: 34 | i__6@70@03 < |First:(Second:(Second:(Second:($t@58@03))))| && 0 <= i__6@70@03]
(assert (and
  (<
    i__6@70@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))
  (<= 0 i__6@70@03)))
; [eval] diz.Controller_m.Main_process_state[i__6] == -1 || 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__6] == -1
; [eval] diz.Controller_m.Main_process_state[i__6]
(push) ; 12
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      82
;  :arith-assert-lower      275
;  :arith-assert-upper      179
;  :arith-conflicts         16
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               239
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1436
;  :mk-clause               325
;  :num-allocs              4941961
;  :num-checks              290
;  :propagations            187
;  :quant-instantiations    96
;  :rlimit-count            181419)
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i__6@70@03 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      82
;  :arith-assert-lower      275
;  :arith-assert-upper      179
;  :arith-conflicts         16
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               239
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1436
;  :mk-clause               325
;  :num-allocs              4941961
;  :num-checks              291
;  :propagations            187
;  :quant-instantiations    96
;  :rlimit-count            181428)
; [eval] -1
(push) ; 12
; [then-branch: 35 | First:(Second:(Second:(Second:($t@58@03))))[i__6@70@03] == -1 | live]
; [else-branch: 35 | First:(Second:(Second:(Second:($t@58@03))))[i__6@70@03] != -1 | live]
(push) ; 13
; [then-branch: 35 | First:(Second:(Second:(Second:($t@58@03))))[i__6@70@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
    i__6@70@03)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 35 | First:(Second:(Second:(Second:($t@58@03))))[i__6@70@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
      i__6@70@03)
    (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__6] && diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__6]
; [eval] diz.Controller_m.Main_process_state[i__6]
(set-option :timeout 10)
(push) ; 14
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 14
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      83
;  :arith-assert-lower      278
;  :arith-assert-upper      180
;  :arith-conflicts         16
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               240
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1442
;  :mk-clause               329
;  :num-allocs              4941961
;  :num-checks              292
;  :propagations            189
;  :quant-instantiations    97
;  :rlimit-count            181699)
(set-option :timeout 0)
(push) ; 14
(assert (not (>= i__6@70@03 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      83
;  :arith-assert-lower      278
;  :arith-assert-upper      180
;  :arith-conflicts         16
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               240
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1442
;  :mk-clause               329
;  :num-allocs              4941961
;  :num-checks              293
;  :propagations            189
;  :quant-instantiations    97
;  :rlimit-count            181708)
(push) ; 14
; [then-branch: 36 | 0 <= First:(Second:(Second:(Second:($t@58@03))))[i__6@70@03] | live]
; [else-branch: 36 | !(0 <= First:(Second:(Second:(Second:($t@58@03))))[i__6@70@03]) | live]
(push) ; 15
; [then-branch: 36 | 0 <= First:(Second:(Second:(Second:($t@58@03))))[i__6@70@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
    i__6@70@03)))
; [eval] diz.Controller_m.Main_process_state[i__6] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__6]
(set-option :timeout 10)
(push) ; 16
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      83
;  :arith-assert-lower      278
;  :arith-assert-upper      180
;  :arith-conflicts         16
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               241
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1442
;  :mk-clause               329
;  :num-allocs              4941961
;  :num-checks              294
;  :propagations            189
;  :quant-instantiations    97
;  :rlimit-count            181861)
(set-option :timeout 0)
(push) ; 16
(assert (not (>= i__6@70@03 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      83
;  :arith-assert-lower      278
;  :arith-assert-upper      180
;  :arith-conflicts         16
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               241
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1442
;  :mk-clause               329
;  :num-allocs              4941961
;  :num-checks              295
;  :propagations            189
;  :quant-instantiations    97
;  :rlimit-count            181870)
; [eval] |diz.Controller_m.Main_event_state|
(set-option :timeout 10)
(push) ; 16
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      83
;  :arith-assert-lower      278
;  :arith-assert-upper      180
;  :arith-conflicts         16
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               242
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              278
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1442
;  :mk-clause               329
;  :num-allocs              4941961
;  :num-checks              296
;  :propagations            189
;  :quant-instantiations    97
;  :rlimit-count            181918)
(pop) ; 15
(push) ; 15
; [else-branch: 36 | !(0 <= First:(Second:(Second:(Second:($t@58@03))))[i__6@70@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
      i__6@70@03))))
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
; [else-branch: 34 | !(i__6@70@03 < |First:(Second:(Second:(Second:($t@58@03))))| && 0 <= i__6@70@03)]
(assert (not
  (and
    (<
      i__6@70@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))
    (<= 0 i__6@70@03))))
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
(assert (not (forall ((i__6@70@03 Int)) (!
  (implies
    (and
      (<
        i__6@70@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))
      (<= 0 i__6@70@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
          i__6@70@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
            i__6@70@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
            i__6@70@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
    i__6@70@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      85
;  :arith-assert-lower      279
;  :arith-assert-upper      181
;  :arith-conflicts         16
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               243
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              296
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1450
;  :mk-clause               343
;  :num-allocs              4941961
;  :num-checks              297
;  :propagations            191
;  :quant-instantiations    98
;  :rlimit-count            182364)
(assert (forall ((i__6@70@03 Int)) (!
  (implies
    (and
      (<
        i__6@70@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))
      (<= 0 i__6@70@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
          i__6@70@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
            i__6@70@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
            i__6@70@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@03)))))
    i__6@70@03))
  :qid |prog.l<no position>|)))
(declare-const $k@71@03 $Perm)
(assert ($Perm.isReadVar $k@71@03 $Perm.Write))
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      86
;  :arith-assert-lower      281
;  :arith-assert-upper      182
;  :arith-conflicts         16
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               244
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              296
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1455
;  :mk-clause               345
;  :num-allocs              4941961
;  :num-checks              298
;  :propagations            192
;  :quant-instantiations    98
;  :rlimit-count            182923)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@71@03 $Perm.No) (< $Perm.No $k@71@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2349
;  :arith-add-rows          15
;  :arith-assert-diseq      86
;  :arith-assert-lower      281
;  :arith-assert-upper      182
;  :arith-conflicts         16
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         32
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               245
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              296
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1455
;  :mk-clause               345
;  :num-allocs              4941961
;  :num-checks              299
;  :propagations            192
;  :quant-instantiations    98
;  :rlimit-count            182973)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@43@03 $k@54@03) $k@60@03) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2350
;  :arith-add-rows          15
;  :arith-assert-diseq      86
;  :arith-assert-lower      281
;  :arith-assert-upper      183
;  :arith-conflicts         17
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         32
;  :arith-pivots            50
;  :binary-propagations     16
;  :conflicts               246
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              298
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1457
;  :mk-clause               347
;  :num-allocs              4941961
;  :num-checks              300
;  :propagations            193
;  :quant-instantiations    98
;  :rlimit-count            183061)
(assert (< $k@71@03 (+ (- $k@43@03 $k@54@03) $k@60@03)))
(assert (<= $Perm.No (- (+ (- $k@43@03 $k@54@03) $k@60@03) $k@71@03)))
(assert (<= (- (+ (- $k@43@03 $k@54@03) $k@60@03) $k@71@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@43@03 $k@54@03) $k@60@03) $k@71@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
; [eval] diz.Controller_m.Main_robot != null
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2350
;  :arith-add-rows          16
;  :arith-assert-diseq      86
;  :arith-assert-lower      283
;  :arith-assert-upper      184
;  :arith-conflicts         17
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         32
;  :arith-pivots            50
;  :binary-propagations     16
;  :conflicts               247
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              298
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1460
;  :mk-clause               347
;  :num-allocs              4941961
;  :num-checks              301
;  :propagations            193
;  :quant-instantiations    98
;  :rlimit-count            183296)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@43@03 $k@54@03) $k@60@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2350
;  :arith-add-rows          16
;  :arith-assert-diseq      86
;  :arith-assert-lower      283
;  :arith-assert-upper      185
;  :arith-conflicts         18
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         33
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               248
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              298
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1461
;  :mk-clause               347
;  :num-allocs              4941961
;  :num-checks              302
;  :propagations            193
;  :quant-instantiations    98
;  :rlimit-count            183385)
(declare-const $k@72@03 $Perm)
(assert ($Perm.isReadVar $k@72@03 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2350
;  :arith-add-rows          16
;  :arith-assert-diseq      87
;  :arith-assert-lower      285
;  :arith-assert-upper      186
;  :arith-conflicts         18
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         33
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               249
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              298
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1465
;  :mk-clause               349
;  :num-allocs              4941961
;  :num-checks              303
;  :propagations            194
;  :quant-instantiations    98
;  :rlimit-count            183581)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@72@03 $Perm.No) (< $Perm.No $k@72@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2350
;  :arith-add-rows          16
;  :arith-assert-diseq      87
;  :arith-assert-lower      285
;  :arith-assert-upper      186
;  :arith-conflicts         18
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         33
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               250
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              298
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1465
;  :mk-clause               349
;  :num-allocs              4941961
;  :num-checks              304
;  :propagations            194
;  :quant-instantiations    98
;  :rlimit-count            183631)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@44@03 $k@55@03) $k@62@03) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2351
;  :arith-add-rows          16
;  :arith-assert-diseq      87
;  :arith-assert-lower      285
;  :arith-assert-upper      187
;  :arith-conflicts         19
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         33
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               251
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              300
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1467
;  :mk-clause               351
;  :num-allocs              4941961
;  :num-checks              305
;  :propagations            195
;  :quant-instantiations    98
;  :rlimit-count            183711)
(assert (< $k@72@03 (+ (- $k@44@03 $k@55@03) $k@62@03)))
(assert (<= $Perm.No (- (+ (- $k@44@03 $k@55@03) $k@62@03) $k@72@03)))
(assert (<= (- (+ (- $k@44@03 $k@55@03) $k@62@03) $k@72@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@44@03 $k@55@03) $k@62@03) $k@72@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
; [eval] diz.Controller_m.Main_robot_sensor != null
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2351
;  :arith-add-rows          18
;  :arith-assert-diseq      87
;  :arith-assert-lower      287
;  :arith-assert-upper      188
;  :arith-conflicts         19
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         33
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               252
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              300
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1470
;  :mk-clause               351
;  :num-allocs              4941961
;  :num-checks              306
;  :propagations            195
;  :quant-instantiations    98
;  :rlimit-count            183947)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@44@03 $k@55@03) $k@62@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2351
;  :arith-add-rows          18
;  :arith-assert-diseq      87
;  :arith-assert-lower      287
;  :arith-assert-upper      189
;  :arith-conflicts         20
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         34
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               253
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              300
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1471
;  :mk-clause               351
;  :num-allocs              4941961
;  :num-checks              307
;  :propagations            195
;  :quant-instantiations    98
;  :rlimit-count            184028)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2351
;  :arith-add-rows          18
;  :arith-assert-diseq      87
;  :arith-assert-lower      287
;  :arith-assert-upper      189
;  :arith-conflicts         20
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         34
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               254
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              300
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1471
;  :mk-clause               351
;  :num-allocs              4941961
;  :num-checks              308
;  :propagations            195
;  :quant-instantiations    98
;  :rlimit-count            184076)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@44@03 $k@55@03) $k@62@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2351
;  :arith-add-rows          18
;  :arith-assert-diseq      87
;  :arith-assert-lower      287
;  :arith-assert-upper      190
;  :arith-conflicts         21
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         35
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               255
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              300
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1472
;  :mk-clause               351
;  :num-allocs              4941961
;  :num-checks              309
;  :propagations            195
;  :quant-instantiations    98
;  :rlimit-count            184157)
(declare-const $k@73@03 $Perm)
(assert ($Perm.isReadVar $k@73@03 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2351
;  :arith-add-rows          18
;  :arith-assert-diseq      88
;  :arith-assert-lower      289
;  :arith-assert-upper      191
;  :arith-conflicts         21
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         35
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               256
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              300
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1476
;  :mk-clause               353
;  :num-allocs              4941961
;  :num-checks              310
;  :propagations            196
;  :quant-instantiations    98
;  :rlimit-count            184354)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@73@03 $Perm.No) (< $Perm.No $k@73@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2351
;  :arith-add-rows          18
;  :arith-assert-diseq      88
;  :arith-assert-lower      289
;  :arith-assert-upper      191
;  :arith-conflicts         21
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         35
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               257
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              300
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1476
;  :mk-clause               353
;  :num-allocs              4941961
;  :num-checks              311
;  :propagations            196
;  :quant-instantiations    98
;  :rlimit-count            184404)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@45@03 $k@56@03) $k@64@03) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2352
;  :arith-add-rows          18
;  :arith-assert-diseq      88
;  :arith-assert-lower      289
;  :arith-assert-upper      192
;  :arith-conflicts         22
;  :arith-eq-adapter        124
;  :arith-fixed-eqs         35
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               258
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              302
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1478
;  :mk-clause               355
;  :num-allocs              4941961
;  :num-checks              312
;  :propagations            197
;  :quant-instantiations    98
;  :rlimit-count            184484)
(assert (< $k@73@03 (+ (- $k@45@03 $k@56@03) $k@64@03)))
(assert (<= $Perm.No (- (+ (- $k@45@03 $k@56@03) $k@64@03) $k@73@03)))
(assert (<= (- (+ (- $k@45@03 $k@56@03) $k@64@03) $k@73@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@45@03 $k@56@03) $k@64@03) $k@73@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
; [eval] diz.Controller_m.Main_robot_controller != null
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2352
;  :arith-add-rows          20
;  :arith-assert-diseq      88
;  :arith-assert-lower      291
;  :arith-assert-upper      193
;  :arith-conflicts         22
;  :arith-eq-adapter        124
;  :arith-fixed-eqs         35
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               259
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              302
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1481
;  :mk-clause               355
;  :num-allocs              4941961
;  :num-checks              313
;  :propagations            197
;  :quant-instantiations    98
;  :rlimit-count            184720)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@45@03 $k@56@03) $k@64@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2352
;  :arith-add-rows          20
;  :arith-assert-diseq      88
;  :arith-assert-lower      291
;  :arith-assert-upper      194
;  :arith-conflicts         23
;  :arith-eq-adapter        124
;  :arith-fixed-eqs         36
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               260
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              302
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1482
;  :mk-clause               355
;  :num-allocs              4941961
;  :num-checks              314
;  :propagations            197
;  :quant-instantiations    98
;  :rlimit-count            184801)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2352
;  :arith-add-rows          20
;  :arith-assert-diseq      88
;  :arith-assert-lower      291
;  :arith-assert-upper      194
;  :arith-conflicts         23
;  :arith-eq-adapter        124
;  :arith-fixed-eqs         36
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               261
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              302
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1482
;  :mk-clause               355
;  :num-allocs              4941961
;  :num-checks              315
;  :propagations            197
;  :quant-instantiations    98
;  :rlimit-count            184849)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@45@03 $k@56@03) $k@64@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2352
;  :arith-add-rows          20
;  :arith-assert-diseq      88
;  :arith-assert-lower      291
;  :arith-assert-upper      195
;  :arith-conflicts         24
;  :arith-eq-adapter        124
;  :arith-fixed-eqs         37
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               262
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              302
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1483
;  :mk-clause               355
;  :num-allocs              4941961
;  :num-checks              316
;  :propagations            197
;  :quant-instantiations    98
;  :rlimit-count            184930)
(declare-const $k@74@03 $Perm)
(assert ($Perm.isReadVar $k@74@03 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2352
;  :arith-add-rows          20
;  :arith-assert-diseq      89
;  :arith-assert-lower      293
;  :arith-assert-upper      196
;  :arith-conflicts         24
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         37
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               263
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              302
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1487
;  :mk-clause               357
;  :num-allocs              4941961
;  :num-checks              317
;  :propagations            198
;  :quant-instantiations    98
;  :rlimit-count            185127)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@43@03 $k@54@03) $k@60@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2352
;  :arith-add-rows          20
;  :arith-assert-diseq      89
;  :arith-assert-lower      293
;  :arith-assert-upper      197
;  :arith-conflicts         25
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         38
;  :arith-pivots            52
;  :binary-propagations     16
;  :conflicts               264
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              302
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1488
;  :mk-clause               357
;  :num-allocs              4941961
;  :num-checks              318
;  :propagations            198
;  :quant-instantiations    98
;  :rlimit-count            185216)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@74@03 $Perm.No) (< $Perm.No $k@74@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2352
;  :arith-add-rows          20
;  :arith-assert-diseq      89
;  :arith-assert-lower      293
;  :arith-assert-upper      197
;  :arith-conflicts         25
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         38
;  :arith-pivots            52
;  :binary-propagations     16
;  :conflicts               265
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              302
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1488
;  :mk-clause               357
;  :num-allocs              4941961
;  :num-checks              319
;  :propagations            198
;  :quant-instantiations    98
;  :rlimit-count            185266)
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
  $t@61@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2352
;  :arith-add-rows          20
;  :arith-assert-diseq      89
;  :arith-assert-lower      293
;  :arith-assert-upper      197
;  :arith-conflicts         25
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         38
;  :arith-pivots            52
;  :binary-propagations     16
;  :conflicts               265
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              302
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1488
;  :mk-clause               357
;  :num-allocs              4941961
;  :num-checks              320
;  :propagations            198
;  :quant-instantiations    98
;  :rlimit-count            185277)
(push) ; 9
(assert (not (not (= (+ (- $k@46@03 $k@57@03) $k@66@03) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2353
;  :arith-add-rows          20
;  :arith-assert-diseq      89
;  :arith-assert-lower      293
;  :arith-assert-upper      198
;  :arith-conflicts         26
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         38
;  :arith-pivots            52
;  :binary-propagations     16
;  :conflicts               266
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              304
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1490
;  :mk-clause               359
;  :num-allocs              4941961
;  :num-checks              321
;  :propagations            199
;  :quant-instantiations    98
;  :rlimit-count            185355)
(assert (< $k@74@03 (+ (- $k@46@03 $k@57@03) $k@66@03)))
(assert (<= $Perm.No (- (+ (- $k@46@03 $k@57@03) $k@66@03) $k@74@03)))
(assert (<= (- (+ (- $k@46@03 $k@57@03) $k@66@03) $k@74@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@46@03 $k@57@03) $k@66@03) $k@74@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
      $Ref.null))))
; [eval] diz.Controller_m.Main_robot.Robot_m == diz.Controller_m
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2353
;  :arith-add-rows          21
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      199
;  :arith-conflicts         26
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         38
;  :arith-pivots            52
;  :binary-propagations     16
;  :conflicts               267
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              304
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1493
;  :mk-clause               359
;  :num-allocs              4941961
;  :num-checks              322
;  :propagations            199
;  :quant-instantiations    98
;  :rlimit-count            185590)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@43@03 $k@54@03) $k@60@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2353
;  :arith-add-rows          21
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      200
;  :arith-conflicts         27
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         39
;  :arith-pivots            53
;  :binary-propagations     16
;  :conflicts               268
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              304
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1494
;  :mk-clause               359
;  :num-allocs              4941961
;  :num-checks              323
;  :propagations            199
;  :quant-instantiations    98
;  :rlimit-count            185679)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
  $t@61@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2353
;  :arith-add-rows          21
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      200
;  :arith-conflicts         27
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         39
;  :arith-pivots            53
;  :binary-propagations     16
;  :conflicts               268
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              304
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1494
;  :mk-clause               359
;  :num-allocs              4941961
;  :num-checks              324
;  :propagations            199
;  :quant-instantiations    98
;  :rlimit-count            185690)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@46@03 $k@57@03) $k@66@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2353
;  :arith-add-rows          21
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      201
;  :arith-conflicts         28
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         40
;  :arith-pivots            53
;  :binary-propagations     16
;  :conflicts               269
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              304
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1495
;  :mk-clause               359
;  :num-allocs              4941961
;  :num-checks              325
;  :propagations            199
;  :quant-instantiations    98
;  :rlimit-count            185768)
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2353
;  :arith-add-rows          21
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      201
;  :arith-conflicts         28
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         40
;  :arith-pivots            53
;  :binary-propagations     16
;  :conflicts               270
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              304
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1495
;  :mk-clause               359
;  :num-allocs              4941961
;  :num-checks              326
;  :propagations            199
;  :quant-instantiations    98
;  :rlimit-count            185816)
; [eval] diz.Controller_m.Main_robot_controller == diz
(push) ; 9
(assert (not (< $Perm.No $k@41@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2353
;  :arith-add-rows          21
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      201
;  :arith-conflicts         28
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         40
;  :arith-pivots            53
;  :binary-propagations     16
;  :conflicts               271
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              304
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1495
;  :mk-clause               359
;  :num-allocs              4941961
;  :num-checks              327
;  :propagations            199
;  :quant-instantiations    98
;  :rlimit-count            185864)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@45@03 $k@56@03) $k@64@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2353
;  :arith-add-rows          21
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      202
;  :arith-conflicts         29
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         41
;  :arith-pivots            53
;  :binary-propagations     16
;  :conflicts               272
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              304
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1496
;  :mk-clause               359
;  :num-allocs              4941961
;  :num-checks              328
;  :propagations            199
;  :quant-instantiations    98
;  :rlimit-count            185945)
(set-option :timeout 0)
(push) ; 9
(assert (not (= $t@65@03 diz@2@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2353
;  :arith-add-rows          21
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      202
;  :arith-conflicts         29
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         41
;  :arith-pivots            53
;  :binary-propagations     16
;  :conflicts               272
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 350
;  :datatype-occurs-check   194
;  :datatype-splits         280
;  :decisions               326
;  :del-clause              304
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1496
;  :mk-clause               359
;  :num-allocs              4941961
;  :num-checks              329
;  :propagations            199
;  :quant-instantiations    98
;  :rlimit-count            185956)
(assert (= $t@65@03 diz@2@03))
(pop) ; 8
(push) ; 8
; [else-branch: 24 | !(First:(Second:(Second:(Second:($t@40@03))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@40@03))))))[2] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
          2)
        (- 0 2))))))
(pop) ; 8
(set-option :timeout 10)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2506
;  :arith-add-rows          22
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      202
;  :arith-conflicts         29
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         41
;  :arith-pivots            60
;  :binary-propagations     16
;  :conflicts               273
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 389
;  :datatype-occurs-check   206
;  :datatype-splits         310
;  :decisions               361
;  :del-clause              317
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1529
;  :mk-clause               360
;  :num-allocs              4941961
;  :num-checks              330
;  :propagations            202
;  :quant-instantiations    98
;  :rlimit-count            187369
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2641
;  :arith-add-rows          22
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      202
;  :arith-conflicts         29
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         41
;  :arith-pivots            60
;  :binary-propagations     16
;  :conflicts               274
;  :datatype-accessor-ax    169
;  :datatype-constructor-ax 428
;  :datatype-occurs-check   218
;  :datatype-splits         340
;  :decisions               396
;  :del-clause              318
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1562
;  :mk-clause               361
;  :num-allocs              4941961
;  :num-checks              331
;  :propagations            205
;  :quant-instantiations    98
;  :rlimit-count            188493
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2776
;  :arith-add-rows          22
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      202
;  :arith-conflicts         29
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         41
;  :arith-pivots            60
;  :binary-propagations     16
;  :conflicts               275
;  :datatype-accessor-ax    173
;  :datatype-constructor-ax 467
;  :datatype-occurs-check   230
;  :datatype-splits         370
;  :decisions               431
;  :del-clause              319
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1595
;  :mk-clause               362
;  :num-allocs              4941961
;  :num-checks              332
;  :propagations            208
;  :quant-instantiations    98
;  :rlimit-count            189617
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2911
;  :arith-add-rows          22
;  :arith-assert-diseq      89
;  :arith-assert-lower      295
;  :arith-assert-upper      202
;  :arith-conflicts         29
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         41
;  :arith-pivots            60
;  :binary-propagations     16
;  :conflicts               276
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 506
;  :datatype-occurs-check   242
;  :datatype-splits         400
;  :decisions               466
;  :del-clause              320
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1628
;  :mk-clause               363
;  :num-allocs              4941961
;  :num-checks              333
;  :propagations            211
;  :quant-instantiations    98
;  :rlimit-count            190741
;  :time                    0.00)
(declare-const $t@75@03 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@41@03)
    (= $t@75@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03))))
  (implies
    (< $Perm.No (- $k@25@03 $k@47@03))
    (= $t@75@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03))))))
(assert (<= $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03))))
(assert (<= (+ $k@41@03 (- $k@25@03 $k@47@03)) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))
  (not (= diz@2@03 $Ref.null))))
; [eval] !(diz.Controller_m.Main_process_state[1] != -1 || diz.Controller_m.Main_event_state[2] != -2)
; [eval] diz.Controller_m.Main_process_state[1] != -1 || diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_process_state[1] != -1
; [eval] diz.Controller_m.Main_process_state[1]
(push) ; 8
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2916
;  :arith-add-rows          23
;  :arith-assert-diseq      89
;  :arith-assert-lower      296
;  :arith-assert-upper      204
;  :arith-conflicts         30
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         42
;  :arith-pivots            61
;  :binary-propagations     16
;  :conflicts               277
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 506
;  :datatype-occurs-check   242
;  :datatype-splits         400
;  :decisions               466
;  :del-clause              320
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1633
;  :mk-clause               363
;  :num-allocs              4941961
;  :num-checks              334
;  :propagations            211
;  :quant-instantiations    98
;  :rlimit-count            191082)
(push) ; 8
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2916
;  :arith-add-rows          23
;  :arith-assert-diseq      89
;  :arith-assert-lower      296
;  :arith-assert-upper      204
;  :arith-conflicts         30
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         42
;  :arith-pivots            61
;  :binary-propagations     16
;  :conflicts               278
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 506
;  :datatype-occurs-check   242
;  :datatype-splits         400
;  :decisions               466
;  :del-clause              320
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1634
;  :mk-clause               363
;  :num-allocs              4941961
;  :num-checks              335
;  :propagations            211
;  :quant-instantiations    98
;  :rlimit-count            191162)
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2916
;  :arith-add-rows          23
;  :arith-assert-diseq      89
;  :arith-assert-lower      296
;  :arith-assert-upper      204
;  :arith-conflicts         30
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         42
;  :arith-pivots            61
;  :binary-propagations     16
;  :conflicts               278
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 506
;  :datatype-occurs-check   242
;  :datatype-splits         400
;  :decisions               466
;  :del-clause              320
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1634
;  :mk-clause               363
;  :num-allocs              4941961
;  :num-checks              336
;  :propagations            211
;  :quant-instantiations    98
;  :rlimit-count            191177)
; [eval] -1
(push) ; 8
; [then-branch: 37 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1 | live]
; [else-branch: 37 | First:(Second:(Second:(Second:($t@40@03))))[1] == -1 | live]
(push) ; 9
; [then-branch: 37 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
      1)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 37 | First:(Second:(Second:(Second:($t@40@03))))[1] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    1)
  (- 0 1)))
; [eval] diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_event_state[2]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2917
;  :arith-add-rows          23
;  :arith-assert-diseq      89
;  :arith-assert-lower      296
;  :arith-assert-upper      205
;  :arith-conflicts         31
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         43
;  :arith-pivots            61
;  :binary-propagations     16
;  :conflicts               279
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 506
;  :datatype-occurs-check   242
;  :datatype-splits         400
;  :decisions               466
;  :del-clause              320
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1636
;  :mk-clause               363
;  :num-allocs              4941961
;  :num-checks              337
;  :propagations            211
;  :quant-instantiations    98
;  :rlimit-count            191400)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2917
;  :arith-add-rows          23
;  :arith-assert-diseq      89
;  :arith-assert-lower      296
;  :arith-assert-upper      205
;  :arith-conflicts         31
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         43
;  :arith-pivots            61
;  :binary-propagations     16
;  :conflicts               280
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 506
;  :datatype-occurs-check   242
;  :datatype-splits         400
;  :decisions               466
;  :del-clause              320
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1637
;  :mk-clause               363
;  :num-allocs              4941961
;  :num-checks              338
;  :propagations            211
;  :quant-instantiations    98
;  :rlimit-count            191480)
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2917
;  :arith-add-rows          23
;  :arith-assert-diseq      89
;  :arith-assert-lower      296
;  :arith-assert-upper      205
;  :arith-conflicts         31
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         43
;  :arith-pivots            61
;  :binary-propagations     16
;  :conflicts               280
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 506
;  :datatype-occurs-check   242
;  :datatype-splits         400
;  :decisions               466
;  :del-clause              320
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1637
;  :mk-clause               363
;  :num-allocs              4941961
;  :num-checks              339
;  :propagations            211
;  :quant-instantiations    98
;  :rlimit-count            191495)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
        2)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3040
;  :arith-add-rows          23
;  :arith-assert-diseq      89
;  :arith-assert-lower      296
;  :arith-assert-upper      205
;  :arith-conflicts         31
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         43
;  :arith-pivots            61
;  :binary-propagations     16
;  :conflicts               280
;  :datatype-accessor-ax    180
;  :datatype-constructor-ax 535
;  :datatype-occurs-check   253
;  :datatype-splits         427
;  :decisions               492
;  :del-clause              320
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1665
;  :mk-clause               363
;  :num-allocs              4941961
;  :num-checks              340
;  :propagations            214
;  :quant-instantiations    98
;  :rlimit-count            192644
;  :time                    0.00)
(push) ; 8
(assert (not (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
          2)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3169
;  :arith-add-rows          24
;  :arith-assert-diseq      92
;  :arith-assert-lower      307
;  :arith-assert-upper      210
;  :arith-conflicts         31
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         45
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               280
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              338
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1716
;  :mk-clause               381
;  :num-allocs              4941961
;  :num-checks              341
;  :propagations            225
;  :quant-instantiations    102
;  :rlimit-count            194030
;  :time                    0.00)
; [then-branch: 38 | !(First:(Second:(Second:(Second:($t@40@03))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@40@03))))))[2] != -2) | live]
; [else-branch: 38 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@40@03))))))[2] != -2 | live]
(push) ; 8
; [then-branch: 38 | !(First:(Second:(Second:(Second:($t@40@03))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@40@03))))))[2] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
          2)
        (- 0 2))))))
; [exec]
; diz.Controller_alarm_flag := true
; Loop head block: Re-establish invariant
(declare-const $k@76@03 $Perm)
(assert ($Perm.isReadVar $k@76@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@76@03 $Perm.No) (< $Perm.No $k@76@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3171
;  :arith-add-rows          24
;  :arith-assert-diseq      93
;  :arith-assert-lower      309
;  :arith-assert-upper      211
;  :arith-conflicts         31
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         45
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               281
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              338
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1722
;  :mk-clause               383
;  :num-allocs              4941961
;  :num-checks              342
;  :propagations            226
;  :quant-instantiations    102
;  :rlimit-count            194426)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ $k@41@03 (- $k@25@03 $k@47@03)) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          24
;  :arith-assert-diseq      93
;  :arith-assert-lower      309
;  :arith-assert-upper      212
;  :arith-conflicts         32
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         45
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               282
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1724
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              343
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            194506)
(assert (< $k@76@03 (+ $k@41@03 (- $k@25@03 $k@47@03))))
(assert (<= $Perm.No (- (+ $k@41@03 (- $k@25@03 $k@47@03)) $k@76@03)))
(assert (<= (- (+ $k@41@03 (- $k@25@03 $k@47@03)) $k@76@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@41@03 (- $k@25@03 $k@47@03)) $k@76@03))
  (not (= diz@2@03 $Ref.null))))
; [eval] diz.Controller_m != null
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      214
;  :arith-conflicts         33
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         46
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               283
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1728
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              344
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            194775)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= $t@75@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      214
;  :arith-conflicts         33
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         46
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               283
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1728
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              345
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            194793)
(assert (not (= $t@75@03 $Ref.null)))
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      215
;  :arith-conflicts         34
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         47
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               284
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1729
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              346
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            194894)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      215
;  :arith-conflicts         34
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         47
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               285
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1730
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              347
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            194974)
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      216
;  :arith-conflicts         35
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               286
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1731
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              348
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            195055)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      216
;  :arith-conflicts         35
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               287
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1732
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              349
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            195135)
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      217
;  :arith-conflicts         36
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         49
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               288
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1733
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              350
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            195216)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      217
;  :arith-conflicts         36
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         49
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               289
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1734
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              351
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            195296)
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      218
;  :arith-conflicts         37
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         50
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               290
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1735
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              352
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            195377)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      218
;  :arith-conflicts         37
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         50
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               291
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1736
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              353
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            195457)
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      219
;  :arith-conflicts         38
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         51
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               292
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1737
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              354
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            195538)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      311
;  :arith-assert-upper      219
;  :arith-conflicts         38
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         51
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               293
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1738
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              355
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            195618)
; [eval] (forall i__5: Int :: { diz.Controller_m.Main_process_state[i__5] } 0 <= i__5 && i__5 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__5] == -1 || 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|)
(declare-const i__5@77@03 Int)
(push) ; 9
; [eval] 0 <= i__5 && i__5 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__5] == -1 || 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__5 && i__5 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__5
(push) ; 10
; [then-branch: 39 | 0 <= i__5@77@03 | live]
; [else-branch: 39 | !(0 <= i__5@77@03) | live]
(push) ; 11
; [then-branch: 39 | 0 <= i__5@77@03]
(assert (<= 0 i__5@77@03))
; [eval] i__5 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 12
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      312
;  :arith-assert-upper      220
;  :arith-conflicts         39
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         52
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               294
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1740
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              356
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            195751)
(push) ; 12
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      312
;  :arith-assert-upper      220
;  :arith-conflicts         39
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         52
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               295
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1741
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              357
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            195831)
(pop) ; 11
(push) ; 11
; [else-branch: 39 | !(0 <= i__5@77@03)]
(assert (not (<= 0 i__5@77@03)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 40 | i__5@77@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i__5@77@03 | live]
; [else-branch: 40 | !(i__5@77@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i__5@77@03) | live]
(push) ; 11
; [then-branch: 40 | i__5@77@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i__5@77@03]
(assert (and
  (<
    i__5@77@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
  (<= 0 i__5@77@03)))
; [eval] diz.Controller_m.Main_process_state[i__5] == -1 || 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__5] == -1
; [eval] diz.Controller_m.Main_process_state[i__5]
(push) ; 12
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      313
;  :arith-assert-upper      222
;  :arith-conflicts         40
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         53
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               296
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1744
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              358
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            196021)
(push) ; 12
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      313
;  :arith-assert-upper      222
;  :arith-conflicts         40
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         53
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               297
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1745
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              359
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            196101)
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i__5@77@03 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      93
;  :arith-assert-lower      313
;  :arith-assert-upper      222
;  :arith-conflicts         40
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         53
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               297
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1745
;  :mk-clause               385
;  :num-allocs              4941961
;  :num-checks              360
;  :propagations            227
;  :quant-instantiations    102
;  :rlimit-count            196110)
; [eval] -1
(push) ; 12
; [then-branch: 41 | First:(Second:(Second:(Second:($t@40@03))))[i__5@77@03] == -1 | live]
; [else-branch: 41 | First:(Second:(Second:(Second:($t@40@03))))[i__5@77@03] != -1 | live]
(push) ; 13
; [then-branch: 41 | First:(Second:(Second:(Second:($t@40@03))))[i__5@77@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i__5@77@03)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 41 | First:(Second:(Second:(Second:($t@40@03))))[i__5@77@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
      i__5@77@03)
    (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__5] && diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__5]
; [eval] diz.Controller_m.Main_process_state[i__5]
(set-option :timeout 10)
(push) ; 14
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      94
;  :arith-assert-lower      316
;  :arith-assert-upper      224
;  :arith-conflicts         41
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         54
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               298
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1752
;  :mk-clause               389
;  :num-allocs              4941961
;  :num-checks              361
;  :propagations            229
;  :quant-instantiations    103
;  :rlimit-count            196414)
(push) ; 14
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      94
;  :arith-assert-lower      316
;  :arith-assert-upper      224
;  :arith-conflicts         41
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         54
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               299
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1753
;  :mk-clause               389
;  :num-allocs              4941961
;  :num-checks              362
;  :propagations            229
;  :quant-instantiations    103
;  :rlimit-count            196494)
(set-option :timeout 0)
(push) ; 14
(assert (not (>= i__5@77@03 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      94
;  :arith-assert-lower      316
;  :arith-assert-upper      224
;  :arith-conflicts         41
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         54
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               299
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1753
;  :mk-clause               389
;  :num-allocs              4941961
;  :num-checks              363
;  :propagations            229
;  :quant-instantiations    103
;  :rlimit-count            196503)
(push) ; 14
; [then-branch: 42 | 0 <= First:(Second:(Second:(Second:($t@40@03))))[i__5@77@03] | live]
; [else-branch: 42 | !(0 <= First:(Second:(Second:(Second:($t@40@03))))[i__5@77@03]) | live]
(push) ; 15
; [then-branch: 42 | 0 <= First:(Second:(Second:(Second:($t@40@03))))[i__5@77@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i__5@77@03)))
; [eval] diz.Controller_m.Main_process_state[i__5] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__5]
(set-option :timeout 10)
(push) ; 16
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      94
;  :arith-assert-lower      316
;  :arith-assert-upper      225
;  :arith-conflicts         42
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         55
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               300
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1754
;  :mk-clause               389
;  :num-allocs              4941961
;  :num-checks              364
;  :propagations            229
;  :quant-instantiations    103
;  :rlimit-count            196689)
(push) ; 16
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      94
;  :arith-assert-lower      316
;  :arith-assert-upper      225
;  :arith-conflicts         42
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         55
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               301
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1755
;  :mk-clause               389
;  :num-allocs              4941961
;  :num-checks              365
;  :propagations            229
;  :quant-instantiations    103
;  :rlimit-count            196769)
(set-option :timeout 0)
(push) ; 16
(assert (not (>= i__5@77@03 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      94
;  :arith-assert-lower      316
;  :arith-assert-upper      225
;  :arith-conflicts         42
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         55
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               301
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1755
;  :mk-clause               389
;  :num-allocs              4941961
;  :num-checks              366
;  :propagations            229
;  :quant-instantiations    103
;  :rlimit-count            196778)
; [eval] |diz.Controller_m.Main_event_state|
(set-option :timeout 10)
(push) ; 16
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      94
;  :arith-assert-lower      316
;  :arith-assert-upper      226
;  :arith-conflicts         43
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         56
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               302
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1756
;  :mk-clause               389
;  :num-allocs              4941961
;  :num-checks              367
;  :propagations            229
;  :quant-instantiations    103
;  :rlimit-count            196859)
(push) ; 16
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      94
;  :arith-assert-lower      316
;  :arith-assert-upper      226
;  :arith-conflicts         43
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         56
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               303
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              340
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1757
;  :mk-clause               389
;  :num-allocs              4941961
;  :num-checks              368
;  :propagations            229
;  :quant-instantiations    103
;  :rlimit-count            196939)
(pop) ; 15
(push) ; 15
; [else-branch: 42 | !(0 <= First:(Second:(Second:(Second:($t@40@03))))[i__5@77@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
      i__5@77@03))))
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
; [else-branch: 40 | !(i__5@77@03 < |First:(Second:(Second:(Second:($t@40@03))))| && 0 <= i__5@77@03)]
(assert (not
  (and
    (<
      i__5@77@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
    (<= 0 i__5@77@03))))
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
(assert (not (forall ((i__5@77@03 Int)) (!
  (implies
    (and
      (<
        i__5@77@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
      (<= 0 i__5@77@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
          i__5@77@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i__5@77@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i__5@77@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i__5@77@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      96
;  :arith-assert-lower      317
;  :arith-assert-upper      227
;  :arith-conflicts         43
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         56
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               304
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1765
;  :mk-clause               403
;  :num-allocs              4941961
;  :num-checks              369
;  :propagations            231
;  :quant-instantiations    104
;  :rlimit-count            197385)
(assert (forall ((i__5@77@03 Int)) (!
  (implies
    (and
      (<
        i__5@77@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
      (<= 0 i__5@77@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
          i__5@77@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i__5@77@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
            i__5@77@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
    i__5@77@03))
  :qid |prog.l<no position>|)))
(declare-const $k@78@03 $Perm)
(assert ($Perm.isReadVar $k@78@03 $Perm.Write))
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      97
;  :arith-assert-lower      319
;  :arith-assert-upper      229
;  :arith-conflicts         44
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         57
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               305
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1771
;  :mk-clause               405
;  :num-allocs              4941961
;  :num-checks              370
;  :propagations            232
;  :quant-instantiations    104
;  :rlimit-count            197977)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@78@03 $Perm.No) (< $Perm.No $k@78@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      97
;  :arith-assert-lower      319
;  :arith-assert-upper      229
;  :arith-conflicts         44
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         57
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               306
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1771
;  :mk-clause               405
;  :num-allocs              4941961
;  :num-checks              371
;  :propagations            232
;  :quant-instantiations    104
;  :rlimit-count            198027)
(set-option :timeout 10)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      97
;  :arith-assert-lower      319
;  :arith-assert-upper      229
;  :arith-conflicts         44
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         57
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               307
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1772
;  :mk-clause               405
;  :num-allocs              4941961
;  :num-checks              372
;  :propagations            232
;  :quant-instantiations    104
;  :rlimit-count            198107)
(push) ; 9
(assert (not (not (= $k@43@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      97
;  :arith-assert-lower      319
;  :arith-assert-upper      229
;  :arith-conflicts         44
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         57
;  :arith-pivots            65
;  :binary-propagations     16
;  :conflicts               307
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1772
;  :mk-clause               405
;  :num-allocs              4941961
;  :num-checks              373
;  :propagations            232
;  :quant-instantiations    104
;  :rlimit-count            198118)
(assert (< $k@78@03 $k@43@03))
(assert (<= $Perm.No (- $k@43@03 $k@78@03)))
(assert (<= (- $k@43@03 $k@78@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@43@03 $k@78@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
; [eval] diz.Controller_m.Main_robot != null
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      97
;  :arith-assert-lower      321
;  :arith-assert-upper      231
;  :arith-conflicts         45
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         58
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               308
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1776
;  :mk-clause               405
;  :num-allocs              4941961
;  :num-checks              374
;  :propagations            232
;  :quant-instantiations    104
;  :rlimit-count            198365)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      97
;  :arith-assert-lower      321
;  :arith-assert-upper      231
;  :arith-conflicts         45
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         58
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               309
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1777
;  :mk-clause               405
;  :num-allocs              4941961
;  :num-checks              375
;  :propagations            232
;  :quant-instantiations    104
;  :rlimit-count            198445)
(push) ; 9
(assert (not (< $Perm.No $k@43@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      97
;  :arith-assert-lower      321
;  :arith-assert-upper      231
;  :arith-conflicts         45
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         58
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               310
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1777
;  :mk-clause               405
;  :num-allocs              4941961
;  :num-checks              376
;  :propagations            232
;  :quant-instantiations    104
;  :rlimit-count            198493)
(declare-const $k@79@03 $Perm)
(assert ($Perm.isReadVar $k@79@03 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      98
;  :arith-assert-lower      323
;  :arith-assert-upper      233
;  :arith-conflicts         46
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         59
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               311
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1782
;  :mk-clause               407
;  :num-allocs              4941961
;  :num-checks              377
;  :propagations            233
;  :quant-instantiations    104
;  :rlimit-count            198722)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@79@03 $Perm.No) (< $Perm.No $k@79@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      98
;  :arith-assert-lower      323
;  :arith-assert-upper      233
;  :arith-conflicts         46
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         59
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               312
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1782
;  :mk-clause               407
;  :num-allocs              4941961
;  :num-checks              378
;  :propagations            233
;  :quant-instantiations    104
;  :rlimit-count            198772)
(set-option :timeout 10)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      98
;  :arith-assert-lower      323
;  :arith-assert-upper      233
;  :arith-conflicts         46
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         59
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               313
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1783
;  :mk-clause               407
;  :num-allocs              4941961
;  :num-checks              379
;  :propagations            233
;  :quant-instantiations    104
;  :rlimit-count            198852)
(push) ; 9
(assert (not (not (= $k@44@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      98
;  :arith-assert-lower      323
;  :arith-assert-upper      233
;  :arith-conflicts         46
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         59
;  :arith-pivots            66
;  :binary-propagations     16
;  :conflicts               313
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1783
;  :mk-clause               407
;  :num-allocs              4941961
;  :num-checks              380
;  :propagations            233
;  :quant-instantiations    104
;  :rlimit-count            198863)
(assert (< $k@79@03 $k@44@03))
(assert (<= $Perm.No (- $k@44@03 $k@79@03)))
(assert (<= (- $k@44@03 $k@79@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@44@03 $k@79@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
; [eval] diz.Controller_m.Main_robot_sensor != null
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      98
;  :arith-assert-lower      325
;  :arith-assert-upper      235
;  :arith-conflicts         47
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         60
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               314
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1787
;  :mk-clause               407
;  :num-allocs              4941961
;  :num-checks              381
;  :propagations            233
;  :quant-instantiations    104
;  :rlimit-count            199110)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      98
;  :arith-assert-lower      325
;  :arith-assert-upper      235
;  :arith-conflicts         47
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         60
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               315
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1788
;  :mk-clause               407
;  :num-allocs              4941961
;  :num-checks              382
;  :propagations            233
;  :quant-instantiations    104
;  :rlimit-count            199190)
(push) ; 9
(assert (not (< $Perm.No $k@44@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      98
;  :arith-assert-lower      325
;  :arith-assert-upper      235
;  :arith-conflicts         47
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         60
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               316
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1788
;  :mk-clause               407
;  :num-allocs              4941961
;  :num-checks              383
;  :propagations            233
;  :quant-instantiations    104
;  :rlimit-count            199238)
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      98
;  :arith-assert-lower      325
;  :arith-assert-upper      236
;  :arith-conflicts         48
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         61
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               317
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1789
;  :mk-clause               407
;  :num-allocs              4941961
;  :num-checks              384
;  :propagations            233
;  :quant-instantiations    104
;  :rlimit-count            199319)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      98
;  :arith-assert-lower      325
;  :arith-assert-upper      236
;  :arith-conflicts         48
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         61
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               318
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1790
;  :mk-clause               407
;  :num-allocs              4941961
;  :num-checks              385
;  :propagations            233
;  :quant-instantiations    104
;  :rlimit-count            199399)
(push) ; 9
(assert (not (< $Perm.No $k@44@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      98
;  :arith-assert-lower      325
;  :arith-assert-upper      236
;  :arith-conflicts         48
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         61
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               319
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1790
;  :mk-clause               407
;  :num-allocs              4941961
;  :num-checks              386
;  :propagations            233
;  :quant-instantiations    104
;  :rlimit-count            199447)
(declare-const $k@80@03 $Perm)
(assert ($Perm.isReadVar $k@80@03 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      99
;  :arith-assert-lower      327
;  :arith-assert-upper      238
;  :arith-conflicts         49
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         62
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               320
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1795
;  :mk-clause               409
;  :num-allocs              4941961
;  :num-checks              387
;  :propagations            234
;  :quant-instantiations    104
;  :rlimit-count            199677)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@80@03 $Perm.No) (< $Perm.No $k@80@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      99
;  :arith-assert-lower      327
;  :arith-assert-upper      238
;  :arith-conflicts         49
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         62
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               321
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1795
;  :mk-clause               409
;  :num-allocs              4941961
;  :num-checks              388
;  :propagations            234
;  :quant-instantiations    104
;  :rlimit-count            199727)
(set-option :timeout 10)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      99
;  :arith-assert-lower      327
;  :arith-assert-upper      238
;  :arith-conflicts         49
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         62
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               322
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1796
;  :mk-clause               409
;  :num-allocs              4941961
;  :num-checks              389
;  :propagations            234
;  :quant-instantiations    104
;  :rlimit-count            199807)
(push) ; 9
(assert (not (not (= $k@45@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      99
;  :arith-assert-lower      327
;  :arith-assert-upper      238
;  :arith-conflicts         49
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         62
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               322
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1796
;  :mk-clause               409
;  :num-allocs              4941961
;  :num-checks              390
;  :propagations            234
;  :quant-instantiations    104
;  :rlimit-count            199818)
(assert (< $k@80@03 $k@45@03))
(assert (<= $Perm.No (- $k@45@03 $k@80@03)))
(assert (<= (- $k@45@03 $k@80@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@45@03 $k@80@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $Ref.null))))
; [eval] diz.Controller_m.Main_robot_controller != null
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      99
;  :arith-assert-lower      329
;  :arith-assert-upper      240
;  :arith-conflicts         50
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         63
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               323
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1800
;  :mk-clause               409
;  :num-allocs              4941961
;  :num-checks              391
;  :propagations            234
;  :quant-instantiations    104
;  :rlimit-count            200059)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      99
;  :arith-assert-lower      329
;  :arith-assert-upper      240
;  :arith-conflicts         50
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         63
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               324
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1801
;  :mk-clause               409
;  :num-allocs              4941961
;  :num-checks              392
;  :propagations            234
;  :quant-instantiations    104
;  :rlimit-count            200139)
(push) ; 9
(assert (not (< $Perm.No $k@45@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      99
;  :arith-assert-lower      329
;  :arith-assert-upper      240
;  :arith-conflicts         50
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         63
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               325
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1801
;  :mk-clause               409
;  :num-allocs              4941961
;  :num-checks              393
;  :propagations            234
;  :quant-instantiations    104
;  :rlimit-count            200187)
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      99
;  :arith-assert-lower      329
;  :arith-assert-upper      241
;  :arith-conflicts         51
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         64
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               326
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1802
;  :mk-clause               409
;  :num-allocs              4941961
;  :num-checks              394
;  :propagations            234
;  :quant-instantiations    104
;  :rlimit-count            200268)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      99
;  :arith-assert-lower      329
;  :arith-assert-upper      241
;  :arith-conflicts         51
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         64
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               327
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1803
;  :mk-clause               409
;  :num-allocs              4941961
;  :num-checks              395
;  :propagations            234
;  :quant-instantiations    104
;  :rlimit-count            200348)
(push) ; 9
(assert (not (< $Perm.No $k@45@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      99
;  :arith-assert-lower      329
;  :arith-assert-upper      241
;  :arith-conflicts         51
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         64
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               328
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1803
;  :mk-clause               409
;  :num-allocs              4941961
;  :num-checks              396
;  :propagations            234
;  :quant-instantiations    104
;  :rlimit-count            200396)
(push) ; 9
(assert (not (=
  diz@2@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      99
;  :arith-assert-lower      329
;  :arith-assert-upper      241
;  :arith-conflicts         51
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         64
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               328
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1803
;  :mk-clause               409
;  :num-allocs              4941961
;  :num-checks              397
;  :propagations            234
;  :quant-instantiations    104
;  :rlimit-count            200407)
(declare-const $k@81@03 $Perm)
(assert ($Perm.isReadVar $k@81@03 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      331
;  :arith-assert-upper      243
;  :arith-conflicts         52
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         65
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               329
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1808
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              398
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            200637)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      331
;  :arith-assert-upper      243
;  :arith-conflicts         52
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         65
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               330
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1809
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              399
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            200717)
(push) ; 9
(assert (not (< $Perm.No $k@43@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      331
;  :arith-assert-upper      243
;  :arith-conflicts         52
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         65
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               331
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1809
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              400
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            200765)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@81@03 $Perm.No) (< $Perm.No $k@81@03))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      331
;  :arith-assert-upper      243
;  :arith-conflicts         52
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         65
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               332
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1809
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              401
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            200815)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@46@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      331
;  :arith-assert-upper      243
;  :arith-conflicts         52
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         65
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               332
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1809
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              402
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            200826)
(assert (< $k@81@03 $k@46@03))
(assert (<= $Perm.No (- $k@46@03 $k@81@03)))
(assert (<= (- $k@46@03 $k@81@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@46@03 $k@81@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))
      $Ref.null))))
; [eval] diz.Controller_m.Main_robot.Robot_m == diz.Controller_m
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      245
;  :arith-conflicts         53
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         66
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               333
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1813
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              403
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            201067)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      245
;  :arith-conflicts         53
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         66
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               334
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1814
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              404
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            201147)
(push) ; 9
(assert (not (< $Perm.No $k@43@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      245
;  :arith-conflicts         53
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         66
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               335
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1814
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              405
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            201195)
(push) ; 9
(assert (not (< $Perm.No $k@46@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      245
;  :arith-conflicts         53
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         66
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               336
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1814
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              406
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            201243)
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      246
;  :arith-conflicts         54
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         67
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               337
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1815
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              407
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            201324)
(set-option :timeout 0)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
  $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3172
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      246
;  :arith-conflicts         54
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         67
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               338
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1816
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              408
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            201400)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03))))))))))))))))))
  $t@75@03))
; [eval] diz.Controller_m.Main_robot_controller == diz
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ $k@41@03 (- $k@25@03 $k@47@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3173
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      247
;  :arith-conflicts         55
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         68
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               339
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1818
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              409
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            201534)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@40@03)) $t@75@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3173
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      247
;  :arith-conflicts         55
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         68
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               339
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1818
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              410
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            201545)
(push) ; 9
(assert (not (< $Perm.No $k@45@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3173
;  :arith-add-rows          26
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      247
;  :arith-conflicts         55
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         68
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               340
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 564
;  :datatype-occurs-check   264
;  :datatype-splits         454
;  :decisions               519
;  :del-clause              358
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1818
;  :mk-clause               411
;  :num-allocs              4941961
;  :num-checks              411
;  :propagations            235
;  :quant-instantiations    104
;  :rlimit-count            201593)
(pop) ; 8
(push) ; 8
; [else-branch: 38 | First:(Second:(Second:(Second:($t@40@03))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@40@03))))))[2] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@40@03)))))))
        2)
      (- 0 2)))))
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@03)))))))))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3273
;  :arith-add-rows          27
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      247
;  :arith-conflicts         55
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         68
;  :arith-pivots            76
;  :binary-propagations     16
;  :conflicts               341
;  :datatype-accessor-ax    186
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   273
;  :datatype-splits         474
;  :decisions               544
;  :del-clause              399
;  :final-checks            60
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1841
;  :mk-clause               412
;  :num-allocs              4941961
;  :num-checks              412
;  :propagations            237
;  :quant-instantiations    104
;  :rlimit-count            202761
;  :time                    0.00)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3398
;  :arith-add-rows          27
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      247
;  :arith-conflicts         55
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         68
;  :arith-pivots            76
;  :binary-propagations     16
;  :conflicts               342
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 629
;  :datatype-occurs-check   285
;  :datatype-splits         507
;  :decisions               576
;  :del-clause              400
;  :final-checks            64
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1876
;  :mk-clause               413
;  :num-allocs              4941961
;  :num-checks              413
;  :propagations            241
;  :quant-instantiations    104
;  :rlimit-count            203799
;  :time                    0.00)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3523
;  :arith-add-rows          27
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      247
;  :arith-conflicts         55
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         68
;  :arith-pivots            76
;  :binary-propagations     16
;  :conflicts               343
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 666
;  :datatype-occurs-check   297
;  :datatype-splits         540
;  :decisions               608
;  :del-clause              401
;  :final-checks            68
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1911
;  :mk-clause               414
;  :num-allocs              4941961
;  :num-checks              414
;  :propagations            245
;  :quant-instantiations    104
;  :rlimit-count            204837
;  :time                    0.00)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3648
;  :arith-add-rows          27
;  :arith-assert-diseq      100
;  :arith-assert-lower      333
;  :arith-assert-upper      247
;  :arith-conflicts         55
;  :arith-eq-adapter        139
;  :arith-fixed-eqs         68
;  :arith-pivots            76
;  :binary-propagations     16
;  :conflicts               344
;  :datatype-accessor-ax    201
;  :datatype-constructor-ax 703
;  :datatype-occurs-check   309
;  :datatype-splits         573
;  :decisions               640
;  :del-clause              402
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.64
;  :memory                  4.64
;  :mk-bool-var             1946
;  :mk-clause               415
;  :num-allocs              4941961
;  :num-checks              415
;  :propagations            249
;  :quant-instantiations    104
;  :rlimit-count            205875
;  :time                    0.00)
(declare-const $t@82@03 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@25@03)
    (= $t@82@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@03))))
  (implies
    (< $Perm.No (- $k@5@03 $k@31@03))
    (= $t@82@03 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))))))
(assert (<= $Perm.No (+ $k@25@03 (- $k@5@03 $k@31@03))))
(assert (<= (+ $k@25@03 (- $k@5@03 $k@31@03)) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@25@03 (- $k@5@03 $k@31@03)))
  (not (= diz@2@03 $Ref.null))))
; [eval] !true
; [then-branch: 43 | False | dead]
; [else-branch: 43 | True | live]
(push) ; 5
; [else-branch: 43 | True]
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
