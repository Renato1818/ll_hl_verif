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
; ---------- Main___contract_unsatisfiable__Main_EncodedGlobalVariables ----------
(declare-const diz@0@02 $Ref)
(declare-const globals@1@02 $Ref)
(declare-const diz@2@02 $Ref)
(declare-const globals@3@02 $Ref)
(push) ; 1
(declare-const $t@4@02 $Snap)
(assert (= $t@4@02 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@2@02 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@5@02 $Snap)
(assert (= $t@5@02 ($Snap.combine ($Snap.first $t@5@02) ($Snap.second $t@5@02))))
(assert (= ($Snap.first $t@5@02) $Snap.unit))
(assert (= ($Snap.second $t@5@02) $Snap.unit))
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
(declare-const diz@6@02 $Ref)
(declare-const globals@7@02 $Ref)
(declare-const diz@8@02 $Ref)
(declare-const globals@9@02 $Ref)
(push) ; 1
(declare-const $t@10@02 $Snap)
(assert (= $t@10@02 ($Snap.combine ($Snap.first $t@10@02) ($Snap.second $t@10@02))))
(assert (= ($Snap.first $t@10@02) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@8@02 $Ref.null)))
(assert (=
  ($Snap.second $t@10@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@10@02))
    ($Snap.second ($Snap.second $t@10@02)))))
(declare-const $k@11@02 $Perm)
(assert ($Perm.isReadVar $k@11@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@11@02 $Perm.No) (< $Perm.No $k@11@02))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             23
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   7
;  :conflicts             1
;  :datatype-accessor-ax  5
;  :datatype-occurs-check 9
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.91
;  :memory                3.66
;  :mk-bool-var           223
;  :mk-clause             3
;  :num-allocs            3092965
;  :num-checks            6
;  :propagations          8
;  :quant-instantiations  1
;  :rlimit-count          96430)
(assert (<= $Perm.No $k@11@02))
(assert (<= $k@11@02 $Perm.Write))
(assert (implies (< $Perm.No $k@11@02) (not (= diz@8@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@10@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@10@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@10@02))) $Snap.unit))
; [eval] diz.Main_half != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             29
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   7
;  :conflicts             2
;  :datatype-accessor-ax  6
;  :datatype-occurs-check 9
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.91
;  :memory                3.66
;  :mk-bool-var           226
;  :mk-clause             3
;  :num-allocs            3092965
;  :num-checks            7
;  :propagations          8
;  :quant-instantiations  1
;  :rlimit-count          96683)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@02))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@10@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             35
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   7
;  :conflicts             3
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 9
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.91
;  :memory                3.66
;  :mk-bool-var           229
;  :mk-clause             3
;  :num-allocs            3092965
;  :num-checks            8
;  :propagations          8
;  :quant-instantiations  2
;  :rlimit-count          96967)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             35
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   7
;  :conflicts             3
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 9
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.91
;  :memory                3.66
;  :mk-bool-var           229
;  :mk-clause             3
;  :num-allocs            3092965
;  :num-checks            9
;  :propagations          8
;  :quant-instantiations  2
;  :rlimit-count          96980)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
  $Snap.unit))
; [eval] diz.Main_half.Half_adder_m == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             41
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   7
;  :conflicts             4
;  :datatype-accessor-ax  8
;  :datatype-occurs-check 9
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.91
;  :memory                3.66
;  :mk-bool-var           231
;  :mk-clause             3
;  :num-allocs            3092965
;  :num-checks            10
;  :propagations          8
;  :quant-instantiations  2
;  :rlimit-count          97199)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
  diz@8@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             48
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   7
;  :conflicts             5
;  :datatype-accessor-ax  9
;  :datatype-occurs-check 9
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.91
;  :memory                3.66
;  :mk-bool-var           234
;  :mk-clause             3
;  :num-allocs            3092965
;  :num-checks            11
;  :propagations          8
;  :quant-instantiations  3
;  :rlimit-count          97485)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             48
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   7
;  :conflicts             5
;  :datatype-accessor-ax  9
;  :datatype-occurs-check 9
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.91
;  :memory                3.66
;  :mk-bool-var           234
;  :mk-clause             3
;  :num-allocs            3092965
;  :num-checks            12
;  :propagations          8
;  :quant-instantiations  3
;  :rlimit-count          97498)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
  $Snap.unit))
; [eval] !diz.Main_half.Half_adder_init
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@11@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             54
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   7
;  :conflicts             6
;  :datatype-accessor-ax  10
;  :datatype-occurs-check 9
;  :final-checks          5
;  :max-generation        1
;  :max-memory            3.91
;  :memory                3.66
;  :mk-bool-var           236
;  :mk-clause             3
;  :num-allocs            3092965
;  :num-checks            13
;  :propagations          8
;  :quant-instantiations  3
;  :rlimit-count          97737)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))
(push) ; 2
(assert (not (< $Perm.No $k@11@02)))
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
;  :binary-propagations   7
;  :conflicts             7
;  :datatype-accessor-ax  10
;  :datatype-occurs-check 9
;  :final-checks          5
;  :max-generation        2
;  :max-memory            3.91
;  :memory                3.66
;  :mk-bool-var           239
;  :mk-clause             3
;  :num-allocs            3092965
;  :num-checks            14
;  :propagations          8
;  :quant-instantiations  5
;  :rlimit-count          97955)
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@12@02 $Snap)
(assert (= $t@12@02 ($Snap.combine ($Snap.first $t@12@02) ($Snap.second $t@12@02))))
(declare-const $k@13@02 $Perm)
(assert ($Perm.isReadVar $k@13@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@13@02 $Perm.No) (< $Perm.No $k@13@02))))
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
;  :binary-propagations     7
;  :conflicts               8
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.66
;  :mk-bool-var             248
;  :mk-clause               5
;  :num-allocs              3092965
;  :num-checks              16
;  :propagations            9
;  :quant-instantiations    5
;  :rlimit-count            98545)
(assert (<= $Perm.No $k@13@02))
(assert (<= $k@13@02 $Perm.Write))
(assert (implies (< $Perm.No $k@13@02) (not (= diz@8@02 $Ref.null))))
(assert (=
  ($Snap.second $t@12@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@12@02))
    ($Snap.second ($Snap.second $t@12@02)))))
(assert (= ($Snap.first ($Snap.second $t@12@02)) $Snap.unit))
; [eval] diz.Main_half != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@13@02)))
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
;  :binary-propagations     7
;  :conflicts               9
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.66
;  :mk-bool-var             251
;  :mk-clause               5
;  :num-allocs              3092965
;  :num-checks              17
;  :propagations            9
;  :quant-instantiations    5
;  :rlimit-count            98788)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@12@02)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@12@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@12@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@12@02))))))
(push) ; 3
(assert (not (< $Perm.No $k@13@02)))
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
;  :binary-propagations     7
;  :conflicts               10
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.66
;  :mk-bool-var             254
;  :mk-clause               5
;  :num-allocs              3092965
;  :num-checks              18
;  :propagations            9
;  :quant-instantiations    6
;  :rlimit-count            99060)
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
;  :binary-propagations     7
;  :conflicts               10
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.66
;  :mk-bool-var             254
;  :mk-clause               5
;  :num-allocs              3092965
;  :num-checks              19
;  :propagations            9
;  :quant-instantiations    6
;  :rlimit-count            99073)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@12@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@02))))
  $Snap.unit))
; [eval] diz.Main_half.Half_adder_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@13@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               91
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               11
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.66
;  :mk-bool-var             256
;  :mk-clause               5
;  :num-allocs              3092965
;  :num-checks              20
;  :propagations            9
;  :quant-instantiations    6
;  :rlimit-count            99282)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@12@02))))
  diz@8@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@02))))))))
(push) ; 3
(assert (not (< $Perm.No $k@13@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               99
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               12
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.66
;  :mk-bool-var             259
;  :mk-clause               5
;  :num-allocs              3092965
;  :num-checks              21
;  :propagations            9
;  :quant-instantiations    7
;  :rlimit-count            99557)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               99
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               12
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.66
;  :mk-bool-var             259
;  :mk-clause               5
;  :num-allocs              3092965
;  :num-checks              22
;  :propagations            9
;  :quant-instantiations    7
;  :rlimit-count            99570)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@02))))))
  $Snap.unit))
; [eval] !diz.Main_half.Half_adder_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@13@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               105
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             261
;  :mk-clause               5
;  :num-allocs              3202415
;  :num-checks              23
;  :propagations            9
;  :quant-instantiations    7
;  :rlimit-count            99799)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@02))))))))
(push) ; 3
(assert (not (< $Perm.No $k@13@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               108
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               14
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            7
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             263
;  :mk-clause               5
;  :num-allocs              3202415
;  :num-checks              24
;  :propagations            9
;  :quant-instantiations    8
;  :rlimit-count            99987)
(pop) ; 2
(push) ; 2
; [exec]
; var min_advance__29: Int
(declare-const min_advance__29@14@02 Int)
; [exec]
; var __flatten_25__27: Seq[Int]
(declare-const __flatten_25__27@15@02 Seq<Int>)
; [exec]
; var __flatten_26__28: Seq[Int]
(declare-const __flatten_26__28@16@02 Seq<Int>)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@17@02 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(assert (= $t@17@02 ($Snap.combine ($Snap.first $t@17@02) ($Snap.second $t@17@02))))
(assert (= ($Snap.first $t@17@02) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@17@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@17@02))
    ($Snap.second ($Snap.second $t@17@02)))))
(assert (= ($Snap.first ($Snap.second $t@17@02)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@17@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@17@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@17@02))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@17@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@18@02 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@18@02 | live]
; [else-branch: 0 | !(0 <= i@18@02) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@18@02]
(assert (<= 0 i@18@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@18@02)]
(assert (not (<= 0 i@18@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@18@02 < |First:(Second:(Second:(Second:($t@17@02))))| && 0 <= i@18@02 | live]
; [else-branch: 1 | !(i@18@02 < |First:(Second:(Second:(Second:($t@17@02))))| && 0 <= i@18@02) | live]
(push) ; 5
; [then-branch: 1 | i@18@02 < |First:(Second:(Second:(Second:($t@17@02))))| && 0 <= i@18@02]
(assert (and
  (<
    i@18@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
  (<= 0 i@18@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@18@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               169
;  :arith-assert-diseq      4
;  :arith-assert-lower      12
;  :arith-assert-upper      8
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               14
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              4
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             295
;  :mk-clause               11
;  :num-allocs              3202415
;  :num-checks              26
;  :propagations            11
;  :quant-instantiations    14
;  :rlimit-count            101630)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:($t@17@02))))[i@18@02] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:($t@17@02))))[i@18@02] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:($t@17@02))))[i@18@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
    i@18@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:($t@17@02))))[i@18@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
      i@18@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@18@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               169
;  :arith-assert-diseq      4
;  :arith-assert-lower      12
;  :arith-assert-upper      8
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               14
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              4
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             296
;  :mk-clause               11
;  :num-allocs              3202415
;  :num-checks              27
;  :propagations            11
;  :quant-instantiations    14
;  :rlimit-count            101805)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@17@02))))[i@18@02] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@17@02))))[i@18@02]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@17@02))))[i@18@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
    i@18@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@18@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               169
;  :arith-assert-diseq      5
;  :arith-assert-lower      15
;  :arith-assert-upper      8
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               14
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              4
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             299
;  :mk-clause               12
;  :num-allocs              3202415
;  :num-checks              28
;  :propagations            11
;  :quant-instantiations    14
;  :rlimit-count            101929)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@17@02))))[i@18@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
      i@18@02))))
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
; [else-branch: 1 | !(i@18@02 < |First:(Second:(Second:(Second:($t@17@02))))| && 0 <= i@18@02)]
(assert (not
  (and
    (<
      i@18@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
    (<= 0 i@18@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@18@02 Int)) (!
  (implies
    (and
      (<
        i@18@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
      (<= 0 i@18@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
          i@18@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
            i@18@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
            i@18@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
    i@18@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))
(declare-const $k@19@02 $Perm)
(assert ($Perm.isReadVar $k@19@02 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@19@02 $Perm.No) (< $Perm.No $k@19@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               174
;  :arith-assert-diseq      6
;  :arith-assert-lower      17
;  :arith-assert-upper      9
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               15
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              5
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             305
;  :mk-clause               14
;  :num-allocs              3202415
;  :num-checks              29
;  :propagations            12
;  :quant-instantiations    14
;  :rlimit-count            102697)
(declare-const $t@20@02 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@11@02)
    (=
      $t@20@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@02)))))
  (implies
    (< $Perm.No $k@19@02)
    (=
      $t@20@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))
(assert (<= $Perm.No (+ $k@11@02 $k@19@02)))
(assert (<= (+ $k@11@02 $k@19@02) $Perm.Write))
(assert (implies (< $Perm.No (+ $k@11@02 $k@19@02)) (not (= diz@8@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))
  $Snap.unit))
; [eval] diz.Main_half != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@11@02 $k@19@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               184
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      11
;  :arith-conflicts         1
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               16
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              5
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             313
;  :mk-clause               14
;  :num-allocs              3202415
;  :num-checks              30
;  :propagations            12
;  :quant-instantiations    15
;  :rlimit-count            103310)
(assert (not (= $t@20@02 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@11@02 $k@19@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               190
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      12
;  :arith-conflicts         2
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               17
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              5
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             316
;  :mk-clause               14
;  :num-allocs              3202415
;  :num-checks              31
;  :propagations            12
;  :quant-instantiations    15
;  :rlimit-count            103616)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@11@02 $k@19@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               195
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      13
;  :arith-conflicts         3
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               18
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              5
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             318
;  :mk-clause               14
;  :num-allocs              3202415
;  :num-checks              32
;  :propagations            12
;  :quant-instantiations    15
;  :rlimit-count            103887)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@11@02 $k@19@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               200
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      14
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               19
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              5
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             320
;  :mk-clause               14
;  :num-allocs              3202415
;  :num-checks              33
;  :propagations            12
;  :quant-instantiations    15
;  :rlimit-count            104168)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@11@02 $k@19@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               205
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      15
;  :arith-conflicts         5
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               20
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              5
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             322
;  :mk-clause               14
;  :num-allocs              3202415
;  :num-checks              34
;  :propagations            12
;  :quant-instantiations    15
;  :rlimit-count            104459)
(push) ; 3
(assert (not (< $Perm.No (+ $k@11@02 $k@19@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               205
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      16
;  :arith-conflicts         6
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               21
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              5
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             323
;  :mk-clause               14
;  :num-allocs              3202415
;  :num-checks              35
;  :propagations            12
;  :quant-instantiations    15
;  :rlimit-count            104521)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               205
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      16
;  :arith-conflicts         6
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               21
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              5
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             323
;  :mk-clause               14
;  :num-allocs              3202415
;  :num-checks              36
;  :propagations            12
;  :quant-instantiations    15
;  :rlimit-count            104534)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@02))) $t@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               205
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      16
;  :arith-conflicts         6
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               22
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              5
;  :final-checks            8
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             324
;  :mk-clause               14
;  :num-allocs              3202415
;  :num-checks              37
;  :propagations            12
;  :quant-instantiations    15
;  :rlimit-count            104624)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
  ($SortWrappers.$SnapToBool ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@17@02 diz@8@02 globals@9@02))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@21@02 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; Half_adder_forkOperator_EncodedGlobalVariables(diz.Main_half, globals)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@11@02 $k@19@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               286
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      17
;  :arith-conflicts         7
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               24
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              13
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             346
;  :mk-clause               15
;  :num-allocs              3202415
;  :num-checks              40
;  :propagations            13
;  :quant-instantiations    16
;  :rlimit-count            105871)
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
; (:added-eqs               286
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      17
;  :arith-conflicts         7
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               24
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              13
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             346
;  :mk-clause               15
;  :num-allocs              3202415
;  :num-checks              41
;  :propagations            13
;  :quant-instantiations    16
;  :rlimit-count            105884)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@02))) $t@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               286
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      17
;  :arith-conflicts         7
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               25
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              13
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             347
;  :mk-clause               15
;  :num-allocs              3202415
;  :num-checks              42
;  :propagations            13
;  :quant-instantiations    16
;  :rlimit-count            105974)
; [eval] diz.Half_adder_m != null
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@02))) $t@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               286
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      17
;  :arith-conflicts         7
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              13
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             348
;  :mk-clause               15
;  :num-allocs              3202415
;  :num-checks              43
;  :propagations            13
;  :quant-instantiations    16
;  :rlimit-count            106064)
(set-option :timeout 0)
(push) ; 3
(assert (not (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
    $Ref.null))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               286
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      17
;  :arith-conflicts         7
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              13
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             348
;  :mk-clause               15
;  :num-allocs              3202415
;  :num-checks              44
;  :propagations            13
;  :quant-instantiations    16
;  :rlimit-count            106082)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
    $Ref.null)))
(declare-const $k@22@02 $Perm)
(assert ($Perm.isReadVar $k@22@02 $Perm.Write))
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@02))) $t@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               286
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      18
;  :arith-conflicts         7
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               27
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              13
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             353
;  :mk-clause               17
;  :num-allocs              3202415
;  :num-checks              45
;  :propagations            14
;  :quant-instantiations    16
;  :rlimit-count            106346)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@22@02 $Perm.No) (< $Perm.No $k@22@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               286
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      18
;  :arith-conflicts         7
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               28
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              13
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             353
;  :mk-clause               17
;  :num-allocs              3202415
;  :num-checks              46
;  :propagations            14
;  :quant-instantiations    16
;  :rlimit-count            106396)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@8@02
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               286
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      18
;  :arith-conflicts         7
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               28
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              13
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             353
;  :mk-clause               17
;  :num-allocs              3202415
;  :num-checks              47
;  :propagations            14
;  :quant-instantiations    16
;  :rlimit-count            106407)
(push) ; 3
(assert (not (not (= (+ $k@11@02 $k@19@02) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               287
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      19
;  :arith-conflicts         8
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               29
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              15
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             355
;  :mk-clause               19
;  :num-allocs              3202415
;  :num-checks              48
;  :propagations            15
;  :quant-instantiations    16
;  :rlimit-count            106469)
(assert (< $k@22@02 (+ $k@11@02 $k@19@02)))
(assert (<= $Perm.No (- (+ $k@11@02 $k@19@02) $k@22@02)))
(assert (<= (- (+ $k@11@02 $k@19@02) $k@22@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@11@02 $k@19@02) $k@22@02))
  (not (= diz@8@02 $Ref.null))))
; [eval] diz.Half_adder_m.Main_half == diz
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@02))) $t@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               287
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      22
;  :arith-assert-upper      20
;  :arith-conflicts         8
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               30
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              15
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             359
;  :mk-clause               19
;  :num-allocs              3202415
;  :num-checks              49
;  :propagations            15
;  :quant-instantiations    16
;  :rlimit-count            106728)
(push) ; 3
(assert (not (=
  diz@8@02
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               287
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      22
;  :arith-assert-upper      20
;  :arith-conflicts         8
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         8
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               30
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              15
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             359
;  :mk-clause               19
;  :num-allocs              3202415
;  :num-checks              50
;  :propagations            15
;  :quant-instantiations    16
;  :rlimit-count            106739)
(push) ; 3
(assert (not (< $Perm.No (+ $k@11@02 $k@19@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               287
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      22
;  :arith-assert-upper      21
;  :arith-conflicts         9
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               31
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              15
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             360
;  :mk-clause               19
;  :num-allocs              3202415
;  :num-checks              51
;  :propagations            15
;  :quant-instantiations    16
;  :rlimit-count            106802)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               287
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      22
;  :arith-assert-upper      21
;  :arith-conflicts         9
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               31
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              15
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             360
;  :mk-clause               19
;  :num-allocs              3202415
;  :num-checks              52
;  :propagations            15
;  :quant-instantiations    16
;  :rlimit-count            106815)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@02))) $t@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               287
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      22
;  :arith-assert-upper      21
;  :arith-conflicts         9
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               32
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   24
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              15
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             361
;  :mk-clause               19
;  :num-allocs              3202415
;  :num-checks              53
;  :propagations            15
;  :quant-instantiations    16
;  :rlimit-count            106905)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               324
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      22
;  :arith-assert-upper      21
;  :arith-conflicts         9
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               32
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   30
;  :datatype-splits         28
;  :decisions               42
;  :del-clause              15
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             368
;  :mk-clause               19
;  :num-allocs              3318189
;  :num-checks              54
;  :propagations            16
;  :quant-instantiations    16
;  :rlimit-count            107375
;  :time                    0.00)
; [eval] !diz.Half_adder_init
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@02))) $t@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               324
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      22
;  :arith-assert-upper      21
;  :arith-conflicts         9
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               33
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   30
;  :datatype-splits         28
;  :decisions               42
;  :del-clause              15
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             369
;  :mk-clause               19
;  :num-allocs              3318189
;  :num-checks              55
;  :propagations            16
;  :quant-instantiations    16
;  :rlimit-count            107465)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@02))) $t@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               324
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      22
;  :arith-assert-upper      21
;  :arith-conflicts         9
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         9
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               34
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   30
;  :datatype-splits         28
;  :decisions               42
;  :del-clause              15
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             370
;  :mk-clause               19
;  :num-allocs              3318189
;  :num-checks              56
;  :propagations            16
;  :quant-instantiations    16
;  :rlimit-count            107555)
(declare-const $t@23@02 $Snap)
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@24@02 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@24@02 | live]
; [else-branch: 4 | !(0 <= i@24@02) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@24@02]
(assert (<= 0 i@24@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@24@02)]
(assert (not (<= 0 i@24@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@24@02 < |First:(Second:(Second:(Second:($t@17@02))))| && 0 <= i@24@02 | live]
; [else-branch: 5 | !(i@24@02 < |First:(Second:(Second:(Second:($t@17@02))))| && 0 <= i@24@02) | live]
(push) ; 5
; [then-branch: 5 | i@24@02 < |First:(Second:(Second:(Second:($t@17@02))))| && 0 <= i@24@02]
(assert (and
  (<
    i@24@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
  (<= 0 i@24@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@24@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               362
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      23
;  :arith-assert-upper      22
;  :arith-conflicts         9
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         10
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               34
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             379
;  :mk-clause               19
;  :num-allocs              3318189
;  :num-checks              58
;  :propagations            17
;  :quant-instantiations    16
;  :rlimit-count            108149)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:($t@17@02))))[i@24@02] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@17@02))))[i@24@02] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@17@02))))[i@24@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
    i@24@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:($t@17@02))))[i@24@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
      i@24@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@24@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               364
;  :arith-add-rows          1
;  :arith-assert-diseq      9
;  :arith-assert-lower      26
;  :arith-assert-upper      23
;  :arith-conflicts         9
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         10
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               34
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             386
;  :mk-clause               29
;  :num-allocs              3318189
;  :num-checks              59
;  :propagations            22
;  :quant-instantiations    17
;  :rlimit-count            108386)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@17@02))))[i@24@02] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@17@02))))[i@24@02]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@17@02))))[i@24@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
    i@24@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@24@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          1
;  :arith-assert-diseq      9
;  :arith-assert-lower      28
;  :arith-assert-upper      24
;  :arith-conflicts         9
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         11
;  :arith-pivots            4
;  :binary-propagations     7
;  :conflicts               34
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             390
;  :mk-clause               29
;  :num-allocs              3318189
;  :num-checks              60
;  :propagations            22
;  :quant-instantiations    17
;  :rlimit-count            108527)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@17@02))))[i@24@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
      i@24@02))))
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
; [else-branch: 5 | !(i@24@02 < |First:(Second:(Second:(Second:($t@17@02))))| && 0 <= i@24@02)]
(assert (not
  (and
    (<
      i@24@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
    (<= 0 i@24@02))))
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
(assert (not (forall ((i@24@02 Int)) (!
  (implies
    (and
      (<
        i@24@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
      (<= 0 i@24@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
          i@24@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
            i@24@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
            i@24@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
    i@24@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          1
;  :arith-assert-diseq      11
;  :arith-assert-lower      29
;  :arith-assert-upper      25
;  :arith-conflicts         9
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               35
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              41
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             398
;  :mk-clause               43
;  :num-allocs              3318189
;  :num-checks              61
;  :propagations            24
;  :quant-instantiations    18
;  :rlimit-count            108976)
(assert (forall ((i@24@02 Int)) (!
  (implies
    (and
      (<
        i@24@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
      (<= 0 i@24@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
          i@24@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
            i@24@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
            i@24@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
    i@24@02))
  :qid |prog.l<no position>|)))
(declare-const $k@25@02 $Perm)
(assert ($Perm.isReadVar $k@25@02 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@25@02 $Perm.No) (< $Perm.No $k@25@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          1
;  :arith-assert-diseq      12
;  :arith-assert-lower      31
;  :arith-assert-upper      26
;  :arith-conflicts         9
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               36
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              41
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             403
;  :mk-clause               45
;  :num-allocs              3318189
;  :num-checks              62
;  :propagations            25
;  :quant-instantiations    18
;  :rlimit-count            109537)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- (+ $k@11@02 $k@19@02) $k@22@02) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          1
;  :arith-assert-diseq      12
;  :arith-assert-lower      31
;  :arith-assert-upper      26
;  :arith-conflicts         9
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              41
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             404
;  :mk-clause               45
;  :num-allocs              3318189
;  :num-checks              63
;  :propagations            25
;  :quant-instantiations    18
;  :rlimit-count            109611)
(assert (< $k@25@02 (- (+ $k@11@02 $k@19@02) $k@22@02)))
(assert (<= $Perm.No (- (- (+ $k@11@02 $k@19@02) $k@22@02) $k@25@02)))
(assert (<= (- (- (+ $k@11@02 $k@19@02) $k@22@02) $k@25@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- (+ $k@11@02 $k@19@02) $k@22@02) $k@25@02))
  (not (= diz@8@02 $Ref.null))))
; [eval] diz.Main_half != null
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@11@02 $k@19@02) $k@22@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         9
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         12
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              41
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             407
;  :mk-clause               45
;  :num-allocs              3318189
;  :num-checks              64
;  :propagations            25
;  :quant-instantiations    18
;  :rlimit-count            109845)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@11@02 $k@19@02) $k@22@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         9
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         12
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              41
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             407
;  :mk-clause               45
;  :num-allocs              3318189
;  :num-checks              65
;  :propagations            25
;  :quant-instantiations    18
;  :rlimit-count            109866)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@11@02 $k@19@02) $k@22@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         9
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         12
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              41
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             407
;  :mk-clause               45
;  :num-allocs              3318189
;  :num-checks              66
;  :propagations            25
;  :quant-instantiations    18
;  :rlimit-count            109887)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@11@02 $k@19@02) $k@22@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         9
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         12
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              41
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             407
;  :mk-clause               45
;  :num-allocs              3318189
;  :num-checks              67
;  :propagations            25
;  :quant-instantiations    18
;  :rlimit-count            109908)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@11@02 $k@19@02) $k@22@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         9
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         12
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              41
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             407
;  :mk-clause               45
;  :num-allocs              3318189
;  :num-checks              68
;  :propagations            25
;  :quant-instantiations    18
;  :rlimit-count            109929)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         9
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         12
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              41
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             407
;  :mk-clause               45
;  :num-allocs              3318189
;  :num-checks              69
;  :propagations            25
;  :quant-instantiations    18
;  :rlimit-count            109942)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@11@02 $k@19@02) $k@22@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         9
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         12
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              41
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             407
;  :mk-clause               45
;  :num-allocs              3318189
;  :num-checks              70
;  :propagations            25
;  :quant-instantiations    18
;  :rlimit-count            109963)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@02))) $t@20@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         9
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         12
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   36
;  :datatype-splits         36
;  :decisions               53
;  :del-clause              41
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.85
;  :mk-bool-var             408
;  :mk-clause               45
;  :num-allocs              3318189
;  :num-checks              71
;  :propagations            25
;  :quant-instantiations    18
;  :rlimit-count            110053)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($SortWrappers.$RefTo$Snap $t@20@02)
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))))))))) diz@8@02 globals@9@02))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const min_advance__29@26@02 Int)
(declare-const __flatten_26__28@27@02 Seq<Int>)
(declare-const __flatten_25__27@28@02 Seq<Int>)
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
; (:added-eqs               523
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         9
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         12
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 93
;  :datatype-occurs-check   54
;  :datatype-splits         60
;  :decisions               86
;  :del-clause              41
;  :final-checks            29
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             430
;  :mk-clause               45
;  :num-allocs              3436584
;  :num-checks              74
;  :propagations            28
;  :quant-instantiations    18
;  :rlimit-count            112091)
; [then-branch: 8 | True | live]
; [else-branch: 8 | False | dead]
(push) ; 5
; [then-branch: 8 | True]
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@29@02 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(assert (= $t@29@02 ($Snap.combine ($Snap.first $t@29@02) ($Snap.second $t@29@02))))
(assert (= ($Snap.first $t@29@02) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@29@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@29@02))
    ($Snap.second ($Snap.second $t@29@02)))))
(assert (= ($Snap.first ($Snap.second $t@29@02)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@29@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@29@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@29@02))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@29@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@30@02 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 9 | 0 <= i@30@02 | live]
; [else-branch: 9 | !(0 <= i@30@02) | live]
(push) ; 8
; [then-branch: 9 | 0 <= i@30@02]
(assert (<= 0 i@30@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 9 | !(0 <= i@30@02)]
(assert (not (<= 0 i@30@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 10 | i@30@02 < |First:(Second:(Second:(Second:($t@29@02))))| && 0 <= i@30@02 | live]
; [else-branch: 10 | !(i@30@02 < |First:(Second:(Second:(Second:($t@29@02))))| && 0 <= i@30@02) | live]
(push) ; 8
; [then-branch: 10 | i@30@02 < |First:(Second:(Second:(Second:($t@29@02))))| && 0 <= i@30@02]
(assert (and
  (<
    i@30@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
  (<= 0 i@30@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@30@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               611
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      38
;  :arith-assert-upper      30
;  :arith-conflicts         9
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 105
;  :datatype-occurs-check   60
;  :datatype-splits         68
;  :decisions               97
;  :del-clause              41
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             463
;  :mk-clause               45
;  :num-allocs              3436584
;  :num-checks              76
;  :propagations            29
;  :quant-instantiations    22
;  :rlimit-count            113867)
; [eval] -1
(push) ; 9
; [then-branch: 11 | First:(Second:(Second:(Second:($t@29@02))))[i@30@02] == -1 | live]
; [else-branch: 11 | First:(Second:(Second:(Second:($t@29@02))))[i@30@02] != -1 | live]
(push) ; 10
; [then-branch: 11 | First:(Second:(Second:(Second:($t@29@02))))[i@30@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    i@30@02)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 11 | First:(Second:(Second:(Second:($t@29@02))))[i@30@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
      i@30@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@30@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               611
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      38
;  :arith-assert-upper      30
;  :arith-conflicts         9
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 105
;  :datatype-occurs-check   60
;  :datatype-splits         68
;  :decisions               97
;  :del-clause              41
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             464
;  :mk-clause               45
;  :num-allocs              3436584
;  :num-checks              77
;  :propagations            29
;  :quant-instantiations    22
;  :rlimit-count            114042)
(push) ; 11
; [then-branch: 12 | 0 <= First:(Second:(Second:(Second:($t@29@02))))[i@30@02] | live]
; [else-branch: 12 | !(0 <= First:(Second:(Second:(Second:($t@29@02))))[i@30@02]) | live]
(push) ; 12
; [then-branch: 12 | 0 <= First:(Second:(Second:(Second:($t@29@02))))[i@30@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    i@30@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@30@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               611
;  :arith-add-rows          3
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      30
;  :arith-conflicts         9
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 105
;  :datatype-occurs-check   60
;  :datatype-splits         68
;  :decisions               97
;  :del-clause              41
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             467
;  :mk-clause               46
;  :num-allocs              3436584
;  :num-checks              78
;  :propagations            29
;  :quant-instantiations    22
;  :rlimit-count            114166)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 12 | !(0 <= First:(Second:(Second:(Second:($t@29@02))))[i@30@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
      i@30@02))))
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
; [else-branch: 10 | !(i@30@02 < |First:(Second:(Second:(Second:($t@29@02))))| && 0 <= i@30@02)]
(assert (not
  (and
    (<
      i@30@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
    (<= 0 i@30@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@30@02 Int)) (!
  (implies
    (and
      (<
        i@30@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
      (<= 0 i@30@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
          i@30@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
            i@30@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
            i@30@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    i@30@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))
(declare-const $k@31@02 $Perm)
(assert ($Perm.isReadVar $k@31@02 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@31@02 $Perm.No) (< $Perm.No $k@31@02))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               616
;  :arith-add-rows          3
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      31
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 105
;  :datatype-occurs-check   60
;  :datatype-splits         68
;  :decisions               97
;  :del-clause              42
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             473
;  :mk-clause               48
;  :num-allocs              3436584
;  :num-checks              79
;  :propagations            30
;  :quant-instantiations    22
;  :rlimit-count            114935)
(assert (<= $Perm.No $k@31@02))
(assert (<= $k@31@02 $Perm.Write))
(assert (implies (< $Perm.No $k@31@02) (not (= diz@8@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))
  $Snap.unit))
; [eval] diz.Main_half != null
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               622
;  :arith-add-rows          3
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      32
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               40
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 105
;  :datatype-occurs-check   60
;  :datatype-splits         68
;  :decisions               97
;  :del-clause              42
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             476
;  :mk-clause               48
;  :num-allocs              3436584
;  :num-checks              80
;  :propagations            30
;  :quant-instantiations    22
;  :rlimit-count            115258)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               628
;  :arith-add-rows          3
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      32
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               41
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 105
;  :datatype-occurs-check   60
;  :datatype-splits         68
;  :decisions               97
;  :del-clause              42
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             479
;  :mk-clause               48
;  :num-allocs              3436584
;  :num-checks              81
;  :propagations            30
;  :quant-instantiations    23
;  :rlimit-count            115614)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               633
;  :arith-add-rows          3
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      32
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               42
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 105
;  :datatype-occurs-check   60
;  :datatype-splits         68
;  :decisions               97
;  :del-clause              42
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             480
;  :mk-clause               48
;  :num-allocs              3436584
;  :num-checks              82
;  :propagations            30
;  :quant-instantiations    23
;  :rlimit-count            115871)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               638
;  :arith-add-rows          3
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      32
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 105
;  :datatype-occurs-check   60
;  :datatype-splits         68
;  :decisions               97
;  :del-clause              42
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             481
;  :mk-clause               48
;  :num-allocs              3436584
;  :num-checks              83
;  :propagations            30
;  :quant-instantiations    23
;  :rlimit-count            116138)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               643
;  :arith-add-rows          3
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      32
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               44
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 105
;  :datatype-occurs-check   60
;  :datatype-splits         68
;  :decisions               97
;  :del-clause              42
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             482
;  :mk-clause               48
;  :num-allocs              3436584
;  :num-checks              84
;  :propagations            30
;  :quant-instantiations    23
;  :rlimit-count            116415)
(push) ; 6
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               643
;  :arith-add-rows          3
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      32
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               45
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 105
;  :datatype-occurs-check   60
;  :datatype-splits         68
;  :decisions               97
;  :del-clause              42
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             482
;  :mk-clause               48
;  :num-allocs              3436584
;  :num-checks              85
;  :propagations            30
;  :quant-instantiations    23
;  :rlimit-count            116463)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               643
;  :arith-add-rows          3
;  :arith-assert-diseq      14
;  :arith-assert-lower      43
;  :arith-assert-upper      32
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         13
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               45
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 105
;  :datatype-occurs-check   60
;  :datatype-splits         68
;  :decisions               97
;  :del-clause              42
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             482
;  :mk-clause               48
;  :num-allocs              3436584
;  :num-checks              86
;  :propagations            30
;  :quant-instantiations    23
;  :rlimit-count            116476)
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@29@02 diz@8@02 globals@9@02))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@32@02 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; Main_immediate_wakeup_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@33@02 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 13 | 0 <= i@33@02 | live]
; [else-branch: 13 | !(0 <= i@33@02) | live]
(push) ; 8
; [then-branch: 13 | 0 <= i@33@02]
(assert (<= 0 i@33@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 13 | !(0 <= i@33@02)]
(assert (not (<= 0 i@33@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 14 | i@33@02 < |First:(Second:(Second:(Second:($t@29@02))))| && 0 <= i@33@02 | live]
; [else-branch: 14 | !(i@33@02 < |First:(Second:(Second:(Second:($t@29@02))))| && 0 <= i@33@02) | live]
(push) ; 8
; [then-branch: 14 | i@33@02 < |First:(Second:(Second:(Second:($t@29@02))))| && 0 <= i@33@02]
(assert (and
  (<
    i@33@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
  (<= 0 i@33@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@33@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               825
;  :arith-add-rows          3
;  :arith-assert-diseq      14
;  :arith-assert-lower      44
;  :arith-assert-upper      33
;  :arith-conflicts         9
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         14
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               46
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   76
;  :datatype-splits         104
;  :decisions               143
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             521
;  :mk-clause               49
;  :num-allocs              3436584
;  :num-checks              89
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            118007)
; [eval] -1
(push) ; 9
; [then-branch: 15 | First:(Second:(Second:(Second:($t@29@02))))[i@33@02] == -1 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:($t@29@02))))[i@33@02] != -1 | live]
(push) ; 10
; [then-branch: 15 | First:(Second:(Second:(Second:($t@29@02))))[i@33@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    i@33@02)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 15 | First:(Second:(Second:(Second:($t@29@02))))[i@33@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
      i@33@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@33@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               827
;  :arith-add-rows          3
;  :arith-assert-diseq      16
;  :arith-assert-lower      47
;  :arith-assert-upper      34
;  :arith-conflicts         9
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         14
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               46
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   76
;  :datatype-splits         104
;  :decisions               143
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             528
;  :mk-clause               59
;  :num-allocs              3436584
;  :num-checks              90
;  :propagations            38
;  :quant-instantiations    24
;  :rlimit-count            118238)
(push) ; 11
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@29@02))))[i@33@02] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@29@02))))[i@33@02]) | live]
(push) ; 12
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@29@02))))[i@33@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    i@33@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@33@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               829
;  :arith-add-rows          3
;  :arith-assert-diseq      16
;  :arith-assert-lower      49
;  :arith-assert-upper      35
;  :arith-conflicts         9
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         15
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               46
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   76
;  :datatype-splits         104
;  :decisions               143
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             532
;  :mk-clause               59
;  :num-allocs              3436584
;  :num-checks              91
;  :propagations            38
;  :quant-instantiations    24
;  :rlimit-count            118369)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@29@02))))[i@33@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
      i@33@02))))
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
; [else-branch: 14 | !(i@33@02 < |First:(Second:(Second:(Second:($t@29@02))))| && 0 <= i@33@02)]
(assert (not
  (and
    (<
      i@33@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
    (<= 0 i@33@02))))
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
(assert (not (forall ((i@33@02 Int)) (!
  (implies
    (and
      (<
        i@33@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
      (<= 0 i@33@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
          i@33@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
            i@33@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
            i@33@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    i@33@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               829
;  :arith-add-rows          3
;  :arith-assert-diseq      18
;  :arith-assert-lower      50
;  :arith-assert-upper      36
;  :arith-conflicts         9
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         16
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               47
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   76
;  :datatype-splits         104
;  :decisions               143
;  :del-clause              68
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             540
;  :mk-clause               73
;  :num-allocs              3436584
;  :num-checks              92
;  :propagations            40
;  :quant-instantiations    25
;  :rlimit-count            118815)
(assert (forall ((i@33@02 Int)) (!
  (implies
    (and
      (<
        i@33@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
      (<= 0 i@33@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
          i@33@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
            i@33@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
            i@33@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    i@33@02))
  :qid |prog.l<no position>|)))
(declare-const $t@34@02 $Snap)
(assert (= $t@34@02 ($Snap.combine ($Snap.first $t@34@02) ($Snap.second $t@34@02))))
(assert (=
  ($Snap.second $t@34@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@34@02))
    ($Snap.second ($Snap.second $t@34@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@34@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@34@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@34@02))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02))))
  1))
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
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
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
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@35@02 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 17 | 0 <= i@35@02 | live]
; [else-branch: 17 | !(0 <= i@35@02) | live]
(push) ; 8
; [then-branch: 17 | 0 <= i@35@02]
(assert (<= 0 i@35@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 17 | !(0 <= i@35@02)]
(assert (not (<= 0 i@35@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 18 | i@35@02 < |First:(Second:($t@34@02))| && 0 <= i@35@02 | live]
; [else-branch: 18 | !(i@35@02 < |First:(Second:($t@34@02))| && 0 <= i@35@02) | live]
(push) ; 8
; [then-branch: 18 | i@35@02 < |First:(Second:($t@34@02))| && 0 <= i@35@02]
(assert (and
  (<
    i@35@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))))
  (<= 0 i@35@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@35@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               867
;  :arith-add-rows          3
;  :arith-assert-diseq      18
;  :arith-assert-lower      55
;  :arith-assert-upper      39
;  :arith-conflicts         9
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         17
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               47
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   76
;  :datatype-splits         104
;  :decisions               143
;  :del-clause              68
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             562
;  :mk-clause               73
;  :num-allocs              3436584
;  :num-checks              93
;  :propagations            40
;  :quant-instantiations    29
;  :rlimit-count            120246)
; [eval] -1
(push) ; 9
; [then-branch: 19 | First:(Second:($t@34@02))[i@35@02] == -1 | live]
; [else-branch: 19 | First:(Second:($t@34@02))[i@35@02] != -1 | live]
(push) ; 10
; [then-branch: 19 | First:(Second:($t@34@02))[i@35@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
    i@35@02)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 19 | First:(Second:($t@34@02))[i@35@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
      i@35@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@35@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               867
;  :arith-add-rows          3
;  :arith-assert-diseq      18
;  :arith-assert-lower      55
;  :arith-assert-upper      39
;  :arith-conflicts         9
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         17
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               47
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   76
;  :datatype-splits         104
;  :decisions               143
;  :del-clause              68
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             563
;  :mk-clause               73
;  :num-allocs              3436584
;  :num-checks              94
;  :propagations            40
;  :quant-instantiations    29
;  :rlimit-count            120397)
(push) ; 11
; [then-branch: 20 | 0 <= First:(Second:($t@34@02))[i@35@02] | live]
; [else-branch: 20 | !(0 <= First:(Second:($t@34@02))[i@35@02]) | live]
(push) ; 12
; [then-branch: 20 | 0 <= First:(Second:($t@34@02))[i@35@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
    i@35@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@35@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               867
;  :arith-add-rows          3
;  :arith-assert-diseq      19
;  :arith-assert-lower      58
;  :arith-assert-upper      39
;  :arith-conflicts         9
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         17
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               47
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   76
;  :datatype-splits         104
;  :decisions               143
;  :del-clause              68
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             566
;  :mk-clause               74
;  :num-allocs              3436584
;  :num-checks              95
;  :propagations            40
;  :quant-instantiations    29
;  :rlimit-count            120500)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 20 | !(0 <= First:(Second:($t@34@02))[i@35@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
      i@35@02))))
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
; [else-branch: 18 | !(i@35@02 < |First:(Second:($t@34@02))| && 0 <= i@35@02)]
(assert (not
  (and
    (<
      i@35@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))))
    (<= 0 i@35@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@35@02 Int)) (!
  (implies
    (and
      (<
        i@35@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))))
      (<= 0 i@35@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
          i@35@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
            i@35@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
            i@35@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
    i@35@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               885
;  :arith-add-rows          3
;  :arith-assert-diseq      19
;  :arith-assert-lower      59
;  :arith-assert-upper      40
;  :arith-conflicts         9
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         18
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               47
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   76
;  :datatype-splits         104
;  :decisions               143
;  :del-clause              69
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             586
;  :mk-clause               84
;  :num-allocs              3436584
;  :num-checks              96
;  :propagations            44
;  :quant-instantiations    31
;  :rlimit-count            121573)
(push) ; 6
; [then-branch: 21 | 0 <= First:(Second:(Second:(Second:($t@29@02))))[0] | live]
; [else-branch: 21 | !(0 <= First:(Second:(Second:(Second:($t@29@02))))[0]) | live]
(push) ; 7
; [then-branch: 21 | 0 <= First:(Second:(Second:(Second:($t@29@02))))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               885
;  :arith-add-rows          3
;  :arith-assert-diseq      19
;  :arith-assert-lower      60
;  :arith-assert-upper      40
;  :arith-conflicts         9
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         18
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               47
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   76
;  :datatype-splits         104
;  :decisions               143
;  :del-clause              69
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             592
;  :mk-clause               91
;  :num-allocs              3436584
;  :num-checks              97
;  :propagations            44
;  :quant-instantiations    33
;  :rlimit-count            121751)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               885
;  :arith-add-rows          3
;  :arith-assert-diseq      19
;  :arith-assert-lower      60
;  :arith-assert-upper      40
;  :arith-conflicts         9
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         18
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               47
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   76
;  :datatype-splits         104
;  :decisions               143
;  :del-clause              69
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             592
;  :mk-clause               91
;  :num-allocs              3436584
;  :num-checks              98
;  :propagations            44
;  :quant-instantiations    33
;  :rlimit-count            121760)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               886
;  :arith-add-rows          3
;  :arith-assert-diseq      19
;  :arith-assert-lower      61
;  :arith-assert-upper      41
;  :arith-conflicts         10
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         18
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 155
;  :datatype-occurs-check   76
;  :datatype-splits         104
;  :decisions               143
;  :del-clause              69
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.00
;  :memory                  4.00
;  :mk-bool-var             592
;  :mk-clause               91
;  :num-allocs              3436584
;  :num-checks              99
;  :propagations            48
;  :quant-instantiations    33
;  :rlimit-count            121878)
(pop) ; 7
(push) ; 7
; [else-branch: 21 | !(0 <= First:(Second:(Second:(Second:($t@29@02))))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
        0))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               988
;  :arith-add-rows          5
;  :arith-assert-diseq      22
;  :arith-assert-lower      72
;  :arith-assert-upper      46
;  :arith-conflicts         10
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         20
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 180
;  :datatype-occurs-check   87
;  :datatype-splits         125
;  :decisions               166
;  :del-clause              91
;  :final-checks            41
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             638
;  :mk-clause               106
;  :num-allocs              3563600
;  :num-checks              100
;  :propagations            57
;  :quant-instantiations    38
;  :rlimit-count            123079
;  :time                    0.00)
(push) ; 7
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
      0)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1082
;  :arith-add-rows          5
;  :arith-assert-diseq      22
;  :arith-assert-lower      73
;  :arith-assert-upper      48
;  :arith-conflicts         10
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         20
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 205
;  :datatype-occurs-check   98
;  :datatype-splits         146
;  :decisions               190
;  :del-clause              94
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             666
;  :mk-clause               109
;  :num-allocs              3563600
;  :num-checks              101
;  :propagations            60
;  :quant-instantiations    40
;  :rlimit-count            124073
;  :time                    0.00)
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:(Second:($t@29@02))))))[First:(Second:(Second:(Second:($t@29@02))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@29@02))))[0] | live]
; [else-branch: 22 | !(First:(Second:(Second:(Second:(Second:(Second:($t@29@02))))))[First:(Second:(Second:(Second:($t@29@02))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@29@02))))[0]) | live]
(push) ; 7
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:(Second:($t@29@02))))))[First:(Second:(Second:(Second:($t@29@02))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@29@02))))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1083
;  :arith-add-rows          5
;  :arith-assert-diseq      22
;  :arith-assert-lower      74
;  :arith-assert-upper      48
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         20
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 205
;  :datatype-occurs-check   98
;  :datatype-splits         146
;  :decisions               190
;  :del-clause              94
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             673
;  :mk-clause               116
;  :num-allocs              3563600
;  :num-checks              102
;  :propagations            60
;  :quant-instantiations    42
;  :rlimit-count            124290)
; [eval] -1
(pop) ; 7
(push) ; 7
; [else-branch: 22 | !(First:(Second:(Second:(Second:(Second:(Second:($t@29@02))))))[First:(Second:(Second:(Second:($t@29@02))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@29@02))))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
        0)))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@02))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1084
;  :arith-add-rows          5
;  :arith-assert-diseq      22
;  :arith-assert-lower      74
;  :arith-assert-upper      48
;  :arith-conflicts         10
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         20
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 205
;  :datatype-occurs-check   98
;  :datatype-splits         146
;  :decisions               190
;  :del-clause              101
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             677
;  :mk-clause               117
;  :num-allocs              3563600
;  :num-checks              103
;  :propagations            60
;  :quant-instantiations    42
;  :rlimit-count            124698)
(push) ; 6
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@29@02))))[0] | live]
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@29@02))))[0]) | live]
(push) ; 7
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@29@02))))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1084
;  :arith-add-rows          5
;  :arith-assert-diseq      22
;  :arith-assert-lower      75
;  :arith-assert-upper      48
;  :arith-conflicts         10
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         20
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 205
;  :datatype-occurs-check   98
;  :datatype-splits         146
;  :decisions               190
;  :del-clause              101
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             682
;  :mk-clause               124
;  :num-allocs              3563600
;  :num-checks              104
;  :propagations            60
;  :quant-instantiations    44
;  :rlimit-count            124828)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1084
;  :arith-add-rows          5
;  :arith-assert-diseq      22
;  :arith-assert-lower      75
;  :arith-assert-upper      48
;  :arith-conflicts         10
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         20
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 205
;  :datatype-occurs-check   98
;  :datatype-splits         146
;  :decisions               190
;  :del-clause              101
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             682
;  :mk-clause               124
;  :num-allocs              3563600
;  :num-checks              105
;  :propagations            60
;  :quant-instantiations    44
;  :rlimit-count            124837)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1085
;  :arith-add-rows          5
;  :arith-assert-diseq      22
;  :arith-assert-lower      76
;  :arith-assert-upper      49
;  :arith-conflicts         11
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         20
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               49
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 205
;  :datatype-occurs-check   98
;  :datatype-splits         146
;  :decisions               190
;  :del-clause              101
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             682
;  :mk-clause               124
;  :num-allocs              3563600
;  :num-checks              106
;  :propagations            64
;  :quant-instantiations    44
;  :rlimit-count            124955)
(pop) ; 7
(push) ; 7
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@29@02))))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
      0)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1178
;  :arith-add-rows          5
;  :arith-assert-diseq      22
;  :arith-assert-lower      77
;  :arith-assert-upper      51
;  :arith-conflicts         11
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         20
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               49
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 229
;  :datatype-occurs-check   111
;  :datatype-splits         166
;  :decisions               213
;  :del-clause              111
;  :final-checks            47
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             707
;  :mk-clause               127
;  :num-allocs              3563600
;  :num-checks              107
;  :propagations            67
;  :quant-instantiations    46
;  :rlimit-count            125954
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
        0))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1324
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      84
;  :arith-assert-upper      55
;  :arith-conflicts         11
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        1
;  :arith-pivots            12
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   128
;  :datatype-splits         190
;  :decisions               247
;  :del-clause              126
;  :final-checks            52
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             762
;  :mk-clause               142
;  :num-allocs              3563600
;  :num-checks              108
;  :propagations            75
;  :quant-instantiations    50
;  :rlimit-count            127230
;  :time                    0.00)
; [then-branch: 24 | !(First:(Second:(Second:(Second:(Second:(Second:($t@29@02))))))[First:(Second:(Second:(Second:($t@29@02))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@29@02))))[0]) | live]
; [else-branch: 24 | First:(Second:(Second:(Second:(Second:(Second:($t@29@02))))))[First:(Second:(Second:(Second:($t@29@02))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@29@02))))[0] | live]
(push) ; 7
; [then-branch: 24 | !(First:(Second:(Second:(Second:(Second:(Second:($t@29@02))))))[First:(Second:(Second:(Second:($t@29@02))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@29@02))))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1324
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      84
;  :arith-assert-upper      55
;  :arith-conflicts         11
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        1
;  :arith-pivots            12
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   128
;  :datatype-splits         190
;  :decisions               247
;  :del-clause              126
;  :final-checks            52
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             762
;  :mk-clause               143
;  :num-allocs              3563600
;  :num-checks              109
;  :propagations            75
;  :quant-instantiations    50
;  :rlimit-count            127429)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1324
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      84
;  :arith-assert-upper      55
;  :arith-conflicts         11
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        1
;  :arith-pivots            12
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   128
;  :datatype-splits         190
;  :decisions               247
;  :del-clause              126
;  :final-checks            52
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             762
;  :mk-clause               143
;  :num-allocs              3563600
;  :num-checks              110
;  :propagations            75
;  :quant-instantiations    50
;  :rlimit-count            127444)
(pop) ; 7
(push) ; 7
; [else-branch: 24 | First:(Second:(Second:(Second:(Second:(Second:($t@29@02))))))[First:(Second:(Second:(Second:($t@29@02))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@29@02))))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
            0))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))
      0))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; Main_reset_events_no_delta_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@36@02 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 25 | 0 <= i@36@02 | live]
; [else-branch: 25 | !(0 <= i@36@02) | live]
(push) ; 8
; [then-branch: 25 | 0 <= i@36@02]
(assert (<= 0 i@36@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 25 | !(0 <= i@36@02)]
(assert (not (<= 0 i@36@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 26 | i@36@02 < |First:(Second:($t@34@02))| && 0 <= i@36@02 | live]
; [else-branch: 26 | !(i@36@02 < |First:(Second:($t@34@02))| && 0 <= i@36@02) | live]
(push) ; 8
; [then-branch: 26 | i@36@02 < |First:(Second:($t@34@02))| && 0 <= i@36@02]
(assert (and
  (<
    i@36@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))))
  (<= 0 i@36@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@36@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1422
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      87
;  :arith-assert-upper      59
;  :arith-bound-prop        2
;  :arith-conflicts         11
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        1
;  :arith-pivots            14
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   141
;  :datatype-splits         210
;  :decisions               270
;  :del-clause              145
;  :final-checks            55
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             801
;  :mk-clause               159
;  :num-allocs              3563600
;  :num-checks              112
;  :propagations            81
;  :quant-instantiations    53
;  :rlimit-count            128707)
; [eval] -1
(push) ; 9
; [then-branch: 27 | First:(Second:($t@34@02))[i@36@02] == -1 | live]
; [else-branch: 27 | First:(Second:($t@34@02))[i@36@02] != -1 | live]
(push) ; 10
; [then-branch: 27 | First:(Second:($t@34@02))[i@36@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
    i@36@02)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 27 | First:(Second:($t@34@02))[i@36@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
      i@36@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@36@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1424
;  :arith-add-rows          5
;  :arith-assert-diseq      26
;  :arith-assert-lower      90
;  :arith-assert-upper      60
;  :arith-bound-prop        2
;  :arith-conflicts         11
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        1
;  :arith-pivots            14
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   141
;  :datatype-splits         210
;  :decisions               270
;  :del-clause              145
;  :final-checks            55
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             805
;  :mk-clause               167
;  :num-allocs              3563600
;  :num-checks              113
;  :propagations            85
;  :quant-instantiations    54
;  :rlimit-count            128875)
(push) ; 11
; [then-branch: 28 | 0 <= First:(Second:($t@34@02))[i@36@02] | live]
; [else-branch: 28 | !(0 <= First:(Second:($t@34@02))[i@36@02]) | live]
(push) ; 12
; [then-branch: 28 | 0 <= First:(Second:($t@34@02))[i@36@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
    i@36@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@36@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1426
;  :arith-add-rows          5
;  :arith-assert-diseq      26
;  :arith-assert-lower      92
;  :arith-assert-upper      61
;  :arith-bound-prop        2
;  :arith-conflicts         11
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        1
;  :arith-pivots            15
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   141
;  :datatype-splits         210
;  :decisions               270
;  :del-clause              145
;  :final-checks            55
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             809
;  :mk-clause               167
;  :num-allocs              3563600
;  :num-checks              114
;  :propagations            85
;  :quant-instantiations    54
;  :rlimit-count            128992)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 28 | !(0 <= First:(Second:($t@34@02))[i@36@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
      i@36@02))))
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
; [else-branch: 26 | !(i@36@02 < |First:(Second:($t@34@02))| && 0 <= i@36@02)]
(assert (not
  (and
    (<
      i@36@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))))
    (<= 0 i@36@02))))
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
(assert (not (forall ((i@36@02 Int)) (!
  (implies
    (and
      (<
        i@36@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))))
      (<= 0 i@36@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
          i@36@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
            i@36@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
            i@36@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
    i@36@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1426
;  :arith-add-rows          5
;  :arith-assert-diseq      28
;  :arith-assert-lower      93
;  :arith-assert-upper      62
;  :arith-bound-prop        2
;  :arith-conflicts         11
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   141
;  :datatype-splits         210
;  :decisions               270
;  :del-clause              167
;  :final-checks            55
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             817
;  :mk-clause               181
;  :num-allocs              3563600
;  :num-checks              115
;  :propagations            87
;  :quant-instantiations    55
;  :rlimit-count            129417)
(assert (forall ((i@36@02 Int)) (!
  (implies
    (and
      (<
        i@36@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))))
      (<= 0 i@36@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
          i@36@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
            i@36@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
            i@36@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))
    i@36@02))
  :qid |prog.l<no position>|)))
(declare-const $t@37@02 $Snap)
(assert (= $t@37@02 ($Snap.combine ($Snap.first $t@37@02) ($Snap.second $t@37@02))))
(assert (=
  ($Snap.second $t@37@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@37@02))
    ($Snap.second ($Snap.second $t@37@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@37@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@37@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@37@02))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@37@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@38@02 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 29 | 0 <= i@38@02 | live]
; [else-branch: 29 | !(0 <= i@38@02) | live]
(push) ; 8
; [then-branch: 29 | 0 <= i@38@02]
(assert (<= 0 i@38@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 29 | !(0 <= i@38@02)]
(assert (not (<= 0 i@38@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 30 | i@38@02 < |First:(Second:($t@37@02))| && 0 <= i@38@02 | live]
; [else-branch: 30 | !(i@38@02 < |First:(Second:($t@37@02))| && 0 <= i@38@02) | live]
(push) ; 8
; [then-branch: 30 | i@38@02 < |First:(Second:($t@37@02))| && 0 <= i@38@02]
(assert (and
  (<
    i@38@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
  (<= 0 i@38@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@38@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1464
;  :arith-add-rows          5
;  :arith-assert-diseq      28
;  :arith-assert-lower      98
;  :arith-assert-upper      65
;  :arith-bound-prop        2
;  :arith-conflicts         11
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   141
;  :datatype-splits         210
;  :decisions               270
;  :del-clause              167
;  :final-checks            55
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             839
;  :mk-clause               181
;  :num-allocs              3563600
;  :num-checks              116
;  :propagations            87
;  :quant-instantiations    59
;  :rlimit-count            130808)
; [eval] -1
(push) ; 9
; [then-branch: 31 | First:(Second:($t@37@02))[i@38@02] == -1 | live]
; [else-branch: 31 | First:(Second:($t@37@02))[i@38@02] != -1 | live]
(push) ; 10
; [then-branch: 31 | First:(Second:($t@37@02))[i@38@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@38@02)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 31 | First:(Second:($t@37@02))[i@38@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      i@38@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@38@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1464
;  :arith-add-rows          5
;  :arith-assert-diseq      28
;  :arith-assert-lower      98
;  :arith-assert-upper      65
;  :arith-bound-prop        2
;  :arith-conflicts         11
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   141
;  :datatype-splits         210
;  :decisions               270
;  :del-clause              167
;  :final-checks            55
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             840
;  :mk-clause               181
;  :num-allocs              3563600
;  :num-checks              117
;  :propagations            87
;  :quant-instantiations    59
;  :rlimit-count            130959)
(push) ; 11
; [then-branch: 32 | 0 <= First:(Second:($t@37@02))[i@38@02] | live]
; [else-branch: 32 | !(0 <= First:(Second:($t@37@02))[i@38@02]) | live]
(push) ; 12
; [then-branch: 32 | 0 <= First:(Second:($t@37@02))[i@38@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@38@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@38@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1464
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      101
;  :arith-assert-upper      65
;  :arith-bound-prop        2
;  :arith-conflicts         11
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   141
;  :datatype-splits         210
;  :decisions               270
;  :del-clause              167
;  :final-checks            55
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             843
;  :mk-clause               182
;  :num-allocs              3563600
;  :num-checks              118
;  :propagations            87
;  :quant-instantiations    59
;  :rlimit-count            131062)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 32 | !(0 <= First:(Second:($t@37@02))[i@38@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      i@38@02))))
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
; [else-branch: 30 | !(i@38@02 < |First:(Second:($t@37@02))| && 0 <= i@38@02)]
(assert (not
  (and
    (<
      i@38@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
    (<= 0 i@38@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@38@02 Int)) (!
  (implies
    (and
      (<
        i@38@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
      (<= 0 i@38@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          i@38@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@38@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@38@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@38@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@34@02)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
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
; (:added-eqs               1482
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      102
;  :arith-assert-upper      66
;  :arith-bound-prop        2
;  :arith-conflicts         11
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        1
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   141
;  :datatype-splits         210
;  :decisions               270
;  :del-clause              168
;  :final-checks            55
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.10
;  :memory                  4.10
;  :mk-bool-var             863
;  :mk-clause               192
;  :num-allocs              3563600
;  :num-checks              119
;  :propagations            91
;  :quant-instantiations    61
;  :rlimit-count            132077)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1658
;  :arith-add-rows          7
;  :arith-assert-diseq      29
;  :arith-assert-lower      105
;  :arith-assert-upper      70
;  :arith-bound-prop        4
;  :arith-conflicts         11
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        1
;  :arith-pivots            19
;  :binary-propagations     7
;  :conflicts               53
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 334
;  :datatype-occurs-check   156
;  :datatype-splits         235
;  :decisions               312
;  :del-clause              185
;  :final-checks            58
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             908
;  :mk-clause               209
;  :num-allocs              3697617
;  :num-checks              120
;  :propagations            102
;  :quant-instantiations    66
;  :rlimit-count            133472
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1833
;  :arith-add-rows          9
;  :arith-assert-diseq      29
;  :arith-assert-lower      108
;  :arith-assert-upper      74
;  :arith-bound-prop        6
;  :arith-conflicts         11
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        1
;  :arith-pivots            21
;  :binary-propagations     7
;  :conflicts               54
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 378
;  :datatype-occurs-check   171
;  :datatype-splits         260
;  :decisions               354
;  :del-clause              202
;  :final-checks            61
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             953
;  :mk-clause               226
;  :num-allocs              3697617
;  :num-checks              121
;  :propagations            113
;  :quant-instantiations    71
;  :rlimit-count            134842
;  :time                    0.00)
; [then-branch: 33 | First:(Second:(Second:(Second:($t@34@02))))[0] == 0 | live]
; [else-branch: 33 | First:(Second:(Second:(Second:($t@34@02))))[0] != 0 | live]
(push) ; 7
; [then-branch: 33 | First:(Second:(Second:(Second:($t@34@02))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    0)
  0))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1834
;  :arith-add-rows          9
;  :arith-assert-diseq      29
;  :arith-assert-lower      108
;  :arith-assert-upper      74
;  :arith-bound-prop        6
;  :arith-conflicts         11
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        1
;  :arith-pivots            21
;  :binary-propagations     7
;  :conflicts               54
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 378
;  :datatype-occurs-check   171
;  :datatype-splits         260
;  :decisions               354
;  :del-clause              202
;  :final-checks            61
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             954
;  :mk-clause               226
;  :num-allocs              3697617
;  :num-checks              122
;  :propagations            113
;  :quant-instantiations    71
;  :rlimit-count            134970)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 33 | First:(Second:(Second:(Second:($t@34@02))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      0)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 6
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1840
;  :arith-add-rows          9
;  :arith-assert-diseq      29
;  :arith-assert-lower      108
;  :arith-assert-upper      74
;  :arith-bound-prop        6
;  :arith-conflicts         11
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        1
;  :arith-pivots            21
;  :binary-propagations     7
;  :conflicts               54
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 378
;  :datatype-occurs-check   171
;  :datatype-splits         260
;  :decisions               354
;  :del-clause              202
;  :final-checks            61
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             958
;  :mk-clause               227
;  :num-allocs              3697617
;  :num-checks              123
;  :propagations            113
;  :quant-instantiations    71
;  :rlimit-count            135405)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2014
;  :arith-add-rows          11
;  :arith-assert-diseq      29
;  :arith-assert-lower      111
;  :arith-assert-upper      78
;  :arith-bound-prop        8
;  :arith-conflicts         11
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        1
;  :arith-pivots            23
;  :binary-propagations     7
;  :conflicts               55
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 422
;  :datatype-occurs-check   187
;  :datatype-splits         285
;  :decisions               397
;  :del-clause              219
;  :final-checks            64
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1003
;  :mk-clause               244
;  :num-allocs              3697617
;  :num-checks              124
;  :propagations            124
;  :quant-instantiations    76
;  :rlimit-count            136782
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2187
;  :arith-add-rows          13
;  :arith-assert-diseq      29
;  :arith-assert-lower      114
;  :arith-assert-upper      82
;  :arith-bound-prop        10
;  :arith-conflicts         11
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        1
;  :arith-pivots            25
;  :binary-propagations     7
;  :conflicts               56
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 466
;  :datatype-occurs-check   203
;  :datatype-splits         310
;  :decisions               440
;  :del-clause              236
;  :final-checks            67
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1048
;  :mk-clause               261
;  :num-allocs              3697617
;  :num-checks              125
;  :propagations            135
;  :quant-instantiations    81
;  :rlimit-count            138168
;  :time                    0.00)
; [then-branch: 34 | First:(Second:(Second:(Second:($t@34@02))))[1] == 0 | live]
; [else-branch: 34 | First:(Second:(Second:(Second:($t@34@02))))[1] != 0 | live]
(push) ; 7
; [then-branch: 34 | First:(Second:(Second:(Second:($t@34@02))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    1)
  0))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2188
;  :arith-add-rows          13
;  :arith-assert-diseq      29
;  :arith-assert-lower      114
;  :arith-assert-upper      82
;  :arith-bound-prop        10
;  :arith-conflicts         11
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        1
;  :arith-pivots            25
;  :binary-propagations     7
;  :conflicts               56
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 466
;  :datatype-occurs-check   203
;  :datatype-splits         310
;  :decisions               440
;  :del-clause              236
;  :final-checks            67
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1049
;  :mk-clause               261
;  :num-allocs              3697617
;  :num-checks              126
;  :propagations            135
;  :quant-instantiations    81
;  :rlimit-count            138296)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 34 | First:(Second:(Second:(Second:($t@34@02))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      1)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2194
;  :arith-add-rows          13
;  :arith-assert-diseq      29
;  :arith-assert-lower      114
;  :arith-assert-upper      82
;  :arith-bound-prop        10
;  :arith-conflicts         11
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        1
;  :arith-pivots            25
;  :binary-propagations     7
;  :conflicts               56
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 466
;  :datatype-occurs-check   203
;  :datatype-splits         310
;  :decisions               440
;  :del-clause              236
;  :final-checks            67
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1053
;  :mk-clause               262
;  :num-allocs              3697617
;  :num-checks              127
;  :propagations            135
;  :quant-instantiations    81
;  :rlimit-count            138737)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2369
;  :arith-add-rows          15
;  :arith-assert-diseq      29
;  :arith-assert-lower      117
;  :arith-assert-upper      86
;  :arith-bound-prop        12
;  :arith-conflicts         11
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        1
;  :arith-pivots            27
;  :binary-propagations     7
;  :conflicts               57
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 510
;  :datatype-occurs-check   219
;  :datatype-splits         335
;  :decisions               483
;  :del-clause              253
;  :final-checks            70
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1097
;  :mk-clause               279
;  :num-allocs              3697617
;  :num-checks              128
;  :propagations            146
;  :quant-instantiations    86
;  :rlimit-count            140117
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2556
;  :arith-add-rows          17
;  :arith-assert-diseq      29
;  :arith-assert-lower      120
;  :arith-assert-upper      90
;  :arith-bound-prop        14
;  :arith-conflicts         11
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               59
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 557
;  :datatype-occurs-check   240
;  :datatype-splits         362
;  :decisions               528
;  :del-clause              271
;  :final-checks            74
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1153
;  :mk-clause               297
;  :num-allocs              3697617
;  :num-checks              129
;  :propagations            158
;  :quant-instantiations    91
;  :rlimit-count            141550
;  :time                    0.00)
; [then-branch: 35 | First:(Second:(Second:(Second:($t@34@02))))[0] != 0 | live]
; [else-branch: 35 | First:(Second:(Second:(Second:($t@34@02))))[0] == 0 | live]
(push) ; 7
; [then-branch: 35 | First:(Second:(Second:(Second:($t@34@02))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      0)
    0)))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2556
;  :arith-add-rows          17
;  :arith-assert-diseq      29
;  :arith-assert-lower      120
;  :arith-assert-upper      90
;  :arith-bound-prop        14
;  :arith-conflicts         11
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               59
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 557
;  :datatype-occurs-check   240
;  :datatype-splits         362
;  :decisions               528
;  :del-clause              271
;  :final-checks            74
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1153
;  :mk-clause               297
;  :num-allocs              3697617
;  :num-checks              130
;  :propagations            158
;  :quant-instantiations    91
;  :rlimit-count            141680)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2556
;  :arith-add-rows          17
;  :arith-assert-diseq      29
;  :arith-assert-lower      120
;  :arith-assert-upper      90
;  :arith-bound-prop        14
;  :arith-conflicts         11
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               59
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 557
;  :datatype-occurs-check   240
;  :datatype-splits         362
;  :decisions               528
;  :del-clause              271
;  :final-checks            74
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1153
;  :mk-clause               297
;  :num-allocs              3697617
;  :num-checks              131
;  :propagations            158
;  :quant-instantiations    91
;  :rlimit-count            141695)
(pop) ; 7
(push) ; 7
; [else-branch: 35 | First:(Second:(Second:(Second:($t@34@02))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
        0)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2561
;  :arith-add-rows          17
;  :arith-assert-diseq      29
;  :arith-assert-lower      120
;  :arith-assert-upper      90
;  :arith-bound-prop        14
;  :arith-conflicts         11
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               59
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 557
;  :datatype-occurs-check   240
;  :datatype-splits         362
;  :decisions               528
;  :del-clause              271
;  :final-checks            74
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1155
;  :mk-clause               298
;  :num-allocs              3697617
;  :num-checks              132
;  :propagations            158
;  :quant-instantiations    91
;  :rlimit-count            142015)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2732
;  :arith-add-rows          19
;  :arith-assert-diseq      29
;  :arith-assert-lower      123
;  :arith-assert-upper      94
;  :arith-bound-prop        16
;  :arith-conflicts         11
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        1
;  :arith-pivots            31
;  :binary-propagations     7
;  :conflicts               60
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 600
;  :datatype-occurs-check   254
;  :datatype-splits         386
;  :decisions               570
;  :del-clause              288
;  :final-checks            77
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1198
;  :mk-clause               315
;  :num-allocs              3697617
;  :num-checks              133
;  :propagations            170
;  :quant-instantiations    96
;  :rlimit-count            143390
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2916
;  :arith-add-rows          21
;  :arith-assert-diseq      29
;  :arith-assert-lower      126
;  :arith-assert-upper      98
;  :arith-bound-prop        18
;  :arith-conflicts         11
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        1
;  :arith-pivots            33
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    126
;  :datatype-constructor-ax 646
;  :datatype-occurs-check   272
;  :datatype-splits         412
;  :decisions               614
;  :del-clause              306
;  :final-checks            81
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1253
;  :mk-clause               333
;  :num-allocs              3697617
;  :num-checks              134
;  :propagations            183
;  :quant-instantiations    101
;  :rlimit-count            144815
;  :time                    0.00)
; [then-branch: 36 | First:(Second:(Second:(Second:($t@34@02))))[1] != 0 | live]
; [else-branch: 36 | First:(Second:(Second:(Second:($t@34@02))))[1] == 0 | live]
(push) ; 7
; [then-branch: 36 | First:(Second:(Second:(Second:($t@34@02))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      1)
    0)))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2916
;  :arith-add-rows          21
;  :arith-assert-diseq      29
;  :arith-assert-lower      126
;  :arith-assert-upper      98
;  :arith-bound-prop        18
;  :arith-conflicts         11
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        1
;  :arith-pivots            33
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    126
;  :datatype-constructor-ax 646
;  :datatype-occurs-check   272
;  :datatype-splits         412
;  :decisions               614
;  :del-clause              306
;  :final-checks            81
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1253
;  :mk-clause               333
;  :num-allocs              3697617
;  :num-checks              135
;  :propagations            183
;  :quant-instantiations    101
;  :rlimit-count            144945)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2916
;  :arith-add-rows          21
;  :arith-assert-diseq      29
;  :arith-assert-lower      126
;  :arith-assert-upper      98
;  :arith-bound-prop        18
;  :arith-conflicts         11
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        1
;  :arith-pivots            33
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    126
;  :datatype-constructor-ax 646
;  :datatype-occurs-check   272
;  :datatype-splits         412
;  :decisions               614
;  :del-clause              306
;  :final-checks            81
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1253
;  :mk-clause               333
;  :num-allocs              3697617
;  :num-checks              136
;  :propagations            183
;  :quant-instantiations    101
;  :rlimit-count            144960)
(pop) ; 7
(push) ; 7
; [else-branch: 36 | First:(Second:(Second:(Second:($t@34@02))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
        1)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@02)))))
      1))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] diz.Main_process_state[0] != -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3088
;  :arith-add-rows          23
;  :arith-assert-diseq      29
;  :arith-assert-lower      129
;  :arith-assert-upper      102
;  :arith-bound-prop        20
;  :arith-conflicts         11
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         44
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               63
;  :datatype-accessor-ax    129
;  :datatype-constructor-ax 689
;  :datatype-occurs-check   286
;  :datatype-splits         436
;  :decisions               657
;  :del-clause              330
;  :final-checks            84
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1299
;  :mk-clause               352
;  :num-allocs              3697617
;  :num-checks              138
;  :propagations            196
;  :quant-instantiations    106
;  :rlimit-count            146455)
; [eval] -1
(set-option :timeout 10)
(push) ; 6
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3211
;  :arith-add-rows          27
;  :arith-assert-diseq      33
;  :arith-assert-lower      145
;  :arith-assert-upper      110
;  :arith-bound-prop        20
;  :arith-conflicts         11
;  :arith-eq-adapter        87
;  :arith-fixed-eqs         47
;  :arith-offset-eqs        1
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    132
;  :datatype-constructor-ax 717
;  :datatype-occurs-check   300
;  :datatype-splits         460
;  :decisions               686
;  :del-clause              355
;  :final-checks            88
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             1350
;  :mk-clause               377
;  :num-allocs              3697617
;  :num-checks              139
;  :propagations            219
;  :quant-instantiations    113
;  :rlimit-count            147793
;  :time                    0.00)
(push) ; 6
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3415
;  :arith-add-rows          28
;  :arith-assert-diseq      38
;  :arith-assert-lower      157
;  :arith-assert-upper      115
;  :arith-bound-prop        24
;  :arith-conflicts         11
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         51
;  :arith-offset-eqs        1
;  :arith-pivots            44
;  :binary-propagations     7
;  :conflicts               69
;  :datatype-accessor-ax    139
;  :datatype-constructor-ax 765
;  :datatype-occurs-check   322
;  :datatype-splits         492
;  :decisions               731
;  :del-clause              385
;  :final-checks            94
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.20
;  :memory                  4.20
;  :minimized-lits          1
;  :mk-bool-var             1431
;  :mk-clause               407
;  :num-allocs              3697617
;  :num-checks              140
;  :propagations            236
;  :quant-instantiations    117
;  :rlimit-count            149308
;  :time                    0.00)
; [then-branch: 37 | First:(Second:($t@37@02))[0] != -1 | live]
; [else-branch: 37 | First:(Second:($t@37@02))[0] == -1 | live]
(push) ; 6
; [then-branch: 37 | First:(Second:($t@37@02))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0)
    (- 0 1))))
; [exec]
; min_advance__29 := Main_find_minimum_advance_Sequence$Integer$(diz, diz.Main_event_state)
; [eval] Main_find_minimum_advance_Sequence$Integer$(diz, diz.Main_event_state)
(push) ; 7
; [eval] diz != null
; [eval] |vals| == 2
; [eval] |vals|
(pop) ; 7
; Joined path conditions
(declare-const min_advance__29@39@02 Int)
(assert (=
  min_advance__29@39@02
  (Main_find_minimum_advance_Sequence$Integer$ ($Snap.combine
    $Snap.unit
    $Snap.unit) diz@8@02 ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02))))))))
; [eval] min_advance__29 == -1
; [eval] -1
(push) ; 7
(assert (not (not (= min_advance__29@39@02 (- 0 1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3556
;  :arith-add-rows          31
;  :arith-assert-diseq      54
;  :arith-assert-lower      180
;  :arith-assert-upper      132
;  :arith-bound-prop        24
;  :arith-conflicts         12
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         55
;  :arith-offset-eqs        1
;  :arith-pivots            49
;  :binary-propagations     7
;  :conflicts               71
;  :datatype-accessor-ax    143
;  :datatype-constructor-ax 793
;  :datatype-occurs-check   336
;  :datatype-splits         516
;  :decisions               764
;  :del-clause              415
;  :final-checks            98
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1518
;  :mk-clause               491
;  :num-allocs              3844192
;  :num-checks              141
;  :propagations            280
;  :quant-instantiations    127
;  :rlimit-count            151137
;  :time                    0.00)
(push) ; 7
(assert (not (= min_advance__29@39@02 (- 0 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3683
;  :arith-add-rows          31
;  :arith-assert-diseq      67
;  :arith-assert-lower      195
;  :arith-assert-upper      144
;  :arith-bound-prop        26
;  :arith-conflicts         12
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         56
;  :arith-offset-eqs        2
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               72
;  :datatype-accessor-ax    146
;  :datatype-constructor-ax 821
;  :datatype-occurs-check   350
;  :datatype-splits         540
;  :decisions               796
;  :del-clause              449
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1572
;  :mk-clause               525
;  :num-allocs              3844192
;  :num-checks              142
;  :propagations            312
;  :quant-instantiations    131
;  :rlimit-count            152375
;  :time                    0.00)
; [then-branch: 38 | min_advance__29@39@02 == -1 | live]
; [else-branch: 38 | min_advance__29@39@02 != -1 | live]
(push) ; 7
; [then-branch: 38 | min_advance__29@39@02 == -1]
(assert (= min_advance__29@39@02 (- 0 1)))
; [exec]
; min_advance__29 := 0
; [exec]
; __flatten_26__28 := Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__29), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__29))
; [eval] Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__29), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__29))
; [eval] (diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__29)
; [eval] diz.Main_event_state[0] < -1
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3685
;  :arith-add-rows          31
;  :arith-assert-diseq      68
;  :arith-assert-lower      196
;  :arith-assert-upper      147
;  :arith-bound-prop        26
;  :arith-conflicts         12
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         56
;  :arith-offset-eqs        2
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               72
;  :datatype-accessor-ax    146
;  :datatype-constructor-ax 821
;  :datatype-occurs-check   350
;  :datatype-splits         540
;  :decisions               796
;  :del-clause              449
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1576
;  :mk-clause               525
;  :num-allocs              3844192
;  :num-checks              143
;  :propagations            313
;  :quant-instantiations    131
;  :rlimit-count            152456)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3810
;  :arith-add-rows          31
;  :arith-assert-diseq      78
;  :arith-assert-lower      211
;  :arith-assert-upper      158
;  :arith-bound-prop        28
;  :arith-conflicts         13
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         59
;  :arith-offset-eqs        2
;  :arith-pivots            54
;  :binary-propagations     7
;  :conflicts               74
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   364
;  :datatype-splits         564
;  :decisions               826
;  :del-clause              467
;  :final-checks            106
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1627
;  :mk-clause               543
;  :num-allocs              3844192
;  :num-checks              144
;  :propagations            340
;  :quant-instantiations    135
;  :rlimit-count            153719
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          31
;  :arith-assert-diseq      88
;  :arith-assert-lower      224
;  :arith-assert-upper      169
;  :arith-bound-prop        30
;  :arith-conflicts         13
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         62
;  :arith-offset-eqs        2
;  :arith-pivots            56
;  :binary-propagations     7
;  :conflicts               75
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 877
;  :datatype-occurs-check   378
;  :datatype-splits         588
;  :decisions               857
;  :del-clause              491
;  :final-checks            110
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1679
;  :mk-clause               567
;  :num-allocs              3844192
;  :num-checks              145
;  :propagations            367
;  :quant-instantiations    139
;  :rlimit-count            154970
;  :time                    0.00)
; [then-branch: 39 | First:(Second:(Second:(Second:($t@37@02))))[0] < -1 | live]
; [else-branch: 39 | !(First:(Second:(Second:(Second:($t@37@02))))[0] < -1) | live]
(push) ; 9
; [then-branch: 39 | First:(Second:(Second:(Second:($t@37@02))))[0] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
    0)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 39 | !(First:(Second:(Second:(Second:($t@37@02))))[0] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] - min_advance__29
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          31
;  :arith-assert-diseq      88
;  :arith-assert-lower      225
;  :arith-assert-upper      170
;  :arith-bound-prop        30
;  :arith-conflicts         13
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         62
;  :arith-offset-eqs        2
;  :arith-pivots            56
;  :binary-propagations     7
;  :conflicts               75
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 877
;  :datatype-occurs-check   378
;  :datatype-splits         588
;  :decisions               857
;  :del-clause              491
;  :final-checks            110
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1679
;  :mk-clause               567
;  :num-allocs              3844192
;  :num-checks              146
;  :propagations            369
;  :quant-instantiations    139
;  :rlimit-count            155133)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
; [eval] (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__29)
; [eval] diz.Main_event_state[1] < -1
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          31
;  :arith-assert-diseq      88
;  :arith-assert-lower      225
;  :arith-assert-upper      170
;  :arith-bound-prop        30
;  :arith-conflicts         13
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         62
;  :arith-offset-eqs        2
;  :arith-pivots            56
;  :binary-propagations     7
;  :conflicts               75
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 877
;  :datatype-occurs-check   378
;  :datatype-splits         588
;  :decisions               857
;  :del-clause              491
;  :final-checks            110
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1679
;  :mk-clause               567
;  :num-allocs              3844192
;  :num-checks              147
;  :propagations            369
;  :quant-instantiations    139
;  :rlimit-count            155148)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4060
;  :arith-add-rows          31
;  :arith-assert-diseq      98
;  :arith-assert-lower      240
;  :arith-assert-upper      181
;  :arith-bound-prop        32
;  :arith-conflicts         14
;  :arith-eq-adapter        144
;  :arith-fixed-eqs         65
;  :arith-offset-eqs        2
;  :arith-pivots            58
;  :binary-propagations     7
;  :conflicts               77
;  :datatype-accessor-ax    155
;  :datatype-constructor-ax 905
;  :datatype-occurs-check   392
;  :datatype-splits         612
;  :decisions               887
;  :del-clause              509
;  :final-checks            114
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1730
;  :mk-clause               585
;  :num-allocs              3844192
;  :num-checks              148
;  :propagations            396
;  :quant-instantiations    143
;  :rlimit-count            156411
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
    1)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4189
;  :arith-add-rows          31
;  :arith-assert-diseq      111
;  :arith-assert-lower      256
;  :arith-assert-upper      195
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        153
;  :arith-fixed-eqs         67
;  :arith-offset-eqs        3
;  :arith-pivots            60
;  :binary-propagations     7
;  :conflicts               79
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              534
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1783
;  :mk-clause               610
;  :num-allocs              3844192
;  :num-checks              149
;  :propagations            430
;  :quant-instantiations    147
;  :rlimit-count            157728
;  :time                    0.00)
; [then-branch: 40 | First:(Second:(Second:(Second:($t@37@02))))[1] < -1 | live]
; [else-branch: 40 | !(First:(Second:(Second:(Second:($t@37@02))))[1] < -1) | live]
(push) ; 9
; [then-branch: 40 | First:(Second:(Second:(Second:($t@37@02))))[1] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
    1)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 40 | !(First:(Second:(Second:(Second:($t@37@02))))[1] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] - min_advance__29
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4189
;  :arith-add-rows          31
;  :arith-assert-diseq      111
;  :arith-assert-lower      257
;  :arith-assert-upper      196
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        153
;  :arith-fixed-eqs         67
;  :arith-offset-eqs        3
;  :arith-pivots            60
;  :binary-propagations     7
;  :conflicts               79
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              534
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1783
;  :mk-clause               610
;  :num-allocs              3844192
;  :num-checks              150
;  :propagations            432
;  :quant-instantiations    147
;  :rlimit-count            157891)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (=
  (Seq_length
    (Seq_append
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
            0)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
          0)))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
            1)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
          1)))))
  2))
(declare-const __flatten_26__28@40@02 Seq<Int>)
(assert (Seq_equal
  __flatten_26__28@40@02
  (Seq_append
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
          0)
        (- 0 1))
      (- 0 3)
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
        0)))
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
          1)
        (- 0 1))
      (- 0 3)
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
        1))))))
; [exec]
; __flatten_25__27 := __flatten_26__28
; [exec]
; diz.Main_event_state := __flatten_25__27
; [exec]
; Main_wakeup_after_wait_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(push) ; 8
(assert (not (= (Seq_length __flatten_26__28@40@02) 2)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4196
;  :arith-add-rows          32
;  :arith-assert-diseq      111
;  :arith-assert-lower      260
;  :arith-assert-upper      198
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        157
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            61
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              534
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1814
;  :mk-clause               630
;  :num-allocs              3844192
;  :num-checks              151
;  :propagations            437
;  :quant-instantiations    151
;  :rlimit-count            158569)
(assert (= (Seq_length __flatten_26__28@40@02) 2))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@41@02 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 41 | 0 <= i@41@02 | live]
; [else-branch: 41 | !(0 <= i@41@02) | live]
(push) ; 10
; [then-branch: 41 | 0 <= i@41@02]
(assert (<= 0 i@41@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 41 | !(0 <= i@41@02)]
(assert (not (<= 0 i@41@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 42 | i@41@02 < |First:(Second:($t@37@02))| && 0 <= i@41@02 | live]
; [else-branch: 42 | !(i@41@02 < |First:(Second:($t@37@02))| && 0 <= i@41@02) | live]
(push) ; 10
; [then-branch: 42 | i@41@02 < |First:(Second:($t@37@02))| && 0 <= i@41@02]
(assert (and
  (<
    i@41@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
  (<= 0 i@41@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@41@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4198
;  :arith-add-rows          32
;  :arith-assert-diseq      111
;  :arith-assert-lower      262
;  :arith-assert-upper      200
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        158
;  :arith-fixed-eqs         69
;  :arith-offset-eqs        3
;  :arith-pivots            61
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              534
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1819
;  :mk-clause               630
;  :num-allocs              3844192
;  :num-checks              152
;  :propagations            437
;  :quant-instantiations    151
;  :rlimit-count            158760)
; [eval] -1
(push) ; 11
; [then-branch: 43 | First:(Second:($t@37@02))[i@41@02] == -1 | live]
; [else-branch: 43 | First:(Second:($t@37@02))[i@41@02] != -1 | live]
(push) ; 12
; [then-branch: 43 | First:(Second:($t@37@02))[i@41@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@41@02)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 43 | First:(Second:($t@37@02))[i@41@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      i@41@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@41@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4200
;  :arith-add-rows          32
;  :arith-assert-diseq      112
;  :arith-assert-lower      262
;  :arith-assert-upper      200
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        158
;  :arith-fixed-eqs         69
;  :arith-offset-eqs        3
;  :arith-pivots            61
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              534
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1820
;  :mk-clause               630
;  :num-allocs              3844192
;  :num-checks              153
;  :propagations            437
;  :quant-instantiations    151
;  :rlimit-count            158908)
(push) ; 13
; [then-branch: 44 | 0 <= First:(Second:($t@37@02))[i@41@02] | live]
; [else-branch: 44 | !(0 <= First:(Second:($t@37@02))[i@41@02]) | live]
(push) ; 14
; [then-branch: 44 | 0 <= First:(Second:($t@37@02))[i@41@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@41@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@41@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4202
;  :arith-add-rows          33
;  :arith-assert-diseq      112
;  :arith-assert-lower      264
;  :arith-assert-upper      201
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        3
;  :arith-pivots            62
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              534
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1824
;  :mk-clause               630
;  :num-allocs              3844192
;  :num-checks              154
;  :propagations            437
;  :quant-instantiations    151
;  :rlimit-count            159025)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 44 | !(0 <= First:(Second:($t@37@02))[i@41@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      i@41@02))))
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
; [else-branch: 42 | !(i@41@02 < |First:(Second:($t@37@02))| && 0 <= i@41@02)]
(assert (not
  (and
    (<
      i@41@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
    (<= 0 i@41@02))))
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
(assert (not (forall ((i@41@02 Int)) (!
  (implies
    (and
      (<
        i@41@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
      (<= 0 i@41@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          i@41@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@41@02)
          (Seq_length __flatten_26__28@40@02))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@41@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@41@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4202
;  :arith-add-rows          33
;  :arith-assert-diseq      114
;  :arith-assert-lower      265
;  :arith-assert-upper      202
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        3
;  :arith-pivots            63
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              561
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1838
;  :mk-clause               657
;  :num-allocs              3844192
;  :num-checks              155
;  :propagations            439
;  :quant-instantiations    154
;  :rlimit-count            159517)
(assert (forall ((i@41@02 Int)) (!
  (implies
    (and
      (<
        i@41@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
      (<= 0 i@41@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          i@41@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@41@02)
          (Seq_length __flatten_26__28@40@02))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@41@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@41@02))
  :qid |prog.l<no position>|)))
(declare-const $t@42@02 $Snap)
(assert (= $t@42@02 ($Snap.combine ($Snap.first $t@42@02) ($Snap.second $t@42@02))))
(assert (=
  ($Snap.second $t@42@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@42@02))
    ($Snap.second ($Snap.second $t@42@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@42@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@42@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@42@02))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@42@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@43@02 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 45 | 0 <= i@43@02 | live]
; [else-branch: 45 | !(0 <= i@43@02) | live]
(push) ; 10
; [then-branch: 45 | 0 <= i@43@02]
(assert (<= 0 i@43@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 45 | !(0 <= i@43@02)]
(assert (not (<= 0 i@43@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 46 | i@43@02 < |First:(Second:($t@42@02))| && 0 <= i@43@02 | live]
; [else-branch: 46 | !(i@43@02 < |First:(Second:($t@42@02))| && 0 <= i@43@02) | live]
(push) ; 10
; [then-branch: 46 | i@43@02 < |First:(Second:($t@42@02))| && 0 <= i@43@02]
(assert (and
  (<
    i@43@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))))
  (<= 0 i@43@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@43@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4240
;  :arith-add-rows          33
;  :arith-assert-diseq      114
;  :arith-assert-lower      270
;  :arith-assert-upper      205
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        163
;  :arith-fixed-eqs         72
;  :arith-offset-eqs        3
;  :arith-pivots            63
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    164
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              561
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1860
;  :mk-clause               657
;  :num-allocs              3844192
;  :num-checks              156
;  :propagations            439
;  :quant-instantiations    159
;  :rlimit-count            160935)
; [eval] -1
(push) ; 11
; [then-branch: 47 | First:(Second:($t@42@02))[i@43@02] == -1 | live]
; [else-branch: 47 | First:(Second:($t@42@02))[i@43@02] != -1 | live]
(push) ; 12
; [then-branch: 47 | First:(Second:($t@42@02))[i@43@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
    i@43@02)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 47 | First:(Second:($t@42@02))[i@43@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
      i@43@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@43@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4240
;  :arith-add-rows          33
;  :arith-assert-diseq      114
;  :arith-assert-lower      270
;  :arith-assert-upper      205
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        163
;  :arith-fixed-eqs         72
;  :arith-offset-eqs        3
;  :arith-pivots            63
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    164
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              561
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1861
;  :mk-clause               657
;  :num-allocs              3844192
;  :num-checks              157
;  :propagations            439
;  :quant-instantiations    159
;  :rlimit-count            161086)
(push) ; 13
; [then-branch: 48 | 0 <= First:(Second:($t@42@02))[i@43@02] | live]
; [else-branch: 48 | !(0 <= First:(Second:($t@42@02))[i@43@02]) | live]
(push) ; 14
; [then-branch: 48 | 0 <= First:(Second:($t@42@02))[i@43@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
    i@43@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@43@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4240
;  :arith-add-rows          33
;  :arith-assert-diseq      115
;  :arith-assert-lower      273
;  :arith-assert-upper      205
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        164
;  :arith-fixed-eqs         72
;  :arith-offset-eqs        3
;  :arith-pivots            63
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    164
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              561
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1864
;  :mk-clause               658
;  :num-allocs              3844192
;  :num-checks              158
;  :propagations            439
;  :quant-instantiations    159
;  :rlimit-count            161190)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 48 | !(0 <= First:(Second:($t@42@02))[i@43@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
      i@43@02))))
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
; [else-branch: 46 | !(i@43@02 < |First:(Second:($t@42@02))| && 0 <= i@43@02)]
(assert (not
  (and
    (<
      i@43@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))))
    (<= 0 i@43@02))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@43@02 Int)) (!
  (implies
    (and
      (<
        i@43@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))))
      (<= 0 i@43@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
          i@43@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
            i@43@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
            i@43@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
    i@43@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
  __flatten_26__28@40@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4261
;  :arith-add-rows          33
;  :arith-assert-diseq      115
;  :arith-assert-lower      274
;  :arith-assert-upper      206
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        166
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        3
;  :arith-pivots            63
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              562
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1888
;  :mk-clause               674
;  :num-allocs              3844192
;  :num-checks              159
;  :propagations            445
;  :quant-instantiations    161
;  :rlimit-count            162215)
(push) ; 8
; [then-branch: 49 | 0 <= First:(Second:($t@37@02))[0] | live]
; [else-branch: 49 | !(0 <= First:(Second:($t@37@02))[0]) | live]
(push) ; 9
; [then-branch: 49 | 0 <= First:(Second:($t@37@02))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4261
;  :arith-add-rows          33
;  :arith-assert-diseq      115
;  :arith-assert-lower      274
;  :arith-assert-upper      206
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        166
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        3
;  :arith-pivots            63
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              562
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1888
;  :mk-clause               674
;  :num-allocs              3844192
;  :num-checks              160
;  :propagations            445
;  :quant-instantiations    161
;  :rlimit-count            162315)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4261
;  :arith-add-rows          33
;  :arith-assert-diseq      115
;  :arith-assert-lower      274
;  :arith-assert-upper      206
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        166
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        3
;  :arith-pivots            63
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              562
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1888
;  :mk-clause               674
;  :num-allocs              3844192
;  :num-checks              161
;  :propagations            445
;  :quant-instantiations    161
;  :rlimit-count            162324)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (Seq_length __flatten_26__28@40@02))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4261
;  :arith-add-rows          33
;  :arith-assert-diseq      115
;  :arith-assert-lower      274
;  :arith-assert-upper      206
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        166
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        3
;  :arith-pivots            63
;  :binary-propagations     7
;  :conflicts               82
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              562
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1888
;  :mk-clause               674
;  :num-allocs              3844192
;  :num-checks              162
;  :propagations            445
;  :quant-instantiations    161
;  :rlimit-count            162412)
(push) ; 10
; [then-branch: 50 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0 | live]
; [else-branch: 50 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] != 0 | live]
(push) ; 11
; [then-branch: 50 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_26__28@40@02
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 50 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_26__28@40@02
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4262
;  :arith-add-rows          34
;  :arith-assert-diseq      115
;  :arith-assert-lower      274
;  :arith-assert-upper      206
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        166
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        3
;  :arith-pivots            63
;  :binary-propagations     7
;  :conflicts               82
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              562
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1893
;  :mk-clause               679
;  :num-allocs              3844192
;  :num-checks              163
;  :propagations            445
;  :quant-instantiations    162
;  :rlimit-count            162627)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4262
;  :arith-add-rows          34
;  :arith-assert-diseq      115
;  :arith-assert-lower      274
;  :arith-assert-upper      206
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        166
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        3
;  :arith-pivots            63
;  :binary-propagations     7
;  :conflicts               82
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              562
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1893
;  :mk-clause               679
;  :num-allocs              3844192
;  :num-checks              164
;  :propagations            445
;  :quant-instantiations    162
;  :rlimit-count            162636)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (Seq_length __flatten_26__28@40@02))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4262
;  :arith-add-rows          34
;  :arith-assert-diseq      115
;  :arith-assert-lower      274
;  :arith-assert-upper      206
;  :arith-bound-prop        32
;  :arith-conflicts         15
;  :arith-eq-adapter        166
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        3
;  :arith-pivots            63
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 933
;  :datatype-occurs-check   406
;  :datatype-splits         636
;  :decisions               921
;  :del-clause              562
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :minimized-lits          1
;  :mk-bool-var             1893
;  :mk-clause               679
;  :num-allocs              3844192
;  :num-checks              165
;  :propagations            445
;  :quant-instantiations    162
;  :rlimit-count            162724)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 49 | !(0 <= First:(Second:($t@37@02))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
          __flatten_26__28@40@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        0)
      (=
        (Seq_index
          __flatten_26__28@40@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4567
;  :arith-add-rows          46
;  :arith-assert-diseq      138
;  :arith-assert-lower      313
;  :arith-assert-upper      230
;  :arith-bound-prop        38
;  :arith-conflicts         16
;  :arith-eq-adapter        192
;  :arith-fixed-eqs         89
;  :arith-offset-eqs        7
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 984
;  :datatype-occurs-check   422
;  :datatype-splits         666
;  :decisions               979
;  :del-clause              655
;  :final-checks            122
;  :interface-eqs           10
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          14
;  :mk-bool-var             2046
;  :mk-clause               767
;  :num-allocs              4155997
;  :num-checks              166
;  :propagations            499
;  :quant-instantiations    188
;  :rlimit-count            165459
;  :time                    0.00)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_26__28@40@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      0)
    (=
      (Seq_index
        __flatten_26__28@40@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4851
;  :arith-add-rows          61
;  :arith-assert-diseq      158
;  :arith-assert-lower      350
;  :arith-assert-upper      252
;  :arith-bound-prop        43
;  :arith-conflicts         17
;  :arith-eq-adapter        217
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        8
;  :arith-pivots            83
;  :binary-propagations     7
;  :conflicts               97
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 1035
;  :datatype-occurs-check   438
;  :datatype-splits         696
;  :decisions               1035
;  :del-clause              733
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          16
;  :mk-bool-var             2187
;  :mk-clause               845
;  :num-allocs              4155997
;  :num-checks              167
;  :propagations            550
;  :quant-instantiations    211
;  :rlimit-count            168025
;  :time                    0.00)
; [then-branch: 51 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0] | live]
; [else-branch: 51 | !(__flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0]) | live]
(push) ; 9
; [then-branch: 51 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_26__28@40@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      0)
    (=
      (Seq_index
        __flatten_26__28@40@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4851
;  :arith-add-rows          61
;  :arith-assert-diseq      158
;  :arith-assert-lower      350
;  :arith-assert-upper      252
;  :arith-bound-prop        43
;  :arith-conflicts         17
;  :arith-eq-adapter        217
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        8
;  :arith-pivots            83
;  :binary-propagations     7
;  :conflicts               97
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 1035
;  :datatype-occurs-check   438
;  :datatype-splits         696
;  :decisions               1035
;  :del-clause              733
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          16
;  :mk-bool-var             2189
;  :mk-clause               846
;  :num-allocs              4155997
;  :num-checks              168
;  :propagations            550
;  :quant-instantiations    211
;  :rlimit-count            168193)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 51 | !(__flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_26__28@40@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        0)
      (=
        (Seq_index
          __flatten_26__28@40@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
          __flatten_26__28@40@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        0)
      (=
        (Seq_index
          __flatten_26__28@40@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@02))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4856
;  :arith-add-rows          61
;  :arith-assert-diseq      158
;  :arith-assert-lower      350
;  :arith-assert-upper      252
;  :arith-bound-prop        43
;  :arith-conflicts         17
;  :arith-eq-adapter        217
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        8
;  :arith-pivots            83
;  :binary-propagations     7
;  :conflicts               97
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 1035
;  :datatype-occurs-check   438
;  :datatype-splits         696
;  :decisions               1035
;  :del-clause              734
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          16
;  :mk-bool-var             2194
;  :mk-clause               850
;  :num-allocs              4155997
;  :num-checks              169
;  :propagations            550
;  :quant-instantiations    211
;  :rlimit-count            168575)
(push) ; 8
; [then-branch: 52 | 0 <= First:(Second:($t@37@02))[0] | live]
; [else-branch: 52 | !(0 <= First:(Second:($t@37@02))[0]) | live]
(push) ; 9
; [then-branch: 52 | 0 <= First:(Second:($t@37@02))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4856
;  :arith-add-rows          61
;  :arith-assert-diseq      158
;  :arith-assert-lower      350
;  :arith-assert-upper      252
;  :arith-bound-prop        43
;  :arith-conflicts         17
;  :arith-eq-adapter        217
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        8
;  :arith-pivots            83
;  :binary-propagations     7
;  :conflicts               97
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 1035
;  :datatype-occurs-check   438
;  :datatype-splits         696
;  :decisions               1035
;  :del-clause              734
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          16
;  :mk-bool-var             2194
;  :mk-clause               850
;  :num-allocs              4155997
;  :num-checks              170
;  :propagations            550
;  :quant-instantiations    211
;  :rlimit-count            168675)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4856
;  :arith-add-rows          61
;  :arith-assert-diseq      158
;  :arith-assert-lower      350
;  :arith-assert-upper      252
;  :arith-bound-prop        43
;  :arith-conflicts         17
;  :arith-eq-adapter        217
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        8
;  :arith-pivots            83
;  :binary-propagations     7
;  :conflicts               97
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 1035
;  :datatype-occurs-check   438
;  :datatype-splits         696
;  :decisions               1035
;  :del-clause              734
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          16
;  :mk-bool-var             2194
;  :mk-clause               850
;  :num-allocs              4155997
;  :num-checks              171
;  :propagations            550
;  :quant-instantiations    211
;  :rlimit-count            168684)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (Seq_length __flatten_26__28@40@02))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4856
;  :arith-add-rows          61
;  :arith-assert-diseq      158
;  :arith-assert-lower      350
;  :arith-assert-upper      252
;  :arith-bound-prop        43
;  :arith-conflicts         17
;  :arith-eq-adapter        217
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        8
;  :arith-pivots            83
;  :binary-propagations     7
;  :conflicts               98
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 1035
;  :datatype-occurs-check   438
;  :datatype-splits         696
;  :decisions               1035
;  :del-clause              734
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          16
;  :mk-bool-var             2194
;  :mk-clause               850
;  :num-allocs              4155997
;  :num-checks              172
;  :propagations            550
;  :quant-instantiations    211
;  :rlimit-count            168772)
(push) ; 10
; [then-branch: 53 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0 | live]
; [else-branch: 53 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] != 0 | live]
(push) ; 11
; [then-branch: 53 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_26__28@40@02
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 53 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_26__28@40@02
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4857
;  :arith-add-rows          63
;  :arith-assert-diseq      158
;  :arith-assert-lower      350
;  :arith-assert-upper      252
;  :arith-bound-prop        43
;  :arith-conflicts         17
;  :arith-eq-adapter        217
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        8
;  :arith-pivots            83
;  :binary-propagations     7
;  :conflicts               98
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 1035
;  :datatype-occurs-check   438
;  :datatype-splits         696
;  :decisions               1035
;  :del-clause              734
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          16
;  :mk-bool-var             2198
;  :mk-clause               855
;  :num-allocs              4155997
;  :num-checks              173
;  :propagations            550
;  :quant-instantiations    212
;  :rlimit-count            168926)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4857
;  :arith-add-rows          63
;  :arith-assert-diseq      158
;  :arith-assert-lower      350
;  :arith-assert-upper      252
;  :arith-bound-prop        43
;  :arith-conflicts         17
;  :arith-eq-adapter        217
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        8
;  :arith-pivots            83
;  :binary-propagations     7
;  :conflicts               98
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 1035
;  :datatype-occurs-check   438
;  :datatype-splits         696
;  :decisions               1035
;  :del-clause              734
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          16
;  :mk-bool-var             2198
;  :mk-clause               855
;  :num-allocs              4155997
;  :num-checks              174
;  :propagations            550
;  :quant-instantiations    212
;  :rlimit-count            168935)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (Seq_length __flatten_26__28@40@02))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4857
;  :arith-add-rows          63
;  :arith-assert-diseq      158
;  :arith-assert-lower      350
;  :arith-assert-upper      252
;  :arith-bound-prop        43
;  :arith-conflicts         17
;  :arith-eq-adapter        217
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        8
;  :arith-pivots            83
;  :binary-propagations     7
;  :conflicts               99
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 1035
;  :datatype-occurs-check   438
;  :datatype-splits         696
;  :decisions               1035
;  :del-clause              734
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          16
;  :mk-bool-var             2198
;  :mk-clause               855
;  :num-allocs              4155997
;  :num-checks              175
;  :propagations            550
;  :quant-instantiations    212
;  :rlimit-count            169023)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 52 | !(0 <= First:(Second:($t@37@02))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
        __flatten_26__28@40@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      0)
    (=
      (Seq_index
        __flatten_26__28@40@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5135
;  :arith-add-rows          75
;  :arith-assert-diseq      178
;  :arith-assert-lower      387
;  :arith-assert-upper      274
;  :arith-bound-prop        48
;  :arith-conflicts         18
;  :arith-eq-adapter        242
;  :arith-fixed-eqs         113
;  :arith-offset-eqs        9
;  :arith-pivots            89
;  :binary-propagations     7
;  :conflicts               105
;  :datatype-accessor-ax    178
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   454
;  :datatype-splits         725
;  :decisions               1090
;  :del-clause              810
;  :final-checks            130
;  :interface-eqs           12
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          18
;  :mk-bool-var             2333
;  :mk-clause               926
;  :num-allocs              4155997
;  :num-checks              176
;  :propagations            599
;  :quant-instantiations    235
;  :rlimit-count            171536
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_26__28@40@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        0)
      (=
        (Seq_index
          __flatten_26__28@40@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5484
;  :arith-add-rows          88
;  :arith-assert-diseq      199
;  :arith-assert-lower      418
;  :arith-assert-upper      294
;  :arith-bound-prop        54
;  :arith-conflicts         19
;  :arith-eq-adapter        264
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        13
;  :arith-pivots            95
;  :binary-propagations     7
;  :conflicts               116
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 1151
;  :datatype-occurs-check   476
;  :datatype-splits         758
;  :decisions               1161
;  :del-clause              888
;  :final-checks            135
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          31
;  :mk-bool-var             2483
;  :mk-clause               1004
;  :num-allocs              4155997
;  :num-checks              177
;  :propagations            651
;  :quant-instantiations    259
;  :rlimit-count            174273
;  :time                    0.00)
; [then-branch: 54 | !(__flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0]) | live]
; [else-branch: 54 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0] | live]
(push) ; 9
; [then-branch: 54 | !(__flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_26__28@40@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        0)
      (=
        (Seq_index
          __flatten_26__28@40@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5485
;  :arith-add-rows          90
;  :arith-assert-diseq      199
;  :arith-assert-lower      418
;  :arith-assert-upper      294
;  :arith-bound-prop        54
;  :arith-conflicts         19
;  :arith-eq-adapter        264
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        13
;  :arith-pivots            95
;  :binary-propagations     7
;  :conflicts               116
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 1151
;  :datatype-occurs-check   476
;  :datatype-splits         758
;  :decisions               1161
;  :del-clause              888
;  :final-checks            135
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          31
;  :mk-bool-var             2487
;  :mk-clause               1009
;  :num-allocs              4155997
;  :num-checks              178
;  :propagations            653
;  :quant-instantiations    260
;  :rlimit-count            174457)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5485
;  :arith-add-rows          90
;  :arith-assert-diseq      199
;  :arith-assert-lower      418
;  :arith-assert-upper      294
;  :arith-bound-prop        54
;  :arith-conflicts         19
;  :arith-eq-adapter        264
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        13
;  :arith-pivots            95
;  :binary-propagations     7
;  :conflicts               116
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 1151
;  :datatype-occurs-check   476
;  :datatype-splits         758
;  :decisions               1161
;  :del-clause              888
;  :final-checks            135
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          31
;  :mk-bool-var             2487
;  :mk-clause               1009
;  :num-allocs              4155997
;  :num-checks              179
;  :propagations            653
;  :quant-instantiations    260
;  :rlimit-count            174472)
(pop) ; 9
(push) ; 9
; [else-branch: 54 | __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@40@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_26__28@40@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      0)
    (=
      (Seq_index
        __flatten_26__28@40@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
            __flatten_26__28@40@02
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
              0))
          0)
        (=
          (Seq_index
            __flatten_26__28@40@02
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; Main_reset_all_events_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@44@02 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 55 | 0 <= i@44@02 | live]
; [else-branch: 55 | !(0 <= i@44@02) | live]
(push) ; 10
; [then-branch: 55 | 0 <= i@44@02]
(assert (<= 0 i@44@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 55 | !(0 <= i@44@02)]
(assert (not (<= 0 i@44@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 56 | i@44@02 < |First:(Second:($t@42@02))| && 0 <= i@44@02 | live]
; [else-branch: 56 | !(i@44@02 < |First:(Second:($t@42@02))| && 0 <= i@44@02) | live]
(push) ; 10
; [then-branch: 56 | i@44@02 < |First:(Second:($t@42@02))| && 0 <= i@44@02]
(assert (and
  (<
    i@44@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))))
  (<= 0 i@44@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@44@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5766
;  :arith-add-rows          107
;  :arith-assert-diseq      219
;  :arith-assert-lower      456
;  :arith-assert-upper      317
;  :arith-bound-prop        60
;  :arith-conflicts         20
;  :arith-eq-adapter        289
;  :arith-fixed-eqs         141
;  :arith-offset-eqs        14
;  :arith-pivots            103
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 1201
;  :datatype-occurs-check   492
;  :datatype-splits         787
;  :decisions               1217
;  :del-clause              974
;  :final-checks            139
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          33
;  :mk-bool-var             2628
;  :mk-clause               1096
;  :num-allocs              4155997
;  :num-checks              181
;  :propagations            705
;  :quant-instantiations    284
;  :rlimit-count            177277)
; [eval] -1
(push) ; 11
; [then-branch: 57 | First:(Second:($t@42@02))[i@44@02] == -1 | live]
; [else-branch: 57 | First:(Second:($t@42@02))[i@44@02] != -1 | live]
(push) ; 12
; [then-branch: 57 | First:(Second:($t@42@02))[i@44@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
    i@44@02)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 57 | First:(Second:($t@42@02))[i@44@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
      i@44@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@44@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5772
;  :arith-add-rows          108
;  :arith-assert-diseq      221
;  :arith-assert-lower      460
;  :arith-assert-upper      319
;  :arith-bound-prop        60
;  :arith-conflicts         20
;  :arith-eq-adapter        291
;  :arith-fixed-eqs         142
;  :arith-offset-eqs        14
;  :arith-pivots            104
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 1201
;  :datatype-occurs-check   492
;  :datatype-splits         787
;  :decisions               1217
;  :del-clause              974
;  :final-checks            139
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          33
;  :mk-bool-var             2637
;  :mk-clause               1101
;  :num-allocs              4155997
;  :num-checks              182
;  :propagations            712
;  :quant-instantiations    286
;  :rlimit-count            177484)
(push) ; 13
; [then-branch: 58 | 0 <= First:(Second:($t@42@02))[i@44@02] | live]
; [else-branch: 58 | !(0 <= First:(Second:($t@42@02))[i@44@02]) | live]
(push) ; 14
; [then-branch: 58 | 0 <= First:(Second:($t@42@02))[i@44@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
    i@44@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@44@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5774
;  :arith-add-rows          109
;  :arith-assert-diseq      221
;  :arith-assert-lower      462
;  :arith-assert-upper      320
;  :arith-bound-prop        60
;  :arith-conflicts         20
;  :arith-eq-adapter        292
;  :arith-fixed-eqs         143
;  :arith-offset-eqs        14
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 1201
;  :datatype-occurs-check   492
;  :datatype-splits         787
;  :decisions               1217
;  :del-clause              974
;  :final-checks            139
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          33
;  :mk-bool-var             2641
;  :mk-clause               1101
;  :num-allocs              4155997
;  :num-checks              183
;  :propagations            712
;  :quant-instantiations    286
;  :rlimit-count            177603)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 58 | !(0 <= First:(Second:($t@42@02))[i@44@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
      i@44@02))))
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
; [else-branch: 56 | !(i@44@02 < |First:(Second:($t@42@02))| && 0 <= i@44@02)]
(assert (not
  (and
    (<
      i@44@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))))
    (<= 0 i@44@02))))
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
(assert (not (forall ((i@44@02 Int)) (!
  (implies
    (and
      (<
        i@44@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))))
      (<= 0 i@44@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
          i@44@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
            i@44@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
            i@44@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
    i@44@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5774
;  :arith-add-rows          109
;  :arith-assert-diseq      223
;  :arith-assert-lower      463
;  :arith-assert-upper      321
;  :arith-bound-prop        60
;  :arith-conflicts         20
;  :arith-eq-adapter        293
;  :arith-fixed-eqs         144
;  :arith-offset-eqs        14
;  :arith-pivots            107
;  :binary-propagations     7
;  :conflicts               123
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 1201
;  :datatype-occurs-check   492
;  :datatype-splits         787
;  :decisions               1217
;  :del-clause              993
;  :final-checks            139
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          33
;  :mk-bool-var             2649
;  :mk-clause               1115
;  :num-allocs              4155997
;  :num-checks              184
;  :propagations            714
;  :quant-instantiations    287
;  :rlimit-count            178034)
(assert (forall ((i@44@02 Int)) (!
  (implies
    (and
      (<
        i@44@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))))
      (<= 0 i@44@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
          i@44@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
            i@44@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
            i@44@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))
    i@44@02))
  :qid |prog.l<no position>|)))
(declare-const $t@45@02 $Snap)
(assert (= $t@45@02 ($Snap.combine ($Snap.first $t@45@02) ($Snap.second $t@45@02))))
(assert (=
  ($Snap.second $t@45@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@45@02))
    ($Snap.second ($Snap.second $t@45@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@45@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@45@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@45@02))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@45@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@46@02 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 59 | 0 <= i@46@02 | live]
; [else-branch: 59 | !(0 <= i@46@02) | live]
(push) ; 10
; [then-branch: 59 | 0 <= i@46@02]
(assert (<= 0 i@46@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 59 | !(0 <= i@46@02)]
(assert (not (<= 0 i@46@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 60 | i@46@02 < |First:(Second:($t@45@02))| && 0 <= i@46@02 | live]
; [else-branch: 60 | !(i@46@02 < |First:(Second:($t@45@02))| && 0 <= i@46@02) | live]
(push) ; 10
; [then-branch: 60 | i@46@02 < |First:(Second:($t@45@02))| && 0 <= i@46@02]
(assert (and
  (<
    i@46@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))))
  (<= 0 i@46@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@46@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5812
;  :arith-add-rows          109
;  :arith-assert-diseq      223
;  :arith-assert-lower      468
;  :arith-assert-upper      324
;  :arith-bound-prop        60
;  :arith-conflicts         20
;  :arith-eq-adapter        295
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        14
;  :arith-pivots            107
;  :binary-propagations     7
;  :conflicts               123
;  :datatype-accessor-ax    195
;  :datatype-constructor-ax 1201
;  :datatype-occurs-check   492
;  :datatype-splits         787
;  :decisions               1217
;  :del-clause              993
;  :final-checks            139
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          33
;  :mk-bool-var             2671
;  :mk-clause               1115
;  :num-allocs              4155997
;  :num-checks              185
;  :propagations            714
;  :quant-instantiations    291
;  :rlimit-count            179425)
; [eval] -1
(push) ; 11
; [then-branch: 61 | First:(Second:($t@45@02))[i@46@02] == -1 | live]
; [else-branch: 61 | First:(Second:($t@45@02))[i@46@02] != -1 | live]
(push) ; 12
; [then-branch: 61 | First:(Second:($t@45@02))[i@46@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
    i@46@02)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 61 | First:(Second:($t@45@02))[i@46@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
      i@46@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@46@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5812
;  :arith-add-rows          109
;  :arith-assert-diseq      223
;  :arith-assert-lower      468
;  :arith-assert-upper      324
;  :arith-bound-prop        60
;  :arith-conflicts         20
;  :arith-eq-adapter        295
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        14
;  :arith-pivots            107
;  :binary-propagations     7
;  :conflicts               123
;  :datatype-accessor-ax    195
;  :datatype-constructor-ax 1201
;  :datatype-occurs-check   492
;  :datatype-splits         787
;  :decisions               1217
;  :del-clause              993
;  :final-checks            139
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          33
;  :mk-bool-var             2672
;  :mk-clause               1115
;  :num-allocs              4155997
;  :num-checks              186
;  :propagations            714
;  :quant-instantiations    291
;  :rlimit-count            179576)
(push) ; 13
; [then-branch: 62 | 0 <= First:(Second:($t@45@02))[i@46@02] | live]
; [else-branch: 62 | !(0 <= First:(Second:($t@45@02))[i@46@02]) | live]
(push) ; 14
; [then-branch: 62 | 0 <= First:(Second:($t@45@02))[i@46@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
    i@46@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@46@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5812
;  :arith-add-rows          109
;  :arith-assert-diseq      224
;  :arith-assert-lower      471
;  :arith-assert-upper      324
;  :arith-bound-prop        60
;  :arith-conflicts         20
;  :arith-eq-adapter        296
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        14
;  :arith-pivots            107
;  :binary-propagations     7
;  :conflicts               123
;  :datatype-accessor-ax    195
;  :datatype-constructor-ax 1201
;  :datatype-occurs-check   492
;  :datatype-splits         787
;  :decisions               1217
;  :del-clause              993
;  :final-checks            139
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          33
;  :mk-bool-var             2675
;  :mk-clause               1116
;  :num-allocs              4155997
;  :num-checks              187
;  :propagations            714
;  :quant-instantiations    291
;  :rlimit-count            179680)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 62 | !(0 <= First:(Second:($t@45@02))[i@46@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
      i@46@02))))
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
; [else-branch: 60 | !(i@46@02 < |First:(Second:($t@45@02))| && 0 <= i@46@02)]
(assert (not
  (and
    (<
      i@46@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))))
    (<= 0 i@46@02))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@46@02 Int)) (!
  (implies
    (and
      (<
        i@46@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))))
      (<= 0 i@46@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
          i@46@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
            i@46@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
            i@46@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
    i@46@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@42@02)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5830
;  :arith-add-rows          109
;  :arith-assert-diseq      224
;  :arith-assert-lower      472
;  :arith-assert-upper      325
;  :arith-bound-prop        60
;  :arith-conflicts         20
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         146
;  :arith-offset-eqs        14
;  :arith-pivots            107
;  :binary-propagations     7
;  :conflicts               123
;  :datatype-accessor-ax    197
;  :datatype-constructor-ax 1201
;  :datatype-occurs-check   492
;  :datatype-splits         787
;  :decisions               1217
;  :del-clause              994
;  :final-checks            139
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          33
;  :mk-bool-var             2695
;  :mk-clause               1126
;  :num-allocs              4155997
;  :num-checks              188
;  :propagations            718
;  :quant-instantiations    293
;  :rlimit-count            180696)
(push) ; 8
; [then-branch: 63 | First:(Second:(Second:(Second:($t@42@02))))[0] == 0 | live]
; [else-branch: 63 | First:(Second:(Second:(Second:($t@42@02))))[0] != 0 | live]
(push) ; 9
; [then-branch: 63 | First:(Second:(Second:(Second:($t@42@02))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 63 | First:(Second:(Second:(Second:($t@42@02))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5831
;  :arith-add-rows          110
;  :arith-assert-diseq      224
;  :arith-assert-lower      472
;  :arith-assert-upper      325
;  :arith-bound-prop        60
;  :arith-conflicts         20
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         146
;  :arith-offset-eqs        14
;  :arith-pivots            107
;  :binary-propagations     7
;  :conflicts               123
;  :datatype-accessor-ax    197
;  :datatype-constructor-ax 1201
;  :datatype-occurs-check   492
;  :datatype-splits         787
;  :decisions               1217
;  :del-clause              994
;  :final-checks            139
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.49
;  :minimized-lits          33
;  :mk-bool-var             2700
;  :mk-clause               1131
;  :num-allocs              4155997
;  :num-checks              189
;  :propagations            718
;  :quant-instantiations    294
;  :rlimit-count            180909)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6238
;  :arith-add-rows          129
;  :arith-assert-diseq      265
;  :arith-assert-lower      530
;  :arith-assert-upper      367
;  :arith-bound-prop        63
;  :arith-conflicts         20
;  :arith-eq-adapter        330
;  :arith-fixed-eqs         170
;  :arith-offset-eqs        15
;  :arith-pivots            119
;  :binary-propagations     7
;  :conflicts               133
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 1257
;  :datatype-occurs-check   510
;  :datatype-splits         821
;  :decisions               1286
;  :del-clause              1090
;  :final-checks            142
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          49
;  :mk-bool-var             2879
;  :mk-clause               1222
;  :num-allocs              4322435
;  :num-checks              190
;  :propagations            825
;  :quant-instantiations    339
;  :rlimit-count            184399
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6541
;  :arith-add-rows          141
;  :arith-assert-diseq      290
;  :arith-assert-lower      559
;  :arith-assert-upper      389
;  :arith-bound-prop        65
;  :arith-conflicts         20
;  :arith-eq-adapter        352
;  :arith-fixed-eqs         176
;  :arith-offset-eqs        19
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               136
;  :datatype-accessor-ax    207
;  :datatype-constructor-ax 1313
;  :datatype-occurs-check   528
;  :datatype-splits         855
;  :decisions               1346
;  :del-clause              1141
;  :final-checks            145
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          49
;  :mk-bool-var             2999
;  :mk-clause               1273
;  :num-allocs              4322435
;  :num-checks              191
;  :propagations            873
;  :quant-instantiations    360
;  :rlimit-count            187045
;  :time                    0.00)
; [then-branch: 64 | First:(Second:(Second:(Second:($t@42@02))))[0] == 0 || First:(Second:(Second:(Second:($t@42@02))))[0] == -1 | live]
; [else-branch: 64 | !(First:(Second:(Second:(Second:($t@42@02))))[0] == 0 || First:(Second:(Second:(Second:($t@42@02))))[0] == -1) | live]
(push) ; 9
; [then-branch: 64 | First:(Second:(Second:(Second:($t@42@02))))[0] == 0 || First:(Second:(Second:(Second:($t@42@02))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6541
;  :arith-add-rows          141
;  :arith-assert-diseq      290
;  :arith-assert-lower      559
;  :arith-assert-upper      389
;  :arith-bound-prop        65
;  :arith-conflicts         20
;  :arith-eq-adapter        352
;  :arith-fixed-eqs         176
;  :arith-offset-eqs        19
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               136
;  :datatype-accessor-ax    207
;  :datatype-constructor-ax 1313
;  :datatype-occurs-check   528
;  :datatype-splits         855
;  :decisions               1346
;  :del-clause              1141
;  :final-checks            145
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          49
;  :mk-bool-var             3001
;  :mk-clause               1274
;  :num-allocs              4322435
;  :num-checks              192
;  :propagations            873
;  :quant-instantiations    360
;  :rlimit-count            187194)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 64 | !(First:(Second:(Second:(Second:($t@42@02))))[0] == 0 || First:(Second:(Second:(Second:($t@42@02))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6547
;  :arith-add-rows          141
;  :arith-assert-diseq      290
;  :arith-assert-lower      559
;  :arith-assert-upper      389
;  :arith-bound-prop        65
;  :arith-conflicts         20
;  :arith-eq-adapter        352
;  :arith-fixed-eqs         176
;  :arith-offset-eqs        19
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               136
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 1313
;  :datatype-occurs-check   528
;  :datatype-splits         855
;  :decisions               1346
;  :del-clause              1142
;  :final-checks            145
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          49
;  :mk-bool-var             3007
;  :mk-clause               1278
;  :num-allocs              4322435
;  :num-checks              193
;  :propagations            873
;  :quant-instantiations    360
;  :rlimit-count            187677)
(push) ; 8
; [then-branch: 65 | First:(Second:(Second:(Second:($t@42@02))))[1] == 0 | live]
; [else-branch: 65 | First:(Second:(Second:(Second:($t@42@02))))[1] != 0 | live]
(push) ; 9
; [then-branch: 65 | First:(Second:(Second:(Second:($t@42@02))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 65 | First:(Second:(Second:(Second:($t@42@02))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6548
;  :arith-add-rows          142
;  :arith-assert-diseq      290
;  :arith-assert-lower      559
;  :arith-assert-upper      389
;  :arith-bound-prop        65
;  :arith-conflicts         20
;  :arith-eq-adapter        352
;  :arith-fixed-eqs         176
;  :arith-offset-eqs        19
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               136
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 1313
;  :datatype-occurs-check   528
;  :datatype-splits         855
;  :decisions               1346
;  :del-clause              1142
;  :final-checks            145
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          49
;  :mk-bool-var             3012
;  :mk-clause               1283
;  :num-allocs              4322435
;  :num-checks              194
;  :propagations            873
;  :quant-instantiations    361
;  :rlimit-count            187862)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6890
;  :arith-add-rows          151
;  :arith-assert-diseq      322
;  :arith-assert-lower      597
;  :arith-assert-upper      419
;  :arith-bound-prop        67
;  :arith-conflicts         20
;  :arith-eq-adapter        380
;  :arith-fixed-eqs         187
;  :arith-offset-eqs        24
;  :arith-pivots            139
;  :binary-propagations     7
;  :conflicts               140
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 1369
;  :datatype-occurs-check   547
;  :datatype-splits         889
;  :decisions               1410
;  :del-clause              1211
;  :final-checks            148
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          54
;  :mk-bool-var             3162
;  :mk-clause               1347
;  :num-allocs              4322435
;  :num-checks              195
;  :propagations            938
;  :quant-instantiations    390
;  :rlimit-count            190626
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7257
;  :arith-add-rows          159
;  :arith-assert-diseq      352
;  :arith-assert-lower      651
;  :arith-assert-upper      451
;  :arith-bound-prop        69
;  :arith-conflicts         20
;  :arith-eq-adapter        411
;  :arith-fixed-eqs         208
;  :arith-offset-eqs        26
;  :arith-pivots            149
;  :binary-propagations     7
;  :conflicts               146
;  :datatype-accessor-ax    219
;  :datatype-constructor-ax 1428
;  :datatype-occurs-check   571
;  :datatype-splits         925
;  :decisions               1476
;  :del-clause              1292
;  :final-checks            152
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          55
;  :mk-bool-var             3331
;  :mk-clause               1428
;  :num-allocs              4322435
;  :num-checks              196
;  :propagations            1027
;  :quant-instantiations    424
;  :rlimit-count            193596
;  :time                    0.00)
; [then-branch: 66 | First:(Second:(Second:(Second:($t@42@02))))[1] == 0 || First:(Second:(Second:(Second:($t@42@02))))[1] == -1 | live]
; [else-branch: 66 | !(First:(Second:(Second:(Second:($t@42@02))))[1] == 0 || First:(Second:(Second:(Second:($t@42@02))))[1] == -1) | live]
(push) ; 9
; [then-branch: 66 | First:(Second:(Second:(Second:($t@42@02))))[1] == 0 || First:(Second:(Second:(Second:($t@42@02))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7257
;  :arith-add-rows          159
;  :arith-assert-diseq      352
;  :arith-assert-lower      651
;  :arith-assert-upper      451
;  :arith-bound-prop        69
;  :arith-conflicts         20
;  :arith-eq-adapter        411
;  :arith-fixed-eqs         208
;  :arith-offset-eqs        26
;  :arith-pivots            149
;  :binary-propagations     7
;  :conflicts               146
;  :datatype-accessor-ax    219
;  :datatype-constructor-ax 1428
;  :datatype-occurs-check   571
;  :datatype-splits         925
;  :decisions               1476
;  :del-clause              1292
;  :final-checks            152
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          55
;  :mk-bool-var             3333
;  :mk-clause               1429
;  :num-allocs              4322435
;  :num-checks              197
;  :propagations            1027
;  :quant-instantiations    424
;  :rlimit-count            193745)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 66 | !(First:(Second:(Second:(Second:($t@42@02))))[1] == 0 || First:(Second:(Second:(Second:($t@42@02))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7263
;  :arith-add-rows          159
;  :arith-assert-diseq      352
;  :arith-assert-lower      651
;  :arith-assert-upper      451
;  :arith-bound-prop        69
;  :arith-conflicts         20
;  :arith-eq-adapter        411
;  :arith-fixed-eqs         208
;  :arith-offset-eqs        26
;  :arith-pivots            149
;  :binary-propagations     7
;  :conflicts               146
;  :datatype-accessor-ax    220
;  :datatype-constructor-ax 1428
;  :datatype-occurs-check   571
;  :datatype-splits         925
;  :decisions               1476
;  :del-clause              1293
;  :final-checks            152
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          55
;  :mk-bool-var             3339
;  :mk-clause               1433
;  :num-allocs              4322435
;  :num-checks              198
;  :propagations            1027
;  :quant-instantiations    424
;  :rlimit-count            194234)
(push) ; 8
; [then-branch: 67 | First:(Second:(Second:(Second:($t@42@02))))[0] == 0 | live]
; [else-branch: 67 | First:(Second:(Second:(Second:($t@42@02))))[0] != 0 | live]
(push) ; 9
; [then-branch: 67 | First:(Second:(Second:(Second:($t@42@02))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 67 | First:(Second:(Second:(Second:($t@42@02))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7264
;  :arith-add-rows          160
;  :arith-assert-diseq      352
;  :arith-assert-lower      651
;  :arith-assert-upper      451
;  :arith-bound-prop        69
;  :arith-conflicts         20
;  :arith-eq-adapter        411
;  :arith-fixed-eqs         208
;  :arith-offset-eqs        26
;  :arith-pivots            149
;  :binary-propagations     7
;  :conflicts               146
;  :datatype-accessor-ax    220
;  :datatype-constructor-ax 1428
;  :datatype-occurs-check   571
;  :datatype-splits         925
;  :decisions               1476
;  :del-clause              1293
;  :final-checks            152
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          55
;  :mk-bool-var             3343
;  :mk-clause               1438
;  :num-allocs              4322435
;  :num-checks              199
;  :propagations            1027
;  :quant-instantiations    425
;  :rlimit-count            194403)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7610
;  :arith-add-rows          176
;  :arith-assert-diseq      385
;  :arith-assert-lower      688
;  :arith-assert-upper      481
;  :arith-bound-prop        71
;  :arith-conflicts         20
;  :arith-eq-adapter        438
;  :arith-fixed-eqs         218
;  :arith-offset-eqs        29
;  :arith-pivots            161
;  :binary-propagations     7
;  :conflicts               151
;  :datatype-accessor-ax    226
;  :datatype-constructor-ax 1487
;  :datatype-occurs-check   595
;  :datatype-splits         961
;  :decisions               1542
;  :del-clause              1364
;  :final-checks            156
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          60
;  :mk-bool-var             3497
;  :mk-clause               1504
;  :num-allocs              4322435
;  :num-checks              200
;  :propagations            1094
;  :quant-instantiations    452
;  :rlimit-count            197431
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8063
;  :arith-add-rows          191
;  :arith-assert-diseq      426
;  :arith-assert-lower      746
;  :arith-assert-upper      523
;  :arith-bound-prop        74
;  :arith-conflicts         20
;  :arith-eq-adapter        471
;  :arith-fixed-eqs         253
;  :arith-offset-eqs        31
;  :arith-pivots            171
;  :binary-propagations     7
;  :conflicts               163
;  :datatype-accessor-ax    232
;  :datatype-constructor-ax 1546
;  :datatype-occurs-check   619
;  :datatype-splits         997
;  :decisions               1614
;  :del-clause              1462
;  :final-checks            160
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          76
;  :mk-bool-var             3695
;  :mk-clause               1602
;  :num-allocs              4322435
;  :num-checks              201
;  :propagations            1218
;  :quant-instantiations    500
;  :rlimit-count            200908
;  :time                    0.00)
; [then-branch: 68 | !(First:(Second:(Second:(Second:($t@42@02))))[0] == 0 || First:(Second:(Second:(Second:($t@42@02))))[0] == -1) | live]
; [else-branch: 68 | First:(Second:(Second:(Second:($t@42@02))))[0] == 0 || First:(Second:(Second:(Second:($t@42@02))))[0] == -1 | live]
(push) ; 9
; [then-branch: 68 | !(First:(Second:(Second:(Second:($t@42@02))))[0] == 0 || First:(Second:(Second:(Second:($t@42@02))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8064
;  :arith-add-rows          192
;  :arith-assert-diseq      426
;  :arith-assert-lower      746
;  :arith-assert-upper      523
;  :arith-bound-prop        74
;  :arith-conflicts         20
;  :arith-eq-adapter        471
;  :arith-fixed-eqs         253
;  :arith-offset-eqs        31
;  :arith-pivots            171
;  :binary-propagations     7
;  :conflicts               163
;  :datatype-accessor-ax    232
;  :datatype-constructor-ax 1546
;  :datatype-occurs-check   619
;  :datatype-splits         997
;  :decisions               1614
;  :del-clause              1462
;  :final-checks            160
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          76
;  :mk-bool-var             3699
;  :mk-clause               1607
;  :num-allocs              4322435
;  :num-checks              202
;  :propagations            1219
;  :quant-instantiations    501
;  :rlimit-count            201098)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8064
;  :arith-add-rows          192
;  :arith-assert-diseq      426
;  :arith-assert-lower      746
;  :arith-assert-upper      523
;  :arith-bound-prop        74
;  :arith-conflicts         20
;  :arith-eq-adapter        471
;  :arith-fixed-eqs         253
;  :arith-offset-eqs        31
;  :arith-pivots            171
;  :binary-propagations     7
;  :conflicts               163
;  :datatype-accessor-ax    232
;  :datatype-constructor-ax 1546
;  :datatype-occurs-check   619
;  :datatype-splits         997
;  :decisions               1614
;  :del-clause              1462
;  :final-checks            160
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          76
;  :mk-bool-var             3699
;  :mk-clause               1607
;  :num-allocs              4322435
;  :num-checks              203
;  :propagations            1219
;  :quant-instantiations    501
;  :rlimit-count            201113)
(pop) ; 9
(push) ; 9
; [else-branch: 68 | First:(Second:(Second:(Second:($t@42@02))))[0] == 0 || First:(Second:(Second:(Second:($t@42@02))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@02))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8071
;  :arith-add-rows          192
;  :arith-assert-diseq      426
;  :arith-assert-lower      746
;  :arith-assert-upper      523
;  :arith-bound-prop        74
;  :arith-conflicts         20
;  :arith-eq-adapter        471
;  :arith-fixed-eqs         253
;  :arith-offset-eqs        31
;  :arith-pivots            171
;  :binary-propagations     7
;  :conflicts               163
;  :datatype-accessor-ax    232
;  :datatype-constructor-ax 1546
;  :datatype-occurs-check   619
;  :datatype-splits         997
;  :decisions               1614
;  :del-clause              1467
;  :final-checks            160
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          76
;  :mk-bool-var             3701
;  :mk-clause               1608
;  :num-allocs              4322435
;  :num-checks              204
;  :propagations            1219
;  :quant-instantiations    501
;  :rlimit-count            201465)
(push) ; 8
; [then-branch: 69 | First:(Second:(Second:(Second:($t@42@02))))[1] == 0 | live]
; [else-branch: 69 | First:(Second:(Second:(Second:($t@42@02))))[1] != 0 | live]
(push) ; 9
; [then-branch: 69 | First:(Second:(Second:(Second:($t@42@02))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 69 | First:(Second:(Second:(Second:($t@42@02))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8072
;  :arith-add-rows          193
;  :arith-assert-diseq      426
;  :arith-assert-lower      746
;  :arith-assert-upper      523
;  :arith-bound-prop        74
;  :arith-conflicts         20
;  :arith-eq-adapter        471
;  :arith-fixed-eqs         253
;  :arith-offset-eqs        31
;  :arith-pivots            171
;  :binary-propagations     7
;  :conflicts               163
;  :datatype-accessor-ax    232
;  :datatype-constructor-ax 1546
;  :datatype-occurs-check   619
;  :datatype-splits         997
;  :decisions               1614
;  :del-clause              1467
;  :final-checks            160
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          76
;  :mk-bool-var             3705
;  :mk-clause               1613
;  :num-allocs              4322435
;  :num-checks              205
;  :propagations            1219
;  :quant-instantiations    502
;  :rlimit-count            201634)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8438
;  :arith-add-rows          201
;  :arith-assert-diseq      456
;  :arith-assert-lower      800
;  :arith-assert-upper      555
;  :arith-bound-prop        76
;  :arith-conflicts         20
;  :arith-eq-adapter        502
;  :arith-fixed-eqs         274
;  :arith-offset-eqs        33
;  :arith-pivots            179
;  :binary-propagations     7
;  :conflicts               169
;  :datatype-accessor-ax    238
;  :datatype-constructor-ax 1604
;  :datatype-occurs-check   643
;  :datatype-splits         1032
;  :decisions               1679
;  :del-clause              1553
;  :final-checks            164
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          77
;  :mk-bool-var             3871
;  :mk-clause               1694
;  :num-allocs              4322435
;  :num-checks              206
;  :propagations            1310
;  :quant-instantiations    536
;  :rlimit-count            204587
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8792
;  :arith-add-rows          216
;  :arith-assert-diseq      488
;  :arith-assert-lower      838
;  :arith-assert-upper      585
;  :arith-bound-prop        78
;  :arith-conflicts         20
;  :arith-eq-adapter        530
;  :arith-fixed-eqs         285
;  :arith-offset-eqs        37
;  :arith-pivots            191
;  :binary-propagations     7
;  :conflicts               175
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 1662
;  :datatype-occurs-check   667
;  :datatype-splits         1067
;  :decisions               1745
;  :del-clause              1618
;  :final-checks            168
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          82
;  :mk-bool-var             4030
;  :mk-clause               1759
;  :num-allocs              4322435
;  :num-checks              207
;  :propagations            1381
;  :quant-instantiations    565
;  :rlimit-count            207577
;  :time                    0.00)
; [then-branch: 70 | !(First:(Second:(Second:(Second:($t@42@02))))[1] == 0 || First:(Second:(Second:(Second:($t@42@02))))[1] == -1) | live]
; [else-branch: 70 | First:(Second:(Second:(Second:($t@42@02))))[1] == 0 || First:(Second:(Second:(Second:($t@42@02))))[1] == -1 | live]
(push) ; 9
; [then-branch: 70 | !(First:(Second:(Second:(Second:($t@42@02))))[1] == 0 || First:(Second:(Second:(Second:($t@42@02))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8793
;  :arith-add-rows          217
;  :arith-assert-diseq      488
;  :arith-assert-lower      838
;  :arith-assert-upper      585
;  :arith-bound-prop        78
;  :arith-conflicts         20
;  :arith-eq-adapter        530
;  :arith-fixed-eqs         285
;  :arith-offset-eqs        37
;  :arith-pivots            191
;  :binary-propagations     7
;  :conflicts               175
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 1662
;  :datatype-occurs-check   667
;  :datatype-splits         1067
;  :decisions               1745
;  :del-clause              1618
;  :final-checks            168
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          82
;  :mk-bool-var             4034
;  :mk-clause               1764
;  :num-allocs              4322435
;  :num-checks              208
;  :propagations            1382
;  :quant-instantiations    566
;  :rlimit-count            207767)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8793
;  :arith-add-rows          217
;  :arith-assert-diseq      488
;  :arith-assert-lower      838
;  :arith-assert-upper      585
;  :arith-bound-prop        78
;  :arith-conflicts         20
;  :arith-eq-adapter        530
;  :arith-fixed-eqs         285
;  :arith-offset-eqs        37
;  :arith-pivots            191
;  :binary-propagations     7
;  :conflicts               175
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 1662
;  :datatype-occurs-check   667
;  :datatype-splits         1067
;  :decisions               1745
;  :del-clause              1618
;  :final-checks            168
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          82
;  :mk-bool-var             4034
;  :mk-clause               1764
;  :num-allocs              4322435
;  :num-checks              209
;  :propagations            1382
;  :quant-instantiations    566
;  :rlimit-count            207782)
(pop) ; 9
(push) ; 9
; [else-branch: 70 | First:(Second:(Second:(Second:($t@42@02))))[1] == 0 || First:(Second:(Second:(Second:($t@42@02))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@02)))))
      1))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@47@02 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 71 | 0 <= i@47@02 | live]
; [else-branch: 71 | !(0 <= i@47@02) | live]
(push) ; 10
; [then-branch: 71 | 0 <= i@47@02]
(assert (<= 0 i@47@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 71 | !(0 <= i@47@02)]
(assert (not (<= 0 i@47@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 72 | i@47@02 < |First:(Second:($t@45@02))| && 0 <= i@47@02 | live]
; [else-branch: 72 | !(i@47@02 < |First:(Second:($t@45@02))| && 0 <= i@47@02) | live]
(push) ; 10
; [then-branch: 72 | i@47@02 < |First:(Second:($t@45@02))| && 0 <= i@47@02]
(assert (and
  (<
    i@47@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))))
  (<= 0 i@47@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@47@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9148
;  :arith-add-rows          225
;  :arith-assert-diseq      520
;  :arith-assert-lower      877
;  :arith-assert-upper      616
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        558
;  :arith-fixed-eqs         297
;  :arith-offset-eqs        42
;  :arith-pivots            199
;  :binary-propagations     7
;  :conflicts               180
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1700
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4196
;  :mk-clause               1829
;  :num-allocs              4322435
;  :num-checks              211
;  :propagations            1453
;  :quant-instantiations    595
;  :rlimit-count            210794)
; [eval] -1
(push) ; 11
; [then-branch: 73 | First:(Second:($t@45@02))[i@47@02] == -1 | live]
; [else-branch: 73 | First:(Second:($t@45@02))[i@47@02] != -1 | live]
(push) ; 12
; [then-branch: 73 | First:(Second:($t@45@02))[i@47@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
    i@47@02)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 73 | First:(Second:($t@45@02))[i@47@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
      i@47@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@47@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9158
;  :arith-add-rows          226
;  :arith-assert-diseq      523
;  :arith-assert-lower      885
;  :arith-assert-upper      620
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        562
;  :arith-fixed-eqs         299
;  :arith-offset-eqs        42
;  :arith-pivots            199
;  :binary-propagations     7
;  :conflicts               180
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1700
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4214
;  :mk-clause               1840
;  :num-allocs              4322435
;  :num-checks              212
;  :propagations            1463
;  :quant-instantiations    599
;  :rlimit-count            211025)
(push) ; 13
; [then-branch: 74 | 0 <= First:(Second:($t@45@02))[i@47@02] | live]
; [else-branch: 74 | !(0 <= First:(Second:($t@45@02))[i@47@02]) | live]
(push) ; 14
; [then-branch: 74 | 0 <= First:(Second:($t@45@02))[i@47@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
    i@47@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@47@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9160
;  :arith-add-rows          227
;  :arith-assert-diseq      523
;  :arith-assert-lower      887
;  :arith-assert-upper      621
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        563
;  :arith-fixed-eqs         300
;  :arith-offset-eqs        42
;  :arith-pivots            200
;  :binary-propagations     7
;  :conflicts               180
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1700
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4218
;  :mk-clause               1840
;  :num-allocs              4322435
;  :num-checks              213
;  :propagations            1463
;  :quant-instantiations    599
;  :rlimit-count            211142)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 74 | !(0 <= First:(Second:($t@45@02))[i@47@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
      i@47@02))))
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
; [else-branch: 72 | !(i@47@02 < |First:(Second:($t@45@02))| && 0 <= i@47@02)]
(assert (not
  (and
    (<
      i@47@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))))
    (<= 0 i@47@02))))
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
(assert (not (forall ((i@47@02 Int)) (!
  (implies
    (and
      (<
        i@47@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))))
      (<= 0 i@47@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
          i@47@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
            i@47@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
            i@47@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
    i@47@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9160
;  :arith-add-rows          227
;  :arith-assert-diseq      525
;  :arith-assert-lower      888
;  :arith-assert-upper      622
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        565
;  :arith-fixed-eqs         301
;  :arith-offset-eqs        42
;  :arith-pivots            201
;  :binary-propagations     7
;  :conflicts               181
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1738
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4232
;  :mk-clause               1867
;  :num-allocs              4322435
;  :num-checks              214
;  :propagations            1465
;  :quant-instantiations    602
;  :rlimit-count            211634)
(assert (forall ((i@47@02 Int)) (!
  (implies
    (and
      (<
        i@47@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))))
      (<= 0 i@47@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
          i@47@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
            i@47@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
            i@47@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@45@02)))
    i@47@02))
  :qid |prog.l<no position>|)))
(declare-const $k@48@02 $Perm)
(assert ($Perm.isReadVar $k@48@02 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@48@02 $Perm.No) (< $Perm.No $k@48@02))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9160
;  :arith-add-rows          227
;  :arith-assert-diseq      526
;  :arith-assert-lower      890
;  :arith-assert-upper      623
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        566
;  :arith-fixed-eqs         301
;  :arith-offset-eqs        42
;  :arith-pivots            201
;  :binary-propagations     7
;  :conflicts               182
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1738
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4237
;  :mk-clause               1869
;  :num-allocs              4322435
;  :num-checks              215
;  :propagations            1466
;  :quant-instantiations    602
;  :rlimit-count            212159)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@31@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9160
;  :arith-add-rows          227
;  :arith-assert-diseq      526
;  :arith-assert-lower      890
;  :arith-assert-upper      623
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        566
;  :arith-fixed-eqs         301
;  :arith-offset-eqs        42
;  :arith-pivots            201
;  :binary-propagations     7
;  :conflicts               182
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1738
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4237
;  :mk-clause               1869
;  :num-allocs              4322435
;  :num-checks              216
;  :propagations            1466
;  :quant-instantiations    602
;  :rlimit-count            212170)
(assert (< $k@48@02 $k@31@02))
(assert (<= $Perm.No (- $k@31@02 $k@48@02)))
(assert (<= (- $k@31@02 $k@48@02) $Perm.Write))
(assert (implies (< $Perm.No (- $k@31@02 $k@48@02)) (not (= diz@8@02 $Ref.null))))
; [eval] diz.Main_half != null
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9160
;  :arith-add-rows          227
;  :arith-assert-diseq      526
;  :arith-assert-lower      892
;  :arith-assert-upper      624
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        566
;  :arith-fixed-eqs         301
;  :arith-offset-eqs        42
;  :arith-pivots            202
;  :binary-propagations     7
;  :conflicts               183
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1738
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4240
;  :mk-clause               1869
;  :num-allocs              4322435
;  :num-checks              217
;  :propagations            1466
;  :quant-instantiations    602
;  :rlimit-count            212384)
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9160
;  :arith-add-rows          227
;  :arith-assert-diseq      526
;  :arith-assert-lower      892
;  :arith-assert-upper      624
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        566
;  :arith-fixed-eqs         301
;  :arith-offset-eqs        42
;  :arith-pivots            202
;  :binary-propagations     7
;  :conflicts               184
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1738
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4240
;  :mk-clause               1869
;  :num-allocs              4322435
;  :num-checks              218
;  :propagations            1466
;  :quant-instantiations    602
;  :rlimit-count            212432)
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9160
;  :arith-add-rows          227
;  :arith-assert-diseq      526
;  :arith-assert-lower      892
;  :arith-assert-upper      624
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        566
;  :arith-fixed-eqs         301
;  :arith-offset-eqs        42
;  :arith-pivots            202
;  :binary-propagations     7
;  :conflicts               185
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1738
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4240
;  :mk-clause               1869
;  :num-allocs              4322435
;  :num-checks              219
;  :propagations            1466
;  :quant-instantiations    602
;  :rlimit-count            212480)
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9160
;  :arith-add-rows          227
;  :arith-assert-diseq      526
;  :arith-assert-lower      892
;  :arith-assert-upper      624
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        566
;  :arith-fixed-eqs         301
;  :arith-offset-eqs        42
;  :arith-pivots            202
;  :binary-propagations     7
;  :conflicts               186
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1738
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4240
;  :mk-clause               1869
;  :num-allocs              4322435
;  :num-checks              220
;  :propagations            1466
;  :quant-instantiations    602
;  :rlimit-count            212528)
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9160
;  :arith-add-rows          227
;  :arith-assert-diseq      526
;  :arith-assert-lower      892
;  :arith-assert-upper      624
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        566
;  :arith-fixed-eqs         301
;  :arith-offset-eqs        42
;  :arith-pivots            202
;  :binary-propagations     7
;  :conflicts               187
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1738
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4240
;  :mk-clause               1869
;  :num-allocs              4322435
;  :num-checks              221
;  :propagations            1466
;  :quant-instantiations    602
;  :rlimit-count            212576)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9160
;  :arith-add-rows          227
;  :arith-assert-diseq      526
;  :arith-assert-lower      892
;  :arith-assert-upper      624
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        566
;  :arith-fixed-eqs         301
;  :arith-offset-eqs        42
;  :arith-pivots            202
;  :binary-propagations     7
;  :conflicts               187
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1738
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4240
;  :mk-clause               1869
;  :num-allocs              4322435
;  :num-checks              222
;  :propagations            1466
;  :quant-instantiations    602
;  :rlimit-count            212589)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9160
;  :arith-add-rows          227
;  :arith-assert-diseq      526
;  :arith-assert-lower      892
;  :arith-assert-upper      624
;  :arith-bound-prop        80
;  :arith-conflicts         20
;  :arith-eq-adapter        566
;  :arith-fixed-eqs         301
;  :arith-offset-eqs        42
;  :arith-pivots            202
;  :binary-propagations     7
;  :conflicts               188
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 1720
;  :datatype-occurs-check   691
;  :datatype-splits         1102
;  :decisions               1810
;  :del-clause              1738
;  :final-checks            172
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4240
;  :mk-clause               1869
;  :num-allocs              4322435
;  :num-checks              223
;  :propagations            1466
;  :quant-instantiations    602
;  :rlimit-count            212637)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@45@02))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@02))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))))
                            ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))))))))))))))))))) diz@8@02 globals@9@02))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 7
(push) ; 7
; [else-branch: 38 | min_advance__29@39@02 != -1]
(assert (not (= min_advance__29@39@02 (- 0 1))))
(pop) ; 7
; [eval] !(min_advance__29 == -1)
; [eval] min_advance__29 == -1
; [eval] -1
(push) ; 7
(assert (not (= min_advance__29@39@02 (- 0 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9287
;  :arith-add-rows          228
;  :arith-assert-diseq      539
;  :arith-assert-lower      907
;  :arith-assert-upper      636
;  :arith-bound-prop        82
;  :arith-conflicts         20
;  :arith-eq-adapter        575
;  :arith-fixed-eqs         302
;  :arith-offset-eqs        43
;  :arith-pivots            207
;  :binary-propagations     7
;  :conflicts               189
;  :datatype-accessor-ax    253
;  :datatype-constructor-ax 1748
;  :datatype-occurs-check   705
;  :datatype-splits         1126
;  :decisions               1842
;  :del-clause              1827
;  :final-checks            176
;  :interface-eqs           15
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4294
;  :mk-clause               1903
;  :num-allocs              4322435
;  :num-checks              224
;  :propagations            1498
;  :quant-instantiations    606
;  :rlimit-count            213989
;  :time                    0.00)
(push) ; 7
(assert (not (not (= min_advance__29@39@02 (- 0 1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9418
;  :arith-add-rows          228
;  :arith-assert-diseq      553
;  :arith-assert-lower      922
;  :arith-assert-upper      650
;  :arith-bound-prop        82
;  :arith-conflicts         21
;  :arith-eq-adapter        585
;  :arith-fixed-eqs         304
;  :arith-offset-eqs        44
;  :arith-pivots            209
;  :binary-propagations     7
;  :conflicts               191
;  :datatype-accessor-ax    256
;  :datatype-constructor-ax 1776
;  :datatype-occurs-check   719
;  :datatype-splits         1150
;  :decisions               1875
;  :del-clause              1857
;  :final-checks            180
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4351
;  :mk-clause               1933
;  :num-allocs              4322435
;  :num-checks              225
;  :propagations            1532
;  :quant-instantiations    610
;  :rlimit-count            215244
;  :time                    0.00)
; [then-branch: 75 | min_advance__29@39@02 != -1 | live]
; [else-branch: 75 | min_advance__29@39@02 == -1 | live]
(push) ; 7
; [then-branch: 75 | min_advance__29@39@02 != -1]
(assert (not (= min_advance__29@39@02 (- 0 1))))
; [exec]
; __flatten_26__28 := Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__29), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__29))
; [eval] Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__29), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__29))
; [eval] (diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__29)
; [eval] diz.Main_event_state[0] < -1
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9419
;  :arith-add-rows          228
;  :arith-assert-diseq      555
;  :arith-assert-lower      922
;  :arith-assert-upper      650
;  :arith-bound-prop        82
;  :arith-conflicts         21
;  :arith-eq-adapter        586
;  :arith-fixed-eqs         304
;  :arith-offset-eqs        44
;  :arith-pivots            209
;  :binary-propagations     7
;  :conflicts               191
;  :datatype-accessor-ax    256
;  :datatype-constructor-ax 1776
;  :datatype-occurs-check   719
;  :datatype-splits         1150
;  :decisions               1875
;  :del-clause              1857
;  :final-checks            180
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4355
;  :mk-clause               1942
;  :num-allocs              4322435
;  :num-checks              226
;  :propagations            1532
;  :quant-instantiations    610
;  :rlimit-count            215334)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9545
;  :arith-add-rows          228
;  :arith-assert-diseq      566
;  :arith-assert-lower      937
;  :arith-assert-upper      662
;  :arith-bound-prop        86
;  :arith-conflicts         21
;  :arith-eq-adapter        594
;  :arith-fixed-eqs         305
;  :arith-offset-eqs        45
;  :arith-pivots            211
;  :binary-propagations     7
;  :conflicts               192
;  :datatype-accessor-ax    259
;  :datatype-constructor-ax 1804
;  :datatype-occurs-check   733
;  :datatype-splits         1174
;  :decisions               1905
;  :del-clause              1879
;  :final-checks            184
;  :interface-eqs           17
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4406
;  :mk-clause               1964
;  :num-allocs              4322435
;  :num-checks              227
;  :propagations            1560
;  :quant-instantiations    614
;  :rlimit-count            216599
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9670
;  :arith-add-rows          230
;  :arith-assert-diseq      577
;  :arith-assert-lower      955
;  :arith-assert-upper      671
;  :arith-bound-prop        89
;  :arith-conflicts         21
;  :arith-eq-adapter        602
;  :arith-fixed-eqs         307
;  :arith-offset-eqs        46
;  :arith-pivots            215
;  :binary-propagations     7
;  :conflicts               193
;  :datatype-accessor-ax    262
;  :datatype-constructor-ax 1832
;  :datatype-occurs-check   747
;  :datatype-splits         1198
;  :decisions               1936
;  :del-clause              1904
;  :final-checks            188
;  :interface-eqs           18
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4457
;  :mk-clause               1989
;  :num-allocs              4322435
;  :num-checks              228
;  :propagations            1590
;  :quant-instantiations    618
;  :rlimit-count            217900
;  :time                    0.00)
; [then-branch: 76 | First:(Second:(Second:(Second:($t@37@02))))[0] < -1 | live]
; [else-branch: 76 | !(First:(Second:(Second:(Second:($t@37@02))))[0] < -1) | live]
(push) ; 9
; [then-branch: 76 | First:(Second:(Second:(Second:($t@37@02))))[0] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
    0)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 76 | !(First:(Second:(Second:(Second:($t@37@02))))[0] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] - min_advance__29
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9670
;  :arith-add-rows          230
;  :arith-assert-diseq      577
;  :arith-assert-lower      956
;  :arith-assert-upper      672
;  :arith-bound-prop        89
;  :arith-conflicts         21
;  :arith-eq-adapter        602
;  :arith-fixed-eqs         307
;  :arith-offset-eqs        46
;  :arith-pivots            215
;  :binary-propagations     7
;  :conflicts               193
;  :datatype-accessor-ax    262
;  :datatype-constructor-ax 1832
;  :datatype-occurs-check   747
;  :datatype-splits         1198
;  :decisions               1936
;  :del-clause              1904
;  :final-checks            188
;  :interface-eqs           18
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4457
;  :mk-clause               1989
;  :num-allocs              4322435
;  :num-checks              229
;  :propagations            1592
;  :quant-instantiations    618
;  :rlimit-count            218063)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
; [eval] (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__29)
; [eval] diz.Main_event_state[1] < -1
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9670
;  :arith-add-rows          230
;  :arith-assert-diseq      577
;  :arith-assert-lower      956
;  :arith-assert-upper      672
;  :arith-bound-prop        89
;  :arith-conflicts         21
;  :arith-eq-adapter        602
;  :arith-fixed-eqs         307
;  :arith-offset-eqs        46
;  :arith-pivots            215
;  :binary-propagations     7
;  :conflicts               193
;  :datatype-accessor-ax    262
;  :datatype-constructor-ax 1832
;  :datatype-occurs-check   747
;  :datatype-splits         1198
;  :decisions               1936
;  :del-clause              1904
;  :final-checks            188
;  :interface-eqs           18
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4457
;  :mk-clause               1989
;  :num-allocs              4322435
;  :num-checks              230
;  :propagations            1592
;  :quant-instantiations    618
;  :rlimit-count            218078)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9795
;  :arith-add-rows          230
;  :arith-assert-diseq      588
;  :arith-assert-lower      972
;  :arith-assert-upper      684
;  :arith-bound-prop        93
;  :arith-conflicts         21
;  :arith-eq-adapter        610
;  :arith-fixed-eqs         309
;  :arith-offset-eqs        46
;  :arith-pivots            218
;  :binary-propagations     7
;  :conflicts               194
;  :datatype-accessor-ax    265
;  :datatype-constructor-ax 1860
;  :datatype-occurs-check   761
;  :datatype-splits         1222
;  :decisions               1966
;  :del-clause              1926
;  :final-checks            192
;  :interface-eqs           19
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4508
;  :mk-clause               2011
;  :num-allocs              4322435
;  :num-checks              231
;  :propagations            1621
;  :quant-instantiations    622
;  :rlimit-count            219345
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
    1)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9920
;  :arith-add-rows          232
;  :arith-assert-diseq      599
;  :arith-assert-lower      991
;  :arith-assert-upper      693
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        618
;  :arith-fixed-eqs         312
;  :arith-offset-eqs        46
;  :arith-pivots            222
;  :binary-propagations     7
;  :conflicts               195
;  :datatype-accessor-ax    268
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1951
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4560
;  :mk-clause               2036
;  :num-allocs              4322435
;  :num-checks              232
;  :propagations            1651
;  :quant-instantiations    626
;  :rlimit-count            220648
;  :time                    0.00)
; [then-branch: 77 | First:(Second:(Second:(Second:($t@37@02))))[1] < -1 | live]
; [else-branch: 77 | !(First:(Second:(Second:(Second:($t@37@02))))[1] < -1) | live]
(push) ; 9
; [then-branch: 77 | First:(Second:(Second:(Second:($t@37@02))))[1] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
    1)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 77 | !(First:(Second:(Second:(Second:($t@37@02))))[1] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] - min_advance__29
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9920
;  :arith-add-rows          232
;  :arith-assert-diseq      599
;  :arith-assert-lower      992
;  :arith-assert-upper      694
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        618
;  :arith-fixed-eqs         312
;  :arith-offset-eqs        46
;  :arith-pivots            222
;  :binary-propagations     7
;  :conflicts               195
;  :datatype-accessor-ax    268
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1951
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4560
;  :mk-clause               2036
;  :num-allocs              4322435
;  :num-checks              233
;  :propagations            1653
;  :quant-instantiations    626
;  :rlimit-count            220811)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (=
  (Seq_length
    (Seq_append
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
            0)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
            0)
          min_advance__29@39@02)))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
            1)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
            1)
          min_advance__29@39@02)))))
  2))
(declare-const __flatten_26__28@49@02 Seq<Int>)
(assert (Seq_equal
  __flatten_26__28@49@02
  (Seq_append
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
          0)
        (- 0 1))
      (- 0 3)
      (-
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
          0)
        min_advance__29@39@02)))
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
          1)
        (- 0 1))
      (- 0 3)
      (-
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))
          1)
        min_advance__29@39@02))))))
; [exec]
; __flatten_25__27 := __flatten_26__28
; [exec]
; diz.Main_event_state := __flatten_25__27
; [exec]
; Main_wakeup_after_wait_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(push) ; 8
(assert (not (= (Seq_length __flatten_26__28@49@02) 2)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9929
;  :arith-add-rows          236
;  :arith-assert-diseq      599
;  :arith-assert-lower      996
;  :arith-assert-upper      697
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        623
;  :arith-fixed-eqs         314
;  :arith-offset-eqs        46
;  :arith-pivots            224
;  :binary-propagations     7
;  :conflicts               196
;  :datatype-accessor-ax    268
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1951
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4594
;  :mk-clause               2058
;  :num-allocs              4322435
;  :num-checks              234
;  :propagations            1658
;  :quant-instantiations    630
;  :rlimit-count            221595)
(assert (= (Seq_length __flatten_26__28@49@02) 2))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@50@02 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 78 | 0 <= i@50@02 | live]
; [else-branch: 78 | !(0 <= i@50@02) | live]
(push) ; 10
; [then-branch: 78 | 0 <= i@50@02]
(assert (<= 0 i@50@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 78 | !(0 <= i@50@02)]
(assert (not (<= 0 i@50@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 79 | i@50@02 < |First:(Second:($t@37@02))| && 0 <= i@50@02 | live]
; [else-branch: 79 | !(i@50@02 < |First:(Second:($t@37@02))| && 0 <= i@50@02) | live]
(push) ; 10
; [then-branch: 79 | i@50@02 < |First:(Second:($t@37@02))| && 0 <= i@50@02]
(assert (and
  (<
    i@50@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
  (<= 0 i@50@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@50@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9931
;  :arith-add-rows          236
;  :arith-assert-diseq      599
;  :arith-assert-lower      998
;  :arith-assert-upper      699
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        624
;  :arith-fixed-eqs         315
;  :arith-offset-eqs        46
;  :arith-pivots            224
;  :binary-propagations     7
;  :conflicts               196
;  :datatype-accessor-ax    268
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1951
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4599
;  :mk-clause               2058
;  :num-allocs              4322435
;  :num-checks              235
;  :propagations            1658
;  :quant-instantiations    630
;  :rlimit-count            221786)
; [eval] -1
(push) ; 11
; [then-branch: 80 | First:(Second:($t@37@02))[i@50@02] == -1 | live]
; [else-branch: 80 | First:(Second:($t@37@02))[i@50@02] != -1 | live]
(push) ; 12
; [then-branch: 80 | First:(Second:($t@37@02))[i@50@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@50@02)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 80 | First:(Second:($t@37@02))[i@50@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      i@50@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@50@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9933
;  :arith-add-rows          236
;  :arith-assert-diseq      600
;  :arith-assert-lower      998
;  :arith-assert-upper      699
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        624
;  :arith-fixed-eqs         315
;  :arith-offset-eqs        46
;  :arith-pivots            224
;  :binary-propagations     7
;  :conflicts               196
;  :datatype-accessor-ax    268
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1951
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4600
;  :mk-clause               2058
;  :num-allocs              4322435
;  :num-checks              236
;  :propagations            1658
;  :quant-instantiations    630
;  :rlimit-count            221934)
(push) ; 13
; [then-branch: 81 | 0 <= First:(Second:($t@37@02))[i@50@02] | live]
; [else-branch: 81 | !(0 <= First:(Second:($t@37@02))[i@50@02]) | live]
(push) ; 14
; [then-branch: 81 | 0 <= First:(Second:($t@37@02))[i@50@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@50@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@50@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9935
;  :arith-add-rows          237
;  :arith-assert-diseq      600
;  :arith-assert-lower      1000
;  :arith-assert-upper      700
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        625
;  :arith-fixed-eqs         316
;  :arith-offset-eqs        46
;  :arith-pivots            225
;  :binary-propagations     7
;  :conflicts               196
;  :datatype-accessor-ax    268
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1951
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4604
;  :mk-clause               2058
;  :num-allocs              4322435
;  :num-checks              237
;  :propagations            1658
;  :quant-instantiations    630
;  :rlimit-count            222051)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 81 | !(0 <= First:(Second:($t@37@02))[i@50@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      i@50@02))))
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
; [else-branch: 79 | !(i@50@02 < |First:(Second:($t@37@02))| && 0 <= i@50@02)]
(assert (not
  (and
    (<
      i@50@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
    (<= 0 i@50@02))))
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
(assert (not (forall ((i@50@02 Int)) (!
  (implies
    (and
      (<
        i@50@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
      (<= 0 i@50@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          i@50@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@50@02)
          (Seq_length __flatten_26__28@49@02))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@50@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@50@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9935
;  :arith-add-rows          237
;  :arith-assert-diseq      601
;  :arith-assert-lower      1001
;  :arith-assert-upper      701
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        627
;  :arith-fixed-eqs         317
;  :arith-offset-eqs        46
;  :arith-pivots            226
;  :binary-propagations     7
;  :conflicts               197
;  :datatype-accessor-ax    268
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1976
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4618
;  :mk-clause               2083
;  :num-allocs              4322435
;  :num-checks              238
;  :propagations            1660
;  :quant-instantiations    633
;  :rlimit-count            222543)
(assert (forall ((i@50@02 Int)) (!
  (implies
    (and
      (<
        i@50@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
      (<= 0 i@50@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          i@50@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@50@02)
          (Seq_length __flatten_26__28@49@02))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@50@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@50@02))
  :qid |prog.l<no position>|)))
(declare-const $t@51@02 $Snap)
(assert (= $t@51@02 ($Snap.combine ($Snap.first $t@51@02) ($Snap.second $t@51@02))))
(assert (=
  ($Snap.second $t@51@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@51@02))
    ($Snap.second ($Snap.second $t@51@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@51@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@51@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@51@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@51@02))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@51@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@52@02 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 82 | 0 <= i@52@02 | live]
; [else-branch: 82 | !(0 <= i@52@02) | live]
(push) ; 10
; [then-branch: 82 | 0 <= i@52@02]
(assert (<= 0 i@52@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 82 | !(0 <= i@52@02)]
(assert (not (<= 0 i@52@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 83 | i@52@02 < |First:(Second:($t@51@02))| && 0 <= i@52@02 | live]
; [else-branch: 83 | !(i@52@02 < |First:(Second:($t@51@02))| && 0 <= i@52@02) | live]
(push) ; 10
; [then-branch: 83 | i@52@02 < |First:(Second:($t@51@02))| && 0 <= i@52@02]
(assert (and
  (<
    i@52@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))))
  (<= 0 i@52@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@52@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9973
;  :arith-add-rows          237
;  :arith-assert-diseq      601
;  :arith-assert-lower      1006
;  :arith-assert-upper      704
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        629
;  :arith-fixed-eqs         318
;  :arith-offset-eqs        46
;  :arith-pivots            226
;  :binary-propagations     7
;  :conflicts               197
;  :datatype-accessor-ax    274
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1976
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4640
;  :mk-clause               2083
;  :num-allocs              4322435
;  :num-checks              239
;  :propagations            1660
;  :quant-instantiations    638
;  :rlimit-count            223961)
; [eval] -1
(push) ; 11
; [then-branch: 84 | First:(Second:($t@51@02))[i@52@02] == -1 | live]
; [else-branch: 84 | First:(Second:($t@51@02))[i@52@02] != -1 | live]
(push) ; 12
; [then-branch: 84 | First:(Second:($t@51@02))[i@52@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
    i@52@02)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 84 | First:(Second:($t@51@02))[i@52@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
      i@52@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@52@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9973
;  :arith-add-rows          237
;  :arith-assert-diseq      601
;  :arith-assert-lower      1006
;  :arith-assert-upper      704
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        629
;  :arith-fixed-eqs         318
;  :arith-offset-eqs        46
;  :arith-pivots            226
;  :binary-propagations     7
;  :conflicts               197
;  :datatype-accessor-ax    274
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1976
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4641
;  :mk-clause               2083
;  :num-allocs              4322435
;  :num-checks              240
;  :propagations            1660
;  :quant-instantiations    638
;  :rlimit-count            224112)
(push) ; 13
; [then-branch: 85 | 0 <= First:(Second:($t@51@02))[i@52@02] | live]
; [else-branch: 85 | !(0 <= First:(Second:($t@51@02))[i@52@02]) | live]
(push) ; 14
; [then-branch: 85 | 0 <= First:(Second:($t@51@02))[i@52@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
    i@52@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@52@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9973
;  :arith-add-rows          237
;  :arith-assert-diseq      602
;  :arith-assert-lower      1009
;  :arith-assert-upper      704
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        630
;  :arith-fixed-eqs         318
;  :arith-offset-eqs        46
;  :arith-pivots            226
;  :binary-propagations     7
;  :conflicts               197
;  :datatype-accessor-ax    274
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1976
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4644
;  :mk-clause               2084
;  :num-allocs              4322435
;  :num-checks              241
;  :propagations            1660
;  :quant-instantiations    638
;  :rlimit-count            224216)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 85 | !(0 <= First:(Second:($t@51@02))[i@52@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
      i@52@02))))
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
; [else-branch: 83 | !(i@52@02 < |First:(Second:($t@51@02))| && 0 <= i@52@02)]
(assert (not
  (and
    (<
      i@52@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))))
    (<= 0 i@52@02))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@52@02 Int)) (!
  (implies
    (and
      (<
        i@52@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))))
      (<= 0 i@52@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
          i@52@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
            i@52@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
            i@52@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
    i@52@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
  __flatten_26__28@49@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9993
;  :arith-add-rows          237
;  :arith-assert-diseq      602
;  :arith-assert-lower      1010
;  :arith-assert-upper      705
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        632
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        46
;  :arith-pivots            226
;  :binary-propagations     7
;  :conflicts               197
;  :datatype-accessor-ax    276
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1977
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4667
;  :mk-clause               2100
;  :num-allocs              4322435
;  :num-checks              242
;  :propagations            1666
;  :quant-instantiations    640
;  :rlimit-count            225245)
(push) ; 8
; [then-branch: 86 | 0 <= First:(Second:($t@37@02))[0] | live]
; [else-branch: 86 | !(0 <= First:(Second:($t@37@02))[0]) | live]
(push) ; 9
; [then-branch: 86 | 0 <= First:(Second:($t@37@02))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9993
;  :arith-add-rows          237
;  :arith-assert-diseq      602
;  :arith-assert-lower      1010
;  :arith-assert-upper      705
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        632
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        46
;  :arith-pivots            226
;  :binary-propagations     7
;  :conflicts               197
;  :datatype-accessor-ax    276
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1977
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4667
;  :mk-clause               2100
;  :num-allocs              4322435
;  :num-checks              243
;  :propagations            1666
;  :quant-instantiations    640
;  :rlimit-count            225345)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9993
;  :arith-add-rows          237
;  :arith-assert-diseq      602
;  :arith-assert-lower      1010
;  :arith-assert-upper      705
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        632
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        46
;  :arith-pivots            226
;  :binary-propagations     7
;  :conflicts               197
;  :datatype-accessor-ax    276
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1977
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4667
;  :mk-clause               2100
;  :num-allocs              4322435
;  :num-checks              244
;  :propagations            1666
;  :quant-instantiations    640
;  :rlimit-count            225354)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (Seq_length __flatten_26__28@49@02))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9993
;  :arith-add-rows          237
;  :arith-assert-diseq      602
;  :arith-assert-lower      1010
;  :arith-assert-upper      705
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        632
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        46
;  :arith-pivots            226
;  :binary-propagations     7
;  :conflicts               198
;  :datatype-accessor-ax    276
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1977
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4667
;  :mk-clause               2100
;  :num-allocs              4322435
;  :num-checks              245
;  :propagations            1666
;  :quant-instantiations    640
;  :rlimit-count            225442)
(push) ; 10
; [then-branch: 87 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0 | live]
; [else-branch: 87 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] != 0 | live]
(push) ; 11
; [then-branch: 87 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_26__28@49@02
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 87 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_26__28@49@02
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9994
;  :arith-add-rows          238
;  :arith-assert-diseq      602
;  :arith-assert-lower      1010
;  :arith-assert-upper      705
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        632
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        46
;  :arith-pivots            226
;  :binary-propagations     7
;  :conflicts               198
;  :datatype-accessor-ax    276
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1977
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4672
;  :mk-clause               2105
;  :num-allocs              4322435
;  :num-checks              246
;  :propagations            1666
;  :quant-instantiations    641
;  :rlimit-count            225657)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9994
;  :arith-add-rows          238
;  :arith-assert-diseq      602
;  :arith-assert-lower      1010
;  :arith-assert-upper      705
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        632
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        46
;  :arith-pivots            226
;  :binary-propagations     7
;  :conflicts               198
;  :datatype-accessor-ax    276
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1977
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4672
;  :mk-clause               2105
;  :num-allocs              4322435
;  :num-checks              247
;  :propagations            1666
;  :quant-instantiations    641
;  :rlimit-count            225666)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (Seq_length __flatten_26__28@49@02))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9994
;  :arith-add-rows          238
;  :arith-assert-diseq      602
;  :arith-assert-lower      1010
;  :arith-assert-upper      705
;  :arith-bound-prop        96
;  :arith-conflicts         21
;  :arith-eq-adapter        632
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        46
;  :arith-pivots            226
;  :binary-propagations     7
;  :conflicts               199
;  :datatype-accessor-ax    276
;  :datatype-constructor-ax 1888
;  :datatype-occurs-check   775
;  :datatype-splits         1246
;  :decisions               1997
;  :del-clause              1977
;  :final-checks            196
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4672
;  :mk-clause               2105
;  :num-allocs              4322435
;  :num-checks              248
;  :propagations            1666
;  :quant-instantiations    641
;  :rlimit-count            225754)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 86 | !(0 <= First:(Second:($t@37@02))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
          __flatten_26__28@49@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        0)
      (=
        (Seq_index
          __flatten_26__28@49@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10262
;  :arith-add-rows          251
;  :arith-assert-diseq      618
;  :arith-assert-lower      1047
;  :arith-assert-upper      724
;  :arith-bound-prop        100
;  :arith-conflicts         21
;  :arith-eq-adapter        653
;  :arith-fixed-eqs         327
;  :arith-offset-eqs        46
;  :arith-pivots            237
;  :binary-propagations     7
;  :conflicts               204
;  :datatype-accessor-ax    281
;  :datatype-constructor-ax 1942
;  :datatype-occurs-check   797
;  :datatype-splits         1278
;  :decisions               2058
;  :del-clause              2061
;  :final-checks            201
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          87
;  :mk-bool-var             4803
;  :mk-clause               2184
;  :num-allocs              4322435
;  :num-checks              249
;  :propagations            1716
;  :quant-instantiations    660
;  :rlimit-count            228216
;  :time                    0.00)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_26__28@49@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      0)
    (=
      (Seq_index
        __flatten_26__28@49@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10558
;  :arith-add-rows          264
;  :arith-assert-diseq      639
;  :arith-assert-lower      1090
;  :arith-assert-upper      744
;  :arith-bound-prop        105
;  :arith-conflicts         22
;  :arith-eq-adapter        678
;  :arith-fixed-eqs         340
;  :arith-offset-eqs        48
;  :arith-pivots            247
;  :binary-propagations     7
;  :conflicts               211
;  :datatype-accessor-ax    286
;  :datatype-constructor-ax 1996
;  :datatype-occurs-check   819
;  :datatype-splits         1310
;  :decisions               2119
;  :del-clause              2158
;  :final-checks            206
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          93
;  :mk-bool-var             4956
;  :mk-clause               2281
;  :num-allocs              4322435
;  :num-checks              250
;  :propagations            1775
;  :quant-instantiations    684
;  :rlimit-count            230878
;  :time                    0.00)
; [then-branch: 88 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0] | live]
; [else-branch: 88 | !(__flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0]) | live]
(push) ; 9
; [then-branch: 88 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_26__28@49@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      0)
    (=
      (Seq_index
        __flatten_26__28@49@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10558
;  :arith-add-rows          264
;  :arith-assert-diseq      639
;  :arith-assert-lower      1090
;  :arith-assert-upper      744
;  :arith-bound-prop        105
;  :arith-conflicts         22
;  :arith-eq-adapter        678
;  :arith-fixed-eqs         340
;  :arith-offset-eqs        48
;  :arith-pivots            247
;  :binary-propagations     7
;  :conflicts               211
;  :datatype-accessor-ax    286
;  :datatype-constructor-ax 1996
;  :datatype-occurs-check   819
;  :datatype-splits         1310
;  :decisions               2119
;  :del-clause              2158
;  :final-checks            206
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          93
;  :mk-bool-var             4958
;  :mk-clause               2282
;  :num-allocs              4322435
;  :num-checks              251
;  :propagations            1775
;  :quant-instantiations    684
;  :rlimit-count            231046)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 88 | !(__flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_26__28@49@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        0)
      (=
        (Seq_index
          __flatten_26__28@49@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
          __flatten_26__28@49@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        0)
      (=
        (Seq_index
          __flatten_26__28@49@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@02))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10563
;  :arith-add-rows          264
;  :arith-assert-diseq      639
;  :arith-assert-lower      1090
;  :arith-assert-upper      744
;  :arith-bound-prop        105
;  :arith-conflicts         22
;  :arith-eq-adapter        678
;  :arith-fixed-eqs         340
;  :arith-offset-eqs        48
;  :arith-pivots            247
;  :binary-propagations     7
;  :conflicts               211
;  :datatype-accessor-ax    286
;  :datatype-constructor-ax 1996
;  :datatype-occurs-check   819
;  :datatype-splits         1310
;  :decisions               2119
;  :del-clause              2159
;  :final-checks            206
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          93
;  :mk-bool-var             4963
;  :mk-clause               2286
;  :num-allocs              4322435
;  :num-checks              252
;  :propagations            1775
;  :quant-instantiations    684
;  :rlimit-count            231428)
(push) ; 8
; [then-branch: 89 | 0 <= First:(Second:($t@37@02))[0] | live]
; [else-branch: 89 | !(0 <= First:(Second:($t@37@02))[0]) | live]
(push) ; 9
; [then-branch: 89 | 0 <= First:(Second:($t@37@02))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10563
;  :arith-add-rows          264
;  :arith-assert-diseq      639
;  :arith-assert-lower      1090
;  :arith-assert-upper      744
;  :arith-bound-prop        105
;  :arith-conflicts         22
;  :arith-eq-adapter        678
;  :arith-fixed-eqs         340
;  :arith-offset-eqs        48
;  :arith-pivots            247
;  :binary-propagations     7
;  :conflicts               211
;  :datatype-accessor-ax    286
;  :datatype-constructor-ax 1996
;  :datatype-occurs-check   819
;  :datatype-splits         1310
;  :decisions               2119
;  :del-clause              2159
;  :final-checks            206
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          93
;  :mk-bool-var             4963
;  :mk-clause               2286
;  :num-allocs              4322435
;  :num-checks              253
;  :propagations            1775
;  :quant-instantiations    684
;  :rlimit-count            231528)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10563
;  :arith-add-rows          264
;  :arith-assert-diseq      639
;  :arith-assert-lower      1090
;  :arith-assert-upper      744
;  :arith-bound-prop        105
;  :arith-conflicts         22
;  :arith-eq-adapter        678
;  :arith-fixed-eqs         340
;  :arith-offset-eqs        48
;  :arith-pivots            247
;  :binary-propagations     7
;  :conflicts               211
;  :datatype-accessor-ax    286
;  :datatype-constructor-ax 1996
;  :datatype-occurs-check   819
;  :datatype-splits         1310
;  :decisions               2119
;  :del-clause              2159
;  :final-checks            206
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          93
;  :mk-bool-var             4963
;  :mk-clause               2286
;  :num-allocs              4322435
;  :num-checks              254
;  :propagations            1775
;  :quant-instantiations    684
;  :rlimit-count            231537)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (Seq_length __flatten_26__28@49@02))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10563
;  :arith-add-rows          264
;  :arith-assert-diseq      639
;  :arith-assert-lower      1090
;  :arith-assert-upper      744
;  :arith-bound-prop        105
;  :arith-conflicts         22
;  :arith-eq-adapter        678
;  :arith-fixed-eqs         340
;  :arith-offset-eqs        48
;  :arith-pivots            247
;  :binary-propagations     7
;  :conflicts               212
;  :datatype-accessor-ax    286
;  :datatype-constructor-ax 1996
;  :datatype-occurs-check   819
;  :datatype-splits         1310
;  :decisions               2119
;  :del-clause              2159
;  :final-checks            206
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          93
;  :mk-bool-var             4963
;  :mk-clause               2286
;  :num-allocs              4322435
;  :num-checks              255
;  :propagations            1775
;  :quant-instantiations    684
;  :rlimit-count            231625)
(push) ; 10
; [then-branch: 90 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0 | live]
; [else-branch: 90 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] != 0 | live]
(push) ; 11
; [then-branch: 90 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_26__28@49@02
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 90 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_26__28@49@02
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10564
;  :arith-add-rows          265
;  :arith-assert-diseq      639
;  :arith-assert-lower      1090
;  :arith-assert-upper      744
;  :arith-bound-prop        105
;  :arith-conflicts         22
;  :arith-eq-adapter        678
;  :arith-fixed-eqs         340
;  :arith-offset-eqs        48
;  :arith-pivots            247
;  :binary-propagations     7
;  :conflicts               212
;  :datatype-accessor-ax    286
;  :datatype-constructor-ax 1996
;  :datatype-occurs-check   819
;  :datatype-splits         1310
;  :decisions               2119
;  :del-clause              2159
;  :final-checks            206
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          93
;  :mk-bool-var             4967
;  :mk-clause               2291
;  :num-allocs              4322435
;  :num-checks              256
;  :propagations            1775
;  :quant-instantiations    685
;  :rlimit-count            231782)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10564
;  :arith-add-rows          265
;  :arith-assert-diseq      639
;  :arith-assert-lower      1090
;  :arith-assert-upper      744
;  :arith-bound-prop        105
;  :arith-conflicts         22
;  :arith-eq-adapter        678
;  :arith-fixed-eqs         340
;  :arith-offset-eqs        48
;  :arith-pivots            247
;  :binary-propagations     7
;  :conflicts               212
;  :datatype-accessor-ax    286
;  :datatype-constructor-ax 1996
;  :datatype-occurs-check   819
;  :datatype-splits         1310
;  :decisions               2119
;  :del-clause              2159
;  :final-checks            206
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          93
;  :mk-bool-var             4967
;  :mk-clause               2291
;  :num-allocs              4322435
;  :num-checks              257
;  :propagations            1775
;  :quant-instantiations    685
;  :rlimit-count            231791)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (Seq_length __flatten_26__28@49@02))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10564
;  :arith-add-rows          265
;  :arith-assert-diseq      639
;  :arith-assert-lower      1090
;  :arith-assert-upper      744
;  :arith-bound-prop        105
;  :arith-conflicts         22
;  :arith-eq-adapter        678
;  :arith-fixed-eqs         340
;  :arith-offset-eqs        48
;  :arith-pivots            247
;  :binary-propagations     7
;  :conflicts               213
;  :datatype-accessor-ax    286
;  :datatype-constructor-ax 1996
;  :datatype-occurs-check   819
;  :datatype-splits         1310
;  :decisions               2119
;  :del-clause              2159
;  :final-checks            206
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          93
;  :mk-bool-var             4967
;  :mk-clause               2291
;  :num-allocs              4322435
;  :num-checks              258
;  :propagations            1775
;  :quant-instantiations    685
;  :rlimit-count            231879)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 89 | !(0 <= First:(Second:($t@37@02))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
        __flatten_26__28@49@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      0)
    (=
      (Seq_index
        __flatten_26__28@49@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10854
;  :arith-add-rows          275
;  :arith-assert-diseq      660
;  :arith-assert-lower      1133
;  :arith-assert-upper      764
;  :arith-bound-prop        110
;  :arith-conflicts         23
;  :arith-eq-adapter        703
;  :arith-fixed-eqs         351
;  :arith-offset-eqs        50
;  :arith-pivots            253
;  :binary-propagations     7
;  :conflicts               220
;  :datatype-accessor-ax    291
;  :datatype-constructor-ax 2049
;  :datatype-occurs-check   841
;  :datatype-splits         1341
;  :decisions               2179
;  :del-clause              2240
;  :final-checks            211
;  :interface-eqs           23
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          99
;  :mk-bool-var             5114
;  :mk-clause               2367
;  :num-allocs              4322435
;  :num-checks              259
;  :propagations            1828
;  :quant-instantiations    709
;  :rlimit-count            234463
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_26__28@49@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        0)
      (=
        (Seq_index
          __flatten_26__28@49@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11182
;  :arith-add-rows          284
;  :arith-assert-diseq      674
;  :arith-assert-lower      1162
;  :arith-assert-upper      779
;  :arith-bound-prop        114
;  :arith-conflicts         23
;  :arith-eq-adapter        720
;  :arith-fixed-eqs         357
;  :arith-offset-eqs        50
;  :arith-pivots            259
;  :binary-propagations     7
;  :conflicts               229
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 2121
;  :datatype-occurs-check   868
;  :datatype-splits         1378
;  :decisions               2255
;  :del-clause              2296
;  :final-checks            217
;  :interface-eqs           24
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          99
;  :mk-bool-var             5245
;  :mk-clause               2423
;  :num-allocs              4322435
;  :num-checks              260
;  :propagations            1872
;  :quant-instantiations    726
;  :rlimit-count            236984
;  :time                    0.00)
; [then-branch: 91 | !(__flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0]) | live]
; [else-branch: 91 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0] | live]
(push) ; 9
; [then-branch: 91 | !(__flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_26__28@49@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        0)
      (=
        (Seq_index
          __flatten_26__28@49@02
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11183
;  :arith-add-rows          285
;  :arith-assert-diseq      674
;  :arith-assert-lower      1162
;  :arith-assert-upper      779
;  :arith-bound-prop        114
;  :arith-conflicts         23
;  :arith-eq-adapter        720
;  :arith-fixed-eqs         357
;  :arith-offset-eqs        50
;  :arith-pivots            259
;  :binary-propagations     7
;  :conflicts               229
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 2121
;  :datatype-occurs-check   868
;  :datatype-splits         1378
;  :decisions               2255
;  :del-clause              2296
;  :final-checks            217
;  :interface-eqs           24
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          99
;  :mk-bool-var             5249
;  :mk-clause               2428
;  :num-allocs              4322435
;  :num-checks              261
;  :propagations            1874
;  :quant-instantiations    727
;  :rlimit-count            237171)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11183
;  :arith-add-rows          285
;  :arith-assert-diseq      674
;  :arith-assert-lower      1162
;  :arith-assert-upper      779
;  :arith-bound-prop        114
;  :arith-conflicts         23
;  :arith-eq-adapter        720
;  :arith-fixed-eqs         357
;  :arith-offset-eqs        50
;  :arith-pivots            259
;  :binary-propagations     7
;  :conflicts               229
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 2121
;  :datatype-occurs-check   868
;  :datatype-splits         1378
;  :decisions               2255
;  :del-clause              2296
;  :final-checks            217
;  :interface-eqs           24
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          99
;  :mk-bool-var             5249
;  :mk-clause               2428
;  :num-allocs              4322435
;  :num-checks              262
;  :propagations            1874
;  :quant-instantiations    727
;  :rlimit-count            237186)
(pop) ; 9
(push) ; 9
; [else-branch: 91 | __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == 0 || __flatten_26__28@49@02[First:(Second:($t@37@02))[0]] == -1 && 0 <= First:(Second:($t@37@02))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_26__28@49@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      0)
    (=
      (Seq_index
        __flatten_26__28@49@02
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
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
            __flatten_26__28@49@02
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
              0))
          0)
        (=
          (Seq_index
            __flatten_26__28@49@02
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; Main_reset_all_events_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@53@02 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 92 | 0 <= i@53@02 | live]
; [else-branch: 92 | !(0 <= i@53@02) | live]
(push) ; 10
; [then-branch: 92 | 0 <= i@53@02]
(assert (<= 0 i@53@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 92 | !(0 <= i@53@02)]
(assert (not (<= 0 i@53@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 93 | i@53@02 < |First:(Second:($t@51@02))| && 0 <= i@53@02 | live]
; [else-branch: 93 | !(i@53@02 < |First:(Second:($t@51@02))| && 0 <= i@53@02) | live]
(push) ; 10
; [then-branch: 93 | i@53@02 < |First:(Second:($t@51@02))| && 0 <= i@53@02]
(assert (and
  (<
    i@53@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))))
  (<= 0 i@53@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@53@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11476
;  :arith-add-rows          299
;  :arith-assert-diseq      695
;  :arith-assert-lower      1206
;  :arith-assert-upper      800
;  :arith-bound-prop        120
;  :arith-conflicts         24
;  :arith-eq-adapter        745
;  :arith-fixed-eqs         371
;  :arith-offset-eqs        52
;  :arith-pivots            265
;  :binary-propagations     7
;  :conflicts               236
;  :datatype-accessor-ax    305
;  :datatype-constructor-ax 2174
;  :datatype-occurs-check   890
;  :datatype-splits         1409
;  :decisions               2316
;  :del-clause              2390
;  :final-checks            222
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          105
;  :mk-bool-var             5402
;  :mk-clause               2519
;  :num-allocs              4322435
;  :num-checks              264
;  :propagations            1930
;  :quant-instantiations    752
;  :rlimit-count            240028)
; [eval] -1
(push) ; 11
; [then-branch: 94 | First:(Second:($t@51@02))[i@53@02] == -1 | live]
; [else-branch: 94 | First:(Second:($t@51@02))[i@53@02] != -1 | live]
(push) ; 12
; [then-branch: 94 | First:(Second:($t@51@02))[i@53@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
    i@53@02)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 94 | First:(Second:($t@51@02))[i@53@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
      i@53@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@53@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11482
;  :arith-add-rows          300
;  :arith-assert-diseq      697
;  :arith-assert-lower      1210
;  :arith-assert-upper      802
;  :arith-bound-prop        120
;  :arith-conflicts         24
;  :arith-eq-adapter        747
;  :arith-fixed-eqs         372
;  :arith-offset-eqs        52
;  :arith-pivots            265
;  :binary-propagations     7
;  :conflicts               236
;  :datatype-accessor-ax    305
;  :datatype-constructor-ax 2174
;  :datatype-occurs-check   890
;  :datatype-splits         1409
;  :decisions               2316
;  :del-clause              2390
;  :final-checks            222
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          105
;  :mk-bool-var             5411
;  :mk-clause               2524
;  :num-allocs              4322435
;  :num-checks              265
;  :propagations            1937
;  :quant-instantiations    754
;  :rlimit-count            240231)
(push) ; 13
; [then-branch: 95 | 0 <= First:(Second:($t@51@02))[i@53@02] | live]
; [else-branch: 95 | !(0 <= First:(Second:($t@51@02))[i@53@02]) | live]
(push) ; 14
; [then-branch: 95 | 0 <= First:(Second:($t@51@02))[i@53@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
    i@53@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@53@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11484
;  :arith-add-rows          301
;  :arith-assert-diseq      697
;  :arith-assert-lower      1212
;  :arith-assert-upper      803
;  :arith-bound-prop        120
;  :arith-conflicts         24
;  :arith-eq-adapter        748
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        52
;  :arith-pivots            266
;  :binary-propagations     7
;  :conflicts               236
;  :datatype-accessor-ax    305
;  :datatype-constructor-ax 2174
;  :datatype-occurs-check   890
;  :datatype-splits         1409
;  :decisions               2316
;  :del-clause              2390
;  :final-checks            222
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          105
;  :mk-bool-var             5415
;  :mk-clause               2524
;  :num-allocs              4322435
;  :num-checks              266
;  :propagations            1937
;  :quant-instantiations    754
;  :rlimit-count            240350)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 95 | !(0 <= First:(Second:($t@51@02))[i@53@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
      i@53@02))))
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
; [else-branch: 93 | !(i@53@02 < |First:(Second:($t@51@02))| && 0 <= i@53@02)]
(assert (not
  (and
    (<
      i@53@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))))
    (<= 0 i@53@02))))
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
(assert (not (forall ((i@53@02 Int)) (!
  (implies
    (and
      (<
        i@53@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))))
      (<= 0 i@53@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
          i@53@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
            i@53@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
            i@53@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
    i@53@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11484
;  :arith-add-rows          301
;  :arith-assert-diseq      698
;  :arith-assert-lower      1213
;  :arith-assert-upper      804
;  :arith-bound-prop        120
;  :arith-conflicts         24
;  :arith-eq-adapter        749
;  :arith-fixed-eqs         374
;  :arith-offset-eqs        52
;  :arith-pivots            267
;  :binary-propagations     7
;  :conflicts               237
;  :datatype-accessor-ax    305
;  :datatype-constructor-ax 2174
;  :datatype-occurs-check   890
;  :datatype-splits         1409
;  :decisions               2316
;  :del-clause              2407
;  :final-checks            222
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          105
;  :mk-bool-var             5423
;  :mk-clause               2536
;  :num-allocs              4322435
;  :num-checks              267
;  :propagations            1939
;  :quant-instantiations    755
;  :rlimit-count            240776)
(assert (forall ((i@53@02 Int)) (!
  (implies
    (and
      (<
        i@53@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))))
      (<= 0 i@53@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
          i@53@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
            i@53@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
            i@53@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))
    i@53@02))
  :qid |prog.l<no position>|)))
(declare-const $t@54@02 $Snap)
(assert (= $t@54@02 ($Snap.combine ($Snap.first $t@54@02) ($Snap.second $t@54@02))))
(assert (=
  ($Snap.second $t@54@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@54@02))
    ($Snap.second ($Snap.second $t@54@02)))))
(assert (=
  ($Snap.second ($Snap.second $t@54@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@54@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@54@02))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@54@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@55@02 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 96 | 0 <= i@55@02 | live]
; [else-branch: 96 | !(0 <= i@55@02) | live]
(push) ; 10
; [then-branch: 96 | 0 <= i@55@02]
(assert (<= 0 i@55@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 96 | !(0 <= i@55@02)]
(assert (not (<= 0 i@55@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 97 | i@55@02 < |First:(Second:($t@54@02))| && 0 <= i@55@02 | live]
; [else-branch: 97 | !(i@55@02 < |First:(Second:($t@54@02))| && 0 <= i@55@02) | live]
(push) ; 10
; [then-branch: 97 | i@55@02 < |First:(Second:($t@54@02))| && 0 <= i@55@02]
(assert (and
  (<
    i@55@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))))
  (<= 0 i@55@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@55@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11522
;  :arith-add-rows          301
;  :arith-assert-diseq      698
;  :arith-assert-lower      1218
;  :arith-assert-upper      807
;  :arith-bound-prop        120
;  :arith-conflicts         24
;  :arith-eq-adapter        751
;  :arith-fixed-eqs         375
;  :arith-offset-eqs        52
;  :arith-pivots            267
;  :binary-propagations     7
;  :conflicts               237
;  :datatype-accessor-ax    311
;  :datatype-constructor-ax 2174
;  :datatype-occurs-check   890
;  :datatype-splits         1409
;  :decisions               2316
;  :del-clause              2407
;  :final-checks            222
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          105
;  :mk-bool-var             5445
;  :mk-clause               2536
;  :num-allocs              4322435
;  :num-checks              268
;  :propagations            1939
;  :quant-instantiations    759
;  :rlimit-count            242168)
; [eval] -1
(push) ; 11
; [then-branch: 98 | First:(Second:($t@54@02))[i@55@02] == -1 | live]
; [else-branch: 98 | First:(Second:($t@54@02))[i@55@02] != -1 | live]
(push) ; 12
; [then-branch: 98 | First:(Second:($t@54@02))[i@55@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
    i@55@02)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 98 | First:(Second:($t@54@02))[i@55@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
      i@55@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@55@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11522
;  :arith-add-rows          301
;  :arith-assert-diseq      698
;  :arith-assert-lower      1218
;  :arith-assert-upper      807
;  :arith-bound-prop        120
;  :arith-conflicts         24
;  :arith-eq-adapter        751
;  :arith-fixed-eqs         375
;  :arith-offset-eqs        52
;  :arith-pivots            267
;  :binary-propagations     7
;  :conflicts               237
;  :datatype-accessor-ax    311
;  :datatype-constructor-ax 2174
;  :datatype-occurs-check   890
;  :datatype-splits         1409
;  :decisions               2316
;  :del-clause              2407
;  :final-checks            222
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          105
;  :mk-bool-var             5446
;  :mk-clause               2536
;  :num-allocs              4322435
;  :num-checks              269
;  :propagations            1939
;  :quant-instantiations    759
;  :rlimit-count            242319)
(push) ; 13
; [then-branch: 99 | 0 <= First:(Second:($t@54@02))[i@55@02] | live]
; [else-branch: 99 | !(0 <= First:(Second:($t@54@02))[i@55@02]) | live]
(push) ; 14
; [then-branch: 99 | 0 <= First:(Second:($t@54@02))[i@55@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
    i@55@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@55@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11522
;  :arith-add-rows          301
;  :arith-assert-diseq      699
;  :arith-assert-lower      1221
;  :arith-assert-upper      807
;  :arith-bound-prop        120
;  :arith-conflicts         24
;  :arith-eq-adapter        752
;  :arith-fixed-eqs         375
;  :arith-offset-eqs        52
;  :arith-pivots            267
;  :binary-propagations     7
;  :conflicts               237
;  :datatype-accessor-ax    311
;  :datatype-constructor-ax 2174
;  :datatype-occurs-check   890
;  :datatype-splits         1409
;  :decisions               2316
;  :del-clause              2407
;  :final-checks            222
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          105
;  :mk-bool-var             5449
;  :mk-clause               2537
;  :num-allocs              4322435
;  :num-checks              270
;  :propagations            1939
;  :quant-instantiations    759
;  :rlimit-count            242423)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 99 | !(0 <= First:(Second:($t@54@02))[i@55@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
      i@55@02))))
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
; [else-branch: 97 | !(i@55@02 < |First:(Second:($t@54@02))| && 0 <= i@55@02)]
(assert (not
  (and
    (<
      i@55@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))))
    (<= 0 i@55@02))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@55@02 Int)) (!
  (implies
    (and
      (<
        i@55@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))))
      (<= 0 i@55@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
          i@55@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
            i@55@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
            i@55@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
    i@55@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@02)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11540
;  :arith-add-rows          301
;  :arith-assert-diseq      699
;  :arith-assert-lower      1222
;  :arith-assert-upper      808
;  :arith-bound-prop        120
;  :arith-conflicts         24
;  :arith-eq-adapter        753
;  :arith-fixed-eqs         376
;  :arith-offset-eqs        52
;  :arith-pivots            267
;  :binary-propagations     7
;  :conflicts               237
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 2174
;  :datatype-occurs-check   890
;  :datatype-splits         1409
;  :decisions               2316
;  :del-clause              2408
;  :final-checks            222
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          105
;  :mk-bool-var             5469
;  :mk-clause               2547
;  :num-allocs              4322435
;  :num-checks              271
;  :propagations            1943
;  :quant-instantiations    761
;  :rlimit-count            243438)
(push) ; 8
; [then-branch: 100 | First:(Second:(Second:(Second:($t@51@02))))[0] == 0 | live]
; [else-branch: 100 | First:(Second:(Second:(Second:($t@51@02))))[0] != 0 | live]
(push) ; 9
; [then-branch: 100 | First:(Second:(Second:(Second:($t@51@02))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 100 | First:(Second:(Second:(Second:($t@51@02))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11541
;  :arith-add-rows          301
;  :arith-assert-diseq      699
;  :arith-assert-lower      1222
;  :arith-assert-upper      808
;  :arith-bound-prop        120
;  :arith-conflicts         24
;  :arith-eq-adapter        753
;  :arith-fixed-eqs         376
;  :arith-offset-eqs        52
;  :arith-pivots            267
;  :binary-propagations     7
;  :conflicts               237
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 2174
;  :datatype-occurs-check   890
;  :datatype-splits         1409
;  :decisions               2316
;  :del-clause              2408
;  :final-checks            222
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          105
;  :mk-bool-var             5473
;  :mk-clause               2552
;  :num-allocs              4322435
;  :num-checks              272
;  :propagations            1943
;  :quant-instantiations    762
;  :rlimit-count            243650)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11837
;  :arith-add-rows          305
;  :arith-assert-diseq      719
;  :arith-assert-lower      1262
;  :arith-assert-upper      822
;  :arith-bound-prop        120
;  :arith-conflicts         24
;  :arith-eq-adapter        773
;  :arith-fixed-eqs         387
;  :arith-offset-eqs        53
;  :arith-pivots            274
;  :binary-propagations     7
;  :conflicts               239
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 2238
;  :datatype-occurs-check   914
;  :datatype-splits         1445
;  :decisions               2385
;  :del-clause              2481
;  :final-checks            225
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          105
;  :mk-bool-var             5579
;  :mk-clause               2620
;  :num-allocs              4322435
;  :num-checks              273
;  :propagations            2001
;  :quant-instantiations    780
;  :rlimit-count            246058
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12328
;  :arith-add-rows          331
;  :arith-assert-diseq      762
;  :arith-assert-lower      1338
;  :arith-assert-upper      858
;  :arith-bound-prop        127
;  :arith-conflicts         25
;  :arith-eq-adapter        818
;  :arith-fixed-eqs         402
;  :arith-offset-eqs        62
;  :arith-pivots            294
;  :binary-propagations     7
;  :conflicts               247
;  :datatype-accessor-ax    335
;  :datatype-constructor-ax 2327
;  :datatype-occurs-check   964
;  :datatype-splits         1541
;  :decisions               2477
;  :del-clause              2621
;  :final-checks            230
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          106
;  :mk-bool-var             5822
;  :mk-clause               2760
;  :num-allocs              4322435
;  :num-checks              274
;  :propagations            2124
;  :quant-instantiations    823
;  :rlimit-count            249779
;  :time                    0.00)
; [then-branch: 101 | First:(Second:(Second:(Second:($t@51@02))))[0] == 0 || First:(Second:(Second:(Second:($t@51@02))))[0] == -1 | live]
; [else-branch: 101 | !(First:(Second:(Second:(Second:($t@51@02))))[0] == 0 || First:(Second:(Second:(Second:($t@51@02))))[0] == -1) | live]
(push) ; 9
; [then-branch: 101 | First:(Second:(Second:(Second:($t@51@02))))[0] == 0 || First:(Second:(Second:(Second:($t@51@02))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12328
;  :arith-add-rows          331
;  :arith-assert-diseq      762
;  :arith-assert-lower      1338
;  :arith-assert-upper      858
;  :arith-bound-prop        127
;  :arith-conflicts         25
;  :arith-eq-adapter        818
;  :arith-fixed-eqs         402
;  :arith-offset-eqs        62
;  :arith-pivots            294
;  :binary-propagations     7
;  :conflicts               247
;  :datatype-accessor-ax    335
;  :datatype-constructor-ax 2327
;  :datatype-occurs-check   964
;  :datatype-splits         1541
;  :decisions               2477
;  :del-clause              2621
;  :final-checks            230
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          106
;  :mk-bool-var             5824
;  :mk-clause               2761
;  :num-allocs              4322435
;  :num-checks              275
;  :propagations            2124
;  :quant-instantiations    823
;  :rlimit-count            249928)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 101 | !(First:(Second:(Second:(Second:($t@51@02))))[0] == 0 || First:(Second:(Second:(Second:($t@51@02))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12334
;  :arith-add-rows          331
;  :arith-assert-diseq      762
;  :arith-assert-lower      1338
;  :arith-assert-upper      858
;  :arith-bound-prop        127
;  :arith-conflicts         25
;  :arith-eq-adapter        818
;  :arith-fixed-eqs         402
;  :arith-offset-eqs        62
;  :arith-pivots            294
;  :binary-propagations     7
;  :conflicts               247
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 2327
;  :datatype-occurs-check   964
;  :datatype-splits         1541
;  :decisions               2477
;  :del-clause              2622
;  :final-checks            230
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          106
;  :mk-bool-var             5830
;  :mk-clause               2765
;  :num-allocs              4322435
;  :num-checks              276
;  :propagations            2124
;  :quant-instantiations    823
;  :rlimit-count            250411)
(push) ; 8
; [then-branch: 102 | First:(Second:(Second:(Second:($t@51@02))))[1] == 0 | live]
; [else-branch: 102 | First:(Second:(Second:(Second:($t@51@02))))[1] != 0 | live]
(push) ; 9
; [then-branch: 102 | First:(Second:(Second:(Second:($t@51@02))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 102 | First:(Second:(Second:(Second:($t@51@02))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12335
;  :arith-add-rows          331
;  :arith-assert-diseq      762
;  :arith-assert-lower      1338
;  :arith-assert-upper      858
;  :arith-bound-prop        127
;  :arith-conflicts         25
;  :arith-eq-adapter        818
;  :arith-fixed-eqs         402
;  :arith-offset-eqs        62
;  :arith-pivots            294
;  :binary-propagations     7
;  :conflicts               247
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 2327
;  :datatype-occurs-check   964
;  :datatype-splits         1541
;  :decisions               2477
;  :del-clause              2622
;  :final-checks            230
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.59
;  :memory                  4.59
;  :minimized-lits          106
;  :mk-bool-var             5835
;  :mk-clause               2771
;  :num-allocs              4322435
;  :num-checks              277
;  :propagations            2124
;  :quant-instantiations    824
;  :rlimit-count            250595)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13101
;  :arith-add-rows          349
;  :arith-assert-diseq      799
;  :arith-assert-lower      1411
;  :arith-assert-upper      892
;  :arith-bound-prop        131
;  :arith-conflicts         26
;  :arith-eq-adapter        855
;  :arith-fixed-eqs         438
;  :arith-offset-eqs        81
;  :arith-pivots            304
;  :binary-propagations     7
;  :conflicts               260
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 2460
;  :datatype-occurs-check   1020
;  :datatype-splits         1623
;  :decisions               2620
;  :del-clause              2774
;  :final-checks            237
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          110
;  :mk-bool-var             6102
;  :mk-clause               2917
;  :num-allocs              4528738
;  :num-checks              278
;  :propagations            2268
;  :quant-instantiations    878
;  :rlimit-count            255708
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13627
;  :arith-add-rows          355
;  :arith-assert-diseq      846
;  :arith-assert-lower      1496
;  :arith-assert-upper      921
;  :arith-bound-prop        135
;  :arith-conflicts         26
;  :arith-eq-adapter        895
;  :arith-fixed-eqs         467
;  :arith-offset-eqs        86
;  :arith-pivots            318
;  :binary-propagations     7
;  :conflicts               265
;  :datatype-accessor-ax    369
;  :datatype-constructor-ax 2561
;  :datatype-occurs-check   1070
;  :datatype-splits         1697
;  :decisions               2727
;  :del-clause              2915
;  :final-checks            243
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          112
;  :mk-bool-var             6324
;  :mk-clause               3058
;  :num-allocs              4528738
;  :num-checks              279
;  :propagations            2393
;  :quant-instantiations    916
;  :rlimit-count            259395
;  :time                    0.00)
; [then-branch: 103 | First:(Second:(Second:(Second:($t@51@02))))[1] == 0 || First:(Second:(Second:(Second:($t@51@02))))[1] == -1 | live]
; [else-branch: 103 | !(First:(Second:(Second:(Second:($t@51@02))))[1] == 0 || First:(Second:(Second:(Second:($t@51@02))))[1] == -1) | live]
(push) ; 9
; [then-branch: 103 | First:(Second:(Second:(Second:($t@51@02))))[1] == 0 || First:(Second:(Second:(Second:($t@51@02))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13627
;  :arith-add-rows          355
;  :arith-assert-diseq      846
;  :arith-assert-lower      1496
;  :arith-assert-upper      921
;  :arith-bound-prop        135
;  :arith-conflicts         26
;  :arith-eq-adapter        895
;  :arith-fixed-eqs         467
;  :arith-offset-eqs        86
;  :arith-pivots            318
;  :binary-propagations     7
;  :conflicts               265
;  :datatype-accessor-ax    369
;  :datatype-constructor-ax 2561
;  :datatype-occurs-check   1070
;  :datatype-splits         1697
;  :decisions               2727
;  :del-clause              2915
;  :final-checks            243
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          112
;  :mk-bool-var             6326
;  :mk-clause               3059
;  :num-allocs              4528738
;  :num-checks              280
;  :propagations            2393
;  :quant-instantiations    916
;  :rlimit-count            259544)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 103 | !(First:(Second:(Second:(Second:($t@51@02))))[1] == 0 || First:(Second:(Second:(Second:($t@51@02))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13633
;  :arith-add-rows          355
;  :arith-assert-diseq      846
;  :arith-assert-lower      1496
;  :arith-assert-upper      921
;  :arith-bound-prop        135
;  :arith-conflicts         26
;  :arith-eq-adapter        895
;  :arith-fixed-eqs         467
;  :arith-offset-eqs        86
;  :arith-pivots            318
;  :binary-propagations     7
;  :conflicts               265
;  :datatype-accessor-ax    370
;  :datatype-constructor-ax 2561
;  :datatype-occurs-check   1070
;  :datatype-splits         1697
;  :decisions               2727
;  :del-clause              2916
;  :final-checks            243
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          112
;  :mk-bool-var             6332
;  :mk-clause               3063
;  :num-allocs              4528738
;  :num-checks              281
;  :propagations            2393
;  :quant-instantiations    916
;  :rlimit-count            260033)
(push) ; 8
; [then-branch: 104 | First:(Second:(Second:(Second:($t@51@02))))[0] == 0 | live]
; [else-branch: 104 | First:(Second:(Second:(Second:($t@51@02))))[0] != 0 | live]
(push) ; 9
; [then-branch: 104 | First:(Second:(Second:(Second:($t@51@02))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 104 | First:(Second:(Second:(Second:($t@51@02))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13634
;  :arith-add-rows          355
;  :arith-assert-diseq      846
;  :arith-assert-lower      1496
;  :arith-assert-upper      921
;  :arith-bound-prop        135
;  :arith-conflicts         26
;  :arith-eq-adapter        895
;  :arith-fixed-eqs         467
;  :arith-offset-eqs        86
;  :arith-pivots            318
;  :binary-propagations     7
;  :conflicts               265
;  :datatype-accessor-ax    370
;  :datatype-constructor-ax 2561
;  :datatype-occurs-check   1070
;  :datatype-splits         1697
;  :decisions               2727
;  :del-clause              2916
;  :final-checks            243
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          112
;  :mk-bool-var             6335
;  :mk-clause               3068
;  :num-allocs              4528738
;  :num-checks              282
;  :propagations            2393
;  :quant-instantiations    917
;  :rlimit-count            260201)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14199
;  :arith-add-rows          376
;  :arith-assert-diseq      898
;  :arith-assert-lower      1581
;  :arith-assert-upper      958
;  :arith-bound-prop        142
;  :arith-conflicts         26
;  :arith-eq-adapter        941
;  :arith-fixed-eqs         483
;  :arith-offset-eqs        94
;  :arith-pivots            340
;  :binary-propagations     7
;  :conflicts               274
;  :datatype-accessor-ax    384
;  :datatype-constructor-ax 2665
;  :datatype-occurs-check   1120
;  :datatype-splits         1771
;  :decisions               2837
;  :del-clause              3074
;  :final-checks            249
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          114
;  :mk-bool-var             6576
;  :mk-clause               3221
;  :num-allocs              4528738
;  :num-checks              283
;  :propagations            2534
;  :quant-instantiations    964
;  :rlimit-count            264316
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14710
;  :arith-add-rows          381
;  :arith-assert-diseq      935
;  :arith-assert-lower      1656
;  :arith-assert-upper      983
;  :arith-bound-prop        142
;  :arith-conflicts         26
;  :arith-eq-adapter        977
;  :arith-fixed-eqs         506
;  :arith-offset-eqs        98
;  :arith-pivots            354
;  :binary-propagations     7
;  :conflicts               279
;  :datatype-accessor-ax    398
;  :datatype-constructor-ax 2766
;  :datatype-occurs-check   1170
;  :datatype-splits         1845
;  :decisions               2946
;  :del-clause              3198
;  :final-checks            255
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          114
;  :mk-bool-var             6778
;  :mk-clause               3345
;  :num-allocs              4528738
;  :num-checks              284
;  :propagations            2646
;  :quant-instantiations    998
;  :rlimit-count            267890
;  :time                    0.00)
; [then-branch: 105 | !(First:(Second:(Second:(Second:($t@51@02))))[0] == 0 || First:(Second:(Second:(Second:($t@51@02))))[0] == -1) | live]
; [else-branch: 105 | First:(Second:(Second:(Second:($t@51@02))))[0] == 0 || First:(Second:(Second:(Second:($t@51@02))))[0] == -1 | live]
(push) ; 9
; [then-branch: 105 | !(First:(Second:(Second:(Second:($t@51@02))))[0] == 0 || First:(Second:(Second:(Second:($t@51@02))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14711
;  :arith-add-rows          381
;  :arith-assert-diseq      935
;  :arith-assert-lower      1656
;  :arith-assert-upper      983
;  :arith-bound-prop        142
;  :arith-conflicts         26
;  :arith-eq-adapter        977
;  :arith-fixed-eqs         506
;  :arith-offset-eqs        98
;  :arith-pivots            354
;  :binary-propagations     7
;  :conflicts               279
;  :datatype-accessor-ax    398
;  :datatype-constructor-ax 2766
;  :datatype-occurs-check   1170
;  :datatype-splits         1845
;  :decisions               2946
;  :del-clause              3198
;  :final-checks            255
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          114
;  :mk-bool-var             6781
;  :mk-clause               3350
;  :num-allocs              4528738
;  :num-checks              285
;  :propagations            2647
;  :quant-instantiations    999
;  :rlimit-count            268079)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14711
;  :arith-add-rows          381
;  :arith-assert-diseq      935
;  :arith-assert-lower      1656
;  :arith-assert-upper      983
;  :arith-bound-prop        142
;  :arith-conflicts         26
;  :arith-eq-adapter        977
;  :arith-fixed-eqs         506
;  :arith-offset-eqs        98
;  :arith-pivots            354
;  :binary-propagations     7
;  :conflicts               279
;  :datatype-accessor-ax    398
;  :datatype-constructor-ax 2766
;  :datatype-occurs-check   1170
;  :datatype-splits         1845
;  :decisions               2946
;  :del-clause              3198
;  :final-checks            255
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          114
;  :mk-bool-var             6781
;  :mk-clause               3350
;  :num-allocs              4528738
;  :num-checks              286
;  :propagations            2647
;  :quant-instantiations    999
;  :rlimit-count            268094)
(pop) ; 9
(push) ; 9
; [else-branch: 105 | First:(Second:(Second:(Second:($t@51@02))))[0] == 0 || First:(Second:(Second:(Second:($t@51@02))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@02))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14718
;  :arith-add-rows          381
;  :arith-assert-diseq      935
;  :arith-assert-lower      1656
;  :arith-assert-upper      983
;  :arith-bound-prop        142
;  :arith-conflicts         26
;  :arith-eq-adapter        977
;  :arith-fixed-eqs         506
;  :arith-offset-eqs        98
;  :arith-pivots            354
;  :binary-propagations     7
;  :conflicts               279
;  :datatype-accessor-ax    398
;  :datatype-constructor-ax 2766
;  :datatype-occurs-check   1170
;  :datatype-splits         1845
;  :decisions               2946
;  :del-clause              3203
;  :final-checks            255
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          114
;  :mk-bool-var             6783
;  :mk-clause               3351
;  :num-allocs              4528738
;  :num-checks              287
;  :propagations            2647
;  :quant-instantiations    999
;  :rlimit-count            268446)
(push) ; 8
; [then-branch: 106 | First:(Second:(Second:(Second:($t@51@02))))[1] == 0 | live]
; [else-branch: 106 | First:(Second:(Second:(Second:($t@51@02))))[1] != 0 | live]
(push) ; 9
; [then-branch: 106 | First:(Second:(Second:(Second:($t@51@02))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 106 | First:(Second:(Second:(Second:($t@51@02))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14719
;  :arith-add-rows          381
;  :arith-assert-diseq      935
;  :arith-assert-lower      1656
;  :arith-assert-upper      983
;  :arith-bound-prop        142
;  :arith-conflicts         26
;  :arith-eq-adapter        977
;  :arith-fixed-eqs         506
;  :arith-offset-eqs        98
;  :arith-pivots            354
;  :binary-propagations     7
;  :conflicts               279
;  :datatype-accessor-ax    398
;  :datatype-constructor-ax 2766
;  :datatype-occurs-check   1170
;  :datatype-splits         1845
;  :decisions               2946
;  :del-clause              3203
;  :final-checks            255
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          114
;  :mk-bool-var             6787
;  :mk-clause               3357
;  :num-allocs              4528738
;  :num-checks              288
;  :propagations            2647
;  :quant-instantiations    1000
;  :rlimit-count            268614)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15247
;  :arith-add-rows          388
;  :arith-assert-diseq      982
;  :arith-assert-lower      1741
;  :arith-assert-upper      1012
;  :arith-bound-prop        146
;  :arith-conflicts         26
;  :arith-eq-adapter        1017
;  :arith-fixed-eqs         536
;  :arith-offset-eqs        103
;  :arith-pivots            372
;  :binary-propagations     7
;  :conflicts               284
;  :datatype-accessor-ax    412
;  :datatype-constructor-ax 2865
;  :datatype-occurs-check   1220
;  :datatype-splits         1917
;  :decisions               3051
;  :del-clause              3354
;  :final-checks            261
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          116
;  :mk-bool-var             7008
;  :mk-clause               3502
;  :num-allocs              4528738
;  :num-checks              289
;  :propagations            2775
;  :quant-instantiations    1039
;  :rlimit-count            272361
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16016
;  :arith-add-rows          408
;  :arith-assert-diseq      1019
;  :arith-assert-lower      1814
;  :arith-assert-upper      1046
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1054
;  :arith-fixed-eqs         572
;  :arith-offset-eqs        122
;  :arith-pivots            384
;  :binary-propagations     7
;  :conflicts               298
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 2996
;  :datatype-occurs-check   1276
;  :datatype-splits         1997
;  :decisions               3193
;  :del-clause              3500
;  :final-checks            268
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          120
;  :mk-bool-var             7271
;  :mk-clause               3648
;  :num-allocs              4528738
;  :num-checks              290
;  :propagations            2925
;  :quant-instantiations    1093
;  :rlimit-count            277418
;  :time                    0.00)
; [then-branch: 107 | !(First:(Second:(Second:(Second:($t@51@02))))[1] == 0 || First:(Second:(Second:(Second:($t@51@02))))[1] == -1) | live]
; [else-branch: 107 | First:(Second:(Second:(Second:($t@51@02))))[1] == 0 || First:(Second:(Second:(Second:($t@51@02))))[1] == -1 | live]
(push) ; 9
; [then-branch: 107 | !(First:(Second:(Second:(Second:($t@51@02))))[1] == 0 || First:(Second:(Second:(Second:($t@51@02))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16017
;  :arith-add-rows          408
;  :arith-assert-diseq      1019
;  :arith-assert-lower      1814
;  :arith-assert-upper      1046
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1054
;  :arith-fixed-eqs         572
;  :arith-offset-eqs        122
;  :arith-pivots            384
;  :binary-propagations     7
;  :conflicts               298
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 2996
;  :datatype-occurs-check   1276
;  :datatype-splits         1997
;  :decisions               3193
;  :del-clause              3500
;  :final-checks            268
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          120
;  :mk-bool-var             7275
;  :mk-clause               3654
;  :num-allocs              4528738
;  :num-checks              291
;  :propagations            2926
;  :quant-instantiations    1094
;  :rlimit-count            277607)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16017
;  :arith-add-rows          408
;  :arith-assert-diseq      1019
;  :arith-assert-lower      1814
;  :arith-assert-upper      1046
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1054
;  :arith-fixed-eqs         572
;  :arith-offset-eqs        122
;  :arith-pivots            384
;  :binary-propagations     7
;  :conflicts               298
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 2996
;  :datatype-occurs-check   1276
;  :datatype-splits         1997
;  :decisions               3193
;  :del-clause              3500
;  :final-checks            268
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          120
;  :mk-bool-var             7275
;  :mk-clause               3654
;  :num-allocs              4528738
;  :num-checks              292
;  :propagations            2926
;  :quant-instantiations    1094
;  :rlimit-count            277622)
(pop) ; 9
(push) ; 9
; [else-branch: 107 | First:(Second:(Second:(Second:($t@51@02))))[1] == 0 || First:(Second:(Second:(Second:($t@51@02))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@02)))))
      1))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@56@02 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 108 | 0 <= i@56@02 | live]
; [else-branch: 108 | !(0 <= i@56@02) | live]
(push) ; 10
; [then-branch: 108 | 0 <= i@56@02]
(assert (<= 0 i@56@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 108 | !(0 <= i@56@02)]
(assert (not (<= 0 i@56@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 109 | i@56@02 < |First:(Second:($t@54@02))| && 0 <= i@56@02 | live]
; [else-branch: 109 | !(i@56@02 < |First:(Second:($t@54@02))| && 0 <= i@56@02) | live]
(push) ; 10
; [then-branch: 109 | i@56@02 < |First:(Second:($t@54@02))| && 0 <= i@56@02]
(assert (and
  (<
    i@56@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))))
  (<= 0 i@56@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@56@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16556
;  :arith-add-rows          416
;  :arith-assert-diseq      1064
;  :arith-assert-lower      1900
;  :arith-assert-upper      1076
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1096
;  :arith-fixed-eqs         604
;  :arith-offset-eqs        128
;  :arith-pivots            400
;  :binary-propagations     7
;  :conflicts               303
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3675
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7509
;  :mk-clause               3808
;  :num-allocs              4528738
;  :num-checks              294
;  :propagations            3061
;  :quant-instantiations    1136
;  :rlimit-count            281619)
; [eval] -1
(push) ; 11
; [then-branch: 110 | First:(Second:($t@54@02))[i@56@02] == -1 | live]
; [else-branch: 110 | First:(Second:($t@54@02))[i@56@02] != -1 | live]
(push) ; 12
; [then-branch: 110 | First:(Second:($t@54@02))[i@56@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
    i@56@02)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 110 | First:(Second:($t@54@02))[i@56@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
      i@56@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@56@02 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16566
;  :arith-add-rows          418
;  :arith-assert-diseq      1067
;  :arith-assert-lower      1908
;  :arith-assert-upper      1080
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1100
;  :arith-fixed-eqs         606
;  :arith-offset-eqs        128
;  :arith-pivots            402
;  :binary-propagations     7
;  :conflicts               303
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3675
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7527
;  :mk-clause               3819
;  :num-allocs              4528738
;  :num-checks              295
;  :propagations            3071
;  :quant-instantiations    1140
;  :rlimit-count            281889)
(push) ; 13
; [then-branch: 111 | 0 <= First:(Second:($t@54@02))[i@56@02] | live]
; [else-branch: 111 | !(0 <= First:(Second:($t@54@02))[i@56@02]) | live]
(push) ; 14
; [then-branch: 111 | 0 <= First:(Second:($t@54@02))[i@56@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
    i@56@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@56@02 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          419
;  :arith-assert-diseq      1067
;  :arith-assert-lower      1910
;  :arith-assert-upper      1081
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1101
;  :arith-fixed-eqs         607
;  :arith-offset-eqs        128
;  :arith-pivots            403
;  :binary-propagations     7
;  :conflicts               303
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3675
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7531
;  :mk-clause               3819
;  :num-allocs              4528738
;  :num-checks              296
;  :propagations            3071
;  :quant-instantiations    1140
;  :rlimit-count            282008)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 111 | !(0 <= First:(Second:($t@54@02))[i@56@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
      i@56@02))))
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
; [else-branch: 109 | !(i@56@02 < |First:(Second:($t@54@02))| && 0 <= i@56@02)]
(assert (not
  (and
    (<
      i@56@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))))
    (<= 0 i@56@02))))
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
(assert (not (forall ((i@56@02 Int)) (!
  (implies
    (and
      (<
        i@56@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))))
      (<= 0 i@56@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
          i@56@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
            i@56@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
            i@56@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
    i@56@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          419
;  :arith-assert-diseq      1068
;  :arith-assert-lower      1911
;  :arith-assert-upper      1082
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1102
;  :arith-fixed-eqs         608
;  :arith-offset-eqs        128
;  :arith-pivots            406
;  :binary-propagations     7
;  :conflicts               304
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3704
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7543
;  :mk-clause               3837
;  :num-allocs              4528738
;  :num-checks              297
;  :propagations            3073
;  :quant-instantiations    1143
;  :rlimit-count            282511)
(assert (forall ((i@56@02 Int)) (!
  (implies
    (and
      (<
        i@56@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))))
      (<= 0 i@56@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
          i@56@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
            i@56@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
            i@56@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@02)))
    i@56@02))
  :qid |prog.l<no position>|)))
(declare-const $k@57@02 $Perm)
(assert ($Perm.isReadVar $k@57@02 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@57@02 $Perm.No) (< $Perm.No $k@57@02))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          419
;  :arith-assert-diseq      1069
;  :arith-assert-lower      1913
;  :arith-assert-upper      1083
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1103
;  :arith-fixed-eqs         608
;  :arith-offset-eqs        128
;  :arith-pivots            406
;  :binary-propagations     7
;  :conflicts               305
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3704
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7548
;  :mk-clause               3839
;  :num-allocs              4528738
;  :num-checks              298
;  :propagations            3074
;  :quant-instantiations    1143
;  :rlimit-count            283035)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@31@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          419
;  :arith-assert-diseq      1069
;  :arith-assert-lower      1913
;  :arith-assert-upper      1083
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1103
;  :arith-fixed-eqs         608
;  :arith-offset-eqs        128
;  :arith-pivots            406
;  :binary-propagations     7
;  :conflicts               305
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3704
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7548
;  :mk-clause               3839
;  :num-allocs              4528738
;  :num-checks              299
;  :propagations            3074
;  :quant-instantiations    1143
;  :rlimit-count            283046)
(assert (< $k@57@02 $k@31@02))
(assert (<= $Perm.No (- $k@31@02 $k@57@02)))
(assert (<= (- $k@31@02 $k@57@02) $Perm.Write))
(assert (implies (< $Perm.No (- $k@31@02 $k@57@02)) (not (= diz@8@02 $Ref.null))))
; [eval] diz.Main_half != null
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          419
;  :arith-assert-diseq      1069
;  :arith-assert-lower      1915
;  :arith-assert-upper      1084
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1103
;  :arith-fixed-eqs         608
;  :arith-offset-eqs        128
;  :arith-pivots            408
;  :binary-propagations     7
;  :conflicts               306
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3704
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7551
;  :mk-clause               3839
;  :num-allocs              4528738
;  :num-checks              300
;  :propagations            3074
;  :quant-instantiations    1143
;  :rlimit-count            283266)
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          419
;  :arith-assert-diseq      1069
;  :arith-assert-lower      1915
;  :arith-assert-upper      1084
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1103
;  :arith-fixed-eqs         608
;  :arith-offset-eqs        128
;  :arith-pivots            408
;  :binary-propagations     7
;  :conflicts               307
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3704
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7551
;  :mk-clause               3839
;  :num-allocs              4528738
;  :num-checks              301
;  :propagations            3074
;  :quant-instantiations    1143
;  :rlimit-count            283314)
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          419
;  :arith-assert-diseq      1069
;  :arith-assert-lower      1915
;  :arith-assert-upper      1084
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1103
;  :arith-fixed-eqs         608
;  :arith-offset-eqs        128
;  :arith-pivots            408
;  :binary-propagations     7
;  :conflicts               308
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3704
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7551
;  :mk-clause               3839
;  :num-allocs              4528738
;  :num-checks              302
;  :propagations            3074
;  :quant-instantiations    1143
;  :rlimit-count            283362)
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          419
;  :arith-assert-diseq      1069
;  :arith-assert-lower      1915
;  :arith-assert-upper      1084
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1103
;  :arith-fixed-eqs         608
;  :arith-offset-eqs        128
;  :arith-pivots            408
;  :binary-propagations     7
;  :conflicts               309
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3704
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7551
;  :mk-clause               3839
;  :num-allocs              4528738
;  :num-checks              303
;  :propagations            3074
;  :quant-instantiations    1143
;  :rlimit-count            283410)
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          419
;  :arith-assert-diseq      1069
;  :arith-assert-lower      1915
;  :arith-assert-upper      1084
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1103
;  :arith-fixed-eqs         608
;  :arith-offset-eqs        128
;  :arith-pivots            408
;  :binary-propagations     7
;  :conflicts               310
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3704
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7551
;  :mk-clause               3839
;  :num-allocs              4528738
;  :num-checks              304
;  :propagations            3074
;  :quant-instantiations    1143
;  :rlimit-count            283458)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          419
;  :arith-assert-diseq      1069
;  :arith-assert-lower      1915
;  :arith-assert-upper      1084
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1103
;  :arith-fixed-eqs         608
;  :arith-offset-eqs        128
;  :arith-pivots            408
;  :binary-propagations     7
;  :conflicts               310
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3704
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7551
;  :mk-clause               3839
;  :num-allocs              4528738
;  :num-checks              305
;  :propagations            3074
;  :quant-instantiations    1143
;  :rlimit-count            283471)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          419
;  :arith-assert-diseq      1069
;  :arith-assert-lower      1915
;  :arith-assert-upper      1084
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1103
;  :arith-fixed-eqs         608
;  :arith-offset-eqs        128
;  :arith-pivots            408
;  :binary-propagations     7
;  :conflicts               311
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3704
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7551
;  :mk-clause               3839
;  :num-allocs              4528738
;  :num-checks              306
;  :propagations            3074
;  :quant-instantiations    1143
;  :rlimit-count            283519)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@54@02))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@02))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))))
                            ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))))))))))))))))))) diz@8@02 globals@9@02))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 7
(push) ; 7
; [else-branch: 75 | min_advance__29@39@02 == -1]
(assert (= min_advance__29@39@02 (- 0 1)))
(pop) ; 7
(pop) ; 6
(push) ; 6
; [else-branch: 37 | First:(Second:($t@37@02))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (- 0 1)))
(pop) ; 6
; [eval] !(diz.Main_process_state[0] != -1)
; [eval] diz.Main_process_state[0] != -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16568
;  :arith-add-rows          422
;  :arith-assert-diseq      1069
;  :arith-assert-lower      1915
;  :arith-assert-upper      1084
;  :arith-bound-prop        150
;  :arith-conflicts         27
;  :arith-eq-adapter        1103
;  :arith-fixed-eqs         608
;  :arith-offset-eqs        128
;  :arith-pivots            414
;  :binary-propagations     7
;  :conflicts               311
;  :datatype-accessor-ax    445
;  :datatype-constructor-ax 3095
;  :datatype-occurs-check   1326
;  :datatype-splits         2069
;  :decisions               3299
;  :del-clause              3817
;  :final-checks            274
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          122
;  :mk-bool-var             7551
;  :mk-clause               3839
;  :num-allocs              4528738
;  :num-checks              307
;  :propagations            3074
;  :quant-instantiations    1143
;  :rlimit-count            283700)
; [eval] -1
(set-option :timeout 10)
(push) ; 6
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16772
;  :arith-add-rows          423
;  :arith-assert-diseq      1074
;  :arith-assert-lower      1927
;  :arith-assert-upper      1089
;  :arith-bound-prop        154
;  :arith-conflicts         27
;  :arith-eq-adapter        1111
;  :arith-fixed-eqs         612
;  :arith-offset-eqs        128
;  :arith-pivots            418
;  :binary-propagations     7
;  :conflicts               316
;  :datatype-accessor-ax    452
;  :datatype-constructor-ax 3143
;  :datatype-occurs-check   1348
;  :datatype-splits         2101
;  :decisions               3344
;  :del-clause              3847
;  :final-checks            280
;  :interface-eqs           26
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7632
;  :mk-clause               3869
;  :num-allocs              4528738
;  :num-checks              308
;  :propagations            3091
;  :quant-instantiations    1147
;  :rlimit-count            285222
;  :time                    0.00)
(push) ; 6
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16895
;  :arith-add-rows          426
;  :arith-assert-diseq      1078
;  :arith-assert-lower      1942
;  :arith-assert-upper      1097
;  :arith-bound-prop        154
;  :arith-conflicts         27
;  :arith-eq-adapter        1119
;  :arith-fixed-eqs         615
;  :arith-offset-eqs        128
;  :arith-pivots            422
;  :binary-propagations     7
;  :conflicts               317
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3872
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7682
;  :mk-clause               3894
;  :num-allocs              4528738
;  :num-checks              309
;  :propagations            3114
;  :quant-instantiations    1154
;  :rlimit-count            286532)
; [then-branch: 112 | First:(Second:($t@37@02))[0] == -1 | live]
; [else-branch: 112 | First:(Second:($t@37@02))[0] != -1 | live]
(push) ; 6
; [then-branch: 112 | First:(Second:($t@37@02))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    0)
  (- 0 1)))
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@58@02 Int)
(push) ; 7
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 8
; [then-branch: 113 | 0 <= i@58@02 | live]
; [else-branch: 113 | !(0 <= i@58@02) | live]
(push) ; 9
; [then-branch: 113 | 0 <= i@58@02]
(assert (<= 0 i@58@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 113 | !(0 <= i@58@02)]
(assert (not (<= 0 i@58@02)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 114 | i@58@02 < |First:(Second:($t@37@02))| && 0 <= i@58@02 | live]
; [else-branch: 114 | !(i@58@02 < |First:(Second:($t@37@02))| && 0 <= i@58@02) | live]
(push) ; 9
; [then-branch: 114 | i@58@02 < |First:(Second:($t@37@02))| && 0 <= i@58@02]
(assert (and
  (<
    i@58@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
  (<= 0 i@58@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i@58@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16901
;  :arith-add-rows          427
;  :arith-assert-diseq      1078
;  :arith-assert-lower      1945
;  :arith-assert-upper      1100
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1120
;  :arith-fixed-eqs         617
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               317
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3872
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7687
;  :mk-clause               3899
;  :num-allocs              4528738
;  :num-checks              310
;  :propagations            3117
;  :quant-instantiations    1154
;  :rlimit-count            286806)
; [eval] -1
(push) ; 10
; [then-branch: 115 | First:(Second:($t@37@02))[i@58@02] == -1 | live]
; [else-branch: 115 | First:(Second:($t@37@02))[i@58@02] != -1 | live]
(push) ; 11
; [then-branch: 115 | First:(Second:($t@37@02))[i@58@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@58@02)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 115 | First:(Second:($t@37@02))[i@58@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      i@58@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 12
(assert (not (>= i@58@02 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1078
;  :arith-assert-lower      1945
;  :arith-assert-upper      1100
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1120
;  :arith-fixed-eqs         617
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               318
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3872
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7688
;  :mk-clause               3899
;  :num-allocs              4528738
;  :num-checks              311
;  :propagations            3117
;  :quant-instantiations    1154
;  :rlimit-count            286950)
(push) ; 12
; [then-branch: 116 | 0 <= First:(Second:($t@37@02))[i@58@02] | live]
; [else-branch: 116 | !(0 <= First:(Second:($t@37@02))[i@58@02]) | live]
(push) ; 13
; [then-branch: 116 | 0 <= First:(Second:($t@37@02))[i@58@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@58@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@58@02 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1078
;  :arith-assert-lower      1945
;  :arith-assert-upper      1100
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1120
;  :arith-fixed-eqs         617
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               318
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3872
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7689
;  :mk-clause               3899
;  :num-allocs              4528738
;  :num-checks              312
;  :propagations            3117
;  :quant-instantiations    1154
;  :rlimit-count            287035)
; [eval] |diz.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 116 | !(0 <= First:(Second:($t@37@02))[i@58@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      i@58@02))))
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
; [else-branch: 114 | !(i@58@02 < |First:(Second:($t@37@02))| && 0 <= i@58@02)]
(assert (not
  (and
    (<
      i@58@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
    (<= 0 i@58@02))))
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
(assert (not (forall ((i@58@02 Int)) (!
  (implies
    (and
      (<
        i@58@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
      (<= 0 i@58@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          i@58@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@58@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@58@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@58@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1080
;  :arith-assert-lower      1946
;  :arith-assert-upper      1101
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1121
;  :arith-fixed-eqs         618
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               319
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3892
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7701
;  :mk-clause               3919
;  :num-allocs              4528738
;  :num-checks              313
;  :propagations            3119
;  :quant-instantiations    1157
;  :rlimit-count            287520)
(assert (forall ((i@58@02 Int)) (!
  (implies
    (and
      (<
        i@58@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))))
      (<= 0 i@58@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
          i@58@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@58@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
            i@58@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
    i@58@02))
  :qid |prog.l<no position>|)))
(declare-const $k@59@02 $Perm)
(assert ($Perm.isReadVar $k@59@02 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@59@02 $Perm.No) (< $Perm.No $k@59@02))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1081
;  :arith-assert-lower      1948
;  :arith-assert-upper      1102
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1122
;  :arith-fixed-eqs         618
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               320
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3892
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7706
;  :mk-clause               3921
;  :num-allocs              4528738
;  :num-checks              314
;  :propagations            3120
;  :quant-instantiations    1157
;  :rlimit-count            288047)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@31@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1081
;  :arith-assert-lower      1948
;  :arith-assert-upper      1102
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1122
;  :arith-fixed-eqs         618
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               320
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3892
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7706
;  :mk-clause               3921
;  :num-allocs              4528738
;  :num-checks              315
;  :propagations            3120
;  :quant-instantiations    1157
;  :rlimit-count            288058)
(assert (< $k@59@02 $k@31@02))
(assert (<= $Perm.No (- $k@31@02 $k@59@02)))
(assert (<= (- $k@31@02 $k@59@02) $Perm.Write))
(assert (implies (< $Perm.No (- $k@31@02 $k@59@02)) (not (= diz@8@02 $Ref.null))))
; [eval] diz.Main_half != null
(push) ; 7
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1081
;  :arith-assert-lower      1950
;  :arith-assert-upper      1103
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1122
;  :arith-fixed-eqs         618
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               321
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3892
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7709
;  :mk-clause               3921
;  :num-allocs              4528738
;  :num-checks              316
;  :propagations            3120
;  :quant-instantiations    1157
;  :rlimit-count            288266)
(push) ; 7
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1081
;  :arith-assert-lower      1950
;  :arith-assert-upper      1103
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1122
;  :arith-fixed-eqs         618
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               322
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3892
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7709
;  :mk-clause               3921
;  :num-allocs              4528738
;  :num-checks              317
;  :propagations            3120
;  :quant-instantiations    1157
;  :rlimit-count            288314)
(push) ; 7
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1081
;  :arith-assert-lower      1950
;  :arith-assert-upper      1103
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1122
;  :arith-fixed-eqs         618
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               323
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3892
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7709
;  :mk-clause               3921
;  :num-allocs              4528738
;  :num-checks              318
;  :propagations            3120
;  :quant-instantiations    1157
;  :rlimit-count            288362)
(push) ; 7
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1081
;  :arith-assert-lower      1950
;  :arith-assert-upper      1103
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1122
;  :arith-fixed-eqs         618
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               324
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3892
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7709
;  :mk-clause               3921
;  :num-allocs              4528738
;  :num-checks              319
;  :propagations            3120
;  :quant-instantiations    1157
;  :rlimit-count            288410)
(push) ; 7
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1081
;  :arith-assert-lower      1950
;  :arith-assert-upper      1103
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1122
;  :arith-fixed-eqs         618
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               325
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3892
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7709
;  :mk-clause               3921
;  :num-allocs              4528738
;  :num-checks              320
;  :propagations            3120
;  :quant-instantiations    1157
;  :rlimit-count            288458)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1081
;  :arith-assert-lower      1950
;  :arith-assert-upper      1103
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1122
;  :arith-fixed-eqs         618
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               325
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3892
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7709
;  :mk-clause               3921
;  :num-allocs              4528738
;  :num-checks              321
;  :propagations            3120
;  :quant-instantiations    1157
;  :rlimit-count            288471)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@31@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16902
;  :arith-add-rows          427
;  :arith-assert-diseq      1081
;  :arith-assert-lower      1950
;  :arith-assert-upper      1103
;  :arith-bound-prop        156
;  :arith-conflicts         27
;  :arith-eq-adapter        1122
;  :arith-fixed-eqs         618
;  :arith-offset-eqs        128
;  :arith-pivots            423
;  :binary-propagations     7
;  :conflicts               326
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 3171
;  :datatype-occurs-check   1362
;  :datatype-splits         2125
;  :decisions               3373
;  :del-clause              3892
;  :final-checks            284
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.69
;  :memory                  4.69
;  :minimized-lits          123
;  :mk-bool-var             7709
;  :mk-clause               3921
;  :num-allocs              4528738
;  :num-checks              322
;  :propagations            3120
;  :quant-instantiations    1157
;  :rlimit-count            288519)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@37@02))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@02))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02))))))))))))))
                            ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@29@02)))))))))))))))))))))))))))) diz@8@02 globals@9@02))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 6
(push) ; 6
; [else-branch: 112 | First:(Second:($t@37@02))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@37@02)))
      0)
    (- 0 1))))
(pop) ; 6
(pop) ; 5
; [eval] !true
; [then-branch: 117 | False | dead]
; [else-branch: 117 | True | live]
(push) ; 5
; [else-branch: 117 | True]
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
