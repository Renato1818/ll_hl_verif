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
; ---------- Sensor_getDistance_EncodedGlobalVariables ----------
(declare-const diz@0@06 $Ref)
(declare-const globals@1@06 $Ref)
(declare-const sys__result@2@06 Int)
(declare-const diz@3@06 $Ref)
(declare-const globals@4@06 $Ref)
(declare-const sys__result@5@06 Int)
(push) ; 1
(declare-const $t@6@06 $Snap)
(assert (= $t@6@06 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@3@06 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@7@06 $Snap)
(assert (= $t@7@06 ($Snap.combine ($Snap.first $t@7@06) ($Snap.second $t@7@06))))
(assert (= ($Snap.first $t@7@06) $Snap.unit))
; [eval] 0 <= sys__result
(assert (<= 0 sys__result@5@06))
(assert (= ($Snap.second $t@7@06) $Snap.unit))
; [eval] sys__result < 256
(assert (< sys__result@5@06 256))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Controller_Controller_EncodedGlobalVariables_Main ----------
(declare-const globals@8@06 $Ref)
(declare-const m_param@9@06 $Ref)
(declare-const sys__result@10@06 $Ref)
(declare-const globals@11@06 $Ref)
(declare-const m_param@12@06 $Ref)
(declare-const sys__result@13@06 $Ref)
(push) ; 1
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(declare-const $t@14@06 $Snap)
(assert (= $t@14@06 ($Snap.combine ($Snap.first $t@14@06) ($Snap.second $t@14@06))))
(assert (= ($Snap.first $t@14@06) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@13@06 $Ref.null)))
(assert (=
  ($Snap.second $t@14@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@14@06))
    ($Snap.second ($Snap.second $t@14@06)))))
(assert (= ($Snap.first ($Snap.second $t@14@06)) $Snap.unit))
; [eval] type_of(sys__result) == class_Controller()
; [eval] type_of(sys__result)
; [eval] class_Controller()
(assert (= (type_of<TYPE> sys__result@13@06) (as class_Controller<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@14@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@14@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@14@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@14@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06))))))
  $Snap.unit))
; [eval] sys__result.Controller_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@06)))))
  m_param@12@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06)))))))
  $Snap.unit))
; [eval] !sys__result.Controller_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@06))))))))))
(pop) ; 2
(push) ; 2
; [exec]
; var diz__14: Ref
(declare-const diz__14@15@06 $Ref)
; [exec]
; diz__14 := new(Controller_m, Controller_alarm_flag, Controller_init)
(declare-const diz__14@16@06 $Ref)
(assert (not (= diz__14@16@06 $Ref.null)))
(declare-const Controller_m@17@06 $Ref)
(declare-const Controller_alarm_flag@18@06 Bool)
(declare-const Controller_init@19@06 Bool)
(assert (not (= diz__14@16@06 sys__result@13@06)))
(assert (not (= diz__14@16@06 globals@11@06)))
(assert (not (= diz__14@16@06 m_param@12@06)))
(assert (not (= diz__14@16@06 diz__14@15@06)))
; [exec]
; inhale type_of(diz__14) == class_Controller()
(declare-const $t@20@06 $Snap)
(assert (= $t@20@06 $Snap.unit))
; [eval] type_of(diz__14) == class_Controller()
; [eval] type_of(diz__14)
; [eval] class_Controller()
(assert (= (type_of<TYPE> diz__14@16@06) (as class_Controller<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz__14.Controller_m := m_param
; [exec]
; diz__14.Controller_alarm_flag := false
; [exec]
; diz__14.Controller_init := false
; [exec]
; inhale acc(Controller_idleToken_EncodedGlobalVariables(diz__14, globals), write)
(declare-const $t@21@06 $Snap)
; State saturation: after inhale
(check-sat)
; unknown
; [exec]
; sys__result := diz__14
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Controller() && acc(Controller_idleToken_EncodedGlobalVariables(sys__result, globals), write) && acc(sys__result.Controller_m, write) && acc(sys__result.Controller_alarm_flag, write) && sys__result.Controller_m == m_param && acc(sys__result.Controller_init, write) && !sys__result.Controller_init
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Controller()
; [eval] type_of(sys__result)
; [eval] class_Controller()
; [eval] sys__result.Controller_m == m_param
; [eval] !sys__result.Controller_init
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Controller___contract_unsatisfiable__run_EncodedGlobalVariables ----------
(declare-const diz@22@06 $Ref)
(declare-const globals@23@06 $Ref)
(declare-const diz@24@06 $Ref)
(declare-const globals@25@06 $Ref)
(push) ; 1
(declare-const $t@26@06 $Snap)
(assert (= $t@26@06 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@24@06 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.Controller_m, 1 / 2) && diz.Controller_m != null && acc(diz.Controller_m.Main_controller, wildcard) && diz.Controller_m.Main_controller == diz && acc(diz.Controller_init, 1 / 2) && !diz.Controller_init)
(declare-const $t@27@06 $Snap)
(assert (= $t@27@06 ($Snap.combine ($Snap.first $t@27@06) ($Snap.second $t@27@06))))
(assert (= ($Snap.first $t@27@06) $Snap.unit))
(assert (=
  ($Snap.second $t@27@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@27@06))
    ($Snap.second ($Snap.second $t@27@06)))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             20
;  :arith-assert-lower    1
;  :arith-assert-upper    1
;  :arith-eq-adapter      1
;  :binary-propagations   11
;  :datatype-accessor-ax  5
;  :datatype-occurs-check 4
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           261
;  :mk-clause             1
;  :num-allocs            3404520
;  :num-checks            6
;  :propagations          11
;  :quant-instantiations  1
;  :rlimit-count          112016)
(assert (=
  ($Snap.second ($Snap.second $t@27@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@27@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@27@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@27@06))) $Snap.unit))
; [eval] diz.Controller_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@27@06))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@27@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@27@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@06)))))))
(declare-const $k@28@06 $Perm)
(assert ($Perm.isReadVar $k@28@06 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@28@06 $Perm.No) (< $Perm.No $k@28@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             32
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             1
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 4
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           270
;  :mk-clause             3
;  :num-allocs            3404520
;  :num-checks            7
;  :propagations          12
;  :quant-instantiations  2
;  :rlimit-count          112588)
(assert (<= $Perm.No $k@28@06))
(assert (<= $k@28@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@28@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@27@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@06)))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_controller == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@28@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             38
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             2
;  :datatype-accessor-ax  8
;  :datatype-occurs-check 4
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           273
;  :mk-clause             3
;  :num-allocs            3404520
;  :num-checks            8
;  :propagations          12
;  :quant-instantiations  2
;  :rlimit-count          112861
;  :time                  0.01)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@27@06)))))
  diz@24@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@06)))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             45
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             2
;  :datatype-accessor-ax  9
;  :datatype-occurs-check 4
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           276
;  :mk-clause             3
;  :num-allocs            3404520
;  :num-checks            9
;  :propagations          12
;  :quant-instantiations  3
;  :rlimit-count          113112)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@06))))))
  $Snap.unit))
; [eval] !diz.Controller_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@06)))))))))
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
; ---------- Main_wakeup_after_wait_EncodedGlobalVariables ----------
(declare-const diz@29@06 $Ref)
(declare-const globals@30@06 $Ref)
(declare-const diz@31@06 $Ref)
(declare-const globals@32@06 $Ref)
(push) ; 1
(declare-const $t@33@06 $Snap)
(assert (= $t@33@06 ($Snap.combine ($Snap.first $t@33@06) ($Snap.second $t@33@06))))
(assert (= ($Snap.first $t@33@06) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@31@06 $Ref.null)))
(assert (=
  ($Snap.second $t@33@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@33@06))
    ($Snap.second ($Snap.second $t@33@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@33@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@33@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@33@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@06))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06)))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06)))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@34@06 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 0 | 0 <= i@34@06 | live]
; [else-branch: 0 | !(0 <= i@34@06) | live]
(push) ; 4
; [then-branch: 0 | 0 <= i@34@06]
(assert (<= 0 i@34@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(0 <= i@34@06)]
(assert (not (<= 0 i@34@06)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 1 | i@34@06 < |First:(Second:(Second:($t@33@06)))| && 0 <= i@34@06 | live]
; [else-branch: 1 | !(i@34@06 < |First:(Second:(Second:($t@33@06)))| && 0 <= i@34@06) | live]
(push) ; 4
; [then-branch: 1 | i@34@06 < |First:(Second:(Second:($t@33@06)))| && 0 <= i@34@06]
(assert (and
  (<
    i@34@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))
  (<= 0 i@34@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@34@06 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               120
;  :arith-assert-diseq      3
;  :arith-assert-lower      10
;  :arith-assert-upper      6
;  :arith-eq-adapter        6
;  :binary-propagations     11
;  :conflicts               2
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   14
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.81
;  :mk-bool-var             312
;  :mk-clause               9
;  :num-allocs              3404520
;  :num-checks              14
;  :propagations            14
;  :quant-instantiations    11
;  :rlimit-count            115728)
; [eval] -1
(push) ; 5
; [then-branch: 2 | First:(Second:(Second:($t@33@06)))[i@34@06] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:($t@33@06)))[i@34@06] != -1 | live]
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:($t@33@06)))[i@34@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    i@34@06)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 2 | First:(Second:(Second:($t@33@06)))[i@34@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      i@34@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@34@06 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               120
;  :arith-assert-diseq      3
;  :arith-assert-lower      10
;  :arith-assert-upper      6
;  :arith-eq-adapter        6
;  :binary-propagations     11
;  :conflicts               2
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   14
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.81
;  :mk-bool-var             313
;  :mk-clause               9
;  :num-allocs              3404520
;  :num-checks              15
;  :propagations            14
;  :quant-instantiations    11
;  :rlimit-count            115891)
(push) ; 7
; [then-branch: 3 | 0 <= First:(Second:(Second:($t@33@06)))[i@34@06] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:($t@33@06)))[i@34@06]) | live]
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:($t@33@06)))[i@34@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    i@34@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@34@06 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               120
;  :arith-assert-diseq      4
;  :arith-assert-lower      13
;  :arith-assert-upper      6
;  :arith-eq-adapter        7
;  :binary-propagations     11
;  :conflicts               2
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   14
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.81
;  :mk-bool-var             316
;  :mk-clause               10
;  :num-allocs              3404520
;  :num-checks              16
;  :propagations            14
;  :quant-instantiations    11
;  :rlimit-count            116004)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 3 | !(0 <= First:(Second:(Second:($t@33@06)))[i@34@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      i@34@06))))
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
; [else-branch: 1 | !(i@34@06 < |First:(Second:(Second:($t@33@06)))| && 0 <= i@34@06)]
(assert (not
  (and
    (<
      i@34@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))
    (<= 0 i@34@06))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@34@06 Int)) (!
  (implies
    (and
      (<
        i@34@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))
      (<= 0 i@34@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          i@34@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            i@34@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            i@34@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    i@34@06))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@35@06 $Snap)
(assert (= $t@35@06 ($Snap.combine ($Snap.first $t@35@06) ($Snap.second $t@35@06))))
(assert (=
  ($Snap.second $t@35@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@35@06))
    ($Snap.second ($Snap.second $t@35@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@35@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@35@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@35@06))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@35@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@36@06 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@36@06 | live]
; [else-branch: 4 | !(0 <= i@36@06) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@36@06]
(assert (<= 0 i@36@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@36@06)]
(assert (not (<= 0 i@36@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@36@06 < |First:(Second:($t@35@06))| && 0 <= i@36@06 | live]
; [else-branch: 5 | !(i@36@06 < |First:(Second:($t@35@06))| && 0 <= i@36@06) | live]
(push) ; 5
; [then-branch: 5 | i@36@06 < |First:(Second:($t@35@06))| && 0 <= i@36@06]
(assert (and
  (<
    i@36@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))))
  (<= 0 i@36@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@36@06 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               175
;  :arith-assert-diseq      4
;  :arith-assert-lower      18
;  :arith-assert-upper      9
;  :arith-eq-adapter        9
;  :binary-propagations     11
;  :conflicts               3
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              9
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             344
;  :mk-clause               11
;  :num-allocs              3526848
;  :num-checks              18
;  :propagations            14
;  :quant-instantiations    15
;  :rlimit-count            117793)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:($t@35@06))[i@36@06] == -1 | live]
; [else-branch: 6 | First:(Second:($t@35@06))[i@36@06] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:($t@35@06))[i@36@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
    i@36@06)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:($t@35@06))[i@36@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
      i@36@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@36@06 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               175
;  :arith-assert-diseq      4
;  :arith-assert-lower      18
;  :arith-assert-upper      9
;  :arith-eq-adapter        9
;  :binary-propagations     11
;  :conflicts               3
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              9
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             345
;  :mk-clause               11
;  :num-allocs              3526848
;  :num-checks              19
;  :propagations            14
;  :quant-instantiations    15
;  :rlimit-count            117944)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:($t@35@06))[i@36@06] | live]
; [else-branch: 7 | !(0 <= First:(Second:($t@35@06))[i@36@06]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:($t@35@06))[i@36@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
    i@36@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@36@06 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               175
;  :arith-assert-diseq      5
;  :arith-assert-lower      21
;  :arith-assert-upper      9
;  :arith-eq-adapter        10
;  :binary-propagations     11
;  :conflicts               3
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              9
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             348
;  :mk-clause               12
;  :num-allocs              3526848
;  :num-checks              20
;  :propagations            14
;  :quant-instantiations    15
;  :rlimit-count            118047)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:($t@35@06))[i@36@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
      i@36@06))))
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
; [else-branch: 5 | !(i@36@06 < |First:(Second:($t@35@06))| && 0 <= i@36@06)]
(assert (not
  (and
    (<
      i@36@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))))
    (<= 0 i@36@06))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@36@06 Int)) (!
  (implies
    (and
      (<
        i@36@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))))
      (<= 0 i@36@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
          i@36@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
            i@36@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
            i@36@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
    i@36@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               193
;  :arith-assert-diseq      5
;  :arith-assert-lower      22
;  :arith-assert-upper      10
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     11
;  :conflicts               3
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              10
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             368
;  :mk-clause               22
;  :num-allocs              3526848
;  :num-checks              21
;  :propagations            18
;  :quant-instantiations    17
;  :rlimit-count            119108)
(push) ; 3
; [then-branch: 8 | 0 <= First:(Second:(Second:($t@33@06)))[0] | live]
; [else-branch: 8 | !(0 <= First:(Second:(Second:($t@33@06)))[0]) | live]
(push) ; 4
; [then-branch: 8 | 0 <= First:(Second:(Second:($t@33@06)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               193
;  :arith-assert-diseq      5
;  :arith-assert-lower      23
;  :arith-assert-upper      10
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :binary-propagations     11
;  :conflicts               3
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              10
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             374
;  :mk-clause               28
;  :num-allocs              3526848
;  :num-checks              22
;  :propagations            18
;  :quant-instantiations    18
;  :rlimit-count            119271)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               193
;  :arith-assert-diseq      5
;  :arith-assert-lower      23
;  :arith-assert-upper      10
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :binary-propagations     11
;  :conflicts               3
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              10
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             374
;  :mk-clause               28
;  :num-allocs              3526848
;  :num-checks              23
;  :propagations            18
;  :quant-instantiations    18
;  :rlimit-count            119280)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-assert-diseq      5
;  :arith-assert-lower      24
;  :arith-assert-upper      11
;  :arith-conflicts         1
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              10
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             374
;  :mk-clause               28
;  :num-allocs              3526848
;  :num-checks              24
;  :propagations            22
;  :quant-instantiations    18
;  :rlimit-count            119388)
(push) ; 5
; [then-branch: 9 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0 | live]
; [else-branch: 9 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] != 0 | live]
(push) ; 6
; [then-branch: 9 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      0))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 9 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-assert-diseq      5
;  :arith-assert-lower      24
;  :arith-assert-upper      11
;  :arith-conflicts         1
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              10
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             375
;  :mk-clause               28
;  :num-allocs              3526848
;  :num-checks              25
;  :propagations            22
;  :quant-instantiations    18
;  :rlimit-count            119607)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-assert-diseq      5
;  :arith-assert-lower      24
;  :arith-assert-upper      11
;  :arith-conflicts         1
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              10
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             375
;  :mk-clause               28
;  :num-allocs              3526848
;  :num-checks              26
;  :propagations            22
;  :quant-instantiations    18
;  :rlimit-count            119616)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               195
;  :arith-assert-diseq      5
;  :arith-assert-lower      25
;  :arith-assert-upper      12
;  :arith-conflicts         2
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              10
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             375
;  :mk-clause               28
;  :num-allocs              3526848
;  :num-checks              27
;  :propagations            26
;  :quant-instantiations    18
;  :rlimit-count            119724)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 8 | !(0 <= First:(Second:(Second:($t@33@06)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               222
;  :arith-assert-diseq      7
;  :arith-assert-lower      32
;  :arith-assert-upper      15
;  :arith-conflicts         2
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   21
;  :datatype-splits         13
;  :decisions               25
;  :del-clause              25
;  :final-checks            15
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             398
;  :mk-clause               37
;  :num-allocs              3526848
;  :num-checks              28
;  :propagations            31
;  :quant-instantiations    20
;  :rlimit-count            120501
;  :time                    0.00)
(push) ; 4
(assert (not (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               245
;  :arith-assert-diseq      7
;  :arith-assert-lower      33
;  :arith-assert-upper      17
;  :arith-conflicts         2
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   25
;  :datatype-splits         18
;  :decisions               33
;  :del-clause              31
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             413
;  :mk-clause               43
;  :num-allocs              3526848
;  :num-checks              29
;  :propagations            33
;  :quant-instantiations    21
;  :rlimit-count            121181
;  :time                    0.00)
; [then-branch: 10 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[0] | live]
; [else-branch: 10 | !(First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[0]) | live]
(push) ; 4
; [then-branch: 10 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[0]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               245
;  :arith-assert-diseq      7
;  :arith-assert-lower      34
;  :arith-assert-upper      17
;  :arith-conflicts         2
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   25
;  :datatype-splits         18
;  :decisions               33
;  :del-clause              31
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             421
;  :mk-clause               50
;  :num-allocs              3526848
;  :num-checks              30
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            121405)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 10 | !(First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               251
;  :arith-assert-diseq      7
;  :arith-assert-lower      34
;  :arith-assert-upper      17
;  :arith-conflicts         2
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   25
;  :datatype-splits         18
;  :decisions               33
;  :del-clause              38
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             428
;  :mk-clause               54
;  :num-allocs              3526848
;  :num-checks              31
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            121944)
(push) ; 3
; [then-branch: 11 | 0 <= First:(Second:(Second:($t@33@06)))[1] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:($t@33@06)))[1]) | live]
(push) ; 4
; [then-branch: 11 | 0 <= First:(Second:(Second:($t@33@06)))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               251
;  :arith-assert-diseq      7
;  :arith-assert-lower      35
;  :arith-assert-upper      17
;  :arith-conflicts         2
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   25
;  :datatype-splits         18
;  :decisions               33
;  :del-clause              38
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             434
;  :mk-clause               60
;  :num-allocs              3526848
;  :num-checks              32
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            122106)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               251
;  :arith-assert-diseq      7
;  :arith-assert-lower      35
;  :arith-assert-upper      17
;  :arith-conflicts         2
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   25
;  :datatype-splits         18
;  :decisions               33
;  :del-clause              38
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             434
;  :mk-clause               60
;  :num-allocs              3526848
;  :num-checks              33
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            122115)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               252
;  :arith-assert-diseq      7
;  :arith-assert-lower      36
;  :arith-assert-upper      18
;  :arith-conflicts         3
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               6
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   25
;  :datatype-splits         18
;  :decisions               33
;  :del-clause              38
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             434
;  :mk-clause               60
;  :num-allocs              3526848
;  :num-checks              34
;  :propagations            37
;  :quant-instantiations    23
;  :rlimit-count            122222)
(push) ; 5
; [then-branch: 12 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0 | live]
; [else-branch: 12 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] != 0 | live]
(push) ; 6
; [then-branch: 12 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      1))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 12 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               252
;  :arith-assert-diseq      7
;  :arith-assert-lower      36
;  :arith-assert-upper      18
;  :arith-conflicts         3
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               6
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   25
;  :datatype-splits         18
;  :decisions               33
;  :del-clause              38
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             435
;  :mk-clause               60
;  :num-allocs              3526848
;  :num-checks              35
;  :propagations            37
;  :quant-instantiations    23
;  :rlimit-count            122441)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               252
;  :arith-assert-diseq      7
;  :arith-assert-lower      36
;  :arith-assert-upper      18
;  :arith-conflicts         3
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               6
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   25
;  :datatype-splits         18
;  :decisions               33
;  :del-clause              38
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             435
;  :mk-clause               60
;  :num-allocs              3526848
;  :num-checks              36
;  :propagations            37
;  :quant-instantiations    23
;  :rlimit-count            122450)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               253
;  :arith-assert-diseq      7
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-conflicts         4
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   25
;  :datatype-splits         18
;  :decisions               33
;  :del-clause              38
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             435
;  :mk-clause               60
;  :num-allocs              3526848
;  :num-checks              37
;  :propagations            41
;  :quant-instantiations    23
;  :rlimit-count            122557)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 11 | !(0 <= First:(Second:(Second:($t@33@06)))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
        1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               283
;  :arith-assert-diseq      9
;  :arith-assert-lower      46
;  :arith-assert-upper      25
;  :arith-conflicts         4
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         3
;  :arith-pivots            5
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   29
;  :datatype-splits         23
;  :decisions               43
;  :del-clause              59
;  :final-checks            20
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             466
;  :mk-clause               75
;  :num-allocs              3526848
;  :num-checks              38
;  :propagations            49
;  :quant-instantiations    26
;  :rlimit-count            123434
;  :time                    0.00)
(push) ; 4
(assert (not (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               312
;  :arith-assert-diseq      11
;  :arith-assert-lower      54
;  :arith-assert-upper      31
;  :arith-conflicts         4
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   33
;  :datatype-splits         28
;  :decisions               54
;  :del-clause              86
;  :final-checks            23
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             497
;  :mk-clause               102
;  :num-allocs              3526848
;  :num-checks              39
;  :propagations            62
;  :quant-instantiations    29
;  :rlimit-count            124280
;  :time                    0.00)
; [then-branch: 13 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[1] | live]
; [else-branch: 13 | !(First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[1]) | live]
(push) ; 4
; [then-branch: 13 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[1]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      1))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               312
;  :arith-assert-diseq      11
;  :arith-assert-lower      55
;  :arith-assert-upper      31
;  :arith-conflicts         4
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   33
;  :datatype-splits         28
;  :decisions               54
;  :del-clause              86
;  :final-checks            23
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             505
;  :mk-clause               109
;  :num-allocs              3526848
;  :num-checks              40
;  :propagations            62
;  :quant-instantiations    30
;  :rlimit-count            124504)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 13 | !(First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
        1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
      1)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               318
;  :arith-assert-diseq      11
;  :arith-assert-lower      55
;  :arith-assert-upper      31
;  :arith-conflicts         4
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   33
;  :datatype-splits         28
;  :decisions               54
;  :del-clause              93
;  :final-checks            23
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             512
;  :mk-clause               113
;  :num-allocs              3526848
;  :num-checks              41
;  :propagations            62
;  :quant-instantiations    30
;  :rlimit-count            125053)
(push) ; 3
; [then-branch: 14 | 0 <= First:(Second:(Second:($t@33@06)))[0] | live]
; [else-branch: 14 | !(0 <= First:(Second:(Second:($t@33@06)))[0]) | live]
(push) ; 4
; [then-branch: 14 | 0 <= First:(Second:(Second:($t@33@06)))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               318
;  :arith-assert-diseq      11
;  :arith-assert-lower      56
;  :arith-assert-upper      31
;  :arith-conflicts         4
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   33
;  :datatype-splits         28
;  :decisions               54
;  :del-clause              93
;  :final-checks            23
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             517
;  :mk-clause               119
;  :num-allocs              3526848
;  :num-checks              42
;  :propagations            62
;  :quant-instantiations    31
;  :rlimit-count            125170)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               318
;  :arith-assert-diseq      11
;  :arith-assert-lower      56
;  :arith-assert-upper      31
;  :arith-conflicts         4
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   33
;  :datatype-splits         28
;  :decisions               54
;  :del-clause              93
;  :final-checks            23
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             517
;  :mk-clause               119
;  :num-allocs              3526848
;  :num-checks              43
;  :propagations            62
;  :quant-instantiations    31
;  :rlimit-count            125179)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               319
;  :arith-assert-diseq      11
;  :arith-assert-lower      57
;  :arith-assert-upper      32
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               8
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   33
;  :datatype-splits         28
;  :decisions               54
;  :del-clause              93
;  :final-checks            23
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             517
;  :mk-clause               119
;  :num-allocs              3526848
;  :num-checks              44
;  :propagations            66
;  :quant-instantiations    31
;  :rlimit-count            125287)
(push) ; 5
; [then-branch: 15 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] != 0 | live]
(push) ; 6
; [then-branch: 15 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      0))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 15 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               319
;  :arith-assert-diseq      11
;  :arith-assert-lower      57
;  :arith-assert-upper      32
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               8
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   33
;  :datatype-splits         28
;  :decisions               54
;  :del-clause              93
;  :final-checks            23
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             517
;  :mk-clause               119
;  :num-allocs              3526848
;  :num-checks              45
;  :propagations            66
;  :quant-instantiations    31
;  :rlimit-count            125490)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               319
;  :arith-assert-diseq      11
;  :arith-assert-lower      57
;  :arith-assert-upper      32
;  :arith-conflicts         5
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               8
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   33
;  :datatype-splits         28
;  :decisions               54
;  :del-clause              93
;  :final-checks            23
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             517
;  :mk-clause               119
;  :num-allocs              3526848
;  :num-checks              46
;  :propagations            66
;  :quant-instantiations    31
;  :rlimit-count            125499)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               320
;  :arith-assert-diseq      11
;  :arith-assert-lower      58
;  :arith-assert-upper      33
;  :arith-conflicts         6
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               9
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   33
;  :datatype-splits         28
;  :decisions               54
;  :del-clause              93
;  :final-checks            23
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             517
;  :mk-clause               119
;  :num-allocs              3526848
;  :num-checks              47
;  :propagations            70
;  :quant-instantiations    31
;  :rlimit-count            125607)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 14 | !(0 <= First:(Second:(Second:($t@33@06)))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      0)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               349
;  :arith-assert-diseq      11
;  :arith-assert-lower      60
;  :arith-assert-upper      37
;  :arith-conflicts         6
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               9
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 58
;  :datatype-occurs-check   37
;  :datatype-splits         33
;  :decisions               63
;  :del-clause              104
;  :final-checks            25
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             533
;  :mk-clause               124
;  :num-allocs              3526848
;  :num-checks              48
;  :propagations            73
;  :quant-instantiations    33
;  :rlimit-count            126365
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
        0))))))
(check-sat)
; unknown
(pop) ; 4
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-assert-diseq      12
;  :arith-assert-lower      65
;  :arith-assert-upper      42
;  :arith-conflicts         6
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               12
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   45
;  :datatype-splits         46
;  :decisions               80
;  :del-clause              113
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             572
;  :mk-clause               133
;  :num-allocs              3526848
;  :num-checks              49
;  :propagations            80
;  :quant-instantiations    36
;  :rlimit-count            127270
;  :time                    0.00)
; [then-branch: 16 | !(First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[0]) | live]
; [else-branch: 16 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[0] | live]
(push) ; 4
; [then-branch: 16 | !(First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            0))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-assert-diseq      12
;  :arith-assert-lower      65
;  :arith-assert-upper      42
;  :arith-conflicts         6
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               12
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   45
;  :datatype-splits         46
;  :decisions               80
;  :del-clause              113
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             572
;  :mk-clause               134
;  :num-allocs              3526848
;  :num-checks              50
;  :propagations            80
;  :quant-instantiations    36
;  :rlimit-count            127485)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-assert-diseq      12
;  :arith-assert-lower      65
;  :arith-assert-upper      42
;  :arith-conflicts         6
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               12
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   45
;  :datatype-splits         46
;  :decisions               80
;  :del-clause              113
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             572
;  :mk-clause               134
;  :num-allocs              3526848
;  :num-checks              51
;  :propagations            80
;  :quant-instantiations    36
;  :rlimit-count            127500)
(pop) ; 4
(push) ; 4
; [else-branch: 16 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[0]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[0]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          0))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
              0))
          0)
        (=
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               404
;  :arith-assert-diseq      12
;  :arith-assert-lower      65
;  :arith-assert-upper      42
;  :arith-conflicts         6
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               12
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   45
;  :datatype-splits         46
;  :decisions               80
;  :del-clause              114
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             575
;  :mk-clause               138
;  :num-allocs              3526848
;  :num-checks              52
;  :propagations            80
;  :quant-instantiations    36
;  :rlimit-count            127943)
(push) ; 3
; [then-branch: 17 | 0 <= First:(Second:(Second:($t@33@06)))[1] | live]
; [else-branch: 17 | !(0 <= First:(Second:(Second:($t@33@06)))[1]) | live]
(push) ; 4
; [then-branch: 17 | 0 <= First:(Second:(Second:($t@33@06)))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               404
;  :arith-assert-diseq      12
;  :arith-assert-lower      66
;  :arith-assert-upper      42
;  :arith-conflicts         6
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               12
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   45
;  :datatype-splits         46
;  :decisions               80
;  :del-clause              114
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             580
;  :mk-clause               144
;  :num-allocs              3526848
;  :num-checks              53
;  :propagations            80
;  :quant-instantiations    37
;  :rlimit-count            128060)
(push) ; 5
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               404
;  :arith-assert-diseq      12
;  :arith-assert-lower      66
;  :arith-assert-upper      42
;  :arith-conflicts         6
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               12
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   45
;  :datatype-splits         46
;  :decisions               80
;  :del-clause              114
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             580
;  :mk-clause               144
;  :num-allocs              3526848
;  :num-checks              54
;  :propagations            80
;  :quant-instantiations    37
;  :rlimit-count            128069)
(push) ; 5
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               405
;  :arith-assert-diseq      12
;  :arith-assert-lower      67
;  :arith-assert-upper      43
;  :arith-conflicts         7
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               13
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   45
;  :datatype-splits         46
;  :decisions               80
;  :del-clause              114
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             580
;  :mk-clause               144
;  :num-allocs              3526848
;  :num-checks              55
;  :propagations            84
;  :quant-instantiations    37
;  :rlimit-count            128177)
(push) ; 5
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] != 0 | live]
(push) ; 6
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      1))
  0))
(pop) ; 6
(push) ; 6
; [else-branch: 18 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               405
;  :arith-assert-diseq      12
;  :arith-assert-lower      67
;  :arith-assert-upper      43
;  :arith-conflicts         7
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               13
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   45
;  :datatype-splits         46
;  :decisions               80
;  :del-clause              114
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             580
;  :mk-clause               144
;  :num-allocs              3526848
;  :num-checks              56
;  :propagations            84
;  :quant-instantiations    37
;  :rlimit-count            128380)
(push) ; 7
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               405
;  :arith-assert-diseq      12
;  :arith-assert-lower      67
;  :arith-assert-upper      43
;  :arith-conflicts         7
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               13
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   45
;  :datatype-splits         46
;  :decisions               80
;  :del-clause              114
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             580
;  :mk-clause               144
;  :num-allocs              3526848
;  :num-checks              57
;  :propagations            84
;  :quant-instantiations    37
;  :rlimit-count            128389)
(push) ; 7
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               406
;  :arith-assert-diseq      12
;  :arith-assert-lower      68
;  :arith-assert-upper      44
;  :arith-conflicts         8
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         4
;  :arith-pivots            7
;  :binary-propagations     11
;  :conflicts               14
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   45
;  :datatype-splits         46
;  :decisions               80
;  :del-clause              114
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             580
;  :mk-clause               144
;  :num-allocs              3526848
;  :num-checks              58
;  :propagations            88
;  :quant-instantiations    37
;  :rlimit-count            128497)
; [eval] -1
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 17 | !(0 <= First:(Second:(Second:($t@33@06)))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               436
;  :arith-assert-diseq      12
;  :arith-assert-lower      71
;  :arith-assert-upper      49
;  :arith-bound-prop        2
;  :arith-conflicts         8
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         5
;  :arith-pivots            9
;  :binary-propagations     11
;  :conflicts               14
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   49
;  :datatype-splits         50
;  :decisions               88
;  :del-clause              133
;  :final-checks            31
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             605
;  :mk-clause               157
;  :num-allocs              3657492
;  :num-checks              59
;  :propagations            94
;  :quant-instantiations    40
;  :rlimit-count            129304
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
        1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               490
;  :arith-assert-diseq      13
;  :arith-assert-lower      76
;  :arith-assert-upper      53
;  :arith-bound-prop        4
;  :arith-conflicts         8
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         6
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               17
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   57
;  :datatype-splits         61
;  :decisions               103
;  :del-clause              148
;  :final-checks            35
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             647
;  :mk-clause               172
;  :num-allocs              3657492
;  :num-checks              60
;  :propagations            103
;  :quant-instantiations    43
;  :rlimit-count            130230
;  :time                    0.00)
; [then-branch: 19 | !(First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[1]) | live]
; [else-branch: 19 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[1] | live]
(push) ; 4
; [then-branch: 19 | !(First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            1))
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
        1)))))
; [eval] diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               490
;  :arith-assert-diseq      13
;  :arith-assert-lower      76
;  :arith-assert-upper      53
;  :arith-bound-prop        4
;  :arith-conflicts         8
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         6
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               17
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   57
;  :datatype-splits         61
;  :decisions               103
;  :del-clause              148
;  :final-checks            35
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             647
;  :mk-clause               173
;  :num-allocs              3657492
;  :num-checks              61
;  :propagations            103
;  :quant-instantiations    43
;  :rlimit-count            130445)
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               490
;  :arith-assert-diseq      13
;  :arith-assert-lower      76
;  :arith-assert-upper      53
;  :arith-bound-prop        4
;  :arith-conflicts         8
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         6
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               17
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   57
;  :datatype-splits         61
;  :decisions               103
;  :del-clause              148
;  :final-checks            35
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             647
;  :mk-clause               173
;  :num-allocs              3657492
;  :num-checks              62
;  :propagations            103
;  :quant-instantiations    43
;  :rlimit-count            130460)
(pop) ; 4
(push) ; 4
; [else-branch: 19 | First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == 0 || First:(Second:(Second:(Second:(Second:($t@33@06)))))[First:(Second:(Second:($t@33@06)))[1]] == -1 && 0 <= First:(Second:(Second:($t@33@06)))[1]]
(assert (and
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          1))
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
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
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
              1))
          0)
        (=
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@06))))))
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
              1))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
          1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@35@06)))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@33@06))))
      1))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
