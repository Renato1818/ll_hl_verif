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
; ---------- Sensor_Sensor_EncodedGlobalVariables_Main ----------
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
; [eval] type_of(sys__result) == class_Sensor()
; [eval] type_of(sys__result)
; [eval] class_Sensor()
(assert (= (type_of<TYPE> sys__result@5@07) (as class_Sensor<TYPE>  TYPE)))
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
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))
  $Snap.unit))
; [eval] sys__result.Sensor_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))
  m_param@4@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))
  $Snap.unit))
; [eval] !sys__result.Sensor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))
(pop) ; 2
(push) ; 2
; [exec]
; var diz__1: Ref
(declare-const diz__1@7@07 $Ref)
; [exec]
; diz__1 := new(Sensor_m, Sensor_dist, Sensor_obs_detected, Sensor_init)
(declare-const diz__1@8@07 $Ref)
(assert (not (= diz__1@8@07 $Ref.null)))
(declare-const Sensor_m@9@07 $Ref)
(declare-const Sensor_dist@10@07 Int)
(declare-const Sensor_obs_detected@11@07 Bool)
(declare-const Sensor_init@12@07 Bool)
(assert (not (= diz__1@8@07 sys__result@5@07)))
(assert (not (= diz__1@8@07 diz__1@7@07)))
(assert (not (= diz__1@8@07 m_param@4@07)))
(assert (not (= diz__1@8@07 globals@3@07)))
; [exec]
; inhale type_of(diz__1) == class_Sensor()
(declare-const $t@13@07 $Snap)
(assert (= $t@13@07 $Snap.unit))
; [eval] type_of(diz__1) == class_Sensor()
; [eval] type_of(diz__1)
; [eval] class_Sensor()
(assert (= (type_of<TYPE> diz__1@8@07) (as class_Sensor<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz__1.Sensor_m := m_param
; [exec]
; diz__1.Sensor_dist := 0
; [exec]
; diz__1.Sensor_obs_detected := false
; [exec]
; diz__1.Sensor_init := false
; [exec]
; inhale acc(Sensor_idleToken_EncodedGlobalVariables(diz__1, globals), write)
(declare-const $t@14@07 $Snap)
; State saturation: after inhale
(check-sat)
; unknown
; [exec]
; sys__result := diz__1
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Sensor() && acc(Sensor_idleToken_EncodedGlobalVariables(sys__result, globals), write) && acc(sys__result.Sensor_m, write) && acc(sys__result.Sensor_dist, write) && acc(sys__result.Sensor_obs_detected, write) && sys__result.Sensor_m == m_param && acc(sys__result.Sensor_init, write) && !sys__result.Sensor_init
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Sensor()
; [eval] type_of(sys__result)
; [eval] class_Sensor()
; [eval] sys__result.Sensor_m == m_param
; [eval] !sys__result.Sensor_init
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Controller_run_EncodedGlobalVariables ----------
(declare-const diz@15@07 $Ref)
(declare-const globals@16@07 $Ref)
(declare-const diz@17@07 $Ref)
(declare-const globals@18@07 $Ref)
(push) ; 1
(declare-const $t@19@07 $Snap)
(assert (= $t@19@07 ($Snap.combine ($Snap.first $t@19@07) ($Snap.second $t@19@07))))
(assert (= ($Snap.first $t@19@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@17@07 $Ref.null)))
(assert (=
  ($Snap.second $t@19@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@19@07))
    ($Snap.second ($Snap.second $t@19@07)))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             18
;  :arith-assert-lower    1
;  :arith-assert-upper    1
;  :arith-eq-adapter      1
;  :binary-propagations   11
;  :datatype-accessor-ax  4
;  :datatype-occurs-check 2
;  :final-checks          3
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.80
;  :mk-bool-var           258
;  :mk-clause             1
;  :num-allocs            3404220
;  :num-checks            4
;  :propagations          11
;  :quant-instantiations  1
;  :rlimit-count          111354)
(assert (=
  ($Snap.second ($Snap.second $t@19@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@19@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@19@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@19@07))) $Snap.unit))
; [eval] diz.Controller_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@07))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@19@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@07)))))))
(declare-const $k@20@07 $Perm)
(assert ($Perm.isReadVar $k@20@07 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@20@07 $Perm.No) (< $Perm.No $k@20@07))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             30
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             1
;  :datatype-accessor-ax  6
;  :datatype-occurs-check 2
;  :final-checks          3
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.80
;  :mk-bool-var           267
;  :mk-clause             3
;  :num-allocs            3404220
;  :num-checks            5
;  :propagations          12
;  :quant-instantiations  2
;  :rlimit-count          111926)
(assert (<= $Perm.No $k@20@07))
(assert (<= $k@20@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@20@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@07)))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_controller == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@20@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             36
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             2
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 2
;  :final-checks          3
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.80
;  :mk-bool-var           270
;  :mk-clause             3
;  :num-allocs            3404220
;  :num-checks            6
;  :propagations          12
;  :quant-instantiations  2
;  :rlimit-count          112199)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@07)))))
  diz@17@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@07)))))))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             43
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             2
;  :datatype-accessor-ax  8
;  :datatype-occurs-check 2
;  :final-checks          3
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.80
;  :mk-bool-var           273
;  :mk-clause             3
;  :num-allocs            3404220
;  :num-checks            7
;  :propagations          12
;  :quant-instantiations  3
;  :rlimit-count          112450)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@07))))))
  $Snap.unit))
; [eval] !diz.Controller_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@07)))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@21@07 $Snap)
(assert (= $t@21@07 ($Snap.combine ($Snap.first $t@21@07) ($Snap.second $t@21@07))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               61
;  :arith-assert-diseq      1
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-eq-adapter        2
;  :binary-propagations     11
;  :conflicts               2
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   4
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            5
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             281
;  :mk-clause               3
;  :num-allocs              3404220
;  :num-checks              9
;  :propagations            12
;  :quant-instantiations    5
;  :rlimit-count            113099)
(assert (=
  ($Snap.second $t@21@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@21@07))
    ($Snap.second ($Snap.second $t@21@07)))))
(assert (= ($Snap.first ($Snap.second $t@21@07)) $Snap.unit))
; [eval] diz.Controller_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@21@07)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@21@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@21@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@21@07))))))
(declare-const $k@22@07 $Perm)
(assert ($Perm.isReadVar $k@22@07 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@22@07 $Perm.No) (< $Perm.No $k@22@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               73
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               3
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   4
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            5
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             290
;  :mk-clause               5
;  :num-allocs              3404220
;  :num-checks              10
;  :propagations            13
;  :quant-instantiations    6
;  :rlimit-count            113660)
(assert (<= $Perm.No $k@22@07))
(assert (<= $k@22@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@22@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@21@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@21@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@21@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@07)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@21@07))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_controller == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@22@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               79
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   4
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            5
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             293
;  :mk-clause               5
;  :num-allocs              3404220
;  :num-checks              11
;  :propagations            13
;  :quant-instantiations    6
;  :rlimit-count            113923)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@21@07))))
  diz@17@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@07))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               87
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   4
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            5
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             296
;  :mk-clause               5
;  :num-allocs              3404220
;  :num-checks              12
;  :propagations            13
;  :quant-instantiations    7
;  :rlimit-count            114163)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@07)))))
  $Snap.unit))
; [eval] !diz.Controller_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@07))))))))
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_12__15: Ref
(declare-const __flatten_12__15@23@07 $Ref)
; [exec]
; var __flatten_13__16: Seq[Int]
(declare-const __flatten_13__16@24@07 Seq<Int>)
; [exec]
; var __flatten_14__17: Ref
(declare-const __flatten_14__17@25@07 $Ref)
; [exec]
; var __flatten_15__18: Ref
(declare-const __flatten_15__18@26@07 $Ref)
; [exec]
; var __flatten_16__19: Ref
(declare-const __flatten_16__19@27@07 $Ref)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
(declare-const $t@28@07 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
(assert (= $t@28@07 ($Snap.combine ($Snap.first $t@28@07) ($Snap.second $t@28@07))))
(assert (= ($Snap.first $t@28@07) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@28@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@28@07))
    ($Snap.second ($Snap.second $t@28@07)))))
(assert (= ($Snap.first ($Snap.second $t@28@07)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@28@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@28@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@28@07))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@28@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@29@07 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@29@07 | live]
; [else-branch: 0 | !(0 <= i@29@07) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@29@07]
(assert (<= 0 i@29@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@29@07)]
(assert (not (<= 0 i@29@07)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@29@07 < |First:(Second:(Second:(Second:($t@28@07))))| && 0 <= i@29@07 | live]
; [else-branch: 1 | !(i@29@07 < |First:(Second:(Second:(Second:($t@28@07))))| && 0 <= i@29@07) | live]
(push) ; 5
; [then-branch: 1 | i@29@07 < |First:(Second:(Second:(Second:($t@28@07))))| && 0 <= i@29@07]
(assert (and
  (<
    i@29@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
  (<= 0 i@29@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@29@07 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               145
;  :arith-assert-diseq      4
;  :arith-assert-lower      12
;  :arith-assert-upper      8
;  :arith-eq-adapter        7
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              4
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             328
;  :mk-clause               11
;  :num-allocs              3524043
;  :num-checks              14
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            115842)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:($t@28@07))))[i@29@07] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:($t@28@07))))[i@29@07] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:($t@28@07))))[i@29@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
    i@29@07)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:($t@28@07))))[i@29@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
      i@29@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@29@07 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               145
;  :arith-assert-diseq      4
;  :arith-assert-lower      12
;  :arith-assert-upper      8
;  :arith-eq-adapter        7
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              4
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             329
;  :mk-clause               11
;  :num-allocs              3524043
;  :num-checks              15
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            116017)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@28@07))))[i@29@07] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@28@07))))[i@29@07]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@28@07))))[i@29@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
    i@29@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@29@07 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               145
;  :arith-assert-diseq      5
;  :arith-assert-lower      15
;  :arith-assert-upper      8
;  :arith-eq-adapter        8
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              4
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             332
;  :mk-clause               12
;  :num-allocs              3524043
;  :num-checks              16
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            116141)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@28@07))))[i@29@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
      i@29@07))))
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
; [else-branch: 1 | !(i@29@07 < |First:(Second:(Second:(Second:($t@28@07))))| && 0 <= i@29@07)]
(assert (not
  (and
    (<
      i@29@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
    (<= 0 i@29@07))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@29@07 Int)) (!
  (implies
    (and
      (<
        i@29@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
      (<= 0 i@29@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
          i@29@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
            i@29@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
            i@29@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
    i@29@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))
(declare-const $k@30@07 $Perm)
(assert ($Perm.isReadVar $k@30@07 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@30@07 $Perm.No) (< $Perm.No $k@30@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               150
;  :arith-assert-diseq      6
;  :arith-assert-lower      17
;  :arith-assert-upper      9
;  :arith-eq-adapter        9
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             338
;  :mk-clause               14
;  :num-allocs              3524043
;  :num-checks              17
;  :propagations            16
;  :quant-instantiations    13
;  :rlimit-count            116909)
(assert (<= $Perm.No $k@30@07))
(assert (<= $k@30@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@30@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))
  $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@30@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               156
;  :arith-assert-diseq      6
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     11
;  :conflicts               6
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             341
;  :mk-clause               14
;  :num-allocs              3524043
;  :num-checks              18
;  :propagations            16
;  :quant-instantiations    13
;  :rlimit-count            117232)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@30@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               162
;  :arith-assert-diseq      6
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             344
;  :mk-clause               14
;  :num-allocs              3524043
;  :num-checks              19
;  :propagations            16
;  :quant-instantiations    14
;  :rlimit-count            117588)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@30@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               167
;  :arith-assert-diseq      6
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     11
;  :conflicts               8
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             345
;  :mk-clause               14
;  :num-allocs              3524043
;  :num-checks              20
;  :propagations            16
;  :quant-instantiations    14
;  :rlimit-count            117845)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@30@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               172
;  :arith-assert-diseq      6
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     11
;  :conflicts               9
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             346
;  :mk-clause               14
;  :num-allocs              3524043
;  :num-checks              21
;  :propagations            16
;  :quant-instantiations    14
;  :rlimit-count            118112)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               172
;  :arith-assert-diseq      6
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :binary-propagations     11
;  :conflicts               9
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             346
;  :mk-clause               14
;  :num-allocs              3524043
;  :num-checks              22
;  :propagations            16
;  :quant-instantiations    14
;  :rlimit-count            118125)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))
(declare-const $k@31@07 $Perm)
(assert ($Perm.isReadVar $k@31@07 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@31@07 $Perm.No) (< $Perm.No $k@31@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               177
;  :arith-assert-diseq      7
;  :arith-assert-lower      19
;  :arith-assert-upper      11
;  :arith-eq-adapter        10
;  :binary-propagations     11
;  :conflicts               10
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             351
;  :mk-clause               16
;  :num-allocs              3524043
;  :num-checks              23
;  :propagations            17
;  :quant-instantiations    14
;  :rlimit-count            118546)
(declare-const $t@32@07 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@20@07)
    (=
      $t@32@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@07)))))))
  (implies
    (< $Perm.No $k@31@07)
    (=
      $t@32@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))
(assert (<= $Perm.No (+ $k@20@07 $k@31@07)))
(assert (<= (+ $k@20@07 $k@31@07) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@20@07 $k@31@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@07 $k@31@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               187
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      13
;  :arith-conflicts         1
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               11
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             359
;  :mk-clause               16
;  :num-allocs              3524043
;  :num-checks              24
;  :propagations            17
;  :quant-instantiations    15
;  :rlimit-count            119177)
(assert (not (= $t@32@07 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@07 $k@31@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               193
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      14
;  :arith-conflicts         2
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               12
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             362
;  :mk-clause               16
;  :num-allocs              3524043
;  :num-checks              25
;  :propagations            17
;  :quant-instantiations    15
;  :rlimit-count            119533)
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@07 $k@31@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               193
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      15
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               13
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             363
;  :mk-clause               16
;  :num-allocs              3524043
;  :num-checks              26
;  :propagations            17
;  :quant-instantiations    15
;  :rlimit-count            119595)
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
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      15
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               13
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             363
;  :mk-clause               16
;  :num-allocs              3524043
;  :num-checks              27
;  :propagations            17
;  :quant-instantiations    15
;  :rlimit-count            119608)
(set-option :timeout 10)
(push) ; 3
(assert (not (= diz@17@07 $t@32@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               193
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      15
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               14
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            6
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             364
;  :mk-clause               16
;  :num-allocs              3524043
;  :num-checks              28
;  :propagations            17
;  :quant-instantiations    15
;  :rlimit-count            119668)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@07)))))))
  ($SortWrappers.$SnapToBool ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@28@07 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@07))) globals@18@07))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Controller_m, globals), write)
(declare-const $t@33@07 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz.Controller_alarm_flag := false
(set-option :timeout 10)
(push) ; 3
(assert (not (= $t@32@07 diz@17@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               276
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      15
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               16
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              15
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             387
;  :mk-clause               17
;  :num-allocs              3647216
;  :num-checks              31
;  :propagations            18
;  :quant-instantiations    16
;  :rlimit-count            121039)
; [exec]
; diz.Controller_init := true
(declare-const __flatten_12__15@34@07 $Ref)
(declare-const __flatten_14__17@35@07 $Ref)
(declare-const __flatten_13__16@36@07 Seq<Int>)
(declare-const __flatten_16__19@37@07 $Ref)
(declare-const __flatten_15__18@38@07 $Ref)
(push) ; 3
; Loop head block: Check well-definedness of invariant
(declare-const $t@39@07 $Snap)
(assert (= $t@39@07 ($Snap.combine ($Snap.first $t@39@07) ($Snap.second $t@39@07))))
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               281
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      15
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               16
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              15
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             388
;  :mk-clause               17
;  :num-allocs              3647216
;  :num-checks              32
;  :propagations            18
;  :quant-instantiations    16
;  :rlimit-count            121152)
(assert (=
  ($Snap.second $t@39@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@39@07))
    ($Snap.second ($Snap.second $t@39@07)))))
(assert (= ($Snap.first ($Snap.second $t@39@07)) $Snap.unit))
; [eval] diz.Controller_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@39@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@39@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@39@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
  $Snap.unit))
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
  $Snap.unit))
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))
  $Snap.unit))
; [eval] (forall i__20: Int :: { diz.Controller_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|)
(declare-const i__20@40@07 Int)
(push) ; 4
; [eval] 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__20
(push) ; 5
; [then-branch: 4 | 0 <= i__20@40@07 | live]
; [else-branch: 4 | !(0 <= i__20@40@07) | live]
(push) ; 6
; [then-branch: 4 | 0 <= i__20@40@07]
(assert (<= 0 i__20@40@07))
; [eval] i__20 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 4 | !(0 <= i__20@40@07)]
(assert (not (<= 0 i__20@40@07)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 5 | i__20@40@07 < |First:(Second:(Second:(Second:($t@39@07))))| && 0 <= i__20@40@07 | live]
; [else-branch: 5 | !(i__20@40@07 < |First:(Second:(Second:(Second:($t@39@07))))| && 0 <= i__20@40@07) | live]
(push) ; 6
; [then-branch: 5 | i__20@40@07 < |First:(Second:(Second:(Second:($t@39@07))))| && 0 <= i__20@40@07]
(assert (and
  (<
    i__20@40@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
  (<= 0 i__20@40@07)))
; [eval] diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__20] == -1
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 7
(assert (not (>= i__20@40@07 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               325
;  :arith-assert-diseq      7
;  :arith-assert-lower      25
;  :arith-assert-upper      18
;  :arith-conflicts         3
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               16
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              15
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             413
;  :mk-clause               17
;  :num-allocs              3647216
;  :num-checks              33
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            122430)
; [eval] -1
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@39@07))))[i__20@40@07] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@39@07))))[i__20@40@07] != -1 | live]
(push) ; 8
; [then-branch: 6 | First:(Second:(Second:(Second:($t@39@07))))[i__20@40@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
    i__20@40@07)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 6 | First:(Second:(Second:(Second:($t@39@07))))[i__20@40@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
      i__20@40@07)
    (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__20]
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 9
(assert (not (>= i__20@40@07 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               325
;  :arith-assert-diseq      7
;  :arith-assert-lower      25
;  :arith-assert-upper      18
;  :arith-conflicts         3
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               16
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              15
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             414
;  :mk-clause               17
;  :num-allocs              3647216
;  :num-checks              34
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            122605)
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@39@07))))[i__20@40@07] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@39@07))))[i__20@40@07]) | live]
(push) ; 10
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@39@07))))[i__20@40@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
    i__20@40@07)))
; [eval] diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 11
(assert (not (>= i__20@40@07 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               325
;  :arith-assert-diseq      8
;  :arith-assert-lower      28
;  :arith-assert-upper      18
;  :arith-conflicts         3
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               16
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              15
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             417
;  :mk-clause               18
;  :num-allocs              3647216
;  :num-checks              35
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            122729)
; [eval] |diz.Controller_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@39@07))))[i__20@40@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
      i__20@40@07))))
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
; [else-branch: 5 | !(i__20@40@07 < |First:(Second:(Second:(Second:($t@39@07))))| && 0 <= i__20@40@07)]
(assert (not
  (and
    (<
      i__20@40@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
    (<= 0 i__20@40@07))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__20@40@07 Int)) (!
  (implies
    (and
      (<
        i__20@40@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
      (<= 0 i__20@40@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
          i__20@40@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
            i__20@40@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
            i__20@40@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
    i__20@40@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))
(declare-const $k@41@07 $Perm)
(assert ($Perm.isReadVar $k@41@07 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@41@07 $Perm.No) (< $Perm.No $k@41@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               330
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      19
;  :arith-conflicts         3
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               17
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             423
;  :mk-clause               20
;  :num-allocs              3647216
;  :num-checks              36
;  :propagations            19
;  :quant-instantiations    21
;  :rlimit-count            123498)
(assert (<= $Perm.No $k@41@07))
(assert (<= $k@41@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@41@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_sensor != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@41@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               336
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      20
;  :arith-conflicts         3
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               18
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             426
;  :mk-clause               20
;  :num-allocs              3647216
;  :num-checks              37
;  :propagations            19
;  :quant-instantiations    21
;  :rlimit-count            123821
;  :time                    0.00)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@41@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               342
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      20
;  :arith-conflicts         3
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               19
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             429
;  :mk-clause               20
;  :num-allocs              3647216
;  :num-checks              38
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124177)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@41@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               347
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      20
;  :arith-conflicts         3
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               20
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             430
;  :mk-clause               20
;  :num-allocs              3647216
;  :num-checks              39
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124434)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@41@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               352
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      20
;  :arith-conflicts         3
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               21
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             431
;  :mk-clause               20
;  :num-allocs              3647216
;  :num-checks              40
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124701)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               352
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      20
;  :arith-conflicts         3
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               21
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             431
;  :mk-clause               20
;  :num-allocs              3647216
;  :num-checks              41
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124714)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))
(declare-const $k@42@07 $Perm)
(assert ($Perm.isReadVar $k@42@07 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@42@07 $Perm.No) (< $Perm.No $k@42@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      21
;  :arith-conflicts         3
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               22
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             436
;  :mk-clause               22
;  :num-allocs              3647216
;  :num-checks              42
;  :propagations            20
;  :quant-instantiations    22
;  :rlimit-count            125134)
(assert (<= $Perm.No $k@42@07))
(assert (<= $k@42@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@42@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_controller != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@42@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               363
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      22
;  :arith-conflicts         3
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               23
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             439
;  :mk-clause               22
;  :num-allocs              3647216
;  :num-checks              43
;  :propagations            20
;  :quant-instantiations    22
;  :rlimit-count            125507)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@42@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               369
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      22
;  :arith-conflicts         3
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               24
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             442
;  :mk-clause               22
;  :num-allocs              3647216
;  :num-checks              44
;  :propagations            20
;  :quant-instantiations    23
;  :rlimit-count            125917)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@42@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               374
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      22
;  :arith-conflicts         3
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             443
;  :mk-clause               22
;  :num-allocs              3647216
;  :num-checks              45
;  :propagations            20
;  :quant-instantiations    23
;  :rlimit-count            126224)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               374
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      22
;  :arith-conflicts         3
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             443
;  :mk-clause               22
;  :num-allocs              3647216
;  :num-checks              46
;  :propagations            20
;  :quant-instantiations    23
;  :rlimit-count            126237)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_controller == diz
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@42@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               380
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      22
;  :arith-conflicts         3
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               26
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             445
;  :mk-clause               22
;  :num-allocs              3647216
;  :num-checks              47
;  :propagations            20
;  :quant-instantiations    23
;  :rlimit-count            126586)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
  diz@17@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               388
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      22
;  :arith-conflicts         3
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               26
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              16
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             447
;  :mk-clause               22
;  :num-allocs              3647216
;  :num-checks              48
;  :propagations            20
;  :quant-instantiations    23
;  :rlimit-count            126930)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))))
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
; (:added-eqs               396
;  :arith-assert-diseq      10
;  :arith-assert-lower      32
;  :arith-assert-upper      22
;  :arith-conflicts         3
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               26
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              20
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             453
;  :mk-clause               22
;  :num-allocs              3647216
;  :num-checks              49
;  :propagations            20
;  :quant-instantiations    26
;  :rlimit-count            127377)
; [eval] diz.Controller_m != null
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
; [eval] (forall i__20: Int :: { diz.Controller_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|)
(declare-const i__20@43@07 Int)
(push) ; 4
; [eval] 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__20
(push) ; 5
; [then-branch: 8 | 0 <= i__20@43@07 | live]
; [else-branch: 8 | !(0 <= i__20@43@07) | live]
(push) ; 6
; [then-branch: 8 | 0 <= i__20@43@07]
(assert (<= 0 i__20@43@07))
; [eval] i__20 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 8 | !(0 <= i__20@43@07)]
(assert (not (<= 0 i__20@43@07)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 9 | i__20@43@07 < |First:(Second:(Second:(Second:($t@28@07))))| && 0 <= i__20@43@07 | live]
; [else-branch: 9 | !(i__20@43@07 < |First:(Second:(Second:(Second:($t@28@07))))| && 0 <= i__20@43@07) | live]
(push) ; 6
; [then-branch: 9 | i__20@43@07 < |First:(Second:(Second:(Second:($t@28@07))))| && 0 <= i__20@43@07]
(assert (and
  (<
    i__20@43@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
  (<= 0 i__20@43@07)))
; [eval] diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__20] == -1
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 7
(assert (not (>= i__20@43@07 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      10
;  :arith-assert-lower      33
;  :arith-assert-upper      23
;  :arith-conflicts         3
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               26
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              20
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             455
;  :mk-clause               22
;  :num-allocs              3647216
;  :num-checks              50
;  :propagations            20
;  :quant-instantiations    26
;  :rlimit-count            127513)
; [eval] -1
(push) ; 7
; [then-branch: 10 | First:(Second:(Second:(Second:($t@28@07))))[i__20@43@07] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:(Second:($t@28@07))))[i__20@43@07] != -1 | live]
(push) ; 8
; [then-branch: 10 | First:(Second:(Second:(Second:($t@28@07))))[i__20@43@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
    i__20@43@07)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 10 | First:(Second:(Second:(Second:($t@28@07))))[i__20@43@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
      i__20@43@07)
    (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__20]
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 9
(assert (not (>= i__20@43@07 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      11
;  :arith-assert-lower      36
;  :arith-assert-upper      24
;  :arith-conflicts         3
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               26
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              20
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             461
;  :mk-clause               26
;  :num-allocs              3647216
;  :num-checks              51
;  :propagations            22
;  :quant-instantiations    27
;  :rlimit-count            127745)
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@28@07))))[i__20@43@07] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@28@07))))[i__20@43@07]) | live]
(push) ; 10
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@28@07))))[i__20@43@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
    i__20@43@07)))
; [eval] diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 11
(assert (not (>= i__20@43@07 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      11
;  :arith-assert-lower      36
;  :arith-assert-upper      24
;  :arith-conflicts         3
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               26
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              20
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             461
;  :mk-clause               26
;  :num-allocs              3647216
;  :num-checks              52
;  :propagations            22
;  :quant-instantiations    27
;  :rlimit-count            127859)
; [eval] |diz.Controller_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@28@07))))[i__20@43@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
      i__20@43@07))))
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
; [else-branch: 9 | !(i__20@43@07 < |First:(Second:(Second:(Second:($t@28@07))))| && 0 <= i__20@43@07)]
(assert (not
  (and
    (<
      i__20@43@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
    (<= 0 i__20@43@07))))
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
(assert (not (forall ((i__20@43@07 Int)) (!
  (implies
    (and
      (<
        i__20@43@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
      (<= 0 i__20@43@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
          i__20@43@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
            i__20@43@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
            i__20@43@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
    i__20@43@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      25
;  :arith-conflicts         3
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               27
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              36
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             469
;  :mk-clause               38
;  :num-allocs              3647216
;  :num-checks              53
;  :propagations            24
;  :quant-instantiations    28
;  :rlimit-count            128305)
(assert (forall ((i__20@43@07 Int)) (!
  (implies
    (and
      (<
        i__20@43@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
      (<= 0 i__20@43@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
          i__20@43@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
            i__20@43@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
            i__20@43@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
    i__20@43@07))
  :qid |prog.l<no position>|)))
(declare-const $k@44@07 $Perm)
(assert ($Perm.isReadVar $k@44@07 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@44@07 $Perm.No) (< $Perm.No $k@44@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      26
;  :arith-conflicts         3
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               28
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              36
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             474
;  :mk-clause               40
;  :num-allocs              3647216
;  :num-checks              54
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            128865)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@30@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      13
;  :arith-assert-lower      39
;  :arith-assert-upper      26
;  :arith-conflicts         3
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               28
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              36
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             474
;  :mk-clause               40
;  :num-allocs              3647216
;  :num-checks              55
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            128876)
(assert (< $k@44@07 $k@30@07))
(assert (<= $Perm.No (- $k@30@07 $k@44@07)))
(assert (<= (- $k@30@07 $k@44@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@30@07 $k@44@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@07)))
      $Ref.null))))
; [eval] diz.Controller_m.Main_sensor != null
(push) ; 4
(assert (not (< $Perm.No $k@30@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-conflicts         3
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               29
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              36
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             477
;  :mk-clause               40
;  :num-allocs              3647216
;  :num-checks              56
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            129090)
(push) ; 4
(assert (not (< $Perm.No $k@30@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-conflicts         3
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               30
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              36
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             477
;  :mk-clause               40
;  :num-allocs              3647216
;  :num-checks              57
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            129138)
(push) ; 4
(assert (not (< $Perm.No $k@30@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-conflicts         3
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               31
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              36
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             477
;  :mk-clause               40
;  :num-allocs              3647216
;  :num-checks              58
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            129186)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-conflicts         3
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               31
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              36
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             477
;  :mk-clause               40
;  :num-allocs              3647216
;  :num-checks              59
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            129199)
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@30@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-conflicts         3
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               32
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              36
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             477
;  :mk-clause               40
;  :num-allocs              3647216
;  :num-checks              60
;  :propagations            25
;  :quant-instantiations    28
;  :rlimit-count            129247)
(declare-const $k@45@07 $Perm)
(assert ($Perm.isReadVar $k@45@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@45@07 $Perm.No) (< $Perm.No $k@45@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      28
;  :arith-conflicts         3
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               33
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              36
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             481
;  :mk-clause               42
;  :num-allocs              3647216
;  :num-checks              61
;  :propagations            26
;  :quant-instantiations    28
;  :rlimit-count            129446)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= (+ $k@20@07 $k@31@07) $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               397
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      29
;  :arith-conflicts         4
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               34
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             483
;  :mk-clause               44
;  :num-allocs              3647216
;  :num-checks              62
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            129508)
(assert (< $k@45@07 (+ $k@20@07 $k@31@07)))
(assert (<= $Perm.No (- (+ $k@20@07 $k@31@07) $k@45@07)))
(assert (<= (- (+ $k@20@07 $k@31@07) $k@45@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@20@07 $k@31@07) $k@45@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@07)))
      $Ref.null))))
; [eval] diz.Controller_m.Main_controller != null
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@07 $k@31@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               397
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      31
;  :arith-conflicts         5
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               35
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             487
;  :mk-clause               44
;  :num-allocs              3647216
;  :num-checks              63
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            129740)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@07 $k@31@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               397
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      32
;  :arith-conflicts         6
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               36
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             488
;  :mk-clause               44
;  :num-allocs              3647216
;  :num-checks              64
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            129803)
(push) ; 4
(assert (not (= diz@17@07 $t@32@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               397
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      32
;  :arith-conflicts         6
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               37
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             489
;  :mk-clause               44
;  :num-allocs              3647216
;  :num-checks              65
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            129863)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               397
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      32
;  :arith-conflicts         6
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               37
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             489
;  :mk-clause               44
;  :num-allocs              3647216
;  :num-checks              66
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            129876)
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@07 $k@31@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               397
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      33
;  :arith-conflicts         7
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               38
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             490
;  :mk-clause               44
;  :num-allocs              3647216
;  :num-checks              67
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            129939)
(push) ; 4
(assert (not (= diz@17@07 $t@32@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               397
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      33
;  :arith-conflicts         7
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               39
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   17
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              38
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             491
;  :mk-clause               44
;  :num-allocs              3647216
;  :num-checks              68
;  :propagations            27
;  :quant-instantiations    28
;  :rlimit-count            129999
;  :time                    0.00)
(push) ; 4
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               435
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      33
;  :arith-conflicts         7
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               39
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   23
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            15
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             499
;  :mk-clause               44
;  :num-allocs              3647216
;  :num-checks              69
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            130517
;  :time                    0.00)
; [eval] diz.Controller_m.Main_controller == diz
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@07 $k@31@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               435
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      34
;  :arith-conflicts         8
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               40
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   23
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            15
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             500
;  :mk-clause               44
;  :num-allocs              3647216
;  :num-checks              70
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            130580)
(set-option :timeout 0)
(push) ; 4
(assert (not (= $t@32@07 diz@17@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               435
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      34
;  :arith-conflicts         8
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   23
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            15
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             500
;  :mk-clause               44
;  :num-allocs              3647216
;  :num-checks              71
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            130632)
(assert (= $t@32@07 diz@17@07))
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               435
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      45
;  :arith-assert-upper      34
;  :arith-conflicts         8
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   23
;  :datatype-splits         30
;  :decisions               40
;  :del-clause              38
;  :final-checks            15
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             500
;  :mk-clause               44
;  :num-allocs              3647216
;  :num-checks              72
;  :propagations            28
;  :quant-instantiations    28
;  :rlimit-count            130680)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
(assert ($Perm.isReadVar $k@41@07 $Perm.Write))
(assert ($Perm.isReadVar $k@42@07 $Perm.Write))
(assert (= $t@39@07 ($Snap.combine ($Snap.first $t@39@07) ($Snap.second $t@39@07))))
(assert (=
  ($Snap.second $t@39@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@39@07))
    ($Snap.second ($Snap.second $t@39@07)))))
(assert (= ($Snap.first ($Snap.second $t@39@07)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@39@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@39@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@39@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))
  $Snap.unit))
(assert (forall ((i__20@40@07 Int)) (!
  (implies
    (and
      (<
        i__20@40@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))
      (<= 0 i__20@40@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
          i__20@40@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
            i__20@40@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
            i__20@40@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
    i__20@40@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))
(assert (<= $Perm.No $k@41@07))
(assert (<= $k@41@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@41@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))
(assert (<= $Perm.No $k@42@07))
(assert (<= $k@42@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@42@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))
  diz@17@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))))))
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))))))))))))
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
; (:added-eqs               880
;  :arith-add-rows          1
;  :arith-assert-diseq      16
;  :arith-assert-lower      53
;  :arith-assert-upper      40
;  :arith-conflicts         8
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              44
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             631
;  :mk-clause               52
;  :num-allocs              3779292
;  :num-checks              75
;  :propagations            39
;  :quant-instantiations    38
;  :rlimit-count            136379
;  :time                    0.00)
; [then-branch: 12 | True | live]
; [else-branch: 12 | False | dead]
(push) ; 5
; [then-branch: 12 | True]
; [exec]
; __flatten_12__15 := diz.Controller_m
(declare-const __flatten_12__15@46@07 $Ref)
(assert (= __flatten_12__15@46@07 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07))))
; [exec]
; __flatten_14__17 := diz.Controller_m
(declare-const __flatten_14__17@47@07 $Ref)
(assert (= __flatten_14__17@47@07 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07))))
; [exec]
; __flatten_13__16 := __flatten_14__17.Main_process_state[1 := 2]
; [eval] __flatten_14__17.Main_process_state[1 := 2]
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)) __flatten_14__17@47@07)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               882
;  :arith-add-rows          1
;  :arith-assert-diseq      16
;  :arith-assert-lower      53
;  :arith-assert-upper      40
;  :arith-conflicts         8
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              44
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             633
;  :mk-clause               52
;  :num-allocs              3779292
;  :num-checks              76
;  :propagations            39
;  :quant-instantiations    38
;  :rlimit-count            136488)
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               882
;  :arith-add-rows          1
;  :arith-assert-diseq      16
;  :arith-assert-lower      53
;  :arith-assert-upper      40
;  :arith-conflicts         8
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              44
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             633
;  :mk-clause               52
;  :num-allocs              3779292
;  :num-checks              77
;  :propagations            39
;  :quant-instantiations    38
;  :rlimit-count            136503)
(declare-const __flatten_13__16@48@07 Seq<Int>)
(assert (Seq_equal
  __flatten_13__16@48@07
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))
    1
    2)))
; [exec]
; __flatten_12__15.Main_process_state := __flatten_13__16
(set-option :timeout 10)
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)) __flatten_12__15@46@07)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               893
;  :arith-add-rows          4
;  :arith-assert-diseq      17
;  :arith-assert-lower      57
;  :arith-assert-upper      42
;  :arith-conflicts         8
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              44
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             657
;  :mk-clause               72
;  :num-allocs              3779292
;  :num-checks              78
;  :propagations            48
;  :quant-instantiations    43
;  :rlimit-count            136990)
(assert (not (= __flatten_12__15@46@07 $Ref.null)))
(push) ; 6
; Loop head block: Check well-definedness of invariant
(declare-const $t@49@07 $Snap)
(assert (= $t@49@07 ($Snap.combine ($Snap.first $t@49@07) ($Snap.second $t@49@07))))
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               899
;  :arith-add-rows          4
;  :arith-assert-diseq      17
;  :arith-assert-lower      57
;  :arith-assert-upper      42
;  :arith-conflicts         8
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              44
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             659
;  :mk-clause               72
;  :num-allocs              3779292
;  :num-checks              79
;  :propagations            48
;  :quant-instantiations    43
;  :rlimit-count            137159)
(assert (=
  ($Snap.second $t@49@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@49@07))
    ($Snap.second ($Snap.second $t@49@07)))))
(assert (= ($Snap.first ($Snap.second $t@49@07)) $Snap.unit))
; [eval] diz.Controller_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@49@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@49@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@49@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
  $Snap.unit))
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
  $Snap.unit))
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))
  $Snap.unit))
; [eval] (forall i__21: Int :: { diz.Controller_m.Main_process_state[i__21] } 0 <= i__21 && i__21 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__21] == -1 || 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|)
(declare-const i__21@50@07 Int)
(push) ; 7
; [eval] 0 <= i__21 && i__21 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__21] == -1 || 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__21 && i__21 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__21
(push) ; 8
; [then-branch: 13 | 0 <= i__21@50@07 | live]
; [else-branch: 13 | !(0 <= i__21@50@07) | live]
(push) ; 9
; [then-branch: 13 | 0 <= i__21@50@07]
(assert (<= 0 i__21@50@07))
; [eval] i__21 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 13 | !(0 <= i__21@50@07)]
(assert (not (<= 0 i__21@50@07)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 14 | i__21@50@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__21@50@07 | live]
; [else-branch: 14 | !(i__21@50@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__21@50@07) | live]
(push) ; 9
; [then-branch: 14 | i__21@50@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__21@50@07]
(assert (and
  (<
    i__21@50@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
  (<= 0 i__21@50@07)))
; [eval] diz.Controller_m.Main_process_state[i__21] == -1 || 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__21] == -1
; [eval] diz.Controller_m.Main_process_state[i__21]
(push) ; 10
(assert (not (>= i__21@50@07 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               943
;  :arith-add-rows          4
;  :arith-assert-diseq      17
;  :arith-assert-lower      62
;  :arith-assert-upper      45
;  :arith-conflicts         8
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              44
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             684
;  :mk-clause               72
;  :num-allocs              3914789
;  :num-checks              80
;  :propagations            48
;  :quant-instantiations    48
;  :rlimit-count            138438)
; [eval] -1
(push) ; 10
; [then-branch: 15 | First:(Second:(Second:(Second:($t@49@07))))[i__21@50@07] == -1 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:($t@49@07))))[i__21@50@07] != -1 | live]
(push) ; 11
; [then-branch: 15 | First:(Second:(Second:(Second:($t@49@07))))[i__21@50@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__21@50@07)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 15 | First:(Second:(Second:(Second:($t@49@07))))[i__21@50@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      i__21@50@07)
    (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__21]
; [eval] diz.Controller_m.Main_process_state[i__21]
(push) ; 12
(assert (not (>= i__21@50@07 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               943
;  :arith-add-rows          4
;  :arith-assert-diseq      17
;  :arith-assert-lower      62
;  :arith-assert-upper      45
;  :arith-conflicts         8
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              44
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             685
;  :mk-clause               72
;  :num-allocs              3914789
;  :num-checks              81
;  :propagations            48
;  :quant-instantiations    48
;  :rlimit-count            138613)
(push) ; 12
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@49@07))))[i__21@50@07] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@49@07))))[i__21@50@07]) | live]
(push) ; 13
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@49@07))))[i__21@50@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__21@50@07)))
; [eval] diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__21]
(push) ; 14
(assert (not (>= i__21@50@07 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               943
;  :arith-add-rows          4
;  :arith-assert-diseq      18
;  :arith-assert-lower      65
;  :arith-assert-upper      45
;  :arith-conflicts         8
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              44
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             688
;  :mk-clause               73
;  :num-allocs              3914789
;  :num-checks              82
;  :propagations            48
;  :quant-instantiations    48
;  :rlimit-count            138736)
; [eval] |diz.Controller_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@49@07))))[i__21@50@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      i__21@50@07))))
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
; [else-branch: 14 | !(i__21@50@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__21@50@07)]
(assert (not
  (and
    (<
      i__21@50@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
    (<= 0 i__21@50@07))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__21@50@07 Int)) (!
  (implies
    (and
      (<
        i__21@50@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
      (<= 0 i__21@50@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          i__21@50@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__21@50@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__21@50@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__21@50@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))
(declare-const $k@51@07 $Perm)
(assert ($Perm.isReadVar $k@51@07 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@51@07 $Perm.No) (< $Perm.No $k@51@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               948
;  :arith-add-rows          4
;  :arith-assert-diseq      19
;  :arith-assert-lower      67
;  :arith-assert-upper      46
;  :arith-conflicts         8
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               44
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             694
;  :mk-clause               75
;  :num-allocs              3914789
;  :num-checks              83
;  :propagations            49
;  :quant-instantiations    48
;  :rlimit-count            139504)
(assert (<= $Perm.No $k@51@07))
(assert (<= $k@51@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@51@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_sensor != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               954
;  :arith-add-rows          4
;  :arith-assert-diseq      19
;  :arith-assert-lower      67
;  :arith-assert-upper      47
;  :arith-conflicts         8
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               45
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             697
;  :mk-clause               75
;  :num-allocs              3914789
;  :num-checks              84
;  :propagations            49
;  :quant-instantiations    48
;  :rlimit-count            139827)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               960
;  :arith-add-rows          4
;  :arith-assert-diseq      19
;  :arith-assert-lower      67
;  :arith-assert-upper      47
;  :arith-conflicts         8
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               46
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             700
;  :mk-clause               75
;  :num-allocs              3914789
;  :num-checks              85
;  :propagations            49
;  :quant-instantiations    49
;  :rlimit-count            140183)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               965
;  :arith-add-rows          4
;  :arith-assert-diseq      19
;  :arith-assert-lower      67
;  :arith-assert-upper      47
;  :arith-conflicts         8
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               47
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             701
;  :mk-clause               75
;  :num-allocs              3914789
;  :num-checks              86
;  :propagations            49
;  :quant-instantiations    49
;  :rlimit-count            140440)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               970
;  :arith-add-rows          4
;  :arith-assert-diseq      19
;  :arith-assert-lower      67
;  :arith-assert-upper      47
;  :arith-conflicts         8
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               48
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             702
;  :mk-clause               75
;  :num-allocs              3914789
;  :num-checks              87
;  :propagations            49
;  :quant-instantiations    49
;  :rlimit-count            140707)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               970
;  :arith-add-rows          4
;  :arith-assert-diseq      19
;  :arith-assert-lower      67
;  :arith-assert-upper      47
;  :arith-conflicts         8
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               48
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             702
;  :mk-clause               75
;  :num-allocs              3914789
;  :num-checks              88
;  :propagations            49
;  :quant-instantiations    49
;  :rlimit-count            140720)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))
(declare-const $k@52@07 $Perm)
(assert ($Perm.isReadVar $k@52@07 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@52@07 $Perm.No) (< $Perm.No $k@52@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               975
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      48
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               49
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             707
;  :mk-clause               77
;  :num-allocs              3914789
;  :num-checks              89
;  :propagations            50
;  :quant-instantiations    49
;  :rlimit-count            141140)
(assert (<= $Perm.No $k@52@07))
(assert (<= $k@52@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@52@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_controller != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               981
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               50
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             710
;  :mk-clause               77
;  :num-allocs              3914789
;  :num-checks              90
;  :propagations            50
;  :quant-instantiations    49
;  :rlimit-count            141513)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               987
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             713
;  :mk-clause               77
;  :num-allocs              3914789
;  :num-checks              91
;  :propagations            50
;  :quant-instantiations    50
;  :rlimit-count            141923)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               992
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               52
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             714
;  :mk-clause               77
;  :num-allocs              3914789
;  :num-checks              92
;  :propagations            50
;  :quant-instantiations    50
;  :rlimit-count            142230)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               992
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               52
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             714
;  :mk-clause               77
;  :num-allocs              3914789
;  :num-checks              93
;  :propagations            50
;  :quant-instantiations    50
;  :rlimit-count            142243)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
  $Snap.unit))
; [eval] diz.Controller_m.Main_controller == diz
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               998
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             716
;  :mk-clause               77
;  :num-allocs              3914789
;  :num-checks              94
;  :propagations            50
;  :quant-instantiations    50
;  :rlimit-count            142592)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
  diz@17@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1006
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             718
;  :mk-clause               77
;  :num-allocs              3914789
;  :num-checks              95
;  :propagations            50
;  :quant-instantiations    50
;  :rlimit-count            142936)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))))
; Loop head block: Check well-definedness of edge conditions
(push) ; 7
; [eval] diz.Controller_m.Main_process_state[1] != -1 || diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_process_state[1] != -1
; [eval] diz.Controller_m.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1016
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             723
;  :mk-clause               77
;  :num-allocs              4053322
;  :num-checks              96
;  :propagations            50
;  :quant-instantiations    52
;  :rlimit-count            143358)
; [eval] -1
(push) ; 8
; [then-branch: 17 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1 | live]
; [else-branch: 17 | First:(Second:(Second:(Second:($t@49@07))))[1] == -1 | live]
(push) ; 9
; [then-branch: 17 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      1)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 17 | First:(Second:(Second:(Second:($t@49@07))))[1] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    1)
  (- 0 1)))
; [eval] diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1017
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             724
;  :mk-clause               77
;  :num-allocs              4053322
;  :num-checks              97
;  :propagations            50
;  :quant-instantiations    52
;  :rlimit-count            143520)
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
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1017
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             724
;  :mk-clause               77
;  :num-allocs              4053322
;  :num-checks              98
;  :propagations            50
;  :quant-instantiations    52
;  :rlimit-count            143540)
; [eval] -1
(push) ; 8
; [then-branch: 18 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:($t@49@07))))[1] == -1 | live]
(push) ; 9
; [then-branch: 18 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      1)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 18 | First:(Second:(Second:(Second:($t@49@07))))[1] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    1)
  (- 0 1)))
; [eval] diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1018
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              45
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             725
;  :mk-clause               77
;  :num-allocs              4053322
;  :num-checks              99
;  :propagations            50
;  :quant-instantiations    52
;  :rlimit-count            143698)
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
; (:added-eqs               1018
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              49
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             725
;  :mk-clause               77
;  :num-allocs              4053322
;  :num-checks              100
;  :propagations            50
;  :quant-instantiations    52
;  :rlimit-count            143716)
; [eval] diz.Controller_m != null
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
(push) ; 7
(assert (not (= (Seq_length __flatten_13__16@48@07) 2)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1018
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      49
;  :arith-conflicts         8
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               54
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              49
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             728
;  :mk-clause               77
;  :num-allocs              4053322
;  :num-checks              101
;  :propagations            50
;  :quant-instantiations    52
;  :rlimit-count            143790)
(assert (= (Seq_length __flatten_13__16@48@07) 2))
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
; [eval] (forall i__21: Int :: { diz.Controller_m.Main_process_state[i__21] } 0 <= i__21 && i__21 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__21] == -1 || 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|)
(declare-const i__21@53@07 Int)
(push) ; 7
; [eval] 0 <= i__21 && i__21 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__21] == -1 || 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__21 && i__21 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__21
(push) ; 8
; [then-branch: 19 | 0 <= i__21@53@07 | live]
; [else-branch: 19 | !(0 <= i__21@53@07) | live]
(push) ; 9
; [then-branch: 19 | 0 <= i__21@53@07]
(assert (<= 0 i__21@53@07))
; [eval] i__21 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 19 | !(0 <= i__21@53@07)]
(assert (not (<= 0 i__21@53@07)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 20 | i__21@53@07 < |__flatten_13__16@48@07| && 0 <= i__21@53@07 | live]
; [else-branch: 20 | !(i__21@53@07 < |__flatten_13__16@48@07| && 0 <= i__21@53@07) | live]
(push) ; 9
; [then-branch: 20 | i__21@53@07 < |__flatten_13__16@48@07| && 0 <= i__21@53@07]
(assert (and (< i__21@53@07 (Seq_length __flatten_13__16@48@07)) (<= 0 i__21@53@07)))
; [eval] diz.Controller_m.Main_process_state[i__21] == -1 || 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__21] == -1
; [eval] diz.Controller_m.Main_process_state[i__21]
(push) ; 10
(assert (not (>= i__21@53@07 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1019
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      71
;  :arith-assert-upper      51
;  :arith-conflicts         8
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               54
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              49
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             733
;  :mk-clause               77
;  :num-allocs              4053322
;  :num-checks              102
;  :propagations            50
;  :quant-instantiations    52
;  :rlimit-count            143977)
; [eval] -1
(push) ; 10
; [then-branch: 21 | __flatten_13__16@48@07[i__21@53@07] == -1 | live]
; [else-branch: 21 | __flatten_13__16@48@07[i__21@53@07] != -1 | live]
(push) ; 11
; [then-branch: 21 | __flatten_13__16@48@07[i__21@53@07] == -1]
(assert (= (Seq_index __flatten_13__16@48@07 i__21@53@07) (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 21 | __flatten_13__16@48@07[i__21@53@07] != -1]
(assert (not (= (Seq_index __flatten_13__16@48@07 i__21@53@07) (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__21]
; [eval] diz.Controller_m.Main_process_state[i__21]
(push) ; 12
(assert (not (>= i__21@53@07 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1020
;  :arith-add-rows          4
;  :arith-assert-diseq      20
;  :arith-assert-lower      71
;  :arith-assert-upper      52
;  :arith-conflicts         8
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               54
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              49
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             741
;  :mk-clause               87
;  :num-allocs              4053322
;  :num-checks              103
;  :propagations            50
;  :quant-instantiations    53
;  :rlimit-count            144145)
(push) ; 12
; [then-branch: 22 | 0 <= __flatten_13__16@48@07[i__21@53@07] | live]
; [else-branch: 22 | !(0 <= __flatten_13__16@48@07[i__21@53@07]) | live]
(push) ; 13
; [then-branch: 22 | 0 <= __flatten_13__16@48@07[i__21@53@07]]
(assert (<= 0 (Seq_index __flatten_13__16@48@07 i__21@53@07)))
; [eval] diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__21]
(push) ; 14
(assert (not (>= i__21@53@07 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1020
;  :arith-add-rows          4
;  :arith-assert-diseq      21
;  :arith-assert-lower      74
;  :arith-assert-upper      52
;  :arith-conflicts         8
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         9
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               54
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               133
;  :del-clause              49
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             744
;  :mk-clause               88
;  :num-allocs              4053322
;  :num-checks              104
;  :propagations            50
;  :quant-instantiations    53
;  :rlimit-count            144219)
; [eval] |diz.Controller_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 22 | !(0 <= __flatten_13__16@48@07[i__21@53@07])]
(assert (not (<= 0 (Seq_index __flatten_13__16@48@07 i__21@53@07))))
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
; [else-branch: 20 | !(i__21@53@07 < |__flatten_13__16@48@07| && 0 <= i__21@53@07)]
(assert (not
  (and (< i__21@53@07 (Seq_length __flatten_13__16@48@07)) (<= 0 i__21@53@07))))
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
(assert (not (forall ((i__21@53@07 Int)) (!
  (implies
    (and (< i__21@53@07 (Seq_length __flatten_13__16@48@07)) (<= 0 i__21@53@07))
    (or
      (= (Seq_index __flatten_13__16@48@07 i__21@53@07) (- 0 1))
      (and
        (<
          (Seq_index __flatten_13__16@48@07 i__21@53@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))
        (<= 0 (Seq_index __flatten_13__16@48@07 i__21@53@07)))))
  :pattern ((Seq_index __flatten_13__16@48@07 i__21@53@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      26
;  :arith-assert-lower      88
;  :arith-assert-upper      64
;  :arith-conflicts         10
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         13
;  :arith-pivots            8
;  :binary-propagations     11
;  :conflicts               61
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             782
;  :mk-clause               133
;  :num-allocs              4053322
;  :num-checks              105
;  :propagations            81
;  :quant-instantiations    56
;  :rlimit-count            144874
;  :time                    0.00)
(assert (forall ((i__21@53@07 Int)) (!
  (implies
    (and (< i__21@53@07 (Seq_length __flatten_13__16@48@07)) (<= 0 i__21@53@07))
    (or
      (= (Seq_index __flatten_13__16@48@07 i__21@53@07) (- 0 1))
      (and
        (<
          (Seq_index __flatten_13__16@48@07 i__21@53@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@39@07)))))))))
        (<= 0 (Seq_index __flatten_13__16@48@07 i__21@53@07)))))
  :pattern ((Seq_index __flatten_13__16@48@07 i__21@53@07))
  :qid |prog.l<no position>|)))
(declare-const $k@54@07 $Perm)
(assert ($Perm.isReadVar $k@54@07 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@54@07 $Perm.No) (< $Perm.No $k@54@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      90
;  :arith-assert-upper      65
;  :arith-conflicts         10
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         13
;  :arith-pivots            8
;  :binary-propagations     11
;  :conflicts               62
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             787
;  :mk-clause               135
;  :num-allocs              4053322
;  :num-checks              106
;  :propagations            82
;  :quant-instantiations    56
;  :rlimit-count            145344)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@41@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      90
;  :arith-assert-upper      65
;  :arith-conflicts         10
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         13
;  :arith-pivots            8
;  :binary-propagations     11
;  :conflicts               62
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             787
;  :mk-clause               135
;  :num-allocs              4053322
;  :num-checks              107
;  :propagations            82
;  :quant-instantiations    56
;  :rlimit-count            145355)
(assert (< $k@54@07 $k@41@07))
(assert (<= $Perm.No (- $k@41@07 $k@54@07)))
(assert (<= (- $k@41@07 $k@54@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@41@07 $k@54@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)) $Ref.null))))
; [eval] diz.Controller_m.Main_sensor != null
(push) ; 7
(assert (not (< $Perm.No $k@41@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      66
;  :arith-conflicts         10
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         13
;  :arith-pivots            10
;  :binary-propagations     11
;  :conflicts               63
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             790
;  :mk-clause               135
;  :num-allocs              4053322
;  :num-checks              108
;  :propagations            82
;  :quant-instantiations    56
;  :rlimit-count            145575)
(push) ; 7
(assert (not (< $Perm.No $k@41@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      66
;  :arith-conflicts         10
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         13
;  :arith-pivots            10
;  :binary-propagations     11
;  :conflicts               64
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             790
;  :mk-clause               135
;  :num-allocs              4053322
;  :num-checks              109
;  :propagations            82
;  :quant-instantiations    56
;  :rlimit-count            145623)
(push) ; 7
(assert (not (< $Perm.No $k@41@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      66
;  :arith-conflicts         10
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         13
;  :arith-pivots            10
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             790
;  :mk-clause               135
;  :num-allocs              4053322
;  :num-checks              110
;  :propagations            82
;  :quant-instantiations    56
;  :rlimit-count            145671)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      66
;  :arith-conflicts         10
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         13
;  :arith-pivots            10
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             790
;  :mk-clause               135
;  :num-allocs              4053322
;  :num-checks              111
;  :propagations            82
;  :quant-instantiations    56
;  :rlimit-count            145684)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@41@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      66
;  :arith-conflicts         10
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         13
;  :arith-pivots            10
;  :binary-propagations     11
;  :conflicts               66
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             790
;  :mk-clause               135
;  :num-allocs              4053322
;  :num-checks              112
;  :propagations            82
;  :quant-instantiations    56
;  :rlimit-count            145732)
(declare-const $k@55@07 $Perm)
(assert ($Perm.isReadVar $k@55@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@55@07 $Perm.No) (< $Perm.No $k@55@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      28
;  :arith-assert-lower      94
;  :arith-assert-upper      67
;  :arith-conflicts         10
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         13
;  :arith-pivots            10
;  :binary-propagations     11
;  :conflicts               67
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             794
;  :mk-clause               137
;  :num-allocs              4053322
;  :num-checks              113
;  :propagations            83
;  :quant-instantiations    56
;  :rlimit-count            145931)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@42@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      28
;  :arith-assert-lower      94
;  :arith-assert-upper      67
;  :arith-conflicts         10
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         13
;  :arith-pivots            10
;  :binary-propagations     11
;  :conflicts               67
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             794
;  :mk-clause               137
;  :num-allocs              4053322
;  :num-checks              114
;  :propagations            83
;  :quant-instantiations    56
;  :rlimit-count            145942)
(assert (< $k@55@07 $k@42@07))
(assert (<= $Perm.No (- $k@42@07 $k@55@07)))
(assert (<= (- $k@42@07 $k@55@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@42@07 $k@55@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)) $Ref.null))))
; [eval] diz.Controller_m.Main_controller != null
(push) ; 7
(assert (not (< $Perm.No $k@42@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      28
;  :arith-assert-lower      96
;  :arith-assert-upper      68
;  :arith-conflicts         10
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         13
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               68
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             797
;  :mk-clause               137
;  :num-allocs              4053322
;  :num-checks              115
;  :propagations            83
;  :quant-instantiations    56
;  :rlimit-count            146156)
(push) ; 7
(assert (not (< $Perm.No $k@42@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      28
;  :arith-assert-lower      96
;  :arith-assert-upper      68
;  :arith-conflicts         10
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         13
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               69
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             797
;  :mk-clause               137
;  :num-allocs              4053322
;  :num-checks              116
;  :propagations            83
;  :quant-instantiations    56
;  :rlimit-count            146204)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      28
;  :arith-assert-lower      96
;  :arith-assert-upper      68
;  :arith-conflicts         10
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         13
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               69
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             797
;  :mk-clause               137
;  :num-allocs              4053322
;  :num-checks              117
;  :propagations            83
;  :quant-instantiations    56
;  :rlimit-count            146217)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@42@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1041
;  :arith-add-rows          4
;  :arith-assert-diseq      28
;  :arith-assert-lower      96
;  :arith-assert-upper      68
;  :arith-conflicts         10
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         13
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               70
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   50
;  :datatype-splits         99
;  :decisions               139
;  :del-clause              105
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             797
;  :mk-clause               137
;  :num-allocs              4053322
;  :num-checks              118
;  :propagations            83
;  :quant-instantiations    56
;  :rlimit-count            146265)
(push) ; 7
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1121
;  :arith-add-rows          4
;  :arith-assert-diseq      28
;  :arith-assert-lower      96
;  :arith-assert-upper      68
;  :arith-conflicts         10
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         13
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               70
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 176
;  :datatype-occurs-check   59
;  :datatype-splits         122
;  :decisions               162
;  :del-clause              105
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             819
;  :mk-clause               137
;  :num-allocs              4053322
;  :num-checks              119
;  :propagations            86
;  :quant-instantiations    56
;  :rlimit-count            147015
;  :time                    0.00)
; [eval] diz.Controller_m.Main_controller == diz
(push) ; 7
(assert (not (< $Perm.No $k@42@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1121
;  :arith-add-rows          4
;  :arith-assert-diseq      28
;  :arith-assert-lower      96
;  :arith-assert-upper      68
;  :arith-conflicts         10
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         13
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 176
;  :datatype-occurs-check   59
;  :datatype-splits         122
;  :decisions               162
;  :del-clause              105
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             819
;  :mk-clause               137
;  :num-allocs              4053322
;  :num-checks              120
;  :propagations            86
;  :quant-instantiations    56
;  :rlimit-count            147063)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1121
;  :arith-add-rows          4
;  :arith-assert-diseq      28
;  :arith-assert-lower      96
;  :arith-assert-upper      68
;  :arith-conflicts         10
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         13
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 176
;  :datatype-occurs-check   59
;  :datatype-splits         122
;  :decisions               162
;  :del-clause              105
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             819
;  :mk-clause               137
;  :num-allocs              4053322
;  :num-checks              121
;  :propagations            86
;  :quant-instantiations    56
;  :rlimit-count            147076)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 7
(assert ($Perm.isReadVar $k@51@07 $Perm.Write))
(assert ($Perm.isReadVar $k@52@07 $Perm.Write))
(assert (= $t@49@07 ($Snap.combine ($Snap.first $t@49@07) ($Snap.second $t@49@07))))
(assert (=
  ($Snap.second $t@49@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@49@07))
    ($Snap.second ($Snap.second $t@49@07)))))
(assert (= ($Snap.first ($Snap.second $t@49@07)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@49@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@49@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@49@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))
  $Snap.unit))
(assert (forall ((i__21@50@07 Int)) (!
  (implies
    (and
      (<
        i__21@50@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
      (<= 0 i__21@50@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          i__21@50@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__21@50@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__21@50@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__21@50@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))
(assert (<= $Perm.No $k@51@07))
(assert (<= $k@51@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@51@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))
(assert (<= $Perm.No $k@52@07))
(assert (<= $k@52@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@52@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
  diz@17@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))))))
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))))
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
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1550
;  :arith-add-rows          4
;  :arith-assert-diseq      30
;  :arith-assert-lower      104
;  :arith-assert-upper      74
;  :arith-conflicts         10
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         13
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               72
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 267
;  :datatype-occurs-check   81
;  :datatype-splits         190
;  :decisions               245
;  :del-clause              111
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             945
;  :mk-clause               144
;  :num-allocs              4197390
;  :num-checks              124
;  :propagations            95
;  :quant-instantiations    65
;  :rlimit-count            152370)
; [eval] -1
(push) ; 8
; [then-branch: 23 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1 | live]
; [else-branch: 23 | First:(Second:(Second:(Second:($t@49@07))))[1] == -1 | live]
(push) ; 9
; [then-branch: 23 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      1)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 23 | First:(Second:(Second:(Second:($t@49@07))))[1] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    1)
  (- 0 1)))
; [eval] diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1551
;  :arith-add-rows          4
;  :arith-assert-diseq      30
;  :arith-assert-lower      104
;  :arith-assert-upper      74
;  :arith-conflicts         10
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         13
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               72
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 267
;  :datatype-occurs-check   81
;  :datatype-splits         190
;  :decisions               245
;  :del-clause              111
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             946
;  :mk-clause               144
;  :num-allocs              4197390
;  :num-checks              125
;  :propagations            95
;  :quant-instantiations    65
;  :rlimit-count            152528)
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
          2)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1687
;  :arith-add-rows          5
;  :arith-assert-diseq      33
;  :arith-assert-lower      115
;  :arith-assert-upper      79
;  :arith-conflicts         10
;  :arith-eq-adapter        55
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               72
;  :datatype-accessor-ax    134
;  :datatype-constructor-ax 304
;  :datatype-occurs-check   92
;  :datatype-splits         224
;  :decisions               279
;  :del-clause              129
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1004
;  :mk-clause               162
;  :num-allocs              4197390
;  :num-checks              126
;  :propagations            107
;  :quant-instantiations    69
;  :rlimit-count            153972
;  :time                    0.00)
(push) ; 8
(assert (not (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
        2)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      33
;  :arith-assert-lower      115
;  :arith-assert-upper      79
;  :arith-conflicts         10
;  :arith-eq-adapter        55
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               72
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              129
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1039
;  :mk-clause               162
;  :num-allocs              4197390
;  :num-checks              127
;  :propagations            111
;  :quant-instantiations    69
;  :rlimit-count            155123
;  :time                    0.00)
; [then-branch: 24 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))[2] != -2 | live]
; [else-branch: 24 | !(First:(Second:(Second:(Second:($t@49@07))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))[2] != -2) | live]
(push) ; 8
; [then-branch: 24 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))[2] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
        2)
      (- 0 2)))))
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz.Controller_m, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@56@07 Int)
(push) ; 9
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 10
; [then-branch: 25 | 0 <= i@56@07 | live]
; [else-branch: 25 | !(0 <= i@56@07) | live]
(push) ; 11
; [then-branch: 25 | 0 <= i@56@07]
(assert (<= 0 i@56@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 25 | !(0 <= i@56@07)]
(assert (not (<= 0 i@56@07)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 26 | i@56@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i@56@07 | live]
; [else-branch: 26 | !(i@56@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i@56@07) | live]
(push) ; 11
; [then-branch: 26 | i@56@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i@56@07]
(assert (and
  (<
    i@56@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
  (<= 0 i@56@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i@56@07 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      33
;  :arith-assert-lower      116
;  :arith-assert-upper      80
;  :arith-conflicts         10
;  :arith-eq-adapter        55
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               72
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              129
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1043
;  :mk-clause               163
;  :num-allocs              4197390
;  :num-checks              128
;  :propagations            111
;  :quant-instantiations    69
;  :rlimit-count            155489)
; [eval] -1
(push) ; 12
; [then-branch: 27 | First:(Second:(Second:(Second:($t@49@07))))[i@56@07] == -1 | live]
; [else-branch: 27 | First:(Second:(Second:(Second:($t@49@07))))[i@56@07] != -1 | live]
(push) ; 13
; [then-branch: 27 | First:(Second:(Second:(Second:($t@49@07))))[i@56@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i@56@07)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 27 | First:(Second:(Second:(Second:($t@49@07))))[i@56@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      i@56@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@56@07 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      34
;  :arith-assert-lower      119
;  :arith-assert-upper      81
;  :arith-conflicts         10
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               72
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              129
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1049
;  :mk-clause               167
;  :num-allocs              4197390
;  :num-checks              129
;  :propagations            113
;  :quant-instantiations    70
;  :rlimit-count            155721)
(push) ; 14
; [then-branch: 28 | 0 <= First:(Second:(Second:(Second:($t@49@07))))[i@56@07] | live]
; [else-branch: 28 | !(0 <= First:(Second:(Second:(Second:($t@49@07))))[i@56@07]) | live]
(push) ; 15
; [then-branch: 28 | 0 <= First:(Second:(Second:(Second:($t@49@07))))[i@56@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i@56@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 16
(assert (not (>= i@56@07 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      34
;  :arith-assert-lower      119
;  :arith-assert-upper      81
;  :arith-conflicts         10
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               72
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              129
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1049
;  :mk-clause               167
;  :num-allocs              4197390
;  :num-checks              130
;  :propagations            113
;  :quant-instantiations    70
;  :rlimit-count            155835)
; [eval] |diz.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 28 | !(0 <= First:(Second:(Second:(Second:($t@49@07))))[i@56@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      i@56@07))))
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
; [else-branch: 26 | !(i@56@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i@56@07)]
(assert (not
  (and
    (<
      i@56@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
    (<= 0 i@56@07))))
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
(assert (not (forall ((i@56@07 Int)) (!
  (implies
    (and
      (<
        i@56@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
      (<= 0 i@56@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          i@56@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i@56@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i@56@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i@56@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      36
;  :arith-assert-lower      120
;  :arith-assert-upper      82
;  :arith-conflicts         10
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               73
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1057
;  :mk-clause               181
;  :num-allocs              4197390
;  :num-checks              131
;  :propagations            115
;  :quant-instantiations    71
;  :rlimit-count            156281)
(assert (forall ((i@56@07 Int)) (!
  (implies
    (and
      (<
        i@56@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
      (<= 0 i@56@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          i@56@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i@56@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i@56@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i@56@07))
  :qid |prog.l<no position>|)))
(declare-const $k@57@07 $Perm)
(assert ($Perm.isReadVar $k@57@07 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@57@07 $Perm.No) (< $Perm.No $k@57@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      37
;  :arith-assert-lower      122
;  :arith-assert-upper      83
;  :arith-conflicts         10
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               74
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1062
;  :mk-clause               183
;  :num-allocs              4197390
;  :num-checks              132
;  :propagations            116
;  :quant-instantiations    71
;  :rlimit-count            156842)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@51@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      37
;  :arith-assert-lower      122
;  :arith-assert-upper      83
;  :arith-conflicts         10
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               74
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1062
;  :mk-clause               183
;  :num-allocs              4197390
;  :num-checks              133
;  :propagations            116
;  :quant-instantiations    71
;  :rlimit-count            156853)
(assert (< $k@57@07 $k@51@07))
(assert (<= $Perm.No (- $k@51@07 $k@57@07)))
(assert (<= (- $k@51@07 $k@57@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@51@07 $k@57@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
; [eval] diz.Main_sensor != null
(push) ; 9
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      37
;  :arith-assert-lower      124
;  :arith-assert-upper      84
;  :arith-conflicts         10
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               75
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1065
;  :mk-clause               183
;  :num-allocs              4197390
;  :num-checks              134
;  :propagations            116
;  :quant-instantiations    71
;  :rlimit-count            157061)
(push) ; 9
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      37
;  :arith-assert-lower      124
;  :arith-assert-upper      84
;  :arith-conflicts         10
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               76
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1065
;  :mk-clause               183
;  :num-allocs              4197390
;  :num-checks              135
;  :propagations            116
;  :quant-instantiations    71
;  :rlimit-count            157109)
(push) ; 9
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      37
;  :arith-assert-lower      124
;  :arith-assert-upper      84
;  :arith-conflicts         10
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               77
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1065
;  :mk-clause               183
;  :num-allocs              4197390
;  :num-checks              136
;  :propagations            116
;  :quant-instantiations    71
;  :rlimit-count            157157)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      37
;  :arith-assert-lower      124
;  :arith-assert-upper      84
;  :arith-conflicts         10
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               77
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1065
;  :mk-clause               183
;  :num-allocs              4197390
;  :num-checks              137
;  :propagations            116
;  :quant-instantiations    71
;  :rlimit-count            157170)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      37
;  :arith-assert-lower      124
;  :arith-assert-upper      84
;  :arith-conflicts         10
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               78
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1065
;  :mk-clause               183
;  :num-allocs              4197390
;  :num-checks              138
;  :propagations            116
;  :quant-instantiations    71
;  :rlimit-count            157218)
(declare-const $k@58@07 $Perm)
(assert ($Perm.isReadVar $k@58@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@58@07 $Perm.No) (< $Perm.No $k@58@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      38
;  :arith-assert-lower      126
;  :arith-assert-upper      85
;  :arith-conflicts         10
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               79
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1069
;  :mk-clause               185
;  :num-allocs              4197390
;  :num-checks              139
;  :propagations            117
;  :quant-instantiations    71
;  :rlimit-count            157416)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@52@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      38
;  :arith-assert-lower      126
;  :arith-assert-upper      85
;  :arith-conflicts         10
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         15
;  :arith-pivots            15
;  :binary-propagations     11
;  :conflicts               79
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1069
;  :mk-clause               185
;  :num-allocs              4197390
;  :num-checks              140
;  :propagations            117
;  :quant-instantiations    71
;  :rlimit-count            157427)
(assert (< $k@58@07 $k@52@07))
(assert (<= $Perm.No (- $k@52@07 $k@58@07)))
(assert (<= (- $k@52@07 $k@58@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@52@07 $k@58@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
; [eval] diz.Main_controller != null
(push) ; 9
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      38
;  :arith-assert-lower      128
;  :arith-assert-upper      86
;  :arith-conflicts         10
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         15
;  :arith-pivots            17
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1072
;  :mk-clause               185
;  :num-allocs              4197390
;  :num-checks              141
;  :propagations            117
;  :quant-instantiations    71
;  :rlimit-count            157647)
(push) ; 9
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      38
;  :arith-assert-lower      128
;  :arith-assert-upper      86
;  :arith-conflicts         10
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         15
;  :arith-pivots            17
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1072
;  :mk-clause               185
;  :num-allocs              4197390
;  :num-checks              142
;  :propagations            117
;  :quant-instantiations    71
;  :rlimit-count            157695)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      38
;  :arith-assert-lower      128
;  :arith-assert-upper      86
;  :arith-conflicts         10
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         15
;  :arith-pivots            17
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1072
;  :mk-clause               185
;  :num-allocs              4197390
;  :num-checks              143
;  :propagations            117
;  :quant-instantiations    71
;  :rlimit-count            157708)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1817
;  :arith-add-rows          5
;  :arith-assert-diseq      38
;  :arith-assert-lower      128
;  :arith-assert-upper      86
;  :arith-conflicts         10
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         15
;  :arith-pivots            17
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 341
;  :datatype-occurs-check   103
;  :datatype-splits         258
;  :decisions               312
;  :del-clause              147
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1072
;  :mk-clause               185
;  :num-allocs              4197390
;  :num-checks              144
;  :propagations            117
;  :quant-instantiations    71
;  :rlimit-count            157756)
(push) ; 9
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1953
;  :arith-add-rows          6
;  :arith-assert-diseq      41
;  :arith-assert-lower      139
;  :arith-assert-upper      91
;  :arith-conflicts         10
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         17
;  :arith-pivots            21
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    142
;  :datatype-constructor-ax 378
;  :datatype-occurs-check   114
;  :datatype-splits         292
;  :decisions               346
;  :del-clause              164
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1128
;  :mk-clause               202
;  :num-allocs              4197390
;  :num-checks              145
;  :propagations            129
;  :quant-instantiations    76
;  :rlimit-count            158967
;  :time                    0.00)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))))))))))))))))) ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) globals@18@07))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
(declare-const $t@59@07 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Controller_m, globals), write)
(assert (= $t@59@07 ($Snap.combine ($Snap.first $t@59@07) ($Snap.second $t@59@07))))
(assert (= ($Snap.first $t@59@07) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@59@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@59@07))
    ($Snap.second ($Snap.second $t@59@07)))))
(assert (= ($Snap.first ($Snap.second $t@59@07)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@59@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@59@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@59@07))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@59@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@60@07 Int)
(push) ; 9
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 10
; [then-branch: 29 | 0 <= i@60@07 | live]
; [else-branch: 29 | !(0 <= i@60@07) | live]
(push) ; 11
; [then-branch: 29 | 0 <= i@60@07]
(assert (<= 0 i@60@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 29 | !(0 <= i@60@07)]
(assert (not (<= 0 i@60@07)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 30 | i@60@07 < |First:(Second:(Second:(Second:($t@59@07))))| && 0 <= i@60@07 | live]
; [else-branch: 30 | !(i@60@07 < |First:(Second:(Second:(Second:($t@59@07))))| && 0 <= i@60@07) | live]
(push) ; 11
; [then-branch: 30 | i@60@07 < |First:(Second:(Second:(Second:($t@59@07))))| && 0 <= i@60@07]
(assert (and
  (<
    i@60@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
  (<= 0 i@60@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i@60@07 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2180
;  :arith-add-rows          8
;  :arith-assert-diseq      44
;  :arith-assert-lower      155
;  :arith-assert-upper      99
;  :arith-conflicts         10
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         19
;  :arith-pivots            25
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              185
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1211
;  :mk-clause               219
;  :num-allocs              4197390
;  :num-checks              147
;  :propagations            141
;  :quant-instantiations    85
;  :rlimit-count            162131)
; [eval] -1
(push) ; 12
; [then-branch: 31 | First:(Second:(Second:(Second:($t@59@07))))[i@60@07] == -1 | live]
; [else-branch: 31 | First:(Second:(Second:(Second:($t@59@07))))[i@60@07] != -1 | live]
(push) ; 13
; [then-branch: 31 | First:(Second:(Second:(Second:($t@59@07))))[i@60@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
    i@60@07)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 31 | First:(Second:(Second:(Second:($t@59@07))))[i@60@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
      i@60@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@60@07 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2180
;  :arith-add-rows          8
;  :arith-assert-diseq      44
;  :arith-assert-lower      155
;  :arith-assert-upper      99
;  :arith-conflicts         10
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         19
;  :arith-pivots            25
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              185
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1212
;  :mk-clause               219
;  :num-allocs              4197390
;  :num-checks              148
;  :propagations            141
;  :quant-instantiations    85
;  :rlimit-count            162306)
(push) ; 14
; [then-branch: 32 | 0 <= First:(Second:(Second:(Second:($t@59@07))))[i@60@07] | live]
; [else-branch: 32 | !(0 <= First:(Second:(Second:(Second:($t@59@07))))[i@60@07]) | live]
(push) ; 15
; [then-branch: 32 | 0 <= First:(Second:(Second:(Second:($t@59@07))))[i@60@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
    i@60@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 16
(assert (not (>= i@60@07 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2180
;  :arith-add-rows          8
;  :arith-assert-diseq      45
;  :arith-assert-lower      158
;  :arith-assert-upper      99
;  :arith-conflicts         10
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         19
;  :arith-pivots            25
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              185
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1215
;  :mk-clause               220
;  :num-allocs              4197390
;  :num-checks              149
;  :propagations            141
;  :quant-instantiations    85
;  :rlimit-count            162429)
; [eval] |diz.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 32 | !(0 <= First:(Second:(Second:(Second:($t@59@07))))[i@60@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
      i@60@07))))
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
; [else-branch: 30 | !(i@60@07 < |First:(Second:(Second:(Second:($t@59@07))))| && 0 <= i@60@07)]
(assert (not
  (and
    (<
      i@60@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
    (<= 0 i@60@07))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@60@07 Int)) (!
  (implies
    (and
      (<
        i@60@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
      (<= 0 i@60@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
          i@60@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
            i@60@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
            i@60@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
    i@60@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))
(declare-const $k@61@07 $Perm)
(assert ($Perm.isReadVar $k@61@07 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@61@07 $Perm.No) (< $Perm.No $k@61@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2185
;  :arith-add-rows          8
;  :arith-assert-diseq      46
;  :arith-assert-lower      160
;  :arith-assert-upper      100
;  :arith-conflicts         10
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         19
;  :arith-pivots            25
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1221
;  :mk-clause               222
;  :num-allocs              4197390
;  :num-checks              150
;  :propagations            142
;  :quant-instantiations    85
;  :rlimit-count            163198)
(declare-const $t@62@07 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@51@07 $k@57@07))
    (=
      $t@62@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))
  (implies
    (< $Perm.No $k@61@07)
    (=
      $t@62@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))
(assert (<= $Perm.No (+ (- $k@51@07 $k@57@07) $k@61@07)))
(assert (<= (+ (- $k@51@07 $k@57@07) $k@61@07) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@51@07 $k@57@07) $k@61@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))
  $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@51@07 $k@57@07) $k@61@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2195
;  :arith-add-rows          9
;  :arith-assert-diseq      46
;  :arith-assert-lower      161
;  :arith-assert-upper      102
;  :arith-conflicts         11
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         20
;  :arith-pivots            27
;  :binary-propagations     11
;  :conflicts               84
;  :datatype-accessor-ax    172
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1229
;  :mk-clause               222
;  :num-allocs              4197390
;  :num-checks              151
;  :propagations            142
;  :quant-instantiations    86
;  :rlimit-count            163906)
(assert (not (= $t@62@07 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@51@07 $k@57@07) $k@61@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2201
;  :arith-add-rows          9
;  :arith-assert-diseq      46
;  :arith-assert-lower      161
;  :arith-assert-upper      103
;  :arith-conflicts         12
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         21
;  :arith-pivots            28
;  :binary-propagations     11
;  :conflicts               85
;  :datatype-accessor-ax    173
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1232
;  :mk-clause               222
;  :num-allocs              4197390
;  :num-checks              152
;  :propagations            142
;  :quant-instantiations    86
;  :rlimit-count            164238)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@51@07 $k@57@07) $k@61@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2206
;  :arith-add-rows          9
;  :arith-assert-diseq      46
;  :arith-assert-lower      161
;  :arith-assert-upper      104
;  :arith-conflicts         13
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         22
;  :arith-pivots            29
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1234
;  :mk-clause               222
;  :num-allocs              4197390
;  :num-checks              153
;  :propagations            142
;  :quant-instantiations    86
;  :rlimit-count            164535)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@51@07 $k@57@07) $k@61@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2211
;  :arith-add-rows          9
;  :arith-assert-diseq      46
;  :arith-assert-lower      161
;  :arith-assert-upper      105
;  :arith-conflicts         14
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         23
;  :arith-pivots            30
;  :binary-propagations     11
;  :conflicts               87
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1236
;  :mk-clause               222
;  :num-allocs              4197390
;  :num-checks              154
;  :propagations            142
;  :quant-instantiations    86
;  :rlimit-count            164842)
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
;  :arith-add-rows          9
;  :arith-assert-diseq      46
;  :arith-assert-lower      161
;  :arith-assert-upper      105
;  :arith-conflicts         14
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         23
;  :arith-pivots            30
;  :binary-propagations     11
;  :conflicts               87
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1236
;  :mk-clause               222
;  :num-allocs              4197390
;  :num-checks              155
;  :propagations            142
;  :quant-instantiations    86
;  :rlimit-count            164855)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))))
(declare-const $k@63@07 $Perm)
(assert ($Perm.isReadVar $k@63@07 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@63@07 $Perm.No) (< $Perm.No $k@63@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2216
;  :arith-add-rows          9
;  :arith-assert-diseq      47
;  :arith-assert-lower      163
;  :arith-assert-upper      106
;  :arith-conflicts         14
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         23
;  :arith-pivots            30
;  :binary-propagations     11
;  :conflicts               88
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1241
;  :mk-clause               224
;  :num-allocs              4197390
;  :num-checks              156
;  :propagations            143
;  :quant-instantiations    86
;  :rlimit-count            165275)
(declare-const $t@64@07 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@52@07 $k@58@07))
    (=
      $t@64@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))))
  (implies
    (< $Perm.No $k@63@07)
    (=
      $t@64@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@52@07 $k@58@07) $k@63@07)))
(assert (<= (+ (- $k@52@07 $k@58@07) $k@63@07) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@52@07 $k@58@07) $k@63@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@52@07 $k@58@07) $k@63@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2226
;  :arith-add-rows          10
;  :arith-assert-diseq      47
;  :arith-assert-lower      164
;  :arith-assert-upper      108
;  :arith-conflicts         15
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         24
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               89
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1249
;  :mk-clause               224
;  :num-allocs              4197390
;  :num-checks              157
;  :propagations            143
;  :quant-instantiations    87
;  :rlimit-count            165921)
(assert (not (= $t@64@07 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@52@07 $k@58@07) $k@63@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2231
;  :arith-add-rows          10
;  :arith-assert-diseq      47
;  :arith-assert-lower      164
;  :arith-assert-upper      109
;  :arith-conflicts         16
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         25
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               90
;  :datatype-accessor-ax    178
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1251
;  :mk-clause               224
;  :num-allocs              4197390
;  :num-checks              158
;  :propagations            143
;  :quant-instantiations    87
;  :rlimit-count            166268)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@52@07 $k@58@07) $k@63@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2231
;  :arith-add-rows          10
;  :arith-assert-diseq      47
;  :arith-assert-lower      164
;  :arith-assert-upper      110
;  :arith-conflicts         17
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         26
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    178
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1252
;  :mk-clause               224
;  :num-allocs              4197390
;  :num-checks              159
;  :propagations            143
;  :quant-instantiations    87
;  :rlimit-count            166348)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2231
;  :arith-add-rows          10
;  :arith-assert-diseq      47
;  :arith-assert-lower      164
;  :arith-assert-upper      110
;  :arith-conflicts         17
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         26
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    178
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1252
;  :mk-clause               224
;  :num-allocs              4197390
;  :num-checks              160
;  :propagations            143
;  :quant-instantiations    87
;  :rlimit-count            166361)
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
  $t@64@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2231
;  :arith-add-rows          10
;  :arith-assert-diseq      47
;  :arith-assert-lower      164
;  :arith-assert-upper      110
;  :arith-conflicts         17
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         26
;  :arith-pivots            31
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    178
;  :datatype-constructor-ax 415
;  :datatype-occurs-check   164
;  :datatype-splits         326
;  :decisions               380
;  :del-clause              186
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1252
;  :mk-clause               224
;  :num-allocs              4197390
;  :num-checks              161
;  :propagations            143
;  :quant-instantiations    87
;  :rlimit-count            166372)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@59@07 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) globals@18@07))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Controller_m, globals), write)
(declare-const $t@65@07 $Snap)
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
; (:added-eqs               2698
;  :arith-add-rows          16
;  :arith-assert-diseq      58
;  :arith-assert-lower      206
;  :arith-assert-upper      130
;  :arith-conflicts         17
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         35
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              255
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1430
;  :mk-clause               290
;  :num-allocs              4352881
;  :num-checks              164
;  :propagations            183
;  :quant-instantiations    104
;  :rlimit-count            170070)
; [eval] diz.Controller_m != null
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
; [eval] (forall i__21: Int :: { diz.Controller_m.Main_process_state[i__21] } 0 <= i__21 && i__21 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__21] == -1 || 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|)
(declare-const i__21@66@07 Int)
(push) ; 9
; [eval] 0 <= i__21 && i__21 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__21] == -1 || 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__21 && i__21 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__21
(push) ; 10
; [then-branch: 33 | 0 <= i__21@66@07 | live]
; [else-branch: 33 | !(0 <= i__21@66@07) | live]
(push) ; 11
; [then-branch: 33 | 0 <= i__21@66@07]
(assert (<= 0 i__21@66@07))
; [eval] i__21 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 33 | !(0 <= i__21@66@07)]
(assert (not (<= 0 i__21@66@07)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 34 | i__21@66@07 < |First:(Second:(Second:(Second:($t@59@07))))| && 0 <= i__21@66@07 | live]
; [else-branch: 34 | !(i__21@66@07 < |First:(Second:(Second:(Second:($t@59@07))))| && 0 <= i__21@66@07) | live]
(push) ; 11
; [then-branch: 34 | i__21@66@07 < |First:(Second:(Second:(Second:($t@59@07))))| && 0 <= i__21@66@07]
(assert (and
  (<
    i__21@66@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
  (<= 0 i__21@66@07)))
; [eval] diz.Controller_m.Main_process_state[i__21] == -1 || 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__21] == -1
; [eval] diz.Controller_m.Main_process_state[i__21]
(push) ; 12
(assert (not (>= i__21@66@07 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2698
;  :arith-add-rows          16
;  :arith-assert-diseq      58
;  :arith-assert-lower      207
;  :arith-assert-upper      131
;  :arith-conflicts         17
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         35
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              255
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1432
;  :mk-clause               290
;  :num-allocs              4352881
;  :num-checks              165
;  :propagations            183
;  :quant-instantiations    104
;  :rlimit-count            170206)
; [eval] -1
(push) ; 12
; [then-branch: 35 | First:(Second:(Second:(Second:($t@59@07))))[i__21@66@07] == -1 | live]
; [else-branch: 35 | First:(Second:(Second:(Second:($t@59@07))))[i__21@66@07] != -1 | live]
(push) ; 13
; [then-branch: 35 | First:(Second:(Second:(Second:($t@59@07))))[i__21@66@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
    i__21@66@07)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 35 | First:(Second:(Second:(Second:($t@59@07))))[i__21@66@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
      i__21@66@07)
    (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__21] && diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__21]
; [eval] diz.Controller_m.Main_process_state[i__21]
(push) ; 14
(assert (not (>= i__21@66@07 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2698
;  :arith-add-rows          16
;  :arith-assert-diseq      59
;  :arith-assert-lower      210
;  :arith-assert-upper      132
;  :arith-conflicts         17
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         35
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              255
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1438
;  :mk-clause               294
;  :num-allocs              4352881
;  :num-checks              166
;  :propagations            185
;  :quant-instantiations    105
;  :rlimit-count            170438)
(push) ; 14
; [then-branch: 36 | 0 <= First:(Second:(Second:(Second:($t@59@07))))[i__21@66@07] | live]
; [else-branch: 36 | !(0 <= First:(Second:(Second:(Second:($t@59@07))))[i__21@66@07]) | live]
(push) ; 15
; [then-branch: 36 | 0 <= First:(Second:(Second:(Second:($t@59@07))))[i__21@66@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
    i__21@66@07)))
; [eval] diz.Controller_m.Main_process_state[i__21] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__21]
(push) ; 16
(assert (not (>= i__21@66@07 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2698
;  :arith-add-rows          16
;  :arith-assert-diseq      59
;  :arith-assert-lower      210
;  :arith-assert-upper      132
;  :arith-conflicts         17
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         35
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              255
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1438
;  :mk-clause               294
;  :num-allocs              4352881
;  :num-checks              167
;  :propagations            185
;  :quant-instantiations    105
;  :rlimit-count            170552)
; [eval] |diz.Controller_m.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 36 | !(0 <= First:(Second:(Second:(Second:($t@59@07))))[i__21@66@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
      i__21@66@07))))
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
; [else-branch: 34 | !(i__21@66@07 < |First:(Second:(Second:(Second:($t@59@07))))| && 0 <= i__21@66@07)]
(assert (not
  (and
    (<
      i__21@66@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
    (<= 0 i__21@66@07))))
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
(assert (not (forall ((i__21@66@07 Int)) (!
  (implies
    (and
      (<
        i__21@66@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
      (<= 0 i__21@66@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
          i__21@66@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
            i__21@66@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
            i__21@66@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
    i__21@66@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2698
;  :arith-add-rows          16
;  :arith-assert-diseq      61
;  :arith-assert-lower      211
;  :arith-assert-upper      133
;  :arith-conflicts         17
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         35
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               93
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              273
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1446
;  :mk-clause               308
;  :num-allocs              4352881
;  :num-checks              168
;  :propagations            187
;  :quant-instantiations    106
;  :rlimit-count            170998)
(assert (forall ((i__21@66@07 Int)) (!
  (implies
    (and
      (<
        i__21@66@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
      (<= 0 i__21@66@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
          i__21@66@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
            i__21@66@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
            i__21@66@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
    i__21@66@07))
  :qid |prog.l<no position>|)))
(declare-const $k@67@07 $Perm)
(assert ($Perm.isReadVar $k@67@07 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@67@07 $Perm.No) (< $Perm.No $k@67@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2698
;  :arith-add-rows          16
;  :arith-assert-diseq      62
;  :arith-assert-lower      213
;  :arith-assert-upper      134
;  :arith-conflicts         17
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         35
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               94
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              273
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1451
;  :mk-clause               310
;  :num-allocs              4352881
;  :num-checks              169
;  :propagations            188
;  :quant-instantiations    106
;  :rlimit-count            171559)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@51@07 $k@57@07) $k@61@07) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2699
;  :arith-add-rows          16
;  :arith-assert-diseq      62
;  :arith-assert-lower      213
;  :arith-assert-upper      135
;  :arith-conflicts         18
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         35
;  :arith-pivots            48
;  :binary-propagations     11
;  :conflicts               95
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              275
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1453
;  :mk-clause               312
;  :num-allocs              4352881
;  :num-checks              170
;  :propagations            189
;  :quant-instantiations    106
;  :rlimit-count            171647)
(assert (< $k@67@07 (+ (- $k@51@07 $k@57@07) $k@61@07)))
(assert (<= $Perm.No (- (+ (- $k@51@07 $k@57@07) $k@61@07) $k@67@07)))
(assert (<= (- (+ (- $k@51@07 $k@57@07) $k@61@07) $k@67@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@51@07 $k@57@07) $k@61@07) $k@67@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
; [eval] diz.Controller_m.Main_sensor != null
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@51@07 $k@57@07) $k@61@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2699
;  :arith-add-rows          17
;  :arith-assert-diseq      62
;  :arith-assert-lower      215
;  :arith-assert-upper      137
;  :arith-conflicts         19
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         36
;  :arith-pivots            49
;  :binary-propagations     11
;  :conflicts               96
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              275
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1457
;  :mk-clause               312
;  :num-allocs              4352881
;  :num-checks              171
;  :propagations            189
;  :quant-instantiations    106
;  :rlimit-count            171923)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@51@07 $k@57@07) $k@61@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2699
;  :arith-add-rows          17
;  :arith-assert-diseq      62
;  :arith-assert-lower      215
;  :arith-assert-upper      138
;  :arith-conflicts         20
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         37
;  :arith-pivots            50
;  :binary-propagations     11
;  :conflicts               97
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              275
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1458
;  :mk-clause               312
;  :num-allocs              4352881
;  :num-checks              172
;  :propagations            189
;  :quant-instantiations    106
;  :rlimit-count            172012)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@51@07 $k@57@07) $k@61@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2699
;  :arith-add-rows          17
;  :arith-assert-diseq      62
;  :arith-assert-lower      215
;  :arith-assert-upper      139
;  :arith-conflicts         21
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         38
;  :arith-pivots            51
;  :binary-propagations     11
;  :conflicts               98
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              275
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1459
;  :mk-clause               312
;  :num-allocs              4352881
;  :num-checks              173
;  :propagations            189
;  :quant-instantiations    106
;  :rlimit-count            172101)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2699
;  :arith-add-rows          17
;  :arith-assert-diseq      62
;  :arith-assert-lower      215
;  :arith-assert-upper      139
;  :arith-conflicts         21
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         38
;  :arith-pivots            51
;  :binary-propagations     11
;  :conflicts               98
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              275
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1459
;  :mk-clause               312
;  :num-allocs              4352881
;  :num-checks              174
;  :propagations            189
;  :quant-instantiations    106
;  :rlimit-count            172114)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@51@07 $k@57@07) $k@61@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2699
;  :arith-add-rows          17
;  :arith-assert-diseq      62
;  :arith-assert-lower      215
;  :arith-assert-upper      140
;  :arith-conflicts         22
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         39
;  :arith-pivots            52
;  :binary-propagations     11
;  :conflicts               99
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              275
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1460
;  :mk-clause               312
;  :num-allocs              4352881
;  :num-checks              175
;  :propagations            189
;  :quant-instantiations    106
;  :rlimit-count            172203)
(declare-const $k@68@07 $Perm)
(assert ($Perm.isReadVar $k@68@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@68@07 $Perm.No) (< $Perm.No $k@68@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2699
;  :arith-add-rows          17
;  :arith-assert-diseq      63
;  :arith-assert-lower      217
;  :arith-assert-upper      141
;  :arith-conflicts         22
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         39
;  :arith-pivots            52
;  :binary-propagations     11
;  :conflicts               100
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              275
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1464
;  :mk-clause               314
;  :num-allocs              4352881
;  :num-checks              176
;  :propagations            190
;  :quant-instantiations    106
;  :rlimit-count            172401)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@52@07 $k@58@07) $k@63@07) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2700
;  :arith-add-rows          17
;  :arith-assert-diseq      63
;  :arith-assert-lower      217
;  :arith-assert-upper      142
;  :arith-conflicts         23
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         39
;  :arith-pivots            52
;  :binary-propagations     11
;  :conflicts               101
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              277
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1466
;  :mk-clause               316
;  :num-allocs              4352881
;  :num-checks              177
;  :propagations            191
;  :quant-instantiations    106
;  :rlimit-count            172481)
(assert (< $k@68@07 (+ (- $k@52@07 $k@58@07) $k@63@07)))
(assert (<= $Perm.No (- (+ (- $k@52@07 $k@58@07) $k@63@07) $k@68@07)))
(assert (<= (- (+ (- $k@52@07 $k@58@07) $k@63@07) $k@68@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@52@07 $k@58@07) $k@63@07) $k@68@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
; [eval] diz.Controller_m.Main_controller != null
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@52@07 $k@58@07) $k@63@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2700
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      219
;  :arith-assert-upper      144
;  :arith-conflicts         24
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         40
;  :arith-pivots            52
;  :binary-propagations     11
;  :conflicts               102
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              277
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1470
;  :mk-clause               316
;  :num-allocs              4352881
;  :num-checks              178
;  :propagations            191
;  :quant-instantiations    106
;  :rlimit-count            172750)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@52@07 $k@58@07) $k@63@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2700
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      219
;  :arith-assert-upper      145
;  :arith-conflicts         25
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         41
;  :arith-pivots            52
;  :binary-propagations     11
;  :conflicts               103
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              277
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1471
;  :mk-clause               316
;  :num-allocs              4352881
;  :num-checks              179
;  :propagations            191
;  :quant-instantiations    106
;  :rlimit-count            172831)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2700
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      219
;  :arith-assert-upper      145
;  :arith-conflicts         25
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         41
;  :arith-pivots            52
;  :binary-propagations     11
;  :conflicts               103
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              277
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1471
;  :mk-clause               316
;  :num-allocs              4352881
;  :num-checks              180
;  :propagations            191
;  :quant-instantiations    106
;  :rlimit-count            172844)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@52@07 $k@58@07) $k@63@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2700
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      219
;  :arith-assert-upper      146
;  :arith-conflicts         26
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         42
;  :arith-pivots            52
;  :binary-propagations     11
;  :conflicts               104
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              277
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1472
;  :mk-clause               316
;  :num-allocs              4352881
;  :num-checks              181
;  :propagations            191
;  :quant-instantiations    106
;  :rlimit-count            172925)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
  $t@64@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2700
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      219
;  :arith-assert-upper      146
;  :arith-conflicts         26
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         42
;  :arith-pivots            52
;  :binary-propagations     11
;  :conflicts               104
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 528
;  :datatype-occurs-check   236
;  :datatype-splits         410
;  :decisions               485
;  :del-clause              277
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             1472
;  :mk-clause               316
;  :num-allocs              4352881
;  :num-checks              182
;  :propagations            191
;  :quant-instantiations    106
;  :rlimit-count            172936)
(push) ; 9
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2888
;  :arith-add-rows          22
;  :arith-assert-diseq      67
;  :arith-assert-lower      234
;  :arith-assert-upper      153
;  :arith-conflicts         26
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         45
;  :arith-pivots            58
;  :binary-propagations     11
;  :conflicts               104
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 573
;  :datatype-occurs-check   272
;  :datatype-splits         452
;  :decisions               526
;  :del-clause              301
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1545
;  :mk-clause               340
;  :num-allocs              4514259
;  :num-checks              183
;  :propagations            207
;  :quant-instantiations    113
;  :rlimit-count            174452
;  :time                    0.00)
; [eval] diz.Controller_m.Main_controller == diz
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@52@07 $k@58@07) $k@63@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2888
;  :arith-add-rows          22
;  :arith-assert-diseq      67
;  :arith-assert-lower      234
;  :arith-assert-upper      154
;  :arith-conflicts         27
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         46
;  :arith-pivots            58
;  :binary-propagations     11
;  :conflicts               105
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 573
;  :datatype-occurs-check   272
;  :datatype-splits         452
;  :decisions               526
;  :del-clause              301
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1546
;  :mk-clause               340
;  :num-allocs              4514259
;  :num-checks              184
;  :propagations            207
;  :quant-instantiations    113
;  :rlimit-count            174533)
(set-option :timeout 0)
(push) ; 9
(assert (not (= $t@64@07 diz@17@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2888
;  :arith-add-rows          22
;  :arith-assert-diseq      67
;  :arith-assert-lower      234
;  :arith-assert-upper      154
;  :arith-conflicts         27
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         46
;  :arith-pivots            58
;  :binary-propagations     11
;  :conflicts               105
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 573
;  :datatype-occurs-check   272
;  :datatype-splits         452
;  :decisions               526
;  :del-clause              301
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1546
;  :mk-clause               340
;  :num-allocs              4514259
;  :num-checks              185
;  :propagations            207
;  :quant-instantiations    113
;  :rlimit-count            174544)
(assert (= $t@64@07 diz@17@07))
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2888
;  :arith-add-rows          22
;  :arith-assert-diseq      67
;  :arith-assert-lower      234
;  :arith-assert-upper      154
;  :arith-conflicts         27
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         46
;  :arith-pivots            58
;  :binary-propagations     11
;  :conflicts               105
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 573
;  :datatype-occurs-check   272
;  :datatype-splits         452
;  :decisions               526
;  :del-clause              301
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1546
;  :mk-clause               340
;  :num-allocs              4514259
;  :num-checks              186
;  :propagations            207
;  :quant-instantiations    113
;  :rlimit-count            174560)
(pop) ; 8
(push) ; 8
; [else-branch: 24 | !(First:(Second:(Second:(Second:($t@49@07))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))[2] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
          2)
        (- 0 2))))))
(pop) ; 8
(set-option :timeout 10)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3041
;  :arith-add-rows          23
;  :arith-assert-diseq      67
;  :arith-assert-lower      234
;  :arith-assert-upper      154
;  :arith-conflicts         27
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         46
;  :arith-pivots            61
;  :binary-propagations     11
;  :conflicts               106
;  :datatype-accessor-ax    198
;  :datatype-constructor-ax 620
;  :datatype-occurs-check   284
;  :datatype-splits         488
;  :decisions               568
;  :del-clause              308
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1585
;  :mk-clause               341
;  :num-allocs              4514259
;  :num-checks              187
;  :propagations            211
;  :quant-instantiations    113
;  :rlimit-count            175777
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3194
;  :arith-add-rows          23
;  :arith-assert-diseq      67
;  :arith-assert-lower      234
;  :arith-assert-upper      154
;  :arith-conflicts         27
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         46
;  :arith-pivots            61
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 667
;  :datatype-occurs-check   296
;  :datatype-splits         524
;  :decisions               610
;  :del-clause              309
;  :final-checks            60
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1624
;  :mk-clause               342
;  :num-allocs              4514259
;  :num-checks              188
;  :propagations            215
;  :quant-instantiations    113
;  :rlimit-count            176918
;  :time                    0.00)
; [eval] !(diz.Controller_m.Main_process_state[1] != -1 || diz.Controller_m.Main_event_state[2] != -2)
; [eval] diz.Controller_m.Main_process_state[1] != -1 || diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_process_state[1] != -1
; [eval] diz.Controller_m.Main_process_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3194
;  :arith-add-rows          23
;  :arith-assert-diseq      67
;  :arith-assert-lower      234
;  :arith-assert-upper      154
;  :arith-conflicts         27
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         46
;  :arith-pivots            61
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 667
;  :datatype-occurs-check   296
;  :datatype-splits         524
;  :decisions               610
;  :del-clause              309
;  :final-checks            60
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1624
;  :mk-clause               342
;  :num-allocs              4514259
;  :num-checks              189
;  :propagations            215
;  :quant-instantiations    113
;  :rlimit-count            176933)
; [eval] -1
(push) ; 8
; [then-branch: 37 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1 | live]
; [else-branch: 37 | First:(Second:(Second:(Second:($t@49@07))))[1] == -1 | live]
(push) ; 9
; [then-branch: 37 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      1)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 37 | First:(Second:(Second:(Second:($t@49@07))))[1] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    1)
  (- 0 1)))
; [eval] diz.Controller_m.Main_event_state[2] != -2
; [eval] diz.Controller_m.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3195
;  :arith-add-rows          23
;  :arith-assert-diseq      67
;  :arith-assert-lower      234
;  :arith-assert-upper      154
;  :arith-conflicts         27
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         46
;  :arith-pivots            61
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 667
;  :datatype-occurs-check   296
;  :datatype-splits         524
;  :decisions               610
;  :del-clause              309
;  :final-checks            60
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1625
;  :mk-clause               342
;  :num-allocs              4514259
;  :num-checks              190
;  :propagations            215
;  :quant-instantiations    113
;  :rlimit-count            177091)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
        2)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3325
;  :arith-add-rows          23
;  :arith-assert-diseq      67
;  :arith-assert-lower      234
;  :arith-assert-upper      154
;  :arith-conflicts         27
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         46
;  :arith-pivots            61
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    207
;  :datatype-constructor-ax 704
;  :datatype-occurs-check   307
;  :datatype-splits         558
;  :decisions               643
;  :del-clause              309
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1660
;  :mk-clause               342
;  :num-allocs              4514259
;  :num-checks              191
;  :propagations            219
;  :quant-instantiations    113
;  :rlimit-count            178242
;  :time                    0.00)
(push) ; 8
(assert (not (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
          2)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3461
;  :arith-add-rows          24
;  :arith-assert-diseq      70
;  :arith-assert-lower      245
;  :arith-assert-upper      159
;  :arith-conflicts         27
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    211
;  :datatype-constructor-ax 741
;  :datatype-occurs-check   318
;  :datatype-splits         592
;  :decisions               677
;  :del-clause              327
;  :final-checks            66
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1718
;  :mk-clause               360
;  :num-allocs              4514259
;  :num-checks              192
;  :propagations            231
;  :quant-instantiations    117
;  :rlimit-count            179630
;  :time                    0.00)
; [then-branch: 38 | !(First:(Second:(Second:(Second:($t@49@07))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))[2] != -2) | live]
; [else-branch: 38 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))[2] != -2 | live]
(push) ; 8
; [then-branch: 38 | !(First:(Second:(Second:(Second:($t@49@07))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))[2] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
          2)
        (- 0 2))))))
; [exec]
; __flatten_16__19 := diz.Controller_m
(declare-const __flatten_16__19@69@07 $Ref)
(assert (= __flatten_16__19@69@07 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07))))
; [exec]
; __flatten_15__18 := __flatten_16__19.Main_sensor
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07)) __flatten_16__19@69@07)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3617
;  :arith-add-rows          24
;  :arith-assert-diseq      70
;  :arith-assert-lower      245
;  :arith-assert-upper      159
;  :arith-conflicts         27
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               108
;  :datatype-accessor-ax    216
;  :datatype-constructor-ax 788
;  :datatype-occurs-check   330
;  :datatype-splits         628
;  :decisions               719
;  :del-clause              328
;  :final-checks            69
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1760
;  :mk-clause               361
;  :num-allocs              4514259
;  :num-checks              193
;  :propagations            235
;  :quant-instantiations    117
;  :rlimit-count            181018
;  :time                    0.00)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) __flatten_16__19@69@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3617
;  :arith-add-rows          24
;  :arith-assert-diseq      70
;  :arith-assert-lower      245
;  :arith-assert-upper      159
;  :arith-conflicts         27
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               108
;  :datatype-accessor-ax    216
;  :datatype-constructor-ax 788
;  :datatype-occurs-check   330
;  :datatype-splits         628
;  :decisions               719
;  :del-clause              328
;  :final-checks            69
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1760
;  :mk-clause               361
;  :num-allocs              4514259
;  :num-checks              194
;  :propagations            235
;  :quant-instantiations    117
;  :rlimit-count            181029)
(push) ; 9
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3617
;  :arith-add-rows          24
;  :arith-assert-diseq      70
;  :arith-assert-lower      245
;  :arith-assert-upper      159
;  :arith-conflicts         27
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               109
;  :datatype-accessor-ax    216
;  :datatype-constructor-ax 788
;  :datatype-occurs-check   330
;  :datatype-splits         628
;  :decisions               719
;  :del-clause              328
;  :final-checks            69
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1760
;  :mk-clause               361
;  :num-allocs              4514259
;  :num-checks              195
;  :propagations            235
;  :quant-instantiations    117
;  :rlimit-count            181077)
(declare-const __flatten_15__18@70@07 $Ref)
(assert (=
  __flatten_15__18@70@07
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
  __flatten_15__18@70@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3618
;  :arith-add-rows          24
;  :arith-assert-diseq      70
;  :arith-assert-lower      245
;  :arith-assert-upper      159
;  :arith-conflicts         27
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               109
;  :datatype-accessor-ax    216
;  :datatype-constructor-ax 788
;  :datatype-occurs-check   330
;  :datatype-splits         628
;  :decisions               719
;  :del-clause              328
;  :final-checks            69
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1761
;  :mk-clause               361
;  :num-allocs              4514259
;  :num-checks              196
;  :propagations            235
;  :quant-instantiations    117
;  :rlimit-count            181225)
(push) ; 9
(assert (not (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3735
;  :arith-add-rows          24
;  :arith-assert-diseq      70
;  :arith-assert-lower      245
;  :arith-assert-upper      159
;  :arith-conflicts         27
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               109
;  :datatype-accessor-ax    220
;  :datatype-constructor-ax 824
;  :datatype-occurs-check   342
;  :datatype-splits         661
;  :decisions               751
;  :del-clause              328
;  :final-checks            72
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1795
;  :mk-clause               361
;  :num-allocs              4514259
;  :num-checks              197
;  :propagations            239
;  :quant-instantiations    118
;  :rlimit-count            182344
;  :time                    0.00)
(push) ; 9
(assert (not ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3864
;  :arith-add-rows          24
;  :arith-assert-diseq      70
;  :arith-assert-lower      245
;  :arith-assert-upper      159
;  :arith-conflicts         27
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               109
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              328
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1829
;  :mk-clause               361
;  :num-allocs              4514259
;  :num-checks              198
;  :propagations            243
;  :quant-instantiations    119
;  :rlimit-count            183477
;  :time                    0.00)
; [then-branch: 39 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@49@07)))))))))))) | live]
; [else-branch: 39 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))))))))) | live]
(push) ; 9
; [then-branch: 39 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))))))))]
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))
; [exec]
; diz.Controller_alarm_flag := true
; [exec]
; // assert
; assert diz.Controller_m.Main_sensor.Sensor_obs_detected == diz.Controller_alarm_flag
; [eval] diz.Controller_m.Main_sensor.Sensor_obs_detected == diz.Controller_alarm_flag
(push) ; 10
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      70
;  :arith-assert-lower      245
;  :arith-assert-upper      159
;  :arith-conflicts         27
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               110
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              328
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1831
;  :mk-clause               361
;  :num-allocs              4514259
;  :num-checks              199
;  :propagations            243
;  :quant-instantiations    120
;  :rlimit-count            183700)
(set-option :timeout 0)
(push) ; 10
(assert (not (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))
  true)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      70
;  :arith-assert-lower      245
;  :arith-assert-upper      159
;  :arith-conflicts         27
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               110
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              328
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1831
;  :mk-clause               361
;  :num-allocs              4514259
;  :num-checks              200
;  :propagations            243
;  :quant-instantiations    120
;  :rlimit-count            183711)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))
  true))
; Loop head block: Re-establish invariant
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      70
;  :arith-assert-lower      245
;  :arith-assert-upper      159
;  :arith-conflicts         27
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               110
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              328
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1831
;  :mk-clause               361
;  :num-allocs              4514259
;  :num-checks              201
;  :propagations            243
;  :quant-instantiations    120
;  :rlimit-count            183727)
; [eval] diz.Controller_m != null
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
; [eval] (forall i__20: Int :: { diz.Controller_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|)
(declare-const i__20@71@07 Int)
(push) ; 10
; [eval] 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__20
(push) ; 11
; [then-branch: 40 | 0 <= i__20@71@07 | live]
; [else-branch: 40 | !(0 <= i__20@71@07) | live]
(push) ; 12
; [then-branch: 40 | 0 <= i__20@71@07]
(assert (<= 0 i__20@71@07))
; [eval] i__20 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(pop) ; 12
(push) ; 12
; [else-branch: 40 | !(0 <= i__20@71@07)]
(assert (not (<= 0 i__20@71@07)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(push) ; 11
; [then-branch: 41 | i__20@71@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__20@71@07 | live]
; [else-branch: 41 | !(i__20@71@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__20@71@07) | live]
(push) ; 12
; [then-branch: 41 | i__20@71@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__20@71@07]
(assert (and
  (<
    i__20@71@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
  (<= 0 i__20@71@07)))
; [eval] diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__20] == -1
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 13
(assert (not (>= i__20@71@07 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      70
;  :arith-assert-lower      246
;  :arith-assert-upper      160
;  :arith-conflicts         27
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               110
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              328
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1833
;  :mk-clause               361
;  :num-allocs              4514259
;  :num-checks              202
;  :propagations            243
;  :quant-instantiations    120
;  :rlimit-count            183863)
; [eval] -1
(push) ; 13
; [then-branch: 42 | First:(Second:(Second:(Second:($t@49@07))))[i__20@71@07] == -1 | live]
; [else-branch: 42 | First:(Second:(Second:(Second:($t@49@07))))[i__20@71@07] != -1 | live]
(push) ; 14
; [then-branch: 42 | First:(Second:(Second:(Second:($t@49@07))))[i__20@71@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__20@71@07)
  (- 0 1)))
(pop) ; 14
(push) ; 14
; [else-branch: 42 | First:(Second:(Second:(Second:($t@49@07))))[i__20@71@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      i__20@71@07)
    (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__20]
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 15
(assert (not (>= i__20@71@07 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      71
;  :arith-assert-lower      249
;  :arith-assert-upper      161
;  :arith-conflicts         27
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               110
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              328
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1839
;  :mk-clause               365
;  :num-allocs              4514259
;  :num-checks              203
;  :propagations            245
;  :quant-instantiations    121
;  :rlimit-count            184095)
(push) ; 15
; [then-branch: 43 | 0 <= First:(Second:(Second:(Second:($t@49@07))))[i__20@71@07] | live]
; [else-branch: 43 | !(0 <= First:(Second:(Second:(Second:($t@49@07))))[i__20@71@07]) | live]
(push) ; 16
; [then-branch: 43 | 0 <= First:(Second:(Second:(Second:($t@49@07))))[i__20@71@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__20@71@07)))
; [eval] diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 17
(assert (not (>= i__20@71@07 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      71
;  :arith-assert-lower      249
;  :arith-assert-upper      161
;  :arith-conflicts         27
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               110
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              328
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1839
;  :mk-clause               365
;  :num-allocs              4514259
;  :num-checks              204
;  :propagations            245
;  :quant-instantiations    121
;  :rlimit-count            184209)
; [eval] |diz.Controller_m.Main_event_state|
(pop) ; 16
(push) ; 16
; [else-branch: 43 | !(0 <= First:(Second:(Second:(Second:($t@49@07))))[i__20@71@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      i__20@71@07))))
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
; [else-branch: 41 | !(i__20@71@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__20@71@07)]
(assert (not
  (and
    (<
      i__20@71@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
    (<= 0 i__20@71@07))))
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
(assert (not (forall ((i__20@71@07 Int)) (!
  (implies
    (and
      (<
        i__20@71@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
      (<= 0 i__20@71@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          i__20@71@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__20@71@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__20@71@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__20@71@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      72
;  :arith-assert-lower      250
;  :arith-assert-upper      162
;  :arith-conflicts         27
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               111
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1847
;  :mk-clause               377
;  :num-allocs              4514259
;  :num-checks              205
;  :propagations            247
;  :quant-instantiations    122
;  :rlimit-count            184655)
(assert (forall ((i__20@71@07 Int)) (!
  (implies
    (and
      (<
        i__20@71@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
      (<= 0 i__20@71@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          i__20@71@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__20@71@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__20@71@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__20@71@07))
  :qid |prog.l<no position>|)))
(declare-const $k@72@07 $Perm)
(assert ($Perm.isReadVar $k@72@07 $Perm.Write))
(push) ; 10
(assert (not (or (= $k@72@07 $Perm.No) (< $Perm.No $k@72@07))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      73
;  :arith-assert-lower      252
;  :arith-assert-upper      163
;  :arith-conflicts         27
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               112
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1852
;  :mk-clause               379
;  :num-allocs              4514259
;  :num-checks              206
;  :propagations            248
;  :quant-instantiations    122
;  :rlimit-count            185216)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= $k@51@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      73
;  :arith-assert-lower      252
;  :arith-assert-upper      163
;  :arith-conflicts         27
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         48
;  :arith-pivots            65
;  :binary-propagations     11
;  :conflicts               112
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1852
;  :mk-clause               379
;  :num-allocs              4514259
;  :num-checks              207
;  :propagations            248
;  :quant-instantiations    122
;  :rlimit-count            185227)
(assert (< $k@72@07 $k@51@07))
(assert (<= $Perm.No (- $k@51@07 $k@72@07)))
(assert (<= (- $k@51@07 $k@72@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@51@07 $k@72@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
; [eval] diz.Controller_m.Main_sensor != null
(push) ; 10
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      73
;  :arith-assert-lower      254
;  :arith-assert-upper      164
;  :arith-conflicts         27
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         48
;  :arith-pivots            66
;  :binary-propagations     11
;  :conflicts               113
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1855
;  :mk-clause               379
;  :num-allocs              4514259
;  :num-checks              208
;  :propagations            248
;  :quant-instantiations    122
;  :rlimit-count            185441)
(push) ; 10
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      73
;  :arith-assert-lower      254
;  :arith-assert-upper      164
;  :arith-conflicts         27
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         48
;  :arith-pivots            66
;  :binary-propagations     11
;  :conflicts               114
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1855
;  :mk-clause               379
;  :num-allocs              4514259
;  :num-checks              209
;  :propagations            248
;  :quant-instantiations    122
;  :rlimit-count            185489)
(push) ; 10
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      73
;  :arith-assert-lower      254
;  :arith-assert-upper      164
;  :arith-conflicts         27
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         48
;  :arith-pivots            66
;  :binary-propagations     11
;  :conflicts               115
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1855
;  :mk-clause               379
;  :num-allocs              4514259
;  :num-checks              210
;  :propagations            248
;  :quant-instantiations    122
;  :rlimit-count            185537)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      73
;  :arith-assert-lower      254
;  :arith-assert-upper      164
;  :arith-conflicts         27
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         48
;  :arith-pivots            66
;  :binary-propagations     11
;  :conflicts               115
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1855
;  :mk-clause               379
;  :num-allocs              4514259
;  :num-checks              211
;  :propagations            248
;  :quant-instantiations    122
;  :rlimit-count            185550)
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      73
;  :arith-assert-lower      254
;  :arith-assert-upper      164
;  :arith-conflicts         27
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         48
;  :arith-pivots            66
;  :binary-propagations     11
;  :conflicts               116
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1855
;  :mk-clause               379
;  :num-allocs              4514259
;  :num-checks              212
;  :propagations            248
;  :quant-instantiations    122
;  :rlimit-count            185598)
(declare-const $k@73@07 $Perm)
(assert ($Perm.isReadVar $k@73@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@73@07 $Perm.No) (< $Perm.No $k@73@07))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      256
;  :arith-assert-upper      165
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            66
;  :binary-propagations     11
;  :conflicts               117
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1859
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              213
;  :propagations            249
;  :quant-instantiations    122
;  :rlimit-count            185796)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= $k@52@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      256
;  :arith-assert-upper      165
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            66
;  :binary-propagations     11
;  :conflicts               117
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1859
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              214
;  :propagations            249
;  :quant-instantiations    122
;  :rlimit-count            185807)
(assert (< $k@73@07 $k@52@07))
(assert (<= $Perm.No (- $k@52@07 $k@73@07)))
(assert (<= (- $k@52@07 $k@73@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@52@07 $k@73@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
; [eval] diz.Controller_m.Main_controller != null
(push) ; 10
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            67
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1862
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              215
;  :propagations            249
;  :quant-instantiations    122
;  :rlimit-count            186021)
(push) ; 10
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            67
;  :binary-propagations     11
;  :conflicts               119
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1862
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              216
;  :propagations            249
;  :quant-instantiations    122
;  :rlimit-count            186069)
(push) ; 10
(assert (not (=
  diz@17@07
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            67
;  :binary-propagations     11
;  :conflicts               119
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1862
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              217
;  :propagations            249
;  :quant-instantiations    122
;  :rlimit-count            186080)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            67
;  :binary-propagations     11
;  :conflicts               119
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1862
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              218
;  :propagations            249
;  :quant-instantiations    122
;  :rlimit-count            186093)
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3867
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            67
;  :binary-propagations     11
;  :conflicts               120
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 860
;  :datatype-occurs-check   353
;  :datatype-splits         694
;  :decisions               783
;  :del-clause              344
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1862
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              219
;  :propagations            249
;  :quant-instantiations    122
;  :rlimit-count            186141)
(push) ; 10
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3981
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            67
;  :binary-propagations     11
;  :conflicts               120
;  :datatype-accessor-ax    228
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   365
;  :datatype-splits         727
;  :decisions               815
;  :del-clause              344
;  :final-checks            78
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1894
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              220
;  :propagations            253
;  :quant-instantiations    122
;  :rlimit-count            187094
;  :time                    0.00)
; [eval] diz.Controller_m.Main_controller == diz
(push) ; 10
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3981
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            67
;  :binary-propagations     11
;  :conflicts               121
;  :datatype-accessor-ax    228
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   365
;  :datatype-splits         727
;  :decisions               815
;  :del-clause              344
;  :final-checks            78
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1894
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              221
;  :propagations            253
;  :quant-instantiations    122
;  :rlimit-count            187142)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3981
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            67
;  :binary-propagations     11
;  :conflicts               121
;  :datatype-accessor-ax    228
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   365
;  :datatype-splits         727
;  :decisions               815
;  :del-clause              344
;  :final-checks            78
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1894
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              222
;  :propagations            253
;  :quant-instantiations    122
;  :rlimit-count            187155)
(pop) ; 9
(push) ; 9
; [else-branch: 39 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@49@07)))))))))))))]
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
(pop) ; 9
; [eval] !__flatten_15__18.Sensor_obs_detected
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))
  __flatten_15__18@70@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3981
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               121
;  :datatype-accessor-ax    228
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   365
;  :datatype-splits         727
;  :decisions               815
;  :del-clause              348
;  :final-checks            78
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1894
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              223
;  :propagations            253
;  :quant-instantiations    122
;  :rlimit-count            187206)
(push) ; 9
(assert (not ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4110
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               121
;  :datatype-accessor-ax    232
;  :datatype-constructor-ax 932
;  :datatype-occurs-check   376
;  :datatype-splits         760
;  :decisions               847
;  :del-clause              348
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1928
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              224
;  :propagations            257
;  :quant-instantiations    123
;  :rlimit-count            188335
;  :time                    0.00)
(push) ; 9
(assert (not (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4227
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               121
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              348
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1962
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              225
;  :propagations            261
;  :quant-instantiations    124
;  :rlimit-count            189446
;  :time                    0.00)
; [then-branch: 44 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))))))))) | live]
; [else-branch: 44 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@49@07)))))))))))) | live]
(push) ; 9
; [then-branch: 44 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@49@07)))))))))))))]
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))))
; [exec]
; diz.Controller_alarm_flag := false
; [exec]
; // assert
; assert diz.Controller_m.Main_sensor.Sensor_obs_detected == diz.Controller_alarm_flag
; [eval] diz.Controller_m.Main_sensor.Sensor_obs_detected == diz.Controller_alarm_flag
(push) ; 10
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              348
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1964
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              226
;  :propagations            261
;  :quant-instantiations    125
;  :rlimit-count            189679)
(set-option :timeout 0)
(push) ; 10
(assert (not (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))
  false)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              348
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1964
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              227
;  :propagations            261
;  :quant-instantiations    125
;  :rlimit-count            189690)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))))))
  false))
; Loop head block: Re-establish invariant
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      258
;  :arith-assert-upper      166
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              348
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1964
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              228
;  :propagations            261
;  :quant-instantiations    125
;  :rlimit-count            189706)
; [eval] diz.Controller_m != null
; [eval] |diz.Controller_m.Main_process_state| == 2
; [eval] |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_event_state| == 3
; [eval] |diz.Controller_m.Main_event_state|
; [eval] (forall i__20: Int :: { diz.Controller_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|)
(declare-const i__20@74@07 Int)
(push) ; 10
; [eval] 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state| ==> diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= i__20 && i__20 < |diz.Controller_m.Main_process_state|
; [eval] 0 <= i__20
(push) ; 11
; [then-branch: 45 | 0 <= i__20@74@07 | live]
; [else-branch: 45 | !(0 <= i__20@74@07) | live]
(push) ; 12
; [then-branch: 45 | 0 <= i__20@74@07]
(assert (<= 0 i__20@74@07))
; [eval] i__20 < |diz.Controller_m.Main_process_state|
; [eval] |diz.Controller_m.Main_process_state|
(pop) ; 12
(push) ; 12
; [else-branch: 45 | !(0 <= i__20@74@07)]
(assert (not (<= 0 i__20@74@07)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(push) ; 11
; [then-branch: 46 | i__20@74@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__20@74@07 | live]
; [else-branch: 46 | !(i__20@74@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__20@74@07) | live]
(push) ; 12
; [then-branch: 46 | i__20@74@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__20@74@07]
(assert (and
  (<
    i__20@74@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
  (<= 0 i__20@74@07)))
; [eval] diz.Controller_m.Main_process_state[i__20] == -1 || 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__20] == -1
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 13
(assert (not (>= i__20@74@07 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      74
;  :arith-assert-lower      259
;  :arith-assert-upper      167
;  :arith-conflicts         27
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              348
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1966
;  :mk-clause               381
;  :num-allocs              4514259
;  :num-checks              229
;  :propagations            261
;  :quant-instantiations    125
;  :rlimit-count            189842)
; [eval] -1
(push) ; 13
; [then-branch: 47 | First:(Second:(Second:(Second:($t@49@07))))[i__20@74@07] == -1 | live]
; [else-branch: 47 | First:(Second:(Second:(Second:($t@49@07))))[i__20@74@07] != -1 | live]
(push) ; 14
; [then-branch: 47 | First:(Second:(Second:(Second:($t@49@07))))[i__20@74@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__20@74@07)
  (- 0 1)))
(pop) ; 14
(push) ; 14
; [else-branch: 47 | First:(Second:(Second:(Second:($t@49@07))))[i__20@74@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      i__20@74@07)
    (- 0 1))))
; [eval] 0 <= diz.Controller_m.Main_process_state[i__20] && diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] 0 <= diz.Controller_m.Main_process_state[i__20]
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 15
(assert (not (>= i__20@74@07 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      75
;  :arith-assert-lower      262
;  :arith-assert-upper      168
;  :arith-conflicts         27
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              348
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1972
;  :mk-clause               385
;  :num-allocs              4514259
;  :num-checks              230
;  :propagations            263
;  :quant-instantiations    126
;  :rlimit-count            190074)
(push) ; 15
; [then-branch: 48 | 0 <= First:(Second:(Second:(Second:($t@49@07))))[i__20@74@07] | live]
; [else-branch: 48 | !(0 <= First:(Second:(Second:(Second:($t@49@07))))[i__20@74@07]) | live]
(push) ; 16
; [then-branch: 48 | 0 <= First:(Second:(Second:(Second:($t@49@07))))[i__20@74@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__20@74@07)))
; [eval] diz.Controller_m.Main_process_state[i__20] < |diz.Controller_m.Main_event_state|
; [eval] diz.Controller_m.Main_process_state[i__20]
(push) ; 17
(assert (not (>= i__20@74@07 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      75
;  :arith-assert-lower      262
;  :arith-assert-upper      168
;  :arith-conflicts         27
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              348
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1972
;  :mk-clause               385
;  :num-allocs              4514259
;  :num-checks              231
;  :propagations            263
;  :quant-instantiations    126
;  :rlimit-count            190188)
; [eval] |diz.Controller_m.Main_event_state|
(pop) ; 16
(push) ; 16
; [else-branch: 48 | !(0 <= First:(Second:(Second:(Second:($t@49@07))))[i__20@74@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
      i__20@74@07))))
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
; [else-branch: 46 | !(i__20@74@07 < |First:(Second:(Second:(Second:($t@49@07))))| && 0 <= i__20@74@07)]
(assert (not
  (and
    (<
      i__20@74@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
    (<= 0 i__20@74@07))))
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
(assert (not (forall ((i__20@74@07 Int)) (!
  (implies
    (and
      (<
        i__20@74@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
      (<= 0 i__20@74@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          i__20@74@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__20@74@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__20@74@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__20@74@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      77
;  :arith-assert-lower      263
;  :arith-assert-upper      169
;  :arith-conflicts         27
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               123
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1980
;  :mk-clause               399
;  :num-allocs              4514259
;  :num-checks              232
;  :propagations            265
;  :quant-instantiations    127
;  :rlimit-count            190634)
(assert (forall ((i__20@74@07 Int)) (!
  (implies
    (and
      (<
        i__20@74@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
      (<= 0 i__20@74@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
          i__20@74@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__20@74@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
            i__20@74@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
    i__20@74@07))
  :qid |prog.l<no position>|)))
(declare-const $k@75@07 $Perm)
(assert ($Perm.isReadVar $k@75@07 $Perm.Write))
(push) ; 10
(assert (not (or (= $k@75@07 $Perm.No) (< $Perm.No $k@75@07))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      78
;  :arith-assert-lower      265
;  :arith-assert-upper      170
;  :arith-conflicts         27
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1985
;  :mk-clause               401
;  :num-allocs              4514259
;  :num-checks              233
;  :propagations            266
;  :quant-instantiations    127
;  :rlimit-count            191195)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= $k@51@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      78
;  :arith-assert-lower      265
;  :arith-assert-upper      170
;  :arith-conflicts         27
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         48
;  :arith-pivots            69
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1985
;  :mk-clause               401
;  :num-allocs              4514259
;  :num-checks              234
;  :propagations            266
;  :quant-instantiations    127
;  :rlimit-count            191206)
(assert (< $k@75@07 $k@51@07))
(assert (<= $Perm.No (- $k@51@07 $k@75@07)))
(assert (<= (- $k@51@07 $k@75@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@51@07 $k@75@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
; [eval] diz.Controller_m.Main_sensor != null
(push) ; 10
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      78
;  :arith-assert-lower      267
;  :arith-assert-upper      171
;  :arith-conflicts         27
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               125
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1988
;  :mk-clause               401
;  :num-allocs              4514259
;  :num-checks              235
;  :propagations            266
;  :quant-instantiations    127
;  :rlimit-count            191420)
(push) ; 10
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      78
;  :arith-assert-lower      267
;  :arith-assert-upper      171
;  :arith-conflicts         27
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               126
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1988
;  :mk-clause               401
;  :num-allocs              4514259
;  :num-checks              236
;  :propagations            266
;  :quant-instantiations    127
;  :rlimit-count            191468)
(push) ; 10
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      78
;  :arith-assert-lower      267
;  :arith-assert-upper      171
;  :arith-conflicts         27
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               127
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1988
;  :mk-clause               401
;  :num-allocs              4514259
;  :num-checks              237
;  :propagations            266
;  :quant-instantiations    127
;  :rlimit-count            191516)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      78
;  :arith-assert-lower      267
;  :arith-assert-upper      171
;  :arith-conflicts         27
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               127
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1988
;  :mk-clause               401
;  :num-allocs              4514259
;  :num-checks              238
;  :propagations            266
;  :quant-instantiations    127
;  :rlimit-count            191529)
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@51@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      78
;  :arith-assert-lower      267
;  :arith-assert-upper      171
;  :arith-conflicts         27
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               128
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1988
;  :mk-clause               401
;  :num-allocs              4514259
;  :num-checks              239
;  :propagations            266
;  :quant-instantiations    127
;  :rlimit-count            191577)
(declare-const $k@76@07 $Perm)
(assert ($Perm.isReadVar $k@76@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 10
(assert (not (or (= $k@76@07 $Perm.No) (< $Perm.No $k@76@07))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      79
;  :arith-assert-lower      269
;  :arith-assert-upper      172
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               129
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1992
;  :mk-clause               403
;  :num-allocs              4514259
;  :num-checks              240
;  :propagations            267
;  :quant-instantiations    127
;  :rlimit-count            191776)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= $k@52@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      79
;  :arith-assert-lower      269
;  :arith-assert-upper      172
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               129
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1992
;  :mk-clause               403
;  :num-allocs              4514259
;  :num-checks              241
;  :propagations            267
;  :quant-instantiations    127
;  :rlimit-count            191787)
(assert (< $k@76@07 $k@52@07))
(assert (<= $Perm.No (- $k@52@07 $k@76@07)))
(assert (<= (- $k@52@07 $k@76@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@52@07 $k@76@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@49@07)) $Ref.null))))
; [eval] diz.Controller_m.Main_controller != null
(push) ; 10
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      173
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               130
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1995
;  :mk-clause               403
;  :num-allocs              4514259
;  :num-checks              242
;  :propagations            267
;  :quant-instantiations    127
;  :rlimit-count            191995)
(push) ; 10
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      173
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               131
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1995
;  :mk-clause               403
;  :num-allocs              4514259
;  :num-checks              243
;  :propagations            267
;  :quant-instantiations    127
;  :rlimit-count            192043)
(push) ; 10
(assert (not (=
  diz@17@07
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      173
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               131
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1995
;  :mk-clause               403
;  :num-allocs              4514259
;  :num-checks              244
;  :propagations            267
;  :quant-instantiations    127
;  :rlimit-count            192054)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      173
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               131
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1995
;  :mk-clause               403
;  :num-allocs              4514259
;  :num-checks              245
;  :propagations            267
;  :quant-instantiations    127
;  :rlimit-count            192067)
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4230
;  :arith-add-rows          24
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      173
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               132
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 968
;  :datatype-occurs-check   388
;  :datatype-splits         793
;  :decisions               879
;  :del-clause              366
;  :final-checks            84
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             1995
;  :mk-clause               403
;  :num-allocs              4514259
;  :num-checks              246
;  :propagations            267
;  :quant-instantiations    127
;  :rlimit-count            192115)
(push) ; 10
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4356
;  :arith-add-rows          24
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      173
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               132
;  :datatype-accessor-ax    240
;  :datatype-constructor-ax 1004
;  :datatype-occurs-check   399
;  :datatype-splits         826
;  :decisions               911
;  :del-clause              366
;  :final-checks            87
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             2027
;  :mk-clause               403
;  :num-allocs              4514259
;  :num-checks              247
;  :propagations            271
;  :quant-instantiations    127
;  :rlimit-count            193080
;  :time                    0.00)
; [eval] diz.Controller_m.Main_controller == diz
(push) ; 10
(assert (not (< $Perm.No $k@52@07)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4356
;  :arith-add-rows          24
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      173
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               133
;  :datatype-accessor-ax    240
;  :datatype-constructor-ax 1004
;  :datatype-occurs-check   399
;  :datatype-splits         826
;  :decisions               911
;  :del-clause              366
;  :final-checks            87
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             2027
;  :mk-clause               403
;  :num-allocs              4514259
;  :num-checks              248
;  :propagations            271
;  :quant-instantiations    127
;  :rlimit-count            193128)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4356
;  :arith-add-rows          24
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      173
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            70
;  :binary-propagations     11
;  :conflicts               133
;  :datatype-accessor-ax    240
;  :datatype-constructor-ax 1004
;  :datatype-occurs-check   399
;  :datatype-splits         826
;  :decisions               911
;  :del-clause              366
;  :final-checks            87
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             2027
;  :mk-clause               403
;  :num-allocs              4514259
;  :num-checks              249
;  :propagations            271
;  :quant-instantiations    127
;  :rlimit-count            193141)
(pop) ; 9
(push) ; 9
; [else-branch: 44 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))))))))]
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07))))))))))))))
(pop) ; 9
(pop) ; 8
(push) ; 8
; [else-branch: 38 | First:(Second:(Second:(Second:($t@49@07))))[1] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@49@07))))))[2] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@49@07)))))))
        2)
      (- 0 2)))))
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(set-option :timeout 10)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@07))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4486
;  :arith-add-rows          25
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      173
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            75
;  :binary-propagations     11
;  :conflicts               134
;  :datatype-accessor-ax    247
;  :datatype-constructor-ax 1044
;  :datatype-occurs-check   411
;  :datatype-splits         867
;  :decisions               944
;  :del-clause              396
;  :final-checks            91
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             2070
;  :mk-clause               404
;  :num-allocs              4514259
;  :num-checks              250
;  :propagations            277
;  :quant-instantiations    127
;  :rlimit-count            194262
;  :time                    0.00)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@39@07))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@07))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4616
;  :arith-add-rows          25
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      173
;  :arith-conflicts         27
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         48
;  :arith-pivots            75
;  :binary-propagations     11
;  :conflicts               135
;  :datatype-accessor-ax    254
;  :datatype-constructor-ax 1084
;  :datatype-occurs-check   423
;  :datatype-splits         908
;  :decisions               977
;  :del-clause              397
;  :final-checks            95
;  :max-generation          2
;  :max-memory              4.60
;  :memory                  4.60
;  :mk-bool-var             2113
;  :mk-clause               405
;  :num-allocs              4514259
;  :num-checks              251
;  :propagations            283
;  :quant-instantiations    127
;  :rlimit-count            195271
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
