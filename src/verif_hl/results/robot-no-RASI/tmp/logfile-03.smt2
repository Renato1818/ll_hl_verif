(get-info :version)
; (:version "4.8.6")
; Started: 2024-06-21 14:46:57
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
; ---------- Sensor___contract_unsatisfiable__run_EncodedGlobalVariables ----------
(declare-const diz@0@03 $Ref)
(declare-const globals@1@03 $Ref)
(declare-const diz@2@03 $Ref)
(declare-const globals@3@03 $Ref)
(push) ; 1
(declare-const $t@4@03 $Snap)
(assert (= $t@4@03 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@2@03 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.Sensor_m, 1 / 2) && diz.Sensor_m != null && acc(diz.Sensor_m.Main_sensor, wildcard) && diz.Sensor_m.Main_sensor == diz && acc(diz.Sensor_init, 1 / 2) && !diz.Sensor_init)
(declare-const $t@5@03 $Snap)
(assert (= $t@5@03 ($Snap.combine ($Snap.first $t@5@03) ($Snap.second $t@5@03))))
(assert (= ($Snap.first $t@5@03) $Snap.unit))
(assert (=
  ($Snap.second $t@5@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@5@03))
    ($Snap.second ($Snap.second $t@5@03)))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             17
;  :arith-assert-lower    1
;  :arith-assert-upper    1
;  :arith-eq-adapter      1
;  :binary-propagations   11
;  :datatype-accessor-ax  3
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.80
;  :mk-bool-var           252
;  :mk-clause             1
;  :num-allocs            3404234
;  :num-checks            2
;  :propagations          11
;  :quant-instantiations  1
;  :rlimit-count          110416)
(assert (=
  ($Snap.second ($Snap.second $t@5@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@5@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@5@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@5@03))) $Snap.unit))
; [eval] diz.Sensor_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@03))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@5@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@5@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@03)))))))
(declare-const $k@6@03 $Perm)
(assert ($Perm.isReadVar $k@6@03 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@6@03 $Perm.No) (< $Perm.No $k@6@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             29
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             1
;  :datatype-accessor-ax  5
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.80
;  :mk-bool-var           261
;  :mk-clause             3
;  :num-allocs            3404234
;  :num-checks            3
;  :propagations          12
;  :quant-instantiations  2
;  :rlimit-count          110988)
(assert (<= $Perm.No $k@6@03))
(assert (<= $k@6@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@6@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@03)))))
  $Snap.unit))
; [eval] diz.Sensor_m.Main_sensor == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             35
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             2
;  :datatype-accessor-ax  6
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.80
;  :mk-bool-var           264
;  :mk-clause             3
;  :num-allocs            3404234
;  :num-checks            4
;  :propagations          12
;  :quant-instantiations  2
;  :rlimit-count          111261)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@5@03)))))
  diz@2@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@03)))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             42
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   11
;  :conflicts             2
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.80
;  :mk-bool-var           267
;  :mk-clause             3
;  :num-allocs            3404234
;  :num-checks            5
;  :propagations          12
;  :quant-instantiations  3
;  :rlimit-count          111512)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@03))))))
  $Snap.unit))
; [eval] !diz.Sensor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@03)))))))))
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
; ---------- Main_Main_EncodedGlobalVariables_Integer ----------
(declare-const globals@7@03 $Ref)
(declare-const md0@8@03 Int)
(declare-const sys__result@9@03 $Ref)
(declare-const globals@10@03 $Ref)
(declare-const md0@11@03 Int)
(declare-const sys__result@12@03 $Ref)
(push) ; 1
(declare-const $t@13@03 $Snap)
(assert (= $t@13@03 $Snap.unit))
; [eval] 0 < md0
(assert (< 0 md0@11@03))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@14@03 $Snap)
(assert (= $t@14@03 ($Snap.combine ($Snap.first $t@14@03) ($Snap.second $t@14@03))))
(assert (= ($Snap.first $t@14@03) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@12@03 $Ref.null)))
(assert (=
  ($Snap.second $t@14@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@14@03))
    ($Snap.second ($Snap.second $t@14@03)))))
(assert (= ($Snap.first ($Snap.second $t@14@03)) $Snap.unit))
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
(assert (= (type_of<TYPE> sys__result@12@03) (as class_Main<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@14@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@14@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))
(declare-const $k@15@03 $Perm)
(assert ($Perm.isReadVar $k@15@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@15@03 $Perm.No) (< $Perm.No $k@15@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               98
;  :arith-assert-diseq      2
;  :arith-assert-lower      6
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               3
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             287
;  :mk-clause               5
;  :num-allocs              3404234
;  :num-checks              11
;  :propagations            13
;  :quant-instantiations    5
;  :rlimit-count            113974)
(assert (<= $Perm.No $k@15@03))
(assert (<= $k@15@03 $Perm.Write))
(assert (implies (< $Perm.No $k@15@03) (not (= sys__result@12@03 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@14@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@03))))
  $Snap.unit))
; [eval] sys__result.Main_sensor != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               104
;  :arith-assert-diseq      2
;  :arith-assert-lower      6
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               4
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             290
;  :mk-clause               5
;  :num-allocs              3404234
;  :num-checks              12
;  :propagations            13
;  :quant-instantiations    5
;  :rlimit-count            114237)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@14@03))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))
(push) ; 3
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               110
;  :arith-assert-diseq      2
;  :arith-assert-lower      6
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             293
;  :mk-clause               5
;  :num-allocs              3404234
;  :num-checks              13
;  :propagations            13
;  :quant-instantiations    6
;  :rlimit-count            114533)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               110
;  :arith-assert-diseq      2
;  :arith-assert-lower      6
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               5
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             293
;  :mk-clause               5
;  :num-allocs              3404234
;  :num-checks              14
;  :propagations            13
;  :quant-instantiations    6
;  :rlimit-count            114546)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))
  $Snap.unit))
; [eval] sys__result.Main_sensor.Sensor_m == sys__result
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               116
;  :arith-assert-diseq      2
;  :arith-assert-lower      6
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               6
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             295
;  :mk-clause               5
;  :num-allocs              3404234
;  :num-checks              15
;  :propagations            13
;  :quant-instantiations    6
;  :rlimit-count            114775)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))
  sys__result@12@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               123
;  :arith-assert-diseq      2
;  :arith-assert-lower      6
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             298
;  :mk-clause               5
;  :num-allocs              3404234
;  :num-checks              16
;  :propagations            13
;  :quant-instantiations    7
;  :rlimit-count            115071)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               123
;  :arith-assert-diseq      2
;  :arith-assert-lower      6
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               7
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             298
;  :mk-clause               5
;  :num-allocs              3404234
;  :num-checks              17
;  :propagations            13
;  :quant-instantiations    7
;  :rlimit-count            115084)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))
  $Snap.unit))
; [eval] !sys__result.Main_sensor.Sensor_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               129
;  :arith-assert-diseq      2
;  :arith-assert-lower      6
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     11
;  :conflicts               8
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             300
;  :mk-clause               5
;  :num-allocs              3404234
;  :num-checks              18
;  :propagations            13
;  :quant-instantiations    7
;  :rlimit-count            115333)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))
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
; (:added-eqs               138
;  :arith-assert-diseq      3
;  :arith-assert-lower      8
;  :arith-assert-upper      6
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               9
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             308
;  :mk-clause               7
;  :num-allocs              3404234
;  :num-checks              19
;  :propagations            14
;  :quant-instantiations    9
;  :rlimit-count            115811)
(assert (<= $Perm.No $k@16@03))
(assert (<= $k@16@03 $Perm.Write))
(assert (implies (< $Perm.No $k@16@03) (not (= sys__result@12@03 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))
  $Snap.unit))
; [eval] sys__result.Main_controller != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               144
;  :arith-assert-diseq      3
;  :arith-assert-lower      8
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               10
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             311
;  :mk-clause               7
;  :num-allocs              3404234
;  :num-checks              20
;  :propagations            14
;  :quant-instantiations    9
;  :rlimit-count            116134)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               150
;  :arith-assert-diseq      3
;  :arith-assert-lower      8
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               11
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             314
;  :mk-clause               7
;  :num-allocs              3404234
;  :num-checks              21
;  :propagations            14
;  :quant-instantiations    10
;  :rlimit-count            116488)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               150
;  :arith-assert-diseq      3
;  :arith-assert-lower      8
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               11
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             314
;  :mk-clause               7
;  :num-allocs              3404234
;  :num-checks              22
;  :propagations            14
;  :quant-instantiations    10
;  :rlimit-count            116501)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))
  $Snap.unit))
; [eval] sys__result.Main_controller.Controller_m == sys__result
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               156
;  :arith-assert-diseq      3
;  :arith-assert-lower      8
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               12
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             316
;  :mk-clause               7
;  :num-allocs              3404234
;  :num-checks              23
;  :propagations            14
;  :quant-instantiations    10
;  :rlimit-count            116790)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))
  sys__result@12@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               164
;  :arith-assert-diseq      3
;  :arith-assert-lower      8
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               13
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             319
;  :mk-clause               7
;  :num-allocs              3404234
;  :num-checks              24
;  :propagations            14
;  :quant-instantiations    11
;  :rlimit-count            117145)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               164
;  :arith-assert-diseq      3
;  :arith-assert-lower      8
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               13
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.80
;  :mk-bool-var             319
;  :mk-clause               7
;  :num-allocs              3404234
;  :num-checks              25
;  :propagations            14
;  :quant-instantiations    11
;  :rlimit-count            117158)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))))
  $Snap.unit))
; [eval] !sys__result.Main_controller.Controller_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               170
;  :arith-assert-diseq      3
;  :arith-assert-lower      8
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               14
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             321
;  :mk-clause               7
;  :num-allocs              3525902
;  :num-checks              26
;  :propagations            14
;  :quant-instantiations    11
;  :rlimit-count            117467
;  :time                    0.00)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@03))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@15@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               178
;  :arith-assert-diseq      3
;  :arith-assert-lower      8
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               15
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             324
;  :mk-clause               7
;  :num-allocs              3525902
;  :num-checks              27
;  :propagations            14
;  :quant-instantiations    12
;  :rlimit-count            117843)
(push) ; 3
(assert (not (< $Perm.No $k@16@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               178
;  :arith-assert-diseq      3
;  :arith-assert-lower      8
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     11
;  :conflicts               16
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   12
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.90
;  :mk-bool-var             324
;  :mk-clause               7
;  :num-allocs              3525902
;  :num-checks              28
;  :propagations            14
;  :quant-instantiations    12
;  :rlimit-count            117891)
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_31__36: Ref
(declare-const __flatten_31__36@17@03 $Ref)
; [exec]
; var __flatten_29__35: Ref
(declare-const __flatten_29__35@18@03 $Ref)
; [exec]
; var __flatten_28__34: Seq[Int]
(declare-const __flatten_28__34@19@03 Seq<Int>)
; [exec]
; var __flatten_27__33: Seq[Int]
(declare-const __flatten_27__33@20@03 Seq<Int>)
; [exec]
; var __flatten_26__32: Seq[Int]
(declare-const __flatten_26__32@21@03 Seq<Int>)
; [exec]
; var __flatten_25__31: Seq[Int]
(declare-const __flatten_25__31@22@03 Seq<Int>)
; [exec]
; var diz__30: Ref
(declare-const diz__30@23@03 $Ref)
; [exec]
; diz__30 := new(Main_process_state, Main_event_state, Main_sensor, Main_controller, Main_MIN_DIST)
(declare-const diz__30@24@03 $Ref)
(assert (not (= diz__30@24@03 $Ref.null)))
(declare-const Main_process_state@25@03 Seq<Int>)
(declare-const Main_event_state@26@03 Seq<Int>)
(declare-const Main_sensor@27@03 $Ref)
(declare-const Main_controller@28@03 $Ref)
(declare-const Main_MIN_DIST@29@03 Int)
(assert (not (= diz__30@24@03 sys__result@12@03)))
(assert (not (= diz__30@24@03 __flatten_31__36@17@03)))
(assert (not (= diz__30@24@03 diz__30@23@03)))
(assert (not (= diz__30@24@03 __flatten_29__35@18@03)))
(assert (not (= diz__30@24@03 globals@10@03)))
; [exec]
; inhale type_of(diz__30) == class_Main()
(declare-const $t@30@03 $Snap)
(assert (= $t@30@03 $Snap.unit))
; [eval] type_of(diz__30) == class_Main()
; [eval] type_of(diz__30)
; [eval] class_Main()
(assert (= (type_of<TYPE> diz__30@24@03) (as class_Main<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; __flatten_26__32 := Seq(-1, -1)
; [eval] Seq(-1, -1)
; [eval] -1
; [eval] -1
(assert (= (Seq_length (Seq_append (Seq_singleton (- 0 1)) (Seq_singleton (- 0 1)))) 2))
(declare-const __flatten_26__32@31@03 Seq<Int>)
(assert (Seq_equal
  __flatten_26__32@31@03
  (Seq_append (Seq_singleton (- 0 1)) (Seq_singleton (- 0 1)))))
; [exec]
; __flatten_25__31 := __flatten_26__32
; [exec]
; diz__30.Main_process_state := __flatten_25__31
; [exec]
; __flatten_28__34 := Seq(-3, -3, -3)
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
(declare-const __flatten_28__34@32@03 Seq<Int>)
(assert (Seq_equal
  __flatten_28__34@32@03
  (Seq_append
    (Seq_append (Seq_singleton (- 0 3)) (Seq_singleton (- 0 3)))
    (Seq_singleton (- 0 3)))))
; [exec]
; __flatten_27__33 := __flatten_28__34
; [exec]
; diz__30.Main_event_state := __flatten_27__33
; [exec]
; diz__30.Main_MIN_DIST := md0
; [exec]
; __flatten_29__35 := Sensor_Sensor_EncodedGlobalVariables_Main(globals, diz__30)
(declare-const sys__result@33@03 $Ref)
(declare-const $t@34@03 $Snap)
(assert (= $t@34@03 ($Snap.combine ($Snap.first $t@34@03) ($Snap.second $t@34@03))))
(assert (= ($Snap.first $t@34@03) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@33@03 $Ref.null)))
(assert (=
  ($Snap.second $t@34@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@34@03))
    ($Snap.second ($Snap.second $t@34@03)))))
(assert (= ($Snap.first ($Snap.second $t@34@03)) $Snap.unit))
; [eval] type_of(sys__result) == class_Sensor()
; [eval] type_of(sys__result)
; [eval] class_Sensor()
(assert (= (type_of<TYPE> sys__result@33@03) (as class_Sensor<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@34@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@34@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@34@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
  $Snap.unit))
; [eval] sys__result.Sensor_m == m0
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
  diz__30@24@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  $Snap.unit))
; [eval] !sys__result.Sensor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; diz__30.Main_sensor := __flatten_29__35
; [exec]
; __flatten_31__36 := Controller_Controller_EncodedGlobalVariables_Main(globals, diz__30)
(declare-const sys__result@35@03 $Ref)
(declare-const $t@36@03 $Snap)
(assert (= $t@36@03 ($Snap.combine ($Snap.first $t@36@03) ($Snap.second $t@36@03))))
(assert (= ($Snap.first $t@36@03) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@35@03 $Ref.null)))
(assert (=
  ($Snap.second $t@36@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@36@03))
    ($Snap.second ($Snap.second $t@36@03)))))
(assert (= ($Snap.first ($Snap.second $t@36@03)) $Snap.unit))
; [eval] type_of(sys__result) == class_Controller()
; [eval] type_of(sys__result)
; [eval] class_Controller()
(assert (= (type_of<TYPE> sys__result@35@03) (as class_Controller<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@36@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@36@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@36@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@36@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))
  $Snap.unit))
; [eval] sys__result.Controller_m == m0
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))
  diz__30@24@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))))
  $Snap.unit))
; [eval] !sys__result.Controller_alarm_flag
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))))
  $Snap.unit))
; [eval] !sys__result.Controller_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))))))))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__30.Main_controller := __flatten_31__36
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz__30, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 2
; [eval] |diz.Main_process_state|
(set-option :timeout 0)
(push) ; 3
(assert (not (= (Seq_length __flatten_26__32@31@03) 2)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               351
;  :arith-add-rows          11
;  :arith-assert-diseq      8
;  :arith-assert-lower      29
;  :arith-assert-upper      18
;  :arith-bound-prop        2
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        4
;  :arith-pivots            9
;  :binary-propagations     11
;  :conflicts               20
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   23
;  :datatype-splits         8
;  :decisions               24
;  :del-clause              98
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             479
;  :mk-clause               99
;  :num-allocs              3650117
;  :num-checks              32
;  :propagations            53
;  :quant-instantiations    47
;  :rlimit-count            123128)
(assert (= (Seq_length __flatten_26__32@31@03) 2))
; [eval] |diz.Main_event_state| == 3
; [eval] |diz.Main_event_state|
(push) ; 3
(assert (not (= (Seq_length __flatten_28__34@32@03) 3)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               352
;  :arith-add-rows          11
;  :arith-assert-diseq      8
;  :arith-assert-lower      30
;  :arith-assert-upper      19
;  :arith-bound-prop        2
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        4
;  :arith-pivots            9
;  :binary-propagations     11
;  :conflicts               21
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   23
;  :datatype-splits         8
;  :decisions               24
;  :del-clause              98
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             485
;  :mk-clause               99
;  :num-allocs              3650117
;  :num-checks              33
;  :propagations            53
;  :quant-instantiations    47
;  :rlimit-count            123253)
(assert (= (Seq_length __flatten_28__34@32@03) 3))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@37@03 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@37@03 | live]
; [else-branch: 0 | !(0 <= i@37@03) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@37@03]
(assert (<= 0 i@37@03))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@37@03)]
(assert (not (<= 0 i@37@03)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@37@03 < |__flatten_26__32@31@03| && 0 <= i@37@03 | live]
; [else-branch: 1 | !(i@37@03 < |__flatten_26__32@31@03| && 0 <= i@37@03) | live]
(push) ; 5
; [then-branch: 1 | i@37@03 < |__flatten_26__32@31@03| && 0 <= i@37@03]
(assert (and (< i@37@03 (Seq_length __flatten_26__32@31@03)) (<= 0 i@37@03)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 6
(assert (not (>= i@37@03 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               353
;  :arith-add-rows          11
;  :arith-assert-diseq      8
;  :arith-assert-lower      32
;  :arith-assert-upper      21
;  :arith-bound-prop        2
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        4
;  :arith-pivots            9
;  :binary-propagations     11
;  :conflicts               21
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   23
;  :datatype-splits         8
;  :decisions               24
;  :del-clause              98
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             490
;  :mk-clause               99
;  :num-allocs              3650117
;  :num-checks              34
;  :propagations            53
;  :quant-instantiations    47
;  :rlimit-count            123440)
; [eval] -1
(push) ; 6
; [then-branch: 2 | __flatten_26__32@31@03[i@37@03] == -1 | live]
; [else-branch: 2 | __flatten_26__32@31@03[i@37@03] != -1 | live]
(push) ; 7
; [then-branch: 2 | __flatten_26__32@31@03[i@37@03] == -1]
(assert (= (Seq_index __flatten_26__32@31@03 i@37@03) (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | __flatten_26__32@31@03[i@37@03] != -1]
(assert (not (= (Seq_index __flatten_26__32@31@03 i@37@03) (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@37@03 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               354
;  :arith-add-rows          13
;  :arith-assert-diseq      8
;  :arith-assert-lower      32
;  :arith-assert-upper      21
;  :arith-bound-prop        2
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        4
;  :arith-pivots            9
;  :binary-propagations     11
;  :conflicts               21
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   23
;  :datatype-splits         8
;  :decisions               24
;  :del-clause              98
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             495
;  :mk-clause               103
;  :num-allocs              3650117
;  :num-checks              35
;  :propagations            53
;  :quant-instantiations    48
;  :rlimit-count            123609)
(push) ; 8
; [then-branch: 3 | 0 <= __flatten_26__32@31@03[i@37@03] | live]
; [else-branch: 3 | !(0 <= __flatten_26__32@31@03[i@37@03]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= __flatten_26__32@31@03[i@37@03]]
(assert (<= 0 (Seq_index __flatten_26__32@31@03 i@37@03)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@37@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               354
;  :arith-add-rows          13
;  :arith-assert-diseq      9
;  :arith-assert-lower      35
;  :arith-assert-upper      21
;  :arith-bound-prop        2
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        4
;  :arith-pivots            9
;  :binary-propagations     11
;  :conflicts               21
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   23
;  :datatype-splits         8
;  :decisions               24
;  :del-clause              98
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             498
;  :mk-clause               104
;  :num-allocs              3650117
;  :num-checks              36
;  :propagations            53
;  :quant-instantiations    48
;  :rlimit-count            123682)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= __flatten_26__32@31@03[i@37@03])]
(assert (not (<= 0 (Seq_index __flatten_26__32@31@03 i@37@03))))
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
; [else-branch: 1 | !(i@37@03 < |__flatten_26__32@31@03| && 0 <= i@37@03)]
(assert (not (and (< i@37@03 (Seq_length __flatten_26__32@31@03)) (<= 0 i@37@03))))
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
(assert (not (forall ((i@37@03 Int)) (!
  (implies
    (and (< i@37@03 (Seq_length __flatten_26__32@31@03)) (<= 0 i@37@03))
    (or
      (= (Seq_index __flatten_26__32@31@03 i@37@03) (- 0 1))
      (and
        (<
          (Seq_index __flatten_26__32@31@03 i@37@03)
          (Seq_length __flatten_28__34@32@03))
        (<= 0 (Seq_index __flatten_26__32@31@03 i@37@03)))))
  :pattern ((Seq_index __flatten_26__32@31@03 i@37@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               389
;  :arith-add-rows          23
;  :arith-assert-diseq      13
;  :arith-assert-lower      44
;  :arith-assert-upper      25
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               30
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   26
;  :datatype-splits         9
;  :decisions               33
;  :del-clause              160
;  :final-checks            15
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             551
;  :mk-clause               161
;  :num-allocs              3650117
;  :num-checks              37
;  :propagations            63
;  :quant-instantiations    52
;  :rlimit-count            124454)
(assert (forall ((i@37@03 Int)) (!
  (implies
    (and (< i@37@03 (Seq_length __flatten_26__32@31@03)) (<= 0 i@37@03))
    (or
      (= (Seq_index __flatten_26__32@31@03 i@37@03) (- 0 1))
      (and
        (<
          (Seq_index __flatten_26__32@31@03 i@37@03)
          (Seq_length __flatten_28__34@32@03))
        (<= 0 (Seq_index __flatten_26__32@31@03 i@37@03)))))
  :pattern ((Seq_index __flatten_26__32@31@03 i@37@03))
  :qid |prog.l<no position>|)))
(declare-const $k@38@03 $Perm)
(assert ($Perm.isReadVar $k@38@03 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@38@03 $Perm.No) (< $Perm.No $k@38@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               389
;  :arith-add-rows          23
;  :arith-assert-diseq      14
;  :arith-assert-lower      46
;  :arith-assert-upper      26
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               31
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   26
;  :datatype-splits         9
;  :decisions               33
;  :del-clause              160
;  :final-checks            15
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             556
;  :mk-clause               163
;  :num-allocs              3650117
;  :num-checks              38
;  :propagations            64
;  :quant-instantiations    52
;  :rlimit-count            124924)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               389
;  :arith-add-rows          23
;  :arith-assert-diseq      14
;  :arith-assert-lower      46
;  :arith-assert-upper      26
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               31
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   26
;  :datatype-splits         9
;  :decisions               33
;  :del-clause              160
;  :final-checks            15
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             556
;  :mk-clause               163
;  :num-allocs              3650117
;  :num-checks              39
;  :propagations            64
;  :quant-instantiations    52
;  :rlimit-count            124937)
(assert (< $k@38@03 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@38@03)))
(assert (<= (- $Perm.Write $k@38@03) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@38@03)) (not (= diz__30@24@03 $Ref.null))))
; [eval] 0 < diz.Main_MIN_DIST
(declare-const $k@39@03 $Perm)
(assert ($Perm.isReadVar $k@39@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@39@03 $Perm.No) (< $Perm.No $k@39@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               389
;  :arith-add-rows          23
;  :arith-assert-diseq      15
;  :arith-assert-lower      48
;  :arith-assert-upper      28
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               32
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   26
;  :datatype-splits         9
;  :decisions               33
;  :del-clause              160
;  :final-checks            15
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             561
;  :mk-clause               165
;  :num-allocs              3650117
;  :num-checks              40
;  :propagations            65
;  :quant-instantiations    52
;  :rlimit-count            125225)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               389
;  :arith-add-rows          23
;  :arith-assert-diseq      15
;  :arith-assert-lower      48
;  :arith-assert-upper      28
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               32
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   26
;  :datatype-splits         9
;  :decisions               33
;  :del-clause              160
;  :final-checks            15
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             561
;  :mk-clause               165
;  :num-allocs              3650117
;  :num-checks              41
;  :propagations            65
;  :quant-instantiations    52
;  :rlimit-count            125238)
(assert (< $k@39@03 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@39@03)))
(assert (<= (- $Perm.Write $k@39@03) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@39@03)) (not (= diz__30@24@03 $Ref.null))))
; [eval] diz.Main_sensor != null
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               389
;  :arith-add-rows          23
;  :arith-assert-diseq      15
;  :arith-assert-lower      48
;  :arith-assert-upper      29
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               32
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   26
;  :datatype-splits         9
;  :decisions               33
;  :del-clause              160
;  :final-checks            15
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             562
;  :mk-clause               165
;  :num-allocs              3650117
;  :num-checks              42
;  :propagations            65
;  :quant-instantiations    52
;  :rlimit-count            125335)
(set-option :timeout 10)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               405
;  :arith-add-rows          23
;  :arith-assert-diseq      15
;  :arith-assert-lower      48
;  :arith-assert-upper      29
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               32
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   32
;  :datatype-splits         10
;  :decisions               38
;  :del-clause              160
;  :final-checks            17
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             563
;  :mk-clause               165
;  :num-allocs              3650117
;  :num-checks              43
;  :propagations            65
;  :quant-instantiations    52
;  :rlimit-count            125737)
(declare-const $k@40@03 $Perm)
(assert ($Perm.isReadVar $k@40@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@40@03 $Perm.No) (< $Perm.No $k@40@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               405
;  :arith-add-rows          23
;  :arith-assert-diseq      16
;  :arith-assert-lower      50
;  :arith-assert-upper      30
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               33
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   32
;  :datatype-splits         10
;  :decisions               38
;  :del-clause              160
;  :final-checks            17
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             567
;  :mk-clause               167
;  :num-allocs              3650117
;  :num-checks              44
;  :propagations            66
;  :quant-instantiations    52
;  :rlimit-count            125935)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               405
;  :arith-add-rows          23
;  :arith-assert-diseq      16
;  :arith-assert-lower      50
;  :arith-assert-upper      30
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               33
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   32
;  :datatype-splits         10
;  :decisions               38
;  :del-clause              160
;  :final-checks            17
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             567
;  :mk-clause               167
;  :num-allocs              3650117
;  :num-checks              45
;  :propagations            66
;  :quant-instantiations    52
;  :rlimit-count            125948)
(assert (< $k@40@03 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@40@03)))
(assert (<= (- $Perm.Write $k@40@03) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@40@03)) (not (= diz__30@24@03 $Ref.null))))
; [eval] diz.Main_controller != null
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               405
;  :arith-add-rows          23
;  :arith-assert-diseq      16
;  :arith-assert-lower      50
;  :arith-assert-upper      31
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               33
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   32
;  :datatype-splits         10
;  :decisions               38
;  :del-clause              160
;  :final-checks            17
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             568
;  :mk-clause               167
;  :num-allocs              3650117
;  :num-checks              46
;  :propagations            66
;  :quant-instantiations    52
;  :rlimit-count            126045)
(set-option :timeout 10)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               421
;  :arith-add-rows          23
;  :arith-assert-diseq      16
;  :arith-assert-lower      50
;  :arith-assert-upper      31
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               33
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              160
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             569
;  :mk-clause               167
;  :num-allocs              3650117
;  :num-checks              47
;  :propagations            66
;  :quant-instantiations    52
;  :rlimit-count            126451)
; [eval] diz.Main_process_state[0] == -1 || diz.Main_process_state[0] == 0
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 3
(assert (not (< 0 (Seq_length __flatten_26__32@31@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               421
;  :arith-add-rows          23
;  :arith-assert-diseq      16
;  :arith-assert-lower      50
;  :arith-assert-upper      31
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               33
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              160
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             569
;  :mk-clause               167
;  :num-allocs              3650117
;  :num-checks              48
;  :propagations            66
;  :quant-instantiations    52
;  :rlimit-count            126466)
; [eval] -1
(push) ; 3
; [then-branch: 4 | __flatten_26__32@31@03[0] == -1 | live]
; [else-branch: 4 | __flatten_26__32@31@03[0] != -1 | live]
(push) ; 4
; [then-branch: 4 | __flatten_26__32@31@03[0] == -1]
(assert (= (Seq_index __flatten_26__32@31@03 0) (- 0 1)))
(pop) ; 4
(push) ; 4
; [else-branch: 4 | __flatten_26__32@31@03[0] != -1]
(assert (not (= (Seq_index __flatten_26__32@31@03 0) (- 0 1))))
; [eval] diz.Main_process_state[0] == 0
; [eval] diz.Main_process_state[0]
(push) ; 5
(assert (not (< 0 (Seq_length __flatten_26__32@31@03))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               424
;  :arith-add-rows          24
;  :arith-assert-diseq      17
;  :arith-assert-lower      51
;  :arith-assert-upper      32
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               34
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              160
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             581
;  :mk-clause               176
;  :num-allocs              3650117
;  :num-checks              49
;  :propagations            71
;  :quant-instantiations    55
;  :rlimit-count            126709)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(assert (not (or
  (= (Seq_index __flatten_26__32@31@03 0) (- 0 1))
  (= (Seq_index __flatten_26__32@31@03 0) 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               427
;  :arith-add-rows          25
;  :arith-assert-diseq      19
;  :arith-assert-lower      52
;  :arith-assert-upper      33
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               35
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              179
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             595
;  :mk-clause               186
;  :num-allocs              3650117
;  :num-checks              50
;  :propagations            76
;  :quant-instantiations    58
;  :rlimit-count            126932)
(assert (or
  (= (Seq_index __flatten_26__32@31@03 0) (- 0 1))
  (= (Seq_index __flatten_26__32@31@03 0) 0)))
; [eval] diz.Main_process_state[1] == -1 || diz.Main_process_state[1] == 2
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(push) ; 3
(assert (not (< 1 (Seq_length __flatten_26__32@31@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               427
;  :arith-add-rows          25
;  :arith-assert-diseq      19
;  :arith-assert-lower      52
;  :arith-assert-upper      33
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               35
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              179
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             597
;  :mk-clause               187
;  :num-allocs              3650117
;  :num-checks              51
;  :propagations            76
;  :quant-instantiations    58
;  :rlimit-count            127018)
; [eval] -1
(push) ; 3
; [then-branch: 5 | __flatten_26__32@31@03[1] == -1 | live]
; [else-branch: 5 | __flatten_26__32@31@03[1] != -1 | live]
(push) ; 4
; [then-branch: 5 | __flatten_26__32@31@03[1] == -1]
(assert (= (Seq_index __flatten_26__32@31@03 1) (- 0 1)))
(pop) ; 4
(push) ; 4
; [else-branch: 5 | __flatten_26__32@31@03[1] != -1]
(assert (not (= (Seq_index __flatten_26__32@31@03 1) (- 0 1))))
; [eval] diz.Main_process_state[1] == 2
; [eval] diz.Main_process_state[1]
(push) ; 5
(assert (not (< 1 (Seq_length __flatten_26__32@31@03))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               438
;  :arith-add-rows          28
;  :arith-assert-diseq      20
;  :arith-assert-lower      55
;  :arith-assert-upper      34
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        55
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               36
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              179
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             616
;  :mk-clause               200
;  :num-allocs              3650117
;  :num-checks              52
;  :propagations            84
;  :quant-instantiations    64
;  :rlimit-count            127339)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(assert (not (or
  (= (Seq_index __flatten_26__32@31@03 1) (- 0 1))
  (= (Seq_index __flatten_26__32@31@03 1) 2))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               449
;  :arith-add-rows          31
;  :arith-assert-diseq      22
;  :arith-assert-lower      58
;  :arith-assert-upper      37
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               37
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              206
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             638
;  :mk-clause               214
;  :num-allocs              3650117
;  :num-checks              53
;  :propagations            92
;  :quant-instantiations    70
;  :rlimit-count            127689)
(assert (or
  (= (Seq_index __flatten_26__32@31@03 1) (- 0 1))
  (= (Seq_index __flatten_26__32@31@03 1) 2)))
; [eval] diz.Main_event_state[0] != -1
; [eval] diz.Main_event_state[0]
(push) ; 3
(assert (not (< 0 (Seq_length __flatten_28__34@32@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               449
;  :arith-add-rows          31
;  :arith-assert-diseq      22
;  :arith-assert-lower      58
;  :arith-assert-upper      37
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        5
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               37
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              206
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             640
;  :mk-clause               215
;  :num-allocs              3650117
;  :num-checks              54
;  :propagations            92
;  :quant-instantiations    70
;  :rlimit-count            127775)
; [eval] -1
(push) ; 3
(assert (not (not (= (Seq_index __flatten_28__34@32@03 0) (- 0 1)))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               456
;  :arith-add-rows          32
;  :arith-assert-diseq      22
;  :arith-assert-lower      58
;  :arith-assert-upper      37
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        6
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               38
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              210
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             648
;  :mk-clause               219
;  :num-allocs              3650117
;  :num-checks              55
;  :propagations            94
;  :quant-instantiations    73
;  :rlimit-count            127981)
(assert (not (= (Seq_index __flatten_28__34@32@03 0) (- 0 1))))
; [eval] diz.Main_event_state[0] != 0
; [eval] diz.Main_event_state[0]
(push) ; 3
(assert (not (< 0 (Seq_length __flatten_28__34@32@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               463
;  :arith-add-rows          33
;  :arith-assert-diseq      22
;  :arith-assert-lower      58
;  :arith-assert-upper      37
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        7
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               38
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              210
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             656
;  :mk-clause               223
;  :num-allocs              3650117
;  :num-checks              56
;  :propagations            96
;  :quant-instantiations    76
;  :rlimit-count            128114)
(push) ; 3
(assert (not (not (= (Seq_index __flatten_28__34@32@03 0) 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               464
;  :arith-add-rows          33
;  :arith-assert-diseq      22
;  :arith-assert-lower      58
;  :arith-assert-upper      37
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        7
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               39
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              210
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             657
;  :mk-clause               223
;  :num-allocs              3650117
;  :num-checks              57
;  :propagations            96
;  :quant-instantiations    76
;  :rlimit-count            128172)
(assert (not (= (Seq_index __flatten_28__34@32@03 0) 0)))
; [eval] diz.Main_event_state[2] <= -1
; [eval] diz.Main_event_state[2]
(push) ; 3
(assert (not (< 2 (Seq_length __flatten_28__34@32@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               464
;  :arith-add-rows          33
;  :arith-assert-diseq      22
;  :arith-assert-lower      58
;  :arith-assert-upper      37
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        7
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               39
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               43
;  :del-clause              210
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             658
;  :mk-clause               223
;  :num-allocs              3650117
;  :num-checks              58
;  :propagations            96
;  :quant-instantiations    76
;  :rlimit-count            128252)
; [eval] -1
(push) ; 3
(assert (not (<= (Seq_index __flatten_28__34@32@03 2) (- 0 1))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               498
;  :arith-add-rows          37
;  :arith-assert-diseq      22
;  :arith-assert-lower      60
;  :arith-assert-upper      37
;  :arith-bound-prop        5
;  :arith-conflicts         2
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        10
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               47
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             693
;  :mk-clause               233
;  :num-allocs              3650117
;  :num-checks              59
;  :propagations            102
;  :quant-instantiations    80
;  :rlimit-count            128673)
(assert (<= (Seq_index __flatten_28__34@32@03 2) (- 0 1)))
; [eval] !diz.Main_controller.Controller_init || (diz.Main_process_state[1] == -1 ==> diz.Main_process_state[0] != -1)
; [eval] !diz.Main_controller.Controller_init
(push) ; 3
; [then-branch: 6 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@36@03))))))))) | live]
; [else-branch: 6 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@36@03)))))))) | live]
(push) ; 4
; [then-branch: 6 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@36@03)))))))))]
(pop) ; 4
(push) ; 4
; [else-branch: 6 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@36@03))))))))]
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))))))
; [eval] diz.Main_process_state[1] == -1 ==> diz.Main_process_state[0] != -1
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(push) ; 5
(assert (not (< 1 (Seq_length __flatten_26__32@31@03))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               501
;  :arith-add-rows          38
;  :arith-assert-diseq      22
;  :arith-assert-lower      60
;  :arith-assert-upper      38
;  :arith-bound-prop        5
;  :arith-conflicts         2
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         31
;  :arith-offset-eqs        10
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               48
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             698
;  :mk-clause               237
;  :num-allocs              3650117
;  :num-checks              60
;  :propagations            102
;  :quant-instantiations    81
;  :rlimit-count            128767)
; [eval] -1
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= (Seq_index __flatten_26__32@31@03 1) (- 0 1)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               501
;  :arith-add-rows          38
;  :arith-assert-diseq      22
;  :arith-assert-lower      60
;  :arith-assert-upper      38
;  :arith-bound-prop        5
;  :arith-conflicts         2
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         31
;  :arith-offset-eqs        10
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               48
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             698
;  :mk-clause               237
;  :num-allocs              3650117
;  :num-checks              61
;  :propagations            102
;  :quant-instantiations    81
;  :rlimit-count            128771)
; [then-branch: 7 | __flatten_26__32@31@03[1] == -1 | dead]
; [else-branch: 7 | __flatten_26__32@31@03[1] != -1 | live]
(push) ; 6
; [else-branch: 7 | __flatten_26__32@31@03[1] != -1]
(assert (not (= (Seq_index __flatten_26__32@31@03 1) (- 0 1))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
; [eval] -1 <= diz.Main_event_state[2] ==> diz.Main_process_state[0] != -1
; [eval] -1 <= diz.Main_event_state[2]
; [eval] -1
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 3
(assert (not (< 2 (Seq_length __flatten_28__34@32@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               501
;  :arith-add-rows          38
;  :arith-assert-diseq      22
;  :arith-assert-lower      60
;  :arith-assert-upper      38
;  :arith-bound-prop        5
;  :arith-conflicts         2
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         31
;  :arith-offset-eqs        10
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               48
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             698
;  :mk-clause               237
;  :num-allocs              3650117
;  :num-checks              62
;  :propagations            102
;  :quant-instantiations    81
;  :rlimit-count            128788)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (<= (- 0 1) (Seq_index __flatten_28__34@32@03 2)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               504
;  :arith-add-rows          38
;  :arith-assert-diseq      23
;  :arith-assert-lower      62
;  :arith-assert-upper      38
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        10
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               49
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             702
;  :mk-clause               237
;  :num-allocs              3650117
;  :num-checks              63
;  :propagations            104
;  :quant-instantiations    81
;  :rlimit-count            128874)
; [then-branch: 8 | -1 <= __flatten_28__34@32@03[2] | dead]
; [else-branch: 8 | !(-1 <= __flatten_28__34@32@03[2]) | live]
(push) ; 4
; [else-branch: 8 | !(-1 <= __flatten_28__34@32@03[2])]
(assert (not (<= (- 0 1) (Seq_index __flatten_28__34@32@03 2))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; [eval] -1 <= diz.Main_event_state[2] ==> diz.Main_sensor.Sensor_dist < diz.Main_MIN_DIST
; [eval] -1 <= diz.Main_event_state[2]
; [eval] -1
; [eval] diz.Main_event_state[2]
(set-option :timeout 0)
(push) ; 3
(assert (not (< 2 (Seq_length __flatten_28__34@32@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               504
;  :arith-add-rows          38
;  :arith-assert-diseq      23
;  :arith-assert-lower      62
;  :arith-assert-upper      38
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        10
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               49
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             702
;  :mk-clause               237
;  :num-allocs              3650117
;  :num-checks              64
;  :propagations            104
;  :quant-instantiations    81
;  :rlimit-count            128907)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (<= (- 0 1) (Seq_index __flatten_28__34@32@03 2)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               507
;  :arith-add-rows          38
;  :arith-assert-diseq      24
;  :arith-assert-lower      64
;  :arith-assert-upper      38
;  :arith-bound-prop        5
;  :arith-conflicts         4
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        10
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               50
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             706
;  :mk-clause               237
;  :num-allocs              3650117
;  :num-checks              65
;  :propagations            106
;  :quant-instantiations    81
;  :rlimit-count            128992)
; [then-branch: 9 | -1 <= __flatten_28__34@32@03[2] | dead]
; [else-branch: 9 | !(-1 <= __flatten_28__34@32@03[2]) | live]
(push) ; 4
; [else-branch: 9 | !(-1 <= __flatten_28__34@32@03[2])]
(assert (not (<= (- 0 1) (Seq_index __flatten_28__34@32@03 2))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; [eval] diz.Main_controller.Controller_init && diz.Main_process_state[1] == -1 ==> diz.Main_sensor.Sensor_dist < diz.Main_MIN_DIST
; [eval] diz.Main_controller.Controller_init && diz.Main_process_state[1] == -1
(push) ; 3
; [then-branch: 10 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@36@03)))))))) | live]
; [else-branch: 10 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@36@03))))))))) | live]
(push) ; 4
; [then-branch: 10 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@36@03))))))))]
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))))))
; [eval] diz.Main_process_state[1] == -1
; [eval] diz.Main_process_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (< 1 (Seq_length __flatten_26__32@31@03))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               507
;  :arith-add-rows          38
;  :arith-assert-diseq      24
;  :arith-assert-lower      64
;  :arith-assert-upper      38
;  :arith-bound-prop        5
;  :arith-conflicts         4
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        10
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             706
;  :mk-clause               237
;  :num-allocs              3650117
;  :num-checks              66
;  :propagations            106
;  :quant-instantiations    81
;  :rlimit-count            129025)
; [eval] -1
(pop) ; 4
(push) ; 4
; [else-branch: 10 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@36@03)))))))))]
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (and
    (= (Seq_index __flatten_26__32@31@03 1) (- 0 1))
    ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03)))))))))))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               507
;  :arith-add-rows          38
;  :arith-assert-diseq      24
;  :arith-assert-lower      64
;  :arith-assert-upper      38
;  :arith-bound-prop        5
;  :arith-conflicts         4
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        10
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               51
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             706
;  :mk-clause               237
;  :num-allocs              3650117
;  :num-checks              67
;  :propagations            106
;  :quant-instantiations    81
;  :rlimit-count            129058)
; [then-branch: 11 | __flatten_26__32@31@03[1] == -1 && First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@36@03)))))))) | dead]
; [else-branch: 11 | !(__flatten_26__32@31@03[1] == -1 && First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@36@03))))))))) | live]
(push) ; 4
; [else-branch: 11 | !(__flatten_26__32@31@03[1] == -1 && First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@36@03)))))))))]
(assert (not
  (and
    (= (Seq_index __flatten_26__32@31@03 1) (- 0 1))
    ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))))))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($SortWrappers.Seq<Int>To$Snap __flatten_26__32@31@03)
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($SortWrappers.Seq<Int>To$Snap __flatten_28__34@32@03)
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  $Snap.unit
                  ($Snap.combine
                    ($SortWrappers.IntTo$Snap md0@11@03)
                    ($Snap.combine
                      $Snap.unit
                      ($Snap.combine
                        ($SortWrappers.$RefTo$Snap sys__result@33@03)
                        ($Snap.combine
                          $Snap.unit
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
                              ($Snap.combine
                                ($SortWrappers.$RefTo$Snap sys__result@35@03)
                                ($Snap.combine
                                  $Snap.unit
                                  ($Snap.combine
                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))
                                    ($Snap.combine
                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@36@03))))))))
                                      ($Snap.combine
                                        $Snap.unit
                                        ($Snap.combine
                                          $Snap.unit
                                          ($Snap.combine
                                            $Snap.unit
                                            ($Snap.combine
                                              $Snap.unit
                                              ($Snap.combine
                                                $Snap.unit
                                                ($Snap.combine
                                                  $Snap.unit
                                                  ($Snap.combine
                                                    $Snap.unit
                                                    ($Snap.combine
                                                      $Snap.unit
                                                      $Snap.unit))))))))))))))))))))))))))) diz__30@24@03 globals@10@03))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz__30, globals), write)
; [exec]
; sys__result := diz__30
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Main() && acc(sys__result.Main_sensor, wildcard) && sys__result.Main_sensor != null && acc(sys__result.Main_sensor.Sensor_m, 1 / 2) && sys__result.Main_sensor.Sensor_m == sys__result && acc(sys__result.Main_sensor.Sensor_init, 1 / 2) && !sys__result.Main_sensor.Sensor_init && acc(sys__result.Main_controller, wildcard) && sys__result.Main_controller != null && acc(sys__result.Main_controller.Controller_m, 1 / 2) && sys__result.Main_controller.Controller_m == sys__result && acc(sys__result.Main_controller.Controller_init, 1 / 2) && !sys__result.Main_controller.Controller_init && acc(Sensor_idleToken_EncodedGlobalVariables(sys__result.Main_sensor, globals), write) && acc(Controller_idleToken_EncodedGlobalVariables(sys__result.Main_controller, globals), write)
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
(declare-const $k@41@03 $Perm)
(assert ($Perm.isReadVar $k@41@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@41@03 $Perm.No) (< $Perm.No $k@41@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               568
;  :arith-add-rows          38
;  :arith-assert-diseq      25
;  :arith-assert-lower      66
;  :arith-assert-upper      39
;  :arith-bound-prop        5
;  :arith-conflicts         4
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        10
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               52
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             716
;  :mk-clause               239
;  :num-allocs              3781520
;  :num-checks              68
;  :propagations            107
;  :quant-instantiations    86
;  :rlimit-count            130174)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- $Perm.Write $k@39@03) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               568
;  :arith-add-rows          38
;  :arith-assert-diseq      25
;  :arith-assert-lower      66
;  :arith-assert-upper      39
;  :arith-bound-prop        5
;  :arith-conflicts         4
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        10
;  :arith-pivots            11
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             717
;  :mk-clause               239
;  :num-allocs              3781520
;  :num-checks              69
;  :propagations            107
;  :quant-instantiations    86
;  :rlimit-count            130226)
(assert (< $k@41@03 (- $Perm.Write $k@39@03)))
(assert (<= $Perm.No (- (- $Perm.Write $k@39@03) $k@41@03)))
(assert (<= (- (- $Perm.Write $k@39@03) $k@41@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- $Perm.Write $k@39@03) $k@41@03))
  (not (= diz__30@24@03 $Ref.null))))
; [eval] sys__result.Main_sensor != null
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@39@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               568
;  :arith-add-rows          38
;  :arith-assert-diseq      25
;  :arith-assert-lower      67
;  :arith-assert-upper      41
;  :arith-bound-prop        5
;  :arith-conflicts         4
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        10
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             720
;  :mk-clause               239
;  :num-allocs              3781520
;  :num-checks              70
;  :propagations            107
;  :quant-instantiations    86
;  :rlimit-count            130412)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               568
;  :arith-add-rows          38
;  :arith-assert-diseq      25
;  :arith-assert-lower      67
;  :arith-assert-upper      41
;  :arith-bound-prop        5
;  :arith-conflicts         4
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        10
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             720
;  :mk-clause               239
;  :num-allocs              3781520
;  :num-checks              71
;  :propagations            107
;  :quant-instantiations    86
;  :rlimit-count            130425)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@39@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               568
;  :arith-add-rows          38
;  :arith-assert-diseq      25
;  :arith-assert-lower      67
;  :arith-assert-upper      41
;  :arith-bound-prop        5
;  :arith-conflicts         4
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        10
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               53
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   38
;  :datatype-splits         11
;  :decisions               50
;  :del-clause              220
;  :final-checks            19
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             720
;  :mk-clause               239
;  :num-allocs              3781520
;  :num-checks              72
;  :propagations            107
;  :quant-instantiations    86
;  :rlimit-count            130451)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          47
;  :arith-assert-diseq      25
;  :arith-assert-lower      70
;  :arith-assert-upper      45
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        19
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               58
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   171
;  :datatype-splits         36
;  :decisions               85
;  :del-clause              244
;  :final-checks            24
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             794
;  :mk-clause               263
;  :num-allocs              3914721
;  :num-checks              73
;  :propagations            121
;  :quant-instantiations    95
;  :rlimit-count            131764
;  :time                    0.00)
; [eval] sys__result.Main_sensor.Sensor_m == sys__result
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@39@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          47
;  :arith-assert-diseq      25
;  :arith-assert-lower      70
;  :arith-assert-upper      45
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        19
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               58
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   171
;  :datatype-splits         36
;  :decisions               85
;  :del-clause              244
;  :final-checks            24
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             794
;  :mk-clause               263
;  :num-allocs              3914721
;  :num-checks              74
;  :propagations            121
;  :quant-instantiations    95
;  :rlimit-count            131790)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          47
;  :arith-assert-diseq      25
;  :arith-assert-lower      70
;  :arith-assert-upper      45
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        19
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               58
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   171
;  :datatype-splits         36
;  :decisions               85
;  :del-clause              244
;  :final-checks            24
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             794
;  :mk-clause               263
;  :num-allocs              3914721
;  :num-checks              75
;  :propagations            121
;  :quant-instantiations    95
;  :rlimit-count            131803)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@39@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          47
;  :arith-assert-diseq      25
;  :arith-assert-lower      70
;  :arith-assert-upper      45
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        19
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               58
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   171
;  :datatype-splits         36
;  :decisions               85
;  :del-clause              244
;  :final-checks            24
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             794
;  :mk-clause               263
;  :num-allocs              3914721
;  :num-checks              76
;  :propagations            121
;  :quant-instantiations    95
;  :rlimit-count            131829)
; [eval] !sys__result.Main_sensor.Sensor_init
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@39@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          47
;  :arith-assert-diseq      25
;  :arith-assert-lower      70
;  :arith-assert-upper      45
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        19
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               58
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   171
;  :datatype-splits         36
;  :decisions               85
;  :del-clause              244
;  :final-checks            24
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             794
;  :mk-clause               263
;  :num-allocs              3914721
;  :num-checks              77
;  :propagations            121
;  :quant-instantiations    95
;  :rlimit-count            131855)
(declare-const $k@42@03 $Perm)
(assert ($Perm.isReadVar $k@42@03 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@42@03 $Perm.No) (< $Perm.No $k@42@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          47
;  :arith-assert-diseq      26
;  :arith-assert-lower      72
;  :arith-assert-upper      46
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        19
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               59
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   171
;  :datatype-splits         36
;  :decisions               85
;  :del-clause              244
;  :final-checks            24
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             798
;  :mk-clause               265
;  :num-allocs              3914721
;  :num-checks              78
;  :propagations            122
;  :quant-instantiations    95
;  :rlimit-count            132053)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- $Perm.Write $k@40@03) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          47
;  :arith-assert-diseq      26
;  :arith-assert-lower      72
;  :arith-assert-upper      46
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        19
;  :arith-pivots            12
;  :binary-propagations     11
;  :conflicts               60
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   171
;  :datatype-splits         36
;  :decisions               85
;  :del-clause              244
;  :final-checks            24
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             799
;  :mk-clause               265
;  :num-allocs              3914721
;  :num-checks              79
;  :propagations            122
;  :quant-instantiations    95
;  :rlimit-count            132105)
(assert (< $k@42@03 (- $Perm.Write $k@40@03)))
(assert (<= $Perm.No (- (- $Perm.Write $k@40@03) $k@42@03)))
(assert (<= (- (- $Perm.Write $k@40@03) $k@42@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- $Perm.Write $k@40@03) $k@42@03))
  (not (= diz__30@24@03 $Ref.null))))
; [eval] sys__result.Main_controller != null
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@40@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          47
;  :arith-assert-diseq      26
;  :arith-assert-lower      73
;  :arith-assert-upper      48
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        19
;  :arith-pivots            14
;  :binary-propagations     11
;  :conflicts               60
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   171
;  :datatype-splits         36
;  :decisions               85
;  :del-clause              244
;  :final-checks            24
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             802
;  :mk-clause               265
;  :num-allocs              3914721
;  :num-checks              80
;  :propagations            122
;  :quant-instantiations    95
;  :rlimit-count            132297)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          47
;  :arith-assert-diseq      26
;  :arith-assert-lower      73
;  :arith-assert-upper      48
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        19
;  :arith-pivots            14
;  :binary-propagations     11
;  :conflicts               60
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   171
;  :datatype-splits         36
;  :decisions               85
;  :del-clause              244
;  :final-checks            24
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             802
;  :mk-clause               265
;  :num-allocs              3914721
;  :num-checks              81
;  :propagations            122
;  :quant-instantiations    95
;  :rlimit-count            132310)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@40@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          47
;  :arith-assert-diseq      26
;  :arith-assert-lower      73
;  :arith-assert-upper      48
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        19
;  :arith-pivots            14
;  :binary-propagations     11
;  :conflicts               60
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   171
;  :datatype-splits         36
;  :decisions               85
;  :del-clause              244
;  :final-checks            24
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             802
;  :mk-clause               265
;  :num-allocs              3914721
;  :num-checks              82
;  :propagations            122
;  :quant-instantiations    95
;  :rlimit-count            132336)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               956
;  :arith-add-rows          56
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      52
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         51
;  :arith-offset-eqs        28
;  :arith-pivots            14
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   304
;  :datatype-splits         61
;  :decisions               120
;  :del-clause              268
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             876
;  :mk-clause               289
;  :num-allocs              3914721
;  :num-checks              83
;  :propagations            136
;  :quant-instantiations    104
;  :rlimit-count            133650
;  :time                    0.00)
; [eval] sys__result.Main_controller.Controller_m == sys__result
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@40@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               956
;  :arith-add-rows          56
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      52
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         51
;  :arith-offset-eqs        28
;  :arith-pivots            14
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   304
;  :datatype-splits         61
;  :decisions               120
;  :del-clause              268
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             876
;  :mk-clause               289
;  :num-allocs              3914721
;  :num-checks              84
;  :propagations            136
;  :quant-instantiations    104
;  :rlimit-count            133676)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               956
;  :arith-add-rows          56
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      52
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         51
;  :arith-offset-eqs        28
;  :arith-pivots            14
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   304
;  :datatype-splits         61
;  :decisions               120
;  :del-clause              268
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             876
;  :mk-clause               289
;  :num-allocs              3914721
;  :num-checks              85
;  :propagations            136
;  :quant-instantiations    104
;  :rlimit-count            133689)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@40@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               956
;  :arith-add-rows          56
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      52
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         51
;  :arith-offset-eqs        28
;  :arith-pivots            14
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   304
;  :datatype-splits         61
;  :decisions               120
;  :del-clause              268
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             876
;  :mk-clause               289
;  :num-allocs              3914721
;  :num-checks              86
;  :propagations            136
;  :quant-instantiations    104
;  :rlimit-count            133715)
; [eval] !sys__result.Main_controller.Controller_init
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@40@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               956
;  :arith-add-rows          56
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      52
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         51
;  :arith-offset-eqs        28
;  :arith-pivots            14
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   304
;  :datatype-splits         61
;  :decisions               120
;  :del-clause              268
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             876
;  :mk-clause               289
;  :num-allocs              3914721
;  :num-checks              87
;  :propagations            136
;  :quant-instantiations    104
;  :rlimit-count            133741)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@39@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               956
;  :arith-add-rows          56
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      52
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         51
;  :arith-offset-eqs        28
;  :arith-pivots            14
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   304
;  :datatype-splits         61
;  :decisions               120
;  :del-clause              268
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             876
;  :mk-clause               289
;  :num-allocs              3914721
;  :num-checks              88
;  :propagations            136
;  :quant-instantiations    104
;  :rlimit-count            133767)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@40@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               956
;  :arith-add-rows          56
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      52
;  :arith-bound-prop        5
;  :arith-conflicts         6
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         51
;  :arith-offset-eqs        28
;  :arith-pivots            14
;  :binary-propagations     11
;  :conflicts               65
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   304
;  :datatype-splits         61
;  :decisions               120
;  :del-clause              268
;  :final-checks            29
;  :interface-eqs           2
;  :max-generation          4
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             876
;  :mk-clause               289
;  :num-allocs              3914721
;  :num-checks              89
;  :propagations            136
;  :quant-instantiations    104
;  :rlimit-count            133793)
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
