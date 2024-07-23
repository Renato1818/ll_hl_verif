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
; ---------- Sensor_forkOperator_EncodedGlobalVariables ----------
(declare-const diz@0@05 $Ref)
(declare-const globals@1@05 $Ref)
(declare-const diz@2@05 $Ref)
(declare-const globals@3@05 $Ref)
(push) ; 1
(declare-const $t@4@05 $Snap)
(assert (= $t@4@05 ($Snap.combine ($Snap.first $t@4@05) ($Snap.second $t@4@05))))
(assert (= ($Snap.first $t@4@05) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@2@05 $Ref.null)))
(assert (=
  ($Snap.second $t@4@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@4@05))
    ($Snap.second ($Snap.second $t@4@05)))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
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
  ($Snap.second ($Snap.second $t@4@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@4@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@4@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@4@05))) $Snap.unit))
; [eval] diz.Sensor_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@05))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@4@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05)))))))
(declare-const $k@5@05 $Perm)
(assert ($Perm.isReadVar $k@5@05 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@5@05 $Perm.No) (< $Perm.No $k@5@05))))
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
(assert (<= $Perm.No $k@5@05))
(assert (<= $k@5@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@5@05)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@05)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05)))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_sensor == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@5@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
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
;  :rlimit-count         110968
;  :time                 0.00)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@05)))))
  diz@2@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05)))))))))
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
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05)))))))
  $Snap.unit))
; [eval] !diz.Sensor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@05)))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@6@05 $Snap)
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main___contract_unsatisfiable__Main_EncodedGlobalVariables ----------
(declare-const diz@7@05 $Ref)
(declare-const globals@8@05 $Ref)
(declare-const diz@9@05 $Ref)
(declare-const globals@10@05 $Ref)
(push) ; 1
(declare-const $t@11@05 $Snap)
(assert (= $t@11@05 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@9@05 $Ref.null)))
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@12@05 $Snap)
(assert (= $t@12@05 ($Snap.combine ($Snap.first $t@12@05) ($Snap.second $t@12@05))))
(assert (= ($Snap.first $t@12@05) $Snap.unit))
(assert (= ($Snap.second $t@12@05) $Snap.unit))
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
(declare-const diz@13@05 $Ref)
(declare-const globals@14@05 $Ref)
(declare-const diz@15@05 $Ref)
(declare-const globals@16@05 $Ref)
(push) ; 1
(declare-const $t@17@05 $Snap)
(assert (= $t@17@05 ($Snap.combine ($Snap.first $t@17@05) ($Snap.second $t@17@05))))
(assert (= ($Snap.first $t@17@05) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@15@05 $Ref.null)))
(assert (=
  ($Snap.second $t@17@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@17@05))
    ($Snap.second ($Snap.second $t@17@05)))))
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
; (:added-eqs               80
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               3
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             288
;  :mk-clause               5
;  :num-allocs              3404559
;  :num-checks              11
;  :propagations            13
;  :quant-instantiations    5
;  :rlimit-count            113891)
(assert (<= $Perm.No $k@18@05))
(assert (<= $k@18@05 $Perm.Write))
(assert (implies (< $Perm.No $k@18@05) (not (= diz@15@05 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@17@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@17@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@17@05))) $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@18@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               86
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             291
;  :mk-clause               5
;  :num-allocs              3404559
;  :num-checks              12
;  :propagations            13
;  :quant-instantiations    5
;  :rlimit-count            114144)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@05))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@17@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               92
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             294
;  :mk-clause               5
;  :num-allocs              3404559
;  :num-checks              13
;  :propagations            13
;  :quant-instantiations    6
;  :rlimit-count            114428)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               92
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             294
;  :mk-clause               5
;  :num-allocs              3404559
;  :num-checks              14
;  :propagations            13
;  :quant-instantiations    6
;  :rlimit-count            114441)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))
  $Snap.unit))
; [eval] diz.Main_sensor.Sensor_m == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@18@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               98
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               6
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             296
;  :mk-clause               5
;  :num-allocs              3404559
;  :num-checks              15
;  :propagations            13
;  :quant-instantiations    6
;  :rlimit-count            114660)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))
  diz@15@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               105
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             299
;  :mk-clause               5
;  :num-allocs              3404559
;  :num-checks              16
;  :propagations            13
;  :quant-instantiations    7
;  :rlimit-count            114946)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               105
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             299
;  :mk-clause               5
;  :num-allocs              3404559
;  :num-checks              17
;  :propagations            13
;  :quant-instantiations    7
;  :rlimit-count            114959)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))
  $Snap.unit))
; [eval] !diz.Main_sensor.Sensor_init
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@18@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               111
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               8
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             301
;  :mk-clause               5
;  :num-allocs              3404559
;  :num-checks              18
;  :propagations            13
;  :quant-instantiations    7
;  :rlimit-count            115198)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))
(declare-const $k@19@05 $Perm)
(assert ($Perm.isReadVar $k@19@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@19@05 $Perm.No) (< $Perm.No $k@19@05))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               120
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      6
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               9
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             309
;  :mk-clause               7
;  :num-allocs              3404559
;  :num-checks              19
;  :propagations            14
;  :quant-instantiations    9
;  :rlimit-count            115666)
(assert (<= $Perm.No $k@19@05))
(assert (<= $k@19@05 $Perm.Write))
(assert (implies (< $Perm.No $k@19@05) (not (= diz@15@05 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@19@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               126
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               10
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             312
;  :mk-clause               7
;  :num-allocs              3404559
;  :num-checks              20
;  :propagations            14
;  :quant-instantiations    9
;  :rlimit-count            115979)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@19@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               132
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               11
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             315
;  :mk-clause               7
;  :num-allocs              3404559
;  :num-checks              21
;  :propagations            14
;  :quant-instantiations    10
;  :rlimit-count            116323)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               132
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               11
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             315
;  :mk-clause               7
;  :num-allocs              3404559
;  :num-checks              22
;  :propagations            14
;  :quant-instantiations    10
;  :rlimit-count            116336)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))
  $Snap.unit))
; [eval] diz.Main_controller.Controller_m == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@19@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               138
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               12
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             317
;  :mk-clause               7
;  :num-allocs              3404559
;  :num-checks              23
;  :propagations            14
;  :quant-instantiations    10
;  :rlimit-count            116615)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))
  diz@15@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@19@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               146
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               13
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             320
;  :mk-clause               7
;  :num-allocs              3404559
;  :num-checks              24
;  :propagations            14
;  :quant-instantiations    11
;  :rlimit-count            116960)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               146
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               13
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             320
;  :mk-clause               7
;  :num-allocs              3404559
;  :num-checks              25
;  :propagations            14
;  :quant-instantiations    11
;  :rlimit-count            116973)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))))
  $Snap.unit))
; [eval] !diz.Main_controller.Controller_init
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@19@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               152
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               14
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             322
;  :mk-clause               7
;  :num-allocs              3526126
;  :num-checks              26
;  :propagations            14
;  :quant-instantiations    11
;  :rlimit-count            117272)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               160
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               15
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             325
;  :mk-clause               7
;  :num-allocs              3526126
;  :num-checks              27
;  :propagations            14
;  :quant-instantiations    12
;  :rlimit-count            117638)
(push) ; 2
(assert (not (< $Perm.No $k@19@05)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               160
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               16
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             325
;  :mk-clause               7
;  :num-allocs              3526126
;  :num-checks              28
;  :propagations            14
;  :quant-instantiations    12
;  :rlimit-count            117686)
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
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               181
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      8
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               17
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             336
;  :mk-clause               9
;  :num-allocs              3526126
;  :num-checks              30
;  :propagations            15
;  :quant-instantiations    12
;  :rlimit-count            118352)
(assert (<= $Perm.No $k@21@05))
(assert (<= $k@21@05 $Perm.Write))
(assert (implies (< $Perm.No $k@21@05) (not (= diz@15@05 $Ref.null))))
(assert (=
  ($Snap.second $t@20@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@20@05))
    ($Snap.second ($Snap.second $t@20@05)))))
(assert (= ($Snap.first ($Snap.second $t@20@05)) $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               187
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               18
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             339
;  :mk-clause               9
;  :num-allocs              3526126
;  :num-checks              31
;  :propagations            15
;  :quant-instantiations    12
;  :rlimit-count            118595)
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
; (:added-eqs               193
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               19
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             342
;  :mk-clause               9
;  :num-allocs              3526126
;  :num-checks              32
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            118867)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
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
;  :binary-propagations     11
;  :conflicts               19
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             342
;  :mk-clause               9
;  :num-allocs              3526126
;  :num-checks              33
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            118880)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@20@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@05))))
  $Snap.unit))
; [eval] diz.Main_sensor.Sensor_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               199
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               20
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             344
;  :mk-clause               9
;  :num-allocs              3526126
;  :num-checks              34
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            119089
;  :time                    0.00)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@20@05))))
  diz@15@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
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
;  :binary-propagations     11
;  :conflicts               21
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             347
;  :mk-clause               9
;  :num-allocs              3526126
;  :num-checks              35
;  :propagations            15
;  :quant-instantiations    14
;  :rlimit-count            119364)
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
;  :binary-propagations     11
;  :conflicts               21
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             347
;  :mk-clause               9
;  :num-allocs              3526126
;  :num-checks              36
;  :propagations            15
;  :quant-instantiations    14
;  :rlimit-count            119377)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))
  $Snap.unit))
; [eval] !diz.Main_sensor.Sensor_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@21@05)))
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
;  :binary-propagations     11
;  :conflicts               22
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             349
;  :mk-clause               9
;  :num-allocs              3526126
;  :num-checks              37
;  :propagations            15
;  :quant-instantiations    14
;  :rlimit-count            119606)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))
(declare-const $k@22@05 $Perm)
(assert ($Perm.isReadVar $k@22@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@22@05 $Perm.No) (< $Perm.No $k@22@05))))
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
;  :binary-propagations     11
;  :conflicts               23
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             356
;  :mk-clause               11
;  :num-allocs              3526126
;  :num-checks              38
;  :propagations            16
;  :quant-instantiations    15
;  :rlimit-count            120046)
(assert (<= $Perm.No $k@22@05))
(assert (<= $k@22@05 $Perm.Write))
(assert (implies (< $Perm.No $k@22@05) (not (= diz@15@05 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@22@05)))
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
;  :binary-propagations     11
;  :conflicts               24
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             359
;  :mk-clause               11
;  :num-allocs              3526126
;  :num-checks              39
;  :propagations            16
;  :quant-instantiations    15
;  :rlimit-count            120349)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@22@05)))
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
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             362
;  :mk-clause               11
;  :num-allocs              3526126
;  :num-checks              40
;  :propagations            16
;  :quant-instantiations    16
;  :rlimit-count            120683)
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
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             362
;  :mk-clause               11
;  :num-allocs              3526126
;  :num-checks              41
;  :propagations            16
;  :quant-instantiations    16
;  :rlimit-count            120696)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))
  $Snap.unit))
; [eval] diz.Main_controller.Controller_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@22@05)))
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
;  :binary-propagations     11
;  :conflicts               26
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             364
;  :mk-clause               11
;  :num-allocs              3526126
;  :num-checks              42
;  :propagations            16
;  :quant-instantiations    16
;  :rlimit-count            120965)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))
  diz@15@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@22@05)))
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
;  :binary-propagations     11
;  :conflicts               27
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             367
;  :mk-clause               11
;  :num-allocs              3526126
;  :num-checks              43
;  :propagations            16
;  :quant-instantiations    17
;  :rlimit-count            121300)
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
;  :binary-propagations     11
;  :conflicts               27
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             367
;  :mk-clause               11
;  :num-allocs              3526126
;  :num-checks              44
;  :propagations            16
;  :quant-instantiations    17
;  :rlimit-count            121313)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))
  $Snap.unit))
; [eval] !diz.Main_controller.Controller_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@22@05)))
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
;  :binary-propagations     11
;  :conflicts               28
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             369
;  :mk-clause               11
;  :num-allocs              3526126
;  :num-checks              45
;  :propagations            16
;  :quant-instantiations    17
;  :rlimit-count            121602)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@05))))))))))))))
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
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               261
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     11
;  :conflicts               29
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             372
;  :mk-clause               11
;  :num-allocs              3526126
;  :num-checks              46
;  :propagations            16
;  :quant-instantiations    18
;  :rlimit-count            121958)
(push) ; 3
(assert (not (< $Perm.No $k@22@05)))
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
;  :binary-propagations     11
;  :conflicts               30
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   13
;  :datatype-splits         10
;  :decisions               10
;  :del-clause              6
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             372
;  :mk-clause               11
;  :num-allocs              3526126
;  :num-checks              47
;  :propagations            16
;  :quant-instantiations    18
;  :rlimit-count            122006)
(pop) ; 2
(push) ; 2
; [exec]
; var min_advance__31: Int
(declare-const min_advance__31@23@05 Int)
; [exec]
; var __flatten_30__29: Seq[Int]
(declare-const __flatten_30__29@24@05 Seq<Int>)
; [exec]
; var __flatten_31__30: Seq[Int]
(declare-const __flatten_31__30@25@05 Seq<Int>)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@26@05 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(assert (= $t@26@05 ($Snap.combine ($Snap.first $t@26@05) ($Snap.second $t@26@05))))
(assert (= ($Snap.first $t@26@05) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@26@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@26@05))
    ($Snap.second ($Snap.second $t@26@05)))))
(assert (= ($Snap.first ($Snap.second $t@26@05)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@26@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@26@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@26@05))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@26@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@27@05 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@27@05 | live]
; [else-branch: 0 | !(0 <= i@27@05) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@27@05]
(assert (<= 0 i@27@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@27@05)]
(assert (not (<= 0 i@27@05)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@27@05 < |First:(Second:(Second:(Second:($t@26@05))))| && 0 <= i@27@05 | live]
; [else-branch: 1 | !(i@27@05 < |First:(Second:(Second:(Second:($t@26@05))))| && 0 <= i@27@05) | live]
(push) ; 5
; [then-branch: 1 | i@27@05 < |First:(Second:(Second:(Second:($t@26@05))))| && 0 <= i@27@05]
(assert (and
  (<
    i@27@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
  (<= 0 i@27@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@27@05 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               327
;  :arith-assert-diseq      7
;  :arith-assert-lower      18
;  :arith-assert-upper      14
;  :arith-eq-adapter        10
;  :binary-propagations     11
;  :conflicts               30
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              10
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             404
;  :mk-clause               17
;  :num-allocs              3526126
;  :num-checks              49
;  :propagations            18
;  :quant-instantiations    24
;  :rlimit-count            123720)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:($t@26@05))))[i@27@05] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:($t@26@05))))[i@27@05] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:($t@26@05))))[i@27@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
    i@27@05)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:($t@26@05))))[i@27@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
      i@27@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@27@05 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               327
;  :arith-assert-diseq      7
;  :arith-assert-lower      18
;  :arith-assert-upper      14
;  :arith-eq-adapter        10
;  :binary-propagations     11
;  :conflicts               30
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              10
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             405
;  :mk-clause               17
;  :num-allocs              3526126
;  :num-checks              50
;  :propagations            18
;  :quant-instantiations    24
;  :rlimit-count            123895)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@26@05))))[i@27@05] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@26@05))))[i@27@05]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@26@05))))[i@27@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
    i@27@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@27@05 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               327
;  :arith-assert-diseq      8
;  :arith-assert-lower      21
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :binary-propagations     11
;  :conflicts               30
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              10
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             408
;  :mk-clause               18
;  :num-allocs              3652752
;  :num-checks              51
;  :propagations            18
;  :quant-instantiations    24
;  :rlimit-count            124018)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@26@05))))[i@27@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
      i@27@05))))
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
; [else-branch: 1 | !(i@27@05 < |First:(Second:(Second:(Second:($t@26@05))))| && 0 <= i@27@05)]
(assert (not
  (and
    (<
      i@27@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
    (<= 0 i@27@05))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@27@05 Int)) (!
  (implies
    (and
      (<
        i@27@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
      (<= 0 i@27@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
          i@27@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
            i@27@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
            i@27@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
    i@27@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))
(declare-const $k@28@05 $Perm)
(assert ($Perm.isReadVar $k@28@05 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@28@05 $Perm.No) (< $Perm.No $k@28@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               332
;  :arith-assert-diseq      9
;  :arith-assert-lower      23
;  :arith-assert-upper      15
;  :arith-eq-adapter        12
;  :binary-propagations     11
;  :conflicts               31
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             414
;  :mk-clause               20
;  :num-allocs              3652752
;  :num-checks              52
;  :propagations            19
;  :quant-instantiations    24
;  :rlimit-count            124787)
(declare-const $t@29@05 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@18@05)
    (=
      $t@29@05
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@05)))))
  (implies
    (< $Perm.No $k@28@05)
    (=
      $t@29@05
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))))
(assert (<= $Perm.No (+ $k@18@05 $k@28@05)))
(assert (<= (+ $k@18@05 $k@28@05) $Perm.Write))
(assert (implies (< $Perm.No (+ $k@18@05 $k@28@05)) (not (= diz@15@05 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))
  $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@18@05 $k@28@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               342
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      17
;  :arith-conflicts         1
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :binary-propagations     11
;  :conflicts               32
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             422
;  :mk-clause               20
;  :num-allocs              3652752
;  :num-checks              53
;  :propagations            19
;  :quant-instantiations    25
;  :rlimit-count            125386)
(assert (not (= $t@29@05 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@18@05 $k@28@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               348
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      18
;  :arith-conflicts         2
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         2
;  :binary-propagations     11
;  :conflicts               33
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             425
;  :mk-clause               20
;  :num-allocs              3652752
;  :num-checks              54
;  :propagations            19
;  :quant-instantiations    25
;  :rlimit-count            125690)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@18@05 $k@28@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               353
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      19
;  :arith-conflicts         3
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         3
;  :binary-propagations     11
;  :conflicts               34
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             427
;  :mk-clause               20
;  :num-allocs              3652752
;  :num-checks              55
;  :propagations            19
;  :quant-instantiations    25
;  :rlimit-count            125959)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@18@05 $k@28@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               358
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      20
;  :arith-conflicts         4
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         4
;  :binary-propagations     11
;  :conflicts               35
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             429
;  :mk-clause               20
;  :num-allocs              3652752
;  :num-checks              56
;  :propagations            19
;  :quant-instantiations    25
;  :rlimit-count            126238)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               358
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      20
;  :arith-conflicts         4
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         4
;  :binary-propagations     11
;  :conflicts               35
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             429
;  :mk-clause               20
;  :num-allocs              3652752
;  :num-checks              57
;  :propagations            19
;  :quant-instantiations    25
;  :rlimit-count            126251)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@05))) $t@29@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               358
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      20
;  :arith-conflicts         4
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         4
;  :binary-propagations     11
;  :conflicts               36
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             430
;  :mk-clause               20
;  :num-allocs              3652752
;  :num-checks              58
;  :propagations            19
;  :quant-instantiations    25
;  :rlimit-count            126341
;  :time                    0.00)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))))))))
(declare-const $k@30@05 $Perm)
(assert ($Perm.isReadVar $k@30@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@30@05 $Perm.No) (< $Perm.No $k@30@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-assert-diseq      10
;  :arith-assert-lower      26
;  :arith-assert-upper      21
;  :arith-conflicts         4
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         4
;  :binary-propagations     11
;  :conflicts               37
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             437
;  :mk-clause               22
;  :num-allocs              3652752
;  :num-checks              59
;  :propagations            20
;  :quant-instantiations    26
;  :rlimit-count            126855)
(declare-const $t@31@05 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@19@05)
    (=
      $t@31@05
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))
  (implies
    (< $Perm.No $k@30@05)
    (=
      $t@31@05
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))))))))))
(assert (<= $Perm.No (+ $k@19@05 $k@30@05)))
(assert (<= (+ $k@19@05 $k@30@05) $Perm.Write))
(assert (implies (< $Perm.No (+ $k@19@05 $k@30@05)) (not (= diz@15@05 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@19@05 $k@30@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               376
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      23
;  :arith-conflicts         5
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         5
;  :binary-propagations     11
;  :conflicts               38
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             445
;  :mk-clause               22
;  :num-allocs              3652752
;  :num-checks              60
;  :propagations            20
;  :quant-instantiations    27
;  :rlimit-count            127560)
(assert (not (= $t@31@05 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@19@05 $k@30@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               382
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      24
;  :arith-conflicts         6
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         6
;  :binary-propagations     11
;  :conflicts               39
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             448
;  :mk-clause               22
;  :num-allocs              3652752
;  :num-checks              61
;  :propagations            20
;  :quant-instantiations    27
;  :rlimit-count            127914)
(push) ; 3
(assert (not (< $Perm.No (+ $k@19@05 $k@30@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               382
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      25
;  :arith-conflicts         7
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         7
;  :binary-propagations     11
;  :conflicts               40
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             449
;  :mk-clause               22
;  :num-allocs              3652752
;  :num-checks              62
;  :propagations            20
;  :quant-instantiations    27
;  :rlimit-count            127974)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               382
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      25
;  :arith-conflicts         7
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         7
;  :binary-propagations     11
;  :conflicts               40
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             449
;  :mk-clause               22
;  :num-allocs              3652752
;  :num-checks              63
;  :propagations            20
;  :quant-instantiations    27
;  :rlimit-count            127987)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
  $t@31@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               382
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      25
;  :arith-conflicts         7
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         7
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               16
;  :del-clause              11
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             450
;  :mk-clause               22
;  :num-allocs              3652752
;  :num-checks              64
;  :propagations            20
;  :quant-instantiations    27
;  :rlimit-count            128137)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))))))))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@26@05 diz@15@05 globals@16@05))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@32@05 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; Sensor_forkOperator_EncodedGlobalVariables(diz.Main_sensor, globals)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@18@05 $k@28@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      26
;  :arith-conflicts         8
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         8
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              21
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             470
;  :mk-clause               23
;  :num-allocs              3652752
;  :num-checks              67
;  :propagations            21
;  :quant-instantiations    28
;  :rlimit-count            129554)
; [eval] diz != null
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      26
;  :arith-conflicts         8
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         8
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              21
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             470
;  :mk-clause               23
;  :num-allocs              3652752
;  :num-checks              68
;  :propagations            21
;  :quant-instantiations    28
;  :rlimit-count            129567)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@05))) $t@29@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      26
;  :arith-conflicts         8
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         8
;  :binary-propagations     11
;  :conflicts               44
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              21
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             471
;  :mk-clause               23
;  :num-allocs              3652752
;  :num-checks              69
;  :propagations            21
;  :quant-instantiations    28
;  :rlimit-count            129657)
; [eval] diz.Sensor_m != null
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@05))) $t@29@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      26
;  :arith-conflicts         8
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         8
;  :binary-propagations     11
;  :conflicts               45
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              21
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             472
;  :mk-clause               23
;  :num-allocs              3652752
;  :num-checks              70
;  :propagations            21
;  :quant-instantiations    28
;  :rlimit-count            129747)
(set-option :timeout 0)
(push) ; 3
(assert (not (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))
    $Ref.null))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      26
;  :arith-conflicts         8
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         8
;  :binary-propagations     11
;  :conflicts               45
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              21
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             472
;  :mk-clause               23
;  :num-allocs              3652752
;  :num-checks              71
;  :propagations            21
;  :quant-instantiations    28
;  :rlimit-count            129765)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))
    $Ref.null)))
(declare-const $k@33@05 $Perm)
(assert ($Perm.isReadVar $k@33@05 $Perm.Write))
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@05))) $t@29@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      27
;  :arith-conflicts         8
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         8
;  :binary-propagations     11
;  :conflicts               46
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              21
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             477
;  :mk-clause               25
;  :num-allocs              3652752
;  :num-checks              72
;  :propagations            22
;  :quant-instantiations    28
;  :rlimit-count            130030)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@33@05 $Perm.No) (< $Perm.No $k@33@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      27
;  :arith-conflicts         8
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         8
;  :binary-propagations     11
;  :conflicts               47
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              21
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             477
;  :mk-clause               25
;  :num-allocs              3652752
;  :num-checks              73
;  :propagations            22
;  :quant-instantiations    28
;  :rlimit-count            130080)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@15@05
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      27
;  :arith-conflicts         8
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         8
;  :binary-propagations     11
;  :conflicts               47
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              21
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             477
;  :mk-clause               25
;  :num-allocs              3652752
;  :num-checks              74
;  :propagations            22
;  :quant-instantiations    28
;  :rlimit-count            130091)
(push) ; 3
(assert (not (not (= (+ $k@18@05 $k@28@05) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               478
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      28
;  :arith-conflicts         9
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         8
;  :binary-propagations     11
;  :conflicts               48
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              23
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             479
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              75
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            130151)
(assert (< $k@33@05 (+ $k@18@05 $k@28@05)))
(assert (<= $Perm.No (- (+ $k@18@05 $k@28@05) $k@33@05)))
(assert (<= (- (+ $k@18@05 $k@28@05) $k@33@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@18@05 $k@28@05) $k@33@05))
  (not (= diz@15@05 $Ref.null))))
; [eval] diz.Sensor_m.Main_sensor == diz
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@05))) $t@29@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               478
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      29
;  :arith-conflicts         9
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         8
;  :binary-propagations     11
;  :conflicts               49
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              23
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             483
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              76
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            130409)
(push) ; 3
(assert (not (=
  diz@15@05
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               478
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      29
;  :arith-conflicts         9
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         8
;  :binary-propagations     11
;  :conflicts               49
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              23
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             483
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              77
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            130420)
(push) ; 3
(assert (not (< $Perm.No (+ $k@18@05 $k@28@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               478
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      30
;  :arith-conflicts         10
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :binary-propagations     11
;  :conflicts               50
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              23
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             484
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              78
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            130480)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               478
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      30
;  :arith-conflicts         10
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :binary-propagations     11
;  :conflicts               50
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              23
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             484
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              79
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            130493)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@05))) $t@29@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               478
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      30
;  :arith-conflicts         10
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   26
;  :datatype-splits         24
;  :decisions               41
;  :del-clause              23
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             485
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              80
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            130583)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               522
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      30
;  :arith-conflicts         10
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 56
;  :datatype-occurs-check   32
;  :datatype-splits         31
;  :decisions               53
;  :del-clause              23
;  :final-checks            19
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             491
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              81
;  :propagations            24
;  :quant-instantiations    28
;  :rlimit-count            131132
;  :time                    0.00)
; [eval] !diz.Sensor_init
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@05))) $t@29@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               522
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      30
;  :arith-conflicts         10
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :binary-propagations     11
;  :conflicts               52
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 56
;  :datatype-occurs-check   32
;  :datatype-splits         31
;  :decisions               53
;  :del-clause              23
;  :final-checks            19
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             492
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              82
;  :propagations            24
;  :quant-instantiations    28
;  :rlimit-count            131222)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@05))) $t@29@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               522
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      30
;  :arith-conflicts         10
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 56
;  :datatype-occurs-check   32
;  :datatype-splits         31
;  :decisions               53
;  :del-clause              23
;  :final-checks            19
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             493
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              83
;  :propagations            24
;  :quant-instantiations    28
;  :rlimit-count            131312)
(declare-const $t@34@05 $Snap)
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; Controller_forkOperator_EncodedGlobalVariables(diz.Main_controller, globals)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@19@05 $k@30@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      31
;  :arith-conflicts         11
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :binary-propagations     11
;  :conflicts               54
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              25
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             500
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              85
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            131905)
; [eval] diz != null
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      31
;  :arith-conflicts         11
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :binary-propagations     11
;  :conflicts               54
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              25
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             500
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              86
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            131918)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
  $t@31@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      31
;  :arith-conflicts         11
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :binary-propagations     11
;  :conflicts               55
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              25
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             501
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              87
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            132068)
; [eval] diz.Controller_m != null
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
  $t@31@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      31
;  :arith-conflicts         11
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :binary-propagations     11
;  :conflicts               56
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              25
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             502
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              88
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            132218)
(set-option :timeout 0)
(push) ; 3
(assert (not (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))
    $Ref.null))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      31
;  :arith-conflicts         11
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :binary-propagations     11
;  :conflicts               56
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              25
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             502
;  :mk-clause               27
;  :num-allocs              3652752
;  :num-checks              89
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            132236)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))
    $Ref.null)))
(declare-const $k@35@05 $Perm)
(assert ($Perm.isReadVar $k@35@05 $Perm.Write))
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
  $t@31@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      32
;  :arith-conflicts         11
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         10
;  :binary-propagations     11
;  :conflicts               57
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              25
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             507
;  :mk-clause               29
;  :num-allocs              3652752
;  :num-checks              90
;  :propagations            26
;  :quant-instantiations    28
;  :rlimit-count            132560)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@35@05 $Perm.No) (< $Perm.No $k@35@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      32
;  :arith-conflicts         11
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         10
;  :binary-propagations     11
;  :conflicts               58
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              25
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             507
;  :mk-clause               29
;  :num-allocs              3652752
;  :num-checks              91
;  :propagations            26
;  :quant-instantiations    28
;  :rlimit-count            132610)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@15@05
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      32
;  :arith-conflicts         11
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         10
;  :binary-propagations     11
;  :conflicts               58
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              25
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             507
;  :mk-clause               29
;  :num-allocs              3652752
;  :num-checks              92
;  :propagations            26
;  :quant-instantiations    28
;  :rlimit-count            132621)
(push) ; 3
(assert (not (not (= (+ $k@19@05 $k@30@05) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               567
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      33
;  :arith-conflicts         12
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         10
;  :binary-propagations     11
;  :conflicts               59
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              27
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             509
;  :mk-clause               31
;  :num-allocs              3652752
;  :num-checks              93
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            132681)
(assert (< $k@35@05 (+ $k@19@05 $k@30@05)))
(assert (<= $Perm.No (- (+ $k@19@05 $k@30@05) $k@35@05)))
(assert (<= (- (+ $k@19@05 $k@30@05) $k@35@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@19@05 $k@30@05) $k@35@05))
  (not (= diz@15@05 $Ref.null))))
; [eval] diz.Controller_m.Main_controller == diz
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
  $t@31@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               567
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      34
;  :arith-conflicts         12
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               60
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              27
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             513
;  :mk-clause               31
;  :num-allocs              3652752
;  :num-checks              94
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            133006)
(push) ; 3
(assert (not (=
  diz@15@05
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               567
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      34
;  :arith-conflicts         12
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               60
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              27
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             513
;  :mk-clause               31
;  :num-allocs              3652752
;  :num-checks              95
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            133017
;  :time                    0.00)
(push) ; 3
(assert (not (< $Perm.No (+ $k@19@05 $k@30@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               567
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      35
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               61
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              27
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             514
;  :mk-clause               31
;  :num-allocs              3652752
;  :num-checks              96
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            133077)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               567
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      35
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               61
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              27
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             514
;  :mk-clause               31
;  :num-allocs              3652752
;  :num-checks              97
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            133090)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
  $t@31@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               567
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      35
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               62
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   38
;  :datatype-splits         38
;  :decisions               65
;  :del-clause              27
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             515
;  :mk-clause               31
;  :num-allocs              3652752
;  :num-checks              98
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            133240)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               611
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      35
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               62
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 82
;  :datatype-occurs-check   44
;  :datatype-splits         45
;  :decisions               77
;  :del-clause              27
;  :final-checks            25
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             521
;  :mk-clause               31
;  :num-allocs              3652752
;  :num-checks              99
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            133795)
; [eval] !diz.Controller_init
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
  $t@31@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               611
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      35
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               63
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 82
;  :datatype-occurs-check   44
;  :datatype-splits         45
;  :decisions               77
;  :del-clause              27
;  :final-checks            25
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             522
;  :mk-clause               31
;  :num-allocs              3652752
;  :num-checks              100
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            133945)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
  $t@31@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               611
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      35
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               64
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 82
;  :datatype-occurs-check   44
;  :datatype-splits         45
;  :decisions               77
;  :del-clause              27
;  :final-checks            25
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             523
;  :mk-clause               31
;  :num-allocs              3652752
;  :num-checks              101
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            134095)
(declare-const $t@36@05 $Snap)
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@37@05 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@37@05 | live]
; [else-branch: 4 | !(0 <= i@37@05) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@37@05]
(assert (<= 0 i@37@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@37@05)]
(assert (not (<= 0 i@37@05)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@37@05 < |First:(Second:(Second:(Second:($t@26@05))))| && 0 <= i@37@05 | live]
; [else-branch: 5 | !(i@37@05 < |First:(Second:(Second:(Second:($t@26@05))))| && 0 <= i@37@05) | live]
(push) ; 5
; [then-branch: 5 | i@37@05 < |First:(Second:(Second:(Second:($t@26@05))))| && 0 <= i@37@05]
(assert (and
  (<
    i@37@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
  (<= 0 i@37@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@37@05 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      36
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               64
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              29
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             531
;  :mk-clause               31
;  :num-allocs              3652752
;  :num-checks              103
;  :propagations            29
;  :quant-instantiations    28
;  :rlimit-count            134770)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:($t@26@05))))[i@37@05] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@26@05))))[i@37@05] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@26@05))))[i@37@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
    i@37@05)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:($t@26@05))))[i@37@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
      i@37@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@37@05 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      37
;  :arith-conflicts         13
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               64
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              29
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             537
;  :mk-clause               35
;  :num-allocs              3652752
;  :num-checks              104
;  :propagations            31
;  :quant-instantiations    29
;  :rlimit-count            135002)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@26@05))))[i@37@05] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@26@05))))[i@37@05]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@26@05))))[i@37@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
    i@37@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@37@05 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      37
;  :arith-conflicts         13
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               64
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              29
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             537
;  :mk-clause               35
;  :num-allocs              3652752
;  :num-checks              105
;  :propagations            31
;  :quant-instantiations    29
;  :rlimit-count            135116)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@26@05))))[i@37@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
      i@37@05))))
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
; [else-branch: 5 | !(i@37@05 < |First:(Second:(Second:(Second:($t@26@05))))| && 0 <= i@37@05)]
(assert (not
  (and
    (<
      i@37@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
    (<= 0 i@37@05))))
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
(assert (not (forall ((i@37@05 Int)) (!
  (implies
    (and
      (<
        i@37@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
      (<= 0 i@37@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
          i@37@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
            i@37@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
            i@37@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
    i@37@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-assert-diseq      15
;  :arith-assert-lower      40
;  :arith-assert-upper      38
;  :arith-conflicts         13
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             545
;  :mk-clause               49
;  :num-allocs              3652752
;  :num-checks              106
;  :propagations            33
;  :quant-instantiations    30
;  :rlimit-count            135562)
(assert (forall ((i@37@05 Int)) (!
  (implies
    (and
      (<
        i@37@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
      (<= 0 i@37@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
          i@37@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
            i@37@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
            i@37@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
    i@37@05))
  :qid |prog.l<no position>|)))
(declare-const $k@38@05 $Perm)
(assert ($Perm.isReadVar $k@38@05 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@38@05 $Perm.No) (< $Perm.No $k@38@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-assert-diseq      16
;  :arith-assert-lower      42
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               66
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             550
;  :mk-clause               51
;  :num-allocs              3652752
;  :num-checks              107
;  :propagations            34
;  :quant-instantiations    30
;  :rlimit-count            136123)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- (+ $k@18@05 $k@28@05) $k@33@05) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-assert-diseq      16
;  :arith-assert-lower      42
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         11
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               67
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             551
;  :mk-clause               51
;  :num-allocs              3652752
;  :num-checks              108
;  :propagations            34
;  :quant-instantiations    30
;  :rlimit-count            136197)
(assert (< $k@38@05 (- (+ $k@18@05 $k@28@05) $k@33@05)))
(assert (<= $Perm.No (- (- (+ $k@18@05 $k@28@05) $k@33@05) $k@38@05)))
(assert (<= (- (- (+ $k@18@05 $k@28@05) $k@33@05) $k@38@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- (+ $k@18@05 $k@28@05) $k@33@05) $k@38@05))
  (not (= diz@15@05 $Ref.null))))
; [eval] diz.Main_sensor != null
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@18@05 $k@28@05) $k@33@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               67
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             554
;  :mk-clause               51
;  :num-allocs              3652752
;  :num-checks              109
;  :propagations            34
;  :quant-instantiations    30
;  :rlimit-count            136452)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@18@05 $k@28@05) $k@33@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               67
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             554
;  :mk-clause               51
;  :num-allocs              3652752
;  :num-checks              110
;  :propagations            34
;  :quant-instantiations    30
;  :rlimit-count            136473)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@18@05 $k@28@05) $k@33@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               67
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             554
;  :mk-clause               51
;  :num-allocs              3652752
;  :num-checks              111
;  :propagations            34
;  :quant-instantiations    30
;  :rlimit-count            136494)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               67
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             554
;  :mk-clause               51
;  :num-allocs              3652752
;  :num-checks              112
;  :propagations            34
;  :quant-instantiations    30
;  :rlimit-count            136507)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@18@05 $k@28@05) $k@33@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               67
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             554
;  :mk-clause               51
;  :num-allocs              3652752
;  :num-checks              113
;  :propagations            34
;  :quant-instantiations    30
;  :rlimit-count            136528)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@05))) $t@29@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               68
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             555
;  :mk-clause               51
;  :num-allocs              3652752
;  :num-checks              114
;  :propagations            34
;  :quant-instantiations    30
;  :rlimit-count            136618)
(declare-const $k@39@05 $Perm)
(assert ($Perm.isReadVar $k@39@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@39@05 $Perm.No) (< $Perm.No $k@39@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          2
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      41
;  :arith-conflicts         13
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               69
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             559
;  :mk-clause               53
;  :num-allocs              3652752
;  :num-checks              115
;  :propagations            35
;  :quant-instantiations    30
;  :rlimit-count            136816)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- (+ $k@19@05 $k@30@05) $k@35@05) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          2
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      41
;  :arith-conflicts         13
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               70
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             560
;  :mk-clause               53
;  :num-allocs              3652752
;  :num-checks              116
;  :propagations            35
;  :quant-instantiations    30
;  :rlimit-count            136890)
(assert (< $k@39@05 (- (+ $k@19@05 $k@30@05) $k@35@05)))
(assert (<= $Perm.No (- (- (+ $k@19@05 $k@30@05) $k@35@05) $k@39@05)))
(assert (<= (- (- (+ $k@19@05 $k@30@05) $k@35@05) $k@39@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- (+ $k@19@05 $k@30@05) $k@35@05) $k@39@05))
  (not (= diz@15@05 $Ref.null))))
; [eval] diz.Main_controller != null
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@19@05 $k@30@05) $k@35@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          5
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      42
;  :arith-conflicts         13
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               70
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             563
;  :mk-clause               53
;  :num-allocs              3652752
;  :num-checks              117
;  :propagations            35
;  :quant-instantiations    30
;  :rlimit-count            137158)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@19@05 $k@30@05) $k@35@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          5
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      42
;  :arith-conflicts         13
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               70
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             563
;  :mk-clause               53
;  :num-allocs              3652752
;  :num-checks              118
;  :propagations            35
;  :quant-instantiations    30
;  :rlimit-count            137179)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          5
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      42
;  :arith-conflicts         13
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               70
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             563
;  :mk-clause               53
;  :num-allocs              3652752
;  :num-checks              119
;  :propagations            35
;  :quant-instantiations    30
;  :rlimit-count            137192)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@19@05 $k@30@05) $k@35@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          5
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      42
;  :arith-conflicts         13
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               70
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             563
;  :mk-clause               53
;  :num-allocs              3652752
;  :num-checks              120
;  :propagations            35
;  :quant-instantiations    30
;  :rlimit-count            137213)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))
  $t@31@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               655
;  :arith-add-rows          5
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      42
;  :arith-conflicts         13
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   50
;  :datatype-splits         52
;  :decisions               89
;  :del-clause              47
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             564
;  :mk-clause               53
;  :num-allocs              3652752
;  :num-checks              121
;  :propagations            35
;  :quant-instantiations    30
;  :rlimit-count            137363)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($SortWrappers.$RefTo$Snap $t@29@05)
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05))))))
                          ($Snap.combine
                            ($SortWrappers.$RefTo$Snap $t@31@05)
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))))))))))
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@05)))))))))))))))))))))))))))) diz@15@05 globals@16@05))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const min_advance__31@40@05 Int)
(declare-const __flatten_31__30@41@05 Seq<Int>)
(declare-const __flatten_30__29@42@05 Seq<Int>)
(push) ; 3
; Loop head block: Check well-definedness of invariant
; Loop head block: Check well-definedness of edge conditions
(push) ; 4
(pop) ; 4
(push) ; 4
; [eval] !true
(pop) ; 4
(pop) ; 3
(push) ; 3
; Loop head block: Establish invariant
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
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
; (:added-eqs               840
;  :arith-add-rows          5
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      42
;  :arith-conflicts         13
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   68
;  :datatype-splits         73
;  :decisions               125
;  :del-clause              47
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             583
;  :mk-clause               53
;  :num-allocs              3791017
;  :num-checks              124
;  :propagations            38
;  :quant-instantiations    30
;  :rlimit-count            139811
;  :time                    0.00)
; [then-branch: 8 | True | live]
; [else-branch: 8 | False | dead]
(push) ; 5
; [then-branch: 8 | True]
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@43@05 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(assert (= $t@43@05 ($Snap.combine ($Snap.first $t@43@05) ($Snap.second $t@43@05))))
(assert (= ($Snap.first $t@43@05) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@43@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@43@05))
    ($Snap.second ($Snap.second $t@43@05)))))
(assert (= ($Snap.first ($Snap.second $t@43@05)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@43@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@43@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@43@05))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@43@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@44@05 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 9 | 0 <= i@44@05 | live]
; [else-branch: 9 | !(0 <= i@44@05) | live]
(push) ; 8
; [then-branch: 9 | 0 <= i@44@05]
(assert (<= 0 i@44@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 9 | !(0 <= i@44@05)]
(assert (not (<= 0 i@44@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 10 | i@44@05 < |First:(Second:(Second:(Second:($t@43@05))))| && 0 <= i@44@05 | live]
; [else-branch: 10 | !(i@44@05 < |First:(Second:(Second:(Second:($t@43@05))))| && 0 <= i@44@05) | live]
(push) ; 8
; [then-branch: 10 | i@44@05 < |First:(Second:(Second:(Second:($t@43@05))))| && 0 <= i@44@05]
(assert (and
  (<
    i@44@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
  (<= 0 i@44@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@44@05 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               934
;  :arith-add-rows          5
;  :arith-assert-diseq      17
;  :arith-assert-lower      53
;  :arith-assert-upper      45
;  :arith-conflicts         13
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              47
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             615
;  :mk-clause               53
;  :num-allocs              3791017
;  :num-checks              126
;  :propagations            39
;  :quant-instantiations    34
;  :rlimit-count            141674)
; [eval] -1
(push) ; 9
; [then-branch: 11 | First:(Second:(Second:(Second:($t@43@05))))[i@44@05] == -1 | live]
; [else-branch: 11 | First:(Second:(Second:(Second:($t@43@05))))[i@44@05] != -1 | live]
(push) ; 10
; [then-branch: 11 | First:(Second:(Second:(Second:($t@43@05))))[i@44@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    i@44@05)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 11 | First:(Second:(Second:(Second:($t@43@05))))[i@44@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      i@44@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@44@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               934
;  :arith-add-rows          5
;  :arith-assert-diseq      17
;  :arith-assert-lower      53
;  :arith-assert-upper      45
;  :arith-conflicts         13
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              47
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             616
;  :mk-clause               53
;  :num-allocs              3791017
;  :num-checks              127
;  :propagations            39
;  :quant-instantiations    34
;  :rlimit-count            141849)
(push) ; 11
; [then-branch: 12 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[i@44@05] | live]
; [else-branch: 12 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[i@44@05]) | live]
(push) ; 12
; [then-branch: 12 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[i@44@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    i@44@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@44@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               934
;  :arith-add-rows          5
;  :arith-assert-diseq      18
;  :arith-assert-lower      56
;  :arith-assert-upper      45
;  :arith-conflicts         13
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              47
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             619
;  :mk-clause               54
;  :num-allocs              3791017
;  :num-checks              128
;  :propagations            39
;  :quant-instantiations    34
;  :rlimit-count            141973)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 12 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[i@44@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      i@44@05))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 10 | !(i@44@05 < |First:(Second:(Second:(Second:($t@43@05))))| && 0 <= i@44@05)]
(assert (not
  (and
    (<
      i@44@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
    (<= 0 i@44@05))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@44@05 Int)) (!
  (implies
    (and
      (<
        i@44@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
      (<= 0 i@44@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          i@44@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
            i@44@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
            i@44@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    i@44@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))
(declare-const $k@45@05 $Perm)
(assert ($Perm.isReadVar $k@45@05 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@45@05 $Perm.No) (< $Perm.No $k@45@05))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               939
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      46
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               72
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              48
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             625
;  :mk-clause               56
;  :num-allocs              3791017
;  :num-checks              129
;  :propagations            40
;  :quant-instantiations    34
;  :rlimit-count            142741)
(assert (<= $Perm.No $k@45@05))
(assert (<= $k@45@05 $Perm.Write))
(assert (implies (< $Perm.No $k@45@05) (not (= diz@15@05 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))
  $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               945
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      47
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               73
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              48
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             628
;  :mk-clause               56
;  :num-allocs              3791017
;  :num-checks              130
;  :propagations            40
;  :quant-instantiations    34
;  :rlimit-count            143064)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               951
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      47
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               74
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              48
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             631
;  :mk-clause               56
;  :num-allocs              3791017
;  :num-checks              131
;  :propagations            40
;  :quant-instantiations    35
;  :rlimit-count            143420)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               956
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      47
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               75
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              48
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             632
;  :mk-clause               56
;  :num-allocs              3791017
;  :num-checks              132
;  :propagations            40
;  :quant-instantiations    35
;  :rlimit-count            143677)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               961
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      47
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               76
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              48
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             633
;  :mk-clause               56
;  :num-allocs              3791017
;  :num-checks              133
;  :propagations            40
;  :quant-instantiations    35
;  :rlimit-count            143944)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               961
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      47
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               76
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              48
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             633
;  :mk-clause               56
;  :num-allocs              3791017
;  :num-checks              134
;  :propagations            40
;  :quant-instantiations    35
;  :rlimit-count            143957)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))))))
(declare-const $k@46@05 $Perm)
(assert ($Perm.isReadVar $k@46@05 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@46@05 $Perm.No) (< $Perm.No $k@46@05))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               966
;  :arith-add-rows          5
;  :arith-assert-diseq      20
;  :arith-assert-lower      60
;  :arith-assert-upper      48
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               77
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              48
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             638
;  :mk-clause               58
;  :num-allocs              3791017
;  :num-checks              135
;  :propagations            41
;  :quant-instantiations    35
;  :rlimit-count            144377)
(assert (<= $Perm.No $k@46@05))
(assert (<= $k@46@05 $Perm.Write))
(assert (implies (< $Perm.No $k@46@05) (not (= diz@15@05 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               972
;  :arith-add-rows          5
;  :arith-assert-diseq      20
;  :arith-assert-lower      60
;  :arith-assert-upper      49
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               78
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              48
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             641
;  :mk-clause               58
;  :num-allocs              3791017
;  :num-checks              136
;  :propagations            41
;  :quant-instantiations    35
;  :rlimit-count            144750)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               978
;  :arith-add-rows          5
;  :arith-assert-diseq      20
;  :arith-assert-lower      60
;  :arith-assert-upper      49
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               79
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              48
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             644
;  :mk-clause               58
;  :num-allocs              3791017
;  :num-checks              137
;  :propagations            41
;  :quant-instantiations    36
;  :rlimit-count            145160)
(push) ; 6
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               978
;  :arith-add-rows          5
;  :arith-assert-diseq      20
;  :arith-assert-lower      60
;  :arith-assert-upper      49
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              48
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             644
;  :mk-clause               58
;  :num-allocs              3791017
;  :num-checks              138
;  :propagations            41
;  :quant-instantiations    36
;  :rlimit-count            145208)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               978
;  :arith-add-rows          5
;  :arith-assert-diseq      20
;  :arith-assert-lower      60
;  :arith-assert-upper      49
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   74
;  :datatype-splits         80
;  :decisions               137
;  :del-clause              48
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             644
;  :mk-clause               58
;  :num-allocs              3791017
;  :num-checks              139
;  :propagations            41
;  :quant-instantiations    36
;  :rlimit-count            145221)
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@43@05 diz@15@05 globals@16@05))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@47@05 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; Main_immediate_wakeup_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@48@05 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 13 | 0 <= i@48@05 | live]
; [else-branch: 13 | !(0 <= i@48@05) | live]
(push) ; 8
; [then-branch: 13 | 0 <= i@48@05]
(assert (<= 0 i@48@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 13 | !(0 <= i@48@05)]
(assert (not (<= 0 i@48@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 14 | i@48@05 < |First:(Second:(Second:(Second:($t@43@05))))| && 0 <= i@48@05 | live]
; [else-branch: 14 | !(i@48@05 < |First:(Second:(Second:(Second:($t@43@05))))| && 0 <= i@48@05) | live]
(push) ; 8
; [then-branch: 14 | i@48@05 < |First:(Second:(Second:(Second:($t@43@05))))| && 0 <= i@48@05]
(assert (and
  (<
    i@48@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
  (<= 0 i@48@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@48@05 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1186
;  :arith-add-rows          5
;  :arith-assert-diseq      20
;  :arith-assert-lower      61
;  :arith-assert-upper      50
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 200
;  :datatype-occurs-check   90
;  :datatype-splits         116
;  :decisions               186
;  :del-clause              52
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             683
;  :mk-clause               59
;  :num-allocs              3934899
;  :num-checks              142
;  :propagations            44
;  :quant-instantiations    36
;  :rlimit-count            146969)
; [eval] -1
(push) ; 9
; [then-branch: 15 | First:(Second:(Second:(Second:($t@43@05))))[i@48@05] == -1 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:($t@43@05))))[i@48@05] != -1 | live]
(push) ; 10
; [then-branch: 15 | First:(Second:(Second:(Second:($t@43@05))))[i@48@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    i@48@05)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 15 | First:(Second:(Second:(Second:($t@43@05))))[i@48@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      i@48@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@48@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1186
;  :arith-add-rows          5
;  :arith-assert-diseq      21
;  :arith-assert-lower      64
;  :arith-assert-upper      51
;  :arith-conflicts         13
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 200
;  :datatype-occurs-check   90
;  :datatype-splits         116
;  :decisions               186
;  :del-clause              52
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             689
;  :mk-clause               63
;  :num-allocs              3934899
;  :num-checks              143
;  :propagations            46
;  :quant-instantiations    37
;  :rlimit-count            147201)
(push) ; 11
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[i@48@05] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[i@48@05]) | live]
(push) ; 12
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[i@48@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    i@48@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@48@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1186
;  :arith-add-rows          5
;  :arith-assert-diseq      21
;  :arith-assert-lower      64
;  :arith-assert-upper      51
;  :arith-conflicts         13
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 200
;  :datatype-occurs-check   90
;  :datatype-splits         116
;  :decisions               186
;  :del-clause              52
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             689
;  :mk-clause               63
;  :num-allocs              3934899
;  :num-checks              144
;  :propagations            46
;  :quant-instantiations    37
;  :rlimit-count            147315)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[i@48@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      i@48@05))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 14 | !(i@48@05 < |First:(Second:(Second:(Second:($t@43@05))))| && 0 <= i@48@05)]
(assert (not
  (and
    (<
      i@48@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
    (<= 0 i@48@05))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 6
(assert (not (forall ((i@48@05 Int)) (!
  (implies
    (and
      (<
        i@48@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
      (<= 0 i@48@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          i@48@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
            i@48@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
            i@48@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    i@48@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1186
;  :arith-add-rows          5
;  :arith-assert-diseq      23
;  :arith-assert-lower      65
;  :arith-assert-upper      52
;  :arith-conflicts         13
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 200
;  :datatype-occurs-check   90
;  :datatype-splits         116
;  :decisions               186
;  :del-clause              70
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             697
;  :mk-clause               77
;  :num-allocs              3934899
;  :num-checks              145
;  :propagations            48
;  :quant-instantiations    38
;  :rlimit-count            147761
;  :time                    0.00)
(assert (forall ((i@48@05 Int)) (!
  (implies
    (and
      (<
        i@48@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
      (<= 0 i@48@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          i@48@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
            i@48@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
            i@48@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    i@48@05))
  :qid |prog.l<no position>|)))
(declare-const $t@49@05 $Snap)
(assert (= $t@49@05 ($Snap.combine ($Snap.first $t@49@05) ($Snap.second $t@49@05))))
(assert (=
  ($Snap.second $t@49@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@49@05))
    ($Snap.second ($Snap.second $t@49@05)))))
(assert (=
  ($Snap.second ($Snap.second $t@49@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@49@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@49@05))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@49@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@50@05 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 17 | 0 <= i@50@05 | live]
; [else-branch: 17 | !(0 <= i@50@05) | live]
(push) ; 8
; [then-branch: 17 | 0 <= i@50@05]
(assert (<= 0 i@50@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 17 | !(0 <= i@50@05)]
(assert (not (<= 0 i@50@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 18 | i@50@05 < |First:(Second:($t@49@05))| && 0 <= i@50@05 | live]
; [else-branch: 18 | !(i@50@05 < |First:(Second:($t@49@05))| && 0 <= i@50@05) | live]
(push) ; 8
; [then-branch: 18 | i@50@05 < |First:(Second:($t@49@05))| && 0 <= i@50@05]
(assert (and
  (<
    i@50@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))
  (<= 0 i@50@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@50@05 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1223
;  :arith-add-rows          5
;  :arith-assert-diseq      23
;  :arith-assert-lower      70
;  :arith-assert-upper      55
;  :arith-conflicts         13
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 200
;  :datatype-occurs-check   90
;  :datatype-splits         116
;  :decisions               186
;  :del-clause              70
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             719
;  :mk-clause               77
;  :num-allocs              3934899
;  :num-checks              146
;  :propagations            48
;  :quant-instantiations    42
;  :rlimit-count            149189)
; [eval] -1
(push) ; 9
; [then-branch: 19 | First:(Second:($t@49@05))[i@50@05] == -1 | live]
; [else-branch: 19 | First:(Second:($t@49@05))[i@50@05] != -1 | live]
(push) ; 10
; [then-branch: 19 | First:(Second:($t@49@05))[i@50@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
    i@50@05)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 19 | First:(Second:($t@49@05))[i@50@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
      i@50@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@50@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1223
;  :arith-add-rows          5
;  :arith-assert-diseq      23
;  :arith-assert-lower      70
;  :arith-assert-upper      55
;  :arith-conflicts         13
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 200
;  :datatype-occurs-check   90
;  :datatype-splits         116
;  :decisions               186
;  :del-clause              70
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             720
;  :mk-clause               77
;  :num-allocs              3934899
;  :num-checks              147
;  :propagations            48
;  :quant-instantiations    42
;  :rlimit-count            149340)
(push) ; 11
; [then-branch: 20 | 0 <= First:(Second:($t@49@05))[i@50@05] | live]
; [else-branch: 20 | !(0 <= First:(Second:($t@49@05))[i@50@05]) | live]
(push) ; 12
; [then-branch: 20 | 0 <= First:(Second:($t@49@05))[i@50@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
    i@50@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@50@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1223
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      73
;  :arith-assert-upper      55
;  :arith-conflicts         13
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 200
;  :datatype-occurs-check   90
;  :datatype-splits         116
;  :decisions               186
;  :del-clause              70
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             723
;  :mk-clause               78
;  :num-allocs              3934899
;  :num-checks              148
;  :propagations            48
;  :quant-instantiations    42
;  :rlimit-count            149443)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 20 | !(0 <= First:(Second:($t@49@05))[i@50@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
      i@50@05))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 18 | !(i@50@05 < |First:(Second:($t@49@05))| && 0 <= i@50@05)]
(assert (not
  (and
    (<
      i@50@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))
    (<= 0 i@50@05))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@50@05 Int)) (!
  (implies
    (and
      (<
        i@50@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))
      (<= 0 i@50@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
          i@50@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
            i@50@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
            i@50@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
    i@50@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 ==> diz.Main_process_state[0] == -1
; [eval] 0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1241
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      74
;  :arith-assert-upper      56
;  :arith-conflicts         13
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 200
;  :datatype-occurs-check   90
;  :datatype-splits         116
;  :decisions               186
;  :del-clause              71
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             743
;  :mk-clause               88
;  :num-allocs              4082175
;  :num-checks              149
;  :propagations            52
;  :quant-instantiations    44
;  :rlimit-count            150516)
(push) ; 6
; [then-branch: 21 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[0] | live]
; [else-branch: 21 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[0]) | live]
(push) ; 7
; [then-branch: 21 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1241
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      75
;  :arith-assert-upper      56
;  :arith-conflicts         13
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 200
;  :datatype-occurs-check   90
;  :datatype-splits         116
;  :decisions               186
;  :del-clause              71
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             749
;  :mk-clause               95
;  :num-allocs              4082175
;  :num-checks              150
;  :propagations            52
;  :quant-instantiations    46
;  :rlimit-count            150714)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1241
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      75
;  :arith-assert-upper      56
;  :arith-conflicts         13
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 200
;  :datatype-occurs-check   90
;  :datatype-splits         116
;  :decisions               186
;  :del-clause              71
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             749
;  :mk-clause               95
;  :num-allocs              4082175
;  :num-checks              151
;  :propagations            52
;  :quant-instantiations    46
;  :rlimit-count            150723)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1242
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      76
;  :arith-assert-upper      57
;  :arith-conflicts         14
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 200
;  :datatype-occurs-check   90
;  :datatype-splits         116
;  :decisions               186
;  :del-clause              71
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             749
;  :mk-clause               95
;  :num-allocs              4082175
;  :num-checks              152
;  :propagations            56
;  :quant-instantiations    46
;  :rlimit-count            150841)
(pop) ; 7
(push) ; 7
; [else-branch: 21 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      0))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        0))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1358
;  :arith-add-rows          5
;  :arith-assert-diseq      27
;  :arith-assert-lower      87
;  :arith-assert-upper      63
;  :arith-conflicts         14
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         14
;  :arith-pivots            9
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 227
;  :datatype-occurs-check   101
;  :datatype-splits         137
;  :decisions               212
;  :del-clause              95
;  :final-checks            50
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             797
;  :mk-clause               112
;  :num-allocs              4082175
;  :num-checks              153
;  :propagations            66
;  :quant-instantiations    51
;  :rlimit-count            152171
;  :time                    0.00)
(push) ; 7
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      0)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1472
;  :arith-add-rows          6
;  :arith-assert-diseq      30
;  :arith-assert-lower      98
;  :arith-assert-upper      68
;  :arith-conflicts         14
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         16
;  :arith-pivots            13
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 254
;  :datatype-occurs-check   112
;  :datatype-splits         158
;  :decisions               239
;  :del-clause              123
;  :final-checks            53
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             843
;  :mk-clause               140
;  :num-allocs              4231673
;  :num-checks              154
;  :propagations            79
;  :quant-instantiations    56
;  :rlimit-count            153463
;  :time                    0.00)
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[0] | live]
; [else-branch: 22 | !(First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[0]) | live]
(push) ; 7
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1473
;  :arith-add-rows          6
;  :arith-assert-diseq      30
;  :arith-assert-lower      99
;  :arith-assert-upper      68
;  :arith-conflicts         14
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         16
;  :arith-pivots            13
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 254
;  :datatype-occurs-check   112
;  :datatype-splits         158
;  :decisions               239
;  :del-clause              123
;  :final-checks            53
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             850
;  :mk-clause               147
;  :num-allocs              4231673
;  :num-checks              155
;  :propagations            79
;  :quant-instantiations    58
;  :rlimit-count            153680)
; [eval] -1
(pop) ; 7
(push) ; 7
; [else-branch: 22 | !(First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        0)))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[1]) && old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 ==> diz.Main_process_state[1] == -1
; [eval] 0 <= old(diz.Main_process_state[1]) && old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] 0 <= old(diz.Main_process_state[1])
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 6
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1479
;  :arith-add-rows          6
;  :arith-assert-diseq      30
;  :arith-assert-lower      99
;  :arith-assert-upper      68
;  :arith-conflicts         14
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         16
;  :arith-pivots            13
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 254
;  :datatype-occurs-check   112
;  :datatype-splits         158
;  :decisions               239
;  :del-clause              130
;  :final-checks            53
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             855
;  :mk-clause               148
;  :num-allocs              4231673
;  :num-checks              156
;  :propagations            79
;  :quant-instantiations    58
;  :rlimit-count            154185)
(push) ; 6
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[1] | live]
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[1]) | live]
(push) ; 7
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    1)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1479
;  :arith-add-rows          6
;  :arith-assert-diseq      30
;  :arith-assert-lower      100
;  :arith-assert-upper      68
;  :arith-conflicts         14
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         16
;  :arith-pivots            13
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 254
;  :datatype-occurs-check   112
;  :datatype-splits         158
;  :decisions               239
;  :del-clause              130
;  :final-checks            53
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             861
;  :mk-clause               155
;  :num-allocs              4231673
;  :num-checks              157
;  :propagations            79
;  :quant-instantiations    60
;  :rlimit-count            154382)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1479
;  :arith-add-rows          6
;  :arith-assert-diseq      30
;  :arith-assert-lower      100
;  :arith-assert-upper      68
;  :arith-conflicts         14
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         16
;  :arith-pivots            13
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 254
;  :datatype-occurs-check   112
;  :datatype-splits         158
;  :decisions               239
;  :del-clause              130
;  :final-checks            53
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             861
;  :mk-clause               155
;  :num-allocs              4231673
;  :num-checks              158
;  :propagations            79
;  :quant-instantiations    60
;  :rlimit-count            154391)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1480
;  :arith-add-rows          6
;  :arith-assert-diseq      30
;  :arith-assert-lower      101
;  :arith-assert-upper      69
;  :arith-conflicts         15
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         16
;  :arith-pivots            13
;  :binary-propagations     11
;  :conflicts               84
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 254
;  :datatype-occurs-check   112
;  :datatype-splits         158
;  :decisions               239
;  :del-clause              130
;  :final-checks            53
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             861
;  :mk-clause               155
;  :num-allocs              4231673
;  :num-checks              159
;  :propagations            83
;  :quant-instantiations    60
;  :rlimit-count            154508)
(pop) ; 7
(push) ; 7
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      1))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        1))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1609
;  :arith-add-rows          15
;  :arith-assert-diseq      38
;  :arith-assert-lower      128
;  :arith-assert-upper      81
;  :arith-conflicts         15
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :binary-propagations     11
;  :conflicts               85
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 281
;  :datatype-occurs-check   123
;  :datatype-splits         179
;  :decisions               270
;  :del-clause              192
;  :final-checks            58
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             940
;  :mk-clause               210
;  :num-allocs              4231673
;  :num-checks              160
;  :propagations            111
;  :quant-instantiations    70
;  :rlimit-count            156261
;  :time                    0.00)
(push) ; 7
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1725
;  :arith-add-rows          15
;  :arith-assert-diseq      41
;  :arith-assert-lower      139
;  :arith-assert-upper      89
;  :arith-conflicts         15
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            25
;  :binary-propagations     11
;  :conflicts               85
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 308
;  :datatype-occurs-check   134
;  :datatype-splits         200
;  :decisions               299
;  :del-clause              222
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             991
;  :mk-clause               240
;  :num-allocs              4231673
;  :num-checks              161
;  :propagations            125
;  :quant-instantiations    77
;  :rlimit-count            157637
;  :time                    0.00)
; [then-branch: 24 | First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[1] | live]
; [else-branch: 24 | !(First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[1]) | live]
(push) ; 7
; [then-branch: 24 | First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[1]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      1))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1726
;  :arith-add-rows          15
;  :arith-assert-diseq      41
;  :arith-assert-lower      140
;  :arith-assert-upper      89
;  :arith-conflicts         15
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            25
;  :binary-propagations     11
;  :conflicts               85
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 308
;  :datatype-occurs-check   134
;  :datatype-splits         200
;  :decisions               299
;  :del-clause              222
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             998
;  :mk-clause               247
;  :num-allocs              4231673
;  :num-checks              162
;  :propagations            125
;  :quant-instantiations    79
;  :rlimit-count            157845)
; [eval] -1
(pop) ; 7
(push) ; 7
; [else-branch: 24 | !(First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[1])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        1)))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
      1)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0) ==> diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] !(0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0)
; [eval] 0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1732
;  :arith-add-rows          15
;  :arith-assert-diseq      41
;  :arith-assert-lower      140
;  :arith-assert-upper      89
;  :arith-conflicts         15
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            25
;  :binary-propagations     11
;  :conflicts               85
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 308
;  :datatype-occurs-check   134
;  :datatype-splits         200
;  :decisions               299
;  :del-clause              229
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1003
;  :mk-clause               248
;  :num-allocs              4231673
;  :num-checks              163
;  :propagations            125
;  :quant-instantiations    79
;  :rlimit-count            158360)
(push) ; 6
; [then-branch: 25 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[0] | live]
; [else-branch: 25 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[0]) | live]
(push) ; 7
; [then-branch: 25 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1732
;  :arith-add-rows          15
;  :arith-assert-diseq      41
;  :arith-assert-lower      141
;  :arith-assert-upper      89
;  :arith-conflicts         15
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            25
;  :binary-propagations     11
;  :conflicts               85
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 308
;  :datatype-occurs-check   134
;  :datatype-splits         200
;  :decisions               299
;  :del-clause              229
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1008
;  :mk-clause               255
;  :num-allocs              4231673
;  :num-checks              164
;  :propagations            125
;  :quant-instantiations    81
;  :rlimit-count            158489)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1732
;  :arith-add-rows          15
;  :arith-assert-diseq      41
;  :arith-assert-lower      141
;  :arith-assert-upper      89
;  :arith-conflicts         15
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            25
;  :binary-propagations     11
;  :conflicts               85
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 308
;  :datatype-occurs-check   134
;  :datatype-splits         200
;  :decisions               299
;  :del-clause              229
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1008
;  :mk-clause               255
;  :num-allocs              4231673
;  :num-checks              165
;  :propagations            125
;  :quant-instantiations    81
;  :rlimit-count            158498)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1733
;  :arith-add-rows          15
;  :arith-assert-diseq      41
;  :arith-assert-lower      142
;  :arith-assert-upper      90
;  :arith-conflicts         16
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            25
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 308
;  :datatype-occurs-check   134
;  :datatype-splits         200
;  :decisions               299
;  :del-clause              229
;  :final-checks            62
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1008
;  :mk-clause               255
;  :num-allocs              4231673
;  :num-checks              166
;  :propagations            129
;  :quant-instantiations    81
;  :rlimit-count            158616)
(pop) ; 7
(push) ; 7
; [else-branch: 25 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      0))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      0)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1851
;  :arith-add-rows          16
;  :arith-assert-diseq      44
;  :arith-assert-lower      154
;  :arith-assert-upper      97
;  :arith-conflicts         16
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        2
;  :arith-pivots            29
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 335
;  :datatype-occurs-check   145
;  :datatype-splits         221
;  :decisions               327
;  :del-clause              265
;  :final-checks            65
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1056
;  :mk-clause               284
;  :num-allocs              4231673
;  :num-checks              167
;  :propagations            142
;  :quant-instantiations    88
;  :rlimit-count            160013
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        0))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2020
;  :arith-add-rows          16
;  :arith-assert-diseq      46
;  :arith-assert-lower      162
;  :arith-assert-upper      102
;  :arith-conflicts         16
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               88
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 376
;  :datatype-occurs-check   159
;  :datatype-splits         246
;  :decisions               365
;  :del-clause              278
;  :final-checks            69
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1113
;  :mk-clause               297
;  :num-allocs              4231673
;  :num-checks              168
;  :propagations            150
;  :quant-instantiations    94
;  :rlimit-count            161490
;  :time                    0.00)
; [then-branch: 26 | !(First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[0]) | live]
; [else-branch: 26 | First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[0] | live]
(push) ; 7
; [then-branch: 26 | !(First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2020
;  :arith-add-rows          16
;  :arith-assert-diseq      46
;  :arith-assert-lower      162
;  :arith-assert-upper      102
;  :arith-conflicts         16
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               88
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 376
;  :datatype-occurs-check   159
;  :datatype-splits         246
;  :decisions               365
;  :del-clause              278
;  :final-checks            69
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1113
;  :mk-clause               298
;  :num-allocs              4231673
;  :num-checks              169
;  :propagations            150
;  :quant-instantiations    94
;  :rlimit-count            161689)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2020
;  :arith-add-rows          16
;  :arith-assert-diseq      46
;  :arith-assert-lower      162
;  :arith-assert-upper      102
;  :arith-conflicts         16
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               88
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 376
;  :datatype-occurs-check   159
;  :datatype-splits         246
;  :decisions               365
;  :del-clause              278
;  :final-checks            69
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1113
;  :mk-clause               298
;  :num-allocs              4231673
;  :num-checks              170
;  :propagations            150
;  :quant-instantiations    94
;  :rlimit-count            161704)
(pop) ; 7
(push) ; 7
; [else-branch: 26 | First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      0))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
            0))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@05))))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[1]) && old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0) ==> diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] !(0 <= old(diz.Main_process_state[1]) && old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0)
; [eval] 0 <= old(diz.Main_process_state[1]) && old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] 0 <= old(diz.Main_process_state[1])
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 6
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2021
;  :arith-add-rows          16
;  :arith-assert-diseq      46
;  :arith-assert-lower      162
;  :arith-assert-upper      102
;  :arith-conflicts         16
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               88
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 376
;  :datatype-occurs-check   159
;  :datatype-splits         246
;  :decisions               365
;  :del-clause              279
;  :final-checks            69
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1116
;  :mk-clause               302
;  :num-allocs              4231673
;  :num-checks              171
;  :propagations            150
;  :quant-instantiations    94
;  :rlimit-count            162122)
(push) ; 6
; [then-branch: 27 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[1] | live]
; [else-branch: 27 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[1]) | live]
(push) ; 7
; [then-branch: 27 | 0 <= First:(Second:(Second:(Second:($t@43@05))))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    1)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2021
;  :arith-add-rows          16
;  :arith-assert-diseq      46
;  :arith-assert-lower      163
;  :arith-assert-upper      102
;  :arith-conflicts         16
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               88
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 376
;  :datatype-occurs-check   159
;  :datatype-splits         246
;  :decisions               365
;  :del-clause              279
;  :final-checks            69
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1121
;  :mk-clause               309
;  :num-allocs              4231673
;  :num-checks              172
;  :propagations            150
;  :quant-instantiations    96
;  :rlimit-count            162252)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2021
;  :arith-add-rows          16
;  :arith-assert-diseq      46
;  :arith-assert-lower      163
;  :arith-assert-upper      102
;  :arith-conflicts         16
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               88
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 376
;  :datatype-occurs-check   159
;  :datatype-splits         246
;  :decisions               365
;  :del-clause              279
;  :final-checks            69
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1121
;  :mk-clause               309
;  :num-allocs              4231673
;  :num-checks              173
;  :propagations            150
;  :quant-instantiations    96
;  :rlimit-count            162261)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2022
;  :arith-add-rows          16
;  :arith-assert-diseq      46
;  :arith-assert-lower      164
;  :arith-assert-upper      103
;  :arith-conflicts         17
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               89
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 376
;  :datatype-occurs-check   159
;  :datatype-splits         246
;  :decisions               365
;  :del-clause              279
;  :final-checks            69
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1121
;  :mk-clause               309
;  :num-allocs              4231673
;  :num-checks              174
;  :propagations            154
;  :quant-instantiations    96
;  :rlimit-count            162379)
(pop) ; 7
(push) ; 7
; [else-branch: 27 | !(0 <= First:(Second:(Second:(Second:($t@43@05))))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      1))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2138
;  :arith-add-rows          18
;  :arith-assert-diseq      49
;  :arith-assert-lower      176
;  :arith-assert-upper      110
;  :arith-bound-prop        4
;  :arith-conflicts         17
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        2
;  :arith-pivots            35
;  :binary-propagations     11
;  :conflicts               89
;  :datatype-accessor-ax    126
;  :datatype-constructor-ax 402
;  :datatype-occurs-check   170
;  :datatype-splits         266
;  :decisions               392
;  :del-clause              320
;  :final-checks            72
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1176
;  :mk-clause               343
;  :num-allocs              4231673
;  :num-checks              175
;  :propagations            166
;  :quant-instantiations    103
;  :rlimit-count            163788
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        1))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2313
;  :arith-add-rows          20
;  :arith-assert-diseq      54
;  :arith-assert-lower      195
;  :arith-assert-upper      119
;  :arith-bound-prop        8
;  :arith-conflicts         17
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        2
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 442
;  :datatype-occurs-check   184
;  :datatype-splits         290
;  :decisions               431
;  :del-clause              369
;  :final-checks            77
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1263
;  :mk-clause               392
;  :num-allocs              4231673
;  :num-checks              176
;  :propagations            184
;  :quant-instantiations    112
;  :rlimit-count            165466
;  :time                    0.00)
; [then-branch: 28 | !(First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[1]) | live]
; [else-branch: 28 | First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[1] | live]
(push) ; 7
; [then-branch: 28 | !(First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[1])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        1)))))
; [eval] diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2313
;  :arith-add-rows          20
;  :arith-assert-diseq      54
;  :arith-assert-lower      195
;  :arith-assert-upper      119
;  :arith-bound-prop        8
;  :arith-conflicts         17
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        2
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 442
;  :datatype-occurs-check   184
;  :datatype-splits         290
;  :decisions               431
;  :del-clause              369
;  :final-checks            77
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1263
;  :mk-clause               393
;  :num-allocs              4231673
;  :num-checks              177
;  :propagations            184
;  :quant-instantiations    112
;  :rlimit-count            165665)
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2313
;  :arith-add-rows          20
;  :arith-assert-diseq      54
;  :arith-assert-lower      195
;  :arith-assert-upper      119
;  :arith-bound-prop        8
;  :arith-conflicts         17
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        2
;  :arith-pivots            41
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 442
;  :datatype-occurs-check   184
;  :datatype-splits         290
;  :decisions               431
;  :del-clause              369
;  :final-checks            77
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1263
;  :mk-clause               393
;  :num-allocs              4231673
;  :num-checks              178
;  :propagations            184
;  :quant-instantiations    112
;  :rlimit-count            165680)
(pop) ; 7
(push) ; 7
; [else-branch: 28 | First:(Second:(Second:(Second:(Second:(Second:($t@43@05))))))[First:(Second:(Second:(Second:($t@43@05))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@43@05))))[1]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      1))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
            1))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
          1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))
      1))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; Main_reset_events_no_delta_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@51@05 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 29 | 0 <= i@51@05 | live]
; [else-branch: 29 | !(0 <= i@51@05) | live]
(push) ; 8
; [then-branch: 29 | 0 <= i@51@05]
(assert (<= 0 i@51@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 29 | !(0 <= i@51@05)]
(assert (not (<= 0 i@51@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 30 | i@51@05 < |First:(Second:($t@49@05))| && 0 <= i@51@05 | live]
; [else-branch: 30 | !(i@51@05 < |First:(Second:($t@49@05))| && 0 <= i@51@05) | live]
(push) ; 8
; [then-branch: 30 | i@51@05 < |First:(Second:($t@49@05))| && 0 <= i@51@05]
(assert (and
  (<
    i@51@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))
  (<= 0 i@51@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@51@05 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2434
;  :arith-add-rows          22
;  :arith-assert-diseq      57
;  :arith-assert-lower      209
;  :arith-assert-upper      129
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            48
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    132
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   195
;  :datatype-splits         310
;  :decisions               459
;  :del-clause              417
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1334
;  :mk-clause               450
;  :num-allocs              4231673
;  :num-checks              180
;  :propagations            200
;  :quant-instantiations    120
;  :rlimit-count            167371)
; [eval] -1
(push) ; 9
; [then-branch: 31 | First:(Second:($t@49@05))[i@51@05] == -1 | live]
; [else-branch: 31 | First:(Second:($t@49@05))[i@51@05] != -1 | live]
(push) ; 10
; [then-branch: 31 | First:(Second:($t@49@05))[i@51@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
    i@51@05)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 31 | First:(Second:($t@49@05))[i@51@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
      i@51@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@51@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2434
;  :arith-add-rows          22
;  :arith-assert-diseq      58
;  :arith-assert-lower      212
;  :arith-assert-upper      130
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            48
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    132
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   195
;  :datatype-splits         310
;  :decisions               459
;  :del-clause              417
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1340
;  :mk-clause               454
;  :num-allocs              4231673
;  :num-checks              181
;  :propagations            202
;  :quant-instantiations    121
;  :rlimit-count            167579)
(push) ; 11
; [then-branch: 32 | 0 <= First:(Second:($t@49@05))[i@51@05] | live]
; [else-branch: 32 | !(0 <= First:(Second:($t@49@05))[i@51@05]) | live]
(push) ; 12
; [then-branch: 32 | 0 <= First:(Second:($t@49@05))[i@51@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
    i@51@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@51@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2434
;  :arith-add-rows          22
;  :arith-assert-diseq      58
;  :arith-assert-lower      212
;  :arith-assert-upper      130
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            48
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    132
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   195
;  :datatype-splits         310
;  :decisions               459
;  :del-clause              417
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1340
;  :mk-clause               454
;  :num-allocs              4231673
;  :num-checks              182
;  :propagations            202
;  :quant-instantiations    121
;  :rlimit-count            167673)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 32 | !(0 <= First:(Second:($t@49@05))[i@51@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
      i@51@05))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 30 | !(i@51@05 < |First:(Second:($t@49@05))| && 0 <= i@51@05)]
(assert (not
  (and
    (<
      i@51@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))
    (<= 0 i@51@05))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 6
(assert (not (forall ((i@51@05 Int)) (!
  (implies
    (and
      (<
        i@51@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))
      (<= 0 i@51@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
          i@51@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
            i@51@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
            i@51@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
    i@51@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2434
;  :arith-add-rows          22
;  :arith-assert-diseq      60
;  :arith-assert-lower      213
;  :arith-assert-upper      131
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            48
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    132
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   195
;  :datatype-splits         310
;  :decisions               459
;  :del-clause              435
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1348
;  :mk-clause               468
;  :num-allocs              4231673
;  :num-checks              183
;  :propagations            204
;  :quant-instantiations    122
;  :rlimit-count            168095)
(assert (forall ((i@51@05 Int)) (!
  (implies
    (and
      (<
        i@51@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))
      (<= 0 i@51@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
          i@51@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
            i@51@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
            i@51@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))
    i@51@05))
  :qid |prog.l<no position>|)))
(declare-const $t@52@05 $Snap)
(assert (= $t@52@05 ($Snap.combine ($Snap.first $t@52@05) ($Snap.second $t@52@05))))
(assert (=
  ($Snap.second $t@52@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@52@05))
    ($Snap.second ($Snap.second $t@52@05)))))
(assert (=
  ($Snap.second ($Snap.second $t@52@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@52@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@52@05))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@52@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@53@05 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 33 | 0 <= i@53@05 | live]
; [else-branch: 33 | !(0 <= i@53@05) | live]
(push) ; 8
; [then-branch: 33 | 0 <= i@53@05]
(assert (<= 0 i@53@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 33 | !(0 <= i@53@05)]
(assert (not (<= 0 i@53@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 34 | i@53@05 < |First:(Second:($t@52@05))| && 0 <= i@53@05 | live]
; [else-branch: 34 | !(i@53@05 < |First:(Second:($t@52@05))| && 0 <= i@53@05) | live]
(push) ; 8
; [then-branch: 34 | i@53@05 < |First:(Second:($t@52@05))| && 0 <= i@53@05]
(assert (and
  (<
    i@53@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
  (<= 0 i@53@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@53@05 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2471
;  :arith-add-rows          22
;  :arith-assert-diseq      60
;  :arith-assert-lower      218
;  :arith-assert-upper      134
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            48
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   195
;  :datatype-splits         310
;  :decisions               459
;  :del-clause              435
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1370
;  :mk-clause               468
;  :num-allocs              4231673
;  :num-checks              184
;  :propagations            204
;  :quant-instantiations    126
;  :rlimit-count            169483)
; [eval] -1
(push) ; 9
; [then-branch: 35 | First:(Second:($t@52@05))[i@53@05] == -1 | live]
; [else-branch: 35 | First:(Second:($t@52@05))[i@53@05] != -1 | live]
(push) ; 10
; [then-branch: 35 | First:(Second:($t@52@05))[i@53@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@53@05)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 35 | First:(Second:($t@52@05))[i@53@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      i@53@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@53@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2471
;  :arith-add-rows          22
;  :arith-assert-diseq      60
;  :arith-assert-lower      218
;  :arith-assert-upper      134
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            48
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   195
;  :datatype-splits         310
;  :decisions               459
;  :del-clause              435
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1371
;  :mk-clause               468
;  :num-allocs              4231673
;  :num-checks              185
;  :propagations            204
;  :quant-instantiations    126
;  :rlimit-count            169634)
(push) ; 11
; [then-branch: 36 | 0 <= First:(Second:($t@52@05))[i@53@05] | live]
; [else-branch: 36 | !(0 <= First:(Second:($t@52@05))[i@53@05]) | live]
(push) ; 12
; [then-branch: 36 | 0 <= First:(Second:($t@52@05))[i@53@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@53@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@53@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2471
;  :arith-add-rows          22
;  :arith-assert-diseq      61
;  :arith-assert-lower      221
;  :arith-assert-upper      134
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            48
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   195
;  :datatype-splits         310
;  :decisions               459
;  :del-clause              435
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1374
;  :mk-clause               469
;  :num-allocs              4231673
;  :num-checks              186
;  :propagations            204
;  :quant-instantiations    126
;  :rlimit-count            169737)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 36 | !(0 <= First:(Second:($t@52@05))[i@53@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      i@53@05))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 34 | !(i@53@05 < |First:(Second:($t@52@05))| && 0 <= i@53@05)]
(assert (not
  (and
    (<
      i@53@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
    (<= 0 i@53@05))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@53@05 Int)) (!
  (implies
    (and
      (<
        i@53@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
      (<= 0 i@53@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          i@53@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@53@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@53@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@53@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@49@05)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2489
;  :arith-add-rows          22
;  :arith-assert-diseq      61
;  :arith-assert-lower      222
;  :arith-assert-upper      135
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        2
;  :arith-pivots            48
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   195
;  :datatype-splits         310
;  :decisions               459
;  :del-clause              436
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1394
;  :mk-clause               479
;  :num-allocs              4231673
;  :num-checks              187
;  :propagations            208
;  :quant-instantiations    128
;  :rlimit-count            170752)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2700
;  :arith-add-rows          26
;  :arith-assert-diseq      66
;  :arith-assert-lower      245
;  :arith-assert-upper      149
;  :arith-bound-prop        24
;  :arith-conflicts         17
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         39
;  :arith-offset-eqs        2
;  :arith-pivots            59
;  :binary-propagations     11
;  :conflicts               93
;  :datatype-accessor-ax    143
;  :datatype-constructor-ax 514
;  :datatype-occurs-check   209
;  :datatype-splits         335
;  :decisions               506
;  :del-clause              505
;  :final-checks            85
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1481
;  :mk-clause               548
;  :num-allocs              4393668
;  :num-checks              188
;  :propagations            236
;  :quant-instantiations    142
;  :rlimit-count            172750
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2910
;  :arith-add-rows          30
;  :arith-assert-diseq      71
;  :arith-assert-lower      268
;  :arith-assert-upper      163
;  :arith-bound-prop        34
;  :arith-conflicts         17
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        2
;  :arith-pivots            67
;  :binary-propagations     11
;  :conflicts               94
;  :datatype-accessor-ax    146
;  :datatype-constructor-ax 560
;  :datatype-occurs-check   223
;  :datatype-splits         360
;  :decisions               553
;  :del-clause              574
;  :final-checks            89
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1568
;  :mk-clause               617
;  :num-allocs              4393668
;  :num-checks              189
;  :propagations            264
;  :quant-instantiations    156
;  :rlimit-count            174678
;  :time                    0.00)
; [then-branch: 37 | First:(Second:(Second:(Second:($t@49@05))))[0] == 0 | live]
; [else-branch: 37 | First:(Second:(Second:(Second:($t@49@05))))[0] != 0 | live]
(push) ; 7
; [then-branch: 37 | First:(Second:(Second:(Second:($t@49@05))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    0)
  0))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2911
;  :arith-add-rows          30
;  :arith-assert-diseq      71
;  :arith-assert-lower      268
;  :arith-assert-upper      163
;  :arith-bound-prop        34
;  :arith-conflicts         17
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        2
;  :arith-pivots            67
;  :binary-propagations     11
;  :conflicts               94
;  :datatype-accessor-ax    146
;  :datatype-constructor-ax 560
;  :datatype-occurs-check   223
;  :datatype-splits         360
;  :decisions               553
;  :del-clause              574
;  :final-checks            89
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1569
;  :mk-clause               617
;  :num-allocs              4393668
;  :num-checks              190
;  :propagations            264
;  :quant-instantiations    156
;  :rlimit-count            174806)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 37 | First:(Second:(Second:(Second:($t@49@05))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      0)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 6
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2917
;  :arith-add-rows          30
;  :arith-assert-diseq      71
;  :arith-assert-lower      268
;  :arith-assert-upper      163
;  :arith-bound-prop        34
;  :arith-conflicts         17
;  :arith-eq-adapter        138
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        2
;  :arith-pivots            67
;  :binary-propagations     11
;  :conflicts               94
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 560
;  :datatype-occurs-check   223
;  :datatype-splits         360
;  :decisions               553
;  :del-clause              574
;  :final-checks            89
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1573
;  :mk-clause               618
;  :num-allocs              4393668
;  :num-checks              191
;  :propagations            264
;  :quant-instantiations    156
;  :rlimit-count            175241)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3132
;  :arith-add-rows          34
;  :arith-assert-diseq      76
;  :arith-assert-lower      290
;  :arith-assert-upper      177
;  :arith-bound-prop        44
;  :arith-conflicts         17
;  :arith-eq-adapter        151
;  :arith-fixed-eqs         51
;  :arith-offset-eqs        2
;  :arith-pivots            73
;  :binary-propagations     11
;  :conflicts               95
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 606
;  :datatype-occurs-check   237
;  :datatype-splits         385
;  :decisions               601
;  :del-clause              641
;  :final-checks            93
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1659
;  :mk-clause               685
;  :num-allocs              4393668
;  :num-checks              192
;  :propagations            291
;  :quant-instantiations    170
;  :rlimit-count            177171
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3346
;  :arith-add-rows          38
;  :arith-assert-diseq      81
;  :arith-assert-lower      313
;  :arith-assert-upper      191
;  :arith-bound-prop        54
;  :arith-conflicts         17
;  :arith-eq-adapter        164
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        2
;  :arith-pivots            81
;  :binary-propagations     11
;  :conflicts               96
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 652
;  :datatype-occurs-check   251
;  :datatype-splits         410
;  :decisions               649
;  :del-clause              710
;  :final-checks            97
;  :interface-eqs           10
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1746
;  :mk-clause               754
;  :num-allocs              4393668
;  :num-checks              193
;  :propagations            319
;  :quant-instantiations    184
;  :rlimit-count            179127
;  :time                    0.00)
; [then-branch: 38 | First:(Second:(Second:(Second:($t@49@05))))[1] == 0 | live]
; [else-branch: 38 | First:(Second:(Second:(Second:($t@49@05))))[1] != 0 | live]
(push) ; 7
; [then-branch: 38 | First:(Second:(Second:(Second:($t@49@05))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    1)
  0))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3347
;  :arith-add-rows          38
;  :arith-assert-diseq      81
;  :arith-assert-lower      313
;  :arith-assert-upper      191
;  :arith-bound-prop        54
;  :arith-conflicts         17
;  :arith-eq-adapter        164
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        2
;  :arith-pivots            81
;  :binary-propagations     11
;  :conflicts               96
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 652
;  :datatype-occurs-check   251
;  :datatype-splits         410
;  :decisions               649
;  :del-clause              710
;  :final-checks            97
;  :interface-eqs           10
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1747
;  :mk-clause               754
;  :num-allocs              4393668
;  :num-checks              194
;  :propagations            319
;  :quant-instantiations    184
;  :rlimit-count            179255)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 38 | First:(Second:(Second:(Second:($t@49@05))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      1)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[2]) == 0 ==> diz.Main_event_state[2] == -2
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 6
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3353
;  :arith-add-rows          38
;  :arith-assert-diseq      81
;  :arith-assert-lower      313
;  :arith-assert-upper      191
;  :arith-bound-prop        54
;  :arith-conflicts         17
;  :arith-eq-adapter        164
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        2
;  :arith-pivots            81
;  :binary-propagations     11
;  :conflicts               96
;  :datatype-accessor-ax    154
;  :datatype-constructor-ax 652
;  :datatype-occurs-check   251
;  :datatype-splits         410
;  :decisions               649
;  :del-clause              710
;  :final-checks            97
;  :interface-eqs           10
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1751
;  :mk-clause               755
;  :num-allocs              4393668
;  :num-checks              195
;  :propagations            319
;  :quant-instantiations    184
;  :rlimit-count            179696)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      2)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3588
;  :arith-add-rows          43
;  :arith-assert-diseq      90
;  :arith-assert-lower      348
;  :arith-assert-upper      216
;  :arith-bound-prop        64
;  :arith-conflicts         17
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         65
;  :arith-offset-eqs        2
;  :arith-pivots            91
;  :binary-propagations     11
;  :conflicts               98
;  :datatype-accessor-ax    157
;  :datatype-constructor-ax 698
;  :datatype-occurs-check   264
;  :datatype-splits         435
;  :decisions               703
;  :del-clause              820
;  :final-checks            102
;  :interface-eqs           12
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1865
;  :mk-clause               865
;  :num-allocs              4393668
;  :num-checks              196
;  :propagations            378
;  :quant-instantiations    203
;  :rlimit-count            181876
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    2)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3808
;  :arith-add-rows          47
;  :arith-assert-diseq      95
;  :arith-assert-lower      371
;  :arith-assert-upper      230
;  :arith-bound-prop        74
;  :arith-conflicts         17
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        2
;  :arith-pivots            99
;  :binary-propagations     11
;  :conflicts               99
;  :datatype-accessor-ax    160
;  :datatype-constructor-ax 744
;  :datatype-occurs-check   277
;  :datatype-splits         460
;  :decisions               752
;  :del-clause              889
;  :final-checks            106
;  :interface-eqs           13
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1952
;  :mk-clause               934
;  :num-allocs              4393668
;  :num-checks              197
;  :propagations            406
;  :quant-instantiations    217
;  :rlimit-count            183852
;  :time                    0.00)
; [then-branch: 39 | First:(Second:(Second:(Second:($t@49@05))))[2] == 0 | live]
; [else-branch: 39 | First:(Second:(Second:(Second:($t@49@05))))[2] != 0 | live]
(push) ; 7
; [then-branch: 39 | First:(Second:(Second:(Second:($t@49@05))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    2)
  0))
; [eval] diz.Main_event_state[2] == -2
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3809
;  :arith-add-rows          47
;  :arith-assert-diseq      95
;  :arith-assert-lower      371
;  :arith-assert-upper      230
;  :arith-bound-prop        74
;  :arith-conflicts         17
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        2
;  :arith-pivots            99
;  :binary-propagations     11
;  :conflicts               99
;  :datatype-accessor-ax    160
;  :datatype-constructor-ax 744
;  :datatype-occurs-check   277
;  :datatype-splits         460
;  :decisions               752
;  :del-clause              889
;  :final-checks            106
;  :interface-eqs           13
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1953
;  :mk-clause               934
;  :num-allocs              4393668
;  :num-checks              198
;  :propagations            406
;  :quant-instantiations    217
;  :rlimit-count            183972)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 39 | First:(Second:(Second:(Second:($t@49@05))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      2)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      2)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[0]) == 0) ==> diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] !(old(diz.Main_event_state[0]) == 0)
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3815
;  :arith-add-rows          47
;  :arith-assert-diseq      95
;  :arith-assert-lower      371
;  :arith-assert-upper      230
;  :arith-bound-prop        74
;  :arith-conflicts         17
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        2
;  :arith-pivots            99
;  :binary-propagations     11
;  :conflicts               99
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 744
;  :datatype-occurs-check   277
;  :datatype-splits         460
;  :decisions               752
;  :del-clause              889
;  :final-checks            106
;  :interface-eqs           13
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1957
;  :mk-clause               935
;  :num-allocs              4393668
;  :num-checks              199
;  :propagations            406
;  :quant-instantiations    217
;  :rlimit-count            184419)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4033
;  :arith-add-rows          51
;  :arith-assert-diseq      100
;  :arith-assert-lower      394
;  :arith-assert-upper      244
;  :arith-bound-prop        84
;  :arith-conflicts         17
;  :arith-eq-adapter        212
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        2
;  :arith-pivots            107
;  :binary-propagations     11
;  :conflicts               100
;  :datatype-accessor-ax    164
;  :datatype-constructor-ax 790
;  :datatype-occurs-check   291
;  :datatype-splits         485
;  :decisions               801
;  :del-clause              958
;  :final-checks            110
;  :interface-eqs           14
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2043
;  :mk-clause               1004
;  :num-allocs              4393668
;  :num-checks              200
;  :propagations            434
;  :quant-instantiations    231
;  :rlimit-count            186383
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4262
;  :arith-add-rows          55
;  :arith-assert-diseq      105
;  :arith-assert-lower      417
;  :arith-assert-upper      258
;  :arith-bound-prop        94
;  :arith-conflicts         17
;  :arith-eq-adapter        225
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        2
;  :arith-pivots            113
;  :binary-propagations     11
;  :conflicts               102
;  :datatype-accessor-ax    168
;  :datatype-constructor-ax 839
;  :datatype-occurs-check   309
;  :datatype-splits         512
;  :decisions               852
;  :del-clause              1026
;  :final-checks            115
;  :interface-eqs           15
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2141
;  :mk-clause               1072
;  :num-allocs              4393668
;  :num-checks              201
;  :propagations            462
;  :quant-instantiations    245
;  :rlimit-count            188391
;  :time                    0.00)
; [then-branch: 40 | First:(Second:(Second:(Second:($t@49@05))))[0] != 0 | live]
; [else-branch: 40 | First:(Second:(Second:(Second:($t@49@05))))[0] == 0 | live]
(push) ; 7
; [then-branch: 40 | First:(Second:(Second:(Second:($t@49@05))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      0)
    0)))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4262
;  :arith-add-rows          55
;  :arith-assert-diseq      105
;  :arith-assert-lower      417
;  :arith-assert-upper      258
;  :arith-bound-prop        94
;  :arith-conflicts         17
;  :arith-eq-adapter        225
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        2
;  :arith-pivots            113
;  :binary-propagations     11
;  :conflicts               102
;  :datatype-accessor-ax    168
;  :datatype-constructor-ax 839
;  :datatype-occurs-check   309
;  :datatype-splits         512
;  :decisions               852
;  :del-clause              1026
;  :final-checks            115
;  :interface-eqs           15
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2141
;  :mk-clause               1072
;  :num-allocs              4393668
;  :num-checks              202
;  :propagations            462
;  :quant-instantiations    245
;  :rlimit-count            188521)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4262
;  :arith-add-rows          55
;  :arith-assert-diseq      105
;  :arith-assert-lower      417
;  :arith-assert-upper      258
;  :arith-bound-prop        94
;  :arith-conflicts         17
;  :arith-eq-adapter        225
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        2
;  :arith-pivots            113
;  :binary-propagations     11
;  :conflicts               102
;  :datatype-accessor-ax    168
;  :datatype-constructor-ax 839
;  :datatype-occurs-check   309
;  :datatype-splits         512
;  :decisions               852
;  :del-clause              1026
;  :final-checks            115
;  :interface-eqs           15
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2141
;  :mk-clause               1072
;  :num-allocs              4393668
;  :num-checks              203
;  :propagations            462
;  :quant-instantiations    245
;  :rlimit-count            188536)
(pop) ; 7
(push) ; 7
; [else-branch: 40 | First:(Second:(Second:(Second:($t@49@05))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    0)
  0))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
        0)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[1]) == 0) ==> diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] !(old(diz.Main_event_state[1]) == 0)
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 6
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4268
;  :arith-add-rows          55
;  :arith-assert-diseq      105
;  :arith-assert-lower      417
;  :arith-assert-upper      258
;  :arith-bound-prop        94
;  :arith-conflicts         17
;  :arith-eq-adapter        225
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        2
;  :arith-pivots            113
;  :binary-propagations     11
;  :conflicts               102
;  :datatype-accessor-ax    169
;  :datatype-constructor-ax 839
;  :datatype-occurs-check   309
;  :datatype-splits         512
;  :decisions               852
;  :del-clause              1026
;  :final-checks            115
;  :interface-eqs           15
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2144
;  :mk-clause               1073
;  :num-allocs              4393668
;  :num-checks              204
;  :propagations            462
;  :quant-instantiations    245
;  :rlimit-count            188955)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4487
;  :arith-add-rows          59
;  :arith-assert-diseq      110
;  :arith-assert-lower      440
;  :arith-assert-upper      272
;  :arith-bound-prop        104
;  :arith-conflicts         17
;  :arith-eq-adapter        238
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        2
;  :arith-pivots            121
;  :binary-propagations     11
;  :conflicts               103
;  :datatype-accessor-ax    172
;  :datatype-constructor-ax 885
;  :datatype-occurs-check   323
;  :datatype-splits         537
;  :decisions               901
;  :del-clause              1095
;  :final-checks            119
;  :interface-eqs           16
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2230
;  :mk-clause               1142
;  :num-allocs              4393668
;  :num-checks              205
;  :propagations            491
;  :quant-instantiations    259
;  :rlimit-count            190936
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4718
;  :arith-add-rows          63
;  :arith-assert-diseq      115
;  :arith-assert-lower      462
;  :arith-assert-upper      286
;  :arith-bound-prop        114
;  :arith-conflicts         17
;  :arith-eq-adapter        251
;  :arith-fixed-eqs         95
;  :arith-offset-eqs        2
;  :arith-pivots            129
;  :binary-propagations     11
;  :conflicts               105
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   341
;  :datatype-splits         564
;  :decisions               952
;  :del-clause              1163
;  :final-checks            124
;  :interface-eqs           17
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2327
;  :mk-clause               1210
;  :num-allocs              4393668
;  :num-checks              206
;  :propagations            520
;  :quant-instantiations    273
;  :rlimit-count            192957
;  :time                    0.00)
; [then-branch: 41 | First:(Second:(Second:(Second:($t@49@05))))[1] != 0 | live]
; [else-branch: 41 | First:(Second:(Second:(Second:($t@49@05))))[1] == 0 | live]
(push) ; 7
; [then-branch: 41 | First:(Second:(Second:(Second:($t@49@05))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      1)
    0)))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4718
;  :arith-add-rows          63
;  :arith-assert-diseq      115
;  :arith-assert-lower      462
;  :arith-assert-upper      286
;  :arith-bound-prop        114
;  :arith-conflicts         17
;  :arith-eq-adapter        251
;  :arith-fixed-eqs         95
;  :arith-offset-eqs        2
;  :arith-pivots            129
;  :binary-propagations     11
;  :conflicts               105
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   341
;  :datatype-splits         564
;  :decisions               952
;  :del-clause              1163
;  :final-checks            124
;  :interface-eqs           17
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2327
;  :mk-clause               1210
;  :num-allocs              4393668
;  :num-checks              207
;  :propagations            520
;  :quant-instantiations    273
;  :rlimit-count            193087)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4718
;  :arith-add-rows          63
;  :arith-assert-diseq      115
;  :arith-assert-lower      462
;  :arith-assert-upper      286
;  :arith-bound-prop        114
;  :arith-conflicts         17
;  :arith-eq-adapter        251
;  :arith-fixed-eqs         95
;  :arith-offset-eqs        2
;  :arith-pivots            129
;  :binary-propagations     11
;  :conflicts               105
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   341
;  :datatype-splits         564
;  :decisions               952
;  :del-clause              1163
;  :final-checks            124
;  :interface-eqs           17
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2327
;  :mk-clause               1210
;  :num-allocs              4393668
;  :num-checks              208
;  :propagations            520
;  :quant-instantiations    273
;  :rlimit-count            193102)
(pop) ; 7
(push) ; 7
; [else-branch: 41 | First:(Second:(Second:(Second:($t@49@05))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    1)
  0))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
        1)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[2]) == 0) ==> diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] !(old(diz.Main_event_state[2]) == 0)
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 6
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4725
;  :arith-add-rows          63
;  :arith-assert-diseq      115
;  :arith-assert-lower      462
;  :arith-assert-upper      286
;  :arith-bound-prop        114
;  :arith-conflicts         17
;  :arith-eq-adapter        251
;  :arith-fixed-eqs         95
;  :arith-offset-eqs        2
;  :arith-pivots            129
;  :binary-propagations     11
;  :conflicts               105
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   341
;  :datatype-splits         564
;  :decisions               952
;  :del-clause              1163
;  :final-checks            124
;  :interface-eqs           17
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2329
;  :mk-clause               1211
;  :num-allocs              4393668
;  :num-checks              209
;  :propagations            520
;  :quant-instantiations    273
;  :rlimit-count            193444)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    2)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4938
;  :arith-add-rows          67
;  :arith-assert-diseq      120
;  :arith-assert-lower      485
;  :arith-assert-upper      300
;  :arith-bound-prop        124
;  :arith-conflicts         17
;  :arith-eq-adapter        264
;  :arith-fixed-eqs         101
;  :arith-offset-eqs        2
;  :arith-pivots            135
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    179
;  :datatype-constructor-ax 979
;  :datatype-occurs-check   355
;  :datatype-splits         588
;  :decisions               1000
;  :del-clause              1230
;  :final-checks            128
;  :interface-eqs           18
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2414
;  :mk-clause               1278
;  :num-allocs              4393668
;  :num-checks              210
;  :propagations            549
;  :quant-instantiations    287
;  :rlimit-count            195406
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      2)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5180
;  :arith-add-rows          72
;  :arith-assert-diseq      129
;  :arith-assert-lower      520
;  :arith-assert-upper      325
;  :arith-bound-prop        134
;  :arith-conflicts         17
;  :arith-eq-adapter        286
;  :arith-fixed-eqs         109
;  :arith-offset-eqs        2
;  :arith-pivots            145
;  :binary-propagations     11
;  :conflicts               109
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 1027
;  :datatype-occurs-check   373
;  :datatype-splits         614
;  :decisions               1055
;  :del-clause              1341
;  :final-checks            134
;  :interface-eqs           20
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2538
;  :mk-clause               1389
;  :num-allocs              4393668
;  :num-checks              211
;  :propagations            613
;  :quant-instantiations    306
;  :rlimit-count            197645
;  :time                    0.00)
; [then-branch: 42 | First:(Second:(Second:(Second:($t@49@05))))[2] != 0 | live]
; [else-branch: 42 | First:(Second:(Second:(Second:($t@49@05))))[2] == 0 | live]
(push) ; 7
; [then-branch: 42 | First:(Second:(Second:(Second:($t@49@05))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      2)
    0)))
; [eval] diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5180
;  :arith-add-rows          72
;  :arith-assert-diseq      129
;  :arith-assert-lower      520
;  :arith-assert-upper      325
;  :arith-bound-prop        134
;  :arith-conflicts         17
;  :arith-eq-adapter        286
;  :arith-fixed-eqs         109
;  :arith-offset-eqs        2
;  :arith-pivots            145
;  :binary-propagations     11
;  :conflicts               109
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 1027
;  :datatype-occurs-check   373
;  :datatype-splits         614
;  :decisions               1055
;  :del-clause              1341
;  :final-checks            134
;  :interface-eqs           20
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2538
;  :mk-clause               1389
;  :num-allocs              4393668
;  :num-checks              212
;  :propagations            613
;  :quant-instantiations    306
;  :rlimit-count            197775)
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5180
;  :arith-add-rows          72
;  :arith-assert-diseq      129
;  :arith-assert-lower      520
;  :arith-assert-upper      325
;  :arith-bound-prop        134
;  :arith-conflicts         17
;  :arith-eq-adapter        286
;  :arith-fixed-eqs         109
;  :arith-offset-eqs        2
;  :arith-pivots            145
;  :binary-propagations     11
;  :conflicts               109
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 1027
;  :datatype-occurs-check   373
;  :datatype-splits         614
;  :decisions               1055
;  :del-clause              1341
;  :final-checks            134
;  :interface-eqs           20
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2538
;  :mk-clause               1389
;  :num-allocs              4393668
;  :num-checks              213
;  :propagations            613
;  :quant-instantiations    306
;  :rlimit-count            197790)
(pop) ; 7
(push) ; 7
; [else-branch: 42 | First:(Second:(Second:(Second:($t@49@05))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
    2)
  0))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
        2)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@05)))))
      2))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] diz.Main_process_state[0] != -1 && diz.Main_process_state[1] != -1
; [eval] diz.Main_process_state[0] != -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5395
;  :arith-add-rows          76
;  :arith-assert-diseq      134
;  :arith-assert-lower      543
;  :arith-assert-upper      339
;  :arith-bound-prop        144
;  :arith-conflicts         17
;  :arith-eq-adapter        301
;  :arith-fixed-eqs         115
;  :arith-offset-eqs        2
;  :arith-pivots            151
;  :binary-propagations     11
;  :conflicts               110
;  :datatype-accessor-ax    186
;  :datatype-constructor-ax 1072
;  :datatype-occurs-check   387
;  :datatype-splits         638
;  :decisions               1104
;  :del-clause              1407
;  :final-checks            138
;  :interface-eqs           21
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2627
;  :mk-clause               1466
;  :num-allocs              4393668
;  :num-checks              215
;  :propagations            643
;  :quant-instantiations    320
;  :rlimit-count            199874)
; [eval] -1
(push) ; 6
; [then-branch: 43 | First:(Second:($t@52@05))[0] != -1 | live]
; [else-branch: 43 | First:(Second:($t@52@05))[0] == -1 | live]
(push) ; 7
; [then-branch: 43 | First:(Second:($t@52@05))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0)
    (- 0 1))))
; [eval] diz.Main_process_state[1] != -1
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5398
;  :arith-add-rows          76
;  :arith-assert-diseq      136
;  :arith-assert-lower      550
;  :arith-assert-upper      342
;  :arith-bound-prop        144
;  :arith-conflicts         17
;  :arith-eq-adapter        303
;  :arith-fixed-eqs         116
;  :arith-offset-eqs        2
;  :arith-pivots            152
;  :binary-propagations     11
;  :conflicts               110
;  :datatype-accessor-ax    186
;  :datatype-constructor-ax 1072
;  :datatype-occurs-check   387
;  :datatype-splits         638
;  :decisions               1104
;  :del-clause              1407
;  :final-checks            138
;  :interface-eqs           21
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2630
;  :mk-clause               1475
;  :num-allocs              4393668
;  :num-checks              216
;  :propagations            651
;  :quant-instantiations    323
;  :rlimit-count            200050)
; [eval] -1
(pop) ; 7
(push) ; 7
; [else-branch: 43 | First:(Second:($t@52@05))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  (- 0 1)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 6
(assert (not (not
  (and
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0)
        (- 0 1)))))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5551
;  :arith-add-rows          80
;  :arith-assert-diseq      144
;  :arith-assert-lower      581
;  :arith-assert-upper      358
;  :arith-bound-prop        144
;  :arith-conflicts         17
;  :arith-eq-adapter        318
;  :arith-fixed-eqs         122
;  :arith-offset-eqs        2
;  :arith-pivots            160
;  :binary-propagations     11
;  :conflicts               111
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 1102
;  :datatype-occurs-check   401
;  :datatype-splits         662
;  :decisions               1138
;  :del-clause              1467
;  :final-checks            143
;  :interface-eqs           23
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2698
;  :mk-clause               1526
;  :num-allocs              4393668
;  :num-checks              217
;  :propagations            695
;  :quant-instantiations    337
;  :rlimit-count            201944
;  :time                    0.00)
(push) ; 6
(assert (not (and
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 6
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5983
;  :arith-add-rows          85
;  :arith-assert-diseq      158
;  :arith-assert-lower      629
;  :arith-assert-upper      381
;  :arith-bound-prop        152
;  :arith-conflicts         17
;  :arith-eq-adapter        346
;  :arith-fixed-eqs         133
;  :arith-offset-eqs        2
;  :arith-pivots            173
;  :binary-propagations     11
;  :conflicts               116
;  :datatype-accessor-ax    204
;  :datatype-constructor-ax 1194
;  :datatype-occurs-check   439
;  :datatype-splits         736
;  :decisions               1228
;  :del-clause              1575
;  :final-checks            155
;  :interface-eqs           28
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             2883
;  :mk-clause               1634
;  :num-allocs              4393668
;  :num-checks              218
;  :propagations            759
;  :quant-instantiations    356
;  :rlimit-count            204959
;  :time                    0.00)
; [then-branch: 44 | First:(Second:($t@52@05))[1] != -1 && First:(Second:($t@52@05))[0] != -1 | live]
; [else-branch: 44 | !(First:(Second:($t@52@05))[1] != -1 && First:(Second:($t@52@05))[0] != -1) | live]
(push) ; 6
; [then-branch: 44 | First:(Second:($t@52@05))[1] != -1 && First:(Second:($t@52@05))[0] != -1]
(assert (and
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0)
      (- 0 1)))))
; [exec]
; min_advance__31 := Main_find_minimum_advance_Sequence$Integer$(diz, diz.Main_event_state)
; [eval] Main_find_minimum_advance_Sequence$Integer$(diz, diz.Main_event_state)
(push) ; 7
; [eval] diz != null
; [eval] |vals| == 3
; [eval] |vals|
(pop) ; 7
; Joined path conditions
(declare-const min_advance__31@54@05 Int)
(assert (=
  min_advance__31@54@05
  (Main_find_minimum_advance_Sequence$Integer$ ($Snap.combine
    $Snap.unit
    $Snap.unit) diz@15@05 ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05))))))))
; [eval] min_advance__31 == -1
; [eval] -1
(push) ; 7
(assert (not (not (= min_advance__31@54@05 (- 0 1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6154
;  :arith-add-rows          88
;  :arith-assert-diseq      178
;  :arith-assert-lower      663
;  :arith-assert-upper      409
;  :arith-bound-prop        156
;  :arith-conflicts         17
;  :arith-eq-adapter        367
;  :arith-fixed-eqs         140
;  :arith-offset-eqs        2
;  :arith-pivots            180
;  :binary-propagations     11
;  :conflicts               117
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 1224
;  :datatype-occurs-check   453
;  :datatype-splits         760
;  :decisions               1265
;  :del-clause              1631
;  :final-checks            160
;  :interface-eqs           30
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             2994
;  :mk-clause               1755
;  :num-allocs              4393668
;  :num-checks              219
;  :propagations            821
;  :quant-instantiations    373
;  :rlimit-count            207299
;  :time                    0.00)
(push) ; 7
(assert (not (= min_advance__31@54@05 (- 0 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6309
;  :arith-add-rows          88
;  :arith-assert-diseq      196
;  :arith-assert-lower      689
;  :arith-assert-upper      426
;  :arith-bound-prop        160
;  :arith-conflicts         17
;  :arith-eq-adapter        383
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        2
;  :arith-pivots            184
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    211
;  :datatype-constructor-ax 1254
;  :datatype-occurs-check   467
;  :datatype-splits         784
;  :decisions               1304
;  :del-clause              1692
;  :final-checks            165
;  :interface-eqs           32
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3072
;  :mk-clause               1816
;  :num-allocs              4393668
;  :num-checks              220
;  :propagations            865
;  :quant-instantiations    381
;  :rlimit-count            208951
;  :time                    0.00)
; [then-branch: 45 | min_advance__31@54@05 == -1 | live]
; [else-branch: 45 | min_advance__31@54@05 != -1 | live]
(push) ; 7
; [then-branch: 45 | min_advance__31@54@05 == -1]
(assert (= min_advance__31@54@05 (- 0 1)))
; [exec]
; min_advance__31 := 0
; [exec]
; __flatten_31__30 := Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__31), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__31), (diz.Main_event_state[2] < -1 ? -3 : diz.Main_event_state[2] - min_advance__31))
; [eval] Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__31), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__31), (diz.Main_event_state[2] < -1 ? -3 : diz.Main_event_state[2] - min_advance__31))
; [eval] (diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__31)
; [eval] diz.Main_event_state[0] < -1
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6311
;  :arith-add-rows          88
;  :arith-assert-diseq      197
;  :arith-assert-lower      690
;  :arith-assert-upper      429
;  :arith-bound-prop        160
;  :arith-conflicts         17
;  :arith-eq-adapter        384
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        2
;  :arith-pivots            184
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    211
;  :datatype-constructor-ax 1254
;  :datatype-occurs-check   467
;  :datatype-splits         784
;  :decisions               1304
;  :del-clause              1692
;  :final-checks            165
;  :interface-eqs           32
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3076
;  :mk-clause               1816
;  :num-allocs              4393668
;  :num-checks              221
;  :propagations            866
;  :quant-instantiations    381
;  :rlimit-count            209033)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6466
;  :arith-add-rows          88
;  :arith-assert-diseq      212
;  :arith-assert-lower      709
;  :arith-assert-upper      448
;  :arith-bound-prop        164
;  :arith-conflicts         17
;  :arith-eq-adapter        399
;  :arith-fixed-eqs         150
;  :arith-offset-eqs        2
;  :arith-pivots            189
;  :binary-propagations     11
;  :conflicts               119
;  :datatype-accessor-ax    214
;  :datatype-constructor-ax 1284
;  :datatype-occurs-check   481
;  :datatype-splits         808
;  :decisions               1340
;  :del-clause              1739
;  :final-checks            170
;  :interface-eqs           34
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3148
;  :mk-clause               1863
;  :num-allocs              4393668
;  :num-checks              222
;  :propagations            905
;  :quant-instantiations    389
;  :rlimit-count            210693
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6621
;  :arith-add-rows          88
;  :arith-assert-diseq      227
;  :arith-assert-lower      728
;  :arith-assert-upper      467
;  :arith-bound-prop        168
;  :arith-conflicts         17
;  :arith-eq-adapter        414
;  :arith-fixed-eqs         155
;  :arith-offset-eqs        2
;  :arith-pivots            193
;  :binary-propagations     11
;  :conflicts               120
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 1314
;  :datatype-occurs-check   495
;  :datatype-splits         832
;  :decisions               1376
;  :del-clause              1788
;  :final-checks            175
;  :interface-eqs           36
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3220
;  :mk-clause               1912
;  :num-allocs              4393668
;  :num-checks              223
;  :propagations            945
;  :quant-instantiations    397
;  :rlimit-count            212334
;  :time                    0.00)
; [then-branch: 46 | First:(Second:(Second:(Second:($t@52@05))))[0] < -1 | live]
; [else-branch: 46 | !(First:(Second:(Second:(Second:($t@52@05))))[0] < -1) | live]
(push) ; 9
; [then-branch: 46 | First:(Second:(Second:(Second:($t@52@05))))[0] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    0)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 46 | !(First:(Second:(Second:(Second:($t@52@05))))[0] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] - min_advance__31
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6621
;  :arith-add-rows          88
;  :arith-assert-diseq      227
;  :arith-assert-lower      730
;  :arith-assert-upper      467
;  :arith-bound-prop        168
;  :arith-conflicts         17
;  :arith-eq-adapter        414
;  :arith-fixed-eqs         155
;  :arith-offset-eqs        2
;  :arith-pivots            193
;  :binary-propagations     11
;  :conflicts               120
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 1314
;  :datatype-occurs-check   495
;  :datatype-splits         832
;  :decisions               1376
;  :del-clause              1788
;  :final-checks            175
;  :interface-eqs           36
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3220
;  :mk-clause               1912
;  :num-allocs              4393668
;  :num-checks              224
;  :propagations            947
;  :quant-instantiations    397
;  :rlimit-count            212497)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
; [eval] (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__31)
; [eval] diz.Main_event_state[1] < -1
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6621
;  :arith-add-rows          88
;  :arith-assert-diseq      227
;  :arith-assert-lower      730
;  :arith-assert-upper      467
;  :arith-bound-prop        168
;  :arith-conflicts         17
;  :arith-eq-adapter        414
;  :arith-fixed-eqs         155
;  :arith-offset-eqs        2
;  :arith-pivots            193
;  :binary-propagations     11
;  :conflicts               120
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 1314
;  :datatype-occurs-check   495
;  :datatype-splits         832
;  :decisions               1376
;  :del-clause              1788
;  :final-checks            175
;  :interface-eqs           36
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3220
;  :mk-clause               1912
;  :num-allocs              4393668
;  :num-checks              225
;  :propagations            947
;  :quant-instantiations    397
;  :rlimit-count            212512)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6777
;  :arith-add-rows          88
;  :arith-assert-diseq      242
;  :arith-assert-lower      748
;  :arith-assert-upper      486
;  :arith-bound-prop        172
;  :arith-conflicts         17
;  :arith-eq-adapter        429
;  :arith-fixed-eqs         160
;  :arith-offset-eqs        2
;  :arith-pivots            197
;  :binary-propagations     11
;  :conflicts               121
;  :datatype-accessor-ax    220
;  :datatype-constructor-ax 1344
;  :datatype-occurs-check   509
;  :datatype-splits         856
;  :decisions               1412
;  :del-clause              1833
;  :final-checks            180
;  :interface-eqs           38
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3291
;  :mk-clause               1957
;  :num-allocs              4393668
;  :num-checks              226
;  :propagations            985
;  :quant-instantiations    405
;  :rlimit-count            214172
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    1)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6932
;  :arith-add-rows          88
;  :arith-assert-diseq      257
;  :arith-assert-lower      767
;  :arith-assert-upper      505
;  :arith-bound-prop        176
;  :arith-conflicts         17
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         165
;  :arith-offset-eqs        2
;  :arith-pivots            201
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 1374
;  :datatype-occurs-check   523
;  :datatype-splits         880
;  :decisions               1448
;  :del-clause              1882
;  :final-checks            185
;  :interface-eqs           40
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3363
;  :mk-clause               2006
;  :num-allocs              4393668
;  :num-checks              227
;  :propagations            1025
;  :quant-instantiations    413
;  :rlimit-count            215817
;  :time                    0.00)
; [then-branch: 47 | First:(Second:(Second:(Second:($t@52@05))))[1] < -1 | live]
; [else-branch: 47 | !(First:(Second:(Second:(Second:($t@52@05))))[1] < -1) | live]
(push) ; 9
; [then-branch: 47 | First:(Second:(Second:(Second:($t@52@05))))[1] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    1)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 47 | !(First:(Second:(Second:(Second:($t@52@05))))[1] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] - min_advance__31
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6932
;  :arith-add-rows          88
;  :arith-assert-diseq      257
;  :arith-assert-lower      769
;  :arith-assert-upper      505
;  :arith-bound-prop        176
;  :arith-conflicts         17
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         165
;  :arith-offset-eqs        2
;  :arith-pivots            201
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 1374
;  :datatype-occurs-check   523
;  :datatype-splits         880
;  :decisions               1448
;  :del-clause              1882
;  :final-checks            185
;  :interface-eqs           40
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3363
;  :mk-clause               2006
;  :num-allocs              4393668
;  :num-checks              228
;  :propagations            1027
;  :quant-instantiations    413
;  :rlimit-count            215980)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
; [eval] (diz.Main_event_state[2] < -1 ? -3 : diz.Main_event_state[2] - min_advance__31)
; [eval] diz.Main_event_state[2] < -1
; [eval] diz.Main_event_state[2]
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6932
;  :arith-add-rows          88
;  :arith-assert-diseq      257
;  :arith-assert-lower      769
;  :arith-assert-upper      505
;  :arith-bound-prop        176
;  :arith-conflicts         17
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         165
;  :arith-offset-eqs        2
;  :arith-pivots            201
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 1374
;  :datatype-occurs-check   523
;  :datatype-splits         880
;  :decisions               1448
;  :del-clause              1882
;  :final-checks            185
;  :interface-eqs           40
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3363
;  :mk-clause               2006
;  :num-allocs              4393668
;  :num-checks              229
;  :propagations            1027
;  :quant-instantiations    413
;  :rlimit-count            215995)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7086
;  :arith-add-rows          88
;  :arith-assert-diseq      272
;  :arith-assert-lower      789
;  :arith-assert-upper      524
;  :arith-bound-prop        180
;  :arith-conflicts         17
;  :arith-eq-adapter        459
;  :arith-fixed-eqs         170
;  :arith-offset-eqs        2
;  :arith-pivots            205
;  :binary-propagations     11
;  :conflicts               123
;  :datatype-accessor-ax    226
;  :datatype-constructor-ax 1404
;  :datatype-occurs-check   537
;  :datatype-splits         904
;  :decisions               1484
;  :del-clause              1929
;  :final-checks            190
;  :interface-eqs           42
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3436
;  :mk-clause               2053
;  :num-allocs              4393668
;  :num-checks              230
;  :propagations            1066
;  :quant-instantiations    421
;  :rlimit-count            217657
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    2)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7240
;  :arith-add-rows          88
;  :arith-assert-diseq      287
;  :arith-assert-lower      809
;  :arith-assert-upper      543
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        474
;  :arith-fixed-eqs         175
;  :arith-offset-eqs        2
;  :arith-pivots            209
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              1980
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3509
;  :mk-clause               2104
;  :num-allocs              4393668
;  :num-checks              231
;  :propagations            1107
;  :quant-instantiations    429
;  :rlimit-count            219298
;  :time                    0.00)
; [then-branch: 48 | First:(Second:(Second:(Second:($t@52@05))))[2] < -1 | live]
; [else-branch: 48 | !(First:(Second:(Second:(Second:($t@52@05))))[2] < -1) | live]
(push) ; 9
; [then-branch: 48 | First:(Second:(Second:(Second:($t@52@05))))[2] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    2)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 48 | !(First:(Second:(Second:(Second:($t@52@05))))[2] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      2)
    (- 0 1))))
; [eval] diz.Main_event_state[2] - min_advance__31
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7240
;  :arith-add-rows          88
;  :arith-assert-diseq      287
;  :arith-assert-lower      811
;  :arith-assert-upper      543
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        474
;  :arith-fixed-eqs         175
;  :arith-offset-eqs        2
;  :arith-pivots            209
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              1980
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3509
;  :mk-clause               2104
;  :num-allocs              4393668
;  :num-checks              232
;  :propagations            1109
;  :quant-instantiations    429
;  :rlimit-count            219461)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (=
  (Seq_length
    (Seq_append
      (Seq_append
        (Seq_singleton (ite
          (<
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
              0)
            (- 0 1))
          (- 0 3)
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
            0)))
        (Seq_singleton (ite
          (<
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
              1)
            (- 0 1))
          (- 0 3)
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
            1))))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
            2)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
          2)))))
  3))
(declare-const __flatten_31__30@55@05 Seq<Int>)
(assert (Seq_equal
  __flatten_31__30@55@05
  (Seq_append
    (Seq_append
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
            0)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
          0)))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
            1)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
          1))))
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
          2)
        (- 0 1))
      (- 0 3)
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
        2))))))
; [exec]
; __flatten_30__29 := __flatten_31__30
; [exec]
; diz.Main_event_state := __flatten_30__29
; [exec]
; Main_wakeup_after_wait_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(push) ; 8
(assert (not (= (Seq_length __flatten_31__30@55@05) 3)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7246
;  :arith-add-rows          89
;  :arith-assert-diseq      287
;  :arith-assert-lower      814
;  :arith-assert-upper      545
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        478
;  :arith-fixed-eqs         176
;  :arith-offset-eqs        2
;  :arith-pivots            210
;  :binary-propagations     11
;  :conflicts               125
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              1980
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3541
;  :mk-clause               2131
;  :num-allocs              4393668
;  :num-checks              233
;  :propagations            1116
;  :quant-instantiations    433
;  :rlimit-count            220224)
(assert (= (Seq_length __flatten_31__30@55@05) 3))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@56@05 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 49 | 0 <= i@56@05 | live]
; [else-branch: 49 | !(0 <= i@56@05) | live]
(push) ; 10
; [then-branch: 49 | 0 <= i@56@05]
(assert (<= 0 i@56@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 49 | !(0 <= i@56@05)]
(assert (not (<= 0 i@56@05)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 50 | i@56@05 < |First:(Second:($t@52@05))| && 0 <= i@56@05 | live]
; [else-branch: 50 | !(i@56@05 < |First:(Second:($t@52@05))| && 0 <= i@56@05) | live]
(push) ; 10
; [then-branch: 50 | i@56@05 < |First:(Second:($t@52@05))| && 0 <= i@56@05]
(assert (and
  (<
    i@56@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
  (<= 0 i@56@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@56@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7247
;  :arith-add-rows          89
;  :arith-assert-diseq      287
;  :arith-assert-lower      816
;  :arith-assert-upper      547
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        479
;  :arith-fixed-eqs         176
;  :arith-offset-eqs        2
;  :arith-pivots            210
;  :binary-propagations     11
;  :conflicts               125
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              1980
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3546
;  :mk-clause               2131
;  :num-allocs              4393668
;  :num-checks              234
;  :propagations            1116
;  :quant-instantiations    433
;  :rlimit-count            220411)
; [eval] -1
(push) ; 11
; [then-branch: 51 | First:(Second:($t@52@05))[i@56@05] == -1 | live]
; [else-branch: 51 | First:(Second:($t@52@05))[i@56@05] != -1 | live]
(push) ; 12
; [then-branch: 51 | First:(Second:($t@52@05))[i@56@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@56@05)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 51 | First:(Second:($t@52@05))[i@56@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      i@56@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@56@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7251
;  :arith-add-rows          89
;  :arith-assert-diseq      289
;  :arith-assert-lower      823
;  :arith-assert-upper      550
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        482
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               125
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              1980
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3561
;  :mk-clause               2142
;  :num-allocs              4393668
;  :num-checks              235
;  :propagations            1121
;  :quant-instantiations    436
;  :rlimit-count            220717)
(push) ; 13
; [then-branch: 52 | 0 <= First:(Second:($t@52@05))[i@56@05] | live]
; [else-branch: 52 | !(0 <= First:(Second:($t@52@05))[i@56@05]) | live]
(push) ; 14
; [then-branch: 52 | 0 <= First:(Second:($t@52@05))[i@56@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@56@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@56@05 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7251
;  :arith-add-rows          89
;  :arith-assert-diseq      289
;  :arith-assert-lower      823
;  :arith-assert-upper      550
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        482
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               125
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              1980
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3561
;  :mk-clause               2142
;  :num-allocs              4393668
;  :num-checks              236
;  :propagations            1121
;  :quant-instantiations    436
;  :rlimit-count            220811)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 52 | !(0 <= First:(Second:($t@52@05))[i@56@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      i@56@05))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 50 | !(i@56@05 < |First:(Second:($t@52@05))| && 0 <= i@56@05)]
(assert (not
  (and
    (<
      i@56@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
    (<= 0 i@56@05))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@56@05 Int)) (!
  (implies
    (and
      (<
        i@56@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
      (<= 0 i@56@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          i@56@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@56@05)
          (Seq_length __flatten_31__30@55@05))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@56@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@56@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7251
;  :arith-add-rows          89
;  :arith-assert-diseq      291
;  :arith-assert-lower      824
;  :arith-assert-upper      551
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        483
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            212
;  :binary-propagations     11
;  :conflicts               126
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              2011
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3573
;  :mk-clause               2162
;  :num-allocs              4393668
;  :num-checks              237
;  :propagations            1123
;  :quant-instantiations    439
;  :rlimit-count            221302)
(assert (forall ((i@56@05 Int)) (!
  (implies
    (and
      (<
        i@56@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
      (<= 0 i@56@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          i@56@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@56@05)
          (Seq_length __flatten_31__30@55@05))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@56@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@56@05))
  :qid |prog.l<no position>|)))
(declare-const $t@57@05 $Snap)
(assert (= $t@57@05 ($Snap.combine ($Snap.first $t@57@05) ($Snap.second $t@57@05))))
(assert (=
  ($Snap.second $t@57@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@57@05))
    ($Snap.second ($Snap.second $t@57@05)))))
(assert (=
  ($Snap.second ($Snap.second $t@57@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@57@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@57@05))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@57@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@58@05 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 53 | 0 <= i@58@05 | live]
; [else-branch: 53 | !(0 <= i@58@05) | live]
(push) ; 10
; [then-branch: 53 | 0 <= i@58@05]
(assert (<= 0 i@58@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 53 | !(0 <= i@58@05)]
(assert (not (<= 0 i@58@05)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 54 | i@58@05 < |First:(Second:($t@57@05))| && 0 <= i@58@05 | live]
; [else-branch: 54 | !(i@58@05 < |First:(Second:($t@57@05))| && 0 <= i@58@05) | live]
(push) ; 10
; [then-branch: 54 | i@58@05 < |First:(Second:($t@57@05))| && 0 <= i@58@05]
(assert (and
  (<
    i@58@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))
  (<= 0 i@58@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@58@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7288
;  :arith-add-rows          89
;  :arith-assert-diseq      291
;  :arith-assert-lower      829
;  :arith-assert-upper      554
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        485
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            212
;  :binary-propagations     11
;  :conflicts               126
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              2011
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3595
;  :mk-clause               2162
;  :num-allocs              4393668
;  :num-checks              238
;  :propagations            1123
;  :quant-instantiations    445
;  :rlimit-count            222741)
; [eval] -1
(push) ; 11
; [then-branch: 55 | First:(Second:($t@57@05))[i@58@05] == -1 | live]
; [else-branch: 55 | First:(Second:($t@57@05))[i@58@05] != -1 | live]
(push) ; 12
; [then-branch: 55 | First:(Second:($t@57@05))[i@58@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
    i@58@05)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 55 | First:(Second:($t@57@05))[i@58@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
      i@58@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@58@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7288
;  :arith-add-rows          89
;  :arith-assert-diseq      291
;  :arith-assert-lower      829
;  :arith-assert-upper      554
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        485
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            212
;  :binary-propagations     11
;  :conflicts               126
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              2011
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3596
;  :mk-clause               2162
;  :num-allocs              4393668
;  :num-checks              239
;  :propagations            1123
;  :quant-instantiations    445
;  :rlimit-count            222892)
(push) ; 13
; [then-branch: 56 | 0 <= First:(Second:($t@57@05))[i@58@05] | live]
; [else-branch: 56 | !(0 <= First:(Second:($t@57@05))[i@58@05]) | live]
(push) ; 14
; [then-branch: 56 | 0 <= First:(Second:($t@57@05))[i@58@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
    i@58@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@58@05 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7288
;  :arith-add-rows          89
;  :arith-assert-diseq      292
;  :arith-assert-lower      832
;  :arith-assert-upper      554
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            212
;  :binary-propagations     11
;  :conflicts               126
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              2011
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3599
;  :mk-clause               2163
;  :num-allocs              4393668
;  :num-checks              240
;  :propagations            1123
;  :quant-instantiations    445
;  :rlimit-count            222996)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 56 | !(0 <= First:(Second:($t@57@05))[i@58@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
      i@58@05))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 54 | !(i@58@05 < |First:(Second:($t@57@05))| && 0 <= i@58@05)]
(assert (not
  (and
    (<
      i@58@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))
    (<= 0 i@58@05))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@58@05 Int)) (!
  (implies
    (and
      (<
        i@58@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))
      (<= 0 i@58@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
          i@58@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
            i@58@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
            i@58@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
    i@58@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
  __flatten_31__30@55@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1) ==> diz.Main_process_state[0] == -1
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7309
;  :arith-add-rows          89
;  :arith-assert-diseq      292
;  :arith-assert-lower      833
;  :arith-assert-upper      555
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        488
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            212
;  :binary-propagations     11
;  :conflicts               126
;  :datatype-accessor-ax    237
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              2012
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3623
;  :mk-clause               2179
;  :num-allocs              4393668
;  :num-checks              241
;  :propagations            1129
;  :quant-instantiations    447
;  :rlimit-count            224031)
(push) ; 8
; [then-branch: 57 | 0 <= First:(Second:($t@52@05))[0] | live]
; [else-branch: 57 | !(0 <= First:(Second:($t@52@05))[0]) | live]
(push) ; 9
; [then-branch: 57 | 0 <= First:(Second:($t@52@05))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7309
;  :arith-add-rows          89
;  :arith-assert-diseq      292
;  :arith-assert-lower      833
;  :arith-assert-upper      555
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        488
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            212
;  :binary-propagations     11
;  :conflicts               126
;  :datatype-accessor-ax    237
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              2012
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3623
;  :mk-clause               2179
;  :num-allocs              4393668
;  :num-checks              242
;  :propagations            1129
;  :quant-instantiations    447
;  :rlimit-count            224131)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7309
;  :arith-add-rows          89
;  :arith-assert-diseq      292
;  :arith-assert-lower      833
;  :arith-assert-upper      555
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        488
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            212
;  :binary-propagations     11
;  :conflicts               126
;  :datatype-accessor-ax    237
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              2012
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3623
;  :mk-clause               2179
;  :num-allocs              4393668
;  :num-checks              243
;  :propagations            1129
;  :quant-instantiations    447
;  :rlimit-count            224140)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  (Seq_length __flatten_31__30@55@05))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7309
;  :arith-add-rows          89
;  :arith-assert-diseq      292
;  :arith-assert-lower      833
;  :arith-assert-upper      555
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        488
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            212
;  :binary-propagations     11
;  :conflicts               127
;  :datatype-accessor-ax    237
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              2012
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3623
;  :mk-clause               2179
;  :num-allocs              4393668
;  :num-checks              244
;  :propagations            1129
;  :quant-instantiations    447
;  :rlimit-count            224228)
(push) ; 10
; [then-branch: 58 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0 | live]
; [else-branch: 58 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] != 0 | live]
(push) ; 11
; [then-branch: 58 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@55@05
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 58 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@55@05
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 12
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7310
;  :arith-add-rows          90
;  :arith-assert-diseq      292
;  :arith-assert-lower      833
;  :arith-assert-upper      555
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        488
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            212
;  :binary-propagations     11
;  :conflicts               127
;  :datatype-accessor-ax    237
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              2012
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3628
;  :mk-clause               2184
;  :num-allocs              4393668
;  :num-checks              245
;  :propagations            1129
;  :quant-instantiations    448
;  :rlimit-count            224443)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7310
;  :arith-add-rows          90
;  :arith-assert-diseq      292
;  :arith-assert-lower      833
;  :arith-assert-upper      555
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        488
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            212
;  :binary-propagations     11
;  :conflicts               127
;  :datatype-accessor-ax    237
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              2012
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3628
;  :mk-clause               2184
;  :num-allocs              4393668
;  :num-checks              246
;  :propagations            1129
;  :quant-instantiations    448
;  :rlimit-count            224452)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  (Seq_length __flatten_31__30@55@05))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7310
;  :arith-add-rows          90
;  :arith-assert-diseq      292
;  :arith-assert-lower      833
;  :arith-assert-upper      555
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        488
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            212
;  :binary-propagations     11
;  :conflicts               128
;  :datatype-accessor-ax    237
;  :datatype-constructor-ax 1434
;  :datatype-occurs-check   551
;  :datatype-splits         928
;  :decisions               1520
;  :del-clause              2012
;  :final-checks            195
;  :interface-eqs           44
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3628
;  :mk-clause               2184
;  :num-allocs              4393668
;  :num-checks              247
;  :propagations            1129
;  :quant-instantiations    448
;  :rlimit-count            224540)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 57 | !(0 <= First:(Second:($t@52@05))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8436
;  :arith-add-rows          191
;  :arith-assert-diseq      360
;  :arith-assert-lower      997
;  :arith-assert-upper      676
;  :arith-bound-prop        198
;  :arith-conflicts         21
;  :arith-eq-adapter        601
;  :arith-fixed-eqs         237
;  :arith-offset-eqs        16
;  :arith-pivots            286
;  :binary-propagations     11
;  :conflicts               145
;  :datatype-accessor-ax    262
;  :datatype-constructor-ax 1620
;  :datatype-occurs-check   614
;  :datatype-splits         1062
;  :decisions               1715
;  :del-clause              2411
;  :final-checks            214
;  :interface-eqs           54
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          55
;  :mk-bool-var             4312
;  :mk-clause               2578
;  :num-allocs              4983423
;  :num-checks              248
;  :propagations            1349
;  :quant-instantiations    539
;  :rlimit-count            233257
;  :time                    0.01)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8854
;  :arith-add-rows          228
;  :arith-assert-diseq      393
;  :arith-assert-lower      1060
;  :arith-assert-upper      738
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        653
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            310
;  :binary-propagations     11
;  :conflicts               152
;  :datatype-accessor-ax    266
;  :datatype-constructor-ax 1673
;  :datatype-occurs-check   636
;  :datatype-splits         1092
;  :decisions               1787
;  :del-clause              2587
;  :final-checks            221
;  :interface-eqs           58
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4576
;  :mk-clause               2754
;  :num-allocs              4983423
;  :num-checks              249
;  :propagations            1453
;  :quant-instantiations    585
;  :rlimit-count            237510
;  :time                    0.00)
; [then-branch: 59 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0] | live]
; [else-branch: 59 | !(__flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0]) | live]
(push) ; 9
; [then-branch: 59 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8854
;  :arith-add-rows          228
;  :arith-assert-diseq      393
;  :arith-assert-lower      1060
;  :arith-assert-upper      738
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        653
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            310
;  :binary-propagations     11
;  :conflicts               152
;  :datatype-accessor-ax    266
;  :datatype-constructor-ax 1673
;  :datatype-occurs-check   636
;  :datatype-splits         1092
;  :decisions               1787
;  :del-clause              2587
;  :final-checks            221
;  :interface-eqs           58
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4578
;  :mk-clause               2755
;  :num-allocs              4983423
;  :num-checks              250
;  :propagations            1453
;  :quant-instantiations    585
;  :rlimit-count            237678)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 59 | !(__flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1) ==> diz.Main_process_state[1] == -1
; [eval] 0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[1])
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8860
;  :arith-add-rows          228
;  :arith-assert-diseq      393
;  :arith-assert-lower      1060
;  :arith-assert-upper      738
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        653
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            310
;  :binary-propagations     11
;  :conflicts               152
;  :datatype-accessor-ax    267
;  :datatype-constructor-ax 1673
;  :datatype-occurs-check   636
;  :datatype-splits         1092
;  :decisions               1787
;  :del-clause              2588
;  :final-checks            221
;  :interface-eqs           58
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4584
;  :mk-clause               2759
;  :num-allocs              4983423
;  :num-checks              251
;  :propagations            1453
;  :quant-instantiations    585
;  :rlimit-count            238157)
(push) ; 8
; [then-branch: 60 | 0 <= First:(Second:($t@52@05))[1] | live]
; [else-branch: 60 | !(0 <= First:(Second:($t@52@05))[1]) | live]
(push) ; 9
; [then-branch: 60 | 0 <= First:(Second:($t@52@05))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8860
;  :arith-add-rows          228
;  :arith-assert-diseq      393
;  :arith-assert-lower      1060
;  :arith-assert-upper      738
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        653
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            310
;  :binary-propagations     11
;  :conflicts               152
;  :datatype-accessor-ax    267
;  :datatype-constructor-ax 1673
;  :datatype-occurs-check   636
;  :datatype-splits         1092
;  :decisions               1787
;  :del-clause              2588
;  :final-checks            221
;  :interface-eqs           58
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4584
;  :mk-clause               2759
;  :num-allocs              4983423
;  :num-checks              252
;  :propagations            1453
;  :quant-instantiations    585
;  :rlimit-count            238257)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8860
;  :arith-add-rows          228
;  :arith-assert-diseq      393
;  :arith-assert-lower      1060
;  :arith-assert-upper      738
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        653
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            310
;  :binary-propagations     11
;  :conflicts               152
;  :datatype-accessor-ax    267
;  :datatype-constructor-ax 1673
;  :datatype-occurs-check   636
;  :datatype-splits         1092
;  :decisions               1787
;  :del-clause              2588
;  :final-checks            221
;  :interface-eqs           58
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4584
;  :mk-clause               2759
;  :num-allocs              4983423
;  :num-checks              253
;  :propagations            1453
;  :quant-instantiations    585
;  :rlimit-count            238266)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  (Seq_length __flatten_31__30@55@05))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8860
;  :arith-add-rows          228
;  :arith-assert-diseq      393
;  :arith-assert-lower      1060
;  :arith-assert-upper      738
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        653
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            310
;  :binary-propagations     11
;  :conflicts               153
;  :datatype-accessor-ax    267
;  :datatype-constructor-ax 1673
;  :datatype-occurs-check   636
;  :datatype-splits         1092
;  :decisions               1787
;  :del-clause              2588
;  :final-checks            221
;  :interface-eqs           58
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4584
;  :mk-clause               2759
;  :num-allocs              4983423
;  :num-checks              254
;  :propagations            1453
;  :quant-instantiations    585
;  :rlimit-count            238354)
(push) ; 10
; [then-branch: 61 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0 | live]
; [else-branch: 61 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] != 0 | live]
(push) ; 11
; [then-branch: 61 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@55@05
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 61 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@55@05
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 12
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8861
;  :arith-add-rows          230
;  :arith-assert-diseq      393
;  :arith-assert-lower      1060
;  :arith-assert-upper      738
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        653
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            310
;  :binary-propagations     11
;  :conflicts               153
;  :datatype-accessor-ax    267
;  :datatype-constructor-ax 1673
;  :datatype-occurs-check   636
;  :datatype-splits         1092
;  :decisions               1787
;  :del-clause              2588
;  :final-checks            221
;  :interface-eqs           58
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4589
;  :mk-clause               2764
;  :num-allocs              4983423
;  :num-checks              255
;  :propagations            1453
;  :quant-instantiations    586
;  :rlimit-count            238528)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8861
;  :arith-add-rows          230
;  :arith-assert-diseq      393
;  :arith-assert-lower      1060
;  :arith-assert-upper      738
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        653
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            310
;  :binary-propagations     11
;  :conflicts               153
;  :datatype-accessor-ax    267
;  :datatype-constructor-ax 1673
;  :datatype-occurs-check   636
;  :datatype-splits         1092
;  :decisions               1787
;  :del-clause              2588
;  :final-checks            221
;  :interface-eqs           58
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4589
;  :mk-clause               2764
;  :num-allocs              4983423
;  :num-checks              256
;  :propagations            1453
;  :quant-instantiations    586
;  :rlimit-count            238537)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  (Seq_length __flatten_31__30@55@05))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8861
;  :arith-add-rows          230
;  :arith-assert-diseq      393
;  :arith-assert-lower      1060
;  :arith-assert-upper      738
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        653
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            310
;  :binary-propagations     11
;  :conflicts               154
;  :datatype-accessor-ax    267
;  :datatype-constructor-ax 1673
;  :datatype-occurs-check   636
;  :datatype-splits         1092
;  :decisions               1787
;  :del-clause              2588
;  :final-checks            221
;  :interface-eqs           58
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4589
;  :mk-clause               2764
;  :num-allocs              4983423
;  :num-checks              257
;  :propagations            1453
;  :quant-instantiations    586
;  :rlimit-count            238625)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 60 | !(0 <= First:(Second:($t@52@05))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10058
;  :arith-add-rows          385
;  :arith-assert-diseq      471
;  :arith-assert-lower      1247
;  :arith-assert-upper      857
;  :arith-bound-prop        228
;  :arith-conflicts         30
;  :arith-eq-adapter        773
;  :arith-fixed-eqs         321
;  :arith-offset-eqs        37
;  :arith-pivots            388
;  :binary-propagations     11
;  :conflicts               179
;  :datatype-accessor-ax    296
;  :datatype-constructor-ax 1883
;  :datatype-occurs-check   716
;  :datatype-splits         1246
;  :decisions               2015
;  :del-clause              3041
;  :final-checks            240
;  :interface-eqs           68
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          137
;  :mk-bool-var             5309
;  :mk-clause               3212
;  :num-allocs              4983423
;  :num-checks              258
;  :propagations            1715
;  :quant-instantiations    683
;  :rlimit-count            248603
;  :time                    0.01)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10857
;  :arith-add-rows          475
;  :arith-assert-diseq      524
;  :arith-assert-lower      1360
;  :arith-assert-upper      951
;  :arith-bound-prop        240
;  :arith-conflicts         33
;  :arith-eq-adapter        858
;  :arith-fixed-eqs         371
;  :arith-offset-eqs        58
;  :arith-pivots            428
;  :binary-propagations     11
;  :conflicts               190
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 1994
;  :datatype-occurs-check   762
;  :datatype-splits         1334
;  :decisions               2147
;  :del-clause              3336
;  :final-checks            251
;  :interface-eqs           73
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          156
;  :mk-bool-var             5833
;  :mk-clause               3507
;  :num-allocs              4983423
;  :num-checks              259
;  :propagations            1883
;  :quant-instantiations    760
;  :rlimit-count            255492
;  :time                    0.01)
; [then-branch: 62 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1] | live]
; [else-branch: 62 | !(__flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1]) | live]
(push) ; 9
; [then-branch: 62 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10857
;  :arith-add-rows          475
;  :arith-assert-diseq      524
;  :arith-assert-lower      1360
;  :arith-assert-upper      951
;  :arith-bound-prop        240
;  :arith-conflicts         33
;  :arith-eq-adapter        858
;  :arith-fixed-eqs         371
;  :arith-offset-eqs        58
;  :arith-pivots            428
;  :binary-propagations     11
;  :conflicts               190
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 1994
;  :datatype-occurs-check   762
;  :datatype-splits         1334
;  :decisions               2147
;  :del-clause              3336
;  :final-checks            251
;  :interface-eqs           73
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          156
;  :mk-bool-var             5835
;  :mk-clause               3508
;  :num-allocs              4983423
;  :num-checks              260
;  :propagations            1883
;  :quant-instantiations    760
;  :rlimit-count            255660)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 62 | !(__flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
      1)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)) ==> diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] !(0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1))
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10863
;  :arith-add-rows          475
;  :arith-assert-diseq      524
;  :arith-assert-lower      1360
;  :arith-assert-upper      951
;  :arith-bound-prop        240
;  :arith-conflicts         33
;  :arith-eq-adapter        858
;  :arith-fixed-eqs         371
;  :arith-offset-eqs        58
;  :arith-pivots            428
;  :binary-propagations     11
;  :conflicts               190
;  :datatype-accessor-ax    309
;  :datatype-constructor-ax 1994
;  :datatype-occurs-check   762
;  :datatype-splits         1334
;  :decisions               2147
;  :del-clause              3337
;  :final-checks            251
;  :interface-eqs           73
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          156
;  :mk-bool-var             5841
;  :mk-clause               3512
;  :num-allocs              4983423
;  :num-checks              261
;  :propagations            1883
;  :quant-instantiations    760
;  :rlimit-count            256149)
(push) ; 8
; [then-branch: 63 | 0 <= First:(Second:($t@52@05))[0] | live]
; [else-branch: 63 | !(0 <= First:(Second:($t@52@05))[0]) | live]
(push) ; 9
; [then-branch: 63 | 0 <= First:(Second:($t@52@05))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10863
;  :arith-add-rows          475
;  :arith-assert-diseq      524
;  :arith-assert-lower      1360
;  :arith-assert-upper      951
;  :arith-bound-prop        240
;  :arith-conflicts         33
;  :arith-eq-adapter        858
;  :arith-fixed-eqs         371
;  :arith-offset-eqs        58
;  :arith-pivots            428
;  :binary-propagations     11
;  :conflicts               190
;  :datatype-accessor-ax    309
;  :datatype-constructor-ax 1994
;  :datatype-occurs-check   762
;  :datatype-splits         1334
;  :decisions               2147
;  :del-clause              3337
;  :final-checks            251
;  :interface-eqs           73
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          156
;  :mk-bool-var             5841
;  :mk-clause               3512
;  :num-allocs              4983423
;  :num-checks              262
;  :propagations            1883
;  :quant-instantiations    760
;  :rlimit-count            256249)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10863
;  :arith-add-rows          475
;  :arith-assert-diseq      524
;  :arith-assert-lower      1360
;  :arith-assert-upper      951
;  :arith-bound-prop        240
;  :arith-conflicts         33
;  :arith-eq-adapter        858
;  :arith-fixed-eqs         371
;  :arith-offset-eqs        58
;  :arith-pivots            428
;  :binary-propagations     11
;  :conflicts               190
;  :datatype-accessor-ax    309
;  :datatype-constructor-ax 1994
;  :datatype-occurs-check   762
;  :datatype-splits         1334
;  :decisions               2147
;  :del-clause              3337
;  :final-checks            251
;  :interface-eqs           73
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          156
;  :mk-bool-var             5841
;  :mk-clause               3512
;  :num-allocs              4983423
;  :num-checks              263
;  :propagations            1883
;  :quant-instantiations    760
;  :rlimit-count            256258)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  (Seq_length __flatten_31__30@55@05))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10863
;  :arith-add-rows          475
;  :arith-assert-diseq      524
;  :arith-assert-lower      1360
;  :arith-assert-upper      951
;  :arith-bound-prop        240
;  :arith-conflicts         33
;  :arith-eq-adapter        858
;  :arith-fixed-eqs         371
;  :arith-offset-eqs        58
;  :arith-pivots            428
;  :binary-propagations     11
;  :conflicts               191
;  :datatype-accessor-ax    309
;  :datatype-constructor-ax 1994
;  :datatype-occurs-check   762
;  :datatype-splits         1334
;  :decisions               2147
;  :del-clause              3337
;  :final-checks            251
;  :interface-eqs           73
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          156
;  :mk-bool-var             5841
;  :mk-clause               3512
;  :num-allocs              4983423
;  :num-checks              264
;  :propagations            1883
;  :quant-instantiations    760
;  :rlimit-count            256346)
(push) ; 10
; [then-branch: 64 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0 | live]
; [else-branch: 64 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] != 0 | live]
(push) ; 11
; [then-branch: 64 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@55@05
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 64 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@55@05
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 12
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10864
;  :arith-add-rows          477
;  :arith-assert-diseq      524
;  :arith-assert-lower      1360
;  :arith-assert-upper      951
;  :arith-bound-prop        240
;  :arith-conflicts         33
;  :arith-eq-adapter        858
;  :arith-fixed-eqs         371
;  :arith-offset-eqs        58
;  :arith-pivots            428
;  :binary-propagations     11
;  :conflicts               191
;  :datatype-accessor-ax    309
;  :datatype-constructor-ax 1994
;  :datatype-occurs-check   762
;  :datatype-splits         1334
;  :decisions               2147
;  :del-clause              3337
;  :final-checks            251
;  :interface-eqs           73
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          156
;  :mk-bool-var             5845
;  :mk-clause               3517
;  :num-allocs              4983423
;  :num-checks              265
;  :propagations            1883
;  :quant-instantiations    761
;  :rlimit-count            256502)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10864
;  :arith-add-rows          477
;  :arith-assert-diseq      524
;  :arith-assert-lower      1360
;  :arith-assert-upper      951
;  :arith-bound-prop        240
;  :arith-conflicts         33
;  :arith-eq-adapter        858
;  :arith-fixed-eqs         371
;  :arith-offset-eqs        58
;  :arith-pivots            428
;  :binary-propagations     11
;  :conflicts               191
;  :datatype-accessor-ax    309
;  :datatype-constructor-ax 1994
;  :datatype-occurs-check   762
;  :datatype-splits         1334
;  :decisions               2147
;  :del-clause              3337
;  :final-checks            251
;  :interface-eqs           73
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          156
;  :mk-bool-var             5845
;  :mk-clause               3517
;  :num-allocs              4983423
;  :num-checks              266
;  :propagations            1883
;  :quant-instantiations    761
;  :rlimit-count            256511)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  (Seq_length __flatten_31__30@55@05))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10864
;  :arith-add-rows          477
;  :arith-assert-diseq      524
;  :arith-assert-lower      1360
;  :arith-assert-upper      951
;  :arith-bound-prop        240
;  :arith-conflicts         33
;  :arith-eq-adapter        858
;  :arith-fixed-eqs         371
;  :arith-offset-eqs        58
;  :arith-pivots            428
;  :binary-propagations     11
;  :conflicts               192
;  :datatype-accessor-ax    309
;  :datatype-constructor-ax 1994
;  :datatype-occurs-check   762
;  :datatype-splits         1334
;  :decisions               2147
;  :del-clause              3337
;  :final-checks            251
;  :interface-eqs           73
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          156
;  :mk-bool-var             5845
;  :mk-clause               3517
;  :num-allocs              4983423
;  :num-checks              267
;  :propagations            1883
;  :quant-instantiations    761
;  :rlimit-count            256599)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 63 | !(0 <= First:(Second:($t@52@05))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11675
;  :arith-add-rows          560
;  :arith-assert-diseq      579
;  :arith-assert-lower      1472
;  :arith-assert-upper      1047
;  :arith-bound-prop        251
;  :arith-conflicts         36
;  :arith-eq-adapter        945
;  :arith-fixed-eqs         421
;  :arith-offset-eqs        79
;  :arith-pivots            472
;  :binary-propagations     11
;  :conflicts               203
;  :datatype-accessor-ax    321
;  :datatype-constructor-ax 2105
;  :datatype-occurs-check   806
;  :datatype-splits         1422
;  :decisions               2280
;  :del-clause              3631
;  :final-checks            263
;  :interface-eqs           79
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          175
;  :mk-bool-var             6361
;  :mk-clause               3806
;  :num-allocs              4983423
;  :num-checks              268
;  :propagations            2044
;  :quant-instantiations    836
;  :rlimit-count            263522
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12867
;  :arith-add-rows          696
;  :arith-assert-diseq      646
;  :arith-assert-lower      1598
;  :arith-assert-upper      1150
;  :arith-bound-prop        273
;  :arith-conflicts         41
;  :arith-eq-adapter        1033
;  :arith-fixed-eqs         473
;  :arith-offset-eqs        99
;  :arith-pivots            523
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 2304
;  :datatype-occurs-check   877
;  :datatype-splits         1586
;  :decisions               2497
;  :del-clause              3989
;  :final-checks            284
;  :interface-eqs           90
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          253
;  :mk-bool-var             6984
;  :mk-clause               4164
;  :num-allocs              4983423
;  :num-checks              269
;  :propagations            2286
;  :quant-instantiations    919
;  :rlimit-count            272900
;  :time                    0.01)
; [then-branch: 65 | !(__flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0]) | live]
; [else-branch: 65 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0] | live]
(push) ; 9
; [then-branch: 65 | !(__flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12868
;  :arith-add-rows          698
;  :arith-assert-diseq      646
;  :arith-assert-lower      1598
;  :arith-assert-upper      1150
;  :arith-bound-prop        273
;  :arith-conflicts         41
;  :arith-eq-adapter        1033
;  :arith-fixed-eqs         473
;  :arith-offset-eqs        99
;  :arith-pivots            523
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 2304
;  :datatype-occurs-check   877
;  :datatype-splits         1586
;  :decisions               2497
;  :del-clause              3989
;  :final-checks            284
;  :interface-eqs           90
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          253
;  :mk-bool-var             6988
;  :mk-clause               4169
;  :num-allocs              4983423
;  :num-checks              270
;  :propagations            2288
;  :quant-instantiations    920
;  :rlimit-count            273086)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12868
;  :arith-add-rows          698
;  :arith-assert-diseq      646
;  :arith-assert-lower      1598
;  :arith-assert-upper      1150
;  :arith-bound-prop        273
;  :arith-conflicts         41
;  :arith-eq-adapter        1033
;  :arith-fixed-eqs         473
;  :arith-offset-eqs        99
;  :arith-pivots            523
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 2304
;  :datatype-occurs-check   877
;  :datatype-splits         1586
;  :decisions               2497
;  :del-clause              3989
;  :final-checks            284
;  :interface-eqs           90
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          253
;  :mk-bool-var             6988
;  :mk-clause               4169
;  :num-allocs              4983423
;  :num-checks              271
;  :propagations            2288
;  :quant-instantiations    920
;  :rlimit-count            273101)
(pop) ; 9
(push) ; 9
; [else-branch: 65 | __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (or
        (=
          (Seq_index
            __flatten_31__30@55@05
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
              0))
          0)
        (=
          (Seq_index
            __flatten_31__30@55@05
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@05))))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1)) ==> diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] !(0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1))
; [eval] 0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[1])
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12875
;  :arith-add-rows          698
;  :arith-assert-diseq      646
;  :arith-assert-lower      1598
;  :arith-assert-upper      1150
;  :arith-bound-prop        273
;  :arith-conflicts         41
;  :arith-eq-adapter        1033
;  :arith-fixed-eqs         473
;  :arith-offset-eqs        99
;  :arith-pivots            523
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 2304
;  :datatype-occurs-check   877
;  :datatype-splits         1586
;  :decisions               2497
;  :del-clause              3994
;  :final-checks            284
;  :interface-eqs           90
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          253
;  :mk-bool-var             6991
;  :mk-clause               4172
;  :num-allocs              4983423
;  :num-checks              272
;  :propagations            2288
;  :quant-instantiations    920
;  :rlimit-count            273489)
(push) ; 8
; [then-branch: 66 | 0 <= First:(Second:($t@52@05))[1] | live]
; [else-branch: 66 | !(0 <= First:(Second:($t@52@05))[1]) | live]
(push) ; 9
; [then-branch: 66 | 0 <= First:(Second:($t@52@05))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12875
;  :arith-add-rows          698
;  :arith-assert-diseq      646
;  :arith-assert-lower      1598
;  :arith-assert-upper      1150
;  :arith-bound-prop        273
;  :arith-conflicts         41
;  :arith-eq-adapter        1033
;  :arith-fixed-eqs         473
;  :arith-offset-eqs        99
;  :arith-pivots            523
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 2304
;  :datatype-occurs-check   877
;  :datatype-splits         1586
;  :decisions               2497
;  :del-clause              3994
;  :final-checks            284
;  :interface-eqs           90
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          253
;  :mk-bool-var             6991
;  :mk-clause               4172
;  :num-allocs              4983423
;  :num-checks              273
;  :propagations            2288
;  :quant-instantiations    920
;  :rlimit-count            273589)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12875
;  :arith-add-rows          698
;  :arith-assert-diseq      646
;  :arith-assert-lower      1598
;  :arith-assert-upper      1150
;  :arith-bound-prop        273
;  :arith-conflicts         41
;  :arith-eq-adapter        1033
;  :arith-fixed-eqs         473
;  :arith-offset-eqs        99
;  :arith-pivots            523
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 2304
;  :datatype-occurs-check   877
;  :datatype-splits         1586
;  :decisions               2497
;  :del-clause              3994
;  :final-checks            284
;  :interface-eqs           90
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          253
;  :mk-bool-var             6991
;  :mk-clause               4172
;  :num-allocs              4983423
;  :num-checks              274
;  :propagations            2288
;  :quant-instantiations    920
;  :rlimit-count            273598)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  (Seq_length __flatten_31__30@55@05))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12875
;  :arith-add-rows          698
;  :arith-assert-diseq      646
;  :arith-assert-lower      1598
;  :arith-assert-upper      1150
;  :arith-bound-prop        273
;  :arith-conflicts         41
;  :arith-eq-adapter        1033
;  :arith-fixed-eqs         473
;  :arith-offset-eqs        99
;  :arith-pivots            523
;  :binary-propagations     11
;  :conflicts               227
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 2304
;  :datatype-occurs-check   877
;  :datatype-splits         1586
;  :decisions               2497
;  :del-clause              3994
;  :final-checks            284
;  :interface-eqs           90
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          253
;  :mk-bool-var             6991
;  :mk-clause               4172
;  :num-allocs              4983423
;  :num-checks              275
;  :propagations            2288
;  :quant-instantiations    920
;  :rlimit-count            273686)
(push) ; 10
; [then-branch: 67 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0 | live]
; [else-branch: 67 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] != 0 | live]
(push) ; 11
; [then-branch: 67 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@55@05
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 67 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@55@05
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 12
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12876
;  :arith-add-rows          700
;  :arith-assert-diseq      646
;  :arith-assert-lower      1598
;  :arith-assert-upper      1150
;  :arith-bound-prop        273
;  :arith-conflicts         41
;  :arith-eq-adapter        1033
;  :arith-fixed-eqs         473
;  :arith-offset-eqs        99
;  :arith-pivots            523
;  :binary-propagations     11
;  :conflicts               227
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 2304
;  :datatype-occurs-check   877
;  :datatype-splits         1586
;  :decisions               2497
;  :del-clause              3994
;  :final-checks            284
;  :interface-eqs           90
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          253
;  :mk-bool-var             6995
;  :mk-clause               4177
;  :num-allocs              4983423
;  :num-checks              276
;  :propagations            2288
;  :quant-instantiations    921
;  :rlimit-count            273842)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12876
;  :arith-add-rows          700
;  :arith-assert-diseq      646
;  :arith-assert-lower      1598
;  :arith-assert-upper      1150
;  :arith-bound-prop        273
;  :arith-conflicts         41
;  :arith-eq-adapter        1033
;  :arith-fixed-eqs         473
;  :arith-offset-eqs        99
;  :arith-pivots            523
;  :binary-propagations     11
;  :conflicts               227
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 2304
;  :datatype-occurs-check   877
;  :datatype-splits         1586
;  :decisions               2497
;  :del-clause              3994
;  :final-checks            284
;  :interface-eqs           90
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          253
;  :mk-bool-var             6995
;  :mk-clause               4177
;  :num-allocs              4983423
;  :num-checks              277
;  :propagations            2288
;  :quant-instantiations    921
;  :rlimit-count            273851)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  (Seq_length __flatten_31__30@55@05))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12876
;  :arith-add-rows          700
;  :arith-assert-diseq      646
;  :arith-assert-lower      1598
;  :arith-assert-upper      1150
;  :arith-bound-prop        273
;  :arith-conflicts         41
;  :arith-eq-adapter        1033
;  :arith-fixed-eqs         473
;  :arith-offset-eqs        99
;  :arith-pivots            523
;  :binary-propagations     11
;  :conflicts               228
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 2304
;  :datatype-occurs-check   877
;  :datatype-splits         1586
;  :decisions               2497
;  :del-clause              3994
;  :final-checks            284
;  :interface-eqs           90
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          253
;  :mk-bool-var             6995
;  :mk-clause               4177
;  :num-allocs              4983423
;  :num-checks              278
;  :propagations            2288
;  :quant-instantiations    921
;  :rlimit-count            273939)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 66 | !(0 <= First:(Second:($t@52@05))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13666
;  :arith-add-rows          782
;  :arith-assert-diseq      698
;  :arith-assert-lower      1708
;  :arith-assert-upper      1243
;  :arith-bound-prop        285
;  :arith-conflicts         44
;  :arith-eq-adapter        1117
;  :arith-fixed-eqs         523
;  :arith-offset-eqs        120
;  :arith-pivots            559
;  :binary-propagations     11
;  :conflicts               239
;  :datatype-accessor-ax    367
;  :datatype-constructor-ax 2412
;  :datatype-occurs-check   921
;  :datatype-splits         1671
;  :decisions               2627
;  :del-clause              4284
;  :final-checks            296
;  :interface-eqs           96
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          272
;  :mk-bool-var             7505
;  :mk-clause               4462
;  :num-allocs              5200926
;  :num-checks              279
;  :propagations            2457
;  :quant-instantiations    997
;  :rlimit-count            280669
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15375
;  :arith-add-rows          959
;  :arith-assert-diseq      791
;  :arith-assert-lower      1887
;  :arith-assert-upper      1372
;  :arith-bound-prop        307
;  :arith-conflicts         52
;  :arith-eq-adapter        1241
;  :arith-fixed-eqs         602
;  :arith-offset-eqs        148
;  :arith-pivots            624
;  :binary-propagations     11
;  :conflicts               269
;  :datatype-accessor-ax    426
;  :datatype-constructor-ax 2727
;  :datatype-occurs-check   1072
;  :datatype-splits         1912
;  :decisions               2936
;  :del-clause              4729
;  :final-checks            324
;  :interface-eqs           111
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          369
;  :mk-bool-var             8351
;  :mk-clause               4907
;  :num-allocs              5200926
;  :num-checks              280
;  :propagations            2772
;  :quant-instantiations    1099
;  :rlimit-count            293305
;  :time                    0.01)
; [then-branch: 68 | !(__flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1]) | live]
; [else-branch: 68 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1] | live]
(push) ; 9
; [then-branch: 68 | !(__flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@55@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1)))))
; [eval] diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15376
;  :arith-add-rows          961
;  :arith-assert-diseq      791
;  :arith-assert-lower      1887
;  :arith-assert-upper      1372
;  :arith-bound-prop        307
;  :arith-conflicts         52
;  :arith-eq-adapter        1241
;  :arith-fixed-eqs         602
;  :arith-offset-eqs        148
;  :arith-pivots            624
;  :binary-propagations     11
;  :conflicts               269
;  :datatype-accessor-ax    426
;  :datatype-constructor-ax 2727
;  :datatype-occurs-check   1072
;  :datatype-splits         1912
;  :decisions               2936
;  :del-clause              4729
;  :final-checks            324
;  :interface-eqs           111
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          369
;  :mk-bool-var             8355
;  :mk-clause               4912
;  :num-allocs              5200926
;  :num-checks              281
;  :propagations            2774
;  :quant-instantiations    1100
;  :rlimit-count            293491)
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15376
;  :arith-add-rows          961
;  :arith-assert-diseq      791
;  :arith-assert-lower      1887
;  :arith-assert-upper      1372
;  :arith-bound-prop        307
;  :arith-conflicts         52
;  :arith-eq-adapter        1241
;  :arith-fixed-eqs         602
;  :arith-offset-eqs        148
;  :arith-pivots            624
;  :binary-propagations     11
;  :conflicts               269
;  :datatype-accessor-ax    426
;  :datatype-constructor-ax 2727
;  :datatype-occurs-check   1072
;  :datatype-splits         1912
;  :decisions               2936
;  :del-clause              4729
;  :final-checks            324
;  :interface-eqs           111
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          369
;  :mk-bool-var             8355
;  :mk-clause               4912
;  :num-allocs              5200926
;  :num-checks              282
;  :propagations            2774
;  :quant-instantiations    1100
;  :rlimit-count            293506)
(pop) ; 9
(push) ; 9
; [else-branch: 68 | __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@55@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@55@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (or
        (=
          (Seq_index
            __flatten_31__30@55@05
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
              1))
          0)
        (=
          (Seq_index
            __flatten_31__30@55@05
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
              1))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; Main_reset_all_events_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@59@05 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 69 | 0 <= i@59@05 | live]
; [else-branch: 69 | !(0 <= i@59@05) | live]
(push) ; 10
; [then-branch: 69 | 0 <= i@59@05]
(assert (<= 0 i@59@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 69 | !(0 <= i@59@05)]
(assert (not (<= 0 i@59@05)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 70 | i@59@05 < |First:(Second:($t@57@05))| && 0 <= i@59@05 | live]
; [else-branch: 70 | !(i@59@05 < |First:(Second:($t@57@05))| && 0 <= i@59@05) | live]
(push) ; 10
; [then-branch: 70 | i@59@05 < |First:(Second:($t@57@05))| && 0 <= i@59@05]
(assert (and
  (<
    i@59@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))
  (<= 0 i@59@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@59@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16132
;  :arith-add-rows          1031
;  :arith-assert-diseq      841
;  :arith-assert-lower      1980
;  :arith-assert-upper      1460
;  :arith-bound-prop        318
;  :arith-conflicts         55
;  :arith-eq-adapter        1317
;  :arith-fixed-eqs         647
;  :arith-offset-eqs        163
;  :arith-pivots            654
;  :binary-propagations     11
;  :conflicts               280
;  :datatype-accessor-ax    438
;  :datatype-constructor-ax 2835
;  :datatype-occurs-check   1116
;  :datatype-splits         1997
;  :decisions               3066
;  :del-clause              4998
;  :final-checks            336
;  :interface-eqs           117
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          379
;  :mk-bool-var             8825
;  :mk-clause               5204
;  :num-allocs              5200926
;  :num-checks              284
;  :propagations            2926
;  :quant-instantiations    1168
;  :rlimit-count            300129)
; [eval] -1
(push) ; 11
; [then-branch: 71 | First:(Second:($t@57@05))[i@59@05] == -1 | live]
; [else-branch: 71 | First:(Second:($t@57@05))[i@59@05] != -1 | live]
(push) ; 12
; [then-branch: 71 | First:(Second:($t@57@05))[i@59@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
    i@59@05)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 71 | First:(Second:($t@57@05))[i@59@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
      i@59@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@59@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16132
;  :arith-add-rows          1031
;  :arith-assert-diseq      842
;  :arith-assert-lower      1983
;  :arith-assert-upper      1461
;  :arith-bound-prop        318
;  :arith-conflicts         55
;  :arith-eq-adapter        1318
;  :arith-fixed-eqs         647
;  :arith-offset-eqs        163
;  :arith-pivots            654
;  :binary-propagations     11
;  :conflicts               280
;  :datatype-accessor-ax    438
;  :datatype-constructor-ax 2835
;  :datatype-occurs-check   1116
;  :datatype-splits         1997
;  :decisions               3066
;  :del-clause              4998
;  :final-checks            336
;  :interface-eqs           117
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          379
;  :mk-bool-var             8831
;  :mk-clause               5208
;  :num-allocs              5200926
;  :num-checks              285
;  :propagations            2928
;  :quant-instantiations    1169
;  :rlimit-count            300337)
(push) ; 13
; [then-branch: 72 | 0 <= First:(Second:($t@57@05))[i@59@05] | live]
; [else-branch: 72 | !(0 <= First:(Second:($t@57@05))[i@59@05]) | live]
(push) ; 14
; [then-branch: 72 | 0 <= First:(Second:($t@57@05))[i@59@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
    i@59@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@59@05 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16132
;  :arith-add-rows          1031
;  :arith-assert-diseq      842
;  :arith-assert-lower      1983
;  :arith-assert-upper      1461
;  :arith-bound-prop        318
;  :arith-conflicts         55
;  :arith-eq-adapter        1318
;  :arith-fixed-eqs         647
;  :arith-offset-eqs        163
;  :arith-pivots            654
;  :binary-propagations     11
;  :conflicts               280
;  :datatype-accessor-ax    438
;  :datatype-constructor-ax 2835
;  :datatype-occurs-check   1116
;  :datatype-splits         1997
;  :decisions               3066
;  :del-clause              4998
;  :final-checks            336
;  :interface-eqs           117
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          379
;  :mk-bool-var             8831
;  :mk-clause               5208
;  :num-allocs              5200926
;  :num-checks              286
;  :propagations            2928
;  :quant-instantiations    1169
;  :rlimit-count            300431)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 72 | !(0 <= First:(Second:($t@57@05))[i@59@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
      i@59@05))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 70 | !(i@59@05 < |First:(Second:($t@57@05))| && 0 <= i@59@05)]
(assert (not
  (and
    (<
      i@59@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))
    (<= 0 i@59@05))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@59@05 Int)) (!
  (implies
    (and
      (<
        i@59@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))
      (<= 0 i@59@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
          i@59@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
            i@59@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
            i@59@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
    i@59@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16132
;  :arith-add-rows          1031
;  :arith-assert-diseq      843
;  :arith-assert-lower      1984
;  :arith-assert-upper      1462
;  :arith-bound-prop        318
;  :arith-conflicts         55
;  :arith-eq-adapter        1319
;  :arith-fixed-eqs         647
;  :arith-offset-eqs        163
;  :arith-pivots            654
;  :binary-propagations     11
;  :conflicts               281
;  :datatype-accessor-ax    438
;  :datatype-constructor-ax 2835
;  :datatype-occurs-check   1116
;  :datatype-splits         1997
;  :decisions               3066
;  :del-clause              5014
;  :final-checks            336
;  :interface-eqs           117
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          379
;  :mk-bool-var             8839
;  :mk-clause               5220
;  :num-allocs              5200926
;  :num-checks              287
;  :propagations            2930
;  :quant-instantiations    1170
;  :rlimit-count            300853)
(assert (forall ((i@59@05 Int)) (!
  (implies
    (and
      (<
        i@59@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))
      (<= 0 i@59@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
          i@59@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
            i@59@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
            i@59@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))
    i@59@05))
  :qid |prog.l<no position>|)))
(declare-const $t@60@05 $Snap)
(assert (= $t@60@05 ($Snap.combine ($Snap.first $t@60@05) ($Snap.second $t@60@05))))
(assert (=
  ($Snap.second $t@60@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@60@05))
    ($Snap.second ($Snap.second $t@60@05)))))
(assert (=
  ($Snap.second ($Snap.second $t@60@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@60@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@60@05))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@60@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@61@05 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 73 | 0 <= i@61@05 | live]
; [else-branch: 73 | !(0 <= i@61@05) | live]
(push) ; 10
; [then-branch: 73 | 0 <= i@61@05]
(assert (<= 0 i@61@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 73 | !(0 <= i@61@05)]
(assert (not (<= 0 i@61@05)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 74 | i@61@05 < |First:(Second:($t@60@05))| && 0 <= i@61@05 | live]
; [else-branch: 74 | !(i@61@05 < |First:(Second:($t@60@05))| && 0 <= i@61@05) | live]
(push) ; 10
; [then-branch: 74 | i@61@05 < |First:(Second:($t@60@05))| && 0 <= i@61@05]
(assert (and
  (<
    i@61@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))))
  (<= 0 i@61@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@61@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16169
;  :arith-add-rows          1031
;  :arith-assert-diseq      843
;  :arith-assert-lower      1989
;  :arith-assert-upper      1465
;  :arith-bound-prop        318
;  :arith-conflicts         55
;  :arith-eq-adapter        1321
;  :arith-fixed-eqs         647
;  :arith-offset-eqs        163
;  :arith-pivots            654
;  :binary-propagations     11
;  :conflicts               281
;  :datatype-accessor-ax    444
;  :datatype-constructor-ax 2835
;  :datatype-occurs-check   1116
;  :datatype-splits         1997
;  :decisions               3066
;  :del-clause              5014
;  :final-checks            336
;  :interface-eqs           117
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          379
;  :mk-bool-var             8861
;  :mk-clause               5220
;  :num-allocs              5200926
;  :num-checks              288
;  :propagations            2930
;  :quant-instantiations    1174
;  :rlimit-count            302242)
; [eval] -1
(push) ; 11
; [then-branch: 75 | First:(Second:($t@60@05))[i@61@05] == -1 | live]
; [else-branch: 75 | First:(Second:($t@60@05))[i@61@05] != -1 | live]
(push) ; 12
; [then-branch: 75 | First:(Second:($t@60@05))[i@61@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
    i@61@05)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 75 | First:(Second:($t@60@05))[i@61@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
      i@61@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@61@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16169
;  :arith-add-rows          1031
;  :arith-assert-diseq      843
;  :arith-assert-lower      1989
;  :arith-assert-upper      1465
;  :arith-bound-prop        318
;  :arith-conflicts         55
;  :arith-eq-adapter        1321
;  :arith-fixed-eqs         647
;  :arith-offset-eqs        163
;  :arith-pivots            654
;  :binary-propagations     11
;  :conflicts               281
;  :datatype-accessor-ax    444
;  :datatype-constructor-ax 2835
;  :datatype-occurs-check   1116
;  :datatype-splits         1997
;  :decisions               3066
;  :del-clause              5014
;  :final-checks            336
;  :interface-eqs           117
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          379
;  :mk-bool-var             8862
;  :mk-clause               5220
;  :num-allocs              5200926
;  :num-checks              289
;  :propagations            2930
;  :quant-instantiations    1174
;  :rlimit-count            302393)
(push) ; 13
; [then-branch: 76 | 0 <= First:(Second:($t@60@05))[i@61@05] | live]
; [else-branch: 76 | !(0 <= First:(Second:($t@60@05))[i@61@05]) | live]
(push) ; 14
; [then-branch: 76 | 0 <= First:(Second:($t@60@05))[i@61@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
    i@61@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@61@05 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16169
;  :arith-add-rows          1031
;  :arith-assert-diseq      844
;  :arith-assert-lower      1992
;  :arith-assert-upper      1465
;  :arith-bound-prop        318
;  :arith-conflicts         55
;  :arith-eq-adapter        1322
;  :arith-fixed-eqs         647
;  :arith-offset-eqs        163
;  :arith-pivots            654
;  :binary-propagations     11
;  :conflicts               281
;  :datatype-accessor-ax    444
;  :datatype-constructor-ax 2835
;  :datatype-occurs-check   1116
;  :datatype-splits         1997
;  :decisions               3066
;  :del-clause              5014
;  :final-checks            336
;  :interface-eqs           117
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          379
;  :mk-bool-var             8865
;  :mk-clause               5221
;  :num-allocs              5200926
;  :num-checks              290
;  :propagations            2930
;  :quant-instantiations    1174
;  :rlimit-count            302497)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 76 | !(0 <= First:(Second:($t@60@05))[i@61@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
      i@61@05))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 74 | !(i@61@05 < |First:(Second:($t@60@05))| && 0 <= i@61@05)]
(assert (not
  (and
    (<
      i@61@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))))
    (<= 0 i@61@05))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@61@05 Int)) (!
  (implies
    (and
      (<
        i@61@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))))
      (<= 0 i@61@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
          i@61@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
            i@61@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
            i@61@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
    i@61@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@57@05)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16187
;  :arith-add-rows          1031
;  :arith-assert-diseq      844
;  :arith-assert-lower      1993
;  :arith-assert-upper      1466
;  :arith-bound-prop        318
;  :arith-conflicts         55
;  :arith-eq-adapter        1323
;  :arith-fixed-eqs         648
;  :arith-offset-eqs        163
;  :arith-pivots            654
;  :binary-propagations     11
;  :conflicts               281
;  :datatype-accessor-ax    446
;  :datatype-constructor-ax 2835
;  :datatype-occurs-check   1116
;  :datatype-splits         1997
;  :decisions               3066
;  :del-clause              5015
;  :final-checks            336
;  :interface-eqs           117
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          379
;  :mk-bool-var             8885
;  :mk-clause               5231
;  :num-allocs              5200926
;  :num-checks              291
;  :propagations            2934
;  :quant-instantiations    1176
;  :rlimit-count            303512)
(push) ; 8
; [then-branch: 77 | First:(Second:(Second:(Second:($t@57@05))))[0] == 0 | live]
; [else-branch: 77 | First:(Second:(Second:(Second:($t@57@05))))[0] != 0 | live]
(push) ; 9
; [then-branch: 77 | First:(Second:(Second:(Second:($t@57@05))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 77 | First:(Second:(Second:(Second:($t@57@05))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16188
;  :arith-add-rows          1032
;  :arith-assert-diseq      844
;  :arith-assert-lower      1993
;  :arith-assert-upper      1466
;  :arith-bound-prop        318
;  :arith-conflicts         55
;  :arith-eq-adapter        1323
;  :arith-fixed-eqs         648
;  :arith-offset-eqs        163
;  :arith-pivots            654
;  :binary-propagations     11
;  :conflicts               281
;  :datatype-accessor-ax    446
;  :datatype-constructor-ax 2835
;  :datatype-occurs-check   1116
;  :datatype-splits         1997
;  :decisions               3066
;  :del-clause              5015
;  :final-checks            336
;  :interface-eqs           117
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          379
;  :mk-bool-var             8890
;  :mk-clause               5237
;  :num-allocs              5200926
;  :num-checks              292
;  :propagations            2934
;  :quant-instantiations    1177
;  :rlimit-count            303725)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17283
;  :arith-add-rows          1161
;  :arith-assert-diseq      1021
;  :arith-assert-lower      2339
;  :arith-assert-upper      1672
;  :arith-bound-prop        337
;  :arith-conflicts         56
;  :arith-eq-adapter        1554
;  :arith-fixed-eqs         763
;  :arith-offset-eqs        195
;  :arith-pivots            750
;  :binary-propagations     11
;  :conflicts               306
;  :datatype-accessor-ax    456
;  :datatype-constructor-ax 2907
;  :datatype-occurs-check   1142
;  :datatype-splits         2057
;  :decisions               3219
;  :del-clause              5818
;  :final-checks            340
;  :interface-eqs           119
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          404
;  :mk-bool-var             9885
;  :mk-clause               6034
;  :num-allocs              5200926
;  :num-checks              293
;  :propagations            3588
;  :quant-instantiations    1444
;  :rlimit-count            314506
;  :time                    0.01)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18042
;  :arith-add-rows          1245
;  :arith-assert-diseq      1105
;  :arith-assert-lower      2505
;  :arith-assert-upper      1767
;  :arith-bound-prop        346
;  :arith-conflicts         57
;  :arith-eq-adapter        1658
;  :arith-fixed-eqs         827
;  :arith-offset-eqs        218
;  :arith-pivots            802
;  :binary-propagations     11
;  :conflicts               317
;  :datatype-accessor-ax    466
;  :datatype-constructor-ax 3005
;  :datatype-occurs-check   1183
;  :datatype-splits         2125
;  :decisions               3343
;  :del-clause              6181
;  :final-checks            349
;  :interface-eqs           123
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          406
;  :mk-bool-var             10402
;  :mk-clause               6397
;  :num-allocs              5434296
;  :num-checks              294
;  :propagations            3831
;  :quant-instantiations    1547
;  :rlimit-count            321689
;  :time                    0.01)
; [then-branch: 78 | First:(Second:(Second:(Second:($t@57@05))))[0] == 0 || First:(Second:(Second:(Second:($t@57@05))))[0] == -1 | live]
; [else-branch: 78 | !(First:(Second:(Second:(Second:($t@57@05))))[0] == 0 || First:(Second:(Second:(Second:($t@57@05))))[0] == -1) | live]
(push) ; 9
; [then-branch: 78 | First:(Second:(Second:(Second:($t@57@05))))[0] == 0 || First:(Second:(Second:(Second:($t@57@05))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18042
;  :arith-add-rows          1245
;  :arith-assert-diseq      1105
;  :arith-assert-lower      2505
;  :arith-assert-upper      1767
;  :arith-bound-prop        346
;  :arith-conflicts         57
;  :arith-eq-adapter        1658
;  :arith-fixed-eqs         827
;  :arith-offset-eqs        218
;  :arith-pivots            802
;  :binary-propagations     11
;  :conflicts               317
;  :datatype-accessor-ax    466
;  :datatype-constructor-ax 3005
;  :datatype-occurs-check   1183
;  :datatype-splits         2125
;  :decisions               3343
;  :del-clause              6181
;  :final-checks            349
;  :interface-eqs           123
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          406
;  :mk-bool-var             10404
;  :mk-clause               6398
;  :num-allocs              5434296
;  :num-checks              295
;  :propagations            3831
;  :quant-instantiations    1547
;  :rlimit-count            321838)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 78 | !(First:(Second:(Second:(Second:($t@57@05))))[0] == 0 || First:(Second:(Second:(Second:($t@57@05))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        0)
      (- 0 1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18048
;  :arith-add-rows          1245
;  :arith-assert-diseq      1105
;  :arith-assert-lower      2505
;  :arith-assert-upper      1767
;  :arith-bound-prop        346
;  :arith-conflicts         57
;  :arith-eq-adapter        1658
;  :arith-fixed-eqs         827
;  :arith-offset-eqs        218
;  :arith-pivots            802
;  :binary-propagations     11
;  :conflicts               317
;  :datatype-accessor-ax    467
;  :datatype-constructor-ax 3005
;  :datatype-occurs-check   1183
;  :datatype-splits         2125
;  :decisions               3343
;  :del-clause              6182
;  :final-checks            349
;  :interface-eqs           123
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          406
;  :mk-bool-var             10410
;  :mk-clause               6402
;  :num-allocs              5434296
;  :num-checks              296
;  :propagations            3831
;  :quant-instantiations    1547
;  :rlimit-count            322321)
(push) ; 8
; [then-branch: 79 | First:(Second:(Second:(Second:($t@57@05))))[1] == 0 | live]
; [else-branch: 79 | First:(Second:(Second:(Second:($t@57@05))))[1] != 0 | live]
(push) ; 9
; [then-branch: 79 | First:(Second:(Second:(Second:($t@57@05))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 79 | First:(Second:(Second:(Second:($t@57@05))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18049
;  :arith-add-rows          1246
;  :arith-assert-diseq      1105
;  :arith-assert-lower      2505
;  :arith-assert-upper      1767
;  :arith-bound-prop        346
;  :arith-conflicts         57
;  :arith-eq-adapter        1658
;  :arith-fixed-eqs         827
;  :arith-offset-eqs        218
;  :arith-pivots            802
;  :binary-propagations     11
;  :conflicts               317
;  :datatype-accessor-ax    467
;  :datatype-constructor-ax 3005
;  :datatype-occurs-check   1183
;  :datatype-splits         2125
;  :decisions               3343
;  :del-clause              6182
;  :final-checks            349
;  :interface-eqs           123
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          406
;  :mk-bool-var             10414
;  :mk-clause               6407
;  :num-allocs              5434296
;  :num-checks              297
;  :propagations            3831
;  :quant-instantiations    1548
;  :rlimit-count            322506)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18744
;  :arith-add-rows          1318
;  :arith-assert-diseq      1175
;  :arith-assert-lower      2640
;  :arith-assert-upper      1844
;  :arith-bound-prop        356
;  :arith-conflicts         58
;  :arith-eq-adapter        1747
;  :arith-fixed-eqs         873
;  :arith-offset-eqs        231
;  :arith-pivots            838
;  :binary-propagations     11
;  :conflicts               324
;  :datatype-accessor-ax    477
;  :datatype-constructor-ax 3099
;  :datatype-occurs-check   1219
;  :datatype-splits         2189
;  :decisions               3462
;  :del-clause              6502
;  :final-checks            355
;  :interface-eqs           125
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          406
;  :mk-bool-var             10841
;  :mk-clause               6722
;  :num-allocs              5434296
;  :num-checks              298
;  :propagations            4035
;  :quant-instantiations    1634
;  :rlimit-count            328976
;  :time                    0.01)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19370
;  :arith-add-rows          1396
;  :arith-assert-diseq      1252
;  :arith-assert-lower      2792
;  :arith-assert-upper      1936
;  :arith-bound-prop        367
;  :arith-conflicts         58
;  :arith-eq-adapter        1849
;  :arith-fixed-eqs         923
;  :arith-offset-eqs        243
;  :arith-pivots            868
;  :binary-propagations     11
;  :conflicts               332
;  :datatype-accessor-ax    482
;  :datatype-constructor-ax 3163
;  :datatype-occurs-check   1247
;  :datatype-splits         2223
;  :decisions               3564
;  :del-clause              6857
;  :final-checks            362
;  :interface-eqs           129
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          407
;  :mk-bool-var             11290
;  :mk-clause               7077
;  :num-allocs              5434296
;  :num-checks              299
;  :propagations            4280
;  :quant-instantiations    1743
;  :rlimit-count            335554
;  :time                    0.01)
; [then-branch: 80 | First:(Second:(Second:(Second:($t@57@05))))[1] == 0 || First:(Second:(Second:(Second:($t@57@05))))[1] == -1 | live]
; [else-branch: 80 | !(First:(Second:(Second:(Second:($t@57@05))))[1] == 0 || First:(Second:(Second:(Second:($t@57@05))))[1] == -1) | live]
(push) ; 9
; [then-branch: 80 | First:(Second:(Second:(Second:($t@57@05))))[1] == 0 || First:(Second:(Second:(Second:($t@57@05))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19370
;  :arith-add-rows          1396
;  :arith-assert-diseq      1252
;  :arith-assert-lower      2792
;  :arith-assert-upper      1936
;  :arith-bound-prop        367
;  :arith-conflicts         58
;  :arith-eq-adapter        1849
;  :arith-fixed-eqs         923
;  :arith-offset-eqs        243
;  :arith-pivots            868
;  :binary-propagations     11
;  :conflicts               332
;  :datatype-accessor-ax    482
;  :datatype-constructor-ax 3163
;  :datatype-occurs-check   1247
;  :datatype-splits         2223
;  :decisions               3564
;  :del-clause              6857
;  :final-checks            362
;  :interface-eqs           129
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          407
;  :mk-bool-var             11292
;  :mk-clause               7078
;  :num-allocs              5434296
;  :num-checks              300
;  :propagations            4280
;  :quant-instantiations    1743
;  :rlimit-count            335703)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 80 | !(First:(Second:(Second:(Second:($t@57@05))))[1] == 0 || First:(Second:(Second:(Second:($t@57@05))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        1)
      (- 0 1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1 ==> diz.Main_event_state[2] == -2
; [eval] old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19376
;  :arith-add-rows          1396
;  :arith-assert-diseq      1252
;  :arith-assert-lower      2792
;  :arith-assert-upper      1936
;  :arith-bound-prop        367
;  :arith-conflicts         58
;  :arith-eq-adapter        1849
;  :arith-fixed-eqs         923
;  :arith-offset-eqs        243
;  :arith-pivots            868
;  :binary-propagations     11
;  :conflicts               332
;  :datatype-accessor-ax    483
;  :datatype-constructor-ax 3163
;  :datatype-occurs-check   1247
;  :datatype-splits         2223
;  :decisions               3564
;  :del-clause              6858
;  :final-checks            362
;  :interface-eqs           129
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          407
;  :mk-bool-var             11298
;  :mk-clause               7082
;  :num-allocs              5434296
;  :num-checks              301
;  :propagations            4280
;  :quant-instantiations    1743
;  :rlimit-count            336192)
(push) ; 8
; [then-branch: 81 | First:(Second:(Second:(Second:($t@57@05))))[2] == 0 | live]
; [else-branch: 81 | First:(Second:(Second:(Second:($t@57@05))))[2] != 0 | live]
(push) ; 9
; [then-branch: 81 | First:(Second:(Second:(Second:($t@57@05))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
    2)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 81 | First:(Second:(Second:(Second:($t@57@05))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19377
;  :arith-add-rows          1397
;  :arith-assert-diseq      1252
;  :arith-assert-lower      2792
;  :arith-assert-upper      1936
;  :arith-bound-prop        367
;  :arith-conflicts         58
;  :arith-eq-adapter        1849
;  :arith-fixed-eqs         923
;  :arith-offset-eqs        243
;  :arith-pivots            868
;  :binary-propagations     11
;  :conflicts               332
;  :datatype-accessor-ax    483
;  :datatype-constructor-ax 3163
;  :datatype-occurs-check   1247
;  :datatype-splits         2223
;  :decisions               3564
;  :del-clause              6858
;  :final-checks            362
;  :interface-eqs           129
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          407
;  :mk-bool-var             11302
;  :mk-clause               7087
;  :num-allocs              5434296
;  :num-checks              302
;  :propagations            4280
;  :quant-instantiations    1744
;  :rlimit-count            336377)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20027
;  :arith-add-rows          1480
;  :arith-assert-diseq      1329
;  :arith-assert-lower      2958
;  :arith-assert-upper      2035
;  :arith-bound-prop        377
;  :arith-conflicts         58
;  :arith-eq-adapter        1952
;  :arith-fixed-eqs         982
;  :arith-offset-eqs        257
;  :arith-pivots            917
;  :binary-propagations     11
;  :conflicts               341
;  :datatype-accessor-ax    488
;  :datatype-constructor-ax 3227
;  :datatype-occurs-check   1269
;  :datatype-splits         2257
;  :decisions               3673
;  :del-clause              7260
;  :final-checks            368
;  :interface-eqs           132
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          421
;  :mk-bool-var             11809
;  :mk-clause               7484
;  :num-allocs              5434296
;  :num-checks              303
;  :propagations            4550
;  :quant-instantiations    1865
;  :rlimit-count            343118
;  :time                    0.01)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20805
;  :arith-add-rows          1551
;  :arith-assert-diseq      1418
;  :arith-assert-lower      3125
;  :arith-assert-upper      2124
;  :arith-bound-prop        386
;  :arith-conflicts         59
;  :arith-eq-adapter        2057
;  :arith-fixed-eqs         1046
;  :arith-offset-eqs        271
;  :arith-pivots            965
;  :binary-propagations     11
;  :conflicts               350
;  :datatype-accessor-ax    499
;  :datatype-constructor-ax 3324
;  :datatype-occurs-check   1310
;  :datatype-splits         2323
;  :decisions               3802
;  :del-clause              7635
;  :final-checks            375
;  :interface-eqs           134
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          423
;  :mk-bool-var             12335
;  :mk-clause               7859
;  :num-allocs              5434296
;  :num-checks              304
;  :propagations            4811
;  :quant-instantiations    1975
;  :rlimit-count            350238
;  :time                    0.01)
; [then-branch: 82 | First:(Second:(Second:(Second:($t@57@05))))[2] == 0 || First:(Second:(Second:(Second:($t@57@05))))[2] == -1 | live]
; [else-branch: 82 | !(First:(Second:(Second:(Second:($t@57@05))))[2] == 0 || First:(Second:(Second:(Second:($t@57@05))))[2] == -1) | live]
(push) ; 9
; [then-branch: 82 | First:(Second:(Second:(Second:($t@57@05))))[2] == 0 || First:(Second:(Second:(Second:($t@57@05))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      2)
    (- 0 1))))
; [eval] diz.Main_event_state[2] == -2
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20805
;  :arith-add-rows          1551
;  :arith-assert-diseq      1418
;  :arith-assert-lower      3125
;  :arith-assert-upper      2124
;  :arith-bound-prop        386
;  :arith-conflicts         59
;  :arith-eq-adapter        2057
;  :arith-fixed-eqs         1046
;  :arith-offset-eqs        271
;  :arith-pivots            965
;  :binary-propagations     11
;  :conflicts               350
;  :datatype-accessor-ax    499
;  :datatype-constructor-ax 3324
;  :datatype-occurs-check   1310
;  :datatype-splits         2323
;  :decisions               3802
;  :del-clause              7635
;  :final-checks            375
;  :interface-eqs           134
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          423
;  :mk-bool-var             12337
;  :mk-clause               7860
;  :num-allocs              5434296
;  :num-checks              305
;  :propagations            4811
;  :quant-instantiations    1975
;  :rlimit-count            350387)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 82 | !(First:(Second:(Second:(Second:($t@57@05))))[2] == 0 || First:(Second:(Second:(Second:($t@57@05))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        2)
      (- 0 1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        2)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))
      2)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1) ==> diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1)
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20811
;  :arith-add-rows          1551
;  :arith-assert-diseq      1418
;  :arith-assert-lower      3125
;  :arith-assert-upper      2124
;  :arith-bound-prop        386
;  :arith-conflicts         59
;  :arith-eq-adapter        2057
;  :arith-fixed-eqs         1046
;  :arith-offset-eqs        271
;  :arith-pivots            965
;  :binary-propagations     11
;  :conflicts               350
;  :datatype-accessor-ax    500
;  :datatype-constructor-ax 3324
;  :datatype-occurs-check   1310
;  :datatype-splits         2323
;  :decisions               3802
;  :del-clause              7636
;  :final-checks            375
;  :interface-eqs           134
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          423
;  :mk-bool-var             12343
;  :mk-clause               7864
;  :num-allocs              5434296
;  :num-checks              306
;  :propagations            4811
;  :quant-instantiations    1975
;  :rlimit-count            350886)
(push) ; 8
; [then-branch: 83 | First:(Second:(Second:(Second:($t@57@05))))[0] == 0 | live]
; [else-branch: 83 | First:(Second:(Second:(Second:($t@57@05))))[0] != 0 | live]
(push) ; 9
; [then-branch: 83 | First:(Second:(Second:(Second:($t@57@05))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 83 | First:(Second:(Second:(Second:($t@57@05))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20812
;  :arith-add-rows          1552
;  :arith-assert-diseq      1418
;  :arith-assert-lower      3125
;  :arith-assert-upper      2124
;  :arith-bound-prop        386
;  :arith-conflicts         59
;  :arith-eq-adapter        2057
;  :arith-fixed-eqs         1046
;  :arith-offset-eqs        271
;  :arith-pivots            965
;  :binary-propagations     11
;  :conflicts               350
;  :datatype-accessor-ax    500
;  :datatype-constructor-ax 3324
;  :datatype-occurs-check   1310
;  :datatype-splits         2323
;  :decisions               3802
;  :del-clause              7636
;  :final-checks            375
;  :interface-eqs           134
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          423
;  :mk-bool-var             12347
;  :mk-clause               7870
;  :num-allocs              5434296
;  :num-checks              307
;  :propagations            4811
;  :quant-instantiations    1976
;  :rlimit-count            351055)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               21563
;  :arith-add-rows          1643
;  :arith-assert-diseq      1502
;  :arith-assert-lower      3293
;  :arith-assert-upper      2214
;  :arith-bound-prop        395
;  :arith-conflicts         60
;  :arith-eq-adapter        2161
;  :arith-fixed-eqs         1101
;  :arith-offset-eqs        285
;  :arith-pivots            1007
;  :binary-propagations     11
;  :conflicts               359
;  :datatype-accessor-ax    511
;  :datatype-constructor-ax 3421
;  :datatype-occurs-check   1351
;  :datatype-splits         2389
;  :decisions               3928
;  :del-clause              8007
;  :final-checks            382
;  :interface-eqs           136
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          425
;  :mk-bool-var             12852
;  :mk-clause               8235
;  :num-allocs              5434296
;  :num-checks              308
;  :propagations            5062
;  :quant-instantiations    2079
;  :rlimit-count            358401
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22703
;  :arith-add-rows          1836
;  :arith-assert-diseq      1672
;  :arith-assert-lower      3640
;  :arith-assert-upper      2424
;  :arith-bound-prop        413
;  :arith-conflicts         61
;  :arith-eq-adapter        2384
;  :arith-fixed-eqs         1227
;  :arith-offset-eqs        314
;  :arith-pivots            1078
;  :binary-propagations     11
;  :conflicts               385
;  :datatype-accessor-ax    517
;  :datatype-constructor-ax 3488
;  :datatype-occurs-check   1379
;  :datatype-splits         2425
;  :decisions               4095
;  :del-clause              8857
;  :final-checks            390
;  :interface-eqs           140
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.10
;  :minimized-lits          462
;  :mk-bool-var             13913
;  :mk-clause               9085
;  :num-allocs              5687875
;  :num-checks              309
;  :propagations            5727
;  :quant-instantiations    2358
;  :rlimit-count            370993
;  :time                    0.01)
; [then-branch: 84 | !(First:(Second:(Second:(Second:($t@57@05))))[0] == 0 || First:(Second:(Second:(Second:($t@57@05))))[0] == -1) | live]
; [else-branch: 84 | First:(Second:(Second:(Second:($t@57@05))))[0] == 0 || First:(Second:(Second:(Second:($t@57@05))))[0] == -1 | live]
(push) ; 9
; [then-branch: 84 | !(First:(Second:(Second:(Second:($t@57@05))))[0] == 0 || First:(Second:(Second:(Second:($t@57@05))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22704
;  :arith-add-rows          1837
;  :arith-assert-diseq      1672
;  :arith-assert-lower      3640
;  :arith-assert-upper      2424
;  :arith-bound-prop        413
;  :arith-conflicts         61
;  :arith-eq-adapter        2384
;  :arith-fixed-eqs         1227
;  :arith-offset-eqs        314
;  :arith-pivots            1078
;  :binary-propagations     11
;  :conflicts               385
;  :datatype-accessor-ax    517
;  :datatype-constructor-ax 3488
;  :datatype-occurs-check   1379
;  :datatype-splits         2425
;  :decisions               4095
;  :del-clause              8857
;  :final-checks            390
;  :interface-eqs           140
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.10
;  :minimized-lits          462
;  :mk-bool-var             13917
;  :mk-clause               9091
;  :num-allocs              5687875
;  :num-checks              310
;  :propagations            5728
;  :quant-instantiations    2359
;  :rlimit-count            371183)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22704
;  :arith-add-rows          1837
;  :arith-assert-diseq      1672
;  :arith-assert-lower      3640
;  :arith-assert-upper      2424
;  :arith-bound-prop        413
;  :arith-conflicts         61
;  :arith-eq-adapter        2384
;  :arith-fixed-eqs         1227
;  :arith-offset-eqs        314
;  :arith-pivots            1078
;  :binary-propagations     11
;  :conflicts               385
;  :datatype-accessor-ax    517
;  :datatype-constructor-ax 3488
;  :datatype-occurs-check   1379
;  :datatype-splits         2425
;  :decisions               4095
;  :del-clause              8857
;  :final-checks            390
;  :interface-eqs           140
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.10
;  :minimized-lits          462
;  :mk-bool-var             13917
;  :mk-clause               9091
;  :num-allocs              5687875
;  :num-checks              311
;  :propagations            5728
;  :quant-instantiations    2359
;  :rlimit-count            371198)
(pop) ; 9
(push) ; 9
; [else-branch: 84 | First:(Second:(Second:(Second:($t@57@05))))[0] == 0 || First:(Second:(Second:(Second:($t@57@05))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      0)
    (- 0 1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1) ==> diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1)
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22710
;  :arith-add-rows          1837
;  :arith-assert-diseq      1672
;  :arith-assert-lower      3640
;  :arith-assert-upper      2424
;  :arith-bound-prop        413
;  :arith-conflicts         61
;  :arith-eq-adapter        2384
;  :arith-fixed-eqs         1227
;  :arith-offset-eqs        314
;  :arith-pivots            1078
;  :binary-propagations     11
;  :conflicts               385
;  :datatype-accessor-ax    518
;  :datatype-constructor-ax 3488
;  :datatype-occurs-check   1379
;  :datatype-splits         2425
;  :decisions               4095
;  :del-clause              8863
;  :final-checks            390
;  :interface-eqs           140
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.10
;  :minimized-lits          462
;  :mk-bool-var             13920
;  :mk-clause               9092
;  :num-allocs              5687875
;  :num-checks              312
;  :propagations            5728
;  :quant-instantiations    2359
;  :rlimit-count            371647)
(push) ; 8
; [then-branch: 85 | First:(Second:(Second:(Second:($t@57@05))))[1] == 0 | live]
; [else-branch: 85 | First:(Second:(Second:(Second:($t@57@05))))[1] != 0 | live]
(push) ; 9
; [then-branch: 85 | First:(Second:(Second:(Second:($t@57@05))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 85 | First:(Second:(Second:(Second:($t@57@05))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22711
;  :arith-add-rows          1838
;  :arith-assert-diseq      1672
;  :arith-assert-lower      3640
;  :arith-assert-upper      2424
;  :arith-bound-prop        413
;  :arith-conflicts         61
;  :arith-eq-adapter        2384
;  :arith-fixed-eqs         1227
;  :arith-offset-eqs        314
;  :arith-pivots            1078
;  :binary-propagations     11
;  :conflicts               385
;  :datatype-accessor-ax    518
;  :datatype-constructor-ax 3488
;  :datatype-occurs-check   1379
;  :datatype-splits         2425
;  :decisions               4095
;  :del-clause              8863
;  :final-checks            390
;  :interface-eqs           140
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.10
;  :minimized-lits          462
;  :mk-bool-var             13923
;  :mk-clause               9097
;  :num-allocs              5687875
;  :num-checks              313
;  :propagations            5728
;  :quant-instantiations    2360
;  :rlimit-count            371816)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               23401
;  :arith-add-rows          1910
;  :arith-assert-diseq      1757
;  :arith-assert-lower      3819
;  :arith-assert-upper      2523
;  :arith-bound-prop        424
;  :arith-conflicts         61
;  :arith-eq-adapter        2496
;  :arith-fixed-eqs         1290
;  :arith-offset-eqs        336
;  :arith-pivots            1129
;  :binary-propagations     11
;  :conflicts               395
;  :datatype-accessor-ax    524
;  :datatype-constructor-ax 3555
;  :datatype-occurs-check   1407
;  :datatype-splits         2461
;  :decisions               4205
;  :del-clause              9282
;  :final-checks            397
;  :interface-eqs           143
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          472
;  :mk-bool-var             14440
;  :mk-clause               9511
;  :num-allocs              5942320
;  :num-checks              314
;  :propagations            6010
;  :quant-instantiations    2489
;  :rlimit-count            378770
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24130
;  :arith-add-rows          1968
;  :arith-assert-diseq      1831
;  :arith-assert-lower      3958
;  :arith-assert-upper      2600
;  :arith-bound-prop        433
;  :arith-conflicts         62
;  :arith-eq-adapter        2587
;  :arith-fixed-eqs         1340
;  :arith-offset-eqs        346
;  :arith-pivots            1165
;  :binary-propagations     11
;  :conflicts               404
;  :datatype-accessor-ax    535
;  :datatype-constructor-ax 3652
;  :datatype-occurs-check   1448
;  :datatype-splits         2527
;  :decisions               4330
;  :del-clause              9597
;  :final-checks            404
;  :interface-eqs           145
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          472
;  :mk-bool-var             14879
;  :mk-clause               9826
;  :num-allocs              5942320
;  :num-checks              315
;  :propagations            6229
;  :quant-instantiations    2577
;  :rlimit-count            385232
;  :time                    0.00)
; [then-branch: 86 | !(First:(Second:(Second:(Second:($t@57@05))))[1] == 0 || First:(Second:(Second:(Second:($t@57@05))))[1] == -1) | live]
; [else-branch: 86 | First:(Second:(Second:(Second:($t@57@05))))[1] == 0 || First:(Second:(Second:(Second:($t@57@05))))[1] == -1 | live]
(push) ; 9
; [then-branch: 86 | !(First:(Second:(Second:(Second:($t@57@05))))[1] == 0 || First:(Second:(Second:(Second:($t@57@05))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24131
;  :arith-add-rows          1969
;  :arith-assert-diseq      1831
;  :arith-assert-lower      3958
;  :arith-assert-upper      2600
;  :arith-bound-prop        433
;  :arith-conflicts         62
;  :arith-eq-adapter        2587
;  :arith-fixed-eqs         1340
;  :arith-offset-eqs        346
;  :arith-pivots            1165
;  :binary-propagations     11
;  :conflicts               404
;  :datatype-accessor-ax    535
;  :datatype-constructor-ax 3652
;  :datatype-occurs-check   1448
;  :datatype-splits         2527
;  :decisions               4330
;  :del-clause              9597
;  :final-checks            404
;  :interface-eqs           145
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          472
;  :mk-bool-var             14882
;  :mk-clause               9831
;  :num-allocs              5942320
;  :num-checks              316
;  :propagations            6230
;  :quant-instantiations    2578
;  :rlimit-count            385422)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24131
;  :arith-add-rows          1969
;  :arith-assert-diseq      1831
;  :arith-assert-lower      3958
;  :arith-assert-upper      2600
;  :arith-bound-prop        433
;  :arith-conflicts         62
;  :arith-eq-adapter        2587
;  :arith-fixed-eqs         1340
;  :arith-offset-eqs        346
;  :arith-pivots            1165
;  :binary-propagations     11
;  :conflicts               404
;  :datatype-accessor-ax    535
;  :datatype-constructor-ax 3652
;  :datatype-occurs-check   1448
;  :datatype-splits         2527
;  :decisions               4330
;  :del-clause              9597
;  :final-checks            404
;  :interface-eqs           145
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          472
;  :mk-bool-var             14882
;  :mk-clause               9831
;  :num-allocs              5942320
;  :num-checks              317
;  :propagations            6230
;  :quant-instantiations    2578
;  :rlimit-count            385437)
(pop) ; 9
(push) ; 9
; [else-branch: 86 | First:(Second:(Second:(Second:($t@57@05))))[1] == 0 || First:(Second:(Second:(Second:($t@57@05))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      1)
    (- 0 1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1) ==> diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] !(old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1)
; [eval] old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24140
;  :arith-add-rows          1969
;  :arith-assert-diseq      1831
;  :arith-assert-lower      3958
;  :arith-assert-upper      2600
;  :arith-bound-prop        433
;  :arith-conflicts         62
;  :arith-eq-adapter        2587
;  :arith-fixed-eqs         1340
;  :arith-offset-eqs        346
;  :arith-pivots            1165
;  :binary-propagations     11
;  :conflicts               404
;  :datatype-accessor-ax    535
;  :datatype-constructor-ax 3652
;  :datatype-occurs-check   1448
;  :datatype-splits         2527
;  :decisions               4330
;  :del-clause              9602
;  :final-checks            404
;  :interface-eqs           145
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          472
;  :mk-bool-var             14884
;  :mk-clause               9832
;  :num-allocs              5942320
;  :num-checks              318
;  :propagations            6230
;  :quant-instantiations    2578
;  :rlimit-count            385811)
(push) ; 8
; [then-branch: 87 | First:(Second:(Second:(Second:($t@57@05))))[2] == 0 | live]
; [else-branch: 87 | First:(Second:(Second:(Second:($t@57@05))))[2] != 0 | live]
(push) ; 9
; [then-branch: 87 | First:(Second:(Second:(Second:($t@57@05))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
    2)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 87 | First:(Second:(Second:(Second:($t@57@05))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24141
;  :arith-add-rows          1970
;  :arith-assert-diseq      1831
;  :arith-assert-lower      3958
;  :arith-assert-upper      2600
;  :arith-bound-prop        433
;  :arith-conflicts         62
;  :arith-eq-adapter        2587
;  :arith-fixed-eqs         1340
;  :arith-offset-eqs        346
;  :arith-pivots            1165
;  :binary-propagations     11
;  :conflicts               404
;  :datatype-accessor-ax    535
;  :datatype-constructor-ax 3652
;  :datatype-occurs-check   1448
;  :datatype-splits         2527
;  :decisions               4330
;  :del-clause              9602
;  :final-checks            404
;  :interface-eqs           145
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          472
;  :mk-bool-var             14887
;  :mk-clause               9837
;  :num-allocs              5942320
;  :num-checks              319
;  :propagations            6230
;  :quant-instantiations    2579
;  :rlimit-count            385980)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24915
;  :arith-add-rows          2062
;  :arith-assert-diseq      1920
;  :arith-assert-lower      4125
;  :arith-assert-upper      2689
;  :arith-bound-prop        442
;  :arith-conflicts         63
;  :arith-eq-adapter        2692
;  :arith-fixed-eqs         1400
;  :arith-offset-eqs        361
;  :arith-pivots            1213
;  :binary-propagations     11
;  :conflicts               413
;  :datatype-accessor-ax    546
;  :datatype-constructor-ax 3747
;  :datatype-occurs-check   1489
;  :datatype-splits         2591
;  :decisions               4457
;  :del-clause              9982
;  :final-checks            411
;  :interface-eqs           147
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.10
;  :minimized-lits          474
;  :mk-bool-var             15409
;  :mk-clause               10212
;  :num-allocs              6205254
;  :num-checks              320
;  :propagations            6500
;  :quant-instantiations    2689
;  :rlimit-count            393551
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25552
;  :arith-add-rows          2152
;  :arith-assert-diseq      1992
;  :arith-assert-lower      4272
;  :arith-assert-upper      2781
;  :arith-bound-prop        453
;  :arith-conflicts         63
;  :arith-eq-adapter        2788
;  :arith-fixed-eqs         1451
;  :arith-offset-eqs        372
;  :arith-pivots            1247
;  :binary-propagations     11
;  :conflicts               423
;  :datatype-accessor-ax    552
;  :datatype-constructor-ax 3813
;  :datatype-occurs-check   1517
;  :datatype-splits         2626
;  :decisions               4566
;  :del-clause              10336
;  :final-checks            419
;  :interface-eqs           151
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.10
;  :minimized-lits          481
;  :mk-bool-var             15867
;  :mk-clause               10566
;  :num-allocs              6734321
;  :num-checks              321
;  :propagations            6756
;  :quant-instantiations    2797
;  :rlimit-count            400375
;  :time                    0.00)
; [then-branch: 88 | !(First:(Second:(Second:(Second:($t@57@05))))[2] == 0 || First:(Second:(Second:(Second:($t@57@05))))[2] == -1) | live]
; [else-branch: 88 | First:(Second:(Second:(Second:($t@57@05))))[2] == 0 || First:(Second:(Second:(Second:($t@57@05))))[2] == -1 | live]
(push) ; 9
; [then-branch: 88 | !(First:(Second:(Second:(Second:($t@57@05))))[2] == 0 || First:(Second:(Second:(Second:($t@57@05))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
        2)
      (- 0 1)))))
; [eval] diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25553
;  :arith-add-rows          2153
;  :arith-assert-diseq      1992
;  :arith-assert-lower      4272
;  :arith-assert-upper      2781
;  :arith-bound-prop        453
;  :arith-conflicts         63
;  :arith-eq-adapter        2788
;  :arith-fixed-eqs         1451
;  :arith-offset-eqs        372
;  :arith-pivots            1247
;  :binary-propagations     11
;  :conflicts               423
;  :datatype-accessor-ax    552
;  :datatype-constructor-ax 3813
;  :datatype-occurs-check   1517
;  :datatype-splits         2626
;  :decisions               4566
;  :del-clause              10336
;  :final-checks            419
;  :interface-eqs           151
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.10
;  :minimized-lits          481
;  :mk-bool-var             15870
;  :mk-clause               10571
;  :num-allocs              6734321
;  :num-checks              322
;  :propagations            6757
;  :quant-instantiations    2798
;  :rlimit-count            400565)
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25553
;  :arith-add-rows          2153
;  :arith-assert-diseq      1992
;  :arith-assert-lower      4272
;  :arith-assert-upper      2781
;  :arith-bound-prop        453
;  :arith-conflicts         63
;  :arith-eq-adapter        2788
;  :arith-fixed-eqs         1451
;  :arith-offset-eqs        372
;  :arith-pivots            1247
;  :binary-propagations     11
;  :conflicts               423
;  :datatype-accessor-ax    552
;  :datatype-constructor-ax 3813
;  :datatype-occurs-check   1517
;  :datatype-splits         2626
;  :decisions               4566
;  :del-clause              10336
;  :final-checks            419
;  :interface-eqs           151
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.10
;  :minimized-lits          481
;  :mk-bool-var             15870
;  :mk-clause               10571
;  :num-allocs              6734321
;  :num-checks              323
;  :propagations            6757
;  :quant-instantiations    2798
;  :rlimit-count            400580)
(pop) ; 9
(push) ; 9
; [else-branch: 88 | First:(Second:(Second:(Second:($t@57@05))))[2] == 0 || First:(Second:(Second:(Second:($t@57@05))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      2)
    (- 0 1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
          2)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
          2)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@05)))))
      2))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@62@05 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 89 | 0 <= i@62@05 | live]
; [else-branch: 89 | !(0 <= i@62@05) | live]
(push) ; 10
; [then-branch: 89 | 0 <= i@62@05]
(assert (<= 0 i@62@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 89 | !(0 <= i@62@05)]
(assert (not (<= 0 i@62@05)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 90 | i@62@05 < |First:(Second:($t@60@05))| && 0 <= i@62@05 | live]
; [else-branch: 90 | !(i@62@05 < |First:(Second:($t@60@05))| && 0 <= i@62@05) | live]
(push) ; 10
; [then-branch: 90 | i@62@05 < |First:(Second:($t@60@05))| && 0 <= i@62@05]
(assert (and
  (<
    i@62@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))))
  (<= 0 i@62@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@62@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26353
;  :arith-add-rows          2234
;  :arith-assert-diseq      2085
;  :arith-assert-lower      4444
;  :arith-assert-upper      2872
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2895
;  :arith-fixed-eqs         1516
;  :arith-offset-eqs        391
;  :arith-pivots            1296
;  :binary-propagations     11
;  :conflicts               432
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10708
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16411
;  :mk-clause               10956
;  :num-allocs              7000598
;  :num-checks              325
;  :propagations            7036
;  :quant-instantiations    2912
;  :rlimit-count            408169)
; [eval] -1
(push) ; 11
; [then-branch: 91 | First:(Second:($t@60@05))[i@62@05] == -1 | live]
; [else-branch: 91 | First:(Second:($t@60@05))[i@62@05] != -1 | live]
(push) ; 12
; [then-branch: 91 | First:(Second:($t@60@05))[i@62@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
    i@62@05)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 91 | First:(Second:($t@60@05))[i@62@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
      i@62@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@62@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2087
;  :arith-assert-lower      4451
;  :arith-assert-upper      2875
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2898
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1296
;  :binary-propagations     11
;  :conflicts               432
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10708
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16426
;  :mk-clause               10973
;  :num-allocs              7000598
;  :num-checks              326
;  :propagations            7043
;  :quant-instantiations    2915
;  :rlimit-count            408470)
(push) ; 13
; [then-branch: 92 | 0 <= First:(Second:($t@60@05))[i@62@05] | live]
; [else-branch: 92 | !(0 <= First:(Second:($t@60@05))[i@62@05]) | live]
(push) ; 14
; [then-branch: 92 | 0 <= First:(Second:($t@60@05))[i@62@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
    i@62@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@62@05 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2087
;  :arith-assert-lower      4451
;  :arith-assert-upper      2875
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2898
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1296
;  :binary-propagations     11
;  :conflicts               432
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10708
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16426
;  :mk-clause               10973
;  :num-allocs              7000598
;  :num-checks              327
;  :propagations            7043
;  :quant-instantiations    2915
;  :rlimit-count            408564)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 92 | !(0 <= First:(Second:($t@60@05))[i@62@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
      i@62@05))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 90 | !(i@62@05 < |First:(Second:($t@60@05))| && 0 <= i@62@05)]
(assert (not
  (and
    (<
      i@62@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))))
    (<= 0 i@62@05))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@62@05 Int)) (!
  (implies
    (and
      (<
        i@62@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))))
      (<= 0 i@62@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
          i@62@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
            i@62@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
            i@62@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
    i@62@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2088
;  :arith-assert-lower      4452
;  :arith-assert-upper      2876
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2899
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1296
;  :binary-propagations     11
;  :conflicts               433
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16438
;  :mk-clause               10991
;  :num-allocs              7000598
;  :num-checks              328
;  :propagations            7045
;  :quant-instantiations    2918
;  :rlimit-count            409052)
(assert (forall ((i@62@05 Int)) (!
  (implies
    (and
      (<
        i@62@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))))
      (<= 0 i@62@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
          i@62@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
            i@62@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
            i@62@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@05)))
    i@62@05))
  :qid |prog.l<no position>|)))
(declare-const $k@63@05 $Perm)
(assert ($Perm.isReadVar $k@63@05 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@63@05 $Perm.No) (< $Perm.No $k@63@05))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2089
;  :arith-assert-lower      4454
;  :arith-assert-upper      2877
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2900
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1296
;  :binary-propagations     11
;  :conflicts               434
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16443
;  :mk-clause               10993
;  :num-allocs              7000598
;  :num-checks              329
;  :propagations            7046
;  :quant-instantiations    2918
;  :rlimit-count            409576)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@45@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2089
;  :arith-assert-lower      4454
;  :arith-assert-upper      2877
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2900
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1296
;  :binary-propagations     11
;  :conflicts               434
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16443
;  :mk-clause               10993
;  :num-allocs              7000598
;  :num-checks              330
;  :propagations            7046
;  :quant-instantiations    2918
;  :rlimit-count            409587)
(assert (< $k@63@05 $k@45@05))
(assert (<= $Perm.No (- $k@45@05 $k@63@05)))
(assert (<= (- $k@45@05 $k@63@05) $Perm.Write))
(assert (implies (< $Perm.No (- $k@45@05 $k@63@05)) (not (= diz@15@05 $Ref.null))))
; [eval] diz.Main_sensor != null
(push) ; 8
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2089
;  :arith-assert-lower      4456
;  :arith-assert-upper      2878
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2900
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1297
;  :binary-propagations     11
;  :conflicts               435
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16446
;  :mk-clause               10993
;  :num-allocs              7000598
;  :num-checks              331
;  :propagations            7046
;  :quant-instantiations    2918
;  :rlimit-count            409801)
(push) ; 8
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2089
;  :arith-assert-lower      4456
;  :arith-assert-upper      2878
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2900
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1297
;  :binary-propagations     11
;  :conflicts               436
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16446
;  :mk-clause               10993
;  :num-allocs              7000598
;  :num-checks              332
;  :propagations            7046
;  :quant-instantiations    2918
;  :rlimit-count            409849)
(push) ; 8
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2089
;  :arith-assert-lower      4456
;  :arith-assert-upper      2878
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2900
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1297
;  :binary-propagations     11
;  :conflicts               437
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16446
;  :mk-clause               10993
;  :num-allocs              7000598
;  :num-checks              333
;  :propagations            7046
;  :quant-instantiations    2918
;  :rlimit-count            409897)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2089
;  :arith-assert-lower      4456
;  :arith-assert-upper      2878
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2900
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1297
;  :binary-propagations     11
;  :conflicts               437
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16446
;  :mk-clause               10993
;  :num-allocs              7000598
;  :num-checks              334
;  :propagations            7046
;  :quant-instantiations    2918
;  :rlimit-count            409910)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2089
;  :arith-assert-lower      4456
;  :arith-assert-upper      2878
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2900
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1297
;  :binary-propagations     11
;  :conflicts               438
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16446
;  :mk-clause               10993
;  :num-allocs              7000598
;  :num-checks              335
;  :propagations            7046
;  :quant-instantiations    2918
;  :rlimit-count            409958)
(declare-const $k@64@05 $Perm)
(assert ($Perm.isReadVar $k@64@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 8
(assert (not (or (= $k@64@05 $Perm.No) (< $Perm.No $k@64@05))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2090
;  :arith-assert-lower      4458
;  :arith-assert-upper      2879
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2901
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1297
;  :binary-propagations     11
;  :conflicts               439
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16450
;  :mk-clause               10995
;  :num-allocs              7000598
;  :num-checks              336
;  :propagations            7047
;  :quant-instantiations    2918
;  :rlimit-count            410157)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@46@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2090
;  :arith-assert-lower      4458
;  :arith-assert-upper      2879
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2901
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1297
;  :binary-propagations     11
;  :conflicts               439
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16450
;  :mk-clause               10995
;  :num-allocs              7000598
;  :num-checks              337
;  :propagations            7047
;  :quant-instantiations    2918
;  :rlimit-count            410168)
(assert (< $k@64@05 $k@46@05))
(assert (<= $Perm.No (- $k@46@05 $k@64@05)))
(assert (<= (- $k@46@05 $k@64@05) $Perm.Write))
(assert (implies (< $Perm.No (- $k@46@05 $k@64@05)) (not (= diz@15@05 $Ref.null))))
; [eval] diz.Main_controller != null
(push) ; 8
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2090
;  :arith-assert-lower      4460
;  :arith-assert-upper      2880
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2901
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1297
;  :binary-propagations     11
;  :conflicts               440
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16453
;  :mk-clause               10995
;  :num-allocs              7000598
;  :num-checks              338
;  :propagations            7047
;  :quant-instantiations    2918
;  :rlimit-count            410376)
(push) ; 8
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2090
;  :arith-assert-lower      4460
;  :arith-assert-upper      2880
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2901
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1297
;  :binary-propagations     11
;  :conflicts               441
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16453
;  :mk-clause               10995
;  :num-allocs              7000598
;  :num-checks              339
;  :propagations            7047
;  :quant-instantiations    2918
;  :rlimit-count            410424)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2090
;  :arith-assert-lower      4460
;  :arith-assert-upper      2880
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2901
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1297
;  :binary-propagations     11
;  :conflicts               441
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16453
;  :mk-clause               10995
;  :num-allocs              7000598
;  :num-checks              340
;  :propagations            7047
;  :quant-instantiations    2918
;  :rlimit-count            410437)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26357
;  :arith-add-rows          2234
;  :arith-assert-diseq      2090
;  :arith-assert-lower      4460
;  :arith-assert-upper      2880
;  :arith-bound-prop        461
;  :arith-conflicts         64
;  :arith-eq-adapter        2901
;  :arith-fixed-eqs         1517
;  :arith-offset-eqs        391
;  :arith-pivots            1297
;  :binary-propagations     11
;  :conflicts               442
;  :datatype-accessor-ax    563
;  :datatype-constructor-ax 3908
;  :datatype-occurs-check   1558
;  :datatype-splits         2690
;  :decisions               4696
;  :del-clause              10743
;  :final-checks            426
;  :interface-eqs           153
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16453
;  :mk-clause               10995
;  :num-allocs              7000598
;  :num-checks              341
;  :propagations            7047
;  :quant-instantiations    2918
;  :rlimit-count            410485)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@60@05))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))))
                                ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))))))))))))))))))))) diz@15@05 globals@16@05))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 7
(push) ; 7
; [else-branch: 45 | min_advance__31@54@05 != -1]
(assert (not (= min_advance__31@54@05 (- 0 1))))
(pop) ; 7
; [eval] !(min_advance__31 == -1)
; [eval] min_advance__31 == -1
; [eval] -1
(push) ; 7
(assert (not (= min_advance__31@54@05 (- 0 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26513
;  :arith-add-rows          2235
;  :arith-assert-diseq      2108
;  :arith-assert-lower      4484
;  :arith-assert-upper      2897
;  :arith-bound-prop        465
;  :arith-conflicts         64
;  :arith-eq-adapter        2917
;  :arith-fixed-eqs         1522
;  :arith-offset-eqs        391
;  :arith-pivots            1306
;  :binary-propagations     11
;  :conflicts               443
;  :datatype-accessor-ax    566
;  :datatype-constructor-ax 3938
;  :datatype-occurs-check   1572
;  :datatype-splits         2714
;  :decisions               4735
;  :del-clause              10930
;  :final-checks            431
;  :interface-eqs           155
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16529
;  :mk-clause               11054
;  :num-allocs              7000598
;  :num-checks              342
;  :propagations            7090
;  :quant-instantiations    2926
;  :rlimit-count            412265
;  :time                    0.00)
(push) ; 7
(assert (not (not (= min_advance__31@54@05 (- 0 1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26669
;  :arith-add-rows          2235
;  :arith-assert-diseq      2124
;  :arith-assert-lower      4505
;  :arith-assert-upper      2919
;  :arith-bound-prop        469
;  :arith-conflicts         64
;  :arith-eq-adapter        2933
;  :arith-fixed-eqs         1527
;  :arith-offset-eqs        391
;  :arith-pivots            1310
;  :binary-propagations     11
;  :conflicts               444
;  :datatype-accessor-ax    569
;  :datatype-constructor-ax 3968
;  :datatype-occurs-check   1586
;  :datatype-splits         2738
;  :decisions               4772
;  :del-clause              10988
;  :final-checks            436
;  :interface-eqs           157
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16606
;  :mk-clause               11112
;  :num-allocs              7000598
;  :num-checks              343
;  :propagations            7134
;  :quant-instantiations    2934
;  :rlimit-count            413876
;  :time                    0.00)
; [then-branch: 93 | min_advance__31@54@05 != -1 | live]
; [else-branch: 93 | min_advance__31@54@05 == -1 | live]
(push) ; 7
; [then-branch: 93 | min_advance__31@54@05 != -1]
(assert (not (= min_advance__31@54@05 (- 0 1))))
; [exec]
; __flatten_31__30 := Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__31), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__31), (diz.Main_event_state[2] < -1 ? -3 : diz.Main_event_state[2] - min_advance__31))
; [eval] Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__31), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__31), (diz.Main_event_state[2] < -1 ? -3 : diz.Main_event_state[2] - min_advance__31))
; [eval] (diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__31)
; [eval] diz.Main_event_state[0] < -1
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26670
;  :arith-add-rows          2235
;  :arith-assert-diseq      2126
;  :arith-assert-lower      4505
;  :arith-assert-upper      2919
;  :arith-bound-prop        469
;  :arith-conflicts         64
;  :arith-eq-adapter        2934
;  :arith-fixed-eqs         1527
;  :arith-offset-eqs        391
;  :arith-pivots            1310
;  :binary-propagations     11
;  :conflicts               444
;  :datatype-accessor-ax    569
;  :datatype-constructor-ax 3968
;  :datatype-occurs-check   1586
;  :datatype-splits         2738
;  :decisions               4772
;  :del-clause              10988
;  :final-checks            436
;  :interface-eqs           157
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16610
;  :mk-clause               11121
;  :num-allocs              7000598
;  :num-checks              344
;  :propagations            7134
;  :quant-instantiations    2934
;  :rlimit-count            413966)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26824
;  :arith-add-rows          2235
;  :arith-assert-diseq      2142
;  :arith-assert-lower      4531
;  :arith-assert-upper      2936
;  :arith-bound-prop        473
;  :arith-conflicts         64
;  :arith-eq-adapter        2949
;  :arith-fixed-eqs         1532
;  :arith-offset-eqs        391
;  :arith-pivots            1316
;  :binary-propagations     11
;  :conflicts               445
;  :datatype-accessor-ax    572
;  :datatype-constructor-ax 3998
;  :datatype-occurs-check   1600
;  :datatype-splits         2762
;  :decisions               4810
;  :del-clause              11035
;  :final-checks            441
;  :interface-eqs           159
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16684
;  :mk-clause               11168
;  :num-allocs              7000598
;  :num-checks              345
;  :propagations            7176
;  :quant-instantiations    2942
;  :rlimit-count            415672
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26978
;  :arith-add-rows          2239
;  :arith-assert-diseq      2158
;  :arith-assert-lower      4556
;  :arith-assert-upper      2953
;  :arith-bound-prop        477
;  :arith-conflicts         64
;  :arith-eq-adapter        2964
;  :arith-fixed-eqs         1537
;  :arith-offset-eqs        391
;  :arith-pivots            1323
;  :binary-propagations     11
;  :conflicts               446
;  :datatype-accessor-ax    575
;  :datatype-constructor-ax 4028
;  :datatype-occurs-check   1614
;  :datatype-splits         2786
;  :decisions               4848
;  :del-clause              11084
;  :final-checks            446
;  :interface-eqs           161
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16757
;  :mk-clause               11217
;  :num-allocs              7000598
;  :num-checks              346
;  :propagations            7219
;  :quant-instantiations    2950
;  :rlimit-count            417414
;  :time                    0.00)
; [then-branch: 94 | First:(Second:(Second:(Second:($t@52@05))))[0] < -1 | live]
; [else-branch: 94 | !(First:(Second:(Second:(Second:($t@52@05))))[0] < -1) | live]
(push) ; 9
; [then-branch: 94 | First:(Second:(Second:(Second:($t@52@05))))[0] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    0)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 94 | !(First:(Second:(Second:(Second:($t@52@05))))[0] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] - min_advance__31
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26978
;  :arith-add-rows          2239
;  :arith-assert-diseq      2158
;  :arith-assert-lower      4558
;  :arith-assert-upper      2953
;  :arith-bound-prop        477
;  :arith-conflicts         64
;  :arith-eq-adapter        2964
;  :arith-fixed-eqs         1537
;  :arith-offset-eqs        391
;  :arith-pivots            1323
;  :binary-propagations     11
;  :conflicts               446
;  :datatype-accessor-ax    575
;  :datatype-constructor-ax 4028
;  :datatype-occurs-check   1614
;  :datatype-splits         2786
;  :decisions               4848
;  :del-clause              11084
;  :final-checks            446
;  :interface-eqs           161
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16757
;  :mk-clause               11217
;  :num-allocs              7000598
;  :num-checks              347
;  :propagations            7221
;  :quant-instantiations    2950
;  :rlimit-count            417577)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
; [eval] (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__31)
; [eval] diz.Main_event_state[1] < -1
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26978
;  :arith-add-rows          2239
;  :arith-assert-diseq      2158
;  :arith-assert-lower      4558
;  :arith-assert-upper      2953
;  :arith-bound-prop        477
;  :arith-conflicts         64
;  :arith-eq-adapter        2964
;  :arith-fixed-eqs         1537
;  :arith-offset-eqs        391
;  :arith-pivots            1323
;  :binary-propagations     11
;  :conflicts               446
;  :datatype-accessor-ax    575
;  :datatype-constructor-ax 4028
;  :datatype-occurs-check   1614
;  :datatype-splits         2786
;  :decisions               4848
;  :del-clause              11084
;  :final-checks            446
;  :interface-eqs           161
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16757
;  :mk-clause               11217
;  :num-allocs              7000598
;  :num-checks              348
;  :propagations            7221
;  :quant-instantiations    2950
;  :rlimit-count            417592)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27132
;  :arith-add-rows          2239
;  :arith-assert-diseq      2174
;  :arith-assert-lower      4583
;  :arith-assert-upper      2970
;  :arith-bound-prop        481
;  :arith-conflicts         64
;  :arith-eq-adapter        2979
;  :arith-fixed-eqs         1542
;  :arith-offset-eqs        391
;  :arith-pivots            1327
;  :binary-propagations     11
;  :conflicts               447
;  :datatype-accessor-ax    578
;  :datatype-constructor-ax 4058
;  :datatype-occurs-check   1628
;  :datatype-splits         2810
;  :decisions               4886
;  :del-clause              11131
;  :final-checks            451
;  :interface-eqs           163
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16830
;  :mk-clause               11264
;  :num-allocs              7000598
;  :num-checks              349
;  :propagations            7263
;  :quant-instantiations    2958
;  :rlimit-count            419277
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    1)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27286
;  :arith-add-rows          2243
;  :arith-assert-diseq      2190
;  :arith-assert-lower      4609
;  :arith-assert-upper      2987
;  :arith-bound-prop        485
;  :arith-conflicts         64
;  :arith-eq-adapter        2994
;  :arith-fixed-eqs         1547
;  :arith-offset-eqs        391
;  :arith-pivots            1334
;  :binary-propagations     11
;  :conflicts               448
;  :datatype-accessor-ax    581
;  :datatype-constructor-ax 4088
;  :datatype-occurs-check   1642
;  :datatype-splits         2834
;  :decisions               4924
;  :del-clause              11182
;  :final-checks            456
;  :interface-eqs           165
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16904
;  :mk-clause               11315
;  :num-allocs              7000598
;  :num-checks              350
;  :propagations            7307
;  :quant-instantiations    2966
;  :rlimit-count            421030
;  :time                    0.00)
; [then-branch: 95 | First:(Second:(Second:(Second:($t@52@05))))[1] < -1 | live]
; [else-branch: 95 | !(First:(Second:(Second:(Second:($t@52@05))))[1] < -1) | live]
(push) ; 9
; [then-branch: 95 | First:(Second:(Second:(Second:($t@52@05))))[1] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    1)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 95 | !(First:(Second:(Second:(Second:($t@52@05))))[1] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] - min_advance__31
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27286
;  :arith-add-rows          2243
;  :arith-assert-diseq      2190
;  :arith-assert-lower      4611
;  :arith-assert-upper      2987
;  :arith-bound-prop        485
;  :arith-conflicts         64
;  :arith-eq-adapter        2994
;  :arith-fixed-eqs         1547
;  :arith-offset-eqs        391
;  :arith-pivots            1334
;  :binary-propagations     11
;  :conflicts               448
;  :datatype-accessor-ax    581
;  :datatype-constructor-ax 4088
;  :datatype-occurs-check   1642
;  :datatype-splits         2834
;  :decisions               4924
;  :del-clause              11182
;  :final-checks            456
;  :interface-eqs           165
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16904
;  :mk-clause               11315
;  :num-allocs              7000598
;  :num-checks              351
;  :propagations            7309
;  :quant-instantiations    2966
;  :rlimit-count            421193)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
; [eval] (diz.Main_event_state[2] < -1 ? -3 : diz.Main_event_state[2] - min_advance__31)
; [eval] diz.Main_event_state[2] < -1
; [eval] diz.Main_event_state[2]
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27286
;  :arith-add-rows          2243
;  :arith-assert-diseq      2190
;  :arith-assert-lower      4611
;  :arith-assert-upper      2987
;  :arith-bound-prop        485
;  :arith-conflicts         64
;  :arith-eq-adapter        2994
;  :arith-fixed-eqs         1547
;  :arith-offset-eqs        391
;  :arith-pivots            1334
;  :binary-propagations     11
;  :conflicts               448
;  :datatype-accessor-ax    581
;  :datatype-constructor-ax 4088
;  :datatype-occurs-check   1642
;  :datatype-splits         2834
;  :decisions               4924
;  :del-clause              11182
;  :final-checks            456
;  :interface-eqs           165
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16904
;  :mk-clause               11315
;  :num-allocs              7000598
;  :num-checks              352
;  :propagations            7309
;  :quant-instantiations    2966
;  :rlimit-count            421208)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27440
;  :arith-add-rows          2243
;  :arith-assert-diseq      2206
;  :arith-assert-lower      4636
;  :arith-assert-upper      3004
;  :arith-bound-prop        489
;  :arith-conflicts         64
;  :arith-eq-adapter        3009
;  :arith-fixed-eqs         1552
;  :arith-offset-eqs        391
;  :arith-pivots            1340
;  :binary-propagations     11
;  :conflicts               449
;  :datatype-accessor-ax    584
;  :datatype-constructor-ax 4118
;  :datatype-occurs-check   1656
;  :datatype-splits         2858
;  :decisions               4962
;  :del-clause              11229
;  :final-checks            461
;  :interface-eqs           167
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             16977
;  :mk-clause               11362
;  :num-allocs              7000598
;  :num-checks              353
;  :propagations            7351
;  :quant-instantiations    2974
;  :rlimit-count            422901
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    2)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27594
;  :arith-add-rows          2247
;  :arith-assert-diseq      2222
;  :arith-assert-lower      4661
;  :arith-assert-upper      3021
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3024
;  :arith-fixed-eqs         1557
;  :arith-offset-eqs        391
;  :arith-pivots            1347
;  :binary-propagations     11
;  :conflicts               450
;  :datatype-accessor-ax    587
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11278
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17050
;  :mk-clause               11411
;  :num-allocs              7000598
;  :num-checks              354
;  :propagations            7394
;  :quant-instantiations    2982
;  :rlimit-count            424647
;  :time                    0.00)
; [then-branch: 96 | First:(Second:(Second:(Second:($t@52@05))))[2] < -1 | live]
; [else-branch: 96 | !(First:(Second:(Second:(Second:($t@52@05))))[2] < -1) | live]
(push) ; 9
; [then-branch: 96 | First:(Second:(Second:(Second:($t@52@05))))[2] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
    2)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 96 | !(First:(Second:(Second:(Second:($t@52@05))))[2] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
      2)
    (- 0 1))))
; [eval] diz.Main_event_state[2] - min_advance__31
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27594
;  :arith-add-rows          2247
;  :arith-assert-diseq      2222
;  :arith-assert-lower      4663
;  :arith-assert-upper      3021
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3024
;  :arith-fixed-eqs         1557
;  :arith-offset-eqs        391
;  :arith-pivots            1347
;  :binary-propagations     11
;  :conflicts               450
;  :datatype-accessor-ax    587
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11278
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17050
;  :mk-clause               11411
;  :num-allocs              7000598
;  :num-checks              355
;  :propagations            7396
;  :quant-instantiations    2982
;  :rlimit-count            424810)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (=
  (Seq_length
    (Seq_append
      (Seq_append
        (Seq_singleton (ite
          (<
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
              0)
            (- 0 1))
          (- 0 3)
          (-
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
              0)
            min_advance__31@54@05)))
        (Seq_singleton (ite
          (<
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
              1)
            (- 0 1))
          (- 0 3)
          (-
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
              1)
            min_advance__31@54@05))))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
            2)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
            2)
          min_advance__31@54@05)))))
  3))
(declare-const __flatten_31__30@65@05 Seq<Int>)
(assert (Seq_equal
  __flatten_31__30@65@05
  (Seq_append
    (Seq_append
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
            0)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
            0)
          min_advance__31@54@05)))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
            1)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
            1)
          min_advance__31@54@05))))
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
          2)
        (- 0 1))
      (- 0 3)
      (-
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))
          2)
        min_advance__31@54@05))))))
; [exec]
; __flatten_30__29 := __flatten_31__30
; [exec]
; diz.Main_event_state := __flatten_30__29
; [exec]
; Main_wakeup_after_wait_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(push) ; 8
(assert (not (= (Seq_length __flatten_31__30@65@05) 3)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27603
;  :arith-add-rows          2252
;  :arith-assert-diseq      2222
;  :arith-assert-lower      4667
;  :arith-assert-upper      3024
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3029
;  :arith-fixed-eqs         1559
;  :arith-offset-eqs        392
;  :arith-pivots            1349
;  :binary-propagations     11
;  :conflicts               451
;  :datatype-accessor-ax    587
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11278
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17085
;  :mk-clause               11438
;  :num-allocs              7000598
;  :num-checks              356
;  :propagations            7403
;  :quant-instantiations    2986
;  :rlimit-count            425720)
(assert (= (Seq_length __flatten_31__30@65@05) 3))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@66@05 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 97 | 0 <= i@66@05 | live]
; [else-branch: 97 | !(0 <= i@66@05) | live]
(push) ; 10
; [then-branch: 97 | 0 <= i@66@05]
(assert (<= 0 i@66@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 97 | !(0 <= i@66@05)]
(assert (not (<= 0 i@66@05)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 98 | i@66@05 < |First:(Second:($t@52@05))| && 0 <= i@66@05 | live]
; [else-branch: 98 | !(i@66@05 < |First:(Second:($t@52@05))| && 0 <= i@66@05) | live]
(push) ; 10
; [then-branch: 98 | i@66@05 < |First:(Second:($t@52@05))| && 0 <= i@66@05]
(assert (and
  (<
    i@66@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
  (<= 0 i@66@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@66@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27604
;  :arith-add-rows          2252
;  :arith-assert-diseq      2222
;  :arith-assert-lower      4669
;  :arith-assert-upper      3026
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3030
;  :arith-fixed-eqs         1559
;  :arith-offset-eqs        392
;  :arith-pivots            1349
;  :binary-propagations     11
;  :conflicts               451
;  :datatype-accessor-ax    587
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11278
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17090
;  :mk-clause               11438
;  :num-allocs              7000598
;  :num-checks              357
;  :propagations            7403
;  :quant-instantiations    2986
;  :rlimit-count            425907)
; [eval] -1
(push) ; 11
; [then-branch: 99 | First:(Second:($t@52@05))[i@66@05] == -1 | live]
; [else-branch: 99 | First:(Second:($t@52@05))[i@66@05] != -1 | live]
(push) ; 12
; [then-branch: 99 | First:(Second:($t@52@05))[i@66@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@66@05)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 99 | First:(Second:($t@52@05))[i@66@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      i@66@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@66@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27608
;  :arith-add-rows          2252
;  :arith-assert-diseq      2224
;  :arith-assert-lower      4676
;  :arith-assert-upper      3029
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3033
;  :arith-fixed-eqs         1560
;  :arith-offset-eqs        392
;  :arith-pivots            1350
;  :binary-propagations     11
;  :conflicts               451
;  :datatype-accessor-ax    587
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11278
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17105
;  :mk-clause               11455
;  :num-allocs              7000598
;  :num-checks              358
;  :propagations            7410
;  :quant-instantiations    2989
;  :rlimit-count            426213)
(push) ; 13
; [then-branch: 100 | 0 <= First:(Second:($t@52@05))[i@66@05] | live]
; [else-branch: 100 | !(0 <= First:(Second:($t@52@05))[i@66@05]) | live]
(push) ; 14
; [then-branch: 100 | 0 <= First:(Second:($t@52@05))[i@66@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@66@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@66@05 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27608
;  :arith-add-rows          2252
;  :arith-assert-diseq      2224
;  :arith-assert-lower      4676
;  :arith-assert-upper      3029
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3033
;  :arith-fixed-eqs         1560
;  :arith-offset-eqs        392
;  :arith-pivots            1350
;  :binary-propagations     11
;  :conflicts               451
;  :datatype-accessor-ax    587
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11278
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17105
;  :mk-clause               11455
;  :num-allocs              7000598
;  :num-checks              359
;  :propagations            7410
;  :quant-instantiations    2989
;  :rlimit-count            426307)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 100 | !(0 <= First:(Second:($t@52@05))[i@66@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      i@66@05))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 98 | !(i@66@05 < |First:(Second:($t@52@05))| && 0 <= i@66@05)]
(assert (not
  (and
    (<
      i@66@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
    (<= 0 i@66@05))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@66@05 Int)) (!
  (implies
    (and
      (<
        i@66@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
      (<= 0 i@66@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          i@66@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@66@05)
          (Seq_length __flatten_31__30@65@05))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@66@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@66@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27608
;  :arith-add-rows          2252
;  :arith-assert-diseq      2225
;  :arith-assert-lower      4677
;  :arith-assert-upper      3030
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3034
;  :arith-fixed-eqs         1560
;  :arith-offset-eqs        392
;  :arith-pivots            1351
;  :binary-propagations     11
;  :conflicts               452
;  :datatype-accessor-ax    587
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11313
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17117
;  :mk-clause               11473
;  :num-allocs              7000598
;  :num-checks              360
;  :propagations            7412
;  :quant-instantiations    2992
;  :rlimit-count            426798)
(assert (forall ((i@66@05 Int)) (!
  (implies
    (and
      (<
        i@66@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
      (<= 0 i@66@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          i@66@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@66@05)
          (Seq_length __flatten_31__30@65@05))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@66@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@66@05))
  :qid |prog.l<no position>|)))
(declare-const $t@67@05 $Snap)
(assert (= $t@67@05 ($Snap.combine ($Snap.first $t@67@05) ($Snap.second $t@67@05))))
(assert (=
  ($Snap.second $t@67@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@67@05))
    ($Snap.second ($Snap.second $t@67@05)))))
(assert (=
  ($Snap.second ($Snap.second $t@67@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@67@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@67@05))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@67@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@68@05 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 101 | 0 <= i@68@05 | live]
; [else-branch: 101 | !(0 <= i@68@05) | live]
(push) ; 10
; [then-branch: 101 | 0 <= i@68@05]
(assert (<= 0 i@68@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 101 | !(0 <= i@68@05)]
(assert (not (<= 0 i@68@05)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 102 | i@68@05 < |First:(Second:($t@67@05))| && 0 <= i@68@05 | live]
; [else-branch: 102 | !(i@68@05 < |First:(Second:($t@67@05))| && 0 <= i@68@05) | live]
(push) ; 10
; [then-branch: 102 | i@68@05 < |First:(Second:($t@67@05))| && 0 <= i@68@05]
(assert (and
  (<
    i@68@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))
  (<= 0 i@68@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@68@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27645
;  :arith-add-rows          2252
;  :arith-assert-diseq      2225
;  :arith-assert-lower      4682
;  :arith-assert-upper      3033
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3036
;  :arith-fixed-eqs         1560
;  :arith-offset-eqs        392
;  :arith-pivots            1351
;  :binary-propagations     11
;  :conflicts               452
;  :datatype-accessor-ax    593
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11313
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17139
;  :mk-clause               11473
;  :num-allocs              7000598
;  :num-checks              361
;  :propagations            7412
;  :quant-instantiations    2998
;  :rlimit-count            428238)
; [eval] -1
(push) ; 11
; [then-branch: 103 | First:(Second:($t@67@05))[i@68@05] == -1 | live]
; [else-branch: 103 | First:(Second:($t@67@05))[i@68@05] != -1 | live]
(push) ; 12
; [then-branch: 103 | First:(Second:($t@67@05))[i@68@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
    i@68@05)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 103 | First:(Second:($t@67@05))[i@68@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
      i@68@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@68@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27645
;  :arith-add-rows          2252
;  :arith-assert-diseq      2225
;  :arith-assert-lower      4682
;  :arith-assert-upper      3033
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3036
;  :arith-fixed-eqs         1560
;  :arith-offset-eqs        392
;  :arith-pivots            1351
;  :binary-propagations     11
;  :conflicts               452
;  :datatype-accessor-ax    593
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11313
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17140
;  :mk-clause               11473
;  :num-allocs              7000598
;  :num-checks              362
;  :propagations            7412
;  :quant-instantiations    2998
;  :rlimit-count            428389)
(push) ; 13
; [then-branch: 104 | 0 <= First:(Second:($t@67@05))[i@68@05] | live]
; [else-branch: 104 | !(0 <= First:(Second:($t@67@05))[i@68@05]) | live]
(push) ; 14
; [then-branch: 104 | 0 <= First:(Second:($t@67@05))[i@68@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
    i@68@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@68@05 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27645
;  :arith-add-rows          2252
;  :arith-assert-diseq      2226
;  :arith-assert-lower      4685
;  :arith-assert-upper      3033
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3037
;  :arith-fixed-eqs         1560
;  :arith-offset-eqs        392
;  :arith-pivots            1351
;  :binary-propagations     11
;  :conflicts               452
;  :datatype-accessor-ax    593
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11313
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17143
;  :mk-clause               11474
;  :num-allocs              7000598
;  :num-checks              363
;  :propagations            7412
;  :quant-instantiations    2998
;  :rlimit-count            428493)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 104 | !(0 <= First:(Second:($t@67@05))[i@68@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
      i@68@05))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 102 | !(i@68@05 < |First:(Second:($t@67@05))| && 0 <= i@68@05)]
(assert (not
  (and
    (<
      i@68@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))
    (<= 0 i@68@05))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@68@05 Int)) (!
  (implies
    (and
      (<
        i@68@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))
      (<= 0 i@68@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
          i@68@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
            i@68@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
            i@68@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
    i@68@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
  __flatten_31__30@65@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1) ==> diz.Main_process_state[0] == -1
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27665
;  :arith-add-rows          2252
;  :arith-assert-diseq      2226
;  :arith-assert-lower      4686
;  :arith-assert-upper      3034
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3039
;  :arith-fixed-eqs         1561
;  :arith-offset-eqs        392
;  :arith-pivots            1351
;  :binary-propagations     11
;  :conflicts               452
;  :datatype-accessor-ax    595
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11314
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17166
;  :mk-clause               11490
;  :num-allocs              7000598
;  :num-checks              364
;  :propagations            7418
;  :quant-instantiations    3000
;  :rlimit-count            429534)
(push) ; 8
; [then-branch: 105 | 0 <= First:(Second:($t@52@05))[0] | live]
; [else-branch: 105 | !(0 <= First:(Second:($t@52@05))[0]) | live]
(push) ; 9
; [then-branch: 105 | 0 <= First:(Second:($t@52@05))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27665
;  :arith-add-rows          2252
;  :arith-assert-diseq      2226
;  :arith-assert-lower      4686
;  :arith-assert-upper      3034
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3039
;  :arith-fixed-eqs         1561
;  :arith-offset-eqs        392
;  :arith-pivots            1351
;  :binary-propagations     11
;  :conflicts               452
;  :datatype-accessor-ax    595
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11314
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17166
;  :mk-clause               11490
;  :num-allocs              7000598
;  :num-checks              365
;  :propagations            7418
;  :quant-instantiations    3000
;  :rlimit-count            429634)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27665
;  :arith-add-rows          2252
;  :arith-assert-diseq      2226
;  :arith-assert-lower      4686
;  :arith-assert-upper      3034
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3039
;  :arith-fixed-eqs         1561
;  :arith-offset-eqs        392
;  :arith-pivots            1351
;  :binary-propagations     11
;  :conflicts               452
;  :datatype-accessor-ax    595
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11314
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17166
;  :mk-clause               11490
;  :num-allocs              7000598
;  :num-checks              366
;  :propagations            7418
;  :quant-instantiations    3000
;  :rlimit-count            429643)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  (Seq_length __flatten_31__30@65@05))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27665
;  :arith-add-rows          2252
;  :arith-assert-diseq      2226
;  :arith-assert-lower      4686
;  :arith-assert-upper      3034
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3039
;  :arith-fixed-eqs         1561
;  :arith-offset-eqs        392
;  :arith-pivots            1351
;  :binary-propagations     11
;  :conflicts               453
;  :datatype-accessor-ax    595
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11314
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17166
;  :mk-clause               11490
;  :num-allocs              7000598
;  :num-checks              367
;  :propagations            7418
;  :quant-instantiations    3000
;  :rlimit-count            429731)
(push) ; 10
; [then-branch: 106 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0 | live]
; [else-branch: 106 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] != 0 | live]
(push) ; 11
; [then-branch: 106 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@65@05
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 106 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@65@05
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 12
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27666
;  :arith-add-rows          2253
;  :arith-assert-diseq      2226
;  :arith-assert-lower      4686
;  :arith-assert-upper      3034
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3039
;  :arith-fixed-eqs         1561
;  :arith-offset-eqs        392
;  :arith-pivots            1351
;  :binary-propagations     11
;  :conflicts               453
;  :datatype-accessor-ax    595
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11314
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17171
;  :mk-clause               11495
;  :num-allocs              7000598
;  :num-checks              368
;  :propagations            7418
;  :quant-instantiations    3001
;  :rlimit-count            429946)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27666
;  :arith-add-rows          2253
;  :arith-assert-diseq      2226
;  :arith-assert-lower      4686
;  :arith-assert-upper      3034
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3039
;  :arith-fixed-eqs         1561
;  :arith-offset-eqs        392
;  :arith-pivots            1351
;  :binary-propagations     11
;  :conflicts               453
;  :datatype-accessor-ax    595
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11314
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17171
;  :mk-clause               11495
;  :num-allocs              7000598
;  :num-checks              369
;  :propagations            7418
;  :quant-instantiations    3001
;  :rlimit-count            429955)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  (Seq_length __flatten_31__30@65@05))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27666
;  :arith-add-rows          2253
;  :arith-assert-diseq      2226
;  :arith-assert-lower      4686
;  :arith-assert-upper      3034
;  :arith-bound-prop        493
;  :arith-conflicts         64
;  :arith-eq-adapter        3039
;  :arith-fixed-eqs         1561
;  :arith-offset-eqs        392
;  :arith-pivots            1351
;  :binary-propagations     11
;  :conflicts               454
;  :datatype-accessor-ax    595
;  :datatype-constructor-ax 4148
;  :datatype-occurs-check   1670
;  :datatype-splits         2882
;  :decisions               5000
;  :del-clause              11314
;  :final-checks            466
;  :interface-eqs           169
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17171
;  :mk-clause               11495
;  :num-allocs              7000598
;  :num-checks              370
;  :propagations            7418
;  :quant-instantiations    3001
;  :rlimit-count            430043)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 105 | !(0 <= First:(Second:($t@52@05))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28023
;  :arith-add-rows          2267
;  :arith-assert-diseq      2251
;  :arith-assert-lower      4746
;  :arith-assert-upper      3079
;  :arith-bound-prop        498
;  :arith-conflicts         64
;  :arith-eq-adapter        3081
;  :arith-fixed-eqs         1583
;  :arith-offset-eqs        395
;  :arith-pivots            1376
;  :binary-propagations     11
;  :conflicts               460
;  :datatype-accessor-ax    600
;  :datatype-constructor-ax 4204
;  :datatype-occurs-check   1692
;  :datatype-splits         2914
;  :decisions               5073
;  :del-clause              11474
;  :final-checks            472
;  :interface-eqs           171
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          483
;  :mk-bool-var             17394
;  :mk-clause               11650
;  :num-allocs              7000598
;  :num-checks              371
;  :propagations            7511
;  :quant-instantiations    3037
;  :rlimit-count            433549
;  :time                    0.00)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28427
;  :arith-add-rows          2318
;  :arith-assert-diseq      2281
;  :arith-assert-lower      4813
;  :arith-assert-upper      3126
;  :arith-bound-prop        505
;  :arith-conflicts         65
;  :arith-eq-adapter        3129
;  :arith-fixed-eqs         1612
;  :arith-offset-eqs        405
;  :arith-pivots            1400
;  :binary-propagations     11
;  :conflicts               468
;  :datatype-accessor-ax    605
;  :datatype-constructor-ax 4260
;  :datatype-occurs-check   1714
;  :datatype-splits         2946
;  :decisions               5146
;  :del-clause              11663
;  :final-checks            479
;  :interface-eqs           174
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          501
;  :mk-bool-var             17659
;  :mk-clause               11839
;  :num-allocs              7000598
;  :num-checks              372
;  :propagations            7616
;  :quant-instantiations    3083
;  :rlimit-count            438006
;  :time                    0.00)
; [then-branch: 107 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0] | live]
; [else-branch: 107 | !(__flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0]) | live]
(push) ; 9
; [then-branch: 107 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28427
;  :arith-add-rows          2318
;  :arith-assert-diseq      2281
;  :arith-assert-lower      4813
;  :arith-assert-upper      3126
;  :arith-bound-prop        505
;  :arith-conflicts         65
;  :arith-eq-adapter        3129
;  :arith-fixed-eqs         1612
;  :arith-offset-eqs        405
;  :arith-pivots            1400
;  :binary-propagations     11
;  :conflicts               468
;  :datatype-accessor-ax    605
;  :datatype-constructor-ax 4260
;  :datatype-occurs-check   1714
;  :datatype-splits         2946
;  :decisions               5146
;  :del-clause              11663
;  :final-checks            479
;  :interface-eqs           174
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          501
;  :mk-bool-var             17661
;  :mk-clause               11840
;  :num-allocs              7000598
;  :num-checks              373
;  :propagations            7616
;  :quant-instantiations    3083
;  :rlimit-count            438174)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 107 | !(__flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1) ==> diz.Main_process_state[1] == -1
; [eval] 0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[1])
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28433
;  :arith-add-rows          2318
;  :arith-assert-diseq      2281
;  :arith-assert-lower      4813
;  :arith-assert-upper      3126
;  :arith-bound-prop        505
;  :arith-conflicts         65
;  :arith-eq-adapter        3129
;  :arith-fixed-eqs         1612
;  :arith-offset-eqs        405
;  :arith-pivots            1400
;  :binary-propagations     11
;  :conflicts               468
;  :datatype-accessor-ax    606
;  :datatype-constructor-ax 4260
;  :datatype-occurs-check   1714
;  :datatype-splits         2946
;  :decisions               5146
;  :del-clause              11664
;  :final-checks            479
;  :interface-eqs           174
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          501
;  :mk-bool-var             17667
;  :mk-clause               11844
;  :num-allocs              7000598
;  :num-checks              374
;  :propagations            7616
;  :quant-instantiations    3083
;  :rlimit-count            438653)
(push) ; 8
; [then-branch: 108 | 0 <= First:(Second:($t@52@05))[1] | live]
; [else-branch: 108 | !(0 <= First:(Second:($t@52@05))[1]) | live]
(push) ; 9
; [then-branch: 108 | 0 <= First:(Second:($t@52@05))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28433
;  :arith-add-rows          2318
;  :arith-assert-diseq      2281
;  :arith-assert-lower      4813
;  :arith-assert-upper      3126
;  :arith-bound-prop        505
;  :arith-conflicts         65
;  :arith-eq-adapter        3129
;  :arith-fixed-eqs         1612
;  :arith-offset-eqs        405
;  :arith-pivots            1400
;  :binary-propagations     11
;  :conflicts               468
;  :datatype-accessor-ax    606
;  :datatype-constructor-ax 4260
;  :datatype-occurs-check   1714
;  :datatype-splits         2946
;  :decisions               5146
;  :del-clause              11664
;  :final-checks            479
;  :interface-eqs           174
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          501
;  :mk-bool-var             17667
;  :mk-clause               11844
;  :num-allocs              7000598
;  :num-checks              375
;  :propagations            7616
;  :quant-instantiations    3083
;  :rlimit-count            438753)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28433
;  :arith-add-rows          2318
;  :arith-assert-diseq      2281
;  :arith-assert-lower      4813
;  :arith-assert-upper      3126
;  :arith-bound-prop        505
;  :arith-conflicts         65
;  :arith-eq-adapter        3129
;  :arith-fixed-eqs         1612
;  :arith-offset-eqs        405
;  :arith-pivots            1400
;  :binary-propagations     11
;  :conflicts               468
;  :datatype-accessor-ax    606
;  :datatype-constructor-ax 4260
;  :datatype-occurs-check   1714
;  :datatype-splits         2946
;  :decisions               5146
;  :del-clause              11664
;  :final-checks            479
;  :interface-eqs           174
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          501
;  :mk-bool-var             17667
;  :mk-clause               11844
;  :num-allocs              7000598
;  :num-checks              376
;  :propagations            7616
;  :quant-instantiations    3083
;  :rlimit-count            438762)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  (Seq_length __flatten_31__30@65@05))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28433
;  :arith-add-rows          2318
;  :arith-assert-diseq      2281
;  :arith-assert-lower      4813
;  :arith-assert-upper      3126
;  :arith-bound-prop        505
;  :arith-conflicts         65
;  :arith-eq-adapter        3129
;  :arith-fixed-eqs         1612
;  :arith-offset-eqs        405
;  :arith-pivots            1400
;  :binary-propagations     11
;  :conflicts               469
;  :datatype-accessor-ax    606
;  :datatype-constructor-ax 4260
;  :datatype-occurs-check   1714
;  :datatype-splits         2946
;  :decisions               5146
;  :del-clause              11664
;  :final-checks            479
;  :interface-eqs           174
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          501
;  :mk-bool-var             17667
;  :mk-clause               11844
;  :num-allocs              7000598
;  :num-checks              377
;  :propagations            7616
;  :quant-instantiations    3083
;  :rlimit-count            438850)
(push) ; 10
; [then-branch: 109 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0 | live]
; [else-branch: 109 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] != 0 | live]
(push) ; 11
; [then-branch: 109 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@65@05
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 109 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@65@05
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 12
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28434
;  :arith-add-rows          2319
;  :arith-assert-diseq      2281
;  :arith-assert-lower      4813
;  :arith-assert-upper      3126
;  :arith-bound-prop        505
;  :arith-conflicts         65
;  :arith-eq-adapter        3129
;  :arith-fixed-eqs         1612
;  :arith-offset-eqs        405
;  :arith-pivots            1400
;  :binary-propagations     11
;  :conflicts               469
;  :datatype-accessor-ax    606
;  :datatype-constructor-ax 4260
;  :datatype-occurs-check   1714
;  :datatype-splits         2946
;  :decisions               5146
;  :del-clause              11664
;  :final-checks            479
;  :interface-eqs           174
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          501
;  :mk-bool-var             17672
;  :mk-clause               11849
;  :num-allocs              7000598
;  :num-checks              378
;  :propagations            7616
;  :quant-instantiations    3084
;  :rlimit-count            439023)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28434
;  :arith-add-rows          2319
;  :arith-assert-diseq      2281
;  :arith-assert-lower      4813
;  :arith-assert-upper      3126
;  :arith-bound-prop        505
;  :arith-conflicts         65
;  :arith-eq-adapter        3129
;  :arith-fixed-eqs         1612
;  :arith-offset-eqs        405
;  :arith-pivots            1400
;  :binary-propagations     11
;  :conflicts               469
;  :datatype-accessor-ax    606
;  :datatype-constructor-ax 4260
;  :datatype-occurs-check   1714
;  :datatype-splits         2946
;  :decisions               5146
;  :del-clause              11664
;  :final-checks            479
;  :interface-eqs           174
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          501
;  :mk-bool-var             17672
;  :mk-clause               11849
;  :num-allocs              7000598
;  :num-checks              379
;  :propagations            7616
;  :quant-instantiations    3084
;  :rlimit-count            439032)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  (Seq_length __flatten_31__30@65@05))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28434
;  :arith-add-rows          2319
;  :arith-assert-diseq      2281
;  :arith-assert-lower      4813
;  :arith-assert-upper      3126
;  :arith-bound-prop        505
;  :arith-conflicts         65
;  :arith-eq-adapter        3129
;  :arith-fixed-eqs         1612
;  :arith-offset-eqs        405
;  :arith-pivots            1400
;  :binary-propagations     11
;  :conflicts               470
;  :datatype-accessor-ax    606
;  :datatype-constructor-ax 4260
;  :datatype-occurs-check   1714
;  :datatype-splits         2946
;  :decisions               5146
;  :del-clause              11664
;  :final-checks            479
;  :interface-eqs           174
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          501
;  :mk-bool-var             17672
;  :mk-clause               11849
;  :num-allocs              7000598
;  :num-checks              380
;  :propagations            7616
;  :quant-instantiations    3084
;  :rlimit-count            439120)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 108 | !(0 <= First:(Second:($t@52@05))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29865
;  :arith-add-rows          2527
;  :arith-assert-diseq      2382
;  :arith-assert-lower      5039
;  :arith-assert-upper      3266
;  :arith-bound-prop        529
;  :arith-conflicts         75
;  :arith-eq-adapter        3274
;  :arith-fixed-eqs         1687
;  :arith-offset-eqs        424
;  :arith-pivots            1493
;  :binary-propagations     11
;  :conflicts               498
;  :datatype-accessor-ax    641
;  :datatype-constructor-ax 4502
;  :datatype-occurs-check   1831
;  :datatype-splits         3136
;  :decisions               5415
;  :del-clause              12196
;  :final-checks            506
;  :interface-eqs           188
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          597
;  :mk-bool-var             18529
;  :mk-clause               12376
;  :num-allocs              7000598
;  :num-checks              381
;  :propagations            7947
;  :quant-instantiations    3190
;  :rlimit-count            452144
;  :time                    0.01)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30445
;  :arith-add-rows          2605
;  :arith-assert-diseq      2423
;  :arith-assert-lower      5131
;  :arith-assert-upper      3328
;  :arith-bound-prop        539
;  :arith-conflicts         77
;  :arith-eq-adapter        3338
;  :arith-fixed-eqs         1723
;  :arith-offset-eqs        436
;  :arith-pivots            1529
;  :binary-propagations     11
;  :conflicts               508
;  :datatype-accessor-ax    651
;  :datatype-constructor-ax 4588
;  :datatype-occurs-check   1870
;  :datatype-splits         3198
;  :decisions               5523
;  :del-clause              12430
;  :final-checks            517
;  :interface-eqs           194
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          622
;  :mk-bool-var             18908
;  :mk-clause               12610
;  :num-allocs              7000598
;  :num-checks              382
;  :propagations            8080
;  :quant-instantiations    3247
;  :rlimit-count            458029
;  :time                    0.00)
; [then-branch: 110 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1] | live]
; [else-branch: 110 | !(__flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1]) | live]
(push) ; 9
; [then-branch: 110 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30445
;  :arith-add-rows          2605
;  :arith-assert-diseq      2423
;  :arith-assert-lower      5131
;  :arith-assert-upper      3328
;  :arith-bound-prop        539
;  :arith-conflicts         77
;  :arith-eq-adapter        3338
;  :arith-fixed-eqs         1723
;  :arith-offset-eqs        436
;  :arith-pivots            1529
;  :binary-propagations     11
;  :conflicts               508
;  :datatype-accessor-ax    651
;  :datatype-constructor-ax 4588
;  :datatype-occurs-check   1870
;  :datatype-splits         3198
;  :decisions               5523
;  :del-clause              12430
;  :final-checks            517
;  :interface-eqs           194
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          622
;  :mk-bool-var             18910
;  :mk-clause               12611
;  :num-allocs              7000598
;  :num-checks              383
;  :propagations            8080
;  :quant-instantiations    3247
;  :rlimit-count            458197)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 110 | !(__flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
      1)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)) ==> diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] !(0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1))
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30451
;  :arith-add-rows          2605
;  :arith-assert-diseq      2423
;  :arith-assert-lower      5131
;  :arith-assert-upper      3328
;  :arith-bound-prop        539
;  :arith-conflicts         77
;  :arith-eq-adapter        3338
;  :arith-fixed-eqs         1723
;  :arith-offset-eqs        436
;  :arith-pivots            1529
;  :binary-propagations     11
;  :conflicts               508
;  :datatype-accessor-ax    652
;  :datatype-constructor-ax 4588
;  :datatype-occurs-check   1870
;  :datatype-splits         3198
;  :decisions               5523
;  :del-clause              12431
;  :final-checks            517
;  :interface-eqs           194
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          622
;  :mk-bool-var             18916
;  :mk-clause               12615
;  :num-allocs              7000598
;  :num-checks              384
;  :propagations            8080
;  :quant-instantiations    3247
;  :rlimit-count            458686)
(push) ; 8
; [then-branch: 111 | 0 <= First:(Second:($t@52@05))[0] | live]
; [else-branch: 111 | !(0 <= First:(Second:($t@52@05))[0]) | live]
(push) ; 9
; [then-branch: 111 | 0 <= First:(Second:($t@52@05))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30451
;  :arith-add-rows          2605
;  :arith-assert-diseq      2423
;  :arith-assert-lower      5131
;  :arith-assert-upper      3328
;  :arith-bound-prop        539
;  :arith-conflicts         77
;  :arith-eq-adapter        3338
;  :arith-fixed-eqs         1723
;  :arith-offset-eqs        436
;  :arith-pivots            1529
;  :binary-propagations     11
;  :conflicts               508
;  :datatype-accessor-ax    652
;  :datatype-constructor-ax 4588
;  :datatype-occurs-check   1870
;  :datatype-splits         3198
;  :decisions               5523
;  :del-clause              12431
;  :final-checks            517
;  :interface-eqs           194
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          622
;  :mk-bool-var             18916
;  :mk-clause               12615
;  :num-allocs              7000598
;  :num-checks              385
;  :propagations            8080
;  :quant-instantiations    3247
;  :rlimit-count            458786)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30451
;  :arith-add-rows          2605
;  :arith-assert-diseq      2423
;  :arith-assert-lower      5131
;  :arith-assert-upper      3328
;  :arith-bound-prop        539
;  :arith-conflicts         77
;  :arith-eq-adapter        3338
;  :arith-fixed-eqs         1723
;  :arith-offset-eqs        436
;  :arith-pivots            1529
;  :binary-propagations     11
;  :conflicts               508
;  :datatype-accessor-ax    652
;  :datatype-constructor-ax 4588
;  :datatype-occurs-check   1870
;  :datatype-splits         3198
;  :decisions               5523
;  :del-clause              12431
;  :final-checks            517
;  :interface-eqs           194
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          622
;  :mk-bool-var             18916
;  :mk-clause               12615
;  :num-allocs              7000598
;  :num-checks              386
;  :propagations            8080
;  :quant-instantiations    3247
;  :rlimit-count            458795)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  (Seq_length __flatten_31__30@65@05))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30451
;  :arith-add-rows          2605
;  :arith-assert-diseq      2423
;  :arith-assert-lower      5131
;  :arith-assert-upper      3328
;  :arith-bound-prop        539
;  :arith-conflicts         77
;  :arith-eq-adapter        3338
;  :arith-fixed-eqs         1723
;  :arith-offset-eqs        436
;  :arith-pivots            1529
;  :binary-propagations     11
;  :conflicts               509
;  :datatype-accessor-ax    652
;  :datatype-constructor-ax 4588
;  :datatype-occurs-check   1870
;  :datatype-splits         3198
;  :decisions               5523
;  :del-clause              12431
;  :final-checks            517
;  :interface-eqs           194
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          622
;  :mk-bool-var             18916
;  :mk-clause               12615
;  :num-allocs              7000598
;  :num-checks              387
;  :propagations            8080
;  :quant-instantiations    3247
;  :rlimit-count            458883)
(push) ; 10
; [then-branch: 112 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0 | live]
; [else-branch: 112 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] != 0 | live]
(push) ; 11
; [then-branch: 112 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@65@05
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 112 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@65@05
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 12
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30452
;  :arith-add-rows          2607
;  :arith-assert-diseq      2423
;  :arith-assert-lower      5131
;  :arith-assert-upper      3328
;  :arith-bound-prop        539
;  :arith-conflicts         77
;  :arith-eq-adapter        3338
;  :arith-fixed-eqs         1723
;  :arith-offset-eqs        436
;  :arith-pivots            1529
;  :binary-propagations     11
;  :conflicts               509
;  :datatype-accessor-ax    652
;  :datatype-constructor-ax 4588
;  :datatype-occurs-check   1870
;  :datatype-splits         3198
;  :decisions               5523
;  :del-clause              12431
;  :final-checks            517
;  :interface-eqs           194
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          622
;  :mk-bool-var             18920
;  :mk-clause               12620
;  :num-allocs              7000598
;  :num-checks              388
;  :propagations            8080
;  :quant-instantiations    3248
;  :rlimit-count            459041)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30452
;  :arith-add-rows          2607
;  :arith-assert-diseq      2423
;  :arith-assert-lower      5131
;  :arith-assert-upper      3328
;  :arith-bound-prop        539
;  :arith-conflicts         77
;  :arith-eq-adapter        3338
;  :arith-fixed-eqs         1723
;  :arith-offset-eqs        436
;  :arith-pivots            1529
;  :binary-propagations     11
;  :conflicts               509
;  :datatype-accessor-ax    652
;  :datatype-constructor-ax 4588
;  :datatype-occurs-check   1870
;  :datatype-splits         3198
;  :decisions               5523
;  :del-clause              12431
;  :final-checks            517
;  :interface-eqs           194
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          622
;  :mk-bool-var             18920
;  :mk-clause               12620
;  :num-allocs              7000598
;  :num-checks              389
;  :propagations            8080
;  :quant-instantiations    3248
;  :rlimit-count            459050)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  (Seq_length __flatten_31__30@65@05))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30452
;  :arith-add-rows          2607
;  :arith-assert-diseq      2423
;  :arith-assert-lower      5131
;  :arith-assert-upper      3328
;  :arith-bound-prop        539
;  :arith-conflicts         77
;  :arith-eq-adapter        3338
;  :arith-fixed-eqs         1723
;  :arith-offset-eqs        436
;  :arith-pivots            1529
;  :binary-propagations     11
;  :conflicts               510
;  :datatype-accessor-ax    652
;  :datatype-constructor-ax 4588
;  :datatype-occurs-check   1870
;  :datatype-splits         3198
;  :decisions               5523
;  :del-clause              12431
;  :final-checks            517
;  :interface-eqs           194
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          622
;  :mk-bool-var             18920
;  :mk-clause               12620
;  :num-allocs              7000598
;  :num-checks              390
;  :propagations            8080
;  :quant-instantiations    3248
;  :rlimit-count            459138)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 111 | !(0 <= First:(Second:($t@52@05))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30928
;  :arith-add-rows          2652
;  :arith-assert-diseq      2449
;  :arith-assert-lower      5182
;  :arith-assert-upper      3367
;  :arith-bound-prop        546
;  :arith-conflicts         78
;  :arith-eq-adapter        3378
;  :arith-fixed-eqs         1748
;  :arith-offset-eqs        445
;  :arith-pivots            1547
;  :binary-propagations     11
;  :conflicts               521
;  :datatype-accessor-ax    661
;  :datatype-constructor-ax 4664
;  :datatype-occurs-check   1897
;  :datatype-splits         3236
;  :decisions               5614
;  :del-clause              12587
;  :final-checks            525
;  :interface-eqs           197
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          640
;  :mk-bool-var             19167
;  :mk-clause               12771
;  :num-allocs              7000598
;  :num-checks              391
;  :propagations            8171
;  :quant-instantiations    3290
;  :rlimit-count            463615
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31359
;  :arith-add-rows          2677
;  :arith-assert-diseq      2470
;  :arith-assert-lower      5226
;  :arith-assert-upper      3403
;  :arith-bound-prop        550
;  :arith-conflicts         78
;  :arith-eq-adapter        3413
;  :arith-fixed-eqs         1766
;  :arith-offset-eqs        448
;  :arith-pivots            1562
;  :binary-propagations     11
;  :conflicts               531
;  :datatype-accessor-ax    670
;  :datatype-constructor-ax 4740
;  :datatype-occurs-check   1924
;  :datatype-splits         3274
;  :decisions               5705
;  :del-clause              12705
;  :final-checks            532
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          645
;  :mk-bool-var             19371
;  :mk-clause               12889
;  :num-allocs              7000598
;  :num-checks              392
;  :propagations            8253
;  :quant-instantiations    3324
;  :rlimit-count            467393
;  :time                    0.00)
; [then-branch: 113 | !(__flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0]) | live]
; [else-branch: 113 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0] | live]
(push) ; 9
; [then-branch: 113 | !(__flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31360
;  :arith-add-rows          2679
;  :arith-assert-diseq      2470
;  :arith-assert-lower      5226
;  :arith-assert-upper      3403
;  :arith-bound-prop        550
;  :arith-conflicts         78
;  :arith-eq-adapter        3413
;  :arith-fixed-eqs         1766
;  :arith-offset-eqs        448
;  :arith-pivots            1562
;  :binary-propagations     11
;  :conflicts               531
;  :datatype-accessor-ax    670
;  :datatype-constructor-ax 4740
;  :datatype-occurs-check   1924
;  :datatype-splits         3274
;  :decisions               5705
;  :del-clause              12705
;  :final-checks            532
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          645
;  :mk-bool-var             19375
;  :mk-clause               12894
;  :num-allocs              7000598
;  :num-checks              393
;  :propagations            8255
;  :quant-instantiations    3325
;  :rlimit-count            467581)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31360
;  :arith-add-rows          2679
;  :arith-assert-diseq      2470
;  :arith-assert-lower      5226
;  :arith-assert-upper      3403
;  :arith-bound-prop        550
;  :arith-conflicts         78
;  :arith-eq-adapter        3413
;  :arith-fixed-eqs         1766
;  :arith-offset-eqs        448
;  :arith-pivots            1562
;  :binary-propagations     11
;  :conflicts               531
;  :datatype-accessor-ax    670
;  :datatype-constructor-ax 4740
;  :datatype-occurs-check   1924
;  :datatype-splits         3274
;  :decisions               5705
;  :del-clause              12705
;  :final-checks            532
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          645
;  :mk-bool-var             19375
;  :mk-clause               12894
;  :num-allocs              7000598
;  :num-checks              394
;  :propagations            8255
;  :quant-instantiations    3325
;  :rlimit-count            467596)
(pop) ; 9
(push) ; 9
; [else-branch: 113 | __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[0]] == -1 && 0 <= First:(Second:($t@52@05))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (or
        (=
          (Seq_index
            __flatten_31__30@65@05
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
              0))
          0)
        (=
          (Seq_index
            __flatten_31__30@65@05
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@05))))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1)) ==> diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] !(0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1))
; [eval] 0 <= old(diz.Main_process_state[1]) && (old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[1])
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31367
;  :arith-add-rows          2679
;  :arith-assert-diseq      2470
;  :arith-assert-lower      5226
;  :arith-assert-upper      3403
;  :arith-bound-prop        550
;  :arith-conflicts         78
;  :arith-eq-adapter        3413
;  :arith-fixed-eqs         1766
;  :arith-offset-eqs        448
;  :arith-pivots            1562
;  :binary-propagations     11
;  :conflicts               531
;  :datatype-accessor-ax    670
;  :datatype-constructor-ax 4740
;  :datatype-occurs-check   1924
;  :datatype-splits         3274
;  :decisions               5705
;  :del-clause              12710
;  :final-checks            532
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          645
;  :mk-bool-var             19378
;  :mk-clause               12897
;  :num-allocs              7000598
;  :num-checks              395
;  :propagations            8255
;  :quant-instantiations    3325
;  :rlimit-count            467984)
(push) ; 8
; [then-branch: 114 | 0 <= First:(Second:($t@52@05))[1] | live]
; [else-branch: 114 | !(0 <= First:(Second:($t@52@05))[1]) | live]
(push) ; 9
; [then-branch: 114 | 0 <= First:(Second:($t@52@05))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31367
;  :arith-add-rows          2679
;  :arith-assert-diseq      2470
;  :arith-assert-lower      5226
;  :arith-assert-upper      3403
;  :arith-bound-prop        550
;  :arith-conflicts         78
;  :arith-eq-adapter        3413
;  :arith-fixed-eqs         1766
;  :arith-offset-eqs        448
;  :arith-pivots            1562
;  :binary-propagations     11
;  :conflicts               531
;  :datatype-accessor-ax    670
;  :datatype-constructor-ax 4740
;  :datatype-occurs-check   1924
;  :datatype-splits         3274
;  :decisions               5705
;  :del-clause              12710
;  :final-checks            532
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          645
;  :mk-bool-var             19378
;  :mk-clause               12897
;  :num-allocs              7000598
;  :num-checks              396
;  :propagations            8255
;  :quant-instantiations    3325
;  :rlimit-count            468084)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31367
;  :arith-add-rows          2679
;  :arith-assert-diseq      2470
;  :arith-assert-lower      5226
;  :arith-assert-upper      3403
;  :arith-bound-prop        550
;  :arith-conflicts         78
;  :arith-eq-adapter        3413
;  :arith-fixed-eqs         1766
;  :arith-offset-eqs        448
;  :arith-pivots            1562
;  :binary-propagations     11
;  :conflicts               531
;  :datatype-accessor-ax    670
;  :datatype-constructor-ax 4740
;  :datatype-occurs-check   1924
;  :datatype-splits         3274
;  :decisions               5705
;  :del-clause              12710
;  :final-checks            532
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          645
;  :mk-bool-var             19378
;  :mk-clause               12897
;  :num-allocs              7000598
;  :num-checks              397
;  :propagations            8255
;  :quant-instantiations    3325
;  :rlimit-count            468093)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  (Seq_length __flatten_31__30@65@05))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31367
;  :arith-add-rows          2679
;  :arith-assert-diseq      2470
;  :arith-assert-lower      5226
;  :arith-assert-upper      3403
;  :arith-bound-prop        550
;  :arith-conflicts         78
;  :arith-eq-adapter        3413
;  :arith-fixed-eqs         1766
;  :arith-offset-eqs        448
;  :arith-pivots            1562
;  :binary-propagations     11
;  :conflicts               532
;  :datatype-accessor-ax    670
;  :datatype-constructor-ax 4740
;  :datatype-occurs-check   1924
;  :datatype-splits         3274
;  :decisions               5705
;  :del-clause              12710
;  :final-checks            532
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          645
;  :mk-bool-var             19378
;  :mk-clause               12897
;  :num-allocs              7000598
;  :num-checks              398
;  :propagations            8255
;  :quant-instantiations    3325
;  :rlimit-count            468181)
(push) ; 10
; [then-branch: 115 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0 | live]
; [else-branch: 115 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] != 0 | live]
(push) ; 11
; [then-branch: 115 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@65@05
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 115 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@65@05
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[1])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[1])]
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 12
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31368
;  :arith-add-rows          2681
;  :arith-assert-diseq      2470
;  :arith-assert-lower      5226
;  :arith-assert-upper      3403
;  :arith-bound-prop        550
;  :arith-conflicts         78
;  :arith-eq-adapter        3413
;  :arith-fixed-eqs         1766
;  :arith-offset-eqs        448
;  :arith-pivots            1562
;  :binary-propagations     11
;  :conflicts               532
;  :datatype-accessor-ax    670
;  :datatype-constructor-ax 4740
;  :datatype-occurs-check   1924
;  :datatype-splits         3274
;  :decisions               5705
;  :del-clause              12710
;  :final-checks            532
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          645
;  :mk-bool-var             19382
;  :mk-clause               12902
;  :num-allocs              7000598
;  :num-checks              399
;  :propagations            8255
;  :quant-instantiations    3326
;  :rlimit-count            468365)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31368
;  :arith-add-rows          2681
;  :arith-assert-diseq      2470
;  :arith-assert-lower      5226
;  :arith-assert-upper      3403
;  :arith-bound-prop        550
;  :arith-conflicts         78
;  :arith-eq-adapter        3413
;  :arith-fixed-eqs         1766
;  :arith-offset-eqs        448
;  :arith-pivots            1562
;  :binary-propagations     11
;  :conflicts               532
;  :datatype-accessor-ax    670
;  :datatype-constructor-ax 4740
;  :datatype-occurs-check   1924
;  :datatype-splits         3274
;  :decisions               5705
;  :del-clause              12710
;  :final-checks            532
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          645
;  :mk-bool-var             19382
;  :mk-clause               12902
;  :num-allocs              7000598
;  :num-checks              400
;  :propagations            8255
;  :quant-instantiations    3326
;  :rlimit-count            468374)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    1)
  (Seq_length __flatten_31__30@65@05))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31368
;  :arith-add-rows          2681
;  :arith-assert-diseq      2470
;  :arith-assert-lower      5226
;  :arith-assert-upper      3403
;  :arith-bound-prop        550
;  :arith-conflicts         78
;  :arith-eq-adapter        3413
;  :arith-fixed-eqs         1766
;  :arith-offset-eqs        448
;  :arith-pivots            1562
;  :binary-propagations     11
;  :conflicts               533
;  :datatype-accessor-ax    670
;  :datatype-constructor-ax 4740
;  :datatype-occurs-check   1924
;  :datatype-splits         3274
;  :decisions               5705
;  :del-clause              12710
;  :final-checks            532
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          645
;  :mk-bool-var             19382
;  :mk-clause               12902
;  :num-allocs              7000598
;  :num-checks              401
;  :propagations            8255
;  :quant-instantiations    3326
;  :rlimit-count            468462)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 114 | !(0 <= First:(Second:($t@52@05))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31939
;  :arith-add-rows          2755
;  :arith-assert-diseq      2510
;  :arith-assert-lower      5314
;  :arith-assert-upper      3463
;  :arith-bound-prop        560
;  :arith-conflicts         80
;  :arith-eq-adapter        3475
;  :arith-fixed-eqs         1803
;  :arith-offset-eqs        461
;  :arith-pivots            1594
;  :binary-propagations     11
;  :conflicts               543
;  :datatype-accessor-ax    680
;  :datatype-constructor-ax 4824
;  :datatype-occurs-check   1963
;  :datatype-splits         3334
;  :decisions               5811
;  :del-clause              12938
;  :final-checks            543
;  :interface-eqs           205
;  :max-generation          5
;  :max-memory              5.10
;  :memory                  5.00
;  :minimized-lits          670
;  :mk-bool-var             19745
;  :mk-clause               13125
;  :num-allocs              7000598
;  :num-checks              402
;  :propagations            8387
;  :quant-instantiations    3382
;  :rlimit-count            474253
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33457
;  :arith-add-rows          2954
;  :arith-assert-diseq      2598
;  :arith-assert-lower      5489
;  :arith-assert-upper      3577
;  :arith-bound-prop        586
;  :arith-conflicts         90
;  :arith-eq-adapter        3594
;  :arith-fixed-eqs         1869
;  :arith-offset-eqs        480
;  :arith-pivots            1664
;  :binary-propagations     11
;  :conflicts               575
;  :datatype-accessor-ax    735
;  :datatype-constructor-ax 5105
;  :datatype-occurs-check   2106
;  :datatype-splits         3548
;  :decisions               6101
;  :del-clause              13397
;  :final-checks            570
;  :interface-eqs           219
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          766
;  :mk-bool-var             20542
;  :mk-clause               13584
;  :num-allocs              7307403
;  :num-checks              403
;  :propagations            8713
;  :quant-instantiations    3475
;  :rlimit-count            486952
;  :time                    0.01)
; [then-branch: 116 | !(__flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1]) | live]
; [else-branch: 116 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1] | live]
(push) ; 9
; [then-branch: 116 | !(__flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@65@05
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1)))))
; [eval] diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33458
;  :arith-add-rows          2956
;  :arith-assert-diseq      2598
;  :arith-assert-lower      5489
;  :arith-assert-upper      3577
;  :arith-bound-prop        586
;  :arith-conflicts         90
;  :arith-eq-adapter        3594
;  :arith-fixed-eqs         1869
;  :arith-offset-eqs        480
;  :arith-pivots            1664
;  :binary-propagations     11
;  :conflicts               575
;  :datatype-accessor-ax    735
;  :datatype-constructor-ax 5105
;  :datatype-occurs-check   2106
;  :datatype-splits         3548
;  :decisions               6101
;  :del-clause              13397
;  :final-checks            570
;  :interface-eqs           219
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          766
;  :mk-bool-var             20546
;  :mk-clause               13589
;  :num-allocs              7307403
;  :num-checks              404
;  :propagations            8715
;  :quant-instantiations    3476
;  :rlimit-count            487138)
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33458
;  :arith-add-rows          2956
;  :arith-assert-diseq      2598
;  :arith-assert-lower      5489
;  :arith-assert-upper      3577
;  :arith-bound-prop        586
;  :arith-conflicts         90
;  :arith-eq-adapter        3594
;  :arith-fixed-eqs         1869
;  :arith-offset-eqs        480
;  :arith-pivots            1664
;  :binary-propagations     11
;  :conflicts               575
;  :datatype-accessor-ax    735
;  :datatype-constructor-ax 5105
;  :datatype-occurs-check   2106
;  :datatype-splits         3548
;  :decisions               6101
;  :del-clause              13397
;  :final-checks            570
;  :interface-eqs           219
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          766
;  :mk-bool-var             20546
;  :mk-clause               13589
;  :num-allocs              7307403
;  :num-checks              405
;  :propagations            8715
;  :quant-instantiations    3476
;  :rlimit-count            487153)
(pop) ; 9
(push) ; 9
; [else-branch: 116 | __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == 0 || __flatten_31__30@65@05[First:(Second:($t@52@05))[1]] == -1 && 0 <= First:(Second:($t@52@05))[1]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@65@05
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (or
        (=
          (Seq_index
            __flatten_31__30@65@05
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
              1))
          0)
        (=
          (Seq_index
            __flatten_31__30@65@05
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
              1))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      1))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; Main_reset_all_events_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@69@05 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 117 | 0 <= i@69@05 | live]
; [else-branch: 117 | !(0 <= i@69@05) | live]
(push) ; 10
; [then-branch: 117 | 0 <= i@69@05]
(assert (<= 0 i@69@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 117 | !(0 <= i@69@05)]
(assert (not (<= 0 i@69@05)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 118 | i@69@05 < |First:(Second:($t@67@05))| && 0 <= i@69@05 | live]
; [else-branch: 118 | !(i@69@05 < |First:(Second:($t@67@05))| && 0 <= i@69@05) | live]
(push) ; 10
; [then-branch: 118 | i@69@05 < |First:(Second:($t@67@05))| && 0 <= i@69@05]
(assert (and
  (<
    i@69@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))
  (<= 0 i@69@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@69@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35156
;  :arith-add-rows          3183
;  :arith-assert-diseq      2700
;  :arith-assert-lower      5684
;  :arith-assert-upper      3704
;  :arith-bound-prop        613
;  :arith-conflicts         101
;  :arith-eq-adapter        3725
;  :arith-fixed-eqs         1943
;  :arith-offset-eqs        505
;  :arith-pivots            1741
;  :binary-propagations     11
;  :conflicts               608
;  :datatype-accessor-ax    798
;  :datatype-constructor-ax 5419
;  :datatype-occurs-check   2267
;  :datatype-splits         3795
;  :decisions               6422
;  :del-clause              13855
;  :final-checks            599
;  :interface-eqs           234
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          860
;  :mk-bool-var             21407
;  :mk-clause               14130
;  :num-allocs              7307403
;  :num-checks              407
;  :propagations            9074
;  :quant-instantiations    3578
;  :rlimit-count            501715)
; [eval] -1
(push) ; 11
; [then-branch: 119 | First:(Second:($t@67@05))[i@69@05] == -1 | live]
; [else-branch: 119 | First:(Second:($t@67@05))[i@69@05] != -1 | live]
(push) ; 12
; [then-branch: 119 | First:(Second:($t@67@05))[i@69@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
    i@69@05)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 119 | First:(Second:($t@67@05))[i@69@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
      i@69@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@69@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35156
;  :arith-add-rows          3183
;  :arith-assert-diseq      2701
;  :arith-assert-lower      5687
;  :arith-assert-upper      3705
;  :arith-bound-prop        613
;  :arith-conflicts         101
;  :arith-eq-adapter        3726
;  :arith-fixed-eqs         1943
;  :arith-offset-eqs        505
;  :arith-pivots            1741
;  :binary-propagations     11
;  :conflicts               608
;  :datatype-accessor-ax    798
;  :datatype-constructor-ax 5419
;  :datatype-occurs-check   2267
;  :datatype-splits         3795
;  :decisions               6422
;  :del-clause              13855
;  :final-checks            599
;  :interface-eqs           234
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          860
;  :mk-bool-var             21413
;  :mk-clause               14134
;  :num-allocs              7307403
;  :num-checks              408
;  :propagations            9076
;  :quant-instantiations    3579
;  :rlimit-count            501923)
(push) ; 13
; [then-branch: 120 | 0 <= First:(Second:($t@67@05))[i@69@05] | live]
; [else-branch: 120 | !(0 <= First:(Second:($t@67@05))[i@69@05]) | live]
(push) ; 14
; [then-branch: 120 | 0 <= First:(Second:($t@67@05))[i@69@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
    i@69@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@69@05 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35156
;  :arith-add-rows          3183
;  :arith-assert-diseq      2701
;  :arith-assert-lower      5687
;  :arith-assert-upper      3705
;  :arith-bound-prop        613
;  :arith-conflicts         101
;  :arith-eq-adapter        3726
;  :arith-fixed-eqs         1943
;  :arith-offset-eqs        505
;  :arith-pivots            1741
;  :binary-propagations     11
;  :conflicts               608
;  :datatype-accessor-ax    798
;  :datatype-constructor-ax 5419
;  :datatype-occurs-check   2267
;  :datatype-splits         3795
;  :decisions               6422
;  :del-clause              13855
;  :final-checks            599
;  :interface-eqs           234
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          860
;  :mk-bool-var             21413
;  :mk-clause               14134
;  :num-allocs              7307403
;  :num-checks              409
;  :propagations            9076
;  :quant-instantiations    3579
;  :rlimit-count            502017)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 120 | !(0 <= First:(Second:($t@67@05))[i@69@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
      i@69@05))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 118 | !(i@69@05 < |First:(Second:($t@67@05))| && 0 <= i@69@05)]
(assert (not
  (and
    (<
      i@69@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))
    (<= 0 i@69@05))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@69@05 Int)) (!
  (implies
    (and
      (<
        i@69@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))
      (<= 0 i@69@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
          i@69@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
            i@69@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
            i@69@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
    i@69@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35156
;  :arith-add-rows          3183
;  :arith-assert-diseq      2702
;  :arith-assert-lower      5688
;  :arith-assert-upper      3706
;  :arith-bound-prop        613
;  :arith-conflicts         101
;  :arith-eq-adapter        3727
;  :arith-fixed-eqs         1943
;  :arith-offset-eqs        505
;  :arith-pivots            1741
;  :binary-propagations     11
;  :conflicts               609
;  :datatype-accessor-ax    798
;  :datatype-constructor-ax 5419
;  :datatype-occurs-check   2267
;  :datatype-splits         3795
;  :decisions               6422
;  :del-clause              13871
;  :final-checks            599
;  :interface-eqs           234
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          860
;  :mk-bool-var             21421
;  :mk-clause               14146
;  :num-allocs              7307403
;  :num-checks              410
;  :propagations            9078
;  :quant-instantiations    3580
;  :rlimit-count            502439)
(assert (forall ((i@69@05 Int)) (!
  (implies
    (and
      (<
        i@69@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))
      (<= 0 i@69@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
          i@69@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
            i@69@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
            i@69@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))
    i@69@05))
  :qid |prog.l<no position>|)))
(declare-const $t@70@05 $Snap)
(assert (= $t@70@05 ($Snap.combine ($Snap.first $t@70@05) ($Snap.second $t@70@05))))
(assert (=
  ($Snap.second $t@70@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@70@05))
    ($Snap.second ($Snap.second $t@70@05)))))
(assert (=
  ($Snap.second ($Snap.second $t@70@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@70@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@70@05))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@70@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@71@05 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 121 | 0 <= i@71@05 | live]
; [else-branch: 121 | !(0 <= i@71@05) | live]
(push) ; 10
; [then-branch: 121 | 0 <= i@71@05]
(assert (<= 0 i@71@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 121 | !(0 <= i@71@05)]
(assert (not (<= 0 i@71@05)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 122 | i@71@05 < |First:(Second:($t@70@05))| && 0 <= i@71@05 | live]
; [else-branch: 122 | !(i@71@05 < |First:(Second:($t@70@05))| && 0 <= i@71@05) | live]
(push) ; 10
; [then-branch: 122 | i@71@05 < |First:(Second:($t@70@05))| && 0 <= i@71@05]
(assert (and
  (<
    i@71@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))))
  (<= 0 i@71@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@71@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35193
;  :arith-add-rows          3183
;  :arith-assert-diseq      2702
;  :arith-assert-lower      5693
;  :arith-assert-upper      3709
;  :arith-bound-prop        613
;  :arith-conflicts         101
;  :arith-eq-adapter        3729
;  :arith-fixed-eqs         1943
;  :arith-offset-eqs        505
;  :arith-pivots            1741
;  :binary-propagations     11
;  :conflicts               609
;  :datatype-accessor-ax    804
;  :datatype-constructor-ax 5419
;  :datatype-occurs-check   2267
;  :datatype-splits         3795
;  :decisions               6422
;  :del-clause              13871
;  :final-checks            599
;  :interface-eqs           234
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          860
;  :mk-bool-var             21443
;  :mk-clause               14146
;  :num-allocs              7307403
;  :num-checks              411
;  :propagations            9078
;  :quant-instantiations    3584
;  :rlimit-count            503827)
; [eval] -1
(push) ; 11
; [then-branch: 123 | First:(Second:($t@70@05))[i@71@05] == -1 | live]
; [else-branch: 123 | First:(Second:($t@70@05))[i@71@05] != -1 | live]
(push) ; 12
; [then-branch: 123 | First:(Second:($t@70@05))[i@71@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
    i@71@05)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 123 | First:(Second:($t@70@05))[i@71@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
      i@71@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@71@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35193
;  :arith-add-rows          3183
;  :arith-assert-diseq      2702
;  :arith-assert-lower      5693
;  :arith-assert-upper      3709
;  :arith-bound-prop        613
;  :arith-conflicts         101
;  :arith-eq-adapter        3729
;  :arith-fixed-eqs         1943
;  :arith-offset-eqs        505
;  :arith-pivots            1741
;  :binary-propagations     11
;  :conflicts               609
;  :datatype-accessor-ax    804
;  :datatype-constructor-ax 5419
;  :datatype-occurs-check   2267
;  :datatype-splits         3795
;  :decisions               6422
;  :del-clause              13871
;  :final-checks            599
;  :interface-eqs           234
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          860
;  :mk-bool-var             21444
;  :mk-clause               14146
;  :num-allocs              7307403
;  :num-checks              412
;  :propagations            9078
;  :quant-instantiations    3584
;  :rlimit-count            503978)
(push) ; 13
; [then-branch: 124 | 0 <= First:(Second:($t@70@05))[i@71@05] | live]
; [else-branch: 124 | !(0 <= First:(Second:($t@70@05))[i@71@05]) | live]
(push) ; 14
; [then-branch: 124 | 0 <= First:(Second:($t@70@05))[i@71@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
    i@71@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@71@05 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35193
;  :arith-add-rows          3183
;  :arith-assert-diseq      2703
;  :arith-assert-lower      5696
;  :arith-assert-upper      3709
;  :arith-bound-prop        613
;  :arith-conflicts         101
;  :arith-eq-adapter        3730
;  :arith-fixed-eqs         1943
;  :arith-offset-eqs        505
;  :arith-pivots            1741
;  :binary-propagations     11
;  :conflicts               609
;  :datatype-accessor-ax    804
;  :datatype-constructor-ax 5419
;  :datatype-occurs-check   2267
;  :datatype-splits         3795
;  :decisions               6422
;  :del-clause              13871
;  :final-checks            599
;  :interface-eqs           234
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          860
;  :mk-bool-var             21447
;  :mk-clause               14147
;  :num-allocs              7307403
;  :num-checks              413
;  :propagations            9078
;  :quant-instantiations    3584
;  :rlimit-count            504082)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 124 | !(0 <= First:(Second:($t@70@05))[i@71@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
      i@71@05))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 122 | !(i@71@05 < |First:(Second:($t@70@05))| && 0 <= i@71@05)]
(assert (not
  (and
    (<
      i@71@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))))
    (<= 0 i@71@05))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@71@05 Int)) (!
  (implies
    (and
      (<
        i@71@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))))
      (<= 0 i@71@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
          i@71@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
            i@71@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
            i@71@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
    i@71@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@05)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35211
;  :arith-add-rows          3183
;  :arith-assert-diseq      2703
;  :arith-assert-lower      5697
;  :arith-assert-upper      3710
;  :arith-bound-prop        613
;  :arith-conflicts         101
;  :arith-eq-adapter        3731
;  :arith-fixed-eqs         1944
;  :arith-offset-eqs        505
;  :arith-pivots            1741
;  :binary-propagations     11
;  :conflicts               609
;  :datatype-accessor-ax    806
;  :datatype-constructor-ax 5419
;  :datatype-occurs-check   2267
;  :datatype-splits         3795
;  :decisions               6422
;  :del-clause              13872
;  :final-checks            599
;  :interface-eqs           234
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          860
;  :mk-bool-var             21467
;  :mk-clause               14157
;  :num-allocs              7307403
;  :num-checks              414
;  :propagations            9082
;  :quant-instantiations    3586
;  :rlimit-count            505097)
(push) ; 8
; [then-branch: 125 | First:(Second:(Second:(Second:($t@67@05))))[0] == 0 | live]
; [else-branch: 125 | First:(Second:(Second:(Second:($t@67@05))))[0] != 0 | live]
(push) ; 9
; [then-branch: 125 | First:(Second:(Second:(Second:($t@67@05))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 125 | First:(Second:(Second:(Second:($t@67@05))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35212
;  :arith-add-rows          3184
;  :arith-assert-diseq      2703
;  :arith-assert-lower      5697
;  :arith-assert-upper      3710
;  :arith-bound-prop        613
;  :arith-conflicts         101
;  :arith-eq-adapter        3731
;  :arith-fixed-eqs         1944
;  :arith-offset-eqs        505
;  :arith-pivots            1741
;  :binary-propagations     11
;  :conflicts               609
;  :datatype-accessor-ax    806
;  :datatype-constructor-ax 5419
;  :datatype-occurs-check   2267
;  :datatype-splits         3795
;  :decisions               6422
;  :del-clause              13872
;  :final-checks            599
;  :interface-eqs           234
;  :max-generation          5
;  :max-memory              5.11
;  :memory                  5.11
;  :minimized-lits          860
;  :mk-bool-var             21472
;  :mk-clause               14162
;  :num-allocs              7307403
;  :num-checks              415
;  :propagations            9082
;  :quant-instantiations    3587
;  :rlimit-count            505310)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35817
;  :arith-add-rows          3269
;  :arith-assert-diseq      2755
;  :arith-assert-lower      5832
;  :arith-assert-upper      3768
;  :arith-bound-prop        624
;  :arith-conflicts         102
;  :arith-eq-adapter        3797
;  :arith-fixed-eqs         1986
;  :arith-offset-eqs        529
;  :arith-pivots            1786
;  :binary-propagations     11
;  :conflicts               616
;  :datatype-accessor-ax    819
;  :datatype-constructor-ax 5500
;  :datatype-occurs-check   2298
;  :datatype-splits         3837
;  :decisions               6533
;  :del-clause              14122
;  :final-checks            603
;  :interface-eqs           235
;  :max-generation          5
;  :max-memory              5.22
;  :memory                  5.22
;  :minimized-lits          865
;  :mk-bool-var             21772
;  :mk-clause               14407
;  :num-allocs              7623382
;  :num-checks              416
;  :propagations            9274
;  :quant-instantiations    3659
;  :rlimit-count            511634
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               36543
;  :arith-add-rows          3373
;  :arith-assert-diseq      2828
;  :arith-assert-lower      6013
;  :arith-assert-upper      3844
;  :arith-bound-prop        642
;  :arith-conflicts         103
;  :arith-eq-adapter        3888
;  :arith-fixed-eqs         2045
;  :arith-offset-eqs        563
;  :arith-pivots            1837
;  :binary-propagations     11
;  :conflicts               627
;  :datatype-accessor-ax    832
;  :datatype-constructor-ax 5581
;  :datatype-occurs-check   2329
;  :datatype-splits         3879
;  :decisions               6659
;  :del-clause              14452
;  :final-checks            607
;  :interface-eqs           236
;  :max-generation          5
;  :max-memory              5.22
;  :memory                  5.22
;  :minimized-lits          871
;  :mk-bool-var             22156
;  :mk-clause               14737
;  :num-allocs              7623382
;  :num-checks              417
;  :propagations            9545
;  :quant-instantiations    3757
;  :rlimit-count            519225
;  :time                    0.01)
; [then-branch: 126 | First:(Second:(Second:(Second:($t@67@05))))[0] == 0 || First:(Second:(Second:(Second:($t@67@05))))[0] == -1 | live]
; [else-branch: 126 | !(First:(Second:(Second:(Second:($t@67@05))))[0] == 0 || First:(Second:(Second:(Second:($t@67@05))))[0] == -1) | live]
(push) ; 9
; [then-branch: 126 | First:(Second:(Second:(Second:($t@67@05))))[0] == 0 || First:(Second:(Second:(Second:($t@67@05))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               36543
;  :arith-add-rows          3373
;  :arith-assert-diseq      2828
;  :arith-assert-lower      6013
;  :arith-assert-upper      3844
;  :arith-bound-prop        642
;  :arith-conflicts         103
;  :arith-eq-adapter        3888
;  :arith-fixed-eqs         2045
;  :arith-offset-eqs        563
;  :arith-pivots            1837
;  :binary-propagations     11
;  :conflicts               627
;  :datatype-accessor-ax    832
;  :datatype-constructor-ax 5581
;  :datatype-occurs-check   2329
;  :datatype-splits         3879
;  :decisions               6659
;  :del-clause              14452
;  :final-checks            607
;  :interface-eqs           236
;  :max-generation          5
;  :max-memory              5.22
;  :memory                  5.22
;  :minimized-lits          871
;  :mk-bool-var             22158
;  :mk-clause               14738
;  :num-allocs              7623382
;  :num-checks              418
;  :propagations            9545
;  :quant-instantiations    3757
;  :rlimit-count            519374)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 126 | !(First:(Second:(Second:(Second:($t@67@05))))[0] == 0 || First:(Second:(Second:(Second:($t@67@05))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        0)
      (- 0 1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               36549
;  :arith-add-rows          3373
;  :arith-assert-diseq      2828
;  :arith-assert-lower      6013
;  :arith-assert-upper      3844
;  :arith-bound-prop        642
;  :arith-conflicts         103
;  :arith-eq-adapter        3888
;  :arith-fixed-eqs         2045
;  :arith-offset-eqs        563
;  :arith-pivots            1837
;  :binary-propagations     11
;  :conflicts               627
;  :datatype-accessor-ax    833
;  :datatype-constructor-ax 5581
;  :datatype-occurs-check   2329
;  :datatype-splits         3879
;  :decisions               6659
;  :del-clause              14453
;  :final-checks            607
;  :interface-eqs           236
;  :max-generation          5
;  :max-memory              5.22
;  :memory                  5.22
;  :minimized-lits          871
;  :mk-bool-var             22164
;  :mk-clause               14742
;  :num-allocs              7623382
;  :num-checks              419
;  :propagations            9545
;  :quant-instantiations    3757
;  :rlimit-count            519857)
(push) ; 8
; [then-branch: 127 | First:(Second:(Second:(Second:($t@67@05))))[1] == 0 | live]
; [else-branch: 127 | First:(Second:(Second:(Second:($t@67@05))))[1] != 0 | live]
(push) ; 9
; [then-branch: 127 | First:(Second:(Second:(Second:($t@67@05))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 127 | First:(Second:(Second:(Second:($t@67@05))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               36550
;  :arith-add-rows          3374
;  :arith-assert-diseq      2828
;  :arith-assert-lower      6013
;  :arith-assert-upper      3844
;  :arith-bound-prop        642
;  :arith-conflicts         103
;  :arith-eq-adapter        3888
;  :arith-fixed-eqs         2045
;  :arith-offset-eqs        563
;  :arith-pivots            1837
;  :binary-propagations     11
;  :conflicts               627
;  :datatype-accessor-ax    833
;  :datatype-constructor-ax 5581
;  :datatype-occurs-check   2329
;  :datatype-splits         3879
;  :decisions               6659
;  :del-clause              14453
;  :final-checks            607
;  :interface-eqs           236
;  :max-generation          5
;  :max-memory              5.22
;  :memory                  5.22
;  :minimized-lits          871
;  :mk-bool-var             22169
;  :mk-clause               14747
;  :num-allocs              7623382
;  :num-checks              420
;  :propagations            9545
;  :quant-instantiations    3758
;  :rlimit-count            520070)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               37757
;  :arith-add-rows          3581
;  :arith-assert-diseq      2910
;  :arith-assert-lower      6232
;  :arith-assert-upper      3949
;  :arith-bound-prop        664
;  :arith-conflicts         105
;  :arith-eq-adapter        4000
;  :arith-fixed-eqs         2156
;  :arith-offset-eqs        644
;  :arith-pivots            1909
;  :binary-propagations     11
;  :conflicts               639
;  :datatype-accessor-ax    856
;  :datatype-constructor-ax 5705
;  :datatype-occurs-check   2391
;  :datatype-splits         3965
;  :decisions               6826
;  :del-clause              14920
;  :final-checks            616
;  :interface-eqs           239
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          882
;  :mk-bool-var             22767
;  :mk-clause               15209
;  :num-allocs              8268750
;  :num-checks              421
;  :propagations            9905
;  :quant-instantiations    3891
;  :rlimit-count            531886
;  :time                    0.01)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               38866
;  :arith-add-rows          3724
;  :arith-assert-diseq      3007
;  :arith-assert-lower      6462
;  :arith-assert-upper      4051
;  :arith-bound-prop        680
;  :arith-conflicts         107
;  :arith-eq-adapter        4111
;  :arith-fixed-eqs         2269
;  :arith-offset-eqs        710
;  :arith-pivots            1982
;  :binary-propagations     11
;  :conflicts               650
;  :datatype-accessor-ax    879
;  :datatype-constructor-ax 5829
;  :datatype-occurs-check   2453
;  :datatype-splits         4051
;  :decisions               6984
;  :del-clause              15361
;  :final-checks            625
;  :interface-eqs           242
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          891
;  :mk-bool-var             23334
;  :mk-clause               15650
;  :num-allocs              8268750
;  :num-checks              422
;  :propagations            10255
;  :quant-instantiations    4015
;  :rlimit-count            542083
;  :time                    0.01)
; [then-branch: 128 | First:(Second:(Second:(Second:($t@67@05))))[1] == 0 || First:(Second:(Second:(Second:($t@67@05))))[1] == -1 | live]
; [else-branch: 128 | !(First:(Second:(Second:(Second:($t@67@05))))[1] == 0 || First:(Second:(Second:(Second:($t@67@05))))[1] == -1) | live]
(push) ; 9
; [then-branch: 128 | First:(Second:(Second:(Second:($t@67@05))))[1] == 0 || First:(Second:(Second:(Second:($t@67@05))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               38866
;  :arith-add-rows          3724
;  :arith-assert-diseq      3007
;  :arith-assert-lower      6462
;  :arith-assert-upper      4051
;  :arith-bound-prop        680
;  :arith-conflicts         107
;  :arith-eq-adapter        4111
;  :arith-fixed-eqs         2269
;  :arith-offset-eqs        710
;  :arith-pivots            1982
;  :binary-propagations     11
;  :conflicts               650
;  :datatype-accessor-ax    879
;  :datatype-constructor-ax 5829
;  :datatype-occurs-check   2453
;  :datatype-splits         4051
;  :decisions               6984
;  :del-clause              15361
;  :final-checks            625
;  :interface-eqs           242
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          891
;  :mk-bool-var             23336
;  :mk-clause               15651
;  :num-allocs              8268750
;  :num-checks              423
;  :propagations            10255
;  :quant-instantiations    4015
;  :rlimit-count            542232)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 128 | !(First:(Second:(Second:(Second:($t@67@05))))[1] == 0 || First:(Second:(Second:(Second:($t@67@05))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        1)
      (- 0 1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1 ==> diz.Main_event_state[2] == -2
; [eval] old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               38872
;  :arith-add-rows          3724
;  :arith-assert-diseq      3007
;  :arith-assert-lower      6462
;  :arith-assert-upper      4051
;  :arith-bound-prop        680
;  :arith-conflicts         107
;  :arith-eq-adapter        4111
;  :arith-fixed-eqs         2269
;  :arith-offset-eqs        710
;  :arith-pivots            1982
;  :binary-propagations     11
;  :conflicts               650
;  :datatype-accessor-ax    880
;  :datatype-constructor-ax 5829
;  :datatype-occurs-check   2453
;  :datatype-splits         4051
;  :decisions               6984
;  :del-clause              15362
;  :final-checks            625
;  :interface-eqs           242
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          891
;  :mk-bool-var             23342
;  :mk-clause               15655
;  :num-allocs              8268750
;  :num-checks              424
;  :propagations            10255
;  :quant-instantiations    4015
;  :rlimit-count            542721)
(push) ; 8
; [then-branch: 129 | First:(Second:(Second:(Second:($t@67@05))))[2] == 0 | live]
; [else-branch: 129 | First:(Second:(Second:(Second:($t@67@05))))[2] != 0 | live]
(push) ; 9
; [then-branch: 129 | First:(Second:(Second:(Second:($t@67@05))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
    2)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 129 | First:(Second:(Second:(Second:($t@67@05))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               38873
;  :arith-add-rows          3725
;  :arith-assert-diseq      3007
;  :arith-assert-lower      6462
;  :arith-assert-upper      4051
;  :arith-bound-prop        680
;  :arith-conflicts         107
;  :arith-eq-adapter        4111
;  :arith-fixed-eqs         2269
;  :arith-offset-eqs        710
;  :arith-pivots            1982
;  :binary-propagations     11
;  :conflicts               650
;  :datatype-accessor-ax    880
;  :datatype-constructor-ax 5829
;  :datatype-occurs-check   2453
;  :datatype-splits         4051
;  :decisions               6984
;  :del-clause              15362
;  :final-checks            625
;  :interface-eqs           242
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          891
;  :mk-bool-var             23347
;  :mk-clause               15660
;  :num-allocs              8268750
;  :num-checks              425
;  :propagations            10255
;  :quant-instantiations    4016
;  :rlimit-count            542934)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39944
;  :arith-add-rows          3865
;  :arith-assert-diseq      3103
;  :arith-assert-lower      6692
;  :arith-assert-upper      4154
;  :arith-bound-prop        694
;  :arith-conflicts         109
;  :arith-eq-adapter        4222
;  :arith-fixed-eqs         2364
;  :arith-offset-eqs        768
;  :arith-pivots            2056
;  :binary-propagations     11
;  :conflicts               662
;  :datatype-accessor-ax    903
;  :datatype-constructor-ax 5953
;  :datatype-occurs-check   2515
;  :datatype-splits         4137
;  :decisions               7152
;  :del-clause              15839
;  :final-checks            633
;  :interface-eqs           244
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          901
;  :mk-bool-var             23933
;  :mk-clause               16132
;  :num-allocs              8268750
;  :num-checks              426
;  :propagations            10636
;  :quant-instantiations    4148
;  :rlimit-count            552705
;  :time                    0.01)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               40950
;  :arith-add-rows          3967
;  :arith-assert-diseq      3213
;  :arith-assert-lower      6934
;  :arith-assert-upper      4253
;  :arith-bound-prop        705
;  :arith-conflicts         109
;  :arith-eq-adapter        4341
;  :arith-fixed-eqs         2463
;  :arith-offset-eqs        810
;  :arith-pivots            2126
;  :binary-propagations     11
;  :conflicts               675
;  :datatype-accessor-ax    918
;  :datatype-constructor-ax 6081
;  :datatype-occurs-check   2577
;  :datatype-splits         4219
;  :decisions               7321
;  :del-clause              16334
;  :final-checks            640
;  :interface-eqs           245
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          914
;  :mk-bool-var             24500
;  :mk-clause               16627
;  :num-allocs              8268750
;  :num-checks              427
;  :propagations            10987
;  :quant-instantiations    4271
;  :rlimit-count            561695
;  :time                    0.01)
; [then-branch: 130 | First:(Second:(Second:(Second:($t@67@05))))[2] == 0 || First:(Second:(Second:(Second:($t@67@05))))[2] == -1 | live]
; [else-branch: 130 | !(First:(Second:(Second:(Second:($t@67@05))))[2] == 0 || First:(Second:(Second:(Second:($t@67@05))))[2] == -1) | live]
(push) ; 9
; [then-branch: 130 | First:(Second:(Second:(Second:($t@67@05))))[2] == 0 || First:(Second:(Second:(Second:($t@67@05))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      2)
    (- 0 1))))
; [eval] diz.Main_event_state[2] == -2
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               40950
;  :arith-add-rows          3967
;  :arith-assert-diseq      3213
;  :arith-assert-lower      6934
;  :arith-assert-upper      4253
;  :arith-bound-prop        705
;  :arith-conflicts         109
;  :arith-eq-adapter        4341
;  :arith-fixed-eqs         2463
;  :arith-offset-eqs        810
;  :arith-pivots            2126
;  :binary-propagations     11
;  :conflicts               675
;  :datatype-accessor-ax    918
;  :datatype-constructor-ax 6081
;  :datatype-occurs-check   2577
;  :datatype-splits         4219
;  :decisions               7321
;  :del-clause              16334
;  :final-checks            640
;  :interface-eqs           245
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          914
;  :mk-bool-var             24502
;  :mk-clause               16628
;  :num-allocs              8268750
;  :num-checks              428
;  :propagations            10987
;  :quant-instantiations    4271
;  :rlimit-count            561844)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 130 | !(First:(Second:(Second:(Second:($t@67@05))))[2] == 0 || First:(Second:(Second:(Second:($t@67@05))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        2)
      (- 0 1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        2)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))
      2)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1) ==> diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1)
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               40956
;  :arith-add-rows          3967
;  :arith-assert-diseq      3213
;  :arith-assert-lower      6934
;  :arith-assert-upper      4253
;  :arith-bound-prop        705
;  :arith-conflicts         109
;  :arith-eq-adapter        4341
;  :arith-fixed-eqs         2463
;  :arith-offset-eqs        810
;  :arith-pivots            2126
;  :binary-propagations     11
;  :conflicts               675
;  :datatype-accessor-ax    919
;  :datatype-constructor-ax 6081
;  :datatype-occurs-check   2577
;  :datatype-splits         4219
;  :decisions               7321
;  :del-clause              16335
;  :final-checks            640
;  :interface-eqs           245
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          914
;  :mk-bool-var             24508
;  :mk-clause               16632
;  :num-allocs              8268750
;  :num-checks              429
;  :propagations            10987
;  :quant-instantiations    4271
;  :rlimit-count            562343)
(push) ; 8
; [then-branch: 131 | First:(Second:(Second:(Second:($t@67@05))))[0] == 0 | live]
; [else-branch: 131 | First:(Second:(Second:(Second:($t@67@05))))[0] != 0 | live]
(push) ; 9
; [then-branch: 131 | First:(Second:(Second:(Second:($t@67@05))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 131 | First:(Second:(Second:(Second:($t@67@05))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               40957
;  :arith-add-rows          3968
;  :arith-assert-diseq      3213
;  :arith-assert-lower      6934
;  :arith-assert-upper      4253
;  :arith-bound-prop        705
;  :arith-conflicts         109
;  :arith-eq-adapter        4341
;  :arith-fixed-eqs         2463
;  :arith-offset-eqs        810
;  :arith-pivots            2126
;  :binary-propagations     11
;  :conflicts               675
;  :datatype-accessor-ax    919
;  :datatype-constructor-ax 6081
;  :datatype-occurs-check   2577
;  :datatype-splits         4219
;  :decisions               7321
;  :del-clause              16335
;  :final-checks            640
;  :interface-eqs           245
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          914
;  :mk-bool-var             24512
;  :mk-clause               16637
;  :num-allocs              8268750
;  :num-checks              430
;  :propagations            10987
;  :quant-instantiations    4272
;  :rlimit-count            562512)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               42145
;  :arith-add-rows          4115
;  :arith-assert-diseq      3326
;  :arith-assert-lower      7215
;  :arith-assert-upper      4378
;  :arith-bound-prop        728
;  :arith-conflicts         111
;  :arith-eq-adapter        4484
;  :arith-fixed-eqs         2578
;  :arith-offset-eqs        873
;  :arith-pivots            2208
;  :binary-propagations     11
;  :conflicts               692
;  :datatype-accessor-ax    942
;  :datatype-constructor-ax 6205
;  :datatype-occurs-check   2639
;  :datatype-splits         4305
;  :decisions               7505
;  :del-clause              16916
;  :final-checks            648
;  :interface-eqs           247
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          933
;  :mk-bool-var             25190
;  :mk-clause               17213
;  :num-allocs              8268750
;  :num-checks              431
;  :propagations            11457
;  :quant-instantiations    4431
;  :rlimit-count            573488
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43155
;  :arith-add-rows          4228
;  :arith-assert-diseq      3411
;  :arith-assert-lower      7428
;  :arith-assert-upper      4469
;  :arith-bound-prop        739
;  :arith-conflicts         113
;  :arith-eq-adapter        4586
;  :arith-fixed-eqs         2666
;  :arith-offset-eqs        918
;  :arith-pivots            2270
;  :binary-propagations     11
;  :conflicts               704
;  :datatype-accessor-ax    965
;  :datatype-constructor-ax 6329
;  :datatype-occurs-check   2701
;  :datatype-splits         4391
;  :decisions               7672
;  :del-clause              17326
;  :final-checks            656
;  :interface-eqs           249
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          940
;  :mk-bool-var             25709
;  :mk-clause               17623
;  :num-allocs              8268750
;  :num-checks              432
;  :propagations            11797
;  :quant-instantiations    4546
;  :rlimit-count            582466
;  :time                    0.01)
; [then-branch: 132 | !(First:(Second:(Second:(Second:($t@67@05))))[0] == 0 || First:(Second:(Second:(Second:($t@67@05))))[0] == -1) | live]
; [else-branch: 132 | First:(Second:(Second:(Second:($t@67@05))))[0] == 0 || First:(Second:(Second:(Second:($t@67@05))))[0] == -1 | live]
(push) ; 9
; [then-branch: 132 | !(First:(Second:(Second:(Second:($t@67@05))))[0] == 0 || First:(Second:(Second:(Second:($t@67@05))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43156
;  :arith-add-rows          4229
;  :arith-assert-diseq      3411
;  :arith-assert-lower      7428
;  :arith-assert-upper      4469
;  :arith-bound-prop        739
;  :arith-conflicts         113
;  :arith-eq-adapter        4586
;  :arith-fixed-eqs         2666
;  :arith-offset-eqs        918
;  :arith-pivots            2270
;  :binary-propagations     11
;  :conflicts               704
;  :datatype-accessor-ax    965
;  :datatype-constructor-ax 6329
;  :datatype-occurs-check   2701
;  :datatype-splits         4391
;  :decisions               7672
;  :del-clause              17326
;  :final-checks            656
;  :interface-eqs           249
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          940
;  :mk-bool-var             25713
;  :mk-clause               17628
;  :num-allocs              8268750
;  :num-checks              433
;  :propagations            11798
;  :quant-instantiations    4547
;  :rlimit-count            582656)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43156
;  :arith-add-rows          4229
;  :arith-assert-diseq      3411
;  :arith-assert-lower      7428
;  :arith-assert-upper      4469
;  :arith-bound-prop        739
;  :arith-conflicts         113
;  :arith-eq-adapter        4586
;  :arith-fixed-eqs         2666
;  :arith-offset-eqs        918
;  :arith-pivots            2270
;  :binary-propagations     11
;  :conflicts               704
;  :datatype-accessor-ax    965
;  :datatype-constructor-ax 6329
;  :datatype-occurs-check   2701
;  :datatype-splits         4391
;  :decisions               7672
;  :del-clause              17326
;  :final-checks            656
;  :interface-eqs           249
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          940
;  :mk-bool-var             25713
;  :mk-clause               17628
;  :num-allocs              8268750
;  :num-checks              434
;  :propagations            11798
;  :quant-instantiations    4547
;  :rlimit-count            582671)
(pop) ; 9
(push) ; 9
; [else-branch: 132 | First:(Second:(Second:(Second:($t@67@05))))[0] == 0 || First:(Second:(Second:(Second:($t@67@05))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      0)
    (- 0 1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1) ==> diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1)
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43162
;  :arith-add-rows          4229
;  :arith-assert-diseq      3411
;  :arith-assert-lower      7428
;  :arith-assert-upper      4469
;  :arith-bound-prop        739
;  :arith-conflicts         113
;  :arith-eq-adapter        4586
;  :arith-fixed-eqs         2666
;  :arith-offset-eqs        918
;  :arith-pivots            2270
;  :binary-propagations     11
;  :conflicts               704
;  :datatype-accessor-ax    966
;  :datatype-constructor-ax 6329
;  :datatype-occurs-check   2701
;  :datatype-splits         4391
;  :decisions               7672
;  :del-clause              17331
;  :final-checks            656
;  :interface-eqs           249
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          940
;  :mk-bool-var             25716
;  :mk-clause               17629
;  :num-allocs              8268750
;  :num-checks              435
;  :propagations            11798
;  :quant-instantiations    4547
;  :rlimit-count            583120)
(push) ; 8
; [then-branch: 133 | First:(Second:(Second:(Second:($t@67@05))))[1] == 0 | live]
; [else-branch: 133 | First:(Second:(Second:(Second:($t@67@05))))[1] != 0 | live]
(push) ; 9
; [then-branch: 133 | First:(Second:(Second:(Second:($t@67@05))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 133 | First:(Second:(Second:(Second:($t@67@05))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43163
;  :arith-add-rows          4230
;  :arith-assert-diseq      3411
;  :arith-assert-lower      7428
;  :arith-assert-upper      4469
;  :arith-bound-prop        739
;  :arith-conflicts         113
;  :arith-eq-adapter        4586
;  :arith-fixed-eqs         2666
;  :arith-offset-eqs        918
;  :arith-pivots            2270
;  :binary-propagations     11
;  :conflicts               704
;  :datatype-accessor-ax    966
;  :datatype-constructor-ax 6329
;  :datatype-occurs-check   2701
;  :datatype-splits         4391
;  :decisions               7672
;  :del-clause              17331
;  :final-checks            656
;  :interface-eqs           249
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          940
;  :mk-bool-var             25720
;  :mk-clause               17634
;  :num-allocs              8268750
;  :num-checks              436
;  :propagations            11798
;  :quant-instantiations    4548
;  :rlimit-count            583289)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               44241
;  :arith-add-rows          4367
;  :arith-assert-diseq      3502
;  :arith-assert-lower      7653
;  :arith-assert-upper      4569
;  :arith-bound-prop        755
;  :arith-conflicts         115
;  :arith-eq-adapter        4694
;  :arith-fixed-eqs         2761
;  :arith-offset-eqs        977
;  :arith-pivots            2342
;  :binary-propagations     11
;  :conflicts               716
;  :datatype-accessor-ax    989
;  :datatype-constructor-ax 6453
;  :datatype-occurs-check   2763
;  :datatype-splits         4477
;  :decisions               7836
;  :del-clause              17790
;  :final-checks            664
;  :interface-eqs           251
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          950
;  :mk-bool-var             26279
;  :mk-clause               18088
;  :num-allocs              8268750
;  :num-checks              437
;  :propagations            12182
;  :quant-instantiations    4675
;  :rlimit-count            593049
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               45393
;  :arith-add-rows          4506
;  :arith-assert-diseq      3580
;  :arith-assert-lower      7864
;  :arith-assert-upper      4669
;  :arith-bound-prop        771
;  :arith-conflicts         117
;  :arith-eq-adapter        4800
;  :arith-fixed-eqs         2868
;  :arith-offset-eqs        1043
;  :arith-pivots            2412
;  :binary-propagations     11
;  :conflicts               730
;  :datatype-accessor-ax    1012
;  :datatype-constructor-ax 6577
;  :datatype-occurs-check   2825
;  :datatype-splits         4563
;  :decisions               8005
;  :del-clause              18242
;  :final-checks            672
;  :interface-eqs           253
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          960
;  :mk-bool-var             26845
;  :mk-clause               18540
;  :num-allocs              8268750
;  :num-checks              438
;  :propagations            12560
;  :quant-instantiations    4803
;  :rlimit-count            603125
;  :time                    0.01)
; [then-branch: 134 | !(First:(Second:(Second:(Second:($t@67@05))))[1] == 0 || First:(Second:(Second:(Second:($t@67@05))))[1] == -1) | live]
; [else-branch: 134 | First:(Second:(Second:(Second:($t@67@05))))[1] == 0 || First:(Second:(Second:(Second:($t@67@05))))[1] == -1 | live]
(push) ; 9
; [then-branch: 134 | !(First:(Second:(Second:(Second:($t@67@05))))[1] == 0 || First:(Second:(Second:(Second:($t@67@05))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               45394
;  :arith-add-rows          4507
;  :arith-assert-diseq      3580
;  :arith-assert-lower      7864
;  :arith-assert-upper      4669
;  :arith-bound-prop        771
;  :arith-conflicts         117
;  :arith-eq-adapter        4800
;  :arith-fixed-eqs         2868
;  :arith-offset-eqs        1043
;  :arith-pivots            2412
;  :binary-propagations     11
;  :conflicts               730
;  :datatype-accessor-ax    1012
;  :datatype-constructor-ax 6577
;  :datatype-occurs-check   2825
;  :datatype-splits         4563
;  :decisions               8005
;  :del-clause              18242
;  :final-checks            672
;  :interface-eqs           253
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          960
;  :mk-bool-var             26849
;  :mk-clause               18545
;  :num-allocs              8268750
;  :num-checks              439
;  :propagations            12561
;  :quant-instantiations    4804
;  :rlimit-count            603315)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               45394
;  :arith-add-rows          4507
;  :arith-assert-diseq      3580
;  :arith-assert-lower      7864
;  :arith-assert-upper      4669
;  :arith-bound-prop        771
;  :arith-conflicts         117
;  :arith-eq-adapter        4800
;  :arith-fixed-eqs         2868
;  :arith-offset-eqs        1043
;  :arith-pivots            2412
;  :binary-propagations     11
;  :conflicts               730
;  :datatype-accessor-ax    1012
;  :datatype-constructor-ax 6577
;  :datatype-occurs-check   2825
;  :datatype-splits         4563
;  :decisions               8005
;  :del-clause              18242
;  :final-checks            672
;  :interface-eqs           253
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          960
;  :mk-bool-var             26849
;  :mk-clause               18545
;  :num-allocs              8268750
;  :num-checks              440
;  :propagations            12561
;  :quant-instantiations    4804
;  :rlimit-count            603330)
(pop) ; 9
(push) ; 9
; [else-branch: 134 | First:(Second:(Second:(Second:($t@67@05))))[1] == 0 || First:(Second:(Second:(Second:($t@67@05))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      1)
    (- 0 1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@70@05))))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1) ==> diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] !(old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1)
; [eval] old(diz.Main_event_state[2]) == 0 || old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               45403
;  :arith-add-rows          4507
;  :arith-assert-diseq      3580
;  :arith-assert-lower      7864
;  :arith-assert-upper      4669
;  :arith-bound-prop        771
;  :arith-conflicts         117
;  :arith-eq-adapter        4800
;  :arith-fixed-eqs         2868
;  :arith-offset-eqs        1043
;  :arith-pivots            2412
;  :binary-propagations     11
;  :conflicts               730
;  :datatype-accessor-ax    1012
;  :datatype-constructor-ax 6577
;  :datatype-occurs-check   2825
;  :datatype-splits         4563
;  :decisions               8005
;  :del-clause              18247
;  :final-checks            672
;  :interface-eqs           253
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          960
;  :mk-bool-var             26851
;  :mk-clause               18546
;  :num-allocs              8268750
;  :num-checks              441
;  :propagations            12561
;  :quant-instantiations    4804
;  :rlimit-count            603704)
(push) ; 8
; [then-branch: 135 | First:(Second:(Second:(Second:($t@67@05))))[2] == 0 | live]
; [else-branch: 135 | First:(Second:(Second:(Second:($t@67@05))))[2] != 0 | live]
(push) ; 9
; [then-branch: 135 | First:(Second:(Second:(Second:($t@67@05))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
    2)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 135 | First:(Second:(Second:(Second:($t@67@05))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               45404
;  :arith-add-rows          4508
;  :arith-assert-diseq      3580
;  :arith-assert-lower      7864
;  :arith-assert-upper      4669
;  :arith-bound-prop        771
;  :arith-conflicts         117
;  :arith-eq-adapter        4800
;  :arith-fixed-eqs         2868
;  :arith-offset-eqs        1043
;  :arith-pivots            2412
;  :binary-propagations     11
;  :conflicts               730
;  :datatype-accessor-ax    1012
;  :datatype-constructor-ax 6577
;  :datatype-occurs-check   2825
;  :datatype-splits         4563
;  :decisions               8005
;  :del-clause              18247
;  :final-checks            672
;  :interface-eqs           253
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          960
;  :mk-bool-var             26855
;  :mk-clause               18551
;  :num-allocs              8268750
;  :num-checks              442
;  :propagations            12561
;  :quant-instantiations    4805
;  :rlimit-count            603873)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46417
;  :arith-add-rows          4615
;  :arith-assert-diseq      3690
;  :arith-assert-lower      8106
;  :arith-assert-upper      4768
;  :arith-bound-prop        782
;  :arith-conflicts         117
;  :arith-eq-adapter        4919
;  :arith-fixed-eqs         2969
;  :arith-offset-eqs        1087
;  :arith-pivots            2485
;  :binary-propagations     11
;  :conflicts               743
;  :datatype-accessor-ax    1027
;  :datatype-constructor-ax 6703
;  :datatype-occurs-check   2887
;  :datatype-splits         4643
;  :decisions               8172
;  :del-clause              18749
;  :final-checks            679
;  :interface-eqs           254
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          973
;  :mk-bool-var             27424
;  :mk-clause               19048
;  :num-allocs              8268750
;  :num-checks              443
;  :propagations            12923
;  :quant-instantiations    4930
;  :rlimit-count            613006
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47366
;  :arith-add-rows          4789
;  :arith-assert-diseq      3763
;  :arith-assert-lower      8278
;  :arith-assert-upper      4843
;  :arith-bound-prop        809
;  :arith-conflicts         118
;  :arith-eq-adapter        5004
;  :arith-fixed-eqs         3033
;  :arith-offset-eqs        1135
;  :arith-pivots            2540
;  :binary-propagations     11
;  :conflicts               755
;  :datatype-accessor-ax    1050
;  :datatype-constructor-ax 6825
;  :datatype-occurs-check   2949
;  :datatype-splits         4727
;  :decisions               8327
;  :del-clause              19116
;  :final-checks            687
;  :interface-eqs           256
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          995
;  :mk-bool-var             27897
;  :mk-clause               19415
;  :num-allocs              8268750
;  :num-checks              444
;  :propagations            13206
;  :quant-instantiations    5025
;  :rlimit-count            622660
;  :time                    0.01)
; [then-branch: 136 | !(First:(Second:(Second:(Second:($t@67@05))))[2] == 0 || First:(Second:(Second:(Second:($t@67@05))))[2] == -1) | live]
; [else-branch: 136 | First:(Second:(Second:(Second:($t@67@05))))[2] == 0 || First:(Second:(Second:(Second:($t@67@05))))[2] == -1 | live]
(push) ; 9
; [then-branch: 136 | !(First:(Second:(Second:(Second:($t@67@05))))[2] == 0 || First:(Second:(Second:(Second:($t@67@05))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
        2)
      (- 0 1)))))
; [eval] diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47367
;  :arith-add-rows          4789
;  :arith-assert-diseq      3763
;  :arith-assert-lower      8278
;  :arith-assert-upper      4843
;  :arith-bound-prop        809
;  :arith-conflicts         118
;  :arith-eq-adapter        5004
;  :arith-fixed-eqs         3033
;  :arith-offset-eqs        1135
;  :arith-pivots            2540
;  :binary-propagations     11
;  :conflicts               755
;  :datatype-accessor-ax    1050
;  :datatype-constructor-ax 6825
;  :datatype-occurs-check   2949
;  :datatype-splits         4727
;  :decisions               8327
;  :del-clause              19116
;  :final-checks            687
;  :interface-eqs           256
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          995
;  :mk-bool-var             27901
;  :mk-clause               19420
;  :num-allocs              8268750
;  :num-checks              445
;  :propagations            13207
;  :quant-instantiations    5026
;  :rlimit-count            622849)
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47367
;  :arith-add-rows          4789
;  :arith-assert-diseq      3763
;  :arith-assert-lower      8278
;  :arith-assert-upper      4843
;  :arith-bound-prop        809
;  :arith-conflicts         118
;  :arith-eq-adapter        5004
;  :arith-fixed-eqs         3033
;  :arith-offset-eqs        1135
;  :arith-pivots            2540
;  :binary-propagations     11
;  :conflicts               755
;  :datatype-accessor-ax    1050
;  :datatype-constructor-ax 6825
;  :datatype-occurs-check   2949
;  :datatype-splits         4727
;  :decisions               8327
;  :del-clause              19116
;  :final-checks            687
;  :interface-eqs           256
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          995
;  :mk-bool-var             27901
;  :mk-clause               19420
;  :num-allocs              8268750
;  :num-checks              446
;  :propagations            13207
;  :quant-instantiations    5026
;  :rlimit-count            622864)
(pop) ; 9
(push) ; 9
; [else-branch: 136 | First:(Second:(Second:(Second:($t@67@05))))[2] == 0 || First:(Second:(Second:(Second:($t@67@05))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      2)
    (- 0 1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
          2)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
          2)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@05)))))
      2))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@72@05 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 137 | 0 <= i@72@05 | live]
; [else-branch: 137 | !(0 <= i@72@05) | live]
(push) ; 10
; [then-branch: 137 | 0 <= i@72@05]
(assert (<= 0 i@72@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 137 | !(0 <= i@72@05)]
(assert (not (<= 0 i@72@05)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 138 | i@72@05 < |First:(Second:($t@70@05))| && 0 <= i@72@05 | live]
; [else-branch: 138 | !(i@72@05 < |First:(Second:($t@70@05))| && 0 <= i@72@05) | live]
(push) ; 10
; [then-branch: 138 | i@72@05 < |First:(Second:($t@70@05))| && 0 <= i@72@05]
(assert (and
  (<
    i@72@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))))
  (<= 0 i@72@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@72@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48446
;  :arith-add-rows          4912
;  :arith-assert-diseq      3859
;  :arith-assert-lower      8511
;  :arith-assert-upper      4947
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5115
;  :arith-fixed-eqs         3134
;  :arith-offset-eqs        1187
;  :arith-pivots            2613
;  :binary-propagations     11
;  :conflicts               767
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19586
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28482
;  :mk-clause               19897
;  :num-allocs              8268750
;  :num-checks              448
;  :propagations            13609
;  :quant-instantiations    5158
;  :rlimit-count            632586)
; [eval] -1
(push) ; 11
; [then-branch: 139 | First:(Second:($t@70@05))[i@72@05] == -1 | live]
; [else-branch: 139 | First:(Second:($t@70@05))[i@72@05] != -1 | live]
(push) ; 12
; [then-branch: 139 | First:(Second:($t@70@05))[i@72@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
    i@72@05)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 139 | First:(Second:($t@70@05))[i@72@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
      i@72@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@72@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3861
;  :arith-assert-lower      8518
;  :arith-assert-upper      4950
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5118
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2614
;  :binary-propagations     11
;  :conflicts               767
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19586
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28497
;  :mk-clause               19908
;  :num-allocs              8268750
;  :num-checks              449
;  :propagations            13614
;  :quant-instantiations    5161
;  :rlimit-count            632892)
(push) ; 13
; [then-branch: 140 | 0 <= First:(Second:($t@70@05))[i@72@05] | live]
; [else-branch: 140 | !(0 <= First:(Second:($t@70@05))[i@72@05]) | live]
(push) ; 14
; [then-branch: 140 | 0 <= First:(Second:($t@70@05))[i@72@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
    i@72@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@72@05 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3861
;  :arith-assert-lower      8518
;  :arith-assert-upper      4950
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5118
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2614
;  :binary-propagations     11
;  :conflicts               767
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19586
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28497
;  :mk-clause               19908
;  :num-allocs              8268750
;  :num-checks              450
;  :propagations            13614
;  :quant-instantiations    5161
;  :rlimit-count            632986)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 140 | !(0 <= First:(Second:($t@70@05))[i@72@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
      i@72@05))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 138 | !(i@72@05 < |First:(Second:($t@70@05))| && 0 <= i@72@05)]
(assert (not
  (and
    (<
      i@72@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))))
    (<= 0 i@72@05))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@72@05 Int)) (!
  (implies
    (and
      (<
        i@72@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))))
      (<= 0 i@72@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
          i@72@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
            i@72@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
            i@72@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
    i@72@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3863
;  :arith-assert-lower      8519
;  :arith-assert-upper      4951
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5120
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2615
;  :binary-propagations     11
;  :conflicts               768
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28511
;  :mk-clause               19935
;  :num-allocs              8268750
;  :num-checks              451
;  :propagations            13616
;  :quant-instantiations    5164
;  :rlimit-count            633477)
(assert (forall ((i@72@05 Int)) (!
  (implies
    (and
      (<
        i@72@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))))
      (<= 0 i@72@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
          i@72@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
            i@72@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
            i@72@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@70@05)))
    i@72@05))
  :qid |prog.l<no position>|)))
(declare-const $k@73@05 $Perm)
(assert ($Perm.isReadVar $k@73@05 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@73@05 $Perm.No) (< $Perm.No $k@73@05))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3864
;  :arith-assert-lower      8521
;  :arith-assert-upper      4952
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5121
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2615
;  :binary-propagations     11
;  :conflicts               769
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28516
;  :mk-clause               19937
;  :num-allocs              8268750
;  :num-checks              452
;  :propagations            13617
;  :quant-instantiations    5164
;  :rlimit-count            634002)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@45@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3864
;  :arith-assert-lower      8521
;  :arith-assert-upper      4952
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5121
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2615
;  :binary-propagations     11
;  :conflicts               769
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28516
;  :mk-clause               19937
;  :num-allocs              8268750
;  :num-checks              453
;  :propagations            13617
;  :quant-instantiations    5164
;  :rlimit-count            634013)
(assert (< $k@73@05 $k@45@05))
(assert (<= $Perm.No (- $k@45@05 $k@73@05)))
(assert (<= (- $k@45@05 $k@73@05) $Perm.Write))
(assert (implies (< $Perm.No (- $k@45@05 $k@73@05)) (not (= diz@15@05 $Ref.null))))
; [eval] diz.Main_sensor != null
(push) ; 8
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3864
;  :arith-assert-lower      8523
;  :arith-assert-upper      4953
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5121
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2615
;  :binary-propagations     11
;  :conflicts               770
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28519
;  :mk-clause               19937
;  :num-allocs              8268750
;  :num-checks              454
;  :propagations            13617
;  :quant-instantiations    5164
;  :rlimit-count            634221)
(push) ; 8
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3864
;  :arith-assert-lower      8523
;  :arith-assert-upper      4953
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5121
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2615
;  :binary-propagations     11
;  :conflicts               771
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28519
;  :mk-clause               19937
;  :num-allocs              8268750
;  :num-checks              455
;  :propagations            13617
;  :quant-instantiations    5164
;  :rlimit-count            634269)
(push) ; 8
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3864
;  :arith-assert-lower      8523
;  :arith-assert-upper      4953
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5121
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2615
;  :binary-propagations     11
;  :conflicts               772
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28519
;  :mk-clause               19937
;  :num-allocs              8268750
;  :num-checks              456
;  :propagations            13617
;  :quant-instantiations    5164
;  :rlimit-count            634317)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3864
;  :arith-assert-lower      8523
;  :arith-assert-upper      4953
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5121
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2615
;  :binary-propagations     11
;  :conflicts               772
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28519
;  :mk-clause               19937
;  :num-allocs              8268750
;  :num-checks              457
;  :propagations            13617
;  :quant-instantiations    5164
;  :rlimit-count            634330)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3864
;  :arith-assert-lower      8523
;  :arith-assert-upper      4953
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5121
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2615
;  :binary-propagations     11
;  :conflicts               773
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28519
;  :mk-clause               19937
;  :num-allocs              8268750
;  :num-checks              458
;  :propagations            13617
;  :quant-instantiations    5164
;  :rlimit-count            634378)
(declare-const $k@74@05 $Perm)
(assert ($Perm.isReadVar $k@74@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 8
(assert (not (or (= $k@74@05 $Perm.No) (< $Perm.No $k@74@05))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3865
;  :arith-assert-lower      8525
;  :arith-assert-upper      4954
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5122
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2615
;  :binary-propagations     11
;  :conflicts               774
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28523
;  :mk-clause               19939
;  :num-allocs              8268750
;  :num-checks              459
;  :propagations            13618
;  :quant-instantiations    5164
;  :rlimit-count            634576)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@46@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3865
;  :arith-assert-lower      8525
;  :arith-assert-upper      4954
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5122
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2615
;  :binary-propagations     11
;  :conflicts               774
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28523
;  :mk-clause               19939
;  :num-allocs              8268750
;  :num-checks              460
;  :propagations            13618
;  :quant-instantiations    5164
;  :rlimit-count            634587)
(assert (< $k@74@05 $k@46@05))
(assert (<= $Perm.No (- $k@46@05 $k@74@05)))
(assert (<= (- $k@46@05 $k@74@05) $Perm.Write))
(assert (implies (< $Perm.No (- $k@46@05 $k@74@05)) (not (= diz@15@05 $Ref.null))))
; [eval] diz.Main_controller != null
(push) ; 8
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3865
;  :arith-assert-lower      8527
;  :arith-assert-upper      4955
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5122
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2616
;  :binary-propagations     11
;  :conflicts               775
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28526
;  :mk-clause               19939
;  :num-allocs              8268750
;  :num-checks              461
;  :propagations            13618
;  :quant-instantiations    5164
;  :rlimit-count            634801)
(push) ; 8
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3865
;  :arith-assert-lower      8527
;  :arith-assert-upper      4955
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5122
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2616
;  :binary-propagations     11
;  :conflicts               776
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28526
;  :mk-clause               19939
;  :num-allocs              8268750
;  :num-checks              462
;  :propagations            13618
;  :quant-instantiations    5164
;  :rlimit-count            634849)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3865
;  :arith-assert-lower      8527
;  :arith-assert-upper      4955
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5122
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2616
;  :binary-propagations     11
;  :conflicts               776
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28526
;  :mk-clause               19939
;  :num-allocs              8268750
;  :num-checks              463
;  :propagations            13618
;  :quant-instantiations    5164
;  :rlimit-count            634862)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4912
;  :arith-assert-diseq      3865
;  :arith-assert-lower      8527
;  :arith-assert-upper      4955
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5122
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2616
;  :binary-propagations     11
;  :conflicts               777
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19624
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28526
;  :mk-clause               19939
;  :num-allocs              8268750
;  :num-checks              464
;  :propagations            13618
;  :quant-instantiations    5164
;  :rlimit-count            634910)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@70@05))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@70@05))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))))
                                ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))))))))))))))))))))) diz@15@05 globals@16@05))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 7
(push) ; 7
; [else-branch: 93 | min_advance__31@54@05 == -1]
(assert (= min_advance__31@54@05 (- 0 1)))
(pop) ; 7
(pop) ; 6
(push) ; 6
; [else-branch: 44 | !(First:(Second:($t@52@05))[1] != -1 && First:(Second:($t@52@05))[0] != -1)]
(assert (not
  (and
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0)
        (- 0 1))))))
(pop) ; 6
; [eval] !(diz.Main_process_state[0] != -1 && diz.Main_process_state[1] != -1)
; [eval] diz.Main_process_state[0] != -1 && diz.Main_process_state[1] != -1
; [eval] diz.Main_process_state[0] != -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48450
;  :arith-add-rows          4925
;  :arith-assert-diseq      3865
;  :arith-assert-lower      8527
;  :arith-assert-upper      4955
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5122
;  :arith-fixed-eqs         3135
;  :arith-offset-eqs        1187
;  :arith-pivots            2626
;  :binary-propagations     11
;  :conflicts               777
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19880
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28526
;  :mk-clause               19939
;  :num-allocs              8268750
;  :num-checks              465
;  :propagations            13618
;  :quant-instantiations    5164
;  :rlimit-count            635347)
; [eval] -1
(push) ; 6
; [then-branch: 141 | First:(Second:($t@52@05))[0] != -1 | live]
; [else-branch: 141 | First:(Second:($t@52@05))[0] == -1 | live]
(push) ; 7
; [then-branch: 141 | First:(Second:($t@52@05))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      0)
    (- 0 1))))
; [eval] diz.Main_process_state[1] != -1
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48453
;  :arith-add-rows          4925
;  :arith-assert-diseq      3867
;  :arith-assert-lower      8534
;  :arith-assert-upper      4958
;  :arith-bound-prop        819
;  :arith-conflicts         120
;  :arith-eq-adapter        5124
;  :arith-fixed-eqs         3136
;  :arith-offset-eqs        1187
;  :arith-pivots            2626
;  :binary-propagations     11
;  :conflicts               777
;  :datatype-accessor-ax    1073
;  :datatype-constructor-ax 6947
;  :datatype-occurs-check   3011
;  :datatype-splits         4811
;  :decisions               8493
;  :del-clause              19880
;  :final-checks            695
;  :interface-eqs           258
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1005
;  :mk-bool-var             28529
;  :mk-clause               19948
;  :num-allocs              8268750
;  :num-checks              466
;  :propagations            13626
;  :quant-instantiations    5167
;  :rlimit-count            635574)
; [eval] -1
(pop) ; 7
(push) ; 7
; [else-branch: 141 | First:(Second:($t@52@05))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    0)
  (- 0 1)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 6
(assert (not (and
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48999
;  :arith-add-rows          4930
;  :arith-assert-diseq      3884
;  :arith-assert-lower      8586
;  :arith-assert-upper      4992
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5160
;  :arith-fixed-eqs         3150
;  :arith-offset-eqs        1187
;  :arith-pivots            2642
;  :binary-propagations     11
;  :conflicts               784
;  :datatype-accessor-ax    1093
;  :datatype-constructor-ax 7063
;  :datatype-occurs-check   3049
;  :datatype-splits         4885
;  :decisions               8603
;  :del-clause              20022
;  :final-checks            708
;  :interface-eqs           264
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28753
;  :mk-clause               20081
;  :num-allocs              8268750
;  :num-checks              467
;  :propagations            13705
;  :quant-instantiations    5190
;  :rlimit-count            639065
;  :time                    0.00)
(push) ; 6
(assert (not (not
  (and
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0)
        (- 0 1)))))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49153
;  :arith-add-rows          4933
;  :arith-assert-diseq      3892
;  :arith-assert-lower      8616
;  :arith-assert-upper      5008
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5175
;  :arith-fixed-eqs         3156
;  :arith-offset-eqs        1187
;  :arith-pivots            2648
;  :binary-propagations     11
;  :conflicts               785
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20073
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28820
;  :mk-clause               20132
;  :num-allocs              8268750
;  :num-checks              468
;  :propagations            13749
;  :quant-instantiations    5204
;  :rlimit-count            640905
;  :time                    0.00)
; [then-branch: 142 | !(First:(Second:($t@52@05))[1] != -1 && First:(Second:($t@52@05))[0] != -1) | live]
; [else-branch: 142 | First:(Second:($t@52@05))[1] != -1 && First:(Second:($t@52@05))[0] != -1 | live]
(push) ; 6
; [then-branch: 142 | !(First:(Second:($t@52@05))[1] != -1 && First:(Second:($t@52@05))[0] != -1)]
(assert (not
  (and
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          0)
        (- 0 1))))))
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@75@05 Int)
(push) ; 7
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 8
; [then-branch: 143 | 0 <= i@75@05 | live]
; [else-branch: 143 | !(0 <= i@75@05) | live]
(push) ; 9
; [then-branch: 143 | 0 <= i@75@05]
(assert (<= 0 i@75@05))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 143 | !(0 <= i@75@05)]
(assert (not (<= 0 i@75@05)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 144 | i@75@05 < |First:(Second:($t@52@05))| && 0 <= i@75@05 | live]
; [else-branch: 144 | !(i@75@05 < |First:(Second:($t@52@05))| && 0 <= i@75@05) | live]
(push) ; 9
; [then-branch: 144 | i@75@05 < |First:(Second:($t@52@05))| && 0 <= i@75@05]
(assert (and
  (<
    i@75@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
  (<= 0 i@75@05)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i@75@05 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49155
;  :arith-add-rows          4933
;  :arith-assert-diseq      3892
;  :arith-assert-lower      8617
;  :arith-assert-upper      5009
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5177
;  :arith-fixed-eqs         3156
;  :arith-offset-eqs        1187
;  :arith-pivots            2648
;  :binary-propagations     11
;  :conflicts               785
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20073
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28826
;  :mk-clause               20143
;  :num-allocs              8268750
;  :num-checks              469
;  :propagations            13749
;  :quant-instantiations    5204
;  :rlimit-count            641189)
; [eval] -1
(push) ; 10
; [then-branch: 145 | First:(Second:($t@52@05))[i@75@05] == -1 | live]
; [else-branch: 145 | First:(Second:($t@52@05))[i@75@05] != -1 | live]
(push) ; 11
; [then-branch: 145 | First:(Second:($t@52@05))[i@75@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@75@05)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 145 | First:(Second:($t@52@05))[i@75@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      i@75@05)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 12
(assert (not (>= i@75@05 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3894
;  :arith-assert-lower      8624
;  :arith-assert-upper      5012
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5180
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2649
;  :binary-propagations     11
;  :conflicts               785
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20073
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28841
;  :mk-clause               20154
;  :num-allocs              8268750
;  :num-checks              470
;  :propagations            13754
;  :quant-instantiations    5207
;  :rlimit-count            641495)
(push) ; 12
; [then-branch: 146 | 0 <= First:(Second:($t@52@05))[i@75@05] | live]
; [else-branch: 146 | !(0 <= First:(Second:($t@52@05))[i@75@05]) | live]
(push) ; 13
; [then-branch: 146 | 0 <= First:(Second:($t@52@05))[i@75@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@75@05)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@75@05 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3894
;  :arith-assert-lower      8624
;  :arith-assert-upper      5012
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5180
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2649
;  :binary-propagations     11
;  :conflicts               785
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20073
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28841
;  :mk-clause               20154
;  :num-allocs              8268750
;  :num-checks              471
;  :propagations            13754
;  :quant-instantiations    5207
;  :rlimit-count            641589)
; [eval] |diz.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 146 | !(0 <= First:(Second:($t@52@05))[i@75@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
      i@75@05))))
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
; [else-branch: 144 | !(i@75@05 < |First:(Second:($t@52@05))| && 0 <= i@75@05)]
(assert (not
  (and
    (<
      i@75@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
    (<= 0 i@75@05))))
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
(assert (not (forall ((i@75@05 Int)) (!
  (implies
    (and
      (<
        i@75@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
      (<= 0 i@75@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          i@75@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@75@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@75@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@75@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3896
;  :arith-assert-lower      8625
;  :arith-assert-upper      5013
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5182
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               786
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28855
;  :mk-clause               20181
;  :num-allocs              8268750
;  :num-checks              472
;  :propagations            13756
;  :quant-instantiations    5210
;  :rlimit-count            642080)
(assert (forall ((i@75@05 Int)) (!
  (implies
    (and
      (<
        i@75@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))))
      (<= 0 i@75@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
          i@75@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@75@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
            i@75@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
    i@75@05))
  :qid |prog.l<no position>|)))
(declare-const $k@76@05 $Perm)
(assert ($Perm.isReadVar $k@76@05 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@76@05 $Perm.No) (< $Perm.No $k@76@05))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3897
;  :arith-assert-lower      8627
;  :arith-assert-upper      5014
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5183
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               787
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28860
;  :mk-clause               20183
;  :num-allocs              8268750
;  :num-checks              473
;  :propagations            13757
;  :quant-instantiations    5210
;  :rlimit-count            642605)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@45@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3897
;  :arith-assert-lower      8627
;  :arith-assert-upper      5014
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5183
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               787
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28860
;  :mk-clause               20183
;  :num-allocs              8268750
;  :num-checks              474
;  :propagations            13757
;  :quant-instantiations    5210
;  :rlimit-count            642616)
(assert (< $k@76@05 $k@45@05))
(assert (<= $Perm.No (- $k@45@05 $k@76@05)))
(assert (<= (- $k@45@05 $k@76@05) $Perm.Write))
(assert (implies (< $Perm.No (- $k@45@05 $k@76@05)) (not (= diz@15@05 $Ref.null))))
; [eval] diz.Main_sensor != null
(push) ; 7
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3897
;  :arith-assert-lower      8629
;  :arith-assert-upper      5015
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5183
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               788
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28863
;  :mk-clause               20183
;  :num-allocs              8268750
;  :num-checks              475
;  :propagations            13757
;  :quant-instantiations    5210
;  :rlimit-count            642824)
(push) ; 7
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3897
;  :arith-assert-lower      8629
;  :arith-assert-upper      5015
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5183
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               789
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28863
;  :mk-clause               20183
;  :num-allocs              8268750
;  :num-checks              476
;  :propagations            13757
;  :quant-instantiations    5210
;  :rlimit-count            642872)
(push) ; 7
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3897
;  :arith-assert-lower      8629
;  :arith-assert-upper      5015
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5183
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               790
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28863
;  :mk-clause               20183
;  :num-allocs              8268750
;  :num-checks              477
;  :propagations            13757
;  :quant-instantiations    5210
;  :rlimit-count            642920)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3897
;  :arith-assert-lower      8629
;  :arith-assert-upper      5015
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5183
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               790
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28863
;  :mk-clause               20183
;  :num-allocs              8268750
;  :num-checks              478
;  :propagations            13757
;  :quant-instantiations    5210
;  :rlimit-count            642933)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@45@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3897
;  :arith-assert-lower      8629
;  :arith-assert-upper      5015
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5183
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               791
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28863
;  :mk-clause               20183
;  :num-allocs              8268750
;  :num-checks              479
;  :propagations            13757
;  :quant-instantiations    5210
;  :rlimit-count            642981)
(declare-const $k@77@05 $Perm)
(assert ($Perm.isReadVar $k@77@05 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@77@05 $Perm.No) (< $Perm.No $k@77@05))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3898
;  :arith-assert-lower      8631
;  :arith-assert-upper      5016
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5184
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               792
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28867
;  :mk-clause               20185
;  :num-allocs              8268750
;  :num-checks              480
;  :propagations            13758
;  :quant-instantiations    5210
;  :rlimit-count            643180)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@46@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3898
;  :arith-assert-lower      8631
;  :arith-assert-upper      5016
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5184
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               792
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28867
;  :mk-clause               20185
;  :num-allocs              8268750
;  :num-checks              481
;  :propagations            13758
;  :quant-instantiations    5210
;  :rlimit-count            643191)
(assert (< $k@77@05 $k@46@05))
(assert (<= $Perm.No (- $k@46@05 $k@77@05)))
(assert (<= (- $k@46@05 $k@77@05) $Perm.Write))
(assert (implies (< $Perm.No (- $k@46@05 $k@77@05)) (not (= diz@15@05 $Ref.null))))
; [eval] diz.Main_controller != null
(push) ; 7
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3898
;  :arith-assert-lower      8633
;  :arith-assert-upper      5017
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5184
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               793
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28870
;  :mk-clause               20185
;  :num-allocs              8268750
;  :num-checks              482
;  :propagations            13758
;  :quant-instantiations    5210
;  :rlimit-count            643399)
(push) ; 7
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3898
;  :arith-assert-lower      8633
;  :arith-assert-upper      5017
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5184
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               794
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28870
;  :mk-clause               20185
;  :num-allocs              8268750
;  :num-checks              483
;  :propagations            13758
;  :quant-instantiations    5210
;  :rlimit-count            643447)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3898
;  :arith-assert-lower      8633
;  :arith-assert-upper      5017
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5184
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               794
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28870
;  :mk-clause               20185
;  :num-allocs              8268750
;  :num-checks              484
;  :propagations            13758
;  :quant-instantiations    5210
;  :rlimit-count            643460)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@46@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49159
;  :arith-add-rows          4933
;  :arith-assert-diseq      3898
;  :arith-assert-lower      8633
;  :arith-assert-upper      5017
;  :arith-bound-prop        827
;  :arith-conflicts         120
;  :arith-eq-adapter        5184
;  :arith-fixed-eqs         3157
;  :arith-offset-eqs        1187
;  :arith-pivots            2650
;  :binary-propagations     11
;  :conflicts               795
;  :datatype-accessor-ax    1096
;  :datatype-constructor-ax 7093
;  :datatype-occurs-check   3063
;  :datatype-splits         4909
;  :decisions               8637
;  :del-clause              20111
;  :final-checks            713
;  :interface-eqs           266
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.41
;  :minimized-lits          1006
;  :mk-bool-var             28870
;  :mk-clause               20185
;  :num-allocs              8268750
;  :num-checks              485
;  :propagations            13758
;  :quant-instantiations    5210
;  :rlimit-count            643508)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@52@05))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@05))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05))))))))))))))))
                                ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@05)))))))))))))))))))))))))))))))) diz@15@05 globals@16@05))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 6
(push) ; 6
; [else-branch: 142 | First:(Second:($t@52@05))[1] != -1 && First:(Second:($t@52@05))[0] != -1]
(assert (and
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@52@05)))
        0)
      (- 0 1)))))
(pop) ; 6
(pop) ; 5
; [eval] !true
; [then-branch: 147 | False | dead]
; [else-branch: 147 | True | live]
(push) ; 5
; [else-branch: 147 | True]
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
