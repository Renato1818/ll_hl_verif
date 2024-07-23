(get-info :version)
; (:version "4.8.6")
; Started: 2024-07-23 11:39:42
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
(declare-sort Set<Int>)
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
(declare-fun zfrac_val<Perm> (zfrac) $Perm)
(declare-const class_Sensor<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Object<TYPE> TYPE)
(declare-const class_Controller<TYPE> TYPE)
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
; /field_value_functions_declarations.smt2 [Sensor_m: Ref]
(declare-fun $FVF.domain_Sensor_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Sensor_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Sensor_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Sensor_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Sensor_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Sensor_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [Controller_m: Ref]
(declare-fun $FVF.domain_Controller_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Controller_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Controller_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Controller_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Controller_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Controller_m $FVF<$Ref>)
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
(declare-fun new_zfrac ($Snap $Perm) zfrac)
(declare-fun new_zfrac%limited ($Snap $Perm) zfrac)
(declare-fun new_zfrac%stateless ($Perm) Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
(declare-fun Sensor_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Sensor_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Controller_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Controller_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_held_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
; ////////// Uniqueness assumptions from domains
(assert (distinct class_Sensor<TYPE> class_java_DOT_lang_DOT_Object<TYPE> class_Controller<TYPE> class_Main<TYPE> class_EncodedGlobalVariables<TYPE>))
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
(assert (forall ((a zfrac) (b zfrac)) (!
  (= (= (zfrac_val<Perm> a) (zfrac_val<Perm> b)) (= a b))
  :pattern ((zfrac_val<Perm> a) (zfrac_val<Perm> b))
  :qid |prog.zfrac_eq|)))
(assert (forall ((a zfrac)) (!
  (and (<= $Perm.No (zfrac_val<Perm> a)) (<= (zfrac_val<Perm> a) $Perm.Write))
  :pattern ((zfrac_val<Perm> a))
  :qid |prog.zfrac_bound|)))
(assert (=
  (directSuperclass<TYPE> (as class_Sensor<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Controller<TYPE>  TYPE))
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
(assert (forall ((s@$ $Snap) (x@8@00 $Perm)) (!
  (= (new_zfrac%limited s@$ x@8@00) (new_zfrac s@$ x@8@00))
  :pattern ((new_zfrac s@$ x@8@00))
  )))
(assert (forall ((s@$ $Snap) (x@8@00 $Perm)) (!
  (new_zfrac%stateless x@8@00)
  :pattern ((new_zfrac%limited s@$ x@8@00))
  )))
(assert (forall ((s@$ $Snap) (x@8@00 $Perm)) (!
  (let ((result@9@00 (new_zfrac%limited s@$ x@8@00))) (implies
    (and (<= $Perm.No x@8@00) (<= x@8@00 $Perm.Write))
    (= (zfrac_val<Perm> result@9@00) x@8@00)))
  :pattern ((new_zfrac%limited s@$ x@8@00))
  )))
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- Sensor_run_EncodedGlobalVariables ----------
(declare-const diz@0@02 $Ref)
(declare-const globals@1@02 $Ref)
(declare-const diz@2@02 $Ref)
(declare-const globals@3@02 $Ref)
(push) ; 1
(declare-const $t@4@02 $Snap)
(assert (= $t@4@02 ($Snap.combine ($Snap.first $t@4@02) ($Snap.second $t@4@02))))
(assert (= ($Snap.first $t@4@02) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@2@02 $Ref.null)))
(assert (=
  ($Snap.second $t@4@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@4@02))
    ($Snap.second ($Snap.second $t@4@02)))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            16
;  :arith-assert-lower   1
;  :arith-assert-upper   1
;  :arith-eq-adapter     1
;  :binary-propagations  11
;  :datatype-accessor-ax 3
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.71
;  :mk-bool-var          251
;  :mk-clause            1
;  :num-allocs           3289031
;  :num-checks           1
;  :propagations         11
;  :quant-instantiations 1
;  :rlimit-count         110123)
(assert (=
  ($Snap.second ($Snap.second $t@4@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@4@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@4@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@4@02))) $Snap.unit))
; [eval] diz.Sensor_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@02))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@4@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@02)))))))
(declare-const $k@5@02 $Perm)
(assert ($Perm.isReadVar $k@5@02 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@5@02 $Perm.No) (< $Perm.No $k@5@02))))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            28
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   2
;  :arith-eq-adapter     2
;  :binary-propagations  11
;  :conflicts            1
;  :datatype-accessor-ax 5
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.80
;  :mk-bool-var          260
;  :mk-clause            3
;  :num-allocs           3404559
;  :num-checks           2
;  :propagations         12
;  :quant-instantiations 2
;  :rlimit-count         110695)
(assert (<= $Perm.No $k@5@02))
(assert (<= $k@5@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@5@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@02)))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_sensor == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@5@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            34
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  11
;  :conflicts            2
;  :datatype-accessor-ax 6
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.80
;  :mk-bool-var          263
;  :mk-clause            3
;  :num-allocs           3404559
;  :num-checks           3
;  :propagations         12
;  :quant-instantiations 2
;  :rlimit-count         110968)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@02)))))
  diz@2@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@02)))))))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            41
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  11
;  :conflicts            2
;  :datatype-accessor-ax 7
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.80
;  :mk-bool-var          266
;  :mk-clause            3
;  :num-allocs           3404559
;  :num-checks           4
;  :propagations         12
;  :quant-instantiations 3
;  :rlimit-count         111219)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@02))))))
  $Snap.unit))
; [eval] !diz.Sensor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@02)))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@6@02 $Snap)
(assert (= $t@6@02 ($Snap.combine ($Snap.first $t@6@02) ($Snap.second $t@6@02))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               59
;  :arith-assert-diseq      1
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-eq-adapter        2
;  :binary-propagations     11
;  :conflicts               2
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   2
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             274
;  :mk-clause               3
;  :num-allocs              3404559
;  :num-checks              6
;  :propagations            12
;  :quant-instantiations    5
;  :rlimit-count            111868)
(assert (=
  ($Snap.second $t@6@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@6@02))
    ($Snap.second ($Snap.second $t@6@02)))))
(assert (= ($Snap.first ($Snap.second $t@6@02)) $Snap.unit))
; [eval] diz.Sensor_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@6@02)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@6@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@6@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@6@02))))))
(declare-const $k@7@02 $Perm)
(assert ($Perm.isReadVar $k@7@02 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@7@02 $Perm.No) (< $Perm.No $k@7@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               71
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               3
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   2
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             283
;  :mk-clause               5
;  :num-allocs              3404559
;  :num-checks              7
;  :propagations            13
;  :quant-instantiations    6
;  :rlimit-count            112429)
(assert (<= $Perm.No $k@7@02))
(assert (<= $k@7@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@7@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@6@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@6@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@6@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@02)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@6@02)))) $Snap.unit))
; [eval] diz.Sensor_m.Main_sensor == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@7@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               77
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   2
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             286
;  :mk-clause               5
;  :num-allocs              3404559
;  :num-checks              8
;  :propagations            13
;  :quant-instantiations    6
;  :rlimit-count            112692)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@6@02))))
  diz@2@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@02))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               85
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   2
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             289
;  :mk-clause               5
;  :num-allocs              3404559
;  :num-checks              9
;  :propagations            13
;  :quant-instantiations    7
;  :rlimit-count            112932)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@02)))))
  $Snap.unit))
; [eval] !diz.Sensor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@02))))))))
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_1__2: Ref
(declare-const __flatten_1__2@8@02 $Ref)
; [exec]
; var __flatten_2__3: Seq[Int]
(declare-const __flatten_2__3@9@02 Seq<Int>)
; [exec]
; var __flatten_3__4: Ref
(declare-const __flatten_3__4@10@02 $Ref)
; [exec]
; var __flatten_4__5: Ref
(declare-const __flatten_4__5@11@02 $Ref)
; [exec]
; var __flatten_5__6: Seq[Int]
(declare-const __flatten_5__6@12@02 Seq<Int>)
; [exec]
; var __flatten_6__7: Ref
(declare-const __flatten_6__7@13@02 $Ref)
; [exec]
; var __flatten_7__8: Int
(declare-const __flatten_7__8@14@02 Int)
; [exec]
; var __flatten_9__9: Ref
(declare-const __flatten_9__9@15@02 $Ref)
; [exec]
; var __flatten_10__10: Seq[Int]
(declare-const __flatten_10__10@16@02 Seq<Int>)
; [exec]
; var __flatten_11__11: Ref
(declare-const __flatten_11__11@17@02 $Ref)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(declare-const $t@18@02 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(assert (= $t@18@02 ($Snap.combine ($Snap.first $t@18@02) ($Snap.second $t@18@02))))
(assert (= ($Snap.first $t@18@02) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@18@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@18@02))
    ($Snap.second ($Snap.second $t@18@02)))))
(assert (= ($Snap.first ($Snap.second $t@18@02)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@18@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@18@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@18@02))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@18@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@19@02 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@19@02 | live]
; [else-branch: 0 | !(0 <= i@19@02) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@19@02]
(assert (<= 0 i@19@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@19@02)]
(assert (not (<= 0 i@19@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@19@02 < |First:(Second:(Second:(Second:($t@18@02))))| && 0 <= i@19@02 | live]
; [else-branch: 1 | !(i@19@02 < |First:(Second:(Second:(Second:($t@18@02))))| && 0 <= i@19@02) | live]
(push) ; 5
; [then-branch: 1 | i@19@02 < |First:(Second:(Second:(Second:($t@18@02))))| && 0 <= i@19@02]
(assert (and
  (<
    i@19@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
  (<= 0 i@19@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@19@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               143
;  :arith-assert-diseq      4
;  :arith-assert-lower      12
;  :arith-assert-upper      8
;  :arith-eq-adapter        7
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              4
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             321
;  :mk-clause               11
;  :num-allocs              3523113
;  :num-checks              11
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            114611)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:($t@18@02))))[i@19@02] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:($t@18@02))))[i@19@02] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:($t@18@02))))[i@19@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
    i@19@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:($t@18@02))))[i@19@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
      i@19@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@19@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               143
;  :arith-assert-diseq      4
;  :arith-assert-lower      12
;  :arith-assert-upper      8
;  :arith-eq-adapter        7
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              4
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             322
;  :mk-clause               11
;  :num-allocs              3523113
;  :num-checks              12
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            114786)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@18@02))))[i@19@02] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@18@02))))[i@19@02]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@18@02))))[i@19@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
    i@19@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@19@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               143
;  :arith-assert-diseq      5
;  :arith-assert-lower      15
;  :arith-assert-upper      8
;  :arith-eq-adapter        8
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              4
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             325
;  :mk-clause               12
;  :num-allocs              3523113
;  :num-checks              13
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            114910)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@18@02))))[i@19@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
      i@19@02))))
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
; [else-branch: 1 | !(i@19@02 < |First:(Second:(Second:(Second:($t@18@02))))| && 0 <= i@19@02)]
(assert (not
  (and
    (<
      i@19@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
    (<= 0 i@19@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@19@02 Int)) (!
  (implies
    (and
      (<
        i@19@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
      (<= 0 i@19@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
          i@19@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
            i@19@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
            i@19@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
    i@19@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))))
(declare-const $k@20@02 $Perm)
(assert ($Perm.isReadVar $k@20@02 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@20@02 $Perm.No) (< $Perm.No $k@20@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               148
;  :arith-assert-diseq      6
;  :arith-assert-lower      17
;  :arith-assert-upper      9
;  :arith-eq-adapter        9
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             331
;  :mk-clause               14
;  :num-allocs              3523113
;  :num-checks              14
;  :propagations            16
;  :quant-instantiations    13
;  :rlimit-count            115678)
(declare-const $t@21@02 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@5@02)
    (=
      $t@21@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@02)))))))
  (implies
    (< $Perm.No $k@20@02)
    (=
      $t@21@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))))))
(assert (<= $Perm.No (+ $k@5@02 $k@20@02)))
(assert (<= (+ $k@5@02 $k@20@02) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@5@02 $k@20@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))
  $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@5@02 $k@20@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               158
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      11
;  :arith-conflicts         1
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               6
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             339
;  :mk-clause               14
;  :num-allocs              3523113
;  :num-checks              15
;  :propagations            16
;  :quant-instantiations    14
;  :rlimit-count            116263)
(assert (not (= $t@21@02 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@5@02 $k@20@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               164
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      12
;  :arith-conflicts         2
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             342
;  :mk-clause               14
;  :num-allocs              3523113
;  :num-checks              16
;  :propagations            16
;  :quant-instantiations    14
;  :rlimit-count            116569)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@5@02 $k@20@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               169
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      13
;  :arith-conflicts         3
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               8
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             344
;  :mk-clause               14
;  :num-allocs              3523113
;  :num-checks              17
;  :propagations            16
;  :quant-instantiations    14
;  :rlimit-count            116840)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@5@02 $k@20@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               174
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      14
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               9
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             346
;  :mk-clause               14
;  :num-allocs              3523113
;  :num-checks              18
;  :propagations            16
;  :quant-instantiations    14
;  :rlimit-count            117121)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               174
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      14
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               9
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             346
;  :mk-clause               14
;  :num-allocs              3523113
;  :num-checks              19
;  :propagations            16
;  :quant-instantiations    14
;  :rlimit-count            117134)
(set-option :timeout 10)
(push) ; 3
(assert (not (= diz@2@02 $t@21@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               174
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      14
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               10
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             347
;  :mk-clause               14
;  :num-allocs              3523113
;  :num-checks              20
;  :propagations            16
;  :quant-instantiations    14
;  :rlimit-count            117194)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@02)))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))))))))
(declare-const $k@22@02 $Perm)
(assert ($Perm.isReadVar $k@22@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@22@02 $Perm.No) (< $Perm.No $k@22@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               182
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      15
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               11
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             354
;  :mk-clause               16
;  :num-allocs              3523113
;  :num-checks              21
;  :propagations            17
;  :quant-instantiations    15
;  :rlimit-count            117707)
(assert (<= $Perm.No $k@22@02))
(assert (<= $k@22@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@22@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@22@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               188
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      16
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               12
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             357
;  :mk-clause               16
;  :num-allocs              3523113
;  :num-checks              22
;  :propagations            17
;  :quant-instantiations    15
;  :rlimit-count            118080)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@22@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      16
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               13
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             360
;  :mk-clause               16
;  :num-allocs              3523113
;  :num-checks              23
;  :propagations            17
;  :quant-instantiations    16
;  :rlimit-count            118482)
(push) ; 3
(assert (not (< $Perm.No $k@22@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      16
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               14
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             360
;  :mk-clause               16
;  :num-allocs              3523113
;  :num-checks              24
;  :propagations            17
;  :quant-instantiations    16
;  :rlimit-count            118530)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      16
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               14
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             360
;  :mk-clause               16
;  :num-allocs              3523113
;  :num-checks              25
;  :propagations            17
;  :quant-instantiations    16
;  :rlimit-count            118543)
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@18@02 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@02))) globals@3@02))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(declare-const $t@23@02 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz.Sensor_init := true
(declare-const __flatten_1__2@24@02 $Ref)
(declare-const __flatten_3__4@25@02 $Ref)
(declare-const __flatten_2__3@26@02 Seq<Int>)
(declare-const __flatten_4__5@27@02 $Ref)
(declare-const __flatten_6__7@28@02 $Ref)
(declare-const __flatten_5__6@29@02 Seq<Int>)
(declare-const __flatten_7__8@30@02 Int)
(declare-const __flatten_9__9@31@02 $Ref)
(declare-const __flatten_11__11@32@02 $Ref)
(declare-const __flatten_10__10@33@02 Seq<Int>)
(push) ; 3
; Loop head block: Check well-definedness of invariant
(declare-const $t@34@02 $Snap)
(assert (= $t@34@02 ($Snap.combine ($Snap.first $t@34@02) ($Snap.second $t@34@02))))
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               279
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      16
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               15
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              15
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             382
;  :mk-clause               17
;  :num-allocs              3523113
;  :num-checks              28
;  :propagations            18
;  :quant-instantiations    16
;  :rlimit-count            119723)
(assert (=
  ($Snap.second $t@34@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@34@02))
    ($Snap.second ($Snap.second $t@34@02)))))
(assert (= ($Snap.first ($Snap.second $t@34@02)) $Snap.unit))
; [eval] diz.Sensor_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@34@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@34@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@34@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
  $Snap.unit))
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
  $Snap.unit))
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
  $Snap.unit))
; [eval] (forall i__12: Int :: { diz.Sensor_m.Main_process_state[i__12] } 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|)
(declare-const i__12@35@02 Int)
(push) ; 4
; [eval] 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__12
(push) ; 5
; [then-branch: 4 | 0 <= i__12@35@02 | live]
; [else-branch: 4 | !(0 <= i__12@35@02) | live]
(push) ; 6
; [then-branch: 4 | 0 <= i__12@35@02]
(assert (<= 0 i__12@35@02))
; [eval] i__12 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 4 | !(0 <= i__12@35@02)]
(assert (not (<= 0 i__12@35@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 5 | i__12@35@02 < |First:(Second:(Second:(Second:($t@34@02))))| && 0 <= i__12@35@02 | live]
; [else-branch: 5 | !(i__12@35@02 < |First:(Second:(Second:(Second:($t@34@02))))| && 0 <= i__12@35@02) | live]
(push) ; 6
; [then-branch: 5 | i__12@35@02 < |First:(Second:(Second:(Second:($t@34@02))))| && 0 <= i__12@35@02]
(assert (and
  (<
    i__12@35@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
  (<= 0 i__12@35@02)))
; [eval] diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__12] == -1
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 7
(assert (not (>= i__12@35@02 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               323
;  :arith-assert-diseq      7
;  :arith-assert-lower      25
;  :arith-assert-upper      19
;  :arith-conflicts         4
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               15
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              15
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             407
;  :mk-clause               17
;  :num-allocs              3646233
;  :num-checks              29
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            121002)
; [eval] -1
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@34@02))))[i__12@35@02] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@34@02))))[i__12@35@02] != -1 | live]
(push) ; 8
; [then-branch: 6 | First:(Second:(Second:(Second:($t@34@02))))[i__12@35@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    i__12@35@02)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 6 | First:(Second:(Second:(Second:($t@34@02))))[i__12@35@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      i__12@35@02)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__12]
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 9
(assert (not (>= i__12@35@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               323
;  :arith-assert-diseq      7
;  :arith-assert-lower      25
;  :arith-assert-upper      19
;  :arith-conflicts         4
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               15
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              15
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             408
;  :mk-clause               17
;  :num-allocs              3646233
;  :num-checks              30
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            121177)
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@34@02))))[i__12@35@02] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@34@02))))[i__12@35@02]) | live]
(push) ; 10
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@34@02))))[i__12@35@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    i__12@35@02)))
; [eval] diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 11
(assert (not (>= i__12@35@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               323
;  :arith-assert-diseq      8
;  :arith-assert-lower      28
;  :arith-assert-upper      19
;  :arith-conflicts         4
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               15
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              15
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             411
;  :mk-clause               18
;  :num-allocs              3646233
;  :num-checks              31
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            121301)
; [eval] |diz.Sensor_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@34@02))))[i__12@35@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      i__12@35@02))))
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
; [else-branch: 5 | !(i__12@35@02 < |First:(Second:(Second:(Second:($t@34@02))))| && 0 <= i__12@35@02)]
(assert (not
  (and
    (<
      i__12@35@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
    (<= 0 i__12@35@02))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__12@35@02 Int)) (!
  (implies
    (and
      (<
        i__12@35@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
      (<= 0 i__12@35@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
          i__12@35@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
            i__12@35@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
            i__12@35@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    i__12@35@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))
(declare-const $k@36@02 $Perm)
(assert ($Perm.isReadVar $k@36@02 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@36@02 $Perm.No) (< $Perm.No $k@36@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               328
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      20
;  :arith-conflicts         4
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               16
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             417
;  :mk-clause               20
;  :num-allocs              3646233
;  :num-checks              32
;  :propagations            19
;  :quant-instantiations    21
;  :rlimit-count            122069)
(assert (<= $Perm.No $k@36@02))
(assert (<= $k@36@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@36@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_sensor != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@36@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               334
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      21
;  :arith-conflicts         4
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               17
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             420
;  :mk-clause               20
;  :num-allocs              3646233
;  :num-checks              33
;  :propagations            19
;  :quant-instantiations    21
;  :rlimit-count            122392)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@36@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               340
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      21
;  :arith-conflicts         4
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               18
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             423
;  :mk-clause               20
;  :num-allocs              3646233
;  :num-checks              34
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            122748)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@36@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               345
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      21
;  :arith-conflicts         4
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               19
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             424
;  :mk-clause               20
;  :num-allocs              3646233
;  :num-checks              35
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            123005)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@36@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               350
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      21
;  :arith-conflicts         4
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               20
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             425
;  :mk-clause               20
;  :num-allocs              3646233
;  :num-checks              36
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            123272)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               350
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      21
;  :arith-conflicts         4
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               20
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             425
;  :mk-clause               20
;  :num-allocs              3646233
;  :num-checks              37
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            123285)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))
(declare-const $k@37@02 $Perm)
(assert ($Perm.isReadVar $k@37@02 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@37@02 $Perm.No) (< $Perm.No $k@37@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               355
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      22
;  :arith-conflicts         4
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               21
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             430
;  :mk-clause               22
;  :num-allocs              3646233
;  :num-checks              38
;  :propagations            20
;  :quant-instantiations    22
;  :rlimit-count            123705)
(assert (<= $Perm.No $k@37@02))
(assert (<= $k@37@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@37@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_controller != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@37@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               361
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      23
;  :arith-conflicts         4
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               22
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             433
;  :mk-clause               22
;  :num-allocs              3646233
;  :num-checks              39
;  :propagations            20
;  :quant-instantiations    22
;  :rlimit-count            124078)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@37@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               367
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      23
;  :arith-conflicts         4
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               23
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             436
;  :mk-clause               22
;  :num-allocs              3646233
;  :num-checks              40
;  :propagations            20
;  :quant-instantiations    23
;  :rlimit-count            124488)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@37@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               372
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      23
;  :arith-conflicts         4
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               24
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             437
;  :mk-clause               22
;  :num-allocs              3646233
;  :num-checks              41
;  :propagations            20
;  :quant-instantiations    23
;  :rlimit-count            124795)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               372
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      23
;  :arith-conflicts         4
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               24
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             437
;  :mk-clause               22
;  :num-allocs              3646233
;  :num-checks              42
;  :propagations            20
;  :quant-instantiations    23
;  :rlimit-count            124808)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_sensor == diz
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@36@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               378
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      23
;  :arith-conflicts         4
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             439
;  :mk-clause               22
;  :num-allocs              3646233
;  :num-checks              43
;  :propagations            20
;  :quant-instantiations    23
;  :rlimit-count            125157)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
  diz@2@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               386
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      23
;  :arith-conflicts         4
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             441
;  :mk-clause               22
;  :num-allocs              3646233
;  :num-checks              44
;  :propagations            20
;  :quant-instantiations    23
;  :rlimit-count            125501)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
; Loop head block: Check well-definedness of edge conditions
(push) ; 4
(pop) ; 4
(push) ; 4
; [eval] !true
(pop) ; 4
(pop) ; 3
(push) ; 3
; Loop head block: Establish invariant
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               394
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      23
;  :arith-conflicts         4
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              20
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             447
;  :mk-clause               22
;  :num-allocs              3646233
;  :num-checks              45
;  :propagations            20
;  :quant-instantiations    26
;  :rlimit-count            125948)
; [eval] diz.Sensor_m != null
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
; [eval] (forall i__12: Int :: { diz.Sensor_m.Main_process_state[i__12] } 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|)
(declare-const i__12@38@02 Int)
(push) ; 4
; [eval] 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__12
(push) ; 5
; [then-branch: 8 | 0 <= i__12@38@02 | live]
; [else-branch: 8 | !(0 <= i__12@38@02) | live]
(push) ; 6
; [then-branch: 8 | 0 <= i__12@38@02]
(assert (<= 0 i__12@38@02))
; [eval] i__12 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 8 | !(0 <= i__12@38@02)]
(assert (not (<= 0 i__12@38@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 9 | i__12@38@02 < |First:(Second:(Second:(Second:($t@18@02))))| && 0 <= i__12@38@02 | live]
; [else-branch: 9 | !(i__12@38@02 < |First:(Second:(Second:(Second:($t@18@02))))| && 0 <= i__12@38@02) | live]
(push) ; 6
; [then-branch: 9 | i__12@38@02 < |First:(Second:(Second:(Second:($t@18@02))))| && 0 <= i__12@38@02]
(assert (and
  (<
    i__12@38@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
  (<= 0 i__12@38@02)))
; [eval] diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__12] == -1
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 7
(assert (not (>= i__12@38@02 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               394
;  :arith-assert-diseq      10
;  :arith-assert-lower      33
;  :arith-assert-upper      24
;  :arith-conflicts         4
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              20
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             449
;  :mk-clause               22
;  :num-allocs              3646233
;  :num-checks              46
;  :propagations            20
;  :quant-instantiations    26
;  :rlimit-count            126084)
; [eval] -1
(push) ; 7
; [then-branch: 10 | First:(Second:(Second:(Second:($t@18@02))))[i__12@38@02] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:(Second:($t@18@02))))[i__12@38@02] != -1 | live]
(push) ; 8
; [then-branch: 10 | First:(Second:(Second:(Second:($t@18@02))))[i__12@38@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
    i__12@38@02)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 10 | First:(Second:(Second:(Second:($t@18@02))))[i__12@38@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
      i__12@38@02)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__12]
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 9
(assert (not (>= i__12@38@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               394
;  :arith-assert-diseq      11
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         4
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              20
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             455
;  :mk-clause               26
;  :num-allocs              3646233
;  :num-checks              47
;  :propagations            22
;  :quant-instantiations    27
;  :rlimit-count            126316)
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@18@02))))[i__12@38@02] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@18@02))))[i__12@38@02]) | live]
(push) ; 10
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@18@02))))[i__12@38@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
    i__12@38@02)))
; [eval] diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 11
(assert (not (>= i__12@38@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               394
;  :arith-assert-diseq      11
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         4
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              20
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             455
;  :mk-clause               26
;  :num-allocs              3646233
;  :num-checks              48
;  :propagations            22
;  :quant-instantiations    27
;  :rlimit-count            126430)
; [eval] |diz.Sensor_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@18@02))))[i__12@38@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
      i__12@38@02))))
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
; [else-branch: 9 | !(i__12@38@02 < |First:(Second:(Second:(Second:($t@18@02))))| && 0 <= i__12@38@02)]
(assert (not
  (and
    (<
      i__12@38@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
    (<= 0 i__12@38@02))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 4
(assert (not (forall ((i__12@38@02 Int)) (!
  (implies
    (and
      (<
        i__12@38@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
      (<= 0 i__12@38@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
          i__12@38@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
            i__12@38@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
            i__12@38@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
    i__12@38@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               394
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      26
;  :arith-conflicts         4
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               26
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              36
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             463
;  :mk-clause               38
;  :num-allocs              3646233
;  :num-checks              49
;  :propagations            24
;  :quant-instantiations    28
;  :rlimit-count            126876)
(assert (forall ((i__12@38@02 Int)) (!
  (implies
    (and
      (<
        i__12@38@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
      (<= 0 i__12@38@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
          i__12@38@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
            i__12@38@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
            i__12@38@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
    i__12@38@02))
  :qid |prog.l<no position>|)))
(declare-const $k@39@02 $Perm)
(assert ($Perm.isReadVar $k@39@02 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@39@02 $Perm.No) (< $Perm.No $k@39@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               394
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      27
;  :arith-conflicts         4
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               27
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              36
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             468
;  :mk-clause               40
;  :num-allocs              3646233
;  :num-checks              50
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            127437)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= (+ $k@5@02 $k@20@02) $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               395
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      28
;  :arith-conflicts         5
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               28
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             470
;  :mk-clause               42
;  :num-allocs              3646233
;  :num-checks              51
;  :propagations            26
;  :quant-instantiations    28
;  :rlimit-count            127499)
(assert (< $k@39@02 (+ $k@5@02 $k@20@02)))
(assert (<= $Perm.No (- (+ $k@5@02 $k@20@02) $k@39@02)))
(assert (<= (- (+ $k@5@02 $k@20@02) $k@39@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@5@02 $k@20@02) $k@39@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@02)))
      $Ref.null))))
; [eval] diz.Sensor_m.Main_sensor != null
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@02 $k@20@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               395
;  :arith-add-rows          1
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      30
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               29
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             474
;  :mk-clause               42
;  :num-allocs              3646233
;  :num-checks              52
;  :propagations            26
;  :quant-instantiations    28
;  :rlimit-count            127731)
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@02 $k@20@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               395
;  :arith-add-rows          1
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      31
;  :arith-conflicts         7
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               30
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             475
;  :mk-clause               42
;  :num-allocs              3646233
;  :num-checks              53
;  :propagations            26
;  :quant-instantiations    28
;  :rlimit-count            127794)
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@02 $k@20@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               395
;  :arith-add-rows          1
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      32
;  :arith-conflicts         8
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               31
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             476
;  :mk-clause               42
;  :num-allocs              3646233
;  :num-checks              54
;  :propagations            26
;  :quant-instantiations    28
;  :rlimit-count            127857)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               395
;  :arith-add-rows          1
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      32
;  :arith-conflicts         8
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               31
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             476
;  :mk-clause               42
;  :num-allocs              3646233
;  :num-checks              55
;  :propagations            26
;  :quant-instantiations    28
;  :rlimit-count            127870)
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@02 $k@20@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               395
;  :arith-add-rows          1
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      33
;  :arith-conflicts         9
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               32
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             477
;  :mk-clause               42
;  :num-allocs              3646233
;  :num-checks              56
;  :propagations            26
;  :quant-instantiations    28
;  :rlimit-count            127933)
(push) ; 4
(assert (not (= diz@2@02 $t@21@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               395
;  :arith-add-rows          1
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      33
;  :arith-conflicts         9
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               33
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   15
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             478
;  :mk-clause               42
;  :num-allocs              3646233
;  :num-checks              57
;  :propagations            26
;  :quant-instantiations    28
;  :rlimit-count            127993)
(push) ; 4
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          1
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      33
;  :arith-conflicts         9
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               33
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   21
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             486
;  :mk-clause               42
;  :num-allocs              3646233
;  :num-checks              58
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            128505)
(declare-const $k@40@02 $Perm)
(assert ($Perm.isReadVar $k@40@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@40@02 $Perm.No) (< $Perm.No $k@40@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      34
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               34
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   21
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             490
;  :mk-clause               44
;  :num-allocs              3646233
;  :num-checks              59
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            128704)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@22@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      34
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               34
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   21
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             490
;  :mk-clause               44
;  :num-allocs              3646233
;  :num-checks              60
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            128715)
(assert (< $k@40@02 $k@22@02))
(assert (<= $Perm.No (- $k@22@02 $k@40@02)))
(assert (<= (- $k@22@02 $k@40@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@22@02 $k@40@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@02)))
      $Ref.null))))
; [eval] diz.Sensor_m.Main_controller != null
(push) ; 4
(assert (not (< $Perm.No $k@22@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      35
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               35
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   21
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             493
;  :mk-clause               44
;  :num-allocs              3646233
;  :num-checks              61
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            128923)
(push) ; 4
(assert (not (< $Perm.No $k@22@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      35
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               36
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   21
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             493
;  :mk-clause               44
;  :num-allocs              3646233
;  :num-checks              62
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            128971)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      35
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               36
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   21
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             493
;  :mk-clause               44
;  :num-allocs              3646233
;  :num-checks              63
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            128984)
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@22@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      35
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               37
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   21
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             493
;  :mk-clause               44
;  :num-allocs              3646233
;  :num-checks              64
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            129032)
; [eval] diz.Sensor_m.Main_sensor == diz
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@02 $k@20@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      36
;  :arith-conflicts         10
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               38
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   21
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             494
;  :mk-clause               44
;  :num-allocs              3646233
;  :num-checks              65
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            129095)
(set-option :timeout 0)
(push) ; 4
(assert (not (= $t@21@02 diz@2@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      36
;  :arith-conflicts         10
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               39
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   21
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             494
;  :mk-clause               44
;  :num-allocs              3646233
;  :num-checks              66
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            129151)
(assert (= $t@21@02 diz@2@02))
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      36
;  :arith-conflicts         10
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               39
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   21
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             494
;  :mk-clause               44
;  :num-allocs              3646233
;  :num-checks              67
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            129199)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
(assert ($Perm.isReadVar $k@36@02 $Perm.Write))
(assert ($Perm.isReadVar $k@37@02 $Perm.Write))
(assert (= $t@34@02 ($Snap.combine ($Snap.first $t@34@02) ($Snap.second $t@34@02))))
(assert (=
  ($Snap.second $t@34@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@34@02))
    ($Snap.second ($Snap.second $t@34@02)))))
(assert (= ($Snap.first ($Snap.second $t@34@02)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@34@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@34@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@34@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
  $Snap.unit))
(assert (forall ((i__12@35@02 Int)) (!
  (implies
    (and
      (<
        i__12@35@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
      (<= 0 i__12@35@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
          i__12@35@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
            i__12@35@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
            i__12@35@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    i__12@35@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))
(assert (<= $Perm.No $k@36@02))
(assert (<= $k@36@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@36@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))
(assert (<= $Perm.No $k@37@02))
(assert (<= $k@37@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@37@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
  diz@2@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))))))
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))))))
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
; (:added-eqs               870
;  :arith-add-rows          1
;  :arith-assert-diseq      16
;  :arith-assert-lower      53
;  :arith-assert-upper      42
;  :arith-conflicts         10
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              44
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             625
;  :mk-clause               52
;  :num-allocs              3776743
;  :num-checks              70
;  :propagations            39
;  :quant-instantiations    38
;  :rlimit-count            134860
;  :time                    0.00)
; [then-branch: 12 | True | live]
; [else-branch: 12 | False | dead]
(push) ; 5
; [then-branch: 12 | True]
; [exec]
; __flatten_1__2 := diz.Sensor_m
(declare-const __flatten_1__2@41@02 $Ref)
(assert (= __flatten_1__2@41@02 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02))))
; [exec]
; __flatten_3__4 := diz.Sensor_m
(declare-const __flatten_3__4@42@02 $Ref)
(assert (= __flatten_3__4@42@02 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02))))
; [exec]
; __flatten_2__3 := __flatten_3__4.Main_process_state[0 := 0]
; [eval] __flatten_3__4.Main_process_state[0 := 0]
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) __flatten_3__4@42@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               872
;  :arith-add-rows          1
;  :arith-assert-diseq      16
;  :arith-assert-lower      53
;  :arith-assert-upper      42
;  :arith-conflicts         10
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              44
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             627
;  :mk-clause               52
;  :num-allocs              3776743
;  :num-checks              71
;  :propagations            39
;  :quant-instantiations    38
;  :rlimit-count            134969)
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               872
;  :arith-add-rows          1
;  :arith-assert-diseq      16
;  :arith-assert-lower      53
;  :arith-assert-upper      42
;  :arith-conflicts         10
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              44
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             627
;  :mk-clause               52
;  :num-allocs              3776743
;  :num-checks              72
;  :propagations            39
;  :quant-instantiations    38
;  :rlimit-count            134984)
(declare-const __flatten_2__3@43@02 Seq<Int>)
(assert (Seq_equal
  __flatten_2__3@43@02
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    0
    0)))
; [exec]
; __flatten_1__2.Main_process_state := __flatten_2__3
(set-option :timeout 10)
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) __flatten_1__2@41@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               883
;  :arith-add-rows          4
;  :arith-assert-diseq      17
;  :arith-assert-lower      57
;  :arith-assert-upper      44
;  :arith-conflicts         10
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              44
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             651
;  :mk-clause               72
;  :num-allocs              3776743
;  :num-checks              73
;  :propagations            48
;  :quant-instantiations    43
;  :rlimit-count            135471)
(assert (not (= __flatten_1__2@41@02 $Ref.null)))
; [exec]
; __flatten_4__5 := diz.Sensor_m
(declare-const __flatten_4__5@44@02 $Ref)
(assert (= __flatten_4__5@44@02 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02))))
; [exec]
; __flatten_6__7 := diz.Sensor_m
(declare-const __flatten_6__7@45@02 $Ref)
(assert (= __flatten_6__7@45@02 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02))))
; [exec]
; __flatten_5__6 := __flatten_6__7.Main_event_state[0 := 2]
; [eval] __flatten_6__7.Main_event_state[0 := 2]
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) __flatten_6__7@45@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               886
;  :arith-add-rows          4
;  :arith-assert-diseq      17
;  :arith-assert-lower      57
;  :arith-assert-upper      44
;  :arith-conflicts         10
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              44
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             654
;  :mk-clause               72
;  :num-allocs              3776743
;  :num-checks              74
;  :propagations            48
;  :quant-instantiations    43
;  :rlimit-count            135598)
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               886
;  :arith-add-rows          4
;  :arith-assert-diseq      17
;  :arith-assert-lower      57
;  :arith-assert-upper      44
;  :arith-conflicts         10
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              44
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             654
;  :mk-clause               72
;  :num-allocs              3776743
;  :num-checks              75
;  :propagations            48
;  :quant-instantiations    43
;  :rlimit-count            135613)
(declare-const __flatten_5__6@46@02 Seq<Int>)
(assert (Seq_equal
  __flatten_5__6@46@02
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
    0
    2)))
; [exec]
; __flatten_4__5.Main_event_state := __flatten_5__6
(set-option :timeout 10)
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) __flatten_4__5@44@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               896
;  :arith-add-rows          7
;  :arith-assert-diseq      18
;  :arith-assert-lower      61
;  :arith-assert-upper      46
;  :arith-conflicts         10
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              44
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             677
;  :mk-clause               91
;  :num-allocs              3776743
;  :num-checks              76
;  :propagations            57
;  :quant-instantiations    48
;  :rlimit-count            136111)
(assert (not (= __flatten_4__5@44@02 $Ref.null)))
(push) ; 6
; Loop head block: Check well-definedness of invariant
(declare-const $t@47@02 $Snap)
(assert (= $t@47@02 ($Snap.combine ($Snap.first $t@47@02) ($Snap.second $t@47@02))))
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-add-rows          7
;  :arith-assert-diseq      18
;  :arith-assert-lower      61
;  :arith-assert-upper      46
;  :arith-conflicts         10
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              44
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             678
;  :mk-clause               91
;  :num-allocs              3776743
;  :num-checks              77
;  :propagations            57
;  :quant-instantiations    48
;  :rlimit-count            136244)
(assert (=
  ($Snap.second $t@47@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@47@02))
    ($Snap.second ($Snap.second $t@47@02)))))
(assert (= ($Snap.first ($Snap.second $t@47@02)) $Snap.unit))
; [eval] diz.Sensor_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@47@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@47@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@47@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
  $Snap.unit))
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
  $Snap.unit))
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))
  $Snap.unit))
; [eval] (forall i__13: Int :: { diz.Sensor_m.Main_process_state[i__13] } 0 <= i__13 && i__13 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__13] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|)
(declare-const i__13@48@02 Int)
(push) ; 7
; [eval] 0 <= i__13 && i__13 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__13] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__13 && i__13 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__13
(push) ; 8
; [then-branch: 13 | 0 <= i__13@48@02 | live]
; [else-branch: 13 | !(0 <= i__13@48@02) | live]
(push) ; 9
; [then-branch: 13 | 0 <= i__13@48@02]
(assert (<= 0 i__13@48@02))
; [eval] i__13 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 13 | !(0 <= i__13@48@02)]
(assert (not (<= 0 i__13@48@02)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 14 | i__13@48@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__13@48@02 | live]
; [else-branch: 14 | !(i__13@48@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__13@48@02) | live]
(push) ; 9
; [then-branch: 14 | i__13@48@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__13@48@02]
(assert (and
  (<
    i__13@48@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
  (<= 0 i__13@48@02)))
; [eval] diz.Sensor_m.Main_process_state[i__13] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__13] == -1
; [eval] diz.Sensor_m.Main_process_state[i__13]
(push) ; 10
(assert (not (>= i__13@48@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               945
;  :arith-add-rows          7
;  :arith-assert-diseq      18
;  :arith-assert-lower      66
;  :arith-assert-upper      49
;  :arith-conflicts         10
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              44
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             703
;  :mk-clause               91
;  :num-allocs              3910888
;  :num-checks              78
;  :propagations            57
;  :quant-instantiations    53
;  :rlimit-count            137522)
; [eval] -1
(push) ; 10
; [then-branch: 15 | First:(Second:(Second:(Second:($t@47@02))))[i__13@48@02] == -1 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:($t@47@02))))[i__13@48@02] != -1 | live]
(push) ; 11
; [then-branch: 15 | First:(Second:(Second:(Second:($t@47@02))))[i__13@48@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__13@48@02)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 15 | First:(Second:(Second:(Second:($t@47@02))))[i__13@48@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      i__13@48@02)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__13]
; [eval] diz.Sensor_m.Main_process_state[i__13]
(push) ; 12
(assert (not (>= i__13@48@02 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               945
;  :arith-add-rows          7
;  :arith-assert-diseq      18
;  :arith-assert-lower      66
;  :arith-assert-upper      49
;  :arith-conflicts         10
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              44
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             704
;  :mk-clause               91
;  :num-allocs              3910888
;  :num-checks              79
;  :propagations            57
;  :quant-instantiations    53
;  :rlimit-count            137697)
(push) ; 12
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@47@02))))[i__13@48@02] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@47@02))))[i__13@48@02]) | live]
(push) ; 13
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@47@02))))[i__13@48@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__13@48@02)))
; [eval] diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__13]
(push) ; 14
(assert (not (>= i__13@48@02 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               945
;  :arith-add-rows          7
;  :arith-assert-diseq      19
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         10
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              44
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             707
;  :mk-clause               92
;  :num-allocs              3910888
;  :num-checks              80
;  :propagations            57
;  :quant-instantiations    53
;  :rlimit-count            137821)
; [eval] |diz.Sensor_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@47@02))))[i__13@48@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      i__13@48@02))))
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
; [else-branch: 14 | !(i__13@48@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__13@48@02)]
(assert (not
  (and
    (<
      i__13@48@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
    (<= 0 i__13@48@02))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__13@48@02 Int)) (!
  (implies
    (and
      (<
        i__13@48@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
      (<= 0 i__13@48@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          i__13@48@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__13@48@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__13@48@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__13@48@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))
(declare-const $k@49@02 $Perm)
(assert ($Perm.isReadVar $k@49@02 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@49@02 $Perm.No) (< $Perm.No $k@49@02))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               950
;  :arith-add-rows          7
;  :arith-assert-diseq      20
;  :arith-assert-lower      71
;  :arith-assert-upper      50
;  :arith-conflicts         10
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               42
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             713
;  :mk-clause               94
;  :num-allocs              3910888
;  :num-checks              81
;  :propagations            58
;  :quant-instantiations    53
;  :rlimit-count            138589)
(assert (<= $Perm.No $k@49@02))
(assert (<= $k@49@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@49@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_sensor != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               956
;  :arith-add-rows          7
;  :arith-assert-diseq      20
;  :arith-assert-lower      71
;  :arith-assert-upper      51
;  :arith-conflicts         10
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             716
;  :mk-clause               94
;  :num-allocs              3910888
;  :num-checks              82
;  :propagations            58
;  :quant-instantiations    53
;  :rlimit-count            138912)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               962
;  :arith-add-rows          7
;  :arith-assert-diseq      20
;  :arith-assert-lower      71
;  :arith-assert-upper      51
;  :arith-conflicts         10
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               44
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             719
;  :mk-clause               94
;  :num-allocs              3910888
;  :num-checks              83
;  :propagations            58
;  :quant-instantiations    54
;  :rlimit-count            139268)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               967
;  :arith-add-rows          7
;  :arith-assert-diseq      20
;  :arith-assert-lower      71
;  :arith-assert-upper      51
;  :arith-conflicts         10
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               45
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             720
;  :mk-clause               94
;  :num-allocs              3910888
;  :num-checks              84
;  :propagations            58
;  :quant-instantiations    54
;  :rlimit-count            139525)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               972
;  :arith-add-rows          7
;  :arith-assert-diseq      20
;  :arith-assert-lower      71
;  :arith-assert-upper      51
;  :arith-conflicts         10
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               46
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             721
;  :mk-clause               94
;  :num-allocs              3910888
;  :num-checks              85
;  :propagations            58
;  :quant-instantiations    54
;  :rlimit-count            139792)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               972
;  :arith-add-rows          7
;  :arith-assert-diseq      20
;  :arith-assert-lower      71
;  :arith-assert-upper      51
;  :arith-conflicts         10
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               46
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             721
;  :mk-clause               94
;  :num-allocs              3910888
;  :num-checks              86
;  :propagations            58
;  :quant-instantiations    54
;  :rlimit-count            139805)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))
(declare-const $k@50@02 $Perm)
(assert ($Perm.isReadVar $k@50@02 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@50@02 $Perm.No) (< $Perm.No $k@50@02))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               977
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      52
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               47
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             726
;  :mk-clause               96
;  :num-allocs              3910888
;  :num-checks              87
;  :propagations            59
;  :quant-instantiations    54
;  :rlimit-count            140226)
(assert (<= $Perm.No $k@50@02))
(assert (<= $k@50@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@50@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_controller != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               983
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               48
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             729
;  :mk-clause               96
;  :num-allocs              3910888
;  :num-checks              88
;  :propagations            59
;  :quant-instantiations    54
;  :rlimit-count            140599)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               989
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               49
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             732
;  :mk-clause               96
;  :num-allocs              3910888
;  :num-checks              89
;  :propagations            59
;  :quant-instantiations    55
;  :rlimit-count            141009)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               994
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               50
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             733
;  :mk-clause               96
;  :num-allocs              3910888
;  :num-checks              90
;  :propagations            59
;  :quant-instantiations    55
;  :rlimit-count            141316)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               994
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               50
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             733
;  :mk-clause               96
;  :num-allocs              3910888
;  :num-checks              91
;  :propagations            59
;  :quant-instantiations    55
;  :rlimit-count            141329)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_sensor == diz
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1000
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             735
;  :mk-clause               96
;  :num-allocs              4047856
;  :num-checks              92
;  :propagations            59
;  :quant-instantiations    55
;  :rlimit-count            141678)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
  diz@2@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1008
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             737
;  :mk-clause               96
;  :num-allocs              4047856
;  :num-checks              93
;  :propagations            59
;  :quant-instantiations    55
;  :rlimit-count            142022)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
; Loop head block: Check well-definedness of edge conditions
(push) ; 7
; [eval] diz.Sensor_m.Main_process_state[0] != -1 || diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_process_state[0] != -1
; [eval] diz.Sensor_m.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1017
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             742
;  :mk-clause               96
;  :num-allocs              4047856
;  :num-checks              94
;  :propagations            59
;  :quant-instantiations    57
;  :rlimit-count            142443)
; [eval] -1
(push) ; 8
; [then-branch: 17 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1 | live]
; [else-branch: 17 | First:(Second:(Second:(Second:($t@47@02))))[0] == -1 | live]
(push) ; 9
; [then-branch: 17 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 17 | First:(Second:(Second:(Second:($t@47@02))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    0)
  (- 0 1)))
; [eval] diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1018
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             743
;  :mk-clause               96
;  :num-allocs              4047856
;  :num-checks              95
;  :propagations            59
;  :quant-instantiations    57
;  :rlimit-count            142605)
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
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1018
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             743
;  :mk-clause               96
;  :num-allocs              4047856
;  :num-checks              96
;  :propagations            59
;  :quant-instantiations    57
;  :rlimit-count            142625)
; [eval] -1
(push) ; 8
; [then-branch: 18 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:($t@47@02))))[0] == -1 | live]
(push) ; 9
; [then-branch: 18 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 18 | First:(Second:(Second:(Second:($t@47@02))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    0)
  (- 0 1)))
; [eval] diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1019
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              45
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             744
;  :mk-clause               96
;  :num-allocs              4047856
;  :num-checks              97
;  :propagations            59
;  :quant-instantiations    57
;  :rlimit-count            142783)
; [eval] -2
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(pop) ; 6
(push) ; 6
; Loop head block: Establish invariant
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1019
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              49
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             744
;  :mk-clause               96
;  :num-allocs              4047856
;  :num-checks              98
;  :propagations            59
;  :quant-instantiations    57
;  :rlimit-count            142801)
; [eval] diz.Sensor_m != null
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
(push) ; 7
(assert (not (= (Seq_length __flatten_2__3@43@02) 2)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1019
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      53
;  :arith-conflicts         10
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               52
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              49
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             747
;  :mk-clause               96
;  :num-allocs              4047856
;  :num-checks              99
;  :propagations            59
;  :quant-instantiations    57
;  :rlimit-count            142875)
(assert (= (Seq_length __flatten_2__3@43@02) 2))
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
(push) ; 7
(assert (not (= (Seq_length __flatten_5__6@46@02) 3)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1020
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      74
;  :arith-assert-upper      54
;  :arith-conflicts         10
;  :arith-eq-adapter        38
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              49
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             753
;  :mk-clause               96
;  :num-allocs              4047856
;  :num-checks              100
;  :propagations            59
;  :quant-instantiations    57
;  :rlimit-count            143000)
(assert (= (Seq_length __flatten_5__6@46@02) 3))
; [eval] (forall i__13: Int :: { diz.Sensor_m.Main_process_state[i__13] } 0 <= i__13 && i__13 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__13] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|)
(declare-const i__13@51@02 Int)
(push) ; 7
; [eval] 0 <= i__13 && i__13 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__13] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__13 && i__13 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__13
(push) ; 8
; [then-branch: 19 | 0 <= i__13@51@02 | live]
; [else-branch: 19 | !(0 <= i__13@51@02) | live]
(push) ; 9
; [then-branch: 19 | 0 <= i__13@51@02]
(assert (<= 0 i__13@51@02))
; [eval] i__13 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 19 | !(0 <= i__13@51@02)]
(assert (not (<= 0 i__13@51@02)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 20 | i__13@51@02 < |__flatten_2__3@43@02| && 0 <= i__13@51@02 | live]
; [else-branch: 20 | !(i__13@51@02 < |__flatten_2__3@43@02| && 0 <= i__13@51@02) | live]
(push) ; 9
; [then-branch: 20 | i__13@51@02 < |__flatten_2__3@43@02| && 0 <= i__13@51@02]
(assert (and (< i__13@51@02 (Seq_length __flatten_2__3@43@02)) (<= 0 i__13@51@02)))
; [eval] diz.Sensor_m.Main_process_state[i__13] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__13] == -1
; [eval] diz.Sensor_m.Main_process_state[i__13]
(push) ; 10
(assert (not (>= i__13@51@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1021
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      76
;  :arith-assert-upper      56
;  :arith-conflicts         10
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              49
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             758
;  :mk-clause               96
;  :num-allocs              4047856
;  :num-checks              101
;  :propagations            59
;  :quant-instantiations    57
;  :rlimit-count            143187)
; [eval] -1
(push) ; 10
; [then-branch: 21 | __flatten_2__3@43@02[i__13@51@02] == -1 | live]
; [else-branch: 21 | __flatten_2__3@43@02[i__13@51@02] != -1 | live]
(push) ; 11
; [then-branch: 21 | __flatten_2__3@43@02[i__13@51@02] == -1]
(assert (= (Seq_index __flatten_2__3@43@02 i__13@51@02) (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 21 | __flatten_2__3@43@02[i__13@51@02] != -1]
(assert (not (= (Seq_index __flatten_2__3@43@02 i__13@51@02) (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__13]
; [eval] diz.Sensor_m.Main_process_state[i__13]
(push) ; 12
(assert (not (>= i__13@51@02 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1022
;  :arith-add-rows          7
;  :arith-assert-diseq      21
;  :arith-assert-lower      76
;  :arith-assert-upper      56
;  :arith-conflicts         10
;  :arith-eq-adapter        40
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              49
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             765
;  :mk-clause               104
;  :num-allocs              4047856
;  :num-checks              102
;  :propagations            59
;  :quant-instantiations    58
;  :rlimit-count            143350)
(push) ; 12
; [then-branch: 22 | 0 <= __flatten_2__3@43@02[i__13@51@02] | live]
; [else-branch: 22 | !(0 <= __flatten_2__3@43@02[i__13@51@02]) | live]
(push) ; 13
; [then-branch: 22 | 0 <= __flatten_2__3@43@02[i__13@51@02]]
(assert (<= 0 (Seq_index __flatten_2__3@43@02 i__13@51@02)))
; [eval] diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__13]
(push) ; 14
(assert (not (>= i__13@51@02 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1022
;  :arith-add-rows          7
;  :arith-assert-diseq      22
;  :arith-assert-lower      79
;  :arith-assert-upper      56
;  :arith-conflicts         10
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               130
;  :del-clause              49
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             768
;  :mk-clause               105
;  :num-allocs              4047856
;  :num-checks              103
;  :propagations            59
;  :quant-instantiations    58
;  :rlimit-count            143424)
; [eval] |diz.Sensor_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 22 | !(0 <= __flatten_2__3@43@02[i__13@51@02])]
(assert (not (<= 0 (Seq_index __flatten_2__3@43@02 i__13@51@02))))
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
; [else-branch: 20 | !(i__13@51@02 < |__flatten_2__3@43@02| && 0 <= i__13@51@02)]
(assert (not (and (< i__13@51@02 (Seq_length __flatten_2__3@43@02)) (<= 0 i__13@51@02))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 7
(assert (not (forall ((i__13@51@02 Int)) (!
  (implies
    (and (< i__13@51@02 (Seq_length __flatten_2__3@43@02)) (<= 0 i__13@51@02))
    (or
      (= (Seq_index __flatten_2__3@43@02 i__13@51@02) (- 0 1))
      (and
        (<
          (Seq_index __flatten_2__3@43@02 i__13@51@02)
          (Seq_length __flatten_5__6@46@02))
        (<= 0 (Seq_index __flatten_2__3@43@02 i__13@51@02)))))
  :pattern ((Seq_index __flatten_2__3@43@02 i__13@51@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1043
;  :arith-add-rows          7
;  :arith-assert-diseq      28
;  :arith-assert-lower      95
;  :arith-assert-upper      67
;  :arith-conflicts         13
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         15
;  :arith-pivots            10
;  :binary-propagations     11
;  :conflicts               60
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               136
;  :del-clause              121
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             811
;  :mk-clause               168
;  :num-allocs              4047856
;  :num-checks              104
;  :propagations            90
;  :quant-instantiations    62
;  :rlimit-count            144129
;  :time                    0.00)
(assert (forall ((i__13@51@02 Int)) (!
  (implies
    (and (< i__13@51@02 (Seq_length __flatten_2__3@43@02)) (<= 0 i__13@51@02))
    (or
      (= (Seq_index __flatten_2__3@43@02 i__13@51@02) (- 0 1))
      (and
        (<
          (Seq_index __flatten_2__3@43@02 i__13@51@02)
          (Seq_length __flatten_5__6@46@02))
        (<= 0 (Seq_index __flatten_2__3@43@02 i__13@51@02)))))
  :pattern ((Seq_index __flatten_2__3@43@02 i__13@51@02))
  :qid |prog.l<no position>|)))
(declare-const $k@52@02 $Perm)
(assert ($Perm.isReadVar $k@52@02 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@52@02 $Perm.No) (< $Perm.No $k@52@02))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1043
;  :arith-add-rows          7
;  :arith-assert-diseq      29
;  :arith-assert-lower      97
;  :arith-assert-upper      68
;  :arith-conflicts         13
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         15
;  :arith-pivots            10
;  :binary-propagations     11
;  :conflicts               61
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               136
;  :del-clause              121
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             816
;  :mk-clause               170
;  :num-allocs              4047856
;  :num-checks              105
;  :propagations            91
;  :quant-instantiations    62
;  :rlimit-count            144600)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@36@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1043
;  :arith-add-rows          7
;  :arith-assert-diseq      29
;  :arith-assert-lower      97
;  :arith-assert-upper      68
;  :arith-conflicts         13
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         15
;  :arith-pivots            10
;  :binary-propagations     11
;  :conflicts               61
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               136
;  :del-clause              121
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             816
;  :mk-clause               170
;  :num-allocs              4047856
;  :num-checks              106
;  :propagations            91
;  :quant-instantiations    62
;  :rlimit-count            144611)
(assert (< $k@52@02 $k@36@02))
(assert (<= $Perm.No (- $k@36@02 $k@52@02)))
(assert (<= (- $k@36@02 $k@52@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@36@02 $k@52@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) $Ref.null))))
; [eval] diz.Sensor_m.Main_sensor != null
(push) ; 7
(assert (not (< $Perm.No $k@36@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1043
;  :arith-add-rows          7
;  :arith-assert-diseq      29
;  :arith-assert-lower      99
;  :arith-assert-upper      69
;  :arith-conflicts         13
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         15
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               62
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               136
;  :del-clause              121
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             819
;  :mk-clause               170
;  :num-allocs              4047856
;  :num-checks              107
;  :propagations            91
;  :quant-instantiations    62
;  :rlimit-count            144825)
(push) ; 7
(assert (not (< $Perm.No $k@36@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1043
;  :arith-add-rows          7
;  :arith-assert-diseq      29
;  :arith-assert-lower      99
;  :arith-assert-upper      69
;  :arith-conflicts         13
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         15
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               63
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               136
;  :del-clause              121
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             819
;  :mk-clause               170
;  :num-allocs              4047856
;  :num-checks              108
;  :propagations            91
;  :quant-instantiations    62
;  :rlimit-count            144873)
(push) ; 7
(assert (not (< $Perm.No $k@36@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1043
;  :arith-add-rows          7
;  :arith-assert-diseq      29
;  :arith-assert-lower      99
;  :arith-assert-upper      69
;  :arith-conflicts         13
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         15
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               64
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               136
;  :del-clause              121
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             819
;  :mk-clause               170
;  :num-allocs              4047856
;  :num-checks              109
;  :propagations            91
;  :quant-instantiations    62
;  :rlimit-count            144921)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1043
;  :arith-add-rows          7
;  :arith-assert-diseq      29
;  :arith-assert-lower      99
;  :arith-assert-upper      69
;  :arith-conflicts         13
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         15
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               64
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               136
;  :del-clause              121
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             819
;  :mk-clause               170
;  :num-allocs              4047856
;  :num-checks              110
;  :propagations            91
;  :quant-instantiations    62
;  :rlimit-count            144934)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@36@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1043
;  :arith-add-rows          7
;  :arith-assert-diseq      29
;  :arith-assert-lower      99
;  :arith-assert-upper      69
;  :arith-conflicts         13
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         15
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   48
;  :datatype-splits         99
;  :decisions               136
;  :del-clause              121
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             819
;  :mk-clause               170
;  :num-allocs              4047856
;  :num-checks              111
;  :propagations            91
;  :quant-instantiations    62
;  :rlimit-count            144982)
(push) ; 7
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1123
;  :arith-add-rows          7
;  :arith-assert-diseq      29
;  :arith-assert-lower      99
;  :arith-assert-upper      69
;  :arith-conflicts         13
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         15
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 173
;  :datatype-occurs-check   57
;  :datatype-splits         122
;  :decisions               159
;  :del-clause              121
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             841
;  :mk-clause               170
;  :num-allocs              4047856
;  :num-checks              112
;  :propagations            94
;  :quant-instantiations    62
;  :rlimit-count            145730
;  :time                    0.00)
(declare-const $k@53@02 $Perm)
(assert ($Perm.isReadVar $k@53@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@53@02 $Perm.No) (< $Perm.No $k@53@02))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1123
;  :arith-add-rows          7
;  :arith-assert-diseq      30
;  :arith-assert-lower      101
;  :arith-assert-upper      70
;  :arith-conflicts         13
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         15
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               66
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 173
;  :datatype-occurs-check   57
;  :datatype-splits         122
;  :decisions               159
;  :del-clause              121
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             845
;  :mk-clause               172
;  :num-allocs              4047856
;  :num-checks              113
;  :propagations            95
;  :quant-instantiations    62
;  :rlimit-count            145928)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@37@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1123
;  :arith-add-rows          7
;  :arith-assert-diseq      30
;  :arith-assert-lower      101
;  :arith-assert-upper      70
;  :arith-conflicts         13
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         15
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               66
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 173
;  :datatype-occurs-check   57
;  :datatype-splits         122
;  :decisions               159
;  :del-clause              121
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             845
;  :mk-clause               172
;  :num-allocs              4047856
;  :num-checks              114
;  :propagations            95
;  :quant-instantiations    62
;  :rlimit-count            145939)
(assert (< $k@53@02 $k@37@02))
(assert (<= $Perm.No (- $k@37@02 $k@53@02)))
(assert (<= (- $k@37@02 $k@53@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@37@02 $k@53@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)) $Ref.null))))
; [eval] diz.Sensor_m.Main_controller != null
(push) ; 7
(assert (not (< $Perm.No $k@37@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1123
;  :arith-add-rows          7
;  :arith-assert-diseq      30
;  :arith-assert-lower      103
;  :arith-assert-upper      71
;  :arith-conflicts         13
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         15
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               67
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 173
;  :datatype-occurs-check   57
;  :datatype-splits         122
;  :decisions               159
;  :del-clause              121
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             848
;  :mk-clause               172
;  :num-allocs              4047856
;  :num-checks              115
;  :propagations            95
;  :quant-instantiations    62
;  :rlimit-count            146153)
(push) ; 7
(assert (not (< $Perm.No $k@37@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1123
;  :arith-add-rows          7
;  :arith-assert-diseq      30
;  :arith-assert-lower      103
;  :arith-assert-upper      71
;  :arith-conflicts         13
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         15
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               68
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 173
;  :datatype-occurs-check   57
;  :datatype-splits         122
;  :decisions               159
;  :del-clause              121
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             848
;  :mk-clause               172
;  :num-allocs              4047856
;  :num-checks              116
;  :propagations            95
;  :quant-instantiations    62
;  :rlimit-count            146201)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1123
;  :arith-add-rows          7
;  :arith-assert-diseq      30
;  :arith-assert-lower      103
;  :arith-assert-upper      71
;  :arith-conflicts         13
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         15
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               68
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 173
;  :datatype-occurs-check   57
;  :datatype-splits         122
;  :decisions               159
;  :del-clause              121
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             848
;  :mk-clause               172
;  :num-allocs              4047856
;  :num-checks              117
;  :propagations            95
;  :quant-instantiations    62
;  :rlimit-count            146214)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@37@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1123
;  :arith-add-rows          7
;  :arith-assert-diseq      30
;  :arith-assert-lower      103
;  :arith-assert-upper      71
;  :arith-conflicts         13
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         15
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               69
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 173
;  :datatype-occurs-check   57
;  :datatype-splits         122
;  :decisions               159
;  :del-clause              121
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             848
;  :mk-clause               172
;  :num-allocs              4047856
;  :num-checks              118
;  :propagations            95
;  :quant-instantiations    62
;  :rlimit-count            146262)
; [eval] diz.Sensor_m.Main_sensor == diz
(push) ; 7
(assert (not (< $Perm.No $k@36@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1123
;  :arith-add-rows          7
;  :arith-assert-diseq      30
;  :arith-assert-lower      103
;  :arith-assert-upper      71
;  :arith-conflicts         13
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         15
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               70
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 173
;  :datatype-occurs-check   57
;  :datatype-splits         122
;  :decisions               159
;  :del-clause              121
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             848
;  :mk-clause               172
;  :num-allocs              4047856
;  :num-checks              119
;  :propagations            95
;  :quant-instantiations    62
;  :rlimit-count            146310)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1123
;  :arith-add-rows          7
;  :arith-assert-diseq      30
;  :arith-assert-lower      103
;  :arith-assert-upper      71
;  :arith-conflicts         13
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         15
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               70
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 173
;  :datatype-occurs-check   57
;  :datatype-splits         122
;  :decisions               159
;  :del-clause              121
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.28
;  :mk-bool-var             848
;  :mk-clause               172
;  :num-allocs              4047856
;  :num-checks              120
;  :propagations            95
;  :quant-instantiations    62
;  :rlimit-count            146323)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 7
(assert ($Perm.isReadVar $k@49@02 $Perm.Write))
(assert ($Perm.isReadVar $k@50@02 $Perm.Write))
(assert (= $t@47@02 ($Snap.combine ($Snap.first $t@47@02) ($Snap.second $t@47@02))))
(assert (=
  ($Snap.second $t@47@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@47@02))
    ($Snap.second ($Snap.second $t@47@02)))))
(assert (= ($Snap.first ($Snap.second $t@47@02)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@47@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@47@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@47@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))
  $Snap.unit))
(assert (forall ((i__13@48@02 Int)) (!
  (implies
    (and
      (<
        i__13@48@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
      (<= 0 i__13@48@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          i__13@48@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__13@48@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__13@48@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__13@48@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))
(assert (<= $Perm.No $k@49@02))
(assert (<= $k@49@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@49@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))
(assert (<= $Perm.No $k@50@02))
(assert (<= $k@50@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@50@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
  diz@2@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))))))
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))
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
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1553
;  :arith-add-rows          7
;  :arith-assert-diseq      32
;  :arith-assert-lower      111
;  :arith-assert-upper      77
;  :arith-conflicts         13
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         15
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    129
;  :datatype-constructor-ax 264
;  :datatype-occurs-check   79
;  :datatype-splits         190
;  :decisions               242
;  :del-clause              127
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             974
;  :mk-clause               179
;  :num-allocs              4190869
;  :num-checks              123
;  :propagations            104
;  :quant-instantiations    71
;  :rlimit-count            151621)
; [eval] -1
(push) ; 8
; [then-branch: 23 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1 | live]
; [else-branch: 23 | First:(Second:(Second:(Second:($t@47@02))))[0] == -1 | live]
(push) ; 9
; [then-branch: 23 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 23 | First:(Second:(Second:(Second:($t@47@02))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    0)
  (- 0 1)))
; [eval] diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1554
;  :arith-add-rows          7
;  :arith-assert-diseq      32
;  :arith-assert-lower      111
;  :arith-assert-upper      77
;  :arith-conflicts         13
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         15
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    129
;  :datatype-constructor-ax 264
;  :datatype-occurs-check   79
;  :datatype-splits         190
;  :decisions               242
;  :del-clause              127
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             975
;  :mk-clause               179
;  :num-allocs              4190869
;  :num-checks              124
;  :propagations            104
;  :quant-instantiations    71
;  :rlimit-count            151779)
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
          0)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1691
;  :arith-add-rows          7
;  :arith-assert-diseq      35
;  :arith-assert-lower      122
;  :arith-assert-upper      82
;  :arith-conflicts         13
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 301
;  :datatype-occurs-check   90
;  :datatype-splits         224
;  :decisions               276
;  :del-clause              152
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1033
;  :mk-clause               204
;  :num-allocs              4190869
;  :num-checks              125
;  :propagations            118
;  :quant-instantiations    75
;  :rlimit-count            153195
;  :time                    0.00)
(push) ; 8
(assert (not (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
        0)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      35
;  :arith-assert-lower      122
;  :arith-assert-upper      82
;  :arith-conflicts         13
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              152
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1068
;  :mk-clause               204
;  :num-allocs              4190869
;  :num-checks              126
;  :propagations            122
;  :quant-instantiations    75
;  :rlimit-count            154349
;  :time                    0.00)
; [then-branch: 24 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@47@02))))))[0] != -2 | live]
; [else-branch: 24 | !(First:(Second:(Second:(Second:($t@47@02))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@47@02))))))[0] != -2) | live]
(push) ; 8
; [then-branch: 24 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@47@02))))))[0] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
        0)
      (- 0 2)))))
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz.Sensor_m, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@54@02 Int)
(push) ; 9
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 10
; [then-branch: 25 | 0 <= i@54@02 | live]
; [else-branch: 25 | !(0 <= i@54@02) | live]
(push) ; 11
; [then-branch: 25 | 0 <= i@54@02]
(assert (<= 0 i@54@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 25 | !(0 <= i@54@02)]
(assert (not (<= 0 i@54@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 26 | i@54@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i@54@02 | live]
; [else-branch: 26 | !(i@54@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i@54@02) | live]
(push) ; 11
; [then-branch: 26 | i@54@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i@54@02]
(assert (and
  (<
    i@54@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
  (<= 0 i@54@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i@54@02 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      35
;  :arith-assert-lower      123
;  :arith-assert-upper      83
;  :arith-conflicts         13
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              152
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1072
;  :mk-clause               205
;  :num-allocs              4190869
;  :num-checks              127
;  :propagations            122
;  :quant-instantiations    75
;  :rlimit-count            154715)
; [eval] -1
(push) ; 12
; [then-branch: 27 | First:(Second:(Second:(Second:($t@47@02))))[i@54@02] == -1 | live]
; [else-branch: 27 | First:(Second:(Second:(Second:($t@47@02))))[i@54@02] != -1 | live]
(push) ; 13
; [then-branch: 27 | First:(Second:(Second:(Second:($t@47@02))))[i@54@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i@54@02)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 27 | First:(Second:(Second:(Second:($t@47@02))))[i@54@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      i@54@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@54@02 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      36
;  :arith-assert-lower      126
;  :arith-assert-upper      84
;  :arith-conflicts         13
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              152
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1078
;  :mk-clause               209
;  :num-allocs              4190869
;  :num-checks              128
;  :propagations            124
;  :quant-instantiations    76
;  :rlimit-count            154947)
(push) ; 14
; [then-branch: 28 | 0 <= First:(Second:(Second:(Second:($t@47@02))))[i@54@02] | live]
; [else-branch: 28 | !(0 <= First:(Second:(Second:(Second:($t@47@02))))[i@54@02]) | live]
(push) ; 15
; [then-branch: 28 | 0 <= First:(Second:(Second:(Second:($t@47@02))))[i@54@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i@54@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 16
(assert (not (>= i@54@02 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      36
;  :arith-assert-lower      126
;  :arith-assert-upper      84
;  :arith-conflicts         13
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              152
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1078
;  :mk-clause               209
;  :num-allocs              4190869
;  :num-checks              129
;  :propagations            124
;  :quant-instantiations    76
;  :rlimit-count            155061)
; [eval] |diz.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 28 | !(0 <= First:(Second:(Second:(Second:($t@47@02))))[i@54@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      i@54@02))))
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
; [else-branch: 26 | !(i@54@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i@54@02)]
(assert (not
  (and
    (<
      i@54@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
    (<= 0 i@54@02))))
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
(assert (not (forall ((i@54@02 Int)) (!
  (implies
    (and
      (<
        i@54@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
      (<= 0 i@54@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          i@54@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i@54@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i@54@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i@54@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      38
;  :arith-assert-lower      127
;  :arith-assert-upper      85
;  :arith-conflicts         13
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     11
;  :conflicts               72
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              170
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1086
;  :mk-clause               223
;  :num-allocs              4190869
;  :num-checks              130
;  :propagations            126
;  :quant-instantiations    77
;  :rlimit-count            155507)
(assert (forall ((i@54@02 Int)) (!
  (implies
    (and
      (<
        i@54@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
      (<= 0 i@54@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          i@54@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i@54@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i@54@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i@54@02))
  :qid |prog.l<no position>|)))
(declare-const $k@55@02 $Perm)
(assert ($Perm.isReadVar $k@55@02 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@55@02 $Perm.No) (< $Perm.No $k@55@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      39
;  :arith-assert-lower      129
;  :arith-assert-upper      86
;  :arith-conflicts         13
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     11
;  :conflicts               73
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              170
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1091
;  :mk-clause               225
;  :num-allocs              4190869
;  :num-checks              131
;  :propagations            127
;  :quant-instantiations    77
;  :rlimit-count            156068)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@49@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      39
;  :arith-assert-lower      129
;  :arith-assert-upper      86
;  :arith-conflicts         13
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     11
;  :conflicts               73
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              170
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1091
;  :mk-clause               225
;  :num-allocs              4190869
;  :num-checks              132
;  :propagations            127
;  :quant-instantiations    77
;  :rlimit-count            156079)
(assert (< $k@55@02 $k@49@02))
(assert (<= $Perm.No (- $k@49@02 $k@55@02)))
(assert (<= (- $k@49@02 $k@55@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@49@02 $k@55@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
; [eval] diz.Main_sensor != null
(push) ; 9
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      39
;  :arith-assert-lower      131
;  :arith-assert-upper      87
;  :arith-conflicts         13
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         17
;  :arith-pivots            17
;  :binary-propagations     11
;  :conflicts               74
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              170
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1094
;  :mk-clause               225
;  :num-allocs              4190869
;  :num-checks              133
;  :propagations            127
;  :quant-instantiations    77
;  :rlimit-count            156293)
(push) ; 9
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      39
;  :arith-assert-lower      131
;  :arith-assert-upper      87
;  :arith-conflicts         13
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         17
;  :arith-pivots            17
;  :binary-propagations     11
;  :conflicts               75
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              170
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1094
;  :mk-clause               225
;  :num-allocs              4190869
;  :num-checks              134
;  :propagations            127
;  :quant-instantiations    77
;  :rlimit-count            156341)
(push) ; 9
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      39
;  :arith-assert-lower      131
;  :arith-assert-upper      87
;  :arith-conflicts         13
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         17
;  :arith-pivots            17
;  :binary-propagations     11
;  :conflicts               76
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              170
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1094
;  :mk-clause               225
;  :num-allocs              4190869
;  :num-checks              135
;  :propagations            127
;  :quant-instantiations    77
;  :rlimit-count            156389)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      39
;  :arith-assert-lower      131
;  :arith-assert-upper      87
;  :arith-conflicts         13
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         17
;  :arith-pivots            17
;  :binary-propagations     11
;  :conflicts               76
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              170
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1094
;  :mk-clause               225
;  :num-allocs              4190869
;  :num-checks              136
;  :propagations            127
;  :quant-instantiations    77
;  :rlimit-count            156402)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1822
;  :arith-add-rows          7
;  :arith-assert-diseq      39
;  :arith-assert-lower      131
;  :arith-assert-upper      87
;  :arith-conflicts         13
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         17
;  :arith-pivots            17
;  :binary-propagations     11
;  :conflicts               77
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 338
;  :datatype-occurs-check   101
;  :datatype-splits         258
;  :decisions               309
;  :del-clause              170
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1094
;  :mk-clause               225
;  :num-allocs              4190869
;  :num-checks              137
;  :propagations            127
;  :quant-instantiations    77
;  :rlimit-count            156450)
(push) ; 9
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1959
;  :arith-add-rows          7
;  :arith-assert-diseq      42
;  :arith-assert-lower      142
;  :arith-assert-upper      92
;  :arith-conflicts         13
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         19
;  :arith-pivots            21
;  :binary-propagations     11
;  :conflicts               77
;  :datatype-accessor-ax    141
;  :datatype-constructor-ax 375
;  :datatype-occurs-check   112
;  :datatype-splits         292
;  :decisions               343
;  :del-clause              194
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1150
;  :mk-clause               249
;  :num-allocs              4190869
;  :num-checks              138
;  :propagations            141
;  :quant-instantiations    82
;  :rlimit-count            157646
;  :time                    0.00)
(declare-const $k@56@02 $Perm)
(assert ($Perm.isReadVar $k@56@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@56@02 $Perm.No) (< $Perm.No $k@56@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1959
;  :arith-add-rows          7
;  :arith-assert-diseq      43
;  :arith-assert-lower      144
;  :arith-assert-upper      93
;  :arith-conflicts         13
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         19
;  :arith-pivots            21
;  :binary-propagations     11
;  :conflicts               78
;  :datatype-accessor-ax    141
;  :datatype-constructor-ax 375
;  :datatype-occurs-check   112
;  :datatype-splits         292
;  :decisions               343
;  :del-clause              194
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1154
;  :mk-clause               251
;  :num-allocs              4190869
;  :num-checks              139
;  :propagations            142
;  :quant-instantiations    82
;  :rlimit-count            157844)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@50@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1959
;  :arith-add-rows          7
;  :arith-assert-diseq      43
;  :arith-assert-lower      144
;  :arith-assert-upper      93
;  :arith-conflicts         13
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         19
;  :arith-pivots            21
;  :binary-propagations     11
;  :conflicts               78
;  :datatype-accessor-ax    141
;  :datatype-constructor-ax 375
;  :datatype-occurs-check   112
;  :datatype-splits         292
;  :decisions               343
;  :del-clause              194
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1154
;  :mk-clause               251
;  :num-allocs              4190869
;  :num-checks              140
;  :propagations            142
;  :quant-instantiations    82
;  :rlimit-count            157855)
(assert (< $k@56@02 $k@50@02))
(assert (<= $Perm.No (- $k@50@02 $k@56@02)))
(assert (<= (- $k@50@02 $k@56@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@50@02 $k@56@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
; [eval] diz.Main_controller != null
(push) ; 9
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1959
;  :arith-add-rows          7
;  :arith-assert-diseq      43
;  :arith-assert-lower      146
;  :arith-assert-upper      94
;  :arith-conflicts         13
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         19
;  :arith-pivots            22
;  :binary-propagations     11
;  :conflicts               79
;  :datatype-accessor-ax    141
;  :datatype-constructor-ax 375
;  :datatype-occurs-check   112
;  :datatype-splits         292
;  :decisions               343
;  :del-clause              194
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1157
;  :mk-clause               251
;  :num-allocs              4190869
;  :num-checks              141
;  :propagations            142
;  :quant-instantiations    82
;  :rlimit-count            158069)
(push) ; 9
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1959
;  :arith-add-rows          7
;  :arith-assert-diseq      43
;  :arith-assert-lower      146
;  :arith-assert-upper      94
;  :arith-conflicts         13
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         19
;  :arith-pivots            22
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    141
;  :datatype-constructor-ax 375
;  :datatype-occurs-check   112
;  :datatype-splits         292
;  :decisions               343
;  :del-clause              194
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1157
;  :mk-clause               251
;  :num-allocs              4190869
;  :num-checks              142
;  :propagations            142
;  :quant-instantiations    82
;  :rlimit-count            158117)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1959
;  :arith-add-rows          7
;  :arith-assert-diseq      43
;  :arith-assert-lower      146
;  :arith-assert-upper      94
;  :arith-conflicts         13
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         19
;  :arith-pivots            22
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    141
;  :datatype-constructor-ax 375
;  :datatype-occurs-check   112
;  :datatype-splits         292
;  :decisions               343
;  :del-clause              194
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1157
;  :mk-clause               251
;  :num-allocs              4190869
;  :num-checks              143
;  :propagations            142
;  :quant-instantiations    82
;  :rlimit-count            158130)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1959
;  :arith-add-rows          7
;  :arith-assert-diseq      43
;  :arith-assert-lower      146
;  :arith-assert-upper      94
;  :arith-conflicts         13
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         19
;  :arith-pivots            22
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    141
;  :datatype-constructor-ax 375
;  :datatype-occurs-check   112
;  :datatype-splits         292
;  :decisions               343
;  :del-clause              194
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.38
;  :mk-bool-var             1157
;  :mk-clause               251
;  :num-allocs              4190869
;  :num-checks              144
;  :propagations            142
;  :quant-instantiations    82
;  :rlimit-count            158178)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))))))))))))))))))))) ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) globals@3@02))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(declare-const $t@57@02 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(assert (= $t@57@02 ($Snap.combine ($Snap.first $t@57@02) ($Snap.second $t@57@02))))
(assert (= ($Snap.first $t@57@02) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@57@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@57@02))
    ($Snap.second ($Snap.second $t@57@02)))))
(assert (= ($Snap.first ($Snap.second $t@57@02)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@57@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@57@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@57@02))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@57@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@58@02 Int)
(push) ; 9
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 10
; [then-branch: 29 | 0 <= i@58@02 | live]
; [else-branch: 29 | !(0 <= i@58@02) | live]
(push) ; 11
; [then-branch: 29 | 0 <= i@58@02]
(assert (<= 0 i@58@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 29 | !(0 <= i@58@02)]
(assert (not (<= 0 i@58@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 30 | i@58@02 < |First:(Second:(Second:(Second:($t@57@02))))| && 0 <= i@58@02 | live]
; [else-branch: 30 | !(i@58@02 < |First:(Second:(Second:(Second:($t@57@02))))| && 0 <= i@58@02) | live]
(push) ; 11
; [then-branch: 30 | i@58@02 < |First:(Second:(Second:(Second:($t@57@02))))| && 0 <= i@58@02]
(assert (and
  (<
    i@58@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))
  (<= 0 i@58@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i@58@02 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2181
;  :arith-add-rows          7
;  :arith-assert-diseq      46
;  :arith-assert-lower      162
;  :arith-assert-upper      102
;  :arith-conflicts         13
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         21
;  :arith-pivots            26
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    169
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              222
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1240
;  :mk-clause               275
;  :num-allocs              4341876
;  :num-checks              146
;  :propagations            156
;  :quant-instantiations    91
;  :rlimit-count            161314)
; [eval] -1
(push) ; 12
; [then-branch: 31 | First:(Second:(Second:(Second:($t@57@02))))[i@58@02] == -1 | live]
; [else-branch: 31 | First:(Second:(Second:(Second:($t@57@02))))[i@58@02] != -1 | live]
(push) ; 13
; [then-branch: 31 | First:(Second:(Second:(Second:($t@57@02))))[i@58@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
    i@58@02)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 31 | First:(Second:(Second:(Second:($t@57@02))))[i@58@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
      i@58@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@58@02 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2181
;  :arith-add-rows          7
;  :arith-assert-diseq      46
;  :arith-assert-lower      162
;  :arith-assert-upper      102
;  :arith-conflicts         13
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         21
;  :arith-pivots            26
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    169
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              222
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1241
;  :mk-clause               275
;  :num-allocs              4341876
;  :num-checks              147
;  :propagations            156
;  :quant-instantiations    91
;  :rlimit-count            161489)
(push) ; 14
; [then-branch: 32 | 0 <= First:(Second:(Second:(Second:($t@57@02))))[i@58@02] | live]
; [else-branch: 32 | !(0 <= First:(Second:(Second:(Second:($t@57@02))))[i@58@02]) | live]
(push) ; 15
; [then-branch: 32 | 0 <= First:(Second:(Second:(Second:($t@57@02))))[i@58@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
    i@58@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 16
(assert (not (>= i@58@02 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2181
;  :arith-add-rows          7
;  :arith-assert-diseq      47
;  :arith-assert-lower      165
;  :arith-assert-upper      102
;  :arith-conflicts         13
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         21
;  :arith-pivots            26
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    169
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              222
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1244
;  :mk-clause               276
;  :num-allocs              4341876
;  :num-checks              148
;  :propagations            156
;  :quant-instantiations    91
;  :rlimit-count            161612)
; [eval] |diz.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 32 | !(0 <= First:(Second:(Second:(Second:($t@57@02))))[i@58@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
      i@58@02))))
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
; [else-branch: 30 | !(i@58@02 < |First:(Second:(Second:(Second:($t@57@02))))| && 0 <= i@58@02)]
(assert (not
  (and
    (<
      i@58@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))
    (<= 0 i@58@02))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@58@02 Int)) (!
  (implies
    (and
      (<
        i@58@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))
      (<= 0 i@58@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
          i@58@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
            i@58@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
            i@58@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
    i@58@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))))
(declare-const $k@59@02 $Perm)
(assert ($Perm.isReadVar $k@59@02 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@59@02 $Perm.No) (< $Perm.No $k@59@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2186
;  :arith-add-rows          7
;  :arith-assert-diseq      48
;  :arith-assert-lower      167
;  :arith-assert-upper      103
;  :arith-conflicts         13
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         21
;  :arith-pivots            26
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1250
;  :mk-clause               278
;  :num-allocs              4341876
;  :num-checks              149
;  :propagations            157
;  :quant-instantiations    91
;  :rlimit-count            162380)
(declare-const $t@60@02 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@49@02 $k@55@02))
    (=
      $t@60@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))
  (implies
    (< $Perm.No $k@59@02)
    (=
      $t@60@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))))))
(assert (<= $Perm.No (+ (- $k@49@02 $k@55@02) $k@59@02)))
(assert (<= (+ (- $k@49@02 $k@55@02) $k@59@02) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@49@02 $k@55@02) $k@59@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))
  $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@49@02 $k@55@02) $k@59@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2196
;  :arith-add-rows          8
;  :arith-assert-diseq      48
;  :arith-assert-lower      168
;  :arith-assert-upper      105
;  :arith-conflicts         14
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         22
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1258
;  :mk-clause               278
;  :num-allocs              4341876
;  :num-checks              150
;  :propagations            157
;  :quant-instantiations    92
;  :rlimit-count            162972)
(assert (not (= $t@60@02 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@49@02 $k@55@02) $k@59@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2201
;  :arith-add-rows          8
;  :arith-assert-diseq      48
;  :arith-assert-lower      168
;  :arith-assert-upper      106
;  :arith-conflicts         15
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         23
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               84
;  :datatype-accessor-ax    172
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1260
;  :mk-clause               278
;  :num-allocs              4341876
;  :num-checks              151
;  :propagations            157
;  :quant-instantiations    92
;  :rlimit-count            163269)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@49@02 $k@55@02) $k@59@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2206
;  :arith-add-rows          8
;  :arith-assert-diseq      48
;  :arith-assert-lower      168
;  :arith-assert-upper      107
;  :arith-conflicts         16
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         24
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               85
;  :datatype-accessor-ax    173
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1262
;  :mk-clause               278
;  :num-allocs              4341876
;  :num-checks              152
;  :propagations            157
;  :quant-instantiations    92
;  :rlimit-count            163558)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@49@02 $k@55@02) $k@59@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2211
;  :arith-add-rows          8
;  :arith-assert-diseq      48
;  :arith-assert-lower      168
;  :arith-assert-upper      108
;  :arith-conflicts         17
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         25
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1264
;  :mk-clause               278
;  :num-allocs              4341876
;  :num-checks              153
;  :propagations            157
;  :quant-instantiations    92
;  :rlimit-count            163857)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2211
;  :arith-add-rows          8
;  :arith-assert-diseq      48
;  :arith-assert-lower      168
;  :arith-assert-upper      108
;  :arith-conflicts         17
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         25
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1264
;  :mk-clause               278
;  :num-allocs              4341876
;  :num-checks              154
;  :propagations            157
;  :quant-instantiations    92
;  :rlimit-count            163870)
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
  $t@60@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2211
;  :arith-add-rows          8
;  :arith-assert-diseq      48
;  :arith-assert-lower      168
;  :arith-assert-upper      108
;  :arith-conflicts         17
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         25
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1264
;  :mk-clause               278
;  :num-allocs              4341876
;  :num-checks              155
;  :propagations            157
;  :quant-instantiations    92
;  :rlimit-count            163881)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))))))))
(declare-const $k@61@02 $Perm)
(assert ($Perm.isReadVar $k@61@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@61@02 $Perm.No) (< $Perm.No $k@61@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2219
;  :arith-add-rows          8
;  :arith-assert-diseq      49
;  :arith-assert-lower      170
;  :arith-assert-upper      109
;  :arith-conflicts         17
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         25
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               87
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1271
;  :mk-clause               280
;  :num-allocs              4341876
;  :num-checks              156
;  :propagations            158
;  :quant-instantiations    93
;  :rlimit-count            164383)
(declare-const $t@62@02 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@50@02 $k@56@02))
    (=
      $t@62@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))))))
  (implies
    (< $Perm.No $k@61@02)
    (=
      $t@62@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@50@02 $k@56@02) $k@61@02)))
(assert (<= (+ (- $k@50@02 $k@56@02) $k@61@02) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@50@02 $k@56@02) $k@61@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@50@02 $k@56@02) $k@61@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2229
;  :arith-add-rows          9
;  :arith-assert-diseq      49
;  :arith-assert-lower      171
;  :arith-assert-upper      111
;  :arith-conflicts         18
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         26
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               88
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1279
;  :mk-clause               280
;  :num-allocs              4341876
;  :num-checks              157
;  :propagations            158
;  :quant-instantiations    94
;  :rlimit-count            165159)
(assert (not (= $t@62@02 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@50@02 $k@56@02) $k@61@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2235
;  :arith-add-rows          9
;  :arith-assert-diseq      49
;  :arith-assert-lower      171
;  :arith-assert-upper      112
;  :arith-conflicts         19
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         27
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               89
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1282
;  :mk-clause               280
;  :num-allocs              4341876
;  :num-checks              158
;  :propagations            158
;  :quant-instantiations    94
;  :rlimit-count            165531)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@50@02 $k@56@02) $k@61@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2235
;  :arith-add-rows          9
;  :arith-assert-diseq      49
;  :arith-assert-lower      171
;  :arith-assert-upper      113
;  :arith-conflicts         20
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         28
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               90
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1283
;  :mk-clause               280
;  :num-allocs              4341876
;  :num-checks              159
;  :propagations            158
;  :quant-instantiations    94
;  :rlimit-count            165609)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2235
;  :arith-add-rows          9
;  :arith-assert-diseq      49
;  :arith-assert-lower      171
;  :arith-assert-upper      113
;  :arith-conflicts         20
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         28
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               90
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 412
;  :datatype-occurs-check   165
;  :datatype-splits         326
;  :decisions               377
;  :del-clause              223
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.48
;  :memory                  4.48
;  :mk-bool-var             1283
;  :mk-clause               280
;  :num-allocs              4341876
;  :num-checks              160
;  :propagations            158
;  :quant-instantiations    94
;  :rlimit-count            165622)
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@57@02 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) globals@3@02))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Sensor_m, globals), write)
(declare-const $t@63@02 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; Loop head block: Re-establish invariant
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2693
;  :arith-add-rows          13
;  :arith-assert-diseq      60
;  :arith-assert-lower      213
;  :arith-assert-upper      133
;  :arith-conflicts         20
;  :arith-eq-adapter        101
;  :arith-fixed-eqs         37
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              313
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1459
;  :mk-clause               367
;  :num-allocs              4497333
;  :num-checks              163
;  :propagations            204
;  :quant-instantiations    110
;  :rlimit-count            169058)
; [eval] diz.Sensor_m != null
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
; [eval] (forall i__13: Int :: { diz.Sensor_m.Main_process_state[i__13] } 0 <= i__13 && i__13 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__13] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|)
(declare-const i__13@64@02 Int)
(push) ; 9
; [eval] 0 <= i__13 && i__13 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__13] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__13 && i__13 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__13
(push) ; 10
; [then-branch: 33 | 0 <= i__13@64@02 | live]
; [else-branch: 33 | !(0 <= i__13@64@02) | live]
(push) ; 11
; [then-branch: 33 | 0 <= i__13@64@02]
(assert (<= 0 i__13@64@02))
; [eval] i__13 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 33 | !(0 <= i__13@64@02)]
(assert (not (<= 0 i__13@64@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 34 | i__13@64@02 < |First:(Second:(Second:(Second:($t@57@02))))| && 0 <= i__13@64@02 | live]
; [else-branch: 34 | !(i__13@64@02 < |First:(Second:(Second:(Second:($t@57@02))))| && 0 <= i__13@64@02) | live]
(push) ; 11
; [then-branch: 34 | i__13@64@02 < |First:(Second:(Second:(Second:($t@57@02))))| && 0 <= i__13@64@02]
(assert (and
  (<
    i__13@64@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))
  (<= 0 i__13@64@02)))
; [eval] diz.Sensor_m.Main_process_state[i__13] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__13] == -1
; [eval] diz.Sensor_m.Main_process_state[i__13]
(push) ; 12
(assert (not (>= i__13@64@02 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2693
;  :arith-add-rows          13
;  :arith-assert-diseq      60
;  :arith-assert-lower      214
;  :arith-assert-upper      134
;  :arith-conflicts         20
;  :arith-eq-adapter        101
;  :arith-fixed-eqs         37
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              313
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1461
;  :mk-clause               367
;  :num-allocs              4497333
;  :num-checks              164
;  :propagations            204
;  :quant-instantiations    110
;  :rlimit-count            169194)
; [eval] -1
(push) ; 12
; [then-branch: 35 | First:(Second:(Second:(Second:($t@57@02))))[i__13@64@02] == -1 | live]
; [else-branch: 35 | First:(Second:(Second:(Second:($t@57@02))))[i__13@64@02] != -1 | live]
(push) ; 13
; [then-branch: 35 | First:(Second:(Second:(Second:($t@57@02))))[i__13@64@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
    i__13@64@02)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 35 | First:(Second:(Second:(Second:($t@57@02))))[i__13@64@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
      i__13@64@02)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__13] && diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__13]
; [eval] diz.Sensor_m.Main_process_state[i__13]
(push) ; 14
(assert (not (>= i__13@64@02 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2693
;  :arith-add-rows          13
;  :arith-assert-diseq      61
;  :arith-assert-lower      217
;  :arith-assert-upper      135
;  :arith-conflicts         20
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         37
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              313
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1467
;  :mk-clause               371
;  :num-allocs              4497333
;  :num-checks              165
;  :propagations            206
;  :quant-instantiations    111
;  :rlimit-count            169426)
(push) ; 14
; [then-branch: 36 | 0 <= First:(Second:(Second:(Second:($t@57@02))))[i__13@64@02] | live]
; [else-branch: 36 | !(0 <= First:(Second:(Second:(Second:($t@57@02))))[i__13@64@02]) | live]
(push) ; 15
; [then-branch: 36 | 0 <= First:(Second:(Second:(Second:($t@57@02))))[i__13@64@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
    i__13@64@02)))
; [eval] diz.Sensor_m.Main_process_state[i__13] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__13]
(push) ; 16
(assert (not (>= i__13@64@02 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2693
;  :arith-add-rows          13
;  :arith-assert-diseq      61
;  :arith-assert-lower      217
;  :arith-assert-upper      135
;  :arith-conflicts         20
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         37
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              313
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1467
;  :mk-clause               371
;  :num-allocs              4497333
;  :num-checks              166
;  :propagations            206
;  :quant-instantiations    111
;  :rlimit-count            169540)
; [eval] |diz.Sensor_m.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 36 | !(0 <= First:(Second:(Second:(Second:($t@57@02))))[i__13@64@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
      i__13@64@02))))
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
; [else-branch: 34 | !(i__13@64@02 < |First:(Second:(Second:(Second:($t@57@02))))| && 0 <= i__13@64@02)]
(assert (not
  (and
    (<
      i__13@64@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))
    (<= 0 i__13@64@02))))
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
(assert (not (forall ((i__13@64@02 Int)) (!
  (implies
    (and
      (<
        i__13@64@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))
      (<= 0 i__13@64@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
          i__13@64@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
            i__13@64@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
            i__13@64@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
    i__13@64@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2693
;  :arith-add-rows          13
;  :arith-assert-diseq      63
;  :arith-assert-lower      218
;  :arith-assert-upper      136
;  :arith-conflicts         20
;  :arith-eq-adapter        103
;  :arith-fixed-eqs         37
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              331
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1475
;  :mk-clause               385
;  :num-allocs              4497333
;  :num-checks              167
;  :propagations            208
;  :quant-instantiations    112
;  :rlimit-count            169986)
(assert (forall ((i__13@64@02 Int)) (!
  (implies
    (and
      (<
        i__13@64@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))
      (<= 0 i__13@64@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
          i__13@64@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
            i__13@64@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
            i__13@64@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@02)))))
    i__13@64@02))
  :qid |prog.l<no position>|)))
(declare-const $k@65@02 $Perm)
(assert ($Perm.isReadVar $k@65@02 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@65@02 $Perm.No) (< $Perm.No $k@65@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2693
;  :arith-add-rows          13
;  :arith-assert-diseq      64
;  :arith-assert-lower      220
;  :arith-assert-upper      137
;  :arith-conflicts         20
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         37
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               93
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              331
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1480
;  :mk-clause               387
;  :num-allocs              4497333
;  :num-checks              168
;  :propagations            209
;  :quant-instantiations    112
;  :rlimit-count            170547)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@49@02 $k@55@02) $k@59@02) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2694
;  :arith-add-rows          13
;  :arith-assert-diseq      64
;  :arith-assert-lower      220
;  :arith-assert-upper      138
;  :arith-conflicts         21
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         37
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               94
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              333
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1482
;  :mk-clause               389
;  :num-allocs              4497333
;  :num-checks              169
;  :propagations            210
;  :quant-instantiations    112
;  :rlimit-count            170627)
(assert (< $k@65@02 (+ (- $k@49@02 $k@55@02) $k@59@02)))
(assert (<= $Perm.No (- (+ (- $k@49@02 $k@55@02) $k@59@02) $k@65@02)))
(assert (<= (- (+ (- $k@49@02 $k@55@02) $k@59@02) $k@65@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@49@02 $k@55@02) $k@59@02) $k@65@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
; [eval] diz.Sensor_m.Main_sensor != null
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@49@02 $k@55@02) $k@59@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2694
;  :arith-add-rows          15
;  :arith-assert-diseq      64
;  :arith-assert-lower      222
;  :arith-assert-upper      140
;  :arith-conflicts         22
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         38
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               95
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              333
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1486
;  :mk-clause               389
;  :num-allocs              4497333
;  :num-checks              170
;  :propagations            210
;  :quant-instantiations    112
;  :rlimit-count            170896)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@49@02 $k@55@02) $k@59@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2694
;  :arith-add-rows          15
;  :arith-assert-diseq      64
;  :arith-assert-lower      222
;  :arith-assert-upper      141
;  :arith-conflicts         23
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         39
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               96
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              333
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1487
;  :mk-clause               389
;  :num-allocs              4497333
;  :num-checks              171
;  :propagations            210
;  :quant-instantiations    112
;  :rlimit-count            170977)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@49@02 $k@55@02) $k@59@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2694
;  :arith-add-rows          15
;  :arith-assert-diseq      64
;  :arith-assert-lower      222
;  :arith-assert-upper      142
;  :arith-conflicts         24
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         40
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               97
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              333
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1488
;  :mk-clause               389
;  :num-allocs              4497333
;  :num-checks              172
;  :propagations            210
;  :quant-instantiations    112
;  :rlimit-count            171058)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2694
;  :arith-add-rows          15
;  :arith-assert-diseq      64
;  :arith-assert-lower      222
;  :arith-assert-upper      142
;  :arith-conflicts         24
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         40
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               97
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              333
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1488
;  :mk-clause               389
;  :num-allocs              4497333
;  :num-checks              173
;  :propagations            210
;  :quant-instantiations    112
;  :rlimit-count            171071)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@49@02 $k@55@02) $k@59@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2694
;  :arith-add-rows          15
;  :arith-assert-diseq      64
;  :arith-assert-lower      222
;  :arith-assert-upper      143
;  :arith-conflicts         25
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         41
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               98
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              333
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1489
;  :mk-clause               389
;  :num-allocs              4497333
;  :num-checks              174
;  :propagations            210
;  :quant-instantiations    112
;  :rlimit-count            171152)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02))))))))))
  $t@60@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2694
;  :arith-add-rows          15
;  :arith-assert-diseq      64
;  :arith-assert-lower      222
;  :arith-assert-upper      143
;  :arith-conflicts         25
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         41
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               98
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 525
;  :datatype-occurs-check   237
;  :datatype-splits         410
;  :decisions               482
;  :del-clause              333
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1489
;  :mk-clause               389
;  :num-allocs              4497333
;  :num-checks              175
;  :propagations            210
;  :quant-instantiations    112
;  :rlimit-count            171163)
(push) ; 9
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2877
;  :arith-add-rows          17
;  :arith-assert-diseq      68
;  :arith-assert-lower      237
;  :arith-assert-upper      150
;  :arith-conflicts         25
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         44
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               98
;  :datatype-accessor-ax    192
;  :datatype-constructor-ax 570
;  :datatype-occurs-check   273
;  :datatype-splits         452
;  :decisions               523
;  :del-clause              364
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1562
;  :mk-clause               420
;  :num-allocs              4497333
;  :num-checks              176
;  :propagations            228
;  :quant-instantiations    119
;  :rlimit-count            172662
;  :time                    0.00)
(declare-const $k@66@02 $Perm)
(assert ($Perm.isReadVar $k@66@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@66@02 $Perm.No) (< $Perm.No $k@66@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2877
;  :arith-add-rows          17
;  :arith-assert-diseq      69
;  :arith-assert-lower      239
;  :arith-assert-upper      151
;  :arith-conflicts         25
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         44
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               99
;  :datatype-accessor-ax    192
;  :datatype-constructor-ax 570
;  :datatype-occurs-check   273
;  :datatype-splits         452
;  :decisions               523
;  :del-clause              364
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1566
;  :mk-clause               422
;  :num-allocs              4497333
;  :num-checks              177
;  :propagations            229
;  :quant-instantiations    119
;  :rlimit-count            172861)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@50@02 $k@56@02) $k@61@02) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2878
;  :arith-add-rows          17
;  :arith-assert-diseq      69
;  :arith-assert-lower      239
;  :arith-assert-upper      152
;  :arith-conflicts         26
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         44
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               100
;  :datatype-accessor-ax    192
;  :datatype-constructor-ax 570
;  :datatype-occurs-check   273
;  :datatype-splits         452
;  :decisions               523
;  :del-clause              366
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1568
;  :mk-clause               424
;  :num-allocs              4497333
;  :num-checks              178
;  :propagations            230
;  :quant-instantiations    119
;  :rlimit-count            172939)
(assert (< $k@66@02 (+ (- $k@50@02 $k@56@02) $k@61@02)))
(assert (<= $Perm.No (- (+ (- $k@50@02 $k@56@02) $k@61@02) $k@66@02)))
(assert (<= (- (+ (- $k@50@02 $k@56@02) $k@61@02) $k@66@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@50@02 $k@56@02) $k@61@02) $k@66@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
; [eval] diz.Sensor_m.Main_controller != null
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@50@02 $k@56@02) $k@61@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2878
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      154
;  :arith-conflicts         27
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         45
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               101
;  :datatype-accessor-ax    192
;  :datatype-constructor-ax 570
;  :datatype-occurs-check   273
;  :datatype-splits         452
;  :decisions               523
;  :del-clause              366
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1572
;  :mk-clause               424
;  :num-allocs              4497333
;  :num-checks              179
;  :propagations            230
;  :quant-instantiations    119
;  :rlimit-count            173204)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@50@02 $k@56@02) $k@61@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2878
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      155
;  :arith-conflicts         28
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         46
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               102
;  :datatype-accessor-ax    192
;  :datatype-constructor-ax 570
;  :datatype-occurs-check   273
;  :datatype-splits         452
;  :decisions               523
;  :del-clause              366
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1573
;  :mk-clause               424
;  :num-allocs              4497333
;  :num-checks              180
;  :propagations            230
;  :quant-instantiations    119
;  :rlimit-count            173282)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2878
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      155
;  :arith-conflicts         28
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         46
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               102
;  :datatype-accessor-ax    192
;  :datatype-constructor-ax 570
;  :datatype-occurs-check   273
;  :datatype-splits         452
;  :decisions               523
;  :del-clause              366
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1573
;  :mk-clause               424
;  :num-allocs              4497333
;  :num-checks              181
;  :propagations            230
;  :quant-instantiations    119
;  :rlimit-count            173295)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@50@02 $k@56@02) $k@61@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2878
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      156
;  :arith-conflicts         29
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         47
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               103
;  :datatype-accessor-ax    192
;  :datatype-constructor-ax 570
;  :datatype-occurs-check   273
;  :datatype-splits         452
;  :decisions               523
;  :del-clause              366
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1574
;  :mk-clause               424
;  :num-allocs              4497333
;  :num-checks              182
;  :propagations            230
;  :quant-instantiations    119
;  :rlimit-count            173373)
; [eval] diz.Sensor_m.Main_sensor == diz
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@49@02 $k@55@02) $k@59@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2878
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      157
;  :arith-conflicts         30
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         48
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               104
;  :datatype-accessor-ax    192
;  :datatype-constructor-ax 570
;  :datatype-occurs-check   273
;  :datatype-splits         452
;  :decisions               523
;  :del-clause              366
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1575
;  :mk-clause               424
;  :num-allocs              4497333
;  :num-checks              183
;  :propagations            230
;  :quant-instantiations    119
;  :rlimit-count            173454)
(set-option :timeout 0)
(push) ; 9
(assert (not (= $t@60@02 diz@2@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2878
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      157
;  :arith-conflicts         30
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         48
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               104
;  :datatype-accessor-ax    192
;  :datatype-constructor-ax 570
;  :datatype-occurs-check   273
;  :datatype-splits         452
;  :decisions               523
;  :del-clause              366
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1575
;  :mk-clause               424
;  :num-allocs              4497333
;  :num-checks              184
;  :propagations            230
;  :quant-instantiations    119
;  :rlimit-count            173465)
(assert (= $t@60@02 diz@2@02))
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2878
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      157
;  :arith-conflicts         30
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         48
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               104
;  :datatype-accessor-ax    192
;  :datatype-constructor-ax 570
;  :datatype-occurs-check   273
;  :datatype-splits         452
;  :decisions               523
;  :del-clause              366
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1575
;  :mk-clause               424
;  :num-allocs              4497333
;  :num-checks              185
;  :propagations            230
;  :quant-instantiations    119
;  :rlimit-count            173481)
(pop) ; 8
(push) ; 8
; [else-branch: 24 | !(First:(Second:(Second:(Second:($t@47@02))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@47@02))))))[0] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
          0)
        (- 0 2))))))
(pop) ; 8
(set-option :timeout 10)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3032
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      157
;  :arith-conflicts         30
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         48
;  :arith-pivots            50
;  :binary-propagations     11
;  :conflicts               105
;  :datatype-accessor-ax    197
;  :datatype-constructor-ax 617
;  :datatype-occurs-check   285
;  :datatype-splits         488
;  :decisions               565
;  :del-clause              373
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1614
;  :mk-clause               425
;  :num-allocs              4497333
;  :num-checks              186
;  :propagations            234
;  :quant-instantiations    119
;  :rlimit-count            174686
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3186
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      157
;  :arith-conflicts         30
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         48
;  :arith-pivots            50
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 664
;  :datatype-occurs-check   297
;  :datatype-splits         524
;  :decisions               607
;  :del-clause              374
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1653
;  :mk-clause               426
;  :num-allocs              4497333
;  :num-checks              187
;  :propagations            238
;  :quant-instantiations    119
;  :rlimit-count            175830
;  :time                    0.00)
; [eval] !(diz.Sensor_m.Main_process_state[0] != -1 || diz.Sensor_m.Main_event_state[0] != -2)
; [eval] diz.Sensor_m.Main_process_state[0] != -1 || diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_process_state[0] != -1
; [eval] diz.Sensor_m.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3186
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      157
;  :arith-conflicts         30
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         48
;  :arith-pivots            50
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 664
;  :datatype-occurs-check   297
;  :datatype-splits         524
;  :decisions               607
;  :del-clause              374
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1653
;  :mk-clause               426
;  :num-allocs              4497333
;  :num-checks              188
;  :propagations            238
;  :quant-instantiations    119
;  :rlimit-count            175845)
; [eval] -1
(push) ; 8
; [then-branch: 37 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1 | live]
; [else-branch: 37 | First:(Second:(Second:(Second:($t@47@02))))[0] == -1 | live]
(push) ; 9
; [then-branch: 37 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 37 | First:(Second:(Second:(Second:($t@47@02))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    0)
  (- 0 1)))
; [eval] diz.Sensor_m.Main_event_state[0] != -2
; [eval] diz.Sensor_m.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3187
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      157
;  :arith-conflicts         30
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         48
;  :arith-pivots            50
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 664
;  :datatype-occurs-check   297
;  :datatype-splits         524
;  :decisions               607
;  :del-clause              374
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1654
;  :mk-clause               426
;  :num-allocs              4497333
;  :num-checks              189
;  :propagations            238
;  :quant-instantiations    119
;  :rlimit-count            176003)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
        0)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3318
;  :arith-add-rows          18
;  :arith-assert-diseq      69
;  :arith-assert-lower      241
;  :arith-assert-upper      157
;  :arith-conflicts         30
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         48
;  :arith-pivots            50
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    206
;  :datatype-constructor-ax 701
;  :datatype-occurs-check   308
;  :datatype-splits         558
;  :decisions               640
;  :del-clause              374
;  :final-checks            60
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1689
;  :mk-clause               426
;  :num-allocs              4497333
;  :num-checks              190
;  :propagations            242
;  :quant-instantiations    119
;  :rlimit-count            177157
;  :time                    0.00)
(push) ; 8
(assert (not (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
          0)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3455
;  :arith-add-rows          18
;  :arith-assert-diseq      72
;  :arith-assert-lower      252
;  :arith-assert-upper      162
;  :arith-conflicts         30
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         50
;  :arith-pivots            54
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    210
;  :datatype-constructor-ax 738
;  :datatype-occurs-check   319
;  :datatype-splits         592
;  :decisions               674
;  :del-clause              399
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1747
;  :mk-clause               451
;  :num-allocs              4497333
;  :num-checks              191
;  :propagations            256
;  :quant-instantiations    123
;  :rlimit-count            178535
;  :time                    0.00)
; [then-branch: 38 | !(First:(Second:(Second:(Second:($t@47@02))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@47@02))))))[0] != -2) | live]
; [else-branch: 38 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@47@02))))))[0] != -2 | live]
(push) ; 8
; [then-branch: 38 | !(First:(Second:(Second:(Second:($t@47@02))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@47@02))))))[0] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
          0)
        (- 0 2))))))
; [exec]
; __flatten_7__8 := Sensor_getDistance_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
(declare-const sys__result@67@02 Int)
(declare-const $t@68@02 $Snap)
(assert (= $t@68@02 ($Snap.combine ($Snap.first $t@68@02) ($Snap.second $t@68@02))))
(assert (= ($Snap.first $t@68@02) $Snap.unit))
; [eval] 0 <= sys__result
(assert (<= 0 sys__result@67@02))
(assert (= ($Snap.second $t@68@02) $Snap.unit))
; [eval] sys__result < 256
(assert (< sys__result@67@02 256))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; diz.Sensor_dist := __flatten_7__8
; [eval] diz.Sensor_dist < 50
(set-option :timeout 10)
(push) ; 9
(assert (not (not (< sys__result@67@02 50))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3724
;  :arith-add-rows          18
;  :arith-assert-diseq      72
;  :arith-assert-lower      253
;  :arith-assert-upper      164
;  :arith-conflicts         30
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         50
;  :arith-pivots            54
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    219
;  :datatype-constructor-ax 812
;  :datatype-occurs-check   343
;  :datatype-splits         660
;  :decisions               740
;  :del-clause              399
;  :final-checks            69
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1821
;  :mk-clause               451
;  :num-allocs              4497333
;  :num-checks              193
;  :propagations            264
;  :quant-instantiations    123
;  :rlimit-count            180961
;  :time                    0.00)
(push) ; 9
(assert (not (< sys__result@67@02 50)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3854
;  :arith-add-rows          18
;  :arith-assert-diseq      72
;  :arith-assert-lower      254
;  :arith-assert-upper      164
;  :arith-conflicts         30
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         50
;  :arith-pivots            54
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              399
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1855
;  :mk-clause               451
;  :num-allocs              4497333
;  :num-checks              194
;  :propagations            268
;  :quant-instantiations    123
;  :rlimit-count            181965
;  :time                    0.00)
; [then-branch: 39 | sys__result@67@02 < 50 | live]
; [else-branch: 39 | !(sys__result@67@02 < 50) | live]
(push) ; 9
; [then-branch: 39 | sys__result@67@02 < 50]
(assert (< sys__result@67@02 50))
; [exec]
; __flatten_9__9 := diz.Sensor_m
(declare-const __flatten_9__9@69@02 $Ref)
(assert (= __flatten_9__9@69@02 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02))))
; [exec]
; __flatten_11__11 := diz.Sensor_m
(declare-const __flatten_11__11@70@02 $Ref)
(assert (= __flatten_11__11@70@02 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02))))
; [exec]
; __flatten_10__10 := __flatten_11__11.Main_event_state[1 := -1]
; [eval] __flatten_11__11.Main_event_state[1 := -1]
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) __flatten_11__11@70@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3856
;  :arith-add-rows          18
;  :arith-assert-diseq      72
;  :arith-assert-lower      254
;  :arith-assert-upper      165
;  :arith-conflicts         30
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         50
;  :arith-pivots            54
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              399
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1858
;  :mk-clause               451
;  :num-allocs              4497333
;  :num-checks              195
;  :propagations            268
;  :quant-instantiations    123
;  :rlimit-count            182130)
; [eval] -1
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3856
;  :arith-add-rows          18
;  :arith-assert-diseq      72
;  :arith-assert-lower      254
;  :arith-assert-upper      165
;  :arith-conflicts         30
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         50
;  :arith-pivots            54
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              399
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1858
;  :mk-clause               451
;  :num-allocs              4497333
;  :num-checks              196
;  :propagations            268
;  :quant-instantiations    123
;  :rlimit-count            182145)
(declare-const __flatten_10__10@71@02 Seq<Int>)
(assert (Seq_equal
  __flatten_10__10@71@02
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
    1
    (- 0 1))))
; [exec]
; __flatten_9__9.Main_event_state := __flatten_10__10
(set-option :timeout 10)
(push) ; 10
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) __flatten_9__9@69@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          21
;  :arith-assert-diseq      73
;  :arith-assert-lower      258
;  :arith-assert-upper      167
;  :arith-conflicts         30
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              399
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1882
;  :mk-clause               471
;  :num-allocs              4497333
;  :num-checks              197
;  :propagations            277
;  :quant-instantiations    128
;  :rlimit-count            182662)
(assert (not (= __flatten_9__9@69@02 $Ref.null)))
; [exec]
; diz.Sensor_obs_detected := true
; [exec]
; // assert
; assert diz.Sensor_dist < 50 == diz.Sensor_obs_detected
; [eval] diz.Sensor_dist < 50 == diz.Sensor_obs_detected
; [eval] diz.Sensor_dist < 50
(set-option :timeout 0)
(push) ; 10
(assert (not (= (< sys__result@67@02 50) true)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3868
;  :arith-add-rows          21
;  :arith-assert-diseq      73
;  :arith-assert-lower      258
;  :arith-assert-upper      167
;  :arith-conflicts         30
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              399
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1883
;  :mk-clause               471
;  :num-allocs              4497333
;  :num-checks              198
;  :propagations            277
;  :quant-instantiations    128
;  :rlimit-count            182740)
(assert (= (< sys__result@67@02 50) true))
; Loop head block: Re-establish invariant
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3868
;  :arith-add-rows          21
;  :arith-assert-diseq      73
;  :arith-assert-lower      258
;  :arith-assert-upper      167
;  :arith-conflicts         30
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              399
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1883
;  :mk-clause               471
;  :num-allocs              4497333
;  :num-checks              199
;  :propagations            277
;  :quant-instantiations    128
;  :rlimit-count            182777)
; [eval] diz.Sensor_m != null
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
(push) ; 10
(assert (not (= (Seq_length __flatten_10__10@71@02) 3)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3868
;  :arith-add-rows          21
;  :arith-assert-diseq      73
;  :arith-assert-lower      258
;  :arith-assert-upper      167
;  :arith-conflicts         30
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              399
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1886
;  :mk-clause               471
;  :num-allocs              4497333
;  :num-checks              200
;  :propagations            277
;  :quant-instantiations    128
;  :rlimit-count            182851)
(assert (= (Seq_length __flatten_10__10@71@02) 3))
; [eval] (forall i__12: Int :: { diz.Sensor_m.Main_process_state[i__12] } 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|)
(declare-const i__12@72@02 Int)
(push) ; 10
; [eval] 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__12
(push) ; 11
; [then-branch: 40 | 0 <= i__12@72@02 | live]
; [else-branch: 40 | !(0 <= i__12@72@02) | live]
(push) ; 12
; [then-branch: 40 | 0 <= i__12@72@02]
(assert (<= 0 i__12@72@02))
; [eval] i__12 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(pop) ; 12
(push) ; 12
; [else-branch: 40 | !(0 <= i__12@72@02)]
(assert (not (<= 0 i__12@72@02)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(push) ; 11
; [then-branch: 41 | i__12@72@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__12@72@02 | live]
; [else-branch: 41 | !(i__12@72@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__12@72@02) | live]
(push) ; 12
; [then-branch: 41 | i__12@72@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__12@72@02]
(assert (and
  (<
    i__12@72@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
  (<= 0 i__12@72@02)))
; [eval] diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__12] == -1
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 13
(assert (not (>= i__12@72@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      73
;  :arith-assert-lower      260
;  :arith-assert-upper      169
;  :arith-conflicts         30
;  :arith-eq-adapter        124
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              399
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1891
;  :mk-clause               471
;  :num-allocs              4497333
;  :num-checks              201
;  :propagations            277
;  :quant-instantiations    128
;  :rlimit-count            183038)
; [eval] -1
(push) ; 13
; [then-branch: 42 | First:(Second:(Second:(Second:($t@47@02))))[i__12@72@02] == -1 | live]
; [else-branch: 42 | First:(Second:(Second:(Second:($t@47@02))))[i__12@72@02] != -1 | live]
(push) ; 14
; [then-branch: 42 | First:(Second:(Second:(Second:($t@47@02))))[i__12@72@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__12@72@02)
  (- 0 1)))
(pop) ; 14
(push) ; 14
; [else-branch: 42 | First:(Second:(Second:(Second:($t@47@02))))[i__12@72@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      i__12@72@02)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__12]
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 15
(assert (not (>= i__12@72@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      74
;  :arith-assert-lower      263
;  :arith-assert-upper      170
;  :arith-conflicts         30
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              399
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1897
;  :mk-clause               475
;  :num-allocs              4497333
;  :num-checks              202
;  :propagations            279
;  :quant-instantiations    129
;  :rlimit-count            183270)
(push) ; 15
; [then-branch: 43 | 0 <= First:(Second:(Second:(Second:($t@47@02))))[i__12@72@02] | live]
; [else-branch: 43 | !(0 <= First:(Second:(Second:(Second:($t@47@02))))[i__12@72@02]) | live]
(push) ; 16
; [then-branch: 43 | 0 <= First:(Second:(Second:(Second:($t@47@02))))[i__12@72@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__12@72@02)))
; [eval] diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 17
(assert (not (>= i__12@72@02 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      74
;  :arith-assert-lower      263
;  :arith-assert-upper      170
;  :arith-conflicts         30
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              399
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1897
;  :mk-clause               475
;  :num-allocs              4497333
;  :num-checks              203
;  :propagations            279
;  :quant-instantiations    129
;  :rlimit-count            183384)
; [eval] |diz.Sensor_m.Main_event_state|
(pop) ; 16
(push) ; 16
; [else-branch: 43 | !(0 <= First:(Second:(Second:(Second:($t@47@02))))[i__12@72@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      i__12@72@02))))
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
; [else-branch: 41 | !(i__12@72@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__12@72@02)]
(assert (not
  (and
    (<
      i__12@72@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
    (<= 0 i__12@72@02))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 10
(assert (not (forall ((i__12@72@02 Int)) (!
  (implies
    (and
      (<
        i__12@72@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
      (<= 0 i__12@72@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          i__12@72@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__12@72@02)
          (Seq_length __flatten_10__10@71@02))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__12@72@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__12@72@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      76
;  :arith-assert-lower      264
;  :arith-assert-upper      171
;  :arith-conflicts         30
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               108
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              417
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1905
;  :mk-clause               489
;  :num-allocs              4497333
;  :num-checks              204
;  :propagations            281
;  :quant-instantiations    130
;  :rlimit-count            183830)
(assert (forall ((i__12@72@02 Int)) (!
  (implies
    (and
      (<
        i__12@72@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
      (<= 0 i__12@72@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          i__12@72@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__12@72@02)
          (Seq_length __flatten_10__10@71@02))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__12@72@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__12@72@02))
  :qid |prog.l<no position>|)))
(declare-const $k@73@02 $Perm)
(assert ($Perm.isReadVar $k@73@02 $Perm.Write))
(push) ; 10
(assert (not (or (= $k@73@02 $Perm.No) (< $Perm.No $k@73@02))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      77
;  :arith-assert-lower      266
;  :arith-assert-upper      172
;  :arith-conflicts         30
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               109
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              417
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1910
;  :mk-clause               491
;  :num-allocs              4497333
;  :num-checks              205
;  :propagations            282
;  :quant-instantiations    130
;  :rlimit-count            184392)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= $k@49@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      77
;  :arith-assert-lower      266
;  :arith-assert-upper      172
;  :arith-conflicts         30
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               109
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              417
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1910
;  :mk-clause               491
;  :num-allocs              4497333
;  :num-checks              206
;  :propagations            282
;  :quant-instantiations    130
;  :rlimit-count            184403)
(assert (< $k@73@02 $k@49@02))
(assert (<= $Perm.No (- $k@49@02 $k@73@02)))
(assert (<= (- $k@49@02 $k@73@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@49@02 $k@73@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
; [eval] diz.Sensor_m.Main_sensor != null
(push) ; 10
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      77
;  :arith-assert-lower      268
;  :arith-assert-upper      173
;  :arith-conflicts         30
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               110
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              417
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1913
;  :mk-clause               491
;  :num-allocs              4497333
;  :num-checks              207
;  :propagations            282
;  :quant-instantiations    130
;  :rlimit-count            184611)
(push) ; 10
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      77
;  :arith-assert-lower      268
;  :arith-assert-upper      173
;  :arith-conflicts         30
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               111
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              417
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1913
;  :mk-clause               491
;  :num-allocs              4497333
;  :num-checks              208
;  :propagations            282
;  :quant-instantiations    130
;  :rlimit-count            184659)
(push) ; 10
(assert (not (=
  diz@2@02
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      77
;  :arith-assert-lower      268
;  :arith-assert-upper      173
;  :arith-conflicts         30
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               111
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              417
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1913
;  :mk-clause               491
;  :num-allocs              4497333
;  :num-checks              209
;  :propagations            282
;  :quant-instantiations    130
;  :rlimit-count            184670)
(push) ; 10
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      77
;  :arith-assert-lower      268
;  :arith-assert-upper      173
;  :arith-conflicts         30
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               112
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              417
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1913
;  :mk-clause               491
;  :num-allocs              4497333
;  :num-checks              210
;  :propagations            282
;  :quant-instantiations    130
;  :rlimit-count            184718)
(push) ; 10
(assert (not (=
  diz@2@02
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      77
;  :arith-assert-lower      268
;  :arith-assert-upper      173
;  :arith-conflicts         30
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               112
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              417
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1913
;  :mk-clause               491
;  :num-allocs              4497333
;  :num-checks              211
;  :propagations            282
;  :quant-instantiations    130
;  :rlimit-count            184729)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      77
;  :arith-assert-lower      268
;  :arith-assert-upper      173
;  :arith-conflicts         30
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               112
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              417
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1913
;  :mk-clause               491
;  :num-allocs              4497333
;  :num-checks              212
;  :propagations            282
;  :quant-instantiations    130
;  :rlimit-count            184742)
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3869
;  :arith-add-rows          21
;  :arith-assert-diseq      77
;  :arith-assert-lower      268
;  :arith-assert-upper      173
;  :arith-conflicts         30
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               113
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   355
;  :datatype-splits         694
;  :decisions               773
;  :del-clause              417
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1913
;  :mk-clause               491
;  :num-allocs              4497333
;  :num-checks              213
;  :propagations            282
;  :quant-instantiations    130
;  :rlimit-count            184790)
(push) ; 10
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3999
;  :arith-add-rows          21
;  :arith-assert-diseq      77
;  :arith-assert-lower      268
;  :arith-assert-upper      173
;  :arith-conflicts         30
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               113
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 886
;  :datatype-occurs-check   367
;  :datatype-splits         728
;  :decisions               806
;  :del-clause              417
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1946
;  :mk-clause               491
;  :num-allocs              4497333
;  :num-checks              214
;  :propagations            286
;  :quant-instantiations    130
;  :rlimit-count            185773
;  :time                    0.00)
(declare-const $k@74@02 $Perm)
(assert ($Perm.isReadVar $k@74@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@74@02 $Perm.No) (< $Perm.No $k@74@02))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3999
;  :arith-add-rows          21
;  :arith-assert-diseq      78
;  :arith-assert-lower      270
;  :arith-assert-upper      174
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               114
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 886
;  :datatype-occurs-check   367
;  :datatype-splits         728
;  :decisions               806
;  :del-clause              417
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1950
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              215
;  :propagations            287
;  :quant-instantiations    130
;  :rlimit-count            185971)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= $k@50@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3999
;  :arith-add-rows          21
;  :arith-assert-diseq      78
;  :arith-assert-lower      270
;  :arith-assert-upper      174
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            56
;  :binary-propagations     11
;  :conflicts               114
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 886
;  :datatype-occurs-check   367
;  :datatype-splits         728
;  :decisions               806
;  :del-clause              417
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1950
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              216
;  :propagations            287
;  :quant-instantiations    130
;  :rlimit-count            185982)
(assert (< $k@74@02 $k@50@02))
(assert (<= $Perm.No (- $k@50@02 $k@74@02)))
(assert (<= (- $k@50@02 $k@74@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@50@02 $k@74@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
; [eval] diz.Sensor_m.Main_controller != null
(push) ; 10
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3999
;  :arith-add-rows          21
;  :arith-assert-diseq      78
;  :arith-assert-lower      272
;  :arith-assert-upper      175
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            57
;  :binary-propagations     11
;  :conflicts               115
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 886
;  :datatype-occurs-check   367
;  :datatype-splits         728
;  :decisions               806
;  :del-clause              417
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1953
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              217
;  :propagations            287
;  :quant-instantiations    130
;  :rlimit-count            186196)
(push) ; 10
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3999
;  :arith-add-rows          21
;  :arith-assert-diseq      78
;  :arith-assert-lower      272
;  :arith-assert-upper      175
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            57
;  :binary-propagations     11
;  :conflicts               116
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 886
;  :datatype-occurs-check   367
;  :datatype-splits         728
;  :decisions               806
;  :del-clause              417
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1953
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              218
;  :propagations            287
;  :quant-instantiations    130
;  :rlimit-count            186244)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3999
;  :arith-add-rows          21
;  :arith-assert-diseq      78
;  :arith-assert-lower      272
;  :arith-assert-upper      175
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            57
;  :binary-propagations     11
;  :conflicts               116
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 886
;  :datatype-occurs-check   367
;  :datatype-splits         728
;  :decisions               806
;  :del-clause              417
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1953
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              219
;  :propagations            287
;  :quant-instantiations    130
;  :rlimit-count            186257)
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3999
;  :arith-add-rows          21
;  :arith-assert-diseq      78
;  :arith-assert-lower      272
;  :arith-assert-upper      175
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            57
;  :binary-propagations     11
;  :conflicts               117
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 886
;  :datatype-occurs-check   367
;  :datatype-splits         728
;  :decisions               806
;  :del-clause              417
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1953
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              220
;  :propagations            287
;  :quant-instantiations    130
;  :rlimit-count            186305)
; [eval] diz.Sensor_m.Main_sensor == diz
(push) ; 10
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3999
;  :arith-add-rows          21
;  :arith-assert-diseq      78
;  :arith-assert-lower      272
;  :arith-assert-upper      175
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            57
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 886
;  :datatype-occurs-check   367
;  :datatype-splits         728
;  :decisions               806
;  :del-clause              417
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1953
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              221
;  :propagations            287
;  :quant-instantiations    130
;  :rlimit-count            186353)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3999
;  :arith-add-rows          21
;  :arith-assert-diseq      78
;  :arith-assert-lower      272
;  :arith-assert-upper      175
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            57
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 886
;  :datatype-occurs-check   367
;  :datatype-splits         728
;  :decisions               806
;  :del-clause              417
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1953
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              222
;  :propagations            287
;  :quant-instantiations    130
;  :rlimit-count            186366)
(pop) ; 9
(push) ; 9
; [else-branch: 39 | !(sys__result@67@02 < 50)]
(assert (not (< sys__result@67@02 50)))
(pop) ; 9
; [eval] !(diz.Sensor_dist < 50)
; [eval] diz.Sensor_dist < 50
(set-option :timeout 10)
(push) ; 9
(assert (not (< sys__result@67@02 50)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4129
;  :arith-add-rows          22
;  :arith-assert-diseq      78
;  :arith-assert-lower      273
;  :arith-assert-upper      175
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    231
;  :datatype-constructor-ax 923
;  :datatype-occurs-check   379
;  :datatype-splits         762
;  :decisions               839
;  :del-clause              441
;  :final-checks            78
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             1987
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              223
;  :propagations            291
;  :quant-instantiations    130
;  :rlimit-count            187408
;  :time                    0.00)
(push) ; 9
(assert (not (not (< sys__result@67@02 50))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      78
;  :arith-assert-lower      273
;  :arith-assert-upper      176
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              441
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2021
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              224
;  :propagations            295
;  :quant-instantiations    130
;  :rlimit-count            188430
;  :time                    0.00)
; [then-branch: 44 | !(sys__result@67@02 < 50) | live]
; [else-branch: 44 | sys__result@67@02 < 50 | live]
(push) ; 9
; [then-branch: 44 | !(sys__result@67@02 < 50)]
(assert (not (< sys__result@67@02 50)))
; [exec]
; diz.Sensor_obs_detected := false
; [exec]
; // assert
; assert diz.Sensor_dist < 50 == diz.Sensor_obs_detected
; [eval] diz.Sensor_dist < 50 == diz.Sensor_obs_detected
; [eval] diz.Sensor_dist < 50
(set-option :timeout 0)
(push) ; 10
(assert (not (= (< sys__result@67@02 50) false)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      78
;  :arith-assert-lower      274
;  :arith-assert-upper      176
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              441
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2022
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              225
;  :propagations            295
;  :quant-instantiations    130
;  :rlimit-count            188502)
(assert (= (< sys__result@67@02 50) false))
; Loop head block: Re-establish invariant
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      78
;  :arith-assert-lower      274
;  :arith-assert-upper      176
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              441
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2022
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              226
;  :propagations            295
;  :quant-instantiations    130
;  :rlimit-count            188538)
; [eval] diz.Sensor_m != null
; [eval] |diz.Sensor_m.Main_process_state| == 2
; [eval] |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_event_state| == 3
; [eval] |diz.Sensor_m.Main_event_state|
; [eval] (forall i__12: Int :: { diz.Sensor_m.Main_process_state[i__12] } 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|)
(declare-const i__12@75@02 Int)
(push) ; 10
; [eval] 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state| ==> diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= i__12 && i__12 < |diz.Sensor_m.Main_process_state|
; [eval] 0 <= i__12
(push) ; 11
; [then-branch: 45 | 0 <= i__12@75@02 | live]
; [else-branch: 45 | !(0 <= i__12@75@02) | live]
(push) ; 12
; [then-branch: 45 | 0 <= i__12@75@02]
(assert (<= 0 i__12@75@02))
; [eval] i__12 < |diz.Sensor_m.Main_process_state|
; [eval] |diz.Sensor_m.Main_process_state|
(pop) ; 12
(push) ; 12
; [else-branch: 45 | !(0 <= i__12@75@02)]
(assert (not (<= 0 i__12@75@02)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(push) ; 11
; [then-branch: 46 | i__12@75@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__12@75@02 | live]
; [else-branch: 46 | !(i__12@75@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__12@75@02) | live]
(push) ; 12
; [then-branch: 46 | i__12@75@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__12@75@02]
(assert (and
  (<
    i__12@75@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
  (<= 0 i__12@75@02)))
; [eval] diz.Sensor_m.Main_process_state[i__12] == -1 || 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__12] == -1
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 13
(assert (not (>= i__12@75@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      78
;  :arith-assert-lower      275
;  :arith-assert-upper      177
;  :arith-conflicts         30
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              441
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2024
;  :mk-clause               493
;  :num-allocs              4497333
;  :num-checks              227
;  :propagations            295
;  :quant-instantiations    130
;  :rlimit-count            188674)
; [eval] -1
(push) ; 13
; [then-branch: 47 | First:(Second:(Second:(Second:($t@47@02))))[i__12@75@02] == -1 | live]
; [else-branch: 47 | First:(Second:(Second:(Second:($t@47@02))))[i__12@75@02] != -1 | live]
(push) ; 14
; [then-branch: 47 | First:(Second:(Second:(Second:($t@47@02))))[i__12@75@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__12@75@02)
  (- 0 1)))
(pop) ; 14
(push) ; 14
; [else-branch: 47 | First:(Second:(Second:(Second:($t@47@02))))[i__12@75@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      i__12@75@02)
    (- 0 1))))
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__12] && diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] 0 <= diz.Sensor_m.Main_process_state[i__12]
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 15
(assert (not (>= i__12@75@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      79
;  :arith-assert-lower      278
;  :arith-assert-upper      178
;  :arith-conflicts         30
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              441
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2030
;  :mk-clause               497
;  :num-allocs              4497333
;  :num-checks              228
;  :propagations            297
;  :quant-instantiations    131
;  :rlimit-count            188906)
(push) ; 15
; [then-branch: 48 | 0 <= First:(Second:(Second:(Second:($t@47@02))))[i__12@75@02] | live]
; [else-branch: 48 | !(0 <= First:(Second:(Second:(Second:($t@47@02))))[i__12@75@02]) | live]
(push) ; 16
; [then-branch: 48 | 0 <= First:(Second:(Second:(Second:($t@47@02))))[i__12@75@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__12@75@02)))
; [eval] diz.Sensor_m.Main_process_state[i__12] < |diz.Sensor_m.Main_event_state|
; [eval] diz.Sensor_m.Main_process_state[i__12]
(push) ; 17
(assert (not (>= i__12@75@02 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      79
;  :arith-assert-lower      278
;  :arith-assert-upper      178
;  :arith-conflicts         30
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              441
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2030
;  :mk-clause               497
;  :num-allocs              4497333
;  :num-checks              229
;  :propagations            297
;  :quant-instantiations    131
;  :rlimit-count            189020)
; [eval] |diz.Sensor_m.Main_event_state|
(pop) ; 16
(push) ; 16
; [else-branch: 48 | !(0 <= First:(Second:(Second:(Second:($t@47@02))))[i__12@75@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
      i__12@75@02))))
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
; [else-branch: 46 | !(i__12@75@02 < |First:(Second:(Second:(Second:($t@47@02))))| && 0 <= i__12@75@02)]
(assert (not
  (and
    (<
      i__12@75@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
    (<= 0 i__12@75@02))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 10
(assert (not (forall ((i__12@75@02 Int)) (!
  (implies
    (and
      (<
        i__12@75@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
      (<= 0 i__12@75@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          i__12@75@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__12@75@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__12@75@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__12@75@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      81
;  :arith-assert-lower      279
;  :arith-assert-upper      179
;  :arith-conflicts         30
;  :arith-eq-adapter        130
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               119
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              459
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2038
;  :mk-clause               511
;  :num-allocs              4497333
;  :num-checks              230
;  :propagations            299
;  :quant-instantiations    132
;  :rlimit-count            189466)
(assert (forall ((i__12@75@02 Int)) (!
  (implies
    (and
      (<
        i__12@75@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
      (<= 0 i__12@75@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
          i__12@75@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__12@75@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
            i__12@75@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
    i__12@75@02))
  :qid |prog.l<no position>|)))
(declare-const $k@76@02 $Perm)
(assert ($Perm.isReadVar $k@76@02 $Perm.Write))
(push) ; 10
(assert (not (or (= $k@76@02 $Perm.No) (< $Perm.No $k@76@02))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      82
;  :arith-assert-lower      281
;  :arith-assert-upper      180
;  :arith-conflicts         30
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               120
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              459
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2043
;  :mk-clause               513
;  :num-allocs              4497333
;  :num-checks              231
;  :propagations            300
;  :quant-instantiations    132
;  :rlimit-count            190028)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= $k@49@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      82
;  :arith-assert-lower      281
;  :arith-assert-upper      180
;  :arith-conflicts         30
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               120
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              459
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2043
;  :mk-clause               513
;  :num-allocs              4497333
;  :num-checks              232
;  :propagations            300
;  :quant-instantiations    132
;  :rlimit-count            190039)
(assert (< $k@76@02 $k@49@02))
(assert (<= $Perm.No (- $k@49@02 $k@76@02)))
(assert (<= (- $k@49@02 $k@76@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@49@02 $k@76@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
; [eval] diz.Sensor_m.Main_sensor != null
(push) ; 10
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      82
;  :arith-assert-lower      283
;  :arith-assert-upper      181
;  :arith-conflicts         30
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               121
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              459
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2046
;  :mk-clause               513
;  :num-allocs              4497333
;  :num-checks              233
;  :propagations            300
;  :quant-instantiations    132
;  :rlimit-count            190247)
(push) ; 10
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      82
;  :arith-assert-lower      283
;  :arith-assert-upper      181
;  :arith-conflicts         30
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              459
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2046
;  :mk-clause               513
;  :num-allocs              4497333
;  :num-checks              234
;  :propagations            300
;  :quant-instantiations    132
;  :rlimit-count            190295)
(push) ; 10
(assert (not (=
  diz@2@02
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      82
;  :arith-assert-lower      283
;  :arith-assert-upper      181
;  :arith-conflicts         30
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              459
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2046
;  :mk-clause               513
;  :num-allocs              4497333
;  :num-checks              235
;  :propagations            300
;  :quant-instantiations    132
;  :rlimit-count            190306)
(push) ; 10
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      82
;  :arith-assert-lower      283
;  :arith-assert-upper      181
;  :arith-conflicts         30
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               123
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              459
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2046
;  :mk-clause               513
;  :num-allocs              4497333
;  :num-checks              236
;  :propagations            300
;  :quant-instantiations    132
;  :rlimit-count            190354)
(push) ; 10
(assert (not (=
  diz@2@02
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      82
;  :arith-assert-lower      283
;  :arith-assert-upper      181
;  :arith-conflicts         30
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               123
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              459
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2046
;  :mk-clause               513
;  :num-allocs              4497333
;  :num-checks              237
;  :propagations            300
;  :quant-instantiations    132
;  :rlimit-count            190365)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      82
;  :arith-assert-lower      283
;  :arith-assert-upper      181
;  :arith-conflicts         30
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               123
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              459
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2046
;  :mk-clause               513
;  :num-allocs              4497333
;  :num-checks              238
;  :propagations            300
;  :quant-instantiations    132
;  :rlimit-count            190378)
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4259
;  :arith-add-rows          22
;  :arith-assert-diseq      82
;  :arith-assert-lower      283
;  :arith-assert-upper      181
;  :arith-conflicts         30
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 960
;  :datatype-occurs-check   391
;  :datatype-splits         796
;  :decisions               872
;  :del-clause              459
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2046
;  :mk-clause               513
;  :num-allocs              4497333
;  :num-checks              239
;  :propagations            300
;  :quant-instantiations    132
;  :rlimit-count            190426)
(push) ; 10
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4389
;  :arith-add-rows          22
;  :arith-assert-diseq      82
;  :arith-assert-lower      283
;  :arith-assert-upper      181
;  :arith-conflicts         30
;  :arith-eq-adapter        131
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 997
;  :datatype-occurs-check   403
;  :datatype-splits         830
;  :decisions               905
;  :del-clause              459
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2079
;  :mk-clause               513
;  :num-allocs              4497333
;  :num-checks              240
;  :propagations            304
;  :quant-instantiations    132
;  :rlimit-count            191404
;  :time                    0.00)
(declare-const $k@77@02 $Perm)
(assert ($Perm.isReadVar $k@77@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@77@02 $Perm.No) (< $Perm.No $k@77@02))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4389
;  :arith-add-rows          22
;  :arith-assert-diseq      83
;  :arith-assert-lower      285
;  :arith-assert-upper      182
;  :arith-conflicts         30
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               125
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 997
;  :datatype-occurs-check   403
;  :datatype-splits         830
;  :decisions               905
;  :del-clause              459
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2083
;  :mk-clause               515
;  :num-allocs              4497333
;  :num-checks              241
;  :propagations            305
;  :quant-instantiations    132
;  :rlimit-count            191602)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= $k@50@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4389
;  :arith-add-rows          22
;  :arith-assert-diseq      83
;  :arith-assert-lower      285
;  :arith-assert-upper      182
;  :arith-conflicts         30
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         52
;  :arith-pivots            60
;  :binary-propagations     11
;  :conflicts               125
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 997
;  :datatype-occurs-check   403
;  :datatype-splits         830
;  :decisions               905
;  :del-clause              459
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2083
;  :mk-clause               515
;  :num-allocs              4497333
;  :num-checks              242
;  :propagations            305
;  :quant-instantiations    132
;  :rlimit-count            191613)
(assert (< $k@77@02 $k@50@02))
(assert (<= $Perm.No (- $k@50@02 $k@77@02)))
(assert (<= (- $k@50@02 $k@77@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@50@02 $k@77@02))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@47@02)) $Ref.null))))
; [eval] diz.Sensor_m.Main_controller != null
(push) ; 10
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4389
;  :arith-add-rows          22
;  :arith-assert-diseq      83
;  :arith-assert-lower      287
;  :arith-assert-upper      183
;  :arith-conflicts         30
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         52
;  :arith-pivots            61
;  :binary-propagations     11
;  :conflicts               126
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 997
;  :datatype-occurs-check   403
;  :datatype-splits         830
;  :decisions               905
;  :del-clause              459
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2086
;  :mk-clause               515
;  :num-allocs              4497333
;  :num-checks              243
;  :propagations            305
;  :quant-instantiations    132
;  :rlimit-count            191827)
(push) ; 10
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4389
;  :arith-add-rows          22
;  :arith-assert-diseq      83
;  :arith-assert-lower      287
;  :arith-assert-upper      183
;  :arith-conflicts         30
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         52
;  :arith-pivots            61
;  :binary-propagations     11
;  :conflicts               127
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 997
;  :datatype-occurs-check   403
;  :datatype-splits         830
;  :decisions               905
;  :del-clause              459
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2086
;  :mk-clause               515
;  :num-allocs              4497333
;  :num-checks              244
;  :propagations            305
;  :quant-instantiations    132
;  :rlimit-count            191875)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4389
;  :arith-add-rows          22
;  :arith-assert-diseq      83
;  :arith-assert-lower      287
;  :arith-assert-upper      183
;  :arith-conflicts         30
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         52
;  :arith-pivots            61
;  :binary-propagations     11
;  :conflicts               127
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 997
;  :datatype-occurs-check   403
;  :datatype-splits         830
;  :decisions               905
;  :del-clause              459
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2086
;  :mk-clause               515
;  :num-allocs              4497333
;  :num-checks              245
;  :propagations            305
;  :quant-instantiations    132
;  :rlimit-count            191888)
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@50@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4389
;  :arith-add-rows          22
;  :arith-assert-diseq      83
;  :arith-assert-lower      287
;  :arith-assert-upper      183
;  :arith-conflicts         30
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         52
;  :arith-pivots            61
;  :binary-propagations     11
;  :conflicts               128
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 997
;  :datatype-occurs-check   403
;  :datatype-splits         830
;  :decisions               905
;  :del-clause              459
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2086
;  :mk-clause               515
;  :num-allocs              4497333
;  :num-checks              246
;  :propagations            305
;  :quant-instantiations    132
;  :rlimit-count            191936)
; [eval] diz.Sensor_m.Main_sensor == diz
(push) ; 10
(assert (not (< $Perm.No $k@49@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4389
;  :arith-add-rows          22
;  :arith-assert-diseq      83
;  :arith-assert-lower      287
;  :arith-assert-upper      183
;  :arith-conflicts         30
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         52
;  :arith-pivots            61
;  :binary-propagations     11
;  :conflicts               129
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 997
;  :datatype-occurs-check   403
;  :datatype-splits         830
;  :decisions               905
;  :del-clause              459
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2086
;  :mk-clause               515
;  :num-allocs              4497333
;  :num-checks              247
;  :propagations            305
;  :quant-instantiations    132
;  :rlimit-count            191984)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4389
;  :arith-add-rows          22
;  :arith-assert-diseq      83
;  :arith-assert-lower      287
;  :arith-assert-upper      183
;  :arith-conflicts         30
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         52
;  :arith-pivots            61
;  :binary-propagations     11
;  :conflicts               129
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 997
;  :datatype-occurs-check   403
;  :datatype-splits         830
;  :decisions               905
;  :del-clause              459
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2086
;  :mk-clause               515
;  :num-allocs              4497333
;  :num-checks              248
;  :propagations            305
;  :quant-instantiations    132
;  :rlimit-count            191997)
(pop) ; 9
(push) ; 9
; [else-branch: 44 | sys__result@67@02 < 50]
(assert (< sys__result@67@02 50))
(pop) ; 9
(pop) ; 8
(push) ; 8
; [else-branch: 38 | First:(Second:(Second:(Second:($t@47@02))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@47@02))))))[0] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@47@02)))))))
        0)
      (- 0 2)))))
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(set-option :timeout 10)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@02))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4519
;  :arith-add-rows          24
;  :arith-assert-diseq      83
;  :arith-assert-lower      287
;  :arith-assert-upper      183
;  :arith-conflicts         30
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         52
;  :arith-pivots            68
;  :binary-propagations     11
;  :conflicts               130
;  :datatype-accessor-ax    246
;  :datatype-constructor-ax 1037
;  :datatype-occurs-check   415
;  :datatype-splits         871
;  :decisions               938
;  :del-clause              508
;  :final-checks            88
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2129
;  :mk-clause               516
;  :num-allocs              4497333
;  :num-checks              249
;  :propagations            311
;  :quant-instantiations    132
;  :rlimit-count            193119
;  :time                    0.00)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@02))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@02))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4649
;  :arith-add-rows          24
;  :arith-assert-diseq      83
;  :arith-assert-lower      287
;  :arith-assert-upper      183
;  :arith-conflicts         30
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         52
;  :arith-pivots            68
;  :binary-propagations     11
;  :conflicts               131
;  :datatype-accessor-ax    253
;  :datatype-constructor-ax 1077
;  :datatype-occurs-check   427
;  :datatype-splits         912
;  :decisions               971
;  :del-clause              509
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.58
;  :memory                  4.58
;  :mk-bool-var             2172
;  :mk-clause               517
;  :num-allocs              4497333
;  :num-checks              250
;  :propagations            317
;  :quant-instantiations    132
;  :rlimit-count            194128
;  :time                    0.00)
; [eval] !true
; [then-branch: 49 | False | dead]
; [else-branch: 49 | True | live]
(push) ; 5
; [else-branch: 49 | True]
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
