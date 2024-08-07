(get-info :version)
; (:version "4.8.6")
; Started: 2024-07-24 15:46:25
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
(declare-const class_Half_adder<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Object<TYPE> TYPE)
(declare-const class_Main<TYPE> TYPE)
(declare-const class_EncodedGlobalVariables<TYPE> TYPE)
(declare-fun directSuperclass<TYPE> (TYPE) TYPE)
(declare-fun type_of<TYPE> ($Ref) TYPE)
(declare-fun zfrac_val<Perm> (zfrac) $Perm)
; /field_value_functions_declarations.smt2 [Main_process_state: Seq[Int]]
(declare-fun $FVF.domain_Main_process_state ($FVF<Seq<Int>>) Set<$Ref>)
(declare-fun $FVF.lookup_Main_process_state ($FVF<Seq<Int>> $Ref) Seq<Int>)
(declare-fun $FVF.after_Main_process_state ($FVF<Seq<Int>> $FVF<Seq<Int>>) Bool)
(declare-fun $FVF.loc_Main_process_state (Seq<Int> $Ref) Bool)
(declare-fun $FVF.perm_Main_process_state ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Main_process_state $FVF<Seq<Int>>)
; /field_value_functions_declarations.smt2 [Half_adder_m: Ref]
(declare-fun $FVF.domain_Half_adder_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Half_adder_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Half_adder_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Half_adder_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Half_adder_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Half_adder_m $FVF<$Ref>)
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
(declare-fun Half_adder_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Half_adder_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_held_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
; ////////// Uniqueness assumptions from domains
(assert (distinct class_Half_adder<TYPE> class_java_DOT_lang_DOT_Object<TYPE> class_Main<TYPE> class_EncodedGlobalVariables<TYPE>))
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
(assert (=
  (directSuperclass<TYPE> (as class_Half_adder<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Main<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_EncodedGlobalVariables<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (forall ((a zfrac) (b zfrac)) (!
  (= (= (zfrac_val<Perm> a) (zfrac_val<Perm> b)) (= a b))
  :pattern ((zfrac_val<Perm> a) (zfrac_val<Perm> b))
  :qid |prog.zfrac_eq|)))
(assert (forall ((a zfrac)) (!
  (and (<= $Perm.No (zfrac_val<Perm> a)) (<= (zfrac_val<Perm> a) $Perm.Write))
  :pattern ((zfrac_val<Perm> a))
  :qid |prog.zfrac_bound|)))
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
; /field_value_functions_axioms.smt2 [Half_adder_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Half_adder_m vs) ($FVF.domain_Half_adder_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Half_adder_m vs))
            (= ($FVF.lookup_Half_adder_m vs x) ($FVF.lookup_Half_adder_m ws x)))
          :pattern (($FVF.lookup_Half_adder_m vs x) ($FVF.lookup_Half_adder_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Half_adder_m pm r))
    :pattern ($FVF.perm_Half_adder_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Half_adder_m f r) true)
    :pattern ($FVF.loc_Half_adder_m f r))))
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
    (and (not (= diz@7@00 $Ref.null)) (= (Seq_length vals@8@00) 2))
    (and
      (and
        (or
          (< (Seq_index vals@8@00 0) (- 0 1))
          (<= result@9@00 (Seq_index vals@8@00 0)))
        (or
          (< (Seq_index vals@8@00 1) (- 0 1))
          (<= result@9@00 (Seq_index vals@8@00 1))))
      (and
        (implies
          (and
            (< (Seq_index vals@8@00 0) (- 0 1))
            (< (Seq_index vals@8@00 1) (- 0 1)))
          (= result@9@00 0))
        (implies
          (or
            (<= (- 0 1) (Seq_index vals@8@00 0))
            (<= (- 0 1) (Seq_index vals@8@00 1)))
          (or
            (and
              (<= (- 0 1) (Seq_index vals@8@00 0))
              (= result@9@00 (Seq_index vals@8@00 0)))
            (and
              (<= (- 0 1) (Seq_index vals@8@00 1))
              (= result@9@00 (Seq_index vals@8@00 1)))))))))
  :pattern ((Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@7@00 vals@8@00))
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
(assert (=
  ($Snap.second $t@4@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@4@01))
    ($Snap.second ($Snap.second $t@4@01)))))
(assert (= ($Snap.first ($Snap.second $t@4@01)) $Snap.unit))
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
(assert (= (type_of<TYPE> sys__result@3@01) (as class_Main<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@4@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@4@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@4@01))))))
(declare-const $k@5@01 $Perm)
(assert ($Perm.isReadVar $k@5@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@5@01 $Perm.No) (< $Perm.No $k@5@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            22
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   2
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            1
;  :datatype-accessor-ax 4
;  :final-checks         1
;  :max-generation       1
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          221
;  :mk-clause            3
;  :num-allocs           3092979
;  :num-checks           2
;  :propagations         8
;  :quant-instantiations 1
;  :rlimit-count         95462)
(assert (<= $Perm.No $k@5@01))
(assert (<= $k@5@01 $Perm.Write))
(assert (implies (< $Perm.No $k@5@01) (not (= sys__result@3@01 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@4@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@01)))) $Snap.unit))
; [eval] sys__result.Main_half != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@5@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            28
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            2
;  :datatype-accessor-ax 5
;  :final-checks         1
;  :max-generation       1
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          224
;  :mk-clause            3
;  :num-allocs           3092979
;  :num-checks           3
;  :propagations         8
;  :quant-instantiations 1
;  :rlimit-count         95725)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@4@01))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01))))))))
(push) ; 3
(assert (not (< $Perm.No $k@5@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            34
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            3
;  :datatype-accessor-ax 6
;  :final-checks         1
;  :max-generation       1
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          227
;  :mk-clause            3
;  :num-allocs           3092979
;  :num-checks           4
;  :propagations         8
;  :quant-instantiations 2
;  :rlimit-count         96021)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            34
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            3
;  :datatype-accessor-ax 6
;  :final-checks         1
;  :max-generation       1
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          227
;  :mk-clause            3
;  :num-allocs           3092979
;  :num-checks           5
;  :propagations         8
;  :quant-instantiations 2
;  :rlimit-count         96034)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01))))))
  $Snap.unit))
; [eval] sys__result.Main_half.Half_adder_m == sys__result
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@5@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            40
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            4
;  :datatype-accessor-ax 7
;  :final-checks         1
;  :max-generation       1
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          229
;  :mk-clause            3
;  :num-allocs           3092979
;  :num-checks           6
;  :propagations         8
;  :quant-instantiations 2
;  :rlimit-count         96263)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01))))))
  sys__result@3@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@5@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            47
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            5
;  :datatype-accessor-ax 8
;  :final-checks         1
;  :max-generation       1
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          232
;  :mk-clause            3
;  :num-allocs           3092979
;  :num-checks           7
;  :propagations         8
;  :quant-instantiations 3
;  :rlimit-count         96559)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            47
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            5
;  :datatype-accessor-ax 8
;  :final-checks         1
;  :max-generation       1
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          232
;  :mk-clause            3
;  :num-allocs           3092979
;  :num-checks           8
;  :propagations         8
;  :quant-instantiations 3
;  :rlimit-count         96572)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01))))))))
  $Snap.unit))
; [eval] !sys__result.Main_half.Half_adder_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@5@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            53
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            6
;  :datatype-accessor-ax 9
;  :final-checks         1
;  :max-generation       1
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          234
;  :mk-clause            3
;  :num-allocs           3092979
;  :num-checks           9
;  :propagations         8
;  :quant-instantiations 3
;  :rlimit-count         96821)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@01))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@5@01)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            57
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            7
;  :datatype-accessor-ax 9
;  :final-checks         1
;  :max-generation       2
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          237
;  :mk-clause            3
;  :num-allocs           3092979
;  :num-checks           10
;  :propagations         8
;  :quant-instantiations 5
;  :rlimit-count         97049)
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_19__26: Ref
(declare-const __flatten_19__26@6@01 $Ref)
; [exec]
; var __flatten_18__25: Seq[Int]
(declare-const __flatten_18__25@7@01 Seq<Int>)
; [exec]
; var __flatten_17__24: Seq[Int]
(declare-const __flatten_17__24@8@01 Seq<Int>)
; [exec]
; var __flatten_16__23: Seq[Int]
(declare-const __flatten_16__23@9@01 Seq<Int>)
; [exec]
; var __flatten_15__22: Seq[Int]
(declare-const __flatten_15__22@10@01 Seq<Int>)
; [exec]
; var diz__21: Ref
(declare-const diz__21@11@01 $Ref)
; [exec]
; diz__21 := new(Main_process_state, Main_event_state, Main_half)
(declare-const diz__21@12@01 $Ref)
(assert (not (= diz__21@12@01 $Ref.null)))
(declare-const Main_process_state@13@01 Seq<Int>)
(declare-const Main_event_state@14@01 Seq<Int>)
(declare-const Main_half@15@01 $Ref)
(assert (not (= diz__21@12@01 globals@2@01)))
(assert (not (= diz__21@12@01 __flatten_19__26@6@01)))
(assert (not (= diz__21@12@01 sys__result@3@01)))
(assert (not (= diz__21@12@01 diz__21@11@01)))
; [exec]
; inhale type_of(diz__21) == class_Main()
(declare-const $t@16@01 $Snap)
(assert (= $t@16@01 $Snap.unit))
; [eval] type_of(diz__21) == class_Main()
; [eval] type_of(diz__21)
; [eval] class_Main()
(assert (= (type_of<TYPE> diz__21@12@01) (as class_Main<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; __flatten_16__23 := Seq(-1)
; [eval] Seq(-1)
; [eval] -1
(assert (= (Seq_length (Seq_singleton (- 0 1))) 1))
(declare-const __flatten_16__23@17@01 Seq<Int>)
(assert (Seq_equal __flatten_16__23@17@01 (Seq_singleton (- 0 1))))
; [exec]
; __flatten_15__22 := __flatten_16__23
; [exec]
; diz__21.Main_process_state := __flatten_15__22
; [exec]
; __flatten_18__25 := Seq(-3, -3)
; [eval] Seq(-3, -3)
; [eval] -3
; [eval] -3
(assert (= (Seq_length (Seq_append (Seq_singleton (- 0 3)) (Seq_singleton (- 0 3)))) 2))
(declare-const __flatten_18__25@18@01 Seq<Int>)
(assert (Seq_equal
  __flatten_18__25@18@01
  (Seq_append (Seq_singleton (- 0 3)) (Seq_singleton (- 0 3)))))
; [exec]
; __flatten_17__24 := __flatten_18__25
; [exec]
; diz__21.Main_event_state := __flatten_17__24
; [exec]
; __flatten_19__26 := Half_adder_Half_adder_EncodedGlobalVariables_Main(globals, diz__21)
(declare-const sys__result@19@01 $Ref)
(declare-const $t@20@01 $Snap)
(assert (= $t@20@01 ($Snap.combine ($Snap.first $t@20@01) ($Snap.second $t@20@01))))
(assert (= ($Snap.first $t@20@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@19@01 $Ref.null)))
(assert (=
  ($Snap.second $t@20@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@20@01))
    ($Snap.second ($Snap.second $t@20@01)))))
(assert (= ($Snap.first ($Snap.second $t@20@01)) $Snap.unit))
; [eval] type_of(sys__result) == class_Half_adder()
; [eval] type_of(sys__result)
; [eval] class_Half_adder()
(assert (= (type_of<TYPE> sys__result@19@01) (as class_Half_adder<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@20@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@20@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@20@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))
  $Snap.unit))
; [eval] !sys__result.Half_adder_a
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))
  $Snap.unit))
; [eval] !sys__result.Half_adder_b
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))
  $Snap.unit))
; [eval] !sys__result.Half_adder_sum
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))))
  $Snap.unit))
; [eval] !sys__result.Half_adder_carry
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))))
  $Snap.unit))
; [eval] sys__result.Half_adder_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))
  diz__21@12@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))))))))))
  $Snap.unit))
; [eval] !sys__result.Half_adder_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; diz__21.Main_half := __flatten_19__26
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz__21, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(set-option :timeout 0)
(push) ; 3
(assert (not (= (Seq_length __flatten_16__23@17@01) 1)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               186
;  :arith-add-rows          2
;  :arith-assert-diseq      4
;  :arith-assert-lower      15
;  :arith-assert-upper      9
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               9
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               4
;  :del-clause              58
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             348
;  :mk-clause               59
;  :num-allocs              3200233
;  :num-checks              13
;  :propagations            30
;  :quant-instantiations    27
;  :rlimit-count            101061)
(assert (= (Seq_length __flatten_16__23@17@01) 1))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(push) ; 3
(assert (not (= (Seq_length __flatten_18__25@18@01) 2)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               187
;  :arith-add-rows          2
;  :arith-assert-diseq      4
;  :arith-assert-lower      16
;  :arith-assert-upper      10
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               10
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               4
;  :del-clause              58
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             354
;  :mk-clause               59
;  :num-allocs              3200233
;  :num-checks              14
;  :propagations            30
;  :quant-instantiations    27
;  :rlimit-count            101186)
(assert (= (Seq_length __flatten_18__25@18@01) 2))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@21@01 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@21@01 | live]
; [else-branch: 0 | !(0 <= i@21@01) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@21@01]
(assert (<= 0 i@21@01))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@21@01)]
(assert (not (<= 0 i@21@01)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@21@01 < |__flatten_16__23@17@01| && 0 <= i@21@01 | live]
; [else-branch: 1 | !(i@21@01 < |__flatten_16__23@17@01| && 0 <= i@21@01) | live]
(push) ; 5
; [then-branch: 1 | i@21@01 < |__flatten_16__23@17@01| && 0 <= i@21@01]
(assert (and (< i@21@01 (Seq_length __flatten_16__23@17@01)) (<= 0 i@21@01)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 6
(assert (not (>= i@21@01 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               189
;  :arith-add-rows          2
;  :arith-assert-diseq      4
;  :arith-assert-lower      18
;  :arith-assert-upper      12
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               10
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               4
;  :del-clause              58
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             359
;  :mk-clause               59
;  :num-allocs              3309276
;  :num-checks              15
;  :propagations            30
;  :quant-instantiations    27
;  :rlimit-count            101377)
; [eval] -1
(push) ; 6
; [then-branch: 2 | __flatten_16__23@17@01[i@21@01] == -1 | live]
; [else-branch: 2 | __flatten_16__23@17@01[i@21@01] != -1 | live]
(push) ; 7
; [then-branch: 2 | __flatten_16__23@17@01[i@21@01] == -1]
(assert (= (Seq_index __flatten_16__23@17@01 i@21@01) (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | __flatten_16__23@17@01[i@21@01] != -1]
(assert (not (= (Seq_index __flatten_16__23@17@01 i@21@01) (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@21@01 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               191
;  :arith-add-rows          2
;  :arith-assert-diseq      4
;  :arith-assert-lower      18
;  :arith-assert-upper      12
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               11
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               4
;  :del-clause              58
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             361
;  :mk-clause               59
;  :num-allocs              3309276
;  :num-checks              16
;  :propagations            30
;  :quant-instantiations    28
;  :rlimit-count            101504)
(push) ; 8
; [then-branch: 3 | 0 <= __flatten_16__23@17@01[i@21@01] | live]
; [else-branch: 3 | !(0 <= __flatten_16__23@17@01[i@21@01]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= __flatten_16__23@17@01[i@21@01]]
(assert (<= 0 (Seq_index __flatten_16__23@17@01 i@21@01)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@21@01 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               191
;  :arith-add-rows          2
;  :arith-assert-diseq      4
;  :arith-assert-lower      18
;  :arith-assert-upper      12
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               11
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               4
;  :del-clause              58
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             362
;  :mk-clause               59
;  :num-allocs              3309276
;  :num-checks              17
;  :propagations            30
;  :quant-instantiations    28
;  :rlimit-count            101559)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= __flatten_16__23@17@01[i@21@01])]
(assert (not (<= 0 (Seq_index __flatten_16__23@17@01 i@21@01))))
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
; [else-branch: 1 | !(i@21@01 < |__flatten_16__23@17@01| && 0 <= i@21@01)]
(assert (not (and (< i@21@01 (Seq_length __flatten_16__23@17@01)) (<= 0 i@21@01))))
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
(assert (not (forall ((i@21@01 Int)) (!
  (implies
    (and (< i@21@01 (Seq_length __flatten_16__23@17@01)) (<= 0 i@21@01))
    (or
      (= (Seq_index __flatten_16__23@17@01 i@21@01) (- 0 1))
      (and
        (<
          (Seq_index __flatten_16__23@17@01 i@21@01)
          (Seq_length __flatten_18__25@18@01))
        (<= 0 (Seq_index __flatten_16__23@17@01 i@21@01)))))
  :pattern ((Seq_index __flatten_16__23@17@01 i@21@01))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-add-rows          2
;  :arith-assert-diseq      6
;  :arith-assert-lower      19
;  :arith-assert-upper      13
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               12
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               4
;  :del-clause              69
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             370
;  :mk-clause               70
;  :num-allocs              3309276
;  :num-checks              18
;  :propagations            30
;  :quant-instantiations    29
;  :rlimit-count            101917)
(assert (forall ((i@21@01 Int)) (!
  (implies
    (and (< i@21@01 (Seq_length __flatten_16__23@17@01)) (<= 0 i@21@01))
    (or
      (= (Seq_index __flatten_16__23@17@01 i@21@01) (- 0 1))
      (and
        (<
          (Seq_index __flatten_16__23@17@01 i@21@01)
          (Seq_length __flatten_18__25@18@01))
        (<= 0 (Seq_index __flatten_16__23@17@01 i@21@01)))))
  :pattern ((Seq_index __flatten_16__23@17@01 i@21@01))
  :qid |prog.l<no position>|)))
(declare-const $k@22@01 $Perm)
(assert ($Perm.isReadVar $k@22@01 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@22@01 $Perm.No) (< $Perm.No $k@22@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-add-rows          2
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      14
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               4
;  :del-clause              69
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             375
;  :mk-clause               72
;  :num-allocs              3309276
;  :num-checks              19
;  :propagations            31
;  :quant-instantiations    29
;  :rlimit-count            102388)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-add-rows          2
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      14
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               4
;  :del-clause              69
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             375
;  :mk-clause               72
;  :num-allocs              3309276
;  :num-checks              20
;  :propagations            31
;  :quant-instantiations    29
;  :rlimit-count            102401)
(assert (< $k@22@01 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@22@01)))
(assert (<= (- $Perm.Write $k@22@01) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@22@01)) (not (= diz__21@12@01 $Ref.null))))
; [eval] diz.Main_half != null
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
;  :arith-add-rows          2
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      15
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               4
;  :del-clause              69
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             376
;  :mk-clause               72
;  :num-allocs              3309276
;  :num-checks              21
;  :propagations            31
;  :quant-instantiations    29
;  :rlimit-count            102498)
(set-option :timeout 10)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               200
;  :arith-add-rows          2
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      15
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   7
;  :datatype-splits         3
;  :decisions               7
;  :del-clause              69
;  :final-checks            5
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             376
;  :mk-clause               72
;  :num-allocs              3309276
;  :num-checks              22
;  :propagations            31
;  :quant-instantiations    29
;  :rlimit-count            102814)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($SortWrappers.Seq<Int>To$Snap __flatten_16__23@17@01)
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($SortWrappers.Seq<Int>To$Snap __flatten_18__25@18@01)
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($SortWrappers.$RefTo$Snap sys__result@19@01)
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))))))))))))))))))))))) diz__21@12@01 globals@2@01))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz__21, globals), write)
; [exec]
; sys__result := diz__21
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Main() && acc(sys__result.Main_half, wildcard) && sys__result.Main_half != null && acc(sys__result.Main_half.Half_adder_m, 1 / 2) && sys__result.Main_half.Half_adder_m == sys__result && acc(sys__result.Main_half.Half_adder_init, 1 / 2) && !sys__result.Main_half.Half_adder_init && acc(Half_adder_idleToken_EncodedGlobalVariables(sys__result.Main_half, globals), write)
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
(declare-const $k@23@01 $Perm)
(assert ($Perm.isReadVar $k@23@01 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@23@01 $Perm.No) (< $Perm.No $k@23@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               233
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      16
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               14
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   7
;  :datatype-splits         3
;  :decisions               7
;  :del-clause              69
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.02
;  :memory                  4.02
;  :mk-bool-var             384
;  :mk-clause               74
;  :num-allocs              3420311
;  :num-checks              23
;  :propagations            32
;  :quant-instantiations    32
;  :rlimit-count            103615)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- $Perm.Write $k@22@01) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               233
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      16
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               15
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   7
;  :datatype-splits         3
;  :decisions               7
;  :del-clause              69
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.02
;  :memory                  4.02
;  :mk-bool-var             385
;  :mk-clause               74
;  :num-allocs              3420311
;  :num-checks              24
;  :propagations            32
;  :quant-instantiations    32
;  :rlimit-count            103667)
(assert (< $k@23@01 (- $Perm.Write $k@22@01)))
(assert (<= $Perm.No (- (- $Perm.Write $k@22@01) $k@23@01)))
(assert (<= (- (- $Perm.Write $k@22@01) $k@23@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- $Perm.Write $k@22@01) $k@23@01))
  (not (= diz__21@12@01 $Ref.null))))
; [eval] sys__result.Main_half != null
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@22@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               233
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      24
;  :arith-assert-upper      18
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            4
;  :binary-propagations     7
;  :conflicts               15
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   7
;  :datatype-splits         3
;  :decisions               7
;  :del-clause              69
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.02
;  :memory                  4.02
;  :mk-bool-var             388
;  :mk-clause               74
;  :num-allocs              3420311
;  :num-checks              25
;  :propagations            32
;  :quant-instantiations    32
;  :rlimit-count            103853)
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
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      24
;  :arith-assert-upper      18
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            4
;  :binary-propagations     7
;  :conflicts               15
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   7
;  :datatype-splits         3
;  :decisions               7
;  :del-clause              69
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.02
;  :memory                  4.02
;  :mk-bool-var             388
;  :mk-clause               74
;  :num-allocs              3420311
;  :num-checks              26
;  :propagations            32
;  :quant-instantiations    32
;  :rlimit-count            103866)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@22@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               233
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      24
;  :arith-assert-upper      18
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            4
;  :binary-propagations     7
;  :conflicts               15
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   7
;  :datatype-splits         3
;  :decisions               7
;  :del-clause              69
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.02
;  :memory                  4.02
;  :mk-bool-var             388
;  :mk-clause               74
;  :num-allocs              3420311
;  :num-checks              27
;  :propagations            32
;  :quant-instantiations    32
;  :rlimit-count            103892)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               291
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      24
;  :arith-assert-upper      18
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            4
;  :binary-propagations     7
;  :conflicts               17
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   58
;  :datatype-splits         12
;  :decisions               19
;  :del-clause              71
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.02
;  :memory                  4.02
;  :mk-bool-var             404
;  :mk-clause               76
;  :num-allocs              3420311
;  :num-checks              28
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            104423
;  :time                    0.00)
; [eval] sys__result.Main_half.Half_adder_m == sys__result
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@22@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               291
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      24
;  :arith-assert-upper      18
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            4
;  :binary-propagations     7
;  :conflicts               17
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   58
;  :datatype-splits         12
;  :decisions               19
;  :del-clause              71
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.02
;  :memory                  4.02
;  :mk-bool-var             404
;  :mk-clause               76
;  :num-allocs              3420311
;  :num-checks              29
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            104449)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               291
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      24
;  :arith-assert-upper      18
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            4
;  :binary-propagations     7
;  :conflicts               17
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   58
;  :datatype-splits         12
;  :decisions               19
;  :del-clause              71
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.02
;  :memory                  4.02
;  :mk-bool-var             404
;  :mk-clause               76
;  :num-allocs              3420311
;  :num-checks              30
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            104462)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@22@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               291
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      24
;  :arith-assert-upper      18
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            4
;  :binary-propagations     7
;  :conflicts               17
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   58
;  :datatype-splits         12
;  :decisions               19
;  :del-clause              71
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.02
;  :memory                  4.02
;  :mk-bool-var             404
;  :mk-clause               76
;  :num-allocs              3420311
;  :num-checks              31
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            104488)
; [eval] !sys__result.Main_half.Half_adder_init
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@22@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               291
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      24
;  :arith-assert-upper      18
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            4
;  :binary-propagations     7
;  :conflicts               17
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   58
;  :datatype-splits         12
;  :decisions               19
;  :del-clause              71
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.02
;  :memory                  4.02
;  :mk-bool-var             404
;  :mk-clause               76
;  :num-allocs              3420311
;  :num-checks              32
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            104514)
(push) ; 3
(assert (not (< $Perm.No (- $Perm.Write $k@22@01))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               291
;  :arith-add-rows          2
;  :arith-assert-diseq      8
;  :arith-assert-lower      24
;  :arith-assert-upper      18
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        1
;  :arith-pivots            4
;  :binary-propagations     7
;  :conflicts               17
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   58
;  :datatype-splits         12
;  :decisions               19
;  :del-clause              71
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.02
;  :memory                  4.02
;  :mk-bool-var             404
;  :mk-clause               76
;  :num-allocs              3420311
;  :num-checks              33
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            104540)
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
