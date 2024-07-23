(get-info :version)
; (:version "4.8.6")
; Started: 2024-07-19 22:37:17
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
(assert (not (= diz__14@16@06 globals@11@06)))
(assert (not (= diz__14@16@06 m_param@12@06)))
(assert (not (= diz__14@16@06 sys__result@13@06)))
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
; ---------- Main___contract_unsatisfiable__Main_EncodedGlobalVariables ----------
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
; inhale true && true
(declare-const $t@27@06 $Snap)
(assert (= $t@27@06 ($Snap.combine ($Snap.first $t@27@06) ($Snap.second $t@27@06))))
(assert (= ($Snap.first $t@27@06) $Snap.unit))
(assert (= ($Snap.second $t@27@06) $Snap.unit))
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
(declare-const diz@28@06 $Ref)
(declare-const globals@29@06 $Ref)
(declare-const diz@30@06 $Ref)
(declare-const globals@31@06 $Ref)
(push) ; 1
(declare-const $t@32@06 $Snap)
(assert (= $t@32@06 ($Snap.combine ($Snap.first $t@32@06) ($Snap.second $t@32@06))))
(assert (= ($Snap.first $t@32@06) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@30@06 $Ref.null)))
(assert (=
  ($Snap.second $t@32@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@32@06))
    ($Snap.second ($Snap.second $t@32@06)))))
(declare-const $k@33@06 $Perm)
(assert ($Perm.isReadVar $k@33@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@33@06 $Perm.No) (< $Perm.No $k@33@06))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             27
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             1
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           269
;  :mk-clause             3
;  :num-allocs            3404520
;  :num-checks            10
;  :propagations          12
;  :quant-instantiations  1
;  :rlimit-count          113443)
(assert (<= $Perm.No $k@33@06))
(assert (<= $k@33@06 $Perm.Write))
(assert (implies (< $Perm.No $k@33@06) (not (= diz@30@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@32@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@32@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@32@06))) $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@33@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             33
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             2
;  :datatype-accessor-ax  8
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           272
;  :mk-clause             3
;  :num-allocs            3404520
;  :num-checks            11
;  :propagations          12
;  :quant-instantiations  1
;  :rlimit-count          113696)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@32@06))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@32@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@32@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))
(push) ; 2
(assert (not (< $Perm.No $k@33@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             39
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             3
;  :datatype-accessor-ax  9
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           275
;  :mk-clause             3
;  :num-allocs            3404520
;  :num-checks            12
;  :propagations          12
;  :quant-instantiations  2
;  :rlimit-count          113980
;  :time                  0.00)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             39
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             3
;  :datatype-accessor-ax  9
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           275
;  :mk-clause             3
;  :num-allocs            3404520
;  :num-checks            13
;  :propagations          12
;  :quant-instantiations  2
;  :rlimit-count          113993)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))
  $Snap.unit))
; [eval] diz.Main_sensor.Sensor_m == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@33@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             45
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             4
;  :datatype-accessor-ax  10
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           277
;  :mk-clause             3
;  :num-allocs            3404520
;  :num-checks            14
;  :propagations          12
;  :quant-instantiations  2
;  :rlimit-count          114212)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))
  diz@30@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
(push) ; 2
(assert (not (< $Perm.No $k@33@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             52
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             5
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           280
;  :mk-clause             3
;  :num-allocs            3404520
;  :num-checks            15
;  :propagations          12
;  :quant-instantiations  3
;  :rlimit-count          114498)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             52
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             5
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           280
;  :mk-clause             3
;  :num-allocs            3404520
;  :num-checks            16
;  :propagations          12
;  :quant-instantiations  3
;  :rlimit-count          114511)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))
  $Snap.unit))
; [eval] !diz.Main_sensor.Sensor_init
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@33@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             58
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             6
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           282
;  :mk-clause             3
;  :num-allocs            3404520
;  :num-checks            17
;  :propagations          12
;  :quant-instantiations  3
;  :rlimit-count          114750)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))
(declare-const $k@34@06 $Perm)
(assert ($Perm.isReadVar $k@34@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@34@06 $Perm.No) (< $Perm.No $k@34@06))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             67
;  :arith-assert-diseq    2
;  :arith-assert-lower    5
;  :arith-assert-upper    4
;  :arith-eq-adapter      3
;  :binary-propagations   11
;  :conflicts             7
;  :datatype-accessor-ax  13
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        2
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           290
;  :mk-clause             5
;  :num-allocs            3404520
;  :num-checks            18
;  :propagations          13
;  :quant-instantiations  5
;  :rlimit-count          115220)
(assert (<= $Perm.No $k@34@06))
(assert (<= $k@34@06 $Perm.Write))
(assert (implies (< $Perm.No $k@34@06) (not (= diz@30@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@34@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             73
;  :arith-assert-diseq    2
;  :arith-assert-lower    5
;  :arith-assert-upper    5
;  :arith-eq-adapter      3
;  :binary-propagations   11
;  :conflicts             8
;  :datatype-accessor-ax  14
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        2
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           293
;  :mk-clause             5
;  :num-allocs            3404520
;  :num-checks            19
;  :propagations          13
;  :quant-instantiations  5
;  :rlimit-count          115533)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@34@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             79
;  :arith-assert-diseq    2
;  :arith-assert-lower    5
;  :arith-assert-upper    5
;  :arith-eq-adapter      3
;  :binary-propagations   11
;  :conflicts             9
;  :datatype-accessor-ax  15
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        2
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           296
;  :mk-clause             5
;  :num-allocs            3404520
;  :num-checks            20
;  :propagations          13
;  :quant-instantiations  6
;  :rlimit-count          115877)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             79
;  :arith-assert-diseq    2
;  :arith-assert-lower    5
;  :arith-assert-upper    5
;  :arith-eq-adapter      3
;  :binary-propagations   11
;  :conflicts             9
;  :datatype-accessor-ax  15
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        2
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           296
;  :mk-clause             5
;  :num-allocs            3404520
;  :num-checks            21
;  :propagations          13
;  :quant-instantiations  6
;  :rlimit-count          115890)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))
  $Snap.unit))
; [eval] diz.Main_controller.Controller_m == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@34@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             85
;  :arith-assert-diseq    2
;  :arith-assert-lower    5
;  :arith-assert-upper    5
;  :arith-eq-adapter      3
;  :binary-propagations   11
;  :conflicts             10
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        2
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           298
;  :mk-clause             5
;  :num-allocs            3404520
;  :num-checks            22
;  :propagations          13
;  :quant-instantiations  6
;  :rlimit-count          116169)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))
  diz@30@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@34@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             93
;  :arith-assert-diseq    2
;  :arith-assert-lower    5
;  :arith-assert-upper    5
;  :arith-eq-adapter      3
;  :binary-propagations   11
;  :conflicts             11
;  :datatype-accessor-ax  17
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        2
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           301
;  :mk-clause             5
;  :num-allocs            3404520
;  :num-checks            23
;  :propagations          13
;  :quant-instantiations  7
;  :rlimit-count          116514)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             93
;  :arith-assert-diseq    2
;  :arith-assert-lower    5
;  :arith-assert-upper    5
;  :arith-eq-adapter      3
;  :binary-propagations   11
;  :conflicts             11
;  :datatype-accessor-ax  17
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        2
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           301
;  :mk-clause             5
;  :num-allocs            3404520
;  :num-checks            24
;  :propagations          13
;  :quant-instantiations  7
;  :rlimit-count          116527)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))))
  $Snap.unit))
; [eval] !diz.Main_controller.Controller_init
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@34@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             99
;  :arith-assert-diseq    2
;  :arith-assert-lower    5
;  :arith-assert-upper    5
;  :arith-eq-adapter      3
;  :binary-propagations   11
;  :conflicts             12
;  :datatype-accessor-ax  18
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        2
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           303
;  :mk-clause             5
;  :num-allocs            3404520
;  :num-checks            25
;  :propagations          13
;  :quant-instantiations  7
;  :rlimit-count          116826)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@33@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             107
;  :arith-assert-diseq    2
;  :arith-assert-lower    5
;  :arith-assert-upper    5
;  :arith-eq-adapter      3
;  :binary-propagations   11
;  :conflicts             13
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        2
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           306
;  :mk-clause             5
;  :num-allocs            3404520
;  :num-checks            26
;  :propagations          13
;  :quant-instantiations  8
;  :rlimit-count          117192)
(push) ; 2
(assert (not (< $Perm.No $k@34@06)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             107
;  :arith-assert-diseq    2
;  :arith-assert-lower    5
;  :arith-assert-upper    5
;  :arith-eq-adapter      3
;  :binary-propagations   11
;  :conflicts             14
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 12
;  :final-checks          9
;  :max-generation        2
;  :max-memory            3.96
;  :memory                3.81
;  :mk-bool-var           306
;  :mk-clause             5
;  :num-allocs            3404520
;  :num-checks            27
;  :propagations          13
;  :quant-instantiations  8
;  :rlimit-count          117240)
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@35@06 $Snap)
(assert (= $t@35@06 ($Snap.combine ($Snap.first $t@35@06) ($Snap.second $t@35@06))))
(declare-const $k@36@06 $Perm)
(assert ($Perm.isReadVar $k@36@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@36@06 $Perm.No) (< $Perm.No $k@36@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               128
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      6
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               15
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.81
;  :mk-bool-var             317
;  :mk-clause               7
;  :num-allocs              3404520
;  :num-checks              29
;  :propagations            14
;  :quant-instantiations    8
;  :rlimit-count            117905)
(assert (<= $Perm.No $k@36@06))
(assert (<= $k@36@06 $Perm.Write))
(assert (implies (< $Perm.No $k@36@06) (not (= diz@30@06 $Ref.null))))
(assert (=
  ($Snap.second $t@35@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@35@06))
    ($Snap.second ($Snap.second $t@35@06)))))
(assert (= ($Snap.first ($Snap.second $t@35@06)) $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@36@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               134
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               16
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             320
;  :mk-clause               7
;  :num-allocs              3527705
;  :num-checks              30
;  :propagations            14
;  :quant-instantiations    8
;  :rlimit-count            118148)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@06)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@35@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@35@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))
(push) ; 3
(assert (not (< $Perm.No $k@36@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               140
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               17
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             323
;  :mk-clause               7
;  :num-allocs              3527705
;  :num-checks              31
;  :propagations            14
;  :quant-instantiations    9
;  :rlimit-count            118420)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               140
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               17
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             323
;  :mk-clause               7
;  :num-allocs              3527705
;  :num-checks              32
;  :propagations            14
;  :quant-instantiations    9
;  :rlimit-count            118433)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@35@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@06))))
  $Snap.unit))
; [eval] diz.Main_sensor.Sensor_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@36@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               146
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               18
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             325
;  :mk-clause               7
;  :num-allocs              3527705
;  :num-checks              33
;  :propagations            14
;  :quant-instantiations    9
;  :rlimit-count            118642)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@35@06))))
  diz@30@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))
(push) ; 3
(assert (not (< $Perm.No $k@36@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               154
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               19
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             328
;  :mk-clause               7
;  :num-allocs              3527705
;  :num-checks              34
;  :propagations            14
;  :quant-instantiations    10
;  :rlimit-count            118917)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               154
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               19
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             328
;  :mk-clause               7
;  :num-allocs              3527705
;  :num-checks              35
;  :propagations            14
;  :quant-instantiations    10
;  :rlimit-count            118930)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))
  $Snap.unit))
; [eval] !diz.Main_sensor.Sensor_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@36@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               160
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               20
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             330
;  :mk-clause               7
;  :num-allocs              3527705
;  :num-checks              36
;  :propagations            14
;  :quant-instantiations    10
;  :rlimit-count            119159)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))
(declare-const $k@37@06 $Perm)
(assert ($Perm.isReadVar $k@37@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@37@06 $Perm.No) (< $Perm.No $k@37@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               168
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      8
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               21
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             337
;  :mk-clause               9
;  :num-allocs              3527705
;  :num-checks              37
;  :propagations            15
;  :quant-instantiations    11
;  :rlimit-count            119599)
(assert (<= $Perm.No $k@37@06))
(assert (<= $k@37@06 $Perm.Write))
(assert (implies (< $Perm.No $k@37@06) (not (= diz@30@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@37@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               174
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               22
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             340
;  :mk-clause               9
;  :num-allocs              3527705
;  :num-checks              38
;  :propagations            15
;  :quant-instantiations    11
;  :rlimit-count            119902)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@37@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               180
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               23
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             343
;  :mk-clause               9
;  :num-allocs              3527705
;  :num-checks              39
;  :propagations            15
;  :quant-instantiations    12
;  :rlimit-count            120236)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               180
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               23
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             343
;  :mk-clause               9
;  :num-allocs              3527705
;  :num-checks              40
;  :propagations            15
;  :quant-instantiations    12
;  :rlimit-count            120249)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))
  $Snap.unit))
; [eval] diz.Main_controller.Controller_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@37@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               186
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               24
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             345
;  :mk-clause               9
;  :num-allocs              3527705
;  :num-checks              41
;  :propagations            15
;  :quant-instantiations    12
;  :rlimit-count            120518)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))
  diz@30@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@37@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             348
;  :mk-clause               9
;  :num-allocs              3527705
;  :num-checks              42
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            120853)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               25
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             348
;  :mk-clause               9
;  :num-allocs              3527705
;  :num-checks              43
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            120866)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))))
  $Snap.unit))
; [eval] !diz.Main_controller.Controller_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@37@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               200
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               26
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             350
;  :mk-clause               9
;  :num-allocs              3527705
;  :num-checks              44
;  :propagations            15
;  :quant-instantiations    13
;  :rlimit-count            121155)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@06))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@36@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               208
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               27
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             353
;  :mk-clause               9
;  :num-allocs              3527705
;  :num-checks              45
;  :propagations            15
;  :quant-instantiations    14
;  :rlimit-count            121511)
(push) ; 3
(assert (not (< $Perm.No $k@37@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               208
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     11
;  :conflicts               28
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              4
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             353
;  :mk-clause               9
;  :num-allocs              3527705
;  :num-checks              46
;  :propagations            15
;  :quant-instantiations    14
;  :rlimit-count            121559
;  :time                    0.00)
(pop) ; 2
(push) ; 2
; [exec]
; var min_advance__31: Int
(declare-const min_advance__31@38@06 Int)
; [exec]
; var __flatten_30__29: Seq[Int]
(declare-const __flatten_30__29@39@06 Seq<Int>)
; [exec]
; var __flatten_31__30: Seq[Int]
(declare-const __flatten_31__30@40@06 Seq<Int>)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@41@06 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(assert (= $t@41@06 ($Snap.combine ($Snap.first $t@41@06) ($Snap.second $t@41@06))))
(assert (= ($Snap.first $t@41@06) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@41@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@41@06))
    ($Snap.second ($Snap.second $t@41@06)))))
(assert (= ($Snap.first ($Snap.second $t@41@06)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@41@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@41@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@41@06))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@41@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@42@06 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@42@06 | live]
; [else-branch: 0 | !(0 <= i@42@06) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@42@06]
(assert (<= 0 i@42@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@42@06)]
(assert (not (<= 0 i@42@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@42@06 < |First:(Second:(Second:(Second:($t@41@06))))| && 0 <= i@42@06 | live]
; [else-branch: 1 | !(i@42@06 < |First:(Second:(Second:(Second:($t@41@06))))| && 0 <= i@42@06) | live]
(push) ; 5
; [then-branch: 1 | i@42@06 < |First:(Second:(Second:(Second:($t@41@06))))| && 0 <= i@42@06]
(assert (and
  (<
    i@42@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))
  (<= 0 i@42@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@42@06 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               274
;  :arith-assert-diseq      6
;  :arith-assert-lower      16
;  :arith-assert-upper      12
;  :arith-eq-adapter        9
;  :binary-propagations     11
;  :conflicts               28
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              8
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             385
;  :mk-clause               15
;  :num-allocs              3527705
;  :num-checks              48
;  :propagations            17
;  :quant-instantiations    20
;  :rlimit-count            123273)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:($t@41@06))))[i@42@06] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:($t@41@06))))[i@42@06] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:($t@41@06))))[i@42@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
    i@42@06)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:($t@41@06))))[i@42@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
      i@42@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@42@06 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               274
;  :arith-assert-diseq      6
;  :arith-assert-lower      16
;  :arith-assert-upper      12
;  :arith-eq-adapter        9
;  :binary-propagations     11
;  :conflicts               28
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              8
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             386
;  :mk-clause               15
;  :num-allocs              3527705
;  :num-checks              49
;  :propagations            17
;  :quant-instantiations    20
;  :rlimit-count            123448)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@41@06))))[i@42@06] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@41@06))))[i@42@06]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@41@06))))[i@42@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
    i@42@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@42@06 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               274
;  :arith-assert-diseq      7
;  :arith-assert-lower      19
;  :arith-assert-upper      12
;  :arith-eq-adapter        10
;  :binary-propagations     11
;  :conflicts               28
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              8
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             389
;  :mk-clause               16
;  :num-allocs              3527705
;  :num-checks              50
;  :propagations            17
;  :quant-instantiations    20
;  :rlimit-count            123572)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@41@06))))[i@42@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
      i@42@06))))
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
; [else-branch: 1 | !(i@42@06 < |First:(Second:(Second:(Second:($t@41@06))))| && 0 <= i@42@06)]
(assert (not
  (and
    (<
      i@42@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))
    (<= 0 i@42@06))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@42@06 Int)) (!
  (implies
    (and
      (<
        i@42@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))
      (<= 0 i@42@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
          i@42@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
            i@42@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
            i@42@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
    i@42@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))
(declare-const $k@43@06 $Perm)
(assert ($Perm.isReadVar $k@43@06 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@43@06 $Perm.No) (< $Perm.No $k@43@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               279
;  :arith-assert-diseq      8
;  :arith-assert-lower      21
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :binary-propagations     11
;  :conflicts               29
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             395
;  :mk-clause               18
;  :num-allocs              3527705
;  :num-checks              51
;  :propagations            18
;  :quant-instantiations    20
;  :rlimit-count            124341)
(declare-const $t@44@06 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@33@06)
    (=
      $t@44@06
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@32@06)))))
  (implies
    (< $Perm.No $k@43@06)
    (=
      $t@44@06
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))))
(assert (<= $Perm.No (+ $k@33@06 $k@43@06)))
(assert (<= (+ $k@33@06 $k@43@06) $Perm.Write))
(assert (implies (< $Perm.No (+ $k@33@06 $k@43@06)) (not (= diz@30@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))
  $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@33@06 $k@43@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               289
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      15
;  :arith-conflicts         1
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               30
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             403
;  :mk-clause               18
;  :num-allocs              3527705
;  :num-checks              52
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            124946)
(assert (not (= $t@44@06 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@33@06 $k@43@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               295
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      16
;  :arith-conflicts         2
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               31
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             406
;  :mk-clause               18
;  :num-allocs              3527705
;  :num-checks              53
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            125252)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@33@06 $k@43@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               300
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      17
;  :arith-conflicts         3
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         3
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               32
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             408
;  :mk-clause               18
;  :num-allocs              3527705
;  :num-checks              54
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            125523)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@33@06 $k@43@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               305
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      18
;  :arith-conflicts         4
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         4
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               33
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             410
;  :mk-clause               18
;  :num-allocs              3527705
;  :num-checks              55
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            125804)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               305
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      18
;  :arith-conflicts         4
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         4
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               33
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             410
;  :mk-clause               18
;  :num-allocs              3527705
;  :num-checks              56
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            125817)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@32@06))) $t@44@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               305
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      18
;  :arith-conflicts         4
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         4
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               34
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             411
;  :mk-clause               18
;  :num-allocs              3527705
;  :num-checks              57
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            125907)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))))))))
(declare-const $k@45@06 $Perm)
(assert ($Perm.isReadVar $k@45@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@45@06 $Perm.No) (< $Perm.No $k@45@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               313
;  :arith-assert-diseq      9
;  :arith-assert-lower      24
;  :arith-assert-upper      19
;  :arith-conflicts         4
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         4
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               35
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.91
;  :mk-bool-var             418
;  :mk-clause               20
;  :num-allocs              3527705
;  :num-checks              58
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            126421)
(declare-const $t@46@06 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@34@06)
    (=
      $t@46@06
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))
  (implies
    (< $Perm.No $k@45@06)
    (=
      $t@46@06
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))))))))))
(assert (<= $Perm.No (+ $k@34@06 $k@45@06)))
(assert (<= (+ $k@34@06 $k@45@06) $Perm.Write))
(assert (implies (< $Perm.No (+ $k@34@06 $k@45@06)) (not (= diz@30@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@34@06 $k@45@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               323
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      21
;  :arith-conflicts         5
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         5
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               36
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             426
;  :mk-clause               20
;  :num-allocs              3656596
;  :num-checks              59
;  :propagations            19
;  :quant-instantiations    23
;  :rlimit-count            127126)
(assert (not (= $t@46@06 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@34@06 $k@45@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      22
;  :arith-conflicts         6
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         6
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               37
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             429
;  :mk-clause               20
;  :num-allocs              3656596
;  :num-checks              60
;  :propagations            19
;  :quant-instantiations    23
;  :rlimit-count            127480)
(push) ; 3
(assert (not (< $Perm.No (+ $k@34@06 $k@45@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      23
;  :arith-conflicts         7
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         7
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               38
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             430
;  :mk-clause               20
;  :num-allocs              3656596
;  :num-checks              61
;  :propagations            19
;  :quant-instantiations    23
;  :rlimit-count            127540)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      23
;  :arith-conflicts         7
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         7
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               38
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             430
;  :mk-clause               20
;  :num-allocs              3656596
;  :num-checks              62
;  :propagations            19
;  :quant-instantiations    23
;  :rlimit-count            127553)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
  $t@46@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      23
;  :arith-conflicts         7
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         7
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               39
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   15
;  :datatype-splits         6
;  :decisions               12
;  :del-clause              9
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             431
;  :mk-clause               20
;  :num-allocs              3656596
;  :num-checks              63
;  :propagations            19
;  :quant-instantiations    23
;  :rlimit-count            127703)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))))))))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@41@06 diz@30@06 globals@31@06))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@47@06 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; Sensor_forkOperator_EncodedGlobalVariables(diz.Main_sensor, globals)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@33@06 $k@43@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               424
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      24
;  :arith-conflicts         8
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              19
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             451
;  :mk-clause               21
;  :num-allocs              3656596
;  :num-checks              66
;  :propagations            20
;  :quant-instantiations    24
;  :rlimit-count            129122)
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
; (:added-eqs               424
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      24
;  :arith-conflicts         8
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               41
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              19
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             451
;  :mk-clause               21
;  :num-allocs              3656596
;  :num-checks              67
;  :propagations            20
;  :quant-instantiations    24
;  :rlimit-count            129135)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@32@06))) $t@44@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               424
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      24
;  :arith-conflicts         8
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               42
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              19
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             452
;  :mk-clause               21
;  :num-allocs              3656596
;  :num-checks              68
;  :propagations            20
;  :quant-instantiations    24
;  :rlimit-count            129225)
; [eval] diz.Sensor_m != null
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@32@06))) $t@44@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               424
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      24
;  :arith-conflicts         8
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              19
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             453
;  :mk-clause               21
;  :num-allocs              3656596
;  :num-checks              69
;  :propagations            20
;  :quant-instantiations    24
;  :rlimit-count            129315)
(set-option :timeout 0)
(push) ; 3
(assert (not (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))
    $Ref.null))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               424
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      24
;  :arith-conflicts         8
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               43
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              19
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             453
;  :mk-clause               21
;  :num-allocs              3656596
;  :num-checks              70
;  :propagations            20
;  :quant-instantiations    24
;  :rlimit-count            129333)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))
    $Ref.null)))
(declare-const $k@48@06 $Perm)
(assert ($Perm.isReadVar $k@48@06 $Perm.Write))
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@32@06))) $t@44@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               424
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      25
;  :arith-conflicts         8
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               44
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              19
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             458
;  :mk-clause               23
;  :num-allocs              3656596
;  :num-checks              71
;  :propagations            21
;  :quant-instantiations    24
;  :rlimit-count            129598)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@48@06 $Perm.No) (< $Perm.No $k@48@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               424
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      25
;  :arith-conflicts         8
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               45
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              19
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             458
;  :mk-clause               23
;  :num-allocs              3656596
;  :num-checks              72
;  :propagations            21
;  :quant-instantiations    24
;  :rlimit-count            129648)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@30@06
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               424
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      25
;  :arith-conflicts         8
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               45
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              19
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             458
;  :mk-clause               23
;  :num-allocs              3656596
;  :num-checks              73
;  :propagations            21
;  :quant-instantiations    24
;  :rlimit-count            129659)
(push) ; 3
(assert (not (not (= (+ $k@33@06 $k@43@06) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               425
;  :arith-assert-diseq      10
;  :arith-assert-lower      27
;  :arith-assert-upper      26
;  :arith-conflicts         9
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               46
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              21
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             460
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              74
;  :propagations            22
;  :quant-instantiations    24
;  :rlimit-count            129721)
(assert (< $k@48@06 (+ $k@33@06 $k@43@06)))
(assert (<= $Perm.No (- (+ $k@33@06 $k@43@06) $k@48@06)))
(assert (<= (- (+ $k@33@06 $k@43@06) $k@48@06) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@33@06 $k@43@06) $k@48@06))
  (not (= diz@30@06 $Ref.null))))
; [eval] diz.Sensor_m.Main_sensor == diz
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@32@06))) $t@44@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               425
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      27
;  :arith-conflicts         9
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               47
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              21
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             464
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              75
;  :propagations            22
;  :quant-instantiations    24
;  :rlimit-count            129980)
(push) ; 3
(assert (not (=
  diz@30@06
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               425
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      27
;  :arith-conflicts         9
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         8
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               47
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              21
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             464
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              76
;  :propagations            22
;  :quant-instantiations    24
;  :rlimit-count            129991)
(push) ; 3
(assert (not (< $Perm.No (+ $k@33@06 $k@43@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               425
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      28
;  :arith-conflicts         10
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         9
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               48
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              21
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             465
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              77
;  :propagations            22
;  :quant-instantiations    24
;  :rlimit-count            130054)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               425
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      28
;  :arith-conflicts         10
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         9
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               48
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              21
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             465
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              78
;  :propagations            22
;  :quant-instantiations    24
;  :rlimit-count            130067)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@32@06))) $t@44@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               425
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      28
;  :arith-conflicts         10
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         9
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               49
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   27
;  :datatype-splits         20
;  :decisions               37
;  :del-clause              21
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             466
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              79
;  :propagations            22
;  :quant-instantiations    24
;  :rlimit-count            130157)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               469
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      28
;  :arith-conflicts         10
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         9
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               49
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   33
;  :datatype-splits         27
;  :decisions               49
;  :del-clause              21
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             472
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              80
;  :propagations            23
;  :quant-instantiations    24
;  :rlimit-count            130706)
; [eval] !diz.Sensor_init
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@32@06))) $t@44@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               469
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      28
;  :arith-conflicts         10
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         9
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               50
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   33
;  :datatype-splits         27
;  :decisions               49
;  :del-clause              21
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             473
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              81
;  :propagations            23
;  :quant-instantiations    24
;  :rlimit-count            130796)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@32@06))) $t@44@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               469
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      28
;  :arith-conflicts         10
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         9
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   33
;  :datatype-splits         27
;  :decisions               49
;  :del-clause              21
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             474
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              82
;  :propagations            23
;  :quant-instantiations    24
;  :rlimit-count            130886)
(declare-const $t@49@06 $Snap)
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; Controller_forkOperator_EncodedGlobalVariables(diz.Main_controller, globals)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@34@06 $k@45@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               513
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      29
;  :arith-conflicts         11
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               52
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              23
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             481
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              84
;  :propagations            24
;  :quant-instantiations    24
;  :rlimit-count            131479)
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
; (:added-eqs               513
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      29
;  :arith-conflicts         11
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               52
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              23
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             481
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              85
;  :propagations            24
;  :quant-instantiations    24
;  :rlimit-count            131492)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
  $t@46@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               513
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      29
;  :arith-conflicts         11
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              23
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             482
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              86
;  :propagations            24
;  :quant-instantiations    24
;  :rlimit-count            131642)
; [eval] diz.Controller_m != null
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
  $t@46@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               513
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      29
;  :arith-conflicts         11
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               54
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              23
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             483
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              87
;  :propagations            24
;  :quant-instantiations    24
;  :rlimit-count            131792)
(set-option :timeout 0)
(push) ; 3
(assert (not (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))
    $Ref.null))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               513
;  :arith-add-rows          1
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      29
;  :arith-conflicts         11
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               54
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              23
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             483
;  :mk-clause               25
;  :num-allocs              3656596
;  :num-checks              88
;  :propagations            24
;  :quant-instantiations    24
;  :rlimit-count            131810)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))
    $Ref.null)))
(declare-const $k@50@06 $Perm)
(assert ($Perm.isReadVar $k@50@06 $Perm.Write))
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
  $t@46@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               513
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      30
;  :arith-conflicts         11
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               55
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              23
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             488
;  :mk-clause               27
;  :num-allocs              3656596
;  :num-checks              89
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            132134)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@50@06 $Perm.No) (< $Perm.No $k@50@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               513
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      30
;  :arith-conflicts         11
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               56
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              23
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             488
;  :mk-clause               27
;  :num-allocs              3656596
;  :num-checks              90
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            132184)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@30@06
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               513
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      30
;  :arith-conflicts         11
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               56
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              23
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             488
;  :mk-clause               27
;  :num-allocs              3656596
;  :num-checks              91
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            132195)
(push) ; 3
(assert (not (not (= (+ $k@34@06 $k@45@06) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               514
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      31
;  :arith-assert-upper      31
;  :arith-conflicts         12
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         10
;  :arith-pivots            1
;  :binary-propagations     11
;  :conflicts               57
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              25
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             490
;  :mk-clause               29
;  :num-allocs              3656596
;  :num-checks              92
;  :propagations            26
;  :quant-instantiations    24
;  :rlimit-count            132255)
(assert (< $k@50@06 (+ $k@34@06 $k@45@06)))
(assert (<= $Perm.No (- (+ $k@34@06 $k@45@06) $k@50@06)))
(assert (<= (- (+ $k@34@06 $k@45@06) $k@50@06) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@34@06 $k@45@06) $k@50@06))
  (not (= diz@30@06 $Ref.null))))
; [eval] diz.Controller_m.Main_controller == diz
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
  $t@46@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               514
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      32
;  :arith-conflicts         12
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         10
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               58
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              25
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             494
;  :mk-clause               29
;  :num-allocs              3656596
;  :num-checks              93
;  :propagations            26
;  :quant-instantiations    24
;  :rlimit-count            132580)
(push) ; 3
(assert (not (=
  diz@30@06
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               514
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      32
;  :arith-conflicts         12
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         10
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               58
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              25
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             494
;  :mk-clause               29
;  :num-allocs              3656596
;  :num-checks              94
;  :propagations            26
;  :quant-instantiations    24
;  :rlimit-count            132591)
(push) ; 3
(assert (not (< $Perm.No (+ $k@34@06 $k@45@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               514
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      33
;  :arith-conflicts         13
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               59
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              25
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             495
;  :mk-clause               29
;  :num-allocs              3656596
;  :num-checks              95
;  :propagations            26
;  :quant-instantiations    24
;  :rlimit-count            132651)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               514
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      33
;  :arith-conflicts         13
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               59
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              25
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             495
;  :mk-clause               29
;  :num-allocs              3656596
;  :num-checks              96
;  :propagations            26
;  :quant-instantiations    24
;  :rlimit-count            132664)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
  $t@46@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               514
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      33
;  :arith-conflicts         13
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               60
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   39
;  :datatype-splits         34
;  :decisions               61
;  :del-clause              25
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             496
;  :mk-clause               29
;  :num-allocs              3656596
;  :num-checks              97
;  :propagations            26
;  :quant-instantiations    24
;  :rlimit-count            132814)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               558
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      33
;  :arith-conflicts         13
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               60
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   45
;  :datatype-splits         41
;  :decisions               73
;  :del-clause              25
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             502
;  :mk-clause               29
;  :num-allocs              3656596
;  :num-checks              98
;  :propagations            27
;  :quant-instantiations    24
;  :rlimit-count            133369)
; [eval] !diz.Controller_init
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
  $t@46@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               558
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      33
;  :arith-conflicts         13
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               61
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   45
;  :datatype-splits         41
;  :decisions               73
;  :del-clause              25
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             503
;  :mk-clause               29
;  :num-allocs              3656596
;  :num-checks              99
;  :propagations            27
;  :quant-instantiations    24
;  :rlimit-count            133519)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
  $t@46@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               558
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      33
;  :arith-conflicts         13
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               62
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   45
;  :datatype-splits         41
;  :decisions               73
;  :del-clause              25
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             504
;  :mk-clause               29
;  :num-allocs              3656596
;  :num-checks              100
;  :propagations            27
;  :quant-instantiations    24
;  :rlimit-count            133669)
(declare-const $t@51@06 $Snap)
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
(declare-const i@52@06 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@52@06 | live]
; [else-branch: 4 | !(0 <= i@52@06) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@52@06]
(assert (<= 0 i@52@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@52@06)]
(assert (not (<= 0 i@52@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@52@06 < |First:(Second:(Second:(Second:($t@41@06))))| && 0 <= i@52@06 | live]
; [else-branch: 5 | !(i@52@06 < |First:(Second:(Second:(Second:($t@41@06))))| && 0 <= i@52@06) | live]
(push) ; 5
; [then-branch: 5 | i@52@06 < |First:(Second:(Second:(Second:($t@41@06))))| && 0 <= i@52@06]
(assert (and
  (<
    i@52@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))
  (<= 0 i@52@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@52@06 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      34
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               62
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              27
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             512
;  :mk-clause               29
;  :num-allocs              3656596
;  :num-checks              102
;  :propagations            28
;  :quant-instantiations    24
;  :rlimit-count            134344)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:($t@41@06))))[i@52@06] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@41@06))))[i@52@06] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@41@06))))[i@52@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
    i@52@06)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:($t@41@06))))[i@52@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
      i@52@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@52@06 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          1
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      35
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               62
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              27
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             518
;  :mk-clause               33
;  :num-allocs              3656596
;  :num-checks              103
;  :propagations            30
;  :quant-instantiations    25
;  :rlimit-count            134576)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@41@06))))[i@52@06] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@41@06))))[i@52@06]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@41@06))))[i@52@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
    i@52@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@52@06 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          1
;  :arith-assert-diseq      12
;  :arith-assert-lower      37
;  :arith-assert-upper      35
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               62
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              27
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             518
;  :mk-clause               33
;  :num-allocs              3656596
;  :num-checks              104
;  :propagations            30
;  :quant-instantiations    25
;  :rlimit-count            134690)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@41@06))))[i@52@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
      i@52@06))))
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
; [else-branch: 5 | !(i@52@06 < |First:(Second:(Second:(Second:($t@41@06))))| && 0 <= i@52@06)]
(assert (not
  (and
    (<
      i@52@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))
    (<= 0 i@52@06))))
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
(assert (not (forall ((i@52@06 Int)) (!
  (implies
    (and
      (<
        i@52@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))
      (<= 0 i@52@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
          i@52@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
            i@52@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
            i@52@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
    i@52@06))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          1
;  :arith-assert-diseq      14
;  :arith-assert-lower      38
;  :arith-assert-upper      36
;  :arith-conflicts         13
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               63
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             526
;  :mk-clause               47
;  :num-allocs              3656596
;  :num-checks              105
;  :propagations            32
;  :quant-instantiations    26
;  :rlimit-count            135136)
(assert (forall ((i@52@06 Int)) (!
  (implies
    (and
      (<
        i@52@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))
      (<= 0 i@52@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
          i@52@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
            i@52@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
            i@52@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))
    i@52@06))
  :qid |prog.l<no position>|)))
(declare-const $k@53@06 $Perm)
(assert ($Perm.isReadVar $k@53@06 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@53@06 $Perm.No) (< $Perm.No $k@53@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          1
;  :arith-assert-diseq      15
;  :arith-assert-lower      40
;  :arith-assert-upper      37
;  :arith-conflicts         13
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               64
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             531
;  :mk-clause               49
;  :num-allocs              3656596
;  :num-checks              106
;  :propagations            33
;  :quant-instantiations    26
;  :rlimit-count            135697)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- (+ $k@33@06 $k@43@06) $k@48@06) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          1
;  :arith-assert-diseq      15
;  :arith-assert-lower      40
;  :arith-assert-upper      37
;  :arith-conflicts         13
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             532
;  :mk-clause               49
;  :num-allocs              3656596
;  :num-checks              107
;  :propagations            33
;  :quant-instantiations    26
;  :rlimit-count            135771)
(assert (< $k@53@06 (- (+ $k@33@06 $k@43@06) $k@48@06)))
(assert (<= $Perm.No (- (- (+ $k@33@06 $k@43@06) $k@48@06) $k@53@06)))
(assert (<= (- (- (+ $k@33@06 $k@43@06) $k@48@06) $k@53@06) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- (+ $k@33@06 $k@43@06) $k@48@06) $k@53@06))
  (not (= diz@30@06 $Ref.null))))
; [eval] diz.Main_sensor != null
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@33@06 $k@43@06) $k@48@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      38
;  :arith-conflicts         13
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             535
;  :mk-clause               49
;  :num-allocs              3656596
;  :num-checks              108
;  :propagations            33
;  :quant-instantiations    26
;  :rlimit-count            135983)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@33@06 $k@43@06) $k@48@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      38
;  :arith-conflicts         13
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             535
;  :mk-clause               49
;  :num-allocs              3656596
;  :num-checks              109
;  :propagations            33
;  :quant-instantiations    26
;  :rlimit-count            136004)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@33@06 $k@43@06) $k@48@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      38
;  :arith-conflicts         13
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             535
;  :mk-clause               49
;  :num-allocs              3656596
;  :num-checks              110
;  :propagations            33
;  :quant-instantiations    26
;  :rlimit-count            136025)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      38
;  :arith-conflicts         13
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             535
;  :mk-clause               49
;  :num-allocs              3656596
;  :num-checks              111
;  :propagations            33
;  :quant-instantiations    26
;  :rlimit-count            136038)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@33@06 $k@43@06) $k@48@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      38
;  :arith-conflicts         13
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             535
;  :mk-clause               49
;  :num-allocs              3656596
;  :num-checks              112
;  :propagations            33
;  :quant-instantiations    26
;  :rlimit-count            136059)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@32@06))) $t@44@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      38
;  :arith-conflicts         13
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               66
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             536
;  :mk-clause               49
;  :num-allocs              3656596
;  :num-checks              113
;  :propagations            33
;  :quant-instantiations    26
;  :rlimit-count            136149)
(declare-const $k@54@06 $Perm)
(assert ($Perm.isReadVar $k@54@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@54@06 $Perm.No) (< $Perm.No $k@54@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               67
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             540
;  :mk-clause               51
;  :num-allocs              3656596
;  :num-checks              114
;  :propagations            34
;  :quant-instantiations    26
;  :rlimit-count            136348)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- (+ $k@34@06 $k@45@06) $k@50@06) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         11
;  :arith-pivots            2
;  :binary-propagations     11
;  :conflicts               68
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             541
;  :mk-clause               51
;  :num-allocs              3656596
;  :num-checks              115
;  :propagations            34
;  :quant-instantiations    26
;  :rlimit-count            136422)
(assert (< $k@54@06 (- (+ $k@34@06 $k@45@06) $k@50@06)))
(assert (<= $Perm.No (- (- (+ $k@34@06 $k@45@06) $k@50@06) $k@54@06)))
(assert (<= (- (- (+ $k@34@06 $k@45@06) $k@50@06) $k@54@06) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- (+ $k@34@06 $k@45@06) $k@50@06) $k@54@06))
  (not (= diz@30@06 $Ref.null))))
; [eval] diz.Main_controller != null
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@34@06 $k@45@06) $k@50@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          5
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               68
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             544
;  :mk-clause               51
;  :num-allocs              3656596
;  :num-checks              116
;  :propagations            34
;  :quant-instantiations    26
;  :rlimit-count            136684)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@34@06 $k@45@06) $k@50@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          5
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               68
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             544
;  :mk-clause               51
;  :num-allocs              3656596
;  :num-checks              117
;  :propagations            34
;  :quant-instantiations    26
;  :rlimit-count            136705)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          5
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               68
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             544
;  :mk-clause               51
;  :num-allocs              3656596
;  :num-checks              118
;  :propagations            34
;  :quant-instantiations    26
;  :rlimit-count            136718)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@34@06 $k@45@06) $k@50@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          5
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               68
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             544
;  :mk-clause               51
;  :num-allocs              3656596
;  :num-checks              119
;  :propagations            34
;  :quant-instantiations    26
;  :rlimit-count            136739)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
  $t@46@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               602
;  :arith-add-rows          5
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               69
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   51
;  :datatype-splits         48
;  :decisions               85
;  :del-clause              45
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             545
;  :mk-clause               51
;  :num-allocs              3656596
;  :num-checks              120
;  :propagations            34
;  :quant-instantiations    26
;  :rlimit-count            136889)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@06))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($SortWrappers.$RefTo$Snap $t@44@06)
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))
                          ($Snap.combine
                            ($SortWrappers.$RefTo$Snap $t@46@06)
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@06))))))))))))))))
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))))))))))))))))))))) diz@30@06 globals@31@06))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const min_advance__31@55@06 Int)
(declare-const __flatten_31__30@56@06 Seq<Int>)
(declare-const __flatten_30__29@57@06 Seq<Int>)
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
; (:added-eqs               787
;  :arith-add-rows          5
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               69
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 130
;  :datatype-occurs-check   69
;  :datatype-splits         69
;  :decisions               121
;  :del-clause              45
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             564
;  :mk-clause               51
;  :num-allocs              3795540
;  :num-checks              123
;  :propagations            37
;  :quant-instantiations    26
;  :rlimit-count            139337)
; [then-branch: 8 | True | live]
; [else-branch: 8 | False | dead]
(push) ; 5
; [then-branch: 8 | True]
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@58@06 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(assert (= $t@58@06 ($Snap.combine ($Snap.first $t@58@06) ($Snap.second $t@58@06))))
(assert (= ($Snap.first $t@58@06) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@58@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@58@06))
    ($Snap.second ($Snap.second $t@58@06)))))
(assert (= ($Snap.first ($Snap.second $t@58@06)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@58@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@58@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@58@06))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@58@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@59@06 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 9 | 0 <= i@59@06 | live]
; [else-branch: 9 | !(0 <= i@59@06) | live]
(push) ; 8
; [then-branch: 9 | 0 <= i@59@06]
(assert (<= 0 i@59@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 9 | !(0 <= i@59@06)]
(assert (not (<= 0 i@59@06)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 10 | i@59@06 < |First:(Second:(Second:(Second:($t@58@06))))| && 0 <= i@59@06 | live]
; [else-branch: 10 | !(i@59@06 < |First:(Second:(Second:(Second:($t@58@06))))| && 0 <= i@59@06) | live]
(push) ; 8
; [then-branch: 10 | i@59@06 < |First:(Second:(Second:(Second:($t@58@06))))| && 0 <= i@59@06]
(assert (and
  (<
    i@59@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
  (<= 0 i@59@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@59@06 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               881
;  :arith-add-rows          5
;  :arith-assert-diseq      16
;  :arith-assert-lower      51
;  :arith-assert-upper      43
;  :arith-conflicts         13
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               69
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              45
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             596
;  :mk-clause               51
;  :num-allocs              3795540
;  :num-checks              125
;  :propagations            38
;  :quant-instantiations    30
;  :rlimit-count            141198)
; [eval] -1
(push) ; 9
; [then-branch: 11 | First:(Second:(Second:(Second:($t@58@06))))[i@59@06] == -1 | live]
; [else-branch: 11 | First:(Second:(Second:(Second:($t@58@06))))[i@59@06] != -1 | live]
(push) ; 10
; [then-branch: 11 | First:(Second:(Second:(Second:($t@58@06))))[i@59@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    i@59@06)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 11 | First:(Second:(Second:(Second:($t@58@06))))[i@59@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
      i@59@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@59@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               881
;  :arith-add-rows          5
;  :arith-assert-diseq      16
;  :arith-assert-lower      51
;  :arith-assert-upper      43
;  :arith-conflicts         13
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               69
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              45
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             597
;  :mk-clause               51
;  :num-allocs              3795540
;  :num-checks              126
;  :propagations            38
;  :quant-instantiations    30
;  :rlimit-count            141373)
(push) ; 11
; [then-branch: 12 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[i@59@06] | live]
; [else-branch: 12 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[i@59@06]) | live]
(push) ; 12
; [then-branch: 12 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[i@59@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    i@59@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@59@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               881
;  :arith-add-rows          5
;  :arith-assert-diseq      17
;  :arith-assert-lower      54
;  :arith-assert-upper      43
;  :arith-conflicts         13
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               69
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              45
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             600
;  :mk-clause               52
;  :num-allocs              3795540
;  :num-checks              127
;  :propagations            38
;  :quant-instantiations    30
;  :rlimit-count            141497)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 12 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[i@59@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
      i@59@06))))
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
; [else-branch: 10 | !(i@59@06 < |First:(Second:(Second:(Second:($t@58@06))))| && 0 <= i@59@06)]
(assert (not
  (and
    (<
      i@59@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
    (<= 0 i@59@06))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@59@06 Int)) (!
  (implies
    (and
      (<
        i@59@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
      (<= 0 i@59@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          i@59@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
            i@59@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
            i@59@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    i@59@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))
(declare-const $k@60@06 $Perm)
(assert ($Perm.isReadVar $k@60@06 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@60@06 $Perm.No) (< $Perm.No $k@60@06))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               886
;  :arith-add-rows          5
;  :arith-assert-diseq      18
;  :arith-assert-lower      56
;  :arith-assert-upper      44
;  :arith-conflicts         13
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               70
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              46
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             606
;  :mk-clause               54
;  :num-allocs              3795540
;  :num-checks              128
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            142265)
(assert (<= $Perm.No $k@60@06))
(assert (<= $k@60@06 $Perm.Write))
(assert (implies (< $Perm.No $k@60@06) (not (= diz@30@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))
  $Snap.unit))
; [eval] diz.Main_sensor != null
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               892
;  :arith-add-rows          5
;  :arith-assert-diseq      18
;  :arith-assert-lower      56
;  :arith-assert-upper      45
;  :arith-conflicts         13
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               71
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              46
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             609
;  :mk-clause               54
;  :num-allocs              3795540
;  :num-checks              129
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            142588)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               898
;  :arith-add-rows          5
;  :arith-assert-diseq      18
;  :arith-assert-lower      56
;  :arith-assert-upper      45
;  :arith-conflicts         13
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               72
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              46
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             612
;  :mk-clause               54
;  :num-allocs              3795540
;  :num-checks              130
;  :propagations            39
;  :quant-instantiations    31
;  :rlimit-count            142944)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               903
;  :arith-add-rows          5
;  :arith-assert-diseq      18
;  :arith-assert-lower      56
;  :arith-assert-upper      45
;  :arith-conflicts         13
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               73
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              46
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             613
;  :mk-clause               54
;  :num-allocs              3795540
;  :num-checks              131
;  :propagations            39
;  :quant-instantiations    31
;  :rlimit-count            143201)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               908
;  :arith-add-rows          5
;  :arith-assert-diseq      18
;  :arith-assert-lower      56
;  :arith-assert-upper      45
;  :arith-conflicts         13
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               74
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              46
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             614
;  :mk-clause               54
;  :num-allocs              3795540
;  :num-checks              132
;  :propagations            39
;  :quant-instantiations    31
;  :rlimit-count            143468)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               908
;  :arith-add-rows          5
;  :arith-assert-diseq      18
;  :arith-assert-lower      56
;  :arith-assert-upper      45
;  :arith-conflicts         13
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               74
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              46
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             614
;  :mk-clause               54
;  :num-allocs              3795540
;  :num-checks              133
;  :propagations            39
;  :quant-instantiations    31
;  :rlimit-count            143481)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))))))
(declare-const $k@61@06 $Perm)
(assert ($Perm.isReadVar $k@61@06 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@61@06 $Perm.No) (< $Perm.No $k@61@06))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               913
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      46
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               75
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              46
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             619
;  :mk-clause               56
;  :num-allocs              3795540
;  :num-checks              134
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            143902)
(assert (<= $Perm.No $k@61@06))
(assert (<= $k@61@06 $Perm.Write))
(assert (implies (< $Perm.No $k@61@06) (not (= diz@30@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))))
  $Snap.unit))
; [eval] diz.Main_controller != null
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               919
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      47
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               76
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              46
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             622
;  :mk-clause               56
;  :num-allocs              3795540
;  :num-checks              135
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            144275)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               925
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      47
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               77
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              46
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             625
;  :mk-clause               56
;  :num-allocs              3795540
;  :num-checks              136
;  :propagations            40
;  :quant-instantiations    32
;  :rlimit-count            144685)
(push) ; 6
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               925
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      47
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               78
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              46
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             625
;  :mk-clause               56
;  :num-allocs              3795540
;  :num-checks              137
;  :propagations            40
;  :quant-instantiations    32
;  :rlimit-count            144733)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               925
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      47
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               78
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 143
;  :datatype-occurs-check   75
;  :datatype-splits         76
;  :decisions               133
;  :del-clause              46
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             625
;  :mk-clause               56
;  :num-allocs              3795540
;  :num-checks              138
;  :propagations            40
;  :quant-instantiations    32
;  :rlimit-count            144746)
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@58@06 diz@30@06 globals@31@06))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@62@06 $Snap)
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
(declare-const i@63@06 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 13 | 0 <= i@63@06 | live]
; [else-branch: 13 | !(0 <= i@63@06) | live]
(push) ; 8
; [then-branch: 13 | 0 <= i@63@06]
(assert (<= 0 i@63@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 13 | !(0 <= i@63@06)]
(assert (not (<= 0 i@63@06)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 14 | i@63@06 < |First:(Second:(Second:(Second:($t@58@06))))| && 0 <= i@63@06 | live]
; [else-branch: 14 | !(i@63@06 < |First:(Second:(Second:(Second:($t@58@06))))| && 0 <= i@63@06) | live]
(push) ; 8
; [then-branch: 14 | i@63@06 < |First:(Second:(Second:(Second:($t@58@06))))| && 0 <= i@63@06]
(assert (and
  (<
    i@63@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
  (<= 0 i@63@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@63@06 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1133
;  :arith-add-rows          5
;  :arith-assert-diseq      19
;  :arith-assert-lower      59
;  :arith-assert-upper      48
;  :arith-conflicts         13
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               79
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   91
;  :datatype-splits         112
;  :decisions               182
;  :del-clause              50
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             664
;  :mk-clause               57
;  :num-allocs              3940295
;  :num-checks              141
;  :propagations            43
;  :quant-instantiations    32
;  :rlimit-count            146494)
; [eval] -1
(push) ; 9
; [then-branch: 15 | First:(Second:(Second:(Second:($t@58@06))))[i@63@06] == -1 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:($t@58@06))))[i@63@06] != -1 | live]
(push) ; 10
; [then-branch: 15 | First:(Second:(Second:(Second:($t@58@06))))[i@63@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    i@63@06)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 15 | First:(Second:(Second:(Second:($t@58@06))))[i@63@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
      i@63@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@63@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1133
;  :arith-add-rows          5
;  :arith-assert-diseq      20
;  :arith-assert-lower      62
;  :arith-assert-upper      49
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               79
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   91
;  :datatype-splits         112
;  :decisions               182
;  :del-clause              50
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             670
;  :mk-clause               61
;  :num-allocs              3940295
;  :num-checks              142
;  :propagations            45
;  :quant-instantiations    33
;  :rlimit-count            146726)
(push) ; 11
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[i@63@06] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[i@63@06]) | live]
(push) ; 12
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[i@63@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    i@63@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@63@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1133
;  :arith-add-rows          5
;  :arith-assert-diseq      20
;  :arith-assert-lower      62
;  :arith-assert-upper      49
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               79
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   91
;  :datatype-splits         112
;  :decisions               182
;  :del-clause              50
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             670
;  :mk-clause               61
;  :num-allocs              3940295
;  :num-checks              143
;  :propagations            45
;  :quant-instantiations    33
;  :rlimit-count            146840)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[i@63@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
      i@63@06))))
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
; [else-branch: 14 | !(i@63@06 < |First:(Second:(Second:(Second:($t@58@06))))| && 0 <= i@63@06)]
(assert (not
  (and
    (<
      i@63@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
    (<= 0 i@63@06))))
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
(assert (not (forall ((i@63@06 Int)) (!
  (implies
    (and
      (<
        i@63@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
      (<= 0 i@63@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          i@63@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
            i@63@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
            i@63@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    i@63@06))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1133
;  :arith-add-rows          5
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      50
;  :arith-conflicts         13
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   91
;  :datatype-splits         112
;  :decisions               182
;  :del-clause              68
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             678
;  :mk-clause               75
;  :num-allocs              3940295
;  :num-checks              144
;  :propagations            47
;  :quant-instantiations    34
;  :rlimit-count            147286)
(assert (forall ((i@63@06 Int)) (!
  (implies
    (and
      (<
        i@63@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
      (<= 0 i@63@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          i@63@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
            i@63@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
            i@63@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    i@63@06))
  :qid |prog.l<no position>|)))
(declare-const $t@64@06 $Snap)
(assert (= $t@64@06 ($Snap.combine ($Snap.first $t@64@06) ($Snap.second $t@64@06))))
(assert (=
  ($Snap.second $t@64@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@64@06))
    ($Snap.second ($Snap.second $t@64@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@64@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@64@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@64@06))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@64@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@65@06 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 17 | 0 <= i@65@06 | live]
; [else-branch: 17 | !(0 <= i@65@06) | live]
(push) ; 8
; [then-branch: 17 | 0 <= i@65@06]
(assert (<= 0 i@65@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 17 | !(0 <= i@65@06)]
(assert (not (<= 0 i@65@06)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 18 | i@65@06 < |First:(Second:($t@64@06))| && 0 <= i@65@06 | live]
; [else-branch: 18 | !(i@65@06 < |First:(Second:($t@64@06))| && 0 <= i@65@06) | live]
(push) ; 8
; [then-branch: 18 | i@65@06 < |First:(Second:($t@64@06))| && 0 <= i@65@06]
(assert (and
  (<
    i@65@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))
  (<= 0 i@65@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@65@06 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1170
;  :arith-add-rows          5
;  :arith-assert-diseq      22
;  :arith-assert-lower      68
;  :arith-assert-upper      53
;  :arith-conflicts         13
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   91
;  :datatype-splits         112
;  :decisions               182
;  :del-clause              68
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             700
;  :mk-clause               75
;  :num-allocs              3940295
;  :num-checks              145
;  :propagations            47
;  :quant-instantiations    38
;  :rlimit-count            148713)
; [eval] -1
(push) ; 9
; [then-branch: 19 | First:(Second:($t@64@06))[i@65@06] == -1 | live]
; [else-branch: 19 | First:(Second:($t@64@06))[i@65@06] != -1 | live]
(push) ; 10
; [then-branch: 19 | First:(Second:($t@64@06))[i@65@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
    i@65@06)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 19 | First:(Second:($t@64@06))[i@65@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
      i@65@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@65@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1170
;  :arith-add-rows          5
;  :arith-assert-diseq      22
;  :arith-assert-lower      68
;  :arith-assert-upper      53
;  :arith-conflicts         13
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   91
;  :datatype-splits         112
;  :decisions               182
;  :del-clause              68
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             701
;  :mk-clause               75
;  :num-allocs              3940295
;  :num-checks              146
;  :propagations            47
;  :quant-instantiations    38
;  :rlimit-count            148864)
(push) ; 11
; [then-branch: 20 | 0 <= First:(Second:($t@64@06))[i@65@06] | live]
; [else-branch: 20 | !(0 <= First:(Second:($t@64@06))[i@65@06]) | live]
(push) ; 12
; [then-branch: 20 | 0 <= First:(Second:($t@64@06))[i@65@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
    i@65@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@65@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1170
;  :arith-add-rows          5
;  :arith-assert-diseq      23
;  :arith-assert-lower      71
;  :arith-assert-upper      53
;  :arith-conflicts         13
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   91
;  :datatype-splits         112
;  :decisions               182
;  :del-clause              68
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             704
;  :mk-clause               76
;  :num-allocs              3940295
;  :num-checks              147
;  :propagations            47
;  :quant-instantiations    38
;  :rlimit-count            148968)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 20 | !(0 <= First:(Second:($t@64@06))[i@65@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
      i@65@06))))
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
; [else-branch: 18 | !(i@65@06 < |First:(Second:($t@64@06))| && 0 <= i@65@06)]
(assert (not
  (and
    (<
      i@65@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))
    (<= 0 i@65@06))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@65@06 Int)) (!
  (implies
    (and
      (<
        i@65@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))
      (<= 0 i@65@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
          i@65@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
            i@65@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
            i@65@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
    i@65@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1188
;  :arith-add-rows          5
;  :arith-assert-diseq      23
;  :arith-assert-lower      72
;  :arith-assert-upper      54
;  :arith-conflicts         13
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         12
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   91
;  :datatype-splits         112
;  :decisions               182
;  :del-clause              69
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             724
;  :mk-clause               86
;  :num-allocs              3940295
;  :num-checks              148
;  :propagations            51
;  :quant-instantiations    40
;  :rlimit-count            150041)
(push) ; 6
; [then-branch: 21 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[0] | live]
; [else-branch: 21 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[0]) | live]
(push) ; 7
; [then-branch: 21 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1188
;  :arith-add-rows          5
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      54
;  :arith-conflicts         13
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         12
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   91
;  :datatype-splits         112
;  :decisions               182
;  :del-clause              69
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             730
;  :mk-clause               93
;  :num-allocs              3940295
;  :num-checks              149
;  :propagations            51
;  :quant-instantiations    42
;  :rlimit-count            150238)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1188
;  :arith-add-rows          5
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      54
;  :arith-conflicts         13
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         12
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               80
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   91
;  :datatype-splits         112
;  :decisions               182
;  :del-clause              69
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             730
;  :mk-clause               93
;  :num-allocs              3940295
;  :num-checks              150
;  :propagations            51
;  :quant-instantiations    42
;  :rlimit-count            150247)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1189
;  :arith-add-rows          5
;  :arith-assert-diseq      23
;  :arith-assert-lower      74
;  :arith-assert-upper      55
;  :arith-conflicts         14
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         12
;  :arith-pivots            4
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   91
;  :datatype-splits         112
;  :decisions               182
;  :del-clause              69
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             730
;  :mk-clause               93
;  :num-allocs              3940295
;  :num-checks              151
;  :propagations            55
;  :quant-instantiations    42
;  :rlimit-count            150364)
(pop) ; 7
(push) ; 7
; [else-branch: 21 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        0))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1304
;  :arith-add-rows          5
;  :arith-assert-diseq      26
;  :arith-assert-lower      85
;  :arith-assert-upper      60
;  :arith-conflicts         14
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         14
;  :arith-pivots            8
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 223
;  :datatype-occurs-check   102
;  :datatype-splits         133
;  :decisions               207
;  :del-clause              91
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             776
;  :mk-clause               108
;  :num-allocs              4088500
;  :num-checks              152
;  :propagations            64
;  :quant-instantiations    47
;  :rlimit-count            151672
;  :time                    0.00)
(push) ; 7
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
      0)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1418
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      96
;  :arith-assert-upper      65
;  :arith-conflicts         14
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         16
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   113
;  :datatype-splits         154
;  :decisions               234
;  :del-clause              119
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             822
;  :mk-clause               136
;  :num-allocs              4088500
;  :num-checks              153
;  :propagations            77
;  :quant-instantiations    52
;  :rlimit-count            152953
;  :time                    0.00)
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[0] | live]
; [else-branch: 22 | !(First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[0]) | live]
(push) ; 7
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1419
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      97
;  :arith-assert-upper      65
;  :arith-conflicts         14
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         16
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   113
;  :datatype-splits         154
;  :decisions               234
;  :del-clause              119
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             829
;  :mk-clause               143
;  :num-allocs              4088500
;  :num-checks              154
;  :propagations            77
;  :quant-instantiations    54
;  :rlimit-count            153170)
; [eval] -1
(pop) ; 7
(push) ; 7
; [else-branch: 22 | !(First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        0)))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1425
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      97
;  :arith-assert-upper      65
;  :arith-conflicts         14
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         16
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   113
;  :datatype-splits         154
;  :decisions               234
;  :del-clause              126
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             834
;  :mk-clause               144
;  :num-allocs              4088500
;  :num-checks              155
;  :propagations            77
;  :quant-instantiations    54
;  :rlimit-count            153675)
(push) ; 6
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[1] | live]
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[1]) | live]
(push) ; 7
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1425
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      98
;  :arith-assert-upper      65
;  :arith-conflicts         14
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         16
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   113
;  :datatype-splits         154
;  :decisions               234
;  :del-clause              126
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             840
;  :mk-clause               151
;  :num-allocs              4088500
;  :num-checks              156
;  :propagations            77
;  :quant-instantiations    56
;  :rlimit-count            153872)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1425
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      98
;  :arith-assert-upper      65
;  :arith-conflicts         14
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         16
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               81
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   113
;  :datatype-splits         154
;  :decisions               234
;  :del-clause              126
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             840
;  :mk-clause               151
;  :num-allocs              4088500
;  :num-checks              157
;  :propagations            77
;  :quant-instantiations    56
;  :rlimit-count            153881)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1426
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      99
;  :arith-assert-upper      66
;  :arith-conflicts         15
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         16
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               82
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   113
;  :datatype-splits         154
;  :decisions               234
;  :del-clause              126
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             840
;  :mk-clause               151
;  :num-allocs              4088500
;  :num-checks              158
;  :propagations            81
;  :quant-instantiations    56
;  :rlimit-count            153998)
(pop) ; 7
(push) ; 7
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        1))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1555
;  :arith-add-rows          14
;  :arith-assert-diseq      37
;  :arith-assert-lower      126
;  :arith-assert-upper      78
;  :arith-conflicts         15
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        2
;  :arith-pivots            22
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 277
;  :datatype-occurs-check   124
;  :datatype-splits         175
;  :decisions               265
;  :del-clause              188
;  :final-checks            59
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             919
;  :mk-clause               206
;  :num-allocs              4088500
;  :num-checks              159
;  :propagations            109
;  :quant-instantiations    66
;  :rlimit-count            155749
;  :time                    0.00)
(push) ; 7
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
      1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1671
;  :arith-add-rows          14
;  :arith-assert-diseq      40
;  :arith-assert-lower      137
;  :arith-assert-upper      86
;  :arith-conflicts         15
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            24
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 304
;  :datatype-occurs-check   135
;  :datatype-splits         196
;  :decisions               294
;  :del-clause              218
;  :final-checks            63
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             970
;  :mk-clause               236
;  :num-allocs              4088500
;  :num-checks              160
;  :propagations            123
;  :quant-instantiations    73
;  :rlimit-count            157123
;  :time                    0.00)
; [then-branch: 24 | First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[1] | live]
; [else-branch: 24 | !(First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[1]) | live]
(push) ; 7
; [then-branch: 24 | First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[1]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
      1))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1672
;  :arith-add-rows          14
;  :arith-assert-diseq      40
;  :arith-assert-lower      138
;  :arith-assert-upper      86
;  :arith-conflicts         15
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            24
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 304
;  :datatype-occurs-check   135
;  :datatype-splits         196
;  :decisions               294
;  :del-clause              218
;  :final-checks            63
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             977
;  :mk-clause               243
;  :num-allocs              4088500
;  :num-checks              161
;  :propagations            123
;  :quant-instantiations    75
;  :rlimit-count            157331)
; [eval] -1
(pop) ; 7
(push) ; 7
; [else-branch: 24 | !(First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[1])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        1)))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
      1)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1678
;  :arith-add-rows          14
;  :arith-assert-diseq      40
;  :arith-assert-lower      138
;  :arith-assert-upper      86
;  :arith-conflicts         15
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            24
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 304
;  :datatype-occurs-check   135
;  :datatype-splits         196
;  :decisions               294
;  :del-clause              225
;  :final-checks            63
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             982
;  :mk-clause               244
;  :num-allocs              4088500
;  :num-checks              162
;  :propagations            123
;  :quant-instantiations    75
;  :rlimit-count            157846)
(push) ; 6
; [then-branch: 25 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[0] | live]
; [else-branch: 25 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[0]) | live]
(push) ; 7
; [then-branch: 25 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1678
;  :arith-add-rows          14
;  :arith-assert-diseq      40
;  :arith-assert-lower      139
;  :arith-assert-upper      86
;  :arith-conflicts         15
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            24
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 304
;  :datatype-occurs-check   135
;  :datatype-splits         196
;  :decisions               294
;  :del-clause              225
;  :final-checks            63
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             987
;  :mk-clause               251
;  :num-allocs              4088500
;  :num-checks              163
;  :propagations            123
;  :quant-instantiations    77
;  :rlimit-count            157975)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1678
;  :arith-add-rows          14
;  :arith-assert-diseq      40
;  :arith-assert-lower      139
;  :arith-assert-upper      86
;  :arith-conflicts         15
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            24
;  :binary-propagations     11
;  :conflicts               83
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 304
;  :datatype-occurs-check   135
;  :datatype-splits         196
;  :decisions               294
;  :del-clause              225
;  :final-checks            63
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             987
;  :mk-clause               251
;  :num-allocs              4088500
;  :num-checks              164
;  :propagations            123
;  :quant-instantiations    77
;  :rlimit-count            157984)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1679
;  :arith-add-rows          14
;  :arith-assert-diseq      40
;  :arith-assert-lower      140
;  :arith-assert-upper      87
;  :arith-conflicts         16
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        2
;  :arith-pivots            24
;  :binary-propagations     11
;  :conflicts               84
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 304
;  :datatype-occurs-check   135
;  :datatype-splits         196
;  :decisions               294
;  :del-clause              225
;  :final-checks            63
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             987
;  :mk-clause               251
;  :num-allocs              4088500
;  :num-checks              165
;  :propagations            127
;  :quant-instantiations    77
;  :rlimit-count            158102)
(pop) ; 7
(push) ; 7
; [else-branch: 25 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
      0)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1797
;  :arith-add-rows          15
;  :arith-assert-diseq      43
;  :arith-assert-lower      152
;  :arith-assert-upper      94
;  :arith-conflicts         16
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        2
;  :arith-pivots            28
;  :binary-propagations     11
;  :conflicts               84
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 331
;  :datatype-occurs-check   146
;  :datatype-splits         217
;  :decisions               322
;  :del-clause              261
;  :final-checks            66
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             1035
;  :mk-clause               280
;  :num-allocs              4088500
;  :num-checks              166
;  :propagations            140
;  :quant-instantiations    84
;  :rlimit-count            159497
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        0))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1966
;  :arith-add-rows          15
;  :arith-assert-diseq      45
;  :arith-assert-lower      160
;  :arith-assert-upper      99
;  :arith-conflicts         16
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            30
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 372
;  :datatype-occurs-check   160
;  :datatype-splits         242
;  :decisions               360
;  :del-clause              274
;  :final-checks            70
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             1092
;  :mk-clause               293
;  :num-allocs              4088500
;  :num-checks              167
;  :propagations            148
;  :quant-instantiations    90
;  :rlimit-count            160978
;  :time                    0.00)
; [then-branch: 26 | !(First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[0]) | live]
; [else-branch: 26 | First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[0] | live]
(push) ; 7
; [then-branch: 26 | !(First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1966
;  :arith-add-rows          15
;  :arith-assert-diseq      45
;  :arith-assert-lower      160
;  :arith-assert-upper      99
;  :arith-conflicts         16
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            30
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 372
;  :datatype-occurs-check   160
;  :datatype-splits         242
;  :decisions               360
;  :del-clause              274
;  :final-checks            70
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             1092
;  :mk-clause               294
;  :num-allocs              4088500
;  :num-checks              168
;  :propagations            148
;  :quant-instantiations    90
;  :rlimit-count            161177)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1966
;  :arith-add-rows          15
;  :arith-assert-diseq      45
;  :arith-assert-lower      160
;  :arith-assert-upper      99
;  :arith-conflicts         16
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            30
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 372
;  :datatype-occurs-check   160
;  :datatype-splits         242
;  :decisions               360
;  :del-clause              274
;  :final-checks            70
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             1092
;  :mk-clause               294
;  :num-allocs              4088500
;  :num-checks              169
;  :propagations            148
;  :quant-instantiations    90
;  :rlimit-count            161192)
(pop) ; 7
(push) ; 7
; [else-branch: 26 | First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
            0))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1967
;  :arith-add-rows          15
;  :arith-assert-diseq      45
;  :arith-assert-lower      160
;  :arith-assert-upper      99
;  :arith-conflicts         16
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            30
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 372
;  :datatype-occurs-check   160
;  :datatype-splits         242
;  :decisions               360
;  :del-clause              275
;  :final-checks            70
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             1095
;  :mk-clause               298
;  :num-allocs              4088500
;  :num-checks              170
;  :propagations            148
;  :quant-instantiations    90
;  :rlimit-count            161610)
(push) ; 6
; [then-branch: 27 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[1] | live]
; [else-branch: 27 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[1]) | live]
(push) ; 7
; [then-branch: 27 | 0 <= First:(Second:(Second:(Second:($t@58@06))))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1967
;  :arith-add-rows          15
;  :arith-assert-diseq      45
;  :arith-assert-lower      161
;  :arith-assert-upper      99
;  :arith-conflicts         16
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            30
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 372
;  :datatype-occurs-check   160
;  :datatype-splits         242
;  :decisions               360
;  :del-clause              275
;  :final-checks            70
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             1100
;  :mk-clause               305
;  :num-allocs              4088500
;  :num-checks              171
;  :propagations            148
;  :quant-instantiations    92
;  :rlimit-count            161740)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1967
;  :arith-add-rows          15
;  :arith-assert-diseq      45
;  :arith-assert-lower      161
;  :arith-assert-upper      99
;  :arith-conflicts         16
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            30
;  :binary-propagations     11
;  :conflicts               86
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 372
;  :datatype-occurs-check   160
;  :datatype-splits         242
;  :decisions               360
;  :del-clause              275
;  :final-checks            70
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             1100
;  :mk-clause               305
;  :num-allocs              4088500
;  :num-checks              172
;  :propagations            148
;  :quant-instantiations    92
;  :rlimit-count            161749)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
    1)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1968
;  :arith-add-rows          15
;  :arith-assert-diseq      45
;  :arith-assert-lower      162
;  :arith-assert-upper      100
;  :arith-conflicts         17
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        2
;  :arith-pivots            30
;  :binary-propagations     11
;  :conflicts               87
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 372
;  :datatype-occurs-check   160
;  :datatype-splits         242
;  :decisions               360
;  :del-clause              275
;  :final-checks            70
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             1100
;  :mk-clause               305
;  :num-allocs              4088500
;  :num-checks              173
;  :propagations            152
;  :quant-instantiations    92
;  :rlimit-count            161867)
(pop) ; 7
(push) ; 7
; [else-branch: 27 | !(0 <= First:(Second:(Second:(Second:($t@58@06))))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
      1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2084
;  :arith-add-rows          17
;  :arith-assert-diseq      48
;  :arith-assert-lower      174
;  :arith-assert-upper      107
;  :arith-bound-prop        4
;  :arith-conflicts         17
;  :arith-eq-adapter        86
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        2
;  :arith-pivots            34
;  :binary-propagations     11
;  :conflicts               87
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 398
;  :datatype-occurs-check   171
;  :datatype-splits         262
;  :decisions               387
;  :del-clause              316
;  :final-checks            73
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             1155
;  :mk-clause               339
;  :num-allocs              4088500
;  :num-checks              174
;  :propagations            164
;  :quant-instantiations    99
;  :rlimit-count            163274
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        1))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2259
;  :arith-add-rows          19
;  :arith-assert-diseq      53
;  :arith-assert-lower      193
;  :arith-assert-upper      116
;  :arith-bound-prop        8
;  :arith-conflicts         17
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        2
;  :arith-pivots            40
;  :binary-propagations     11
;  :conflicts               89
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 438
;  :datatype-occurs-check   185
;  :datatype-splits         286
;  :decisions               426
;  :del-clause              365
;  :final-checks            78
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1242
;  :mk-clause               388
;  :num-allocs              4246537
;  :num-checks              175
;  :propagations            182
;  :quant-instantiations    108
;  :rlimit-count            164956
;  :time                    0.00)
; [then-branch: 28 | !(First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[1]) | live]
; [else-branch: 28 | First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[1] | live]
(push) ; 7
; [then-branch: 28 | !(First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[1])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          1))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        1)))))
; [eval] diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2259
;  :arith-add-rows          19
;  :arith-assert-diseq      53
;  :arith-assert-lower      193
;  :arith-assert-upper      116
;  :arith-bound-prop        8
;  :arith-conflicts         17
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        2
;  :arith-pivots            40
;  :binary-propagations     11
;  :conflicts               89
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 438
;  :datatype-occurs-check   185
;  :datatype-splits         286
;  :decisions               426
;  :del-clause              365
;  :final-checks            78
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1242
;  :mk-clause               389
;  :num-allocs              4246537
;  :num-checks              176
;  :propagations            182
;  :quant-instantiations    108
;  :rlimit-count            165155)
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2259
;  :arith-add-rows          19
;  :arith-assert-diseq      53
;  :arith-assert-lower      193
;  :arith-assert-upper      116
;  :arith-bound-prop        8
;  :arith-conflicts         17
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        2
;  :arith-pivots            40
;  :binary-propagations     11
;  :conflicts               89
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 438
;  :datatype-occurs-check   185
;  :datatype-splits         286
;  :decisions               426
;  :del-clause              365
;  :final-checks            78
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1242
;  :mk-clause               389
;  :num-allocs              4246537
;  :num-checks              177
;  :propagations            182
;  :quant-instantiations    108
;  :rlimit-count            165170)
(pop) ; 7
(push) ; 7
; [else-branch: 28 | First:(Second:(Second:(Second:(Second:(Second:($t@58@06))))))[First:(Second:(Second:(Second:($t@58@06))))[1]] == 0 && 0 <= First:(Second:(Second:(Second:($t@58@06))))[1]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
        1))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
            1))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
          1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))
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
(declare-const i@66@06 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 29 | 0 <= i@66@06 | live]
; [else-branch: 29 | !(0 <= i@66@06) | live]
(push) ; 8
; [then-branch: 29 | 0 <= i@66@06]
(assert (<= 0 i@66@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 29 | !(0 <= i@66@06)]
(assert (not (<= 0 i@66@06)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 30 | i@66@06 < |First:(Second:($t@64@06))| && 0 <= i@66@06 | live]
; [else-branch: 30 | !(i@66@06 < |First:(Second:($t@64@06))| && 0 <= i@66@06) | live]
(push) ; 8
; [then-branch: 30 | i@66@06 < |First:(Second:($t@64@06))| && 0 <= i@66@06]
(assert (and
  (<
    i@66@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))
  (<= 0 i@66@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@66@06 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2380
;  :arith-add-rows          21
;  :arith-assert-diseq      56
;  :arith-assert-lower      207
;  :arith-assert-upper      126
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               89
;  :datatype-accessor-ax    126
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   196
;  :datatype-splits         306
;  :decisions               454
;  :del-clause              413
;  :final-checks            82
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1313
;  :mk-clause               446
;  :num-allocs              4246537
;  :num-checks              179
;  :propagations            198
;  :quant-instantiations    116
;  :rlimit-count            166859)
; [eval] -1
(push) ; 9
; [then-branch: 31 | First:(Second:($t@64@06))[i@66@06] == -1 | live]
; [else-branch: 31 | First:(Second:($t@64@06))[i@66@06] != -1 | live]
(push) ; 10
; [then-branch: 31 | First:(Second:($t@64@06))[i@66@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
    i@66@06)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 31 | First:(Second:($t@64@06))[i@66@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
      i@66@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@66@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2380
;  :arith-add-rows          21
;  :arith-assert-diseq      57
;  :arith-assert-lower      210
;  :arith-assert-upper      127
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               89
;  :datatype-accessor-ax    126
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   196
;  :datatype-splits         306
;  :decisions               454
;  :del-clause              413
;  :final-checks            82
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1319
;  :mk-clause               450
;  :num-allocs              4246537
;  :num-checks              180
;  :propagations            200
;  :quant-instantiations    117
;  :rlimit-count            167067)
(push) ; 11
; [then-branch: 32 | 0 <= First:(Second:($t@64@06))[i@66@06] | live]
; [else-branch: 32 | !(0 <= First:(Second:($t@64@06))[i@66@06]) | live]
(push) ; 12
; [then-branch: 32 | 0 <= First:(Second:($t@64@06))[i@66@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
    i@66@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@66@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2380
;  :arith-add-rows          21
;  :arith-assert-diseq      57
;  :arith-assert-lower      210
;  :arith-assert-upper      127
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               89
;  :datatype-accessor-ax    126
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   196
;  :datatype-splits         306
;  :decisions               454
;  :del-clause              413
;  :final-checks            82
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1319
;  :mk-clause               450
;  :num-allocs              4246537
;  :num-checks              181
;  :propagations            200
;  :quant-instantiations    117
;  :rlimit-count            167161)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 32 | !(0 <= First:(Second:($t@64@06))[i@66@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
      i@66@06))))
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
; [else-branch: 30 | !(i@66@06 < |First:(Second:($t@64@06))| && 0 <= i@66@06)]
(assert (not
  (and
    (<
      i@66@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))
    (<= 0 i@66@06))))
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
(assert (not (forall ((i@66@06 Int)) (!
  (implies
    (and
      (<
        i@66@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))
      (<= 0 i@66@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
          i@66@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
            i@66@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
            i@66@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
    i@66@06))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2380
;  :arith-add-rows          21
;  :arith-assert-diseq      58
;  :arith-assert-lower      211
;  :arith-assert-upper      128
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               90
;  :datatype-accessor-ax    126
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   196
;  :datatype-splits         306
;  :decisions               454
;  :del-clause              429
;  :final-checks            82
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1327
;  :mk-clause               462
;  :num-allocs              4246537
;  :num-checks              182
;  :propagations            202
;  :quant-instantiations    118
;  :rlimit-count            167583)
(assert (forall ((i@66@06 Int)) (!
  (implies
    (and
      (<
        i@66@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))
      (<= 0 i@66@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
          i@66@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
            i@66@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
            i@66@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))
    i@66@06))
  :qid |prog.l<no position>|)))
(declare-const $t@67@06 $Snap)
(assert (= $t@67@06 ($Snap.combine ($Snap.first $t@67@06) ($Snap.second $t@67@06))))
(assert (=
  ($Snap.second $t@67@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@67@06))
    ($Snap.second ($Snap.second $t@67@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@67@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@67@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@67@06))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@67@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@68@06 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 33 | 0 <= i@68@06 | live]
; [else-branch: 33 | !(0 <= i@68@06) | live]
(push) ; 8
; [then-branch: 33 | 0 <= i@68@06]
(assert (<= 0 i@68@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 33 | !(0 <= i@68@06)]
(assert (not (<= 0 i@68@06)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 34 | i@68@06 < |First:(Second:($t@67@06))| && 0 <= i@68@06 | live]
; [else-branch: 34 | !(i@68@06 < |First:(Second:($t@67@06))| && 0 <= i@68@06) | live]
(push) ; 8
; [then-branch: 34 | i@68@06 < |First:(Second:($t@67@06))| && 0 <= i@68@06]
(assert (and
  (<
    i@68@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
  (<= 0 i@68@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@68@06 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2417
;  :arith-add-rows          21
;  :arith-assert-diseq      58
;  :arith-assert-lower      216
;  :arith-assert-upper      131
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               90
;  :datatype-accessor-ax    132
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   196
;  :datatype-splits         306
;  :decisions               454
;  :del-clause              429
;  :final-checks            82
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1349
;  :mk-clause               462
;  :num-allocs              4246537
;  :num-checks              183
;  :propagations            202
;  :quant-instantiations    122
;  :rlimit-count            168971)
; [eval] -1
(push) ; 9
; [then-branch: 35 | First:(Second:($t@67@06))[i@68@06] == -1 | live]
; [else-branch: 35 | First:(Second:($t@67@06))[i@68@06] != -1 | live]
(push) ; 10
; [then-branch: 35 | First:(Second:($t@67@06))[i@68@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@68@06)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 35 | First:(Second:($t@67@06))[i@68@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      i@68@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@68@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2417
;  :arith-add-rows          21
;  :arith-assert-diseq      58
;  :arith-assert-lower      216
;  :arith-assert-upper      131
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               90
;  :datatype-accessor-ax    132
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   196
;  :datatype-splits         306
;  :decisions               454
;  :del-clause              429
;  :final-checks            82
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1350
;  :mk-clause               462
;  :num-allocs              4246537
;  :num-checks              184
;  :propagations            202
;  :quant-instantiations    122
;  :rlimit-count            169122)
(push) ; 11
; [then-branch: 36 | 0 <= First:(Second:($t@67@06))[i@68@06] | live]
; [else-branch: 36 | !(0 <= First:(Second:($t@67@06))[i@68@06]) | live]
(push) ; 12
; [then-branch: 36 | 0 <= First:(Second:($t@67@06))[i@68@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@68@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@68@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2417
;  :arith-add-rows          21
;  :arith-assert-diseq      59
;  :arith-assert-lower      219
;  :arith-assert-upper      131
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        2
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               90
;  :datatype-accessor-ax    132
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   196
;  :datatype-splits         306
;  :decisions               454
;  :del-clause              429
;  :final-checks            82
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1353
;  :mk-clause               463
;  :num-allocs              4246537
;  :num-checks              185
;  :propagations            202
;  :quant-instantiations    122
;  :rlimit-count            169225)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 36 | !(0 <= First:(Second:($t@67@06))[i@68@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      i@68@06))))
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
; [else-branch: 34 | !(i@68@06 < |First:(Second:($t@67@06))| && 0 <= i@68@06)]
(assert (not
  (and
    (<
      i@68@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
    (<= 0 i@68@06))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@68@06 Int)) (!
  (implies
    (and
      (<
        i@68@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
      (<= 0 i@68@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          i@68@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@68@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@68@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@68@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@06)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2435
;  :arith-add-rows          21
;  :arith-assert-diseq      59
;  :arith-assert-lower      220
;  :arith-assert-upper      132
;  :arith-bound-prop        14
;  :arith-conflicts         17
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        2
;  :arith-pivots            47
;  :binary-propagations     11
;  :conflicts               90
;  :datatype-accessor-ax    134
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   196
;  :datatype-splits         306
;  :decisions               454
;  :del-clause              430
;  :final-checks            82
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1373
;  :mk-clause               473
;  :num-allocs              4246537
;  :num-checks              186
;  :propagations            206
;  :quant-instantiations    124
;  :rlimit-count            170240)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2646
;  :arith-add-rows          25
;  :arith-assert-diseq      64
;  :arith-assert-lower      243
;  :arith-assert-upper      146
;  :arith-bound-prop        24
;  :arith-conflicts         17
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         39
;  :arith-offset-eqs        2
;  :arith-pivots            58
;  :binary-propagations     11
;  :conflicts               91
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 510
;  :datatype-occurs-check   210
;  :datatype-splits         331
;  :decisions               501
;  :del-clause              499
;  :final-checks            86
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1460
;  :mk-clause               542
;  :num-allocs              4246537
;  :num-checks              187
;  :propagations            234
;  :quant-instantiations    138
;  :rlimit-count            172234
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2856
;  :arith-add-rows          29
;  :arith-assert-diseq      69
;  :arith-assert-lower      266
;  :arith-assert-upper      160
;  :arith-bound-prop        34
;  :arith-conflicts         17
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        2
;  :arith-pivots            66
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 556
;  :datatype-occurs-check   224
;  :datatype-splits         356
;  :decisions               548
;  :del-clause              568
;  :final-checks            90
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1547
;  :mk-clause               611
;  :num-allocs              4246537
;  :num-checks              188
;  :propagations            262
;  :quant-instantiations    152
;  :rlimit-count            174158
;  :time                    0.00)
; [then-branch: 37 | First:(Second:(Second:(Second:($t@64@06))))[0] == 0 | live]
; [else-branch: 37 | First:(Second:(Second:(Second:($t@64@06))))[0] != 0 | live]
(push) ; 7
; [then-branch: 37 | First:(Second:(Second:(Second:($t@64@06))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
    0)
  0))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2857
;  :arith-add-rows          29
;  :arith-assert-diseq      69
;  :arith-assert-lower      266
;  :arith-assert-upper      160
;  :arith-bound-prop        34
;  :arith-conflicts         17
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        2
;  :arith-pivots            66
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 556
;  :datatype-occurs-check   224
;  :datatype-splits         356
;  :decisions               548
;  :del-clause              568
;  :final-checks            90
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1548
;  :mk-clause               611
;  :num-allocs              4246537
;  :num-checks              189
;  :propagations            262
;  :quant-instantiations    152
;  :rlimit-count            174286)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 37 | First:(Second:(Second:(Second:($t@64@06))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      0)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 6
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2863
;  :arith-add-rows          29
;  :arith-assert-diseq      69
;  :arith-assert-lower      266
;  :arith-assert-upper      160
;  :arith-bound-prop        34
;  :arith-conflicts         17
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        2
;  :arith-pivots            66
;  :binary-propagations     11
;  :conflicts               92
;  :datatype-accessor-ax    141
;  :datatype-constructor-ax 556
;  :datatype-occurs-check   224
;  :datatype-splits         356
;  :decisions               548
;  :del-clause              568
;  :final-checks            90
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1552
;  :mk-clause               612
;  :num-allocs              4246537
;  :num-checks              190
;  :propagations            262
;  :quant-instantiations    152
;  :rlimit-count            174721)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3078
;  :arith-add-rows          33
;  :arith-assert-diseq      74
;  :arith-assert-lower      288
;  :arith-assert-upper      174
;  :arith-bound-prop        44
;  :arith-conflicts         17
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         51
;  :arith-offset-eqs        2
;  :arith-pivots            72
;  :binary-propagations     11
;  :conflicts               93
;  :datatype-accessor-ax    144
;  :datatype-constructor-ax 602
;  :datatype-occurs-check   238
;  :datatype-splits         381
;  :decisions               596
;  :del-clause              635
;  :final-checks            94
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.40
;  :mk-bool-var             1638
;  :mk-clause               679
;  :num-allocs              4246537
;  :num-checks              191
;  :propagations            289
;  :quant-instantiations    166
;  :rlimit-count            176647
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3292
;  :arith-add-rows          37
;  :arith-assert-diseq      79
;  :arith-assert-lower      311
;  :arith-assert-upper      188
;  :arith-bound-prop        54
;  :arith-conflicts         17
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        2
;  :arith-pivots            80
;  :binary-propagations     11
;  :conflicts               94
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 648
;  :datatype-occurs-check   252
;  :datatype-splits         406
;  :decisions               644
;  :del-clause              704
;  :final-checks            98
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1725
;  :mk-clause               748
;  :num-allocs              4412785
;  :num-checks              192
;  :propagations            317
;  :quant-instantiations    180
;  :rlimit-count            178599
;  :time                    0.00)
; [then-branch: 38 | First:(Second:(Second:(Second:($t@64@06))))[1] == 0 | live]
; [else-branch: 38 | First:(Second:(Second:(Second:($t@64@06))))[1] != 0 | live]
(push) ; 7
; [then-branch: 38 | First:(Second:(Second:(Second:($t@64@06))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
    1)
  0))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3293
;  :arith-add-rows          37
;  :arith-assert-diseq      79
;  :arith-assert-lower      311
;  :arith-assert-upper      188
;  :arith-bound-prop        54
;  :arith-conflicts         17
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        2
;  :arith-pivots            80
;  :binary-propagations     11
;  :conflicts               94
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 648
;  :datatype-occurs-check   252
;  :datatype-splits         406
;  :decisions               644
;  :del-clause              704
;  :final-checks            98
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1726
;  :mk-clause               748
;  :num-allocs              4412785
;  :num-checks              193
;  :propagations            317
;  :quant-instantiations    180
;  :rlimit-count            178727)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 38 | First:(Second:(Second:(Second:($t@64@06))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      1)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[2]) == 0 ==> diz.Main_event_state[2] == -2
; [eval] old(diz.Main_event_state[2]) == 0
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 6
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3299
;  :arith-add-rows          37
;  :arith-assert-diseq      79
;  :arith-assert-lower      311
;  :arith-assert-upper      188
;  :arith-bound-prop        54
;  :arith-conflicts         17
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        2
;  :arith-pivots            80
;  :binary-propagations     11
;  :conflicts               94
;  :datatype-accessor-ax    148
;  :datatype-constructor-ax 648
;  :datatype-occurs-check   252
;  :datatype-splits         406
;  :decisions               644
;  :del-clause              704
;  :final-checks            98
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1730
;  :mk-clause               749
;  :num-allocs              4412785
;  :num-checks              194
;  :propagations            317
;  :quant-instantiations    180
;  :rlimit-count            179168)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      2)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3534
;  :arith-add-rows          42
;  :arith-assert-diseq      88
;  :arith-assert-lower      346
;  :arith-assert-upper      213
;  :arith-bound-prop        64
;  :arith-conflicts         17
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         65
;  :arith-offset-eqs        2
;  :arith-pivots            90
;  :binary-propagations     11
;  :conflicts               96
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 694
;  :datatype-occurs-check   265
;  :datatype-splits         431
;  :decisions               698
;  :del-clause              814
;  :final-checks            103
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1844
;  :mk-clause               859
;  :num-allocs              4412785
;  :num-checks              195
;  :propagations            376
;  :quant-instantiations    199
;  :rlimit-count            181344
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
    2)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3754
;  :arith-add-rows          46
;  :arith-assert-diseq      93
;  :arith-assert-lower      369
;  :arith-assert-upper      227
;  :arith-bound-prop        74
;  :arith-conflicts         17
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        2
;  :arith-pivots            98
;  :binary-propagations     11
;  :conflicts               97
;  :datatype-accessor-ax    154
;  :datatype-constructor-ax 740
;  :datatype-occurs-check   278
;  :datatype-splits         456
;  :decisions               747
;  :del-clause              883
;  :final-checks            107
;  :interface-eqs           12
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1931
;  :mk-clause               928
;  :num-allocs              4412785
;  :num-checks              196
;  :propagations            404
;  :quant-instantiations    213
;  :rlimit-count            183316
;  :time                    0.00)
; [then-branch: 39 | First:(Second:(Second:(Second:($t@64@06))))[2] == 0 | live]
; [else-branch: 39 | First:(Second:(Second:(Second:($t@64@06))))[2] != 0 | live]
(push) ; 7
; [then-branch: 39 | First:(Second:(Second:(Second:($t@64@06))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
    2)
  0))
; [eval] diz.Main_event_state[2] == -2
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3755
;  :arith-add-rows          46
;  :arith-assert-diseq      93
;  :arith-assert-lower      369
;  :arith-assert-upper      227
;  :arith-bound-prop        74
;  :arith-conflicts         17
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        2
;  :arith-pivots            98
;  :binary-propagations     11
;  :conflicts               97
;  :datatype-accessor-ax    154
;  :datatype-constructor-ax 740
;  :datatype-occurs-check   278
;  :datatype-splits         456
;  :decisions               747
;  :del-clause              883
;  :final-checks            107
;  :interface-eqs           12
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1932
;  :mk-clause               928
;  :num-allocs              4412785
;  :num-checks              197
;  :propagations            404
;  :quant-instantiations    213
;  :rlimit-count            183436)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 39 | First:(Second:(Second:(Second:($t@64@06))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      2)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      2)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3761
;  :arith-add-rows          46
;  :arith-assert-diseq      93
;  :arith-assert-lower      369
;  :arith-assert-upper      227
;  :arith-bound-prop        74
;  :arith-conflicts         17
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        2
;  :arith-pivots            98
;  :binary-propagations     11
;  :conflicts               97
;  :datatype-accessor-ax    155
;  :datatype-constructor-ax 740
;  :datatype-occurs-check   278
;  :datatype-splits         456
;  :decisions               747
;  :del-clause              883
;  :final-checks            107
;  :interface-eqs           12
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1936
;  :mk-clause               929
;  :num-allocs              4412785
;  :num-checks              198
;  :propagations            404
;  :quant-instantiations    213
;  :rlimit-count            183883)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3979
;  :arith-add-rows          50
;  :arith-assert-diseq      98
;  :arith-assert-lower      392
;  :arith-assert-upper      241
;  :arith-bound-prop        84
;  :arith-conflicts         17
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        2
;  :arith-pivots            106
;  :binary-propagations     11
;  :conflicts               98
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 786
;  :datatype-occurs-check   292
;  :datatype-splits         481
;  :decisions               796
;  :del-clause              952
;  :final-checks            111
;  :interface-eqs           13
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2022
;  :mk-clause               998
;  :num-allocs              4412785
;  :num-checks              199
;  :propagations            432
;  :quant-instantiations    227
;  :rlimit-count            185843
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4208
;  :arith-add-rows          54
;  :arith-assert-diseq      103
;  :arith-assert-lower      415
;  :arith-assert-upper      255
;  :arith-bound-prop        94
;  :arith-conflicts         17
;  :arith-eq-adapter        223
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        2
;  :arith-pivots            112
;  :binary-propagations     11
;  :conflicts               100
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 835
;  :datatype-occurs-check   310
;  :datatype-splits         508
;  :decisions               847
;  :del-clause              1020
;  :final-checks            116
;  :interface-eqs           14
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2120
;  :mk-clause               1066
;  :num-allocs              4412785
;  :num-checks              200
;  :propagations            460
;  :quant-instantiations    241
;  :rlimit-count            187847
;  :time                    0.00)
; [then-branch: 40 | First:(Second:(Second:(Second:($t@64@06))))[0] != 0 | live]
; [else-branch: 40 | First:(Second:(Second:(Second:($t@64@06))))[0] == 0 | live]
(push) ; 7
; [then-branch: 40 | First:(Second:(Second:(Second:($t@64@06))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      0)
    0)))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4208
;  :arith-add-rows          54
;  :arith-assert-diseq      103
;  :arith-assert-lower      415
;  :arith-assert-upper      255
;  :arith-bound-prop        94
;  :arith-conflicts         17
;  :arith-eq-adapter        223
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        2
;  :arith-pivots            112
;  :binary-propagations     11
;  :conflicts               100
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 835
;  :datatype-occurs-check   310
;  :datatype-splits         508
;  :decisions               847
;  :del-clause              1020
;  :final-checks            116
;  :interface-eqs           14
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2120
;  :mk-clause               1066
;  :num-allocs              4412785
;  :num-checks              201
;  :propagations            460
;  :quant-instantiations    241
;  :rlimit-count            187977)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4208
;  :arith-add-rows          54
;  :arith-assert-diseq      103
;  :arith-assert-lower      415
;  :arith-assert-upper      255
;  :arith-bound-prop        94
;  :arith-conflicts         17
;  :arith-eq-adapter        223
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        2
;  :arith-pivots            112
;  :binary-propagations     11
;  :conflicts               100
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 835
;  :datatype-occurs-check   310
;  :datatype-splits         508
;  :decisions               847
;  :del-clause              1020
;  :final-checks            116
;  :interface-eqs           14
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2120
;  :mk-clause               1066
;  :num-allocs              4412785
;  :num-checks              202
;  :propagations            460
;  :quant-instantiations    241
;  :rlimit-count            187992)
(pop) ; 7
(push) ; 7
; [else-branch: 40 | First:(Second:(Second:(Second:($t@64@06))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
        0)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4214
;  :arith-add-rows          54
;  :arith-assert-diseq      103
;  :arith-assert-lower      415
;  :arith-assert-upper      255
;  :arith-bound-prop        94
;  :arith-conflicts         17
;  :arith-eq-adapter        223
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        2
;  :arith-pivots            112
;  :binary-propagations     11
;  :conflicts               100
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 835
;  :datatype-occurs-check   310
;  :datatype-splits         508
;  :decisions               847
;  :del-clause              1020
;  :final-checks            116
;  :interface-eqs           14
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2123
;  :mk-clause               1067
;  :num-allocs              4412785
;  :num-checks              203
;  :propagations            460
;  :quant-instantiations    241
;  :rlimit-count            188411)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4433
;  :arith-add-rows          58
;  :arith-assert-diseq      108
;  :arith-assert-lower      438
;  :arith-assert-upper      269
;  :arith-bound-prop        104
;  :arith-conflicts         17
;  :arith-eq-adapter        236
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        2
;  :arith-pivots            120
;  :binary-propagations     11
;  :conflicts               101
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 881
;  :datatype-occurs-check   324
;  :datatype-splits         533
;  :decisions               896
;  :del-clause              1089
;  :final-checks            120
;  :interface-eqs           15
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2209
;  :mk-clause               1136
;  :num-allocs              4412785
;  :num-checks              204
;  :propagations            489
;  :quant-instantiations    255
;  :rlimit-count            190388
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4664
;  :arith-add-rows          62
;  :arith-assert-diseq      113
;  :arith-assert-lower      460
;  :arith-assert-upper      283
;  :arith-bound-prop        114
;  :arith-conflicts         17
;  :arith-eq-adapter        249
;  :arith-fixed-eqs         95
;  :arith-offset-eqs        2
;  :arith-pivots            128
;  :binary-propagations     11
;  :conflicts               103
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 930
;  :datatype-occurs-check   342
;  :datatype-splits         560
;  :decisions               947
;  :del-clause              1157
;  :final-checks            125
;  :interface-eqs           16
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2306
;  :mk-clause               1204
;  :num-allocs              4412785
;  :num-checks              205
;  :propagations            518
;  :quant-instantiations    269
;  :rlimit-count            192405
;  :time                    0.00)
; [then-branch: 41 | First:(Second:(Second:(Second:($t@64@06))))[1] != 0 | live]
; [else-branch: 41 | First:(Second:(Second:(Second:($t@64@06))))[1] == 0 | live]
(push) ; 7
; [then-branch: 41 | First:(Second:(Second:(Second:($t@64@06))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      1)
    0)))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4664
;  :arith-add-rows          62
;  :arith-assert-diseq      113
;  :arith-assert-lower      460
;  :arith-assert-upper      283
;  :arith-bound-prop        114
;  :arith-conflicts         17
;  :arith-eq-adapter        249
;  :arith-fixed-eqs         95
;  :arith-offset-eqs        2
;  :arith-pivots            128
;  :binary-propagations     11
;  :conflicts               103
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 930
;  :datatype-occurs-check   342
;  :datatype-splits         560
;  :decisions               947
;  :del-clause              1157
;  :final-checks            125
;  :interface-eqs           16
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2306
;  :mk-clause               1204
;  :num-allocs              4412785
;  :num-checks              206
;  :propagations            518
;  :quant-instantiations    269
;  :rlimit-count            192535)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4664
;  :arith-add-rows          62
;  :arith-assert-diseq      113
;  :arith-assert-lower      460
;  :arith-assert-upper      283
;  :arith-bound-prop        114
;  :arith-conflicts         17
;  :arith-eq-adapter        249
;  :arith-fixed-eqs         95
;  :arith-offset-eqs        2
;  :arith-pivots            128
;  :binary-propagations     11
;  :conflicts               103
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 930
;  :datatype-occurs-check   342
;  :datatype-splits         560
;  :decisions               947
;  :del-clause              1157
;  :final-checks            125
;  :interface-eqs           16
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2306
;  :mk-clause               1204
;  :num-allocs              4412785
;  :num-checks              207
;  :propagations            518
;  :quant-instantiations    269
;  :rlimit-count            192550)
(pop) ; 7
(push) ; 7
; [else-branch: 41 | First:(Second:(Second:(Second:($t@64@06))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
        1)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4671
;  :arith-add-rows          62
;  :arith-assert-diseq      113
;  :arith-assert-lower      460
;  :arith-assert-upper      283
;  :arith-bound-prop        114
;  :arith-conflicts         17
;  :arith-eq-adapter        249
;  :arith-fixed-eqs         95
;  :arith-offset-eqs        2
;  :arith-pivots            128
;  :binary-propagations     11
;  :conflicts               103
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 930
;  :datatype-occurs-check   342
;  :datatype-splits         560
;  :decisions               947
;  :del-clause              1157
;  :final-checks            125
;  :interface-eqs           16
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2308
;  :mk-clause               1205
;  :num-allocs              4412785
;  :num-checks              208
;  :propagations            518
;  :quant-instantiations    269
;  :rlimit-count            192892)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
    2)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4884
;  :arith-add-rows          66
;  :arith-assert-diseq      118
;  :arith-assert-lower      483
;  :arith-assert-upper      297
;  :arith-bound-prop        124
;  :arith-conflicts         17
;  :arith-eq-adapter        262
;  :arith-fixed-eqs         101
;  :arith-offset-eqs        2
;  :arith-pivots            134
;  :binary-propagations     11
;  :conflicts               104
;  :datatype-accessor-ax    173
;  :datatype-constructor-ax 975
;  :datatype-occurs-check   356
;  :datatype-splits         584
;  :decisions               995
;  :del-clause              1224
;  :final-checks            129
;  :interface-eqs           17
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2393
;  :mk-clause               1272
;  :num-allocs              4412785
;  :num-checks              209
;  :propagations            547
;  :quant-instantiations    283
;  :rlimit-count            194850
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      2)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5126
;  :arith-add-rows          71
;  :arith-assert-diseq      127
;  :arith-assert-lower      518
;  :arith-assert-upper      322
;  :arith-bound-prop        134
;  :arith-conflicts         17
;  :arith-eq-adapter        284
;  :arith-fixed-eqs         109
;  :arith-offset-eqs        2
;  :arith-pivots            144
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 1023
;  :datatype-occurs-check   374
;  :datatype-splits         610
;  :decisions               1050
;  :del-clause              1335
;  :final-checks            135
;  :interface-eqs           19
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2517
;  :mk-clause               1383
;  :num-allocs              4412785
;  :num-checks              210
;  :propagations            611
;  :quant-instantiations    302
;  :rlimit-count            197085
;  :time                    0.00)
; [then-branch: 42 | First:(Second:(Second:(Second:($t@64@06))))[2] != 0 | live]
; [else-branch: 42 | First:(Second:(Second:(Second:($t@64@06))))[2] == 0 | live]
(push) ; 7
; [then-branch: 42 | First:(Second:(Second:(Second:($t@64@06))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
      2)
    0)))
; [eval] diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5126
;  :arith-add-rows          71
;  :arith-assert-diseq      127
;  :arith-assert-lower      518
;  :arith-assert-upper      322
;  :arith-bound-prop        134
;  :arith-conflicts         17
;  :arith-eq-adapter        284
;  :arith-fixed-eqs         109
;  :arith-offset-eqs        2
;  :arith-pivots            144
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 1023
;  :datatype-occurs-check   374
;  :datatype-splits         610
;  :decisions               1050
;  :del-clause              1335
;  :final-checks            135
;  :interface-eqs           19
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2517
;  :mk-clause               1383
;  :num-allocs              4412785
;  :num-checks              211
;  :propagations            611
;  :quant-instantiations    302
;  :rlimit-count            197215)
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 8
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5126
;  :arith-add-rows          71
;  :arith-assert-diseq      127
;  :arith-assert-lower      518
;  :arith-assert-upper      322
;  :arith-bound-prop        134
;  :arith-conflicts         17
;  :arith-eq-adapter        284
;  :arith-fixed-eqs         109
;  :arith-offset-eqs        2
;  :arith-pivots            144
;  :binary-propagations     11
;  :conflicts               107
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 1023
;  :datatype-occurs-check   374
;  :datatype-splits         610
;  :decisions               1050
;  :del-clause              1335
;  :final-checks            135
;  :interface-eqs           19
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2517
;  :mk-clause               1383
;  :num-allocs              4412785
;  :num-checks              212
;  :propagations            611
;  :quant-instantiations    302
;  :rlimit-count            197230)
(pop) ; 7
(push) ; 7
; [else-branch: 42 | First:(Second:(Second:(Second:($t@64@06))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
        2)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@06)))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5341
;  :arith-add-rows          75
;  :arith-assert-diseq      132
;  :arith-assert-lower      541
;  :arith-assert-upper      336
;  :arith-bound-prop        144
;  :arith-conflicts         17
;  :arith-eq-adapter        299
;  :arith-fixed-eqs         115
;  :arith-offset-eqs        2
;  :arith-pivots            150
;  :binary-propagations     11
;  :conflicts               108
;  :datatype-accessor-ax    180
;  :datatype-constructor-ax 1068
;  :datatype-occurs-check   388
;  :datatype-splits         634
;  :decisions               1099
;  :del-clause              1401
;  :final-checks            139
;  :interface-eqs           20
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2606
;  :mk-clause               1460
;  :num-allocs              4412785
;  :num-checks              214
;  :propagations            641
;  :quant-instantiations    316
;  :rlimit-count            199310)
; [eval] -1
(push) ; 6
; [then-branch: 43 | First:(Second:($t@67@06))[0] != -1 | live]
; [else-branch: 43 | First:(Second:($t@67@06))[0] == -1 | live]
(push) ; 7
; [then-branch: 43 | First:(Second:($t@67@06))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0)
    (- 0 1))))
; [eval] diz.Main_process_state[1] != -1
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5344
;  :arith-add-rows          75
;  :arith-assert-diseq      134
;  :arith-assert-lower      548
;  :arith-assert-upper      339
;  :arith-bound-prop        144
;  :arith-conflicts         17
;  :arith-eq-adapter        301
;  :arith-fixed-eqs         116
;  :arith-offset-eqs        2
;  :arith-pivots            151
;  :binary-propagations     11
;  :conflicts               108
;  :datatype-accessor-ax    180
;  :datatype-constructor-ax 1068
;  :datatype-occurs-check   388
;  :datatype-splits         634
;  :decisions               1099
;  :del-clause              1401
;  :final-checks            139
;  :interface-eqs           20
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2609
;  :mk-clause               1469
;  :num-allocs              4412785
;  :num-checks              215
;  :propagations            649
;  :quant-instantiations    319
;  :rlimit-count            199486)
; [eval] -1
(pop) ; 7
(push) ; 7
; [else-branch: 43 | First:(Second:($t@67@06))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0)
        (- 0 1)))))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5497
;  :arith-add-rows          79
;  :arith-assert-diseq      142
;  :arith-assert-lower      579
;  :arith-assert-upper      355
;  :arith-bound-prop        144
;  :arith-conflicts         17
;  :arith-eq-adapter        316
;  :arith-fixed-eqs         122
;  :arith-offset-eqs        2
;  :arith-pivots            159
;  :binary-propagations     11
;  :conflicts               109
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   402
;  :datatype-splits         658
;  :decisions               1133
;  :del-clause              1461
;  :final-checks            144
;  :interface-eqs           22
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             2677
;  :mk-clause               1520
;  :num-allocs              4412785
;  :num-checks              216
;  :propagations            693
;  :quant-instantiations    333
;  :rlimit-count            201378
;  :time                    0.00)
(push) ; 6
(assert (not (and
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5929
;  :arith-add-rows          84
;  :arith-assert-diseq      156
;  :arith-assert-lower      627
;  :arith-assert-upper      378
;  :arith-bound-prop        152
;  :arith-conflicts         17
;  :arith-eq-adapter        344
;  :arith-fixed-eqs         133
;  :arith-offset-eqs        2
;  :arith-pivots            172
;  :binary-propagations     11
;  :conflicts               114
;  :datatype-accessor-ax    198
;  :datatype-constructor-ax 1190
;  :datatype-occurs-check   440
;  :datatype-splits         732
;  :decisions               1223
;  :del-clause              1569
;  :final-checks            156
;  :interface-eqs           27
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             2862
;  :mk-clause               1628
;  :num-allocs              4412785
;  :num-checks              217
;  :propagations            757
;  :quant-instantiations    352
;  :rlimit-count            204405
;  :time                    0.00)
; [then-branch: 44 | First:(Second:($t@67@06))[1] != -1 && First:(Second:($t@67@06))[0] != -1 | live]
; [else-branch: 44 | !(First:(Second:($t@67@06))[1] != -1 && First:(Second:($t@67@06))[0] != -1) | live]
(push) ; 6
; [then-branch: 44 | First:(Second:($t@67@06))[1] != -1 && First:(Second:($t@67@06))[0] != -1]
(assert (and
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
(declare-const min_advance__31@69@06 Int)
(assert (=
  min_advance__31@69@06
  (Main_find_minimum_advance_Sequence$Integer$ ($Snap.combine
    $Snap.unit
    $Snap.unit) diz@30@06 ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06))))))))
; [eval] min_advance__31 == -1
; [eval] -1
(push) ; 7
(assert (not (not (= min_advance__31@69@06 (- 0 1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6100
;  :arith-add-rows          87
;  :arith-assert-diseq      176
;  :arith-assert-lower      661
;  :arith-assert-upper      406
;  :arith-bound-prop        156
;  :arith-conflicts         17
;  :arith-eq-adapter        365
;  :arith-fixed-eqs         140
;  :arith-offset-eqs        2
;  :arith-pivots            179
;  :binary-propagations     11
;  :conflicts               115
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 1220
;  :datatype-occurs-check   454
;  :datatype-splits         756
;  :decisions               1260
;  :del-clause              1625
;  :final-checks            161
;  :interface-eqs           29
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             2973
;  :mk-clause               1749
;  :num-allocs              4412785
;  :num-checks              218
;  :propagations            819
;  :quant-instantiations    369
;  :rlimit-count            206743
;  :time                    0.00)
(push) ; 7
(assert (not (= min_advance__31@69@06 (- 0 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6255
;  :arith-add-rows          87
;  :arith-assert-diseq      194
;  :arith-assert-lower      687
;  :arith-assert-upper      423
;  :arith-bound-prop        160
;  :arith-conflicts         17
;  :arith-eq-adapter        381
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        2
;  :arith-pivots            183
;  :binary-propagations     11
;  :conflicts               116
;  :datatype-accessor-ax    205
;  :datatype-constructor-ax 1250
;  :datatype-occurs-check   468
;  :datatype-splits         780
;  :decisions               1299
;  :del-clause              1686
;  :final-checks            166
;  :interface-eqs           31
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3051
;  :mk-clause               1810
;  :num-allocs              4412785
;  :num-checks              219
;  :propagations            863
;  :quant-instantiations    377
;  :rlimit-count            208393
;  :time                    0.00)
; [then-branch: 45 | min_advance__31@69@06 == -1 | live]
; [else-branch: 45 | min_advance__31@69@06 != -1 | live]
(push) ; 7
; [then-branch: 45 | min_advance__31@69@06 == -1]
(assert (= min_advance__31@69@06 (- 0 1)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6257
;  :arith-add-rows          87
;  :arith-assert-diseq      195
;  :arith-assert-lower      688
;  :arith-assert-upper      426
;  :arith-bound-prop        160
;  :arith-conflicts         17
;  :arith-eq-adapter        382
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        2
;  :arith-pivots            183
;  :binary-propagations     11
;  :conflicts               116
;  :datatype-accessor-ax    205
;  :datatype-constructor-ax 1250
;  :datatype-occurs-check   468
;  :datatype-splits         780
;  :decisions               1299
;  :del-clause              1686
;  :final-checks            166
;  :interface-eqs           31
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3055
;  :mk-clause               1810
;  :num-allocs              4412785
;  :num-checks              220
;  :propagations            864
;  :quant-instantiations    377
;  :rlimit-count            208475)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6412
;  :arith-add-rows          87
;  :arith-assert-diseq      210
;  :arith-assert-lower      707
;  :arith-assert-upper      445
;  :arith-bound-prop        164
;  :arith-conflicts         17
;  :arith-eq-adapter        397
;  :arith-fixed-eqs         150
;  :arith-offset-eqs        2
;  :arith-pivots            188
;  :binary-propagations     11
;  :conflicts               117
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 1280
;  :datatype-occurs-check   482
;  :datatype-splits         804
;  :decisions               1335
;  :del-clause              1733
;  :final-checks            171
;  :interface-eqs           33
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3127
;  :mk-clause               1857
;  :num-allocs              4412785
;  :num-checks              221
;  :propagations            903
;  :quant-instantiations    385
;  :rlimit-count            210133
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6567
;  :arith-add-rows          87
;  :arith-assert-diseq      225
;  :arith-assert-lower      726
;  :arith-assert-upper      464
;  :arith-bound-prop        168
;  :arith-conflicts         17
;  :arith-eq-adapter        412
;  :arith-fixed-eqs         155
;  :arith-offset-eqs        2
;  :arith-pivots            192
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    211
;  :datatype-constructor-ax 1310
;  :datatype-occurs-check   496
;  :datatype-splits         828
;  :decisions               1371
;  :del-clause              1782
;  :final-checks            176
;  :interface-eqs           35
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3199
;  :mk-clause               1906
;  :num-allocs              4412785
;  :num-checks              222
;  :propagations            943
;  :quant-instantiations    393
;  :rlimit-count            211772
;  :time                    0.00)
; [then-branch: 46 | First:(Second:(Second:(Second:($t@67@06))))[0] < -1 | live]
; [else-branch: 46 | !(First:(Second:(Second:(Second:($t@67@06))))[0] < -1) | live]
(push) ; 9
; [then-branch: 46 | First:(Second:(Second:(Second:($t@67@06))))[0] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    0)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 46 | !(First:(Second:(Second:(Second:($t@67@06))))[0] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] - min_advance__31
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6567
;  :arith-add-rows          87
;  :arith-assert-diseq      225
;  :arith-assert-lower      728
;  :arith-assert-upper      464
;  :arith-bound-prop        168
;  :arith-conflicts         17
;  :arith-eq-adapter        412
;  :arith-fixed-eqs         155
;  :arith-offset-eqs        2
;  :arith-pivots            192
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    211
;  :datatype-constructor-ax 1310
;  :datatype-occurs-check   496
;  :datatype-splits         828
;  :decisions               1371
;  :del-clause              1782
;  :final-checks            176
;  :interface-eqs           35
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3199
;  :mk-clause               1906
;  :num-allocs              4412785
;  :num-checks              223
;  :propagations            945
;  :quant-instantiations    393
;  :rlimit-count            211935)
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6567
;  :arith-add-rows          87
;  :arith-assert-diseq      225
;  :arith-assert-lower      728
;  :arith-assert-upper      464
;  :arith-bound-prop        168
;  :arith-conflicts         17
;  :arith-eq-adapter        412
;  :arith-fixed-eqs         155
;  :arith-offset-eqs        2
;  :arith-pivots            192
;  :binary-propagations     11
;  :conflicts               118
;  :datatype-accessor-ax    211
;  :datatype-constructor-ax 1310
;  :datatype-occurs-check   496
;  :datatype-splits         828
;  :decisions               1371
;  :del-clause              1782
;  :final-checks            176
;  :interface-eqs           35
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3199
;  :mk-clause               1906
;  :num-allocs              4412785
;  :num-checks              224
;  :propagations            945
;  :quant-instantiations    393
;  :rlimit-count            211950)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6723
;  :arith-add-rows          87
;  :arith-assert-diseq      240
;  :arith-assert-lower      746
;  :arith-assert-upper      483
;  :arith-bound-prop        172
;  :arith-conflicts         17
;  :arith-eq-adapter        427
;  :arith-fixed-eqs         160
;  :arith-offset-eqs        2
;  :arith-pivots            196
;  :binary-propagations     11
;  :conflicts               119
;  :datatype-accessor-ax    214
;  :datatype-constructor-ax 1340
;  :datatype-occurs-check   510
;  :datatype-splits         852
;  :decisions               1407
;  :del-clause              1827
;  :final-checks            181
;  :interface-eqs           37
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3270
;  :mk-clause               1951
;  :num-allocs              4412785
;  :num-checks              225
;  :propagations            983
;  :quant-instantiations    401
;  :rlimit-count            213608
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    1)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6878
;  :arith-add-rows          87
;  :arith-assert-diseq      255
;  :arith-assert-lower      765
;  :arith-assert-upper      502
;  :arith-bound-prop        176
;  :arith-conflicts         17
;  :arith-eq-adapter        442
;  :arith-fixed-eqs         165
;  :arith-offset-eqs        2
;  :arith-pivots            200
;  :binary-propagations     11
;  :conflicts               120
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 1370
;  :datatype-occurs-check   524
;  :datatype-splits         876
;  :decisions               1443
;  :del-clause              1876
;  :final-checks            186
;  :interface-eqs           39
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3342
;  :mk-clause               2000
;  :num-allocs              4412785
;  :num-checks              226
;  :propagations            1023
;  :quant-instantiations    409
;  :rlimit-count            215251
;  :time                    0.00)
; [then-branch: 47 | First:(Second:(Second:(Second:($t@67@06))))[1] < -1 | live]
; [else-branch: 47 | !(First:(Second:(Second:(Second:($t@67@06))))[1] < -1) | live]
(push) ; 9
; [then-branch: 47 | First:(Second:(Second:(Second:($t@67@06))))[1] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    1)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 47 | !(First:(Second:(Second:(Second:($t@67@06))))[1] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] - min_advance__31
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6878
;  :arith-add-rows          87
;  :arith-assert-diseq      255
;  :arith-assert-lower      767
;  :arith-assert-upper      502
;  :arith-bound-prop        176
;  :arith-conflicts         17
;  :arith-eq-adapter        442
;  :arith-fixed-eqs         165
;  :arith-offset-eqs        2
;  :arith-pivots            200
;  :binary-propagations     11
;  :conflicts               120
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 1370
;  :datatype-occurs-check   524
;  :datatype-splits         876
;  :decisions               1443
;  :del-clause              1876
;  :final-checks            186
;  :interface-eqs           39
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3342
;  :mk-clause               2000
;  :num-allocs              4412785
;  :num-checks              227
;  :propagations            1025
;  :quant-instantiations    409
;  :rlimit-count            215414)
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6878
;  :arith-add-rows          87
;  :arith-assert-diseq      255
;  :arith-assert-lower      767
;  :arith-assert-upper      502
;  :arith-bound-prop        176
;  :arith-conflicts         17
;  :arith-eq-adapter        442
;  :arith-fixed-eqs         165
;  :arith-offset-eqs        2
;  :arith-pivots            200
;  :binary-propagations     11
;  :conflicts               120
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 1370
;  :datatype-occurs-check   524
;  :datatype-splits         876
;  :decisions               1443
;  :del-clause              1876
;  :final-checks            186
;  :interface-eqs           39
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3342
;  :mk-clause               2000
;  :num-allocs              4412785
;  :num-checks              228
;  :propagations            1025
;  :quant-instantiations    409
;  :rlimit-count            215429)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7032
;  :arith-add-rows          87
;  :arith-assert-diseq      270
;  :arith-assert-lower      787
;  :arith-assert-upper      521
;  :arith-bound-prop        180
;  :arith-conflicts         17
;  :arith-eq-adapter        457
;  :arith-fixed-eqs         170
;  :arith-offset-eqs        2
;  :arith-pivots            204
;  :binary-propagations     11
;  :conflicts               121
;  :datatype-accessor-ax    220
;  :datatype-constructor-ax 1400
;  :datatype-occurs-check   538
;  :datatype-splits         900
;  :decisions               1479
;  :del-clause              1923
;  :final-checks            191
;  :interface-eqs           41
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3415
;  :mk-clause               2047
;  :num-allocs              4412785
;  :num-checks              229
;  :propagations            1064
;  :quant-instantiations    417
;  :rlimit-count            217089
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    2)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7186
;  :arith-add-rows          87
;  :arith-assert-diseq      285
;  :arith-assert-lower      807
;  :arith-assert-upper      540
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        472
;  :arith-fixed-eqs         175
;  :arith-offset-eqs        2
;  :arith-pivots            208
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              1974
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3488
;  :mk-clause               2098
;  :num-allocs              4412785
;  :num-checks              230
;  :propagations            1105
;  :quant-instantiations    425
;  :rlimit-count            218728
;  :time                    0.00)
; [then-branch: 48 | First:(Second:(Second:(Second:($t@67@06))))[2] < -1 | live]
; [else-branch: 48 | !(First:(Second:(Second:(Second:($t@67@06))))[2] < -1) | live]
(push) ; 9
; [then-branch: 48 | First:(Second:(Second:(Second:($t@67@06))))[2] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    2)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 48 | !(First:(Second:(Second:(Second:($t@67@06))))[2] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      2)
    (- 0 1))))
; [eval] diz.Main_event_state[2] - min_advance__31
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7186
;  :arith-add-rows          87
;  :arith-assert-diseq      285
;  :arith-assert-lower      809
;  :arith-assert-upper      540
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        472
;  :arith-fixed-eqs         175
;  :arith-offset-eqs        2
;  :arith-pivots            208
;  :binary-propagations     11
;  :conflicts               122
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              1974
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3488
;  :mk-clause               2098
;  :num-allocs              4412785
;  :num-checks              231
;  :propagations            1107
;  :quant-instantiations    425
;  :rlimit-count            218891)
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
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
              0)
            (- 0 1))
          (- 0 3)
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
            0)))
        (Seq_singleton (ite
          (<
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
              1)
            (- 0 1))
          (- 0 3)
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
            1))))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
            2)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
          2)))))
  3))
(declare-const __flatten_31__30@70@06 Seq<Int>)
(assert (Seq_equal
  __flatten_31__30@70@06
  (Seq_append
    (Seq_append
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
            0)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
          0)))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
            1)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
          1))))
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
          2)
        (- 0 1))
      (- 0 3)
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
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
(assert (not (= (Seq_length __flatten_31__30@70@06) 3)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7192
;  :arith-add-rows          88
;  :arith-assert-diseq      285
;  :arith-assert-lower      812
;  :arith-assert-upper      542
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        476
;  :arith-fixed-eqs         176
;  :arith-offset-eqs        2
;  :arith-pivots            209
;  :binary-propagations     11
;  :conflicts               123
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              1974
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3520
;  :mk-clause               2125
;  :num-allocs              4412785
;  :num-checks              232
;  :propagations            1114
;  :quant-instantiations    429
;  :rlimit-count            219654)
(assert (= (Seq_length __flatten_31__30@70@06) 3))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@71@06 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 49 | 0 <= i@71@06 | live]
; [else-branch: 49 | !(0 <= i@71@06) | live]
(push) ; 10
; [then-branch: 49 | 0 <= i@71@06]
(assert (<= 0 i@71@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 49 | !(0 <= i@71@06)]
(assert (not (<= 0 i@71@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 50 | i@71@06 < |First:(Second:($t@67@06))| && 0 <= i@71@06 | live]
; [else-branch: 50 | !(i@71@06 < |First:(Second:($t@67@06))| && 0 <= i@71@06) | live]
(push) ; 10
; [then-branch: 50 | i@71@06 < |First:(Second:($t@67@06))| && 0 <= i@71@06]
(assert (and
  (<
    i@71@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
  (<= 0 i@71@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@71@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7193
;  :arith-add-rows          88
;  :arith-assert-diseq      285
;  :arith-assert-lower      814
;  :arith-assert-upper      544
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        477
;  :arith-fixed-eqs         176
;  :arith-offset-eqs        2
;  :arith-pivots            209
;  :binary-propagations     11
;  :conflicts               123
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              1974
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3525
;  :mk-clause               2125
;  :num-allocs              4412785
;  :num-checks              233
;  :propagations            1114
;  :quant-instantiations    429
;  :rlimit-count            219841)
; [eval] -1
(push) ; 11
; [then-branch: 51 | First:(Second:($t@67@06))[i@71@06] == -1 | live]
; [else-branch: 51 | First:(Second:($t@67@06))[i@71@06] != -1 | live]
(push) ; 12
; [then-branch: 51 | First:(Second:($t@67@06))[i@71@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@71@06)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 51 | First:(Second:($t@67@06))[i@71@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      i@71@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@71@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7197
;  :arith-add-rows          88
;  :arith-assert-diseq      287
;  :arith-assert-lower      821
;  :arith-assert-upper      547
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        480
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            210
;  :binary-propagations     11
;  :conflicts               123
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              1974
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3540
;  :mk-clause               2136
;  :num-allocs              4412785
;  :num-checks              234
;  :propagations            1119
;  :quant-instantiations    432
;  :rlimit-count            220147)
(push) ; 13
; [then-branch: 52 | 0 <= First:(Second:($t@67@06))[i@71@06] | live]
; [else-branch: 52 | !(0 <= First:(Second:($t@67@06))[i@71@06]) | live]
(push) ; 14
; [then-branch: 52 | 0 <= First:(Second:($t@67@06))[i@71@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@71@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@71@06 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7197
;  :arith-add-rows          88
;  :arith-assert-diseq      287
;  :arith-assert-lower      821
;  :arith-assert-upper      547
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        480
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            210
;  :binary-propagations     11
;  :conflicts               123
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              1974
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3540
;  :mk-clause               2136
;  :num-allocs              4412785
;  :num-checks              235
;  :propagations            1119
;  :quant-instantiations    432
;  :rlimit-count            220241)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 52 | !(0 <= First:(Second:($t@67@06))[i@71@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      i@71@06))))
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
; [else-branch: 50 | !(i@71@06 < |First:(Second:($t@67@06))| && 0 <= i@71@06)]
(assert (not
  (and
    (<
      i@71@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
    (<= 0 i@71@06))))
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
(assert (not (forall ((i@71@06 Int)) (!
  (implies
    (and
      (<
        i@71@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
      (<= 0 i@71@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          i@71@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@71@06)
          (Seq_length __flatten_31__30@70@06))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@71@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@71@06))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7197
;  :arith-add-rows          88
;  :arith-assert-diseq      289
;  :arith-assert-lower      822
;  :arith-assert-upper      548
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        481
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    223
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              2005
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3552
;  :mk-clause               2156
;  :num-allocs              4412785
;  :num-checks              236
;  :propagations            1121
;  :quant-instantiations    435
;  :rlimit-count            220732)
(assert (forall ((i@71@06 Int)) (!
  (implies
    (and
      (<
        i@71@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
      (<= 0 i@71@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          i@71@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@71@06)
          (Seq_length __flatten_31__30@70@06))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@71@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@71@06))
  :qid |prog.l<no position>|)))
(declare-const $t@72@06 $Snap)
(assert (= $t@72@06 ($Snap.combine ($Snap.first $t@72@06) ($Snap.second $t@72@06))))
(assert (=
  ($Snap.second $t@72@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@72@06))
    ($Snap.second ($Snap.second $t@72@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@72@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@72@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@72@06))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06))))
  2))
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
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@73@06 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 53 | 0 <= i@73@06 | live]
; [else-branch: 53 | !(0 <= i@73@06) | live]
(push) ; 10
; [then-branch: 53 | 0 <= i@73@06]
(assert (<= 0 i@73@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 53 | !(0 <= i@73@06)]
(assert (not (<= 0 i@73@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 54 | i@73@06 < |First:(Second:($t@72@06))| && 0 <= i@73@06 | live]
; [else-branch: 54 | !(i@73@06 < |First:(Second:($t@72@06))| && 0 <= i@73@06) | live]
(push) ; 10
; [then-branch: 54 | i@73@06 < |First:(Second:($t@72@06))| && 0 <= i@73@06]
(assert (and
  (<
    i@73@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))
  (<= 0 i@73@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@73@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7234
;  :arith-add-rows          88
;  :arith-assert-diseq      289
;  :arith-assert-lower      827
;  :arith-assert-upper      551
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        483
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              2005
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3574
;  :mk-clause               2156
;  :num-allocs              4412785
;  :num-checks              237
;  :propagations            1121
;  :quant-instantiations    441
;  :rlimit-count            222171)
; [eval] -1
(push) ; 11
; [then-branch: 55 | First:(Second:($t@72@06))[i@73@06] == -1 | live]
; [else-branch: 55 | First:(Second:($t@72@06))[i@73@06] != -1 | live]
(push) ; 12
; [then-branch: 55 | First:(Second:($t@72@06))[i@73@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
    i@73@06)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 55 | First:(Second:($t@72@06))[i@73@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
      i@73@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@73@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7234
;  :arith-add-rows          88
;  :arith-assert-diseq      289
;  :arith-assert-lower      827
;  :arith-assert-upper      551
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        483
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              2005
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3575
;  :mk-clause               2156
;  :num-allocs              4412785
;  :num-checks              238
;  :propagations            1121
;  :quant-instantiations    441
;  :rlimit-count            222322)
(push) ; 13
; [then-branch: 56 | 0 <= First:(Second:($t@72@06))[i@73@06] | live]
; [else-branch: 56 | !(0 <= First:(Second:($t@72@06))[i@73@06]) | live]
(push) ; 14
; [then-branch: 56 | 0 <= First:(Second:($t@72@06))[i@73@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
    i@73@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@73@06 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7234
;  :arith-add-rows          88
;  :arith-assert-diseq      290
;  :arith-assert-lower      830
;  :arith-assert-upper      551
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        484
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              2005
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3578
;  :mk-clause               2157
;  :num-allocs              4412785
;  :num-checks              239
;  :propagations            1121
;  :quant-instantiations    441
;  :rlimit-count            222426)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 56 | !(0 <= First:(Second:($t@72@06))[i@73@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
      i@73@06))))
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
; [else-branch: 54 | !(i@73@06 < |First:(Second:($t@72@06))| && 0 <= i@73@06)]
(assert (not
  (and
    (<
      i@73@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))
    (<= 0 i@73@06))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@73@06 Int)) (!
  (implies
    (and
      (<
        i@73@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))
      (<= 0 i@73@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
          i@73@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
            i@73@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
            i@73@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
    i@73@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
  __flatten_31__30@70@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7255
;  :arith-add-rows          88
;  :arith-assert-diseq      290
;  :arith-assert-lower      831
;  :arith-assert-upper      552
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    231
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              2006
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3602
;  :mk-clause               2173
;  :num-allocs              4412785
;  :num-checks              240
;  :propagations            1127
;  :quant-instantiations    443
;  :rlimit-count            223461)
(push) ; 8
; [then-branch: 57 | 0 <= First:(Second:($t@67@06))[0] | live]
; [else-branch: 57 | !(0 <= First:(Second:($t@67@06))[0]) | live]
(push) ; 9
; [then-branch: 57 | 0 <= First:(Second:($t@67@06))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7255
;  :arith-add-rows          88
;  :arith-assert-diseq      290
;  :arith-assert-lower      831
;  :arith-assert-upper      552
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    231
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              2006
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3602
;  :mk-clause               2173
;  :num-allocs              4412785
;  :num-checks              241
;  :propagations            1127
;  :quant-instantiations    443
;  :rlimit-count            223561)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7255
;  :arith-add-rows          88
;  :arith-assert-diseq      290
;  :arith-assert-lower      831
;  :arith-assert-upper      552
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               124
;  :datatype-accessor-ax    231
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              2006
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3602
;  :mk-clause               2173
;  :num-allocs              4412785
;  :num-checks              242
;  :propagations            1127
;  :quant-instantiations    443
;  :rlimit-count            223570)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  (Seq_length __flatten_31__30@70@06))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7255
;  :arith-add-rows          88
;  :arith-assert-diseq      290
;  :arith-assert-lower      831
;  :arith-assert-upper      552
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               125
;  :datatype-accessor-ax    231
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              2006
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3602
;  :mk-clause               2173
;  :num-allocs              4412785
;  :num-checks              243
;  :propagations            1127
;  :quant-instantiations    443
;  :rlimit-count            223658)
(push) ; 10
; [then-branch: 58 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0 | live]
; [else-branch: 58 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] != 0 | live]
(push) ; 11
; [then-branch: 58 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@70@06
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 58 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@70@06
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7256
;  :arith-add-rows          89
;  :arith-assert-diseq      290
;  :arith-assert-lower      831
;  :arith-assert-upper      552
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               125
;  :datatype-accessor-ax    231
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              2006
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3607
;  :mk-clause               2178
;  :num-allocs              4412785
;  :num-checks              244
;  :propagations            1127
;  :quant-instantiations    444
;  :rlimit-count            223873)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7256
;  :arith-add-rows          89
;  :arith-assert-diseq      290
;  :arith-assert-lower      831
;  :arith-assert-upper      552
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               125
;  :datatype-accessor-ax    231
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              2006
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3607
;  :mk-clause               2178
;  :num-allocs              4412785
;  :num-checks              245
;  :propagations            1127
;  :quant-instantiations    444
;  :rlimit-count            223882)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  (Seq_length __flatten_31__30@70@06))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7256
;  :arith-add-rows          89
;  :arith-assert-diseq      290
;  :arith-assert-lower      831
;  :arith-assert-upper      552
;  :arith-bound-prop        184
;  :arith-conflicts         17
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         178
;  :arith-offset-eqs        2
;  :arith-pivots            211
;  :binary-propagations     11
;  :conflicts               126
;  :datatype-accessor-ax    231
;  :datatype-constructor-ax 1430
;  :datatype-occurs-check   552
;  :datatype-splits         924
;  :decisions               1515
;  :del-clause              2006
;  :final-checks            196
;  :interface-eqs           43
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             3607
;  :mk-clause               2178
;  :num-allocs              4412785
;  :num-checks              246
;  :propagations            1127
;  :quant-instantiations    444
;  :rlimit-count            223970)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 57 | !(0 <= First:(Second:($t@67@06))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8382
;  :arith-add-rows          190
;  :arith-assert-diseq      358
;  :arith-assert-lower      995
;  :arith-assert-upper      673
;  :arith-bound-prop        198
;  :arith-conflicts         21
;  :arith-eq-adapter        599
;  :arith-fixed-eqs         237
;  :arith-offset-eqs        16
;  :arith-pivots            285
;  :binary-propagations     11
;  :conflicts               143
;  :datatype-accessor-ax    256
;  :datatype-constructor-ax 1616
;  :datatype-occurs-check   615
;  :datatype-splits         1058
;  :decisions               1710
;  :del-clause              2405
;  :final-checks            215
;  :interface-eqs           53
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          55
;  :mk-bool-var             4291
;  :mk-clause               2572
;  :num-allocs              5004754
;  :num-checks              247
;  :propagations            1347
;  :quant-instantiations    535
;  :rlimit-count            233131
;  :time                    0.01)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8800
;  :arith-add-rows          227
;  :arith-assert-diseq      391
;  :arith-assert-lower      1058
;  :arith-assert-upper      735
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            309
;  :binary-propagations     11
;  :conflicts               150
;  :datatype-accessor-ax    260
;  :datatype-constructor-ax 1669
;  :datatype-occurs-check   637
;  :datatype-splits         1088
;  :decisions               1782
;  :del-clause              2581
;  :final-checks            222
;  :interface-eqs           57
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4555
;  :mk-clause               2748
;  :num-allocs              5004754
;  :num-checks              248
;  :propagations            1451
;  :quant-instantiations    581
;  :rlimit-count            237373
;  :time                    0.00)
; [then-branch: 59 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0] | live]
; [else-branch: 59 | !(__flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0]) | live]
(push) ; 9
; [then-branch: 59 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8800
;  :arith-add-rows          227
;  :arith-assert-diseq      391
;  :arith-assert-lower      1058
;  :arith-assert-upper      735
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            309
;  :binary-propagations     11
;  :conflicts               150
;  :datatype-accessor-ax    260
;  :datatype-constructor-ax 1669
;  :datatype-occurs-check   637
;  :datatype-splits         1088
;  :decisions               1782
;  :del-clause              2581
;  :final-checks            222
;  :interface-eqs           57
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4557
;  :mk-clause               2749
;  :num-allocs              5004754
;  :num-checks              249
;  :propagations            1451
;  :quant-instantiations    581
;  :rlimit-count            237541)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 59 | !(__flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8806
;  :arith-add-rows          227
;  :arith-assert-diseq      391
;  :arith-assert-lower      1058
;  :arith-assert-upper      735
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            309
;  :binary-propagations     11
;  :conflicts               150
;  :datatype-accessor-ax    261
;  :datatype-constructor-ax 1669
;  :datatype-occurs-check   637
;  :datatype-splits         1088
;  :decisions               1782
;  :del-clause              2582
;  :final-checks            222
;  :interface-eqs           57
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4563
;  :mk-clause               2753
;  :num-allocs              5004754
;  :num-checks              250
;  :propagations            1451
;  :quant-instantiations    581
;  :rlimit-count            238020)
(push) ; 8
; [then-branch: 60 | 0 <= First:(Second:($t@67@06))[1] | live]
; [else-branch: 60 | !(0 <= First:(Second:($t@67@06))[1]) | live]
(push) ; 9
; [then-branch: 60 | 0 <= First:(Second:($t@67@06))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8806
;  :arith-add-rows          227
;  :arith-assert-diseq      391
;  :arith-assert-lower      1058
;  :arith-assert-upper      735
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            309
;  :binary-propagations     11
;  :conflicts               150
;  :datatype-accessor-ax    261
;  :datatype-constructor-ax 1669
;  :datatype-occurs-check   637
;  :datatype-splits         1088
;  :decisions               1782
;  :del-clause              2582
;  :final-checks            222
;  :interface-eqs           57
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4563
;  :mk-clause               2753
;  :num-allocs              5004754
;  :num-checks              251
;  :propagations            1451
;  :quant-instantiations    581
;  :rlimit-count            238120)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8806
;  :arith-add-rows          227
;  :arith-assert-diseq      391
;  :arith-assert-lower      1058
;  :arith-assert-upper      735
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            309
;  :binary-propagations     11
;  :conflicts               150
;  :datatype-accessor-ax    261
;  :datatype-constructor-ax 1669
;  :datatype-occurs-check   637
;  :datatype-splits         1088
;  :decisions               1782
;  :del-clause              2582
;  :final-checks            222
;  :interface-eqs           57
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4563
;  :mk-clause               2753
;  :num-allocs              5004754
;  :num-checks              252
;  :propagations            1451
;  :quant-instantiations    581
;  :rlimit-count            238129)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  (Seq_length __flatten_31__30@70@06))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8806
;  :arith-add-rows          227
;  :arith-assert-diseq      391
;  :arith-assert-lower      1058
;  :arith-assert-upper      735
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            309
;  :binary-propagations     11
;  :conflicts               151
;  :datatype-accessor-ax    261
;  :datatype-constructor-ax 1669
;  :datatype-occurs-check   637
;  :datatype-splits         1088
;  :decisions               1782
;  :del-clause              2582
;  :final-checks            222
;  :interface-eqs           57
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4563
;  :mk-clause               2753
;  :num-allocs              5004754
;  :num-checks              253
;  :propagations            1451
;  :quant-instantiations    581
;  :rlimit-count            238217)
(push) ; 10
; [then-branch: 61 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0 | live]
; [else-branch: 61 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] != 0 | live]
(push) ; 11
; [then-branch: 61 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@70@06
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      1))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 61 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@70@06
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8807
;  :arith-add-rows          229
;  :arith-assert-diseq      391
;  :arith-assert-lower      1058
;  :arith-assert-upper      735
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            309
;  :binary-propagations     11
;  :conflicts               151
;  :datatype-accessor-ax    261
;  :datatype-constructor-ax 1669
;  :datatype-occurs-check   637
;  :datatype-splits         1088
;  :decisions               1782
;  :del-clause              2582
;  :final-checks            222
;  :interface-eqs           57
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4568
;  :mk-clause               2758
;  :num-allocs              5004754
;  :num-checks              254
;  :propagations            1451
;  :quant-instantiations    582
;  :rlimit-count            238391)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8807
;  :arith-add-rows          229
;  :arith-assert-diseq      391
;  :arith-assert-lower      1058
;  :arith-assert-upper      735
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            309
;  :binary-propagations     11
;  :conflicts               151
;  :datatype-accessor-ax    261
;  :datatype-constructor-ax 1669
;  :datatype-occurs-check   637
;  :datatype-splits         1088
;  :decisions               1782
;  :del-clause              2582
;  :final-checks            222
;  :interface-eqs           57
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4568
;  :mk-clause               2758
;  :num-allocs              5004754
;  :num-checks              255
;  :propagations            1451
;  :quant-instantiations    582
;  :rlimit-count            238400)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  (Seq_length __flatten_31__30@70@06))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8807
;  :arith-add-rows          229
;  :arith-assert-diseq      391
;  :arith-assert-lower      1058
;  :arith-assert-upper      735
;  :arith-bound-prop        206
;  :arith-conflicts         22
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         266
;  :arith-offset-eqs        28
;  :arith-pivots            309
;  :binary-propagations     11
;  :conflicts               152
;  :datatype-accessor-ax    261
;  :datatype-constructor-ax 1669
;  :datatype-occurs-check   637
;  :datatype-splits         1088
;  :decisions               1782
;  :del-clause              2582
;  :final-checks            222
;  :interface-eqs           57
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          67
;  :mk-bool-var             4568
;  :mk-clause               2758
;  :num-allocs              5004754
;  :num-checks              256
;  :propagations            1451
;  :quant-instantiations    582
;  :rlimit-count            238488)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 60 | !(0 <= First:(Second:($t@67@06))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10492
;  :arith-add-rows          469
;  :arith-assert-diseq      512
;  :arith-assert-lower      1317
;  :arith-assert-upper      916
;  :arith-bound-prop        234
;  :arith-conflicts         32
;  :arith-eq-adapter        818
;  :arith-fixed-eqs         355
;  :arith-offset-eqs        56
;  :arith-pivots            410
;  :binary-propagations     11
;  :conflicts               184
;  :datatype-accessor-ax    299
;  :datatype-constructor-ax 1944
;  :datatype-occurs-check   756
;  :datatype-splits         1304
;  :decisions               2085
;  :del-clause              3191
;  :final-checks            251
;  :interface-eqs           72
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          173
;  :mk-bool-var             5557
;  :mk-clause               3362
;  :num-allocs              5211357
;  :num-checks              257
;  :propagations            1845
;  :quant-instantiations    713
;  :rlimit-count            253226
;  :time                    0.01)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11279
;  :arith-add-rows          547
;  :arith-assert-diseq      564
;  :arith-assert-lower      1429
;  :arith-assert-upper      1010
;  :arith-bound-prop        246
;  :arith-conflicts         35
;  :arith-eq-adapter        901
;  :arith-fixed-eqs         406
;  :arith-offset-eqs        78
;  :arith-pivots            450
;  :binary-propagations     11
;  :conflicts               195
;  :datatype-accessor-ax    311
;  :datatype-constructor-ax 2055
;  :datatype-occurs-check   802
;  :datatype-splits         1392
;  :decisions               2216
;  :del-clause              3483
;  :final-checks            263
;  :interface-eqs           78
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          183
;  :mk-bool-var             6054
;  :mk-clause               3654
;  :num-allocs              5211357
;  :num-checks              258
;  :propagations            2006
;  :quant-instantiations    785
;  :rlimit-count            259866
;  :time                    0.00)
; [then-branch: 62 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1] | live]
; [else-branch: 62 | !(__flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1]) | live]
(push) ; 9
; [then-branch: 62 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      1))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11279
;  :arith-add-rows          547
;  :arith-assert-diseq      564
;  :arith-assert-lower      1429
;  :arith-assert-upper      1010
;  :arith-bound-prop        246
;  :arith-conflicts         35
;  :arith-eq-adapter        901
;  :arith-fixed-eqs         406
;  :arith-offset-eqs        78
;  :arith-pivots            450
;  :binary-propagations     11
;  :conflicts               195
;  :datatype-accessor-ax    311
;  :datatype-constructor-ax 2055
;  :datatype-occurs-check   802
;  :datatype-splits         1392
;  :decisions               2216
;  :del-clause              3483
;  :final-checks            263
;  :interface-eqs           78
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          183
;  :mk-bool-var             6056
;  :mk-clause               3655
;  :num-allocs              5211357
;  :num-checks              259
;  :propagations            2006
;  :quant-instantiations    785
;  :rlimit-count            260034)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 62 | !(__flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
      1)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11285
;  :arith-add-rows          547
;  :arith-assert-diseq      564
;  :arith-assert-lower      1429
;  :arith-assert-upper      1010
;  :arith-bound-prop        246
;  :arith-conflicts         35
;  :arith-eq-adapter        901
;  :arith-fixed-eqs         406
;  :arith-offset-eqs        78
;  :arith-pivots            450
;  :binary-propagations     11
;  :conflicts               195
;  :datatype-accessor-ax    312
;  :datatype-constructor-ax 2055
;  :datatype-occurs-check   802
;  :datatype-splits         1392
;  :decisions               2216
;  :del-clause              3484
;  :final-checks            263
;  :interface-eqs           78
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          183
;  :mk-bool-var             6062
;  :mk-clause               3659
;  :num-allocs              5211357
;  :num-checks              260
;  :propagations            2006
;  :quant-instantiations    785
;  :rlimit-count            260523)
(push) ; 8
; [then-branch: 63 | 0 <= First:(Second:($t@67@06))[0] | live]
; [else-branch: 63 | !(0 <= First:(Second:($t@67@06))[0]) | live]
(push) ; 9
; [then-branch: 63 | 0 <= First:(Second:($t@67@06))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11285
;  :arith-add-rows          547
;  :arith-assert-diseq      564
;  :arith-assert-lower      1429
;  :arith-assert-upper      1010
;  :arith-bound-prop        246
;  :arith-conflicts         35
;  :arith-eq-adapter        901
;  :arith-fixed-eqs         406
;  :arith-offset-eqs        78
;  :arith-pivots            450
;  :binary-propagations     11
;  :conflicts               195
;  :datatype-accessor-ax    312
;  :datatype-constructor-ax 2055
;  :datatype-occurs-check   802
;  :datatype-splits         1392
;  :decisions               2216
;  :del-clause              3484
;  :final-checks            263
;  :interface-eqs           78
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          183
;  :mk-bool-var             6062
;  :mk-clause               3659
;  :num-allocs              5211357
;  :num-checks              261
;  :propagations            2006
;  :quant-instantiations    785
;  :rlimit-count            260623)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11285
;  :arith-add-rows          547
;  :arith-assert-diseq      564
;  :arith-assert-lower      1429
;  :arith-assert-upper      1010
;  :arith-bound-prop        246
;  :arith-conflicts         35
;  :arith-eq-adapter        901
;  :arith-fixed-eqs         406
;  :arith-offset-eqs        78
;  :arith-pivots            450
;  :binary-propagations     11
;  :conflicts               195
;  :datatype-accessor-ax    312
;  :datatype-constructor-ax 2055
;  :datatype-occurs-check   802
;  :datatype-splits         1392
;  :decisions               2216
;  :del-clause              3484
;  :final-checks            263
;  :interface-eqs           78
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          183
;  :mk-bool-var             6062
;  :mk-clause               3659
;  :num-allocs              5211357
;  :num-checks              262
;  :propagations            2006
;  :quant-instantiations    785
;  :rlimit-count            260632)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  (Seq_length __flatten_31__30@70@06))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11285
;  :arith-add-rows          547
;  :arith-assert-diseq      564
;  :arith-assert-lower      1429
;  :arith-assert-upper      1010
;  :arith-bound-prop        246
;  :arith-conflicts         35
;  :arith-eq-adapter        901
;  :arith-fixed-eqs         406
;  :arith-offset-eqs        78
;  :arith-pivots            450
;  :binary-propagations     11
;  :conflicts               196
;  :datatype-accessor-ax    312
;  :datatype-constructor-ax 2055
;  :datatype-occurs-check   802
;  :datatype-splits         1392
;  :decisions               2216
;  :del-clause              3484
;  :final-checks            263
;  :interface-eqs           78
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          183
;  :mk-bool-var             6062
;  :mk-clause               3659
;  :num-allocs              5211357
;  :num-checks              263
;  :propagations            2006
;  :quant-instantiations    785
;  :rlimit-count            260720)
(push) ; 10
; [then-branch: 64 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0 | live]
; [else-branch: 64 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] != 0 | live]
(push) ; 11
; [then-branch: 64 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@70@06
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 64 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@70@06
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11286
;  :arith-add-rows          549
;  :arith-assert-diseq      564
;  :arith-assert-lower      1429
;  :arith-assert-upper      1010
;  :arith-bound-prop        246
;  :arith-conflicts         35
;  :arith-eq-adapter        901
;  :arith-fixed-eqs         406
;  :arith-offset-eqs        78
;  :arith-pivots            450
;  :binary-propagations     11
;  :conflicts               196
;  :datatype-accessor-ax    312
;  :datatype-constructor-ax 2055
;  :datatype-occurs-check   802
;  :datatype-splits         1392
;  :decisions               2216
;  :del-clause              3484
;  :final-checks            263
;  :interface-eqs           78
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          183
;  :mk-bool-var             6066
;  :mk-clause               3664
;  :num-allocs              5211357
;  :num-checks              264
;  :propagations            2006
;  :quant-instantiations    786
;  :rlimit-count            260876)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11286
;  :arith-add-rows          549
;  :arith-assert-diseq      564
;  :arith-assert-lower      1429
;  :arith-assert-upper      1010
;  :arith-bound-prop        246
;  :arith-conflicts         35
;  :arith-eq-adapter        901
;  :arith-fixed-eqs         406
;  :arith-offset-eqs        78
;  :arith-pivots            450
;  :binary-propagations     11
;  :conflicts               196
;  :datatype-accessor-ax    312
;  :datatype-constructor-ax 2055
;  :datatype-occurs-check   802
;  :datatype-splits         1392
;  :decisions               2216
;  :del-clause              3484
;  :final-checks            263
;  :interface-eqs           78
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          183
;  :mk-bool-var             6066
;  :mk-clause               3664
;  :num-allocs              5211357
;  :num-checks              265
;  :propagations            2006
;  :quant-instantiations    786
;  :rlimit-count            260885)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  (Seq_length __flatten_31__30@70@06))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11286
;  :arith-add-rows          549
;  :arith-assert-diseq      564
;  :arith-assert-lower      1429
;  :arith-assert-upper      1010
;  :arith-bound-prop        246
;  :arith-conflicts         35
;  :arith-eq-adapter        901
;  :arith-fixed-eqs         406
;  :arith-offset-eqs        78
;  :arith-pivots            450
;  :binary-propagations     11
;  :conflicts               197
;  :datatype-accessor-ax    312
;  :datatype-constructor-ax 2055
;  :datatype-occurs-check   802
;  :datatype-splits         1392
;  :decisions               2216
;  :del-clause              3484
;  :final-checks            263
;  :interface-eqs           78
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          183
;  :mk-bool-var             6066
;  :mk-clause               3664
;  :num-allocs              5211357
;  :num-checks              266
;  :propagations            2006
;  :quant-instantiations    786
;  :rlimit-count            260973)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 63 | !(0 <= First:(Second:($t@67@06))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11757
;  :arith-add-rows          594
;  :arith-assert-diseq      593
;  :arith-assert-lower      1477
;  :arith-assert-upper      1065
;  :arith-bound-prop        254
;  :arith-conflicts         36
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         429
;  :arith-offset-eqs        88
;  :arith-pivots            469
;  :binary-propagations     11
;  :conflicts               206
;  :datatype-accessor-ax    319
;  :datatype-constructor-ax 2125
;  :datatype-occurs-check   829
;  :datatype-splits         1426
;  :decisions               2305
;  :del-clause              3644
;  :final-checks            272
;  :interface-eqs           83
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          195
;  :mk-bool-var             6312
;  :mk-clause               3819
;  :num-allocs              5211357
;  :num-checks              267
;  :propagations            2102
;  :quant-instantiations    828
;  :rlimit-count            265580
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12939
;  :arith-add-rows          668
;  :arith-assert-diseq      647
;  :arith-assert-lower      1583
;  :arith-assert-upper      1154
;  :arith-bound-prop        268
;  :arith-conflicts         40
;  :arith-eq-adapter        1029
;  :arith-fixed-eqs         475
;  :arith-offset-eqs        102
;  :arith-pivots            507
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 2332
;  :datatype-occurs-check   903
;  :datatype-splits         1598
;  :decisions               2514
;  :del-clause              3944
;  :final-checks            290
;  :interface-eqs           91
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          249
;  :mk-bool-var             6894
;  :mk-clause               4119
;  :num-allocs              5211357
;  :num-checks              268
;  :propagations            2289
;  :quant-instantiations    903
;  :rlimit-count            273661
;  :time                    0.00)
; [then-branch: 65 | !(__flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0]) | live]
; [else-branch: 65 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0] | live]
(push) ; 9
; [then-branch: 65 | !(__flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12940
;  :arith-add-rows          670
;  :arith-assert-diseq      647
;  :arith-assert-lower      1583
;  :arith-assert-upper      1154
;  :arith-bound-prop        268
;  :arith-conflicts         40
;  :arith-eq-adapter        1029
;  :arith-fixed-eqs         475
;  :arith-offset-eqs        102
;  :arith-pivots            507
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 2332
;  :datatype-occurs-check   903
;  :datatype-splits         1598
;  :decisions               2514
;  :del-clause              3944
;  :final-checks            290
;  :interface-eqs           91
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          249
;  :mk-bool-var             6898
;  :mk-clause               4124
;  :num-allocs              5211357
;  :num-checks              269
;  :propagations            2291
;  :quant-instantiations    904
;  :rlimit-count            273847)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12940
;  :arith-add-rows          670
;  :arith-assert-diseq      647
;  :arith-assert-lower      1583
;  :arith-assert-upper      1154
;  :arith-bound-prop        268
;  :arith-conflicts         40
;  :arith-eq-adapter        1029
;  :arith-fixed-eqs         475
;  :arith-offset-eqs        102
;  :arith-pivots            507
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 2332
;  :datatype-occurs-check   903
;  :datatype-splits         1598
;  :decisions               2514
;  :del-clause              3944
;  :final-checks            290
;  :interface-eqs           91
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          249
;  :mk-bool-var             6898
;  :mk-clause               4124
;  :num-allocs              5211357
;  :num-checks              270
;  :propagations            2291
;  :quant-instantiations    904
;  :rlimit-count            273862)
(pop) ; 9
(push) ; 9
; [else-branch: 65 | __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
            __flatten_31__30@70@06
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
              0))
          0)
        (=
          (Seq_index
            __flatten_31__30@70@06
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12947
;  :arith-add-rows          670
;  :arith-assert-diseq      647
;  :arith-assert-lower      1583
;  :arith-assert-upper      1154
;  :arith-bound-prop        268
;  :arith-conflicts         40
;  :arith-eq-adapter        1029
;  :arith-fixed-eqs         475
;  :arith-offset-eqs        102
;  :arith-pivots            507
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 2332
;  :datatype-occurs-check   903
;  :datatype-splits         1598
;  :decisions               2514
;  :del-clause              3949
;  :final-checks            290
;  :interface-eqs           91
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          249
;  :mk-bool-var             6901
;  :mk-clause               4127
;  :num-allocs              5211357
;  :num-checks              271
;  :propagations            2291
;  :quant-instantiations    904
;  :rlimit-count            274250)
(push) ; 8
; [then-branch: 66 | 0 <= First:(Second:($t@67@06))[1] | live]
; [else-branch: 66 | !(0 <= First:(Second:($t@67@06))[1]) | live]
(push) ; 9
; [then-branch: 66 | 0 <= First:(Second:($t@67@06))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12947
;  :arith-add-rows          670
;  :arith-assert-diseq      647
;  :arith-assert-lower      1583
;  :arith-assert-upper      1154
;  :arith-bound-prop        268
;  :arith-conflicts         40
;  :arith-eq-adapter        1029
;  :arith-fixed-eqs         475
;  :arith-offset-eqs        102
;  :arith-pivots            507
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 2332
;  :datatype-occurs-check   903
;  :datatype-splits         1598
;  :decisions               2514
;  :del-clause              3949
;  :final-checks            290
;  :interface-eqs           91
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          249
;  :mk-bool-var             6901
;  :mk-clause               4127
;  :num-allocs              5211357
;  :num-checks              272
;  :propagations            2291
;  :quant-instantiations    904
;  :rlimit-count            274350)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12947
;  :arith-add-rows          670
;  :arith-assert-diseq      647
;  :arith-assert-lower      1583
;  :arith-assert-upper      1154
;  :arith-bound-prop        268
;  :arith-conflicts         40
;  :arith-eq-adapter        1029
;  :arith-fixed-eqs         475
;  :arith-offset-eqs        102
;  :arith-pivots            507
;  :binary-propagations     11
;  :conflicts               226
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 2332
;  :datatype-occurs-check   903
;  :datatype-splits         1598
;  :decisions               2514
;  :del-clause              3949
;  :final-checks            290
;  :interface-eqs           91
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          249
;  :mk-bool-var             6901
;  :mk-clause               4127
;  :num-allocs              5211357
;  :num-checks              273
;  :propagations            2291
;  :quant-instantiations    904
;  :rlimit-count            274359)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  (Seq_length __flatten_31__30@70@06))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12947
;  :arith-add-rows          670
;  :arith-assert-diseq      647
;  :arith-assert-lower      1583
;  :arith-assert-upper      1154
;  :arith-bound-prop        268
;  :arith-conflicts         40
;  :arith-eq-adapter        1029
;  :arith-fixed-eqs         475
;  :arith-offset-eqs        102
;  :arith-pivots            507
;  :binary-propagations     11
;  :conflicts               227
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 2332
;  :datatype-occurs-check   903
;  :datatype-splits         1598
;  :decisions               2514
;  :del-clause              3949
;  :final-checks            290
;  :interface-eqs           91
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          249
;  :mk-bool-var             6901
;  :mk-clause               4127
;  :num-allocs              5211357
;  :num-checks              274
;  :propagations            2291
;  :quant-instantiations    904
;  :rlimit-count            274447)
(push) ; 10
; [then-branch: 67 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0 | live]
; [else-branch: 67 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] != 0 | live]
(push) ; 11
; [then-branch: 67 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@70@06
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      1))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 67 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@70@06
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12948
;  :arith-add-rows          672
;  :arith-assert-diseq      647
;  :arith-assert-lower      1583
;  :arith-assert-upper      1154
;  :arith-bound-prop        268
;  :arith-conflicts         40
;  :arith-eq-adapter        1029
;  :arith-fixed-eqs         475
;  :arith-offset-eqs        102
;  :arith-pivots            507
;  :binary-propagations     11
;  :conflicts               227
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 2332
;  :datatype-occurs-check   903
;  :datatype-splits         1598
;  :decisions               2514
;  :del-clause              3949
;  :final-checks            290
;  :interface-eqs           91
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          249
;  :mk-bool-var             6905
;  :mk-clause               4132
;  :num-allocs              5211357
;  :num-checks              275
;  :propagations            2291
;  :quant-instantiations    905
;  :rlimit-count            274603)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12948
;  :arith-add-rows          672
;  :arith-assert-diseq      647
;  :arith-assert-lower      1583
;  :arith-assert-upper      1154
;  :arith-bound-prop        268
;  :arith-conflicts         40
;  :arith-eq-adapter        1029
;  :arith-fixed-eqs         475
;  :arith-offset-eqs        102
;  :arith-pivots            507
;  :binary-propagations     11
;  :conflicts               227
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 2332
;  :datatype-occurs-check   903
;  :datatype-splits         1598
;  :decisions               2514
;  :del-clause              3949
;  :final-checks            290
;  :interface-eqs           91
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          249
;  :mk-bool-var             6905
;  :mk-clause               4132
;  :num-allocs              5211357
;  :num-checks              276
;  :propagations            2291
;  :quant-instantiations    905
;  :rlimit-count            274612)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  (Seq_length __flatten_31__30@70@06))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12948
;  :arith-add-rows          672
;  :arith-assert-diseq      647
;  :arith-assert-lower      1583
;  :arith-assert-upper      1154
;  :arith-bound-prop        268
;  :arith-conflicts         40
;  :arith-eq-adapter        1029
;  :arith-fixed-eqs         475
;  :arith-offset-eqs        102
;  :arith-pivots            507
;  :binary-propagations     11
;  :conflicts               228
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 2332
;  :datatype-occurs-check   903
;  :datatype-splits         1598
;  :decisions               2514
;  :del-clause              3949
;  :final-checks            290
;  :interface-eqs           91
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          249
;  :mk-bool-var             6905
;  :mk-clause               4132
;  :num-allocs              5211357
;  :num-checks              277
;  :propagations            2291
;  :quant-instantiations    905
;  :rlimit-count            274700)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 66 | !(0 <= First:(Second:($t@67@06))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13740
;  :arith-add-rows          752
;  :arith-assert-diseq      699
;  :arith-assert-lower      1693
;  :arith-assert-upper      1247
;  :arith-bound-prop        280
;  :arith-conflicts         43
;  :arith-eq-adapter        1113
;  :arith-fixed-eqs         526
;  :arith-offset-eqs        124
;  :arith-pivots            547
;  :binary-propagations     11
;  :conflicts               239
;  :datatype-accessor-ax    366
;  :datatype-constructor-ax 2440
;  :datatype-occurs-check   947
;  :datatype-splits         1683
;  :decisions               2644
;  :del-clause              4239
;  :final-checks            302
;  :interface-eqs           97
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          268
;  :mk-bool-var             7415
;  :mk-clause               4417
;  :num-allocs              5211357
;  :num-checks              278
;  :propagations            2460
;  :quant-instantiations    981
;  :rlimit-count            281414
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15451
;  :arith-add-rows          921
;  :arith-assert-diseq      792
;  :arith-assert-lower      1872
;  :arith-assert-upper      1376
;  :arith-bound-prop        302
;  :arith-conflicts         51
;  :arith-eq-adapter        1237
;  :arith-fixed-eqs         607
;  :arith-offset-eqs        152
;  :arith-pivots            612
;  :binary-propagations     11
;  :conflicts               269
;  :datatype-accessor-ax    425
;  :datatype-constructor-ax 2755
;  :datatype-occurs-check   1098
;  :datatype-splits         1924
;  :decisions               2954
;  :del-clause              4684
;  :final-checks            330
;  :interface-eqs           112
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          365
;  :mk-bool-var             8261
;  :mk-clause               4862
;  :num-allocs              5211357
;  :num-checks              279
;  :propagations            2774
;  :quant-instantiations    1083
;  :rlimit-count            293885
;  :time                    0.01)
; [then-branch: 68 | !(__flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1]) | live]
; [else-branch: 68 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1] | live]
(push) ; 9
; [then-branch: 68 | !(__flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@70@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1)))))
; [eval] diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15452
;  :arith-add-rows          923
;  :arith-assert-diseq      792
;  :arith-assert-lower      1872
;  :arith-assert-upper      1376
;  :arith-bound-prop        302
;  :arith-conflicts         51
;  :arith-eq-adapter        1237
;  :arith-fixed-eqs         607
;  :arith-offset-eqs        152
;  :arith-pivots            612
;  :binary-propagations     11
;  :conflicts               269
;  :datatype-accessor-ax    425
;  :datatype-constructor-ax 2755
;  :datatype-occurs-check   1098
;  :datatype-splits         1924
;  :decisions               2954
;  :del-clause              4684
;  :final-checks            330
;  :interface-eqs           112
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          365
;  :mk-bool-var             8265
;  :mk-clause               4867
;  :num-allocs              5211357
;  :num-checks              280
;  :propagations            2776
;  :quant-instantiations    1084
;  :rlimit-count            294071)
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15452
;  :arith-add-rows          923
;  :arith-assert-diseq      792
;  :arith-assert-lower      1872
;  :arith-assert-upper      1376
;  :arith-bound-prop        302
;  :arith-conflicts         51
;  :arith-eq-adapter        1237
;  :arith-fixed-eqs         607
;  :arith-offset-eqs        152
;  :arith-pivots            612
;  :binary-propagations     11
;  :conflicts               269
;  :datatype-accessor-ax    425
;  :datatype-constructor-ax 2755
;  :datatype-occurs-check   1098
;  :datatype-splits         1924
;  :decisions               2954
;  :del-clause              4684
;  :final-checks            330
;  :interface-eqs           112
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          365
;  :mk-bool-var             8265
;  :mk-clause               4867
;  :num-allocs              5211357
;  :num-checks              281
;  :propagations            2776
;  :quant-instantiations    1084
;  :rlimit-count            294086)
(pop) ; 9
(push) ; 9
; [else-branch: 68 | __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@70@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@70@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
            __flatten_31__30@70@06
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
              1))
          0)
        (=
          (Seq_index
            __flatten_31__30@70@06
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
              1))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
(declare-const i@74@06 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 69 | 0 <= i@74@06 | live]
; [else-branch: 69 | !(0 <= i@74@06) | live]
(push) ; 10
; [then-branch: 69 | 0 <= i@74@06]
(assert (<= 0 i@74@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 69 | !(0 <= i@74@06)]
(assert (not (<= 0 i@74@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 70 | i@74@06 < |First:(Second:($t@72@06))| && 0 <= i@74@06 | live]
; [else-branch: 70 | !(i@74@06 < |First:(Second:($t@72@06))| && 0 <= i@74@06) | live]
(push) ; 10
; [then-branch: 70 | i@74@06 < |First:(Second:($t@72@06))| && 0 <= i@74@06]
(assert (and
  (<
    i@74@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))
  (<= 0 i@74@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@74@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17175
;  :arith-add-rows          1086
;  :arith-assert-diseq      890
;  :arith-assert-lower      2056
;  :arith-assert-upper      1508
;  :arith-bound-prop        325
;  :arith-conflicts         59
;  :arith-eq-adapter        1363
;  :arith-fixed-eqs         689
;  :arith-offset-eqs        180
;  :arith-pivots            677
;  :binary-propagations     11
;  :conflicts               298
;  :datatype-accessor-ax    484
;  :datatype-constructor-ax 3070
;  :datatype-occurs-check   1249
;  :datatype-splits         2165
;  :decisions               3266
;  :del-clause              5103
;  :final-checks            358
;  :interface-eqs           127
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          462
;  :mk-bool-var             9120
;  :mk-clause               5344
;  :num-allocs              5211357
;  :num-checks              283
;  :propagations            3099
;  :quant-instantiations    1188
;  :rlimit-count            306719)
; [eval] -1
(push) ; 11
; [then-branch: 71 | First:(Second:($t@72@06))[i@74@06] == -1 | live]
; [else-branch: 71 | First:(Second:($t@72@06))[i@74@06] != -1 | live]
(push) ; 12
; [then-branch: 71 | First:(Second:($t@72@06))[i@74@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
    i@74@06)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 71 | First:(Second:($t@72@06))[i@74@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
      i@74@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@74@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17175
;  :arith-add-rows          1086
;  :arith-assert-diseq      891
;  :arith-assert-lower      2059
;  :arith-assert-upper      1509
;  :arith-bound-prop        325
;  :arith-conflicts         59
;  :arith-eq-adapter        1364
;  :arith-fixed-eqs         689
;  :arith-offset-eqs        180
;  :arith-pivots            677
;  :binary-propagations     11
;  :conflicts               298
;  :datatype-accessor-ax    484
;  :datatype-constructor-ax 3070
;  :datatype-occurs-check   1249
;  :datatype-splits         2165
;  :decisions               3266
;  :del-clause              5103
;  :final-checks            358
;  :interface-eqs           127
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          462
;  :mk-bool-var             9126
;  :mk-clause               5348
;  :num-allocs              5211357
;  :num-checks              284
;  :propagations            3101
;  :quant-instantiations    1189
;  :rlimit-count            306927)
(push) ; 13
; [then-branch: 72 | 0 <= First:(Second:($t@72@06))[i@74@06] | live]
; [else-branch: 72 | !(0 <= First:(Second:($t@72@06))[i@74@06]) | live]
(push) ; 14
; [then-branch: 72 | 0 <= First:(Second:($t@72@06))[i@74@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
    i@74@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@74@06 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17175
;  :arith-add-rows          1086
;  :arith-assert-diseq      891
;  :arith-assert-lower      2059
;  :arith-assert-upper      1509
;  :arith-bound-prop        325
;  :arith-conflicts         59
;  :arith-eq-adapter        1364
;  :arith-fixed-eqs         689
;  :arith-offset-eqs        180
;  :arith-pivots            677
;  :binary-propagations     11
;  :conflicts               298
;  :datatype-accessor-ax    484
;  :datatype-constructor-ax 3070
;  :datatype-occurs-check   1249
;  :datatype-splits         2165
;  :decisions               3266
;  :del-clause              5103
;  :final-checks            358
;  :interface-eqs           127
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          462
;  :mk-bool-var             9126
;  :mk-clause               5348
;  :num-allocs              5211357
;  :num-checks              285
;  :propagations            3101
;  :quant-instantiations    1189
;  :rlimit-count            307021)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 72 | !(0 <= First:(Second:($t@72@06))[i@74@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
      i@74@06))))
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
; [else-branch: 70 | !(i@74@06 < |First:(Second:($t@72@06))| && 0 <= i@74@06)]
(assert (not
  (and
    (<
      i@74@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))
    (<= 0 i@74@06))))
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
(assert (not (forall ((i@74@06 Int)) (!
  (implies
    (and
      (<
        i@74@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))
      (<= 0 i@74@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
          i@74@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
            i@74@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
            i@74@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
    i@74@06))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17175
;  :arith-add-rows          1086
;  :arith-assert-diseq      892
;  :arith-assert-lower      2060
;  :arith-assert-upper      1510
;  :arith-bound-prop        325
;  :arith-conflicts         59
;  :arith-eq-adapter        1365
;  :arith-fixed-eqs         689
;  :arith-offset-eqs        180
;  :arith-pivots            677
;  :binary-propagations     11
;  :conflicts               299
;  :datatype-accessor-ax    484
;  :datatype-constructor-ax 3070
;  :datatype-occurs-check   1249
;  :datatype-splits         2165
;  :decisions               3266
;  :del-clause              5119
;  :final-checks            358
;  :interface-eqs           127
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          462
;  :mk-bool-var             9134
;  :mk-clause               5360
;  :num-allocs              5211357
;  :num-checks              286
;  :propagations            3103
;  :quant-instantiations    1190
;  :rlimit-count            307443)
(assert (forall ((i@74@06 Int)) (!
  (implies
    (and
      (<
        i@74@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))
      (<= 0 i@74@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
          i@74@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
            i@74@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
            i@74@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))
    i@74@06))
  :qid |prog.l<no position>|)))
(declare-const $t@75@06 $Snap)
(assert (= $t@75@06 ($Snap.combine ($Snap.first $t@75@06) ($Snap.second $t@75@06))))
(assert (=
  ($Snap.second $t@75@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@75@06))
    ($Snap.second ($Snap.second $t@75@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@75@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@75@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@75@06))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@75@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@76@06 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 73 | 0 <= i@76@06 | live]
; [else-branch: 73 | !(0 <= i@76@06) | live]
(push) ; 10
; [then-branch: 73 | 0 <= i@76@06]
(assert (<= 0 i@76@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 73 | !(0 <= i@76@06)]
(assert (not (<= 0 i@76@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 74 | i@76@06 < |First:(Second:($t@75@06))| && 0 <= i@76@06 | live]
; [else-branch: 74 | !(i@76@06 < |First:(Second:($t@75@06))| && 0 <= i@76@06) | live]
(push) ; 10
; [then-branch: 74 | i@76@06 < |First:(Second:($t@75@06))| && 0 <= i@76@06]
(assert (and
  (<
    i@76@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))))
  (<= 0 i@76@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@76@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17212
;  :arith-add-rows          1086
;  :arith-assert-diseq      892
;  :arith-assert-lower      2065
;  :arith-assert-upper      1513
;  :arith-bound-prop        325
;  :arith-conflicts         59
;  :arith-eq-adapter        1367
;  :arith-fixed-eqs         689
;  :arith-offset-eqs        180
;  :arith-pivots            677
;  :binary-propagations     11
;  :conflicts               299
;  :datatype-accessor-ax    490
;  :datatype-constructor-ax 3070
;  :datatype-occurs-check   1249
;  :datatype-splits         2165
;  :decisions               3266
;  :del-clause              5119
;  :final-checks            358
;  :interface-eqs           127
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          462
;  :mk-bool-var             9156
;  :mk-clause               5360
;  :num-allocs              5211357
;  :num-checks              287
;  :propagations            3103
;  :quant-instantiations    1194
;  :rlimit-count            308831)
; [eval] -1
(push) ; 11
; [then-branch: 75 | First:(Second:($t@75@06))[i@76@06] == -1 | live]
; [else-branch: 75 | First:(Second:($t@75@06))[i@76@06] != -1 | live]
(push) ; 12
; [then-branch: 75 | First:(Second:($t@75@06))[i@76@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
    i@76@06)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 75 | First:(Second:($t@75@06))[i@76@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
      i@76@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@76@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17212
;  :arith-add-rows          1086
;  :arith-assert-diseq      892
;  :arith-assert-lower      2065
;  :arith-assert-upper      1513
;  :arith-bound-prop        325
;  :arith-conflicts         59
;  :arith-eq-adapter        1367
;  :arith-fixed-eqs         689
;  :arith-offset-eqs        180
;  :arith-pivots            677
;  :binary-propagations     11
;  :conflicts               299
;  :datatype-accessor-ax    490
;  :datatype-constructor-ax 3070
;  :datatype-occurs-check   1249
;  :datatype-splits         2165
;  :decisions               3266
;  :del-clause              5119
;  :final-checks            358
;  :interface-eqs           127
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          462
;  :mk-bool-var             9157
;  :mk-clause               5360
;  :num-allocs              5211357
;  :num-checks              288
;  :propagations            3103
;  :quant-instantiations    1194
;  :rlimit-count            308982)
(push) ; 13
; [then-branch: 76 | 0 <= First:(Second:($t@75@06))[i@76@06] | live]
; [else-branch: 76 | !(0 <= First:(Second:($t@75@06))[i@76@06]) | live]
(push) ; 14
; [then-branch: 76 | 0 <= First:(Second:($t@75@06))[i@76@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
    i@76@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@76@06 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17212
;  :arith-add-rows          1086
;  :arith-assert-diseq      893
;  :arith-assert-lower      2068
;  :arith-assert-upper      1513
;  :arith-bound-prop        325
;  :arith-conflicts         59
;  :arith-eq-adapter        1368
;  :arith-fixed-eqs         689
;  :arith-offset-eqs        180
;  :arith-pivots            677
;  :binary-propagations     11
;  :conflicts               299
;  :datatype-accessor-ax    490
;  :datatype-constructor-ax 3070
;  :datatype-occurs-check   1249
;  :datatype-splits         2165
;  :decisions               3266
;  :del-clause              5119
;  :final-checks            358
;  :interface-eqs           127
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          462
;  :mk-bool-var             9160
;  :mk-clause               5361
;  :num-allocs              5211357
;  :num-checks              289
;  :propagations            3103
;  :quant-instantiations    1194
;  :rlimit-count            309086)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 76 | !(0 <= First:(Second:($t@75@06))[i@76@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
      i@76@06))))
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
; [else-branch: 74 | !(i@76@06 < |First:(Second:($t@75@06))| && 0 <= i@76@06)]
(assert (not
  (and
    (<
      i@76@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))))
    (<= 0 i@76@06))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@76@06 Int)) (!
  (implies
    (and
      (<
        i@76@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))))
      (<= 0 i@76@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
          i@76@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
            i@76@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
            i@76@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
    i@76@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@06)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17230
;  :arith-add-rows          1086
;  :arith-assert-diseq      893
;  :arith-assert-lower      2069
;  :arith-assert-upper      1514
;  :arith-bound-prop        325
;  :arith-conflicts         59
;  :arith-eq-adapter        1369
;  :arith-fixed-eqs         690
;  :arith-offset-eqs        180
;  :arith-pivots            677
;  :binary-propagations     11
;  :conflicts               299
;  :datatype-accessor-ax    492
;  :datatype-constructor-ax 3070
;  :datatype-occurs-check   1249
;  :datatype-splits         2165
;  :decisions               3266
;  :del-clause              5120
;  :final-checks            358
;  :interface-eqs           127
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          462
;  :mk-bool-var             9180
;  :mk-clause               5372
;  :num-allocs              5211357
;  :num-checks              290
;  :propagations            3107
;  :quant-instantiations    1196
;  :rlimit-count            310101)
(push) ; 8
; [then-branch: 77 | First:(Second:(Second:(Second:($t@72@06))))[0] == 0 | live]
; [else-branch: 77 | First:(Second:(Second:(Second:($t@72@06))))[0] != 0 | live]
(push) ; 9
; [then-branch: 77 | First:(Second:(Second:(Second:($t@72@06))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 77 | First:(Second:(Second:(Second:($t@72@06))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17231
;  :arith-add-rows          1087
;  :arith-assert-diseq      893
;  :arith-assert-lower      2069
;  :arith-assert-upper      1514
;  :arith-bound-prop        325
;  :arith-conflicts         59
;  :arith-eq-adapter        1369
;  :arith-fixed-eqs         690
;  :arith-offset-eqs        180
;  :arith-pivots            677
;  :binary-propagations     11
;  :conflicts               299
;  :datatype-accessor-ax    492
;  :datatype-constructor-ax 3070
;  :datatype-occurs-check   1249
;  :datatype-splits         2165
;  :decisions               3266
;  :del-clause              5120
;  :final-checks            358
;  :interface-eqs           127
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          462
;  :mk-bool-var             9185
;  :mk-clause               5378
;  :num-allocs              5211357
;  :num-checks              291
;  :propagations            3107
;  :quant-instantiations    1197
;  :rlimit-count            310314)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18522
;  :arith-add-rows          1216
;  :arith-assert-diseq      1055
;  :arith-assert-lower      2379
;  :arith-assert-upper      1712
;  :arith-bound-prop        356
;  :arith-conflicts         61
;  :arith-eq-adapter        1575
;  :arith-fixed-eqs         797
;  :arith-offset-eqs        220
;  :arith-pivots            754
;  :binary-propagations     11
;  :conflicts               328
;  :datatype-accessor-ax    503
;  :datatype-constructor-ax 3178
;  :datatype-occurs-check   1287
;  :datatype-splits         2237
;  :decisions               3444
;  :del-clause              5936
;  :final-checks            363
;  :interface-eqs           130
;  :max-generation          4
;  :max-memory              4.89
;  :memory                  4.89
;  :minimized-lits          484
;  :mk-bool-var             10137
;  :mk-clause               6188
;  :num-allocs              5211357
;  :num-checks              292
;  :propagations            3775
;  :quant-instantiations    1454
;  :rlimit-count            322187
;  :time                    0.01)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19185
;  :arith-add-rows          1245
;  :arith-assert-diseq      1121
;  :arith-assert-lower      2495
;  :arith-assert-upper      1784
;  :arith-bound-prop        364
;  :arith-conflicts         61
;  :arith-eq-adapter        1648
;  :arith-fixed-eqs         841
;  :arith-offset-eqs        237
;  :arith-pivots            781
;  :binary-propagations     11
;  :conflicts               336
;  :datatype-accessor-ax    514
;  :datatype-constructor-ax 3270
;  :datatype-occurs-check   1318
;  :datatype-splits         2277
;  :decisions               3550
;  :del-clause              6207
;  :final-checks            369
;  :interface-eqs           133
;  :max-generation          4
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          487
;  :mk-bool-var             10476
;  :mk-clause               6459
;  :num-allocs              5447229
;  :num-checks              293
;  :propagations            3985
;  :quant-instantiations    1536
;  :rlimit-count            327685
;  :time                    0.00)
; [then-branch: 78 | First:(Second:(Second:(Second:($t@72@06))))[0] == 0 || First:(Second:(Second:(Second:($t@72@06))))[0] == -1 | live]
; [else-branch: 78 | !(First:(Second:(Second:(Second:($t@72@06))))[0] == 0 || First:(Second:(Second:(Second:($t@72@06))))[0] == -1) | live]
(push) ; 9
; [then-branch: 78 | First:(Second:(Second:(Second:($t@72@06))))[0] == 0 || First:(Second:(Second:(Second:($t@72@06))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19185
;  :arith-add-rows          1245
;  :arith-assert-diseq      1121
;  :arith-assert-lower      2495
;  :arith-assert-upper      1784
;  :arith-bound-prop        364
;  :arith-conflicts         61
;  :arith-eq-adapter        1648
;  :arith-fixed-eqs         841
;  :arith-offset-eqs        237
;  :arith-pivots            781
;  :binary-propagations     11
;  :conflicts               336
;  :datatype-accessor-ax    514
;  :datatype-constructor-ax 3270
;  :datatype-occurs-check   1318
;  :datatype-splits         2277
;  :decisions               3550
;  :del-clause              6207
;  :final-checks            369
;  :interface-eqs           133
;  :max-generation          4
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          487
;  :mk-bool-var             10478
;  :mk-clause               6460
;  :num-allocs              5447229
;  :num-checks              294
;  :propagations            3985
;  :quant-instantiations    1536
;  :rlimit-count            327834)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 78 | !(First:(Second:(Second:(Second:($t@72@06))))[0] == 0 || First:(Second:(Second:(Second:($t@72@06))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19191
;  :arith-add-rows          1245
;  :arith-assert-diseq      1121
;  :arith-assert-lower      2495
;  :arith-assert-upper      1784
;  :arith-bound-prop        364
;  :arith-conflicts         61
;  :arith-eq-adapter        1648
;  :arith-fixed-eqs         841
;  :arith-offset-eqs        237
;  :arith-pivots            781
;  :binary-propagations     11
;  :conflicts               336
;  :datatype-accessor-ax    515
;  :datatype-constructor-ax 3270
;  :datatype-occurs-check   1318
;  :datatype-splits         2277
;  :decisions               3550
;  :del-clause              6208
;  :final-checks            369
;  :interface-eqs           133
;  :max-generation          4
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          487
;  :mk-bool-var             10484
;  :mk-clause               6464
;  :num-allocs              5447229
;  :num-checks              295
;  :propagations            3985
;  :quant-instantiations    1536
;  :rlimit-count            328317)
(push) ; 8
; [then-branch: 79 | First:(Second:(Second:(Second:($t@72@06))))[1] == 0 | live]
; [else-branch: 79 | First:(Second:(Second:(Second:($t@72@06))))[1] != 0 | live]
(push) ; 9
; [then-branch: 79 | First:(Second:(Second:(Second:($t@72@06))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 79 | First:(Second:(Second:(Second:($t@72@06))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19192
;  :arith-add-rows          1246
;  :arith-assert-diseq      1121
;  :arith-assert-lower      2495
;  :arith-assert-upper      1784
;  :arith-bound-prop        364
;  :arith-conflicts         61
;  :arith-eq-adapter        1648
;  :arith-fixed-eqs         841
;  :arith-offset-eqs        237
;  :arith-pivots            781
;  :binary-propagations     11
;  :conflicts               336
;  :datatype-accessor-ax    515
;  :datatype-constructor-ax 3270
;  :datatype-occurs-check   1318
;  :datatype-splits         2277
;  :decisions               3550
;  :del-clause              6208
;  :final-checks            369
;  :interface-eqs           133
;  :max-generation          4
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          487
;  :mk-bool-var             10488
;  :mk-clause               6469
;  :num-allocs              5447229
;  :num-checks              296
;  :propagations            3985
;  :quant-instantiations    1537
;  :rlimit-count            328502)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20202
;  :arith-add-rows          1313
;  :arith-assert-diseq      1243
;  :arith-assert-lower      2725
;  :arith-assert-upper      1914
;  :arith-bound-prop        380
;  :arith-conflicts         61
;  :arith-eq-adapter        1801
;  :arith-fixed-eqs         948
;  :arith-offset-eqs        286
;  :arith-pivots            822
;  :binary-propagations     11
;  :conflicts               356
;  :datatype-accessor-ax    526
;  :datatype-constructor-ax 3362
;  :datatype-occurs-check   1349
;  :datatype-splits         2317
;  :decisions               3687
;  :del-clause              6805
;  :final-checks            374
;  :interface-eqs           135
;  :max-generation          4
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          491
;  :mk-bool-var             11105
;  :mk-clause               7061
;  :num-allocs              5447229
;  :num-checks              297
;  :propagations            4481
;  :quant-instantiations    1730
;  :rlimit-count            337339
;  :time                    0.01)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               21067
;  :arith-add-rows          1358
;  :arith-assert-diseq      1320
;  :arith-assert-lower      2864
;  :arith-assert-upper      1994
;  :arith-bound-prop        396
;  :arith-conflicts         61
;  :arith-eq-adapter        1889
;  :arith-fixed-eqs         1019
;  :arith-offset-eqs        322
;  :arith-pivots            849
;  :binary-propagations     11
;  :conflicts               366
;  :datatype-accessor-ax    546
;  :datatype-constructor-ax 3474
;  :datatype-occurs-check   1411
;  :datatype-splits         2393
;  :decisions               3822
;  :del-clause              7137
;  :final-checks            384
;  :interface-eqs           141
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          497
;  :mk-bool-var             11532
;  :mk-clause               7393
;  :num-allocs              5447229
;  :num-checks              298
;  :propagations            4746
;  :quant-instantiations    1838
;  :rlimit-count            344069
;  :time                    0.01)
; [then-branch: 80 | First:(Second:(Second:(Second:($t@72@06))))[1] == 0 || First:(Second:(Second:(Second:($t@72@06))))[1] == -1 | live]
; [else-branch: 80 | !(First:(Second:(Second:(Second:($t@72@06))))[1] == 0 || First:(Second:(Second:(Second:($t@72@06))))[1] == -1) | live]
(push) ; 9
; [then-branch: 80 | First:(Second:(Second:(Second:($t@72@06))))[1] == 0 || First:(Second:(Second:(Second:($t@72@06))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               21067
;  :arith-add-rows          1358
;  :arith-assert-diseq      1320
;  :arith-assert-lower      2864
;  :arith-assert-upper      1994
;  :arith-bound-prop        396
;  :arith-conflicts         61
;  :arith-eq-adapter        1889
;  :arith-fixed-eqs         1019
;  :arith-offset-eqs        322
;  :arith-pivots            849
;  :binary-propagations     11
;  :conflicts               366
;  :datatype-accessor-ax    546
;  :datatype-constructor-ax 3474
;  :datatype-occurs-check   1411
;  :datatype-splits         2393
;  :decisions               3822
;  :del-clause              7137
;  :final-checks            384
;  :interface-eqs           141
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          497
;  :mk-bool-var             11534
;  :mk-clause               7394
;  :num-allocs              5447229
;  :num-checks              299
;  :propagations            4746
;  :quant-instantiations    1838
;  :rlimit-count            344218)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 80 | !(First:(Second:(Second:(Second:($t@72@06))))[1] == 0 || First:(Second:(Second:(Second:($t@72@06))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               21073
;  :arith-add-rows          1358
;  :arith-assert-diseq      1320
;  :arith-assert-lower      2864
;  :arith-assert-upper      1994
;  :arith-bound-prop        396
;  :arith-conflicts         61
;  :arith-eq-adapter        1889
;  :arith-fixed-eqs         1019
;  :arith-offset-eqs        322
;  :arith-pivots            849
;  :binary-propagations     11
;  :conflicts               366
;  :datatype-accessor-ax    547
;  :datatype-constructor-ax 3474
;  :datatype-occurs-check   1411
;  :datatype-splits         2393
;  :decisions               3822
;  :del-clause              7138
;  :final-checks            384
;  :interface-eqs           141
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          497
;  :mk-bool-var             11540
;  :mk-clause               7398
;  :num-allocs              5447229
;  :num-checks              300
;  :propagations            4746
;  :quant-instantiations    1838
;  :rlimit-count            344707)
(push) ; 8
; [then-branch: 81 | First:(Second:(Second:(Second:($t@72@06))))[2] == 0 | live]
; [else-branch: 81 | First:(Second:(Second:(Second:($t@72@06))))[2] != 0 | live]
(push) ; 9
; [then-branch: 81 | First:(Second:(Second:(Second:($t@72@06))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
    2)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 81 | First:(Second:(Second:(Second:($t@72@06))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               21074
;  :arith-add-rows          1359
;  :arith-assert-diseq      1320
;  :arith-assert-lower      2864
;  :arith-assert-upper      1994
;  :arith-bound-prop        396
;  :arith-conflicts         61
;  :arith-eq-adapter        1889
;  :arith-fixed-eqs         1019
;  :arith-offset-eqs        322
;  :arith-pivots            849
;  :binary-propagations     11
;  :conflicts               366
;  :datatype-accessor-ax    547
;  :datatype-constructor-ax 3474
;  :datatype-occurs-check   1411
;  :datatype-splits         2393
;  :decisions               3822
;  :del-clause              7138
;  :final-checks            384
;  :interface-eqs           141
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          497
;  :mk-bool-var             11544
;  :mk-clause               7403
;  :num-allocs              5447229
;  :num-checks              301
;  :propagations            4746
;  :quant-instantiations    1839
;  :rlimit-count            344892)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               21977
;  :arith-add-rows          1407
;  :arith-assert-diseq      1396
;  :arith-assert-lower      3007
;  :arith-assert-upper      2078
;  :arith-bound-prop        410
;  :arith-conflicts         61
;  :arith-eq-adapter        1972
;  :arith-fixed-eqs         1091
;  :arith-offset-eqs        350
;  :arith-pivots            879
;  :binary-propagations     11
;  :conflicts               376
;  :datatype-accessor-ax    567
;  :datatype-constructor-ax 3586
;  :datatype-occurs-check   1460
;  :datatype-splits         2469
;  :decisions               3963
;  :del-clause              7489
;  :final-checks            391
;  :interface-eqs           144
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          511
;  :mk-bool-var             12004
;  :mk-clause               7749
;  :num-allocs              5447229
;  :num-checks              302
;  :propagations            5023
;  :quant-instantiations    1957
;  :rlimit-count            351811
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22691
;  :arith-add-rows          1451
;  :arith-assert-diseq      1475
;  :arith-assert-lower      3138
;  :arith-assert-upper      2158
;  :arith-bound-prop        418
;  :arith-conflicts         61
;  :arith-eq-adapter        2058
;  :arith-fixed-eqs         1139
;  :arith-offset-eqs        362
;  :arith-pivots            912
;  :binary-propagations     11
;  :conflicts               387
;  :datatype-accessor-ax    579
;  :datatype-constructor-ax 3681
;  :datatype-occurs-check   1497
;  :datatype-splits         2511
;  :decisions               4082
;  :del-clause              7805
;  :final-checks            399
;  :interface-eqs           148
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          513
;  :mk-bool-var             12420
;  :mk-clause               8065
;  :num-allocs              5447229
;  :num-checks              303
;  :propagations            5267
;  :quant-instantiations    2053
;  :rlimit-count            358105
;  :time                    0.00)
; [then-branch: 82 | First:(Second:(Second:(Second:($t@72@06))))[2] == 0 || First:(Second:(Second:(Second:($t@72@06))))[2] == -1 | live]
; [else-branch: 82 | !(First:(Second:(Second:(Second:($t@72@06))))[2] == 0 || First:(Second:(Second:(Second:($t@72@06))))[2] == -1) | live]
(push) ; 9
; [then-branch: 82 | First:(Second:(Second:(Second:($t@72@06))))[2] == 0 || First:(Second:(Second:(Second:($t@72@06))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      2)
    (- 0 1))))
; [eval] diz.Main_event_state[2] == -2
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22691
;  :arith-add-rows          1451
;  :arith-assert-diseq      1475
;  :arith-assert-lower      3138
;  :arith-assert-upper      2158
;  :arith-bound-prop        418
;  :arith-conflicts         61
;  :arith-eq-adapter        2058
;  :arith-fixed-eqs         1139
;  :arith-offset-eqs        362
;  :arith-pivots            912
;  :binary-propagations     11
;  :conflicts               387
;  :datatype-accessor-ax    579
;  :datatype-constructor-ax 3681
;  :datatype-occurs-check   1497
;  :datatype-splits         2511
;  :decisions               4082
;  :del-clause              7805
;  :final-checks            399
;  :interface-eqs           148
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          513
;  :mk-bool-var             12422
;  :mk-clause               8066
;  :num-allocs              5447229
;  :num-checks              304
;  :propagations            5267
;  :quant-instantiations    2053
;  :rlimit-count            358254)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 82 | !(First:(Second:(Second:(Second:($t@72@06))))[2] == 0 || First:(Second:(Second:(Second:($t@72@06))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        2)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))
      2)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22697
;  :arith-add-rows          1451
;  :arith-assert-diseq      1475
;  :arith-assert-lower      3138
;  :arith-assert-upper      2158
;  :arith-bound-prop        418
;  :arith-conflicts         61
;  :arith-eq-adapter        2058
;  :arith-fixed-eqs         1139
;  :arith-offset-eqs        362
;  :arith-pivots            912
;  :binary-propagations     11
;  :conflicts               387
;  :datatype-accessor-ax    580
;  :datatype-constructor-ax 3681
;  :datatype-occurs-check   1497
;  :datatype-splits         2511
;  :decisions               4082
;  :del-clause              7806
;  :final-checks            399
;  :interface-eqs           148
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          513
;  :mk-bool-var             12428
;  :mk-clause               8070
;  :num-allocs              5447229
;  :num-checks              305
;  :propagations            5267
;  :quant-instantiations    2053
;  :rlimit-count            358753)
(push) ; 8
; [then-branch: 83 | First:(Second:(Second:(Second:($t@72@06))))[0] == 0 | live]
; [else-branch: 83 | First:(Second:(Second:(Second:($t@72@06))))[0] != 0 | live]
(push) ; 9
; [then-branch: 83 | First:(Second:(Second:(Second:($t@72@06))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 83 | First:(Second:(Second:(Second:($t@72@06))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22698
;  :arith-add-rows          1452
;  :arith-assert-diseq      1475
;  :arith-assert-lower      3138
;  :arith-assert-upper      2158
;  :arith-bound-prop        418
;  :arith-conflicts         61
;  :arith-eq-adapter        2058
;  :arith-fixed-eqs         1139
;  :arith-offset-eqs        362
;  :arith-pivots            912
;  :binary-propagations     11
;  :conflicts               387
;  :datatype-accessor-ax    580
;  :datatype-constructor-ax 3681
;  :datatype-occurs-check   1497
;  :datatype-splits         2511
;  :decisions               4082
;  :del-clause              7806
;  :final-checks            399
;  :interface-eqs           148
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          513
;  :mk-bool-var             12432
;  :mk-clause               8076
;  :num-allocs              5447229
;  :num-checks              306
;  :propagations            5267
;  :quant-instantiations    2054
;  :rlimit-count            358922)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               23399
;  :arith-add-rows          1496
;  :arith-assert-diseq      1552
;  :arith-assert-lower      3271
;  :arith-assert-upper      2239
;  :arith-bound-prop        426
;  :arith-conflicts         61
;  :arith-eq-adapter        2144
;  :arith-fixed-eqs         1184
;  :arith-offset-eqs        374
;  :arith-pivots            945
;  :binary-propagations     11
;  :conflicts               398
;  :datatype-accessor-ax    592
;  :datatype-constructor-ax 3776
;  :datatype-occurs-check   1534
;  :datatype-splits         2553
;  :decisions               4200
;  :del-clause              8122
;  :final-checks            407
;  :interface-eqs           152
;  :max-generation          5
;  :max-memory              4.99
;  :memory                  4.99
;  :minimized-lits          515
;  :mk-bool-var             12836
;  :mk-clause               8386
;  :num-allocs              5447229
;  :num-checks              307
;  :propagations            5507
;  :quant-instantiations    2146
;  :rlimit-count            365153
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24653
;  :arith-add-rows          1646
;  :arith-assert-diseq      1709
;  :arith-assert-lower      3579
;  :arith-assert-upper      2434
;  :arith-bound-prop        446
;  :arith-conflicts         63
;  :arith-eq-adapter        2341
;  :arith-fixed-eqs         1311
;  :arith-offset-eqs        428
;  :arith-pivots            1020
;  :binary-propagations     11
;  :conflicts               428
;  :datatype-accessor-ax    599
;  :datatype-constructor-ax 3858
;  :datatype-occurs-check   1571
;  :datatype-splits         2595
;  :decisions               4370
;  :del-clause              8950
;  :final-checks            413
;  :interface-eqs           154
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          553
;  :mk-bool-var             13819
;  :mk-clause               9214
;  :num-allocs              5703136
;  :num-checks              308
;  :propagations            6191
;  :quant-instantiations    2423
;  :rlimit-count            377936
;  :time                    0.01)
; [then-branch: 84 | !(First:(Second:(Second:(Second:($t@72@06))))[0] == 0 || First:(Second:(Second:(Second:($t@72@06))))[0] == -1) | live]
; [else-branch: 84 | First:(Second:(Second:(Second:($t@72@06))))[0] == 0 || First:(Second:(Second:(Second:($t@72@06))))[0] == -1 | live]
(push) ; 9
; [then-branch: 84 | !(First:(Second:(Second:(Second:($t@72@06))))[0] == 0 || First:(Second:(Second:(Second:($t@72@06))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24654
;  :arith-add-rows          1647
;  :arith-assert-diseq      1709
;  :arith-assert-lower      3579
;  :arith-assert-upper      2434
;  :arith-bound-prop        446
;  :arith-conflicts         63
;  :arith-eq-adapter        2341
;  :arith-fixed-eqs         1311
;  :arith-offset-eqs        428
;  :arith-pivots            1020
;  :binary-propagations     11
;  :conflicts               428
;  :datatype-accessor-ax    599
;  :datatype-constructor-ax 3858
;  :datatype-occurs-check   1571
;  :datatype-splits         2595
;  :decisions               4370
;  :del-clause              8950
;  :final-checks            413
;  :interface-eqs           154
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          553
;  :mk-bool-var             13823
;  :mk-clause               9220
;  :num-allocs              5703136
;  :num-checks              309
;  :propagations            6192
;  :quant-instantiations    2424
;  :rlimit-count            378126)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24654
;  :arith-add-rows          1647
;  :arith-assert-diseq      1709
;  :arith-assert-lower      3579
;  :arith-assert-upper      2434
;  :arith-bound-prop        446
;  :arith-conflicts         63
;  :arith-eq-adapter        2341
;  :arith-fixed-eqs         1311
;  :arith-offset-eqs        428
;  :arith-pivots            1020
;  :binary-propagations     11
;  :conflicts               428
;  :datatype-accessor-ax    599
;  :datatype-constructor-ax 3858
;  :datatype-occurs-check   1571
;  :datatype-splits         2595
;  :decisions               4370
;  :del-clause              8950
;  :final-checks            413
;  :interface-eqs           154
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          553
;  :mk-bool-var             13823
;  :mk-clause               9220
;  :num-allocs              5703136
;  :num-checks              310
;  :propagations            6192
;  :quant-instantiations    2424
;  :rlimit-count            378141)
(pop) ; 9
(push) ; 9
; [else-branch: 84 | First:(Second:(Second:(Second:($t@72@06))))[0] == 0 || First:(Second:(Second:(Second:($t@72@06))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24660
;  :arith-add-rows          1647
;  :arith-assert-diseq      1709
;  :arith-assert-lower      3579
;  :arith-assert-upper      2434
;  :arith-bound-prop        446
;  :arith-conflicts         63
;  :arith-eq-adapter        2341
;  :arith-fixed-eqs         1311
;  :arith-offset-eqs        428
;  :arith-pivots            1020
;  :binary-propagations     11
;  :conflicts               428
;  :datatype-accessor-ax    600
;  :datatype-constructor-ax 3858
;  :datatype-occurs-check   1571
;  :datatype-splits         2595
;  :decisions               4370
;  :del-clause              8956
;  :final-checks            413
;  :interface-eqs           154
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          553
;  :mk-bool-var             13826
;  :mk-clause               9221
;  :num-allocs              5703136
;  :num-checks              311
;  :propagations            6192
;  :quant-instantiations    2424
;  :rlimit-count            378590)
(push) ; 8
; [then-branch: 85 | First:(Second:(Second:(Second:($t@72@06))))[1] == 0 | live]
; [else-branch: 85 | First:(Second:(Second:(Second:($t@72@06))))[1] != 0 | live]
(push) ; 9
; [then-branch: 85 | First:(Second:(Second:(Second:($t@72@06))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 85 | First:(Second:(Second:(Second:($t@72@06))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24661
;  :arith-add-rows          1648
;  :arith-assert-diseq      1709
;  :arith-assert-lower      3579
;  :arith-assert-upper      2434
;  :arith-bound-prop        446
;  :arith-conflicts         63
;  :arith-eq-adapter        2341
;  :arith-fixed-eqs         1311
;  :arith-offset-eqs        428
;  :arith-pivots            1020
;  :binary-propagations     11
;  :conflicts               428
;  :datatype-accessor-ax    600
;  :datatype-constructor-ax 3858
;  :datatype-occurs-check   1571
;  :datatype-splits         2595
;  :decisions               4370
;  :del-clause              8956
;  :final-checks            413
;  :interface-eqs           154
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          553
;  :mk-bool-var             13829
;  :mk-clause               9226
;  :num-allocs              5703136
;  :num-checks              312
;  :propagations            6192
;  :quant-instantiations    2425
;  :rlimit-count            378759)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25593
;  :arith-add-rows          1689
;  :arith-assert-diseq      1796
;  :arith-assert-lower      3738
;  :arith-assert-upper      2523
;  :arith-bound-prop        460
;  :arith-conflicts         63
;  :arith-eq-adapter        2436
;  :arith-fixed-eqs         1378
;  :arith-offset-eqs        453
;  :arith-pivots            1054
;  :binary-propagations     11
;  :conflicts               439
;  :datatype-accessor-ax    621
;  :datatype-constructor-ax 3973
;  :datatype-occurs-check   1627
;  :datatype-splits         2673
;  :decisions               4514
;  :del-clause              9333
;  :final-checks            421
;  :interface-eqs           157
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          561
;  :mk-bool-var             14315
;  :mk-clause               9598
;  :num-allocs              5703136
;  :num-checks              313
;  :propagations            6498
;  :quant-instantiations    2550
;  :rlimit-count            386005
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26673
;  :arith-add-rows          1758
;  :arith-assert-diseq      1918
;  :arith-assert-lower      3958
;  :arith-assert-upper      2657
;  :arith-bound-prop        474
;  :arith-conflicts         63
;  :arith-eq-adapter        2588
;  :arith-fixed-eqs         1487
;  :arith-offset-eqs        503
;  :arith-pivots            1091
;  :binary-propagations     11
;  :conflicts               461
;  :datatype-accessor-ax    633
;  :datatype-constructor-ax 4068
;  :datatype-occurs-check   1664
;  :datatype-splits         2715
;  :decisions               4660
;  :del-clause              9880
;  :final-checks            427
;  :interface-eqs           159
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          574
;  :mk-bool-var             14953
;  :mk-clause               10145
;  :num-allocs              5703136
;  :num-checks              314
;  :propagations            6993
;  :quant-instantiations    2751
;  :rlimit-count            395239
;  :time                    0.01)
; [then-branch: 86 | !(First:(Second:(Second:(Second:($t@72@06))))[1] == 0 || First:(Second:(Second:(Second:($t@72@06))))[1] == -1) | live]
; [else-branch: 86 | First:(Second:(Second:(Second:($t@72@06))))[1] == 0 || First:(Second:(Second:(Second:($t@72@06))))[1] == -1 | live]
(push) ; 9
; [then-branch: 86 | !(First:(Second:(Second:(Second:($t@72@06))))[1] == 0 || First:(Second:(Second:(Second:($t@72@06))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26674
;  :arith-add-rows          1759
;  :arith-assert-diseq      1918
;  :arith-assert-lower      3958
;  :arith-assert-upper      2657
;  :arith-bound-prop        474
;  :arith-conflicts         63
;  :arith-eq-adapter        2588
;  :arith-fixed-eqs         1487
;  :arith-offset-eqs        503
;  :arith-pivots            1091
;  :binary-propagations     11
;  :conflicts               461
;  :datatype-accessor-ax    633
;  :datatype-constructor-ax 4068
;  :datatype-occurs-check   1664
;  :datatype-splits         2715
;  :decisions               4660
;  :del-clause              9880
;  :final-checks            427
;  :interface-eqs           159
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          574
;  :mk-bool-var             14956
;  :mk-clause               10150
;  :num-allocs              5703136
;  :num-checks              315
;  :propagations            6994
;  :quant-instantiations    2752
;  :rlimit-count            395429)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26674
;  :arith-add-rows          1759
;  :arith-assert-diseq      1918
;  :arith-assert-lower      3958
;  :arith-assert-upper      2657
;  :arith-bound-prop        474
;  :arith-conflicts         63
;  :arith-eq-adapter        2588
;  :arith-fixed-eqs         1487
;  :arith-offset-eqs        503
;  :arith-pivots            1091
;  :binary-propagations     11
;  :conflicts               461
;  :datatype-accessor-ax    633
;  :datatype-constructor-ax 4068
;  :datatype-occurs-check   1664
;  :datatype-splits         2715
;  :decisions               4660
;  :del-clause              9880
;  :final-checks            427
;  :interface-eqs           159
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          574
;  :mk-bool-var             14956
;  :mk-clause               10150
;  :num-allocs              5703136
;  :num-checks              316
;  :propagations            6994
;  :quant-instantiations    2752
;  :rlimit-count            395444)
(pop) ; 9
(push) ; 9
; [else-branch: 86 | First:(Second:(Second:(Second:($t@72@06))))[1] == 0 || First:(Second:(Second:(Second:($t@72@06))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@06))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26683
;  :arith-add-rows          1759
;  :arith-assert-diseq      1918
;  :arith-assert-lower      3958
;  :arith-assert-upper      2657
;  :arith-bound-prop        474
;  :arith-conflicts         63
;  :arith-eq-adapter        2588
;  :arith-fixed-eqs         1487
;  :arith-offset-eqs        503
;  :arith-pivots            1091
;  :binary-propagations     11
;  :conflicts               461
;  :datatype-accessor-ax    633
;  :datatype-constructor-ax 4068
;  :datatype-occurs-check   1664
;  :datatype-splits         2715
;  :decisions               4660
;  :del-clause              9885
;  :final-checks            427
;  :interface-eqs           159
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          574
;  :mk-bool-var             14958
;  :mk-clause               10151
;  :num-allocs              5703136
;  :num-checks              317
;  :propagations            6994
;  :quant-instantiations    2752
;  :rlimit-count            395818)
(push) ; 8
; [then-branch: 87 | First:(Second:(Second:(Second:($t@72@06))))[2] == 0 | live]
; [else-branch: 87 | First:(Second:(Second:(Second:($t@72@06))))[2] != 0 | live]
(push) ; 9
; [then-branch: 87 | First:(Second:(Second:(Second:($t@72@06))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
    2)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 87 | First:(Second:(Second:(Second:($t@72@06))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26684
;  :arith-add-rows          1760
;  :arith-assert-diseq      1918
;  :arith-assert-lower      3958
;  :arith-assert-upper      2657
;  :arith-bound-prop        474
;  :arith-conflicts         63
;  :arith-eq-adapter        2588
;  :arith-fixed-eqs         1487
;  :arith-offset-eqs        503
;  :arith-pivots            1091
;  :binary-propagations     11
;  :conflicts               461
;  :datatype-accessor-ax    633
;  :datatype-constructor-ax 4068
;  :datatype-occurs-check   1664
;  :datatype-splits         2715
;  :decisions               4660
;  :del-clause              9885
;  :final-checks            427
;  :interface-eqs           159
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          574
;  :mk-bool-var             14961
;  :mk-clause               10156
;  :num-allocs              5703136
;  :num-checks              318
;  :propagations            6994
;  :quant-instantiations    2753
;  :rlimit-count            395987)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27411
;  :arith-add-rows          1787
;  :arith-assert-diseq      1997
;  :arith-assert-lower      4088
;  :arith-assert-upper      2735
;  :arith-bound-prop        481
;  :arith-conflicts         63
;  :arith-eq-adapter        2672
;  :arith-fixed-eqs         1541
;  :arith-offset-eqs        518
;  :arith-pivots            1121
;  :binary-propagations     11
;  :conflicts               472
;  :datatype-accessor-ax    645
;  :datatype-constructor-ax 4162
;  :datatype-occurs-check   1701
;  :datatype-splits         2756
;  :decisions               4776
;  :del-clause              10199
;  :final-checks            433
;  :interface-eqs           161
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          576
;  :mk-bool-var             15366
;  :mk-clause               10465
;  :num-allocs              5703136
;  :num-checks              319
;  :propagations            7245
;  :quant-instantiations    2849
;  :rlimit-count            402021
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28323
;  :arith-add-rows          1834
;  :arith-assert-diseq      2073
;  :arith-assert-lower      4231
;  :arith-assert-upper      2819
;  :arith-bound-prop        495
;  :arith-conflicts         63
;  :arith-eq-adapter        2755
;  :arith-fixed-eqs         1613
;  :arith-offset-eqs        546
;  :arith-pivots            1153
;  :binary-propagations     11
;  :conflicts               484
;  :datatype-accessor-ax    666
;  :datatype-constructor-ax 4275
;  :datatype-occurs-check   1757
;  :datatype-splits         2832
;  :decisions               4918
;  :del-clause              10546
;  :final-checks            441
;  :interface-eqs           164
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          590
;  :mk-bool-var             15828
;  :mk-clause               10812
;  :num-allocs              5703136
;  :num-checks              320
;  :propagations            7538
;  :quant-instantiations    2967
;  :rlimit-count            408999
;  :time                    0.00)
; [then-branch: 88 | !(First:(Second:(Second:(Second:($t@72@06))))[2] == 0 || First:(Second:(Second:(Second:($t@72@06))))[2] == -1) | live]
; [else-branch: 88 | First:(Second:(Second:(Second:($t@72@06))))[2] == 0 || First:(Second:(Second:(Second:($t@72@06))))[2] == -1 | live]
(push) ; 9
; [then-branch: 88 | !(First:(Second:(Second:(Second:($t@72@06))))[2] == 0 || First:(Second:(Second:(Second:($t@72@06))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
        2)
      (- 0 1)))))
; [eval] diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28324
;  :arith-add-rows          1835
;  :arith-assert-diseq      2073
;  :arith-assert-lower      4231
;  :arith-assert-upper      2819
;  :arith-bound-prop        495
;  :arith-conflicts         63
;  :arith-eq-adapter        2755
;  :arith-fixed-eqs         1613
;  :arith-offset-eqs        546
;  :arith-pivots            1153
;  :binary-propagations     11
;  :conflicts               484
;  :datatype-accessor-ax    666
;  :datatype-constructor-ax 4275
;  :datatype-occurs-check   1757
;  :datatype-splits         2832
;  :decisions               4918
;  :del-clause              10546
;  :final-checks            441
;  :interface-eqs           164
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          590
;  :mk-bool-var             15831
;  :mk-clause               10817
;  :num-allocs              5703136
;  :num-checks              321
;  :propagations            7539
;  :quant-instantiations    2968
;  :rlimit-count            409189)
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28324
;  :arith-add-rows          1835
;  :arith-assert-diseq      2073
;  :arith-assert-lower      4231
;  :arith-assert-upper      2819
;  :arith-bound-prop        495
;  :arith-conflicts         63
;  :arith-eq-adapter        2755
;  :arith-fixed-eqs         1613
;  :arith-offset-eqs        546
;  :arith-pivots            1153
;  :binary-propagations     11
;  :conflicts               484
;  :datatype-accessor-ax    666
;  :datatype-constructor-ax 4275
;  :datatype-occurs-check   1757
;  :datatype-splits         2832
;  :decisions               4918
;  :del-clause              10546
;  :final-checks            441
;  :interface-eqs           164
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          590
;  :mk-bool-var             15831
;  :mk-clause               10817
;  :num-allocs              5703136
;  :num-checks              322
;  :propagations            7539
;  :quant-instantiations    2968
;  :rlimit-count            409204)
(pop) ; 9
(push) ; 9
; [else-branch: 88 | First:(Second:(Second:(Second:($t@72@06))))[2] == 0 || First:(Second:(Second:(Second:($t@72@06))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
          2)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
          2)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@06)))))
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
(declare-const i@77@06 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 89 | 0 <= i@77@06 | live]
; [else-branch: 89 | !(0 <= i@77@06) | live]
(push) ; 10
; [then-branch: 89 | 0 <= i@77@06]
(assert (<= 0 i@77@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 89 | !(0 <= i@77@06)]
(assert (not (<= 0 i@77@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 90 | i@77@06 < |First:(Second:($t@75@06))| && 0 <= i@77@06 | live]
; [else-branch: 90 | !(i@77@06 < |First:(Second:($t@75@06))| && 0 <= i@77@06) | live]
(push) ; 10
; [then-branch: 90 | i@77@06 < |First:(Second:($t@75@06))| && 0 <= i@77@06]
(assert (and
  (<
    i@77@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))))
  (<= 0 i@77@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@77@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29064
;  :arith-add-rows          1882
;  :arith-assert-diseq      2156
;  :arith-assert-lower      4367
;  :arith-assert-upper      2901
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2843
;  :arith-fixed-eqs         1662
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               495
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10862
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16263
;  :mk-clause               11144
;  :num-allocs              5703136
;  :num-checks              324
;  :propagations            7801
;  :quant-instantiations    3068
;  :rlimit-count            415934)
; [eval] -1
(push) ; 11
; [then-branch: 91 | First:(Second:($t@75@06))[i@77@06] == -1 | live]
; [else-branch: 91 | First:(Second:($t@75@06))[i@77@06] != -1 | live]
(push) ; 12
; [then-branch: 91 | First:(Second:($t@75@06))[i@77@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
    i@77@06)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 91 | First:(Second:($t@75@06))[i@77@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
      i@77@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@77@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2158
;  :arith-assert-lower      4374
;  :arith-assert-upper      2904
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2846
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               495
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10862
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16278
;  :mk-clause               11155
;  :num-allocs              5703136
;  :num-checks              325
;  :propagations            7806
;  :quant-instantiations    3071
;  :rlimit-count            416235)
(push) ; 13
; [then-branch: 92 | 0 <= First:(Second:($t@75@06))[i@77@06] | live]
; [else-branch: 92 | !(0 <= First:(Second:($t@75@06))[i@77@06]) | live]
(push) ; 14
; [then-branch: 92 | 0 <= First:(Second:($t@75@06))[i@77@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
    i@77@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@77@06 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2158
;  :arith-assert-lower      4374
;  :arith-assert-upper      2904
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2846
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               495
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10862
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16278
;  :mk-clause               11155
;  :num-allocs              5703136
;  :num-checks              326
;  :propagations            7806
;  :quant-instantiations    3071
;  :rlimit-count            416329)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 92 | !(0 <= First:(Second:($t@75@06))[i@77@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
      i@77@06))))
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
; [else-branch: 90 | !(i@77@06 < |First:(Second:($t@75@06))| && 0 <= i@77@06)]
(assert (not
  (and
    (<
      i@77@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))))
    (<= 0 i@77@06))))
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
(assert (not (forall ((i@77@06 Int)) (!
  (implies
    (and
      (<
        i@77@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))))
      (<= 0 i@77@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
          i@77@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
            i@77@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
            i@77@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
    i@77@06))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2159
;  :arith-assert-lower      4375
;  :arith-assert-upper      2905
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2848
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               496
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16292
;  :mk-clause               11180
;  :num-allocs              5703136
;  :num-checks              327
;  :propagations            7808
;  :quant-instantiations    3074
;  :rlimit-count            416817)
(assert (forall ((i@77@06 Int)) (!
  (implies
    (and
      (<
        i@77@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))))
      (<= 0 i@77@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
          i@77@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
            i@77@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
            i@77@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@06)))
    i@77@06))
  :qid |prog.l<no position>|)))
(declare-const $k@78@06 $Perm)
(assert ($Perm.isReadVar $k@78@06 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@78@06 $Perm.No) (< $Perm.No $k@78@06))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2160
;  :arith-assert-lower      4377
;  :arith-assert-upper      2906
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2849
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               497
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16297
;  :mk-clause               11182
;  :num-allocs              5703136
;  :num-checks              328
;  :propagations            7809
;  :quant-instantiations    3074
;  :rlimit-count            417342)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@60@06 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2160
;  :arith-assert-lower      4377
;  :arith-assert-upper      2906
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2849
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               497
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16297
;  :mk-clause               11182
;  :num-allocs              5703136
;  :num-checks              329
;  :propagations            7809
;  :quant-instantiations    3074
;  :rlimit-count            417353)
(assert (< $k@78@06 $k@60@06))
(assert (<= $Perm.No (- $k@60@06 $k@78@06)))
(assert (<= (- $k@60@06 $k@78@06) $Perm.Write))
(assert (implies (< $Perm.No (- $k@60@06 $k@78@06)) (not (= diz@30@06 $Ref.null))))
; [eval] diz.Main_sensor != null
(push) ; 8
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2160
;  :arith-assert-lower      4379
;  :arith-assert-upper      2907
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2849
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               498
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16300
;  :mk-clause               11182
;  :num-allocs              5703136
;  :num-checks              330
;  :propagations            7809
;  :quant-instantiations    3074
;  :rlimit-count            417561)
(push) ; 8
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2160
;  :arith-assert-lower      4379
;  :arith-assert-upper      2907
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2849
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               499
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16300
;  :mk-clause               11182
;  :num-allocs              5703136
;  :num-checks              331
;  :propagations            7809
;  :quant-instantiations    3074
;  :rlimit-count            417609)
(push) ; 8
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2160
;  :arith-assert-lower      4379
;  :arith-assert-upper      2907
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2849
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               500
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16300
;  :mk-clause               11182
;  :num-allocs              5703136
;  :num-checks              332
;  :propagations            7809
;  :quant-instantiations    3074
;  :rlimit-count            417657)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2160
;  :arith-assert-lower      4379
;  :arith-assert-upper      2907
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2849
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               500
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16300
;  :mk-clause               11182
;  :num-allocs              5703136
;  :num-checks              333
;  :propagations            7809
;  :quant-instantiations    3074
;  :rlimit-count            417670)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2160
;  :arith-assert-lower      4379
;  :arith-assert-upper      2907
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2849
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               501
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16300
;  :mk-clause               11182
;  :num-allocs              5703136
;  :num-checks              334
;  :propagations            7809
;  :quant-instantiations    3074
;  :rlimit-count            417718)
(declare-const $k@79@06 $Perm)
(assert ($Perm.isReadVar $k@79@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 8
(assert (not (or (= $k@79@06 $Perm.No) (< $Perm.No $k@79@06))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2161
;  :arith-assert-lower      4381
;  :arith-assert-upper      2908
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2850
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               502
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16304
;  :mk-clause               11184
;  :num-allocs              5703136
;  :num-checks              335
;  :propagations            7810
;  :quant-instantiations    3074
;  :rlimit-count            417916)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@61@06 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2161
;  :arith-assert-lower      4381
;  :arith-assert-upper      2908
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2850
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1186
;  :binary-propagations     11
;  :conflicts               502
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16304
;  :mk-clause               11184
;  :num-allocs              5703136
;  :num-checks              336
;  :propagations            7810
;  :quant-instantiations    3074
;  :rlimit-count            417927)
(assert (< $k@79@06 $k@61@06))
(assert (<= $Perm.No (- $k@61@06 $k@79@06)))
(assert (<= (- $k@61@06 $k@79@06) $Perm.Write))
(assert (implies (< $Perm.No (- $k@61@06 $k@79@06)) (not (= diz@30@06 $Ref.null))))
; [eval] diz.Main_controller != null
(push) ; 8
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2161
;  :arith-assert-lower      4383
;  :arith-assert-upper      2909
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2850
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1188
;  :binary-propagations     11
;  :conflicts               503
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16307
;  :mk-clause               11184
;  :num-allocs              5703136
;  :num-checks              337
;  :propagations            7810
;  :quant-instantiations    3074
;  :rlimit-count            418147)
(push) ; 8
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2161
;  :arith-assert-lower      4383
;  :arith-assert-upper      2909
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2850
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1188
;  :binary-propagations     11
;  :conflicts               504
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16307
;  :mk-clause               11184
;  :num-allocs              5703136
;  :num-checks              338
;  :propagations            7810
;  :quant-instantiations    3074
;  :rlimit-count            418195)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2161
;  :arith-assert-lower      4383
;  :arith-assert-upper      2909
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2850
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1188
;  :binary-propagations     11
;  :conflicts               504
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16307
;  :mk-clause               11184
;  :num-allocs              5703136
;  :num-checks              339
;  :propagations            7810
;  :quant-instantiations    3074
;  :rlimit-count            418208)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29068
;  :arith-add-rows          1882
;  :arith-assert-diseq      2161
;  :arith-assert-lower      4383
;  :arith-assert-upper      2909
;  :arith-bound-prop        503
;  :arith-conflicts         63
;  :arith-eq-adapter        2850
;  :arith-fixed-eqs         1663
;  :arith-offset-eqs        559
;  :arith-pivots            1188
;  :binary-propagations     11
;  :conflicts               505
;  :datatype-accessor-ax    678
;  :datatype-constructor-ax 4369
;  :datatype-occurs-check   1794
;  :datatype-splits         2873
;  :decisions               5040
;  :del-clause              10898
;  :final-checks            449
;  :interface-eqs           168
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16307
;  :mk-clause               11184
;  :num-allocs              5703136
;  :num-checks              340
;  :propagations            7810
;  :quant-instantiations    3074
;  :rlimit-count            418256)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@75@06))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@06))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))))
                                ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))))))))))))))))))))) diz@30@06 globals@31@06))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 7
(push) ; 7
; [else-branch: 45 | min_advance__31@69@06 != -1]
(assert (not (= min_advance__31@69@06 (- 0 1))))
(pop) ; 7
; [eval] !(min_advance__31 == -1)
; [eval] min_advance__31 == -1
; [eval] -1
(push) ; 7
(assert (not (= min_advance__31@69@06 (- 0 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29223
;  :arith-add-rows          1883
;  :arith-assert-diseq      2179
;  :arith-assert-lower      4408
;  :arith-assert-upper      2926
;  :arith-bound-prop        507
;  :arith-conflicts         63
;  :arith-eq-adapter        2866
;  :arith-fixed-eqs         1668
;  :arith-offset-eqs        559
;  :arith-pivots            1197
;  :binary-propagations     11
;  :conflicts               506
;  :datatype-accessor-ax    681
;  :datatype-constructor-ax 4399
;  :datatype-occurs-check   1808
;  :datatype-splits         2897
;  :decisions               5079
;  :del-clause              11121
;  :final-checks            454
;  :interface-eqs           170
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16384
;  :mk-clause               11245
;  :num-allocs              5703136
;  :num-checks              341
;  :propagations            7854
;  :quant-instantiations    3082
;  :rlimit-count            420030
;  :time                    0.00)
(push) ; 7
(assert (not (not (= min_advance__31@69@06 (- 0 1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29380
;  :arith-add-rows          1883
;  :arith-assert-diseq      2195
;  :arith-assert-lower      4428
;  :arith-assert-upper      2948
;  :arith-bound-prop        511
;  :arith-conflicts         63
;  :arith-eq-adapter        2882
;  :arith-fixed-eqs         1673
;  :arith-offset-eqs        559
;  :arith-pivots            1201
;  :binary-propagations     11
;  :conflicts               507
;  :datatype-accessor-ax    684
;  :datatype-constructor-ax 4429
;  :datatype-occurs-check   1822
;  :datatype-splits         2921
;  :decisions               5116
;  :del-clause              11177
;  :final-checks            459
;  :interface-eqs           172
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16460
;  :mk-clause               11301
;  :num-allocs              5703136
;  :num-checks              342
;  :propagations            7897
;  :quant-instantiations    3090
;  :rlimit-count            421641
;  :time                    0.00)
; [then-branch: 93 | min_advance__31@69@06 != -1 | live]
; [else-branch: 93 | min_advance__31@69@06 == -1 | live]
(push) ; 7
; [then-branch: 93 | min_advance__31@69@06 != -1]
(assert (not (= min_advance__31@69@06 (- 0 1))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29381
;  :arith-add-rows          1883
;  :arith-assert-diseq      2197
;  :arith-assert-lower      4428
;  :arith-assert-upper      2948
;  :arith-bound-prop        511
;  :arith-conflicts         63
;  :arith-eq-adapter        2883
;  :arith-fixed-eqs         1673
;  :arith-offset-eqs        559
;  :arith-pivots            1201
;  :binary-propagations     11
;  :conflicts               507
;  :datatype-accessor-ax    684
;  :datatype-constructor-ax 4429
;  :datatype-occurs-check   1822
;  :datatype-splits         2921
;  :decisions               5116
;  :del-clause              11177
;  :final-checks            459
;  :interface-eqs           172
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16464
;  :mk-clause               11310
;  :num-allocs              5703136
;  :num-checks              343
;  :propagations            7897
;  :quant-instantiations    3090
;  :rlimit-count            421731)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29535
;  :arith-add-rows          1883
;  :arith-assert-diseq      2213
;  :arith-assert-lower      4453
;  :arith-assert-upper      2965
;  :arith-bound-prop        515
;  :arith-conflicts         63
;  :arith-eq-adapter        2898
;  :arith-fixed-eqs         1678
;  :arith-offset-eqs        559
;  :arith-pivots            1207
;  :binary-propagations     11
;  :conflicts               508
;  :datatype-accessor-ax    687
;  :datatype-constructor-ax 4459
;  :datatype-occurs-check   1836
;  :datatype-splits         2945
;  :decisions               5154
;  :del-clause              11224
;  :final-checks            464
;  :interface-eqs           174
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16537
;  :mk-clause               11357
;  :num-allocs              5703136
;  :num-checks              344
;  :propagations            7939
;  :quant-instantiations    3098
;  :rlimit-count            423434
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29689
;  :arith-add-rows          1887
;  :arith-assert-diseq      2229
;  :arith-assert-lower      4479
;  :arith-assert-upper      2982
;  :arith-bound-prop        519
;  :arith-conflicts         63
;  :arith-eq-adapter        2913
;  :arith-fixed-eqs         1683
;  :arith-offset-eqs        559
;  :arith-pivots            1214
;  :binary-propagations     11
;  :conflicts               509
;  :datatype-accessor-ax    690
;  :datatype-constructor-ax 4489
;  :datatype-occurs-check   1850
;  :datatype-splits         2969
;  :decisions               5192
;  :del-clause              11275
;  :final-checks            469
;  :interface-eqs           176
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16611
;  :mk-clause               11408
;  :num-allocs              5703136
;  :num-checks              345
;  :propagations            7983
;  :quant-instantiations    3106
;  :rlimit-count            425185
;  :time                    0.00)
; [then-branch: 94 | First:(Second:(Second:(Second:($t@67@06))))[0] < -1 | live]
; [else-branch: 94 | !(First:(Second:(Second:(Second:($t@67@06))))[0] < -1) | live]
(push) ; 9
; [then-branch: 94 | First:(Second:(Second:(Second:($t@67@06))))[0] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    0)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 94 | !(First:(Second:(Second:(Second:($t@67@06))))[0] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] - min_advance__31
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29689
;  :arith-add-rows          1887
;  :arith-assert-diseq      2229
;  :arith-assert-lower      4481
;  :arith-assert-upper      2982
;  :arith-bound-prop        519
;  :arith-conflicts         63
;  :arith-eq-adapter        2913
;  :arith-fixed-eqs         1683
;  :arith-offset-eqs        559
;  :arith-pivots            1214
;  :binary-propagations     11
;  :conflicts               509
;  :datatype-accessor-ax    690
;  :datatype-constructor-ax 4489
;  :datatype-occurs-check   1850
;  :datatype-splits         2969
;  :decisions               5192
;  :del-clause              11275
;  :final-checks            469
;  :interface-eqs           176
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16611
;  :mk-clause               11408
;  :num-allocs              5703136
;  :num-checks              346
;  :propagations            7985
;  :quant-instantiations    3106
;  :rlimit-count            425348)
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29689
;  :arith-add-rows          1887
;  :arith-assert-diseq      2229
;  :arith-assert-lower      4481
;  :arith-assert-upper      2982
;  :arith-bound-prop        519
;  :arith-conflicts         63
;  :arith-eq-adapter        2913
;  :arith-fixed-eqs         1683
;  :arith-offset-eqs        559
;  :arith-pivots            1214
;  :binary-propagations     11
;  :conflicts               509
;  :datatype-accessor-ax    690
;  :datatype-constructor-ax 4489
;  :datatype-occurs-check   1850
;  :datatype-splits         2969
;  :decisions               5192
;  :del-clause              11275
;  :final-checks            469
;  :interface-eqs           176
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16611
;  :mk-clause               11408
;  :num-allocs              5703136
;  :num-checks              347
;  :propagations            7985
;  :quant-instantiations    3106
;  :rlimit-count            425363)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29843
;  :arith-add-rows          1887
;  :arith-assert-diseq      2245
;  :arith-assert-lower      4507
;  :arith-assert-upper      2999
;  :arith-bound-prop        523
;  :arith-conflicts         63
;  :arith-eq-adapter        2928
;  :arith-fixed-eqs         1688
;  :arith-offset-eqs        559
;  :arith-pivots            1218
;  :binary-propagations     11
;  :conflicts               510
;  :datatype-accessor-ax    693
;  :datatype-constructor-ax 4519
;  :datatype-occurs-check   1864
;  :datatype-splits         2993
;  :decisions               5230
;  :del-clause              11322
;  :final-checks            474
;  :interface-eqs           178
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16685
;  :mk-clause               11455
;  :num-allocs              5703136
;  :num-checks              348
;  :propagations            8027
;  :quant-instantiations    3114
;  :rlimit-count            427043
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    1)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29997
;  :arith-add-rows          1891
;  :arith-assert-diseq      2261
;  :arith-assert-lower      4532
;  :arith-assert-upper      3016
;  :arith-bound-prop        527
;  :arith-conflicts         63
;  :arith-eq-adapter        2943
;  :arith-fixed-eqs         1693
;  :arith-offset-eqs        559
;  :arith-pivots            1225
;  :binary-propagations     11
;  :conflicts               511
;  :datatype-accessor-ax    696
;  :datatype-constructor-ax 4549
;  :datatype-occurs-check   1878
;  :datatype-splits         3017
;  :decisions               5268
;  :del-clause              11373
;  :final-checks            479
;  :interface-eqs           180
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16758
;  :mk-clause               11506
;  :num-allocs              5703136
;  :num-checks              349
;  :propagations            8071
;  :quant-instantiations    3122
;  :rlimit-count            428785
;  :time                    0.00)
; [then-branch: 95 | First:(Second:(Second:(Second:($t@67@06))))[1] < -1 | live]
; [else-branch: 95 | !(First:(Second:(Second:(Second:($t@67@06))))[1] < -1) | live]
(push) ; 9
; [then-branch: 95 | First:(Second:(Second:(Second:($t@67@06))))[1] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    1)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 95 | !(First:(Second:(Second:(Second:($t@67@06))))[1] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] - min_advance__31
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29997
;  :arith-add-rows          1891
;  :arith-assert-diseq      2261
;  :arith-assert-lower      4534
;  :arith-assert-upper      3016
;  :arith-bound-prop        527
;  :arith-conflicts         63
;  :arith-eq-adapter        2943
;  :arith-fixed-eqs         1693
;  :arith-offset-eqs        559
;  :arith-pivots            1225
;  :binary-propagations     11
;  :conflicts               511
;  :datatype-accessor-ax    696
;  :datatype-constructor-ax 4549
;  :datatype-occurs-check   1878
;  :datatype-splits         3017
;  :decisions               5268
;  :del-clause              11373
;  :final-checks            479
;  :interface-eqs           180
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16758
;  :mk-clause               11506
;  :num-allocs              5703136
;  :num-checks              350
;  :propagations            8073
;  :quant-instantiations    3122
;  :rlimit-count            428948)
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               29997
;  :arith-add-rows          1891
;  :arith-assert-diseq      2261
;  :arith-assert-lower      4534
;  :arith-assert-upper      3016
;  :arith-bound-prop        527
;  :arith-conflicts         63
;  :arith-eq-adapter        2943
;  :arith-fixed-eqs         1693
;  :arith-offset-eqs        559
;  :arith-pivots            1225
;  :binary-propagations     11
;  :conflicts               511
;  :datatype-accessor-ax    696
;  :datatype-constructor-ax 4549
;  :datatype-occurs-check   1878
;  :datatype-splits         3017
;  :decisions               5268
;  :del-clause              11373
;  :final-checks            479
;  :interface-eqs           180
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16758
;  :mk-clause               11506
;  :num-allocs              5703136
;  :num-checks              351
;  :propagations            8073
;  :quant-instantiations    3122
;  :rlimit-count            428963)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30151
;  :arith-add-rows          1891
;  :arith-assert-diseq      2277
;  :arith-assert-lower      4560
;  :arith-assert-upper      3033
;  :arith-bound-prop        531
;  :arith-conflicts         63
;  :arith-eq-adapter        2958
;  :arith-fixed-eqs         1698
;  :arith-offset-eqs        559
;  :arith-pivots            1231
;  :binary-propagations     11
;  :conflicts               512
;  :datatype-accessor-ax    699
;  :datatype-constructor-ax 4579
;  :datatype-occurs-check   1892
;  :datatype-splits         3041
;  :decisions               5306
;  :del-clause              11420
;  :final-checks            484
;  :interface-eqs           182
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16832
;  :mk-clause               11553
;  :num-allocs              5703136
;  :num-checks              352
;  :propagations            8115
;  :quant-instantiations    3130
;  :rlimit-count            430663
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    2)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30305
;  :arith-add-rows          1895
;  :arith-assert-diseq      2293
;  :arith-assert-lower      4585
;  :arith-assert-upper      3050
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2973
;  :arith-fixed-eqs         1703
;  :arith-offset-eqs        559
;  :arith-pivots            1238
;  :binary-propagations     11
;  :conflicts               513
;  :datatype-accessor-ax    702
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11471
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16905
;  :mk-clause               11604
;  :num-allocs              5703136
;  :num-checks              353
;  :propagations            8159
;  :quant-instantiations    3138
;  :rlimit-count            432413
;  :time                    0.00)
; [then-branch: 96 | First:(Second:(Second:(Second:($t@67@06))))[2] < -1 | live]
; [else-branch: 96 | !(First:(Second:(Second:(Second:($t@67@06))))[2] < -1) | live]
(push) ; 9
; [then-branch: 96 | First:(Second:(Second:(Second:($t@67@06))))[2] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
    2)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 96 | !(First:(Second:(Second:(Second:($t@67@06))))[2] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
      2)
    (- 0 1))))
; [eval] diz.Main_event_state[2] - min_advance__31
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30305
;  :arith-add-rows          1895
;  :arith-assert-diseq      2293
;  :arith-assert-lower      4587
;  :arith-assert-upper      3050
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2973
;  :arith-fixed-eqs         1703
;  :arith-offset-eqs        559
;  :arith-pivots            1238
;  :binary-propagations     11
;  :conflicts               513
;  :datatype-accessor-ax    702
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11471
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16905
;  :mk-clause               11604
;  :num-allocs              5703136
;  :num-checks              354
;  :propagations            8161
;  :quant-instantiations    3138
;  :rlimit-count            432576)
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
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
              0)
            (- 0 1))
          (- 0 3)
          (-
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
              0)
            min_advance__31@69@06)))
        (Seq_singleton (ite
          (<
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
              1)
            (- 0 1))
          (- 0 3)
          (-
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
              1)
            min_advance__31@69@06))))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
            2)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
            2)
          min_advance__31@69@06)))))
  3))
(declare-const __flatten_31__30@80@06 Seq<Int>)
(assert (Seq_equal
  __flatten_31__30@80@06
  (Seq_append
    (Seq_append
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
            0)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
            0)
          min_advance__31@69@06)))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
            1)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
            1)
          min_advance__31@69@06))))
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
          2)
        (- 0 1))
      (- 0 3)
      (-
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))
          2)
        min_advance__31@69@06))))))
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
(assert (not (= (Seq_length __flatten_31__30@80@06) 3)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30314
;  :arith-add-rows          1900
;  :arith-assert-diseq      2293
;  :arith-assert-lower      4591
;  :arith-assert-upper      3053
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2978
;  :arith-fixed-eqs         1705
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               514
;  :datatype-accessor-ax    702
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11471
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16940
;  :mk-clause               11627
;  :num-allocs              5703136
;  :num-checks              355
;  :propagations            8166
;  :quant-instantiations    3142
;  :rlimit-count            433485)
(assert (= (Seq_length __flatten_31__30@80@06) 3))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@81@06 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 97 | 0 <= i@81@06 | live]
; [else-branch: 97 | !(0 <= i@81@06) | live]
(push) ; 10
; [then-branch: 97 | 0 <= i@81@06]
(assert (<= 0 i@81@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 97 | !(0 <= i@81@06)]
(assert (not (<= 0 i@81@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 98 | i@81@06 < |First:(Second:($t@67@06))| && 0 <= i@81@06 | live]
; [else-branch: 98 | !(i@81@06 < |First:(Second:($t@67@06))| && 0 <= i@81@06) | live]
(push) ; 10
; [then-branch: 98 | i@81@06 < |First:(Second:($t@67@06))| && 0 <= i@81@06]
(assert (and
  (<
    i@81@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
  (<= 0 i@81@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@81@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30315
;  :arith-add-rows          1900
;  :arith-assert-diseq      2293
;  :arith-assert-lower      4593
;  :arith-assert-upper      3055
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2979
;  :arith-fixed-eqs         1705
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               514
;  :datatype-accessor-ax    702
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11471
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16945
;  :mk-clause               11627
;  :num-allocs              5703136
;  :num-checks              356
;  :propagations            8166
;  :quant-instantiations    3142
;  :rlimit-count            433672)
; [eval] -1
(push) ; 11
; [then-branch: 99 | First:(Second:($t@67@06))[i@81@06] == -1 | live]
; [else-branch: 99 | First:(Second:($t@67@06))[i@81@06] != -1 | live]
(push) ; 12
; [then-branch: 99 | First:(Second:($t@67@06))[i@81@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@81@06)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 99 | First:(Second:($t@67@06))[i@81@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      i@81@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@81@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30319
;  :arith-add-rows          1900
;  :arith-assert-diseq      2295
;  :arith-assert-lower      4600
;  :arith-assert-upper      3058
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2982
;  :arith-fixed-eqs         1706
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               514
;  :datatype-accessor-ax    702
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11471
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16960
;  :mk-clause               11644
;  :num-allocs              5703136
;  :num-checks              357
;  :propagations            8173
;  :quant-instantiations    3145
;  :rlimit-count            433973)
(push) ; 13
; [then-branch: 100 | 0 <= First:(Second:($t@67@06))[i@81@06] | live]
; [else-branch: 100 | !(0 <= First:(Second:($t@67@06))[i@81@06]) | live]
(push) ; 14
; [then-branch: 100 | 0 <= First:(Second:($t@67@06))[i@81@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@81@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@81@06 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30319
;  :arith-add-rows          1900
;  :arith-assert-diseq      2295
;  :arith-assert-lower      4600
;  :arith-assert-upper      3058
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2982
;  :arith-fixed-eqs         1706
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               514
;  :datatype-accessor-ax    702
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11471
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16960
;  :mk-clause               11644
;  :num-allocs              5703136
;  :num-checks              358
;  :propagations            8173
;  :quant-instantiations    3145
;  :rlimit-count            434067)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 100 | !(0 <= First:(Second:($t@67@06))[i@81@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      i@81@06))))
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
; [else-branch: 98 | !(i@81@06 < |First:(Second:($t@67@06))| && 0 <= i@81@06)]
(assert (not
  (and
    (<
      i@81@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
    (<= 0 i@81@06))))
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
(assert (not (forall ((i@81@06 Int)) (!
  (implies
    (and
      (<
        i@81@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
      (<= 0 i@81@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          i@81@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@81@06)
          (Seq_length __flatten_31__30@80@06))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@81@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@81@06))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30319
;  :arith-add-rows          1900
;  :arith-assert-diseq      2296
;  :arith-assert-lower      4601
;  :arith-assert-upper      3059
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2984
;  :arith-fixed-eqs         1706
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               515
;  :datatype-accessor-ax    702
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11513
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16974
;  :mk-clause               11669
;  :num-allocs              5703136
;  :num-checks              359
;  :propagations            8175
;  :quant-instantiations    3148
;  :rlimit-count            434555)
(assert (forall ((i@81@06 Int)) (!
  (implies
    (and
      (<
        i@81@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
      (<= 0 i@81@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          i@81@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@81@06)
          (Seq_length __flatten_31__30@80@06))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@81@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@81@06))
  :qid |prog.l<no position>|)))
(declare-const $t@82@06 $Snap)
(assert (= $t@82@06 ($Snap.combine ($Snap.first $t@82@06) ($Snap.second $t@82@06))))
(assert (=
  ($Snap.second $t@82@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@82@06))
    ($Snap.second ($Snap.second $t@82@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@82@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@82@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@82@06))) $Snap.unit))
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@82@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))
  3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@83@06 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 101 | 0 <= i@83@06 | live]
; [else-branch: 101 | !(0 <= i@83@06) | live]
(push) ; 10
; [then-branch: 101 | 0 <= i@83@06]
(assert (<= 0 i@83@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 101 | !(0 <= i@83@06)]
(assert (not (<= 0 i@83@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 102 | i@83@06 < |First:(Second:($t@82@06))| && 0 <= i@83@06 | live]
; [else-branch: 102 | !(i@83@06 < |First:(Second:($t@82@06))| && 0 <= i@83@06) | live]
(push) ; 10
; [then-branch: 102 | i@83@06 < |First:(Second:($t@82@06))| && 0 <= i@83@06]
(assert (and
  (<
    i@83@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))
  (<= 0 i@83@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@83@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30356
;  :arith-add-rows          1900
;  :arith-assert-diseq      2296
;  :arith-assert-lower      4606
;  :arith-assert-upper      3062
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2986
;  :arith-fixed-eqs         1706
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               515
;  :datatype-accessor-ax    708
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11513
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16996
;  :mk-clause               11669
;  :num-allocs              5703136
;  :num-checks              360
;  :propagations            8175
;  :quant-instantiations    3154
;  :rlimit-count            435995)
; [eval] -1
(push) ; 11
; [then-branch: 103 | First:(Second:($t@82@06))[i@83@06] == -1 | live]
; [else-branch: 103 | First:(Second:($t@82@06))[i@83@06] != -1 | live]
(push) ; 12
; [then-branch: 103 | First:(Second:($t@82@06))[i@83@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
    i@83@06)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 103 | First:(Second:($t@82@06))[i@83@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
      i@83@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@83@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30356
;  :arith-add-rows          1900
;  :arith-assert-diseq      2296
;  :arith-assert-lower      4606
;  :arith-assert-upper      3062
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2986
;  :arith-fixed-eqs         1706
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               515
;  :datatype-accessor-ax    708
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11513
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             16997
;  :mk-clause               11669
;  :num-allocs              5703136
;  :num-checks              361
;  :propagations            8175
;  :quant-instantiations    3154
;  :rlimit-count            436146)
(push) ; 13
; [then-branch: 104 | 0 <= First:(Second:($t@82@06))[i@83@06] | live]
; [else-branch: 104 | !(0 <= First:(Second:($t@82@06))[i@83@06]) | live]
(push) ; 14
; [then-branch: 104 | 0 <= First:(Second:($t@82@06))[i@83@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
    i@83@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@83@06 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30356
;  :arith-add-rows          1900
;  :arith-assert-diseq      2297
;  :arith-assert-lower      4609
;  :arith-assert-upper      3062
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2987
;  :arith-fixed-eqs         1706
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               515
;  :datatype-accessor-ax    708
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11513
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             17000
;  :mk-clause               11670
;  :num-allocs              5703136
;  :num-checks              362
;  :propagations            8175
;  :quant-instantiations    3154
;  :rlimit-count            436250)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 104 | !(0 <= First:(Second:($t@82@06))[i@83@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
      i@83@06))))
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
; [else-branch: 102 | !(i@83@06 < |First:(Second:($t@82@06))| && 0 <= i@83@06)]
(assert (not
  (and
    (<
      i@83@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))
    (<= 0 i@83@06))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@83@06 Int)) (!
  (implies
    (and
      (<
        i@83@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))
      (<= 0 i@83@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
          i@83@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
            i@83@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
            i@83@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
    i@83@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
  __flatten_31__30@80@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30376
;  :arith-add-rows          1900
;  :arith-assert-diseq      2297
;  :arith-assert-lower      4610
;  :arith-assert-upper      3063
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2989
;  :arith-fixed-eqs         1707
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               515
;  :datatype-accessor-ax    710
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11514
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             17023
;  :mk-clause               11686
;  :num-allocs              5703136
;  :num-checks              363
;  :propagations            8181
;  :quant-instantiations    3156
;  :rlimit-count            437291)
(push) ; 8
; [then-branch: 105 | 0 <= First:(Second:($t@67@06))[0] | live]
; [else-branch: 105 | !(0 <= First:(Second:($t@67@06))[0]) | live]
(push) ; 9
; [then-branch: 105 | 0 <= First:(Second:($t@67@06))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30376
;  :arith-add-rows          1900
;  :arith-assert-diseq      2297
;  :arith-assert-lower      4610
;  :arith-assert-upper      3063
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2989
;  :arith-fixed-eqs         1707
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               515
;  :datatype-accessor-ax    710
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11514
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             17023
;  :mk-clause               11686
;  :num-allocs              5703136
;  :num-checks              364
;  :propagations            8181
;  :quant-instantiations    3156
;  :rlimit-count            437391)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30376
;  :arith-add-rows          1900
;  :arith-assert-diseq      2297
;  :arith-assert-lower      4610
;  :arith-assert-upper      3063
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2989
;  :arith-fixed-eqs         1707
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               515
;  :datatype-accessor-ax    710
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11514
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             17023
;  :mk-clause               11686
;  :num-allocs              5703136
;  :num-checks              365
;  :propagations            8181
;  :quant-instantiations    3156
;  :rlimit-count            437400)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  (Seq_length __flatten_31__30@80@06))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30376
;  :arith-add-rows          1900
;  :arith-assert-diseq      2297
;  :arith-assert-lower      4610
;  :arith-assert-upper      3063
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2989
;  :arith-fixed-eqs         1707
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               516
;  :datatype-accessor-ax    710
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11514
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             17023
;  :mk-clause               11686
;  :num-allocs              5703136
;  :num-checks              366
;  :propagations            8181
;  :quant-instantiations    3156
;  :rlimit-count            437488)
(push) ; 10
; [then-branch: 106 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0 | live]
; [else-branch: 106 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] != 0 | live]
(push) ; 11
; [then-branch: 106 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@80@06
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 106 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@80@06
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30377
;  :arith-add-rows          1901
;  :arith-assert-diseq      2297
;  :arith-assert-lower      4610
;  :arith-assert-upper      3063
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2989
;  :arith-fixed-eqs         1707
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               516
;  :datatype-accessor-ax    710
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11514
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             17028
;  :mk-clause               11691
;  :num-allocs              5703136
;  :num-checks              367
;  :propagations            8181
;  :quant-instantiations    3157
;  :rlimit-count            437703)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30377
;  :arith-add-rows          1901
;  :arith-assert-diseq      2297
;  :arith-assert-lower      4610
;  :arith-assert-upper      3063
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2989
;  :arith-fixed-eqs         1707
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               516
;  :datatype-accessor-ax    710
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11514
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             17028
;  :mk-clause               11691
;  :num-allocs              5703136
;  :num-checks              368
;  :propagations            8181
;  :quant-instantiations    3157
;  :rlimit-count            437712)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  (Seq_length __flatten_31__30@80@06))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30377
;  :arith-add-rows          1901
;  :arith-assert-diseq      2297
;  :arith-assert-lower      4610
;  :arith-assert-upper      3063
;  :arith-bound-prop        535
;  :arith-conflicts         63
;  :arith-eq-adapter        2989
;  :arith-fixed-eqs         1707
;  :arith-offset-eqs        560
;  :arith-pivots            1240
;  :binary-propagations     11
;  :conflicts               517
;  :datatype-accessor-ax    710
;  :datatype-constructor-ax 4609
;  :datatype-occurs-check   1906
;  :datatype-splits         3065
;  :decisions               5344
;  :del-clause              11514
;  :final-checks            489
;  :interface-eqs           184
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          592
;  :mk-bool-var             17028
;  :mk-clause               11691
;  :num-allocs              5703136
;  :num-checks              369
;  :propagations            8181
;  :quant-instantiations    3157
;  :rlimit-count            437800)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 105 | !(0 <= First:(Second:($t@67@06))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30739
;  :arith-add-rows          1914
;  :arith-assert-diseq      2322
;  :arith-assert-lower      4670
;  :arith-assert-upper      3107
;  :arith-bound-prop        539
;  :arith-conflicts         63
;  :arith-eq-adapter        3032
;  :arith-fixed-eqs         1729
;  :arith-offset-eqs        562
;  :arith-pivots            1260
;  :binary-propagations     11
;  :conflicts               523
;  :datatype-accessor-ax    715
;  :datatype-constructor-ax 4665
;  :datatype-occurs-check   1928
;  :datatype-splits         3097
;  :decisions               5416
;  :del-clause              11670
;  :final-checks            495
;  :interface-eqs           186
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          597
;  :mk-bool-var             17249
;  :mk-clause               11842
;  :num-allocs              5703136
;  :num-checks              370
;  :propagations            8274
;  :quant-instantiations    3195
;  :rlimit-count            441320
;  :time                    0.00)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31140
;  :arith-add-rows          1949
;  :arith-assert-diseq      2352
;  :arith-assert-lower      4736
;  :arith-assert-upper      3154
;  :arith-bound-prop        546
;  :arith-conflicts         64
;  :arith-eq-adapter        3080
;  :arith-fixed-eqs         1757
;  :arith-offset-eqs        571
;  :arith-pivots            1284
;  :binary-propagations     11
;  :conflicts               531
;  :datatype-accessor-ax    720
;  :datatype-constructor-ax 4721
;  :datatype-occurs-check   1950
;  :datatype-splits         3129
;  :decisions               5489
;  :del-clause              11857
;  :final-checks            502
;  :interface-eqs           189
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          615
;  :mk-bool-var             17513
;  :mk-clause               12029
;  :num-allocs              5703136
;  :num-checks              371
;  :propagations            8378
;  :quant-instantiations    3241
;  :rlimit-count            445539
;  :time                    0.00)
; [then-branch: 107 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0] | live]
; [else-branch: 107 | !(__flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0]) | live]
(push) ; 9
; [then-branch: 107 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31140
;  :arith-add-rows          1949
;  :arith-assert-diseq      2352
;  :arith-assert-lower      4736
;  :arith-assert-upper      3154
;  :arith-bound-prop        546
;  :arith-conflicts         64
;  :arith-eq-adapter        3080
;  :arith-fixed-eqs         1757
;  :arith-offset-eqs        571
;  :arith-pivots            1284
;  :binary-propagations     11
;  :conflicts               531
;  :datatype-accessor-ax    720
;  :datatype-constructor-ax 4721
;  :datatype-occurs-check   1950
;  :datatype-splits         3129
;  :decisions               5489
;  :del-clause              11857
;  :final-checks            502
;  :interface-eqs           189
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          615
;  :mk-bool-var             17515
;  :mk-clause               12030
;  :num-allocs              5703136
;  :num-checks              372
;  :propagations            8378
;  :quant-instantiations    3241
;  :rlimit-count            445707)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 107 | !(__flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31146
;  :arith-add-rows          1949
;  :arith-assert-diseq      2352
;  :arith-assert-lower      4736
;  :arith-assert-upper      3154
;  :arith-bound-prop        546
;  :arith-conflicts         64
;  :arith-eq-adapter        3080
;  :arith-fixed-eqs         1757
;  :arith-offset-eqs        571
;  :arith-pivots            1284
;  :binary-propagations     11
;  :conflicts               531
;  :datatype-accessor-ax    721
;  :datatype-constructor-ax 4721
;  :datatype-occurs-check   1950
;  :datatype-splits         3129
;  :decisions               5489
;  :del-clause              11858
;  :final-checks            502
;  :interface-eqs           189
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          615
;  :mk-bool-var             17521
;  :mk-clause               12034
;  :num-allocs              5703136
;  :num-checks              373
;  :propagations            8378
;  :quant-instantiations    3241
;  :rlimit-count            446186)
(push) ; 8
; [then-branch: 108 | 0 <= First:(Second:($t@67@06))[1] | live]
; [else-branch: 108 | !(0 <= First:(Second:($t@67@06))[1]) | live]
(push) ; 9
; [then-branch: 108 | 0 <= First:(Second:($t@67@06))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31146
;  :arith-add-rows          1949
;  :arith-assert-diseq      2352
;  :arith-assert-lower      4736
;  :arith-assert-upper      3154
;  :arith-bound-prop        546
;  :arith-conflicts         64
;  :arith-eq-adapter        3080
;  :arith-fixed-eqs         1757
;  :arith-offset-eqs        571
;  :arith-pivots            1284
;  :binary-propagations     11
;  :conflicts               531
;  :datatype-accessor-ax    721
;  :datatype-constructor-ax 4721
;  :datatype-occurs-check   1950
;  :datatype-splits         3129
;  :decisions               5489
;  :del-clause              11858
;  :final-checks            502
;  :interface-eqs           189
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          615
;  :mk-bool-var             17521
;  :mk-clause               12034
;  :num-allocs              5703136
;  :num-checks              374
;  :propagations            8378
;  :quant-instantiations    3241
;  :rlimit-count            446286)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31146
;  :arith-add-rows          1949
;  :arith-assert-diseq      2352
;  :arith-assert-lower      4736
;  :arith-assert-upper      3154
;  :arith-bound-prop        546
;  :arith-conflicts         64
;  :arith-eq-adapter        3080
;  :arith-fixed-eqs         1757
;  :arith-offset-eqs        571
;  :arith-pivots            1284
;  :binary-propagations     11
;  :conflicts               531
;  :datatype-accessor-ax    721
;  :datatype-constructor-ax 4721
;  :datatype-occurs-check   1950
;  :datatype-splits         3129
;  :decisions               5489
;  :del-clause              11858
;  :final-checks            502
;  :interface-eqs           189
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          615
;  :mk-bool-var             17521
;  :mk-clause               12034
;  :num-allocs              5703136
;  :num-checks              375
;  :propagations            8378
;  :quant-instantiations    3241
;  :rlimit-count            446295)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  (Seq_length __flatten_31__30@80@06))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31146
;  :arith-add-rows          1949
;  :arith-assert-diseq      2352
;  :arith-assert-lower      4736
;  :arith-assert-upper      3154
;  :arith-bound-prop        546
;  :arith-conflicts         64
;  :arith-eq-adapter        3080
;  :arith-fixed-eqs         1757
;  :arith-offset-eqs        571
;  :arith-pivots            1284
;  :binary-propagations     11
;  :conflicts               532
;  :datatype-accessor-ax    721
;  :datatype-constructor-ax 4721
;  :datatype-occurs-check   1950
;  :datatype-splits         3129
;  :decisions               5489
;  :del-clause              11858
;  :final-checks            502
;  :interface-eqs           189
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          615
;  :mk-bool-var             17521
;  :mk-clause               12034
;  :num-allocs              5703136
;  :num-checks              376
;  :propagations            8378
;  :quant-instantiations    3241
;  :rlimit-count            446383)
(push) ; 10
; [then-branch: 109 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0 | live]
; [else-branch: 109 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] != 0 | live]
(push) ; 11
; [then-branch: 109 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@80@06
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      1))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 109 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@80@06
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31147
;  :arith-add-rows          1951
;  :arith-assert-diseq      2352
;  :arith-assert-lower      4736
;  :arith-assert-upper      3154
;  :arith-bound-prop        546
;  :arith-conflicts         64
;  :arith-eq-adapter        3080
;  :arith-fixed-eqs         1757
;  :arith-offset-eqs        571
;  :arith-pivots            1284
;  :binary-propagations     11
;  :conflicts               532
;  :datatype-accessor-ax    721
;  :datatype-constructor-ax 4721
;  :datatype-occurs-check   1950
;  :datatype-splits         3129
;  :decisions               5489
;  :del-clause              11858
;  :final-checks            502
;  :interface-eqs           189
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          615
;  :mk-bool-var             17526
;  :mk-clause               12039
;  :num-allocs              5703136
;  :num-checks              377
;  :propagations            8378
;  :quant-instantiations    3242
;  :rlimit-count            446557)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31147
;  :arith-add-rows          1951
;  :arith-assert-diseq      2352
;  :arith-assert-lower      4736
;  :arith-assert-upper      3154
;  :arith-bound-prop        546
;  :arith-conflicts         64
;  :arith-eq-adapter        3080
;  :arith-fixed-eqs         1757
;  :arith-offset-eqs        571
;  :arith-pivots            1284
;  :binary-propagations     11
;  :conflicts               532
;  :datatype-accessor-ax    721
;  :datatype-constructor-ax 4721
;  :datatype-occurs-check   1950
;  :datatype-splits         3129
;  :decisions               5489
;  :del-clause              11858
;  :final-checks            502
;  :interface-eqs           189
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          615
;  :mk-bool-var             17526
;  :mk-clause               12039
;  :num-allocs              5703136
;  :num-checks              378
;  :propagations            8378
;  :quant-instantiations    3242
;  :rlimit-count            446566)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  (Seq_length __flatten_31__30@80@06))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31147
;  :arith-add-rows          1951
;  :arith-assert-diseq      2352
;  :arith-assert-lower      4736
;  :arith-assert-upper      3154
;  :arith-bound-prop        546
;  :arith-conflicts         64
;  :arith-eq-adapter        3080
;  :arith-fixed-eqs         1757
;  :arith-offset-eqs        571
;  :arith-pivots            1284
;  :binary-propagations     11
;  :conflicts               533
;  :datatype-accessor-ax    721
;  :datatype-constructor-ax 4721
;  :datatype-occurs-check   1950
;  :datatype-splits         3129
;  :decisions               5489
;  :del-clause              11858
;  :final-checks            502
;  :interface-eqs           189
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          615
;  :mk-bool-var             17526
;  :mk-clause               12039
;  :num-allocs              5703136
;  :num-checks              379
;  :propagations            8378
;  :quant-instantiations    3242
;  :rlimit-count            446654)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 108 | !(0 <= First:(Second:($t@67@06))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               31535
;  :arith-add-rows          1999
;  :arith-assert-diseq      2382
;  :arith-assert-lower      4802
;  :arith-assert-upper      3204
;  :arith-bound-prop        551
;  :arith-conflicts         65
;  :arith-eq-adapter        3128
;  :arith-fixed-eqs         1780
;  :arith-offset-eqs        574
;  :arith-pivots            1305
;  :binary-propagations     11
;  :conflicts               541
;  :datatype-accessor-ax    726
;  :datatype-constructor-ax 4777
;  :datatype-occurs-check   1972
;  :datatype-splits         3161
;  :decisions               5570
;  :del-clause              12045
;  :final-checks            510
;  :interface-eqs           193
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          628
;  :mk-bool-var             17782
;  :mk-clause               12221
;  :num-allocs              5703136
;  :num-checks              380
;  :propagations            8484
;  :quant-instantiations    3286
;  :rlimit-count            450927
;  :time                    0.00)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               32114
;  :arith-add-rows          2077
;  :arith-assert-diseq      2423
;  :arith-assert-lower      4894
;  :arith-assert-upper      3266
;  :arith-bound-prop        561
;  :arith-conflicts         67
;  :arith-eq-adapter        3192
;  :arith-fixed-eqs         1816
;  :arith-offset-eqs        585
;  :arith-pivots            1341
;  :binary-propagations     11
;  :conflicts               551
;  :datatype-accessor-ax    736
;  :datatype-constructor-ax 4863
;  :datatype-occurs-check   2011
;  :datatype-splits         3223
;  :decisions               5678
;  :del-clause              12300
;  :final-checks            521
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          653
;  :mk-bool-var             18161
;  :mk-clause               12476
;  :num-allocs              5703136
;  :num-checks              381
;  :propagations            8623
;  :quant-instantiations    3343
;  :rlimit-count            456817
;  :time                    0.00)
; [then-branch: 110 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1] | live]
; [else-branch: 110 | !(__flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1]) | live]
(push) ; 9
; [then-branch: 110 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      1))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               32114
;  :arith-add-rows          2077
;  :arith-assert-diseq      2423
;  :arith-assert-lower      4894
;  :arith-assert-upper      3266
;  :arith-bound-prop        561
;  :arith-conflicts         67
;  :arith-eq-adapter        3192
;  :arith-fixed-eqs         1816
;  :arith-offset-eqs        585
;  :arith-pivots            1341
;  :binary-propagations     11
;  :conflicts               551
;  :datatype-accessor-ax    736
;  :datatype-constructor-ax 4863
;  :datatype-occurs-check   2011
;  :datatype-splits         3223
;  :decisions               5678
;  :del-clause              12300
;  :final-checks            521
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          653
;  :mk-bool-var             18163
;  :mk-clause               12477
;  :num-allocs              5703136
;  :num-checks              382
;  :propagations            8623
;  :quant-instantiations    3343
;  :rlimit-count            456985)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 110 | !(__flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
      1)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               32120
;  :arith-add-rows          2077
;  :arith-assert-diseq      2423
;  :arith-assert-lower      4894
;  :arith-assert-upper      3266
;  :arith-bound-prop        561
;  :arith-conflicts         67
;  :arith-eq-adapter        3192
;  :arith-fixed-eqs         1816
;  :arith-offset-eqs        585
;  :arith-pivots            1341
;  :binary-propagations     11
;  :conflicts               551
;  :datatype-accessor-ax    737
;  :datatype-constructor-ax 4863
;  :datatype-occurs-check   2011
;  :datatype-splits         3223
;  :decisions               5678
;  :del-clause              12301
;  :final-checks            521
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          653
;  :mk-bool-var             18169
;  :mk-clause               12481
;  :num-allocs              5703136
;  :num-checks              383
;  :propagations            8623
;  :quant-instantiations    3343
;  :rlimit-count            457474)
(push) ; 8
; [then-branch: 111 | 0 <= First:(Second:($t@67@06))[0] | live]
; [else-branch: 111 | !(0 <= First:(Second:($t@67@06))[0]) | live]
(push) ; 9
; [then-branch: 111 | 0 <= First:(Second:($t@67@06))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               32120
;  :arith-add-rows          2077
;  :arith-assert-diseq      2423
;  :arith-assert-lower      4894
;  :arith-assert-upper      3266
;  :arith-bound-prop        561
;  :arith-conflicts         67
;  :arith-eq-adapter        3192
;  :arith-fixed-eqs         1816
;  :arith-offset-eqs        585
;  :arith-pivots            1341
;  :binary-propagations     11
;  :conflicts               551
;  :datatype-accessor-ax    737
;  :datatype-constructor-ax 4863
;  :datatype-occurs-check   2011
;  :datatype-splits         3223
;  :decisions               5678
;  :del-clause              12301
;  :final-checks            521
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          653
;  :mk-bool-var             18169
;  :mk-clause               12481
;  :num-allocs              5703136
;  :num-checks              384
;  :propagations            8623
;  :quant-instantiations    3343
;  :rlimit-count            457574)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               32120
;  :arith-add-rows          2077
;  :arith-assert-diseq      2423
;  :arith-assert-lower      4894
;  :arith-assert-upper      3266
;  :arith-bound-prop        561
;  :arith-conflicts         67
;  :arith-eq-adapter        3192
;  :arith-fixed-eqs         1816
;  :arith-offset-eqs        585
;  :arith-pivots            1341
;  :binary-propagations     11
;  :conflicts               551
;  :datatype-accessor-ax    737
;  :datatype-constructor-ax 4863
;  :datatype-occurs-check   2011
;  :datatype-splits         3223
;  :decisions               5678
;  :del-clause              12301
;  :final-checks            521
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          653
;  :mk-bool-var             18169
;  :mk-clause               12481
;  :num-allocs              5703136
;  :num-checks              385
;  :propagations            8623
;  :quant-instantiations    3343
;  :rlimit-count            457583)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  (Seq_length __flatten_31__30@80@06))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               32120
;  :arith-add-rows          2077
;  :arith-assert-diseq      2423
;  :arith-assert-lower      4894
;  :arith-assert-upper      3266
;  :arith-bound-prop        561
;  :arith-conflicts         67
;  :arith-eq-adapter        3192
;  :arith-fixed-eqs         1816
;  :arith-offset-eqs        585
;  :arith-pivots            1341
;  :binary-propagations     11
;  :conflicts               552
;  :datatype-accessor-ax    737
;  :datatype-constructor-ax 4863
;  :datatype-occurs-check   2011
;  :datatype-splits         3223
;  :decisions               5678
;  :del-clause              12301
;  :final-checks            521
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          653
;  :mk-bool-var             18169
;  :mk-clause               12481
;  :num-allocs              5703136
;  :num-checks              386
;  :propagations            8623
;  :quant-instantiations    3343
;  :rlimit-count            457671)
(push) ; 10
; [then-branch: 112 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0 | live]
; [else-branch: 112 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] != 0 | live]
(push) ; 11
; [then-branch: 112 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@80@06
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 112 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@80@06
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               32121
;  :arith-add-rows          2079
;  :arith-assert-diseq      2423
;  :arith-assert-lower      4894
;  :arith-assert-upper      3266
;  :arith-bound-prop        561
;  :arith-conflicts         67
;  :arith-eq-adapter        3192
;  :arith-fixed-eqs         1816
;  :arith-offset-eqs        585
;  :arith-pivots            1341
;  :binary-propagations     11
;  :conflicts               552
;  :datatype-accessor-ax    737
;  :datatype-constructor-ax 4863
;  :datatype-occurs-check   2011
;  :datatype-splits         3223
;  :decisions               5678
;  :del-clause              12301
;  :final-checks            521
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          653
;  :mk-bool-var             18173
;  :mk-clause               12486
;  :num-allocs              5703136
;  :num-checks              387
;  :propagations            8623
;  :quant-instantiations    3344
;  :rlimit-count            457829)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               32121
;  :arith-add-rows          2079
;  :arith-assert-diseq      2423
;  :arith-assert-lower      4894
;  :arith-assert-upper      3266
;  :arith-bound-prop        561
;  :arith-conflicts         67
;  :arith-eq-adapter        3192
;  :arith-fixed-eqs         1816
;  :arith-offset-eqs        585
;  :arith-pivots            1341
;  :binary-propagations     11
;  :conflicts               552
;  :datatype-accessor-ax    737
;  :datatype-constructor-ax 4863
;  :datatype-occurs-check   2011
;  :datatype-splits         3223
;  :decisions               5678
;  :del-clause              12301
;  :final-checks            521
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          653
;  :mk-bool-var             18173
;  :mk-clause               12486
;  :num-allocs              5703136
;  :num-checks              388
;  :propagations            8623
;  :quant-instantiations    3344
;  :rlimit-count            457838)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    0)
  (Seq_length __flatten_31__30@80@06))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               32121
;  :arith-add-rows          2079
;  :arith-assert-diseq      2423
;  :arith-assert-lower      4894
;  :arith-assert-upper      3266
;  :arith-bound-prop        561
;  :arith-conflicts         67
;  :arith-eq-adapter        3192
;  :arith-fixed-eqs         1816
;  :arith-offset-eqs        585
;  :arith-pivots            1341
;  :binary-propagations     11
;  :conflicts               553
;  :datatype-accessor-ax    737
;  :datatype-constructor-ax 4863
;  :datatype-occurs-check   2011
;  :datatype-splits         3223
;  :decisions               5678
;  :del-clause              12301
;  :final-checks            521
;  :interface-eqs           199
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          653
;  :mk-bool-var             18173
;  :mk-clause               12486
;  :num-allocs              5703136
;  :num-checks              389
;  :propagations            8623
;  :quant-instantiations    3344
;  :rlimit-count            457926)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 111 | !(0 <= First:(Second:($t@67@06))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               32702
;  :arith-add-rows          2167
;  :arith-assert-diseq      2463
;  :arith-assert-lower      4984
;  :arith-assert-upper      3328
;  :arith-bound-prop        569
;  :arith-conflicts         69
;  :arith-eq-adapter        3256
;  :arith-fixed-eqs         1850
;  :arith-offset-eqs        595
;  :arith-pivots            1375
;  :binary-propagations     11
;  :conflicts               563
;  :datatype-accessor-ax    747
;  :datatype-constructor-ax 4949
;  :datatype-occurs-check   2050
;  :datatype-splits         3285
;  :decisions               5786
;  :del-clause              12534
;  :final-checks            532
;  :interface-eqs           205
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          678
;  :mk-bool-var             18542
;  :mk-clause               12714
;  :num-allocs              5703136
;  :num-checks              390
;  :propagations            8751
;  :quant-instantiations    3401
;  :rlimit-count            464109
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33424
;  :arith-add-rows          2212
;  :arith-assert-diseq      2497
;  :arith-assert-lower      5055
;  :arith-assert-upper      3381
;  :arith-bound-prop        576
;  :arith-conflicts         71
;  :arith-eq-adapter        3309
;  :arith-fixed-eqs         1879
;  :arith-offset-eqs        600
;  :arith-pivots            1397
;  :binary-propagations     11
;  :conflicts               579
;  :datatype-accessor-ax    766
;  :datatype-constructor-ax 5081
;  :datatype-occurs-check   2089
;  :datatype-splits         3367
;  :decisions               5931
;  :del-clause              12729
;  :final-checks            544
;  :interface-eqs           210
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          699
;  :mk-bool-var             18891
;  :mk-clause               12909
;  :num-allocs              5703136
;  :num-checks              391
;  :propagations            8878
;  :quant-instantiations    3451
;  :rlimit-count            469608
;  :time                    0.00)
; [then-branch: 113 | !(__flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0]) | live]
; [else-branch: 113 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0] | live]
(push) ; 9
; [then-branch: 113 | !(__flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        0)
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33425
;  :arith-add-rows          2214
;  :arith-assert-diseq      2497
;  :arith-assert-lower      5055
;  :arith-assert-upper      3381
;  :arith-bound-prop        576
;  :arith-conflicts         71
;  :arith-eq-adapter        3309
;  :arith-fixed-eqs         1879
;  :arith-offset-eqs        600
;  :arith-pivots            1397
;  :binary-propagations     11
;  :conflicts               579
;  :datatype-accessor-ax    766
;  :datatype-constructor-ax 5081
;  :datatype-occurs-check   2089
;  :datatype-splits         3367
;  :decisions               5931
;  :del-clause              12729
;  :final-checks            544
;  :interface-eqs           210
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          699
;  :mk-bool-var             18895
;  :mk-clause               12914
;  :num-allocs              5703136
;  :num-checks              392
;  :propagations            8880
;  :quant-instantiations    3452
;  :rlimit-count            469796)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33425
;  :arith-add-rows          2214
;  :arith-assert-diseq      2497
;  :arith-assert-lower      5055
;  :arith-assert-upper      3381
;  :arith-bound-prop        576
;  :arith-conflicts         71
;  :arith-eq-adapter        3309
;  :arith-fixed-eqs         1879
;  :arith-offset-eqs        600
;  :arith-pivots            1397
;  :binary-propagations     11
;  :conflicts               579
;  :datatype-accessor-ax    766
;  :datatype-constructor-ax 5081
;  :datatype-occurs-check   2089
;  :datatype-splits         3367
;  :decisions               5931
;  :del-clause              12729
;  :final-checks            544
;  :interface-eqs           210
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          699
;  :mk-bool-var             18895
;  :mk-clause               12914
;  :num-allocs              5703136
;  :num-checks              393
;  :propagations            8880
;  :quant-instantiations    3452
;  :rlimit-count            469811)
(pop) ; 9
(push) ; 9
; [else-branch: 113 | __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[0]] == -1 && 0 <= First:(Second:($t@67@06))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      0)
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
            __flatten_31__30@80@06
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
              0))
          0)
        (=
          (Seq_index
            __flatten_31__30@80@06
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33432
;  :arith-add-rows          2214
;  :arith-assert-diseq      2497
;  :arith-assert-lower      5055
;  :arith-assert-upper      3381
;  :arith-bound-prop        576
;  :arith-conflicts         71
;  :arith-eq-adapter        3309
;  :arith-fixed-eqs         1879
;  :arith-offset-eqs        600
;  :arith-pivots            1397
;  :binary-propagations     11
;  :conflicts               579
;  :datatype-accessor-ax    766
;  :datatype-constructor-ax 5081
;  :datatype-occurs-check   2089
;  :datatype-splits         3367
;  :decisions               5931
;  :del-clause              12734
;  :final-checks            544
;  :interface-eqs           210
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          699
;  :mk-bool-var             18898
;  :mk-clause               12917
;  :num-allocs              5703136
;  :num-checks              394
;  :propagations            8880
;  :quant-instantiations    3452
;  :rlimit-count            470199)
(push) ; 8
; [then-branch: 114 | 0 <= First:(Second:($t@67@06))[1] | live]
; [else-branch: 114 | !(0 <= First:(Second:($t@67@06))[1]) | live]
(push) ; 9
; [then-branch: 114 | 0 <= First:(Second:($t@67@06))[1]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33432
;  :arith-add-rows          2214
;  :arith-assert-diseq      2497
;  :arith-assert-lower      5055
;  :arith-assert-upper      3381
;  :arith-bound-prop        576
;  :arith-conflicts         71
;  :arith-eq-adapter        3309
;  :arith-fixed-eqs         1879
;  :arith-offset-eqs        600
;  :arith-pivots            1397
;  :binary-propagations     11
;  :conflicts               579
;  :datatype-accessor-ax    766
;  :datatype-constructor-ax 5081
;  :datatype-occurs-check   2089
;  :datatype-splits         3367
;  :decisions               5931
;  :del-clause              12734
;  :final-checks            544
;  :interface-eqs           210
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          699
;  :mk-bool-var             18898
;  :mk-clause               12917
;  :num-allocs              5703136
;  :num-checks              395
;  :propagations            8880
;  :quant-instantiations    3452
;  :rlimit-count            470299)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33432
;  :arith-add-rows          2214
;  :arith-assert-diseq      2497
;  :arith-assert-lower      5055
;  :arith-assert-upper      3381
;  :arith-bound-prop        576
;  :arith-conflicts         71
;  :arith-eq-adapter        3309
;  :arith-fixed-eqs         1879
;  :arith-offset-eqs        600
;  :arith-pivots            1397
;  :binary-propagations     11
;  :conflicts               579
;  :datatype-accessor-ax    766
;  :datatype-constructor-ax 5081
;  :datatype-occurs-check   2089
;  :datatype-splits         3367
;  :decisions               5931
;  :del-clause              12734
;  :final-checks            544
;  :interface-eqs           210
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          699
;  :mk-bool-var             18898
;  :mk-clause               12917
;  :num-allocs              5703136
;  :num-checks              396
;  :propagations            8880
;  :quant-instantiations    3452
;  :rlimit-count            470308)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  (Seq_length __flatten_31__30@80@06))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33432
;  :arith-add-rows          2214
;  :arith-assert-diseq      2497
;  :arith-assert-lower      5055
;  :arith-assert-upper      3381
;  :arith-bound-prop        576
;  :arith-conflicts         71
;  :arith-eq-adapter        3309
;  :arith-fixed-eqs         1879
;  :arith-offset-eqs        600
;  :arith-pivots            1397
;  :binary-propagations     11
;  :conflicts               580
;  :datatype-accessor-ax    766
;  :datatype-constructor-ax 5081
;  :datatype-occurs-check   2089
;  :datatype-splits         3367
;  :decisions               5931
;  :del-clause              12734
;  :final-checks            544
;  :interface-eqs           210
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          699
;  :mk-bool-var             18898
;  :mk-clause               12917
;  :num-allocs              5703136
;  :num-checks              397
;  :propagations            8880
;  :quant-instantiations    3452
;  :rlimit-count            470396)
(push) ; 10
; [then-branch: 115 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0 | live]
; [else-branch: 115 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] != 0 | live]
(push) ; 11
; [then-branch: 115 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0]
(assert (=
  (Seq_index
    __flatten_31__30@80@06
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      1))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 115 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_31__30@80@06
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33433
;  :arith-add-rows          2216
;  :arith-assert-diseq      2497
;  :arith-assert-lower      5055
;  :arith-assert-upper      3381
;  :arith-bound-prop        576
;  :arith-conflicts         71
;  :arith-eq-adapter        3309
;  :arith-fixed-eqs         1879
;  :arith-offset-eqs        600
;  :arith-pivots            1397
;  :binary-propagations     11
;  :conflicts               580
;  :datatype-accessor-ax    766
;  :datatype-constructor-ax 5081
;  :datatype-occurs-check   2089
;  :datatype-splits         3367
;  :decisions               5931
;  :del-clause              12734
;  :final-checks            544
;  :interface-eqs           210
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          699
;  :mk-bool-var             18902
;  :mk-clause               12922
;  :num-allocs              5703136
;  :num-checks              398
;  :propagations            8880
;  :quant-instantiations    3453
;  :rlimit-count            470554)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33433
;  :arith-add-rows          2216
;  :arith-assert-diseq      2497
;  :arith-assert-lower      5055
;  :arith-assert-upper      3381
;  :arith-bound-prop        576
;  :arith-conflicts         71
;  :arith-eq-adapter        3309
;  :arith-fixed-eqs         1879
;  :arith-offset-eqs        600
;  :arith-pivots            1397
;  :binary-propagations     11
;  :conflicts               580
;  :datatype-accessor-ax    766
;  :datatype-constructor-ax 5081
;  :datatype-occurs-check   2089
;  :datatype-splits         3367
;  :decisions               5931
;  :del-clause              12734
;  :final-checks            544
;  :interface-eqs           210
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          699
;  :mk-bool-var             18902
;  :mk-clause               12922
;  :num-allocs              5703136
;  :num-checks              399
;  :propagations            8880
;  :quant-instantiations    3453
;  :rlimit-count            470563)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    1)
  (Seq_length __flatten_31__30@80@06))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33433
;  :arith-add-rows          2216
;  :arith-assert-diseq      2497
;  :arith-assert-lower      5055
;  :arith-assert-upper      3381
;  :arith-bound-prop        576
;  :arith-conflicts         71
;  :arith-eq-adapter        3309
;  :arith-fixed-eqs         1879
;  :arith-offset-eqs        600
;  :arith-pivots            1397
;  :binary-propagations     11
;  :conflicts               581
;  :datatype-accessor-ax    766
;  :datatype-constructor-ax 5081
;  :datatype-occurs-check   2089
;  :datatype-splits         3367
;  :decisions               5931
;  :del-clause              12734
;  :final-checks            544
;  :interface-eqs           210
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          699
;  :mk-bool-var             18902
;  :mk-clause               12922
;  :num-allocs              5703136
;  :num-checks              400
;  :propagations            8880
;  :quant-instantiations    3453
;  :rlimit-count            470651)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 114 | !(0 <= First:(Second:($t@67@06))[1])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               33990
;  :arith-add-rows          2288
;  :arith-assert-diseq      2536
;  :arith-assert-lower      5139
;  :arith-assert-upper      3439
;  :arith-bound-prop        587
;  :arith-conflicts         73
;  :arith-eq-adapter        3368
;  :arith-fixed-eqs         1915
;  :arith-offset-eqs        612
;  :arith-pivots            1427
;  :binary-propagations     11
;  :conflicts               591
;  :datatype-accessor-ax    776
;  :datatype-constructor-ax 5165
;  :datatype-occurs-check   2128
;  :datatype-splits         3427
;  :decisions               6037
;  :del-clause              12965
;  :final-checks            555
;  :interface-eqs           216
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          713
;  :mk-bool-var             19256
;  :mk-clause               13148
;  :num-allocs              5703136
;  :num-checks              401
;  :propagations            9005
;  :quant-instantiations    3505
;  :rlimit-count            476348
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               34446
;  :arith-add-rows          2341
;  :arith-assert-diseq      2564
;  :arith-assert-lower      5197
;  :arith-assert-upper      3485
;  :arith-bound-prop        592
;  :arith-conflicts         74
;  :arith-eq-adapter        3412
;  :arith-fixed-eqs         1936
;  :arith-offset-eqs        615
;  :arith-pivots            1448
;  :binary-propagations     11
;  :conflicts               603
;  :datatype-accessor-ax    785
;  :datatype-constructor-ax 5240
;  :datatype-occurs-check   2155
;  :datatype-splits         3464
;  :decisions               6134
;  :del-clause              13124
;  :final-checks            564
;  :interface-eqs           220
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          726
;  :mk-bool-var             19512
;  :mk-clause               13307
;  :num-allocs              5703136
;  :num-checks              402
;  :propagations            9110
;  :quant-instantiations    3547
;  :rlimit-count            480985
;  :time                    0.00)
; [then-branch: 116 | !(__flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1]) | live]
; [else-branch: 116 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1] | live]
(push) ; 9
; [then-branch: 116 | !(__flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        0)
      (=
        (Seq_index
          __flatten_31__30@80@06
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            1))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1)))))
; [eval] diz.Main_process_state[1] == old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               34447
;  :arith-add-rows          2343
;  :arith-assert-diseq      2564
;  :arith-assert-lower      5197
;  :arith-assert-upper      3485
;  :arith-bound-prop        592
;  :arith-conflicts         74
;  :arith-eq-adapter        3412
;  :arith-fixed-eqs         1936
;  :arith-offset-eqs        615
;  :arith-pivots            1448
;  :binary-propagations     11
;  :conflicts               603
;  :datatype-accessor-ax    785
;  :datatype-constructor-ax 5240
;  :datatype-occurs-check   2155
;  :datatype-splits         3464
;  :decisions               6134
;  :del-clause              13124
;  :final-checks            564
;  :interface-eqs           220
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          726
;  :mk-bool-var             19516
;  :mk-clause               13312
;  :num-allocs              5703136
;  :num-checks              403
;  :propagations            9112
;  :quant-instantiations    3548
;  :rlimit-count            481173)
; [eval] old(diz.Main_process_state[1])
; [eval] diz.Main_process_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               34447
;  :arith-add-rows          2343
;  :arith-assert-diseq      2564
;  :arith-assert-lower      5197
;  :arith-assert-upper      3485
;  :arith-bound-prop        592
;  :arith-conflicts         74
;  :arith-eq-adapter        3412
;  :arith-fixed-eqs         1936
;  :arith-offset-eqs        615
;  :arith-pivots            1448
;  :binary-propagations     11
;  :conflicts               603
;  :datatype-accessor-ax    785
;  :datatype-constructor-ax 5240
;  :datatype-occurs-check   2155
;  :datatype-splits         3464
;  :decisions               6134
;  :del-clause              13124
;  :final-checks            564
;  :interface-eqs           220
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          726
;  :mk-bool-var             19516
;  :mk-clause               13312
;  :num-allocs              5703136
;  :num-checks              404
;  :propagations            9112
;  :quant-instantiations    3548
;  :rlimit-count            481188)
(pop) ; 9
(push) ; 9
; [else-branch: 116 | __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == 0 || __flatten_31__30@80@06[First:(Second:($t@67@06))[1]] == -1 && 0 <= First:(Second:($t@67@06))[1]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      0)
    (=
      (Seq_index
        __flatten_31__30@80@06
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
            __flatten_31__30@80@06
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
              1))
          0)
        (=
          (Seq_index
            __flatten_31__30@80@06
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
              1))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
(declare-const i@84@06 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 117 | 0 <= i@84@06 | live]
; [else-branch: 117 | !(0 <= i@84@06) | live]
(push) ; 10
; [then-branch: 117 | 0 <= i@84@06]
(assert (<= 0 i@84@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 117 | !(0 <= i@84@06)]
(assert (not (<= 0 i@84@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 118 | i@84@06 < |First:(Second:($t@82@06))| && 0 <= i@84@06 | live]
; [else-branch: 118 | !(i@84@06 < |First:(Second:($t@82@06))| && 0 <= i@84@06) | live]
(push) ; 10
; [then-branch: 118 | i@84@06 < |First:(Second:($t@82@06))| && 0 <= i@84@06]
(assert (and
  (<
    i@84@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))
  (<= 0 i@84@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@84@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35006
;  :arith-add-rows          2414
;  :arith-assert-diseq      2603
;  :arith-assert-lower      5284
;  :arith-assert-upper      3545
;  :arith-bound-prop        599
;  :arith-conflicts         76
;  :arith-eq-adapter        3474
;  :arith-fixed-eqs         1970
;  :arith-offset-eqs        622
;  :arith-pivots            1476
;  :binary-propagations     11
;  :conflicts               613
;  :datatype-accessor-ax    795
;  :datatype-constructor-ax 5324
;  :datatype-occurs-check   2194
;  :datatype-splits         3524
;  :decisions               6241
;  :del-clause              13352
;  :final-checks            575
;  :interface-eqs           226
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          751
;  :mk-bool-var             19876
;  :mk-clause               13546
;  :num-allocs              5703136
;  :num-checks              406
;  :propagations            9248
;  :quant-instantiations    3605
;  :rlimit-count            487191)
; [eval] -1
(push) ; 11
; [then-branch: 119 | First:(Second:($t@82@06))[i@84@06] == -1 | live]
; [else-branch: 119 | First:(Second:($t@82@06))[i@84@06] != -1 | live]
(push) ; 12
; [then-branch: 119 | First:(Second:($t@82@06))[i@84@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
    i@84@06)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 119 | First:(Second:($t@82@06))[i@84@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
      i@84@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@84@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35006
;  :arith-add-rows          2414
;  :arith-assert-diseq      2604
;  :arith-assert-lower      5287
;  :arith-assert-upper      3546
;  :arith-bound-prop        599
;  :arith-conflicts         76
;  :arith-eq-adapter        3475
;  :arith-fixed-eqs         1970
;  :arith-offset-eqs        622
;  :arith-pivots            1476
;  :binary-propagations     11
;  :conflicts               613
;  :datatype-accessor-ax    795
;  :datatype-constructor-ax 5324
;  :datatype-occurs-check   2194
;  :datatype-splits         3524
;  :decisions               6241
;  :del-clause              13352
;  :final-checks            575
;  :interface-eqs           226
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          751
;  :mk-bool-var             19882
;  :mk-clause               13550
;  :num-allocs              5703136
;  :num-checks              407
;  :propagations            9250
;  :quant-instantiations    3606
;  :rlimit-count            487399)
(push) ; 13
; [then-branch: 120 | 0 <= First:(Second:($t@82@06))[i@84@06] | live]
; [else-branch: 120 | !(0 <= First:(Second:($t@82@06))[i@84@06]) | live]
(push) ; 14
; [then-branch: 120 | 0 <= First:(Second:($t@82@06))[i@84@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
    i@84@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@84@06 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35006
;  :arith-add-rows          2414
;  :arith-assert-diseq      2604
;  :arith-assert-lower      5287
;  :arith-assert-upper      3546
;  :arith-bound-prop        599
;  :arith-conflicts         76
;  :arith-eq-adapter        3475
;  :arith-fixed-eqs         1970
;  :arith-offset-eqs        622
;  :arith-pivots            1476
;  :binary-propagations     11
;  :conflicts               613
;  :datatype-accessor-ax    795
;  :datatype-constructor-ax 5324
;  :datatype-occurs-check   2194
;  :datatype-splits         3524
;  :decisions               6241
;  :del-clause              13352
;  :final-checks            575
;  :interface-eqs           226
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          751
;  :mk-bool-var             19882
;  :mk-clause               13550
;  :num-allocs              5703136
;  :num-checks              408
;  :propagations            9250
;  :quant-instantiations    3606
;  :rlimit-count            487493)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 120 | !(0 <= First:(Second:($t@82@06))[i@84@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
      i@84@06))))
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
; [else-branch: 118 | !(i@84@06 < |First:(Second:($t@82@06))| && 0 <= i@84@06)]
(assert (not
  (and
    (<
      i@84@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))
    (<= 0 i@84@06))))
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
(assert (not (forall ((i@84@06 Int)) (!
  (implies
    (and
      (<
        i@84@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))
      (<= 0 i@84@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
          i@84@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
            i@84@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
            i@84@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
    i@84@06))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35006
;  :arith-add-rows          2414
;  :arith-assert-diseq      2606
;  :arith-assert-lower      5288
;  :arith-assert-upper      3547
;  :arith-bound-prop        599
;  :arith-conflicts         76
;  :arith-eq-adapter        3476
;  :arith-fixed-eqs         1970
;  :arith-offset-eqs        622
;  :arith-pivots            1476
;  :binary-propagations     11
;  :conflicts               614
;  :datatype-accessor-ax    795
;  :datatype-constructor-ax 5324
;  :datatype-occurs-check   2194
;  :datatype-splits         3524
;  :decisions               6241
;  :del-clause              13370
;  :final-checks            575
;  :interface-eqs           226
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          751
;  :mk-bool-var             19890
;  :mk-clause               13564
;  :num-allocs              5703136
;  :num-checks              409
;  :propagations            9252
;  :quant-instantiations    3607
;  :rlimit-count            487915)
(assert (forall ((i@84@06 Int)) (!
  (implies
    (and
      (<
        i@84@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))
      (<= 0 i@84@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
          i@84@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
            i@84@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
            i@84@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))
    i@84@06))
  :qid |prog.l<no position>|)))
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
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06))))
  2))
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
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))
  3))
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
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 121 | 0 <= i@86@06 | live]
; [else-branch: 121 | !(0 <= i@86@06) | live]
(push) ; 10
; [then-branch: 121 | 0 <= i@86@06]
(assert (<= 0 i@86@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 121 | !(0 <= i@86@06)]
(assert (not (<= 0 i@86@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 122 | i@86@06 < |First:(Second:($t@85@06))| && 0 <= i@86@06 | live]
; [else-branch: 122 | !(i@86@06 < |First:(Second:($t@85@06))| && 0 <= i@86@06) | live]
(push) ; 10
; [then-branch: 122 | i@86@06 < |First:(Second:($t@85@06))| && 0 <= i@86@06]
(assert (and
  (<
    i@86@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))
  (<= 0 i@86@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@86@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35043
;  :arith-add-rows          2414
;  :arith-assert-diseq      2606
;  :arith-assert-lower      5293
;  :arith-assert-upper      3550
;  :arith-bound-prop        599
;  :arith-conflicts         76
;  :arith-eq-adapter        3478
;  :arith-fixed-eqs         1970
;  :arith-offset-eqs        622
;  :arith-pivots            1476
;  :binary-propagations     11
;  :conflicts               614
;  :datatype-accessor-ax    801
;  :datatype-constructor-ax 5324
;  :datatype-occurs-check   2194
;  :datatype-splits         3524
;  :decisions               6241
;  :del-clause              13370
;  :final-checks            575
;  :interface-eqs           226
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          751
;  :mk-bool-var             19912
;  :mk-clause               13564
;  :num-allocs              5703136
;  :num-checks              410
;  :propagations            9252
;  :quant-instantiations    3611
;  :rlimit-count            489303)
; [eval] -1
(push) ; 11
; [then-branch: 123 | First:(Second:($t@85@06))[i@86@06] == -1 | live]
; [else-branch: 123 | First:(Second:($t@85@06))[i@86@06] != -1 | live]
(push) ; 12
; [then-branch: 123 | First:(Second:($t@85@06))[i@86@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
    i@86@06)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 123 | First:(Second:($t@85@06))[i@86@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      i@86@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@86@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35043
;  :arith-add-rows          2414
;  :arith-assert-diseq      2606
;  :arith-assert-lower      5293
;  :arith-assert-upper      3550
;  :arith-bound-prop        599
;  :arith-conflicts         76
;  :arith-eq-adapter        3478
;  :arith-fixed-eqs         1970
;  :arith-offset-eqs        622
;  :arith-pivots            1476
;  :binary-propagations     11
;  :conflicts               614
;  :datatype-accessor-ax    801
;  :datatype-constructor-ax 5324
;  :datatype-occurs-check   2194
;  :datatype-splits         3524
;  :decisions               6241
;  :del-clause              13370
;  :final-checks            575
;  :interface-eqs           226
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          751
;  :mk-bool-var             19913
;  :mk-clause               13564
;  :num-allocs              5703136
;  :num-checks              411
;  :propagations            9252
;  :quant-instantiations    3611
;  :rlimit-count            489454)
(push) ; 13
; [then-branch: 124 | 0 <= First:(Second:($t@85@06))[i@86@06] | live]
; [else-branch: 124 | !(0 <= First:(Second:($t@85@06))[i@86@06]) | live]
(push) ; 14
; [then-branch: 124 | 0 <= First:(Second:($t@85@06))[i@86@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
    i@86@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@86@06 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35043
;  :arith-add-rows          2414
;  :arith-assert-diseq      2607
;  :arith-assert-lower      5296
;  :arith-assert-upper      3550
;  :arith-bound-prop        599
;  :arith-conflicts         76
;  :arith-eq-adapter        3479
;  :arith-fixed-eqs         1970
;  :arith-offset-eqs        622
;  :arith-pivots            1476
;  :binary-propagations     11
;  :conflicts               614
;  :datatype-accessor-ax    801
;  :datatype-constructor-ax 5324
;  :datatype-occurs-check   2194
;  :datatype-splits         3524
;  :decisions               6241
;  :del-clause              13370
;  :final-checks            575
;  :interface-eqs           226
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          751
;  :mk-bool-var             19916
;  :mk-clause               13565
;  :num-allocs              5703136
;  :num-checks              412
;  :propagations            9252
;  :quant-instantiations    3611
;  :rlimit-count            489557)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 124 | !(0 <= First:(Second:($t@85@06))[i@86@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      i@86@06))))
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
; [else-branch: 122 | !(i@86@06 < |First:(Second:($t@85@06))| && 0 <= i@86@06)]
(assert (not
  (and
    (<
      i@86@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))
    (<= 0 i@86@06))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
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
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@82@06)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35061
;  :arith-add-rows          2414
;  :arith-assert-diseq      2607
;  :arith-assert-lower      5297
;  :arith-assert-upper      3551
;  :arith-bound-prop        599
;  :arith-conflicts         76
;  :arith-eq-adapter        3480
;  :arith-fixed-eqs         1971
;  :arith-offset-eqs        622
;  :arith-pivots            1476
;  :binary-propagations     11
;  :conflicts               614
;  :datatype-accessor-ax    803
;  :datatype-constructor-ax 5324
;  :datatype-occurs-check   2194
;  :datatype-splits         3524
;  :decisions               6241
;  :del-clause              13371
;  :final-checks            575
;  :interface-eqs           226
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          751
;  :mk-bool-var             19936
;  :mk-clause               13576
;  :num-allocs              5703136
;  :num-checks              413
;  :propagations            9256
;  :quant-instantiations    3613
;  :rlimit-count            490573)
(push) ; 8
; [then-branch: 125 | First:(Second:(Second:(Second:($t@82@06))))[0] == 0 | live]
; [else-branch: 125 | First:(Second:(Second:(Second:($t@82@06))))[0] != 0 | live]
(push) ; 9
; [then-branch: 125 | First:(Second:(Second:(Second:($t@82@06))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 125 | First:(Second:(Second:(Second:($t@82@06))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35062
;  :arith-add-rows          2415
;  :arith-assert-diseq      2607
;  :arith-assert-lower      5297
;  :arith-assert-upper      3551
;  :arith-bound-prop        599
;  :arith-conflicts         76
;  :arith-eq-adapter        3480
;  :arith-fixed-eqs         1971
;  :arith-offset-eqs        622
;  :arith-pivots            1476
;  :binary-propagations     11
;  :conflicts               614
;  :datatype-accessor-ax    803
;  :datatype-constructor-ax 5324
;  :datatype-occurs-check   2194
;  :datatype-splits         3524
;  :decisions               6241
;  :del-clause              13371
;  :final-checks            575
;  :interface-eqs           226
;  :max-generation          5
;  :max-memory              5.09
;  :memory                  5.09
;  :minimized-lits          751
;  :mk-bool-var             19941
;  :mk-clause               13581
;  :num-allocs              5703136
;  :num-checks              414
;  :propagations            9256
;  :quant-instantiations    3614
;  :rlimit-count            490786)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               35543
;  :arith-add-rows          2459
;  :arith-assert-diseq      2654
;  :arith-assert-lower      5422
;  :arith-assert-upper      3601
;  :arith-bound-prop        603
;  :arith-conflicts         76
;  :arith-eq-adapter        3546
;  :arith-fixed-eqs         2004
;  :arith-offset-eqs        627
;  :arith-pivots            1513
;  :binary-propagations     11
;  :conflicts               621
;  :datatype-accessor-ax    810
;  :datatype-constructor-ax 5393
;  :datatype-occurs-check   2219
;  :datatype-splits         3560
;  :decisions               6341
;  :del-clause              13619
;  :final-checks            581
;  :interface-eqs           229
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :minimized-lits          753
;  :mk-bool-var             20262
;  :mk-clause               13824
;  :num-allocs              6015020
;  :num-checks              415
;  :propagations            9408
;  :quant-instantiations    3685
;  :rlimit-count            495928
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               36388
;  :arith-add-rows          2545
;  :arith-assert-diseq      2740
;  :arith-assert-lower      5652
;  :arith-assert-upper      3689
;  :arith-bound-prop        612
;  :arith-conflicts         79
;  :arith-eq-adapter        3670
;  :arith-fixed-eqs         2066
;  :arith-offset-eqs        645
;  :arith-pivots            1572
;  :binary-propagations     11
;  :conflicts               637
;  :datatype-accessor-ax    831
;  :datatype-constructor-ax 5514
;  :datatype-occurs-check   2283
;  :datatype-splits         3686
;  :decisions               6501
;  :del-clause              14071
;  :final-checks            593
;  :interface-eqs           235
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :minimized-lits          760
;  :mk-bool-var             20874
;  :mk-clause               14276
;  :num-allocs              6015020
;  :num-checks              416
;  :propagations            9695
;  :quant-instantiations    3799
;  :rlimit-count            503721
;  :time                    0.01)
; [then-branch: 126 | First:(Second:(Second:(Second:($t@82@06))))[0] == 0 || First:(Second:(Second:(Second:($t@82@06))))[0] == -1 | live]
; [else-branch: 126 | !(First:(Second:(Second:(Second:($t@82@06))))[0] == 0 || First:(Second:(Second:(Second:($t@82@06))))[0] == -1) | live]
(push) ; 9
; [then-branch: 126 | First:(Second:(Second:(Second:($t@82@06))))[0] == 0 || First:(Second:(Second:(Second:($t@82@06))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               36388
;  :arith-add-rows          2545
;  :arith-assert-diseq      2740
;  :arith-assert-lower      5652
;  :arith-assert-upper      3689
;  :arith-bound-prop        612
;  :arith-conflicts         79
;  :arith-eq-adapter        3670
;  :arith-fixed-eqs         2066
;  :arith-offset-eqs        645
;  :arith-pivots            1572
;  :binary-propagations     11
;  :conflicts               637
;  :datatype-accessor-ax    831
;  :datatype-constructor-ax 5514
;  :datatype-occurs-check   2283
;  :datatype-splits         3686
;  :decisions               6501
;  :del-clause              14071
;  :final-checks            593
;  :interface-eqs           235
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :minimized-lits          760
;  :mk-bool-var             20876
;  :mk-clause               14277
;  :num-allocs              6015020
;  :num-checks              417
;  :propagations            9695
;  :quant-instantiations    3799
;  :rlimit-count            503870)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 126 | !(First:(Second:(Second:(Second:($t@82@06))))[0] == 0 || First:(Second:(Second:(Second:($t@82@06))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               36394
;  :arith-add-rows          2545
;  :arith-assert-diseq      2740
;  :arith-assert-lower      5652
;  :arith-assert-upper      3689
;  :arith-bound-prop        612
;  :arith-conflicts         79
;  :arith-eq-adapter        3670
;  :arith-fixed-eqs         2066
;  :arith-offset-eqs        645
;  :arith-pivots            1572
;  :binary-propagations     11
;  :conflicts               637
;  :datatype-accessor-ax    832
;  :datatype-constructor-ax 5514
;  :datatype-occurs-check   2283
;  :datatype-splits         3686
;  :decisions               6501
;  :del-clause              14072
;  :final-checks            593
;  :interface-eqs           235
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :minimized-lits          760
;  :mk-bool-var             20882
;  :mk-clause               14281
;  :num-allocs              6015020
;  :num-checks              418
;  :propagations            9695
;  :quant-instantiations    3799
;  :rlimit-count            504353)
(push) ; 8
; [then-branch: 127 | First:(Second:(Second:(Second:($t@82@06))))[1] == 0 | live]
; [else-branch: 127 | First:(Second:(Second:(Second:($t@82@06))))[1] != 0 | live]
(push) ; 9
; [then-branch: 127 | First:(Second:(Second:(Second:($t@82@06))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 127 | First:(Second:(Second:(Second:($t@82@06))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               36395
;  :arith-add-rows          2546
;  :arith-assert-diseq      2740
;  :arith-assert-lower      5652
;  :arith-assert-upper      3689
;  :arith-bound-prop        612
;  :arith-conflicts         79
;  :arith-eq-adapter        3670
;  :arith-fixed-eqs         2066
;  :arith-offset-eqs        645
;  :arith-pivots            1572
;  :binary-propagations     11
;  :conflicts               637
;  :datatype-accessor-ax    832
;  :datatype-constructor-ax 5514
;  :datatype-occurs-check   2283
;  :datatype-splits         3686
;  :decisions               6501
;  :del-clause              14072
;  :final-checks            593
;  :interface-eqs           235
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :minimized-lits          760
;  :mk-bool-var             20887
;  :mk-clause               14286
;  :num-allocs              6015020
;  :num-checks              419
;  :propagations            9695
;  :quant-instantiations    3800
;  :rlimit-count            504538)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               37613
;  :arith-add-rows          2703
;  :arith-assert-diseq      2882
;  :arith-assert-lower      6067
;  :arith-assert-upper      3855
;  :arith-bound-prop        622
;  :arith-conflicts         81
;  :arith-eq-adapter        3872
;  :arith-fixed-eqs         2204
;  :arith-offset-eqs        696
;  :arith-pivots            1663
;  :binary-propagations     11
;  :conflicts               656
;  :datatype-accessor-ax    852
;  :datatype-constructor-ax 5650
;  :datatype-occurs-check   2346
;  :datatype-splits         3790
;  :decisions               6727
;  :del-clause              14931
;  :final-checks            602
;  :interface-eqs           237
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :minimized-lits          767
;  :mk-bool-var             21919
;  :mk-clause               15140
;  :num-allocs              6015020
;  :num-checks              420
;  :propagations            10290
;  :quant-instantiations    4030
;  :rlimit-count            516164
;  :time                    0.01)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               38365
;  :arith-add-rows          2782
;  :arith-assert-diseq      2960
;  :arith-assert-lower      6254
;  :arith-assert-upper      3927
;  :arith-bound-prop        629
;  :arith-conflicts         81
;  :arith-eq-adapter        3968
;  :arith-fixed-eqs         2256
;  :arith-offset-eqs        712
;  :arith-pivots            1709
;  :binary-propagations     11
;  :conflicts               665
;  :datatype-accessor-ax    866
;  :datatype-constructor-ax 5756
;  :datatype-occurs-check   2396
;  :datatype-splits         3864
;  :decisions               6872
;  :del-clause              15310
;  :final-checks            613
;  :interface-eqs           242
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :minimized-lits          769
;  :mk-bool-var             22400
;  :mk-clause               15519
;  :num-allocs              6015020
;  :num-checks              421
;  :propagations            10537
;  :quant-instantiations    4131
;  :rlimit-count            523317
;  :time                    0.00)
; [then-branch: 128 | First:(Second:(Second:(Second:($t@82@06))))[1] == 0 || First:(Second:(Second:(Second:($t@82@06))))[1] == -1 | live]
; [else-branch: 128 | !(First:(Second:(Second:(Second:($t@82@06))))[1] == 0 || First:(Second:(Second:(Second:($t@82@06))))[1] == -1) | live]
(push) ; 9
; [then-branch: 128 | First:(Second:(Second:(Second:($t@82@06))))[1] == 0 || First:(Second:(Second:(Second:($t@82@06))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               38365
;  :arith-add-rows          2782
;  :arith-assert-diseq      2960
;  :arith-assert-lower      6254
;  :arith-assert-upper      3927
;  :arith-bound-prop        629
;  :arith-conflicts         81
;  :arith-eq-adapter        3968
;  :arith-fixed-eqs         2256
;  :arith-offset-eqs        712
;  :arith-pivots            1709
;  :binary-propagations     11
;  :conflicts               665
;  :datatype-accessor-ax    866
;  :datatype-constructor-ax 5756
;  :datatype-occurs-check   2396
;  :datatype-splits         3864
;  :decisions               6872
;  :del-clause              15310
;  :final-checks            613
;  :interface-eqs           242
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :minimized-lits          769
;  :mk-bool-var             22402
;  :mk-clause               15520
;  :num-allocs              6015020
;  :num-checks              422
;  :propagations            10537
;  :quant-instantiations    4131
;  :rlimit-count            523466)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 128 | !(First:(Second:(Second:(Second:($t@82@06))))[1] == 0 || First:(Second:(Second:(Second:($t@82@06))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               38371
;  :arith-add-rows          2782
;  :arith-assert-diseq      2960
;  :arith-assert-lower      6254
;  :arith-assert-upper      3927
;  :arith-bound-prop        629
;  :arith-conflicts         81
;  :arith-eq-adapter        3968
;  :arith-fixed-eqs         2256
;  :arith-offset-eqs        712
;  :arith-pivots            1709
;  :binary-propagations     11
;  :conflicts               665
;  :datatype-accessor-ax    867
;  :datatype-constructor-ax 5756
;  :datatype-occurs-check   2396
;  :datatype-splits         3864
;  :decisions               6872
;  :del-clause              15311
;  :final-checks            613
;  :interface-eqs           242
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :minimized-lits          769
;  :mk-bool-var             22408
;  :mk-clause               15524
;  :num-allocs              6015020
;  :num-checks              423
;  :propagations            10537
;  :quant-instantiations    4131
;  :rlimit-count            523955)
(push) ; 8
; [then-branch: 129 | First:(Second:(Second:(Second:($t@82@06))))[2] == 0 | live]
; [else-branch: 129 | First:(Second:(Second:(Second:($t@82@06))))[2] != 0 | live]
(push) ; 9
; [then-branch: 129 | First:(Second:(Second:(Second:($t@82@06))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
    2)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 129 | First:(Second:(Second:(Second:($t@82@06))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               38372
;  :arith-add-rows          2783
;  :arith-assert-diseq      2960
;  :arith-assert-lower      6254
;  :arith-assert-upper      3927
;  :arith-bound-prop        629
;  :arith-conflicts         81
;  :arith-eq-adapter        3968
;  :arith-fixed-eqs         2256
;  :arith-offset-eqs        712
;  :arith-pivots            1709
;  :binary-propagations     11
;  :conflicts               665
;  :datatype-accessor-ax    867
;  :datatype-constructor-ax 5756
;  :datatype-occurs-check   2396
;  :datatype-splits         3864
;  :decisions               6872
;  :del-clause              15311
;  :final-checks            613
;  :interface-eqs           242
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :minimized-lits          769
;  :mk-bool-var             22413
;  :mk-clause               15529
;  :num-allocs              6015020
;  :num-checks              424
;  :propagations            10537
;  :quant-instantiations    4132
;  :rlimit-count            524168)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39006
;  :arith-add-rows          2883
;  :arith-assert-diseq      3036
;  :arith-assert-lower      6465
;  :arith-assert-upper      4018
;  :arith-bound-prop        641
;  :arith-conflicts         82
;  :arith-eq-adapter        4080
;  :arith-fixed-eqs         2320
;  :arith-offset-eqs        731
;  :arith-pivots            1777
;  :binary-propagations     11
;  :conflicts               679
;  :datatype-accessor-ax    874
;  :datatype-constructor-ax 5825
;  :datatype-occurs-check   2420
;  :datatype-splits         3900
;  :decisions               7001
;  :del-clause              15813
;  :final-checks            619
;  :interface-eqs           245
;  :max-generation          5
;  :max-memory              5.28
;  :memory                  5.28
;  :minimized-lits          780
;  :mk-bool-var             22986
;  :mk-clause               16026
;  :num-allocs              6342446
;  :num-checks              425
;  :propagations            10839
;  :quant-instantiations    4264
;  :rlimit-count            531573
;  :time                    0.01)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39849
;  :arith-add-rows          2976
;  :arith-assert-diseq      3135
;  :arith-assert-lower      6708
;  :arith-assert-upper      4116
;  :arith-bound-prop        652
;  :arith-conflicts         82
;  :arith-eq-adapter        4207
;  :arith-fixed-eqs         2392
;  :arith-offset-eqs        757
;  :arith-pivots            1847
;  :binary-propagations     11
;  :conflicts               691
;  :datatype-accessor-ax    888
;  :datatype-constructor-ax 5931
;  :datatype-occurs-check   2470
;  :datatype-splits         3974
;  :decisions               7164
;  :del-clause              16355
;  :final-checks            630
;  :interface-eqs           250
;  :max-generation          5
;  :max-memory              5.29
;  :memory                  5.29
;  :minimized-lits          780
;  :mk-bool-var             23631
;  :mk-clause               16568
;  :num-allocs              7001156
;  :num-checks              426
;  :propagations            11179
;  :quant-instantiations    4400
;  :rlimit-count            539647
;  :time                    0.01)
; [then-branch: 130 | First:(Second:(Second:(Second:($t@82@06))))[2] == 0 || First:(Second:(Second:(Second:($t@82@06))))[2] == -1 | live]
; [else-branch: 130 | !(First:(Second:(Second:(Second:($t@82@06))))[2] == 0 || First:(Second:(Second:(Second:($t@82@06))))[2] == -1) | live]
(push) ; 9
; [then-branch: 130 | First:(Second:(Second:(Second:($t@82@06))))[2] == 0 || First:(Second:(Second:(Second:($t@82@06))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      2)
    (- 0 1))))
; [eval] diz.Main_event_state[2] == -2
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39849
;  :arith-add-rows          2976
;  :arith-assert-diseq      3135
;  :arith-assert-lower      6708
;  :arith-assert-upper      4116
;  :arith-bound-prop        652
;  :arith-conflicts         82
;  :arith-eq-adapter        4207
;  :arith-fixed-eqs         2392
;  :arith-offset-eqs        757
;  :arith-pivots            1847
;  :binary-propagations     11
;  :conflicts               691
;  :datatype-accessor-ax    888
;  :datatype-constructor-ax 5931
;  :datatype-occurs-check   2470
;  :datatype-splits         3974
;  :decisions               7164
;  :del-clause              16355
;  :final-checks            630
;  :interface-eqs           250
;  :max-generation          5
;  :max-memory              5.29
;  :memory                  5.29
;  :minimized-lits          780
;  :mk-bool-var             23633
;  :mk-clause               16569
;  :num-allocs              7001156
;  :num-checks              427
;  :propagations            11179
;  :quant-instantiations    4400
;  :rlimit-count            539796)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 130 | !(First:(Second:(Second:(Second:($t@82@06))))[2] == 0 || First:(Second:(Second:(Second:($t@82@06))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        2)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))
      2)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39855
;  :arith-add-rows          2976
;  :arith-assert-diseq      3135
;  :arith-assert-lower      6708
;  :arith-assert-upper      4116
;  :arith-bound-prop        652
;  :arith-conflicts         82
;  :arith-eq-adapter        4207
;  :arith-fixed-eqs         2392
;  :arith-offset-eqs        757
;  :arith-pivots            1847
;  :binary-propagations     11
;  :conflicts               691
;  :datatype-accessor-ax    889
;  :datatype-constructor-ax 5931
;  :datatype-occurs-check   2470
;  :datatype-splits         3974
;  :decisions               7164
;  :del-clause              16356
;  :final-checks            630
;  :interface-eqs           250
;  :max-generation          5
;  :max-memory              5.29
;  :memory                  5.29
;  :minimized-lits          780
;  :mk-bool-var             23639
;  :mk-clause               16573
;  :num-allocs              7001156
;  :num-checks              428
;  :propagations            11179
;  :quant-instantiations    4400
;  :rlimit-count            540295)
(push) ; 8
; [then-branch: 131 | First:(Second:(Second:(Second:($t@82@06))))[0] == 0 | live]
; [else-branch: 131 | First:(Second:(Second:(Second:($t@82@06))))[0] != 0 | live]
(push) ; 9
; [then-branch: 131 | First:(Second:(Second:(Second:($t@82@06))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 131 | First:(Second:(Second:(Second:($t@82@06))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39856
;  :arith-add-rows          2977
;  :arith-assert-diseq      3135
;  :arith-assert-lower      6708
;  :arith-assert-upper      4116
;  :arith-bound-prop        652
;  :arith-conflicts         82
;  :arith-eq-adapter        4207
;  :arith-fixed-eqs         2392
;  :arith-offset-eqs        757
;  :arith-pivots            1847
;  :binary-propagations     11
;  :conflicts               691
;  :datatype-accessor-ax    889
;  :datatype-constructor-ax 5931
;  :datatype-occurs-check   2470
;  :datatype-splits         3974
;  :decisions               7164
;  :del-clause              16356
;  :final-checks            630
;  :interface-eqs           250
;  :max-generation          5
;  :max-memory              5.29
;  :memory                  5.29
;  :minimized-lits          780
;  :mk-bool-var             23643
;  :mk-clause               16578
;  :num-allocs              7001156
;  :num-checks              429
;  :propagations            11179
;  :quant-instantiations    4401
;  :rlimit-count            540464)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               40912
;  :arith-add-rows          3065
;  :arith-assert-diseq      3254
;  :arith-assert-lower      7007
;  :arith-assert-upper      4226
;  :arith-bound-prop        662
;  :arith-conflicts         83
;  :arith-eq-adapter        4361
;  :arith-fixed-eqs         2495
;  :arith-offset-eqs        793
;  :arith-pivots            1924
;  :binary-propagations     11
;  :conflicts               708
;  :datatype-accessor-ax    909
;  :datatype-constructor-ax 6067
;  :datatype-occurs-check   2533
;  :datatype-splits         4078
;  :decisions               7365
;  :del-clause              16995
;  :final-checks            639
;  :interface-eqs           252
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.30
;  :minimized-lits          782
;  :mk-bool-var             24398
;  :mk-clause               17212
;  :num-allocs              7667898
;  :num-checks              430
;  :propagations            11590
;  :quant-instantiations    4556
;  :rlimit-count            549464
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               41664
;  :arith-add-rows          3137
;  :arith-assert-diseq      3333
;  :arith-assert-lower      7181
;  :arith-assert-upper      4292
;  :arith-bound-prop        668
;  :arith-conflicts         83
;  :arith-eq-adapter        4451
;  :arith-fixed-eqs         2545
;  :arith-offset-eqs        810
;  :arith-pivots            1967
;  :binary-propagations     11
;  :conflicts               717
;  :datatype-accessor-ax    923
;  :datatype-constructor-ax 6173
;  :datatype-occurs-check   2583
;  :datatype-splits         4152
;  :decisions               7518
;  :del-clause              17371
;  :final-checks            650
;  :interface-eqs           257
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.30
;  :minimized-lits          782
;  :mk-bool-var             24861
;  :mk-clause               17588
;  :num-allocs              8341354
;  :num-checks              431
;  :propagations            11823
;  :quant-instantiations    4649
;  :rlimit-count            556540
;  :time                    0.00)
; [then-branch: 132 | !(First:(Second:(Second:(Second:($t@82@06))))[0] == 0 || First:(Second:(Second:(Second:($t@82@06))))[0] == -1) | live]
; [else-branch: 132 | First:(Second:(Second:(Second:($t@82@06))))[0] == 0 || First:(Second:(Second:(Second:($t@82@06))))[0] == -1 | live]
(push) ; 9
; [then-branch: 132 | !(First:(Second:(Second:(Second:($t@82@06))))[0] == 0 || First:(Second:(Second:(Second:($t@82@06))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               41665
;  :arith-add-rows          3138
;  :arith-assert-diseq      3333
;  :arith-assert-lower      7181
;  :arith-assert-upper      4292
;  :arith-bound-prop        668
;  :arith-conflicts         83
;  :arith-eq-adapter        4451
;  :arith-fixed-eqs         2545
;  :arith-offset-eqs        810
;  :arith-pivots            1967
;  :binary-propagations     11
;  :conflicts               717
;  :datatype-accessor-ax    923
;  :datatype-constructor-ax 6173
;  :datatype-occurs-check   2583
;  :datatype-splits         4152
;  :decisions               7518
;  :del-clause              17371
;  :final-checks            650
;  :interface-eqs           257
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.30
;  :minimized-lits          782
;  :mk-bool-var             24865
;  :mk-clause               17593
;  :num-allocs              8341354
;  :num-checks              432
;  :propagations            11824
;  :quant-instantiations    4650
;  :rlimit-count            556730)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               41665
;  :arith-add-rows          3138
;  :arith-assert-diseq      3333
;  :arith-assert-lower      7181
;  :arith-assert-upper      4292
;  :arith-bound-prop        668
;  :arith-conflicts         83
;  :arith-eq-adapter        4451
;  :arith-fixed-eqs         2545
;  :arith-offset-eqs        810
;  :arith-pivots            1967
;  :binary-propagations     11
;  :conflicts               717
;  :datatype-accessor-ax    923
;  :datatype-constructor-ax 6173
;  :datatype-occurs-check   2583
;  :datatype-splits         4152
;  :decisions               7518
;  :del-clause              17371
;  :final-checks            650
;  :interface-eqs           257
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.30
;  :minimized-lits          782
;  :mk-bool-var             24865
;  :mk-clause               17593
;  :num-allocs              8341354
;  :num-checks              433
;  :propagations            11824
;  :quant-instantiations    4650
;  :rlimit-count            556745)
(pop) ; 9
(push) ; 9
; [else-branch: 132 | First:(Second:(Second:(Second:($t@82@06))))[0] == 0 || First:(Second:(Second:(Second:($t@82@06))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               41671
;  :arith-add-rows          3138
;  :arith-assert-diseq      3333
;  :arith-assert-lower      7181
;  :arith-assert-upper      4292
;  :arith-bound-prop        668
;  :arith-conflicts         83
;  :arith-eq-adapter        4451
;  :arith-fixed-eqs         2545
;  :arith-offset-eqs        810
;  :arith-pivots            1967
;  :binary-propagations     11
;  :conflicts               717
;  :datatype-accessor-ax    924
;  :datatype-constructor-ax 6173
;  :datatype-occurs-check   2583
;  :datatype-splits         4152
;  :decisions               7518
;  :del-clause              17376
;  :final-checks            650
;  :interface-eqs           257
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.30
;  :minimized-lits          782
;  :mk-bool-var             24868
;  :mk-clause               17594
;  :num-allocs              8341354
;  :num-checks              434
;  :propagations            11824
;  :quant-instantiations    4650
;  :rlimit-count            557194)
(push) ; 8
; [then-branch: 133 | First:(Second:(Second:(Second:($t@82@06))))[1] == 0 | live]
; [else-branch: 133 | First:(Second:(Second:(Second:($t@82@06))))[1] != 0 | live]
(push) ; 9
; [then-branch: 133 | First:(Second:(Second:(Second:($t@82@06))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 133 | First:(Second:(Second:(Second:($t@82@06))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               41672
;  :arith-add-rows          3139
;  :arith-assert-diseq      3333
;  :arith-assert-lower      7181
;  :arith-assert-upper      4292
;  :arith-bound-prop        668
;  :arith-conflicts         83
;  :arith-eq-adapter        4451
;  :arith-fixed-eqs         2545
;  :arith-offset-eqs        810
;  :arith-pivots            1967
;  :binary-propagations     11
;  :conflicts               717
;  :datatype-accessor-ax    924
;  :datatype-constructor-ax 6173
;  :datatype-occurs-check   2583
;  :datatype-splits         4152
;  :decisions               7518
;  :del-clause              17376
;  :final-checks            650
;  :interface-eqs           257
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.30
;  :minimized-lits          782
;  :mk-bool-var             24872
;  :mk-clause               17599
;  :num-allocs              8341354
;  :num-checks              435
;  :propagations            11824
;  :quant-instantiations    4651
;  :rlimit-count            557361)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               42582
;  :arith-add-rows          3235
;  :arith-assert-diseq      3448
;  :arith-assert-lower      7459
;  :arith-assert-upper      4405
;  :arith-bound-prop        677
;  :arith-conflicts         84
;  :arith-eq-adapter        4594
;  :arith-fixed-eqs         2628
;  :arith-offset-eqs        841
;  :arith-pivots            2043
;  :binary-propagations     11
;  :conflicts               730
;  :datatype-accessor-ax    938
;  :datatype-constructor-ax 6279
;  :datatype-occurs-check   2633
;  :datatype-splits         4226
;  :decisions               7690
;  :del-clause              18004
;  :final-checks            661
;  :interface-eqs           262
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.30
;  :minimized-lits          782
;  :mk-bool-var             25587
;  :mk-clause               18222
;  :num-allocs              9022062
;  :num-checks              436
;  :propagations            12235
;  :quant-instantiations    4809
;  :rlimit-count            566022
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43666
;  :arith-add-rows          3404
;  :arith-assert-diseq      3598
;  :arith-assert-lower      7881
;  :arith-assert-upper      4578
;  :arith-bound-prop        687
;  :arith-conflicts         87
;  :arith-eq-adapter        4802
;  :arith-fixed-eqs         2759
;  :arith-offset-eqs        884
;  :arith-pivots            2152
;  :binary-propagations     11
;  :conflicts               750
;  :datatype-accessor-ax    951
;  :datatype-constructor-ax 6376
;  :datatype-occurs-check   2665
;  :datatype-splits         4292
;  :decisions               7903
;  :del-clause              18945
;  :final-checks            666
;  :interface-eqs           264
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             26630
;  :mk-clause               19163
;  :num-allocs              9364463
;  :num-checks              437
;  :propagations            12866
;  :quant-instantiations    5056
;  :rlimit-count            577047
;  :time                    0.01)
; [then-branch: 134 | !(First:(Second:(Second:(Second:($t@82@06))))[1] == 0 || First:(Second:(Second:(Second:($t@82@06))))[1] == -1) | live]
; [else-branch: 134 | First:(Second:(Second:(Second:($t@82@06))))[1] == 0 || First:(Second:(Second:(Second:($t@82@06))))[1] == -1 | live]
(push) ; 9
; [then-branch: 134 | !(First:(Second:(Second:(Second:($t@82@06))))[1] == 0 || First:(Second:(Second:(Second:($t@82@06))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43667
;  :arith-add-rows          3405
;  :arith-assert-diseq      3598
;  :arith-assert-lower      7881
;  :arith-assert-upper      4578
;  :arith-bound-prop        687
;  :arith-conflicts         87
;  :arith-eq-adapter        4802
;  :arith-fixed-eqs         2759
;  :arith-offset-eqs        884
;  :arith-pivots            2152
;  :binary-propagations     11
;  :conflicts               750
;  :datatype-accessor-ax    951
;  :datatype-constructor-ax 6376
;  :datatype-occurs-check   2665
;  :datatype-splits         4292
;  :decisions               7903
;  :del-clause              18945
;  :final-checks            666
;  :interface-eqs           264
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             26634
;  :mk-clause               19168
;  :num-allocs              9364463
;  :num-checks              438
;  :propagations            12867
;  :quant-instantiations    5057
;  :rlimit-count            577235)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43667
;  :arith-add-rows          3405
;  :arith-assert-diseq      3598
;  :arith-assert-lower      7881
;  :arith-assert-upper      4578
;  :arith-bound-prop        687
;  :arith-conflicts         87
;  :arith-eq-adapter        4802
;  :arith-fixed-eqs         2759
;  :arith-offset-eqs        884
;  :arith-pivots            2152
;  :binary-propagations     11
;  :conflicts               750
;  :datatype-accessor-ax    951
;  :datatype-constructor-ax 6376
;  :datatype-occurs-check   2665
;  :datatype-splits         4292
;  :decisions               7903
;  :del-clause              18945
;  :final-checks            666
;  :interface-eqs           264
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             26634
;  :mk-clause               19168
;  :num-allocs              9364463
;  :num-checks              439
;  :propagations            12867
;  :quant-instantiations    5057
;  :rlimit-count            577250)
(pop) ; 9
(push) ; 9
; [else-branch: 134 | First:(Second:(Second:(Second:($t@82@06))))[1] == 0 || First:(Second:(Second:(Second:($t@82@06))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@06))))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43676
;  :arith-add-rows          3405
;  :arith-assert-diseq      3598
;  :arith-assert-lower      7881
;  :arith-assert-upper      4578
;  :arith-bound-prop        687
;  :arith-conflicts         87
;  :arith-eq-adapter        4802
;  :arith-fixed-eqs         2759
;  :arith-offset-eqs        884
;  :arith-pivots            2152
;  :binary-propagations     11
;  :conflicts               750
;  :datatype-accessor-ax    951
;  :datatype-constructor-ax 6376
;  :datatype-occurs-check   2665
;  :datatype-splits         4292
;  :decisions               7903
;  :del-clause              18950
;  :final-checks            666
;  :interface-eqs           264
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             26636
;  :mk-clause               19169
;  :num-allocs              9364463
;  :num-checks              440
;  :propagations            12867
;  :quant-instantiations    5057
;  :rlimit-count            577624)
(push) ; 8
; [then-branch: 135 | First:(Second:(Second:(Second:($t@82@06))))[2] == 0 | live]
; [else-branch: 135 | First:(Second:(Second:(Second:($t@82@06))))[2] != 0 | live]
(push) ; 9
; [then-branch: 135 | First:(Second:(Second:(Second:($t@82@06))))[2] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
    2)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 135 | First:(Second:(Second:(Second:($t@82@06))))[2] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      2)
    0)))
; [eval] old(diz.Main_event_state[2]) == -1
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43677
;  :arith-add-rows          3406
;  :arith-assert-diseq      3598
;  :arith-assert-lower      7881
;  :arith-assert-upper      4578
;  :arith-bound-prop        687
;  :arith-conflicts         87
;  :arith-eq-adapter        4802
;  :arith-fixed-eqs         2759
;  :arith-offset-eqs        884
;  :arith-pivots            2152
;  :binary-propagations     11
;  :conflicts               750
;  :datatype-accessor-ax    951
;  :datatype-constructor-ax 6376
;  :datatype-occurs-check   2665
;  :datatype-splits         4292
;  :decisions               7903
;  :del-clause              18950
;  :final-checks            666
;  :interface-eqs           264
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             26640
;  :mk-clause               19174
;  :num-allocs              9364463
;  :num-checks              441
;  :propagations            12867
;  :quant-instantiations    5058
;  :rlimit-count            577791)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      2)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               44514
;  :arith-add-rows          3513
;  :arith-assert-diseq      3697
;  :arith-assert-lower      8124
;  :arith-assert-upper      4676
;  :arith-bound-prop        697
;  :arith-conflicts         87
;  :arith-eq-adapter        4929
;  :arith-fixed-eqs         2830
;  :arith-offset-eqs        907
;  :arith-pivots            2212
;  :binary-propagations     11
;  :conflicts               762
;  :datatype-accessor-ax    965
;  :datatype-constructor-ax 6480
;  :datatype-occurs-check   2715
;  :datatype-splits         4364
;  :decisions               8065
;  :del-clause              19498
;  :final-checks            677
;  :interface-eqs           269
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.30
;  :minimized-lits          784
;  :mk-bool-var             27280
;  :mk-clause               19717
;  :num-allocs              9713749
;  :num-checks              442
;  :propagations            13217
;  :quant-instantiations    5196
;  :rlimit-count            586238
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        2)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               45386
;  :arith-add-rows          3609
;  :arith-assert-diseq      3788
;  :arith-assert-lower      8361
;  :arith-assert-upper      4776
;  :arith-bound-prop        707
;  :arith-conflicts         87
;  :arith-eq-adapter        5054
;  :arith-fixed-eqs         2907
;  :arith-offset-eqs        933
;  :arith-pivots            2282
;  :binary-propagations     11
;  :conflicts               775
;  :datatype-accessor-ax    979
;  :datatype-constructor-ax 6584
;  :datatype-occurs-check   2765
;  :datatype-splits         4436
;  :decisions               8228
;  :del-clause              20030
;  :final-checks            688
;  :interface-eqs           274
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             27932
;  :mk-clause               20249
;  :num-allocs              10063501
;  :num-checks              443
;  :propagations            13564
;  :quant-instantiations    5339
;  :rlimit-count            594590
;  :time                    0.01)
; [then-branch: 136 | !(First:(Second:(Second:(Second:($t@82@06))))[2] == 0 || First:(Second:(Second:(Second:($t@82@06))))[2] == -1) | live]
; [else-branch: 136 | First:(Second:(Second:(Second:($t@82@06))))[2] == 0 || First:(Second:(Second:(Second:($t@82@06))))[2] == -1 | live]
(push) ; 9
; [then-branch: 136 | !(First:(Second:(Second:(Second:($t@82@06))))[2] == 0 || First:(Second:(Second:(Second:($t@82@06))))[2] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        2)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
        2)
      (- 0 1)))))
; [eval] diz.Main_event_state[2] == old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               45387
;  :arith-add-rows          3610
;  :arith-assert-diseq      3788
;  :arith-assert-lower      8361
;  :arith-assert-upper      4776
;  :arith-bound-prop        707
;  :arith-conflicts         87
;  :arith-eq-adapter        5054
;  :arith-fixed-eqs         2907
;  :arith-offset-eqs        933
;  :arith-pivots            2282
;  :binary-propagations     11
;  :conflicts               775
;  :datatype-accessor-ax    979
;  :datatype-constructor-ax 6584
;  :datatype-occurs-check   2765
;  :datatype-splits         4436
;  :decisions               8228
;  :del-clause              20030
;  :final-checks            688
;  :interface-eqs           274
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             27936
;  :mk-clause               20254
;  :num-allocs              10063501
;  :num-checks              444
;  :propagations            13565
;  :quant-instantiations    5340
;  :rlimit-count            594778)
; [eval] old(diz.Main_event_state[2])
; [eval] diz.Main_event_state[2]
(push) ; 10
(assert (not (<
  2
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               45387
;  :arith-add-rows          3610
;  :arith-assert-diseq      3788
;  :arith-assert-lower      8361
;  :arith-assert-upper      4776
;  :arith-bound-prop        707
;  :arith-conflicts         87
;  :arith-eq-adapter        5054
;  :arith-fixed-eqs         2907
;  :arith-offset-eqs        933
;  :arith-pivots            2282
;  :binary-propagations     11
;  :conflicts               775
;  :datatype-accessor-ax    979
;  :datatype-constructor-ax 6584
;  :datatype-occurs-check   2765
;  :datatype-splits         4436
;  :decisions               8228
;  :del-clause              20030
;  :final-checks            688
;  :interface-eqs           274
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             27936
;  :mk-clause               20254
;  :num-allocs              10063501
;  :num-checks              445
;  :propagations            13565
;  :quant-instantiations    5340
;  :rlimit-count            594793)
(pop) ; 9
(push) ; 9
; [else-branch: 136 | First:(Second:(Second:(Second:($t@82@06))))[2] == 0 || First:(Second:(Second:(Second:($t@82@06))))[2] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
      2)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
          2)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
          2)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))
      2)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@06)))))
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
(declare-const i@87@06 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 137 | 0 <= i@87@06 | live]
; [else-branch: 137 | !(0 <= i@87@06) | live]
(push) ; 10
; [then-branch: 137 | 0 <= i@87@06]
(assert (<= 0 i@87@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 137 | !(0 <= i@87@06)]
(assert (not (<= 0 i@87@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 138 | i@87@06 < |First:(Second:($t@85@06))| && 0 <= i@87@06 | live]
; [else-branch: 138 | !(i@87@06 < |First:(Second:($t@85@06))| && 0 <= i@87@06) | live]
(push) ; 10
; [then-branch: 138 | i@87@06 < |First:(Second:($t@85@06))| && 0 <= i@87@06]
(assert (and
  (<
    i@87@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))
  (<= 0 i@87@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@87@06 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46229
;  :arith-add-rows          3702
;  :arith-assert-diseq      3887
;  :arith-assert-lower      8605
;  :arith-assert-upper      4875
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5181
;  :arith-fixed-eqs         2978
;  :arith-offset-eqs        955
;  :arith-pivots            2351
;  :binary-propagations     11
;  :conflicts               787
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20573
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.30
;  :minimized-lits          784
;  :mk-bool-var             28591
;  :mk-clause               20814
;  :num-allocs              10419752
;  :num-checks              447
;  :propagations            13922
;  :quant-instantiations    5481
;  :rlimit-count            603167)
; [eval] -1
(push) ; 11
; [then-branch: 139 | First:(Second:($t@85@06))[i@87@06] == -1 | live]
; [else-branch: 139 | First:(Second:($t@85@06))[i@87@06] != -1 | live]
(push) ; 12
; [then-branch: 139 | First:(Second:($t@85@06))[i@87@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
    i@87@06)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 139 | First:(Second:($t@85@06))[i@87@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      i@87@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@87@06 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3889
;  :arith-assert-lower      8612
;  :arith-assert-upper      4878
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5184
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2351
;  :binary-propagations     11
;  :conflicts               787
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20573
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.30
;  :minimized-lits          784
;  :mk-bool-var             28606
;  :mk-clause               20825
;  :num-allocs              10419752
;  :num-checks              448
;  :propagations            13927
;  :quant-instantiations    5484
;  :rlimit-count            603468)
(push) ; 13
; [then-branch: 140 | 0 <= First:(Second:($t@85@06))[i@87@06] | live]
; [else-branch: 140 | !(0 <= First:(Second:($t@85@06))[i@87@06]) | live]
(push) ; 14
; [then-branch: 140 | 0 <= First:(Second:($t@85@06))[i@87@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
    i@87@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@87@06 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3889
;  :arith-assert-lower      8612
;  :arith-assert-upper      4878
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5184
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2351
;  :binary-propagations     11
;  :conflicts               787
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20573
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.30
;  :minimized-lits          784
;  :mk-bool-var             28606
;  :mk-clause               20825
;  :num-allocs              10419752
;  :num-checks              449
;  :propagations            13927
;  :quant-instantiations    5484
;  :rlimit-count            603562)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 140 | !(0 <= First:(Second:($t@85@06))[i@87@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
      i@87@06))))
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
; [else-branch: 138 | !(i@87@06 < |First:(Second:($t@85@06))| && 0 <= i@87@06)]
(assert (not
  (and
    (<
      i@87@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))
    (<= 0 i@87@06))))
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
(assert (not (forall ((i@87@06 Int)) (!
  (implies
    (and
      (<
        i@87@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))
      (<= 0 i@87@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
          i@87@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
            i@87@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
            i@87@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
    i@87@06))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3891
;  :arith-assert-lower      8613
;  :arith-assert-upper      4879
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5185
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2351
;  :binary-propagations     11
;  :conflicts               788
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28618
;  :mk-clause               20845
;  :num-allocs              10776963
;  :num-checks              450
;  :propagations            13929
;  :quant-instantiations    5487
;  :rlimit-count            604050)
(assert (forall ((i@87@06 Int)) (!
  (implies
    (and
      (<
        i@87@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))))
      (<= 0 i@87@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
          i@87@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
            i@87@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
            i@87@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@85@06)))
    i@87@06))
  :qid |prog.l<no position>|)))
(declare-const $k@88@06 $Perm)
(assert ($Perm.isReadVar $k@88@06 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@88@06 $Perm.No) (< $Perm.No $k@88@06))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3892
;  :arith-assert-lower      8615
;  :arith-assert-upper      4880
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5186
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2351
;  :binary-propagations     11
;  :conflicts               789
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28623
;  :mk-clause               20847
;  :num-allocs              10776963
;  :num-checks              451
;  :propagations            13930
;  :quant-instantiations    5487
;  :rlimit-count            604574)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@60@06 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3892
;  :arith-assert-lower      8615
;  :arith-assert-upper      4880
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5186
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2351
;  :binary-propagations     11
;  :conflicts               789
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28623
;  :mk-clause               20847
;  :num-allocs              10776963
;  :num-checks              452
;  :propagations            13930
;  :quant-instantiations    5487
;  :rlimit-count            604585)
(assert (< $k@88@06 $k@60@06))
(assert (<= $Perm.No (- $k@60@06 $k@88@06)))
(assert (<= (- $k@60@06 $k@88@06) $Perm.Write))
(assert (implies (< $Perm.No (- $k@60@06 $k@88@06)) (not (= diz@30@06 $Ref.null))))
; [eval] diz.Main_sensor != null
(push) ; 8
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3892
;  :arith-assert-lower      8617
;  :arith-assert-upper      4881
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5186
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2352
;  :binary-propagations     11
;  :conflicts               790
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28626
;  :mk-clause               20847
;  :num-allocs              10776963
;  :num-checks              453
;  :propagations            13930
;  :quant-instantiations    5487
;  :rlimit-count            604799)
(push) ; 8
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3892
;  :arith-assert-lower      8617
;  :arith-assert-upper      4881
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5186
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2352
;  :binary-propagations     11
;  :conflicts               791
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28626
;  :mk-clause               20847
;  :num-allocs              10776963
;  :num-checks              454
;  :propagations            13930
;  :quant-instantiations    5487
;  :rlimit-count            604847)
(push) ; 8
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3892
;  :arith-assert-lower      8617
;  :arith-assert-upper      4881
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5186
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2352
;  :binary-propagations     11
;  :conflicts               792
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28626
;  :mk-clause               20847
;  :num-allocs              10776963
;  :num-checks              455
;  :propagations            13930
;  :quant-instantiations    5487
;  :rlimit-count            604895)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3892
;  :arith-assert-lower      8617
;  :arith-assert-upper      4881
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5186
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2352
;  :binary-propagations     11
;  :conflicts               792
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28626
;  :mk-clause               20847
;  :num-allocs              10776963
;  :num-checks              456
;  :propagations            13930
;  :quant-instantiations    5487
;  :rlimit-count            604908)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3892
;  :arith-assert-lower      8617
;  :arith-assert-upper      4881
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5186
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2352
;  :binary-propagations     11
;  :conflicts               793
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28626
;  :mk-clause               20847
;  :num-allocs              10776963
;  :num-checks              457
;  :propagations            13930
;  :quant-instantiations    5487
;  :rlimit-count            604956)
(declare-const $k@89@06 $Perm)
(assert ($Perm.isReadVar $k@89@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 8
(assert (not (or (= $k@89@06 $Perm.No) (< $Perm.No $k@89@06))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3893
;  :arith-assert-lower      8619
;  :arith-assert-upper      4882
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5187
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2352
;  :binary-propagations     11
;  :conflicts               794
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28630
;  :mk-clause               20849
;  :num-allocs              10776963
;  :num-checks              458
;  :propagations            13931
;  :quant-instantiations    5487
;  :rlimit-count            605154)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@61@06 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3893
;  :arith-assert-lower      8619
;  :arith-assert-upper      4882
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5187
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2352
;  :binary-propagations     11
;  :conflicts               794
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28630
;  :mk-clause               20849
;  :num-allocs              10776963
;  :num-checks              459
;  :propagations            13931
;  :quant-instantiations    5487
;  :rlimit-count            605165)
(assert (< $k@89@06 $k@61@06))
(assert (<= $Perm.No (- $k@61@06 $k@89@06)))
(assert (<= (- $k@61@06 $k@89@06) $Perm.Write))
(assert (implies (< $Perm.No (- $k@61@06 $k@89@06)) (not (= diz@30@06 $Ref.null))))
; [eval] diz.Main_controller != null
(push) ; 8
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3893
;  :arith-assert-lower      8621
;  :arith-assert-upper      4883
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5187
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2353
;  :binary-propagations     11
;  :conflicts               795
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28633
;  :mk-clause               20849
;  :num-allocs              10776963
;  :num-checks              460
;  :propagations            13931
;  :quant-instantiations    5487
;  :rlimit-count            605379)
(push) ; 8
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3893
;  :arith-assert-lower      8621
;  :arith-assert-upper      4883
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5187
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2353
;  :binary-propagations     11
;  :conflicts               796
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28633
;  :mk-clause               20849
;  :num-allocs              10776963
;  :num-checks              461
;  :propagations            13931
;  :quant-instantiations    5487
;  :rlimit-count            605427)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3893
;  :arith-assert-lower      8621
;  :arith-assert-upper      4883
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5187
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2353
;  :binary-propagations     11
;  :conflicts               796
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28633
;  :mk-clause               20849
;  :num-allocs              10776963
;  :num-checks              462
;  :propagations            13931
;  :quant-instantiations    5487
;  :rlimit-count            605440)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3702
;  :arith-assert-diseq      3893
;  :arith-assert-lower      8621
;  :arith-assert-upper      4883
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5187
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2353
;  :binary-propagations     11
;  :conflicts               797
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20604
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28633
;  :mk-clause               20849
;  :num-allocs              10776963
;  :num-checks              463
;  :propagations            13931
;  :quant-instantiations    5487
;  :rlimit-count            605488)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@85@06))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@06))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))))
                                ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))))))))))))))))))))) diz@30@06 globals@31@06))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 7
(push) ; 7
; [else-branch: 93 | min_advance__31@69@06 == -1]
(assert (= min_advance__31@69@06 (- 0 1)))
(pop) ; 7
(pop) ; 6
(push) ; 6
; [else-branch: 44 | !(First:(Second:($t@67@06))[1] != -1 && First:(Second:($t@67@06))[0] != -1)]
(assert (not
  (and
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46233
;  :arith-add-rows          3711
;  :arith-assert-diseq      3893
;  :arith-assert-lower      8621
;  :arith-assert-upper      4883
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5187
;  :arith-fixed-eqs         2979
;  :arith-offset-eqs        955
;  :arith-pivots            2364
;  :binary-propagations     11
;  :conflicts               797
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20790
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28633
;  :mk-clause               20849
;  :num-allocs              10776963
;  :num-checks              464
;  :propagations            13931
;  :quant-instantiations    5487
;  :rlimit-count            605828)
; [eval] -1
(push) ; 6
; [then-branch: 141 | First:(Second:($t@67@06))[0] != -1 | live]
; [else-branch: 141 | First:(Second:($t@67@06))[0] == -1 | live]
(push) ; 7
; [then-branch: 141 | First:(Second:($t@67@06))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      0)
    (- 0 1))))
; [eval] diz.Main_process_state[1] != -1
; [eval] diz.Main_process_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46236
;  :arith-add-rows          3711
;  :arith-assert-diseq      3895
;  :arith-assert-lower      8628
;  :arith-assert-upper      4886
;  :arith-bound-prop        717
;  :arith-conflicts         87
;  :arith-eq-adapter        5189
;  :arith-fixed-eqs         2980
;  :arith-offset-eqs        955
;  :arith-pivots            2364
;  :binary-propagations     11
;  :conflicts               797
;  :datatype-accessor-ax    993
;  :datatype-constructor-ax 6688
;  :datatype-occurs-check   2815
;  :datatype-splits         4508
;  :decisions               8392
;  :del-clause              20790
;  :final-checks            699
;  :interface-eqs           279
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          784
;  :mk-bool-var             28636
;  :mk-clause               20858
;  :num-allocs              10776963
;  :num-checks              465
;  :propagations            13939
;  :quant-instantiations    5490
;  :rlimit-count            606055)
; [eval] -1
(pop) ; 7
(push) ; 7
; [else-branch: 141 | First:(Second:($t@67@06))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46654
;  :arith-add-rows          3716
;  :arith-assert-diseq      3911
;  :arith-assert-lower      8676
;  :arith-assert-upper      4917
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5219
;  :arith-fixed-eqs         2992
;  :arith-offset-eqs        955
;  :arith-pivots            2376
;  :binary-propagations     11
;  :conflicts               804
;  :datatype-accessor-ax    1008
;  :datatype-constructor-ax 6775
;  :datatype-occurs-check   2847
;  :datatype-splits         4576
;  :decisions               8477
;  :del-clause              20925
;  :final-checks            710
;  :interface-eqs           283
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28835
;  :mk-clause               20984
;  :num-allocs              10776963
;  :num-checks              466
;  :propagations            14011
;  :quant-instantiations    5509
;  :rlimit-count            609034
;  :time                    0.00)
(push) ; 6
(assert (not (not
  (and
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          0)
        (- 0 1)))))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46808
;  :arith-add-rows          3719
;  :arith-assert-diseq      3919
;  :arith-assert-lower      8708
;  :arith-assert-upper      4933
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5234
;  :arith-fixed-eqs         2998
;  :arith-offset-eqs        955
;  :arith-pivots            2382
;  :binary-propagations     11
;  :conflicts               805
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              20976
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28904
;  :mk-clause               21035
;  :num-allocs              10776963
;  :num-checks              467
;  :propagations            14055
;  :quant-instantiations    5523
;  :rlimit-count            610872
;  :time                    0.00)
; [then-branch: 142 | !(First:(Second:($t@67@06))[1] != -1 && First:(Second:($t@67@06))[0] != -1) | live]
; [else-branch: 142 | First:(Second:($t@67@06))[1] != -1 && First:(Second:($t@67@06))[0] != -1 | live]
(push) ; 6
; [then-branch: 142 | !(First:(Second:($t@67@06))[1] != -1 && First:(Second:($t@67@06))[0] != -1)]
(assert (not
  (and
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          1)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
(declare-const i@90@06 Int)
(push) ; 7
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 8
; [then-branch: 143 | 0 <= i@90@06 | live]
; [else-branch: 143 | !(0 <= i@90@06) | live]
(push) ; 9
; [then-branch: 143 | 0 <= i@90@06]
(assert (<= 0 i@90@06))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 143 | !(0 <= i@90@06)]
(assert (not (<= 0 i@90@06)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 144 | i@90@06 < |First:(Second:($t@67@06))| && 0 <= i@90@06 | live]
; [else-branch: 144 | !(i@90@06 < |First:(Second:($t@67@06))| && 0 <= i@90@06) | live]
(push) ; 9
; [then-branch: 144 | i@90@06 < |First:(Second:($t@67@06))| && 0 <= i@90@06]
(assert (and
  (<
    i@90@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
  (<= 0 i@90@06)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i@90@06 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46810
;  :arith-add-rows          3719
;  :arith-assert-diseq      3919
;  :arith-assert-lower      8709
;  :arith-assert-upper      4934
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5236
;  :arith-fixed-eqs         2998
;  :arith-offset-eqs        955
;  :arith-pivots            2382
;  :binary-propagations     11
;  :conflicts               805
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              20976
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28910
;  :mk-clause               21046
;  :num-allocs              10776963
;  :num-checks              468
;  :propagations            14055
;  :quant-instantiations    5523
;  :rlimit-count            611156)
; [eval] -1
(push) ; 10
; [then-branch: 145 | First:(Second:($t@67@06))[i@90@06] == -1 | live]
; [else-branch: 145 | First:(Second:($t@67@06))[i@90@06] != -1 | live]
(push) ; 11
; [then-branch: 145 | First:(Second:($t@67@06))[i@90@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@90@06)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 145 | First:(Second:($t@67@06))[i@90@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      i@90@06)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 12
(assert (not (>= i@90@06 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3921
;  :arith-assert-lower      8716
;  :arith-assert-upper      4937
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5239
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2383
;  :binary-propagations     11
;  :conflicts               805
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              20976
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28925
;  :mk-clause               21063
;  :num-allocs              10776963
;  :num-checks              469
;  :propagations            14062
;  :quant-instantiations    5526
;  :rlimit-count            611464)
(push) ; 12
; [then-branch: 146 | 0 <= First:(Second:($t@67@06))[i@90@06] | live]
; [else-branch: 146 | !(0 <= First:(Second:($t@67@06))[i@90@06]) | live]
(push) ; 13
; [then-branch: 146 | 0 <= First:(Second:($t@67@06))[i@90@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@90@06)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@90@06 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3921
;  :arith-assert-lower      8716
;  :arith-assert-upper      4937
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5239
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2383
;  :binary-propagations     11
;  :conflicts               805
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              20976
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28925
;  :mk-clause               21063
;  :num-allocs              10776963
;  :num-checks              470
;  :propagations            14062
;  :quant-instantiations    5526
;  :rlimit-count            611558)
; [eval] |diz.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 146 | !(0 <= First:(Second:($t@67@06))[i@90@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
      i@90@06))))
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
; [else-branch: 144 | !(i@90@06 < |First:(Second:($t@67@06))| && 0 <= i@90@06)]
(assert (not
  (and
    (<
      i@90@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
    (<= 0 i@90@06))))
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
(assert (not (forall ((i@90@06 Int)) (!
  (implies
    (and
      (<
        i@90@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
      (<= 0 i@90@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          i@90@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@90@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@90@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@90@06))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3923
;  :arith-assert-lower      8717
;  :arith-assert-upper      4938
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5241
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2384
;  :binary-propagations     11
;  :conflicts               806
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28939
;  :mk-clause               21090
;  :num-allocs              10776963
;  :num-checks              471
;  :propagations            14064
;  :quant-instantiations    5529
;  :rlimit-count            612049)
(assert (forall ((i@90@06 Int)) (!
  (implies
    (and
      (<
        i@90@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))))
      (<= 0 i@90@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
          i@90@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@90@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
            i@90@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
    i@90@06))
  :qid |prog.l<no position>|)))
(declare-const $k@91@06 $Perm)
(assert ($Perm.isReadVar $k@91@06 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@91@06 $Perm.No) (< $Perm.No $k@91@06))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3924
;  :arith-assert-lower      8719
;  :arith-assert-upper      4939
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5242
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2384
;  :binary-propagations     11
;  :conflicts               807
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28944
;  :mk-clause               21092
;  :num-allocs              10776963
;  :num-checks              472
;  :propagations            14065
;  :quant-instantiations    5529
;  :rlimit-count            612573)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@60@06 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3924
;  :arith-assert-lower      8719
;  :arith-assert-upper      4939
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5242
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2384
;  :binary-propagations     11
;  :conflicts               807
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28944
;  :mk-clause               21092
;  :num-allocs              10776963
;  :num-checks              473
;  :propagations            14065
;  :quant-instantiations    5529
;  :rlimit-count            612584)
(assert (< $k@91@06 $k@60@06))
(assert (<= $Perm.No (- $k@60@06 $k@91@06)))
(assert (<= (- $k@60@06 $k@91@06) $Perm.Write))
(assert (implies (< $Perm.No (- $k@60@06 $k@91@06)) (not (= diz@30@06 $Ref.null))))
; [eval] diz.Main_sensor != null
(push) ; 7
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3924
;  :arith-assert-lower      8721
;  :arith-assert-upper      4940
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5242
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2385
;  :binary-propagations     11
;  :conflicts               808
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28947
;  :mk-clause               21092
;  :num-allocs              10776963
;  :num-checks              474
;  :propagations            14065
;  :quant-instantiations    5529
;  :rlimit-count            612798)
(push) ; 7
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3924
;  :arith-assert-lower      8721
;  :arith-assert-upper      4940
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5242
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2385
;  :binary-propagations     11
;  :conflicts               809
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28947
;  :mk-clause               21092
;  :num-allocs              10776963
;  :num-checks              475
;  :propagations            14065
;  :quant-instantiations    5529
;  :rlimit-count            612846)
(push) ; 7
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3924
;  :arith-assert-lower      8721
;  :arith-assert-upper      4940
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5242
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2385
;  :binary-propagations     11
;  :conflicts               810
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28947
;  :mk-clause               21092
;  :num-allocs              10776963
;  :num-checks              476
;  :propagations            14065
;  :quant-instantiations    5529
;  :rlimit-count            612894)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3924
;  :arith-assert-lower      8721
;  :arith-assert-upper      4940
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5242
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2385
;  :binary-propagations     11
;  :conflicts               810
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28947
;  :mk-clause               21092
;  :num-allocs              10776963
;  :num-checks              477
;  :propagations            14065
;  :quant-instantiations    5529
;  :rlimit-count            612907)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3924
;  :arith-assert-lower      8721
;  :arith-assert-upper      4940
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5242
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2385
;  :binary-propagations     11
;  :conflicts               811
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28947
;  :mk-clause               21092
;  :num-allocs              10776963
;  :num-checks              478
;  :propagations            14065
;  :quant-instantiations    5529
;  :rlimit-count            612955)
(declare-const $k@92@06 $Perm)
(assert ($Perm.isReadVar $k@92@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@92@06 $Perm.No) (< $Perm.No $k@92@06))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3925
;  :arith-assert-lower      8723
;  :arith-assert-upper      4941
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5243
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2385
;  :binary-propagations     11
;  :conflicts               812
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28951
;  :mk-clause               21094
;  :num-allocs              10776963
;  :num-checks              479
;  :propagations            14066
;  :quant-instantiations    5529
;  :rlimit-count            613154)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@61@06 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3925
;  :arith-assert-lower      8723
;  :arith-assert-upper      4941
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5243
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2385
;  :binary-propagations     11
;  :conflicts               812
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28951
;  :mk-clause               21094
;  :num-allocs              10776963
;  :num-checks              480
;  :propagations            14066
;  :quant-instantiations    5529
;  :rlimit-count            613165)
(assert (< $k@92@06 $k@61@06))
(assert (<= $Perm.No (- $k@61@06 $k@92@06)))
(assert (<= (- $k@61@06 $k@92@06) $Perm.Write))
(assert (implies (< $Perm.No (- $k@61@06 $k@92@06)) (not (= diz@30@06 $Ref.null))))
; [eval] diz.Main_controller != null
(push) ; 7
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3925
;  :arith-assert-lower      8725
;  :arith-assert-upper      4942
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5243
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2385
;  :binary-propagations     11
;  :conflicts               813
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28954
;  :mk-clause               21094
;  :num-allocs              10776963
;  :num-checks              481
;  :propagations            14066
;  :quant-instantiations    5529
;  :rlimit-count            613373)
(push) ; 7
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3925
;  :arith-assert-lower      8725
;  :arith-assert-upper      4942
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5243
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2385
;  :binary-propagations     11
;  :conflicts               814
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28954
;  :mk-clause               21094
;  :num-allocs              10776963
;  :num-checks              482
;  :propagations            14066
;  :quant-instantiations    5529
;  :rlimit-count            613421)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3925
;  :arith-assert-lower      8725
;  :arith-assert-upper      4942
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5243
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2385
;  :binary-propagations     11
;  :conflicts               814
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28954
;  :mk-clause               21094
;  :num-allocs              10776963
;  :num-checks              483
;  :propagations            14066
;  :quant-instantiations    5529
;  :rlimit-count            613434)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46814
;  :arith-add-rows          3719
;  :arith-assert-diseq      3925
;  :arith-assert-lower      8725
;  :arith-assert-upper      4942
;  :arith-bound-prop        725
;  :arith-conflicts         87
;  :arith-eq-adapter        5243
;  :arith-fixed-eqs         2999
;  :arith-offset-eqs        955
;  :arith-pivots            2385
;  :binary-propagations     11
;  :conflicts               815
;  :datatype-accessor-ax    1011
;  :datatype-constructor-ax 6805
;  :datatype-occurs-check   2861
;  :datatype-splits         4600
;  :decisions               8511
;  :del-clause              21020
;  :final-checks            715
;  :interface-eqs           285
;  :max-generation          5
;  :max-memory              5.30
;  :memory                  5.20
;  :minimized-lits          785
;  :mk-bool-var             28954
;  :mk-clause               21094
;  :num-allocs              10776963
;  :num-checks              484
;  :propagations            14066
;  :quant-instantiations    5529
;  :rlimit-count            613482)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@67@06))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@06))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))
                            ($Snap.combine
                              $Snap.unit
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06))))))))))))))))
                                ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@58@06)))))))))))))))))))))))))))))))) diz@30@06 globals@31@06))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 6
(push) ; 6
; [else-branch: 142 | First:(Second:($t@67@06))[1] != -1 && First:(Second:($t@67@06))[0] != -1]
(assert (and
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
        1)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@06)))
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
